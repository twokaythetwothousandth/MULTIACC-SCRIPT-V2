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

to use this script to it's full capabilities, it is recommend to have alts running the multiacc ALT version of the script.

if you use this w/o alts, you are slow because you can't fling with this script ALONE.

battle encoder shirase is recommended if you're running the alts on a single computer (lag & stutter may occur, adjust accordingly)

this is NOT a netless/net bypass script, this utilizes roblox animations via tweening & manipulating timepositions

~twokay, a beginner at programming

MADE IN JUNE
]]
local userInput = game:GetService("UserInputService")
local tween = game:GetService("TweenService")
local msgReq = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
local runService = game:GetService("RunService")

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local chara = lp.Character or lp.CharacterAdded:Wait()
local hum = chara:WaitForChild("Humanoid") 
local humRoot = chara:WaitForChild("HumanoidRootPart")

local aniDel = 0.05
local jp = 45
local ws = 4
local hh = 0
local hhMax = 5
local doIntro = false
local prefix = "."

local startUpDiag = "XYZDRIPPY HAS ENTERED THE ARENA! S/O TO LAKESHOP!"

local main 
local mainEnd
local charAdded


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

local floatAssets = 
	{
		floatBG;
		floatEnabled = false;
		floatNum;
	}
local alts = {}
local anims = {}
local floats = {}
local animsCheck = 
	{
		ifIdle = false;
		ifMoving = false;
		ifGroundMoving = false;
		ifQPress = false;
		ifEPress = false;
		ifRPress = false;
		ifTPress = false;
		ifZPress = false;
		ifXPress = false;
	}
local animsEnums = 
	{
		first = Enum.AnimationPriority.Action;
		second = Enum.AnimationPriority.Movement;
		third = Enum.AnimationPriority.Idle;
		last =  Enum.AnimationPriority.Core;
	}
