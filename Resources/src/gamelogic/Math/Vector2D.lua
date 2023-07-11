local sqrt = math.sqrt
local setmetatable = setmetatable
local rawget = rawget
local math = math
local acos = math.acos
local max = math.max

local Vector2D = {}
local _getter = {}

Vector2D.__index = function(t,k)
	local var = rawget(Vector2D, k)
	if var ~= nil then
		return var
	end
	
	var = rawget(_getter, k)
	if var ~= nil then
		return var(t)
	end
	
	return rawget(unity_vector2, k)
end

Vector2D.__call = function(t, x, y)
	return setmetatable({x = x or 0, y = y or 0}, Vector2D)
end

function Vector2D.new(x, y)
	return setmetatable({x = x or 0, y = y or 0}, Vector2D)
end

function Vector2D:Zero()
	-- body
	self.x = 0
	self.y = 0
end

function Vector2D.isZero(v)
	return v:Magnitude() <= 9.999999e-11
end

function Vector2D:Set(x,y)
	self.x = x or 0
	self.y = y or 0	
end

function Vector2D:Get()
	return self.x, self.y
end

function Vector2D.Distance(a, b)
	return sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
end

function Vector2D:SqrMagnitude()
	return self.x * self.x + self.y * self.y
end

function Vector2D:Clone()
	return setmetatable({x = self.x, y = self.y}, Vector2D)
end

function Vector2D.Normalize(v)
	local x = v.x
	local y = v.y
	local magnitude = sqrt(x * x + y * y)

	if magnitude > 1e-05 then
		x = x / magnitude
		y = y / magnitude
    else
        x = 0
		y = 0
	end

	return setmetatable({x = x, y = y}, Vector2D)
end

function Vector2D:SetNormalize()
	local magnitude = sqrt(self.x * self.x + self.y * self.y)

	if magnitude > 1e-05 then
		self.x = self.x / magnitude
		self.y = self.y / magnitude
    else
        self.x = 0
		self.y = 0
	end

	return self
end

function Vector2D.Magnitude(v)
	return sqrt(v.x * v.x + v.y * v.y)
end

function Vector2D.Length(v)
	return sqrt(v.x * v.x + v.y * v.y)
end

function Vector2D.Distance(a, b)
	return sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
end

function Vector2D.Lerp(a, b, t)
	if t < 0 then
		t = 0
	elseif t > 1 then
		t = 1
	end

    return setmetatable({x = a.x + (b.x - a.x) * t, y = a.y + (b.y - a.y) * t}, Vector2D)
end

function Vector2D.RotationVector(v,angle)
	local x = v.x;
	local y = v.y;
	local sin = math.sin(math.pi * angle / 180);
	local cos = math.cos(math.pi * angle / 180);
	local newX = x * cos - y * sin;
	local newY = x * sin + y * cos;
	return setmetatable({x=newX,y=newY},Vector2D)
end

function Vector2D:Sign(v2)
	return self.y*v2.x > self.x*v2.y and -1 or 1
end

Vector2D.__tostring = function(self)
	return string.format("(%f,%f)", self.x, self.y)
end

Vector2D.__div = function(va, d)
	return setmetatable({x = va.x / d, y = va.y / d}, Vector2D)
end

Vector2D.__mul = function(a, d)
	if type(d) == "number" then
		return setmetatable({x = a.x * d, y = a.y * d}, Vector2D)
	else
		return setmetatable({x = a * d.x, y = a * d.y}, Vector2D)
	end
end

Vector2D.__add = function(a, b)
	return setmetatable({x = a.x + b.x, y = a.y + b.y}, Vector2D)
end

Vector2D.__sub = function(a, b)
	return setmetatable({x = a.x - b.x, y = a.y - b.y}, Vector2D)
end

Vector2D.__unm = function(v)
	return setmetatable({x = -v.x, y = -v.y}, Vector2D)
end

Vector2D.__eq = function(a,b)
	return ((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2) < 9.999999e-11
end

return Vector2D
