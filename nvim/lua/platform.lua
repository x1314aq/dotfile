if jit.os == 'Windows' then
    seperator = '\\'
    vim.g.python3_host_prog = 'python.exe'
else
    seperator = '/'
    vim.g.python3_host_prog = 'python3'
end

return {
    SEP = seperator
}