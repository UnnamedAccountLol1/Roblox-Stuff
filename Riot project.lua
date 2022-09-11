local start = tick()
local cl = game:GetService('Players').LocalPlayer
local executor = identifyexecutor and identifyexecutor() or 'Unknown'
--
local function fail(r)
    return cl:Kick(r)
end    
--
local usedCache = shared.__urlcache and next(shared.__urlcache) ~= nil
shared.__urlcache = shared.__urlcache or {}
--
local function urlLoad(url)
    local success, result

    if shared.__urlcache[url] then
        success, result = true, shared.__urlcache[url]
    else
        success, result = pcall(game.HttpGet, game, url)
    end

    if (not success) then
        return fail(string.format('Failed to GET url %q for reason: %q', url, tostring(result)))
    end

    local fn, err = loadstring(result)
    if (type(fn) ~= 'function') then
        return fail(string.format('Failed to loadstring url %q for reason: %q', url, tostring(err)))
    end

    local results = { pcall(fn) }
    if (not results[1]) then
        return fail(string.format('Failed to initialize url %q for reason: %q', url, tostring(results[2])))
    end
    
    shared.__urlcache[url] = result
    return unpack(results, 2)
end
-- essential
if game:GetService("CoreGui"):FindFirstChild("Storage") then game:GetService("CoreGui").Storage:Destroy() else end
if game:GetService("CoreGui"):FindFirstChild("StarterGui") then game:GetService("CoreGui"):Destroy() else end
local EffectsFolder = Instance.new("Folder", game:GetService("CoreGui"))
EffectsFolder.Name = "Storage"
-- getgenv's
getgenv()._HExtender = false
getgenv()._AutoStomp = false
getgenv()._IgnoreFriends = false
getgenv()._HDowned = false
getgenv()._AntiDown = false
getgenv()._Transparency = 0
-- functions
function MadnessHighlight(toggle)   
    if toggle then     
        local light = Instance.new("PointLight", cl.Character.Torso)
        light.Name = "_OKMADNESSLIGHT"
        light.Range = 20
        light.Brightness = 1.5
        light.Color = Color3.fromRGB(255,0,0)
        light.Shadows = true
        local h = Instance.new("Highlight", EffectsFolder);
        h.Name = "MadnessHighlight"
        h.Adornee = cl.Character
        h.FillColor = Color3.fromRGB(0,0,0)
        h.OutlineColor = Color3.fromRGB(255,0,0)
        h.FillTransparency = 1
        h.OutlineTransparency = 1
        game:GetService("TweenService"):Create(h,TweenInfo.new(.35),{FillTransparency = 0}):Play(); game:GetService("TweenService"):Create(h,TweenInfo.new(.35),{OutlineTransparency = 0}):Play();
    elseif not toggle then 
        --ts:Create(EffectsFolder:FindFirstChild("MadnessHighlight"),ti(.35),{FillTransparency = 1}):Play(); ts:Create(EffectsFolder:FindFirstChild("MadnessHighlight"),ti(.35),{OutlineTransparency = 1}):Play();
        task.wait(.35)
        for _,v in pairs(EffectsFolder:GetChildren()) do
            if v:IsA("Highlight") and v.Name == "MadnessHighlight" then v:Destroy() else end
        end   
        for _,v in pairs(cl.Character.Torso:GetChildren()) do
            if v:IsA("PointLight") and v.Name == "_OKMADNESSLIGHT" then v:Destroy() else end
        end 
    end    
