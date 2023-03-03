print("Jetpack - Local")

local uis = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")

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

	attach = Instance.new("Attachment")
	attach.Parent = c.HumanoidRootPart
	attach.CFrame = CFrame.new(0,0,0)

	alignOrientation = Instance.new("AlignOrientation",c.HumanoidRootPart)
	alignOrientation.Attachment0 = attach
	alignOrientation.AlignType = Enum.AlignType.Parallel
	alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOrientation.Responsiveness = 15

	alignPosition = Instance.new("AlignPosition",c.HumanoidRootPart)
	alignPosition.Attachment0 = attach
	alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	alignPosition.Enabled = false
	alignPosition.MaxForce = math.huge
	alignPosition.MaxVelocity = speed

	died = c.Humanoid.Died:Connect(function()
		died:Disconnect()
		rs:Disconnect()
	end)
end

generate(plr.Character)

function sendServerEvent(t,p,a)
	local event = replicatedStorage:FindFirstChild("jetpackEvent")
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
				if onGround == false then
					flying = true
					sendServerEvent("Flying",p,true)
					--print("+Flying")
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
			if flying == true then
				flying = false
				turbo = false
				sendServerEvent("Flying",p,false)
				sendServerEvent("Turbo",p,false)
				plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				--print("-Flying")
			end
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
	
	if stunned == true then
		stunnedFrames = stunnedFrames + delta
	end

	inc = inc + delta

	--print(inc - inctrg)

	if onGround and flying == true then
		flying = false
		turbo = false
		sendServerEvent("Flying",p,false)
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
			if changed == true then
				--print("UPDATED")
				sendServerEvent("Speed",p,-speed/maxSpeed)
				changed = false
			end
		end
	end

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
				sendServerEvent("Flying",p,false)
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

repeat task.wait() until replicatedStorage:FindFirstChild("jetpackEvent")

sendServerEvent("Generate")

repeat task.wait() until plr.Character:FindFirstChild("Jetpack")

p,s = findJetpackComps(plr)