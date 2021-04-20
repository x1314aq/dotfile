set -U fish_greeting
set -U fish_user_paths $fish_user_paths

set -xU EDITOR nvim
set -xU VISUAL nvim

set -xU LESS_TERMCAP_md (printf "\e[01;31m")
set -xU LESS_TERMCAP_me (printf "\e[0m")
set -xU LESS_TERMCAP_se (printf "\e[0m")
set -xU LESS_TERMCAP_so (printf "\e[01;44;33m")
set -xU LESS_TERMCAP_ue (printf "\e[0m")
set -xU LESS_TERMCAP_us (printf "\e[01;32m")

set -xU no_proxy "localhost,127.0.0.1,10.0.2.*"

set -xU LANG en_US.UTF-8
set -xU LC_ALL en_US.UTF-8

if test -f ~/.config/fish/fish_alias
        source ~/.config/fish/fish_alias
end