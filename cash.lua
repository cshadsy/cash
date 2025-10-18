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
        if fs.exists(dir) and fs.isDir(dir) then
            shell.setDir(shell.resolve(dir))
        else
            print("cd: no such directory: " .. dir)
        end
        return true
    elseif cmd == "help" then
        print("Custom bash-like shell for ComputerCraft")
        print("Built-in commands:")
        print("  cd [dir]      - Change directory")
        print("  ls            - List files in current directory")
        print("  help          - Show this help message")
        print("  exit          - Exit the shell")
        print("External programs are resolved via shell.run()")
        return true
    elseif cmd == "ls" then
        local listDir = args[1] or shell.dir()
        local path = shell.resolve(listDir)
        if not fs.exists(path) then
            print("ls: cannot access '" .. listDir .. "': No such file or directory")
        elseif not fs.isDir(path) then
            print(listDir)
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

print("CASH running on CraftOS v1.9")
while true do
    io.write(shell.dir() .. " $ ")
    local line = read()
    if not runCommand(line) then
        break
    end
end

print("Session ended.")
