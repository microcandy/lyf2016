--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local counterModel = class("counterModel", cc.Node)

function counterModel:ctor()
    self.step = 0
    schedule(self, function() self.step = self.step + 0.1 end, 0.1)
end

function counterModel:getTime()
    return self.step
end

return counterModel

--endregion
