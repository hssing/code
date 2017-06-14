local EquitmentWidget = class("EquitmentWidget",function (  )
	-- body
	return ccui.Widget:create()
end)




function EquitmentWidget:ctor(widget)
	self.PropertyImageList = {}
	self.PropertyTextList = {}
	self:init(widget)

end

function EquitmentWidget:init(widget)
	self.view=widget:clone()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self:setAnchorPoint(cc.p(0,0))
	self.view:setAnchorPoint(cc.p(0,0))
	self.view:setPosition(0,0)
	self:addChild(self.view)
	self.name = self.view:getChildByName("Image_zb_bg_29_9"):getChildByName("Text_name1_8")
	self.BtnFrame =self.view:getChildByName("Button_frame"):setTouchEnabled(false)
	self.Img = self.BtnFrame:getChildByName("Image_22_23_5")
	self.BtnEuqipment = self.view:getChildByName("Button_zb")
	self.Qhlv = self.BtnFrame:getChildByName("Image_lv_25_7"):getChildByName("Text_lv")
	self.BtnEuqipment:addTouchEventListener(handler(self,self.onHasEquipmentCallBack))
	self.Icon = self.view:getChildByName("Image_Icon"):setVisible(false)
	self.Lable_JJ = self.view:getChildByName("Button_frame"):getChildByName("Text_jj")
	self.Lable_JJ:setVisible(false)
	for i=1,3 do
		self.PropertyImageList[i] = self.view:getChildByName("Panel_Attribute"):getChildByName("Image__"..i)
	end
	self.PropertyTextList[1]=self.PropertyImageList[1]:getChildByName("Text_32_29_12")
	self.PropertyTextList[2]=self.PropertyImageList[2]:getChildByName("Text_33_31_14")
	self.PropertyTextList[3]=self.view:getChildByName("Panel_Attribute"):getChildByName("Text_32_29_12_16")

end

function EquitmentWidget:setHasEquipmentCallBack( fun )
	self.HasEquipmentFun=fun
end

function EquitmentWidget:setHasEuqipment( bool )
	self.BtnEuqipment:setBright(not bool)
	self.BtnEuqipment:setTouchEnabled(not bool)
	self.Icon:setVisible(bool)
end


function EquitmentWidget:onHasEquipmentCallBack( send,even )
	if even == ccui.TouchEventType.ended then
		if self.HasEquipmentFun then
			self.HasEquipmentFun(self.data)
		end
	end
end
function EquitmentWidget:getData(  )
	return self.data
end
function EquitmentWidget:setData( data)
	self.data = data 
	local table_text = {}
	local table_path = {}
	local showsize= 0
	local part =conf.Item:getItemPart(data.mId) 
	local Quality=conf.Item:getItemQuality(data.mId)
	local itemSrc=conf.Item:getSrc(data.mId,data.propertys)
	local path=conf.Item:getItemSrcbymid(data.mId, data.propertys)
	--mgr.PathMgr.getItemImagePath(itemSrc)
    --[[local type=conf.Item:getType(data.mId)
    if type == pack_type.SPRITE then 
        path=mgr.PathMgr.getImageHeadPath(itemSrc)
    end ]]--
	local name = conf.Item:getName(data.mId,data.propertys)
	local qhlv = mgr.ConfMgr.getItemQhLV(data.propertys)
	local jhlv =  mgr.ConfMgr.getItemJh(data.propertys)
	local framePath=res.btn.FRAME[Quality]

	self.BtnFrame:loadTextureNormal(framePath)
	--self.Lable_JJ:setVisible(jhlv>0)
	self.Lable_JJ:setString(jhlv)
	self.Img:ignoreContentAdaptWithSize(true)
	self.Img:loadTexture(path)
	self.name:setColor(COLOR[Quality])
	self.name:setString(name)
	self.Qhlv:setString(qhlv)

	self.Icon:setVisible(false)
	
	self.BtnEuqipment:setVisible(true)
	if data.index>400000 then 
		--self.BtnEuqipment:setVisible(false)
		self.Icon:setVisible(true)
	end 

	if part== 1 then --头盔
		showsize =3
		table_path[1] = res.font.ATK
		table_path[2] = res.font.HP
		table_path[3] = res.font.CRIT_SH
		table_text[1] = mgr.ConfMgr.getItemAtK(data.propertys)
		table_text[2] = mgr.ConfMgr.getItemHp(data.propertys)
		table_text[3] = mgr.ConfMgr.getCritSh(data.propertys)
	elseif part == 2 then -- 武器
		showsize = 2
		table_path[1] = res.font.ATK
		table_path[2] = res.font.MZ
		table_text[1] = mgr.ConfMgr.getItemAtK(data.propertys)
		table_text[2] = mgr.ConfMgr.getMz(data.propertys)
	elseif part == 3 then -- 衣服
		showsize = 2
		table_path[1] = res.font.HP
		table_path[2] = res.font.JR
		table_text[1] = mgr.ConfMgr.getItemHp(data.propertys)
		table_text[2] = mgr.ConfMgr.getResistantCrit(data.propertys)
	elseif part == 4 then -- 披风
		showsize = 3
		table_path[1] = res.font.ATK
		table_path[2] = res.font.HP
		table_path[3] = res.font.CRIT_SH
		table_text[1] = mgr.ConfMgr.getItemAtK(data.propertys)
		table_text[2] = mgr.ConfMgr.getItemHp(data.propertys)
		table_text[3] = mgr.ConfMgr.getCritSh(data.propertys)

	elseif part == 5 then -- 裤子
		showsize = 2
		table_path[1] = res.font.HP
		table_path[2] = res.font.SB
		table_text[1] = mgr.ConfMgr.getItemHp(data.propertys)
		table_text[2] = mgr.ConfMgr.getDodge(data.propertys)
	elseif part == 6 then -- 图腾
		showsize = 2
		table_path[1] = res.font.ATK
		table_path[2] = res.font.CRIT
		table_text[1] = mgr.ConfMgr.getItemAtK(data.propertys)
		table_text[2] = mgr.ConfMgr.getCrit(data.propertys)
	end
	for i=1,#self.PropertyTextList do
		if i > showsize then
			self.PropertyImageList[i]:setVisible(false)
			self.PropertyTextList[i]:setVisible(false)
		else
			self.PropertyImageList[i]:setVisible(true)
			self.PropertyTextList[i]:setVisible(true)
			self.PropertyImageList[i]:ignoreContentAdaptWithSize(true)
			self.PropertyImageList[i]:loadTexture(table_path[i])
			self.PropertyTextList[i]:setString(table_text[i])
			if i <3 then 
				self.PropertyTextList[i]:setPositionX(self.PropertyImageList[i]:getContentSize().width + 5)
			else
				self.PropertyTextList[i]:setPositionX(self.PropertyImageList[i]:getContentSize().width + 5
					+self.PropertyImageList[i]:getPositionX())
			end 
		end
	end

end







return EquitmentWidget