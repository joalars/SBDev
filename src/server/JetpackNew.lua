script.Parent = __jetpack
print("Jetpack - Server")
print("By joalars2")

local plr
local tweenService = game:GetService("TweenService")

repeat
	for i,v in pairs(game:GetService("Players"):GetChildren()) do
		plr = v
	end
	task.wait()
until plr ~= nil and plr.Character

local runLocal

function rct(a)
	--print("[RCT]: Processing "..a:GetFullName())
	for i,v in pairs(a:GetChildren()) do
		--print("[RCT]: Scanning - "..v.Name)
		if (v.Name == "UpperTorso" or v.Name == "Torso") and v:IsA("BasePart") then
			--print("[RCT]: Successfully Identified: "..v.Name)
			return v
		end
	end
	--print("[RCT]: Search failed. Invalid character.")
	return nil
end

function ins(t,vars)
	local i = Instance.new(t)
	local errored
	for _,v in pairs(vars) do
		xpcall(function()
			i[v[1]] = v[2]
		end,function()
			warn("[INS]: Errored at ("..t..") while setting variable ("..v[1]..")")
		end)
	end
	return i
end

function weld(a,b,c0,c1)
	local w = ins("Weld",{
		{"Part0",a},
		{"Part1",b},
		{"C0",c0 or CFrame.new(0,0,0)},
		{"C1",c1 or CFrame.new(0,0,0)},
		{"Name","Weld: "..a.Name.." - "..b.Name}
	})
	return w
end

function generate(plr)

	for i,v in pairs(plr.Character:GetChildren()) do
		if v.Name == "Jetpack" then
			v:Destroy()
		end
	end

	local trs = rct(plr.Character)

	local container = ins("Model",{
		{"Name","Jetpack"},
		{"Parent",trs.Parent}
	})

	local p1 = ins("Part", {
		{"Size",Vector3.new(1.25,1.7,0.2)},
		{"Position",Vector3.new(0,5,0)},
		{"CanCollide",false},
		{"TopSurface",Enum.SurfaceType.Smooth},
		{"BottomSurface",Enum.SurfaceType.Smooth},
		{"Material",Enum.Material.SmoothPlastic},
		{"Anchored",true},
		{"Parent",container}
	})

	local p2 = ins("Part", {
		{"Shape",Enum.PartType.Cylinder},
		{"Size", Vector3.new(1.7,0.2,0.2)},
		{"CanCollide",false},
		{"Material",Enum.Material.SmoothPlastic},
		{"TopSurface",Enum.SurfaceType.Smooth},
		{"BottomSurface",Enum.SurfaceType.Smooth},
		{"Parent", container}
	})

	local p3 = p2:Clone()
	p3.Parent = container
	
	local p4 = ins("Part",{
		{"Size",Vector3.new(0.2,0.2,0.2)},
		{"Transparency",1},
		{"CanCollide",false},
		{"Parent",container}
	})
	
	local p5 = ins("Part",{
		{"Size",Vector3.new(0.2,0.2,0.2)},
		{"Transparency",1},
		{"CanCollide",false},
		{"Parent",container}
	})
	print("Making particle emitters...")
	local f1 = ins("ParticleEmitter",{
		{"Size",
		NumberSequence.new(
			{
				NumberSequenceKeypoint.new(0,0.188,0.175),
				NumberSequenceKeypoint.new(0.596,0,0),
				NumberSequenceKeypoint.new(1,0.25,0)
			}
		)},
		{"Color",
		ColorSequence.new(
			{
				ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
				ColorSequenceKeypoint.new(0.1,Color3.fromRGB(255,155,0)),
				ColorSequenceKeypoint.new(0.277,Color3.fromRGB(251,255,0)),
				ColorSequenceKeypoint.new(0.765,Color3.fromRGB(168,168,168)),
				ColorSequenceKeypoint.new(1,Color3.fromRGB(171,171,171))
			}
		)},
		{"LightEmission",0.45},
		{"Texture","rbxasset://textures/particles/smoke_main.dds"},
		{"Transparency",
		NumberSequence.new(
			{
				NumberSequenceKeypoint.new(0,0,0),
				NumberSequenceKeypoint.new(0.671,0,0),
				NumberSequenceKeypoint.new(1,1,0)
			}
		)},
		{"Rate",500},
		{"Lifetime",NumberRange.new(0.5)},
		{"RotSpeed",NumberRange.new(-50,50)},
		{"Speed",NumberRange.new(4)},
		{"SpreadAngle",Vector2.new(-3,3)},
		{"Enabled",false},
		{"Parent",p4}
	})
	print("Emitter1")
	
	local f2 = f1:Clone()
	f2.Parent = p5
	print("Emitter2")
	
	local song = ins("Sound",{
		{"SoundId","rbxassetid://12697958247"}, --SONG
		{"Looped",true},
		{"Volume",5},
		{"Name","Song"},
		{"Parent",p1}
	})
	
	local tsound = ins("Sound",{
		{"SoundId","rbxassetid://12697962063"},
		{"Looped",true},
		{"Volume",4},
		{"Name","Thruster"},
		{"Pitch",((1/64)*0.25)*20 + 0.5},
		{"Parent",p1}
	})

	local w1 = weld(trs,p1,CFrame.new(0,0,0.7),CFrame.new(0,0,0))
	w1.Parent = p1

	local w2 = weld(p1,p2,CFrame.new(1.25/2,0,0),CFrame.new(0,0,0) * CFrame.Angles(0,0,math.pi/2))
	w2.Parent = p2

	local w3 = weld(p1,p3,CFrame.new(-1.25/2,0,0),CFrame.new(0,0,0) * CFrame.Angles(0,0,math.pi/2))
	w3.Parent = p3
	
	local w4 = weld(p1,p4,CFrame.new(-1.25/2,-1.7/2,0),CFrame.new(0,0,0) * CFrame.Angles(math.pi,0,0))
	w4.Parent = p4
	
	local w5 = weld(p1,p5,CFrame.new(1.25/2,-1.7/2,0),CFrame.new(0,0,0) * CFrame.Angles(math.pi,0,0))
	w5.Parent = p5

	local display = ins("SurfaceGui",{
		{"Name","Display"},
		{"Adornee",p1},
		{"Face","Back"},
		{"Parent",container}
	})

	local speedBG = ins("Frame",{
		{"Name","SpeedBackground"},
		{"Size",UDim2.new(0.05,0,1,-25)},
		{"Position",UDim2.new(0,0,0,12.5)},
		{"BackgroundColor3",Color3.new(0,0,0)},
		{"BorderSizePixel",0},
		{"Parent",display}
	})

	local speedDis = ins("Frame",{
		{"Name","SpeedDisplay"},
		{"Size",UDim2.new(1,0,-0.25,0)},
		{"Position",UDim2.new(0,0,1,0)},
		{"BackgroundColor3",Color3.new(1,1,1)},
		{"BorderSizePixel",0},
		{"Parent",speedBG}
	})

	p1.Anchored = false
