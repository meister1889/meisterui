-- MeisterUI Advanced Library v2.0
-- Sleek, Modern, Dark/Grey Theme with Animations and Notifications

local MeisterUI = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

-- Protect UI
local ParentGui = CoreGui
if gethui then
    ParentGui = gethui()
elseif set_thread_identity then
    set_thread_identity(8)
end

-- Create ScreenGui
local ScreenObject = Instance.new("ScreenGui")
ScreenObject.Name = "MeisterUI_Environment"
ScreenObject.IgnoreGuiInset = true
ScreenObject.ResetOnSpawn = false
ScreenObject.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenObject.Parent = ParentGui

-- Destroy old instances
if ParentGui:FindFirstChild("MeisterUI_Environment") then
    for _, v in pairs(ParentGui:GetChildren()) do
        if v.Name == "MeisterUI_Environment" and v ~= ScreenObject then
            v:Destroy()
        end
    end
end

-- Notification Container
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Parent = ScreenObject
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(1, -320, 1, -20)
NotifContainer.Size = UDim2.new(0, 300, 1, 0)
NotifContainer.AnchorPoint = Vector2.new(0, 1)

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotifContainer
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)

-- Core Functions
local Utility = {}
function Utility:Tween(object, info, properties)
    local t = TweenService:Create(object, TweenInfo.new(unpack(info)), properties)
    t:Play()
    return t
end

function Utility:MakeDraggable(topbar, object)
    local Dragging, DragInput, DragStart, StartPosition
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            Utility:Tween(object, {0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out}, {
                Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
            })
        end
    end)
end

