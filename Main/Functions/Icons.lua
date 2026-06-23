return function()
	local cloneref = cloneref or function(x) return x end
	local HttpService = cloneref(game:GetService("HttpService"))

	local function Get(url)
		if game.HttpGet then
			return game:HttpGet(url, true)
		else
			return HttpService:GetAsync(url)
		end
	end

	local function SafeLoad(url)
		local ok, raw = pcall(function()
			return loadstring(Get(url))()
		end)
		if not ok or raw == nil then return nil end
		if type(raw) == "function" then
			local ok2, result = pcall(raw)
			return ok2 and result or nil
		end
		return raw
	end

	local function WrapLucide(LucideIcons)
		if type(LucideIcons) ~= "table" then return nil end
		return {
			GetIcon = function(name)
				local iconName = name
				local colon = name:find(":")
				if colon then iconName = name:sub(colon + 1) end
				local entry = LucideIcons[iconName]
					or (LucideIcons.Icons and LucideIcons.Icons[iconName])
				if type(entry) == "string" then return entry end
				if type(entry) == "table" then return entry.Image or entry[1] end
				return nil
			end,
			Icon = function(name)
				local iconName = name
				local colon = name:find(":")
				if colon then iconName = name:sub(colon + 1) end
				local entry = LucideIcons[iconName]
					or (LucideIcons.Icons and LucideIcons.Icons[iconName])
				if type(entry) == "string" then
					return {entry, {ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0)}}
				elseif type(entry) == "table" and entry.Image then
					return {entry.Image, entry}
				end
				return nil
			end,
			SetIconsType = function() end,
			Loaded = true,
		}
	end

	local IconModule = SafeLoad("https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Main-v2.lua")

	if IconModule and type(IconModule) == "table" then
		pcall(function()
			if type(IconModule.SetIconsType) == "function" then
				IconModule.SetIconsType("lucide")
			end
		end)
		IconModule.Loaded = true
		return IconModule
	end

	local LucideIcons = SafeLoad("https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/lucide/dist/Icons.lua")
	if LucideIcons then
		local wrapped = WrapLucide(LucideIcons)
		if wrapped then return wrapped end
	end

	return {
		GetIcon      = function() return nil end,
		Icon         = function() return nil end,
		Icon2        = function() return nil end,
		SetIconsType = function() end,
		Loaded       = false,
	}
end
