local Container = {}

Container.main = {}

local Boxes = Container.main
local Editor = {mousecheck = false, mousex = 0, mousey = 0}
local WriteReady = false
local BoxTypeNames = {"normal", "hazard", "enemyspawn"}
local BoxType = "normal"

Boxes[1] = { x = {100}, y = {300}, width = {250}, height = {30}, type = {"normal"} }

local DIST = function( f_x1, f_y1, f_x2, f_y2 )
	return math.sqrt( ((f_x2 - f_x1)^2) + ((f_y2 - f_y1)^2) )
end

Container.run = function( f_dt, f_world, f_LOG )
	local level = f_world.currentlevel
	local player = f_world.player

	for i = 1, #Boxes[level].x do
		if Boxes[level].width[i] ~= 0 then
			if (player.nextx + player.width) > Boxes[level].x[i] and player.x < (Boxes[level].x[i] + Boxes[level].width[i]) then
				if math.floor(player.y + player.height) < Boxes[level].y[i] and math.ceil(player.nexty + player.height) > Boxes[level].y[i] then
					f_world.player.nexty = (Boxes[level].y[i] - f_world.player.height) - 0.1
					f_world.player.collide.bottom = true
					f_LOG( "player is touching box top side", i )
				elseif math.ceil(player.y) > (Boxes[level].y[i] + Boxes[level].height[i]) and math.floor(player.nexty) < (Boxes[level].y[i] + Boxes[level].height[i]) then
					f_world.player.nexty = (Boxes[level].y[i] + Boxes[level].height[i]) + 0.1
					f_world.player.collide.top = true
					f_LOG( "player is touching box bottom side", i )
					
				end
			end
			if (player.nexty + player.height) > Boxes[level].y[i] and player.nexty < (Boxes[level].y[i] + Boxes[level].height[i]) then
				if (player.x + player.width) < Boxes[level].x[i] and (player.nextx + player.width) > Boxes[level].x[i] then
					f_world.player.nextx = (Boxes[level].x[i] - f_world.player.width) - 0.1
					f_world.player.collide.left = true
					f_LOG( "player is touching box left side", i )
				elseif player.x > (Boxes[level].x[i] + Boxes[level].width[i]) and player.nextx < (Boxes[level].x[i] + Boxes[level].width[i]) then
					f_world.player.nextx = (Boxes[level].x[i] + Boxes[level].width[i]) + 0.1
					f_world.player.collide.right = true
					f_LOG( "player is touching box right side", i )
				end
			end
		end
	end

	if f_world.mousepress then
		if Editor.mousecheck then
			if ((love.mouse.getX() + f_world.camera.x) - Editor.mousex) > 0 then
				Boxes[level].x[#Boxes[level].x + 1] = Editor.mousex
				Boxes[level].width[#Boxes[level].width + 1] = (love.mouse.getX() + f_world.camera.x) - Editor.mousex
			else
				Boxes[level].x[#Boxes[level].x + 1] = Editor.mousex + ((love.mouse.getX() + f_world.camera.x) - Editor.mousex)
				Boxes[level].width[#Boxes[level].width + 1] = ((love.mouse.getX() + f_world.camera.x) - Editor.mousex) * -1
			end
			if ((love.mouse.getY() + f_world.camera.y) - Editor.mousey) > 0 then
				Boxes[level].y[#Boxes[level].y + 1] = Editor.mousey
				Boxes[level].height[#Boxes[level].height + 1] = (love.mouse.getY() + f_world.camera.y) - Editor.mousey
			else
				Boxes[level].y[#Boxes[level].y + 1] = Editor.mousey + ((love.mouse.getY() + f_world.camera.y) - Editor.mousey)
				Boxes[level].height[#Boxes[level].height + 1] = ((love.mouse.getY() + f_world.camera.y) - Editor.mousey) * -1
			end
			
			Boxes[level].type[#Boxes[level].type + 1] = BoxType
			Editor.mousecheck = false
		else
			local snapalign = false
			local camera = f_world.camera
			local mx = love.mouse.getX() + camera.x
			local my = love.mouse.getY() + camera.y
			local box = Boxes[level]
			
			if f_world.mousepress == "l" then
				Editor.mousex = mx
				Editor.mousey = my
				Editor.mousecheck = true
			end

			for i = 1, #box.x do
				if f_world.mousepress == "l" then
					if DIST( mx, my, box.x[i], box.y[i] ) < 20 then
						Editor.mousex = box.x[i]
						Editor.mousey = box.y[i]
						break
					end
					if DIST( mx, my, box.x[i] + box.width[i], box.y[i] ) < 20 then
						Editor.mousex = box.x[i] + box.width[i]
						Editor.mousey = box.y[i]
						break
					end
					if DIST( mx, my, box.x[i], box.y[i] + box.height[i] ) < 20 then
						Editor.mousex = box.x[i]
						Editor.mousey = box.y[i] + box.height[i]
						break
					end
					if DIST( mx, my, box.x[i] + box.width[i], box.y[i] + box.height[i] ) < 20 then
						Editor.mousex = box.x[i] + box.width[i]
						Editor.mousey = box.y[i] + box.height[i]
						break
					end
				elseif f_world.mousepress == "r" then
					if (mx >= box.x[i] and mx <= (box.x[i] + box.width[i])) and (my >= box.y[i] and my <= (box.y[i] + box.height[i])) then
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

Container.draw = function( f_world, f_camera )
	local level = f_world.currentlevel

	for i = 1, #Boxes[level].x do
		if Boxes[level].type[i] == "normal" then
		love.graphics.rectangle( "fill", Boxes[level].x[i] - f_camera.x, Boxes[level].y[i] - f_camera.y, Boxes[level].width[i], Boxes[level].height[i] )
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
	end

	if f_world.isdebug then
		love.graphics.print( "(Press 9 to switch) Write to file?: " .. tostring( WriteReady ), 15, 30 )
		love.graphics.print( "(Press 1-8 to switch) Current block type: " .. BoxType, 15, 60 )
		love.graphics.print( "(Press l to switch) Debug is currently: " .. tostring( f_world.isdebug ), 15, 90 )
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
