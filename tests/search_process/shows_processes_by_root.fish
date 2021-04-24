mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock whoami \* "echo root"
mock ps -ef "\
echo 'UID        PID  PPID  C STIME TTY          TIME CMD';
echo 'root         1     0  0 Apr21 ?        00:00:00 /init';
echo 'atsuta     712   102  0 17:02 pts/1    00:00:00 /usr/local/bin/fish';
echo 'atsuta    2817   712  0 17:02 pts/1    00:00:08 emacs';
echo 'atsuta   12955  6832  0 19:01 pts/2    00:00:00 ps -f -u 1000';
"
set --export --append FZF_DEFAULT_OPTS "--filter='root'"
set expected 1
set actual (__fzf_search_process)
@test "shows all the processes owned by root as well" "$actual" = "$expected"
