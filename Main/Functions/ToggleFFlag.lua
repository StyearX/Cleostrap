local cloneref = cloneref or function(...) return ... end
local HttpService = cloneref(game:GetService("HttpService"))

return function(flag: string, value)
	if type(flag) ~= "string" or flag:gsub(" ", ""):len() == 0 then return end

	-- Strip standard FFlag prefixes so the executor's setfflag/getfflag always
	-- receives the bare name (e.g. "TaskSchedulerTargetFps"), which is the format
	-- almost all executors (mobile and PC) expect.
	local stripped = flag
		:gsub("^DFInt", "")
		:gsub("^DFFlag", "")
		:gsub("^FFlag", "")
		:gsub("^FInt", "")
		:gsub("^DFString", "")
		:gsub("^FString", "")

	local strValue = tostring(value)

	-- Attempt to apply with setfflag. Some executors accept the bare name,
	-- some accept the full prefixed name. Try both.
	local ok = pcall(setfflag, stripped, strValue)
	if not ok then
		pcall(setfflag, flag, strValue)
	end

	-- Persist to FFlags.json so rejoin reapplies the flag.
	pcall(function()
		local raw = readfile("Cleostrap/FFlags.json")
		local fflagfile = raw and HttpService:JSONDecode(raw) or {}
		fflagfile[flag] = strValue
		writefile("Cleostrap/FFlags.json", HttpService:JSONEncode(fflagfile))
	end)
end
