set toplevel (git rev-parse --show-toplevel)
mock bat \* "echo '# fzf.fish'"
set expected "# fzf.fish"
set actual (__fzf_preview_git_repository "$toplevel")
@test "shows contents of README to preview git repository" "$actual" = "$expected"
