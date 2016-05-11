
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = true

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 800,
    height = 480,
    autoscale = "EXACT_FIT",
    callback = function(framesize)
        return {autoscale = "EXACT_FIT"}
    end
}

-- user global variable
HOME = "http://www.qq.com/"

NORMAL_RATE = 10
EVENT_RATE = 10
