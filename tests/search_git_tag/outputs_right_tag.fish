mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter='v6.2'"
set expected 'v6.2'
set actual (__fzf_search_git_tag)
@test "outputs right tag" "$actual" = "$expected"
