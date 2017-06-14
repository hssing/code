local BaseTipsView=class("BaseTipsView",import(".BaseView"))



function BaseTipsView:ctor()
	--self.super.ctor(self)
end

function BaseTipsView:init()
	self.showtype=view_show_type.TIPS
end





return BaseTipsView