function __fzf_search_docker_container --description "Search the docker containers under management. Insert the selected container ID into the commandline at the cursor."
    if not type -q docker
        echo '__fzf_search_docker_container: Unable to find docker(1) on the system' >&2
        return 1
    else if not docker stats --no-stream >/dev/null 2>&1
        echo '__fzf_search_docker_container: Cannot connect to the Docker daemon' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    # Narrow fields to search down to ID, Image, Command, Status,
    # Ports and Names by providing '--nth' option.
    set selected_container_lines (
        docker ps --all | \
        fzf --ansi --multi --tiebreak='begin,index' \
            --header-lines=1 --nth='1..3,7,-2,-1' \
            --preview-window=hidden \
            --preview='docker container logs {1}' \
            --query=(commandline --current-token)
    )

    if test $status -eq 0
        set container_ids

        for line in $selected_container_lines
            set abbrev_container_id (string split --max 1 " " $line)[1]
            if set --query fzf_docker_use_full_id
                set --append container_ids (docker container inspect --format='{{.Id}}' $abbrev_container_id)
            else
                set --append container_ids $abbrev_container_id
            end
        end

        commandline --current-token --replace -- (string escape -- $container_ids | string join ' ')
    end

    commandline --function repaint
end
