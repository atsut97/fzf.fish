set expected "# fzf.fish"
mock bat \* "echo '# fzf.fish'"
set actual (__fzf_preview_git_repository .)
@test "shows contents of README to preview git repository" "$actual" = "$expected"
