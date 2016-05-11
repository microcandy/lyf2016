
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

cc.exports.tools = require("app.model.tools")

cc.exports.json = require("app.model.json")

cc.exports.eventM = require("app.model.eventManager")
cc.exports.eventM.init()
cc.exports.codeProblemM = require("app.model.codeProblemManager")
cc.exports.codeProblemM.init()
---[[
cc.exports.normalInputProblemBaseM = require("app.model.normalInputProblemBaseManager")
cc.exports.normalInputProblemBaseM.init()
cc.exports.normalSelectProblemBaseM = require("app.model.normalSelectProblemBaseManager")
cc.exports.normalSelectProblemBaseM.init()
cc.exports.scienceInputProblemM = require("app.model.scienceInputProblemManager")
cc.exports.scienceInputProblemM.init()
cc.exports.scienceSelectProblemM = require("app.model.scienceSelectProblemManager")
cc.exports.scienceSelectProblemM.init()
cc.exports.artInputProblemM = require("app.model.artInputProblemManager")
cc.exports.artInputProblemM.init()
cc.exports.artSelectProblemM = require("app.model.artSelectProblemManager")
cc.exports.artSelectProblemM.init()
cc.exports.letterInputProblemM = require("app.model.letterInputProblemManager")
cc.exports.letterInputProblemM.init()
cc.exports.letterSelectProblemM = require("app.model.letterSelectProblemManager")
cc.exports.letterSelectProblemM.init()

cc.exports.activeInput = cc.exports.normalInputProblemBaseM
cc.exports.activeInputName = "basePoint"
cc.exports.activeSelect = cc.exports.normalSelectProblemBaseM
cc.exports.activeSelectName = "basePoint"
--]]
cc.exports.soundM = require("app.model.soundManager")
cc.exports.soundM.preload()

local autoView = require("app.view.autoView")
local mapModel = require("app.model.mapModel")
local mapView = require("app.view.mapView")
local eventView = require("app.view.eventView")
local codeProblemView = require("app.view.codeProblemView")

MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
---[[
    cc.Director:getInstance():getOpenGLView():setFrameSize(800, 480)
    print("resource node = %s", tostring(self:getResourceNode()))

    self.updateAction = schedule(self, function() self:updateLoading() end, 0.1)
end

function MainScene:updateLoading()
    if self:getResourceNode():getChildByName("logo"):getChildByName("loadingBar"):getPercent() <= 98 then
        self:getResourceNode():getChildByName("logo"):getChildByName("loadingBar"):setPercent(
            self:getResourceNode():getChildByName("logo"):getChildByName("loadingBar"):getPercent() + cc.exports.tools.getRandom(3))
        self:getResourceNode():getChildByName("logo"):setOpacity(
            self:getResourceNode():getChildByName("logo"):getOpacity() - 1)
    else
        self:stopAction(self.updateAction)
        self:getResourceNode():getChildByName("logo"):setVisible(false)
        self:afterOnCreate()
    end
end

function MainScene:afterOnCreate()
    self:initSdk()
    
    cc.exports.floor = self:getResourceNode():getChildByName("floor")
    self.root = self:getResourceNode():getChildByName("root")
    self.root:setVisible(false)

    self.subTitle = self:getResourceNode():getChildByName("subTitlePad"):getChildByName("subTitleLabel")
    self.subTitle:setString("园区")

    self:initMainMenuButton()
    --share button in func :initSdk()
    self:initSiteButton()
    self:initQuitButton()
    
    self.settingPanel = self:getResourceNode():getChildByName("settingPanel")

    self:initSettingButton()
    self:initMouseCheckBox()
    self:initMusicCheckBox()
    self:initMusicSlider()
    self:initSoundCheckBox()
    self:initSoundSlider()

    self:initTitle()

    self:initArtClassButton()
    self:initLabClassButton()
    self:initLibClassButton()
    self:initMainClassButton()
    self:initDormClassButton()
    self:initFinalClassButton()

    self:initSetAutoButton()
    self:initBackButton()

    self:initMainButtonMouseAnima()

    self:initLock()

    self:initTip()

    self:initHeroSetting()

    self:initInfoPad()

    self:initDataPad()

    self:initPopup()

    self:initMap()

    self:initEventPad()

    self:initCodeProblemPad()
    
    self:initAuto()

    self:readGameSetting()

    self:addEventListener()

    cc.exports.MainScene = self

    self.inputPlay = self:getResourceNode():getChildByName("inputProblemPad")
    cc.exports.inputPlay = self.inputPlay

    self.selectPlay = self:getResourceNode():getChildByName("normalProblemPad")
    cc.exports.selectPlay = self.selectPlay

end

function MainScene:addEventListener()
    require("app.view.inputView"):addEventListener("INPUT_PASS", self, self.onInputPass)
    require("app.view.inputView"):addEventListener("INPUT_NOT_PASS", self, self.onInputNotPass)
    require("app.view.selectView"):addEventListener("SELECT_PASS", self, self.onSelectPass)
    require("app.view.selectView"):addEventListener("SELECT_NOT_PASS", self, self.onSelectNotPass)
    self._autoView:addEventListener("AFTER_AUTO", self, self.onAfterAuto)
    cc.exports.eventV:addEventListener("END_EVENT", self, self.onEventEnd)
    cc.exports.codeProblemV:addEventListener("END_CODE_PROBLEM", self, self.onCodeProblemEnd)
    cc.exports.codeProblemV:addEventListener("PASS_CODE_PROBLEM", self, self.onPassCodeProblem)
end

function MainScene:onSelectPass(event, data)
    self.pointLabel:setString(tostring(tonumber(self.pointLabel:getString()) + 1))
    self.meetLabel:setString(tostring(tonumber(self.meetLabel:getString()) + 1))
    cc.exports.heroModel.updateData("point", cc.exports.heroModel.data.point + 1)
    self:showTip("分数+1")
    self:checkWin()
    self.back:setEnabled(true)
    cc.exports.heroModel.updateData(cc.exports.activeInputName, cc.exports.heroModel.data[cc.exports.activeInputName] + 1)
    print("on SELECT_PASS")
end

function MainScene:onSelectNotPass(event, data)
    self:showTip("选错咯")
    self.meetLabel:setString(tostring(tonumber(self.meetLabel:getString()) + 1))
    self.back:setEnabled(true)
end

function MainScene:onInputPass(event, data)
    self.pointLabel:setString(tostring(tonumber(self.pointLabel:getString()) + 1))
    self.meetLabel:setString(tostring(tonumber(self.meetLabel:getString()) + 1))
    cc.exports.heroModel.updateData("point", cc.exports.heroModel.data.point + 1)
    self:showTip("分数+1")
    self:checkWin()
    self.back:setEnabled(true)
    cc.exports.heroModel.updateData(cc.exports.activeInputName, cc.exports.heroModel.data[cc.exports.activeInputName] + 1)
    print("on INPUT_PASS")
end

function MainScene:onInputNotPass(event, data)
    self:showTip("答错咯")
    self.meetLabel:setString(tostring(tonumber(self.meetLabel:getString()) + 1))
    self.back:setEnabled(true)
end

function MainScene:onPassCodeProblem(event, data)
    self:showTip("不错，解出了一题")
end

function MainScene:onCodeProblemEnd(event, data)
    self:hideTip()
end

function MainScene:onAfterAuto(event, data)
    self.totalLabel:setString(tostring(tonumber(self.totalLabel:getString()) + data))

    self.mapV:pushItem(data)
    self._autoView:setEnabled(false)
    self.back:setEnabled(false)
end

function MainScene:onEventEnd(event, data)
    cc.exports.MainScene._autoView:setEnabled(true)
    self.back:setEnabled(true)
    dump(data)
    if data.exp then
        cc.exports.heroModel.updateData("exp", cc.exports.heroModel.data.exp + data.exp)
    end
    if data.popular then
        cc.exports.heroModel.updateData("popular", cc.exports.heroModel.data.popular + data.popular)
    end
end

function MainScene:checkWin()
    if tonumber(self.winDataRef:getString()) > self.winData then
        print("win")
        cc.exports.soundM.alert()
        cc.exports.popup:show("恭喜！你已经通过本科目，你可以选择继续探索，或者选择其他科目", 
            function() cc.exports.soundM.click() end, 
            function() cc.exports.soundM.click() end)
    end
end

function MainScene:initSdk()
    --初始化anysdk分享
    if device.platform == "android" then
        self.share = self:getResourceNode():getChildByName("mainPanel"):getChildByName("share")
        self.share:addTouchEventListener(function(sender,event)
             print("share="..event)--event是触摸类型，0,1,2,3分别是began，moved，ended，canceled
             if event == ccui.TouchEventType.ended then
                 self:onShare()
             end 
        end)

        --anysdk key
        --P.S. 在framework\runtime-src\Classes\AppDelegate.cpp也需要这几个key值
        local agent = AgentManager:getInstance()
        
        local appKey = "自己申请";
        local appSecret = "自己申请";
        local privateKey = "自己申请";
        local oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php";
        agent:init(appKey,appSecret,privateKey,oauthLoginServer)
        --load
        agent:loadAllPlugins()

        --------------------------------------------------------------
        self.share_plugin = agent:getSharePlugin()
        --cc.FileUtils:getInstance():getWritablePath()
        local function onSharedResultListener( code, msg )     --code: share result code, msg: message of result.
            if code == ShareResultCode.kShareSuccess then
                x:setString("kShareSuccess!")
            elseif code == ShareResultCode.kShareCancel then
                x:setString("kShareCancel!")
            elseif code == ShareResultCode.kShareFail then
                x:setString("kShareFail!")
            else 
                x:setString("kShareNetworkError!")
            end
        end
        self.share_plugin:setResultListener(onSharedResultListener)

        cc.FileUtils:getInstance():getWritablePath()
        local ret = cc.Layer:create()
        self:addChild(ret)

        local s = cc.Director:getInstance():getWinSize()
        self.target = nil

        local function onNodeEvent(event)
            if event == "exit" then
                self.target:release()
                cc.Director:getInstance():getTextureCache():removeUnusedTextures()
            end
        end
        ret:registerScriptHandler(onNodeEvent)

        self.target = cc.RenderTexture:create(s.width, s.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
        self.target:retain()
        self.target:setPosition(display.center)

        ret:addChild(self.target, -1)
        ---------------------------------------------------------------------------
        self.ads_plugin = agent:getAdsPlugin()

        local function onAdsResult(param1, param2)
            print("on ads result.")
        end
        self.ads_plugin:setAdsListener(onAdsResult)
    else
        self.share = self:getResourceNode():getChildByName("mainPanel"):getChildByName("share")
        self.share:addTouchEventListener(function(sender,event)
             print("event="..event)--event是触摸类型，0,1,2,3分别是began，moved，ended，canceled
             if event == ccui.TouchEventType.ended then
                 cc.exports.popup:show("好像只有安卓可以分享哦")
                 cc.exports.soundM.alert()
             end
        end)
    end
end

function MainScene:initMainMenuButton()
    --主菜单
    self.mainMenu = self:getResourceNode():getChildByName("mainPanel")
    --主菜单
    self.mainButton = self:getResourceNode():getChildByName("mainButton")
    self.mainButton:addTouchEventListener(function(sender,event)
        print("main Button="..event)--event是触摸类型，0,1,2,3分别是began，moved，ended，canceled
        if event == ccui.TouchEventType.ended then
            if self.mainMenu:getPositionX() == 0 then
                self.mainMenu:stopAllActions()
                self.mainMenu:runAction(cc.MoveBy:create(0.5 ,cc.p(173, 0)))
                self:showTip("打算要做点什么呢")
                cc.exports.soundM.menuUp()
            end
            if self.mainMenu:getPositionX() == 173 then
                self.mainMenu:stopAllActions()
                self.mainMenu:runAction(cc.MoveBy:create(0.5 ,cc.p(-173, 0)))
                self:hideTip()
                if self.settingPanel:getPositionX() ~= 0 then
                    self.settingPanel:stopAllActions()
                    self.settingPanel:runAction(cc.MoveTo:create(0.5 ,cc.p(0, self.settingPanel:getPositionY())))
                end
                cc.exports.soundM.menuDown()
            end
        end
    end )
end

function MainScene:initSiteButton()
    --官网
    self.home = self:getResourceNode():getChildByName("mainPanel"):getChildByName("site")
    self.home:addTouchEventListener(function(sender,event)
        print("site button="..event)--event是触摸类型，0,1,2,3分别是began，moved，ended，canceled
        if event == ccui.TouchEventType.ended then
            print("site")
            cc.Application:getInstance():openURL(HOME)
        end
    end)
end

function MainScene:initQuitButton()
    --退出
    self.quit = self:getResourceNode():getChildByName("mainPanel"):getChildByName("quit")
    self.quit:addTouchEventListener(function(sender,event)
        print("exit Button="..event)--event是触摸类型，0,1,2,3分别是began，moved，ended，canceled
        if event == ccui.TouchEventType.ended then
            cc.exports.tools.lockScene()
            self:showTip("你就这么忍心退出游戏么")
            cc.exports.popup:show("确定要退出吗", 
                function() os.exit() end, 
                function() 
                    self:unlockScene()
                    cc.exports.popup:hide()
                end)
            cc.exports.soundM.alert()
        end
    end )
end

function MainScene:initSettingButton()
    self.setting = self:getResourceNode():getChildByName("mainPanel"):getChildByName("ssetting")
    self.setting:addTouchEventListener(function(sender,event)
        print("setting button="..event)--event是触摸类型，0,1,2,3分别是began，moved，ended，canceled
        if event == ccui.TouchEventType.ended then
            print("setting")
            if self.settingPanel:getPositionX() == 0 then
                self.settingPanel:stopAllActions()
                self.settingPanel:runAction(cc.MoveBy:create(0.5 ,cc.p(173, 0)))
                cc.exports.soundM.menuUp()
            end
            if self.settingPanel:getPositionX() == 173 then
                self.settingPanel:stopAllActions()
                self.settingPanel:runAction(cc.MoveBy:create(0.5 ,cc.p(-173, 0)))
                cc.exports.soundM.menuDown()
            end
        end
    end)
end

function MainScene:initMouseCheckBox()
    --鼠标动画开关
    local function mouseSelectedStateEvent(sender, eventType)
        print("mouse anima flag")
        if eventType == ccui.CheckBoxEventType.selected then
            cc.UserDefault:getInstance():setBoolForKey("mouseAnima", true)
            self.mouse:resume()
            self._autoView.mouse:resume()
        elseif eventType == ccui.CheckBoxEventType.unselected then
            cc.UserDefault:getInstance():setBoolForKey("mouseAnima", false)
            self.mouse:pause()
            self._autoView.mouse:pause()
        end
        cc.exports.mouseAnima = cc.UserDefault:getInstance():getBoolForKey("mouseAnima")

        cc.exports.soundM.click()
    end

    self.mouseCheckbox = self:getResourceNode():getChildByName("settingPanel"):getChildByName("mouseCheckBox")
    self.mouseCheckbox:addEventListener(mouseSelectedStateEvent)
end

function MainScene:initMusicCheckBox()
    --背景音乐
    local function musicSelectedStateEvent(sender, eventType)
        print("music flag")
        if eventType == ccui.CheckBoxEventType.selected then
            cc.UserDefault:getInstance():setBoolForKey("musicFlag", true)
            self.activeAudioID = ccexp.AudioEngine:play2d("WhenTheMorningComes.mp3", true, cc.exports.musicVol)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            cc.UserDefault:getInstance():setBoolForKey("musicFlag", false)
            ccexp.AudioEngine:stop(self.activeAudioID)
        end
        cc.exports.musicFlag = cc.UserDefault:getInstance():getBoolForKey("musicFlag")

        cc.exports.soundM.click()
    end
    self.musicCheckbox = self:getResourceNode():getChildByName("settingPanel"):getChildByName("musicCheckBox")
    self.musicCheckbox:addEventListener(musicSelectedStateEvent)
end

function MainScene:initMusicSlider()
    local function musicSliderChangedEvent(sender,eventType)
        --动态地变化音量大小
        if eventType == ccui.SliderEventType.percentChanged then
            cc.exports.musicVol = sender:getPercent() / 100.0
            ccexp.AudioEngine:setVolume(self.activeAudioID, cc.exports.musicVol)
        --只在离开slider之后才写入音量值到存档中
        elseif eventType == ccui.SliderEventType.slideBallUp then
            cc.UserDefault:getInstance():setFloatForKey("musicVol", cc.exports.musicVol)
        end
    end
    self.musicSlider = self:getResourceNode():getChildByName("settingPanel"):getChildByName("musicSlider")
    self.musicSlider:addEventListener(musicSliderChangedEvent)
end

function MainScene:initSoundCheckBox()
    --音效
    --newAudioEngine没搞定，音效暂时用simpleAudioEngine
    local function soundSelectedStateEvent(sender, eventType)
        print("sound flag")
        if eventType == ccui.CheckBoxEventType.selected then
            cc.UserDefault:getInstance():setBoolForKey("soundFlag", true)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            cc.UserDefault:getInstance():setBoolForKey("soundFlag", false)
        end
        cc.exports.soundFlag = cc.UserDefault:getInstance():getBoolForKey("soundFlag")

        cc.exports.soundM.click()
    end
    self.soundCheckbox = self:getResourceNode():getChildByName("settingPanel"):getChildByName("soundCheckBox")
    self.soundCheckbox:addEventListener(soundSelectedStateEvent)
end

function MainScene:initSoundSlider()
    local function soundSliderChangedEvent(sender,eventType)
        --动态地变化音量大小
        if eventType == ccui.SliderEventType.percentChanged then
            cc.exports.soundVol = sender:getPercent() / 100.0
            audio.setSoundsVolume(cc.exports.soundVol)
        --只在离开slider之后才写入音量值到存档中
        elseif eventType == ccui.SliderEventType.slideBallUp then
            cc.UserDefault:getInstance():setFloatForKey("soundVol", cc.exports.soundVol)
        end
    end
    self.soundSlider = self:getResourceNode():getChildByName("settingPanel"):getChildByName("soundSlider")
    self.soundSlider:addEventListener(soundSliderChangedEvent)
end

function MainScene:newCounter()
    if not self.counter then
        self.counter = require("app.model.counterModel").new()
        self:addChild(self.counter)
    else
        self.counter.step = 0
    end
end

function MainScene:initArtClassButton()
    --艺术楼
    self.artClass = self:getResourceNode():getChildByName("art")
    self.artClass:addTouchEventListener(function(sender,event)
        print("art button="..event)
        if event == ccui.TouchEventType.ended then
            print("art")
            cc.exports.activeInput = cc.exports.artInputProblemM
            cc.exports.activeInputName = "artPoint"
            cc.exports.activeSelect = cc.exports.artSelectProblemM
            cc.exports.activeSelectName = "artPoint"
            self:initMap()

            self:newCounter()

            self.winDataRef = self.totalLabel
            self.winData = 10

            self.back:setEnabled(true)

            self.hero:setVisible(true)
            self.subTitle:setString("艺术室")
            self:getResourceNode():getChildByName("titlePad"):setVisible(true)
            self:getResourceNode():getChildByName("musicClass"):setVisible(true)
            self.root:setVisible(true)

            self.classNow = self:getResourceNode():getChildByName("musicClass")
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
end

function MainScene:initLabClassButton()
    --实验楼
    self.labClass = self:getResourceNode():getChildByName("lab")
    self.labClass:addTouchEventListener(function(sender,event)
        print("lab button="..event)
        if event == ccui.TouchEventType.ended then
            print("lab")
            cc.exports.activeInput = cc.exports.scienceInputProblemM
            cc.exports.activeInputName = "sciencePoint"
            cc.exports.activeSelect = cc.exports.scienceSelectProblemM
            cc.exports.activeSelectName = "sciencePoint"
            self:initMap()

            self:newCounter()

            self.winDataRef = self.pointLabel
            self.winData = 10

            self.back:setEnabled(true)
            self.hero:setVisible(true)

            self.subTitle:setString("实验室")
            self:getResourceNode():getChildByName("titlePad"):setVisible(true)
            self:getResourceNode():getChildByName("labClass"):setVisible(true)
            self.root:setVisible(true)

            self.classNow = self:getResourceNode():getChildByName("labClass")
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
end

function MainScene:initLibClassButton()
    --图书楼
    self.libClass = self:getResourceNode():getChildByName("lib")
    self.libClass:addTouchEventListener(function(sender,event)
        print("lib button="..event)
        if event == ccui.TouchEventType.ended then
            print("lib")
            cc.exports.activeInput = cc.exports.letterInputProblemM
            cc.exports.activeInputName = "letterPoint"
            cc.exports.activeSelect = cc.exports.artSelectProblemM
            cc.exports.activeSelectName = "letterPoint"
            self:initMap()

            self:newCounter()

            self.winDataRef = self.meetLabel
            self.winData = 10

            self.back:setEnabled(true)
            self.hero:setVisible(true)

            self.subTitle:setString("图书馆")
            self:getResourceNode():getChildByName("titlePad"):setVisible(true)
            self:getResourceNode():getChildByName("libClass"):setVisible(true)
            self.root:setVisible(true)
            self.classNow = self:getResourceNode():getChildByName("libClass")
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
end

function MainScene:initMainClassButton()
    --教室
    self.mainClass = self:getResourceNode():getChildByName("main")
    self.mainClass:addTouchEventListener(function(sender,event)
        print("教室 button="..event)
        if event == ccui.TouchEventType.ended then
            print("教室")
            cc.exports.activeInput = cc.exports.normalInputProblemBaseM
            cc.exports.activeInputName = "basePoint"
            cc.exports.activeSelect = cc.exports.normalSelectProblemBaseM
            cc.exports.activeSelectName = "basePoint"
            self:initMap()

            self:newCounter()

            self.winDataRef = self.pointLabel
            self.winData = 1
            self:showTip("通关条件：分数>1")

            self.back:setEnabled(true)
            self.hero:setVisible(true)

            self.subTitle:setString("主教室")
            self:getResourceNode():getChildByName("titlePad"):setVisible(true)
            self:getResourceNode():getChildByName("roomClass"):setVisible(true)
            self.root:setVisible(true)

            self.classNow = self:getResourceNode():getChildByName("roomClass")
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
end

function MainScene:initDormClassButton()
    --宿舍
    self.activeIndex = 1
    self.dormClass = self:getResourceNode():getChildByName("dorm")
    self.dormClass:addTouchEventListener(function(sender,event)
        print("dorm button="..event)
        if event == ccui.TouchEventType.ended then
            print("dorm")
            --
            --self.ads_plugin:showAds(1)

            self.back:setEnabled(true)
            self:newCounter()
            self.subTitle:setString("宿舍")
            self:getResourceNode():getChildByName("dormClass"):setVisible(true)
            self.classNow = self:getResourceNode():getChildByName("dormClass")

            self.dormBGMName:setString(cc.exports.soundM.BGM[self.activeIndex])
            self.dorm:getChildByName("musicPlayer"):getChildByName("playing"):setString(cc.exports.soundM.BGM[self.activeIndex])
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    -- 换音乐
    self.dorm = self:getResourceNode():getChildByName("dormClass")

    self.dormBGMIndex = 1
    self.dormBGMName = self.dorm:getChildByName("musicPlayer"):getChildByName("name")
    self.dorm:getChildByName("musicPlayer"):getChildByName("btn"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            ccexp.AudioEngine:stop(self.activeAudioID)
            self.activeAudioID = ccexp.AudioEngine:play2d(cc.exports.soundM.BGM[self.dormBGMIndex], true, cc.exports.musicVol)
            self.activeIndex = self.dormBGMIndex
            self.dorm:getChildByName("musicPlayer"):getChildByName("playing"):setString(cc.exports.soundM.BGM[self.dormBGMIndex])
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("musicPlayer"):getChildByName("btnBefore"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.dormBGMIndex = self.dormBGMIndex - 1
            if self.dormBGMIndex == 0 then
                self.dormBGMIndex = #cc.exports.soundM.BGM
            end
            self.dormBGMName:setString(cc.exports.soundM.BGM[self.dormBGMIndex])
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("musicPlayer"):getChildByName("btnAfter"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.dormBGMIndex = self.dormBGMIndex + 1
            if self.dormBGMIndex > #cc.exports.soundM.BGM then
                self.dormBGMIndex = 1
            end
            self.dormBGMName:setString(cc.exports.soundM.BGM[self.dormBGMIndex])
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("musicPlayer"):getChildByName("btnClose"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.dorm:getChildByName("musicPlayer"):setVisible(false)
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("btnMusicPlayer"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.dorm:getChildByName("musicPlayer"):setVisible(true)
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    -- code 写代码
    self.codeSelectIndex = 1
    self.dorm:getChildByName("codePlayer"):getChildByName("title"):setString(cc.exports.codeProblemM.problem[self.codeSelectIndex].title)
    self.dorm:getChildByName("btnCode"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            if cc.UserDefault:getInstance():getBoolForKey("writeLua") then
                self.dorm:getChildByName("codePlayer"):setVisible(true)
            else
                self:showTip("你似乎说过不会写代码")
            end
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("codePlayer"):getChildByName("btnClose"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.dorm:getChildByName("codePlayer"):setVisible(false)
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("codePlayer"):getChildByName("btnLeft"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.codeSelectIndex = self.codeSelectIndex - 1
            if self.codeSelectIndex <= 0 then
                self.codeSelectIndex = cc.exports.codeProblemM.problemCount
            end
            self.dorm:getChildByName("codePlayer"):getChildByName("title"):setString(cc.exports.codeProblemM.problem[self.codeSelectIndex].title)
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("codePlayer"):getChildByName("btnRight"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.codeSelectIndex = self.codeSelectIndex + 1
            if self.codeSelectIndex > cc.exports.codeProblemM.problemCount then
                self.codeSelectIndex = 1
            end
            self.dorm:getChildByName("codePlayer"):getChildByName("title"):setString(cc.exports.codeProblemM.problem[self.codeSelectIndex].title)
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("codePlayer"):getChildByName("btnSure"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            cc.exports.codeProblemV:bindProblem(self.codeSelectIndex)
            cc.exports.codeProblemV:showProblem()
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    --[[answer 看答案
    self.answerType = "select"
    self.answerData = nil
    self.dorm:getChildByName("btnAnswer")addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.dorm:getChildByName("answerPlayer"):setVisible(true)
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("answerPlayer"):getChildByName("btnClose"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.dorm:getChildByName("answerPlayer"):setVisible(false)
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("answerPlayer"):getChildByName("btnLeft"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            if self.answerType ~= "select" then
                self.dorm:getChildByName("answerPlayer"):getChildByName("type"):setString("选择题")
                self.answerType = "select"
            end
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("answerPlayer"):getChildByName("btnRight"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            if self.answerType ~= "input" then
                self.dorm:getChildByName("answerPlayer"):getChildByName("type"):setString("填空题")
                self.answerType = "input"
            end
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    self.dorm:getChildByName("answerPlayer"):getChildByName("btnBase"):addTouchEventListener(function(sender,event)
        if event == ccui.TouchEventType.ended then
            self.answerData = 
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    --]]
end

function MainScene:initFinalClassButton()
    --class
    self.finalClass = self:getResourceNode():getChildByName("final")
    self.finalClass:addTouchEventListener(function(sender,event)
        print("final button="..event)
        if event == ccui.TouchEventType.ended then
            print("final")
            require("app.view.finalClassView").updateData(self:getResourceNode():getChildByName("finalClass"))
            self.back:setEnabled(true)
            self.subTitle:setString("生涯评定")
            self:getResourceNode():getChildByName("finalClass"):setVisible(true)
            self.classNow = self:getResourceNode():getChildByName("finalClass")
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
end

function MainScene:initSetAutoButton()
    self.setAuto = self:getResourceNode():getChildByName("setAuto")
    self.setAuto:addTouchEventListener(function(sender,event)
        print("final button="..event)
        if event == ccui.TouchEventType.ended then
            if self.root:isVisible() then
                self:onAfterAuto(nil, 1)
                self:showTip("指定骰子只能指定1点")
            end
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
end

function MainScene:initBackButton()
    self.back = self:getResourceNode():getChildByName("back")
    self.back:addTouchEventListener(function(sender,event)
        print("back button="..event)
        if event == ccui.TouchEventType.ended then
            print("back")
            self:initMap()

            self.totalLabel:setString("0")
            self.pointLabel:setString("0")
            self.meetLabel:setString("0")
            self.timeLabel:setString("0")

            self.step = 0

            self.subTitle:setString("园区")
            self:unlockScene()
            self:hideTip()

            self.root:setVisible(false)
            self:getResourceNode():getChildByName("titlePad"):setVisible(false)
            self.classNow:setVisible(false)
        elseif event == ccui.TouchEventType.began then
            cc.exports.soundM.click()
        end
    end)
    cc.exports.btnBack = self.back
    self.back:setEnabled(false)
end

function MainScene:initTitle()
    self:newCounter()

    self.totalLabel = self:getResourceNode():getChildByName("titlePad"):getChildByName("totalLabel")
    self.pointLabel = self:getResourceNode():getChildByName("titlePad"):getChildByName("pointLabel")
    self.meetLabel = self:getResourceNode():getChildByName("titlePad"):getChildByName("meetLabel")
    self.timeLabel = self:getResourceNode():getChildByName("titlePad"):getChildByName("timeLabel")

    self.step = 0

    schedule(self, function() 
        if self.counter then
            self.step = self.counter:getTime()
            self.timeLabel:setString(tostring(math.floor(tonumber(self.step))))
        end
    end, 
    0.1)
end

function MainScene:initMainButtonMouseAnima()
    --左下角鼠标动画
    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("mouse.plist", "mouse.png")
    local frames = {cache:getSpriteFrame("mouse1.png"), cache:getSpriteFrame("mouse2.png")}
    self.mouse = cc.Sprite:createWithSpriteFrameName("mouse1.png")
    self:addChild(self.mouse)
    local animation = cc.Animation:createWithSpriteFrames(frames, 0.5)
    self.mouse:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
    self.mouse:setPosition(self:getResourceNode():getChildByName("mouse"):getPosition())
end

function MainScene:initPopup()
    --初始化弹窗
    self.popup = require("app.view.msgPopup").new()
    self:addChild(self.popup, 10)
    self.popup:setPosition(display.cx, display.cy)
    cc.exports.popup = self.popup
end

function MainScene:initMap()
    --地图
    if not self.mapM then
        self.mapM = mapModel.new(cc.exports.eventM.eventCount, cc.exports.activeInput.problemCount + cc.exports.activeSelect.problemCount)
        self.mapV = mapView.new(self.mapM)
        self.mapV:setPositionY(380)
        self.root:addChild(self.mapM)
        self.root:addChild(self.mapV)
    else
        self.mapM:removeSelf()
        self.mapV:removeSelf()
        self.mapM = mapModel.new(cc.exports.eventM.eventCount, cc.exports.activeInput.problemCount + cc.exports.activeSelect.problemCount)
        self.mapV = mapView.new(self.mapM)
        self.mapV:setPositionY(380)
        self.root:addChild(self.mapM)
        self.root:addChild(self.mapV)
    end
end

function MainScene:initEventPad()
    --eventPad
    cc.exports.eventV = eventView.new()
    cc.exports.eventV:setPosition(565, 285)
    cc.exports.eventV:setVisible(false)
    self.root:addChild(cc.exports.eventV, 20)
end

function MainScene:initCodeProblemPad()
    cc.exports.codeProblemV = codeProblemView.new()
    cc.exports.codeProblemV:setPosition(565, 285)
    -----------------------------visible true
    cc.exports.codeProblemV:setVisible(false)

    self:addChild(cc.exports.codeProblemV, 20)
end

function MainScene:initAuto()
    --骰子
    self._autoView = autoView.new()
    self._autoView:setPosition(100, 200)
    self._autoView:setRollFlag()
    self.root:addChild(self._autoView, 20)
end

function MainScene:readGameSetting()
    --读取游戏设置
    local inited = cc.UserDefault:getInstance():getBoolForKey("inited")
    if not inited then
        --第一次初始化游戏设置
        cc.UserDefault:getInstance():setBoolForKey("inited", true)
        cc.UserDefault:getInstance():setBoolForKey("mouseAnima", true)
        cc.UserDefault:getInstance():setBoolForKey("musicFlag", true)
        cc.UserDefault:getInstance():setBoolForKey("soundFlag", true)
        cc.UserDefault:getInstance():setFloatForKey("musicVol", 0.5)
        cc.UserDefault:getInstance():setFloatForKey("soundVol", 0.5)
    end

    cc.exports.mouseAnima = cc.UserDefault:getInstance():getBoolForKey("mouseAnima")
    cc.exports.musicFlag = cc.UserDefault:getInstance():getBoolForKey("musicFlag")
    cc.exports.soundFlag = cc.UserDefault:getInstance():getBoolForKey("soundFlag")
    cc.exports.musicVol = cc.UserDefault:getInstance():getFloatForKey("musicVol")
    cc.exports.soundVol = cc.UserDefault:getInstance():getFloatForKey("soundVol")

    --设置音量
    self.musicSlider:setPercent(math.floor(cc.exports.musicVol * 100))
    self.soundSlider:setPercent(math.floor(cc.exports.soundVol * 100))
    self.musicCheckbox:setSelected(cc.exports.musicFlag)
    self.soundCheckbox:setSelected(cc.exports.soundFlag)

    --播放鼠标动画
    if not cc.exports.mouseAnima then
        self.mouseCheckbox:setSelected(false)
        performWithDelay(self, function() self.mouse:pause() end, 0.1)
    end

    --播放背景音乐
    if cc.exports.musicFlag then
        self.activeAudioID = ccexp.AudioEngine:play2d("WhenTheMorningComes.mp3", true, cc.exports.musicVol)
    end
end

--初始化玩家信息，如果是第一次玩，显示初始化面板，否则从UserDefault加载玩家信息
function MainScene:initHeroSetting()
    print("MainScene:initHeroSetting()")
    self.heroSetting = self:getResourceNode():getChildByName("initHero")

    self.heroSetting.showGirl = self:getResourceNode():getChildByName("initHero"):getChildByName("showGirl")
    self.heroSetting.showBoy = self:getResourceNode():getChildByName("initHero"):getChildByName("showBoy")
    self.heroSetting.typeScience = self:getResourceNode():getChildByName("initHero"):getChildByName("typeScience")
    self.heroSetting.typeArt = self:getResourceNode():getChildByName("initHero"):getChildByName("typeArt")
    self.heroSetting.genderM = self:getResourceNode():getChildByName("initHero"):getChildByName("genderM")
    self.heroSetting.genderF = self:getResourceNode():getChildByName("initHero"):getChildByName("genderF")

    self.heroSetting.showLeft = self:getResourceNode():getChildByName("initHero"):getChildByName("showLeft")
    self.heroSetting.showRight = self:getResourceNode():getChildByName("initHero"):getChildByName("showRight")
    self.heroSetting.typeLeft = self:getResourceNode():getChildByName("initHero"):getChildByName("typeLeft")
    self.heroSetting.typeRight = self:getResourceNode():getChildByName("initHero"):getChildByName("typeRight")
    self.heroSetting.genderLeft = self:getResourceNode():getChildByName("initHero"):getChildByName("genderLeft")
    self.heroSetting.genderRight = self:getResourceNode():getChildByName("initHero"):getChildByName("genderRight")
    
    self.heroSetting.sure = self:getResourceNode():getChildByName("initHero"):getChildByName("sure")
    self.heroSetting.title = self:getResourceNode():getChildByName("initHero"):getChildByName("title")
    self.heroSetting.name = self:getResourceNode():getChildByName("initHero"):getChildByName("name")
    self.heroSetting.coderCheckBox = self:getResourceNode():getChildByName("initHero"):getChildByName("coderCheckBox")

    self.heroSetting.btnFunc = {
        [self.heroSetting.showLeft] = function()
            cc.exports.tools.swapVisible(self.heroSetting.showGirl, self.heroSetting.showBoy)
        end,

        [self.heroSetting.showRight] = function()
            cc.exports.tools.swapVisible(self.heroSetting.showGirl, self.heroSetting.showBoy)
        end,

        [self.heroSetting.typeLeft] = function()
            cc.exports.tools.swapVisible(self.heroSetting.typeScience, self.heroSetting.typeArt)
        end,

        [self.heroSetting.typeRight] = function()
            cc.exports.tools.swapVisible(self.heroSetting.typeScience, self.heroSetting.typeArt)
        end,

        [self.heroSetting.genderLeft] = function()
            cc.exports.tools.swapVisible(self.heroSetting.genderF, self.heroSetting.genderM)
        end,

        [self.heroSetting.genderRight] = function()
            cc.exports.tools.swapVisible(self.heroSetting.genderF, self.heroSetting.genderM)
        end,

        [self.heroSetting.sure] = function()
            print("self.heroSetting.sure")
            local name = "无名"
            if self.heroSetting.name:getString() ~= "" then name = self.heroSetting.name:getString() end
            
            cc.UserDefault:getInstance():setStringForKey("heroName", name)
            cc.UserDefault:getInstance():setStringForKey("heroGender", self.heroSetting.gender or "F")
            cc.UserDefault:getInstance():setStringForKey("heroType", self.heroSetting.type or "science")
            cc.UserDefault:getInstance():setStringForKey("heroShow", self.heroSetting.show or "girl0")
            cc.UserDefault:getInstance():setBoolForKey("writeLua", self.heroSetting.coderCheckBox:isSelected() or false)
            self.heroSetting:setVisible(false)
            self:unlockScene()

            cc.exports.heroModel.init()

            self:setHeroShow()
        end,
    }

    self.heroSetting.show = "girl0"
    self.heroSetting.gender = "F"
    self.heroSetting.type = "science"
    local function onButton(sender,event)
        if event == ccui.TouchEventType.ended then
            --不同回调
            self.heroSetting.btnFunc[sender]()

            --相同回调

            --按键声音
            cc.exports.soundM.click()

            --更新文本，获取选项
            if self.heroSetting.showGirl:isVisible() then 
                self.heroSetting.show = "girl0"
                if self.heroSetting.genderF:isVisible() then
                    self.heroSetting.gender = "F"
                    self.heroSetting.title:setString("可爱少女")
                else
                    self.heroSetting.gender = "M"
                    self.heroSetting.title:setString("女装少年")
                end
            elseif self.heroSetting.showBoy:isVisible() then
                self.heroSetting.show = "boy0"
                if self.heroSetting.genderM:isVisible() then
                    self.heroSetting.gender = "M"
                    self.heroSetting.title:setString("帅气少年")
                else
                    self.heroSetting.gender = "F"
                    self.heroSetting.title:setString("男装少女")
                end
            end

            if self.heroSetting.typeScience:isVisible() then
                self.heroSetting.type = "science"
            else
                self.heroSetting.type = "art"
            end
        end
    end

    self.heroSetting.showLeft:addTouchEventListener(onButton)
    self.heroSetting.showRight:addTouchEventListener(onButton)
    self.heroSetting.typeLeft:addTouchEventListener(onButton)
    self.heroSetting.typeRight:addTouchEventListener(onButton)
    self.heroSetting.genderLeft:addTouchEventListener(onButton)
    self.heroSetting.genderRight:addTouchEventListener(onButton)
    self.heroSetting.sure:addTouchEventListener(onButton)

    --用户第一次玩，先写如一系列默认选项，以防初始化过程出问题
    local inited = cc.UserDefault:getInstance():getBoolForKey("initedHero")
    if inited then
        self.heroSetting:setVisible(false)
    else
        self.heroSetting:setVisible(true)
        self:lockScene()
        cc.UserDefault:getInstance():setBoolForKey("initedHero", true)

        cc.UserDefault:getInstance():setIntegerForKey("popular", 0)
        cc.UserDefault:getInstance():setIntegerForKey("point", 0)
        cc.UserDefault:getInstance():setIntegerForKey("exp", 0)
        cc.UserDefault:getInstance():setIntegerForKey("basePoint", 0)
        cc.UserDefault:getInstance():setIntegerForKey("artPoint", 0)
        cc.UserDefault:getInstance():setIntegerForKey("sciencePoint", 0)
        cc.UserDefault:getInstance():setIntegerForKey("letterPoint", 0)

        cc.UserDefault:getInstance():setStringForKey("heroGender", "F")
        cc.UserDefault:getInstance():setStringForKey("heroType", "science")
        cc.UserDefault:getInstance():setStringForKey("heroShow", "girl0")
        cc.UserDefault:getInstance():setBoolForKey("writeLua", false)
    end

    cc.exports.heroModel = require("app.model.heroModel")
    cc.exports.heroModel.init()

    self:setHeroShow()
end

function MainScene:initInfoPad()
    if not self.infoPad then
        self.infoPad = self:getResourceNode():getChildByName("heroInfoPad")
        print(self.infoPad)
        self.infoNameLabel = self.infoPad:getChildByName("nameLabel")
        print(self.infoNameLabel)
        self.infoGenderLabel = self.infoPad:getChildByName("genderLabel")
        self.infoTypeLabel = self.infoPad:getChildByName("typeLabel")
        self.infoCoderLabel = self.infoPad:getChildByName("coderLabel")

        self.infoBtnClose = self.infoPad:getChildByName("btnClose")
        self.infoBtnClose:addTouchEventListener(function(sender,event)
            print("infoBtnClose button="..event)
            if event == ccui.TouchEventType.ended then
                print("infoBtnClose")
                self.infoPad:setVisible(false)
            elseif event == ccui.TouchEventType.began then
                cc.exports.soundM.click()
            end
        end)

        self.infoBtnChange = self.infoPad:getChildByName("btnChange")
        self.infoBtnChange:addTouchEventListener(function(sender,event)
            print("infoBtnClose button="..event)
            if event == ccui.TouchEventType.ended then
                print("infoBtnClose")
                self.infoPad:setVisible(false)
                self.heroSetting:setVisible(true)
                self:lockScene()
            elseif event == ccui.TouchEventType.began then
                cc.exports.soundM.click()
            end
        end)

        self.btnInfoPad = self:getResourceNode():getChildByName("heroInfo")
        self.btnInfoPad:addTouchEventListener(function(sender,event)
            print("btnInfoPad button="..event)
            if event == ccui.TouchEventType.ended then
                print("btnInfoPad")
                self.infoPad:setVisible(true)
                self:initInfoPad()
            elseif event == ccui.TouchEventType.began then
                cc.exports.soundM.click()
            end
        end)
    end
    cc.exports.heroModel.init()

    self.infoNameLabel:setString(cc.exports.heroModel.data.heroName)
    if cc.exports.heroModel.data.heroGender == "F" then
        self.infoGenderLabel:setString("女生")
    else
        self.infoGenderLabel:setString("男生")
    end
    if cc.exports.heroModel.data.heroType == "science" then
        self.infoTypeLabel:setString("理科")
    else
        self.infoTypeLabel:setString("文科")
    end
    if cc.exports.heroModel.data.writeLua == true then
        self.infoCoderLabel:setString("true")
    else
        self.infoCoderLabel:setString("false")
    end
end

function MainScene:initDataPad()
    if not self.dataPad then
        self.dataPad = self:getResourceNode():getChildByName("heroDataPad")

        self.dataExpLabel = self.dataPad:getChildByName("expLabel")
        self.dataPopularLabel = self.dataPad:getChildByName("popularLabel")
        self.dataPointLabel = self.dataPad:getChildByName("pointLabel")
        self.dataBaseLabel = self.dataPad:getChildByName("baseLabel")
        self.dataScienceLabel = self.dataPad:getChildByName("scienceLabel")
        self.dataLetterLabel = self.dataPad:getChildByName("letterLabel")
        self.dataArtLabel = self.dataPad:getChildByName("artLabel")

        self.dataBtnClose = self.dataPad:getChildByName("btnClose")
        self.dataBtnClose:addTouchEventListener(function(sender,event)
            print("dataBtnClose button="..event)
            if event == ccui.TouchEventType.ended then
                print("dataBtnClose")
                self.dataPad:setVisible(false)
            elseif event == ccui.TouchEventType.began then
                cc.exports.soundM.click()
            end
        end)

        self.btnDataPad = self:getResourceNode():getChildByName("dataInfo")
        self.btnDataPad:addTouchEventListener(function(sender,event)
            print("btnDataPad button="..event)
            if event == ccui.TouchEventType.ended then
                print("btnDataPad")
                self:initDataPad()
                self.dataPad:setVisible(true)
            elseif event == ccui.TouchEventType.began then
                cc.exports.soundM.click()
            end
        end)
    end
    cc.exports.heroModel.init()

    self.dataExpLabel:setString(cc.exports.heroModel.data.exp)
    self.dataPopularLabel:setString(cc.exports.heroModel.data.popular)
    self.dataPointLabel:setString(cc.exports.heroModel.data.point)
    self.dataBaseLabel:setString(cc.exports.heroModel.data.basePoint)
    self.dataScienceLabel:setString(cc.exports.heroModel.data.sciencePoint)
    self.dataLetterLabel:setString(cc.exports.heroModel.data.letterPoint)
    self.dataArtLabel:setString(cc.exports.heroModel.data.artPoint)
end

function MainScene:setHeroShow()
    if self.hero then
        self.hero:removeSelf()
    end
    self.hero = cc.Sprite:create(cc.UserDefault:getInstance():getStringForKey("heroShow")  .. ".png")
    self.hero:setVisible(false)
    self.hero:setScale(1.5)
    self.hero:setAnchorPoint(0.5, 0)
    self.hero:setPosition(185, 81)
    self.root:addChild(self.hero, 10)
end

function MainScene:saveImage()
    print("MainScene:saveImage()")
    self:lockScene()
    self.shotTime = tostring(os.time())
    local png = string.format("%s.png", self.shotTime)
    self.target:begin()
    cc.Director:getInstance():getRunningScene():visit()
    self.target:endToLua()
    self.target:saveToFile(png, cc.IMAGE_FORMAT_PNG)
            
    performWithDelay(self, function() 
        self.target:clear(0,0,0,0)
        self.shotTime = nil 
        self:unlockScene()
    end, 3)
end

function MainScene:onShare(sender)
    self:showTip("正在保存截屏，请稍候")
    self:saveImage()
    local url = HOME
    local info = {
        title = "哇，好好玩的小游戏啊",	--title标题，印象笔记、邮箱、信息、微信、人人网和QQ空间使用
        titleUrl = url, --titleUrl是标题的网络链接，仅在人人网和QQ空间使用
        site = "这个小游戏好好玩啊，我都情不自禁的分享给你了~",		--site是分享此内容的网站名称，仅在QQ空间使用
        siteUrl = url,	--siteUrl是分享此内容的网站地址，仅在QQ空间使用
        imagePath = cc.FileUtils:getInstance():getWritablePath() .. self.shotTime .. ".png",
        --imagePath = "http://f1.sharesdk.cn/imgs/2014/05/21/oESpJ78_533x800.jpg",	--imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
        url = url,		--url仅在微信（包括好友和朋友圈）中使用
        --imageUrl = "http://f1.sharesdk.cn/imgs/2014/05/21/oESpJ78_533x800.jpg",	--imageUrl是图片的网络路径，新浪微博，人人网，QQ空间支持此字段
        text = "这个小游戏好好玩啊，我都情不自禁的分享给你了~",	--text是分享文本，所有平台都需要这个字段
        comment = "",			--comment是我对这条分享的评论，仅在人人网和QQ空间使用
    }
    performWithDelay(self, function() 
        self.share_plugin:share(info)
    end, 4)
end

function MainScene:initLock()
    print("MainScene:initLock()")
    cc.exports.lock = self:getResourceNode():getChildByName("lock")
    cc.exports.lock:setVisible(false)
end

function MainScene:lockScene()
    cc.exports.lock:setVisible(true)
    print("MainScene:lockScene()")
end

function MainScene:unlockScene()
    cc.exports.lock:setVisible(false)
    print("MainScene:unlockScene() " .. cc.exports.lock:getPositionY())
end

function MainScene:initTip()
    self.tips = {}
    for i = 1, 6 do
        self.tips[i] = display.newSprite("tip" .. i .. ".png")
        self.tips[i]:setAnchorPoint(1, 0)
        self.tips[i]:setPosition(display.right - 5, - 60)
        self.tips[i]:setVisible(false)
        self:addChild(self.tips[i])
    end

    self.msg = cc.LabelTTF:create("none", "Arial", 16, cc.size(200, 0 ))
        :addTo(self.tips[1])
    self.msg:setPosition(100, 32)
end

function MainScene:showTip(msg)
    print("show tip")
    self.msg:setString(tostring(msg))
    if not self.activeTip then
        local i = 1
        self.tips[i]:stopAllActions()
        self.tips[i]:setVisible(true)
        self.tips[i]:runAction(cc.MoveTo:create(0.5 , cc.p(display.right - 5, 0)))
        self.activeTip = i
    end
    --performWithDelay(self, function() self:hideTip() end, 5)
end

function MainScene:hideTip()
    print("hide tip")
    local i = 1
    if i then
        self.tips[i]:stopAllActions()
        self.tips[i]:runAction(transition.sequence({cc.MoveTo:create(0.5, cc.p(display.right - 5, - 60)), function() self.tips[i]:setVisible(false) end}))
    else
        for j = 1, #self.tips do
            self.tips[j]:stopAllActions()
            self.tips[j]:runAction(transition.sequence({cc.MoveTo:create(0.5, cc.p(display.right - 5, - 60)), function() self.tips[j]:setVisible(false) end}))
        end
    end
    self.activeTip = nil
end

return MainScene
