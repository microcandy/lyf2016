--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local codeProblemView = class("codeProblemView", cc.Node)
local eventDispatcher = require("app.model.eventDispatcher")

function codeProblemView:ctor()
    eventDispatcher.extend(self)

    self.viewWidth = 424
    self.viewHeight = 300
    self.titleWidth = 400
    self.titleX = self.viewWidth / 2
    self.titleY = self.viewHeight - 20

    self.padSprite = cc.Scale9Sprite:create("eventPad.png", cc.rect(0, 0, 424, 348), cc.rect(5, 30, 400, 265))
    self.padSprite:setContentSize(self.viewWidth, self.viewHeight)
    self:addChild(self.padSprite)
end

function codeProblemView:bindProblem(Id)
    print("code problem Id" .. Id)
    self.problemData = cc.exports.codeProblemM.problem[Id]
end

function codeProblemView:showProblem()
    self:setVisible(true)
    if not self.problemData or self.problemData == {} then
        self.padSprite:setVisible(false)
        print("codeProblemView:showProblem() do nothing")
        return
    end

    self.tip = cc.LabelTTF:create("", "Arial", 20, cc.size(self.titleWidth, 0 ))
    self.padSprite:addChild(self.tip)
    self.tip:setColor(cc.c3b(128, 0, 0))
    self.tip:setPosition(self.titleX, 20)

    self.title = cc.LabelTTF:create(self.problemData.title, "Arial", 20, cc.size(self.titleWidth, 0 ))
    self.padSprite:addChild(self.title)
    self.title:setColor(cc.c3b(0, 128, 0))
    self.title:setPosition(self.titleX, self.titleY)

    local codeY = 0
    local editY = 0

    for i = 1, #self.problemData.text do
        local t = cc.LabelTTF:create(self.problemData.text[i], "Arial", 20, cc.size(self.titleWidth, 0 ), cc.TEXT_ALIGNMENT_LEFT)
        self.padSprite:addChild(t)

        t:setColor(cc.c3b(0, 0, 0))
        t:setPosition(self.titleX, self.titleY - 30 - (i - 1) * 20)
        if i == #self.problemData.text then codeY = self.titleY - 30 - (i - 1) * 20 end
    end

    self.code1 = ""
    self.code2 = " "
    local codeBeAdd = ""

    for i = 1, #self.problemData.code do
        codeBeAdd = codeBeAdd .. self.problemData.code[i]
        print(codeBeAdd)
        local add = ""
        if i == self.problemData.addedCodeLine then
            self.code1 = codeBeAdd
            codeBeAdd = self.code2
            add = "___"
        end
        local t = cc.LabelTTF:create(self.problemData.code[i] .. add, "Arial", 20, cc.size(self.titleWidth, 0 ), cc.TEXT_ALIGNMENT_LEFT)
        self.padSprite:addChild(t)

        t:setColor(cc.c3b(0, 0, 0))
        t:setPosition(self.titleX, codeY - 20 - (i - 1) * 20)

        if i == #self.problemData.code then 
            editY = 55
            self.code2 = codeBeAdd
        end
    end

    local black = cc.Scale9Sprite:create("black.png")
    black:setContentSize(self.titleWidth - 60, 30)
    self.padSprite:addChild(black)
    black:setPosition(self.titleX - 30, editY)

    self.edit = ccui.TextField:create("点击输入代码", "Arial", 20)
    self.padSprite:addChild(self.edit)
    self.edit:setPosition(self.titleX - 30, editY)
    self.edit:addEventListener(function(sender, event)
        if event == 2 or event == 1 or event == 3 then
            self.editCallback[event]()
        end
    end)

    self.codeLabel = cc.LabelTTF:create("", "Arial", 20, cc.size(300, 0 ))
    self.padSprite:addChild(self.codeLabel)
    self.codeLabel:setColor(cc.c3b(0, 0, 0))
    self.codeLabel:setPosition(- self.titleX + 30, self.titleY)

    self.editCallback = {
        [3] = function()
            print(self.edit:getString())
            self.codeLabel:setString(self.edit:getString()) 
        end,
        [2] = function()
            print(self.edit:getString())
            self.codeLabel:setString(self.edit:getString()) 
        end,
        [1] = function()
            print(self.edit:getString())
            self.codeLabel:setString(self.edit:getString()) 
        end,
    }

    self.btnSure = ccui.Button:create("btnSure1.png", "btnSure2.png", "")
    self.btnSure:setScale(1.2)
    self.padSprite:addChild(self.btnSure)
    self.btnSure:setPosition(self.titleWidth - 15, editY)
    self.btnSure:setTouchEnabled(true)
    self.btnSure:addTouchEventListener(function(sender, event) self:btnCallback(sender, event) end)

    self.btnClose = ccui.Button:create("btnClose1.png", "btnClose2.png", "")
    self.btnClose:setScale(1.2)
    self.padSprite:addChild(self.btnClose)
    self.btnClose:setPosition(self.titleWidth - 15, self.titleY)
    self.btnClose:setTouchEnabled(true)
    self.btnClose:addTouchEventListener(function(sender, event) self:btnCallback(sender, event) end)

    self.btnHelp = ccui.Button:create("btnHelp1.png", "btnHelp2.png", "")
    self.btnHelp:setScale(0.8)
    self.padSprite:addChild(self.btnHelp)
    self.btnHelp:setPosition(self.titleWidth - 15, self.titleY - 115)
    self.btnHelp:setTouchEnabled(true)
    self.btnHelp:addTouchEventListener(function(sender, event) self:btnCallback(sender, event) end)

    self.btnCallbackFunc = {
        [self.btnHelp] = function()
            cc.exports.popup:show("警告：使用未定义的变量或函数会引起游戏崩溃")
        end,
        [self.btnClose] = function()
            self:removeProblem()
        end,
        [self.btnSure] = function()
            local userScript = self.code1 .. self.edit:getString() .. self.code2
            print(userScript)
            local userLoader = loadstring(userScript)
            print(userLoader)
            if not userLoader then
                print("bad code")
                self:badCode()
                return
            end

            userLoader()

            local checkScript = ""
            for i = 1, #self.problemData.check do
                checkScript = checkScript .. self.problemData.check[i]
            end
            
            local userFun = false
            if myCode(1) == nil then 
                self.tip:setString("好像啥也没写")
                return 
            end
            if type(myCode(1)) == "function" then
                userFun = true
            else
                userFun = false
            end
            local checkLoader = loadstring(checkScript)
            checkLoader()

            for i = 1, #self.problemData.tests do
                print(-60.6 % 1)
                local res = nil
                if userFun then
                    print("nothing")
                    resMyCode = myCode(i)
                    res = resMyCode(self.problemData.tests[i])
                else
                    res = myCode(self.problemData.tests[i])
                end

                if res == nil then 
                    self:badCase(self.problemData.tests[i], res)
                    return 
                end

                print("checking: " .. self.problemData.tests[i] .. " - " .. tostring(myCheck(res)) .. " - " .. res)
                if not myCheck(self.problemData.tests[i], res) then
                    print("bad case: " .. self.problemData.tests[i] .. " - " ..res)
                    self:badCase(self.problemData.tests[i], res)
                    return
                end
            end

            self:clearCode()
        end,
    }
end

function codeProblemView:removeProblem()
    self:dispatchEvent("END_CODE_PROBLEM", {point = 1})
    self.padSprite:removeAllChildren()
    self:setVisible(false)
end

function codeProblemView:clearCode()
    print("恭喜~")
    self.tip:setString("恭喜~通过了已有的所有测试用例")
    self.btnSure:setVisible(false)
    self:dispatchEvent("PASS_CODE_PROBLEM", {point = 1})
    performWithDelay(self, function()
        self.tip:setString("获得 " .. self.problemData.resulttext)
    end, 
    1.5)
end

function codeProblemView:badCode()
    print("代码好像有问题")
    self.tip:setString("代码好像跑不通")
end

function codeProblemView:badCase(input, res)
    print("代码发现错误用例")
    self.tip:setString("发现错误用例: input:" .. tostring(input) .. " ； output:" .. tostring(res))
end

function codeProblemView:btnCallback(sender, event)
    if event == ccui.TouchEventType.ended then
        self.btnCallbackFunc[sender]()
    elseif event == ccui.TouchEventType.began then
        cc.exports.soundM.click()
    end
end

return codeProblemView

--endregion
