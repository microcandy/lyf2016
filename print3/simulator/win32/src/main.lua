
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
---[[
package.path = package.path .. ";src/?.lua"

function babe_tostring(...)  
    local num = select("#",...);  
    local args = {...};  
    local outs = {};  
    for i = 1, num do  
        if i > 1 then  
            outs[#outs+1] = "\t";  
        end  
        outs[#outs+1] = tostring(args[i]);  
    end  
    return table.concat(outs);  
end  
  
local babe_print = print;  
local babe_output = function(...)
    babe_print(...);  
  
    if decoda_output ~= nil then  
        local str = babe_tostring(...);  
        decoda_output(str);  
    end  
end  
print = babe_output;
--]]

require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
