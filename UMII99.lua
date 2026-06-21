-- [[ GARDEN 2 - VORTEX ULTIMATE HUB v15 + MINIMIZE TOGGLE BUTTON FEATURE ]] --
local LP = game:GetService("Players").LocalPlayer
local WK = game:GetService("Workspace")
local LT = game:GetService("Lighting")
local PG = LP:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local TS = game:GetService("TweenService")

-- States Panel Utama & Minimize System
local UI_Visible = true
local P, H = false, false
local _G_Farm, _G_SellType, _G_SellAll, _G_CollType, _G_CollAll, _G_PlantType = false, false, false, false, false, false
local _G_BuyType, _G_BuyIn, _G_BuyAll, _G_ShopPanelAct = false, false, false, false
local _G_MailPanelAct, _G_AutoMail = false, false
local _G_NotifPanelAct, _G_PetNotif, _G_ClaimNotif = false, false, false
local _G_WebPanelAct, _G_AutoWebhook = false, false
local _G_EventPanelAct, _G_AutoClaimEvent = false, false
local _G_AutoSendMailNotif = false

-- STATES KHUSUS TAB BUY PET
local _G_BuyPetPanelAct, _G_AutoBuyPet = false, false
local _G_SubPetBuyNotifAct, _G_AutoBuyPetNotif = false, false
local SelectedRarities = {}
local SelectedWeights = {}
local SelectedMutations = {}

local WebhookURL = "https://discord.com/api/webhooks/..."
local AllowedPing = "example_user"

local CD_Plant, CD_Sell, CD_Coll = 0.1, 0.1, 0.1
local SelectedFruit, SelectedSeed = "Apple", "Apple Seed"

-- DATA COMPILATION FROM GROW A GARDEN 2 (GaG2)
local GAG2_Rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Divine"}
local GAG2_Weights = {"Lightweight", "Normal", "Heavy", "Massive", "Titanic"}
local GAG2_Mutations = {"None", "Shiny", "Golden", "Rainbow", "Corrupted", "Negative", "Glitch"}

if PG:FindFirstChild("VortexUltimateHub") then PG["VortexUltimateHub"]:Destroy() end

-- ==========================================================
-- INTERFACE CORE & SYSTEM MINIMIZE
-- ==========================================================
local G = Instance.new("ScreenGui", PG) G.Name = "VortexUltimateHub" G.ResetOnSpawn = false
local F = Instance.new("Frame", G) F.Size = UDim2.new(0, 390, 0, 280) F.Position = UDim2.new(0.3, 0, 0.25, 0) F.BackgroundColor3 = Color3.fromRGB(12, 12, 16) F.BackgroundTransparency = 0.05 F.Active = true F.Draggable = true
Instance.new("UICorner", F).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", F).Color = Color3.fromRGB(150, 0, 255)

-- TOMBOL MINIMIZE / TUTUP-BUKA MELAYANG (FLOATING TOGGLE)
local MinBtn = Instance.new("TextButton", G)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(0.95, 0, 0.05, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MinBtn.Text = "V"
MinBtn.TextColor3 = Color3.fromRGB(150, 0, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MinBtn).Color = Color3.fromRGB(150, 0, 255)
MinBtn.Active = true
MinBtn.Draggable = true -- Bisa digeser sesuka hati di layar

MinBtn.MouseButton1Click:Connect(function()
    UI_Visible = not UI_Visible
    F.Visible = UI_Visible
    MinBtn.Text = UI_Visible and "V" or "[+]"
    MinBtn.TextColor3 = UI_Visible and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(0, 255, 150)
end)

local Sidebar = Instance.new("Frame", F) Sidebar.Size = UDim2.new(0, 105, 1, 0) Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local HubTitle = Instance.new("TextLabel", Sidebar) HubTitle.Size = UDim2.new(1, 0, 0, 35) HubTitle.BackgroundTransparency = 1 HubTitle.Text = "★ VORTEX HUB v15" HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255) HubTitle.Font = Enum.Font.GothamBold HubTitle.TextSize = 11

local TabContainer = Instance.new("Frame", F) TabContainer.Size = UDim2.new(1, -120, 1, -45) TabContainer.Position = UDim2.new(0, 115, 0, 35) TabContainer.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("ScrollingFrame", TabContainer) p.Size = UDim2.new(1, 0, 1, 0) p.BackgroundTransparency = 1 p.CanvasSize = UDim2.new(0, 0, 0, 750) p.ScrollBarThickness = 3 p.Visible = false
    pages[name] = p return p
