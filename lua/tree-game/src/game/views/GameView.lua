local GameView=class("GameView",base.BaseView)


function GameView:init()
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()
end
return GameView