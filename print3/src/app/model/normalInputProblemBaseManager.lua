--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local normalInputProblemBaseManager = {}

function normalInputProblemBaseManager.init()
    normalInputProblemBaseManager.problem = cc.exports.json.decode(cc.exports.tools.readFile("normalInputProblemBase.txt"))
    normalInputProblemBaseManager.problemCount = #normalInputProblemBaseManager.problem
end

return normalInputProblemBaseManager

--endregion
