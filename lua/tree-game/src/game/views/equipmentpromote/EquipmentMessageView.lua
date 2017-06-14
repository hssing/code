
local EquipmentMessageWidget = require("game.views.equipmentpromote.EquipmentMessageWidget")
local ScollLayer = require("game.cocosstudioui.ScollLayer")

local EquipmentMessageView = class("EquipmentMessageView",base.BaseView)


function EquipmentMessageView:init()
	self.showtype=view_show_type.TOP
	self.view = self:addSelfView()
	self.ScollView = self.view:getChildByName("ScrollView_1")
	self.Lablename = self.view:getChildByName("Text_name")


	self.cloneWidget = self.view:getChildByName("Panel_clone")
	self.EquipmentWidget = EquipmentMessageWidget.new(self.cloneWidget)

	self.BtnRight = self.view:getChildByName("Button_19_0")
	self.BtnRight:setTag(10002)
	self.BtnRight:addTouchEventListener(handler(self,self.onDirCallBack))
	self.BtnLift = self.view:getChildByName("Button_19")
	self.BtnLift:setTag(10001)
	self.BtnLift:addTouchEventListener(handler(self,self.onDirCallBack))

	local posx = (self.BtnRight:getPositionX()+self.BtnLift:getPositionX())/2-self.EquipmentWidget:getContentSize().width/2
	local posy = self.BtnRight:getPositionY()- self.EquipmentWidget:getContentSize().height/2

	self.EquipmentWidget:setPosition(posx,posy)
	self:addChild(self.EquipmentWidget)
	self.PanelQh = self.ScollView:getChildByName("Panel1")
	self.PanelJh = self.ScollView:getChildByName("Panel2")
	self.PanelProperty = self.ScollView:getChildByName("Panel3")
	self.PanelpropertyLabel = self.view:getChildByName("Panel_property")
	--Ì××°ÊôÐÔÃæ°å±³¾°
	self.Bg_PropertyImg = self.PanelProperty:getChildByName("Image_33_60_78")


	self.Image_star = self.view:getChildByName("Image_star")
	self.Img_h = self.Bg_PropertyImg:getContentSize().height
	self.ImageFrameWidget = {}
	self.ImagePropetyWidget = {}

	
	--¸ü»»°´Å¥
	self.BtnChange = self.view:getChildByName("Button_change")
	self.BtnChange:addTouchEventListener(handler(self,self.onChangeCallBack))

	self.LabelQh_nowlv =  self.PanelQh:getChildByName("Panel_35"):getChildByName("Text_80_0")
	self.LabelQh_maxlv =  self.PanelQh:getChildByName("Panel_35"):getChildByName("Text_19_11_36")

	--self.lab
	self.pro1 = self.PanelQh:getChildByName("Panel_35_1")
	self.pro1.dec = self.pro1:getChildByName("Text_39_18_9_34_53")
	self.pro1.value = self.pro1:getChildByName("Text_19_11_36_55")

	self.pro2 = self.PanelQh:getChildByName("Panel_35_0")
	self.pro2.dec = self.pro2:getChildByName("Text_39_18_9_34_43")
	self.pro2.value = self.pro2:getChildByName("Text_19_11_36_45")

	self.pro3 = self.PanelQh:getChildByName("Panel_35_0_0")
	self.pro3.dec = self.pro3:getChildByName("Text_39_18_9_34_43_47")
	self.pro3.value = self.pro3:getChildByName("Text_19_11_36_45_51")

	self.pro4 = self.PanelQh:getChildByName("Panel_35_0_0_0")
	self.pro4.dec = self.pro4:getChildByName("Text_39_18_9_34_43_47_103")
	self.pro4.value = self.pro4:getChildByName("Text_19_11_36_45_51_105")

	--self.LabelQh_hp = self.PanelQh:getChildByName("Panel_35_0"):getChildByName("Text_19_11_36_45")
	--self.LabelQh_crit = self.PanelQh:getChildByName("Panel_35_0_0"):getChildByName("Text_19_11_36_45_51")
	--self.LabelQh_atk=self.PanelQh:getChildByName("Panel_35_1"):getChildByName("Text_19_11_36_55")
	--Ç¿»¯°´Å¥
	self.BtnQh = self.PanelQh:getChildByName("Button_21")
	self.BtnQh:addTouchEventListener(handler(self,self.onQhCallBack))
	--¾«Á¶°´Å¥
	self.BtnJh = self.PanelJh:getChildByName("Button_21_23")
	self.BtnJh:addTouchEventListener(handler(self,self.onJhCallBack))

	self.LabelJh_nowlv = self.PanelJh:getChildByName("Panel_35_31"):getChildByName("Text_80")
	self.LabelJh_maxlv = self.PanelJh:getChildByName("Panel_35_31"):getChildByName("Text_19_11_36_63")

	self.jl1 = self.PanelJh:getChildByName("Panel_35_1_37")
	self.jl1.dec = self.jl1:getChildByName("Text_39_18_9_34_53_73")
	self.jl1.value = self.jl1:getChildByName("Text_19_11_36_55_75")

	self.jl2 = self.PanelJh:getChildByName("Panel_35_0_33_0")
	self.jl2.dec = self.jl2:getChildByName("Text_39_18_9_34_43_65_111")
	self.jl2.value = self.jl2:getChildByName("Text_19_11_36_45_67_113")

	self.jl3 = self.PanelJh:getChildByName("Panel_35_0_33_0_0")
	self.jl3.dec = self.jl3:getChildByName("Text_39_18_9_34_43_65_111_115")
	self.jl3.value = self.jl3:getChildByName("Text_19_11_36_45_67_113_117")

	self.jl4 = self.PanelJh:getChildByName("Panel_35_0_33")
	self.jl4.dec = self.jl4:getChildByName("Text_39_18_9_34_43_65")
	self.jl4.value = self.jl4:getChildByName("Text_19_11_36_45_67")
	--[[self.LabelJh_hit =  self.PanelJh:getChildByName("Panel_35_0_33"):getChildByName("Text_19_11_36_45_67")
	self.LabelJh_atk =  self.PanelJh:getChildByName("Panel_35_1_37"):getChildByName("Text_19_11_36_55_75")]]--

	local posx,posy = self.view:getChildByName("Panel_26"):getPosition()
	local ccsize =  self.view:getChildByName("Panel_26"):getContentSize()

	local rect =cc.rect(posx,posy,ccsize.width,ccsize.height)
	local layer = ScollLayer.new(rect,30)
	layer:setName("touchlayer")
	layer:setMoveLeftCalllBack(handler(self,self.prv))
	layer:setMoveRightCalllBack(handler(self,self.next))
	self:addChild(layer)


	--界面文本
	local panel35 = self.PanelQh:getChildByName("Panel_35")
	panel35:getChildByName("Text_39_18_9_34"):setString(res.str.EQUIPMENT_DEC2)
	self.pro1:getChildByName("Text_39_18_9_34_53"):setString(res.str.EQUIPMENT_DEC3)
	self.pro2:getChildByName("Text_39_18_9_34_43"):setString(res.str.EQUIPMENT_DEC4)
	self.pro4:getChildByName("Text_39_18_9_34_43_47_103"):setString(res.str.EQUIPMENT_DEC5)
	self.pro3:getChildByName("Text_39_18_9_34_43_47"):setString(res.str.EQUIPMENT_DEC5)

	local panel_35_1= self.PanelJh:getChildByName("Panel_35_31")
	panel_35_1:getChildByName("Text_39_18_9_34_61"):setString(res.str.EQUIPMENT_DEC6)
	self.jl2:getChildByName("Text_39_18_9_34_43_65_111"):setString(res.str.EQUIPMENT_DEC4)
	self.jl4:getChildByName("Text_39_18_9_34_43_65"):setString(res.str.EQUIPMENT_DEC4)
	self.jl1:getChildByName("Text_39_18_9_34_53_73"):setString(res.str.EQUIPMENT_DEC3)
	self.jl3:getChildByName("Text_39_18_9_34_43_65_111_115"):setString(res.str.EQUIPMENT_DEC4)

	self.BtnQh:setTitleText(res.str.EQUIPMENT_DEC8)
	self.BtnJh:setTitleText(res.str.EQUIPMENT_DEC9)
	self.PanelpropertyLabel:getChildByName("Text_suit_name"):setString(res.str.EQUIPMENT_DEC6)
	self.BtnChange:setTitleText(res.str.EQUIPMENT_DEC10)

