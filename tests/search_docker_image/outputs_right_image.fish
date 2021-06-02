mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock docker images "echo 'REPOSITORY       TAG       IMAGE ID       CREATED        SIZE';echo 'hello-world      latest    fce289e99eb9   2 years ago    1.84kB'"
mock docker \* "return 0"
set --export --append FZF_DEFAULT_OPTS "--filter='hello-world'"
set expected 'fce289e99eb9'
set actual (__fzf_search_docker_image)
@test "outputs right docker image repository and tag" "$actual" = "$expected"
