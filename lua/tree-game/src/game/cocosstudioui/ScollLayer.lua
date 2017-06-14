
local CollisionRect = require("game.cocosstudioui.CollisionRect")
local ScollLayer = class("ScollLayer",function ( )
	-- body
	return cc.Layer:create()
end)
ScollLayer.H_LEFT = 1
ScollLayer.H_RIGHT  = 2
ScollLayer.V_UP  = 1
ScollLayer.V_DOWN  = 2
function ScollLayer:ctor(rect,minLength,isdebugRect,Swallow)
	self._rect =  rect
	self._minLength = minLength
	self._Swallow = Swallow
	self.H_MoveDir = nil   --水平移动的方向
	self.V_MoveDir = nil   --垂直移动的方向
	if isdebugRect then
		local _debugRect = CollisionRect.new(rect)
		self:addChild(_debugRect,100)
	end
	self:createMouseEvent(self,handler(self,self.onTouchBegan),handler(self,self.onTouchMoved),handler(self,self.onTouchEnded))
end


function ScollLayer:setMoveLeftCalllBack(fun)
	self._moveleftcallback = fun
end
function ScollLayer:setMoveRightCalllBack(fun)
	self._moverightcallback = fun
end
function ScollLayer:setMoveUpCalllBack(fun)
	self._moveupcallback = fun
end
function ScollLayer:setMoveDownCalllBack(fun)
	self._movedowncallback = fun
end

function ScollLayer:setMoveingCallback( fun )
	-- body
	self.moveingcallback = fun
end


function ScollLayer:createMouseEvent(layer,onTouchBegan,onTouchMoved,onTouchEnded)--为ScrollView添加按键事件
    local listener = cc.EventListenerTouchOneByOne:create()--创建一个事件侦听器的触摸
    listener:setSwallowTouches(self._Swallow or false)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )--注册脚本处理程序
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()--获得获取事件控制器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)--添加场景的优先事件监听器
end


function ScollLayer:onTouchBegan(touch,event)
		local x=touch:getLocation().x
		local y=touch:getLocation().y
		local list_x=self._rect.x
		local list_y=self._rect.y
		local list_w=self._rect.width
		local list_h=self._rect.height
		if x < list_x or  x > list_x+list_w or y < list_y or y > list_y + list_h then
			--debugprint("在点击区域外")
			return false
		else
			self._starpos = touch:getLocation()
			--debugprint("开始")
		end
        return true
    end
 function ScollLayer:onTouchMoved(touch,event)
 	local x=touch:getLocation().x
 	local distance =  self._starpos.x - x
 	--debugprint("移动"..distance)
 	--self.moveingcallback(distance)
 end
 function ScollLayer:onTouchEnded(touch,event)
 		local x=touch:getLocation().x
		local y=touch:getLocation().y
		self.H_MoveDir = self._starpos.x - x > 0 and  ScollLayer.H_LEFT or ScollLayer.H_RIGHT
 		self._moveWidth = math.abs(self._starpos.x - x)
 		self._moveHeight = math.abs(self._starpos.y - y)
 		--print("self._moveWidth:"..self._moveWidth)
 		--print("self._moveHeight:"..self._moveHeight)
 		--水平向左
 		if self._moveWidth >= self._minLength  then   
	 		if self.H_MoveDir == ScollLayer.H_LEFT then
				if  self._moveleftcallback then
					self._moveleftcallback()
				end
	 		elseif self.H_MoveDir == ScollLayer.H_RIGHT then
				if  self._moverightcallback then
					self._moverightcallback()
				end
	 		end
 		end 
 end














return ScollLayer