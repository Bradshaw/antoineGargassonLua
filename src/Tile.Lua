local Tile_mt = {}
local Tile = {}

Tile.id = {floor = 0, grass = 1, ground = 2, sky = 3, bonus = 4, flag = 5}
Tile.size = 32

function Tile.new( id )
	local self = setmetatable({},{__index=Tile_mt})
	self.id = id

	return self
end

return Tile