end

function enableSound(s,spd)
	local tweenInfo = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		0,
		false,
		0
	)

	local g = {}
	g.Pitch = ((1/64)*spd/64)*20 + 0.5

	s.Pitch = 0

	local newTween = tweenService:Create(s,tweenInfo,g)
	s:Play()
	newTween:Play()
end

function disableSound(s,spd)
	local tweenInfo = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		0,
		false,
		0
	)

	local sm = ((1/64)*spd/64)*20 + 0.5

	local g = {}
	g.Pitch = 0

	local newTween = tweenService:Create(s,tweenInfo,g)
	newTween:Play()
	local c
	c = newTween.Completed:Connect(function()
		c:Disconnect()
		if s.Pitch == 0 then
			s:Stop()
			s.Pitch = sm
		end
	end)
end

local jetpackEvent

local eventHandler

function restoreEvent()
	if jetpackEvent == nil then
		jetpackEvent = ins("RemoteEvent",{
			{"Name","jetpackEvent"},
			{"Parent",owner}
		})
		if eventHandler then
			eventHandler:Disconnect()
		end
		eventHandler = jetpackEvent.OnServerEvent:Connect(function(plr,t,p,a)
			xpcall(function()
				--print("Message received")
				--print(t)
				--print("Signal: "..t)
				if t == "Generate" then
					generate(plr)
				end
				if t == "Speed" then
					if p.Parent == plr.Character then
						p.Display.SpeedBackground.SpeedDisplay.Size = UDim2.new(1,0,a,0)
						for i,v in pairs(p:GetChildren()) do
							local f = v:FindFirstChild("Thruster")
							if f then
								f.Pitch = ((1/64)*-a)*20 + 0.5
							end
						end
					else
						error()
					end
				end
				if t == "Flying" then
					--print("Flying signal")
					if p.Parent == plr.Character then
						--print("Valid player")
						if a[1] == true then
							--print("True")
							for i,v in pairs(p:GetChildren()) do
								local f = v:FindFirstChild("Fire")
								if f then
									--print("Fire")
									f.Enabled = true
								end
								local f = v:FindFirstChild("Thruster")
								if f then
									enableSound(f,a[2])
								end
							end
						else
							--print("False")
							for i,v in pairs(p:GetChildren()) do
								local f = v:FindFirstChild("Fire")
								if f then
									--print("Fire")
									f.Enabled = false
								end
								local f = v:FindFirstChild("Thruster")
								if f then
									disableSound(f,a[2])
								end
							end
						end
					end
				end
				if t == "Turbo" then
					if p.Parent == plr.Character then
						if a == true then
							for i,v in pairs(p:GetChildren()) do
								local f = v:FindFirstChild("Song")
								if f then
									f:Play()
								end
							end
						else
							for i,v in pairs(p:GetChildren()) do
								local f = v:FindFirstChild("Song")
								if f then
									f:Stop()
								end
							end
						end
					end
				end
			end,function()
				warn("[EventHandler]: Faulty request received, tossing.")
			end)
		end)
	elseif jetpackEvent.Parent ~= owner then
		jetpackEvent.Parent = owner
	elseif jetpackEvent.Name ~= "jetpackEvent" then
		jetpackEvent.Name = "jetpackEvent"
	end
