--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local mapModel = class("autoView", cc.Node)

function mapModel:ctor(maxEventCount, maxProblemCount)
    self.maxEventCount = maxEventCount
    self.maxProblemCount = maxProblemCount
    print("maxProblemCount = " .. maxProblemCount)
    print("maxEventCount = " .. maxEventCount)
    self.map = {1,1,1,1,1,
                1,1,1,1,1}
    
    self.event = {0,0,0,0,0,
                  0,0,0,0,0}

    self.pushEventFunc = {
        [1] = function()
            self.event[#self.event + 1] = cc.exports.tools.getRandom(0)
        end,

        [2] = function()
            self.event[#self.event + 1] = cc.exports.tools.getRandom(self.maxEventCount)
        end,

        [3] = function()
            self.event[#self.event + 1] = cc.exports.tools.getRandom(self.maxProblemCount)
        end,
    }
end

function mapModel:pushItem()
    local rate = cc.exports.tools.getRandom(100)
    if rate > NORMAL_RATE + EVENT_RATE then --problem
        print("a new problem")
        self.map[#self.map + 1] = 3
    elseif rate > NORMAL_RATE then          --event
        print("a new event")
        self.map[#self.map + 1] = 2
    else                                    --normal
        print("a new normal")
        self.map[#self.map + 1] = 1
    end
    
    print("map item value")
    self.pushEventFunc[self.map[#self.map]]()
end

function mapModel:popItem()
    table.remove(self.map, 1)
    table.remove(self.event, 1)
end

return mapModel

--endregion
