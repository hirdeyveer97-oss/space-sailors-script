local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Space Sailors Hub",
   LoadingTitle = "Space Sailors Hub",
   LoadingSubtitle = "Loaded",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- === TABS ===
local MainTab = Window:CreateTab("🚀 Main")
local UtilityTab = Window:CreateTab("🛠️ Utility")

-- === LANDER HACKS ===
MainTab:CreateSection("Lander Hacks")

local manualDest = "Moon"
MainTab:CreateDropdown({
   Name = "Planet =",
   Options = {"Moon", "Mars"},
   CurrentOption = {"Moon"},
   MultipleOptions = false,
   Flag = "ManualDest", 
   Callback = function(Option) manualDest = Option[1] end,
})

MainTab:CreateButton({
   Name = "Launch Aresonius (Manual)",
   Callback = function()
      local remoteName = manualDest == "Moon" and "ToMoonRemote" or "ToMarsRemote"
      local remote = game:GetService("ReplicatedStorage"):FindFirstChild(remoteName, true)
      if remote then remote:FireServer("Aresonius ManualMode") end
   end,
})

local autoDest = "Moon"
MainTab:CreateDropdown({
   Name = "Planet =",
   Options = {"Moon", "Mars"},
   CurrentOption = {"Moon"},
   MultipleOptions = false,
   Flag = "AutoDest", 
   Callback = function(Option) autoDest = Option[1] end,
})

MainTab:CreateButton({
   Name = "Launch Aresonius (Auto)",
   Callback = function()
      local remoteName = autoDest == "Moon" and "ToMoonRemote" or "ToMarsRemote"
      local remote = game:GetService("ReplicatedStorage"):FindFirstChild(remoteName, true)
      if remote then remote:FireServer("Aresonius") end
   end,
})

MainTab:CreateButton({
   Name = "Launch Llama (Auto)",
   Callback = function()
      local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ToMoonRemote", true)
      if remote then remote:FireServer("LLAMA") end
   end,
})

-- === TERRAIN REMOVE ===
MainTab:CreateSection("Terrain Remove")

MainTab:CreateButton({
   Name = "Clear Lunar Rocks",
   Callback = function()
      local clearedCount = 0
      for _, item in pairs(workspace:GetDescendants()) do
         if item.Name == "SpawnedRocks" or item.Name == "LunarRock" then
            item:Destroy()
            clearedCount = clearedCount + 1
         end
      end
      Rayfield:Notify({Title = "Terrain Cleared", Content = "Deleted " .. clearedCount .. " rock containers.", Duration = 4})
   end,
})

-- === TELEPORTS ===
MainTab:CreateSection("Teleports")

MainTab:CreateButton({
   Name = "TP to My Lander",
   Callback = function()
      local player = game:GetService("Players").LocalPlayer
      local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
      
      if hrp then
         local foundLander = nil
         for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
               local landerOwner = obj:FindFirstChild("LanderOwner")
               if landerOwner and landerOwner:IsA("StringValue") and landerOwner.Value == player.Name then
                  foundLander = obj
                  break
               end
            end
         end
         
         if foundLander then
            local ascentStage = foundLander:FindFirstChild("LanderAscentStage")
            local targetPart = (ascentStage and ascentStage:FindFirstChildWhichIsA("BasePart", true)) or foundLander:FindFirstChildWhichIsA("BasePart", true)
            
            if targetPart then
               hrp.Anchored = true
               hrp.CFrame = targetPart.CFrame + Vector3.new(0, 15, 0)
               Rayfield:Notify({Title = "Loading Terrain...", Content = "Anchoring for 1.5s to let map load.", Duration = 2})
               task.wait(1.5)
               hrp.Anchored = false
               Rayfield:Notify({Title = "Teleported", Content = "Moved to " .. foundLander.Name, Duration = 2})
            else
               Rayfield:Notify({Title = "Error", Content = "Vehicle has no physical parts.", Duration = 3})
            end
         else
            Rayfield:Notify({Title = "Not Found", Content = "Could not find any vehicle owned by you.", Duration = 3})
         end
      end
   end,
})

