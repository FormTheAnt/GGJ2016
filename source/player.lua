local Container = {}
local X = {var = 0, speedlimit = 500, slowdown = 0}
local Y = {var = 900, speedlimit = 500, slowdown = 0, jumptime = 0, jumppower = 0}

Container.main = {firstx = 8000, firsty = 8000, x = 8000, y = 8000, width = 50, height = 100, xvars = X, yvars = Y, nextx = 8000, nexty = 8000, collide = {top = false, bottom = false, left = false, right = false}}

local Player = Container.main

Container.run = function( f_dt, f_world, f_LOG )
	Player.x = Player.nextx
	Player.y = Player.nexty

	if love.keyboard.isDown( "a" ) then
		if X.var < 0 then
			X.var = X.var > (X.speedlimit * -1) and (X.var - (500 * f_dt)) or (X.speedlimit * -1)
		else
			X.var = X.var > (X.speedlimit * -1) and (X.var - (1500 * f_dt)) or (X.speedlimit * -1)
		end
	elseif love.keyboard.isDown( "d" ) then
		if X.var > 0 then
			X.var = X.var < X.speedlimit and (X.var + (500 * f_dt)) or X.speedlimit
		else
			X.var = X.var < X.speedlimit and (X.var + (1500 * f_dt)) or X.speedlimit
		end
	else
		if X.var > 20 then
			X.var = X.var - (1400 * f_dt)

			if X.var < 0 then
				X.var = 0
			end
		elseif X.var < -20 then
			X.var = X.var + (1400 * f_dt)
			
			if X.var > 0 then
				X.var = 0
			end
		else
			X.var = 0
		end
	end

	if Player.collide.bottom then
		Y.var = 0
		Y.jumptime = 0
		Y.jumppower = 0
		X.speedlimit = 530

		if love.keyboard.isDown( " " ) and not(Y.jumpgo) then
			Y.jumpgo = love.timer.getTime()
		end
	elseif not(Player.collide.bottom) then
		if Y.jumptime > 0 and Y.var < 0 then
			Y.jumptime = Y.jumptime - (100 * f_dt)

			if Y.jumptime > 40 then
				if love.keyboard.isDown( " " ) then
					Y.jumppower = Y.jumppower < 600 and Y.jumppower + (2000 * f_dt) or 600
					Y.var = Y.var > -670 and Y.var - (100 * f_dt) or -670
				end
			end
			
			Y.var = Y.var + ((1700 - (Y.jumppower * 2)) * f_dt)
			X.speedlimit = X.speedlimit >= 350 and X.speedlimit - (100 * f_dt) or 350
		else
			if Y.var > 0 then
				f_LOG( "player is falling" )
				X.speedlimit = X.speedlimit >= 250 and X.speedlimit - (100 * f_dt) or 250
			end
		
			Y.var = Y.var < 1400 and Y.var + (800 * f_dt) or 1400
		end
	end
	
	if Y.jumpgo then
		if love.timer.getTime() > Y.jumpgo + 0.1 then
			Y.jumptime = 100
			Y.var = -570
			Y.jumpgo = false
		end
	end

	if Player.collide.top then
		Y.var = (Y.var / 2) * -1
	end
	

	Player.nextx = math.floor( (Player.x + (X.var * f_dt)) * 100 ) / 100
	Player.nexty = math.floor( (Player.y + (Y.var * f_dt)) * 100 ) / 100

	Player.collide = {bottom = false, top = false, left = false, right = false}
end

Container.draw = function( f_world, f_camera, f_images )
	if X.var >= 0 then
		love.graphics.draw( f_images["robot_idle"](), Player.x - f_camera.x, (Player.y - f_camera.y) - 9, 0, 0.26, 0.26 )
	else
		love.graphics.draw( f_images["robot_idle"](), Player.x - f_camera.x, (Player.y - f_camera.y) - 9, 0, -0.26, 0.26, 189)
	end
	--love.graphics.rectangle( "fill", Player.x - f_camera.x, Player.y - f_camera.y, Player.width, Player.height  )
	love.graphics.print( Y.jumptime, Player.x, Player.y )
end


return Container
