--OTHER_VIEW
--[[
	FormationOtherView 查看别人的阵容信息
]]
local pet= require("game.things.PetUi")


local FormationOtherView=class("FormationOtherView",base.BaseView)

local EquipmentName={
	res.str.EQUIPMENT_NAME_TOU,
	res.str.EQUIPMENT_NAME_WUQI,
	res.str.EQUIPMENT_NAME_YIFU,
	res.str.EQUIPMENT_NAME_PIFENG,
	res.str.EQUIPMENT_NAME_KUZI,
	res.str.EQUIPMENT_NAME_TUTENG,
}

function FormationOtherView:ctor( ... )
	-- body
end

function FormationOtherView:init(  )
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.view:getChildByName("Image_bg"):setTouchEnabled(true)
	G_FitScreen(self,"Image_bg")
	self.bg = self.view:getChildByName("Image_bg_0")
	local toppanle = self.view:getChildByName("Panel_up")
	self.top = toppanle
	local btnclose = toppanle:getChildByName("Button_1")
	btnclose:addTouchEventListener(handler(self,self.onBtnCloseView))
	--数码兽列表
	self.listlv = toppanle:getChildByName("ListView_1")
	self.clone_card = self.view:getChildByName("Panel_clone")
	--别人的名字
	self.lab_other_name = toppanle:getChildByName("Text_4")

	---查看符文
	local downpanle = self.view:getChildByName("Panel_down")
	local btnfw = downpanle:getChildByName("Button_z")
	self.btnfw = btnfw
	btnfw:addTouchEventListener(handler(self,self.onbtnSeeFW))
	--属性
	self.panel_pro = downpanle:getChildByName("Panel_shux")
	self.lab_power = self.panel_pro:getChildByName("Image_bg_title_0"):getChildByName("Text_48")
	self.lab_atk = self.panel_pro:getChildByName("Panel_35"):getChildByName("Text_33_0") 
	self.lab_hp = self.panel_pro:getChildByName("Panel_35_0"):getChildByName("Text_33_0_41")
	--亲密
	self.IntimacyList={}
	local lab_1 = self.panel_pro:getChildByName("Text_49")
	table.insert(self.IntimacyList,lab_1)
	local lab_2 = self.panel_pro:getChildByName("Text_49_0")
	table.insert(self.IntimacyList,lab_2)
	local lab_3 = self.panel_pro:getChildByName("Text_49_1")
	table.insert(self.IntimacyList,lab_3)
	local lab_4 = self.panel_pro:getChildByName("Text_49_0_0")
	table.insert(self.IntimacyList,lab_4)
	local lab_5 = self.panel_pro:getChildByName("Text_49_0_1")
	table.insert(self.IntimacyList,lab_5)
	--
	self.clone_equip = self.view:getChildByName("Panel_Helmet")
	self.equip_panle = self.view:getChildByName("Panel_equip")
	
	--
	self.title_panle = self.view:getChildByName("Panel_title")
	self.pv = self.view:getChildByName("PageView_1")
	--
	self.panle_fw = self.view:getChildByName("Panel_17")
	local btn = self.panle_fw:getChildByName("Panel_up_0"):getChildByName("Button_1_2_16")
	btn:addTouchEventListener(handler(self, self.onbtnSeeFW))
	self.panle_fw:setVisible(false)

	self:initDec()
	self:forever()
	self:initEquip()
	self:initRune()

	self.page = 1
	self:setSee()
end


function FormationOtherView:forever( ... )
	-- body
	local armature = mgr.BoneLoad:loadArmature(404826,4)
    armature:setPosition(display.cx,display.cy)
    armature:addTo(self.bg)
end

function FormationOtherView:initDec()
	-- body
	self.lab_other_name:setString("")
	self.btnfw:setTitleText(res.str.DEC_NEW_01)
	self.lab_power:setString("")
	self.lab_atk:setString("")
	self.lab_hp:setString("")
	self.panel_pro:getChildByName("Panel_35"):getChildByName("Text_39"):setString(res.str.DEC_NEW_03[102])
	self.panel_pro:getChildByName("Panel_35_0"):getChildByName("Text_39_43"):setString(res.str.DEC_NEW_03[105])
	for k, v in pairs(self.IntimacyList) do 
		v:setString("")
	end

	self.card_lv = self.title_panle:getChildByName("Image_4"):getChildByName("Text_lv_12")
	self.card_lv:setString("")

	self.card_name = self.title_panle:getChildByName("Image_4"):getChildByName("Text_name")
	self.card_name:setString("")

	self.panel_start = self.title_panle:getChildByName("Panel_1")
	self.img_zhuan = self.title_panle:getChildByName("Image_13")
