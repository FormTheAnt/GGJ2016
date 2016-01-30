local Container = {}
local X = {var = 0, speedlimit = 500, slowdown = 0}
local Y = {var = 0, speedlimit = 500, slowdown = 0}

Container.main = {x = 90, y = 90, width = 50, height = 90, xvars = X, yvars = Y, nextx = 90, nexty = 90}

local Player = Container.main

Container.run = function( f_dt, f_world )
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
		if X.var > 10 then
			X.var = X.var - (1400 * f_dt)
		elseif X.var < -10 then
			X.var = X.var + (1400 * f_dt)
		else
			X.var = 0
		end
	end

	if love.keyboard.isDown( " " ) and Player.collide.bottom then
		Y.var = -550
	end

	Y.var = Y.var < 1400 and Y.var + (900 * f_dt) or 1400

	Player.nextx = math.floor( (Player.x + (X.var * f_dt)) * 100 ) / 100
	Player.nexty = math.floor( (Player.y + (Y.var * f_dt)) * 100 ) / 100
	Player.collide = {bottom = false, top = false, left = false, right = false}
end

Container.draw = function( f_world, f_camera )
	love.graphics.rectangle( "fill", Player.x - f_camera.x, Player.y - f_camera.y, Player.width, Player.height )
end


return Container