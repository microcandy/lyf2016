--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local letterInputProblemManager = {}

function letterInputProblemManager.init()
    letterInputProblemManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("letterInputProblem.txt"))
    letterInputProblemManager.problemCount = #letterInputProblemManager.problem
end

return letterInputProblemManager

--endregion