end

function FormationOtherView:setRuneItem(i,v)
	-- body
	local t = self.runelist[i]
	if not t then 
		return 
	end
	t.widget:removeAllChildren()
	t.name:setString("")
	t.lv:setString("")
	t.lv_di:setVisible(false)
	if v then
		t.lv_di:setVisible(true)
		local spr = display.newSprite(conf.Item:getItemSrcbymid(v.mId)) 
		spr:setScale(0.8)
		spr:setPositionX(t.widget:getContentSize().width/2)
		spr:setPositionY(t.widget:getContentSize().height/2)
		spr:addTo(t.widget)


		t.name:setString(conf.Item:getName(v.mId))
		local colorlv = conf.Item:getItemQuality(v.mId)
		t.name:setColor(COLOR[colorlv])

		local lv = v.propertys[303] and v.propertys[303].value or 0
		t.lv:setString(lv)
	end

end

function FormationOtherView:initRune()
	-- body
	self.runelist = {}
	for i = 1 , 6 do 
		local widget = self.panle_fw:getChildByName("Image_10"):getChildByName("Image_1_"..i)
		local lab = self.panle_fw:getChildByName("Image_10"):getChildByName("Text_1_"..i)
		local lv_di = self.panle_fw:getChildByName("Image_10"):getChildByName("Image_9_"..i)
		local lv = lv_di:getChildByName("Text_3_"..i)
		local t = {}
		t.widget = widget
		t.name = lab
		t.lv = lv 
		t.lv_di = lv_di
		table.insert(self.runelist,t)
	end
	for k ,v in pairs(self.runelist) do 
		self:setRuneItem(k,nil)
	end 
end

--设置每个装备信息
function FormationOtherView:setItemData(i,v)
	-- body
	local widget = self.equite_list[i]
	if not widget then
		return 
	end
	local colorlv = 1
	local name = ""
	local lv = ""
	if v then 
		widget.spr:loadTexture(conf.Item:getItemSrcbymid(v.mId))
		widget.spr:setVisible(true)

		colorlv = conf.Item:getItemQuality(v.mId)
		widget.btnframe:loadTextureNormal(res.btn.FRAME[colorlv])

		name = conf.Item:getName(v.mId,v.propertys)
		widget.name:setColor(COLOR[colorlv])
		widget.name:setString(name)

		lv = v.propertys[303] and v.propertys[303].value or 0
		widget.lv:setString(lv)
		widget.lv:getParent():setVisible(true)
	else
		widget.spr:setVisible(false)
		widget.btnframe:loadTextureNormal(res.btn.FRAME[colorlv])
		widget.name:setString(name)
		widget.lv:setString(lv)
		widget.lv:getParent():setVisible(false)
	end
end

--设定6个位置装备狂 的位置
function FormationOtherView:initEquip()
	-- body
	self.equite_list = {}
	local height = self.equip_panle:getContentSize().height
	local width = self.equip_panle:getContentSize().width
	for i = 1 , 6 do 
		local item = self.clone_equip:clone()
		local x = 0
		if i%2 == 0 then
			x = width - item:getContentSize().width*1.5
		else
			x = item:getContentSize().width/2
		end
		item:setPositionX(x)
		local j = 3-math.ceil(i/2)
		local y =j*height/3 + height/6 - 20
		item:setPositionY(y)
		item:addTo(self.equip_panle)

		item.btnframe = item:getChildByName("Button_66")
		
		item.btnframe:setTitleText(EquipmentName[i])

		item.spr = item:getChildByName("Image_24")
		item.spr:ignoreContentAdaptWithSize(true)
		item.name = item:getChildByName("Text_1")
		item.lv = item:getChildByName("Image_lv"):getChildByName("Text_lv_13")
		item.lv:setString("")
		
		table.insert(self.equite_list,item)
	end

	for k ,v in pairs(self.equite_list) do 
		self:setItemData(k,nil)
	end
end

function FormationOtherView:addStar( amount )
	self.panel_start:removeAllChildren()
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.panel_start:getContentSize().height
	local iconwidth=self.panel_start:getContentSize().width
	local sprite=display.newSprite(starpath)
	local spr_width=sprite:getContentSize().width
	local starx=(iconwidth-spr_width*amount)/2
	for i=1,amount do
		sprite=display.newSprite(starpath)
		sprite:setPosition(starx-10+spr_width*i,iconheight/2)
		self.panel_start:addChild(sprite)
	end
