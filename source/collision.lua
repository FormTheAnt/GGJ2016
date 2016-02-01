local Container = {}

Container.main = {}

local Boxes = Container.main
local Editor = {mousecheck = false, mousex = false, mousey = false}
local WriteReady = false
local BoxTypeNames = {"normal", "barrel", "background", "crate"}
local BoxType = "normal"

local GateWayLocks = {ids = {}, states = {}, keys = {}}

Boxes[1] = { x = { 8000, 7872, 7872, 8320, 8448, 0, 0, 9536, 9664, 10240, 10368, 0, 11072, 10752, 11072, 10944, 0, 11136, 10944, 0, 10944, 10688, 10752, 8320, 0, 8640, 9664, 0, 9792, 9856, 9984, 0, 0, 0, 0, 10176, 10176, 10240, 10304, 10176, 11136, 11200, 10432, 10496, 0, 0, 0, 10688, 0, 10496, 10624, 0, 0, 11136, 11200, 0, 11264, 0, 11328, 11264, 11328, 11456, 11456, 0, 12096, 11456, 0, 11456, 11456, 11456, 11456, 11456, 11776, 12160, 11904, 11968, 12032, 12096, 0, 9984, 10368, 10560, 0, 0, 9984, 10368, 10240, 9984, 10560, 10560, 11008, 0, 0, 11136, 12160, 11136, 11392, 10688, 0, 8000, 8448, 9664, 9856, 10176, 10240, 10304, 10368, 0, 10368, 10368, 0, 0, 10560, 0, 10496, 10560, 10624, 10752, 10816, 10944, 11264, 10944, 11072, 11008, 0, 11200, 11136, 11200, 11136, 11072, 11136, 11328, 12096, 0, 12096, 11904, 11840, 11776, 11456, 11520, 11584, 11648, 11712, 11456, 11456, 11840, 11456, 11456, 11456, 11584, 11712, 12096, 11904, 11968, 12032, 11776, 11840, 10944, 10688, 10560, 10432, 10368, 10304, 0, 0, 9984, 0, 9984, 10240, 10688, 10880, 10688, 10880, 10944, 10944, 10752, 10368, 10432, 0, 0, 0, 0, 0, 10048, 10112, 10112, 10048, 10240 }, y = { 8128, 7936, 7872, 8128, 8832, 0, 0, 8832, 9920, 9920, 11520, 0, 11328, 11200, 11008, 10816, 0, 10624, 10432, 0, 10048, 9856, 11264, 7872, 0, 7872, 7872, 0, 8384, 8512, 9664, 0, 0, 0, 0, 9344, 9472, 9472, 9472, 9664, 10688, 10624, 10944, 11136, 0, 0, 0, 10624, 0, 10688, 10880, 0, 0, 10240, 10176, 0, 10624, 0, 10688, 9344, 10304, 10624, 10304, 0, 10432, 10240, 0, 10176, 10112, 10048, 9984, 9920, 9792, 9920, 9728, 9664, 9600, 9536, 0, 9344, 9152, 9216, 0, 0, 8960, 9088, 8832, 8384, 8832, 8384, 8512, 0, 0, 8768, 8896, 8512, 8640, 9280, 0, 7936, 7936, 8512, 9792, 9728, 9600, 9536, 9472, 0, 9728, 10688, 0, 0, 10688, 0, 10752, 10880, 10944, 11328, 11264, 11392, 11072, 10880, 11072, 9728, 0, 10688, 10752, 9728, 9728, 9728, 10304, 10432, 10496, 0, 9920, 9920, 9920, 9920, 9792, 9920, 9984, 10048, 10112, 9728, 9344, 9408, 9472, 9536, 9600, 9536, 9472, 8896, 8896, 8896, 8896, 8896, 8896, 8896, 8896, 8896, 8896, 8896, 8896, 0, 0, 9024, 0, 8512, 8512, 9728, 9856, 9920, 10048, 10496, 10112, 10624, 10944, 11200, 0, 0, 0, 0, 0, 9024, 8896, 8512, 9216, 9216 }, type = { 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'normal', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'normal', 'normal', 'normal', 'normal', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'background', 'barrel', 'barrel', 'background', 'background', 'background', 'background', 'background', 'background', 'barrel', 'barrel' }, height = { 64, 256, 64, 832, 128, 0, 0, 1216, 128, 1728, 128, 0, 64, 64, 64, 64, 0, 64, 64, 0, 64, 64, 64, 64, 0, 64, 640, 0, 128, 1280, 128, 0, 0, 0, 0, 128, 192, 128, 64, 64, 64, 64, 256, 64, 0, 0, 0, 320, 0, 64, 64, 0, 0, 64, 64, 0, 64, 0, 832, 960, 128, 128, 128, 0, 64, 64, 0, 64, 64, 64, 64, 64, 128, 832, 64, 64, 64, 64, 0, 320, 192, 128, 0, 0, 64, 64, 64, 128, 64, 128, 320, 0, 0, 128, 896, 256, 128, 64, 0, 192, 896, 1408, 128, 192, 128, 64, 64, 0, 960, 256, 0, 0, 192, 0, 384, 256, 576, 192, 256, 128, 320, 512, 256, 1664, 0, 320, 256, 448, 512, 1280, 320, 192, 128, 0, 512, 704, 384, 320, 128, 64, 64, 64, 64, 64, 128, 64, 64, 64, 128, 192, 256, 640, 832, 768, 704, 448, 512, 448, 384, 320, 256, 192, 448, 0, 0, 320, 0, 448, 320, 128, 192, 704, 1152, 320, 320, 576, 576, 320, 0, 0, 0, 0, 0, 320, 128, 384, 128, 128 }, width = { 320, 128, 448, 128, 1088, 0, 0, 128, 576, 128, 1088, 0, 192, 192, 256, 64, 0, 64, 64, 0, 64, 192, 64, 320, 0, 1024, 128, 0, 192, 128, 192, 0, 0, 0, 0, 1088, 64, 64, 64, 64, 64, 64, 64, 128, 0, 0, 0, 64, 0, 64, 64, 0, 0, 128, 64, 0, 192, 0, 128, 192, 128, 704, 448, 0, 64, 384, 0, 320, 256, 192, 128, 64, 512, 128, 256, 192, 128, 64, 0, 192, 192, 128, 0, 0, 128, 64, 320, 576, 576, 576, 128, 0, 0, 1152, 128, 256, 128, 256, 0, 448, 1216, 192, 320, 192, 1024, 960, 896, 0, 320, 128, 0, 0, 128, 0, 64, 64, 128, 64, 128, 384, 64, 64, 192, 64, 0, 128, 64, 64, 64, 64, 192, 576, 64, 0, 64, 192, 64, 64, 320, 256, 192, 128, 64, 448, 384, 64, 256, 128, 128, 128, 192, 64, 64, 64, 64, 64, 64, 832, 256, 128, 128, 64, 64, 0, 0, 64, 0, 128, 768, 320, 128, 192, 64, 64, 64, 128, 64, 192, 0, 0, 0, 0, 0, 256, 192, 128, 64, 64 } }

