function fzy_history
    set -l flags
    if test -n "$argv"
        set flags "-q$argv"
    end
    set -l foo (history | fzy $flags)
    if test $status -eq 0
        commandline $foo
    end
    commandline -f repaint
end