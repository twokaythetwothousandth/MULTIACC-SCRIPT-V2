--[[

                                                                              
                                          88                                  
  ,d                                      88                                  
  88                                      88                                  
MM88MMM  8b      db      d8   ,adPPYba,   88   ,d8   ,adPPYYba,  8b       d8  
  88     `8b    d88b    d8'  a8"     "8a  88 ,a8"    ""     `Y8  `8b     d8'  
  88      `8b  d8'`8b  d8'   8b       d8  8888[      ,adPPPPP88   `8b   d8'   
  88,      `8bd8'  `8bd8'    "8a,   ,a8"  88`"Yba,   88,    ,88    `8b,d8'    
  "Y888      YP      YP       `"YbbdP"'   88   `Y8a  `"8bbdP"Y8      Y88'     
                                                                     d8'      
                                                                    d8'       


twokay's multiacc script v2

this is the ALT ACC version of this script, not the animation script, so this script should be executed on an alt account that you want to control.

battle encoder shirase is recommended if you're running the alts on a single computer (lag & stutter may occur, adjust accordingly)

this is NOT a netless/net bypass script, this utilizes roblox animations via tweening & manipulating timepositions

~twokay, a beginner at programming

MADE IN JUNE
]]
local tween = game:GetService("TweenService")
local msgReq = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
local runService = game:GetService("RunService")

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local chara = lp.Character or lp.CharacterAdded:Wait()
local hum = chara:WaitForChild("Humanoid") 
local humRoot = chara:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local controller = "xyzdrippy" --replace this with the acc you want to use as a "main"
local controllerPlr = plrs[controller]
local controllerChara = controllerPlr.Character or controllerPlr.CharacterAdded:Wait()
local controllerHum = controllerChara:FindFirstChild("Humanoid") 
local controllerHumRoot = controllerChara:FindFirstChild("HumanoidRootPart")
local controllerRArm = controllerChara:FindFirstChild("Right Arm")
local controllerLArm = controllerChara:FindFirstChild("Left Arm")

local radius = 5
local timeRot = 1.5
local degree = 0
local degreeOffset = 0
local force = 50000
local flingPos = 0
local flingDis = 4
local prefix = "."

local startUpDiag = "REJOICE EVERYONE, AS XYZDRIPPY HAS ENTERED THE ARENA!"

local main 
local mainLP 
local mainAni
local charAdded
local mainCharAdded
local noclip
local x, z


local orbitPart


local animIds = 
	{
		"rbxassetid://204328711", --dino walk
		"rbxassetid://126753849", --loop punch
		"rbxassetid://27789359", -- pokie dance USED FOR LEVI PART
		"rbxassetid://121572214",--float head anim
		"rbxassetid://313762630", -- levitate anim
		"rbxassetid://180611870", --SCREAM anim
		"rbxassetid://184574340", --hero anim
		"rbxassetid://282574440", --crawl anim
		"rbxassetid://259438880", --turbine anim
		"rbxassetid://163209885", --roar anim
		"rbxassetid://30235165", --pinch nose walking anim
		"rbxassetid://87986341", --insane legs
		"rbxassetid://204295235", --swordslam
		"rbxassetid://429730430", --spin dance
		"rbxassetid://125750618", --roblox idle1 animation, used to push arms back for idle animation
		"rbxassetid://429681631", --jumping jacks
		"rbxassetid://130018893", --gangnam style
		"rbxassetid://204062532", --one punch
		"rbxassetid://218504594" --slap
	} --19 in total
local anims = {}
local animsCheck = 
	{
		ifTAni = false;
		ifFling = false;
		ifEnabled = false;
		enablePart = false;
		
		ifRSlam = false;
		
		ifIdleOrbit = false;
		ifMovingOrbit = false;
		ifQOrbit = false;
		ifTOrbit = false;
	}
local animsEnums = 
	{
		first = Enum.AnimationPriority.Action;
		second = Enum.AnimationPriority.Movement;
		third = Enum.AnimationPriority.Idle;
		last =  Enum.AnimationPriority.Core;
	}
local tweenInfo = TweenInfo.new(
	3,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true,
	0
)

local function deleteAnimate() --destroys the script that controls the default animations, this is deleted so it doesn't screw with the animations we're gonna use
	local animate = chara:FindFirstChild("Animate")
	if animate then
		animate:Destroy() 
	end
end

local function aniNoDelayFunc() --important
	hum:Move(Vector3.new(0.005,0,0),true)
	hum:Move(Vector3.new(-0.0010,0,0),true)
end

local function antiDelay() --eliminates most of the delay that comes when you rapidly change animation timepositions
	runService.Heartbeat:Connect(function()
		aniNoDelayFunc()
	end)
end

local function createAnim(name, animId, startFade, endFade, weight, speed, timePos, ifLooped, priority) --self explanatory
	if anims[name] then
		print("[XYZ]: Already indexed " .. name .. "! Playing...")
		if priority then
			anims[name].animTrack.Priority = priority
		end
		anims[name].animTrack:Play(startFade, weight, speed)
		anims[name].animTrack.TimePosition = timePos
	else
		local anim = Instance.new("Animation")
		anim.AnimationId = animId
		anims[name] =
			{
				animTrack = hum:LoadAnimation(anim);   
			}
		if priority then
			anims[name].animTrack.Priority = priority
		end
		anims[name].animTrack.Looped = ifLooped
		anims[name].animTrack:Play(startFade, weight, speed)
		anims[name].animTrack.TimePosition = timePos

		anims[name].endFadeTime = endFade
	end 
end

local function setAnimProperty(name, property, value, optFadeTime) --sets animation track property to desired value
	if not optFadeTime then
		optFadeTime = 0.1 --default if optFadeTime isn't used
	end
	local anim = anims[name]
	local track = anims[name].animTrack
	if track then
		if property == "endFade" then --no startFade because that's already used in createAnim
			anim.endFadeTime = value
		elseif property == "weight" then
			track:AdjustWeight(value, optFadeTime)
		elseif property == "speed" then
			track:AdjustSpeed(value, optFadeTime)
		elseif property == "timePos" then
			track.TimePosition = value
		elseif property == "ifLooped" then
			track.Looped = value
		elseif property == "priority" then
			track.Priority = value
		else
			print("[XYZ]: Invalid value in setAnimProperty, with args: " .. name .. ", " .. property .. ", " .. value .. ", " .. optFadeTime .. ".")
		end
	else
		print("[XYZ]: There isn't a track in " .. name .. "...")
	end
end

local function getAnimProperty(name, property) --gets animation track property
	local anim = anims[name]
	local track = anims[name].animTrack
	if track then
		if property == "endFade" then --no startFade because that's already used in createAnim
			print("[XYZ]: Returned".. property .." in getAnimProperty, name: " .. name .. ".")
			return anim.endFadeTime
		elseif property == "weight" then
			print("[XYZ]: Returned".. property .." in getAnimProperty, name: " .. name .. ".")
			return track.WeightCurrent
		elseif property == "speed" then
			print("[XYZ]: Returned".. property .." in getAnimProperty, name: " .. name .. ".")
			return track.Speed
		elseif property == "timePos" then
			print("[XYZ]: Returned".. property .." in getAnimProperty, name: " .. name .. ".")
			return track.TimePosition
		elseif property == "ifLooped" then
			print("[XYZ]: Returned".. property .." in getAnimProperty, name: " .. name .. ".")
			return track.Looped
		elseif property == "priority" then
			print("[XYZ]: Returned".. property .." in getAnimProperty, name: " .. name .. ".")
			return track.Priority
		else
			print("[XYZ]: Invalid value in setAnimProperty, with args: " .. name .. ", " .. property .. ".")
		end
	else
		print("[XYZ]: There isn't a track in " .. name .. "...")
	end  
end


local function tweenAnimTimePos(name, animTweenInfo, table) --tweens the time position, useful if you want sine-wave like animations (yk what i mean)
	local anim = anims[name]
	local track = anims[name].animTrack
	if track then
		anim.tweenTrack = tween:Create(track, animTweenInfo, table)
		anim.tweenTrack:Play()
		print("[XYZ]: Successfully started tweening the TimePosition of " .. name .. ".")
	else
		print("[XYZ]: There isn't a track in " .. name .. "...")
	end    
end

local function stopTweenAnimTimePos(name) --self explanatory
	local anim = anims[name]
	local track = anims[name].animTrack
	if track then
		anim.tweenTrack:Cancel()
		print("[XYZ]: Stopped tweening the TimePosition of " .. name .. ".")
	else
		print("[XYZ]: There isn't a track in " .. name .. "...")
	end    
end

local function stopAnim(name, delete) --self explanatory
	local anim = anims[name]
	local track = anims[name].animTrack
	if track then
		track:Stop(anim.endFadeTime)
		if delete then
			track:Destroy()
			anims[name] = nil
		end
	else
		print("[XYZ]: There isn't a track in " .. name .. "...")
	end
end

local function tAnims() --cross-arm floating animations
	animsCheck.ifTAni = true

	createAnim("cross", animIds[3], 1, 0.5, 1, 0, 2, true)
	wait(0.4)
	createAnim("head", animIds[4], 1, 0.5, 1, 0, 0, true)
	createAnim("legsFloat", animIds[12], 1, 0.5, 0.3, 0, 0.2, true)

	tweenAnimTimePos("legsFloat", tweenInfo, {TimePosition = 0.3}) 

	local corou = coroutine.wrap(function() 
		repeat 
			wait(0.05) 
		until not animsCheck.ifTAni
		stopTweenAnimTimePos("legsFloat")
		stopAnim("legsFloat", true)
		stopAnim("cross", true)
		stopAnim("head", true)
	end)
	corou()
end

local function getPos(ang, dis)
	local x = math.cos(math.rad(ang)) * dis
	local y = math.sin(math.rad(ang)) * dis
	return x, y
end

local function assignOrbitPart()
	if not orbitPart then
		animsCheck.enablePart = true
		
		orbitPart = Instance.new("Part", controllerRArm)
		orbitPart.Size = Vector3.new(1, 1, 1)
		orbitPart.Anchored = true
		orbitPart.Transparency = 0.5
		orbitPart.CanCollide = false
		orbitPart.Position = controllerRArm.Position
	end
end

local function changeOrbitPartCFrame(assignOrbitPartParam)
	if animsCheck.enablePart and animsCheck.ifEnabled then
		orbitPart.CFrame = assignOrbitPartParam
	end
end

local function removeOrbitPart()
	if animsCheck.enablePart then
		animsCheck.enablePart = false
	end
	orbitPart:Destroy()
	orbitPart = nil
end

local function orbit()
	if orbitPart then
		animsCheck.ifEnabled = true
		
		local orbitBP = Instance.new("BodyPosition", humRoot)
		orbitBP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		orbitBP.D = 800
		
		local orbitBG = Instance.new("BodyGyro", humRoot)
		orbitBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		orbitBG.P = 100000
		orbitBG.D = 1000
		
		local corou = coroutine.wrap(function()		
			repeat
				degreeOffset = degreeOffset + timeRot
				x, z = getPos(degree + degreeOffset, radius)	
				
				orbitBP.Position = orbitPart.CFrame:ToWorldSpace(CFrame.new(x, 0, z)).Position
				orbitBG.CFrame = CFrame.lookAt(humRoot.Position, orbitPart.Position, orbitPart.CFrame.UpVector) * CFrame.Angles(0, math.rad(180), 0)
				wait()
			until not animsCheck.ifEnabled 
			degreeOffset = 0
			orbitBP:Destroy()
			orbitBG:Destroy()
		end)
		corou()
	else
		msgReq:FireServer("[XYZ]: orbitPart has not been assigned yet!", "All")
	end
end

local function generalFling(animationTrack, waitTime)
	animsCheck.ifFling = true
	local ifFlingPH = true
	local enabledPH = animsCheck.ifEnabled 
	if enabledPH then
		animsCheck.ifEnabled = false
		animsCheck.ifTAni = false
	end
	
	wait(0.05)
	
	local flingBP = Instance.new("BodyPosition", humRoot)
	flingBP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	flingBP.D = 200

	local flingBAV = Instance.new("BodyAngularVelocity", humRoot)
	flingBAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	flingBAV.AngularVelocity = Vector3.new(0, force, 0)
	camera.CameraSubject = controllerHumRoot
	
	local corou = coroutine.wrap(function()
		repeat
			flingBP.Position = (controllerHumRoot.Position + (controllerHumRoot.CFrame.lookVector * flingDis) + (controllerHumRoot.CFrame.rightVector * flingPos)) 
			wait()
		until not ifFlingPH
	end)
	corou()
	animationTrack.Stopped:Wait()
	if waitTime then
		wait(waitTime)
	end
	ifFlingPH = false
	flingBAV.AngularVelocity = Vector3.new(0, 0, 0)
	wait()
	--local humRootBGTP = Instance.new("BodyGyro", humRoot)
	--humRootBGTP.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	--humRootBGTP.D = 200
	--humRootBGTP.CFrame = CFrame.new(humRoot.Position) * CFrame.Angles(controllerHumRoot.CFrame:ToEulerAnglesXYZ())
	flingBP:Destroy()
	flingBAV:Destroy()
	--wait()
	--humRootBGTP:Destroy()
	camera.CameraSubject = hum

	animsCheck.ifFling = false		

	if enabledPH then
		tAnims()
		orbit()
	end
end

local function surroundFling(animationTrack, waitTime)
	animsCheck.ifFling = true
	
	local xPH, zPH
	
	local ifFlingPH = true
	local enabledPH = animsCheck.ifEnabled 
	if enabledPH then
		animsCheck.ifEnabled = false
		animsCheck.ifTAni = false
	end
	local flingBP = Instance.new("BodyPosition", humRoot)
	flingBP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	flingBP.D = 200

	local flingBAV = Instance.new("BodyAngularVelocity", humRoot)
	flingBAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	flingBAV.AngularVelocity = Vector3.new(0, force, 0)
	camera.CameraSubject = controllerHumRoot
	local corou = coroutine.wrap(function()
		repeat
			--flingBP.Position = (controllerHumRoot.Position + (controllerHumRoot.CFrame.lookVector * flingDis) + (controllerHumRoot.CFrame.rightVector * flingPos)) 
			xPH, zPH = getPos(degree, radius)
			flingBP.Position = controllerHumRoot.CFrame:ToWorldSpace(CFrame.new(xPH, 0, zPH)).Position
			wait()	
		until not ifFlingPH
	end)
	corou()
	animationTrack.Stopped:Wait()
	if waitTime then
		wait(waitTime)
	end
	ifFlingPH = false
	flingBAV.AngularVelocity = Vector3.new(0, 0, 0)
	wait()

	flingBP:Destroy()
	flingBAV:Destroy()

	camera.CameraSubject = hum

	animsCheck.ifFling = false		

	if enabledPH then
		tAnims()
		orbit()
	end	
end

local function disableAnimCheck(obj)
	if animsCheck[obj] then
		animsCheck[obj] = false
	end	
end

local function enableAnimCheck(obj)
	if not animsCheck[obj] then
		animsCheck[obj] = true
	end	
end

local function animationResponse(animationTrack)
	local animationLooped = animationTrack.Looped
	local animationPri = animationTrack.Priority
	local animationId = animationTrack.Animation.AnimationId

	if animationId == animIds[1] and not animsCheck.ifFling then --loop punch
		generalFling(animationTrack)
	elseif animationId == animIds[18] and not animsCheck.ifFling then --punch
		generalFling(animationTrack, 0.5)
	elseif animationId == animIds[19] and not animsCheck.ifFling then --slash/bitchslap
		generalFling(animationTrack, 0.5)
	elseif animationId == animIds[7] then --hero ani
		enableAnimCheck("ifQOrbit")

		disableAnimCheck("ifIdleOrbit")
		disableAnimCheck("ifMovingOrbit")
		disableAnimCheck("ifTOrbit")
		
		local corou = coroutine.wrap(function()
            repeat	
			    changeOrbitPartCFrame(controllerLArm.CFrame:ToWorldSpace(CFrame.new(0, -2, 0) * CFrame.Angles(0, 0, math.rad(180))))
			    wait()
		    until not animsCheck.ifQOrbit
	    end)
	    corou()
	    animationTrack.Stopped:Wait()
		changeOrbitPartCFrame(controllerRArm.CFrame:ToWorldSpace(CFrame.new(0, -2, 0) * CFrame.Angles(0, 0, math.rad(180))))
	elseif animationId == animIds[17] and not animsCheck.ifFling then --gangnam style, IDLE ANIM
		enableAnimCheck("ifIdleOrbit")

		disableAnimCheck("ifQOrbit")
		disableAnimCheck("ifMovingOrbit")
		disableAnimCheck("ifTOrbit")
		
		repeat	
		    print("hi")
			changeOrbitPartCFrame(controllerRArm.CFrame:ToWorldSpace(CFrame.new(0, -2, 0) * CFrame.Angles(0, 0, math.rad(180))))
			wait()
		until not animsCheck.ifIdleOrbit
	elseif animationId == animIds[15] and not animsCheck.ifFling then --rblx idle anim, moving anim
		enableAnimCheck("ifMovingOrbit")

		disableAnimCheck("ifQOrbit")
		disableAnimCheck("ifIdleOrbit")
		disableAnimCheck("ifTOrbit")
		
		repeat	
			changeOrbitPartCFrame(controllerHumRoot.CFrame:ToWorldSpace(CFrame.new(0, 4, 0)))
			wait()
		until not animsCheck.ifMovingOrbit	
	elseif animationId == animIds[3] and not animsCheck.ifFling then --old float anim
		enableAnimCheck("ifTOrbit")

		disableAnimCheck("ifQOrbit")
		disableAnimCheck("ifIdleOrbit")
		disableAnimCheck("ifMovingOrbit")
		repeat
			changeOrbitPartCFrame(controllerHumRoot.CFrame:ToWorldSpace(CFrame.new(0,0,4) * CFrame.Angles(math.rad(90), 0, 0)))
			wait()
		until not animsCheck.ifTOrbit
		changeOrbitPartCFrame(controllerRArm.CFrame:ToWorldSpace(CFrame.new(0, -2, 0) * CFrame.Angles(0, 0, math.rad(180))))
	end
end

local function initialize(mainPlr)
	deleteAnimate()
	main = controllerPlr.Chatted:Connect(function(msg) --self explanatory
		local msgSplit = string.split(msg, " ")
		if string.sub(msgSplit[1],1,1) == prefix then
			if msgSplit[1]:lower() == (prefix .. "orbitform") or msgSplit[1]:lower() == (prefix .. "oform") then
				assignOrbitPart()
				tAnims()
				orbit()
				changeOrbitPartCFrame(controllerRArm.CFrame:ToWorldSpace(CFrame.new(0, -2, 0) * CFrame.Angles(0, 0, math.rad(180))))
			elseif msgSplit[1]:lower() == (prefix .. "unorbitform") or msgSplit[1]:lower() == (prefix .. "unoform") then	
				animsCheck.ifTAni = false
				animsCheck.ifEnabled = false
				removeOrbitPart()
			elseif msgSplit[1]:lower() == (prefix .. "reorbitform") or msgSplit[1]:lower() == (prefix .. "reoform") then
				animsCheck.ifTAni = false
				animsCheck.ifEnabled = false
				wait(0.1)
				changeOrbitPartCFrame(controllerHumRoot.CFrame:ToWorldSpace(CFrame.new(0, 8, 0)))
				tAnims()
				orbit()
			elseif msgSplit[1]:lower() == (prefix .. "assign") then
				if string.match(lp.Name:lower(), msgSplit[2]:lower()) ~= nil and tonumber(msgSplit[3]) ~= nil then				
					degree = msgSplit[3]
					msgReq:FireServer("[XYZ]: Assigned to " .. degree .. " degrees.", "All")
				end
			elseif msgSplit[1]:lower() == (prefix .. "timerot") or msgSplit[1]:lower() == (prefix .. "speed") then
				if tonumber(msgSplit[2]) ~= nil then
					timeRot = tonumber(msgSplit[2])
					msgReq:FireServer("[XYZ]: Set timeRot/speed variable to " .. timeRot .. ".", "All")
				else
					msgReq:FireServer("[XYZ]: Invalid value!", "All")
				end
			elseif msgSplit[1]:lower() == (prefix .. "radius") then
				if tonumber(msgSplit[2]) ~= nil then
					radius = tonumber(msgSplit[2])
					msgReq:FireServer("[XYZ]: Set radius to " .. radius .. ".", "All")
				else
					msgReq:FireServer("[XYZ]: Invalid value!", "All")
				end
			elseif msgSplit[1]:lower() == (prefix .. "flingdis") then
				if string.match(lp.Name:lower(), msgSplit[2]:lower()) ~= nil and tonumber(msgSplit[3]) ~= nil then				
					flingDis = tonumber(msgSplit[3])
					msgReq:FireServer("[XYZ]: Set flingDis variable to " .. flingDis .. ".", "All")
				else
					msgReq:FireServer("[XYZ]: Invalid value!", "All")
				end
			elseif msgSplit[1]:lower() == (prefix .. "flingpos") then
				if string.match(lp.Name:lower(), msgSplit[2]:lower()) ~= nil and tonumber(msgSplit[3]) ~= nil then				
					flingPos = tonumber(msgSplit[3])
					msgReq:FireServer("[XYZ]: Set flingPos variable to " .. flingPos .. ".", "All")
				else
					msgReq:FireServer("[XYZ]: Invalid value!", "All")
				end
			elseif msgSplit[1]:lower() == (prefix .. "stats") then
				print("radius: " .. radius .. ", " .. "timeRot: " .. timeRot .. ", " .. "degree: " .. degree .. ", " .. "force: " .. force .. ", " .. "flingPos: " .. flingPos .. ", " .. "flingDis: " .. flingDis .. ".")
				msgReq:FireServer("[XYZ]: Printed stats to localplayer console.", "All")
			elseif msgSplit[1]:lower() == (prefix .. "credits") then
			    msgReq:FireServer("SCRIPT WAS MADE BY XYZDRIPPY!", "All")
			end
		else
			msgReq:FireServer(msg, "All")
		end
	end)
	mainLP = lp.Chatted:Connect(function(msg) --self explanatory
		local msgSplit = string.split(msg, " ")
		if string.sub(msgSplit[1],1,1) == prefix then
			if msgSplit[1]:lower() == (prefix .. "assignmainplr") then
				for i,v in pairs(plrs:GetChildren()) do
					print(v.Name:lower())
					if string.match(v.Name:lower(), msgSplit[2]:lower()) ~= nil then
						controllerPlr = plrs[v.Name]
						controllerChara = controllerPlr.Character or controllerPlr.CharacterAdded:Wait()
						controllerHumRoot = controllerChara:FindFirstChild("HumanoidRootPart")
						controllerHum = controllerChara:FindFirstChild("Humanoid")
						controllerRArm = controllerChara:FindFirstChild("Right Arm")
						controllerLArm = controllerChara:FindFirstChild("Left Arm")
						msgReq:FireServer("[XYZ]: Assigned controllerPlr to:" .. v.Name .. ".", "All")
						break
					end
				end
			end
		end
	end)
	mainAni = controllerHum.AnimationPlayed:Connect(function(animationTrack) -- deprecated but required, i pray that roblox does not remove this oh god oh fuck
		if animsCheck.enablePart and animsCheck.ifEnabled then
			animationResponse(animationTrack)
		end
	end)
	charAdded = lp.CharacterAdded:Connect(function(addedChar) -- self explanatory
		if addedChar.Name == lp.Name then
			chara = lp.Character
			hum = chara:WaitForChild("Humanoid") 
			humRoot = chara:WaitForChild("HumanoidRootPart")

			deleteAnimate()
		end
	end)
	
	local function died()
		animsCheck.ifTAni = false
		animsCheck.ifEnabled = false
		mainAni:Disconnect()
		
		controllerPlr.CharacterAdded:Wait()
		wait(2)
		
		
		controllerChara = controllerPlr.Character
		controllerHumRoot = controllerChara:FindFirstChild("HumanoidRootPart")
		controllerHum = controllerChara:FindFirstChild("Humanoid")
		controllerRArm = controllerChara:FindFirstChild("Right Arm")
		controllerLArm = controllerChara:FindFirstChild("Left Arm")
		
		mainCharAdded = controllerHum.Died:Connect(function(addedChar) 
			died()
		end)	
		mainAni = controllerHum.AnimationPlayed:Connect(function(animationTrack) -- deprecated but required, i pray that roblox does not remove this oh god oh fuck
			if animsCheck.enablePart and animsCheck.ifEnabled then
				animationResponse(animationTrack)
			end
		end)
	end
	
	mainCharAdded = controllerHum.Died:Connect(function(addedChar) 
		died()
	end)
end

initialize()
warn("XYZ Multiacc ALT Animations Script V2 has been executed. Use with caution, skid.")
warn("ALT VERSION IS ONLINE BITCH!")