end
--Ç¿»¯»Øµ÷
function EquipmentMessageView:onQhCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		local nowdata = self.data[self.NowSelectIndex][self.EuqipmentType]

		local Quality=conf.Item:getItemQuality(nowdata.mId)

		if Quality < 4 then 
			G_TipsOfstr(res.str.EQUIPMENT_LOWER3QH)
			return 
		end 
		local view = mgr.ViewMgr:showView(_viewname.EQUIPMENT_QH)
		view:setData(nowdata)
		view:setShowPageView(1)
		
        --µã»÷Ç¿»¯
        local ids = {1047}
        mgr.Guide:continueGuide__(ids)
		
		self:onCloseSelfView()
	end
end


--¾«Á¶»Øµ÷
function EquipmentMessageView:onJhCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		---
		local herolv = cache.Player:getLevel()
		if herolv < 20 then 
			G_TipsOfstr(res.str.LV20OPEN)
			return 
		end 

		local nowdata = self.data[self.NowSelectIndex][self.EuqipmentType]
		local colorlv = conf.Item:getItemQuality(nowdata.mId)
		if colorlv < 4 then 
			G_TipsOfstr(res.str.EQUIPMENT_LOWER3JL)

			return 
		end 
		--print("--------------------------------------------***************************")
		--printt(nowdata)

		mgr.ViewMgr:showView(_viewname.EQUIPMENT_QH):setData(nowdata):setShowPageView(2)
		self:onCloseSelfView()
	end
