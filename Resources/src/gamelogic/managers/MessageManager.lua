local MessageManager = class("MessageManager")

function MessageManager:ctor()
	self.handlerTable = {}
    self.delayMessageList = {}
end

function MessageManager:Instance()
	if self.instance == nil then
		self.instance = self:new()
	end

	return self.instance
end

function MessageManager:table_simpleEqual(t1,t2)
    if #t1 ~= #t2 then return false end
    for k,v in pairs(t1) do
        if v ~= t2[k] then
            return false
        end
    end
    for k,v in pairs(t2) do
        if v ~= t1[k] then
            return false
        end
    end
    return true
end


function MessageManager:registerMessageHandler(messageID,messageHandler)
	assert(messageHandler, "\n--========this handler is nil========--"..debug.traceback(), 'MessageManager error handler')
      
    assert(type(messageHandler) =='function', "\n--messageHandler not function--"..debug.traceback(), 'MessageManager error handler')

    self.handlerTable[messageID] = self.handlerTable[messageID] or {}
    table.insert(self.handlerTable[messageID],messageHandler)
end

function MessageManager:removeMessageHandler(messageID,messageHandler)
    local handlerMap = self.handlerTable[messageID]
    if handlerMap then
        for i,k in pairs(handlerMap) do
            if k == messageHandler then
                handlerMap[i] = nil
            end
        end
    end
end

function MessageManager:removeAllMessageHandler(messageID)
    if messageID then
        self.handlerTable[messageID] = nil
    end
end

function MessageManager:sendMessage(id,message)
	message = message or {}
	message.messageID = id

    table.insert(self.delayMessageList,message)
end

function MessageManager:sendMessageInstant(id, message)
    local HanderTable = self.handlerTable[id]
    if HanderTable then
        message = message or {}
        message.messageID = id
        for _,v in pairs(HanderTable) do    
            v(message)
        end
    end
end

function MessageManager:update(dt)
	if next(self.delayMessageList) then
		for _,message in pairs(self.delayMessageList) do
			local messageID = message.messageID
            local HanderTable = self.handlerTable[messageID]
            if HanderTable then
                for _,v in pairs(HanderTable) do                
                    v(message)
                end
            end
		end

		self.delayMessageList = {}
	end
end

gMessageManager= MessageManager:Instance()