function __fzf_search_ghq --description "Search the list of locally cloned repositories managed by ghq(1). Insert the full path of the selected repository into the commandline at the cursor."
    if not type -q ghq
        echo '__fzf_search_ghq: Unable to find ghq(1) on the system' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute __fzf_preview_file.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)
    set repository_paths_selected (
        ghq list --full-path 2>/dev/null |
        fzf --multi --preview='__fzf_preview_git_repository {} readme'
    )

    if test $status -eq 0
        for path in $repository_paths_selected
            set escaped_path (string escape "$path")
            commandline --insert "$escaped_path "
        end
    end

    commandline --function repaint
end