end   
--
function RageAura(toggle)
    if toggle then
        local light = Instance.new("PointLight", cl.Character.Torso)
        light.Name = "_OKRAGELIGHT"
        light.Range = 9.5
        light.Brightness = 1.5
        light.Color = Color3.fromRGB(255,0,0)
        light.Shadows = true
        local P1 = Instance.new("ParticleEmitter", cl.Character["Right Arm"]); 
        local s = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0))
        local m = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0))
        local e = ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        P1.Color = ColorSequence.new({s,m,e})
        P1.Lifetime = NumberRange.new(1,2)
        P1.EmissionDirection = "Top"
        P1.LightEmission = 0.4
        P1.LockedToPart = true
        P1.Rate = 50
        P1.RotSpeed = NumberRange.new(-200,200) 
        P1.Rotation = NumberRange.new(-360,360)
        P1.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6); 
            NumberSequenceKeypoint.new(0.5, 1); 
            NumberSequenceKeypoint.new(1, 0); 
        }) 
        P1.Speed = NumberRange.new(0.5, 0.5)
        P1.SpreadAngle = Vector2.new(100,100)
        P1.Texture = "rbxassetid://243664672"
        P1.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7); 
            NumberSequenceKeypoint.new(0.5, 0.80931); 
            NumberSequenceKeypoint.new(1, 1);
        })
        P1.ZOffset = 2
        P1.Name = "Poison"
        --
        P1:Clone().Parent = cl.Character["Left Arm"]
    else
        for _,v in pairs(cl.Character["Left Arm"]:GetChildren()) do
            if v:IsA("ParticleEmitter") then v:Destroy() end
        end  
        for _,v in pairs(cl.Character["Right Arm"]:GetChildren()) do
            if v:IsA("ParticleEmitter") then v:Destroy() end
        end 
        for _,v in pairs(cl.Character.Torso:GetChildren()) do
            if v:IsA("PointLight") and v.Name == "_OKRAGELIGHT" then v:Destroy() end
        end    
    end    
end    
--
function PlaySound(id,vol,ps,de)
        local s = Instance.new("Sound", EffectsFolder)
        s.SoundId = "rbxassetid://"..id
        s.Volume = vol
        s.PlaybackSpeed = ps
        if id == 9735274746 then
            s.Name = "MadnessTheme"
            s.Looped = true
        end    
        if not de then
            s:Play()
        else
            task.spawn(function()
            s:Play()
            s.Ended:Wait()
            s:Destroy()
        end)
    end       
end
--
function PlayAnim(id)
    task.spawn(function()
        local nid = tonumber(id)
        if nid == nil then return end
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://"..nid
        local r = cl.Character:WaitForChild("Humanoid").Animator:LoadAnimation(a)
        r:Play()
    end)
end   
--
function dc(p)
    for i, connection in pairs(getconnections(p)) do
        connection:Disable()
    end  
end
--
function Attributes(typ, toggle, cutscene)
    if typ == "Rage" then
        if not cutscene then
            cl:SetAttribute("RageMode", toggle)
            for _,v in pairs(cl.Character["Left Arm"]:GetChildren()) do
                if v:IsA("ParticleEmitter") then v:Destroy() else end
            end  
            for _,v in pairs(cl.Character["Right Arm"]:GetChildren()) do
                if v:IsA("ParticleEmitter") then v:Destroy() else end
            end  
        else
            PlayAnim(9781948028)
            task.wait(0.15)
            cl:SetAttribute("RageMode", toggle)
            task.wait(1.15)
            PlaySound(257001341,1.5,1,true); RageAura(true)
        end
    elseif typ == "Madness" then
        if not cutscene then
            cl:SetAttribute("MadnessMode", toggle)
            task.wait(.45) 
            for _,v in pairs(EffectsFolder:GetChildren()) do
                if v:IsA("Highlight") and v.Name == "MadnessHighlight" then v:Destroy() else end
            end 
        else
            PlaySound(9735274746,1.5,1,false)
            cl:SetAttribute("MadnessMode", toggle);
        end  
    elseif typ == "InfStamina" then
        cl:SetAttribute("InfStamina", toggle)
    elseif typ == "InfDash" then
        cl:SetAttribute("InfiniteDash", toggle)
    elseif typ == "NoCooldown" then
        cl:SetAttribute("WeaponSpam", toggle)
    elseif typ == "FunnySpeed" then
        if toggle then
            cl:SetAttribute("FunnySpeed", 15)
        else
            cl:SetAttribute("FunnySpeed", false)
        end    
    end    
end    
--
function killAnti()
    spawn(function()
		for _,v in pairs(cl.Character:GetDescendants()) do
		    if v:IsA("LocalScript") and v.Name == "clip" or v.Name == "StateEnabled" then
               v.Disabled = true; 
			   task.wait();
               v.Parent = nil
			   v:Destroy();
		    end;
	    end;
	end);
