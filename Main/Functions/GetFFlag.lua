return function(flag: string)
	if type(flag) ~= "string" or flag:gsub(" ", ""):len() == 0 then return nil end

	local stripped = flag
		:gsub("^DFInt", "")
		:gsub("^DFFlag", "")
		:gsub("^FFlag", "")
		:gsub("^FInt", "")
		:gsub("^DFString", "")
		:gsub("^FString", "")

	-- Try bare name first, then full prefixed name.
	local ok, result = pcall(getfflag, stripped)
	if ok and result ~= nil then return result end

	local ok2, result2 = pcall(getfflag, flag)
	if ok2 and result2 ~= nil then return result2 end

	-- Check persisted FFlags.json as fallback.
	local ok3, raw = pcall(readfile, "Cleostrap/FFlags.json")
	if ok3 and raw then
		local ok4, decoded = pcall(function()
			return (game:GetService("HttpService")):JSONDecode(raw)
		end)
		if ok4 and decoded and decoded[flag] ~= nil then
			return decoded[flag]
		end
	end

	return nil
end
