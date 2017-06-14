
local BossGuReward = class("BossGuReward",base.BaseView)

function BossGuReward:init()
	-- body
	self.showtype=view_show_type.TOP 
    self.view=self:addSelfView()

    self.cloneitem = self.view:getChildByName("Button_frame")
    self.panle = self.view:getChildByName("Panel_2")

    local btn_get = self.panle:getChildByName("Button_Using_26_7")
    btn_get:addTouchEventListener(handler(self,self.onBtnClose))
    btn_get:setTitleText(res.str.RES_GG_54)

    self.item_panle = self.panle:getChildByName("Panel_14")
end

function BossGuReward:setData(data)
	-- body
	self.data = data 
	self.item_panle:removeAllChildren()
	local ccszie = self.item_panle:getContentSize()
	local y = ccszie.height/2
	local x = 0 

	local distance = 10
	local w = (self.cloneitem:getContentSize().width+distance)*#self.data - 10
	local starposx = (ccszie.width-w)/2 

	for k ,v in pairs(self.data) do 
		v.propertys = vector2table(v.propertys,"type")

		local panle = self.cloneitem:clone()
		local framePath = res.btn.FRAME[conf.Item:getItemQuality(v.mId)]
		panle:loadTextureNormal(framePath)

		local spr = conf.Item:getItemSrcbymid(v.mId,v.propertys)
		local Image_spr = panle:getChildByName("Image_spr")
		Image_spr:loadTexture(spr)
		Image_spr:ignoreContentAdaptWithSize(true)
		
		local lab_name = panle:getChildByName("Text_1") 
		lab_name:setString(conf.Item:getName(v.mId).."x"..v.amount)
		lab_name:setColor(COLOR[conf.Item:getItemQuality(v.mId)])

		panle:setPositionX(starposx + (k-1)*(panle:getContentSize().width + 10) )
		panle:setPositionY(y)
		self.item_panle:addChild(panle)
	end
end

function BossGuReward:onBtnClose(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		G_TipsOfstr(res.str.RES_GG_53)
		self:onCloseSelfView()
	end
end

return BossGuReward