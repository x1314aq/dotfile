#!/usr/bin/fish

set enable (nmcli r wifi)
if test $enable = "enabled"
    nmcli r wifi off
else
    nmcli r wifi on
end