end

function FormationOtherView:updateInfo(data)
	-- body
	self.showdata = data
	local lv = data.propertys[304] and data.propertys[304].value or 1
	local Quality=conf.Item:getItemQuality(data.mId)
	local name=conf.Item:getName(data.mId,data.propertys)

	self.card_lv:setString(lv)
	self.card_name:setString(name)
	self.card_name:setColor(COLOR[Quality])
	self.img_zhuan:setVisible(false)
	local conf_data = conf.Item:getItemConf(data.mId)

	self.panel_start = self.title_panle:getChildByName("Panel_1")
	self.img_zhuan = self.title_panle:getChildByName("Image_13")
	if conf_data.zhuan then
		self.img_zhuan:setVisible(true)
		self.img_zhuan:ignoreContentAdaptWithSize(true)
		self.img_zhuan:loadTexture(res.icon.ZHUAN[conf_data.zhuan])
	end
	self:addStar(Quality)
	--设置属性
	self.lab_power:setString(data.propertys[305] and data.propertys[305].value or 0)
	self.lab_atk:setString(data.propertys[102] and data.propertys[102].value or 0)
	self.lab_hp:setString(data.propertys[105] and data.propertys[105].value or 0)
	--设置亲密
	for k ,v in pairs(self.IntimacyList) do 
		v:setString("")
	end 

	local Intimacy_id=conf.Item:getIntimacyID(data.mId)
	if Intimacy_id then
		local listname = conf.CardIntimacy:getSkillName(Intimacy_id)
		local listid = conf.CardIntimacy:getPetList(Intimacy_id)
		for j=1,#listid do
			self.IntimacyList[j]:setColor(cc.c3b(0xaf,0xac,0xac))
			--[[for i=1,#self.card_data do
				self.IntimacyList[j]:setColor(cc.c3b(0xaf,0xac,0xac))
				if self.card_data[i].mId == listid[j] then
					self.IntimacyList[j]:setColor(cc.c3b(255,104,22))
					break;
				end
			end]]--
			printt(self.huoban)
			local flag = false
			for k , v in pairs(self.card_data) do 
				local type_id = conf.Item:getItemConf(v.mId).type_id
				if type_id == listid[j] then
					flag = true
					break
				end
			end

			if not flag then
				for k, v in pairs(self.huoban or {}) do 
					local type_id = conf.Item:getItemConf(v.mId).type_id
					if type_id == listid[j] then
						flag = true
						break
					end
				end
			end

			if flag then
				self.IntimacyList[j]:setColor(cc.c3b(255,104,22))
			end

			self.IntimacyList[j]:setString(listname[j])
		end

	else
		self.IntimacyList[5]:setString(res.str.DEC_NEW_45)
	end 
end

function FormationOtherView:pageTurn()
	-- body
	local page = self.pv:getCurPageIndex()
	if self.oldpage and page == self.oldpage  then 
		return 
	end
	self.oldpage = page

	local widget = self.btnlist[page+1]
	if widget then
		if self.imgchoose and not tolua.isnull(self.imgchoose) then
			self.imgchoose:removeSelf()
			self.imgchoose = nil 
		end

		local size = widget:getContentSize()
		local armature = mgr.BoneLoad:loadArmature(404835,0)
	    armature:setPosition(size.width/2,size.height/2)
	    armature:addTo(widget)
	    self.imgchoose = armature
	end

   
	--
	local data = self.card_data[page+1]
	if data then
		self:updateInfo(data)
		debugprint("发送一下详细信息")
		--printt(data.propertys)
		local pos = data.propertys[308] and data.propertys[308].value or 0
		if pos == 0 then 
			return 
		end
		if self.iskf then 
			local param = {fIndex = pos,roleId = self.data.roleId,reqType = self.iskf }
			proxy.Cross:send_123012(param)
		else
			local param = {fIndex = pos,roleId = self.data.roleId,reqType =self.data.reqType }
			proxy.card:send_101202(param)
		end
	end
end


