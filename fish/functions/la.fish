function la -d "list all contents of directory using long format"
    command -q exa
    if test $status = 0
        command exa --group-directories-first -lhga $argv
    else
        ls -lha $argv
    end
end
