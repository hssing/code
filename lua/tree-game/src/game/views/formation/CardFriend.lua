--[[
	CardFriend 小伙伴
]]
local pet=require("game.things.PetUi")
local CardFriend = class("CardFriend",base.BaseView)

function CardFriend:ctor()
	-- body
	self.war_list = {} --上阵的位置
	self.friend_list = {} --小伙伴位置
end

function CardFriend:init()
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	G_FitScreen(self, "Image_1")

	self.top = self.view:getChildByName("Panel_1")
	self.lab_power = self.top:getChildByName("Text_8")
	self.lab_power:setString("")

	local btn = self.top:getChildByName("Button_1")
	btn:addTouchEventListener(handler(self,self.onbtnCloseView))

	self:initDec()
	--self:setData()
end

function CardFriend:initDec()
	-- body
	local panle = self.view:getChildByName("Panel_3")
	panle:getChildByName("Text_8_0"):setString(res.str.RES_GG_09)
	panle:getChildByName("Text_4_1_0_0"):setString(res.str.RES_GG_10)
	self.lab_qm = panle:getChildByName("Text_4_1_0")
	self.lab_qm:setString(0)

	self.war_list = {}
	self.friend_list = {}
	local openlv = conf.Sys:getValue("xhb_hole_lev")
	for i = 1 , 6 do 

		local item = panle:getChildByName("Panel_friend_"..i)
		item.frame = item:getChildByName("frame_"..i)
		item.frame.pos = i
		item.frame.data = nil 
		
		item.frame:addTouchEventListener(handler(self,self.onbtnFrameCall))
		item.spr = item.frame:getChildByName("spr_"..i)
		item.spr:ignoreContentAdaptWithSize(true)
		item.lv = item:getChildByName("name_"..i)
		item.lv:setString("")
		item.img_lv = item:getChildByName("Image_name_"..i)
		item.img_lv:setVisible(false)
		item.open_lv = item:getChildByName("name_"..i.."_0")

		--local conf_data = conf.Card:getCardFriend(i)
		if cache.Player:getLevel() >= checkint(openlv[i]) then
			item.open_lv:setString("")
			item.frame:setTouchEnabled(true)
		else
			item.frame:setTouchEnabled(false)
			item.open_lv:setString(string.format(res.str.RES_GG_11,checkint(openlv[i])))
		end

		item.name_img = item:getChildByName("Image_friend_"..i)
		item.name = item.name_img:getChildByName("lab_name_"..i)
		item.name:setString("")
		item.name_img:setVisible(false)
		item._7s = item.frame:getChildByName("spr_"..i.."_0")
		item._7s:ignoreContentAdaptWithSize(true)
		item._7s:setVisible(false)

		self.friend_list[i] = item

		local widget = panle:getChildByName("Panel_7_0"..i)
		widget.im_qm = widget:getChildByName("Image_"..i.."_1")
		widget.count = widget.im_qm:getChildByName("Text_"..i.."_1")
		widget.count:setString(0)
		widget.im_qm:setVisible(false)

		widget.img_name = widget:getChildByName("Image_"..i.."_2")
		widget.name = widget.img_name:getChildByName("Text_"..i.."_2")
		widget.name:setString("")
		widget.name:setColor(COLOR[1])
		widget.img_name:setVisible(false)

		widget.tai = widget:getChildByName("Image_"..i.."_3")
		widget._7s = widget:getChildByName("Image_"..i.."_3_0")
		widget._7s:ignoreContentAdaptWithSize(true)
		widget._7s:setVisible(false)
		self.war_list[i] = widget
	end
