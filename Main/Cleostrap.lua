if not isfile("Cleostrap/FFlags.json") then writefile("Cleostrap/FFlags.json", "[]") end

local function loadFunction(func: string)
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/StyearX/Cleostrap/refs/heads/main/Main/Functions/"..func..".lua"))()
end
local loadFunc = loadFunction
local cloneref = cloneref or function(...) return ... end
local players = cloneref(game:GetService("Players"))
local lplr = players.LocalPlayer
local humanoid = lplr.Character and lplr.Character:FindFirstChild("Humanoid")
local HttpService = cloneref(game:GetService("HttpService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local getgenv = getgenv or _G
local files: table = {}
local writefile = writefile or function(name: string, src: string)
	files[name] = src
end
local isfile = isfile or function(file: string)
	return readfile(file) ~= nil
end

getgenv().Cleostrap = {}
Cleostrap.TouchEnabled = UserInputService.TouchEnabled
Cleostrap.Config = setmetatable({
	OofSound = false,
	FPS = 120,
	AntiAliasingQuality = "Automatic",
	LightingTechnology = "Chosen by game",
	TextureQuality = "Automatic",
	DisablePlayerShadows = false,
	DisablePostFX = false,
	DisableTerrainTextures = false,
	GraySky = false,
	Desync = false,
	HitregFix = false,
	PerformanceBoost = false,
	DisableAds = false,
	DisableTelemetry = false,
	DisableWind = false,
	RemoveGrass = false,
	InfiniteZoom = false,
	DisableDynamicHeads = false,
	DisableBlur = false,
	NoInternetDisconnect = false,
	DisableBubbleChat = false,
	customfonttoggle = false,
	customfontroblox = "",
	customtopbar = false,
	CustomFont = "",
	CameraSensitivity = 1,
	CrosshairImage = "",
	TouchUiSize = 1
}, {
	__index = function(s, i)
		s[i] = false
		return s[i]
	end
})
local conf = Cleostrap.Config
Cleostrap.canUpdate = false
Cleostrap.UpdateConfig = function(obj: string, val: any)
	if not Cleostrap.canUpdate then Cleostrap.Config = conf return end
	Cleostrap.Config[obj] = val
end
Cleostrap.SaveConfig = function()
	return writefile("Cleostrap/Main/Configs/Default.json", HttpService:JSONEncode(Cleostrap.Config))
end
if isfile("Cleostrap/Main/Configs/Default.json") then
	Cleostrap.Config = HttpService:JSONDecode(readfile("Cleostrap/Main/Configs/Default.json"))
	conf = Cleostrap.Config
end

local notif = function(a, b)
	cloneref(game:GetService("StarterGui")):SetCore("SendNotification", {
		Title = "Cleostrap",
		Text = a,
		Duration = b or 6
	})
end

Cleostrap.error = notif
Cleostrap.success = notif
Cleostrap.info = notif

-- TopBar resolution: Roblox's internal TopBarApp structure is undocumented
-- and changes between client versions (confirmed nested as TopBarApp.TopBarApp.*).
-- These helpers resolve it safely with a timeout instead of hard-indexing,
-- so a missing/renamed instance degrades gracefully instead of erroring.
local function GetTopBar(timeoutSeconds: number?)
	local CoreGui = cloneref(game:GetService("CoreGui"))
	local ok, outer = pcall(function()
		return CoreGui:WaitForChild("TopBarApp", timeoutSeconds or 5)
	end)
	if not ok or not outer then return nil end

	local ok2, inner = pcall(function()
		return outer:WaitForChild("TopBarApp", timeoutSeconds or 5)
	end)
	if ok2 and inner then
		return inner
	end
	-- some client versions are not double-nested; fall back to the outer instance
	return outer
end

-- Finds the chat menu frame inside UnibarMenu without relying on brittle
-- numeric index names (e.g. ["2"]["3"]) which Roblox can reassign at any time.
-- Walks descendants looking for a child literally named "chat", then the
-- numeric "5" subframe is resolved by scanning that child's children instead
-- of indexing it directly.
local function FindChatMenuFrame(topBar: Instance?)
	if not topBar then return nil end
	local ok, unibarMenu = pcall(function()
		local left = topBar:FindFirstChild("UnibarLeftFrame")
		return left and left:FindFirstChild("UnibarMenu")
	end)
	if not ok or not unibarMenu then return nil end

	local chat
	for _, descendant in unibarMenu:GetDescendants() do
		if descendant.Name == "chat" then
			chat = descendant
			break
		end
	end
	if not chat then return nil end

	-- the "5" subframe historically holds the badge/label; find it by scanning
	-- chat's children for the first Frame-like child instead of hardcoding "5"
	local sub = chat:FindFirstChild("5")
	if not sub then
		for _, child in chat:GetChildren() do
			if child:IsA("GuiObject") then
				sub = child
				break
			end
		end
	end
	return chat, sub
end

local function FindNineDotMenuFrame(topBar: Instance?)
	if not topBar then return nil end
	local ok, unibarMenu = pcall(function()
		local left = topBar:FindFirstChild("UnibarLeftFrame")
		return left and left:FindFirstChild("UnibarMenu")
	end)
	if not ok or not unibarMenu then return nil end

	for _, descendant in unibarMenu:GetDescendants() do
		if descendant.Name == "nine_dot" then
			return descendant
		end
	end
	return nil
end

Cleostrap.ToggleFFlag = loadFunc("ToggleFFlag")
Cleostrap.GetFFlag = loadFunc("GetFFlag")
Cleostrap.start = function(vis: boolean?)
	if vis == nil then vis = true end

	if not vis then
		setidentity(8)
		game:GetService("CoreGui")["Cleostrap Library"].Enabled = false
	end

	if not isfolder("Cleostrap/Logs") then makefolder("Cleostrap/Logs") end
	getgenv().errorlog = getgenv().errorlog or "Cleostrap/Logs/crashlog"..HttpService:GenerateGUID(false)..".txt"

	-- Pre-load the icon module synchronously before building the GUI.
	-- GuiLibrary.lua reads getgenv().CleostrapIcons so every MakeTab/AddSection
	-- call can resolve icons without triggering a network fetch mid-render.
	if not getgenv().CleostrapIcons then
		local ok, Icons = pcall(function()
			return loadfile("Cleostrap/Main/Functions/Icons.lua")()()
		end)
		getgenv().CleostrapIcons = (ok and Icons and Icons.Loaded) and Icons or {
			GetIcon      = function() return nil end,
			Icon         = function() return nil end,
			Icon2        = function() return nil end,
			SetIconsType = function() end,
			Loaded       = false
		}
	end

	local GUI: table = loadfile("Cleostrap/Main/Functions/GuiLibrary.lua")()
	local main: table? = GUI:MakeWindow({
		Title = "Cleostrap",
		SubTitle = "",
		SaveFolder = "Cleostrap/Main/Configs"
	})
	main:Visible(vis)

local Integrations: tab = main:MakeTab({"Integrations", "plug"})
local FastFlags: tab = main:MakeTab({"Mods", "wrench"})
local EngineSettings: tab = main:MakeTab({"Engine Settings", "flag"})
local Appearance: tab = main:MakeTab({"Appearance", "paintbrush-2"})
Appearance:AddSection({'Theme', 'swatch-book'})
Appearance:AddDropdown({
    Name = 'Theme',
    Description = 'Changes the color scheme of the Cleostrap window.',
    Options = {'Darker', 'Dark', 'Purple', 'Midnight', 'Rose', 'Forest', 'Ocean', 'Sunset'},
    Default = GUI.Save.Theme,
    Callback = function(val)
        GUI:SetTheme(val)
    end
})
Appearance:AddSection({'Player', 'user'})
local storeeffects = {}
local isalive = function(v)
      v = v or lplr
      local a, b = pcall(function()
          return v.Character and v.Character:FindFirstChild('HumanoidRootPart') and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0
      end)
      return a and b or false
end
local derendering = Appearance:AddToggle({
    Name = 'De Rendering',
    Description = 'Stops effects and player animations from rendering.',
    Default = Cleostrap.Config.DeRendering,
    Callback = function(call)
        Cleostrap.UpdateConfig('DeRendering', call)
        Cleostrap.ToggleFFlag('FFlagDisablePostFx', call)
        if call then
            repeat
                for i,v in players:GetPlayers() do
                    if not isalive(lplr) then break end
                    if v ~= lplr and isalive(v) then
                        pcall(function()
                            local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                            for i,track in v.Character.Humanoid:GetPlayingAnimationTracks() do
                                track:AdjustSpeed(mag <= 100 and 1 or 0)
                            end
                        end)
                    end
                end
                task.wait()
            until not Cleostrap.Config.DeRendering
        end
    end
})
pcall(function()
local camerascript = require and require(lplr.PlayerScripts.PlayerModule.CameraModule.CameraInput) or {}
local old = camerascript.getRotation
local camsensitivity = Appearance:AddSlider({
    Name = 'Camera Sensitivity',
    Min = 1,
    Max = 7,
    Increase = 0.1,
    Default = Cleostrap.Config.CameraSensitivity,
    Callback = function(val)
        Cleostrap.UpdateConfig('CameraSensitivity', val)
        camerascript.getRotation = function(...)
            return old(...) * val
        end
    end
})  
        end)
local funnycon
local guisets = {}
local guiscale = Appearance:AddToggle({
    Name = 'GUIScaler',
    Description = 'Decrease the roblox gui scales',
    Default = Cleostrap.Config.GUIScale,
    Callback = function(call)
        Cleostrap.UpdateConfig('GUIScale', call)
        if call then
            funnycon = lplr.PlayerGui.ChildAdded: Connect(function(v)
                if v.Name == 'TouchGui' then return end
                local oldui = v:FindFirstChildWhichIsA('UIScale', true)
                if oldui then
                    table.insert(guisets, {oldscale = oldui.Scale, scaler = oldui})
                    oldui.Scale = 0.5
                else
                    local uiscale = Instance.new('UIScale', v)
                    uiscale.Scale = 0.7
                    table.insert(guisets, {oldscale = 9e9, scaler = uiscale})
                end
           end)
            for i,v in lplr.PlayerGui:GetChildren() do
                if v.Name == 'TouchGui' then continue end
                local oldui = v:FindFirstChildWhichIsA('UIScale', true)
                if oldui then
                    table.insert(guisets, {oldscale = oldui.Scale, scaler = oldui})
                    oldui.Scale = 0.5
                else
                    local uiscale = Instance.new('UIScale', v)
                    uiscale.Scale = 0.7
                    table.insert(guisets, {oldscale = 9e9, scaler = uiscale})
                end
            end
            for i,v in game.CoreGui:GetChildren() do
          
                local oldui = v:FindFirstChildWhichIsA('UIScale')
                if oldui then
                    table.insert(guisets, {oldscale = oldui.Scale, scaler = oldui})
                    oldui.Scale -= 0.3
                else
                    local uiscale = Instance.new('UIScale', v)
                    uiscale.Scale = 0.7
                    table.insert(guisets, {oldscale = 9e9, scaler = uiscale})
                end
            end
        else
            pcall(function() funnycon:Disconnect() funnycon = nil end)
            for i,v in guisets do
                if v.oldscale == 9e9 then
                    v.scaler:Destroy()
                else
                    v.scaler.Scale = v.oldscale
                end
            end
            table.clear(guisets)
        end
    end
})

local touchuuval = 1.2
local touchuiscale
local touchui = Appearance:AddToggle({
    Name = 'TouchGui Size',
    Description = 'Increases your touchgui size.',
    Default = Cleostrap.Config.TouchUI,
    Callback = function(call)
        if call then
            touchuiscale = Instance.new('UIScale', lplr.PlayerGui.TouchGui)
            touchuiscale.Scale = touchuuval
        else
            if touchuiscale then
                touchuiscale:Destroy()
                touchuiscale = nil
            end
        end
    end
})
Appearance:AddSlider({
    Name = 'Scale',
    Min = 1,
    Max = 2,
    Increase = 0.1,
    Callback = function(val)
        Cleostrap.UpdateConfig('TouchUiSize', val)
        touchuuval = val
        if touchuiscale then
            touchuiscale.Scale = val
        end
    end
})

local chosenimage = ''
local imagelabel
local screengui = Instance.new('ScreenGui', game.CoreGui)
screengui.IgnoreGuiInset = true
local crosshaircons = {}
local crosshair = Appearance:AddToggle({
    Name = 'Crosshair',
    Default = Cleostrap.Config.Crosshair,
    Callback = function(call)
        Cleostrap.UpdateConfig('Crosshair', call)
        if call then
            imagelabel = Instance.new('ImageLabel', screengui)
            imagelabel.Size = UDim2.new(0, 19, 0, 19)
            imagelabel.AnchorPoint = Vector2.new(0.5, 0.5)
            imagelabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            imagelabel.BackgroundTransparency = 1
            imagelabel.Image = chosenimage
            imagelabel.Visible = true
            repeat
              task.wait()
              if not isalive() then continue end
              local mag = (lplr.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).magnitude
              imagelabel.Visible = (mag <= 3)
            until not Cleostrap.Config.Crosshair
        else
            for i,v in crosshaircons do
                if v and v.Disconnect then v:Disconnect() end
            end
            table.clear(crosshaircons)
            if imagelabel then
                imagelabel:Destroy()
            end
        end
    end
})
Appearance:AddDropdown({
    Name = 'Image',
    Description = 'Add image files to "Cleostrap/Images" to populate this list.',
    Options = listfiles('Cleostrap/Images'),
    Default = Cleostrap.Config.CrosshairImage,
    Callback = function(val)
        Cleostrap.UpdateConfig('CrosshairImage', val)
        if type(val) ~= "string" or val:gsub(" ", ""):len() == 0 then
            return
        end
        chosenimage = getcustomasset(val)
        if imagelabel then
            imagelabel.Image = chosenimage
        end
    end
})
Appearance:AddSection({'Customizations', 'palette'})
local gradients = {}
local fakerobloxbutton
local topBarApp = GetTopBar()

pcall(function()
	if not topBarApp then return end
	local unibarLeft = topBarApp:FindFirstChild("UnibarLeftFrame")
	if not unibarLeft then return end

	fakerobloxbutton = Instance.new('TextButton', unibarLeft)
	fakerobloxbutton.BorderSizePixel = 0
	fakerobloxbutton.BackgroundTransparency = 0.07
	fakerobloxbutton.Text = ''
	fakerobloxbutton.Name = 'funni'
	fakerobloxbutton.ZIndex = 999
	fakerobloxbutton.BackgroundColor3 = Color3.new()
	fakerobloxbutton.Size = UDim2.new(0, 44, 0, 44)
	fakerobloxbutton.Position = UDim2.new(0, -52, 0, 0)
	fakerobloxbutton.Visible = false
	fakerobloxbutton.MouseButton1Click:Connect(function()
		pcall(function()
			local bar = GetTopBar()
			local menuIconHolder = bar and bar:FindFirstChild("MenuIconHolder")
			local triggerPoint = menuIconHolder and menuIconHolder:FindFirstChild("TriggerPoint")
			local background = triggerPoint and triggerPoint:FindFirstChild("Background")
			if background then
				pcall(firesignal, background.Activated)
			end
		end)
	end)

	local fakeRobloxImage = Instance.new('ImageLabel', fakerobloxbutton)
	fakeRobloxImage.Size = UDim2.new(0, 22, 0, 22)
	fakeRobloxImage.Position = UDim2.new(0.25, 0, 0.25, 0)
	fakeRobloxImage.BackgroundTransparency = 1
	fakeRobloxImage.Image = getcustomasset('Cleostrap/icon.png')
	fakeRobloxImage.ImageColor3 = Color3.new(1, 1, 1)

	Instance.new('UICorner', fakerobloxbutton).CornerRadius = UDim.new(1, 0)
end)

local fakeRobloxImage = fakerobloxbutton and fakerobloxbutton:FindFirstChildOfClass("ImageLabel")

local customtopbar
local topbarChatConnection
customtopbar = Appearance:AddToggle({
	Name = 'Cleostrap Topbars',
	Description = 'Gives you a cool unique topbar.',
	Default = Cleostrap.Config.customtopbar,
	Callback = function(call)
		Cleostrap.UpdateConfig('customtopbar', call)

		local ok = pcall(function()
			local bar = GetTopBar()
			local menuIconHolder = bar and bar:FindFirstChild("MenuIconHolder")
			local triggerPoint = menuIconHolder and menuIconHolder:FindFirstChild("TriggerPoint")
			local background = triggerPoint and triggerPoint:FindFirstChild("Background")
			local scalingIcon = background and background:FindFirstChild("ScalingIcon")

			local chat, chatSub = FindChatMenuFrame(bar)
			local nineDot = FindNineDotMenuFrame(bar)

			local topbarinstances = {}
			if chat then
				local integrationIconFrame = chat:FindFirstChild("IntegrationIconFrame")
				local integrationIcon = integrationIconFrame and integrationIconFrame:FindFirstChild("IntegrationIcon")
				if integrationIcon then table.insert(topbarinstances, integrationIcon) end
			end
			if nineDot then
				local integrationIconFrame = nineDot:FindFirstChild("IntegrationIconFrame")
				local integrationIcon = integrationIconFrame and integrationIconFrame:FindFirstChild("IntegrationIcon")
				if integrationIcon then
					local overflow = integrationIcon:FindFirstChild("Overflow")
					local close = integrationIcon:FindFirstChild("Close")
					if overflow then table.insert(topbarinstances, overflow) end
					if close then table.insert(topbarinstances, close) end
				end
			end
			if scalingIcon then table.insert(topbarinstances, scalingIcon) end

			if call then
				if chat then
					topbarChatConnection = chat.ChildAdded:Connect(function(v)
						local grad = Instance.new('UIGradient', v)
						grad.Rotation = -60
						grad.Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(219, 89, 171)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(61, 56, 192))
						})
						if v:FindFirstChild("Text") then
							v.Text.TextColor3 = Color3.new()
							v.Text.TextTruncate = 'None'
						end
						table.insert(gradients, grad)
					end)
				end
				if chatSub then
					local badge = chatSub:FindFirstChild('Badge')
					if badge then
						local grad = Instance.new('UIGradient', badge)
						if badge:FindFirstChild("Text") then
							badge.Text.TextTruncate = 'None'
							badge.Text.TextColor3 = Color3.new()
						end
						grad.Rotation = -60
						grad.Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(219, 89, 171)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(61, 56, 192))
						})
						table.insert(gradients, grad)
					end
				end
				for _, v in topbarinstances do
					local grad = Instance.new('UIGradient', v)
					grad.Rotation = 60
					grad.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(219, 89, 171)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(61, 56, 192))
					})
					table.insert(gradients, grad)
				end
			else
				pcall(function() topbarChatConnection:Disconnect() end)
				for _, v in gradients do pcall(function() v:Destroy() end) end
				table.clear(gradients)
			end
		end)

		if not ok then
			Cleostrap.error("Cleostrap Topbars couldn't fully apply on this client version.")
		end
	end
})

