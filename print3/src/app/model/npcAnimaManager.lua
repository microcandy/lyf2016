--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local npcAnimaManager = {}

npcAnimaManager.list = {
    "xiaohua0",
    "teacher0",
    "teacher1",
    "alien0",
    "doctor0",
}

function npcAnimaManager.load(node)
    node.cache = cc.SpriteFrameCache:getInstance()
    for k,v in pairs(npcAnimaManager.list) do
        node.cache:addSpriteFrames(v .. ".plist", v .. ".png")
    end
end

return npcAnimaManager

--endregion