end
--×óÓÒÇÐ»»
function EquipmentMessageView:onDirCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		if send:getTag() == 10001 then
			self:prv()
		elseif send:getTag() ==  10002 then
			self:next()
		end
	end

end
--Ìæ»»×°±¸
function EquipmentMessageView:onChangeCallBack(send,eventtype)
	if eventtype == ccui.TouchEventType.ended then
		local pos = 400000+self.NowSelectIndex*1000+self.EuqipmentType
		mgr.ViewMgr:showView(_viewname.EQUIPMENT):setData(pos)
	end
end
--ÏÂ¸ö×°±¸
function EquipmentMessageView:next(  )
	if not self:isVisible() then 
		return 
	end 

	if self.EuqipmentType < 6 then
		self.EuqipmentType=self.EuqipmentType+1
	else
		if self.NowSelectIndex < 6 then
			self.EuqipmentType = 1
			self.NowSelectIndex =  self.NowSelectIndex +1
		else
			self.NowSelectIndex = 1 
			self.EuqipmentType =  1
		end
	end
	local data_ = self.data[self.NowSelectIndex][self.EuqipmentType]
	if not data_ then
		self:next()
	else
		self:selectUpdateByData(data_)
	end
end
--ÉÏÒ»¸ö×°±¸
function EquipmentMessageView:prv( )
	if not self:isVisible() then 
		return 
	end 
	
	if self.EuqipmentType > 1 then
		self.EuqipmentType=self.EuqipmentType - 1
	else
		if self.NowSelectIndex > 1 then
			self.EuqipmentType = 6
			self.NowSelectIndex =  self.NowSelectIndex - 1
		else
			self.NowSelectIndex = 6 
			self.EuqipmentType =  6
		end
	end
	local data_ = self.data[self.NowSelectIndex][self.EuqipmentType]
	if not data_ then
		self:prv()
	else
		self:selectUpdateByData(data_)
	end
end

function EquipmentMessageView:updateData(data)
	if not self.data then return end 
	self.data[self.NowSelectIndex][self.EuqipmentType]=data
	self:selectUpdateByData(data)
end

function EquipmentMessageView:setData( data )
	self.data=data
end

