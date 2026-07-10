--// Library.lua (PART 1)

local Library = {}
Library.__index = Library

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--// Theme (inspired dark + pink accent)
Library.Theme = {
    Background = Color3.fromRGB(18, 18, 18),
    Secondary  = Color3.fromRGB(24, 24, 24),
    Tertiary   = Color3.fromRGB(30, 30, 30),
    Accent     = Color3.fromRGB(199, 141, 158),
    Text       = Color3.fromRGB(235, 235, 235),
    SubText    = Color3.fromRGB(160, 160, 160)
}

Library.State = {
    CurrentTab = nil,
    Windows = {},
    Config = {}
}

--// Utility
local function Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do
        inst[i] = v
    end
    return inst
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

--// Drag system
local function EnableDrag(frame, handle)
    handle = handle or frame

    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--// Window constructor
function Library:CreateWindow(config)
    config = config or {}
    local TopBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.TopBar,
        BorderSizePixel = 0,
        Parent = Main
    })

    -- UI Name / Title
    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "primUI",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = TopBar
    })

    local ScreenGui = Create("ScreenGui", {
        Name = "UILibrary",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui")
    })

    local Main = Create("Frame", {
        Size = UDim2.fromOffset(700, 450),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Background,
        Parent = ScreenGui
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Main
    })

    local Stroke = Create("UIStroke", {
        Color = self.Theme.Accent,
        Thickness = 1,
        Transparency = 0.2,
        Parent = Main
    })

    --// Sidebar
    local Sidebar = Create("Frame", {
        Size = UDim2.fromOffset(160, 450),
        BackgroundColor3 = self.Theme.Secondary,
        Parent = Main
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Sidebar
    })

    --// Top bar drag handle
    local TopBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = Main
    })

    EnableDrag(Main, TopBar)

    --// Content holder
    local Content = Create("Frame", {
        Position = UDim2.fromOffset(160, 0),
        Size = UDim2.fromOffset(540, 450),
        BackgroundTransparency = 1,
        Parent = Main
    })

    --// Window object
    local Window = {}

    Window.Instance = Main
    Window.Sidebar = Sidebar
    Window.Content = Content

    Window.Tabs = {}

    return Window
end

--// Library.lua (PART 2)

local Library = Library

local function Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do
        inst[i] = v
    end
    return inst
end

local function Tween(obj, props, t)
    game:GetService("TweenService"):Create(
        obj,
        TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    ):Play()
end

--// TAB SYSTEM
function Library:CreateWindowTab(Window, name)
    local TabButton = Create("TextButton", {
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.fromOffset(5, 5 + (#Window.Tabs * 35)),
        BackgroundColor3 = self.Theme.Tertiary,
        Text = name,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Parent = Window.Sidebar
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = TabButton
    })

    local Page = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = Window.Content
    })

    local Tab = {
        Name = name,
        Button = TabButton,
        Page = Page,
        Elements = {}
    }

    function Tab:Show()
        for _, t in pairs(Window.Tabs) do
            t.Page.Visible = false
        end
        Page.Visible = true
    end

    TabButton.MouseButton1Click:Connect(function()
        Tab:Show()
    end)

    -- first tab auto show
    if #Window.Tabs == 0 then
        Page.Visible = true
    end

    table.insert(Window.Tabs, Tab)
    return Tab
end

--// PUBLIC API: Tab
function Library:Tab(Window, name)
    local Tab = self:CreateWindowTab(Window, name)
    return Tab
end

--// GROUPBOX
function Library:Groupbox(Tab, name)
    local Box = Create("Frame", {
        Size = UDim2.fromOffset(520, 200),
        BackgroundColor3 = self.Theme.Secondary,
        Parent = Tab.Page
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Box
    })

    Create("UIStroke", {
        Color = self.Theme.Accent,
        Thickness = 1,
        Transparency = 0.5,
        Parent = Box
    })

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.fromOffset(10, 5),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Box
    })

    local Holder = Create("Frame", {
        Size = UDim2.new(1, -10, 1, -30),
        Position = UDim2.fromOffset(5, 25),
        BackgroundTransparency = 1,
        Parent = Box
    })

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 6)
    UIList.Parent = Holder

    local Group = {
        Instance = Box,
        Holder = Holder
    }

    return Group
end

--// Library.lua (PART 3)

local Library = Library

local UserInputService = game:GetService("UserInputService")

local function Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do
        inst[i] = v
    end
    return inst
