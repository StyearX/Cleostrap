-- Loads the StyearX/Icons module and returns it.
-- The individual icon packs (lucide, solar, etc.) are loaded by Main-v2.lua itself.
-- This function is called once at startup by Cleostrap.start and the result is
-- stored in getgenv().CleostrapIcons so GuiLibrary can access icons without
-- re-fetching on every GetIcon call.
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

	-- Try to load via the repo's Main-v2 entry point.
	-- If that fails (network error, file not found), fall back to loading
	-- lucide directly (the most commonly-used pack) so icons still work.
	local ok, IconModule = pcall(function()
		return loadstring(Get("https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Main-v2.lua"))()
	end)

	if not ok or not IconModule then
		-- Fallback: load lucide pack directly
		local ok2, LucideIcons = pcall(function()
			return loadstring(Get("https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/lucide/dist/Icons.lua"))()
		end)

		if ok2 and LucideIcons then
			-- Wrap bare lucide table into the expected API shape
			return {
				GetIcon = function(name)
					local iconType, iconName = name, name
					local colon = name:find(":")
					if colon then
						iconType = name:sub(1, colon - 1)
						iconName = name:sub(colon + 1)
					end
					local pack = iconType == "lucide" and LucideIcons or LucideIcons
					if type(pack) == "table" then
						local entry = pack[iconName] or pack.Icons and pack.Icons[iconName]
						if type(entry) == "string" then return entry end
						if type(entry) == "table" then return entry.Image or entry[1] end
					end
					return nil
				end,
				Icon = function(name)
					local colon = name:find(":")
					local iconName = colon and name:sub(colon + 1) or name
					local entry = LucideIcons[iconName] or (LucideIcons.Icons and LucideIcons.Icons[iconName])
					if type(entry) == "string" then
						return {entry, {ImageRectSize = Vector2.new(0,0), ImageRectPosition = Vector2.new(0,0)}}
					elseif type(entry) == "table" and entry.Image then
						return {entry.Image, entry}
					end
					return nil
				end,
				SetIconsType = function() end,
				Loaded = true,
			}
		end

		return {
			GetIcon = function() return nil end,
			Icon = function() return nil end,
			Icon2 = function() return nil end,
			SetIconsType = function() end,
			Loaded = false,
		}
	end

	-- Main-v2 loaded OK — set default icon type and mark as loaded
	pcall(function() IconModule.SetIconsType("lucide") end)
	IconModule.Loaded = true
	return IconModule
end
