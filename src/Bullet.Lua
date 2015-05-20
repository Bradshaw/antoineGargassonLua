local Bullet_mt = {}
local Bullet = {}

function Bullet.new(x,y, player)
	self = setmetatable({}, {__index = Bullet_mt})
	
	self.x = x
	self.y = y
	self.player = player

	return self
end

return Bullet