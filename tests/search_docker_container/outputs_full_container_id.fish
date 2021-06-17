mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock docker ps "\
echo 'CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS                      PORTS     NAMES';
echo 'd203ae5c68ec   ubuntu:focal    \"bash\"        10 minutes ago   Exited (0) 10 minutes ago             cool_mcclintock';
echo '4dcfc7620bc6   ubuntu:bionic   \"bash\"        10 minutes ago   Exited (0) 10 minutes ago             blissful_davinci';
echo '9aa2d2052633   9ff95a467e45    \"bash\"        34 minutes ago   Exited (0) 34 minutes ago             cool_villani';
echo '24cbe789756f   ubuntu:xenial   \"/bin/bash\"   6 days ago       Exited (0) 6 days ago                 agitated_neumann';
"
mock docker container "echo 'd203ae5c68ecad0e2c5bb90e27ea8535fcaa29f3c4340c3063bca15f686c3ede'"
mock docker \* "return 0"

set fzf_docker_use_full_id 1
set --export --append FZF_DEFAULT_OPTS "--filter='focal'"
set expected d203ae5c68ecad0e2c5bb90e27ea8535fcaa29f3c4340c3063bca15f686c3ede
set actual (_fzf_search_docker_container)

@test "outputs full docker container ID" $actual = $expected