local rotatinghotbar = Appearance:AddToggle({
	Name = 'Spin Hotbar',
	Description = 'Spins the roblox logo around for whatever reason.',
	Default = Cleostrap.Config.RotatingHotbar,
	Callback = function(call)
		Cleostrap.UpdateConfig('RotatingHotbar', call)
		local bar = GetTopBar()
		local menuIconHolder = bar and bar:FindFirstChild("MenuIconHolder")
		local triggerPoint = menuIconHolder and menuIconHolder:FindFirstChild("TriggerPoint")
		local background = triggerPoint and triggerPoint:FindFirstChild("Background")
		local scalingIcon = background and background:FindFirstChild("ScalingIcon")

		if not scalingIcon then
			if call then Cleostrap.error("Spin Hotbar isn't supported on this client version.") end
			return
		end

		if call then
			repeat
				scalingIcon.Rotation += 1.5
				if fakeRobloxImage then fakeRobloxImage.Rotation += 1.5 end
				task.wait(0)
			until not Cleostrap.Config.RotatingHotbar
		else
			scalingIcon.Rotation = 0
			if fakeRobloxImage then fakeRobloxImage.Rotation = 0 end
		end
	end
})

local ActivityTracking: section = Integrations:AddSection({"Activity Tracking", "activity"})
Integrations:AddButton({
	Name = "Rejoin",
	Description = "Rejoins the current game to fully apply all Fast Flags that require a restart.",
	Icon = "refresh-cw",
	Callback = function()
		local teleportService = cloneref(game:GetService("TeleportService"))
		local placeId = game.PlaceId
		local jobId = game.JobId
		local players = cloneref(game:GetService("Players"))
		local localPlayer = players.LocalPlayer
		if placeId and placeId ~= 0 then
			local ok, err = pcall(function()
				teleportService:TeleportToPlaceInstance(placeId, jobId, localPlayer)
			end)
			if not ok then
				pcall(function()
					teleportService:Teleport(placeId, localPlayer)
				end)
			end
		else
			Cleostrap.error("Can't rejoin: not in a valid game.")
		end
	end
})