end    
--
function checkDistBetweenPart(part, precise)
    local dist = cl:DistanceFromCharacter(part.Position)
    if dist ~= 0 then
        if not precise then
            return dist
        else
            return math.floor(dist)
        end    
    else
        return nil
    end    
end 
--
function CreateHitVXF(char)
    spawn(function()
        if EffectsFolder:FindFirstChild("HIT_"..char.Name) then EffectsFolder:FindFirstChild("HIT_"..char.Name):Destroy() end
        local h = Instance.new("Highlight", EffectsFolder)
        h.FillTransparency = 0.45
        h.OutlineColor = Color3.fromRGB(255, 0, 0)
        h.Adornee = char
        h.Name = "HIT_"..char.Name
        task.wait(.35)
        h:Destroy()
    end) 
end 
--
--
function Hit(Path)
    task.spawn(function()
        local args = {
            [1] = "Z",
            [2] = 1,
            [3] = "the/???"
        }
        Path:FireServer(unpack(args))
        task.wait()
    end)
end    
--
local IgnoreFriends = false
function CharHit(Path)
    task.spawn(function()
        if not IgnoreFriends then
            for _,v in pairs(game:GetService("Players"):GetPlayers()) do
                if v.Name ~= cl.Name and v.Character:FindFirstChildWhichIsA("Humanoid").Health > 0 and not v.Character:GetAttribute("Downed") and v.Character.PrimaryPart and checkDistBetweenPart(v.Character.PrimaryPart) <= 9 then
                    CreateHitVXF(v.Character)
                    local args = {
                        [1] = "T",
                        [2] = v.Character:FindFirstChild("Head"),
                        [3] = "lol  "
                    }
                    Path:FireServer(unpack(args))
                    task.wait()
                else
                end    
            end 
        else
            for _,v in pairs(game:GetService("Players"):GetPlayers()) do
                if v.Name ~= cl.Name and v.Character:FindFirstChildWhichIsA("Humanoid").Health > 0 and not v.Character:GetAttribute("Downed") and v.Character.PrimaryPart and checkDistBetweenPart(v.Character.PrimaryPart) <= 9 then
                    if not cl:IsFriendsWith(v.UserId) then
                        CreateHitVXF(v.Character)
                        local args = {
                            [1] = "T",
                            [2] = v.Character:FindFirstChild("Head"),
                            [3] = "lol  "
                        }
                        Path:FireServer(unpack(args))
                        task.wait()
                    else
                    end    
                else
                end    
            end
        end    
    end)
end    
--
local function CheckCurrentWeapon()
    local v
    if not cl.Character:FindFirstChildWhichIsA("Tool") then
        return nil
    else
        v = cl.Character:FindFirstChildWhichIsA("Tool")
        return tostring(v.Name)
    end    
end  
--
local KillAura = false
--
local AntiDownV = false
function AntiDown()
    while AntiDownV and task.wait(0.35) and cl.Character do
        if not AntiDownV then
            break
        end
        cl.Character:SetAttribute("Downed", false)    
    end    
end    
local GroupHTTPAttempts = 0
--
local function CheckRole(Player) -- returns true if it is a staff
    local grole
    local success, error    
    repeat
        if GroupHTTPAttempts >= 1 then
            ui:Notification{
                Title = "HTTP Error",
                Text = "("..error.."), attempt: "..GroupHTTPAttempts,
                Duration = 15,
                Callback = function() end
            }
            task.wait(.5)
        end    
        success, error = pcall(function()
            Player:GetRoleInGroup(10294339)
        end)
    until success
    if success then
        grole = Player:GetRoleInGroup(10294339)
    end    
    --
    if grole == "Contributor" or grole == "Moderator" or grole == "Admin" or grole == "Developers" or grole == "Music Man" or grole == "Scripter" or grole == "Builder" or grole == "Crimson" or grole == "Dosko" or grole == "Astrix" then
        return true
    else
        return false
    end    
