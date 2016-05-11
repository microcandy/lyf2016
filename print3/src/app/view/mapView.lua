--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mapView = class("mapView", cc.Node)

local npcAnimaManager = require("app.model.npcAnimaManager")
local inputVC = require("app.view.inputView")
local selectV = require("app.view.selectView") 

function mapView:ctor(model)
    self.model = model
    self.npc = {}

    self.viewCircle = {}
    self.viewLen = 10
    self.delay = 1

    ---[[ autoBatchNode
    self.eventPools = {}
    self.normalPools = {}
    self.problemPools = {}
    for i = 1, self.viewLen do
        self.eventPools[i] = cc.Sprite:create("mapEventItem.png")
        self:addChild(self.eventPools[i])
    end
    for i = 1, self.viewLen do
        self.normalPools[i] = cc.Sprite:create("mapNormalItem.png")
        self:addChild(self.normalPools[i])
    end
    for i = 1, self.viewLen do
        self.problemPools[i] = cc.Sprite:create("mapProblemItem.png")
        self:addChild(self.problemPools[i])
    end
    --]]

    --autoBatchNode 下面开始4行注释 和 上面注释交换使用
    for i = 1, self.viewLen do
        self.viewCircle[i] = {
            ["event"] = self.eventPools[i],--cc.Sprite:create("mapEventItem.png"),
            ["normal"] = self.normalPools[i],--cc.Sprite:create("mapNormalItem.png"),
            ["problem"] = self.problemPools[i],--cc.Sprite:create("mapProblemItem.png"),
        }

        for k,v in pairs(self.viewCircle[i]) do
            --self:addChild(v)
            v:setPosition((i - 1) * 100, 0)
            v:setOpacity(150)
        end

        if self.model.map[i] == 1 then    --normal
            self.viewCircle[i].event:setVisible(false)
            self.viewCircle[i].problem:setVisible(false)
        elseif self.model.map[i] == 2 then --event
            self.viewCircle[i].normal:setVisible(false)
            self.viewCircle[i].problem:setVisible(false)
        else                             --problem
            self.viewCircle[i].event:setVisible(false)
            self.viewCircle[i].normal:setVisible(false)
        end
    end

    self.frameSprite = cc.Sprite:create("mapItemFrame.png")
    self.frameSprite:setPosition(3 * 100, 0)
    self:addChild(self.frameSprite)

    self.doingSprite = cc.Sprite:create("doing.png")
    self.doingSprite:setPosition(3 * 100, -20)
    self:addChild(self.doingSprite)

    self:initUpdateNewItemFunc()

    npcAnimaManager.load(self)
end

