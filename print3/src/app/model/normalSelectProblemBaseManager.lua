--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local normalSelectProblemBaseManager = {}

function normalSelectProblemBaseManager.init()
    normalSelectProblemBaseManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("normalSelectProblemBase.txt"))
    normalSelectProblemBaseManager.problemCount = #normalSelectProblemBaseManager.problem
end

return normalSelectProblemBaseManager

--endregion
