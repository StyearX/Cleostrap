-- Wrapper around StyearX/Icons Main-v2 API.
-- Returns the IconModule table directly so callers can use both
-- GetIcon(name) -> string   and   Icon(name) -> {sheet, rectData}
return function()
	local ok, IconModule = pcall(function()
		local cloneref = cloneref or function(x) return x end
		local HttpService = cloneref(game:GetService("HttpService"))
		local function Get(url)
			if game.HttpGet then
				return game:HttpGet(url, true)
			else
				return HttpService:GetAsync(url)
			end
		end
		return loadstring(Get("https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Main-v2.lua"))()
	end)

	if not ok or not IconModule then
		return {
			GetIcon  = function() return nil end,
			Icon     = function() return nil end,
			Icon2    = function() return nil end,
			SetIconsType = function() end,
			Loaded   = false,
		}
	end

	-- Default to lucide set
	pcall(function() IconModule.SetIconsType("lucide") end)
	IconModule.Loaded = true
	return IconModule
end
