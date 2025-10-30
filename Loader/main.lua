--// LEXHOST Loader - Premium Particle Edition ✨
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- URL data verifikasi & loader
local urlVip = "https://raw.githubusercontent.com/putraborz/VerifikasiScWata/refs/heads/main/Loader/vip.txt"
local urlSatuan = "https://raw.githubusercontent.com/putraborz/VerifikasiScWata/refs/heads/main/Loader/10.txt"

local successUrls = {
    "https://raw.githubusercontent.com/putraborz/WataXMountAtin/main/Loader/WataX.lua",
    "https://raw.githubusercontent.com/putraborz/WataXStecuMount43/refs/heads/main/Loader/mainmap672.lua"
}

local TIKTOK_LINK = "https://www.tiktok.com/"
local DISCORD_LINK = "https://discord.gg/"

-- Helper untuk fetch
local function fetch(url)
	local ok, res = pcall(function()
		return game:HttpGet(url, true)
	end)
	return ok and res or nil
end

-- Cek verifikasi
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

-- Notifikasi
local function notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title or "LEXHOST",
			Text = text or "",
			Duration = duration or 4
		})
	end)
end

-- Blur latar
local blur = Instance.new("BlurEffect")
blur.Size = 20
blur.Parent = Lighting

-- GUI utama
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "LEXHOSTLoader"
gui.ResetOnSpawn = false

-- Frame utama
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 220)
frame.Position = UDim2.new(0.5, -170, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 0, 150)

TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
	BackgroundTransparency = 0
}):Play()

-- Logo LEXHOST
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "LEXHOST"
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(0, 255, 180)
title.TextSize = 26
title.TextStrokeTransparency = 0.8

-- Tombol tutup
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 18
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	blur:Destroy()
	task.wait(0.3)
	gui:Destroy()
end)

-- Avatar pemain
local avatar = Instance.new("ImageLabel", frame)
avatar.Size = UDim2.new(0, 64, 0, 64)
avatar.Position = UDim2.new(0, 25, 0, 52)
avatar.BackgroundTransparency = 1

task.spawn(function()
	local ok, img = pcall(function()
		return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100)
	end)
	avatar.Image = ok and img or "rbxassetid://112840507"
end)

-- Nama pemain
local uname = Instance.new("TextLabel", frame)
uname.Position = UDim2.new(0, 105, 0, 68)
uname.Size = UDim2.new(1, -120, 0, 28)
uname.BackgroundTransparency = 1
uname.Font = Enum.Font.GothamBold
uname.TextSize = 20
uname.TextColor3 = Color3.fromRGB(255, 255, 255)
uname.TextXAlignment = Enum.TextXAlignment.Left
uname.Text = player.Name

-- Status teks
local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 25, 0, 130)
status.Size = UDim2.new(1, -50, 0, 26)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Text = "Klik tombol verifikasi untuk lanjut..."

-- Tombol bar
local btnRow = Instance.new("Frame", frame)
btnRow.Size = UDim2.new(0.86, 0, 0, 38)
btnRow.Position = UDim2.new(0.07, 0, 1, -48)
btnRow.BackgroundTransparency = 1

local function newBtn(parent, text, color, size, pos)
	local b = Instance.new("TextButton", parent)
	b.Size = size
	b.Position = pos
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = color
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	b.AutoButtonColor = false
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1),0.15)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
	end)
	return b
end

local tiktokBtn = newBtn(btnRow, "TikTok", Color3.fromRGB(255, 50, 100), UDim2.new(0.18, 0, 1, 0), UDim2.new(0,0,0,0))
local verifyBtn = newBtn(btnRow, "Verifikasi", Color3.fromRGB(0, 200, 120), UDim2.new(0.56, 0, 1, 0), UDim2.new(0.22,0,0,0))
local discordBtn = newBtn(btnRow, "Discord", Color3.fromRGB(88, 101, 242), UDim2.new(0.18, 0, 1, 0), UDim2.new(0.82,0,0,0))

-- Salin link
local function copyToClipboard(link)
	if setclipboard then
		pcall(setclipboard, link)
		notify("LEXHOST", "Link disalin ke clipboard", 3)
		return true
	else
		notify("LEXHOST", "Executor tidak mendukung salin link", 4)
		print("Manual:", link)
		return false
	end
end

tiktokBtn.MouseButton1Click:Connect(function()
	local ok = copyToClipboard(TIKTOK_LINK)
	status.Text = ok and "✅ Link TikTok disalin!" or "⚠️ Gagal menyalin TikTok"
	task.delay(2, function() status.Text = "Klik tombol verifikasi untuk lanjut..." end)
end)

discordBtn.MouseButton1Click:Connect(function()
	local ok = copyToClipboard(DISCORD_LINK)
	status.Text = ok and "✅ Link Discord disalin!" or "⚠️ Gagal menyalin Discord"
	task.delay(2, function() status.Text = "Klik tombol verifikasi untuk lanjut..." end)
end)

-- Tombol verifikasi
local function doVerify()
	status.Text = "🔍 Memeriksa daftar pengguna..."
	verifyBtn.Active = false
	local ok, result = pcall(function()
		return isVerified(player.Name)
	end)
	verifyBtn.Active = true
	if not ok then
		status.Text = "⚠️ Error saat verifikasi."
		notify("LEXHOST", "Gagal memeriksa daftar.", 4)
		return
	end
	if result then
		status.Text = "✅ Kamu terdaftar sebagai pengguna LEXHOST!"
		_G.LEXHOST_Access = true
		task.wait(1)
		for _,url in ipairs(successUrls) do
			local ok2, err = pcall(function()
				loadstring(game:HttpGet(url))()
			end)
			if not ok2 then warn("Gagal load:", url, err) end
		end
		TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
		task.wait(0.5)
		blur:Destroy()
		gui:Destroy()
	else
		status.Text = "❌ Kamu belum terdaftar di LEXHOST"
		_G.LEXHOST_Access = false
		notify("LEXHOST", "❌ Akses ditolak. Kamu belum terdaftar.", 4)
	end
end
verifyBtn.MouseButton1Click:Connect(doVerify)

-- 🔥 Efek RGB berjalan
task.spawn(function()
	while frame.Parent do
		for i = 0, 1, 0.005 do
			local r = math.sin(6.28 * i) * 127 + 128
			local g = math.sin(6.28 * (i + 0.33)) * 127 + 128
			local b = math.sin(6.28 * (i + 0.66)) * 127 + 128
			stroke.Color = Color3.fromRGB(r, g, b)
			task.wait(0.03)
		end
	end
end)

-- ✨ Partikel cahaya melayang di sekitar frame
for i = 1, 25 do
	local particle = Instance.new("Frame", gui)
	particle.Size = UDim2.new(0, math.random(2,4), 0, math.random(2,4))
	particle.BackgroundColor3 = Color3.fromRGB(math.random(100,255), math.random(100,255), math.random(255))
	particle.BorderSizePixel = 0
	particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
	particle.BackgroundTransparency = 0.2
	task.spawn(function()
		while particle.Parent do
			local newX = math.random()
			local newY = math.random()
			TweenService:Create(particle, TweenInfo.new(math.random(5,10), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(newX, 0, newY, 0),
				BackgroundTransparency = math.random() * 0.6
			}):Play()
			task.wait(math.random(4,8))
		end
	end)
end
