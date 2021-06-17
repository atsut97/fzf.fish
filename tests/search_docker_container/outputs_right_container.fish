mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock docker ps "\
echo 'CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS                      PORTS     NAMES';
echo 'd203ae5c68ec   ubuntu:focal    \"bash\"        10 minutes ago   Exited (0) 10 minutes ago             cool_mcclintock';
echo '4dcfc7620bc6   ubuntu:bionic   \"bash\"        10 minutes ago   Exited (0) 10 minutes ago             blissful_davinci';
echo '9aa2d2052633   9ff95a467e45    \"bash\"        34 minutes ago   Exited (0) 34 minutes ago             cool_villani';
echo '24cbe789756f   ubuntu:xenial   \"/bin/bash\"   6 days ago       Exited (0) 6 days ago                 agitated_neumann';
"
mock docker \* "return 0"
set --export --append FZF_DEFAULT_OPTS "--filter='ubuntu'"
set expected d203ae5c68ec 4dcfc7620bc6 24cbe789756f
set actual (_fzf_search_docker_container | string split " ")
set failed 0
for i in (seq 1 3)
    string match --quiet -- $expected[$i] $actual[$i]; or set failed 1
end
if test $failed -eq 1
    # This is only shown when test is failed.
    echo "expected ("(count $expected)"): $expected"
    echo "actual   ("(count $actual)"): $actual"
end
@test "outputs right docker container ID" $failed -eq 0
