--[[--
登录场景

]]

local LoginScene = class(_scenename.LOGIN, base.BaseScene)

function LoginScene:ctor(...)
		
end

function LoginScene:addView( view, top)
	debugprint("name"..view.__name)
	if not view:getParent() then
		self:getRootLayer():addChild(view)
	end
end

function LoginScene:createLoginView()
		sdk:login()
		if self.view then 
			self.view:removeFromParent()
			self.view = nil 
		end 

		self.view = mgr.ViewMgr:createView(_viewname.LOGIN)
	  self:addChild(self.view)
end

function LoginScene:createUpdateView()
		if self.view then 
				self.view:removeFromParent()
				self.view = nil 
		end 
		self.view = mgr.ViewMgr:createView(_viewname.UPDATE_VIEW)
    self:addChild(self.view)
end

---登陆场景完成调用检测更新
function LoginScene:checkLoginUpdate()
		self:createUpdateView()
		self:addView(self.view)
end

function LoginScene:loading(callback)
		callback()
end

---添加loading
function LoginScene:addLoading()
	local view = mgr.ViewMgr:createView(_viewname.LOADING_VIEW)
	view:setData()
    self:addChild(view)
    return view
end

function LoginScene:onEnter()
		self.super.onEnter(self)
end

function LoginScene:onExit()
		self.super.onExit(self)
end

return LoginScene
