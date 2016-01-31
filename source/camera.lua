local Container = {}

Container.main = {x = 8000, y = 8000, width = 0, height = 0, leftmargin = 500, rightmargin = 600, topmargin = 50, bottommargin = 200, xgoal = 0, ygoal = 0}


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
		if ((player.x + player.width) - camera.x) > camera.rightmargin then
			camera.x = camera.x + (100 * f_dt)
		elseif (player.x - camera.x) < camera.leftmargin then
			camera.x = camera.x - (100 * f_dt)
		end
		if ((player.y + player.height) - camera.y) > camera.bottommargin then
			camera.y = camera.y + (100 * f_dt)
		elseif (player.y - camera.y) < camera.topmargin then
			camera.y = camera.y - (100 * f_dt)
		end
	end
end

Container.draw = function()

end


return Container
