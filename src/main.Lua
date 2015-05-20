function love.load(args)
	math.randomseed(os.time())
	Level = require("Level")
	Tile = require("Tile")
	Player = require("Player")

	players = {}

	love.generate()
end

function love.update(dt)
	if #players > 0 then
		for i = 1, #players do
			if _P.isInAir then
				if _L:findCollision(_P.x, math.ceil(_P.y + dt * _P.gravity)) then

				else
					_P.y = _P.y + dt * _P.gravity
				end

			end
		end
	end
end

function love.draw()
	for i=1,_L.w do
		for j=1,_L.h do
			if _L:getTile(i,j).id == Tile.id.sky then
				love.graphics.setColor(0, 162, 232)
			elseif _L:getTile(i,j).id == Tile.id.floor then
				love.graphics.setColor(239, 228, 176)
			elseif _L:getTile(i,j).id == Tile.id.grass then
				love.graphics.setColor(0, 176, 0)
			elseif _L:getTile(i,j).id == Tile.id.ground then
				love.graphics.setColor(128, 64, 0)
			elseif _L:getTile(i,j).id == Tile.id.trap then
				love.graphics.setColor(255, 0, 0)
			elseif _L:getTile(i,j).id == Tile.id.flag then
				love.graphics.setColor(255, 100, 150)
			end
			love.graphics.rectangle("fill", i*Tile.size, j*Tile.size, Tile.size, Tile.size)
			love.graphics.setColor(255, 255, 255)
			if #players > 0 then
				for i = 1, #players do
					love.graphics.draw(players[i].img, players[i].x*Tile.size, players[i].y*Tile.size)
				end
			end
		end
	end
end

function love.generate()
	_L = Level.new()
	_L:generate()
	_L:placeFlag()
	
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("quit")
	elseif key == " " then
		love.generate()
	end
end

function love.joystickpressed( joystick, button )
	print("pressed")
	if not findPlayer(joystick) then
		_P = Player.new()
		_P.img = love.graphics.newImage("images/cube.png")
		_L:placePlayer(_P)
	end
end

function findPlayer(joystick)
	if #players > 0 then
		for i = 1, #players do
			if players[i].joystick == joystick then
				return true
			end
		end
	else
		return false
	end
end
