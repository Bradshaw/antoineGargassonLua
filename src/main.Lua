function love.load(args)
	math.randomseed(os.time())
	Level = require("Level")
	Tile = require("Tile")
	Player = require("Player")
	Enemy = require("Enemy")
	Bullet = require("Bullet")

	players = {}
	ennemies = {}
	bullets = {}

	love.generate()
end

function love.update(dt)
	if #players > 0 then
		for i = 1, #players do
			if love.timer.getTime() - players[i].lastMovement  > players[i].speed then
				if (players[i].joystick:getGamepadAxis("lefty") > 0.5 ) then
					players[i].y = math.floor(players[i].y + 1)
					players[i].life = players[i].life - 1
				elseif players[i].joystick:getGamepadAxis("lefty") < -0.5 then
					players[i].y = math.floor(players[i].y - 1)
					players[i].life = players[i].life - 1
				end
				if (players[i].joystick:getGamepadAxis("leftx") > 0.5 ) then
					players[i].x = math.floor(players[i].x + 1)
					players[i].life = players[i].life - 1
				elseif players[i].joystick:getGamepadAxis("leftx") < -0.5 then
					players[i].x = math.floor(players[i].x - 1)
					players[i].life = players[i].life - 1
				end
				players[i].lastMovement = love.timer.getTime()
			end

			if (players[i].joystick:isGamepadDown('a') ) then
				players[i].fire.play()
				_B = Bullet.new(players[i].x + 1 , players[i].y + 0.5, players[i])
				_B.img = love.graphics.newImage("images/bullet.png")
				table.insert(bullets, _B)
			end
		end
	end

	checkPlayers()

	if love.timer.getTime() - _L.lastSpawn > _L.speedSpawn then
		_E = Enemy.new()
		_E.img = love.graphics.newImage("images/gaplusennemy.png")
		table.insert(ennemies, _E)
		_L:placeEnnemy(_E)
		_L.lastSpawn = love.timer.getTime()
	end

	if love.timer.getTime() - _L.lastMove > _L.defilement then
		_L:moveBackground()
		if #players > 0 then
			for i = 1, #players do
				players[i].life = players[i].life - 1
			end
		end
		moveBullets()
		checkBullets()
		checkEnnemies()
		moveEnemies()
		checkPlayers()
		_L.lastMove = love.timer.getTime()
	end

end

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function moveEnemies()
	if #ennemies > 0 then
		for i = 1, #ennemies do
			ennemies[i].x = math.floor(ennemies[i].x - 1)
		end
	end
end

function checkEnnemies()
	if #ennemies > 0 and #bullets > 0 then
		for i = #ennemies, 1, -1 do
			for j = #bullets, 1, -1 do
				if bullets[j] ~= nil and ennemies[i] ~= nil then 
					if math.floor(bullets[j].x) == ennemies[i].x and math.floor(bullets[j].y) == ennemies[i].y then
						bullets[j].player.life = bullets[j].player.life + 10
						table.remove(bullets, j)
						table.remove(ennemies, i)

					end
				end
			end
		end
	end
end

function moveBullets()
	if #bullets > 0 then
		for i = 1, #bullets do
			bullets[i].x = math.floor(bullets[i].x + 1)
		end
	end
end

function checkPlayers()
	if #players > 0 then
		for i = 1, #players do
			if players[i].life < 0 then
				love.generate()
			end
			if _L:getTile(math.floor(players[i].x),math.floor(players[i].y)).id ~= Tile.id.sky and _L:getTile(math.floor(players[i].x),math.floor(players[i].y)).id ~= Tile.id.bonus then
				love.generate()
			end
		end
	end
end

function clearBullets()
	if #bullets > 0 then
		for i = #bullets, 1, -1 do
			table.remove(bullets, i)
		end
	end
end

function checkBullets()
	if #bullets > 0 then
		for i = #bullets, 1, -1 do
			if _L:getTile(math.floor(bullets[i].x),math.floor(bullets[i].y)).id ~= Tile.id.sky and _L:getTile(math.floor(bullets[i].x),math.floor(bullets[i].y)).id ~= Tile.id.bonus then
				table.remove(bullets, i)
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
					love.graphics.print(players[i].life, players[i].x*Tile.size, (players[i].y + 1)*Tile.size)
				end
			end
			if #ennemies > 0 then
				for i = 1, #ennemies do
					love.graphics.draw(ennemies[i].img, ennemies[i].x*Tile.size, ennemies[i].y*Tile.size)
				end
			end
			if #bullets > 0 then
				for i = 1, #bullets do
					love.graphics.draw(bullets[i].img, bullets[i].x*Tile.size, bullets[i].y*Tile.size)
				end
			end
		end
	end
end

function love.generate()
	_L = Level.new()
	_L:generate()
	clearBullets()
	for i = 1, #players do
		_L:placePlayer(players[i])
		players[i].life = 100
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
		_P.img = love.graphics.newImage("images/gaplus.png")
		_P.fire = love.sound.newSoundData("fire.mp3")
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
