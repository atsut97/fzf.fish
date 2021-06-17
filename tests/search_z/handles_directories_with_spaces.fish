mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock z --list "\
echo '50         /home/atsuta/multi word directory';
echo '16         /home/atsuta/directory 1';
echo '1.25       /home/atsuta/directory 2';
"
mock z \* "return 0"
set --export --append FZF_DEFAULT_OPTS "--filter='directory'"

set actual (_fzf_search_z)
set expected "'/home/atsuta/directory 1' '/home/atsuta/directory 2' '/home/atsuta/multi word directory'"

@test "handles directories with spaces correctly" "$actual" = $expected
