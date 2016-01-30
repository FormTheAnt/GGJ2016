local Camera = {x = 0, y = 0, width = 0, height = 0, leftmargin = 500, rightmargin = 1000, topmargin = 50, bottommargin = 200}
local World = {currentlevel = 1, camera = Camera, isdebug = true}
local Run = {}
local Draw = {}
local Close = {}

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
	local requirelist = {"player", "collision", "camera"}
	
	love.filesystem.setIdentity( "2016" )
	love.window.setMode( 1200, 700, {fullscreen = true} )

	for i = 1, #requirelist do
		local file = require( requirelist[i] )

		World[ requirelist[i] ] = file.main
		Run[#Run + 1] = file.run
		Draw[#Draw + 1] = file.draw
		Close[#Close + 1] = file.close
	end
end

function love.update( f_dt )
	for i = 1, #Run do
		Run[i]( f_dt, World )
	end
	
	World.keypress = false
	World.mousepress = false
end

function love.draw()
	for i = 1, #Draw do
		Draw[i]( World, World.camera )
	end
end
