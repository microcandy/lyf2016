--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local eventView = class("eventView", cc.Node)
local eventDispatcher = require("app.model.eventDispatcher")

function eventView:ctor()
    eventDispatcher.extend(self)

    self.viewWidth = 424
    self.viewHeight = 160
    self.titleWidth = 270
    self.selfTitleX = self.viewWidth - self.titleWidth + self.titleWidth / 2
    self.npcTitleX = self.titleWidth / 2 + 30
    self.titleY = self.viewHeight - 20
    self.dialogY = self.titleY - 20
    self.selfX = 50
    self.selfY = self.viewHeight - 60
    self.npcX = self.viewWidth - 50
    self.npcY = self.selfY

    self.padSprite = cc.Scale9Sprite:create("eventPad.png", cc.rect(0, 0, 424, 348), cc.rect(5, 30, 400, 265))
    self.padSprite:setContentSize(self.viewWidth, self.viewHeight)
    self:addChild(self.padSprite)
end

--------------------------------
-- self.padSprite 锚点（0，0）
--------------------------------
function eventView:bindEvent(eventId)
    print("eventId" .. eventId)
    self.eventData = cc.exports.eventM.event[eventId]
    self.dialog = self.eventData.dialog.before
    self.dialogStep = 1
end

function eventView:removeEvent()
    self.eventData = {}
    self.dialog = {}
    self.dialogStep = 1
    self.result = nil
end

function eventView:btnCallback(sender, event)
    if event == ccui.TouchEventType.ended then
        self.btnCallbackFunc[sender]()
    elseif event == ccui.TouchEventType.began then
        cc.exports.soundM.click()
    end
end

function eventView:refresh()
    if self.dialogStep > #self.dialog then
        self:endEvent()
        return
    end

    if not self.dialog[self.dialogStep].btn then
        self.btnNo:setVisible(false)
        self.btnYes:setVisible(false)
        self.btnNext:setVisible(true)
    else
        self.btnNo:setVisible(true)
        self.btnYes:setVisible(true)
        self.btnNext:setVisible(false)
    end

    if self.dialog[self.dialogStep].who == "self" then
        self.selfSprite:setVisible(true)
        self.npcSprite:setVisible(false)

        self.title:setPosition(self.selfTitleX , self.titleY)
        self.dialogLabel:setPosition(self.selfTitleX , self.dialogY)
    else
        self.selfSprite:setVisible(false)
        self.npcSprite:setVisible(true)

        self.title:setPosition(self.npcTitleX , self.titleY)
        self.dialogLabel:setPosition(self.npcTitleX , self.dialogY)
    end

    self.dialogLabel:setString(self.dialog[self.dialogStep].text)
end

function eventView:showEvent()
    print("eventView:showEvent()")
    self:setVisible(true)
    if not self.eventData or self.eventData == {} then
        self.padSprite:setVisible(false)
        print("eventView:showEvent() do nothing")
        return
    end

    if self.title then
        self.title:setString(self.eventData.name)
        self.npcSprite:setTexture(self.eventData.npc .. "npc.png")
        self.selfSprite:setTexture(cc.UserDefault:getInstance():getStringForKey("heroShow") .. ".png")
        self:refresh()
        return
    end

    self.title = cc.LabelTTF:create(self.eventData.name, "Arial", 20, cc.size(self.titleWidth, 0 ))
    self.padSprite:addChild(self.title)
    self.title:setColor(cc.c3b(0, 0, 0))
    self.title:setPosition(self.selfTitleX ,  self.titleY)

    self.btnNext = ccui.Button:create("btnNext1.png", "btnNext2.png", "")
    self.padSprite:addChild(self.btnNext)
    self.btnNext:setPosition(self.viewWidth - 40 , 20)
    self.btnNext:setTouchEnabled(true)
    self.btnNext:addTouchEventListener(function(sender, event) self:btnCallback(sender, event) end)

    self.btnYes = ccui.Button:create("btnYes1.png", "btnYes2.png", "")
    self.padSprite:addChild(self.btnYes)
    self.btnYes:setPosition(self.viewWidth / 3 , 20)
    self.btnYes:setTouchEnabled(true)
    self.btnYes:addTouchEventListener(function(sender, event) self:btnCallback(sender, event) end)

    self.btnNo = ccui.Button:create("btnNo1.png", "btnNo2.png", "")
    self.padSprite:addChild(self.btnNo)
    self.btnNo:setPosition(self.viewWidth / 3 * 2 , 20)
    self.btnNo:setTouchEnabled(true)
    self.btnNo:addTouchEventListener(function(sender, event) self:btnCallback(sender, event) end)

    self.btnCallbackFunc = {
        [self.btnNext] = function()
            self.dialogStep = self.dialogStep + 1
            self:refresh()
        end,
        [self.btnYes] = function()
            self.dialogStep = 1
            self.dialog = self.eventData.dialog.afterYes
            self.result = "afterYes"
            self:refresh()
        end,
        [self.btnNo] = function()
            self.dialogStep = 1
            self.dialog = self.eventData.dialog.afterNo
            self.result = "afterNo"
            self:refresh()
        end,
    }

    self.npcSprite = cc.Sprite:create(self.eventData.npc .. "npc.png")
    self.npcSprite:setPosition(self.npcX, self.npcY)
    self.padSprite:addChild(self.npcSprite)

    self.selfSprite = cc.Sprite:create(cc.UserDefault:getInstance():getStringForKey("heroShow") .. ".png")
    self.selfSprite:setPosition(self.selfX, self.selfY)
    self.padSprite:addChild(self.selfSprite)

    self.dialogLabel = cc.LabelTTF:create(self.dialog[self.dialogStep].text, "Arial", 16, cc.size(self.titleWidth, 0 ))
    self.padSprite:addChild(self.dialogLabel)
    self.dialogLabel:setAnchorPoint(0.5, 1)
    self.dialogLabel:setColor(cc.c3b(0, 0, 0))
    self.dialogLabel:setPosition(self.selfTitleX , self.dialogY)

    self:refresh()
end

function eventView:endEvent()
    self:dispatchEvent("END_EVENT", self.eventData["result"][self.result])
    self:setVisible(false)
    self:removeEvent()
end

return eventView

--endregion
