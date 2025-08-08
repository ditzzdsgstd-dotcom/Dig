local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
   Name = "YoxanXHub | DIG Edition",
   LoadingTitle = "YoxanXHub V1.10 BETA",
   LoadingSubtitle = "https://discord.gg/edsBT9Vy",
   Icon = 108632720139222, -- Ganti jika ingin icon lain
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "YoxanXHub",
      FileName = "DIG"
   },
   Discord = {
      Enabled = true,
      Invite = "edsBT9Vy",
      RememberJoins = true
   },
   KeySystem = false
})

game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(4148, -669, 2551)
   end,
})

local MeteorButton = TeleportTab:CreateButton({
   Name = "Teleport to Meteor",
   Callback = function()
        local meteor = workspace:FindFirstChild("Active") and workspace.Active:FindFirstChild("ActiveMeteor")
        if meteor and meteor:IsA("Model") and meteor.PrimaryPart then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = meteor.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to Meteor.",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Meteor not found.",
                Duration = 3,
                Image = 108632720139222
            })
        end
   end,
})

local MerchantButton = TeleportTab:CreateButton({
   Name = "Teleport to Traveling Merchant",
   Callback = function()
        local merchant = workspace.World.NPCs:FindFirstChild("Merchant Cart")
        if merchant and merchant:FindFirstChild("Traveling Merchant") and merchant["Traveling Merchant"].PrimaryPart then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = merchant["Traveling Merchant"].PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to Traveling Merchant.",
                Duration = 3,
                Image = 108632720139222
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Traveling Merchant not found.",
                Duration = 3,
                Image = 108632720139222
            })
        end
   end,
})

-- Spawn Teleports
local TeleportFolder = workspace:WaitForChild("Spawns"):WaitForChild("TeleportSpawns")
local teleportNames = {}
local teleportCoords = {}

for _, part in ipairs(TeleportFolder:GetChildren()) do
    if part:IsA("BasePart") then
        table.insert(teleportNames, part.Name)
        teleportCoords[part.Name] = part.Position
    end
end

local SpawnDropdown = TeleportTab:CreateDropdown({
   Name = "Teleport Spawns",
   Options = teleportNames,
   CurrentOption = {"Select Spawn"},
   MultipleOptions = false,
   Flag = "SpawnTP",
   Callback = function(Option)
        local selected = Option[1]
        local pos = teleportCoords[selected]
        if pos then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = CFrame.new(pos)
        end
   end,
})

-- Purchasable Teleports
local itemNames = {}
local itemPositions = {}

for _, model in ipairs(purchaseablesFolder:GetChildren()) do
    if model:IsA("Model") and model.PrimaryPart then
        local prompt = model:FindFirstChild("PurchasePrompt")
        if prompt and prompt:IsA("ProximityPrompt") then
            local objectText = prompt.ObjectText
            if objectText and objectText ~= "" then
                table.insert(itemNames, objectText)
                itemPositions[objectText] = model.PrimaryPart.Position
            end
        end
    end
end

local PurchasableDropdown = TeleportTab:CreateDropdown({
   Name = "Teleport to Purchasable",
   Options = itemNames,
   CurrentOption = {"Select Item"},
   MultipleOptions = false,
   Flag = "PurchasableTP",
   Callback = function(Option)
        local selected = Option[1]
        local pos = itemPositions[selected]
        if pos then
            local char = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = CFrame.new(pos)
        end
   end,
})

-- Boss Teleports
local bossNames = {
    "Dire Wolf",
    "Fuzzball",
    "Basilisk",
    "King Crab",
    "Molten Monstrosity",
    "Candlelight Phantom",
    "Giant Spider"
}

