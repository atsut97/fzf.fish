mock docker stats "return 1"
mock docker \* "return 0"
set expected "_fzf_search_docker_container: Cannot connect to the Docker daemon"
set actual (_fzf_search_docker_container 2>&1)
@test "reports an error when no docker daemon is running" "$actual" = "$expected"