end

local P_Graphic = createPage("GRAPHIC")
local P_Farm = createPage("FARM")
local P_Shop = createPage("SHOP")
local P_Mail = createPage("MAIL")
local P_Notif = createPage("NOTIFIKASI")
local P_BuyPet = createPage("BUYPET")
local P_Web = createPage("WEBHOOK")
P_Graphic.Visible = true

local function createTabBtn(name, y, targetPage)
    local tb = Instance.new("TextButton", Sidebar) tb.Size = UDim2.new(1, -12, 0, 20) tb.Position = UDim2.new(0, 6, 0, y) tb.Text = name tb.BackgroundColor3 = Color3.fromRGB(26, 26, 36) tb.TextColor3 = Color3.fromRGB(170, 170, 175) tb.Font = Enum.Font.GothamBold tb.TextSize = 8
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 5)
    tb.MouseButton1Click:Connect(function() for _, v in pairs(pages) do v.Visible = false end targetPage.Visible = true end)
end

createTabBtn("OPTIMIZER", 35, P_Graphic)
createTabBtn("AUTO FARM", 57, P_Farm)
createTabBtn("SHOP MGR", 79, P_Shop)
createTabBtn("MAILBOX", 101, P_Mail)
createTabBtn("NOTIFIKASI", 123, P_Notif)
createTabBtn("BUY PET", 145, P_BuyPet)
createTabBtn("WEBHOOK SET", 167, P_Web)

