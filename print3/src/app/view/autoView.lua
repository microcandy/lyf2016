--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local autoView = class("autoView", cc.Node)

local eventDispatcher = require("app.model.eventDispatcher")

function autoView:ctor()
    --开启事件
    self:enableNodeEvents()
    eventDispatcher.extend(self)

    --抛骰子动画
    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("auto.plist", "auto.png")

    local indexs = {0,1,2,3,4,5,6,7,5,6,7,8,9}

    self.frames = {}
    for i = 1, #indexs do
        self.frames[i] = cache:getSpriteFrame("BoardGameUI.Dice.-1." .. indexs[i] .. ".png")
    end

    self.auto = cc.Sprite:createWithSpriteFrameName("BoardGameUI.Dice.-1." .. 0 .. ".png")
    self.auto:setAnchorPoint(0.5, 0)
    self:addChild(self.auto)

    local animation = cc.Animation:createWithSpriteFrames(self.frames, 0.1)
    self.anima = cc.Animate:create(animation)
    self.anima:retain()
    self.auto:setVisible(false)
    
    --按键回调
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            if self.rollFlag then
                cc.exports.btnBack:setEnabled(false)
                self:getNew()
            end
        elseif eventType == ccui.TouchEventType.canceled then
        end
    end

    --骰子
    self.display = {}
    for i = 1, 6 do
        self.display[i] = ccui.Button:create("auto" .. i .. ".png", "auto" .. i .. ".png", "")
        self.display[i]:setScale(1.2)
        self.display[i]:setVisible(false)
        self.display[i]:setTouchEnabled(true)
        self.display[i]:setPositionY(10)
        self.display[i]:setAnchorPoint(0.5, 0)
        self.display[i]:addTouchEventListener(touchEvent)
        self:addChild(self.display[i])
    end
    self.display[1]:setVisible(true)
    self.displayIndex = 1
    self.displaying = self.display[self.displayIndex]

    --骰子鼠标动画
    cache:addSpriteFrames("autoMouse.plist", "autoMouse.png")

    self.mouseframes = {}
    for i = 1, 6 do
        self.mouseframes[i] = cache:getSpriteFrame("Cursor.2." .. i .. ".png")
    end

    self.mouse = cc.Sprite:createWithSpriteFrameName("Cursor.2.0.png")
    self.mouse:setPositionY(10)
    self:addChild(self.mouse)
    local mouseanimation = cc.Animation:createWithSpriteFrames(self.mouseframes, 0.1)
    self.mouse:runAction(cc.RepeatForever:create(cc.Animate:create(mouseanimation)))

    cc.exports.mouseAnima = cc.UserDefault:getInstance():getBoolForKey("mouseAnima")
    if not cc.exports.mouseAnima then
        performWithDelay(self, function() self.mouse:pause() end, 0.1)
    end
end

--显示跑骰子动画
function autoView:showAnima()
    cc.exports.MainScene:hideTip()
    self.auto:setVisible(true)
    transition.execute(self.auto, self.anima, {onComplete = function() self:afterAnima() end})
end

--跑骰子动画结束后
function autoView:afterAnima()
    self.auto:setVisible(false)
    self.displaying:setVisible(true)
    self:setEnabled(false)
    print("self:dispatchEvent(AFTER_AUTO) " .. self.displayIndex)
    self:dispatchEvent("AFTER_AUTO", self.displayIndex)
end

function autoView:setEnabled(b)
    for k,v in pairs(self.display) do
        v:setEnabled(b)
    end
end

--新骰子标识数
function autoView:getNew(index)
    --self.rollFlag = false
    self.displaying:setVisible(false)
    self.displayIndex = index or math.floor(math.random(1, 6))
    self.displaying = self.display[self.displayIndex]
    self:showAnima()

    cc.exports.soundM.auto()

    return self.displayIndex
end

--允许抛骰子
function autoView:setRollFlag()
    self.rollFlag = true
end

function autoView:onEnter()
    print("autoView:onEnter()")
end

function autoView:onExit()
    print("autoView:onExit()")
    self.anima:release()
end

return autoView
--endregion
