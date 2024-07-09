local Nurysium = {}

Nurysium.main = {
    RunTime = workspace:WaitForChild('Runtime'),
    Alive = workspace:WaitForChild('Alive'),
    Dead = workspace:WaitForChild('Dead')
}

local Notify = loadstring(game:HttpGet('https://raw.githubusercontent.com/flezzpe/Nurysium/main/notify_UI.lua'))()

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')

repeat
    task.wait()
until game:IsLoaded()

local LocalPlayer = Players.LocalPlayer

Notify.init()

function Nurysium:create_loop(name: string, priority: number, func)
    if not name or tostring(name):len() <= 0 then
        warn('[create_loop] loop name is null.')

        return
    end

    if not priority then
        warn('[create_loop] priority is null.')

        return
    end

    if not func then
        warn('[create_loop] function is null.')

        return
    end

    RunService:BindToRenderStep(name, priority, func)
end

function Nurysium:remove_loop(name: string)
    if not name or tostring(name):len() <= 0 then
        warn('[remove_loop] loop name is null.')

        return
    end

    RunService:UnbindFromRenderStep(name)
end

function Nurysium:delay_run(delay: number, func)
    if not delay then
        warn('[delay_run] delay is null.')

        return
    end

    if not func then
        warn('[delay_run] function is null.')

        return
    end


    task.delay(delay, func)
end

function Nurysium:notify(text: string, delay: number)
    if not text then
        warn('[send_notify] text is null.')

        return
    end

    if not delay then
        warn('[send_notify] delay is null.')

        return
    end


    Notify.draw_notify(text, delay)
end

function Nurysium:get_client_tick()
    return tick()
end

function Nurysium:get_player()
    if not LocalPlayer then
        warn('player is null.')

        return
    end

    return LocalPlayer
end

function Nurysium:set_velocity(velocity: Vector3)
    if not velocity then
        warn('[set_velocity] velocity is null.')

        return
    end

    if not LocalPlayer.Character then
        return
    end

    if not LocalPlayer.Character.PrimaryPart then
        return
    end

    LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity = velocity
end

function Nurysium:set_position(position: Vector3)
    if not position then
        warn('[set_position] position is null.')

        return
    end

    if not LocalPlayer.Character then
        return
    end

    if not LocalPlayer.Character.PrimaryPart then
        return
    end

    LocalPlayer.Character.PrimaryPart.Position = position
end

function Nurysium:get_aim_entity()
	local closest_entity = nil
	local minimal_dot_product = -math.huge
	local camera_direction = workspace.CurrentCamera.CFrame.LookVector

	for _, player in workspace.Alive:GetChildren() do
		if player.Name ~= LocalPlayer.Name then
			if not player:FindFirstChild("HumanoidRootPart") then
				continue
			end
	
			local entity_direction = (player.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Unit
			local dot_product = camera_direction:Dot(entity_direction)
	
			if dot_product > minimal_dot_product then
				minimal_dot_product = dot_product
				closest_entity = player
			end
		end
	end

	return closest_entity
end

function Nurysium:get_ball()
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then
            return ball
        end
    end
end

return Nurysium
