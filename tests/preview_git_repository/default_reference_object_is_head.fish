set line (__fzf_preview_git_repository . log | head -n 1 | string split " ")
# Remove ANSI color codes
set actual (echo "$line[3]" | cat -v | sed 's/\^[[[0-9;]*m//g')
set expected (git rev-parse --short HEAD)

@test "uses HEAD object to preview git repository by default" "$actual" = "$expected"