local BossDropdown = TeleportTab:CreateDropdown({
   Name = "Teleport to Boss",
   Options = bossNames,
   CurrentOption = {"Select Boss"},
   MultipleOptions = false,
   Flag = "BossTP",
   Callback = function(Option)
        local selected = Option[1]
        local ambience = workspace.World.Zones._Ambience
        for _, obj in pairs(ambience:GetChildren()) do
            if obj.Name:sub(1, #selected) == selected then
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = obj.CFrame + Vector3.new(0, 0, 0)
                end
                break
            end
        end
   end,
})

local BossHitToggle = TeleportTab:CreateToggle({
   Name = "Boss Hit",
   CurrentValue = false,
   Flag = "BossHit",
   Callback = function(Value)
        runningBossHit = Value
        if Value then
            task.spawn(function()
                while runningBossHit do
                    local args = {
                        true
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Dig_Boss_OnHit"):FireServer(unpack(args))
                    task.wait(0)
                end
            end)
        end
   end,
})

-- NPC Teleports
local npcsFolder = workspace:WaitForChild("World"):WaitForChild("NPCs")
local npcNames = {}
local npcPositions = {}

for _, npc in ipairs(npcsFolder:GetChildren()) do
    if npc:IsA("Model") and npc.PrimaryPart then
        table.insert(npcNames, npc.Name)
        npcPositions[npc.Name] = npc.PrimaryPart.Position
    end
end

local NPCDropdown = TeleportTab:CreateDropdown({
   Name = "Teleport to NPC",
   Options = npcNames,
   CurrentOption = {"Select NPC"},
   MultipleOptions = false,
   Flag = "NPCTP",
   Callback = function(Option)
        local selected = Option[1]
        local pos = npcPositions[selected]
        if pos then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
        end
   end,
})

-- Movement Tab
local MovementSection = MovementTab:CreateSection("Movement")

local WalkspeedSlider = MovementTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Walkspeed",
   Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
   end,
})

local JumpPowerSlider = MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 200},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
        end
   end,
})

local GravitySlider = MovementTab:CreateSlider({
   Name = "Gravity",
   Range = {0, 999},
   Increment = 1,
   Suffix = "Gravity",
   CurrentValue = workspace.Gravity,
   Flag = "Gravity",
   Callback = function(Value)
        workspace.Gravity = Value
   end,
})

local FOVSlider = MovementTab:CreateSlider({
   Name = "FOV",
   Range = {20, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = Camera.FieldOfView,
   Flag = "FOV",
   Callback = function(Value)
        Camera.FieldOfView = Value
   end,
})

local InfJumpToggle = MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
        infJump = Value
   end,
})

UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local NoclipToggle = MovementTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
        noclip = Value
   end,
})

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local FlySpeedSlider = MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 999},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
        flySpeed = Value
   end,
})

local FlyToggle = MovementTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
        fly = Value
   end,
})

RunService.RenderStepped:Connect(function()
    if fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local direction = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then direction += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then direction -= Vector3.new(0, 1, 0) end

        hrp.Velocity = direction * flySpeed
    end
end)

local ResetButton = MovementTab:CreateButton({
   Name = "Reset Player",
   Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            h.WalkSpeed = 16
            h.JumpPower = 50
            workspace.Gravity = defaultGravity
            Camera.FieldOfView = defaultFOV
        end
   end,
})

-- Player Teleport
local PlayerSection = MovementTab:CreateSection("Player Teleport")

local function getPlayers()
    local t = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(t, p.Name) end
    end
    return t
end

local PlayerDropdown = MovementTab:CreateDropdown({
   Name = "Teleport to Player",
   Options = getPlayers(),
   CurrentOption = {"Select Player"},
   MultipleOptions = false,
   Flag = "PlayerTP",
   Callback = function(Option)
        local v = Option[1]
        local target = Players:FindFirstChild(v)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            char:WaitForChild("HumanoidRootPart").CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to " .. v,
                Duration = 3,
                Image = 108632720139222
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Player not found.",
                Duration = 3,
                Image = 108632720139222
            })
        end
   end,
})

local RefreshPlayersButton = MovementTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function()
        PlayerDropdown:Refresh(getPlayers())
        Rayfield:Notify({
            Title = "Player List",
            Content = "Player list has been updated.",
            Duration = 2,
            Image = 108632720139222
        })
   end,
})

Rayfield:Notify({
    Title = "YoxanXHub V1.10 BETA",
    Content = "loaded successfully!",
    Duration = 5,
    Image = 108632720139222
})
