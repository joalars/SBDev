script.Parent = __jetpack
print("Jetpack - Server")

local plr
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

repeat
	for i,v in pairs(game:GetService("Players"):GetChildren()) do
		plr = v
	end
	task.wait()
until plr ~= nil and plr.Character

function rct(a)
	--print("[RCT]: Processing "..a:GetFullName())
	for i,v in pairs(a:GetChildren()) do
		--print("[RCT]: Scanning - "..v.Name)
		if (v.Name == "UpperTorso" or v.Name == "Torso") and v:IsA("BasePart") then
			print("[RCT]: Successfully Identified: "..v.Name)
			return v
		end
	end
	print("[RCT]: Search failed. Invalid character.")
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
		{"Anchored",false},
		{"CanCollide",false},
		{"TopSurface",Enum.SurfaceType.Smooth},
		{"BottomSurface",Enum.SurfaceType.Smooth},
		{"Material",Enum.Material.SmoothPlastic},
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
	
	local f1 = ins("Fire",{
		{"Size",0.175},
		{"Enabled",false},
		{"Parent",p4}
	})
	
	local f2 = ins("Fire",{
		{"Size",0.175},
		{"Enabled",false},
		{"Parent",p5}
	})
	
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
end

function enableSound(s)
	local ts = s.Pitch
	local tweenInfo = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		0,
		false,
		0
	)

	local newTween = tweenService:Create(s,tweenInfo,{"Pitch",0,ts}):Play()
end

function disableSound(s)
	local ts = s.Pitch
	local tweenInfo = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		0,
		false,
		0
	)

	local newTween = tweenService:Create(s,tweenInfo,{"Pitch",ts,0}):Play()
end

local jetpackEvent

local eventHandler

function restoreEvent()
	if jetpackEvent == nil then
		jetpackEvent = ins("RemoteEvent",{
			{"Name","jetpackEvent"},
			{"Parent",replicatedStorage}
		})
		if eventHandler then
			eventHandler:Disconnect()
		end
		eventHandler = jetpackEvent.OnServerEvent:Connect(function(plr,t,p,a)
			xpcall(function()
				--print("Message received")
				--print(t)
				print("Signal: "..t)
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
					print("Flying signal")
					if p.Parent == plr.Character then
						print("Valid player")
						if a == true then
							print("True")
							for i,v in pairs(p:GetChildren()) do
								local f = v:FindFirstChild("Fire")
								if f then
									print("Fire")
									f.Enabled = true
								end
								local f = v:FindFirstChild("Thruster")
								if f then
									f:Play()
								end
							end
						else
							print("False")
							for i,v in pairs(p:GetChildren()) do
								local f = v:FindFirstChild("Fire")
								if f then
									print("Fire")
									f.Enabled = false
								end
								local f = v:FindFirstChild("Thruster")
								if f then
									f:Stop()
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
	elseif jetpackEvent.Parent ~= replicatedStorage then
		jetpackEvent.Parent = replicatedStorage
	elseif jetpackEvent.Name ~= "jetpackEvent" then
		jetpackEvent.Name = "jetpackEvent"
	end
end

local temp = game.ReplicatedStorage:FindFirstChild("jetpackEvent")
if temp then
	temp:Destroy()
	temp = nil
end

while task.wait() do
	restoreEvent()
end