function mapView:pushItem(count)
    local function callback()
        for k,v in pairs(self.viewCircle) do
            if v.event.npc then v.event.npc:resume() end
        end
        --模型更新
        self.model:popItem()
        self.model:pushItem()
        --视图更新，队首元素回队尾
        if self.viewCircle[1].event:getPositionX() < 0 then
            print("pop 1")
            local t = self.viewCircle[1]
            table.remove(self.viewCircle, 1)
            if t.event.npc then 
                print("pop sprite")
                t.event.npc:resume()
                t.event.npc:stopAllActions()
                t.event.npc:removeSelf()
                t.event.npc = nil
            end

            t.event:setPosition(self.viewCircle[#self.viewCircle].event:getPosition())
            t.normal:setPosition(self.viewCircle[#self.viewCircle].event:getPosition())
            t.problem:setPosition(self.viewCircle[#self.viewCircle].event:getPosition())
            self.viewCircle[#self.viewCircle + 1] = t

        end
        self:updateNewItem()
        --移动
        for k1,v1 in pairs(self.viewCircle) do
            for _,v2 in pairs(v1) do
                v2:stopAllActions()
                v2:setPosition((k1 - 1) * 100, 0)
                transition.execute(v2, CCMoveBy:create(self.delay, cc.p(-100, 0)))
            end
        end
        performWithDelay(self, function() cc.exports.soundM.itemMove() end, 0.5)
    end

    --移动count格
    local sequenceTable = {}
    local delay = cc.DelayTime:create(self.delay)
    sequenceTable[#sequenceTable + 1] = delay
    sequenceTable[#sequenceTable + 1] = cc.CallFunc:create(function() 
        self.doingSprite:setVisible(false) 
    end)
    for i = 1, count do
        sequenceTable[#sequenceTable + 1] = delay
        sequenceTable[#sequenceTable + 1] = cc.CallFunc:create(callback)
    end
    sequenceTable[#sequenceTable + 1] = delay
    sequenceTable[#sequenceTable + 1] = cc.CallFunc:create(function() 
        self.doingSprite:setVisible(true)
        if self.model.map[5] == 1 then
            cc.exports.MainScene._autoView:setEnabled(true)
            cc.exports.MainScene.back:setEnabled(true)
        elseif self.model.map[5] == 2 then -- event
            cc.exports.eventV:bindEvent(self.model.event[5])
            cc.exports.eventV:showEvent()
        elseif self.model.map[5] == 3 then -- problem
            cc.exports.MainScene._autoView:setEnabled(true)
            if self.model.event[5] > cc.exports.activeInput.problemCount then --select
                selectV.updateData(cc.exports.selectPlay, cc.exports.activeSelect.problem[self.model.event[5] - cc.exports.activeInput.problemCount])
            else
                inputVC.updateData(cc.exports.inputPlay, cc.exports.activeInput.problem[self.model.event[5]])
            end
        end
        for k,v in pairs(self.viewCircle) do
            if v.event.npc then v.event.npc:pause() end
        end
    end)
    local sequence = cc.Sequence:create(sequenceTable)

    self:runAction(sequence)
end

function mapView:setVisibleTrue(key)
    local key = key or "normal"
    for k,v in pairs(self.viewCircle[#self.viewCircle]) do
        v:setVisible(k == key)
    end
end

function mapView:initUpdateNewItemFunc()
    self.updateNewItemFunc = {
        [1] = function()
            self:setVisibleTrue("normal")
        end,
        [2] = function()
            self:setVisibleTrue("event")

            do
                self.viewCircle[#self.viewCircle].event.eventData = cc.exports.eventM.event[self.model.event[#self.model.event]]

                self.npcframes = {}
                for i = 0, self.viewCircle[#self.viewCircle].event.eventData.plistmax do
                    self.npcframes[i] = self.cache:getSpriteFrame(self.viewCircle[#self.viewCircle].event.eventData.npc .. "." .. self.viewCircle[#self.viewCircle].event.eventData.plistitem .. i .. ".png")
                end

                self.viewCircle[#self.viewCircle].event.npc = cc.Sprite:createWithSpriteFrameName(self.viewCircle[#self.viewCircle].event.eventData.npc .. "." .. self.viewCircle[#self.viewCircle].event.eventData.plistitem .. "0.png")
                self.viewCircle[#self.viewCircle].event.npc:setAnchorPoint(0.5, 0)
                local npcanimation = cc.Animation:createWithSpriteFrames(self.npcframes, 0.1)
                self.viewCircle[#self.viewCircle].event.npc:runAction(cc.RepeatForever:create(cc.Animate:create(npcanimation)))

                --self.viewCircle[#self.viewCircle].event.npc:setPosition(50, - 230 + self.viewCircle[#self.viewCircle].event.npc:getContentSize().height / 2)
                self.viewCircle[#self.viewCircle].event.npc:setPosition(50, - 247)
                self.viewCircle[#self.viewCircle].event.npc:setScale(1.5)

                self.viewCircle[#self.viewCircle].event:addChild(self.viewCircle[#self.viewCircle].event.npc)
            end
            
        end,
        [3] = function()
            self:setVisibleTrue("problem")
        end,
    }
end

function mapView:updateNewItem()
    self.updateNewItemFunc[self.model.map[#self.model.map]]()
end

return mapView

--endregion
