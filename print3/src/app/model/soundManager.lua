--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--audio.playSound在pc端模拟时会掉帧，移植真机后无掉帧现象
local t = {}
t.list = {
    "MenuUp.mp3",
    "MenuDown.mp3",
    "Alert.mp3",
    "BtMouseClick.mp3",
    "auto.mp3",
    "Reel.mp3",
}

t.BGM = {
    "WhenTheMorningComes.mp3",
    "MissingYou.mp3",
    "MoonlightShadow.mp3",
    "GoPicnic.mp3",
    "Shinin'Harbor.mp3",
    "BlueSky.mp3",
    "AboveTheTreetops.mp3",
    "DragonDream.mp3",
    "SleepyWood.mp3",
    "SnowyVillage.mp3",
    "WhiteChristmas.mp3"
}

function t.preload()
    for k,v in pairs(t.list) do
        audio.preloadSound(v)
    end
end

function t.unload()
    for k,v in pairs(t.list) do
        audio.unloadSound(v)
    end
end

function t.menuUp()
    if cc.exports.soundFlag then
        audio.playSound("MenuUp.mp3")
    end
end

function t.menuDown()
    if cc.exports.soundFlag then
        audio.playSound("MenuDown.mp3")
    end
end

function t.alert()
    if cc.exports.soundFlag then
        audio.playSound("Alert.mp3")
    end
end

function t.click()
    if cc.exports.soundFlag then
        audio.playSound("BtMouseClick.mp3")
    end
end

function t.auto()
    if cc.exports.soundFlag then
        audio.playSound("auto.mp3")
    end
end

function t.itemMove()
    if cc.exports.soundFlag then
        audio.playSound("Reel.mp3")
    end
end

return t

--endregion
