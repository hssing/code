--
-- Author: Your Name
-- Date: 2015-07-22 16:23:09
--

local Loading=class("Loading",base.BaseView)

function Loading:ctor()
end

function Loading:init()
  self.showtype = view_show_type.GUIDE
  self.view = self:addSelfView()


  self.panel =self.view:getChildByName("Panel_1")
  

  local delay = cc.DelayTime:create(1)
  local func = cc.CallFunc:create(function()
    self._ready = true
    if self._func then
      self._func()
      self:closeSelfView()
    end
  end)
  self:runAction(cc.Sequence:create(delay, func))
end

function Loading:setData(flag)
  -- body
  if not flag then 
    local params = {id=404825,x=display.cx+40,y=display.cy-30,addTo=self,scale=0.5,depth=5}
    mgr.effect:playEffect(params)
  else --为了特殊处理屠魔
      self.panel:setOpacity(0)
      self.panel:setTouchEnabled(false)
  end 
end

function Loading:loadEnd(func_)
  if self._ready == true then
    if func_ then func_() end
    self:closeSelfView()
  else
    if func_ then 
      self._func = func_
    else
      self:closeSelfView()
    end
  end
end

function Loading:onRemoveCallback( ... )
  -- body
  self:stopAllActions()
  self.view:removeAllChildren()
end

return Loading