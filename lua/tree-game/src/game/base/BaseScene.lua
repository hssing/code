
local BaseScene = class("BaseScene", function()
    return display.newScene("BaseScene")
end)

function BaseScene:ctor()
end

function BaseScene:getRootLayer( )
	if self.Rootlayer == nil then
		local Rootlayer=display.newLayer()
	 	Rootlayer:setContentSize(display.width,display.height)
	 	Rootlayer:setPosition(0,0)
	 	Rootlayer:setAnchorPoint(cc.p(0,0))
	 	display.setNodeAdaptationScale(Rootlayer)
		self.Rootlayer=Rootlayer
	 	self:addChild(self.Rootlayer)
 	end
 	return self.Rootlayer
end

--override
function BaseScene:getClassName()
	return self.__cname
end

--override
function BaseScene:addView(view,top)
end

--override
function BaseScene:loading(callback) 

end

--override
function BaseScene:changeView(view) 

end

function BaseScene:onEnter()
	G_ClearTexture____()

    --注册返回键事件
	local keyListener = cc.EventListenerKeyboard:create()
    local function onrelease(code, event)
        if code == cc.KeyCode.KEY_BACK then
            --G_TipsOfstr("点击返回键")
            sdk:onBack()
        end
    end
    keyListener:registerScriptHandler(onrelease,cc.Handler.EVENT_KEYBOARD_RELEASED) 
    local eventDispatch = self:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(keyListener,self)

    --场景切换完成回调
    if self._changeComplete then
        self._changeComplete()
    end
end

function BaseScene:changeSceneCompleteCall(func_)
    if func_ then
        self._changeComplete = func_
    end
end

function BaseScene:onExit()
    self._changeComplete = nil
end


return BaseScene