--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local tools = {}

function tools.swapVisible(nodeA, nodeB)
    nodeA:setVisible(not nodeA:isVisible())
    nodeB:setVisible(not nodeA:isVisible())
end

--取整数随机数
function tools.getRandom(max)
    local item = math.random(1, max + 1)

    item = math.floor(item)
    item = math.min(max, item)
    print("random result:" .. item)
    return item
end

--cc.FileUtils:getInstance():getStringFromFile有时候会在返回的字符串首添加一些不明数据，重新封装
function tools.readFile(fileName)
    local s = cc.FileUtils:getInstance():getStringFromFile(fileName)
    for n = 1, string.len(s) do
		local c = string.char(string.byte(s, n)) --getChar
		if c == '[' or c == '{' then
            s = string.sub(s,n)
            break
        end
    end
    return s
end

function tools.lockScene()
    cc.exports.lock:setVisible(true)
    print("tools.lockScene() ")
end

function tools.unlockScene()
    cc.exports.lock:setVisible(false)
    print("tools.unlockScene() ")
end

return tools

--endregion