end       
cl.CharacterAdded:Connect(killAnti)
-- ui stuff
local ui = urlLoad('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua')
local ThemeManager = urlLoad('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/ThemeManager.lua')
local SaveManager = urlLoad('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/SaveManager.lua')
-- need this here
local AlreadyKicked = false
function CheckForStaff(leave)
    for _,v in pairs(game:GetService("Players"):GetPlayers()) do
        if CheckRole(v) == true then
            if not leave then
                ui:Notify(v.Name..' is in your server \n Rank:', v:GetRoleInGroup(10294339))
            else
                if not AlreadyKicked then
                cl:Kick([[
                    A staff is in the server or has joined.  
                        Closing the client in 5s]])
                task.wait(5)
                game:shutdown()
                AlreadyKicked = true
                else
                end
            end    
        end    
    end  
end  
CheckForStaff(false)
-- i need this here too
function KA()
    while KillAura and task.wait() do
        if not cl.Character:FindFirstChildWhichIsA("Tool") then 
            ui:Notify('Waiting for weapon...', 3)  
            repeat task.wait(.1) if not KillAura then ui:Notify('Disabling killaura...', 3) return end  until cl.Character:FindFirstChildWhichIsA("Tool") 
            ui:Notify('Found: '..cl.Character:FindFirstChildWhichIsA("Tool").Name, 3)            
        end
        local c = cl.Character:FindFirstChildWhichIsA("Tool")
        if CheckCurrentWeapon() == "Chainsaw" then
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name == "WeaponRemote" then
                    Hit(v)
                    --task.wait(.0001)
                    CharHit(v)
                    task.wait()
                end    
            end
        elseif CheckCurrentWeapon() == "Katana" then
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name == "WeaponRemote" then
                    Hit(v)
                    task.wait(.018)
                    CharHit(v)
                    task.wait()
                end    
            end
        elseif CheckCurrentWeapon() == "Fists" then
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name == "WeaponRemote" then
                    Hit(v)
                    task.wait(.038)
                    CharHit(v)
                    task.wait()
                end    
            end
        elseif CheckCurrentWeapon() == "Sword" then
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name == "WeaponRemote" then
                    Hit(v)
                    task.wait(.058)
                    CharHit(v)
                    task.wait()
                end    
            end
        elseif CheckCurrentWeapon() == "Bat" then
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name == "WeaponRemote" then
                    Hit(v)
                    task.wait(0.1)
                    CharHit(v)
                    task.wait()
                end    
            end
        elseif CheckCurrentWeapon() == "Knife" then
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name == "WeaponRemote" then
                    Hit(v)
                    task.wait(.028)
                    CharHit(v)
                    task.wait()
                end    
            end
        else
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name == "WeaponRemote" then
                    Hit(v)
                    task.wait(0.1)
                    CharHit(v)
                    task.wait()
                end    
            end
        end    
    end    
