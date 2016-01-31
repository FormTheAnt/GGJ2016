local Container = {}

Container.main = {}

local Boxes = Container.main
local Editor = {mousecheck = false, mousex = false, mousey = false}
local WriteReady = false
local BoxTypeNames = {"normal", "hazard", "enemyspawn", "gateway"}
local BoxType = "normal"

local GateWayLocks = {ids = {}, states = {}, keys = {}}

Boxes[1] = { x = { 8000, 7872, 7872, 8320, 8448, 0, 0, 9536, 9664, 10240, 10368, 11328, 11072, 10752, 11072, 10944, 0, 11136, 10944, 11136, 10944, 10688, 10752 }, y = { 8128, 7936, 7872, 8128, 8832, 0, 0, 8832, 9920, 9920, 11520, 10752, 11328, 11200, 11008, 10816, 0, 10624, 10432, 10240, 10048, 9856, 11264 }, type = { 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal' }, height = { 64, 256, 64, 832, 128, 0, 0, 1216, 128, 1728, 128, 768, 64, 64, 64, 64, 0, 64, 64, 64, 64, 64, 64 }, width = { 320, 128, 448, 128, 1088, 0, 0, 128, 576, 128, 1088, 128, 192, 192, 256, 64, 0, 64, 64, 64, 64, 192, 64 } }

local DIST = function( f_x1, f_y1, f_x2, f_y2 )
	return math.sqrt( ((f_x2 - f_x1)^2) + ((f_y2 - f_y1)^2) )
end

Container.run = function( f_dt, f_world, f_LOG )
	local level = f_world.currentlevel
	local player = f_world.player

	for i = 1, #Boxes[level].x do
		if Boxes[level].width[i] ~= 0 then
			local overlap = false

			if (player.nextx + player.width) >= Boxes[level].x[i] and player.x <= (Boxes[level].x[i] + Boxes[level].width[i]) then
				if (player.y + player.height) <= Boxes[level].y[i] and (player.nexty + player.height) >= Boxes[level].y[i] then
					f_world.player.nexty = (Boxes[level].y[i] - f_world.player.height) - 0.1
					f_world.player.collide.bottom = true
					f_LOG( "player is touching box top side", i )
					overlap = true
				elseif (player.y) >= (Boxes[level].y[i] + Boxes[level].height[i]) and (player.nexty) <= (Boxes[level].y[i] + Boxes[level].height[i]) then
					f_world.player.nexty = (Boxes[level].y[i] + Boxes[level].height[i]) + 0.1
					f_world.player.collide.top = true
					f_LOG( "player is touching box bottom side", i )
					overlap = true
				end
			end
			if (player.nexty + player.height) >= Boxes[level].y[i] and player.nexty <= (Boxes[level].y[i] + Boxes[level].height[i]) then
				if (player.x + player.width) <= Boxes[level].x[i] and (player.nextx + player.width) >= Boxes[level].x[i] then
					f_world.player.nextx = (Boxes[level].x[i] - f_world.player.width) - 0.1
					f_world.player.collide.left = true
					f_LOG( "player is touching box left side", i )
					overlap = true
				elseif player.x >= (Boxes[level].x[i] + Boxes[level].width[i]) and player.nextx <= (Boxes[level].x[i] + Boxes[level].width[i]) then
					f_world.player.nextx = (Boxes[level].x[i] + Boxes[level].width[i]) + 0.1
					f_world.player.collide.right = true
					f_LOG( "player is touching box right side", i )
					overlap = true
				end
			end

			if overlap and Boxes[level].type[i] == "hazard" then
				f_world.player.nextx = f_world.player.firstx
				f_world.player.nexty = f_world.player.firsty
			end
		end
	end

	if f_world.mousepress then
		if Editor.mousecheck then
			local camera = f_world.camera
			local mx = (love.mouse.getX() + camera.x) - ((love.mouse.getX() + camera.x) % 64)
			local my = (love.mouse.getY() + camera.y) - ((love.mouse.getY() + camera.y) % 64)

			if (my - Editor.mousey) > 0 and (mx - Editor.mousex) > 0 then
				Boxes[level].x[#Boxes[level].x + 1] = Editor.mousex
				Boxes[level].width[#Boxes[level].width + 1] = mx - Editor.mousex
				Boxes[level].y[#Boxes[level].y + 1] = Editor.mousey
				Boxes[level].height[#Boxes[level].height + 1] = my - Editor.mousey
				Boxes[level].type[#Boxes[level].type + 1] = BoxType
				Editor.mousecheck = false
				Editor.mousex = false
				Editor.mousey = false
			else
				Editor.mousecheck = false
				Editor.mousex = false
				Editor.mousey = false
			end
		else
			local snapalign = false
			local camera = f_world.camera
			local mx = (love.mouse.getX() + camera.x) - ((love.mouse.getX() + camera.x) % 64)
			local my = (love.mouse.getY() + camera.y) - ((love.mouse.getY() + camera.y) % 64)
			local box = Boxes[level]
			
			if f_world.mousepress == "l" then
				Editor.mousex = mx
				Editor.mousey = my
				Editor.mousecheck = true
			end

			for i = 1, #box.x do
				if f_world.mousepress == "r" then
					if (mx >= box.x[i] - 1 and mx <= (box.x[i] + box.width[i] + 1)) and (my >= box.y[i] and my <= (box.y[i] + box.height[i] + 1)) then
						Boxes[level].x[i] = 0
						Boxes[level].y[i] = 0
						Boxes[level].width[i] = 0
						Boxes[level].height[i] = 0
					end
				end
			end
		end
	end

	if f_world.keypress then
		if tonumber(f_world.keypress) and not(f_world.keypress == "9") then
			BoxType = BoxTypeNames[tonumber( f_world.keypress )] and BoxTypeNames[tonumber( f_world.keypress )] or BoxTypeNames[1]
		elseif f_world.keypress == "9" then
			WriteReady = not( WriteReady )
		end
	end
end

Container.draw = function( f_world, f_camera, f_images )
	local level = f_world.currentlevel

	for i = 1, #Boxes[level].x do
		if f_world.isdebug then
			if Boxes[level].type[i] == "normal" then
				love.graphics.rectangle( "fill", Boxes[level].x[i] - f_camera.x, Boxes[level].y[i] - f_camera.y, Boxes[level].width[i], Boxes[level].height[i] )
				
				for x = 0, math.floor(Boxes[level].width[i]/64) - 1 do
					for y = 0, math.floor(Boxes[level].height[i]/64) - 1 do
						love.graphics.draw( f_images["foreground"](), (Boxes[level].x[i] - f_camera.x) + (x * 64), (Boxes[level].y[i] - f_camera.y) + (y * 64) )
					end
				end

				love.graphics.setColor( 255, 0, 0 )
				love.graphics.line( Boxes[level].x[i] - f_camera.x, Boxes[level].y[i] - f_camera.y, (Boxes[level].x[i] - f_camera.x) + Boxes[level].width[i], (Boxes[level].y[i] - f_camera.y) + Boxes[level].height[i] )
				love.graphics.line( Boxes[level].x[i] - f_camera.x, (Boxes[level].y[i] - f_camera.y) + Boxes[level].height[i], (Boxes[level].x[i] - f_camera.x) + Boxes[level].width[i],  Boxes[level].y[i] - f_camera.y)
				love.graphics.setColor( 255, 255, 255 )
			elseif Boxes[level].type[i] == "hazard" then
				love.graphics.setColor( 255, 55, 55 )
				love.graphics.rectangle( "fill", Boxes[level].x[i] - f_camera.x, Boxes[level].y[i] - f_camera.y, Boxes[level].width[i], Boxes[level].height[i] )
				love.graphics.setColor( 255, 255, 255 )
			elseif Boxes[level].type[i] == "enemyspawn" then
				love.graphics.setColor( 255, 55, 255 )
				love.graphics.rectangle( "fill", Boxes[level].x[i] - f_camera.x, Boxes[level].y[i] - f_camera.y, Boxes[level].width[i], Boxes[level].height[i] )
				love.graphics.setColor( 255, 255, 255 )
			end
			
			love.graphics.setColor( 55, 55, 55 )
			love.graphics.print( tostring(i), (Boxes[level].x[i] - f_camera.x) + Boxes[level].width[i]/2, (Boxes[level].y[i] - f_camera.y) + Boxes[level].height[i]/2 )
			love.graphics.setColor( 255, 255, 255 )
		end
	end

	if f_world.isdebug then
		love.graphics.print( "(Press 9 to switch) Write to file?: " .. tostring( WriteReady ), 15, 30 )
		love.graphics.print( "(Press 1-8 to switch) Current block type: " .. BoxType, 15, 60 )
		love.graphics.print( "(Press l to switch) Debug is currently: " .. tostring( f_world.isdebug ), 15, 90 )

		love.graphics.rectangle( "fill", love.mouse.getX() - (love.mouse.getX() % 64), love.mouse.getY() - (love.mouse.getY() % 64), 5, 5 ) 
		
		if Editor.mousex then
			love.graphics.rectangle( "fill", Editor.mousex - f_camera.x, Editor.mousey - f_camera.y, ((love.mouse.getX() + f_camera.x) - ((love.mouse.getX() + f_camera.x) % 64)) - Editor.mousex, ((love.mouse.getY() + f_camera.y) - ((love.mouse.getY() + f_camera.y) % 64)) - Editor.mousey ) 
		end
	end
end

Container.close = function( f_world )
	if f_world.isdebug then
		if WriteReady then
			if not( love.filesystem.exists( "levels" ) ) then
				love.filesystem.createDirectory( "levels" )
			end
			
			local level = f_world.currentlevel
			local filesystem = love.filesystem.getDirectoryItems( "levels" )
			local saveindex = 1

			for i = 1, #filesystem do
				if love.system.getOS( ) == "Windows" then
					if love.filesystem.exists( [[levels\level]] .. tostring( saveindex ) .. ".lua" ) then
						saveindex = saveindex + 1
					end
				else
					if love.filesystem.exists( "levels/level" .. tostring( saveindex ) .. ".lua" ) then
						saveindex = saveindex + 1
					end
				end
			end

			local contents = "Boxes[" .. tostring( saveindex ) .. "] = { "

			for k, v in pairs( Boxes[level] ) do
				contents = contents .. k .. " = { "
				
				for i = 1, #v do
					if type( v[i] ) == "number" then
						contents = contents .. tostring( v[i] ) .. ", "
					else
						contents = contents .. "'" ..  v[i] .. "', "
					end
				end

				contents = string.sub(contents, 0, -3)
				
				contents = contents .. " }, "
			end
			
			contents = string.sub(contents, 0, -3)
			
			contents = contents .. " }"

			if love.system.getOS( ) == "Windows" then
				love.filesystem.write( [[levels\level]] .. tostring( saveindex ) .. ".lua", contents )
			else
				love.filesystem.write( "levels/level" .. tostring( saveindex ) .. ".lua", contents )
			end
		end
	end
end

return Container
