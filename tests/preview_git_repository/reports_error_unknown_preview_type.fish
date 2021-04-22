set actual (__fzf_preview_git_repository . hoge 2>&1)
set expected "__fzf_preview_git_repository: Unknown preview type: hoge"
@test "reports an error when unknown preview type is specified" "$actual" = "$expected"
