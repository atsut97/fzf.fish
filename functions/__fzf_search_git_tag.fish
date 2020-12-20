function __fzf_search_git_tag --description "Search the git tag of the current git repository. Insert the selected tag into the commandline at the cursor."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo '__fzf_search_git_tag: Not in a git repository.' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute git show.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    set selected_tags (
        git tag --sort -v:refname |
        fzf --multi --preview-window='right:70%' --preview='__fzf_preview_git_repository (pwd) show {}'
    )

    if test $status -eq 0
        for tag in $selected_tags
            commandline --insert "$tag "
        end
    end

    commandline --function repaint
end
