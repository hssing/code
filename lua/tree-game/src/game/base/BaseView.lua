--[[--



]]

local BaseView = class("BaseView",function()
	return display.newNode()
end)

function BaseView:ctor()
	self._openAction 		= nil
	self._colseAction 		= nil
	self._widget 			= nil--基显示对象
	self.data               = nil
	self.showtype =  nil  --显示类型
	self._events			= {}
end

function BaseView:getClassName()
	return self.__cname
end
function BaseView:getPathName()
	return self.__name
end

function BaseView:init(  )

end

function BaseView:show( data )
	self.data=data
end

--------隐藏界面
function BaseView:onHide()
    local function  _onhide()
		self:retain()
    	self:removeFromParent()
	end
    self:_onClose(_onhide)
end

function BaseView:setData( data )
	self.data=data
end

function BaseView:setColseAction(action)
	self._colseAction = action
end

function BaseView:setOpenAction(action)
	 self._openAction = action
end

--关闭View
function BaseView:close()
	self:_onClose(handler(self,self._onCloseHandler))
end

--private 关闭处理
function BaseView:_onClose(fun_)
	self:stopAllActions()
	if self._colseAction then
		self:runAction(cc.Sequence:create(self._colseAction,cc.CallFunc:create(fun_)))
	else
		fun_()
	end
end

--private 处理一些特有的数据
function BaseView:_onCloseHandler()
	self:onCloseHandler()
end

function BaseView:updateUi(  )
end

--在子类重新
function BaseView:onCloseHandler() 
	self:removeFromParent()		
	self.data = nil
end
--设置默认关闭方式
function BaseView:setClose(closetype)
	self.ColseType=closetype
end
--关闭自身
function BaseView:closeSelfView()  
	if self.ColseType and self.ColseType == view_close_type.HIDE then
		mgr.ViewMgr:hideView(self:getPathName())
	else
		mgr.ViewMgr:closeView(self:getPathName())
	end
end
--按钮关闭自身

function BaseView:onCloseSelfView()  
	self:closeSelfView()  
end
function BaseView:loadUI(fileName,isRetain)
	self._widget=mgr.ViewMgr:loadUI(fileName)
	self:setAnchorPoint(cc.p(0,0))
	self:setContentSize(self._widget:getContentSize())
	self:setTouchEnabled(true)
	local close_btn=self._widget:getChildByName("Button_close")
	if close_btn then
		local fun = function(send,eventtype)
			if eventtype == ccui.TouchEventType.ended then
				self:onCloseSelfView()
			end
		end
		close_btn:addTouchEventListener(fun)
	end
	return self._widget
end

--添加自身view    
--文件名必须与类名一样
function BaseView:addSelfView()
	local selfview=self:loadUI(self:getClassName())
    self:addChild(selfview)
	return selfview
end


return BaseView