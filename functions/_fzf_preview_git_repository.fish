# Helper function for _fzf_search_git_branch and others
function _fzf_preview_git_repository --argument-names repository_path preview_type object --description "Prints a preview for the given repository based on the given preview type which is chosen from readme, show, log."
    if test -z "$repository_path"
        echo '_fzf_preview_git_repository: Requires one argument at least' >&2
        return 1
    end

    if not test -d "$repository_path"
        echo "_fzf_preview_git_repository: $repository_path is not a directory" >&2
        return 1
    end

    # Set the default value of $preview_type.
    if test -z "$preview_type"
        set preview_type readme
    end

    # Set the default value of $object. This value is used when 'show'
    # or 'log' is specified as the preview type.
    if test -z "$object"
        set object HEAD
    end

    if test "$preview_type" = readme
        # List files including 'README' in their names and pick up the
        # first one. If no such files are found leave the variable empty.
        set readme_path (
            fd --ignore-case --max-depth 1 'README' "$repository_path" 2>/dev/null |
            head -n 1
        )
        # If a README is found in the repository show its contents. In
        # case no README is found, list files and directories in the
        # repository.
        if test -n "$readme_path"
            bat --style=numbers --color=always "$readme_path"
        else
            set --local CLICOLOR_FORCE true
            ls -A "$repository_path"
        end
    else if test "$preview_type" = show
        # Show the object.
        git show --color=always $object
    else if test "$preview_type" = log
        # Show the commit logs.
        git log --color=always --graph --format=format:'%C(auto)%as %h%d %s' $object --
    else
        echo "_fzf_preview_git_repository: Unknown preview type: $preview_type" >&2
        return 1
    end

end
