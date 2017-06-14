
--[[
	阵营提示
]]

local CampTips = class("CampTips",base.BaseView)

function CampTips:init()
	-- body
    self.showtype=view_show_type.TOP
    self.view=self:addSelfView()

    local imgbg = self.view:getChildByName("Image_1")
    self.imgbg = imgbg

    self.btnsure = imgbg:getChildByName("Button_2")
    self.btnsure:addTouchEventListener(handler(self,self.onBtnSureCallBack)) 

    self:initDec()
end

function CampTips:initDec()
	-- body
	self.spr = self.imgbg:getChildByName("Image_1_0")
	self.lab_dec = self.imgbg:getChildByName("Text_17_0")

	----
	local dec_1 = self.imgbg:getChildByName("Text_17")
	dec_1:setString(res.str.DEC_ERR_37)

	local dec_1 = self.imgbg:getChildByName("Text_17_0_0")
	dec_1:setString(res.str.DEC_ERR_38)

	self.btnsure:getChildByName("Text_1_17_14"):setString(res.str.SURE)
end

function CampTips:setData(data)
	-- body
	self.data = data 

	if data.camp == 1 then 
		self.spr:loadTexture(res.image.CAMP_BG_LEFT1)
		self.lab_dec:setString(res.str.DEC_ERR_35)
		self.lab_dec:setColor(cc.c3b(45,236,253))
	else
		self.spr:loadTexture(res.image.CAMP_BG_LEFT2)
		self.lab_dec:setString(res.str.DEC_ERR_36)
		self.lab_dec:setColor(cc.c3b(245,82,251))
	end
end

function CampTips:onBtnSureCallBack(send, eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then 
		

		local _view = mgr.ViewMgr:get(_viewname.CAMP_FIRSTR)
		if _view then 
			_view:onCloseSelfView()
		end

		local view = mgr.ViewMgr:showView(_viewname.CAMP_MIAN)
		view:setData()

		self:onCloseSelfView()
	end 
end

function CampTips:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CampTips