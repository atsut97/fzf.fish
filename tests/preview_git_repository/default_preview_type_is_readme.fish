set toplevel (git rev-parse --show-toplevel)
mock fd \* "echo $toplevel/README.md"
mock bat \* "echo '# fzf.fish'"
set expected "# fzf.fish"
set actual (__fzf_preview_git_repository "$toplevel")
@test "shows contents of README to preview git repository" "$actual" = "$expected"
