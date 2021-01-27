function vim -d "nvim wrapper with no user configs"
    command -q vim
    if test $status = 0
        command vim $argv
    else
        command nvim -u NORC $argv
    end
end
