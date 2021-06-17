function _fzf_search_process --description "Search the current processes and insert the process ID into the commandline at the cursor."
    # Make sure that fzf uses fish to execute git show.
    # See similar comment in _fzf_search_variables.fish.
    set --local --export SHELL (command --search fish)

    # Extract processes whose effective user ID matches the current
    # user ID beforehand to avoid complexity. If you run this as
    # a supervisor list all processes running.
    set uid (id -u (whoami))
    if test $uid != 0
        set ps_options -f -u $uid
    else
        set ps_options -ef
    end

    set selected_ps_line (
         ps $ps_options | \
         fzf --no-multi --tiebreak=index \
             --header-lines=1 --nth=1,6,8.. \
             --query=(commandline --current-token)
    )

    if test $status -eq 0
        set process_id (string split --no-empty " " $selected_ps_line)[2]
        commandline --current-token --replace -- $process_id
    end

    commandline --function repaint
end