end

local function Tween(obj, props, t)
    game:GetService("TweenService"):Create(
        obj,
        TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    ):Play()
end

--// TOGGLE
function Library:Toggle(Group, text, default, callback)
    default = default or false

    local state = default

    local Holder = Group.Holder

    local Button = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Tertiary,
        Parent = Holder
    })

    Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Button})

    local Label = Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Button
    })

    local SwitchBack = Create("Frame", {
        Size = UDim2.fromOffset(35, 16),
        Position = UDim2.new(1, -45, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        Parent = Button
    })

    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = SwitchBack})

    local Knob = Create("Frame", {
        Size = UDim2.fromOffset(14,14),
        Position = UDim2.fromOffset(1,1),
        BackgroundColor3 = Color3.fromRGB(200,200,200),
        Parent = SwitchBack
    })

    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Knob})

    local function set(val)
        state = val

        if state then
            Tween(SwitchBack, {BackgroundColor3 = self.Theme.Accent}, 0.2)
            Tween(Knob, {Position = UDim2.fromOffset(19,1)}, 0.2)
        else
            Tween(SwitchBack, {BackgroundColor3 = Color3.fromRGB(40,40,40)}, 0.2)
            Tween(Knob, {Position = UDim2.fromOffset(1,1)}, 0.2)
        end

        if callback then
            callback(state)
        end
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            set(not state)
        end
    end)

    set(default)
end

--// BUTTON
function Library:Button(Group, text, callback)
    local Holder = Group.Holder

    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Tertiary,
        Text = text,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Parent = Holder
    })

    Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Button})

    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = self.Theme.Secondary}, 0.15)
    end)

    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = self.Theme.Tertiary}, 0.15)
    end)

    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

--// SLIDER
function Library:Slider(Group, text, min, max, default, callback)
    local Holder = Group.Holder
    local value = default or min

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = self.Theme.Tertiary
    Frame.Parent = Holder

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 18)
    Label.Position = UDim2.fromOffset(10, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = self.Theme.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local BarBack = Instance.new("Frame")
    BarBack.Size = UDim2.new(1, -20, 0, 6)
    BarBack.Position = UDim2.fromOffset(10, 25)
    BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
    BarBack.Parent = Frame

    Instance.new("UICorner", BarBack).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0,0,1,0)
    Fill.BackgroundColor3 = self.Theme.Accent
    Fill.Parent = BarBack

    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function set(v)
        value = math.clamp(v, min, max)
        local alpha = (value - min) / (max - min)

        Fill.Size = UDim2.new(alpha, 0, 1, 0)
        Label.Text = text .. ": " .. math.floor(value)

        if callback then
            callback(value)
        end
    end

    BarBack.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    BarBack.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local x = (i.Position.X - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X
            set(min + (max - min) * x)
        end
    end)

    -- set initial value
    set(default)

    -- 🔥 RETURN OBJECT so you can access value
    return {
        Set = set,
        Get = function()
            return value
        end
    }
end

--// Library.lua (PART 4)

local Library = Library

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local function Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do
        inst[i] = v
    end
    return inst
end

local function Tween(obj, props, t)
    TweenService:Create(
        obj,
        TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    ):Play()
end

--/////////////////////////////////////////////////////
--// DROPDOWN
--/////////////////////////////////////////////////////
function Library:Dropdown(Group, text, options, callback)
    local Holder = Group.Holder
    local open = false
    local selected = nil

    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Tertiary,
        Parent = Holder
    })

    Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Frame})

    local Label = Create("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.fromOffset(10,0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Frame
    })

    local List = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = self.Theme.Secondary,
        ClipsDescendants = true,
        Parent = Frame
    })

    Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = List})

    local function refresh()
        List:ClearAllChildren()

        local layout = Instance.new("UIListLayout")
        layout.Parent = List
        layout.Padding = UDim.new(0,4)

        for _, v in ipairs(options) do
            local b = Create("TextButton", {
                Size = UDim2.new(1,0,0,25),
                BackgroundColor3 = self.Theme.Tertiary,
                Text = v,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                Parent = List
            })

            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = b})

            b.MouseButton1Click:Connect(function()
                selected = v
                Label.Text = text .. ": " .. v
                if callback then callback(v) end
            end)
        end
    end

    Frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            open = not open
            Tween(List, {Size = open and UDim2.new(1,0,0,#options*29) or UDim2.new(1,0,0,0)}, 0.2)
        end
    end)

    refresh()
end

--/////////////////////////////////////////////////////
--// KEYBIND
--/////////////////////////////////////////////////////
function Library:Keybind(Group, text, default, callback)
    local Holder = Group.Holder
    local key = default

    local Button = Create("TextButton", {
        Size = UDim2.new(1,0,0,30),
        BackgroundColor3 = self.Theme.Tertiary,
        Text = text .. ": " .. tostring(default),
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Parent = Holder
    })

    Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Button})

    local listening = false

    Button.MouseButton1Click:Connect(function()
        listening = true
        Button.Text = "Press a key..."
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if listening and not gp then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                listening = false
                Button.Text = text .. ": " .. tostring(key.Name)
                if callback then callback(key) end
            end
        end
    end)
