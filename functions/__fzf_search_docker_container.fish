function __fzf_search_docker_container --description "Search the docker containers under management. Insert the selected container ID into the commandline at the cursor."
    if not type -q docker
        echo '__fzf_search_docker_container: Unable to find docker(1) on the system' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    # Limit fields to search with the option '--nth' below.
    set selected_container_line (
        docker ps --all |
        fzf --no-multi --tiebreak='begin,index' --header-lines=1 --nth='1..3,7,-2,-1' --preview='docker container logs {1}'
    )

    if test $status -eq 0
        set abbrev_container_id (string split --max 1 " " $selected_container_line)[1]
        set container_id (docker container inspect --format='{{.Id}}' $abbrev_container_id)
        commandline --insert $container_id
    end

    commandline --function repaint
end
