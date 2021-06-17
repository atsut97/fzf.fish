set line (_fzf_preview_git_repository . log | head -n 1)
set actual (echo "$line" | cat -v | string match --regex '[0-9a-f]{7}')
set expected (git rev-parse --short HEAD)

@test "uses HEAD object to preview git repository by default" "$actual" = "$expected"
