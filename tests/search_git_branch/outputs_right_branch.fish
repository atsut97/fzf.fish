mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter='main'"
set expected main
set actual (_fzf_search_git_branch)
@test "outputs right branch name" "$actual" = "$expected"
