mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
mock z --list "\
echo '50         /home/atsuta/develop/fzf.fish';
echo '16         /home/atsuta/dotfiles';
echo '14.25      /home/atsuta/develop';
echo '10         /home/atsuta/develop/dotfiles';
echo '8.75       /home/atsuta/usr/src';
echo '5          /home/atsuta/.emacs.d';
echo '3          /home/atsuta/usr/src/emacs';
echo '2.25       /home/atsuta/usr';
echo '2          /home/atsuta/usr/src/emacs-27.1';
echo '1.75       /home/atsuta/.config/fish';
echo '1.25       /home/atsuta/src';
"
mock z \* "return 0"
set --export --append FZF_DEFAULT_OPTS "--filter='emacs'"
set actual (__fzf_search_z | string split " ")
string match --regex --quiet "^/home/atsuta/\.emacs\.d\$" $actual[1]; and \
    string match --regex --quiet "^/home/atsuta/usr/src/emacs\$" $actual[2]; and \
    string match --regex --quiet "^/home/atsuta/usr/src/emacs-27\.1\$" $actual[3]
@test "correct paths found in z list" $status -eq 0
