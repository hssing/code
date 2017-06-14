--CreateRoleScene
local CreateRoleScene = class(_scenename.ROLE,base.BaseScene)

function CreateRoleScene:ctor()
    
end

function CreateRoleScene:addView(view,top)
	self:getRootLayer():addChild(view)
	--self:addChild(view)
end

function CreateRoleScene:onEnter()
	self.super.onEnter(self)
end


function CreateRoleScene:loading(callback)
	self.createRole=mgr.ViewMgr:createView(_viewname.CREATE_ROLE)
	self:addView(self.createRole)
	callback()
	--self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create( callback )))
end

---添加loading
function CreateRoleScene:addLoading()
    local view = mgr.ViewMgr:createView(_viewname.LOADING_VIEW)
    view:setData()
    self:addChild(view)
    return view
end

function CreateRoleScene:onExit()
	self.super.onExit(self)
end

return CreateRoleScene
