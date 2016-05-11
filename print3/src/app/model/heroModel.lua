--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local heroModel = {}

heroModel.data = {}

function heroModel.init()
    --用户第一次玩，先写如一系列默认选项，以防初始化过程出问题
    local inited = cc.UserDefault:getInstance():getBoolForKey("initedHero")
    if inited then
        
    else
        cc.UserDefault:getInstance():setBoolForKey("initedHero", true)

        cc.UserDefault:getInstance():setIntegerForKey("popular", 0)
        cc.UserDefault:getInstance():setIntegerForKey("point", 0)
        cc.UserDefault:getInstance():setIntegerForKey("exp", 0)
        cc.UserDefault:getInstance():setIntegerForKey("basePoint", 0)
        cc.UserDefault:getInstance():setIntegerForKey("artPoint", 0)
        cc.UserDefault:getInstance():setIntegerForKey("sciencePoint", 0)
        cc.UserDefault:getInstance():setIntegerForKey("letterPoint", 0)

        cc.UserDefault:getInstance():setStringForKey("heroGender", "F")
        cc.UserDefault:getInstance():setStringForKey("heroType", "science")
        cc.UserDefault:getInstance():setStringForKey("heroShow", "girl0")
        cc.UserDefault:getInstance():setStringForKey("heroName", "无名")
        cc.UserDefault:getInstance():setBoolForKey("writeLua", false)
    end

    heroModel.data.popular = cc.UserDefault:getInstance():getIntegerForKey("popular")
    heroModel.data.point = cc.UserDefault:getInstance():getIntegerForKey("point")
    heroModel.data.exp = cc.UserDefault:getInstance():getIntegerForKey("exp")
    heroModel.data.basePoint = cc.UserDefault:getInstance():getIntegerForKey("basePoint")
    heroModel.data.artPoint = cc.UserDefault:getInstance():getIntegerForKey("artPoint")
    heroModel.data.sciencePoint = cc.UserDefault:getInstance():getIntegerForKey("sciencePoint")
    heroModel.data.letterPoint = cc.UserDefault:getInstance():getIntegerForKey("letterPoint")

    heroModel.data.heroGender = cc.UserDefault:getInstance():getStringForKey("heroGender")
    heroModel.data.heroType = cc.UserDefault:getInstance():getStringForKey("heroType")
    heroModel.data.heroShow = cc.UserDefault:getInstance():getStringForKey("heroShow")
    heroModel.data.heroName = cc.UserDefault:getInstance():getStringForKey("heroName")
    heroModel.data.writeLua = cc.UserDefault:getInstance():getBoolForKey("writeLua")
end

heroModel.upFunc = {
    ["popular"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("popular", data)
        heroModel.data.popular = data
    end,
    ["point"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("point", data)
        heroModel.data.point = data
    end,
    ["exp"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("exp", data)
        heroModel.data.exp = data
    end,
    ["basePoint"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("basePoint", data)
        heroModel.data.basePoint = data
    end,
    ["artPoint"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("artPoint", data)
        heroModel.data.artPoint = data
    end,
    ["sciencePoint"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("sciencePoint", data)
        heroModel.data.sciencePoint = data
    end,
    ["letterPoint"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("letterPoint", data)
        heroModel.data.letterPoint = data
    end,
    ["heroGender"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("heroGender", data)
        heroModel.data.heroGender = data
    end,
    ["heroType"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("heroType", data)
        heroModel.data.heroType = data
    end,
    ["heroShow"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("heroShow", data)
        heroModel.data.heroShow = data
    end,
    ["heroName"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("heroName", data)
        heroModel.data.heroName = data
    end,
    ["writeLua"] = function(data)
        cc.UserDefault:getInstance():setIntegerForKey("writeLua", data)
        heroModel.data.writeLua = data
    end,
}

function heroModel.updateData(name, data)
    if heroModel.upFunc[name] then
        heroModel.upFunc[name](data)

    end
end

return heroModel

--endregion