Integrations:AddButton({
	Name = "Rejoin to New Server",
	Description = "Joins a fresh server of the current game to apply Fast Flags in a clean session.",
	Icon = "server",
	Callback = function()
		local teleportService = cloneref(game:GetService("TeleportService"))
		local placeId = game.PlaceId
		local players = cloneref(game:GetService("Players"))
		local localPlayer = players.LocalPlayer
		if placeId and placeId ~= 0 then
			pcall(function()
				teleportService:Teleport(placeId, localPlayer)
			end)
		else
			Cleostrap.error("Can't teleport: not in a valid game.")
		end
	end
})

local FFlagEditor: section = FastFlags:AddSection({"Fast Flag Editor", "flag"})
local usefilepath = false
local FFETextbox: textbox = FastFlags:AddTextBox({
    Name = "Paste Fast Flags (json)",
    Description = "Use with caution. Misusing this can lead to instability or unexpected things happening.",
    Default = readfile('Cleostrap/FFlags.json'),
    Callback = function(call: string)
        writefile("Cleostrap/FFlags.json", call)
        local fflags = HttpService:JSONDecode(call:gsub('"True"', "true"):gsub('"False"', "false"))
        for i,v in fflags do
            Cleostrap.ToggleFFlag(i,v)
        end
    end
})

