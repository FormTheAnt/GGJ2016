local Container = {}

Container.main = {x = 7500, y = 7000, width = 0, height = 0, leftmargin = 500, rightmargin = 700, topmargin = 150, bottommargin = 300, xgoal = 0, ygoal = 0}


Container.run = function( f_dt, f_world )
	local camera = Container.main
	local player = f_world.player

	if f_world.isdebug then
		if love.keyboard.isDown("left") then
			camera.x = camera.x - (1000 * f_dt)
		elseif love.keyboard.isDown("right") then
			camera.x = camera.x + (1000 * f_dt)
		end
		if love.keyboard.isDown("up") then
			camera.y = camera.y - (1000 * f_dt)
		elseif love.keyboard.isDown("down") then
			camera.y = camera.y + (1000 * f_dt)
		end
	else
		--[[if ((player.x + player.width) - camera.x) > camera.rightmargin then
		elseif (player.x - camera.x) < camera.leftmargin then
			camera.x = camera.x + (camera.x - ((player.x + player.width)))
		end
		if ((player.y + player.height) - camera.y) > camera.bottommargin then
			camera.y = camera.y + (((player.y + player.height) - camera.y))
		elseif (player.y - camera.y) < camera.topmargin then
			camera.y = camera.y + (camera.y - ((player.y + player.height) - camera.y))
		end]]
	end

	camera.x = camera.x + ((player.x + player.width) - (camera.x + 500)) 
	camera.y = camera.y + ((player.y + player.height) - (camera.y + 500))
end

Container.draw = function(f_world, f_camera)
end


return Container
