local hideui = getgenv().hideui or false
local cloneref = cloneref or function(...) return ... end
local httpService = cloneref(game:GetService("HttpService"))
local getAsync = function(url)
	return game:HttpGet(url, true)
end

makefolder("Cleostrap")
makefolder("Cleostrap/Main")
makefolder("Cleostrap/Main/Functions")
makefolder("Cleostrap/Main/Configs")
makefolder("Cleostrap/Main/Fonts")
makefolder("Cleostrap/Images")
makefolder("Cleostrap/Logs")

local install = function()
	for _, file in httpService:JSONDecode(getAsync("https://api.github.com/repos/StyearX/Cleostrap/contents/")) do
		if file.name:find(".lua") then
			writefile(`Cleostrap/{file.name}`, `return loadstring(game:HttpGet('https://raw.githubusercontent.com/StyearX/Cleostrap/refs/heads/main/{file.name}', true))()`)
		elseif file.name:find(".mp3") or file.name:find(".png") then
			writefile(`Cleostrap/{file.name}`, game:HttpGet(`https://raw.githubusercontent.com/StyearX/Cleostrap/refs/heads/main/{file.name}`))
		end
	end

	writefile("Cleostrap/Main/Cleostrap.lua", `return loadstring(game:HttpGet('https://raw.githubusercontent.com/StyearX/Cleostrap/refs/heads/main/Main/Cleostrap.lua', true))()`)

	for _, file in httpService:JSONDecode(getAsync("https://api.github.com/repos/StyearX/Cleostrap/contents/Main/Functions")) do
		writefile(`Cleostrap/Main/Functions/{file.name}`, `return loadstring(game:HttpGet('https://raw.githubusercontent.com/StyearX/Cleostrap/refs/heads/main/Main/Functions/{file.name}', true))()`)
	end

	writefile("Cleostrap/Main/Configs/Default.json", "{}")
end

if not isfile("Cleostrap/Main/Cleostrap.lua") then
	install()
end

local function loadCleostrap()
    local success, result = pcall(function()
        return loadfile("Cleostrap/Main/Cleostrap.lua")()
    end)
    if not success or type(result) ~= "table" then
        return nil
    end
    return result
end

local Cleostrap = loadCleostrap()

if not Cleostrap then
    if isfile("Cleostrap/Main/Cleostrap.lua") then
        delfile("Cleostrap/Main/Cleostrap.lua")
    end
    install()
    Cleostrap = loadCleostrap()
end

if type(Cleostrap) == "table" then
    Cleostrap.start()
    Cleostrap.Visible(not hideui)
else
    warn("Cleostrap failed to load.")
end