local wasd =
	{
		w = false;
		a = false;
		s = false;
		d = false;
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

local function idleAnims() --idle animations
	animsCheck.ifIdle = true

	createAnim("idleanimation", animIds[17], 0.3, 1, 1, 0, 0.78, true)

	tweenAnimTimePos("idleanimation", tweenInfo, {TimePosition = 0.7})

	--local corou = coroutine.wrap(function() 
	repeat 
		wait(0.05) 
	until animsCheck.ifIdle == false 
	stopTweenAnimTimePos("idleanimation")
	stopAnim("idleanimation", true)
	--end)
	--corou()
end

local function movingAnims() --walking/running animations
	animsCheck.ifMoving = true

	createAnim("spinny", animIds[16], 1, 1, 0.2, 0, 0.15, true)
	createAnim("legs", animIds[12], 1, 1, 0.5, 0, 0.3, true)
	createAnim("idle1back", animIds[15], 1, 1, 1, 0, 1.5, true)

	tweenAnimTimePos("spinny", tweenInfo, {TimePosition = 0.26})
	tweenAnimTimePos("legs", tweenInfo, {TimePosition = 0.35})    

	--local corou = coroutine.wrap(function() 
	repeat 
		wait(0.05) 
	until animsCheck.ifMoving == false 
	stopTweenAnimTimePos("spinny")
	stopTweenAnimTimePos("legs")

	stopAnim("spinny", true)
	stopAnim("legs", true)
	stopAnim("idle1back", true)
	--end)
	--corou()
end

local function groundMovingAnims() --walking/running animations
	animsCheck.ifMoving = true

	createAnim("walking", animIds[11], 0.25, 0.25, 0.9, 1, 0, true)

	--local corou = coroutine.wrap(function() 
	repeat 
		wait(0.05) 
	until animsCheck.ifMoving == false 
	stopAnim("walking", true)
	--end)
	--corou()
end

local function qAnims() --fe chill-like animations
	animsCheck.ifQPress = true

	createAnim("fechill", animIds[7], 0.8, 0.8, 1, 0, 0.57, true)

	tweenAnimTimePos("fechill", tweenInfo, {TimePosition = 0.75})

	local corou = coroutine.wrap(function() 
		repeat 
			wait(0.05) 
		until animsCheck.ifQPress == false 
		stopTweenAnimTimePos("fechill")
		stopAnim("fechill", true)
	end)
	corou()
end

local function eAnims() --loop punch animations
	animsCheck.ifEPress = true

	hum.JumpPower = 0
	hum.WalkSpeed = 2

	createAnim("dino", animIds[1], 0.1, 0.8, 1, 0, 0, true, animsEnums.second)

	local corou = coroutine.wrap(function() 
		repeat 
			setAnimProperty("dino", "timePos", 0)
			wait(0.05)
			setAnimProperty("dino", "timePos", 0.5)
			wait(0.05)	
			createAnim("punch", animIds[2], 0.1, 0.1, 1, 9, 0, true)
			-- not animsCheck.ifGroundMoving then
			createAnim("legsdino", animIds[12], 0.1, 0.1, 0.5, 0, 0.3, true)
			--end
		until animsCheck.ifEPress == false
		stopAnim("dino", true)
		stopAnim("legsdino", true)
		stopAnim("punch", true)
		hum.JumpPower = jp
		hum.WalkSpeed = ws
	end)
	corou()
end                    

local function rAnims() --slam animations
	animsCheck.ifRPress = true

	hum.HipHeight = 0
	hum.JumpPower = 0
	hum.WalkSpeed = 2    

	createAnim("johncena", animIds[7], 0.1, 0.8, 1, 1, 0, false, animsEnums.second)
	repeat wait() until getAnimProperty("johncena", "timePos") >= 0.95
	print("LEGS GO")
	createAnim("johncenalegs", animIds[12], 0.1, 0.1, 0.7, 0, 0.3, true, animsEnums.third)

	wait(0.5)

	stopAnim("johncena", true)
	stopAnim("johncenalegs", true)

	hum.HipHeight = hh
	hum.JumpPower = jp
	hum.WalkSpeed = ws
	animsCheck.ifRPress = false
end

local function tAnims() --cross-arm floating animations
	animsCheck.ifTPress = true

	hum.JumpPower = 0
	hum.WalkSpeed = 2  

	createAnim("cross", animIds[3], 1, 0.5, 1, 0, 2, true)
	wait(0.4)
	createAnim("head", animIds[4], 1, 0.5, 1, 0, 0, true)
	createAnim("legsFloat", animIds[12], 1, 0.5, 0.3, 0, 0.2, true)

	tweenAnimTimePos("legsFloat", tweenInfo, {TimePosition = 0.3}) 

	local corou = coroutine.wrap(function() 
		repeat 
			wait(0.05) 
		until animsCheck.ifTPress == false 
		stopTweenAnimTimePos("legsFloat")
		stopAnim("legsFloat", true)
		stopAnim("cross", true)
		stopAnim("head", true)
		hum.JumpPower = jp
		hum.WalkSpeed = ws
	end)
	corou()
end

local function zAnims() --punch animation
	animsCheck.ifZPress = true
	createAnim("saitama", animIds[18], 0.1, 0.5, 1, 3, 0, false)
	createAnim("saitamalegs", animIds[12], 0.1, 0.5, 0.4, 0, 0.3, true)
	wait(0.2)
	stopAnim("saitama", true)
	stopAnim("saitamalegs", true)
	wait(0.4)
	animsCheck.ifZPress = false
end

local function xAnims() --slap anim
	animsCheck.ifXPress = true
	createAnim("slap", animIds[19], 0.1, 0.5, 0.8, 2, 0, false)
	createAnim("slaplegs", animIds[12], 0.1, 0.5, 0.6, 0, 0.3, true)    
	wait(0.2)
	stopAnim("slap", true)
	stopAnim("slaplegs", true)
	wait(0.4)
	animsCheck.ifXPress = false
end

local function bodyPosTilt(tiltDeg) --tilts your character, used in conjunction with specific animations
	if floatAssets.floatEnabled == false then
		floatAssets.floatEnabled = true

		floatAssets.floatNum = tiltDeg

		if not floatAssets.floatBG then
			floatAssets.floatBG = Instance.new("BodyGyro", humRoot)
			floatAssets.floatBG.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
			floatAssets.floatBG.D = 0
			local corou = coroutine.wrap(function() 
				repeat 
					floatAssets.floatBG.CFrame = humRoot.CFrame:ToWorldSpace(CFrame.new(0,0,0) * CFrame.Angles(math.rad(floatAssets.floatNum), 0, 0))
					wait() 
				until floatAssets.floatEnabled == false
				floatAssets.floatBG = nil
				for i,v in pairs(chara["HumanoidRootPart"]:GetChildren()) do
					if v:IsA("BodyGyro") then
						v:Destroy()
						warn("[XYZ]: Removed BodyGyro instance.")
					end
				end
			end)
			corou()
		end
	end
end

local function changeBodyPosTilt(tiltDeg) --self explanatory
	floatAssets.floatNum = tiltDeg
end

local function disableBodyPosTilt() --self explanatory
	--if floatAssets.floatEnabled then
	floatAssets.floatEnabled = false
	--warn("[XYZ]: Disabled bodyPos")
end

local function float(name, hipHeightMax) --makes you tween float
	if not floats[name] then
		floats[name] = 
			{
				floatTween = tween:Create(hum, tweenInfo, {HipHeight = hipHeightMax});
			}
		floats[name].floatTween:Play()
	end
end

local function unfloat(name) --self explanatory
	if floats[name] then
		floats[name].floatTween:Cancel()
		floats[name] = nil
		hum.HipHeight = hh
	end
end

local function setAltPriority(name, pri) --if selected alt executed the other script, then it will add that alt along with the priority into the alts table
	alts[pri] = 
		{
			user = name
		}
end

local function movingOrIdleCheck() --loop that checks if plr is moving or if plr is idle, then sets the specific animations, floats, and tilts
	local corou = coroutine.wrap(function() 
		while wait() do
			if not animsCheck.ifQPress and not animsCheck.ifEPress and not animsCheck.ifRPress and not animsCheck.ifTPress and not animsCheck.ifZPress and not animsCheck.ifXPress then
				if animsCheck.ifIdle then
					--float("floatreal", 3)
					--disableBodyPosTilt()
					idleAnims()
				elseif animsCheck.ifMoving then
					--if animsCheck.ifGroundMoving then
					--disableBodyPosTilt()
					--unfloat("floatreal", true)
					--groundMovingAnims()
					--else
					bodyPosTilt(-20)
					movingAnims()
					--end
				end
			else
				--unfloat("floatreal")  
				--disableBodyPosTilt()
			end
		end
	end)

	local corouTilt = coroutine.wrap(function()
		while wait() do
			if not animsCheck.ifQPress and not animsCheck.ifMoving then
				disableBodyPosTilt()
			end
		end
	end)
	corouTilt()
	corou()
end

local function wasdCheck() --checks if plr is moving or if plr is idle, then sets specific booleans
	if wasd.w == false and wasd.a == false and wasd.s == false and wasd.d == false then
		animsCheck.ifIdle = true
		animsCheck.ifMoving = false
	else
		animsCheck.ifIdle = false
		animsCheck.ifMoving = true
	end
end

local function initialize() --the main part of the script
	hum.WalkSpeed = ws
	hum.JumpPower = jp
	hum.HipHeight = hh

	antiDelay()
	deleteAnimate()
	movingOrIdleCheck()

	float("floatreal", 1)
	main = userInput.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.Q and not gameProcessedEvent then 
			if not animsCheck.ifEPress and not animsCheck.ifRPress and not animsCheck.ifTPress and not animsCheck.ifZPress and not animsCheck.ifXPress and not animsCheck.ifMoving then
				animsCheck.ifQPress = not animsCheck.ifQPress
				if animsCheck.ifQPress then
					unfloat("floatreal")
					bodyPosTilt(90)
					float("q", hhMax)
					qAnims()
					hum.JumpPower = 0
				elseif not animsCheck.ifQPress then
					disableBodyPosTilt()
					unfloat("q")
					float("floatreal", 1)
					animsCheck.ifQPress = false
					hum.JumpPower = jp
				end
			end
		elseif input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then 
			if not animsCheck.ifQPress and not animsCheck.ifRPress and not animsCheck.ifTPress and not animsCheck.ifZPress and not animsCheck.ifXPress then   
				eAnims()
			end
		elseif input.KeyCode == Enum.KeyCode.R and not gameProcessedEvent then 
			if not animsCheck.ifRPress and not animsCheck.ifQPress and not animsCheck.ifEPress and not animsCheck.ifTPress and not animsCheck.ifZPress and not animsCheck.ifXPress then
				-- THIS HAS BEEN REMOVED BC ITS SO BROKEN LOL
				--unfloat("floatreal")
				--rAnims()
				--float("floatreal", 1)
			end      
		elseif input.KeyCode == Enum.KeyCode.T and not gameProcessedEvent then 
			if not animsCheck.ifRPress and not animsCheck.ifQPress and not animsCheck.ifEPress and not animsCheck.ifZPress and not animsCheck.ifXPress and not animsCheck.ifMoving then   
				animsCheck.ifTPress = not animsCheck.ifTPress
				if animsCheck.ifTPress then
					unfloat("floatreal")
					float("q", hhMax)
					tAnims()
					hum.JumpPower = 0
				elseif not animsCheck.ifTPress then
					unfloat("q")
					float("floatreal", 1)
					animsCheck.ifTPress = false
					hum.JumpPower = jp
				end
			end  
		elseif input.KeyCode == Enum.KeyCode.Z and not gameProcessedEvent then 
			if not animsCheck.ifZPress and not animsCheck.ifRPress and not animsCheck.ifQPress and not animsCheck.ifEPress and not animsCheck.ifTPress and not animsCheck.ifXPress then   
				zAnims()
				wait(0.1)
			end  
		elseif input.KeyCode == Enum.KeyCode.X and not gameProcessedEvent then 
			if not animsCheck.ifXPress and not animsCheck.ifRPress and not animsCheck.ifQPress and not animsCheck.ifEPress and not animsCheck.ifTPress and not animsCheck.ifZPress then   
				xAnims()
				wait(0.2)
			end  
		elseif input.KeyCode == Enum.KeyCode.W and not gameProcessedEvent then 
			wasd.w = true
			wasdCheck()
		elseif input.KeyCode == Enum.KeyCode.A and not gameProcessedEvent then 
			wasd.a = true
			wasdCheck()
		elseif input.KeyCode == Enum.KeyCode.S and not gameProcessedEvent then 
			wasd.s = true
			wasdCheck()
		elseif input.KeyCode == Enum.KeyCode.D and not gameProcessedEvent then 
			wasd.d = true
			wasdCheck()
		end
	end)
	mainEnd = userInput.InputEnded:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then 
			animsCheck.ifEPress = false
		elseif input.KeyCode == Enum.KeyCode.W and not gameProcessedEvent then 
			wasd.w = false
			wasdCheck()
		elseif input.KeyCode == Enum.KeyCode.A and not gameProcessedEvent then 
			wasd.a = false
			wasdCheck()
		elseif input.KeyCode == Enum.KeyCode.S and not gameProcessedEvent then 
			wasd.s = false
			wasdCheck()
		elseif input.KeyCode == Enum.KeyCode.D and not gameProcessedEvent then 
			wasd.d = false
			wasdCheck()
		end
	end)
