--[[
最开始的场景
]]
local PreScene = class("PreScene",base.BaseScene)
function PreScene:ctor()
	self.ListLayer  =  nil   --层列表
  self:init()
end

function PreScene:init()
  	self.ListLayer={}
  	self:addLayer()  
end

function PreScene:addLayer()
  	local layer = display.newNode()
   	layer:setContentSize(display.width, display.height)
   	layer:setPosition(0,0)
   	layer:setAnchorPoint(cc.p(0,0))
   	self.ListLayer[#self.ListLayer+1]=layer
   	self:getRootLayer():addChild(layer,#self.ListLayer)
end

function PreScene:PlayMp4(name)
    if device.platform == "android" or device.platform == "ios" then
        nous.isVoide = true
  		  self.toplayer = self.ListLayer[#self.ListLayer]
  		  local function onVideoEventCallback( sener, eventType )
            if eventType == ccexp.VideoPlayerEvent.PLAYING then
            elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
                local video_ = self.toplayer:getChildByName( "video_player" )
                video_:setVisible(false)
                if device.platform == "android" then
                    self.toplayer:removeFromParent()
                    self:playOver()
                end    
            elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
            elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
                local video_ = self.toplayer:getChildByName( "video_player" )
                video_:setVisible(false)
                --self.toplayer:removeFromParent()
                self:playOver()
            end
        end
  		  local videoPlayer = ccexp.VideoPlayer:create()
        videoPlayer:setName( "video_player" )
        videoPlayer:setVisible(true)
  	    videoPlayer:setPosition(display.cx,display.cy)
  	    videoPlayer:setAnchorPoint(cc.p(0.5, 0.5))
  	    videoPlayer:setContentSize(cc.size(display.width,display.height))
        videoPlayer:setKeepAspectRatioEnabled(false)
        --videoPlayer:setVideoTouchEnabled(false)
        --videoPlayer:setEnable(false)
  	    videoPlayer:setFullScreenEnabled(true)
  	    videoPlayer:addEventListener(onVideoEventCallback)
        self.toplayer:addChild(videoPlayer, -2, -2)
        
        local color_ = cc.LayerColor:create( cc.c4b( 0xff,0,0,0 ) )
        self.toplayer:addChild( color_ )
        color_:setTouchEnabled(true)
  -- color_:setFocused(true)
        self._listener = cc.EventListenerTouchOneByOne:create()
        self._listener:setSwallowTouches(true)
        self._listener:registerScriptHandler(handler(self,self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN )
        self._listener:registerScriptHandler(handler(self,self.onTouchMoved),cc.Handler.EVENT_TOUCH_MOVED )
        self._listener:registerScriptHandler(handler(self,self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED )
  		  color_:getEventDispatcher():addEventListenerWithSceneGraphPriority(self._listener,color_)

  		  self.toplayer:performWithDelay(function( ... )
            videoPlayer:setFileName("res/video/"..name..".mp4")
            videoPlayer:play()
        end, 0)
  	else
  		  self:playOver()
  	end
end

function PreScene:onTouchBegan(touch_, event_)
  return true
end

function PreScene:onTouchMoved(touch_, event_)
  return true
end

function PreScene:onTouchEnded(touch_, event_)
  local pos = touch_:getLocation()
  local size = display.size
  --if pos.x > size.width*0.80 and pos.y > size.height*0.80 then
    local video_ = self.toplayer:getChildByName( "video_player" )
    if video_ and device.platform == "ios" then
      self.toplayer:removeFromParent()
      self:playOver()
    end
  --end
  return true
end

function PreScene:playVoide()
    self:PlayMp4("gamestart")
end

function PreScene:playOver()
    mgr.SceneMgr:LoginSceneWithUpdateCheck(true)
end

function PreScene:loading(callback)
    callback()
end

function PreScene:onEnter()
    self.super.onEnter(self)
    --if device.platform == "android" then
    --    self:playVoide()
    --end
    --百度91特殊处理，等统一换ios包用上面
    if g_var.channel_id.."" ~= "811" then
        self:playVoide()
    end  
end

function PreScene:onExit()
    self.super.onExit(self)
end

return PreScene