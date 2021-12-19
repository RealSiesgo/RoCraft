if not _G.EXECUTEDROCRAFTADMINa then _G.EXECUTEDROCRAFTADMIN=true
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
		print("kicking "..plrname)
		plrname=plrname:lower()
		if plrname=="others" then
			for i,plr in next, game.Players:GetPlayers()do
				if plr.Name~=game.Players.LocalPlayer.Name then
					destroyobj(plr)
				end
			end
		else
			local plr=findplr(plrname)
			if plr then
				destroyobj(plr)
			else
				print("plr "..plr.." no")
			end
		end
		print("kick failed "..plrname)
	end
	function notools(plrname)
		plrname=plrname:lower()
		if plrname=="all" or plrname=="others" then
			for i,v in next, game.Players:GetPlayers() do
				for a,b in next, v.Character:GetChildren() do
					if plrname=="all" then
						if b:IsA("Tool") then destroyobj(b) end
						for i,v in next, v.Character:GetChildren() do
							if v:IsA("Tool") then
								destroyobj(v)
							end
						end
					elseif plrname=="others" then
						if v.Name~=game.Players.LocalPlayer.Name then
							if b:IsA("Tool") then destroyobj(b) end
							for i,v in next, v.Character:GetChildren() do
								if v:IsA("Tool") then
									destroyobj(v)
								end
							end
						end
					end
				end
			end
		else
			local plr=findplr(plrname)
			if plr then
				clearchildren(plr.Backpack)
				for i,v in next, plr.Character:GetChildren() do
					if v:IsA("Tool") then
						destroyobj(v)
					end
				end
			end
		end
	end
	function sinkplr(plrname)
		plrname=plrname:lower()
		if plrname=="all" or plrname=="others" then
			for i,plr in next, game.Players:GetPlayers() do
				if plr.Character:FindFirstChild("HumanoidRootPart") then
					if plrname=="all" then
						destroyobj(plr.Character:FindFirstChild("HumanoidRootPart"))
					elseif plrname=="others" then
						if plr.Name~=game.Players.LocalPlayer.Name then
							destroyobj(plr.Character:FindFirstChild("HumanoidRootPart"))
						end
					end
				end
			end
		else
			local plr=findplr(plrname)
			if plr then
				if plr.Character:FindFirstChild("HumanoidRootPart") then
					destroyobj(plr.Character:FindFirstChild("HumanoidRootPart"))
				end
			end
		end
	end
	function killplr(plrname)
		plrname=plrname:lower()
		if plrname=="all" or plrname=="others" then
			for i,plr in next, game.Players:GetPlayers() do
				if plr.Character:FindFirstChild("Head") then
					if plrname=="all" then
						destroyobj(plr.Character:FindFirstChild("Head"))
					elseif plrname=="others" then
						if plr.Name~=game.Players.LocalPlayer.Name then
							destroyobj(plr.Character:FindFirstChild("Head"))
						end
					end
				end
			end
		else
			local plr=findplr(plrname)
			if plr then
				if plr.Character:FindFirstChild("Head") then
					destroyobj(plr.Character:FindFirstChild("Head"))
				end
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
				for a,b in next, v:GetChildren() do
					if v.Name:lower()~="dirt" then
						destroyobj(v)
					end
				end
			end
		end end
	--Commands
	game.Players.LocalPlayer.Chatted:Connect(function(msg)
		if msg:lower()==prefix.."kick all" or msg:lower()==prefix.."shutdown" then
			task.wait(waitbeforeexecuting)
			clearchildren(game.Players)
			coroutine.resume(coroutine.create(function()
				game.Players.PlayerAdded:Connect(function(plr)
					destroyobj(plr)
				end)
			end))
		end
		if msg:lower():match(prefix.."kick ") or msg:lower():match("/e "..prefix.."kick .*") then
			task.wait(waitbeforeexecuting)
			msg=msg:gsub(prefix.."kick ","")
			msg=msg:gsub("/e ","")
			kickplr(msg)
		end
		if msg:lower():match(prefix.."notools ") or msg:lower():match("/e "..prefix.."notools ") then
			msg=msg:gsub(prefix.."notools ","")
			msg=msg:gsub("/e ","")
			notools(msg)
		end
		if msg:lower():match(prefix.."sink ") or msg:lower():match("/e "..prefix.."sink ") then
			msg=msg:gsub(prefix.."sink ","")
			msg=msg:gsub("/e ","")
			sinkplr(msg)
		end
		if msg:lower():match(prefix.."kill ") or msg:lower():match("/e "..prefix.."kill ") then
			msg=msg:gsub(prefix.."kill ","")
			msg=msg:gsub("/e ","")
			killplr(msg)
		end
		if msg:lower():match(prefix.."btools ") or msg:lower():match("/e "..prefix.."btools ") then
			btools()
		end
		if msg:lower():match(prefix.."cleanmap ") or msg:lower():match("/e "..prefix.."cleanmap ") then
			clearmap()
		end
		if msg:lower():match(prefix.."cmds") or msg:lower():match("/e "..prefix.."cmds") then
			game.StarterGui:SetCore("SendNotification", {
				Title = "Commands shown\nin developer console";
				Text = "Press F9 to see the commands.";
				Duration = 8;
			})
			warn("\n:btools			-- Gives you a no cooldown tool to destroy objects.\n:cleanmap		-- Destroys the blocks placed by other people.\n:kill {plr}    	-- Kills the player.\n:sink {plr}		-- Sinks the player.\n:notools {plr}  -- Removes player's tools.\n:kick {plr}		-- Kicks the player.\n:shutdown       -- Kicks everyone.")
		end
	end)
	game.StarterGui:SetCore("SendNotification", {
		Title = "RoCraft-Admin";
		Text = "Executed Successfully.\nMade by Siesgo#8832";
		Duration = 8;
	})task.wait(1)
	game.StarterGui:SetCore("SendNotification", {
		Title = "RoCraft-Admin ( "..prefix.." )";
		Text = "Your prefix is ( "..prefix.." )\nWrite "..prefix.."cmds to see the commands!";
		Duration = 8;
	})
end
