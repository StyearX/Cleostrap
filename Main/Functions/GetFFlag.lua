return function(flag: string, value: string?)
	if type(flag) ~= "string" then return task.spawn(error, "string expected, got "..type(flag)) end
	local FFlag: string = Cleostrap.TouchEnabled and flag:gsub("DFInt", ""):gsub("DFFlag", ""):gsub("FFlag", ""):gsub("FInt", ""):gsub("DFString", ""):gsub("FString", "") or flag

	if getfflag(FFlag) ~= nil then
		return getfflag(FFlag)
	else
		return task.spawn(error, "FFlag expected, got "..FFlag)
	end
end
