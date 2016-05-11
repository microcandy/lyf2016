--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--固定popup类
--提供底板littlePad.png，叉键close.png，勾键yes.png，黑底图片black.png
local msgPopup = class("msgPopup", cc.Layer)

function msgPopup:ctor()
    --黑底scale9精灵，纯黑150透明，接收触摸事件
    local  listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(function(touch, event)
        return false
        end,cc.Handler.EVENT_TOUCH_BEGAN )
    listenner:registerScriptHandler(function(touch, event)
        end,cc.Handler.EVENT_TOUCH_MOVED )
    listenner:registerScriptHandler(function(touch, event)
        end,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)

	self.popupBG = ccui.Scale9Sprite:create("black.png")
        :addTo(self)
    self.popupBG:setOpacity(150)
    self.popupBG:setContentSize(cc.size(display.right, display.top))
    self.popupBG:setVisible(false)

    --整个popup的root
    self.r = display.newNode()
		:addTo(self)
	self.r:setVisible(false)

    --底板
    display.newSprite("blackPad.png")
        :addTo(self.r)

    --按键回调
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            sender:setScale(1.1)
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            if sender == self.yes and self.yesCall then 
                print("self.yesCall()")
                self.yesCall()
                self.yesCall = nil
            elseif sender == self.close and self.noCall then
                print("self.noCall()")
                self.noCall()
                self.noCall = nil

                cc.exports.soundM.click()
            end
            self:hide() 
            sender:setScale(1)
        elseif eventType == ccui.TouchEventType.canceled then
            sender:setScale(1)
        end
    end

    --叉键，
    self.close = ccui.Button:create()
    self.close:setTouchEnabled(true)
    self.close:loadTextures("no1.png", "no2.png", "")
    self.close:setPosition(cc.p(168, 70))
    self.close:addTouchEventListener(touchEvent)
    self.r:addChild(self.close)

    --确认键
    self.yes = ccui.Button:create()
    self.yes:setTouchEnabled(true)
    self.yes:loadTextures("yes1.png", "yes2.png", "")
    self.yes:setPosition(cc.p(0, -65))
    self.yes:addTouchEventListener(touchEvent)
    self.r:addChild(self.yes)
    --popup默认显示的文本
    self.Label = cc.LabelTTF:create("未知的弹窗信息", "Arial", 24, cc.size(300, 0 ))
        :addTo(self.r)
    self.Label:setPosition(0, 5)
    self.Label:setColor(cc.c3b(100,100,100))
end

--显示popup，传入需要显示的文本和回调函数
function msgPopup:show(text, yes, no)
    self.yesCall = yes
    self.noCall = no
    
	if type(text) == "string" then self.Label:setString(text) 
	else self.Label:setString("未知的弹窗信息") end

	self.popupBG:setVisible(true)
	self.r:setVisible(true)
	self.r:setScale(0.05)
    --popup果冻效果
	self.r:runAction(transition.sequence({CCScaleTo:create(0.15, 1.2, 1.2), CCScaleTo:create(0.1, 1.2, 1.2), CCScaleTo:create(0.1, 1.0, 1.0)}))
end

--隐藏popup和黑底
function msgPopup:hide()
    self.yesCall = nil
    self.noCall = nil

	self.popupBG:setVisible(false)
	self.r:setVisible(false)
end

return msgPopup
--endregion
