local Player_mt = {}
local Player = {}

function Player.new(joystick)
	self = setmetatable({}, {__index = Player_mt})
	
	self.x = 1
	self.y = 5
	self.life = 2
	self.speed = 10
	self.isInAir = true
	self.gravity = 5

	self.joystick = joystick

	return self
end

return Player