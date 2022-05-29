-- To do: make it to where the aimbot only aims when the zomnbie is visually in front of the player

local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

local GUI = Mercury:Create{
    Name = "Project Lazarus",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/0xd-n/Project-Lazarus"
}


--Data

local localPlayer = game:GetService("Players").LocalPlayer
local Backpack = localPlayer.Backpack
local mouse = localPlayer:GetMouse()
local camera = game:GetService("Workspace").CurrentCamera

local RunService = game:GetService("RunService")

local zombies = game:GetService("Workspace"):FindFirstChild("Baddies")

local enemies = {}


--end of Data



-- utility functions

local function subtractVectors(vectorA, vectorB)

    return Vector3.new(vectorA.X - vectorB.X, vectorA.Y - vectorB.Y, vectorA.Z - vectorB.Z)

end

local function getVectorMagnitude(vector)
    return math.sqrt((math.pow(vector.X, 2) + math.pow(vector.Y, 2) + math.pow(vector.Z, 2)))
end

local function getVectorDistance(vectorA, vectorB)

    return getVectorMagnitude(subtractVectors(vectorA, vectorB))
end

local function getNearestZombie(enemiesArr)
    
    local closestZombie = enemiesArr[1]
    
    local myCharacter = localPlayer.Character

    for index, value in pairs(enemiesArr) do

        local me_to_closestZombie_distance = getVectorDistance(myCharacter.Head.Position, closestZombie.Head.Position)
        local me_to_randomZombie_distance = getVectorDistance(myCharacter.Head.Position, value.Head.Position)

        if me_to_randomZombie_distance < me_to_closestZombie_distance then
            closestZombie = value
        end
        
    end
    
    return closestZombie

end


zombies.ChildRemoved:Connect(function(zombie)

    local i = 0
    
    for index, value in pairs(enemies) do
        
        if value == zombie then
            i = index
        end
    end

    if i ~= -1 then
        table.remove(enemies, i)
    else
        print("The object was not found")
    end
  

end)

zombies.ChildAdded:Connect(function(zombie)

    if zombie then
        table.insert(enemies, zombie)
    end

end)

local UserInputService = game:GetService("UserInputService")

-- end of utility functions



local dictionary = {["unlimited ammo"] = false,
                    ["no bullet spread"] = false,
                    ["no recoil"] = false,
                    ["triggerbot"] = false,
                    ["aimbot"] = false,
                    ["visibility check"] = false}

local aimbotToggle = false

-- start of weapon Menu
local weaponMenu = GUI:Tab{
	Name = "Weapon Menu",
	Icon = "rbxassetid://8569322835"
}

weaponMenu:Toggle{
	Name = "Unlimited ammo",
	StartingState = false,
	Description = "Unlimited ammo for all weapons",
	Callback = function(state) 
        
        if state then
            dictionary["unlimited ammo"] = true
        else
            dictionary["unlimited ammo"] = false
        end
    end
}

weaponMenu:Toggle{
	Name = "No Bullet Spread",
	StartingState = false,
	Description = "Bullets don't spread for all weapons",
	Callback = function(state) 
        
        if state then
            dictionary["no bullet spread"] = true
        else
            dictionary["no bullet spread"] = false
        end
    end
}

weaponMenu:Toggle{
	Name = "No Recoil",
	StartingState = false,
	Description = "No recoil for all weapons",
	Callback = function(state) 
        
        if state then
            dictionary["no recoil"] = true
        else
            dictionary["no recoil"] = false
        end
    end
}


-- end of weapon weapon menu 

-- start of aimbot menu

local aimbotMenu = GUI:Tab{
    Name = "Aimbot Menu",
    Icon = "rbxassetid://8569322835"
}

aimbotMenu:Toggle{
	Name = "Triggerbot",
	StartingState = false,
	Description = "Automatically shoots at zombies in crosshair",
	Callback = function(state) 

        if(state) then
            dictionary["triggerbot"] = true
        else
            dictionary["triggerbot"] = false
        end
    
    end
}

aimbotMenu:Toggle{
	Name = "Aimbot [Q]",
	StartingState = false,
	Description = "Automatically aims at zombie's heads",
	Callback = function(state) 

        if(state) then
            dictionary["aimbot"] = true
        else
            dictionary["aimbot"] = false
        end
    
    end
}

aimbotMenu:Toggle{
	Name = "Visibility Check",
	StartingState = false,
	Description = "Aimbot checks if zombie is on screen",
	Callback = function(state) 

        if(state) then
            dictionary["visibility check"] = true
        else
            dictionary["visibility check"] = false
        end
    
    end
}

UserInputService.InputBegan:Connect(function(input, gameProcessed)

    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyPressed = input.KeyCode

        if(keyPressed == Enum.KeyCode.Q) then
            aimbotToggle = not aimbotToggle
        end
    end

end)

