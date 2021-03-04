function tree -d "Recurse into directories as a tree"
    command -q exa
    if test $status = 0
        command exa -T $argv
    else
        echo "Please install exa first!"
    end
end
