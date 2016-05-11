--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local artInputProblemBaseManager = {}

function artInputProblemBaseManager.init()
    artInputProblemBaseManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("artInputProblem.txt"))
    artInputProblemBaseManager.problemCount = #artInputProblemBaseManager.problem
end

return artInputProblemBaseManager

--endregion
