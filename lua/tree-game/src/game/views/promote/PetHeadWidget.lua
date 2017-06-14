local PetHeadWidget=class("PetHeadWidget",
	function ( ... )
		-- body
		return ccui.Widget:create()
	end)

function PetHeadWidget:ctor(panel)
	self:init(panel)
end
function PetHeadWidget:init(panel)
	self.view=panel:clone()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setAnchorPoint(cc.p(0,0))
	self.view:setPosition(0,0)
	self:setAnchorPoint(cc.p(0,0))
	self:addChild(self.view)

	self.ImageFrame=self.view:getChildByName("Image_12")
	self.ImageHead = self.view:getChildByName("Image_13")
	self.SkillName = self.view:getChildByName("Text_head_name")
	self.LabelPlus = self.view:getChildByName("Text_13")
	self.ZuDuiName = self.view:getChildByName("Text_14")
end
function PetHeadWidget:setLabelColor( glf )
	-- body
	local c
	if glf then
		c =cc.c3b(255,104,22)
	else
		 c = cc.c3b(0xaf,0xac,0xac)
	end
	self.SkillName:setColor(c)
	self.ZuDuiName:setColor(c)
	self.LabelPlus:setColor(c)
end

function PetHeadWidget:updatePanel( data )
	--头像与名称显示第一阶的
	local cardId=conf.Item:getCardId(data.id,1)
	local name=conf.Card:getName(cardId)
	local imagehead=conf.Card:getImageSrc(cardId)
	local frameQuality=conf.Item:getItemQuality(data.id)
	self.ImageFrame:loadTexture(res.btn.FRAME[frameQuality])
	self.SkillName:setString(data.skillname)
	self.LabelPlus:setString(data.plus)
	self.ZuDuiName:setString(string.format(res.str.PET_DEC_19,name))
	--self.ZuDuiName:setString("与"..name.."组队")
	self.ImageHead:ignoreContentAdaptWithSize(true)
	local path=mgr.PathMgr.getImageHeadPath(imagehead)

	self.ImageHead:loadTexture(path)
end















return PetHeadWidget