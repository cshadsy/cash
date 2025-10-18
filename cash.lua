local function split(input)
    local words = {}
    for word in string.gmatch(input, "%S+") do
        table.insert(words, word)
    end
    return words
end

local function runCommand(cmdline)
    local args = split(cmdline)
    local cmd = args[1]
    table.remove(args, 1)

    if not cmd or cmd == "" then return true end

    if cmd == "exit" then
        return false
    elseif cmd == "cd" then
        local dir = args[1] or "/"
        local path = shell.resolve(dir)
        if fs.exists(path) and fs.isDir(path) then
            shell.setDir(path)
        else
            print("cd: " .. dir .. ": No such directory")
        end
        return true
    elseif cmd == "help" then
        print("Built-in commands: cd, ls, help, exit")
        return true
    elseif cmd == "ls" then
        local target = args[1] or "."
        local path = shell.resolve(target)
        if not fs.exists(path) then
            print("ls: cannot access '" .. target .. "': No such file or directory")
        elseif not fs.isDir(path) then
            print(target)
        else
            local items = fs.list(path)
            table.sort(items)
            for _, item in ipairs(items) do
                if fs.isDir(fs.combine(path, item)) then
                    print(item .. "/")
                else
                    print(item)
                end
            end
        end
        return true
    end

    local ok, err = shell.run(cmd, table.unpack(args))
    if not ok then
        print("Command not found or failed: " .. (err or cmd))
    end

    return true
end

print("Custom Bash-like Shell for ComputerCraft")
while true do
    io.write(shell.dir() .. " $ ")
    local line = read()
    if not runCommand(line) then
        break
    end
end

print("Session ended.")