local Presets: section = FastFlags:AddSection({"Presets: Unbannable", "shield-check"})

local GraySky: toggle = FastFlags:AddToggle({
    Name = "Gray sky",
    Description = "Turns the sky gray. Requires rejoin.",
    Default = Cleostrap.Config.GraySky,
    Callback = function(callback)
        Cleostrap.UpdateConfig("GraySky", callback)
        Cleostrap.ToggleFFlag("FFlagDebugSkyGray", callback)
    end
})

local DisableAds: toggle = FastFlags:AddToggle({
    Name = "Disable ads",
    Description = "Removes in-experience ads from loading.",
    Default = Cleostrap.Config.DisableAds,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisableAds", callback)
        Cleostrap.ToggleFFlag("FFlagAdServiceEnabled", not callback)
    end
})

local DisableTelemetry: toggle = FastFlags:AddToggle({
    Name = "Disable telemetry",
    Description = "Reduces background data collection sent to Roblox.",
    Default = Cleostrap.Config.DisableTelemetry,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisableTelemetry", callback)
        local TelemetryFlags = {
            FFlagDebugDisableTelemetryEphemeralCounter = callback,
            FFlagDebugDisableTelemetryEphemeralStat    = callback,
            FFlagDebugDisableTelemetryEventIngest      = callback,
            FFlagDebugDisableTelemetryPoint            = callback,
            FFlagDebugDisableTelemetryV2Counter        = callback,
            FFlagDebugDisableTelemetryV2Event          = callback,
            FFlagDebugDisableTelemetryV2Stat           = callback,
        }
        for flagName, flagValue in TelemetryFlags do
            Cleostrap.ToggleFFlag(flagName, flagValue)
        end
    end
})