function EquipmentMessageView:selectUpdate(pos,euqipment_type)
	if not self.data then return end 
	self.NowSelectIndex =  pos
	self.EuqipmentType = euqipment_type
	local data_= self.data[pos][euqipment_type]
	self:selectUpdateByData(data_)

	--ÇëÇóÏêÏ¸ÐÅÏ¢
	---proxy.pack:reqDetailed(pack_type.EQUIPMENT,data_.index)		
end
-- ÇëÇóÏêÏ¸ÐÅÏ¢ ·µ»ØË¢ÐÂ
function EquipmentMessageView:updateSecond( data )
	-- body
	--self.data[self.NowSelectIndex][self.EuqipmentType] = data
	--self:selectUpdateByData(data)
end

function EquipmentMessageView:selectUpdateByData(data)
	if data then
		self:updatePanel(data)
	end
end
function EquipmentMessageView:updatePanel( data )
	local Quality=conf.Item:getItemQuality(data.mId)
	local name = conf.Item:getName(data.mId,data.propertys)


	self.Lablename:setString(name)
	self.Lablename:setColor(COLOR[Quality])
	self.EquipmentWidget:setData(data)
	self:addStar(Quality)

	self:addItemList(data)
	self:updateQhProperty(data)
	self:updateJhProperty(data)

	self.ScollView:jumpToTop()
end

function EquipmentMessageView:graybtn(btn,flag)
	-- body
	btn:setBright(flag)
	btn:setTouchEnabled(flag)
end

--Ç¿»¯ÊôÐÔ
function EquipmentMessageView:updateQhProperty(data)
	local quality = conf.Item:getItemQuality(data.mId)
	local part = conf.Item:getItemPart(data.mId) -- ²¿Î»

	local nowqhlv = mgr.ConfMgr.getItemQhLV(data.propertys)
    local maxlv = math.min(cache.Player:getLevel(),conf.Item:getMaxQhLv(data.mId))



	if nowqhlv >= maxlv then
		self.LabelQh_nowlv:setColor(cc.c3b(255,0,0))
	else
		self.LabelQh_nowlv:setColor(cc.c3b(0,255,0))
	end
	self.LabelQh_nowlv:setString(nowqhlv)
	self.LabelQh_maxlv:setString("/"..maxlv)

	 --蓝色和绿色增加下图位置红色描述，同时 强化等级和精炼等级应该是：0/0
    self.BtnQh:removeAllChildren()
    if quality < 4 then 
    	maxlv = 0
    	--self.BtnQh
    	local label = display.newTTFLabel({
		    text = "("..res.str.EQUIPMENT_LOWER3QH..")",
		    size = 18,
		    font = self.LabelQh_nowlv:getFontName(),
		    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
		    x = self.BtnQh:getContentSize().width/2,
		    y = -self.BtnQh:getContentSize().height/2,
		    color = COLOR[6],
		})
		label:addTo(self.BtnQh)
		self.LabelQh_nowlv:setColor(cc.c3b(0,255,0))
    end 


	local EquipmentQhID = conf.Item:getEquipmentQhId(data.mId,nowqhlv)
	local atk
	local power = conf.EquipmentQh:getPower(EquipmentQhID)
	local hp
	local crit_hurt
	local hit
	local defcri
	local dodge
	local crit 
	if part == 1 then 
		atk = conf.EquipmentQh:getAtk(EquipmentQhID)
		hp = conf.EquipmentQh:getHp(EquipmentQhID)
		crit_hurt = conf.Item:getLocalEquipCrithurt(data.mId)
	elseif part == 2 then 
		atk = conf.EquipmentQh:getAtk(EquipmentQhID)
		hit = conf.Item:getLocalEquipdefmingzhong(data.mId)
	elseif part == 3 then 
		hp = conf.EquipmentQh:getHp(EquipmentQhID)
		defcri = conf.Item:getLocalEquipdefCrit(data.mId)
	elseif part == 4 then 
		atk = conf.EquipmentQh:getAtk(EquipmentQhID)
		hp = conf.EquipmentQh:getHp(EquipmentQhID)
		crit_hurt = conf.Item:getLocalEquipCrithurt(data.mId)
	elseif part == 5 then 
		hp = conf.EquipmentQh:getHp(EquipmentQhID)
		dodge = conf.Item:getLocalEquipdshanbi(data.mId)
	elseif part == 6 then 
		atk = conf.EquipmentQh:getAtk(EquipmentQhID)
		crit = conf.Item:getLocalEquipCrit(data.mId)
	end 
	if atk then 
		atk = conf.Item:getLocalEquipAtt(data.mId) + atk
	end 
	power = conf.Item:getloaclEquippower(data.mId) + power
	if hp then 
		hp = conf.Item:getLocalEquipHp(data.mId) + hp
	end 

	for i = 1 , 4 do 
		self["pro"..i]:setVisible(false)
	end 
	
	local bl=0
	local function _insetPro(lab,v )
		-- body
		local k = pos 
		if v  then 
			bl = bl +1 
			self["pro"..bl]:setVisible(true)
			self["pro"..bl].dec:setString(lab..":")
			self["pro"..bl].value:setString("+"..v)
		end
	end
	_insetPro(res.str.PRO_PROWER,power)--Õ½¶·Á¦
	_insetPro(res.str.PRO_GONGJI,atk) --¹¥»÷
	_insetPro(res.str.PRO_HP,hp)--ÉúÃü
	_insetPro(res.str.PRO_CRIT,crit)--±©»÷
	_insetPro(res.str.PRO_CRITHUT,crit_hurt)--PRO_CRITHUT
	_insetPro(res.str.PRO_MINGZHONG,hit)--PRO_MINGZHONG
	_insetPro(res.str.PRO_DECRIT,defcri)--¼áÈÍ
	_insetPro(res.str.PRO_DODGE,dodge)--¶º
	
	--[[self.LabelQh_hp:setString("+"..hp)
	self.LabelQh_crit:setString("+"..power)
	self.LabelQh_atk:setString("+"..atk)]]--

	self:graybtn(self.BtnQh,true)


	if nowqhlv >= cache.Player:getLevel() or not  conf.EquipmentQh:isExist(EquipmentQhID+1)  then 
		--self:graybtn(self.BtnQh,false)
	end 
