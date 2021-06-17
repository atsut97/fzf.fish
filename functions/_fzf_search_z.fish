function _fzf_search_z --description "Search the list of most used directories stored by z. Insert the selected path into the commandline at the cursor."
    if not type -q z
        echo '_fzf_search_z: Unable to find z(1) in the system' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute _fzf_preview_file.
    # See similar comment in _fzf_search_variables.fish.
    set --local --export SHELL (command --search fish)

    set directory_paths_selected (
        z --list 2>/dev/null | cut -c 12- | \
        fzf --ansi --multi \
            --preview='_fzf_preview_file {}' \
            --query=(commandline --current-token)
    )

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $directory_paths_selected | string join ' ')
    end

    commandline --function repaint
end
