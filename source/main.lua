local Camera = {x = 0, y = 0, width = 0, height = 0, leftmargin = 500, rightmargin = 1000, topmargin = 50, bottommargin = 200}
local Run = {}
local Draw = {}
local Close = {}
local Images = {}
local Animations = {}
local Music = {}

local GameLog = {}
local GameLogFirsts = {}
local World = {currentlevel = 1, camera = Camera, isdebug = false, log = GameLog, logfirsts = GameLogFirsts, winstate = false, startstate = true}
local LOG = function( f_text, f_id, f_values )
	local f_values = f_values or {}

	if not( GameLogFirsts[f_text] ) then
		GameLogFirsts[f_text] = {love.timer.getTime(), f_id, f_values}
		f_values.first = true
	end
	
	f_values.name = f_text
	f_values.id = f_id
	GameLog[#GameLog + 1] = {f_text, love.timer.getTime(), f_id, f_values}

	for kmain, vmain in pairs(World.rituals.listeners) do
		for i = 1, #vmain do
			if not(vmain[i].complete) then
				if f_values.name == vmain[i].name then
					local stop = false

					for k, v in pairs( vmain[i] ) do
						if not( k == "complete" ) then
							if not( k == "mustcomplete" ) then
								if v ~= f_values[k] then
									stop = true
								end
							else
								if type(v) == "number" then
									if not( vmain[v].complete ) then
										stop = true
									end
								else
									for cyclecheck = 1, #v do
										if not( vmain[ v[cyclecheck] ].complete ) then
											stop = true
										end
									end
								end
							end
						end
					end

					if World.rituals.listeners[kmain].mustcomplete then
						if not(World.rituals.listeners[World.rituals.listeners[kmain].mustcomplete].complete) then
							stop = true
						end
					end
					
					if not(stop) then
						World.rituals.COMPLETE( kmain, i )
						World.rituals.listeners[kmain].counter = World.rituals.listeners[kmain].counter + 1
						return
					end
				end
			else
				if i == #vmain and not(World.rituals.listeners[kmain].complete) then
					World.rituals.listeners[kmain].complete = true
				end
			end
		end
	end
end

function love.keypressed( f_key, f_isrepeat )
	if f_key == "escape" then
		for i = 1, #Close do
			Close[i]( World )
		end

		love.event.push( "quit" )
	else
		if f_key == "l" then
			--World.isdebug = not(World.isdebug)			
		end

		World.keypress = f_key
	end
end

function love.mousepressed( f_x, f_y, f_side )
	World.mousepress = f_side
end

function love.load()
	local requirelist = {"collision", "camera", "player", "rituals"}
	
	love.filesystem.setIdentity( "2016" )
	love.window.setMode( 1200, 700, {fullscreen = false} )

	for i = 1, #requirelist do
		local file = require( requirelist[i] )

		World[ requirelist[i] ] = file.main
		Run[#Run + 1] = file.run
		Draw[#Draw + 1] = file.draw
		Close[#Close + 1] = file.close
	end

	local filesystem = love.filesystem.getDirectoryItems( "images" )

	for i = 1, #filesystem do
		if string.find(filesystem[i], ".png") then
			local name = string.sub(filesystem[i], 0, string.find(filesystem[i], ".png") - 1)
			local image = love.graphics.newImage("images/" .. filesystem[i])
			
			Images[name] = function() return image end
		else
			if love.filesystem.isDirectory( "images/" .. filesystem[i] ) then
				local animationfiles = love.filesystem.getDirectoryItems( "images/" .. filesystem[i] .. "/"  )
				local frames = {}

				for v = 1, #animationfiles do
					if string.find( animationfiles[v], ".png" ) then
						local name = string.sub( animationfiles[v], 0, string.find( animationfiles[v], ".png" ) - 1 )
						
						frames[tonumber(string.sub(animationfiles[v], string.find( animationfiles[v], "_" ) + 1, string.find(animationfiles[v], ".png" ) - 1 ) )] = love.graphics.newImage( "images/" .. filesystem[i] .. "/" .. animationfiles[v] )
					end
				end
				
				Animations[ filesystem[i] ] = {frame = 0, time = love.timer.getTime(), files = frames}
				
				Images[ filesystem[i] ] = function() 
					if love.timer.getTime() >= Animations[ filesystem[i] ].time then
						if Animations[ filesystem[i] ].files[Animations[ filesystem[i] ].frame + 1] then
							Animations[ filesystem[i] ].frame = Animations[ filesystem[i] ].frame + 1
						else
							Animations[ filesystem[i] ].frame = 1
						end
					end

					return Animations[ filesystem[i] ].files[Animations[ filesystem[i] ].frame]
				end
			end
		end
	end

	Music = love.audio.newSource( "sounds/r0r.ogg" )
	
	LOG( "game has started", 0 )
end

function love.update( f_dt )
	if not( World.startstate ) then
		if not( World.winstate ) then
			Music:play()

			local logindex = 1

			for i = 1, #Run do
				Run[i]( f_dt, World, LOG )
				logindex = logindex + 1
			end
			
		end
	else
		if World.mousepress then
			if love.mouse.getX() > 690 and love.mouse.getY() > 310 and love.mouse.getX() < 890 and love.mouse.getY() < 440 then
				World.startstate = false
			end
			if love.mouse.getX() > 690 and love.mouse.getY() > 450 and love.mouse.getX() < 890 and love.mouse.getY() < 540 then
				love.event.push( "quit" )
			end
			
		end
	end
	
	World.keypress = false
	World.mousepress = false
end

local Credits = {titles = {"Programming by Orion Hubert", "Art by Sophia Baldonado", "Music by J. Shagam"}, variables = {150, 300, 450}}

function love.draw()
	if not( World.startstate ) then
		if not( World.winstate ) then
			for i = 1, #Draw do
				Draw[i]( World, World.camera, Images )
			end

			if World.isdebug then
				love.graphics.print( love.timer.getFPS(), 700, 2 )
				
				for i = 1, #GameLog do
					love.graphics.print( GameLog[i][1] .. "         " .. tostring( GameLog[i][3] ), 700, (24 * i) )
				end

				GameLog = {}
			end
		else
			love.graphics.print( "You helped R0R fulfill its primary objective: disassembing itself to produce parts for paperclips. Great work!", 100, 50 )
			
			for i = 1, #Credits.titles do
				love.graphics.print( Credits.titles[i], 650, Credits.variables[i] )
			end
		end
	else
		love.graphics.draw( Images[ "title" ](), 0, 0 )
	end
end
