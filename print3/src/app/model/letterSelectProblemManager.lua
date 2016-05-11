--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local letterSelectProblemManager = {}

function letterSelectProblemManager.init()
    letterSelectProblemManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("letterSelectProblem.txt"))
    letterSelectProblemManager.problemCount = #letterSelectProblemManager.problem
end

return letterSelectProblemManager

--endregion