end     
--
local Window = ui:CreateWindow({
    Title = string.format('swag - version 2.6 | updated: 11/10/22'),
    AutoShow = true,
    Center = true,
    Size = UDim2.fromOffset(550, 627),
})
--
local tabs = {}
local groups = {}
--
tabs.Main = Window:AddTab('Main')
tabs.Extra = Window:AddTab('Extra')
tabs['UI Settings'] = Window:AddTab('UI Settings')
groups.Attributes = tabs.Main:AddLeftGroupbox('Attributes')
groups.Hitbox = tabs.Main:AddLeftGroupbox('Hitbox')
groups.Combat = tabs.Main:AddLeftGroupbox('Combat')
groups.Staff = tabs.Main:AddLeftGroupbox('Staff')
groups.Miscellaneous = tabs.Extra:AddLeftGroupbox('Miscellaneous')
-- group attributes
groups.Attributes:AddToggle('RageToggle',{Text = 'Rage mode', Default = false, ToolTip = 'Enables/Disables rage mode, duration is infinite.'}):AddKeyPicker('Rage mode Keybind', {Default = 'Delete', NoUI = true, SyncToggleState = true})
groups.Attributes:AddToggle('MadnessToggle',{Text = 'Madness mode', Default = false, ToolTip = 'Enables/Disables madness mode, duration is infinite.'}):AddKeyPicker('Madness mode Keybind', {Default = 'End', NoUI = true, SyncToggleState = true})
groups.Attributes:AddToggle('IStam',{Text = 'Infinite stamina', Default = false, ToolTip = 'Self explanatory.'})
groups.Attributes:AddToggle('IDash',{Text = 'Infinite dash', Default = false, ToolTip = 'No cooldown dash.'})
groups.Attributes:AddToggle('NoCD',{Text = 'No cooldown', Default = false, ToolTip = 'It just makes the hits dont have cooldown but they act like normal hits.'})
groups.Attributes:AddToggle('FSpeed',{Text = 'Infinite acceleration', Default = false, ToolTip = 'Makes you run faster over time.'})
--
local AreCutscenesEnabled = false
Toggles.RageToggle:OnChanged(function()
    if Toggles.RageToggle.Value then
        if not AreCutscenesEnabled then
            Attributes("Rage", true, false)
        else
            Attributes("Rage", true, true) 
        end    
    else
        Attributes("Rage", false, false); RageAura(false)
    end    
end)
--
local NightLoop = false
Toggles.MadnessToggle:OnChanged(function()
    NightLoop = Toggles.MadnessToggle.Value 
        if Toggles.MadnessToggle.Value then
            if not AreCutscenesEnabled then
                Attributes("Madness", true, false)
            else
                ui:Notify('Only highlight and music available!', 3)
                Attributes("Madness", true, true); MadnessHighlight(true)
                game:GetService("TweenService"):Create(game:GetService("Lighting"),TweenInfo.new(1),{ClockTime = 3}):Play()
                task.spawn(function()
                    task.wait(1)
                    while NightLoop and task.wait(1) do
                        game:GetService("Lighting").ClockTime = 3
                        if not NightLoop then break end
                    end    
                end)
            end 
        else
            if AreCutscenesEnabled then
                game:GetService("TweenService"):Create(game:GetService("Lighting"),TweenInfo.new(1),{ClockTime = 7}):Play()
                Attributes("Madness", false, false); MadnessHighlight(false); if EffectsFolder:FindFirstChild("MadnessTheme") then EffectsFolder:FindFirstChild("MadnessTheme"):Destroy(); end 
            else
                game:GetService("TweenService"):Create(game:GetService("Lighting"),TweenInfo.new(1),{ClockTime = 7}):Play()
                Attributes("Madness", false, false);
                if EffectsFolder:FindFirstChild("MadnessTheme") then EffectsFolder:FindFirstChild("MadnessTheme"):Destroy(); end 
            end    
        end       
end)
--
Toggles.IStam:OnChanged(function()
    Attributes("InfStamina", Toggles.IStam.Value, false)   
end)
--
Toggles.IDash:OnChanged(function()
    Attributes("InfDash", Toggles.IDash.Value, false)   
end)
--
Toggles.NoCD:OnChanged(function()
    Attributes("NoCooldown", Toggles.NoCD.Value, false)   
end)
--
Toggles.FSpeed:OnChanged(function()
    Attributes("FunnySpeed", Toggles.FSpeed.Value, false)   
end)
-- group hitboxes
groups.Hitbox:AddToggle('HitboxToggle',{Text = 'Toggle hitbox expander', Default = false, ToolTip = 'Enables/Disables hitbox expander.'})
groups.Hitbox:AddSlider('HTransparency', {Text = 'Transparency', Default = 0, Min = 0, Max = 1, Rounding = 2, Compact = false})
groups.Hitbox:AddSlider('HSize', {Text = 'Size', Default = 2, Min = 2, Max = 14, Rounding = 0, Compact = false})
--
local HitboxEnabled = false
Toggles.HitboxToggle:OnChanged(function()
    HitboxEnabled = Toggles.HitboxToggle.Value
    if not HitboxEnabled then
        for i = 1,2 do
            for _,v in pairs(game:GetService("Players"):GetPlayers()) do
                if v.Name ~= cl.Name and v.Character then
                    pcall(function()
                        v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
                    end)
                end    
            end
            task.wait(.1)
        end    
    end    
end)
--
local HitboxTransparency = 0
Options.HTransparency:OnChanged(function()
    HitboxTransparency = Options.HTransparency.Value
end)
--
Options.HSize:OnChanged(function()
    function Extend()
        if not HitboxEnabled then return end
        for _,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= cl.Name and v.Character then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(Options.HSize.Value,Options.HSize.Value,Options.HSize.Value)
                    v.Character.HumanoidRootPart.Transparency = HitboxTransparency
                    v.Character.HumanoidRootPart.CanCollide = false
                    v.Character.Head.CanCollide = false
                    v.Character.Torso.CanCollide = false
                    task.wait()
                end)
            end    
        end    
    end
    spawn(function()
        while HitboxEnabled and task.wait(0.1) do
            if not HitboxEnabled then
                break
            end
            Extend()          
        end
    end)  
