function ll -d "list contents of directory using long format"
    command -q exa
    if test $status = 0
        command exa --group-directories-first -lhg $argv
    else
        ls -lh $argv
    end
end
