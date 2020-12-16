function __fzf_search_z --description "Search the list of most used directories stored by z. Insert the selected path into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)
    set directory_paths_selected (
        z --list 2>/dev/null | cut -c 12- |
        fzf --multi --preview='__fzf_preview_file {}'
    )

    if test $status -eq 0
        for path in $directory_paths_selected
            set escaped_path (string escape "$path")
            commandline --insert "$escaped_path "
        end
    end

    commandline --function repaint
end
