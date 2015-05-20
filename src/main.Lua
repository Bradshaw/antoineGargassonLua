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
			if love.timer.getTime() - players[i].lastMovement  > players[i].speed then
				if (players[i].joystick:getGamepadAxis("lefty") > 0.5 ) then
					players[i].y = math.floor(players[i].y + 1)
				elseif players[i].joystick:getGamepadAxis("lefty") < -0.5 then
					players[i].y = math.floor(players[i].y - 1)
				end
				if (players[i].joystick:getGamepadAxis("leftx") > 0.5 ) then
					players[i].x = math.floor(players[i].x + 1)
				elseif players[i].joystick:getGamepadAxis("leftx") < -0.5 then
					players[i].x = math.floor(players[i].x - 1)
				end
				players[i].lastMovement = love.timer.getTime()
			end

			if (players[i].joystick:isGamepadDown('a') ) then
				
			end
		end
	end

	checkPlayers()

	if love.timer.getTime() - _L.lastMove > _L.defilement then
		_L:moveBackground()
		checkPlayers()
		_L.lastMove = love.timer.getTime()
	end

end

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function checkPlayers()
	if #players > 0 then
		for i = 1, #players do
			if _L:getTile(math.floor(players[i].x),math.floor(players[i].y)).id ~= Tile.id.sky and _L:getTile(math.floor(players[i].x),math.floor(players[i].y)).id ~= Tile.id.bonus then
				print("perdu")
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
			elseif _L:getTile(i,j).id == Tile.id.bonus then
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
	for i = 1, #players do
		_L:placePlayer(players[i])
	end
	_L.lastMove = love.timer.getTime()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("quit")
	elseif key == " " then
		love.generate()
	end
end

function love.joystickpressed(joystick, button )
	if not findPlayer(joystick) then
		local _P = Player.new(joystick)
		_P.img = love.graphics.newImage("images/cube.png")
		_L:placePlayer(_P)
		table.insert(players, _P)
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
