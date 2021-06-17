mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
# Emulates the command 'git tag' to print a specific tag since tags
# are not downloaded on the CI environment.
mock git tag "echo v6.2"
set --export --append FZF_DEFAULT_OPTS "--filter='v6.2'"
set expected 'v6.2'
set actual (_fzf_search_git_tag)
@test "outputs right tag" "$actual" = "$expected"
