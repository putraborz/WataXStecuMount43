-- LEXHOST Loader - Cyber Blue Edition (Final)
-- Paste ini ke LocalScript di StarterGui
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- URL verifikasi dan loader (tetap seperti semula)
local urlVip = "https://raw.githubusercontent.com/putraborz/VerifikasiScWata/refs/heads/main/Loader/vip.txt"
local urlSatuan = "https://raw.githubusercontent.com/putraborz/VerifikasiScWata/refs/heads/main/Loader/10.txt"

local successUrls = {
    "https://raw.githubusercontent.com/putraborz/WataXMountAtin/main/Loader/WataX.lua",
    "https://raw.githubusercontent.com/putraborz/WataXStecuMount43/refs/heads/main/Loader/mainmap672.lua"
}

local TIKTOK_LINK = "https://www.tiktok.com/"
local DISCORD_LINK = "https://discord.gg/"

-- helper fetch
local function fetch(url)
    local ok, res = pcall(function()
        return game:HttpGet(url, true)
    end)
    return ok and res or nil
end

-- cek daftar verifikasi
local function isVerified(uname)
    local vip = fetch(urlVip)
    local sat = fetch(urlSatuan)
    if not vip or not sat then return false end
    uname = uname:lower()
    local function checkList(list)
        for line in list:gmatch("[^\r\n]+") do
            local nameOnly = line:match("^(.-)%s*%-%-") or line
            nameOnly = nameOnly:match("^%s*(.-)%s*$")
            if nameOnly:lower() == uname then
                return true
            end
        end
        return false
    end
    return checkList(vip) or checkList(sat)
end

-- small notification wrapper
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "LEXHOST",
            Text = text or "",
            Duration = duration or 4
        })
    end)
end

-- add blur background
local blur
do
    blur = Instance.new("BlurEffect")
    blur.Name = "LEXHOST_Blur"
    blur.Size = 18
    blur.Parent = Lighting
end

-- main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LEXHOST_Load"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- container frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 230)
frame.Position = UDim2.new(0.5, -180, 0.5, -115)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(18, 24, 34) -- very dark
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 14)

-- neon stroke (border)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Transparency = 0.15

-- subtle panel glow (ImageLabel used as glow layer)
local glow = Instance.new("ImageLabel", frame)
glow.Name = "Glow"
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.Position = UDim2.new(0.5, 0, 0.5, 0)
glow.Size = UDim2.new(1.15, 0, 1.15, 0)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://243660447" -- generic soft gradient circle (works as subtle glow)
glow.ImageTransparency = 0.9
glow.ZIndex = 0

-- header / title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.Text = "LEXHOST"
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(130, 220, 255)
title.TextStrokeTransparency = 0.75
title.ZIndex = 2

-- title glow stroke for pulsing
local titleStroke = Instance.new("UIStroke", title)
titleStroke.Thickness = 1.6
titleStroke.Color = Color3.fromRGB(0, 170, 255)
titleStroke.Transparency = 0.3

-- avatar
local avatar = Instance.new("ImageLabel", frame)
avatar.Size = UDim2.new(0, 72, 0, 72)
avatar.Position = UDim2.new(0, 26, 0, 56)
avatar.BackgroundTransparency = 1
avatar.ZIndex = 2
avatar.Image = "rbxassetid://112840507" -- fallback while fetching

-- avatar rounded
local avtCorner = Instance.new("UICorner", avatar)
avtCorner.CornerRadius = UDim.new(0, 12)

-- username
local uname = Instance.new("TextLabel", frame)
uname.Position = UDim2.new(0, 112, 0, 70)
uname.Size = UDim2.new(1, -128, 0, 28)
uname.BackgroundTransparency = 1
uname.Font = Enum.Font.GothamBold
uname.TextSize = 20
uname.TextColor3 = Color3.fromRGB(220, 240, 255)
uname.TextXAlignment = Enum.TextXAlignment.Left
uname.ZIndex = 2
uname.Text = player.Name

-- status
local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 24, 0, 136)
status.Size = UDim2.new(1, -48, 0, 22)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(170, 190, 210)
status.Text = "Klik tombol Verifikasi untuk melanjutkan..."
status.ZIndex = 2

-- buttons container
local btnRow = Instance.new("Frame", frame)
btnRow.Size = UDim2.new(0.88, 0, 0, 40)
btnRow.Position = UDim2.new(0.06, 0, 1, -54)
btnRow.BackgroundTransparency = 1
btnRow.ZIndex = 2

-- button factory with glow & hover
local function newBtn(parent, text, baseColor, size, pos)
    local b = Instance.new("TextButton", parent)
    b.Size = size
    b.Position = pos
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(230,230,230)
    b.BackgroundColor3 = baseColor
    b.AutoButtonColor = false
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,8)

    -- glow layer (ImageLabel)
    local g = Instance.new("ImageLabel", b)
    g.Name = "Glow"
    g.AnchorPoint = Vector2.new(0.5, 0.5)
    g.Position = UDim2.new(0.5, 0, 0.5, 0)
    g.Size = UDim2.new(1.2, 0, 1.6, 0)
    g.BackgroundTransparency = 1
    g.Image = "rbxassetid://243660447"
    g.ImageTransparency = 0.95
    g.ZIndex = 0

    -- stroke
    local bs = Instance.new("UIStroke", b)
    bs.Thickness = 1.4
    bs.Color = Color3.fromRGB(0, 150, 220)
    bs.Transparency = 0.35

    -- hover animations
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = baseColor + Color3.new(0.06,0.06,0.06)}):Play()
        TweenService:Create(g, TweenInfo.new(0.25), {ImageTransparency = 0.6}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = baseColor}):Play()
        TweenService:Create(g, TweenInfo.new(0.25), {ImageTransparency = 0.95}):Play()
    end)
    return b
