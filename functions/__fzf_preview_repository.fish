# Helper function for __fzf_search_ghq
function __fzf_preview_repository --argument-names repository_path --description "Prints a preview for the given repository. If README is found shows its contents. Otherwise, lists files and directories."
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
end
