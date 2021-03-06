function _fzf_search_git_branch --description "Search the git branch of the current git repository. Insert the selected branch name into the commandline at the cursor."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo '_fzf_search_git_branch: Not in a git repository.' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute git show.
    # See similar comment in _fzf_search_variables.fish.
    set --local --export SHELL (command --search fish)

    set --local preview_cmd '_fzf_preview_git_repository (pwd) log (string split --max 1 " " (string sub --start 3 {}))[1]'
    set selected_branch_line (
        git branch --all --color=always | \
        fzf --ansi \
            --preview=$preview_cmd \
            --query=(commandline --current-token)
    )

    if test $status -eq 0
        # Get rid of the first two charcaters to remove an asterisk.
        set branch_line (string sub --start 3 $selected_branch_line)
        # Get the selected branch name.
        set branch_name (string split --max 1 " " $branch_line)[1]
        # Trim redundant part.
        set branch_name (string replace 'remotes/' '' $branch_name)
        commandline --current-token --replace -- $branch_name
    end

    commandline --function repaint
end
