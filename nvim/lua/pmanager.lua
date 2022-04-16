local uv = vim.loop
local call = vim.call
local cmd = vim.cmd
local api = vim.api

local OS = require('platform')

local URLPREFIX = 'https://github.com/'
local PACKDIR = call('stdpath', 'data') .. OS.SEP .. 'site' .. OS.SEP .. 'pack' .. OS.SEP .. 'managed' .. OS.SEP
local packages = {}
local nr_pkgs = 0
local LOGTABLE = {}

local function do_log(str)
    table.insert(LOGTABLE, str)
end

local function plug(args)
    local name, dir
    assert(type(args) == 'string' or type(args) == 'table')
    if type(args) == 'string' then
        args = {args}
    end
    name = vim.split(args[1], '/', true)[2]
    if packages[name] then
        return
    end

    if args.dest then
        dir = PACKDIR .. args.dest .. OS.SEP .. name
    else
        dir = PACKDIR .. 'opt' .. OS.SEP .. name
    end

    packages[name] = {
        name = name,
        branch = args.branch or 'master',
        dir = dir,
        url = args.url or URLPREFIX .. args[1] .. '.git',
        run = args.run,
        exists = call('isdirectory', dir) ~= 0
    }
    nr_pkgs = nr_pkgs + 1
    do_log(string.format("package[%d]", nr_pkgs))
    for key, value in pairs(packages[name]) do
        do_log(string.format('  %s: %s', key, value))
    end
end

local function install(pkg)
    local handle, pid
    local stdout = uv.new_pipe()
    local stderr = uv.new_pipe()
    if pkg.exists then
        do_log(string.format('%s is already exists', pkg.name))
        return
    end
    do_log('going to install package: ' .. pkg.name)
    handle, pid = uv.spawn(
        'git',
        {
            args = {'clone', '-b', pkg.branch, pkg.url, pkg.dir},
            stdio = {nil, stdout, stderr}
        },
        vim.schedule_wrap(function(code, signal)
            do_log(string.format('install exited %s pid:%d code:%d signal:%d', tostring(handle), pid, code, signal))
            handle:close()
        end)
    )
    uv.read_start(stdout,
        function(err, data)
            if data then
                do_log(data)
            end
        end
    )
    uv.read_start(stderr,
        function(err, data)
            if data then
                do_log(data)
            end
        end
    )
end

local function update(pkg)
    local handle, pid
    local stdout = uv.new_pipe()
    local stderr = uv.new_pipe()
    if not pkg.exists then
        install(pkg)
        pkg.exists = true
        return
    end
    do_log('going to update package: ' .. pkg.name)
    handle, pid = uv.spawn(
        'git',
        {
            args = {'pull'},
            cwd = pkg.dir,
            stdio = {nil, stdout, stderr}
        },
        vim.schedule_wrap(function(code, signal)
            do_log(string.format('install exited %s pid:%d code:%d signal:%d', tostring(handle), pid, code, signal))
            handle:close()
        end)
    )
    uv.read_start(stdout,
        function(err, data)
            if data then
                do_log(data)
            end
        end
    )
    uv.read_start(stderr,
        function(err, data)
            if data then
                do_log(data)
            end
        end
    )
end

local function rmdir(path)
    local name, type, child
    local handle = uv.fs_scandir(path)
    while handle do
        name, type = uv.fs_scandir_next(handle)
        if not name then
            break
        end
        child = path .. OS.SEP .. name
        if type == 'directory' then
            rmdir(child)
        else
            uv.fs_unlink(child)
        end
    end
    uv.fs_rmdir(path)
end

local function clean_dir(path)
    local name
    local handle = uv.fs_scandir(path)
    while handle do
        name, _ = uv.fs_scandir_next(handle)
        if not name then
            break
        end
        if packages[name] then
            do_log('going to remove package: ' .. name)
            rmdir(packages[name].dir)
            packages[name].exists = false
        end
    end
end

local function clean()
    local name, type
    local handle = uv.fs_scandir(PACKDIR)
    while handle do
        name, type = uv.fs_scandir_next(handle)
        if not name then
            break
        end
        if type == 'directory' then
            clean_dir(PACKDIR .. OS.SEP .. name)
        end
    end
end

local function list()
    for k, v in pairs(packages) do
        print(string.format('package:%s exists:%s', k, v.exists))
    end
end

local function open_log()
    print(vim.inspect(LOGTABLE))
end

local function setup(args)
    assert(type(args) == 'table')
    for k, v in pairs(args) do
        do_log(string.format('%s: %s', k, v))
    end
    if args.urlprefix then
        URLPREFIX = args.urlprefix
    end
end

return {
    plug = plug,
    install = function() vim.tbl_map(install, packages) end,
    update = function() vim.tbl_map(update, packages) end,
    list = list,
    clean = clean,
    setup = setup,
    open_log = open_log,
}