end

--/////////////////////////////////////////////////////
--// COLOR PICKER (simple HSV picker)
--/////////////////////////////////////////////////////
function Library:Colorpicker(Group,text,default,callback)

    local Holder = Group.Holder
    local color = default or Color3.new(1,1,1)

    local Frame = Create("Frame",{
        Size = UDim2.new(1,0,0,160),
        BackgroundColor3 = self.Theme.Tertiary,
        Parent = Holder
    })

    Create("UICorner",{
        CornerRadius = UDim.new(0,6),
        Parent = Frame
    })


    Create("TextLabel",{
        Size = UDim2.new(1,0,0,25),
        Text=text,
        BackgroundTransparency=1,
        TextColor3=self.Theme.Text,
        Font=Enum.Font.Gotham,
        TextSize=13,
        Parent=Frame
    })


    -- HSV picker
    local Picker = Create("Frame",{
        Size=UDim2.fromOffset(120,120),
        Position=UDim2.fromOffset(10,30),
        BackgroundColor3=Color3.fromHSV(0,1,1),
        Parent=Frame
    })


    Create("UICorner",{
        CornerRadius=UDim.new(0,5),
        Parent=Picker
    })


    -- White gradient
    local White = Create("Frame",{
        Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(1,1,1),
        Parent=Picker
    })

    local WhiteGradient = Instance.new("UIGradient")
    WhiteGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,0),
        NumberSequenceKeypoint.new(1,1)
    }
    WhiteGradient.Parent = White


    -- Black gradient
    local Black = Create("Frame",{
        Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0),
        Parent=Picker
    })

    local BlackGradient = Instance.new("UIGradient")
    BlackGradient.Rotation = 90
    BlackGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(1,0)
    }
    BlackGradient.Parent = Black


    -- Hue bar
    local Hue = Create("Frame",{
        Size=UDim2.fromOffset(20,120),
        Position=UDim2.fromOffset(140,30),
        Parent=Frame
    })


    local HueGradient = Instance.new("UIGradient")
    HueGradient.Rotation = 90
    HueGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(.16,Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(.33,Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(.5,Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(.66,Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(.83,Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))
    }
    HueGradient.Parent = Hue


    local hue,sat,val = Color3.toHSV(color)

    local pickingColor = false
    local pickingHue = false


    local function Update()

        Picker.BackgroundColor3 =
            Color3.fromHSV(hue,1,1)

        color =
            Color3.fromHSV(hue,sat,val)

        if callback then
            callback(color)
        end
    end


    Picker.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            pickingColor = true
        end
    end)


    Hue.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            pickingHue = true
        end
    end)


    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            pickingColor = false
            pickingHue = false
        end
    end)


    UserInputService.InputChanged:Connect(function(i)

        if i.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end


        if pickingColor then

            sat = math.clamp(
                (i.Position.X-Picker.AbsolutePosition.X)
                /Picker.AbsoluteSize.X,
                0,1
            )

            val = math.clamp(
                1 -
                ((i.Position.Y-Picker.AbsolutePosition.Y)
                /Picker.AbsoluteSize.Y),
                0,1
            )

            Update()

        end


        if pickingHue then

            hue = math.clamp(
                (i.Position.Y-Hue.AbsolutePosition.Y)
                /Hue.AbsoluteSize.Y,
                0,1
            )

            Update()

        end

    end)


    Update()

end