end
--¾«Á¶ÊôÐÔ
function EquipmentMessageView:updateJhProperty(data)
	local quality = conf.Item:getItemQuality(data.mId)
	local part = conf.Item:getItemPart(data.mId) -- ²¿Î»
	local nowjhlv = mgr.ConfMgr.getItemJh(data.propertys)
    local maxlv = math.min(cache.Player:getLevel(),conf.Item:getMaxJhLv(data.mId))
   

	if nowjhlv >= maxlv then
		self.LabelJh_nowlv:setColor(cc.c3b(255,0,0))
	else
		self.LabelJh_nowlv:setColor(cc.c3b(0,255,0))
	end
	self.LabelJh_nowlv:setString(nowjhlv)
	self.LabelJh_maxlv:setString("/"..maxlv)

	 --蓝色和绿色增加下图位置红色描述，同时 强化等级和精炼等级应该是：0/0
    self.BtnJh:removeAllChildren()
    if quality < 4 then 
    	maxlv = 0
    	--self.BtnJh
    	local label = display.newTTFLabel({
		    text = "("..res.str.EQUIPMENT_LOWER3JL..")",
		    size = 18,
		    font = self.LabelJh_nowlv:getFontName(),
		    align = cc.TEXT_ALIGNMENT_CENTER, -- 文字内部居中对齐
		    x = self.BtnJh:getContentSize().width/2,
		    y = -self.BtnJh:getContentSize().height/2,
		    color= COLOR[6]
		})
		label:addTo(self.BtnJh)
		self.LabelJh_nowlv:setColor(cc.c3b(0,255,0))
    end  

	local EquipmentQhID = conf.Item:getEquipmentJLId(data.mId,nowjhlv)
	local atk 
	local hp
	local power = conf.EquipmentJh:getPower(EquipmentQhID)

	local crit_hurt
	local mz 
	local defcri 
	local dodge
	local crit

	if part == 1 then 
		atk= conf.EquipmentJh:getAtk(EquipmentQhID)
		hp  = conf.EquipmentJh:getHp(EquipmentQhID)
		crit_hurt = conf.EquipmentJh:getCrithurt(EquipmentQhID)
	elseif part==2 then
		atk= conf.EquipmentJh:getAtk(EquipmentQhID)
		mz =  conf.EquipmentJh:getMz(EquipmentQhID)
	elseif part ==3 then
		--todo
		hp  = conf.EquipmentJh:getHp(EquipmentQhID)
		defcri = conf.EquipmentJh:getdefCrit(EquipmentQhID)
	elseif part == 4 then
		--todo
		atk= conf.EquipmentJh:getAtk(EquipmentQhID)
		hp  = conf.EquipmentJh:getHp(EquipmentQhID)
		crit_hurt = conf.EquipmentJh:getCrithurt(EquipmentQhID)
	elseif part ==5  then
		--todo
		hp  = conf.EquipmentJh:getHp(EquipmentQhID)
		dodge = conf.EquipmentJh:getDodge(EquipmentQhID)
	elseif part == 6 then
		--todo
		atk= conf.EquipmentJh:getAtk(EquipmentQhID)
		crit = conf.EquipmentJh:getCrit(EquipmentQhID)
	end 

	for i = 1 , 4 do 
		self["jl"..i]:setVisible(false)
	end 
	
	local bl=0
	local function _insetPro(lab,v )
		-- body
		local k = pos 
		if v  then 
			bl = bl +1 
			self["jl"..bl]:setVisible(true)
			self["jl"..bl].dec:setString(lab..":")
			self["jl"..bl].value:setString("+"..v)
		end
	end
	_insetPro(res.str.PRO_PROWER,power)--Õ½¶·Á¦
	_insetPro(res.str.PRO_GONGJI,atk) --¹¥»÷
	_insetPro(res.str.PRO_HP,hp)--ÉúÃü

	_insetPro(res.str.PRO_CRIT,crit)--±©»÷
	_insetPro(res.str.PRO_CRITHUT,crit_hurt)--PRO_CRITHUT
	_insetPro(res.str.PRO_MINGZHONG,mz)--PRO_MINGZHONG
	_insetPro(res.str.PRO_DECRIT,defcri)--¼áÈÍ
	_insetPro(res.str.PRO_DODGE,dodge)--¶º
	
	--[[self.LabelJh_hit:setString("+"..hp)
	self.LabelJh_atk:setString("+"..atk)]]--

	self:graybtn(self.BtnJh,true)
	if not  conf.EquipmentJh:isExist(EquipmentQhID+1)  then 
		--self:graybtn(self.BtnJh,false)
	end 

