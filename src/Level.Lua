local Level_mt = {}
local Level = {}
local Tile = require("Tile")

function Level.new(options)
	options = options or {}
	self = setmetatable({}, {__index = Level_mt})
	
	self.data = {}
	self.xsize = options.xsize or 11
	self.ysize = options.ysize or 7
	self.w = self.xsize * 2 +1
	self.h = self.ysize * 2 +1

	self:createBase()

	return self
end

function Level_mt:createBase()
	for i=1, self.w do
		for j=1, self.h do
			if j == 1 then
				self:setTile(i, j, Tile.new(Tile.id.floor))
			elseif j == self.h then
				self:setTile(i, j, Tile.new(Tile.id.floor))
			else
				self:setTile(i, j, Tile.new(Tile.id.sky))
			end
		end
	end
end

function Level_mt:generate()
	local rand = 0

	-- bordure terre --

	for i=1, self.w do
		for j=1, self.h do
			if j == 2 or j == self.h-1 then
				rand = math.floor(math.random()*2)
				if rand == 0 then
					self:setTile(i, j, Tile.new(Tile.id.ground))
				end
			end
		end
	end

	--milieu terre -- 

	for i=1, self.w do
		for j=1, self.h do
			if self:getTile(i, j-1).id == Tile.id.ground and self:getTile(i, j).id == Tile.id.sky and j < self.h / 3 then
				rand = math.floor(math.random()*2)
				if rand == 0 then
					self:setTile(i, j, Tile.new(Tile.id.ground))
				end
			elseif self:getTile(i, j+1).id == Tile.id.ground and self:getTile(i, j).id == Tile.id.sky and j > self.h / 3  then
				rand = math.floor(math.random()*2)
				if rand == 0 then
					self:setTile(i, j, Tile.new(Tile.id.ground))
				end
			end
		end
	end

	-- herbe --

	for i=1, self.w do
		for j=1, self.h do
			if self:getTile(i, j-1).id == Tile.id.ground and self:getTile(i, j).id == Tile.id.sky then
				self:setTile(i, j, Tile.new(Tile.id.grass))
			elseif self:getTile(i, j+1).id == Tile.id.ground and self:getTile(i, j).id == Tile.id.sky  then
				self:setTile(i, j, Tile.new(Tile.id.grass))
			elseif self:getTile(i+1, j).id == Tile.id.ground and self:getTile(i, j).id == Tile.id.sky  then
				self:setTile(i, j, Tile.new(Tile.id.grass))
			elseif self:getTile(i-1, j).id == Tile.id.ground and self:getTile(i, j).id == Tile.id.sky  then
				self:setTile(i, j, Tile.new(Tile.id.grass))
			end
		end
	end

	-- piege --

	for i=1, self.w do
		for j=1, self.h do
			if self:getTile(i+1, j).id ~= Tile.id.sky and self:getTile(i-1, j).id ~= Tile.id.sky 
			and self:getTile(i+1, j-1).id ~= Tile.id.sky and self:getTile(i+1, j-1).id ~= Tile.id.sky
			and self:getTile(i, j).id == Tile.id.sky and j > self.h / 3 then
				self:setTile(i, j, Tile.new(Tile.id.trap))

			elseif self:getTile(i+1, j).id ~= Tile.id.sky and self:getTile(i-1, j).id ~= Tile.id.sky 
			and self:getTile(i-1, j+1).id ~= Tile.id.sky and self:getTile(i+1, j+1).id ~= Tile.id.sky
			and self:getTile(i, j).id == Tile.id.sky and j < self.h / 3 then
				self:setTile(i, j, Tile.new(Tile.id.trap))
			end
		end
	end

	--self:printLevel()
end

function Level_mt:printLevel()
	for j=1, self.h do
		local tab = ""
		for i=1, self.w do
			tab = tab..self:getTile(i, j).id
		end
		print (tab)

	end
end

function Level_mt:findCollision(x, y)
	for i=1, self.w do
		for j=1, self.h do
			if self:getTile(x, y).id ~= Tile.id.sky then
				return true
			end
		end
	end
	return false
end

function Level_mt:placeFlag()
	for j = self.h, 1, -1 do
		if self:getTile(self.w, j).id == Tile.id.sky then
			self:setTile(self.w, j, Tile.new(Tile.id.flag))
			return
		end
	end
end
function Level_mt:placePlayer(player)
	local placementX = 1
	for j = self.h, 1, -1 do
		if self:getTile(placementX, j).id == Tile.id.sky then
			player.x = placementX
			player.y = j
			return
		elseif self:getTile(placementX, j).id == Tile.id.trap then
			placementX = placementX + 1
			j = self.h
		end
	end
end

function Level_mt:setTile(x, y, tile)
	x = ((x-1)%self.w)+1
	y = ((y-1)%self.h)+1
	self.data[ (x-1) + (y-1) * self.w + 1  ] = tile
end

function Level_mt:getTile(x, y)
	x = ((x-1)%self.w)+1
	y = ((y-1)%self.h)+1
	return self.data[ (x-1) + (y-1) * self.w + 1 ]
end

return Level