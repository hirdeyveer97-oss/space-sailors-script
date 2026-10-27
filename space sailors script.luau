local success, errorMessage = pcall(function()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
       Name = "Space Sailors Hub",
       LoadingTitle = "Space Sailors Master",
       LoadingSubtitle = "by hirdeyveer97",
       ConfigurationSaving = { Enabled = false },
       KeySystem = false
    })

    -- === TABS ===
    local TpTab = Window:CreateTab("🌀 TP")
    local MoonTab = Window:CreateTab("🌕 Moon")
    local MarsTab = Window:CreateTab("🔴 Mars")
    local UtilityTab = Window:CreateTab("⚙️ Utility")

    -- ==========================================
    --                  TP TAB
    -- ==========================================
    TpTab:CreateButton({
       Name = "TP to LGSS",
       Callback = function()
          local TeleportService = game:GetService("TeleportService")
          Rayfield:Notify({Title = "Teleporting", Content = "Connecting to LGSS server...", Duration = 3})
          TeleportService:Teleport(5515926734, game:GetService("Players").LocalPlayer)
       end,
    })

    TpTab:CreateButton({
       Name = "TP to Earth",
       Callback = function()
          local TeleportService = game:GetService("TeleportService")
          Rayfield:Notify({Title = "Teleporting", Content = "Connecting to Earth server...", Duration = 3})
          TeleportService:Teleport(5000143962, game:GetService("Players").LocalPlayer)
       end,
    })

    -- ==========================================
    --                 MOON TAB
    -- ==========================================
    MoonTab:CreateSection("Lander Hacks")

    MoonTab:CreateButton({
       Name = "Launch Aresonius (Auto)",
       Callback = function()
          local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ToMoonRemote", true)
          if remote then remote:FireServer("Aresonius") end
       end,
    })

    MoonTab:CreateButton({
       Name = "Launch Aresonius (Manual)",
       Callback = function()
          local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ToMoonRemote", true)
          if remote then remote:FireServer("Aresonius ManualMode") end
       end,
    })

    MoonTab:CreateButton({
       Name = "Launch LLAMA",
       Callback = function()
          local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ToMoonRemote", true)
          if remote then remote:FireServer("LLAMA") end
       end,
    })

    MoonTab:CreateSection("Teleports")

    MoonTab:CreateButton({
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

    MoonTab:CreateButton({
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

    MoonTab:CreateSection("Other")

    MoonTab:CreateButton({
       Name = "Remove Lunar Rocks",
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

    -- ==========================================
    --                 MARS TAB
    -- ==========================================
    MarsTab:CreateSection("Lander Hacks")

    MarsTab:CreateButton({
       Name = "Launch Aresonius (Auto)",
       Callback = function()
          local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ToMarsRemote", true)
          if remote then remote:FireServer("Aresonius") end
       end,
    })

    MarsTab:CreateButton({
       Name = "Launch Aresonius (Manual)",
       Callback = function()
          local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ToMarsRemote", true)
          if remote then remote:FireServer("Aresonius ManualMode") end
       end,
    })

    MarsTab:CreateSection("Teleports")

    MarsTab:CreateButton({
       Name = "TP to My Lander",
       Callback = function()
          local player = game:GetService("Players").LocalPlayer
          local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
          
          if hrp then
             local foundLander = nil
             for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name == "MarsLander" then
                   local ownerVal = obj:FindFirstChild("CurrentPlayer") or obj:FindFirstChild("LanderOwner")
                   if ownerVal and ownerVal.Value and tostring(ownerVal.Value) == player.Name then
                      foundLander = obj
                      break
                   end
                end
             end
             
             if foundLander then
                local midUpper = foundLander:FindFirstChild("MidUpperStage")
                local targetPart = (midUpper and midUpper:FindFirstChildWhichIsA("BasePart", true)) or foundLander:FindFirstChildWhichIsA("BasePart", true)
                
                if targetPart then
                   hrp.Anchored = true
                   hrp.CFrame = targetPart.CFrame + Vector3.new(0, 10, 0)
                   Rayfield:Notify({Title = "Loading Terrain...", Content = "Anchoring for 1.5s to let map load.", Duration = 2})
                   task.wait(1.5)
                   hrp.Anchored = false
                   Rayfield:Notify({Title = "Teleported", Content = "Moved to Mars Lander.", Duration = 2})
                else
                   Rayfield:Notify({Title = "Error", Content = "MarsLander has no physical parts.", Duration = 3})
                end
             else
                Rayfield:Notify({Title = "Not Found", Content = "Could not find a MarsLander owned by you.", Duration = 3})
             end
          end
       end,
    })

    MarsTab:CreateButton({
       Name = "TP to Gem Pyramid",
       Callback = function()
          local player = game:GetService("Players").LocalPlayer
          local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
          
          if hrp then
             hrp.Anchored = true
             hrp.CFrame = CFrame.new(-54282.675, 1124.963, 9580.470)
             Rayfield:Notify({Title = "Loading Terrain...", Content = "Anchoring for 1.5s to let map load.", Duration = 2})
             task.wait(1.5)
             hrp.Anchored = false
             Rayfield:Notify({Title = "Teleported", Content = "Arrived at Gem Pyramid.", Duration = 2})
          end
       end,
    })

    MarsTab:CreateSection("Other")

    MarsTab:CreateButton({
       Name = "Remove Martian Rocks",
       Callback = function()
          local spawnedRocks = workspace:FindFirstChild("SpawnedRocks")
          if spawnedRocks then
             spawnedRocks:Destroy()
             Rayfield:Notify({Title = "Terrain Cleared", Content = "Martian rocks removed!", Duration = 3})
          else
             Rayfield:Notify({Title = "Not Found", Content = "SpawnedRocks not found in Workspace.", Duration = 3})
          end
       end,
    })

    -- ==========================================
    --               UTILITY TAB
    -- ==========================================
    UtilityTab:CreateButton({
       Name = "Unload UI",
       Callback = function()
          Rayfield:Destroy()
       end,
    })

    -- Auto-select the first tab
    task.spawn(function()
       task.wait(0.1)
       pcall(function()
          if TpTab.SelectTab then
             TpTab:SelectTab()
          elseif TpTab.TabButton then
             for _, c in pairs(getconnections(TpTab.TabButton.MouseButton1Click)) do
                c:Fire()
             end
          end
       end)
    end)

end)

if not success then
    print("Rayfield Master Script Error: " .. tostring(errorMessage))
end
