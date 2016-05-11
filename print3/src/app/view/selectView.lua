--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local selectViewC = {}

local eventDispatcher = require("app.model.eventDispatcher")

eventDispatcher.extend(selectViewC)

function selectViewC.updateData(obj, data)
    cc.exports.tools.lockScene()
    obj:setVisible(true)

    obj:getChildByName("problemText"):setString(data.text)
    obj:getChildByName("A"):setTitleText(data.A)
    obj:getChildByName("B"):setTitleText(data.B)
    obj:getChildByName("C"):setTitleText(data.C)
    obj:getChildByName("D"):setTitleText(data.D)

    local function onSelect(sender,event)
        --动态地变化音量大小
        if event == ccui.TouchEventType.ended then
            if sender:getName() == data.answer then
                print("bingo")
                selectViewC:dispatchEvent("SELECT_PASS")
            else
                selectViewC:dispatchEvent("SELECT_NOT_PASS")
            end
            obj:setVisible(false)
            cc.exports.tools.unlockScene()
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end

    obj:getChildByName("A"):addTouchEventListener(onSelect)
    obj:getChildByName("B"):addTouchEventListener(onSelect)
    obj:getChildByName("C"):addTouchEventListener(onSelect)
    obj:getChildByName("D"):addTouchEventListener(onSelect)
end

return selectViewC

--endregion
