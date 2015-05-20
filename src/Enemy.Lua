local Enemy_mt = {}
local Enemy = {}

function Enemy.new(joystick)
	self = setmetatable({}, {__index = Enemy_mt})
	
	self.x = 1
	self.y = 5
	self.life = 1
	self.speed = 0.05

	return self
end

return Enemy