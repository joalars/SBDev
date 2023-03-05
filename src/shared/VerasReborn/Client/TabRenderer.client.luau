repeat task.wait() until game.ReplicatedStorage:FindFirstChild("Veras")

task.wait(3)

print("Firing from local to server...")
game.ReplicatedStorage.Veras.TabRenderer:FireServer()