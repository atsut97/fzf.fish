mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock docker images "\
echo 'REPOSITORY    TAG      IMAGE ID       CREATED        SIZE';
echo 'ubuntu        xenial   9ff95a467e45   2 weeks ago    135MB';
echo 'ubuntu        bionic   81bcf752ac3d   2 weeks ago    63.1MB';
echo 'ubuntu        focal    7e0aa2d69a15   6 weeks ago    72.7MB';
echo 'hello-world   latest   d1165f221234   3 months ago   13.3kB';
echo 'hello-world   linux    d1165f221234   3 months ago   13.3kB';
"
mock docker \* "return 0"
set --export --append FZF_DEFAULT_OPTS "--filter='ubuntu'"
set expected 9ff95a467e45 81bcf752ac3d 7e0aa2d69a15
set actual (__fzf_search_docker_image | string split " ")
set failed 0
for i in (seq 1 3)
    string match --quiet -- $expected[$i] $actual[$i]; or set failed 1
end
if test $failed -eq 1
    # This is only shown when test is failed.
    echo "expected ("(count $expected)"): $expected"
    echo "actual   ("(count $actual)"): $actual"
end
@test "outputs right docker image ID" $failed -eq 0
