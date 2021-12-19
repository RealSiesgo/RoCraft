--fucntions
function findplr(plrname)
	for i,v in next, game.Players:GetPlayers() do
		if v.Name:lower():match(plrname) then
			return v
		elseif v.DisplayName:lower():match(plrname) then
			return v
		end
	end
end
function destroyobj(object)
	game:GetService("ReplicatedStorage").axe:FireServer(object)
end
function clearchildren(object)
	for i,v in next, object:GetChildren() do
		destroyobj(v)
	end
end
function kickplr(plrname)
	local plr=findplr(plrname)
	if plr then
		destroyobj(plr)
	end
end
function notools(plrname)
	local plr=findplr(plrname)
	if plr then
		clearchildren(plr.Backpack)
		for a,b in next, plr.Character:GetChildren() do
			if b:IsA("Tool") then destroyobj(b) end
		end
	end
end
function sinkplr(plrname)
	local plr=findplr(plrname)
	if plr then
		if plr.Character:FindFirstChild("HumanoidRootPart") then
			destroyobj(plr.Character:FindFirstChild("HumanoidRootPart"))
		end
	end
end
function killplr(plrname)
	local plr=findplr(plrname)
	if plr then
		if plr.Character:FindFirstChild("Head") then
			destroyobj(plr.Character:FindFirstChild("Head"))
		end
	end
end
function btools()
	local mouse = game.Players.LocalPlayer:GetMouse()
	dtool = Instance.new("Tool")
	dtool.RequiresHandle = false
	dtool.Name = "Destroy Tool"
	dtool.Parent = game.Players.LocalPlayer.Backpack
	coroutine.resume(coroutine.create(function()
		dtool.Activated:connect(function()
			destroyobj(mouse.Target)
		end)
	end))
end
function clearmap()
	for i,v in next, game.Workspace:GetChildren() do
		if v.Name=="Map" and #v:GetChildren()>1 then
			clearchildren(v)
		end
	end
end
--Commands
game.Players.LocalPlayer.Chatted:Connect(function(msg)
	if msg:lower():match(prefix.."kick all") or msg:lower():match(prefix.."shutdown") then
		task.wait(waitbeforeexecuting)
		clearchildren(game.Players)
		coroutine.resume(coroutine.create(function()
			game.Players.PlayerAdded:Connect(function(plr)
				destroyobj(plr)
			end)
		end))
	elseif msg:match(prefix.."kick ") then
		task.wait(waitbeforeexecuting)
		msg=msg:gsub(prefix.."kick ","")
		msg=msg:gsub("/e ","")
		kickplr(msg)
	end
	if msg:match(prefix.."notools ") then
		msg=msg:gsub(prefix.."notools ","")
		msg=msg:gsub("/e ","")
		notools(msg)
	end
	if msg:match(prefix.."sink ") then
		msg=msg:gsub(prefix.."sink ","")
		msg=msg:gsub("/e ","")
		sinkplr(msg)
	end
	if msg:match(prefix.."kill ") then
		msg=msg:gsub(prefix.."kill ","")
		msg=msg:gsub("/e ","")
		killplr(msg)
	end
	if msg:match(prefix.."btools") then
		btools()
	end
	if msg:match(prefix.."clearmap") then
		clearmap()
	end
end)
