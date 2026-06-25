local cloneref = cloneref or function(...) return ... end
local HttpService = cloneref(game:GetService("HttpService"))

return function(flag: string, value)
	if type(flag) ~= "string" or flag:gsub(" ", ""):len() == 0 then return end

	local stripped = flag
		:gsub("^DFInt", "")
		:gsub("^DFFlag", "")
		:gsub("^FFlag", "")
		:gsub("^FInt", "")
		:gsub("^DFString", "")
		:gsub("^FString", "")

	local strValue
	if type(value) == "boolean" then
		strValue = value and "True" or "False"
	else
		strValue = tostring(value)
	end

	local ok = pcall(setfflag, stripped, strValue)
	if not ok then
		pcall(setfflag, flag, strValue)
	end

	pcall(function()
		local raw = readfile("Cleostrap/FFlags.json")
		local fflagfile = raw and HttpService:JSONDecode(raw) or {}
		fflagfile[flag] = strValue
		writefile("Cleostrap/FFlags.json", HttpService:JSONEncode(fflagfile))
	end)
end
