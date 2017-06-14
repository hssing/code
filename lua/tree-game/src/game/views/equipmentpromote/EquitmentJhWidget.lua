local EquitmentJhWidget = class("EquitmentJhWidget",require("game.views.equipmentpromote.EquitmentWidget"))



function EquitmentJhWidget:setHasEuqipment( bool )
	self.BtnEuqipment:setBright(not bool)
	self.BtnEuqipment:setTouchEnabled(not bool)
	self.Icon:setVisible(false)
end










return EquitmentJhWidget