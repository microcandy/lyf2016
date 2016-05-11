--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local scienceInputProblemManager = {}

function scienceInputProblemManager.init()
    scienceInputProblemManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("scienceInputProblem.txt"))
    scienceInputProblemManager.problemCount = #scienceInputProblemManager.problem
end

return scienceInputProblemManager

--endregion
