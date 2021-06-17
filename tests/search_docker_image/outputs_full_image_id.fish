mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock docker images "\
echo 'REPOSITORY    TAG      IMAGE ID       CREATED        SIZE';
echo 'ubuntu        xenial   9ff95a467e45   2 weeks ago    135MB';
echo 'hello-world   latest   d1165f221234   3 months ago   13.3kB';
echo 'hello-world   linux    d1165f221234   3 months ago   13.3kB';
"
mock docker image "echo 'sha256:9ff95a467e458bb9e8653b1df439e02e07fc0be5b362cc3d9aeb0d04039d5925'"
mock docker \* "return 0"

set fzf_docker_use_full_id 1
set --export --append FZF_DEFAULT_OPTS "--filter='ubuntu'"
set expected 'sha256:9ff95a467e458bb9e8653b1df439e02e07fc0be5b362cc3d9aeb0d04039d5925'
set actual (_fzf_search_docker_image)

@test "outputs full docker image ID" $actual = $expected
