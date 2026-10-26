-- Wait until the game is fully loaded and you are in Space Sailors
if not game:IsLoaded() then game.Loaded:Wait() end
while game.GameId ~= 1722988797 do
    task.wait(1)
end

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

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

-- === ANTI-DEATH / REJOIN HANDLER ===
local function SetupCharacter(char)
    local humanoid = char:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.Died:Connect(function()
            task.wait(0.5)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
        end)
    end
end

if plr.Character then
    SetupCharacter(plr.Character)
end
plr.CharacterAdded:Connect(SetupCharacter)

-- === RUN WORKER SCRIPT TASK (WITH AUTO-LOAD & FAST-FORWARD) ===
local runningTask = nil

local function InitWorker()
    if runningTask then
        task.cancel(runningTask)
        runningTask = nil
    end
    
    if MainData.AutoFarm then
        runningTask = task.spawn(function()
            -- Load your custom GitHub script
            task.spawn(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/hirdeyveer97-oss/space-sailors-script/refs/heads/main/space%20sailors%20script"))()
            end)
            
            -- Fast-forward trigger for Place ID 5534753074
            if game.PlaceId == 5534753074 then
                local playerGui = plr:WaitForChild("PlayerGui")
                while MainData.AutoFarm do
                    pcall(function()
                        local fastForwardBtn = playerGui:FindFirstChild("FastForwardButton", true) 
                            or playerGui:FindFirstChild("FastForward", true)
                        
                        if fastForwardBtn and fastForwardBtn:IsA("GuiButton") then
                            for _, connection in pairs(getconnections(fastForwardBtn.MouseButton1Click)) do
                                connection:Fire()
                            end
                            for _, connection in pairs(getconnections(fastForwardBtn.Activated)) do
                                connection:Fire()
                            end
                        end
                    end)
                    task.wait(2)
                end
            end
        end)
    end
end

-- === LIGHTWEIGHT DRAGGABLE UI ===
local targetParent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")
if targetParent:FindFirstChild("SpaceSailorsLightweightUI") then
    targetParent.SpaceSailorsLightweightUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpaceSailorsLightweightUI"
ScreenGui.Parent = targetParent
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 75)
MainFrame.Position = UDim2.new(0.02, 0, 0.8, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 45, 55)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -16, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 2)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Auto Farm Bot"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 35)
ToggleButton.BackgroundColor3 = MainData.AutoFarm and Color3.fromRGB(40, 180, 99) or Color3.fromRGB(50, 50, 60)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = MainData.AutoFarm and "Status: ON" or "Status: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainData.AutoFarm = not MainData.AutoFarm
    SaveData()
    
    if MainData.AutoFarm then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 99)
        ToggleButton.Text = "Status: ON"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        ToggleButton.Text = "Status: OFF"
    end
    
    InitWorker()
end)

-- Auto-load worker script on startup if saved as ON
InitWorker()