end
lp.Chatted:Connect(function(msg) --cmds! yay!
	local msgSplit = string.split(msg, " ")
	if string.sub(msgSplit[1],1,1) == prefix then
		if msgSplit[1]:lower() == (prefix .. "initialize") then
			msgReq:FireServer(startUpDiag, "All")
			local chara = lp.Character
			local hum = chara:WaitForChild("Humanoid") 
			local humRoot = chara:WaitForChild("HumanoidRootPart")
			-- above 3 lines are executed just incase you die before you initialize
			initialize()
		elseif msgSplit[1]:lower() == (prefix .. "respawn") then
			if msgSplit[2]:lower() == "true" then
				if not charAdded then 
					charAdded = lp.CharacterAdded:Connect(function(addedChar)
						if addedChar.Name == lp.Name then
							chara = lp.Character
							hum = chara:WaitForChild("Humanoid") 
							humRoot = chara:WaitForChild("HumanoidRootPart")

							deleteAnimate()

							hum.WalkSpeed = ws
							hum.JumpPower = jp
							hum.HipHeight = hh

							unfloat("floatreal")
							float("floatreal", 1)
						end
					end)
					msgReq:FireServer("[XYZ]: Set respawning to true!", "All")
				else
					msgReq:FireServer("[XYZ]: Respawning has already been set!", "All")
				end
			elseif msgSplit[2]:lower() == "false" then
				if charAdded then
					charAdded:Disconnect()
					charAdded = nil
					msgReq:FireServer("[XYZ]: Set respawning to false!", "All")
				else
					msgReq:FireServer("[XYZ]: Respawning has already been set to nil!", "All")
				end
			else
				msgReq:FireServer("[XYZ]: Invalid value!", "All")
			end
		elseif msgSplit[1]:lower() == (prefix .. "nc") then
			for i, v in pairs(plrs:GetChildren()) do
				if string.match(v.Name:lower(), msgSplit[2]:lower()) ~= nil then
				    runService.Stepped:Connect(function()
    					for i2, v2 in pairs(v.Character:GetDescendants()) do
	    					if v2:IsA("Part") or v2:IsA("MeshPart") or v2:IsA("BasePart") then
		    					v2.CanCollide = false
				    		end
					    end
				    end)
				    msgReq:FireServer("[XYZ]: Disabled collisions for plr: " .. v.Name .. ".", "All")
					break
				end
			end
		elseif msgSplit[1]:lower() == (prefix .. "del") then
		    for i, v in pairs(plrs:GetChildren()) do
		        if v.Name ~= lp.Name and string.match(v.Name:lower(), msgSplit[2]:lower()) ~= nil then
		            v.Character:Destroy()
		            msgReq:FireServer("[XYZ]: Deleted plr: " .. v.Name .. ".", "All")
		            break
		        end
	        end
		end
	end
end)

warn("XYZ Multiacc Animations Script V2 has been executed. Use with caution, skid.") --the "skid" is for if script kiddies leak this.
