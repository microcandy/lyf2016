--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local finalView = {}

finalView.dialog =  cc.exports.json.decode(cc.exports.tools.readFile("final.txt"))

finalView.list = {
    "before",
    "point",
    "basePoint",
    "letterPoint",
    "artPoint",
    "sciencePoint",
    "popular",
    "exp",
    "after"
}

function finalView.getTextByPoint(name)
    for i = 1, #finalView.dialog.point do
        if cc.exports.heroModel.data[name] <= finalView.dialog[name][i][1] then
            return finalView.dialog[name][i][2]
        end
    end
    return finalView.dialog[name][#finalView.dialog[name]][2]
end

finalView.listIndexFunc = {
    ["before"] = function()
        if finalView.vectorIndex < #finalView.dialog.before then
            finalView.vectorIndex = finalView.vectorIndex + 1
            return finalView.dialog.before[finalView.vectorIndex - 1]
        else
            finalView.vectorIndex = 1
            finalView.listIndex = finalView.listIndex + 1
            return finalView.listIndexFunc["point"]()
        end
    end,
    ["point"] = function()
        finalView.listIndex = finalView.listIndex + 1
        return finalView.getTextByPoint("point")
    end,
    ["basePoint"] = function()
        finalView.listIndex = finalView.listIndex + 1
        return finalView.getTextByPoint("basePoint")
    end,
    ["artPoint"] = function()
        finalView.listIndex = finalView.listIndex + 1
        return finalView.getTextByPoint("artPoint")
    end,
    ["letterPoint"] = function()
        finalView.listIndex = finalView.listIndex + 1
        return finalView.getTextByPoint("letterPoint")
    end,
    ["sciencePoint"] = function()
        finalView.listIndex = finalView.listIndex + 1
        return finalView.getTextByPoint("sciencePoint")
    end,
    ["popular"] = function()
        finalView.listIndex = finalView.listIndex + 1
        return finalView.getTextByPoint("popular")
    end,
    ["exp"] = function()
        finalView.listIndex = finalView.listIndex + 1
        return finalView.getTextByPoint("exp")
    end,
    ["after"] = function()
        if finalView.vectorIndex < #finalView.dialog.after then
            finalView.vectorIndex = finalView.vectorIndex + 1
            return finalView.dialog.after[finalView.vectorIndex - 1]
        else
            return ""
        end
    end,
}

function finalView.getText()
    return finalView.listIndexFunc[finalView.list[finalView.listIndex]]()
end

function finalView.updateData(obj)
    finalView.listIndex = 1
    finalView.vectorIndex = 1
    obj:setVisible(true)
    obj:getChildByName("btnNext"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            local s = finalView.getText()
            if s ~= "" then
                obj:getChildByName("text"):setString(s)
            else
                cc.exports.MainScene.subTitle:setString("园区")
                obj:setVisible(false)
            end
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
end

return finalView

--endregion
