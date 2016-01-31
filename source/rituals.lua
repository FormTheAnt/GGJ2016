local Container = {}

local RitualList = {
	["is gravity still functioning?"] = { [1] = {name = "player is touching box top side", first = true, complete = false},
						[2] = {name = "player is falling", mustcomplete = 1, complete = false},
						[3] = {name = "player is falling", mustcomplete = {1, 2}, complete = false},
						[4] = {name = "player is falling", mustcomplete = {1, 2, 3}, complete = false},
						[5] = {name = "player is falling", mustcomplete = {1, 2, 3, 4}, complete = false}

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

Container.main = {popuptime = 1.5, listeners = RitualList, COMPLETE = COMPLETE}

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
	for i = 1, #RitualCompleted[1] do
		if RitualCompleted[3][i] then
			love.graphics.setColor( 255, 255, 255, 255 - (255 * ((love.timer.getTime() - RitualCompleted[3][i]) / f_world.rituals.popuptime)) )
			love.graphics.print( RitualCompleted[1][i], 500, 300 )
			love.graphics.setColor( 255, 255, 255, 255 )
		end
	end
end

return Container