end
--Ìí¼ÓÐÇÐÇ
function EquipmentMessageView:addStar( num)
	self.Image_star:removeAllChildren()
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.Image_star:getContentSize().height
	local iconwidth=self.Image_star:getContentSize().width

	--local 
	local sprite=display.newSprite(starpath)
	local w = sprite:getContentSize().width*size
	local strposX = (iconwidth-w)/2 + sprite:getContentSize().width/2

	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setPosition(strposX+sprite:getContentSize().width*(i-1),iconheight/2)
		self.Image_star:addChild(sprite)
	end
end
--Ì××°
--ÊýÂëÊÞÊÇ·ñ´©´÷ÁË¸ÃÌ××°
function EquipmentMessageView:isSuitOnCard(mId)
	-- body
	if not self.data then return false end 

	local nowdata = self.data[self.NowSelectIndex]

	for k , v in pairs (nowdata) do 
		if v.mId == mId then 
			return true
		end 
	end 

	return false
end

function EquipmentMessageView:addItemList(data)
		for i,v in ipairs(self.ImageFrameWidget) do
			self.ImageFrameWidget[i]:removeFromParent()
		end

		for i,v in ipairs(self.ImagePropetyWidget) do
			self.ImagePropetyWidget[i]:removeFromParent()
		end
		self.ImageFrameWidget={}
		self.ImagePropetyWidget ={}
		--print("mid:"..data.mId)

		local suit_id= conf.Item:getItemSuitId(data.mId)
		local ItemList = {}
		local  suit_name  = {} 
		self.PanelProperty:setVisible(false)
		if suit_id then 
			self.PanelProperty:setVisible(true)
			ItemList = conf.Suit:getEquipmentIdList(suit_id)
			suit_name = conf.Suit:getEquipmentNameList(suit_id)
		end

		local starx = 30
		local stary = -100
		local imgh =0
		local offsetX = 50
		local offsetY = 20
		local offsetH=160
		-- Ò»ÐÐ·ÅµÄ×î´ó¸öÊý
		local c_size = 4
		local w=self.EquipmentWidget:getContentSize().width+offsetX
		local h=self.EquipmentWidget:getContentSize().height+offsetY

		local jihuocout = 0 --Ì××°´©´÷¸öÊý
		--×°±¸Í¼±ê
		for i=1,#ItemList do
			local property = self.PanelpropertyLabel:clone()
			local widget= EquipmentMessageWidget.new(self.cloneWidget)
			widget:showName(true)
			local _data={}
			_data.mId=ItemList[i]
			if self:isSuitOnCard(_data.mId) then 
				jihuocout  = jihuocout + 1 
				--_data.color = COLOR[conf.Item:getItemQuality(_data.mId)]
			else
				_data.color = cc.c3b(0xaf,0xac,0xac)
			end
			widget:setData(_data)


			widget:setPosition(starx+((i-1)%c_size)*w,stary-math.floor((i-1)/c_size)*h)
			imgh=math.floor((i-1)/c_size)*h
			self.PanelProperty:addChild(widget)
			self.ImageFrameWidget[#self.ImageFrameWidget+1]=widget

		end
		imgh=imgh+h
		--Ì××°Ð§¹û
		for i=1,#suit_name do
			local property = self.PanelpropertyLabel:clone()
			local suit_name_ = suit_name[i]

			if suit_name_ and suit_name_  ~= ""  then
				--print("suit_name_ = "..suit_name_)
				local _suit = property:getChildByName("Text_suit_value")
				local _eff = property:getChildByName("Text_suit_name")
				if i + 1 <= jihuocout then 
					_suit:setColor(cc.c3b(255,104,22))
					_eff:setColor(cc.c3b(255,104,22))
				else
					_suit:setColor(cc.c3b(0xaf,0xac,0xac))
					_eff:setColor(cc.c3b(0xaf,0xac,0xac))
				end 

				_suit:setString(suit_name_)
				_eff:setString((i+1)..res.str.EQUIPMENT_SUIT)

				property:setPosition(0,-imgh)
				self.PanelProperty:addChild(property)
				imgh=imgh+property:getContentSize().height
				self.ImagePropetyWidget[#self.ImagePropetyWidget+1] =property
			end
		end
		imgh=self.Img_h+imgh-50
		local imgw=self.Bg_PropertyImg:getContentSize().width
		self.Bg_PropertyImg:setContentSize(imgw,imgh)
		self.PanelProperty:setPosition(0,imgh)

		imgh=imgh+offsetH
		self.PanelJh:setPosition(0,imgh)
		imgh=imgh+offsetH
		self.PanelQh:setPosition(0,imgh)

		if imgh > self.ScollView:getContentSize().height then 
		 	self.ScollView:setInnerContainerSize(cc.size(640,imgh))
		else
			imgh = self.ScollView:getContentSize().height
		end 

		self.PanelQh:setPositionY(imgh+15)
		local size1 = self.PanelQh:getChildByName("Image_33"):getContentSize()
		self.PanelJh:setPositionY(imgh-size1.height+20)
		local size2 = self.PanelJh:getChildByName("Image_33_60"):getContentSize()
		self.PanelProperty:setPositionY(imgh-size1.height-size2.height+30)

end

--ÒòÎªÖ»ÄÜ²é¿´ËùÒÔ½ûÓÃÒ»Ð©°´Å¥
function EquipmentMessageView:setOnlySee( ... )
	-- body
	self.BtnRight:setVisible(false)
	self.BtnLift:setVisible(false)
	self.BtnChange:setVisible(false)
	self.BtnQh:setVisible(false)
	self.BtnJh:setVisible(false)
end

function EquipmentMessageView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return EquipmentMessageView