end

local tiktokBtn = newBtn(btnRow, "TikTok", Color3.fromRGB(40, 40, 60), UDim2.new(0.18, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local verifyBtn = newBtn(btnRow, "Verifikasi", Color3.fromRGB(0, 140, 230), UDim2.new(0.56, 0, 1, 0), UDim2.new(0.21, 0, 0, 0))
local discordBtn = newBtn(btnRow, "Discord", Color3.fromRGB(34, 45, 80), UDim2.new(0.18, 0, 1, 0), UDim2.new(0.79, 0, 0, 0))

-- close button (top-right)
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(205, 60, 60)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.ZIndex = 3
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

-- avatar fetch & fade-in
task.spawn(function()
    local ok, img = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420)
    end)
    if ok and img then
        avatar.Image = img
    else
        avatar.Image = "rbxassetid://112840507"
    end
    avatar.ImageTransparency = 1
    TweenService:Create(avatar, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {ImageTransparency = 0}):Play()
end)

-- title pulsing glow (tint)
task.spawn(function()
    while frame.Parent do
        TweenService:Create(titleStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0}):Play()
        TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.85}):Play()
        task.wait(1.2)
        TweenService:Create(titleStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play()
        TweenService:Create(glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.95}):Play()
        task.wait(1.2)
    end
end)

-- border RGB animation (cyber blue subtle)
task.spawn(function()
    local h = 0
    while frame.Parent do
        h = (h + 0.006) % 1
        local c = Color3.fromHSV(0.55 + 0.05*math.sin(h*6.28), 0.8, 0.95)
        stroke.Color = c
        task.wait(0.03)
    end
end)

-- button clipboard helper
local function copyToClipboard(link)
    if setclipboard then
        pcall(setclipboard, link)
        notify("LEXHOST", "Link disalin ke clipboard", 3)
        return true
    else
        notify("LEXHOST", "Executor tidak mendukung clipboard", 3)
        print("Manual link:", link)
        return false
    end
end

-- button actions
tiktokBtn.MouseButton1Click:Connect(function()
    local ok = copyToClipboard(TIKTOK_LINK)
    status.Text = ok and "✅ Link TikTok disalin!" or "⚠️ Gagal menyalin. Cek console."
    task.delay(2, function() if status and status.Parent then status.Text = "Klik tombol Verifikasi untuk melanjutkan..." end end)
end)

discordBtn.MouseButton1Click:Connect(function()
    local ok = copyToClipboard(DISCORD_LINK)
    status.Text = ok and "✅ Link Discord disalin!" or "⚠️ Gagal menyalin. Cek console."
    task.delay(2, function() if status and status.Parent then status.Text = "Klik tombol Verifikasi untuk melanjutkan..." end end)
end)

-- close behaviour
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    if blur and blur.Parent then blur:Destroy() end
    task.wait(0.28)
    gui:Destroy()
end)

-- verification routine (kept as original logic)
local function doVerify()
    status.Text = "🔍 Memeriksa daftar pengguna..."
    verifyBtn.Active = false

    local ok, result = pcall(function()
        return isVerified(player.Name)
    end)
    verifyBtn.Active = true

    if not ok then
        status.Text = "⚠️ Error saat memeriksa."
        notify("LEXHOST", "Gagal memeriksa daftar (error).", 4)
        return
    end

    if result then
        status.Text = "✅ Terdaftar — Pengguna LEXHOST..."
        _G.LEXHOST_Access = true
        task.wait(0.8)

        for _, url in ipairs(successUrls) do
            pcall(function()
                loadstring(game:HttpGet(url))()
            end)
        end

        TweenService:Create(frame, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()
        task.wait(0.45)
        if blur and blur.Parent then blur:Destroy() end
        gui:Destroy()
    else
        status.Text = "❌ Kamu belum terdaftar di LEXHOST."
        _G.LEXHOST_Access = false
        notify("LEXHOST", "Akses ditolak — belum terdaftar.", 4)
    end
end

verifyBtn.MouseButton1Click:Connect(doVerify)

-- subtle entrance animation for entire frame + glow pop
frame.BackgroundTransparency = 1
frame.Size = UDim2.new(0, 340, 0, 220)
frame.Position = UDim2.new(0.5, -180, 0.5, -135)
TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -180, 0.5, -115),
    BackgroundTransparency = 0
}):Play()
TweenService:Create(glow, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {ImageTransparency = 0.92}):Play()

-- Particles (small floating dots) — lightweight, parented to gui, random subtle movement
for i = 1, 18 do
    local p = Instance.new("Frame", gui)
    p.Size = UDim2.new(0, math.random(2,4), 0, math.random(2,4))
    p.BackgroundTransparency = 0.25
    p.BorderSizePixel = 0
    p.ZIndex = 1
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundColor3 = Color3.fromHSV(0.55 + math.random()*0.05, 0.7, 0.9)
    task.spawn(function()
        while p.Parent do
            local nx = math.clamp(math.random(), 0.02, 0.98)
            local ny = math.clamp(math.random(), 0.02, 0.98)
            TweenService:Create(p, TweenInfo.new(6 + math.random()*4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(nx, 0, ny, 0),
                BackgroundTransparency = 0.4 + math.random()*0.4
            }):Play()
            task.wait(4 + math.random()*5)
        end
    end)
end

-- Cleanup if player leaves (safe)
player.AncestryChanged:Connect(function()
    if not player:IsDescendantOf(game) then
        if blur and blur.Parent then blur:Destroy() end
        if gui and gui.Parent then gui:Destroy() end
    end
end)