end
--激活了那些亲密 的飘字
function CardFriend:palywenzi(data)
	-- body
	local type_id = conf.Item:getItemConf(data.mId).type_id
	local height = 0
	local img_list = {}
	for i , j in pairs(self.BattleData) do 
		local confdata =  conf.Item:getItemConf(j.mId)
		local Intimacy_id = conf.Item:getIntimacyID(confdata.type_id) 
		if Intimacy_id then
			local card_id = conf.CardIntimacy:getIntimacy(Intimacy_id)
			if card_id then
				
				for k ,v in pairs(card_id.effect_ids) do 
					if checkint(type_id)  == v then --如果激活了
						local spr = display.newSprite(res.other.TISHI)
						local _img = display.newScale9Sprite(res.other.TISHI,display.cx,display.cy
       					 ,cc.size(500, 40),spr:getContentSize())
						_img:setPosition(display.cx,display.cy)
						_img:addTo(self.view)

						local richText = ccui.RichText:create()

						richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,192,0),255,
   						"["..conf.Item:getName(j.mId).."]",res.ttf[1],30)) --名字

   						richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,
   						res.str.RES_GG_14,res.ttf[1],30)) --的亲密

   						richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,192,0),255,
   						"["..card_id.effect_names[k].."]",res.ttf[1],30)) --亲密的名字

   						richText:pushBackElement(ccui.RichElementText:create(1,cc.c3b(255,255,255),255,
   						res.str.RES_GG_15,res.ttf[1],30)) --激活

   						richText:formatText()
		   				richText:setAnchorPoint(cc.p(0.5,0.5))
		   				richText:setPosition(250,20)
		   				richText:addTo(_img)

		   				table.insert(img_list,_img)
					end
				end
			end
		end
	end
	--适配居中
	local height = 50 --间隔
	for k , v in pairs(img_list) do 
		if k == 2 then
			v:setPositionY(v:getPositionY()+height)
		elseif k == 3  then
			v:setPositionY(v:getPositionY()-height)
		elseif k == 4 then
			v:setPositionY(v:getPositionY()+2*height)
		elseif k == 5 then
			v:setPositionY(v:getPositionY()-2*height)
		elseif k == 6 then
			v:setPositionY(v:getPositionY()+3*height)
		end
	end

	for k, v in pairs(img_list) do 
		local a1 = cc.Spawn:create(cc.FadeIn:create(0.5),cc.MoveBy:create(1.0,cc.p(0,100)))
		local a2 = cc.DelayTime:create(0.5)
		local a3 = cc.CallFunc:create(function( ... )
			-- body
			v:removeSelf()
		end)
		local sequence = cc.Sequence:create(a1,a2,a3)

		v:runAction(sequence)
	end
end

--上，下 之后刷新
function CardFriend:updateInfo(data_,index)
	-- body
	local data  = cache.Pack:getTypePackInfo(pack_type.SPRITE)
	self.Battle_Friend = {}
	local spr_data
	for k,v in pairs(data) do
		if v.propertys[317] and v.propertys[317].value > 0 then 
			if #self.Battle_Friend < 6 then 
				table.insert(self.Battle_Friend,v) --所有小伙伴
			else
				break
			end
			if v.index == index then
				spr_data = v  --这个是刚上阵小伙伴
			end
		end
	end

	if spr_data then
		--激活的亲密字
		print("index"..index)
		self:palywenzi(spr_data) 
	end

	self:updateQMcount() --刷新亲密
	self:setFrienddata() --刷新小伙伴
	self.lab_power:setString(G_FormatPower(cache.Player:getPower())) --重新设置战力
end
--遍历刷新亲密数量
function CardFriend:updateQMcount()
	-- body
	local all_count = 0
	for k ,v in pairs(self.war_list) do 
		if v.mId then 
			local count = G_CountQM(v.mId)
			all_count = all_count + count
			v.count:setString(count)
			v.im_qm:setVisible(true)
		end
	end
	self.lab_qm:setString(all_count)
end
--获取上阵的数码兽
function CardFriend:setbattonwar()
	-- body
	for k ,v in pairs(self.BattleData) do 
		local topos = v.propertys[309] and v.propertys[309].value or 1
		local widget = self.war_list[topos]
		widget.mId = v.mId
		widget.img_name:setVisible(true)

		widget.name:setString(conf.Item:getName(v.mId,v.propertys))
		widget.name:setColor(COLOR[conf.Item:getItemQuality(v.mId)])

		local node=pet.new(v.mId,v.propertys)
		node.node:setScale(res.card.petdetail)
		node:setAnchorPoint(cc.p(0.5,0))
		node:setPosition(widget.tai:getContentSize().width/2,
			widget.tai:getContentSize().height/2 - node:getContentSize().height*res.card.petdetail/2 )
		node:addTo(widget.tai)

		local conf_data = conf.Item:getItemConf(v.mId)
		if checkint(conf_data.zhuan)>0 then
			widget._7s:setVisible(true)
			widget._7s:loadTexture(res.icon.ZHUAN[conf_data.zhuan])
		end
	end
	self:updateQMcount()
end