local PerformanceBoost: toggle = FastFlags:AddToggle({
    Name = "Performance boost",
    Description = "Applies a set of flags that improve frame pacing, replication throughput and input latency. Rejoin to fully remove.",
    Default = Cleostrap.Config.PerformanceBoost,
    Callback = function(callback)
        Cleostrap.UpdateConfig("PerformanceBoost", callback)
        if not callback then return end
        local PerfFlags = {
            DFFlagFastEndUpdateLoop                            = "True",
            FFlagSimEnableDCD16                                = "True",
            DFFlagReplicatorSeparateVarThresholds              = "True",
            FFlagFasterPreciseTime4                            = "True",
            FFlagLargeReplicatorRead2                          = "True",
            FFlagPreComputeAcceleratorArrayForSharingTimeCurve = "True",
            FFlagUserBetterInertialScrolling                   = "True",
            FFlagUISUseLastFrameTimeInUpdateInputSignal        = "True",
            DFFlagNextGenRepRollbackOverbudgetPackets          = "True",
            DFFlagTeleportClientAssetPreloadingDoingExperiment2 = "True",
            DFIntMegaReplicatorNumParallelTasks                = "12",
            DFIntNetworkClusterPacketCacheNumParallelTasks     = "12",
            DFIntTaskSchedulerJobInitThreads                   = "12",
            DFIntCodecMaxOutgoingFrames                        = "1000",
            DFIntS2PhysicsSenderRate                          = "128",
            DFIntGraphicsOptimizationModeMaxFrameTimeTargetMs  = "25",
            DFIntGraphicsOptimizationModeMinFrameTimeTargetMs  = "16",
            FIntActivatedCountTimerMSKeyboard                  = "0",
        }
        for flagName, flagValue in PerfFlags do
            Cleostrap.ToggleFFlag(flagName, flagValue)
        end
    end
})

local updatedfonts: table = {}
local font: string = 'Arimo'
local fonttdropdown: dropdown
local customFontEnabled = false
local currentcustomfont = nil
local funnycon84
local usecustomfont: toggle

-- Applies the chosen font to an instance while guarding against the
-- PropertyChangedSignal("Font") connection re-firing itself: setting
-- .FontFace also updates the legacy .Font property internally, which would
-- otherwise retrigger this same connection and spam warnings/errors forever.
local applyingFont = {}
local function ApplyFont(inst: Instance, currfont: string)
    if applyingFont[inst] then return end
    applyingFont[inst] = true

    if currentcustomfont then
        inst.FontFace = currentcustomfont
    elseif currfont and Enum.Font[currfont] then
        inst.Font = Enum.Font[currfont]
    end

    applyingFont[inst] = false
end

local function HookFontInstance(v: Instance)
    if updatedfonts[v] then return end -- already hooked, avoid duplicate connections
    if not (v.ClassName == 'TextLabel' or v.ClassName == 'TextButton' or v.ClassName == 'TextBox') then return end

    local ok, originalFontName = pcall(function()
        return tostring(v.Font):split('.')[3]
    end)
    if not ok then return end

    local entry = {inst = v, font = originalFontName}
    entry.connection = v:GetPropertyChangedSignal('Font'):Connect(function()
        ApplyFont(v, originalFontName)
    end)
    updatedfonts[v] = entry

    ApplyFont(v, originalFontName)
end

local fontchanger: toggle = FastFlags:AddToggle({
    Name = 'Change Game Fonts',
    Description = 'Changes The Game font to the one you chose',
    Callback = function(call: boolean)
    customFontEnabled = call
    Cleostrap.UpdateConfig('customfonttoggle', call)
    if call then
        funnycon84 = game.DescendantAdded:Connect(function(v)
            if customFontEnabled then
                pcall(HookFontInstance, v)
            end
        end)
        for i,v in game:GetDescendants() do
            pcall(HookFontInstance, v)
        end
    else
        pcall(function() funnycon84:Disconnect() end)
        for inst, entry in updatedfonts do
            pcall(function()
                entry.connection:Disconnect()
                entry.connection = nil
                inst.Font = Enum.Font[entry.font]
            end)
        end
        table.clear(updatedfonts)
    end
    end
})
local list: table = {}
for i,v in Enum.Font:GetEnumItems() do
    table.insert(list, tostring(v):split('.')[3]);
end
fonttdropdown = FastFlags:AddDropdown({
    Name = "Preset-Fonts",
    Description = "",
    Options = list,
    Default = Cleostrap.Config.customfontroblox or '',
    Callback = function(qweqweq: string)
        Cleostrap.UpdateConfig('customfontroblox', qweqweq);
    font = qweqweq
    end
})
local fontlists = {'none'}
for i,v in listfiles('Cleostrap/Main/Fonts') do
    if v:find('.ttf') then
        table.insert(fontlists, v)
    end
end
usecustomfont = FastFlags:AddDropdown({
    Name = 'Custom Fonts',
    Options = fontlists,
    Description = 'All fonts that are inside "Cleostrap/Main/Fonts" folder.',
    Default = Cleostrap.Config.CustomFont,
    Callback = function(val)
        if type(val) ~= "string" or val == 'none' or val:gsub(" ", ""):len() == 0 then
            currentcustomfont = nil
            return Cleostrap.UpdateConfig('CustomFont', '')
        end
        local json = val:gsub('.ttf', '.json')
        Cleostrap.UpdateConfig('CustomFont', val)
        writefile(json, HttpService:JSONEncode({name = 'font', faces = {
            {
                name = 'Regular',
                weight = 600,
                style = 'normal',
                assetId = getcustomasset(val)
            }
        }}))
          currentcustomfont = Font.new(getcustomasset(json), Enum.FontWeight.Regular)
          if Cleostrap.Config.customfonttoggle then
            fontchanger:Toggle(false)
            fontchanger:Toggle(true)
          end
    end
})

fontchanger:Toggle(Cleostrap.Config.customfonttoggle)

local Presets: section = FastFlags:AddSection({"Presets: Bannable", "shield-alert"})

local Desync: toggle = FastFlags:AddToggle({
    Name = "Desync",
    Description = "Lags your character behind on other screens.",
    Default = Cleostrap.Config.Desync,
    Callback = function(callback: boolean)
        Cleostrap.UpdateConfig("Desync", callback)
        Cleostrap.ToggleFFlag("DFIntS2PhysicsSenderRate", callback and 38000 or 15)
    end
})