function FormationOtherView:initListView()
	-- body
	self.pv:removeAllPages()
	self.listlv:removeAllItems()
	self.btnlist = {}
	for k ,v in pairs(self.card_data) do 
		local item = self.clone_card:clone()
		local btnframe = item:getChildByName("Button")
		local spr = btnframe:getChildByName("Image")
		local colorlv = conf.Item:getItemQuality(v.mId)
		btnframe:loadTextureNormal(res.btn.FRAME[colorlv])
		btnframe.page = k -1
		spr:loadTexture(conf.Item:getItemSrcbymid(v.mId,v.propertys))
		spr:ignoreContentAdaptWithSize(true)
		btnframe:addTouchEventListener(handler(self,self.onbtnSroTo))
		table.insert(self.btnlist,btnframe)
		self.listlv:pushBackCustomItem(item)


		local layout = ccui.Layout:create()
		layout:setContentSize(self.pv:getContentSize())

		local pet_node = pet.new(v.mId,v.propertys)

		pet_node:setAnchorPoint(cc.p(0.5,0))
		pet_node:addTo(layout)
		pet_node:setPosition(layout:getContentSize().width/2,0)
		self.pv:addPage(layout)
	end
	self.pv:addEventListener(handler(self, self.pageTurn))
end

function FormationOtherView:setData(data_,flag)
	-- body
	self.iskf = flag
	self.data = data_
	--printt(self.data)
	self.card_data = {}
	self.huoban = {}
	for k ,v in pairs(data_.tarCards) do 
		if v.propertys[308] and v.propertys[308].value > 0 then
			table.insert(self.card_data,v)
		end

		if v.propertys[317] and v.propertys[317].value > 0 then
			table.insert(self.huoban,v)
		end
	end
	--self.card_data = data_.tarCards
	--self.huoban = data_.huoban

	if #self.huoban == 0 then
		local namestr = string.split(data_.tarName, ".")
		local str = ""
		--if self.data.roleId and self.data.roleId.key == cache.Player:getRoleInfo().roleId.key then  --如果是自己
		if #namestr == 2 then
			str =namestr[2]
		else
			str = namestr[1]
		end
		if str~="" and str == cache.Player:getName() then
			local dataCard = cache.Pack:getTypePackInfo(pack_type.SPRITE)
			for k ,v in pairs(dataCard) do 
				if v.propertys[317] and v.propertys[317].value > 0 then
					table.insert(self.huoban,v)
				end
			end
		end 
	end

	self.lab_other_name:setString(data_.tarName)
	self:initListView(data_.tarCards)
end

function FormationOtherView:setServerBack( data )
	-- body
	data.cardInfo.propertys = vector2table(data.cardInfo.propertys, "type")
	self:updateInfo(data.cardInfo)

	for k ,v in pairs(self.equite_list) do 
		self:setItemData(k,nil)
	end
	for k ,v in pairs(data.equipInfos) do 
		v.propertys = vector2table(v.propertys, "type")
		local part = conf.Item:getItemPart(v.mId)
		self:setItemData(part,v)
	end

	for k ,v in pairs(self.runelist) do 
		self:setRuneItem(k,nil)
	end 
	for k ,v in pairs(data.fwInfos) do 
		--v:setRuneItem(k,nil)
		v.propertys = vector2table(v.propertys, "type")
		local part = tonumber(string.sub(v.index,-1,-1))
		self:setRuneItem(part,v)
	end 
end

function FormationOtherView:setChoose(index)
	-- body
	for k ,v in pairs(self.card_data) do 
		if v.index == index then 
			self:onbtnSroTo(self.btnlist[k] or self.btnlist[1],ccui.TouchEventType.ended)
			return 
		end 
	end
end


function FormationOtherView:setSee()
	-- body
	if self.page == 1 then
		self.top:setVisible(true)
		self.pv:setVisible(true)
		self.panle_fw:setVisible(false)
		for k ,v in pairs(self.equite_list) do 
			v:setVisible(true)
		end
		self.btnfw:setTitleText(res.str.DUI_DEC_09)
	else
		self.top:setVisible(false)
		self.pv:setVisible(false)
		self.panle_fw:setVisible(true)
		for k ,v in pairs(self.equite_list) do 
			v:setVisible(false)
		end
		self.btnfw:setTitleText(res.str.EQUIPMENT_DEC15)
	end
end

function FormationOtherView:onbtnSroTo(sender_, eventtype )
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--滚动
		local page = sender_.page
		if page then
			self.pv:scrollToPage(page)
		end
	end
end

function FormationOtherView:onbtnSeeFW(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		--查看符文
		if self.page ==1 then
			self.page = 2 
		else
			self.page = 1
		end
		self:setSee()
	end
end

function FormationOtherView:onBtnCloseView(sender_, eventtype)
	-- body
	if eventtype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function FormationOtherView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return FormationOtherView