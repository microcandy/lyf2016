--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local artSelectProblemManager = {}

function artSelectProblemManager.init()
    artSelectProblemManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("artSelectProblem.txt"))
    artSelectProblemManager.problemCount = #artSelectProblemManager.problem
end

return artSelectProblemManager

--endregion