local HitregFix: toggle = FastFlags:AddToggle({
    Name = "Hitreg Fix",
    Description = "Makes your hitreg in most games better. Rejoin to fully remove when disabled.",
    Default = Cleostrap.Config.HitregFix,
    Callback = function(callback: boolean)
        Cleostrap.UpdateConfig("HitregFix", callback)
        if not callback then return end
        local HitregFlags = {
            DFIntCodecMaxIncomingPackets                    = "100",
            DFIntCodecMaxOutgoingFrames                     = "1000",
            DFIntLargePacketQueueSizeCutoffMB               = "1000",
            DFIntMaxProcessPacketsJobScaling                 = "10000",
            DFIntMaxProcessPacketsStepsAccumulated           = "0",
            DFIntMaxProcessPacketsStepsPerCyclic             = "5000",
            DFIntMegaReplicatorNetworkQualityProcessorUnit   = "12",
            DFIntMegaReplicatorNumParallelTasks              = "12",
            DFIntNetworkClusterPacketCacheNumParallelTasks   = "12",
            DFIntNetworkLatencyTolerance                     = "1",
            DFIntNetworkPrediction                           = "120",
            DFIntOptimizePingThreshold                       = "50",
            DFIntPlayerNetworkUpdateQueueSize                = "20",
            DFIntPlayerNetworkUpdateRate                     = "60",
            DFIntRaknetBandwidthInfluxHundredthsPercentageV2 = "10000",
            DFIntRaknetBandwidthPingSendEveryXSeconds        = "1",
            DFIntRakNetLoopMs                                = "1",
            DFIntRakNetResendRttMultiple                     = "1",
            DFIntS2PhysicsSenderRate                         = "128",
            DFIntServerPhysicsUpdateRate                     = "60",
            DFIntServerTickRate                              = "60",
            DFIntWaitOnRecvFromLoopEndedMS                   = "100",
            DFIntWaitOnUpdateNetworkLoopEndedMS              = "100",
            DFFlagNextGenRepRollbackOverbudgetPackets        = "True",
            DFFlagReplicatorSeparateVarThresholds            = "True",
            FFlagLargeReplicatorRead2                        = "True",
            FFlagOptimizeNetwork                             = "true",
            FFlagOptimizeNetworkRouting                      = "true",
            FFlagOptimizeNetworkTransport                    = "true",
            FFlagOptimizeServerTickRate                      = "true",
            FIntRakNetResendBufferArrayLength                = "128",
        }
        for flagName, flagValue in HitregFlags do
            Cleostrap.ToggleFFlag(flagName, flagValue)
        end
    end
})

local Presets: section = EngineSettings:AddSection({"Presets", "settings-2"})

local deathsoundConnection;
local enabled
local notified = false
local addcon = function()
    if getcustomasset == nil  then
        return
    end
    if deathsoundConnection then
        deathsoundConnection:Disconnect()
        deathsoundConnection = nil
    end
    if not lplr.Character then
        repeat task.wait() until lplr.Character
    end
    if not lplr.Character:FindFirstChild('Humanoid') then
        repeat task.wait() until lplr.Character:FindFirstChild('Humanoid')
    end
    repeat task.wait() until humanoid.Parent ~= nil
    deathsoundConnection = humanoid.HealthChanged:Connect(function()
        if humanoid.Health <= 0 then
            game:GetService("Players").LocalPlayer.PlayerScripts.RbxCharacterSounds.Enabled = false
            local sound = Instance.new("Sound", workspace)
            sound.SoundId = isfile('Cleostrap/deathsound.mp3') and getcustomasset('Cleostrap/deathsound.mp3') or isfile('Cleostrap/oofsound.mp3') and getcustomasset('Cleostrap/oofsound.mp3')
            sound.PlayOnRemove = true 
            sound.Volume = 0.5
            sound:Destroy()
        end
    end)
end
local olddeathsound: toggle = EngineSettings:AddToggle({
    Name = isfile('Cleostrap/deathsound.mp3') and 'Use custom death sound' or 'Use old death sound',
    Description = isfile('Cleostrap/deathsound.mp3') and 'Gives you a custom death sound.' or "Bring back the classic 'oof' death sound.",
    Default = Cleostrap.Config.OofSound,
    Callback = function(call)
    Cleostrap.UpdateConfig("OofSound", call)
        if call then
            addcon()
            lplr.CharacterAdded:Connect(addcon)
        else
            deathsoundConnection:Disconnect()
            deathsoundConnection = nil
        end
    end
})

lplr.CharacterAdded:Connect(function()
    if not lplr.Character then
        repeat task.wait() until lplr.Character
    end
    if not lplr.Character:FindFirstChild('Humanoid') then
        repeat task.wait() until isalive()
    end
    humanoid = lplr.Character:FindFirstChild('Humanoid')
    game:GetService("Players").LocalPlayer.PlayerScripts.RbxCharacterSounds.Enabled = true
end)

local defaultMSAA = tonumber(Cleostrap.GetFFlag("FIntDebugForceMSAASamples")) or 0
local AntiAliasingQuality: dropdown = EngineSettings:AddDropdown({
    Name = "Anti-aliasing quality (MSAA)",
    Description = "Does not apply on mobile.",
    Options = {"Automatic", "1x", "2x", "4x"},
    Default = Cleostrap.Config.AntiAliasingQuality,
    Callback = function(msaa: string)
        if UserInputService.TouchEnabled then return end
        Cleostrap.UpdateConfig("AntiAliasingQuality", msaa)
        Cleostrap.ToggleFFlag("FIntDebugForceMSAASamples", msaa:find("x") and msaa:gsub("x", "") or defaultMSAA)
    end
})

local shadowIntense = tonumber(Cleostrap.GetFFlag("FIntRenderShadowIntensity")) or 1
local DisablePlayerShadows: toggle = EngineSettings:AddToggle({
    Name = "Disable player shadows",
    Description = "",
    Default = Cleostrap.Config.DisablePlayerShadows,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisablePlayerShadows", callback)
        Cleostrap.ToggleFFlag("FIntRenderShadowIntensity", callback and 0 or shadowIntense)
    end
})

local disableppfx = Cleostrap.GetFFlag("FFlagDisablePostFx") or false
local DisablePostFX: toggle = EngineSettings:AddToggle({
    Name = "Disable post-processing effects",
    Description = "",
    Default = Cleostrap.Config.DisablePostFX,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisablePostFX", callback)
        Cleostrap.ToggleFFlag("FFlagDisablePostFx", callback and true or disableppfx)
    end
})

