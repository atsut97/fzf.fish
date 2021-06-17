mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock ps -f "\
echo 'UID        PID  PPID  C STIME TTY          TIME CMD';
echo 'atsuta     712   102  0 17:02 pts/1    00:00:00 /usr/local/bin/fish';
echo 'atsuta    2817   712  0 17:02 pts/1    00:00:08 emacs';
echo 'atsuta   12955  6832  0 19:01 pts/2    00:00:00 ps -f -u 1000';
"
set --export --append FZF_DEFAULT_OPTS "--filter='emacs'"
set expected 2817
set actual (_fzf_search_process)
@test "matches tokens in the 8th field" "$actual" = "$expected"
