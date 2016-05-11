--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local inputViewC = {}

local eventDispatcher = require("app.model.eventDispatcher")

eventDispatcher.extend(inputViewC)

function inputViewC.updateData(obj, data)
    cc.exports.tools.lockScene()
    obj:setVisible(true)

    obj:getChildByName("problemText"):setString(data.text)
    
    local btnSure = obj:getChildByName("btnSure")
    btnSure:addTouchEventListener(function(sender,event)
        print("sure input button="..event)--event是触摸类型，0,1,2,3分别是began，moved，ended，canceled
        if event == ccui.TouchEventType.ended then
            print("sure input")
            if obj:getChildByName("input"):getString() == data.answer then
                print("bingo")
                inputViewC:dispatchEvent("INPUT_PASS")
            else
                inputViewC:dispatchEvent("INPUT_NOT_PASS")
            end
            obj:getChildByName("input"):setString("")
            obj:setVisible(false)
            cc.exports.tools.unlockScene()
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
end

return inputViewC

--endregion