--一闪一闪的动画
function CardFriend:_runBilk( lab,tiem )
	-- body
	local a1 = cc.FadeOut:create(tiem)
	local a2 = cc.FadeIn:create(tiem)
	local a3 = cc.DelayTime:create(tiem)
	local sequence = cc.Sequence:create(a1,a2)
	lab:runAction(cc.RepeatForever:create(sequence))	
end
--
function CardFriend:setFrienddata()
	-- body
	--清除数据
	for k , item in pairs(self.friend_list) do 
		item.frame.data = nil 
		item.frame:loadTexture(res.btn.FRAME[1])
		item.spr:setVisible(false)
		item.lv:setString("")
		item.img_lv:setVisible(false)
		item.name:setString("")
		item.name_img:setVisible(false)
		item._7s:setVisible(false)
		if item.jia and not tolua.isnull(item.jia) then 
			item.jia:removeSelf()
			item.jia = nil 
		end
	end
	--设置小伙伴
	for k,v in pairs(self.Battle_Friend) do
		local topos = v.propertys[317] and v.propertys[317].value or 1
		local widget = self.friend_list[topos]

		widget.frame.data = v 
		local colorlv = conf.Item:getItemQuality(v.mId)
		widget.frame:loadTexture(res.btn.FRAME[colorlv])
		widget.spr:setVisible(true)
		widget.spr:ignoreContentAdaptWithSize(true)
		widget.spr:loadTexture(conf.Item:getItemSrcbymid(v.mId,v.propertys))
		widget.img_lv:setVisible(true)
		widget.lv:setString(v.propertys[304] and v.propertys[304].value or 1)

		widget.name_img:setVisible(true)
		widget.name:setString(conf.Item:getName(v.mId))
		widget.name:setColor(COLOR[colorlv])

		local conf_data = conf.Item:getItemConf(v.mId)
		if checkint(conf_data.zhuan)>0 then
			widget._7s:setVisible(true)
			widget._7s:loadTexture(res.icon.ZHUANFRAME[conf_data.zhuan])
		end
	end
	--看看那些空的 是否给个加号
	if G_CheckFriend() then --是否有小伙伴可以激活亲密
		for k , item in pairs(self.friend_list) do
			if item.frame.data == nil and item.open_lv:getString() == "" then
				item.jia = display.newSprite(res.other.JIAHAO)
				item.jia:setPositionX(item.frame:getContentSize().width/2)
				item.jia:setPositionY(item.frame:getContentSize().height/2)
				item.jia:addTo(item.frame)

				self:_runBilk(item.jia,0.5)
			end
		end				
	end	
end

function CardFriend:setData()
	-- body
	--设置战力
	self.BattleData = {}
	self.Battle_Friend = {}
	local data  = cache.Pack:getTypePackInfo(pack_type.SPRITE)
	for k,v in pairs(data) do
		if conf.Item:getBattleProperty(v) > 0 then
			if #self.BattleData < 6 then 
				table.insert(self.BattleData,v) --所有上阵的人
			end
		end

		if v.propertys[317] and v.propertys[317].value > 0 then 
			if #self.Battle_Friend < 6 then 
				table.insert(self.Battle_Friend,v) --所有小伙伴
			end
		end
	end


	self.lab_power:setString(G_FormatPower(cache.Player:getPower()))
	self:setbattonwar() --设置阵型数码兽
	self:setFrienddata() --小伙伴
end

function CardFriend:setDataOther()
	-- body
	for k , item in pairs(self.friend_list) do
		item.frame.data = nil 
		item.frame:setTouchEnabled(false)
	end
end


function CardFriend:onbtnFrameCall( sender,eventtype )
	-- body
	if  eventtype == ccui.TouchEventType.ended then
       	if sender.data then --有数码兽的时候
       		local data = {}
       		table.insert(data,sender.data)
       		local view=mgr.ViewMgr:createView(_viewname.PETDETAIL)
       		view:setData(data)
       		view:setFrienddata()
       		view:selectUpdate(1)
   			mgr.ViewMgr:showView(_viewname.PETDETAIL)
       	else
       		local view = mgr.ViewMgr:showView(_viewname.CRADFRIEND_LIAS)
       		view:setPos(sender.pos)
       	end
	end
end

function CardFriend:onbtnCloseView( sender,eventtype )
	-- body
	if  eventtype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
	end
end

function CardFriend:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CardFriend
