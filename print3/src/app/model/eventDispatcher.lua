--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-- 简版事件分发
local EventDispatcher = {}

function EventDispatcher.extend(object)
    object.listeners_ = {}
    object.listenerHandleIndex_ = 0

    function object:addEventListener(eventName, target, listener)
        eventName = string.upper(eventName)
        if object.listeners_[eventName] == nil then
            object.listeners_[eventName] = {}
        end

        object.listeners_[eventName][target] = listener
    end

    function object:dispatchEvent(eventName, data)
        eventName = string.upper(eventName)
        if object.listeners_[eventName] == nil then return end

       	for target,listener in pairs(object.listeners_[eventName]) do
       		if listener then	
       			listener(target, eventName, data)
       		end
       	end
    end

    function object:removeEventListener(eventName, target)
        eventName = string.upper(eventName)
        if object.listeners_[eventName] == nil then return end

       	for _target,listener in pairs(object.listeners_[eventName]) do
       		if _target == target then
       			object.listeners_[eventName][target] = nil
       			break
       		end
       	end
    end

    function object:removeAllEventListeners()
        object.listeners_ = {}
    end

    return object
end


return EventDispatcher

--endregion
