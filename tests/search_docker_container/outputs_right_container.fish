mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock docker ps "echo 'CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     PORTS     NAMES';echo '4242eeb19b6e   hello-world   \"/hello\"   12 months ago   Exited (0) 12 months ago             charming_banach'"
mock docker \* "return 0"
set --export --append FZF_DEFAULT_OPTS "--filter='hello-world'"
set expected 4242eeb19b6e
set actual (__fzf_search_docker_container)
@test "outputs right docker container ID" "$actual" = "$expected"