local disableterraintex = tonumber(Cleostrap.GetFFlag("FIntTerrainArraySliceSize")) or 3
local DisableTerrainTextures: toggle = EngineSettings:AddToggle({
    Name = "Disable terrain textures",
    Description = "",
    Default = Cleostrap.Config.DisableTerrainTextures,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisableTerrainTextures", callback)
        Cleostrap.ToggleFFlag("FIntTerrainArraySliceSize", callback and 0 or disableterraintex)
    end
})

local origValue = tonumber(Cleostrap.GetFFlag("DFIntTaskSchedulerTargetFps")) or 60
local FramerateLimit: textbox = EngineSettings:AddTextBox({
    Name = "Framerate limit",
    Description = "Set to 0 if you want to use Roblox's native framerate unlocker.",
    Default = Cleostrap.Config.FPS,
    Callback = function(fps)
        if type(fps) == "string" then fps = tonumber(fps) end
        if type(fps) ~= "number" then return end
        Cleostrap.UpdateConfig("FPS", fps)
        Cleostrap.ToggleFFlag("FFlagTaskSchedulerLimitTargetFpsTo2402", fps >= 70)
        if fps > 0 then
            pcall(setfpscap, fps)
            Cleostrap.ToggleFFlag("DFIntTaskSchedulerTargetFps", fps)
        else
            pcall(setfpscap, 9e9)
            Cleostrap.ToggleFFlag("DFIntTaskSchedulerTargetFps", origValue)
        end
    end;
});
EngineSettings:AddToggle({
    Name = 'Display FPS',
    Default = Cleostrap.Config.DisplayFPS,
    Callback = function(call)
        Cleostrap.UpdateConfig('DisplayFPS', call)
        Cleostrap.ToggleFFlag('FFlagDebugDisplayFPS', call);
    end
})

local function changeLighting(lighting: string)
    sethiddenproperty(game.Lighting, "Technology", lighting:find("Voxel") and "Voxel" or lighting:find("Shadow Map") and "ShadowMap" or "Future")
    if not UserInputService.TouchEnabled then
        local str = lighting:lower()
        if str:find("voxel") then
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceTechnologyVoxel", true)
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceFutureIsBrightPhase2", false)
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceFutureIsBrightPhase3", false)
        elseif str:find("shadow map") then
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceTechnologyVoxel", false)
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceFutureIsBrightPhase2", true)
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceFutureIsBrightPhase3", false)
        elseif str:find("future") then
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceTechnologyVoxel", false)
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceFutureIsBrightPhase2", false)
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceFutureIsBrightPhase3", true)
        else
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceTechnologyVoxel", false)
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceFutureIsBrightPhase2", false)
            Cleostrap.ToggleFFlag("DFFlagDebugRenderForceFutureIsBrightPhase3", false)
        end
    end
end

local PreferredLightingTechnology: dropdown = EngineSettings:AddDropdown({
    Name = "Preferred lighting technology",
    Description = "Chosen one will be force enabled in all games.",
    Options = {"Chosen by game", "Voxel (Phase 1)", "Shadow Map (Phase 2)", "Future (Phase 3)"},
    Default = Cleostrap.Config.LightingTechnology,
    Callback = function(light: string)
        Cleostrap.UpdateConfig("LightingTechnology", light)
        pcall(changeLighting, light)
    end
})

local textureQual = tonumber(Cleostrap.GetFFlag("DFIntTextureQualityOverride")) or 3
local function changeTextureQuality(level: string)
    local str = level:lower()
    if str:find("automatic") then
        Cleostrap.ToggleFFlag("DFFlagTextureQualityOverrideEnabled", false)
        Cleostrap.ToggleFFlag("DFIntTextureQualityOverride", textureQual)
        Cleostrap.ToggleFFlag("FIntDebugTextureManagerSkipMips", 0)
    elseif str:find("lowest") then
        Cleostrap.ToggleFFlag("DFFlagTextureQualityOverrideEnabled", true)
        Cleostrap.ToggleFFlag("DFIntTextureQualityOverride", 0)
        Cleostrap.ToggleFFlag("FIntDebugTextureManagerSkipMips", 2)
    elseif str:find("highest") then
        Cleostrap.ToggleFFlag("DFFlagTextureQualityOverrideEnabled", true)
        Cleostrap.ToggleFFlag("DFIntTextureQualityOverride", 3)
        Cleostrap.ToggleFFlag("FIntDebugTextureManagerSkipMips", 0)
    elseif str:find("high") then
        Cleostrap.ToggleFFlag("DFFlagTextureQualityOverrideEnabled", true)
        Cleostrap.ToggleFFlag("DFIntTextureQualityOverride", 2)
        Cleostrap.ToggleFFlag("FIntDebugTextureManagerSkipMips", 0)
    elseif str:find("medium") then
        Cleostrap.ToggleFFlag("DFFlagTextureQualityOverrideEnabled", true)
        Cleostrap.ToggleFFlag("DFIntTextureQualityOverride", 1)
        Cleostrap.ToggleFFlag("FIntDebugTextureManagerSkipMips", 0)
    elseif str:find("low") then
        Cleostrap.ToggleFFlag("DFFlagTextureQualityOverrideEnabled", true)
        Cleostrap.ToggleFFlag("DFIntTextureQualityOverride", 0)
        Cleostrap.ToggleFFlag("FIntDebugTextureManagerSkipMips", 0)
    end
end

local TextureQuality: dropdown = EngineSettings:AddDropdown({
    Name = "Texture quality",
    Description = "",
    Options = {"Automatic", "Lowest (Requires rejoin)", "Low", "Medium", "High", "Highest"},
    Default = Cleostrap.Config.TextureQuality,
    Callback = function(level)
        Cleostrap.UpdateConfig("TextureQuality", level)
        pcall(changeTextureQuality, level)
    end
})

EngineSettings:AddSection({"Extras", "sparkles"})

local DisableWind: toggle = EngineSettings:AddToggle({
    Name = "Disable wind",
    Description = "Removes global wind rendering and simulation.",
    Default = Cleostrap.Config.DisableWind,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisableWind", callback)
        Cleostrap.ToggleFFlag("FFlagGlobalWindRendering", not callback)
        Cleostrap.ToggleFFlag("FFlagGlobalWindActivated", not callback)
    end
})

