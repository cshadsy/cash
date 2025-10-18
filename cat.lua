local args = {...}

local function readAndPrintFile(path)
    if not fs.exists(path) or fs.isDir(path) then
        print("cat: " .. path .. ": No such file")
        return false
    end

    local file = io.open(path, "r")
    if file then
        for line in file:lines() do
            print(line)
        end
        file:close()
        return true
    else
        print("cat: " .. path .. ": Unable to open file")
        return false
    end
end

if #args == 0 then
    while true do
        local line = read()
        if not line then break end
        print(line)
    end
else
    for _, path in ipairs(args) do
        if path == "-" then
            while true do
                local line = read()
                if not line then break end
                print(line)
            end
        else
            readAndPrintFile(shell.resolve(path))
        end
    end
end
