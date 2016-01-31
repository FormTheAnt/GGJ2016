local Camera = {x = 0, y = 0, width = 0, height = 0, leftmargin = 500, rightmargin = 1000, topmargin = 50, bottommargin = 200}
local Run = {}
local Draw = {}
local Close = {}
local Images = {}

local GameLog = {}
local GameLogFirsts = {}
local World = {currentlevel = 1, camera = Camera, isdebug = true, log = GameLog, logfirsts = GameLogFirsts}
local LOG = function( f_text, f_id, f_values )
	local f_values = f_values or {}

	if not( GameLogFirsts[f_text] ) then
		GameLogFirsts[f_text] = {love.timer.getTime(), f_id, f_values}
		f_values.first = true
	end
	
	f_values.name = f_text
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
					
					if not(stop) then
						World.rituals.COMPLETE( kmain, i )
					end
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
		World.keypress = f_key
	end
end

function love.mousepressed( f_x, f_y, f_side )
	World.mousepress = f_side
end

function love.load()
	local requirelist = {"player", "collision", "camera", "rituals"}
	
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
		local name = string.sub(filesystem[i], 0, string.find(filesystem[i], ".png") - 1)
		
		Images[name] = love.graphics.newImage("images/" .. filesystem[i])
	end
	
	LOG( "game has started", 0 )
end

function love.update( f_dt )
	local logindex = 1

	for i = 1, #Run do
		Run[i]( f_dt, World, LOG )
		logindex = logindex + 1
	end
	
	World.keypress = false
	World.mousepress = false
end

function love.draw()
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
end
