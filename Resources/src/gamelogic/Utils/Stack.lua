local Stack = class("Stack")

function Stack:ctor()
	self:Clear()
end

function Stack:Push(data)
	self.size = self.size+1
	self.stackList[self.size]=data
end

function Stack:Pop()
	assert(self.size>0,"Stack no data to Pop")
	local data = self.stackList[self.size]
	self.size = self.size -1
	return data
end

function Stack:Top()
	assert(self.size>0,"Stack no data")
	return self.stackList[self.size]
end

function Stack:GetSize()
	return self.size
end

function Stack:Print()
	assert(self.size>0,"Stack no data")

	for i=1,self.size do
		print(self.stackList[i].." ")
	end
end

function Stack:Clear()
	self.stackList = {}
	self.size = 0
end

function Stack:Remove(data)
	-- body
	local stackTemp = Stack:new()

	while self:GetSize() > 0 do
		local top = self:Pop()

		if top == data then break end

		stackTemp:Push(top)
	end

	while stackTemp:GetSize() > 0 do
		local top = stackTemp:Pop()
		self:Push(top)
	end
end

return Stack