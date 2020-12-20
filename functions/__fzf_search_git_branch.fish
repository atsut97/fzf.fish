function __fzf_search_git_branch --description "Search the git branch of the current git repository. Insert the selected branch name into the commandline at the cursor."
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo '__fzf_search_git_branch: Not in a git repository.' >&2
        return 1
    end

    # Make sure that fzf uses fish to execute git show.
    # See similar comment in __fzf_search_shell_variables.fish.
    set --local --export SHELL (command --search fish)

    set selected_branch_line (
        git branch --all --color=always |
        fzf --ansi --preview='__fzf_preview_git_repository (pwd) log (string split --max 1 " " (string sub --start 3 {}))[1]'
    )

    if test $status -eq 0
        # Get rid of the first two charcaters to remove an asterisk.
        set branch_line (string sub --start 3 $selected_branch_line)
        # Get the selected branch name.
        set branch_name (string split --max 1 " " $branch_line)[1]
        # Trim redundant part.
        set branch_name (string replace 'remotes/' '' $branch_name)
        commandline --insert $branch_name
    end

    commandline --function repaint
end
