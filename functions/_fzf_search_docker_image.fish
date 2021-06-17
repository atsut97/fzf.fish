function _fzf_search_docker_image --description "Search the docker top-level images under management. Insert the selected image repository and tag into the commandline at the cursor."
    if not type -q docker
        echo '_fzf_search_docker_image: Unable to find docker(1) on the system' >&2
        return 1
    else if not docker stats --no-stream >/dev/null 2>&1
        echo '_fzf_search_docker_image: Cannot connect to the Docker daemon' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute _fzf_preview_file.
    # See similar comment in _fzf_search_variables.fish.
    set --local --export SHELL (command --search fish)

    # Narrow fields to search down to Repository, Tag and Image ID by
    # providing '--nth' option.
    set selected_image_lines (
        docker images | \
        fzf --ansi --multi --tiebreak='begin,index' \
            --header-lines=1 --nth='1..3' \
            --preview-window=hidden \
            --preview='docker image history {3}' \
            --query=(commandline --current-token)
    )

    if test $status -eq 0
        set image_ids

        for line in $selected_image_lines
            set abbrev_image_id (string split --no-empty " " $line)[3]
            if set --query fzf_docker_use_full_id
                set --append image_ids (docker image inspect --format='{{.Id}}' $abbrev_image_id)
            else
                set --append image_ids $abbrev_image_id
            end
        end

        commandline --current-token --replace -- (string escape -- $image_ids | string join ' ')
    end

    commandline --function repaint
end