end

local temp = owner:FindFirstChild("jetpackEvent")
if temp then
	temp:Destroy()
	temp = nil
end

NLS([[
	print("Jetpack - Local")

task.wait()

local uis = game:GetService("UserInputService")

local plr = game:GetService("Players").LocalPlayer

script.Parent = plr

local speed = 16
local maxSpeed = 64

local increasing = false
local decreasing = false
local changed = false
local turbo = false

local inctrg = os.clock()
local inc = os.clock()

local onGround = true
local flying = false

local flycd = 0.3
local flycdcur = 0

local hovering = false
local hoverPoint = nil

local stunned = false
local stunnedFrames = 0
local stunDuration = 2.5

local cd = 0.05

local p,s

local attach

local alignOrientation
local alignPosition

local died
local rs

function generate(c)

	onGround = true
	flying = false
	turbo = false
	hovering = false
	
	local rp = c:WaitForChild("HumanoidRootPart")

	attach = Instance.new("Attachment")
	attach.Parent = rp
	attach.CFrame = CFrame.new(0,0,0)

	if alignOrientation ~= nil then
		alignOrientation:Destroy()
	end

	if alignPosition ~= nil then
		alignPosition:Destroy()
	end

	increasing = false
	decreasing = false
	changed = false
	turbo = false
	onGround = true
	flying = false
	hovering = false
	stunned = false

	alignOrientation = Instance.new("AlignOrientation",rp)
	alignOrientation.Attachment0 = attach
	alignOrientation.AlignType = Enum.AlignType.Parallel
	alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOrientation.Responsiveness = 15

	alignPosition = Instance.new("AlignPosition",rp)
	alignPosition.Attachment0 = attach
	alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	alignPosition.Enabled = false
	alignPosition.MaxForce = math.huge
	alignPosition.MaxVelocity = speed

	died = c.Humanoid.Died:Connect(function()
		died:Disconnect()
		--rs:Disconnect()
	end)
end

repeat task.wait() until plr.Character

generate(plr.Character)

function sendServerEvent(t,p,a)
	local event = game:GetService("Players").LocalPlayer:FindFirstChild("jetpackEvent")
	if event then
		event:FireServer(t,p,a)
	else
		warn("[Jetpack Local]: Event not found")
	end
end

uis.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed == false then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.R then
				--print("+R")
				increasing = true
			elseif input.KeyCode == Enum.KeyCode.F then
				--print("+F")
				decreasing = true
			elseif input.KeyCode == Enum.KeyCode.Space then
				--print("+Space")
				if flycdcur <= 0 then
					if onGround == false and flying == false then
						flying = true
						sendServerEvent("Flying",p,{true,speed})
						flycdcur = flycd
						--print("+Flying")
					elseif flying == true then
						flying = false
						turbo = false
						sendServerEvent("Flying",p,{false,speed})
						flycdcur = flycd
						sendServerEvent("Turbo",p,false)
						plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
						--print("-Flying")
					end
				end
			elseif input.KeyCode == Enum.KeyCode.T then
				if flying == true and hovering == false then
					turbo = true
					sendServerEvent("Turbo",p,true)
				end
			end
		end
	end
end)

uis.InputEnded:Connect(function(input,gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.R then
			--print("-R")
			increasing = false
		elseif input.KeyCode == Enum.KeyCode.F then
			--print("-F")
			decreasing = false
		elseif input.KeyCode == Enum.KeyCode.Space then
			--print("-Space")
		elseif input.KeyCode == Enum.KeyCode.T then
			turbo = false
			sendServerEvent("Turbo",p,false)
		end
	end
end)

function findJetpackComps(plr)
	local chr = plr.Character
	if chr then
		local pack = chr:FindFirstChild("Jetpack")
		if pack then
			local sgui = pack:FindFirstChildOfClass("SurfaceGui")
			if sgui then
				local bgfrm = sgui:FindFirstChildOfClass("Frame")
				if bgfrm then
					local spfrm = bgfrm:FindFirstChildOfClass("Frame")
					if spfrm then
						return pack,spfrm
					end
				end
			end
			return pack,nil
		end
	end
	return nil
end

local f = 0
rs = game:GetService("RunService").RenderStepped:Connect(function(delta)

	f = f + 1

	if flycdcur > 0 then
		flycdcur = flycdcur - delta
		if flycdcur < 0 then
			flycdcur = 0
		end
	end

	if stunned == true then
		stunnedFrames = stunnedFrames + delta
	end

	inc = inc + delta

	if onGround and flying == true then
		flying = false
		turbo = false
		sendServerEvent("Flying",p,{false,speed})
		sendServerEvent("Turbo",p,false)
	end

	if flying == true then
		if speed > 2 then
			plr.Character.Humanoid.PlatformStand = true
			alignOrientation.Enabled = true
			alignPosition.Enabled = true
			hovering = false
			hoverPoint = nil
		else
			plr.Character.Humanoid.PlatformStand = true
			alignOrientation.Enabled = true
			alignPosition.Enabled = true
			plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			hovering = true
			if hoverPoint == nil then
				hoverPoint = plr.Character.HumanoidRootPart.Position
				if turbo == true then
					turbo = false
					sendServerEvent("Turbo",p,false)
				end
			end
		end
	else
		hovering = false
		hoverPoint = nil
		plr.Character.Humanoid.PlatformStand = false
		alignOrientation.Enabled = false
		alignPosition.Enabled = false
	end

	alignOrientation.CFrame = workspace.CurrentCamera.CFrame.Rotation * CFrame.Angles(-math.pi/2,0,0)

	if hovering == false then
		alignPosition.Position = plr.Character.HumanoidRootPart.CFrame.p + plr.Character.HumanoidRootPart.CFrame.UpVector * 100
	else
		alignPosition.Position = hoverPoint + Vector3.new(math.sin(f*0.003)*1.5,math.cos(f*0.001)*1.5,math.sin(f*0.002)*1.5)
		alignOrientation.CFrame = workspace.CurrentCamera.CFrame.Rotation * CFrame.Angles(0,0,0)
	end

	if turbo == false then
		alignPosition.MaxVelocity = speed
		alignOrientation.RigidityEnabled = false
	else
		alignPosition.MaxVelocity = maxSpeed * 4
		alignOrientation.RigidityEnabled = true
	end

	if inctrg <= inc then
		inctrg = inc + cd
		--print("SendingTriggered")
		p,s = findJetpackComps(plr)
		if p then
			--print(changed)
			if changed == true and flycdcur <= 0 then
				--print("UPDATED")
				sendServerEvent("Speed",p,-speed/maxSpeed)
				changed = false
			end
		end
	end

	if flycdcur <= 0 then
		if increasing == true then
			speed = speed + delta * 35
			changed = true
			if speed > maxSpeed then
				speed = maxSpeed
			end
		end
		if decreasing == true then
			speed = speed - delta * 35
			changed = true
			if speed < 1 then
				speed = 1
			end
		end
	end

	if p then
		if s then
			s.Size = UDim2.new(1,0,-speed/maxSpeed,0)
		end
	end

	if hovering == false then

		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {plr.Character}
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		rayParams.IgnoreWater = true
		rayParams.RespectCanCollide = true

		if flying == false then
			local rayResult = workspace:Raycast(plr.Character.HumanoidRootPart.CFrame.p, Vector3.new(0, -4.5, 0), rayParams)
			if rayResult then
				onGround = true
			else
				onGround = false
			end
		else
			local rayResult = workspace:Raycast(plr.Character.HumanoidRootPart.CFrame.p, plr.Character.HumanoidRootPart.CFrame.UpVector*4.5, rayParams)
			if rayResult then
				onGround = true
				flying = false
				turbo = false
				hovering = false
				sendServerEvent("Flying",p,{false,speed})
				sendServerEvent("Turbo",p,false)
				stunned = true
				stunnedFrames = 0
			else
				onGround = false
			end
		end
	end

	if stunned == true and stunnedFrames < stunDuration then
		plr.Character.Humanoid.PlatformStand = true
	elseif stunned == true and stunnedFrames >= stunDuration then
		stunned = false
		plr.Character.Humanoid.PlatformStand = false
		plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end)

plr.CharacterAdded:Connect(function(c)

	repeat task.wait() until c.HumanoidRootPart

	generate(c)
	sendServerEvent("Generate")

	p,s = findJetpackComps(plr)
end)

repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("jetpackEvent")

sendServerEvent("Generate")

repeat task.wait() until plr.Character:FindFirstChild("Jetpack")

p,s = findJetpackComps(plr)

while task.wait(0.5) do end
]])

while task.wait() do
	restoreEvent()
end