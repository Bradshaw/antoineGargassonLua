local Player_mt = {}
local Player = {}

function Player.new(joystick)
	self = setmetatable({}, {__index = Player_mt})
	
	self.x = 1
	self.y = 5
	self.life = 2
	self.speed = 0.05

	self.lastMovement = 0;

	self.joystick = joystick

	return self
end

return Player