RunService.RenderStepped:Connect(function() 

    if(dictionary["unlimited ammo"]) then

        local Weapon1 = Backpack:FindFirstChild("Weapon1")
        local Weapon2 = Backpack:FindFirstChild("Weapon2")
        local Weapon3 = Backpack:FindFirstChild("Weapon3")

        if(Weapon1) then


            local Weapon1_script = require(Weapon1)
            
            Weapon1_script.Ammo = Weapon1_script.MagSize
        
        end

        if(Weapon2) then

            local Weapon2_script = require(Weapon2)

            Weapon2_script.Ammo = Weapon2_script.MagSize

        end

        if(Weapon3) then

            local Weapon3_script = require(Weapon3)

            Weapon3_script.Ammo = Weapon3_script.MagSize

        end
        
    end

    if(dictionary["no bullet spread"]) then

        if(Backpack) then
    
            local Weapon1 = Backpack:FindFirstChild("Weapon1")
            local Weapon2 = Backpack:FindFirstChild("Weapon2")
            local Weapon3 = Backpack:FindFirstChild("Weapon3")
    
            if(Weapon1) then
    
    
                local Weapon1_script = require(Weapon1)

                Weapon1_script.Spread["Min"] = 0
                Weapon1_script.Spread["Max"] = 0

            end

            if(Weapon2) then
    
    
                local Weapon2_script = require(Weapon2)

                Weapon2_script.Spread["Min"] = 0
                Weapon2_script.Spread["Max"] = 0

            end

            if(Weapon3) then
    
    
                local Weapon3_script = require(Weapon3)

                Weapon3_script.Spread["Min"] = 0
                Weapon3_script.Spread["Max"] = 0

            end

        end
    end

    if(dictionary["no recoil"]) then

        if(Backpack) then
    
            local Weapon1 = Backpack:FindFirstChild("Weapon1")
            local Weapon2 = Backpack:FindFirstChild("Weapon2")
            local Weapon3 = Backpack:FindFirstChild("Weapon3")
    
            if(Weapon1) then
    
    
                local Weapon1_script = require(Weapon1)

                Weapon1_script.ViewKick.Pitch["Min"] = 0
                Weapon1_script.ViewKick.Pitch["Max"] = 0

                Weapon1_script.ViewKick.Yaw["Min"] = 0
                Weapon1_script.ViewKick.Yaw["Max"] = 0
            
            end

            if(Weapon2) then
    
    
                local Weapon2_script = require(Weapon2)

                Weapon2_script.ViewKick.Pitch["Min"] = 0
                Weapon2_script.ViewKick.Pitch["Max"] = 0
                
                Weapon2_script.ViewKick.Yaw["Min"] = 0
                Weapon2_script.ViewKick.Yaw["Max"] = 0
    
            end

            if(Weapon3) then
    
    
                local Weapon3_script = require(Weapon3)

                Weapon3_script.ViewKick.Pitch["Min"] = 0
                Weapon3_script.ViewKick.Pitch["Max"] = 0
                
                Weapon3_script.ViewKick.Yaw["Min"] = 0
                Weapon3_script.ViewKick.Yaw["Max"] = 0
    
            end

        end
    end

    if(dictionary["triggerbot"]) then
        
        if mouse.Target.Parent.Name == "Zombie" or mouse.Target.Parent.Name == "Climb" then
            mouse1press()
        else
            mouse1release()
        end

    end

    if(dictionary["aimbot"]) then

        if(aimbotToggle) then

            if dictionary["visibility check"] then

                --local _, onscreen = camera:WorldToScreenPoint(getNearestZombie(enemies).Head.Position)

                --if(onscreen) then

                local castPoints = {getNearestZombie(enemies).Head.Position}

                
                local parts = game:GetService("Workspace").CurrentCamera:GetPartsObscuringTarget(castPoints, {})
            
                if(#parts == 1) then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, getNearestZombie(enemies).Head.Position)
                end

                --end

            else
                camera.CFrame = CFrame.new(camera.CFrame.Position, getNearestZombie(enemies).Head.Position)
            end
            
        end
    end


end)


-- reference stuff



--end of aimbot menu

--[[
local weaponMenu = GUI:Tab{
	Name = "Project Lazarus Menu",
	Icon = "rbxassetid://8569322835"
}

weaponMenu:Button{
	Name = "Button",
	Description = 'A test',
	Callback = function() 
        
        print("I was clicked")
    end
}


Tab:Toggle{
	Name = "Toggle",
	StartingState = false,
	Description = nil,
	Callback = function(state) end
}

Tab:Textbox{
	Name = "Textbox",
	Callback = function(text) end
}

local MyDropdown = Tab:Dropdown{
	Name = "Dropdown",
	StartingText = "Select...",
	Description = nil,
	Items = {
		{"Hello", 1}, 		-- {name, value}
		12,			-- or just value, which is also automatically taken as name
		{"Test", "bump the thread pls"}
	},
	Callback = function(item) 
        
        print(item)
    end
}

MyDropdown:AddItems({
	{"NewItem", 12},		-- {name, value}
	400				-- or just value, which is also automatically taken as name
})

MyDropdown:RemoveItems({
	"NewItem", "Hello"		-- just the names to get removed (upper/lower case ignored)
})

--MyDropdown:Clear()

Tab:Slider{
	Name = "Slider",
	Default = 50,
	Min = 0,
	Max = 100,
	Callback = function() end
}

Tab:Keybind{
	Name = "Keybind",
	Keybind = nil,
	Description = nil
}
]]