-- ==========================================================
-- SINKRONISASI WEBHOOK (1 WEB URL CENTRAL)
-- ==========================================================
local function SendDiscordWebhook(title, description, color)
    if WebhookURL == "" or WebhookURL == "https://discord.com/api/webhooks/..." then return end
    local content = AllowedPing ~= "" and "<@"..AllowedPing..">" or ""
    local data = {
        ["content"] = content,
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["footer"] = {["text"] = "Vortex Engine v15 • Minimize System Valid"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    local request = syn and syn.request or http and http.request or route and route.request or request
    if request then
        pcall(function()
            request({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
        end)
    end
end

local function ReportAutoBuyPet(name, rarity, weight, mutation, price)
    if not _G_AutoBuyPetNotif then return end
    local logDescription = string.format("PRICE: %s\nWEIGHT: %s\nMUT: %s\nRARITY: %s\nNAME PET: %s", tostring(price), tostring(weight), tostring(mutation), tostring(rarity), tostring(name))
    SendDiscordWebhook("🎁 [PET AUTO BUY NOTIFI] SNAP SUCCESS!", logDescription, 10181046)
end

-- ==========================================================
-- UI FACTORY COMPONENT
-- ==========================================================
local function createToggle(parent, txt, cb)
    local Box = Instance.new("Frame", parent) Box.Size = UDim2.new(1, -5, 0, 30) Box.BackgroundTransparency = 1
    local Lbl = Instance.new("TextLabel", Box) Lbl.Size = UDim2.new(1, -50, 1, 0) Lbl.BackgroundTransparency = 1 Lbl.Text = txt Lbl.TextColor3 = Color3.fromRGB(190, 190, 195) Lbl.Font = Enum.Font.GothamBold Lbl.TextSize = 8.5 Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local Slot = Instance.new("TextButton", Box) Slot.Size = UDim2.new(0, 36, 0, 16) Slot.Position = UDim2.new(1, -42, 0, 7) Slot.BackgroundColor3 = Color3.fromRGB(32, 32, 42) Slot.Text = ""
    Instance.new("UICorner", Slot).CornerRadius = UDim.new(1, 0)
    local Ball = Instance.new("Frame", Slot) Ball.Size = UDim2.new(0, 10, 0, 10) Ball.Position = UDim2.new(0, 3, 0, 3) Ball.BackgroundColor3 = Color3.fromRGB(140, 140, 145)
    Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)
    Slot.MouseButton1Click:Connect(function()
        local s = cb()
        Ball:TweenPosition(s and UDim2.new(0, 23, 0, 3) or UDim2.new(0, 3, 0, 3), "Out", "Quad", 0.1, true)
        Ball.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(140,140,145)
        Slot.BackgroundColor3 = s and Color3.fromRGB(150,0,255) or Color3.fromRGB(32,32,42)
    end)
    return Box
end

local function createMultiSelectDropdown(parent, label, items, storageTable)
    local Box = Instance.new("Frame", parent) Box.Size = UDim2.new(1, -5, 0, 30) Box.BackgroundTransparency = 1
    local Lbl = Instance.new("TextLabel", Box) Lbl.Size = UDim2.new(0, 100, 1, 0) Lbl.BackgroundTransparency = 1 Lbl.Text = label Lbl.TextColor3 = Color3.fromRGB(190, 190, 195) Lbl.Font = Enum.Font.GothamBold Lbl.TextSize = 8.5 Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local Btn = Instance.new("TextButton", Box) Btn.Size = UDim2.new(0, 95, 0, 20) Btn.Position = UDim2.new(1, -100, 0, 5) Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40) Btn.Text = "Pilih (0 Selected)" Btn.TextColor3 = Color3.fromRGB(200, 0, 255) Btn.Font = Enum.Font.GothamBold Btn.TextSize = 8
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    local curIdx = 1
    Btn.MouseButton1Click:Connect(function()
        local activeItem = items[curIdx]
        if storageTable[activeItem] then storageTable[activeItem] = nil else storageTable[activeItem] = true end
        local total = 0 for _, _ in pairs(storageTable) do total = total + 1 end
        local checkSign = storageTable[activeItem] and " √" or ""
        Btn.Text = activeItem .. checkSign .. " ("..total..")"
        curIdx = curIdx + 1 if curIdx > #items then curIdx = 1 end
    end)
    return Box
end

local function createTextBox(parent, label, default, cb)
    local Box = Instance.new("Frame", parent) Box.Size = UDim2.new(1, -5, 0, 30) Box.BackgroundTransparency = 1
    local Lbl = Instance.new("TextLabel", Box) Lbl.Size = UDim2.new(0, 120, 1, 0) Lbl.BackgroundTransparency = 1 Lbl.Text = label Lbl.TextColor3 = Color3.fromRGB(190, 190, 195) Lbl.Font = Enum.Font.GothamBold Lbl.TextSize = 8.5 Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local Txt = Instance.new("TextBox", Box) Txt.Size = UDim2.new(0, 75, 0, 20) Txt.Position = UDim2.new(1, -80, 0, 5) Txt.BackgroundColor3 = Color3.fromRGB(24, 24, 34) Txt.Text = default Txt.TextColor3 = Color3.new(1,1,1) Txt.Font = Enum.Font.GothamBold Txt.TextSize = 8.5
    Instance.new("UICorner", Txt).CornerRadius = UDim.new(0, 4)
    Txt.FocusLost:Connect(function() cb(Txt.Text) end)
    return Box
end

-- ==========================================================
-- CONTENT TAB: BUY PET (ANTI-BUG OPEN / CLOSE)
-- ==========================================================
local BuyPetLayout = Instance.new("UIListLayout", P_BuyPet)
BuyPetLayout.SortOrder = Enum.SortOrder.LayoutOrder
BuyPetLayout.Padding = UDim.new(0, 4)

local BuyPetPanel = Instance.new("Frame", P_BuyPet) 
BuyPetPanel.Size = UDim2.new(1, 0, 0, 200) 
BuyPetPanel.BackgroundTransparency = 1 
BuyPetPanel.Visible = false

local SubPanelLayout = Instance.new("UIListLayout", BuyPetPanel)
SubPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder
SubPanelLayout.Padding = UDim.new(0, 4)

createToggle(P_BuyPet, "BUKA/TUTUP PANEL BELI PET", function() 
    _G_BuyPetPanelAct = not _G_BuyPetPanelAct 
    BuyPetPanel.Visible = _G_BuyPetPanelAct 
    return _G_BuyPetPanelAct 
end)

createToggle(BuyPetPanel, "AUTO BUY PET ENGINE", function()
    _G_AutoBuyPet = not _G_AutoBuyPet
    if _G_AutoBuyPet then
        task.spawn(function()
            local EggStand = WK:FindFirstChild("EggStand") or WK:FindFirstChild("EggShop") or WK:FindFirstChild("Eggs")
            local TargetPosition = nil
            if EggStand then
                local StandPart = EggStand:IsA("Model") and (EggStand:FindFirstChild("HumanoidRootPart") or EggStand:FindFirstChildOfClass("Part")) or EggStand
                if StandPart then TargetPosition = StandPart.CFrame end
            end
            
            while _G_AutoBuyPet do
                pcall(function()
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        local savedPos = LP.Character.HumanoidRootPart.CFrame
                        
                        if TargetPosition then
                            LP.Character.HumanoidRootPart.CFrame = TargetPosition + Vector3.new(0, 2, 0)
                            task.wait(0.02)
                        end
                        
                        local EggPrice = "500 Coins"
                        local resultPet = game:GetService("ReplicatedStorage").RemoteSignals.BuyPetEgg:InvokeServer("Basic_Egg") 
                        
                        LP.Character.HumanoidRootPart.CFrame = savedPos
                        
                        if resultPet then
                            local petName = resultPet.Name or "Unknown Pet"
                            local petRarity = resultPet.Rarity or "Common"
                            local petWeight = resultPet.Weight or "Normal"
                            local petMutation = resultPet.Mutation or "None"
                            
                            local matchRarity = next(SelectedRarities) == nil or SelectedRarities[petRarity]
                            local matchWeight = next(SelectedWeights) == nil or SelectedWeights[petWeight]
                            local matchMutation = next(SelectedMutations) == nil or SelectedMutations[petMutation]
                            
                            if matchRarity and matchWeight and matchMutation then
                                ReportAutoBuyPet(petName, petRarity, petWeight, petMutation, EggPrice)
                            else
                                game:GetService("ReplicatedStorage").RemoteSignals.DeletePet:FireServer(resultPet.ID)
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
    return _G_AutoBuyPet
end)

createMultiSelectDropdown(BuyPetPanel, "RARITY FILTER:", GAG2_Rarities, SelectedRarities)
createMultiSelectDropdown(BuyPetPanel, "WEIGHT FILTER:", GAG2_Weights, SelectedWeights)
createMultiSelectDropdown(BuyPetPanel, "MUTATION FILTER:", GAG2_Mutations, SelectedMutations)

local InnerNotifPanel = Instance.new("Frame", BuyPetPanel) 
InnerNotifPanel.Size = UDim2.new(1, 0, 0, 35) 
InnerNotifPanel.BackgroundTransparency = 1 
InnerNotifPanel.Visible = false

local InnerLayout = Instance.new("UIListLayout", InnerNotifPanel)
InnerLayout.SortOrder = Enum.SortOrder.LayoutOrder

createToggle(BuyPetPanel, "PET AUTO BUY NOTIFI", function()
    _G_SubPetBuyNotifAct = not _G_SubPetBuyNotifAct
    InnerNotifPanel.Visible = _G_SubPetBuyNotifAct
    BuyPetPanel.Size = _G_SubPetBuyNotifAct and UDim2.new(1, 0, 0, 240) or UDim2.new(1, 0, 0, 200)
    return _G_SubPetBuyNotifAct
end)

createToggle(InnerNotifPanel, "AUTO BUY PET NOTIFIKASI ON/OFF", function()
    _G_AutoBuyPetNotif = not _G_AutoBuyPetNotif
    return _G_AutoBuyPetNotif
end)

-- ==========================================================
-- KONTEN TAB: WEBHOOK SETTING
-- ==========================================================
local WebLayout = Instance.new("UIListLayout", P_Web)
WebLayout.SortOrder = Enum.SortOrder.LayoutOrder
WebLayout.Padding = UDim.new(0, 4)

local WebPanel = Instance.new("Frame", P_Web) 
WebPanel.Size = UDim2.new(1, 0, 0, 160) 
WebPanel.BackgroundTransparency = 1 
WebPanel.Visible = false

local WebSubLayout = Instance.new("UIListLayout", WebPanel)
WebSubLayout.SortOrder = Enum.SortOrder.LayoutOrder
WebSubLayout.Padding = UDim.new(0, 4)

createToggle(P_Web, "BUKA/TUTUP WEBHOOK CONFIG", function() _G_WebPanelAct = not _G_WebPanelAct WebPanel.Visible = _G_WebPanelAct return _G_WebPanelAct end)
createTextBox(WebPanel, "WEB URL:", "https://discord.com/...", function(val) WebhookURL = val end)
createTextBox(WebPanel, "ALLOWED PINGS/TAGS ID:", "example_user", function(val) AllowedPing = val end)
createToggle(WebPanel, "AUTO SEND NOTIFI TO DISCORD", function() _G_AutoWebhook = not _G_AutoWebhook return _G_AutoWebhook end)
createToggle(WebPanel, "AUTO SEND MAIL BOX NOTIFIKASI", function() _G_AutoSendMailNotif = not _G_AutoSendMailNotif return _G_AutoSendMailNotif end)