MainTab:CreateButton({
   Name = "TP to Moon Dorm",
   Callback = function()
      local player = game:GetService("Players").LocalPlayer
      local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
      
      if hrp then
         local moonDorm = nil
         for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
               local nameLower = string.lower(obj.Name)
               if string.find(nameLower, "dorm") or string.find(nameLower, "moon dorm") or string.find(nameLower, "living quarters") then
                  local targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                  if targetPart then
                     moonDorm = targetPart
                     break
                  end
               end
            end
         end
         
         if moonDorm then
            hrp.Anchored = true
            hrp.CFrame = moonDorm.CFrame + Vector3.new(0, 15, 0)
            Rayfield:Notify({Title = "Loading Terrain...", Content = "Streaming Moon Dorm...", Duration = 2})
            task.wait(1.5)
            hrp.Anchored = false
            Rayfield:Notify({Title = "Teleported", Content = "Arrived at Moon Dorm.", Duration = 2})
         else
            Rayfield:Notify({Title = "Not Found", Content = "Moon Dorm not loaded on this server.", Duration = 3})
         end
      end
   end,
})

MainTab:CreateButton({
   Name = "TP to Cargo Llama",
   Callback = function()
      local player = game:GetService("Players").LocalPlayer
      local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
      
      if hrp then
         local cargoLlama = nil
         for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
               local nameLower = string.lower(obj.Name)
               if string.find(nameLower, "llama") and (obj:FindFirstChild("Cargo", true) or obj:FindFirstChild("Box", true) or string.find(nameLower, "cargo")) then
                  local targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                  if targetPart then
                     cargoLlama = targetPart
                     break
                  end
               end
            end
         end
         
         if not cargoLlama then
            for _, obj in pairs(workspace:GetDescendants()) do
               if obj:IsA("Model") and string.find(string.lower(obj.Name), "llama") then
                  local targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                  if targetPart then
                     cargoLlama = targetPart
                     break
                  end
               end
            end
         end
         
         if cargoLlama then
            hrp.Anchored = true
            hrp.CFrame = cargoLlama.CFrame + Vector3.new(0, 15, 0)
            Rayfield:Notify({Title = "Loading Terrain...", Content = "Streaming Cargo Llama...", Duration = 2})
            task.wait(1.5)
            hrp.Anchored = false
            Rayfield:Notify({Title = "Teleported", Content = "Arrived at Cargo Llama.", Duration = 2})
         else
            Rayfield:Notify({Title = "Not Found", Content = "Cargo Llama not found on this server.", Duration = 3})
         end
      end
   end,
})

MainTab:CreateButton({
   Name = "TP to LGSS",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      Rayfield:Notify({Title = "Teleporting", Content = "Connecting to LGSS server...", Duration = 3})
      TeleportService:Teleport(5515926734, game:GetService("Players").LocalPlayer)
   end,
})

MainTab:CreateButton({
   Name = "TP to Earth",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      Rayfield:Notify({Title = "Teleporting", Content = "Connecting to Earth server...", Duration = 3})
      TeleportService:Teleport(5000143962, game:GetService("Players").LocalPlayer)
   end,
})

-- === UTILITY ===
UtilityTab:CreateSection("External Scripts")

