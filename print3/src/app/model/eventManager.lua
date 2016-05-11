--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local eventManager = {}

function eventManager.init()
    eventManager.event = cc.exports.json.decode(cc.exports.tools.readFile("event.txt"))
    eventManager.eventCount = #eventManager.event
end

return eventManager

--endregion
