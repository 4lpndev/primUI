# primUI Documentation

## Overview

**primUI** is a lightweight Roblox Lua UI library designed for creating modern animated interfaces.

Features:

- Custom window creation
- Sidebar tab navigation
- Groupboxes
- Buttons
- Toggles
- Sliders
- Dropdown menus
- Keybind selectors
- Color picker
- Notifications
- Search bar
- Hover animations
- Open animations
- Drag support

---

# Installation

Load primUI using `loadstring`:

```lua
local primUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/4lpndev/primUI/refs/heads/main/primo.lua"
))()
```

---

# Theme

primUI includes a built-in theme system.

```lua
primUI.Theme
```

Default properties:

| Property | Description |
|---|---|
| Background | Main window color |
| Secondary | Panel colors |
| Tertiary | Control backgrounds |
| Accent | Highlight color |
| Text | Main text color |
| SubText | Secondary text color |

Example:

```lua
primUI.Theme.Accent = Color3.fromRGB(255, 0, 0)
```

---

# Window

## CreateWindow

Creates the main UI window.

### Syntax

```lua
local Window = primUI:CreateWindow({
    Name = "My Script"
})
```

### Parameters

| Parameter | Type | Description |
|---|---|---|
| Name | string | Window title |

### Returns

A window object.

---

# Tabs

Tabs separate different UI sections.

## Create Tab

```lua
local Tab = primUI:Tab(
    Window,
    "Combat"
)
```

Example:

```lua
local Combat = primUI:Tab(
    Window,
    "Combat"
)

local Visuals = primUI:Tab(
    Window,
    "Visuals"
)
```

---

# Groupboxes

Groupboxes organize UI elements.

## Create Groupbox

```lua
local Group = primUI:Groupbox(
    Tab,
    "Settings"
)
```

Example:

```lua
local Settings = primUI:Groupbox(
    Combat,
    "Combat Settings"
)
```

---

# Elements

## Button

Creates a clickable button.

### Syntax

```lua
primUI:Button(
    Group,
    Text,
    Callback
)
```

### Example

```lua
primUI:Button(
    Settings,
    "Execute",
    function()
        print("Pressed")
    end
)
```

---

# Toggle

Creates an on/off switch.

## Syntax

```lua
primUI:Toggle(
    Group,
    Text,
    Default,
    Callback
)
```

### Example

```lua
primUI:Toggle(
    Settings,
    "Enabled",
    false,
    function(state)
        print(state)
    end
)
```

Callback:

```lua
true
false
```

---

# Slider

Creates a draggable value slider.

## Syntax

```lua
local Slider = primUI:Slider(
    Group,
    Text,
    Minimum,
    Maximum,
    Default,
    Callback
)
```

### Example

```lua
local Speed = primUI:Slider(
    Settings,
    "Speed",
    0,
    100,
    50,
    function(value)
        print(value)
    end
)
```

## Methods

### Get

Returns the current value.

```lua
Speed:Get()
```

### Set

Changes the current value.

```lua
Speed:Set(75)
```

---

# Dropdown

Creates a selectable list.

## Syntax

```lua
primUI:Dropdown(
    Group,
    Text,
    Options,
    Callback
)
```

### Example

```lua
primUI:Dropdown(
    Settings,
    "Weapon",
    {
        "AK47",
        "M4A1",
        "AWP"
    },
    function(choice)
        print(choice)
    end
)
```

---

# Keybind

Creates a key selector.

## Syntax

```lua
primUI:Keybind(
    Group,
    Text,
    DefaultKey,
    Callback
)
```

### Example

```lua
primUI:Keybind(
    Settings,
    "Menu Key",
    Enum.KeyCode.RightShift,
    function(key)
        print(key)
    end
)
```

---

# Colorpicker

Creates a color selection control.

## Syntax

```lua
primUI:Colorpicker(
    Group,
    Text,
    DefaultColor,
    Callback
)
```

### Example

```lua
primUI:Colorpicker(
    Settings,
    "ESP Color",
    Color3.fromRGB(255,0,0),
    function(color)
        print(color)
    end
)
```

---

# Notifications

Creates a temporary notification.

## Syntax

```lua
primUI:Notify(
    Message,
    Duration
)
```

### Example

```lua
primUI:Notify(
    "Loaded successfully!",
    5
)
```

Default duration:

```
3 seconds
```

---

# Window Enhancements

## EnablePolish

Adds extra UI effects.

```lua
primUI:EnablePolish(Window)
```

Includes:

- Search bar
- Hover animations
- Tab animations
- Open animation

---

# Finish

Finalizes the window.

```lua
primUI:Finish(Window)
```

---

# Complete Example

```lua
local primUI = loadstring(game:HttpGet(
    "YOUR_URL_HERE"
))()

local Window = primUI:CreateWindow({
    Name = "Example Hub"
})

local Main = primUI:Tab(
    Window,
    "Main"
)

local Settings = primUI:Groupbox(
    Main,
    "Settings"
)

primUI:Toggle(
    Settings,
    "Enabled",
    false,
    function(value)
        print(value)
    end
)

primUI:Button(
    Settings,
    "Test Button",
    function()
        primUI:Notify(
            "Hello World!",
            3
        )
    end
)

local Slider = primUI:Slider(
    Settings,
    "Amount",
    1,
    100,
    50,
    function(value)
        print(value)
    end
)

primUI:Finish(Window)
```

---

# API Reference

| Function | Description |
|---|---|
| `CreateWindow()` | Creates a window |
| `Tab()` | Creates a tab |
| `Groupbox()` | Creates a groupbox |
| `Button()` | Creates a button |
| `Toggle()` | Creates a toggle |
| `Slider()` | Creates a slider |
| `Dropdown()` | Creates a dropdown |
| `Keybind()` | Creates a keybind |
| `Colorpicker()` | Creates a color picker |
| `Notify()` | Creates a notification |
| `EnablePolish()` | Adds UI effects |
| `Finish()` | Finalizes the UI |

---

# Credits

Created by **4lpndev**

Library: **primUI**