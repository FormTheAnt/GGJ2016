local Container = {}

local RitualList = {
	["is gravity still functioning?"] = { [1] = {name = "player is touching box top side", first = true, complete = false},
						[2] = {name = "player is touching box top side", mustcomplete = 1, id = 5, complete = false},
						[3] = {name = "player is touching box top side", mustcomplete = {1, 2}, id = 9, complete = false},

		complete = false,
		counter = 0
	},
	["test barrel weight limit integrity"] = { [1] = {name = "player is touching box top side", id = 99, complete = false},
		complete = false,
		counter = 0
	}
}
local RitualCompleted = {{} --[[ritual names go here]], {} --[[indexes go here]], {} --[[Timers go here]]}
local COMPLETE = function( f_ritual, f_index )
	if #RitualCompleted[1] > 1 then
		for i = 1, #RitualCompleted[1] do
			if RitualCompleted[1][i] == nil then
				RitualCompleted[1][i] = f_ritual
				RitualCompleted[2][i] = f_index
				RitualCompleted[3][i] = love.timer.getTime()
				break
			end
		end
	else
		RitualCompleted[1][#RitualCompleted[1] + 1] = f_ritual
		RitualCompleted[2][#RitualCompleted[2] + 1] = f_index
		RitualCompleted[3][#RitualCompleted[3] + 1] = love.timer.getTime()
	end

	RitualList[f_ritual][f_index].complete = true
end

local CurrentRitual = "is gravity still functioning?"

Container.main = {popuptime = 1.5, listeners = RitualList, COMPLETE = COMPLETE, currentritual = CurrentRitual}

Container.run = function( f_dt, f_world )
	local rituals = Container.main

	local speciallist = {
		["first"] = function( f_ritual, f_index )
			if f_world.logfirsts[RitualList[f_ritual][f_index].event] then
				return true
			end
		end
	}

	for i = 1, #RitualCompleted[1] do
		if RitualCompleted[3][i] then
			if love.timer.getTime() >= RitualCompleted[3][i] + rituals.popuptime then
				RitualCompleted[1][i] = nil
				RitualCompleted[2][i] = nil
				RitualCompleted[3][i] = nil
			end
		end
	end
end

Container.draw = function( f_world, f_camera )
	local ritual = Container.main

	for i = 1, #RitualCompleted[1] do
		if RitualCompleted[3][i] then
			love.graphics.setColor( 55, 255, 55, 255 - (200 * ((love.timer.getTime() - RitualCompleted[3][i]) / f_world.rituals.popuptime)) )
			love.graphics.print( "test " .. RitualList[ritual.currentritual].counter .. " passed", (f_world.player.x - f_camera.x) - (string.len( "test " .. RitualList[ritual.currentritual].counter .. " passed" ) * 2), ((f_world.player.y - f_camera.y) - 20) + (i * 20) )
		end
	end

	love.graphics.setColor( 55, 255, 55, 255)
	love.graphics.print( "Diagnostic: " .. ritual.currentritual .. "  passed(" .. RitualList[ritual.currentritual].counter .. ")", (f_world.player.x - f_camera.x) - (string.len( "Diagnostic: " .. ritual.currentritual  .. "  passed(" .. RitualList[ritual.currentritual].counter .. ")") * 2), ((f_world.player.y - f_camera.y) - 20) )
	love.graphics.setColor( 255, 255, 255, 255 )
end

return Container