local RemoveGrass: toggle = EngineSettings:AddToggle({
    Name = "Remove grass",
    Description = "Eliminates terrain grass for cleaner visuals and a small performance gain.",
    Default = Cleostrap.Config.RemoveGrass,
    Callback = function(callback)
        Cleostrap.UpdateConfig("RemoveGrass", callback)
        Cleostrap.ToggleFFlag("FIntFRMMinGrassDistance",     callback and 0 or 125)
        Cleostrap.ToggleFFlag("FIntFRMMaxGrassDistance",     callback and 0 or 2000)
        Cleostrap.ToggleFFlag("FIntRenderGrassDetailStrands", callback and 0 or 32)
        Cleostrap.ToggleFFlag("FIntRenderGrassHeightScaler", callback and 0 or 1)
    end
})

local InfiniteZoom: toggle = EngineSettings:AddToggle({
    Name = "Infinite zoom",
    Description = "Removes the camera max zoom limit.",
    Default = Cleostrap.Config.InfiniteZoom,
    Callback = function(callback)
        Cleostrap.UpdateConfig("InfiniteZoom", callback)
        Cleostrap.ToggleFFlag("FIntCameraMaxZoomDistance", callback and 9999 or 400)
    end
})

local DisableDynamicHeads: toggle = EngineSettings:AddToggle({
    Name = "Disable dynamic heads",
    Description = "Disables animated facial expressions on avatars.",
    Default = Cleostrap.Config.DisableDynamicHeads,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisableDynamicHeads", callback)
        Cleostrap.ToggleFFlag("DFFlagEnableDynamicHeadByDefault", not callback)
    end
})

local DisableBlur: toggle = EngineSettings:AddToggle({
    Name = "Remove disconnect blur",
    Description = "Removes the blur overlay on the disconnect and loading screens.",
    Default = Cleostrap.Config.DisableBlur,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisableBlur", callback)
        Cleostrap.ToggleFFlag("FIntRobloxGuiBlurIntensity", callback and 0 or 24)
    end
})

local DisableBubbleChat: toggle = EngineSettings:AddToggle({
    Name = "Disable bubble chat",
    Description = "Hides chat bubbles above player heads.",
    Default = Cleostrap.Config.DisableBubbleChat,
    Callback = function(callback)
        Cleostrap.UpdateConfig("DisableBubbleChat", callback)
        Cleostrap.ToggleFFlag("FFlagEnableBubbleChatFromChatService", not callback)
    end
})

local NoInternetDisconnect: toggle = EngineSettings:AddToggle({
    Name = "No internet disconnect",
    Description = "Hides the disconnection message when internet drops. You will still be kicked.",
    Default = Cleostrap.Config.NoInternetDisconnect,
    Callback = function(callback)
        Cleostrap.UpdateConfig("NoInternetDisconnect", callback)
        Cleostrap.ToggleFFlag("DFFlagDebugDisableTimeoutDisconnect", callback)
    end
})

Cleostrap.canUpdate = true
do
	local button
	local grad
	local CoreGuiService = cloneref(game:GetService("CoreGui"))
	local localPlayer = cloneref(game:GetService("Players")).LocalPlayer

	local function makeButtonInFrame(parentFrame)
		local frame = Instance.new("Frame", parentFrame)
		frame.Size = UDim2.new(0, 44, 0, 44)
		frame.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
		frame.BackgroundTransparency = 0.08
		Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)

		button = Instance.new("TextButton", frame)
		button.Size = UDim2.new(1, 0, 1, 0)
		button.BackgroundTransparency = 1
		button.Text = ""
		button.BorderSizePixel = 0

		local toggleImage = Instance.new("ImageLabel", button)
		toggleImage.Size = UDim2.new(0, 22, 0, 22)
		toggleImage.Position = UDim2.new(0.5, -11, 0.5, -11)
		toggleImage.BackgroundTransparency = 1
		toggleImage.Image = getcustomasset("Cleostrap/icon.png")
		toggleImage.ImageColor3 = Color3.new(1, 1, 1)

		grad = Instance.new("UIGradient", toggleImage)
		grad.Rotation = 60
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(219, 89, 171)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(61, 56, 192))
		})
		grad.Enabled = CoreGuiService["Cleostrap Library"].Enabled

		button.MouseButton1Click:Connect(function()
			CoreGuiService["Cleostrap Library"].Enabled = not grad.Enabled
			grad.Enabled = not grad.Enabled
		end)
	end

	-- Check if game uses TopbarPlus (PlayerGui.TopbarStandard exists)
	local hasTopbarPlus = localPlayer:WaitForChild("PlayerGui", 5) and
		localPlayer.PlayerGui:FindFirstChild("TopbarStandard") ~= nil

	local ok = pcall(function()
		if hasTopbarPlus then
			-- TopbarPlus detected: inject into its Left holder so we sit
			-- alongside existing TopbarPlus icons without overlapping.
			local holder = localPlayer.PlayerGui.TopbarStandard.Holders.Left
			makeButtonInFrame(holder)
		else
			-- No TopbarPlus: build our own minimal topbar container
			-- inside CoreGui.TopBarApp.TopBarApp (double-nested, confirmed structure).
			local topBarApp = GetTopBar()
			if not topBarApp then error("TopBarApp not found") end

			local frame1 = Instance.new("Frame", topBarApp)
			frame1.Size = UDim2.new(1, 0, 0, 48)
			frame1.Position = UDim2.new(0, 0, 0, 10)
			frame1.BackgroundTransparency = 1
			frame1.Active = false
			frame1.Name = "CleostrapTopbarHolder"

			local frame2 = Instance.new("Frame", frame1)
			frame2.Size = UDim2.new(0, 56, 0, 44)
			frame2.Position = UDim2.new(1, -60, 0, 2)
			frame2.BackgroundTransparency = 1
			frame2.Active = false

			local uiListLayout = Instance.new("UIListLayout", frame2)
			uiListLayout.Padding = UDim.new(0, 12)
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

			makeButtonInFrame(frame2)
		end
	end)

	if ok and button then
		Cleostrap.Visible = function(callback)
			button.Visible = callback
			CoreGuiService["Cleostrap Library"].Enabled = callback
		end
	else
		Cleostrap.error("Couldn't add the topbar icon. Use the keybind or menu to toggle the GUI.")
		Cleostrap.Visible = function(callback)
			CoreGuiService["Cleostrap Library"].Enabled = callback
		end
	end
end
end
return Cleostrap
