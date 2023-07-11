local IMsgInterface = class("IMsgInterface")

function IMsgInterface:addListener(opcode,callback)
	local h = callback ~= nil and handler(self,callback) or handler(self,self._OnMessage)
	gMessageManager:registerMessageHandler(opcode,h)
	self.msgID = self.msgID or {}
	local data  = {}
	data.opcode = opcode
	data.callback = h
	table.insert(self.msgID,data)
end

function IMsgInterface:_OnMessage(message)

end

function IMsgInterface:_removeAllMsg()
	for _,data in ipairs(self.msgID or {}) do
		gMessageManager:removeMessageHandler(data.opcode,data.callback)
	end

	self.msgID = {}
end

return IMsgInterface