function _fzf_search_ghq --description "Search the list of locally cloned repositories managed by ghq(1). Insert the full path of the selected repository into the commandline at the cursor."
    if not type -q ghq
        echo '_fzf_search_ghq: Unable to find ghq(1) on the system' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute _fzf_preview_file.
    # See similar comment in _fzf_search_variables.fish.
    set --local --export SHELL (command --search fish)

    set repository_paths_selected (
        ghq list --full-path 2>/dev/null | \
        fzf --ansi --multi \
            --preview='_fzf_preview_git_repository {} readme' \
            --query=(commandline --current-token)
    )

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $repository_paths_selected | string join ' ')
    end

    commandline --function repaint
end