UtilityTab:CreateButton({
   Name = "Open Auto-Farm Panel",
   Callback = function()
      if not game:IsLoaded() then game.Loaded:Wait() end
      if game.GameId ~= 1722988797 then
         error("This is not Space Sailors. Code won't run.")
         return
      end

      local HttpService = game:GetService("HttpService")
      local Players = game:GetService("Players")
      local targetParent = (gethui and gethui()) or Players.LocalPlayer:WaitForChild("PlayerGui")

      local FileName = "Save.JSON"
      local DefaultData = {
         AutoFarm = false,
         CameFromPlanet = false
      }

      local function LoadData()
         if not isfile or not readfile then return DefaultData end
         if not isfile(FileName) then
            writefile(FileName, HttpService:JSONEncode(DefaultData))
         end
         local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(FileName))
         end)
         if success and type(result) == "table" then
            return result
         else
            writefile(FileName, HttpService:JSONEncode(DefaultData))
            return DefaultData
         end
      end

      local MainData = LoadData()

      local function SaveData()
         if writefile then
            writefile(FileName, HttpService:JSONEncode(MainData))
         end
      end

      local runningTask = nil

      local function Init()
         if runningTask then
            task.cancel(runningTask)
            runningTask = nil
         end
         
         if MainData.AutoFarm then
            runningTask = task.spawn(function()
               loadstring(game:HttpGet("https://raw.githubusercontent.com/UnknownMoons/SpaceSailors-Auto-Farm/refs/heads/main/AutoFarm-v1.0.0.lua"))()
            end)
         end
      end

      if targetParent:FindFirstChild("SpaceSailorsCleanUI") then
         targetParent.SpaceSailorsCleanUI:Destroy()
      end

      local ScreenGui = Instance.new("ScreenGui")
      ScreenGui.Name = "SpaceSailorsCleanUI"
      ScreenGui.Parent = targetParent
      ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

      local MainFrame = Instance.new("Frame")
      MainFrame.Name = "MainFrame"
      MainFrame.Size = UDim2.new(0, 300, 0, 160)
      MainFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
      MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
      MainFrame.BorderSizePixel = 0
      MainFrame.Active = true       
      MainFrame.Draggable = true    
      MainFrame.Parent = ScreenGui

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 10)
      UICorner.Parent = MainFrame

      local UIStroke = Instance.new("UIStroke")
      UIStroke.Color = Color3.fromRGB(45, 45, 55)
      UIStroke.Thickness = 1.5
      UIStroke.Parent = MainFrame

      local TitleLabel = Instance.new("TextLabel")
      TitleLabel.Size = UDim2.new(1, -50, 0, 40)
      TitleLabel.Position = UDim2.new(0, 16, 0, 0)
      TitleLabel.BackgroundTransparency = 1
      TitleLabel.Font = Enum.Font.GothamBold
      TitleLabel.Text = "SPACE SAILORS"
      TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
      TitleLabel.TextSize = 14
      TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
      TitleLabel.Parent = MainFrame

      local CloseButton = Instance.new("TextButton")
      CloseButton.Size = UDim2.new(0, 26, 0, 26)
      CloseButton.Position = UDim2.new(1, -34, 0, 10)
      CloseButton.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
      CloseButton.Font = Enum.Font.GothamBold
      CloseButton.Text = "×"
      CloseButton.TextColor3 = Color3.fromRGB(180, 180, 190)
      CloseButton.TextSize = 16
      CloseButton.Parent = MainFrame

      local CloseCorner = Instance.new("UICorner")
      CloseCorner.CornerRadius = UDim.new(0, 6)
      CloseCorner.Parent = CloseButton

      CloseButton.MouseButton1Click:Connect(function()
         ScreenGui:Destroy()
      end)

      local ContentBox = Instance.new("Frame")
      ContentBox.Size = UDim2.new(1, -32, 0, 88)
      ContentBox.Position = UDim2.new(0, 16, 0, 50)
      ContentBox.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
      ContentBox.BorderSizePixel = 0
      ContentBox.Parent = MainFrame

      local ContentCorner = Instance.new("UICorner")
      ContentCorner.CornerRadius = UDim.new(0, 8)
      ContentCorner.Parent = ContentBox

      local ToggleLabel = Instance.new("TextLabel")
      ToggleLabel.Size = UDim2.new(1, -90, 1, 0)
      ToggleLabel.Position = UDim2.new(0, 14, 0, 0)
      ToggleLabel.BackgroundTransparency = 1
      ToggleLabel.Font = Enum.Font.GothamSemibold
      ToggleLabel.Text = "Auto Farm"
      ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
      ToggleLabel.TextSize = 13
      ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
      ToggleLabel.Parent = ContentBox

      local ToggleButton = Instance.new("TextButton")
      ToggleButton.Size = UDim2.new(0, 70, 0, 32)
      ToggleButton.Position = UDim2.new(1, -82, 0.5, -16)
      ToggleButton.BackgroundColor3 = MainData.AutoFarm and Color3.fromRGB(40, 180, 99) or Color3.fromRGB(50, 50, 60)
      ToggleButton.Font = Enum.Font.GothamBold
      ToggleButton.Text = MainData.AutoFarm and "ON" or "OFF"
      ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
      ToggleButton.TextSize = 12
      ToggleButton.Parent = ContentBox

      local ToggleCorner = Instance.new("UICorner")
      ToggleCorner.CornerRadius = UDim.new(0, 6)
      ToggleCorner.Parent = ToggleButton

      ToggleButton.MouseButton1Click:Connect(function()
         MainData.AutoFarm = not MainData.AutoFarm
         SaveData()
         
         if MainData.AutoFarm then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 99)
            ToggleButton.Text = "ON"
         else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            ToggleButton.Text = "OFF"
         end
         
         Init()
      end)

      Init()
   end,
})

UtilityTab:CreateButton({
   Name = "Unload UI",
   Callback = function()
      local Players = game:GetService("Players")
      local targetParent = (gethui and gethui()) or Players.LocalPlayer:WaitForChild("PlayerGui")
      if targetParent:FindFirstChild("SpaceSailorsCleanUI") then
         targetParent.SpaceSailorsCleanUI:Destroy()
      end
      
      Rayfield:Destroy()
   end,
})

task.spawn(function()
   task.wait(0.1)
   pcall(function()
      if MainTab.SelectTab then
         MainTab:SelectTab()
      elseif MainTab.TabButton then
         for _, c in pairs(getconnections(MainTab.TabButton.MouseButton1Click)) do
            c:Fire()
         end
      end
   end)
end)
