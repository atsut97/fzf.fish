function make_temp_repo
    set --local path (mktemp -d -t repo.XXXXXXXX)
    git init --quiet $path
    echo "$path"
end

set path1 (make_temp_repo)
set path2 (make_temp_repo)
mock commandline \* ""
mock commandline "--current-token --replace --" "echo \$argv"
mock ghq list "echo $path1; echo $path2"
mock ghq \* "return 0"

set --export --append FZF_DEFAULT_OPTS "--filter='repo'"
set actual (__fzf_search_ghq | string split " ")

string match --regex --quiet "^$path1\$" "$actual[1]"; and string match --regex --quiet "^$path2\$" "$actual[2]"

@test "correct full paths found in output by ghq" $status -eq 0

rm -rf $path1 $path2
