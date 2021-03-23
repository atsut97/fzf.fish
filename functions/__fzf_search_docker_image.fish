function __fzf_search_docker_image --description "Search the docker top-level images under management. Insert the selected image repository and tag into the commandline at the cursor."
    if not type -q docker
        echo '__fzf_search_docker_image: Unable to find docker(1) on the system' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    # Narrow fields to search down to Repository, Tag and Image ID by
    # providing '--nth' option.
    set selected_image_line (
        docker images | \
        fzf --ansi --no-multi --tiebreak='begin,index' \
            --header-lines=1 --nth='1..3' \
            --preview-window=hidden \
            --preview='docker image history {3}' \
            --query=(commandline --current-token)
    )

    if test $status -eq 0
        set fields (string split --no-empty " " $selected_image_line)
        set repository $fields[1]
        set tag $fields[2]
        commandline --current-token --replace -- "$repository:$tag "
    end

    commandline --function repaint
end
