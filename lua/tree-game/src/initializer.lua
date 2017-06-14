require("config")
require("cocos.init")
require("framework.init")
require("game.init")
require("message.init")
sdk = require("game.sdk.init")--SDK

local Initializer = class("Initializer", cc.mvc.AppBase)

function Initializer:ctor()
    Initializer.super.ctor(self,"mx","game")
end

function Initializer:initAll( ... )
   
end

function Initializer:initManagers( ... )
    require("game.init")
    require("message.init") 
    require("game.sdk.init")--SDK
end

function Initializer:run()
    mgr.SceneMgr:joinPreScene()
end

return Initializer