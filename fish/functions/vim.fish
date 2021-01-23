function vim -d "neovim with NORC"
    command -s vim
    if test $status = 0
        command vim $argv
    else
        command nvim -u NORC $argv
    end
end
