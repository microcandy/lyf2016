--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local codeProblemManager = {}

function codeProblemManager.init()
    codeProblemManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("codeProblem.txt"))
    codeProblemManager.problemCount = #codeProblemManager.problem
end

return codeProblemManager

--endregion
