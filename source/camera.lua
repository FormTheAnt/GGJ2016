local Container = {}

Container.main = {x = 0, y = 0, width = 0, height = 0, leftmargin = 500, rightmargin = 600, topmargin = 50, bottommargin = 200, xgoal = 0, ygoal = 0}


Container.run = function( f_dt, f_world )
	local camera = Container.main
	local player = f_world.player

	if ((player.x + player.width) - camera.x) > camera.rightmargin then
		camera.xgoal = camera.xgoal + (100 * f_dt)
	elseif (player.x - camera.x) < camera.leftmargin then
		camera.xgoal = camera.xgoal - (100 * f_dt)
	end
	if ((player.y + player.height) - camera.y) > camera.bottommargin then
		camera.ygoal = camera.ygoal + (100 * f_dt)
	elseif (player.y - camera.y) < camera.topmargin then
		camera.ygoal = camera.ygoal - (100 * f_dt)
	end

	if camera.xgoal > 10 then
		camera.x = camera.x + (100 * f_dt)
		camera.xgoal = camera.xgoal - (100 * f_dt)
		
		if camera.xgoal < 0 then
			camera.xgoal = 0
		end
	elseif camera.xgoal < -10 then
		camera.x = camera.x - (100 * f_dt)
		camera.xgoal = camera.xgoal + (100 * f_dt)

		if camera.xgoal > 0 then
			camera.xgoal = 0
		end
	end
	if camera.ygoal > 10 then
		camera.y = camera.y + (100 * f_dt)
		camera.ygoal = camera.ygoal - (100 * f_dt)
		
		if camera.ygoal < 0 then
			camera.ygoal = 0
		end
	elseif camera.ygoal < -10 then
		camera.y = camera.y - (100 * f_dt)
		camera.ygoal = camera.ygoal + (100 * f_dt)
		
		if camera.ygoal > 0 then
			camera.ygoal = 0
		end
	end
end

Container.draw = function()

end


return Container
