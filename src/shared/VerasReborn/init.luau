_M = {}

function _M.LoadVeras()

    script.Parent = __verasReborn

    local version = "0.0.1"

    warn("Veras Reborn v"..version)
    warn("init.")

    --[[Services]]
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local tweenService      = game:GetService("TweenService")
    local runService        = game:GetService("RunService")
    local players           = game:GetService("Players")

    --[[Shortcuts]]
    local client = script.Client
    local server = script.Server

    for _,v in pairs(client:GetChildren()) do
        v.Enabled = false
    end

    for _,v in pairs(server:GetChildren()) do
        v.Enabled = false
    end
    
    local ws = workspace

    --[[Functions & Exclusive variables]]
    local function ins(t,vars)
        local i = Instance.new(t)
        for _,v in pairs(vars) do
            xpcall(function()
                i[v[1]] = v[2]
            end,function()
                warn("[INS]: Errored at ("..t..") while setting variable ("..v[1]..")")
            end)
        end
        return i
    end

    local function TabRenderer()
        print("Event received on TabRenderer")
    end

    local checkingEvents = false

    local eventsList = {
        {
            "TabRenderer",
            "RemoteEvent",
            TabRenderer
        }
    }

    local connectedEvents = {}

    local function checkEventName(a)
        local validName = false
        for _,v in pairs(eventsList) do
            if a.Name == v[1] then
                validName = true
            end
        end
        return validName
    end

    local function connectEvents(vFolder)
        for _,v in pairs(vFolder:GetChildren()) do
            for _,e in pairs(eventsList) do
                if v.Name == e[1] then
                    local ev = v.OnServerEvent:Connect(e[3])
                    table.insert(connectedEvents,ev)
                end
            end
        end
        vFolder.Parent = replicatedStorage
    end

    local function regenerateEvents()
        print("Regenerating Events")
        for _,v in pairs(connectedEvents) do
            v:Disconnect()
        end
        connectedEvents = {}
        for _,v in pairs(replicatedStorage:GetChildren()) do
            if v.Name == "Veras" then
                v:Destroy()
            end
        end
        local vFolder = ins("Folder",{
            {"Name","Veras"}
        })
        for _,v in pairs(eventsList) do
            ins(v[2],{
                {"Name",v[1]},
                {"Parent",vFolder}
            })
        end
        connectEvents(vFolder)
    end

    local function checkEvents()
        local foundPossibleMatch = false
        for _,v in pairs(replicatedStorage:GetChildren()) do
            if v.Name == "Veras" then
                if foundPossibleMatch == false then
                    foundPossibleMatch = true
                    for _,va in pairs(v:GetChildren()) do
                        local valid = checkEventName(va)
                        if valid == false then
                            regenerateEvents()
                            break
                        end
                    end
                end
            end
        end
        if foundPossibleMatch == false then
            regenerateEvents()
        else
            for _,ev in pairs(eventsList) do
                local found = false
                for _,v in pairs(replicatedStorage.Veras:GetChildren()) do
                    if v.Name == ev[1] then
                        if v:IsA(ev[2]) then
                            found = true
                        end
                    end
                end
                if found == false then
                    regenerateEvents()
                    break
                end
            end
        end
    end

    for _,v in pairs(players:GetChildren()) do
        local c
        xpcall(
            function()
                c = client:Clone()
                c.Name = "VerasClient"
                local plrgui = v:FindFirstChildOfClass("PlayerGui")
                if plrgui then
                    c.Parent = plrgui
                else
                    error()
                end
            end,
            function()
                warn("Invalid Player: "..v.Name)
                if c then
                    c:Destroy()
                end
            end
        )
    end

    runService.Heartbeat:Connect(function(dt)
        if checkingEvents == false then
            checkingEvents = true
            checkEvents()
            checkingEvents = false
        end
    end)
end

return _M