local DIST = function( f_x1, f_y1, f_x2, f_y2 )
	return math.sqrt( ((f_x2 - f_x1)^2) + ((f_y2 - f_y1)^2) )
end

Container.run = function( f_dt, f_world, f_LOG )
	local level = f_world.currentlevel
	local player = f_world.player

	for i = 1, #Boxes[level].x do
		if not( Boxes[level].type[i] == "background" ) then
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
			if Boxes[level].type[i] == "normal" then
				love.graphics.rectangle( "fill", Boxes[level].x[i] - f_camera.x, Boxes[level].y[i] - f_camera.y, Boxes[level].width[i], Boxes[level].height[i] )
				
				for x = 0, math.floor(Boxes[level].width[i]/64) - 1 do
					for y = 0, math.floor(Boxes[level].height[i]/64) - 1 do
						love.graphics.draw( f_images["foreground"](), (Boxes[level].x[i] - f_camera.x) + (x * 64), (Boxes[level].y[i] - f_camera.y) + (y * 64) )
					end
				end

				if f_world.isdebug then
					love.graphics.setColor( 255, 0, 0 )
					love.graphics.line( Boxes[level].x[i] - f_camera.x, Boxes[level].y[i] - f_camera.y, (Boxes[level].x[i] - f_camera.x) + Boxes[level].width[i], (Boxes[level].y[i] - f_camera.y) + Boxes[level].height[i] )
					love.graphics.line( Boxes[level].x[i] - f_camera.x, (Boxes[level].y[i] - f_camera.y) + Boxes[level].height[i], (Boxes[level].x[i] - f_camera.x) + Boxes[level].width[i],  Boxes[level].y[i] - f_camera.y)
					love.graphics.setColor( 255, 255, 255 )
				end
			elseif Boxes[level].type[i] == "background" then
				for x = 0, math.floor(Boxes[level].width[i]/64) - 1 do
					for y = 0, math.floor(Boxes[level].height[i]/64) - 1 do
						love.graphics.draw( f_images["background"](), (Boxes[level].x[i] - f_camera.x) + (x * 64), (Boxes[level].y[i] - f_camera.y) + (y * 64) )
					end
				end
			elseif Boxes[level].type[i] == "barrel" then
				love.graphics.draw( f_images["barrel1"](), (Boxes[level].x[i] - f_camera.x), (Boxes[level].y[i] - f_camera.y) )
			elseif Boxes[level].type[i] == "crate" then
				for x = 0, math.floor(Boxes[level].width[i]/64) - 1 do
					for y = 0, math.floor(Boxes[level].height[i]/64) - 1 do
						love.graphics.draw( f_images["crate"](), (Boxes[level].x[i] - f_camera.x) + ((x * 60)), (Boxes[level].y[i] - f_camera.y) + (y * 60) )
					end
				end
			end
			
		if f_world.isdebug then
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