-- Notification System
function MeisterUI:Notify(options)
    local title = options.Title or "Notification"
    local content = options.Content or "Notification content."
    local duration = options.Duration or 3

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.Parent = NotifContainer
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Size = UDim2.new(1, 40, 0, 0) -- Starts off screen
    NotifFrame.Position = UDim2.new(1, 50, 0, 0)
    NotifFrame.ClipsDescendants = true
    NotifFrame.BackgroundTransparency = 1

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotifFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Parent = NotifFrame
    NotifStroke.Color = Color3.fromRGB(60, 60, 65)
    NotifStroke.Thickness = 1
    NotifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    NotifStroke.Transparency = 1

    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = NotifFrame
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 15, 0, 10)
    NotifTitle.Size = UDim2.new(1, -30, 0, 20)
    NotifTitle.Font = Enum.Font.Ubuntu
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
    NotifTitle.TextSize = 14
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.TextTransparency = 1

    local NotifText = Instance.new("TextLabel")
    NotifText.Parent = NotifFrame
    NotifText.BackgroundTransparency = 1
    NotifText.Position = UDim2.new(0, 15, 0, 32)
    NotifText.Size = UDim2.new(1, -30, 0, 40)
    NotifText.Font = Enum.Font.Ubuntu
    NotifText.Text = content
    NotifText.TextColor3 = Color3.fromRGB(180, 180, 180)
    NotifText.TextSize = 13
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextYAlignment = Enum.TextYAlignment.Top
    NotifText.TextWrapped = true
    NotifText.TextTransparency = 1

    local ProgressBarBG = Instance.new("Frame")
    ProgressBarBG.Parent = NotifFrame
    ProgressBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ProgressBarBG.Position = UDim2.new(0, 15, 1, -8)
    ProgressBarBG.Size = UDim2.new(1, -30, 0, 3)
    ProgressBarBG.BorderSizePixel = 0
    ProgressBarBG.BackgroundTransparency = 1

    local ProgressBarBGCorner = Instance.new("UICorner")
    ProgressBarBGCorner.CornerRadius = UDim.new(1, 0)
    ProgressBarBGCorner.Parent = ProgressBarBG

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Parent = ProgressBarBG
    ProgressBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ProgressBar.Size = UDim2.new(1, 0, 1, 0)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.BackgroundTransparency = 1

    local ProgressBarCorner = Instance.new("UICorner")
    ProgressBarCorner.CornerRadius = UDim.new(1, 0)
    ProgressBarCorner.Parent = ProgressBar

    -- Calculate Height
    local bounds = TextService:GetTextSize(content, 13, Enum.Font.Ubuntu, Vector2.new(270, math.huge))
    local totalHeight = 55 + bounds.Y
    
    -- Animate In
    Utility:Tween(NotifFrame, {0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, totalHeight), BackgroundTransparency = 0})
    Utility:Tween(NotifStroke, {0.4}, {Transparency = 0})
    Utility:Tween(NotifTitle, {0.3}, {TextTransparency = 0})
    Utility:Tween(NotifText, {0.3}, {TextTransparency = 0})
    Utility:Tween(ProgressBarBG, {0.3}, {BackgroundTransparency = 0})
    Utility:Tween(ProgressBar, {0.3}, {BackgroundTransparency = 0})

    -- Progress
    Utility:Tween(ProgressBar, {duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In}, {Size = UDim2.new(0, 0, 1, 0)})

    -- Animate Out
    task.delay(duration, function()
        Utility:Tween(NotifTitle, {0.3}, {TextTransparency = 1})
        Utility:Tween(NotifText, {0.3}, {TextTransparency = 1})
        Utility:Tween(ProgressBarBG, {0.3}, {BackgroundTransparency = 1})
        Utility:Tween(ProgressBar, {0.3}, {BackgroundTransparency = 1})
        local hideTween = Utility:Tween(NotifFrame, {0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In}, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        Utility:Tween(NotifStroke, {0.4}, {Transparency = 1})
        
        hideTween.Completed:Connect(function()
            NotifFrame:Destroy()
        end)
    end)
end

function MeisterUI:CreateWindow(options)
    local WindowName = options.Name or "MeisterUI"
    local HideKey = options.HideKey or Enum.KeyCode.Insert
    
    local WindowOpen = false

    -- Loading Screen Fullscreen
    local IntroOverlay = Instance.new("Frame")
    IntroOverlay.Name = "IntroOverlay"
    IntroOverlay.Parent = ScreenObject
    IntroOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IntroOverlay.Position = UDim2.new(0, 0, 0, 0)
    IntroOverlay.Size = UDim2.new(1, 0, 1, 0)
    IntroOverlay.ZIndex = 100
    IntroOverlay.BackgroundTransparency = 1 -- Start transparent and fade to solid black

    local IntroTitle = Instance.new("TextLabel")
    IntroTitle.Parent = IntroOverlay
    IntroTitle.BackgroundTransparency = 1
    IntroTitle.Position = UDim2.new(0.5, -200, 0.5, -40)
    IntroTitle.Size = UDim2.new(0, 400, 0, 80)
    IntroTitle.Font = Enum.Font.Jura
    IntroTitle.Text = "MEISTER"
    IntroTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
    IntroTitle.TextScaled = true
    IntroTitle.TextTransparency = 1


    -- Main UI Elements
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenObject
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 650, 0, 400)
    MainFrame.Visible = false

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(50, 50, 55)
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Drop Shadow (Fake)
    local ShadowFrame = Instance.new("Frame")
    ShadowFrame.Name = "Shadow"
    ShadowFrame.Parent = MainFrame
    ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ShadowFrame.Size = UDim2.new(1, 10, 1, 10)
    ShadowFrame.Position = UDim2.new(0, -5, 0, -5)
    ShadowFrame.BackgroundTransparency = 0.8
    ShadowFrame.ZIndex = -1
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 14)
    ShadowCorner.Parent = ShadowFrame

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.Size = UDim2.new(0, 180, 1, -35)
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Parent = Sidebar
    SidebarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    SidebarFix.Position = UDim2.new(1, -10, 0, 0)
    SidebarFix.Size = UDim2.new(0, 10, 1, 0)
    SidebarFix.BorderSizePixel = 0

    local SidebarFixTop = Instance.new("Frame")
    SidebarFixTop.Parent = Sidebar
    SidebarFixTop.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    SidebarFixTop.Position = UDim2.new(0, 0, 0, 0)
    SidebarFixTop.Size = UDim2.new(1, 0, 0, 10)
    SidebarFixTop.BorderSizePixel = 0

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Parent = Sidebar
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    SidebarDivider.Position = UDim2.new(1, 0, 0, 0)
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    SidebarDivider.BorderSizePixel = 0

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BorderSizePixel = 0
    Topbar.ZIndex = 5
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 10)
    TopbarCorner.Parent = Topbar
    
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Parent = Topbar
    TopbarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    TopbarFix.Position = UDim2.new(0, 0, 1, -10)
    TopbarFix.Size = UDim2.new(1, 0, 0, 10)
    TopbarFix.BorderSizePixel = 0

    local TopbarDivider = Instance.new("Frame")
    TopbarDivider.Parent = Topbar
    TopbarDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TopbarDivider.Position = UDim2.new(0, 0, 1, -1)
    TopbarDivider.Size = UDim2.new(1, 0, 0, 1)
    TopbarDivider.BorderSizePixel = 0

    Utility:MakeDraggable(Topbar, MainFrame)
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Topbar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Font = Enum.Font.Ubuntu
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.TextSize = 14
    CloseBtn.AutoButtonColor = false

    CloseBtn.MouseEnter:Connect(function()
        Utility:Tween(CloseBtn, {0.2}, {TextColor3 = Color3.fromRGB(255, 100, 100)})
    end)
    CloseBtn.MouseLeave:Connect(function()
        Utility:Tween(CloseBtn, {0.2}, {TextColor3 = Color3.fromRGB(150, 150, 150)})
    end)

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Parent = Topbar
    MainTitle.BackgroundTransparency = 1
    MainTitle.Position = UDim2.new(0, 15, 0, 0)
    MainTitle.Size = UDim2.new(1, -60, 1, 0)
    MainTitle.Font = Enum.Font.Ubuntu
    MainTitle.Text = WindowName
    MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTitle.TextSize = 14
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.TextYAlignment = Enum.TextYAlignment.Center
    MainTitle.TextTruncate = Enum.TextTruncate.AtEnd

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.Active = true
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 10)
    TabContainer.Size = UDim2.new(1, 0, 1, -80)
    TabContainer.ScrollBarThickness = 0
    
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)

    -- Player Profile
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local MarketplaceService = game:GetService("MarketplaceService")

    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Name = "ProfileFrame"
    ProfileFrame.Parent = Sidebar
    ProfileFrame.BackgroundTransparency = 1
    ProfileFrame.Position = UDim2.new(0, 10, 1, -60)
    ProfileFrame.Size = UDim2.new(1, -20, 0, 50)
    ProfileFrame.ClipsDescendants = true

    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Parent = ProfileFrame
    AvatarImage.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    AvatarImage.Size = UDim2.new(0, 34, 0, 34)
    AvatarImage.Position = UDim2.new(0, 0, 0.5, -17)
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = AvatarImage
    
    local NameLab = Instance.new("TextLabel")
    NameLab.Parent = ProfileFrame
    NameLab.BackgroundTransparency = 1
    NameLab.Position = UDim2.new(0, 42, 0, 8)
    NameLab.Size = UDim2.new(1, -42, 0, 16)
    NameLab.Font = Enum.Font.Ubuntu
    NameLab.Text = LocalPlayer and LocalPlayer.Name or "Unknown"
    NameLab.TextColor3 = Color3.fromRGB(240, 240, 240)
    NameLab.TextSize = 13
    NameLab.TextXAlignment = Enum.TextXAlignment.Left
    NameLab.TextTruncate = Enum.TextTruncate.AtEnd

    local GameLab = Instance.new("TextLabel")
    GameLab.Parent = ProfileFrame
    GameLab.BackgroundTransparency = 1
    GameLab.Position = UDim2.new(0, 42, 0, 24)
    GameLab.Size = UDim2.new(1, -42, 0, 14)
    GameLab.Font = Enum.Font.Ubuntu
    GameLab.Text = "Loading..."
    GameLab.TextColor3 = Color3.fromRGB(150, 150, 150)
    GameLab.TextSize = 11
    GameLab.TextXAlignment = Enum.TextXAlignment.Left
    GameLab.TextTruncate = Enum.TextTruncate.AtEnd

    -- Fetch Avatar
    task.spawn(function()
        if LocalPlayer then
            local success, avatarUrl = pcall(function()
                return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            if success then
                AvatarImage.Image = avatarUrl
            end
        end
    end)

    -- Fetch Game Name
    task.spawn(function()
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if success and info and info.Name then
            GameLab.Text = info.Name
        else
            GameLab.Text = "Unknown Game"
        end
    end)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 181, 0, 35)
    ContentArea.Size = UDim2.new(1, -181, 1, -35)

    task.spawn(function()
        -- 1. Full black screen fade in
        Utility:Tween(IntroOverlay, {0.5}, {BackgroundTransparency = 0})
        task.wait(0.6)
        
        -- 2. Fade in text smoothly
        Utility:Tween(IntroTitle, {1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {TextTransparency = 0})
        
        -- Pulse text size animation
        local glowTween = Utility:Tween(IntroTitle, {1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut}, {
            Size = UDim2.new(0, 480, 0, 96), 
            Position = UDim2.new(0.5, -240, 0.5, -48)
        })
        
        task.wait(1.5)
        
        -- 3. Fade out text
        Utility:Tween(IntroTitle, {0.6}, {
            TextTransparency = 1, 
            Size = UDim2.new(0, 600, 0, 120), 
            Position = UDim2.new(0.5, -300, 0.5, -60)
        })
        task.wait(0.7)
        
        -- 4. Setup Main Hub to start small and then grow as background fades
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 550, 0, 300)
        MainFrame.Position = UDim2.new(0.5, -275, 0.5, -150)
        
        -- Use a task.delay failsafe in case Tweens get hung
        task.delay(1.5, function()
            if IntroOverlay and IntroOverlay.Parent then
                IntroOverlay:Destroy()
            end
        end)
        
        local fadeBg = Utility:Tween(IntroOverlay, {0.8}, {BackgroundTransparency = 1})
        Utility:Tween(MainFrame, {0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {
            Size = UDim2.new(0, 650, 0, 400), 
            Position = UDim2.new(0.5, -325, 0.5, -200)
        })
        
        fadeBg.Completed:Connect(function()
            if IntroOverlay and IntroOverlay.Parent then IntroOverlay:Destroy() end
            WindowOpen = true
            MeisterUI:Notify({Title = "Loaded", Content = "meister module loaded successfully.", Duration = 4})
        end)
    end)
    
    local function ToggleUI(state)
        WindowOpen = state
        if WindowOpen then
            MainFrame.Visible = true
            Utility:Tween(MainFrame, {0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 650, 0, 400), Position = UDim2.new(0.5, -325, 0.5, -200)})
        else
            local closeTween = Utility:Tween(MainFrame, {0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In}, {Size = UDim2.new(0, 500, 0, 250), Position = UDim2.new(0.5, -250, 0.5, -125)})
            closeTween.Completed:Connect(function()
                if not WindowOpen then MainFrame.Visible = false end
            end)
            MeisterUI:Notify({Title = "UI Hidden", Content = "Press INSERT to open the menu again.", Duration = 4})
        end
    end

    CloseBtn.MouseButton1Click:Connect(function()
        if WindowOpen then
            ToggleUI(false)
        end
    end)

    -- Toggle Logic
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == HideKey and not ParentGui:FindFirstChild("IntroOverlay") then
            ToggleUI(not WindowOpen)
        end
    end)

    local Window = {}
    local Pages = {}
    local activeTabBtn = nil

    function Window:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName.."_Btn"
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.Font = Enum.Font.Ubuntu
        TabBtn.Text = "   " .. tabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.AutoButtonColor = false

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        local SelectedIndicator = Instance.new("Frame")
        SelectedIndicator.Parent = TabBtn
        SelectedIndicator.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        SelectedIndicator.Size = UDim2.new(0, 3, 0, 0)
        SelectedIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        SelectedIndicator.AnchorPoint = Vector2.new(0, 0.5)
        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(1, 0)
        IndCorner.Parent = SelectedIndicator

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName.."_Page"
        TabPage.Parent = ContentArea
        TabPage.Active = true
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 55)
        TabPage.Visible = false
        TabPage.CanvasSize = UDim2.new(0,0,0,0)
        
        table.insert(Pages, TabPage)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = TabPage
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = TabPage
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 20)
        PagePadding.PaddingLeft = UDim.new(0, 20)
        PagePadding.PaddingRight = UDim.new(0, 20)

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
        end)

        local function ActivateTab()
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    Utility:Tween(child, {0.3}, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150)})
                    local ind = child:FindFirstChild("Frame")
                    if ind then Utility:Tween(ind, {0.3}, {Size = UDim2.new(0, 3, 0, 0)}) end
                end
            end
            for _, page in pairs(Pages) do
                if page.Visible then
                    page.Visible = false
                    page.Position = UDim2.new(0, 10, 0, 0)
                end
            end

            Utility:Tween(TabBtn, {0.3}, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(240, 240, 240)})
            Utility:Tween(SelectedIndicator, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 3, 0, 18)})
            
            TabPage.Visible = true
            Utility:Tween(TabPage, {0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 0, 0, 0)})
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)

        if #Pages == 1 then
            ActivateTab()
        end

        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(options)
            local name = options.Name or "Button"
            local callback = options.Callback or function() end

            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Parent = TabPage
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ButtonFrame.Size = UDim2.new(1, 0, 0, 42)
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = ButtonFrame
            
            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Parent = ButtonFrame
            BtnStroke.Color = Color3.fromRGB(45, 45, 50)
            BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local BtnButton = Instance.new("TextButton")
            BtnButton.Parent = ButtonFrame
            BtnButton.BackgroundTransparency = 1
            BtnButton.Size = UDim2.new(1, 0, 1, 0)
            BtnButton.Text = ""

            local BtnText = Instance.new("TextLabel")
            BtnText.Parent = ButtonFrame
            BtnText.BackgroundTransparency = 1
            BtnText.Position = UDim2.new(0, 15, 0, 0)
            BtnText.Size = UDim2.new(1, -30, 1, 0)
            BtnText.Font = Enum.Font.Ubuntu
            BtnText.Text = name
            BtnText.TextColor3 = Color3.fromRGB(220, 220, 220)
            BtnText.TextSize = 14
            BtnText.TextXAlignment = Enum.TextXAlignment.Left
            BtnText.TextTruncate = Enum.TextTruncate.AtEnd

            local BtnIcon = Instance.new("ImageLabel")
            BtnIcon.Parent = ButtonFrame
            BtnIcon.BackgroundTransparency = 1
            BtnIcon.Position = UDim2.new(1, -30, 0.5, -8)
            BtnIcon.Size = UDim2.new(0, 16, 0, 16)
            BtnIcon.Image = "rbxassetid://10888331510" -- Pointer icon
            BtnIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

            BtnButton.MouseEnter:Connect(function()
                Utility:Tween(ButtonFrame, {0.2}, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)})
                Utility:Tween(BtnIcon, {0.2}, {Position = UDim2.new(1, -25, 0.5, -8), ImageColor3 = Color3.fromRGB(255, 255, 255)})
            end)

            BtnButton.MouseLeave:Connect(function()
                Utility:Tween(ButtonFrame, {0.2}, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)})
                Utility:Tween(BtnIcon, {0.2}, {Position = UDim2.new(1, -30, 0.5, -8), ImageColor3 = Color3.fromRGB(150, 150, 150)})
            end)

            BtnButton.MouseButton1Down:Connect(function()
                Utility:Tween(ButtonFrame, {0.1}, {Size = UDim2.new(1, -4, 0, 38)})
                Utility:Tween(BtnStroke, {0.1}, {Color = Color3.fromRGB(100, 100, 110)})
            end)

            BtnButton.MouseButton1Up:Connect(function()
                Utility:Tween(ButtonFrame, {0.1}, {Size = UDim2.new(1, 0, 0, 42)})
                Utility:Tween(BtnStroke, {0.1}, {Color = Color3.fromRGB(45, 45, 50)})
                callback()
            end)
        end

        -- TOGGLE
        function Elements:CreateToggle(options)
            local name = options.Name or "Toggle"
            local default = options.CurrentValue or false
            local callback = options.Callback or function() end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = TabPage
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
            
            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 6)
            TglCorner.Parent = ToggleFrame
            
            local TglStroke = Instance.new("UIStroke")
            TglStroke.Parent = ToggleFrame
            TglStroke.Color = Color3.fromRGB(45, 45, 50)
            TglStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local TglButton = Instance.new("TextButton")
            TglButton.Parent = ToggleFrame
            TglButton.BackgroundTransparency = 1
            TglButton.Size = UDim2.new(1, 0, 1, 0)
            TglButton.Text = ""

            local TglText = Instance.new("TextLabel")
            TglText.Parent = ToggleFrame
            TglText.BackgroundTransparency = 1
            TglText.Position = UDim2.new(0, 15, 0, 0)
            TglText.Size = UDim2.new(1, -60, 1, 0)
            TglText.Font = Enum.Font.Ubuntu
            TglText.Text = name
            TglText.TextColor3 = Color3.fromRGB(220, 220, 220)
            TglText.TextSize = 14
            TglText.TextXAlignment = Enum.TextXAlignment.Left
            TglText.TextTruncate = Enum.TextTruncate.AtEnd

            local SliderBG = Instance.new("Frame")
            SliderBG.Parent = ToggleFrame
            SliderBG.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
            SliderBG.Position = UDim2.new(1, -45, 0.5, -12)
            SliderBG.Size = UDim2.new(0, 36, 0, 24)
            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = SliderBG

            local SStroke = Instance.new("UIStroke")
            SStroke.Parent = SliderBG
            SStroke.Color = Color3.fromRGB(50, 50, 55)

            local SliderCircle = Instance.new("Frame")
            SliderCircle.Parent = SliderBG
            SliderCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            SliderCircle.Position = UDim2.new(0, 4, 0.5, -8)
            SliderCircle.Size = UDim2.new(0, 16, 0, 16)
            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(1, 0)
            CCorner.Parent = SliderCircle

            local toggled = default

            local function updateToggle(anim)
                local time = anim and 0.25 or 0
                if toggled then
                    Utility:Tween(SliderBG, {time}, {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
                    Utility:Tween(SliderCircle, {time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = Color3.fromRGB(30, 30, 35)})
                    Utility:Tween(SStroke, {time}, {Color = Color3.fromRGB(220, 220, 220)})
                else
                    Utility:Tween(SliderBG, {time}, {BackgroundColor3 = Color3.fromRGB(20, 20, 22)})
                    Utility:Tween(SliderCircle, {time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 150)})
                    Utility:Tween(SStroke, {time}, {Color = Color3.fromRGB(50, 50, 55)})
                end
            end

            updateToggle(false)

            TglButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle(true)
                callback(toggled)
            end)

            TglButton.MouseEnter:Connect(function()
                Utility:Tween(ToggleFrame, {0.2}, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)})
            end)
            TglButton.MouseLeave:Connect(function()
                Utility:Tween(ToggleFrame, {0.2}, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)})
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(options)
            local name = options.Name or "Slider"
            local min = options.Range[1] or 0
            local max = options.Range[2] or 100
            local default = options.CurrentValue or min
            local callback = options.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = TabPage
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            
            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(0, 6)
            SCorner.Parent = SliderFrame
            
            local SStroke = Instance.new("UIStroke")
            SStroke.Parent = SliderFrame
            SStroke.Color = Color3.fromRGB(45, 45, 50)
            SStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local TitleLab = Instance.new("TextLabel")
            TitleLab.Parent = SliderFrame
            TitleLab.BackgroundTransparency = 1
            TitleLab.Position = UDim2.new(0, 15, 0, 10)
            TitleLab.Size = UDim2.new(1, -30, 0, 20)
            TitleLab.Font = Enum.Font.Ubuntu
            TitleLab.Text = name
            TitleLab.TextColor3 = Color3.fromRGB(220, 220, 220)
            TitleLab.TextSize = 14
            TitleLab.TextXAlignment = Enum.TextXAlignment.Left
            TitleLab.TextTruncate = Enum.TextTruncate.AtEnd

            local ValueLab = Instance.new("TextLabel")
            ValueLab.Parent = SliderFrame
            ValueLab.BackgroundTransparency = 1
            ValueLab.Position = UDim2.new(0, 15, 0, 10)
            ValueLab.Size = UDim2.new(1, -30, 0, 20)
            ValueLab.Font = Enum.Font.Ubuntu
            ValueLab.Text = tostring(default)
            ValueLab.TextColor3 = Color3.fromRGB(150, 150, 150)
            ValueLab.TextSize = 14
            ValueLab.TextXAlignment = Enum.TextXAlignment.Right

            local TrackBG = Instance.new("Frame")
            TrackBG.Parent = SliderFrame
            TrackBG.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
            TrackBG.Position = UDim2.new(0, 15, 1, -15)
            TrackBG.Size = UDim2.new(1, -30, 0, 6)
            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(1, 0)
            TCorner.Parent = TrackBG

            local TrackFill = Instance.new("Frame")
            TrackFill.Parent = TrackBG
            TrackFill.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            TrackFill.Size = UDim2.new(0, 0, 1, 0)
            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = TrackFill

            local DragBtn = Instance.new("TextButton")
            DragBtn.Parent = TrackBG
            DragBtn.BackgroundTransparency = 1
            DragBtn.Position = UDim2.new(0, -15, 0, -10)
            DragBtn.Size = UDim2.new(1, 30, 1, 20)
            DragBtn.Text = ""

            local hovering = false
            SliderFrame.MouseEnter:Connect(function() hovering = true Utility:Tween(SliderFrame, {0.2}, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}) end)
            SliderFrame.MouseLeave:Connect(function() hovering = false Utility:Tween(SliderFrame, {0.2}, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}) end)

            local dragging = false
            local function updateSlider(input)
                local trackWidth = TrackBG.AbsoluteSize.X
                if trackWidth == 0 then trackWidth = 1 end
                local sizeX = math.clamp((input.Position.X - TrackBG.AbsolutePosition.X) / trackWidth, 0, 1)
                Utility:Tween(TrackFill, {0.1}, {Size = UDim2.new(sizeX, 0, 1, 0)})
                local value = math.floor(min + ((max - min) * sizeX))
                ValueLab.Text = tostring(value)
                callback(value)
            end

            DragBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)

            DragBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            -- Set default
            TrackFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        end

        -- DROPDOWN
        function Elements:CreateDropdown(options)
            local name = options.Name or "Dropdown"
            local list = options.Options or {}
            local current = options.CurrentOption or ""
            local callback = options.Callback or function() end

            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = TabPage
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            DropFrame.Size = UDim2.new(1, 0, 0, 42)
            DropFrame.ClipsDescendants = true
            
            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(0, 6)
            DCorner.Parent = DropFrame
            
            local DStroke = Instance.new("UIStroke")
            DStroke.Parent = DropFrame
            DStroke.Color = Color3.fromRGB(45, 45, 50)
            DStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local DropBtn = Instance.new("TextButton")
            DropBtn.Parent = DropFrame
            DropBtn.BackgroundTransparency = 1
            DropBtn.Size = UDim2.new(1, 0, 0, 42)
            DropBtn.Text = ""

            local TitleLab = Instance.new("TextLabel")
            TitleLab.Parent = DropFrame
            TitleLab.BackgroundTransparency = 1
            TitleLab.Position = UDim2.new(0, 15, 0, 0)
            TitleLab.Size = UDim2.new(1, -60, 0, 42)
            TitleLab.Font = Enum.Font.Ubuntu
            TitleLab.Text = name .. " : " .. tostring(current)
            TitleLab.TextColor3 = Color3.fromRGB(220, 220, 220)
            TitleLab.TextSize = 14
            TitleLab.TextXAlignment = Enum.TextXAlignment.Left
            TitleLab.TextTruncate = Enum.TextTruncate.AtEnd

            local DropIcon = Instance.new("ImageLabel")
            DropIcon.Parent = DropFrame
            DropIcon.BackgroundTransparency = 1
            DropIcon.Position = UDim2.new(1, -30, 0, 13)
            DropIcon.Size = UDim2.new(0, 16, 0, 16)
            DropIcon.Image = "rbxassetid://10888331510"
            DropIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            DropIcon.Rotation = 90

            local ListContainer = Instance.new("ScrollingFrame")
            ListContainer.Parent = DropFrame
            ListContainer.BackgroundTransparency = 1
            ListContainer.Position = UDim2.new(0, 0, 0, 42)
            ListContainer.Size = UDim2.new(1, 0, 1, -42)
            ListContainer.ScrollBarThickness = 2
            ListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = ListContainer
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local expanded = false

            local function refreshList()
                for _, v in pairs(ListContainer:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                local ySize = 0
                for _, option in pairs(list) do
                    local OptionBtn = Instance.new("TextButton")
                    OptionBtn.Parent = ListContainer
                    OptionBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                    OptionBtn.BackgroundTransparency = 1
                    OptionBtn.Size = UDim2.new(1, 0, 0, 32)
                    OptionBtn.Font = Enum.Font.Ubuntu
                    OptionBtn.Text = "  " .. tostring(option)
                    OptionBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                    OptionBtn.TextSize = 13
                    OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptionBtn.AutoButtonColor = false

                    OptionBtn.MouseEnter:Connect(function()
                        Utility:Tween(OptionBtn, {0.1}, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)})
                    end)
                    OptionBtn.MouseLeave:Connect(function()
                        Utility:Tween(OptionBtn, {0.1}, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 180)})
                    end)

                    OptionBtn.MouseButton1Click:Connect(function()
                        current = option
                        TitleLab.Text = name .. " : " .. tostring(current)
                        expanded = false
                        Utility:Tween(DropFrame, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 42)})
                        Utility:Tween(DropIcon, {0.3}, {Rotation = 90})
                        callback(current)
                    end)
                    ySize = ySize + 32
                end
                ListContainer.CanvasSize = UDim2.new(0, 0, 0, ySize)
            end
            
            refreshList()

            DropBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    local targetHeight = math.clamp(42 + (#list * 32), 42, 170)
                    Utility:Tween(DropFrame, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, targetHeight)})
                    Utility:Tween(DropIcon, {0.3}, {Rotation = -90})
                else
                    Utility:Tween(DropFrame, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 42)})
                    Utility:Tween(DropIcon, {0.3}, {Rotation = 90})
                end
            end)
        end

        -- INPUT / TEXTBOX
        function Elements:CreateInput(options)
            local name = options.Name or "Input"
            local placeholder = options.PlaceholderText or "Type here..."
            local callback = options.Callback or function() end

            local InputFrame = Instance.new("Frame")
            InputFrame.Parent = TabPage
            InputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            InputFrame.Size = UDim2.new(1, 0, 0, 42)
            
            local ICorner = Instance.new("UICorner")
            ICorner.CornerRadius = UDim.new(0, 6)
            ICorner.Parent = InputFrame
            
            local IStroke = Instance.new("UIStroke")
            IStroke.Parent = InputFrame
            IStroke.Color = Color3.fromRGB(45, 45, 50)
            IStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local TitleLab = Instance.new("TextLabel")
            TitleLab.Parent = InputFrame
            TitleLab.BackgroundTransparency = 1
            TitleLab.Position = UDim2.new(0, 15, 0, 0)
            TitleLab.Size = UDim2.new(0.4, 0, 1, 0)
            TitleLab.Font = Enum.Font.Ubuntu
            TitleLab.Text = name
            TitleLab.TextColor3 = Color3.fromRGB(220, 220, 220)
            TitleLab.TextSize = 14
            TitleLab.TextXAlignment = Enum.TextXAlignment.Left
            TitleLab.TextTruncate = Enum.TextTruncate.AtEnd

            local TextBoxBG = Instance.new("Frame")
            TextBoxBG.Parent = InputFrame
            TextBoxBG.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
            TextBoxBG.Position = UDim2.new(0.4, 15, 0.5, -12)
            TextBoxBG.Size = UDim2.new(0.6, -30, 0, 24)
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = TextBoxBG

            local TextBox = Instance.new("TextBox")
            TextBox.Parent = TextBoxBG
            TextBox.BackgroundTransparency = 1
            TextBox.Size = UDim2.new(1, -10, 1, 0)
            TextBox.Position = UDim2.new(0, 5, 0, 0)
            TextBox.Font = Enum.Font.Ubuntu
            TextBox.Text = ""
            TextBox.PlaceholderText = placeholder
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            TextBox.TextSize = 13
            TextBox.TextXAlignment = Enum.TextXAlignment.Left

            TextBox.FocusLost:Connect(function(enterPressed)
                callback(TextBox.Text)
            end)
        end

        return Elements
    end

    return Window
end

return MeisterUI
