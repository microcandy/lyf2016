--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local scienceSelectProblemManager = {}

function scienceSelectProblemManager.init()
    scienceSelectProblemManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("scienceSelectProblem.txt"))
    scienceSelectProblemManager.problemCount = #scienceSelectProblemManager.problem
end

return scienceSelectProblemManager

--endregion
