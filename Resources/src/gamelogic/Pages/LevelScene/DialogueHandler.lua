local DialogueHandler = class("DialogueHandler")
local StringUtil = TWRequire("StringUtil")

function DialogueHandler:ctor(dialogueNode)
	local director = cc.Director:getInstance()
    local winSize = director:getWinSize()

	local isChinese = StringUtil:isChinese()
	local endFix = isChinese and "_zh" or ""

	self._DialogueNode = dialogueNode
	self._LeftNameLabel = cc.utils.findChild(dialogueNode,"leftName"..endFix)
	self._RightNameLabel = cc.utils.findChild(dialogueNode,"rightName"..endFix)
	self._LeftDialogHead = cc.utils.findChild(dialogueNode,"LeftDialogHead")
	self._RightDialogHead = cc.utils.findChild(dialogueNode,"RightDialogHead")
	self._DialogueText = cc.utils.findChild(dialogueNode,"DialogueText"..endFix)
	self._curText = ""
	self._strLen = 0
	self._curTextIndex = 1

	local touchHandler = handler(self,self.onTouch)
	self._DialogPanelTouch = cc.utils.findChild(dialogueNode,"DialogPanelTouch")
	self._DialogPanelTouch:onTouch(touchHandler)
	self._DialogPanelTouch:setContentSize(winSize.width,winSize.height)
	self._hasDialogue = false

	self._curMoveTime = 0
	self._moveTimeDelta = 0.5
	self._curFinishTime = 0
	self._finishTimie = 2
end

function DialogueHandler:ShowDialogue(dialogId)
	local DialogueCfg = TWRequire("DialogueCfg")
	local Dialogue  = DialogueCfg[dialogId]
	self._curText = ""
	self._curTextIndex = 1

	if Dialogue then
		self._LeftNameLabel:setVisible(not (Dialogue.side == "right"))
		self._LeftDialogHead:setVisible(not (Dialogue.side == "right"))

		self._RightNameLabel:setVisible(Dialogue.side == "right")
		self._RightDialogHead:setVisible(Dialogue.side == "right")

		local curLabel = Dialogue.side == "right" and self._RightNameLabel or self._LeftNameLabel
		local curHead = Dialogue.side == "right" and self._RightDialogHead or self._LeftDialogHead
		curLabel:setString(_Lang(Dialogue.name))
		curHead:setSpriteFrame(Dialogue.icon)
		self._curText = _Lang(Dialogue.content)
		self._strLen = string.len(self._curText)
		self._curMoveTime = self._moveTimeDelta
		self._hasDialogue = true
		self._curTextIndex = 1
		self._curMoveTime = 0
		self._curFinishTime = 0
		self._finishTimie = 2
		self._DialogueText:setString("")
	end
end

function DialogueHandler:setFinishCallback(CB)
	self._finishCallback = CB
end

function DialogueHandler:update(dt)
	if not self._hasDialogue then return end

	if self._curTextIndex > self._strLen then
		if self._finishCallback then 
			self._curFinishTime = self._curFinishTime + dt
			if self._curFinishTime >= self._finishTimie then
				self._finishCallback()
				self._finishCallback = nil
			end
		end
		return
	end

	self._curMoveTime = self._curMoveTime + dt
	if self._curMoveTime >= self._moveTimeDelta then
		local newStr = string.sub(self._curText,0,self._curTextIndex)
		self._DialogueText:setString(newStr)
		self._curTextIndex = self._curTextIndex + 1
	end
end

function DialogueHandler:onTouch(event)
	if event.name == "ended" then
		if self._curTextIndex < self._strLen then
			self._curTextIndex = self._strLen
			self._DialogueText:setString(self._curText)
		else

			if self._finishCallback then
				self._finishCallback()
			end

			self._finishCallback = nil
		end

		self._hasDialogue = false
	end
end

return DialogueHandler