end)
-- group combat
groups.Combat:AddToggle('KAToggle',{Text = 'Kill aura', Default = false, ToolTip = 'Attacks automatically anybody, using it against too many peopole will result in a ban.'}):AddKeyPicker('Kill aura Keybind', {Default = 'K', NoUI = true, SyncToggleState = true})
groups.Combat:AddToggle('FriendlyToggle',{Text = 'Dont attack friends', Default = false, ToolTip = 'Kill Aura WILL NOT damage/attack your roblox friends.'})
groups.Combat:AddToggle('AntiDown',{Text = 'Anti down', Default = false, ToolTip = 'If you get knocked out you will still be able to walk around but not attack others.'})
groups.Combat:AddToggle('AutoStomp',{Text = 'Auto stomp', Default = false, ToolTip = 'Auto stomps any nearby downed player.'})
groups.Combat:AddToggle('ResetOnDeath',{Text = 'Reset on death', Default = false, ToolTip = 'Instantly resets when you die'})
--
Toggles.KAToggle:OnChanged(function()
    if Toggles.KAToggle.Value then
        if CheckCurrentWeapon() == nil then 
            ui:Notify('Waiting for player to equip a weapon...', 3) 
            repeat task.wait(.1) until cl.Character:FindFirstChildWhichIsA("Tool") 
            ui:Notify('Starting killaura with: '..cl.Character:FindFirstChildWhichIsA("Tool").Name, 3)  
            KillAura = true
            KA()
            task.wait(0.1)  
            else
            ui:Notify('Optimal CD is setted automatically.', 3)
            KillAura = true
            KA()
            task.wait(0.1)
        end
    else
        KillAura = false
    end        
end)
--
Toggles.FriendlyToggle:OnChanged(function()
    IgnoreFriends = Toggles.FriendlyToggle.Value       
end)
--
Toggles.AntiDown:OnChanged(function()
    AntiDownV = Toggles.AntiDown.Value
    if AntiDownV then
        AntiDown()
    elseif not AntiDownV and cl.PlayerGui:WaitForChild("Profile").Centered.Health.Bar:FindFirstChild("dmglabel") then
        cl.Character:SetAttribute("Downed", true)
    end    
end)
--
local AutoStompV = false
Toggles.AutoStomp:OnChanged(function()
    AutoStompV = Toggles.AutoStomp.Value
    if AutoStompV then
        local args = {[1] = {["KeyCode"] = Enum.KeyCode.X}}
        spawn(function()
            while AutoStompV and task.wait(0.55) do
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes").MainRemote:FireServer(unpack(args))
            end
        end)
    end    
end)
--
local ResetOnDeathV = false
Toggles.ResetOnDeath:OnChanged(function()
    ResetOnDeathV = Toggles.ResetOnDeath.Value
    while ResetOnDeathV and task.wait(0.1) do
        if not ResetOnDeathV then break end
        if cl.Character and cl.Character:GetAttribute("Downed") then
            if cl.Character.Torso:FindFirstChild("Neck") then
                cl.Character.Torso.Neck:Destroy()
            else
                cl.Character.Head:Destroy()
            end    
        end    
    end       
end)
-- group staff
groups.Staff:AddToggle('WSJ',{Text = 'Warn on staff join', Default = false, ToolTip = 'Sends a notification when a staff joins or is in your server'})
groups.Staff:AddToggle('LSJ',{Text = 'Leave on staff join', Default = false, ToolTip = 'Leaves the game when a staff joins or is in your server'})
groups.Staff:AddToggle('AHS',{Text = 'Auto highlight staff', Default = false, ToolTip = 'ESP for staff'})
--
local CanCheckForStaff = false
Toggles.WSJ:OnChanged(function()
    CanCheckForStaff = Toggles.WSJ.Value
    CheckForStaff(false) 
    game:GetService("Players").PlayerAdded:Connect(function()
        if CanCheckForStaff then
            CheckForStaff(false)
        else 
        end    
    end) 
end)
--
local LeaveOnStaffJoin = false
Toggles.LSJ:OnChanged(function()
    LeaveOnStaffJoin = Toggles.LSJ.Value
    if LeaveOnStaffJoin then CheckForStaff(true) else end 
    game:GetService("Players").PlayerAdded:Connect(function()
        if LeaveOnStaffJoin then
            CheckForStaff(true)
        else 
        end    
    end)
end)
--
local HighlightStaff = false
Toggles.AHS:OnChanged(function()
    HighlightStaff = Toggles.AHS.Value
    if HighlightStaff then
        while HighlightStaff and task.wait(0.5) do
            for _,v in pairs(game:GetService("Players"):GetPlayers()) do
                if CheckRole(v) then -- checkStaff
                    if v.Character and not EffectsFolder:FindFirstChild("STAFF_"..v.Name) then
                        local h = Instance.new("Highlight", EffectsFolder)
                        h.Adornee = v.Character
                        h.Name = "STAFF_"..v.Name
                        h.FillColor = Color3.fromRGB(191, 0, 255)
                        h.OutlineColor = Color3.fromRGB(191, 0, 255)    
                    end    
                end    
            end    
        end    
    else
    for _,v in pairs(EffectsFolder:GetDescendants()) do
        if v:IsA("Highlight") and v.Name:match("STAFF_") then
            v:Destroy()
        end    
    end    
end  
end)
-- group miscellaneous
groups.Miscellaneous:AddToggle('Cutscenes',{Text = 'Cutscenes / Special effects (CS)', Default = false, ToolTip = 'Adds epic effects to rage and madnes'})
groups.Miscellaneous:AddToggle('NoclipToggle',{Text = 'Noclip', Default = false, ToolTip = 'Allows you to go trough solid objects'})
groups.Miscellaneous:AddToggle('HighlightPiles',{Text = 'Highlight piles', Default = false, ToolTip = 'ESP for piles'})
groups.Miscellaneous:AddToggle('HighlightMBox',{Text = 'Highlight Mystery Box', Default = false, ToolTip = 'ESP for Mystery Box'})
groups.Miscellaneous:AddToggle('HighlightFriends',{Text = 'Auto highlight friends', Default = false, ToolTip = 'ESP for roblox friends'})
groups.Miscellaneous:AddButton('Rejoin', function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, cl) end)
groups.Miscellaneous:AddButton('Force reset', function() if cl.Character:FindFirstChildWhichIsA("ForceField") then cl.Character:FindFirstChildWhichIsA("ForceField"):Destroy() else end  cl.Character:FindFirstChildWhichIsA("Humanoid"):TakeDamage(-math.huge); cl.Character:FindFirstChildWhichIsA("Humanoid").Health = -math.huge; end)
--
local Clip = true
local Noclipping = nil
Toggles.NoclipToggle:OnChanged(function()
    if Toggles.NoclipToggle.Value then
        Clip = false
        Noclipping = game:GetService("RunService").Stepped:Connect(function()
            if Clip == false and cl.Character ~= nil then
                for _, child in pairs(cl.Character:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide == true then
                        child.CanCollide = false
                    end
                end
            end
        end)
    else
        if Noclipping then
            Noclipping:Disconnect()
        end    
        Clip = true
    end    
end)
--
Toggles.HighlightPiles:OnChanged(function()
    if Toggles.HighlightPiles.Value then
        for _,v in pairs(workspace["New map"].Piles:GetChildren()) do
            if v:IsA("Model") and not v:FindFirstChild("AnimationController") then
                local h = Instance.new("Highlight", EffectsFolder)
                h.FillTransparency = 1
                h.Adornee = v
                h.Name = "PileHighlight"
            end    
        end
    else
        for _,v in pairs(EffectsFolder:GetChildren()) do
            if v:IsA("Highlight") and v.Name == "PileHighlight" then
                v:Destroy()
            end
        end
    end    
end)
--
Toggles.HighlightMBox:OnChanged(function()
    if Toggles.HighlightMBox.Value then
        if workspace["Mystery"]:FindFirstChild("MysteryBox") then
            local h = Instance.new("Highlight", EffectsFolder)
            h.Adornee = workspace["Mystery"].MysteryBox
            h.FillTransparency = 0.75
            h.OutlineTransparency = 0
            h.OutlineColor = Color3.fromRGB(196, 68, 68)
            h.FillColor = Color3.fromRGB(0,0,0)
            h.Name = "BoxHighlight"
        end
    else
        for _,v in pairs(EffectsFolder:GetChildren()) do
            if v:IsA("Highlight") and v.Name == "BoxHighlight" then
                v:Destroy()
            end
        end
    end    
end)
--
local HighlightFriendsV = false
Toggles.HighlightFriends:OnChanged(function()
    HighlightFriendsV = Toggles.HighlightFriends.Value 
    if HighlightFriendsV then
            while HighlightFriendsV and task.wait(0.25) do
                for _,v in pairs(game:GetService("Players"):GetPlayers()) do
                    local c = v.Character
                    local id = v.UserId
                    if cl:IsFriendsWith(id) and c and not EffectsFolder:FindFirstChild("FRIEND_"..v.Name) then  
                        local h = Instance.new("Highlight", EffectsFolder)
                        h.Adornee = v.Character
                        h.Name = "FRIEND_"..v.Name
                        h.FillColor = Color3.fromRGB(140, 255, 163)
                        h.OutlineColor = Color3.fromRGB(140, 255, 163)        
                    end    
                end    
            end    
        else
        for _,v in pairs(EffectsFolder:GetDescendants()) do
            if v:IsA("Highlight") and v.Name:match("FRIEND_") then
                v:Destroy()
            end    
        end    
    end    
end)
--
Toggles.Cutscenes:OnChanged(function()
    AreCutscenesEnabled = Toggles.Cutscenes.Value
end)
--
groups.Miscellaneous:AddButton('Unload script', function() 
    cl:SetAttribute("RageMode", false)
    cl:SetAttribute("MadnessMode", false)
    cl:SetAttribute("InfStamina", false)
    cl:SetAttribute("InfiniteDash", false)
    cl:SetAttribute("WeaponSpam", false)
    cl:SetAttribute("FunnySpeed", false)
    if game:GetService("CoreGui"):FindFirstChild("Storage") then game:GetService("CoreGui").Storage:Destroy() else end       
    KillAura = false
    Clip = true
    if Noclipping then Noclipping:Disconnect() end
    AreCutscenesEnabled = false
    LeaveOnStaffJoin = false
    CanCheckForStaff = false
    AutoStompV = false
    HitboxEnabled = false
    NightLoop = false
    game:GetService("Lighting").ClockTime = 7
    for i = 1,2 do
        for _,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= cl.Name and v.Character then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
                end)
            end    
        end
        task.wait(.1)
    end
    ui:Unload()
end)
--
ui:Notify(string.format('Loaded script in %.4f second(s)!', tick() - start), 3)
ui:Notify('Press right shift to close or open the ui, can be changed in ui settings.', 3)
-- auto saving
local MenuGroup = tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind'}) 
ui.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu
SaveManager:SetLibrary(ui)
ThemeManager:SetLibrary(ui)
ThemeManager:SetFolder('swag')
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'}) 
SaveManager:SetFolder('swag/riot')
SaveManager:BuildConfigSection(tabs['UI Settings']) 
ThemeManager:ApplyToTab(tabs['UI Settings'])