--/////////////////////////////////////////////////////
--// NOTIFICATIONS
--/////////////////////////////////////////////////////
function Library:Notify(text, duration)
    duration = duration or 3

    local player = game:GetService("Players").LocalPlayer
    local gui = player:WaitForChild("PlayerGui")

    local holder = gui:FindFirstChild("primUINotifications")

    if not holder then
        holder = Create("ScreenGui", {
            Name = "primUINotifications",
            ResetOnSpawn = false,
            Parent = gui
        })
    end

    local notif = Create("Frame", {
        Size = UDim2.fromOffset(250,45),
        Position = UDim2.new(1,-270,1,-70),
        BackgroundColor3 = self.Theme.Secondary,
        Parent = holder
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0,8),
        Parent = notif
    })

    local label = Create("TextLabel", {
        Size = UDim2.new(1,-20,1,0),
        Position = UDim2.fromOffset(10,0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })

    Tween(
        notif,
        {
            Position = UDim2.new(1,-270,1,-130)
        },
        .3
    )

    task.delay(duration,function()
        Tween(notif,{
            BackgroundTransparency = 1
        },.3)

        task.wait(.3)

        notif:Destroy()
    end)
end

--// Library.lua (FINAL PART - POLISH PASS)

local Library = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do
        inst[i] = v
    end
    return inst
end

local function Tween(obj, props, t)
    TweenService:Create(
        obj,
        TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    ):Play()
end

--/////////////////////////////////////////////////////
--// WINDOW POLISH WRAPPER (call after CreateWindow)
--/////////////////////////////////////////////////////
function Library:EnablePolish(Window)

    local Main = Window.Instance
    local Sidebar = Window.Sidebar

    --/////////////////////////////////////////////////////
    -- SEARCH BAR (TOP SIDEBAR)
    --/////////////////////////////////////////////////////
    local Search = Create("TextBox", {
        Size = UDim2.new(1, -10, 0, 28),
        Position = UDim2.fromOffset(5, 5),
        BackgroundColor3 = self.Theme.Tertiary,
        PlaceholderText = "Search...",
        Text = "",
        TextColor3 = self.Theme.Text,
        PlaceholderColor3 = self.Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = Sidebar
    })

    Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Search})

    --/////////////////////////////////////////////////////
    -- TAB HIGHLIGHT SYSTEM
    --/////////////////////////////////////////////////////
    local function updateTabVisual(tab, active)
        if active then
            Tween(tab.Button, {BackgroundColor3 = self.Theme.Accent}, 0.2)
            Tween(tab.Button, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.2)
        else
            Tween(tab.Button, {BackgroundColor3 = self.Theme.Tertiary}, 0.2)
            Tween(tab.Button, {TextColor3 = self.Theme.Text}, 0.2)
        end
    end

    for i, tab in ipairs(Window.Tabs) do
        local t = tab

        tab.Button.MouseButton1Click:Connect(function()
            for _, other in ipairs(Window.Tabs) do
                other.Page.Visible = false
                updateTabVisual(other, false)
            end

            t.Page.Visible = true
            updateTabVisual(t, true)
        end)

        -- default state
        if i == 1 then
            updateTabVisual(tab, true)
        else
            updateTabVisual(tab, false)
        end
    end

    --/////////////////////////////////////////////////////
    -- HOVER ANIMATIONS (GLOBAL POLISH)
    --/////////////////////////////////////////////////////
    local function addHover(obj)
        if obj:IsA("TextButton") then
            obj.MouseEnter:Connect(function()
                Tween(obj, {BackgroundColor3 = self.Theme.Secondary}, 0.15)
            end)

            obj.MouseLeave:Connect(function()
                Tween(obj, {BackgroundColor3 = self.Theme.Tertiary}, 0.15)
            end)
        end
    end

    for _, obj in ipairs(Main:GetDescendants()) do
        if obj:IsA("TextButton") then
            addHover(obj)
        end
    end

    Main.DescendantAdded:Connect(function(obj)
        task.wait()
        if obj:IsA("TextButton") then
            addHover(obj)
        end
    end)

    --/////////////////////////////////////////////////////
    -- OPEN ANIMATION (SMOOTH POP-IN)
    --/////////////////////////////////////////////////////
    Main.Size = UDim2.fromOffset(0, 0)
    Main.BackgroundTransparency = 1

    Tween(Main, {Size = UDim2.fromOffset(700, 450)}, 0.35)
    Tween(Main, {BackgroundTransparency = 0}, 0.35)

end

--/////////////////////////////////////////////////////
--// FINAL API WRAPPER (clean usage)
--/////////////////////////////////////////////////////
function Library:Finish(Window)
    self:EnablePolish(Window)
    return Window
end

return Library
