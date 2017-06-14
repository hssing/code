local BattleWidget=class("BattleWidget",
	function (  )
		return ccui.Widget:create()
	end
	)



function BattleWidget:init(parent)
	self.isBattle = false  --是否出战士
	self.parent=parent
	self.view=parent:getWidgetClone()
	self:setContentSize(self.view:getContentSize())
	self:setAnchorPoint(cc.p(0,0))
	self.view:setAnchorPoint(cc.p(0,0))
	self.view:setPosition(0,0)
	self:addChild(self.view)

	self.BtnFrame=self.view:getChildByName("Button_frame_18")
	self.LabDescribe=self.view:getChildByName("Text_describe_33")
	--攻击
	local _img_decatt = self.view:getChildByName("Image__2_33")
	self.PropertyAtk = _img_decatt:getChildByName("Text_33_31")
	--生命
	local _img_dechp =  self.view:getChildByName("Image__1_31")
	self.PropertyDef = _img_dechp:getChildByName("Text_32_29")


	_img_decatt:loadTexture(res.font.HP)
	_img_dechp:loadTexture(res.font.ATK)
	
	_img_decatt:setVisible(true)
	_img_dechp:setVisible(true)
	
	
	self.Image_head=self.BtnFrame:getChildByName("Image_22_23")

	self.Btn=self.view:getChildByName("Button_Using")
	

	self.LabName=self.view:getChildByName("Image_zb_bg_29"):getChildByName("Text_name1")
	self.LabLv=self.BtnFrame:getChildByName("Image_lv_25"):getChildByName("Text_lv_21")
	self.Icon=self.view:getChildByName("Image_Icon_27"):setVisible(false)

	self.spr7s = self.view:getChildByName("Image_13_0_0")
	self.spr7s:setVisible(false)
end

--出战
function  BattleWidget:onCallBack(send,eventype)
	if eventype == ccui.TouchEventType.ended then
		local data={}
		data.toIndex=self.pos
		data.index=self.data.index
		data.mId=self.data.mId
		data.opType = self.type--队形上阵还是阵型上阵
		--printt(data)
		proxy.card:setToindx(self.pos)
		proxy.card:reqBattle(data)
        ---点击出战
        local ids = {1010}
        mgr.Guide:continueGuide__(ids)
		self.parent:onCloseSelfView()
	end
end
--下阵
function BattleWidget:onXiaCallback( send,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		local data={}
		data.toIndex= conf.Item:getBattlePropertyTo(self.data)
		data.index=self.data.index
		data.mId=self.data.mId
		data.opType = 12--阵型下阵
		--printt(data)

		proxy.card:reqBattle(data)
        ---点击出战
        local ids = {1010}
        mgr.Guide:continueGuide__(ids)
		self.parent:onCloseSelfView()
	end 
end

function BattleWidget:setData(data,pos,stype)
		self.data=data
		self.pos=pos
		self.type = stype
		
		local Quality=conf.Item:getItemQuality(data.mId)
		local name=conf.Item:getName(data.mId,data.propertys)
		local path = conf.Item:getItemSrcbymid(data.mId,data.propertys)
		local Dscribe=conf.Item:getItemDescribe(data.mId)

		local atk = mgr.ConfMgr.getItemAtK(data.propertys)
		local hp = mgr.ConfMgr.getItemHp(data.propertys)
		if data.propertys[308].value > 0 then 
			self.Btn:setVisible(true)
			self.Btn:setTitleText(res.str.BATTLE_DEC1)
			self:setBattle(true)
			self.Btn:addTouchEventListener(handler(self,self.onXiaCallback))
		else
			self.Btn:setVisible(true)
			self.Btn:setTitleText(res.str.BATTLE_DEC2)
			self:setBattle(false)
			self.Btn:addTouchEventListener(handler(self,self.onCallBack))
		end
		
		local conf_data = conf.Item:getItemConf(self.data.mId)
		self.spr7s:setVisible(false)
		if checkint(conf_data.zhuan) > 0 then
			self.spr7s:setVisible(true)
			self.spr7s:loadTexture(res.icon.ZHUANFRAME[conf_data.zhuan])
		end
		

		 if not data.propertys[304] then 
		 	data.propertys[304]={}
		 	data.propertys[304].value = 1
		 end 

		self:setImage(path)
		self:setFrameQuality(Quality)
		self:setLabName(name)
		self:setLv(data.propertys[304].value)
		self:setDscribe(Dscribe)


		self.PropertyDef:setString(atk)
		self.PropertyAtk:setString(hp)

end
function BattleWidget:setLv(text)
	self.LabLv:setString(text)
end
function BattleWidget:setLabName(text)
	self.LabName:setString(text)
end
function BattleWidget:setImage( imgpath )
	-- body
	 self.Image_head:loadTexture(imgpath)
end
--设置框的品质
function BattleWidget:setFrameQuality(lv)
	local framePath=res.btn.FRAME[lv]
	self.BtnFrame:loadTextureNormal(framePath)
	self.LabName:setColor(COLOR[lv])
end
--设置描述
function BattleWidget:setDscribe( shuom )
	self.LabDescribe:setString(shuom)
end
--设置出战
function BattleWidget:setBattle( bool )
	--self.Btn:setBright(not bool)
	--self.Btn:setTouchEnabled(not bool)
	self.isBattle=bool
	self.Icon:setVisible(bool)
end











return BattleWidget