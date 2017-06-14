local ProMessageView=class("ProMessageView",base.BaseView)


function ProMessageView:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local bg = self.view:getChildByName("Image_bg")
    bg:addTouchEventListener(handler(self, self.onbgclose))

    self.Panel_clone_0 = self.view:getChildByName("Panel_clone_0")
	self.ListView=self.view:getChildByName("ListView")
	self.PanelItem=self.view:getChildByName("Panel_item")
	self.PanelAttribute=self.PanelItem:getChildByName("Panel_1")
	self.BtnFrame=self.PanelItem:getChildByName("btn")
	self.IconStar=self.PanelItem:getChildByName("Panel_star")
	self.LabName=self.PanelItem:getChildByName("Text_item_name")
	self.dec = self.view:getChildByName("Text_1")
	self.spr=self.PanelItem:getChildByName("Image_2")

	self.inbg=self.view:getChildByName("Image_1")
	
	
	G_FitScreen(self,"Image_bg")
	
end

function ProMessageView:onbtnGoto( sender,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		local data = sender.data
		print("支持跳转")
		--printt(data)
		if  data then --如果支持跳转就
			if self.stype == pack_type.MATERIAL then
				if "COPY_CHAPTER" == data[1] then
					if not sender.isOpen then
						G_TipsOfstr(res.str.FRUIT_DESC16)
						return
					end

					local newData = {}
					newData.index = data[4]--关卡
					newData.fromView = self
					newData.level = data[2]--模式
					newData.chapter = data[3]--章节
					debugprint("==============onbtnGoto =跳转副本====================")
					--printt(newData)
					G_GotoChapter(newData)
				end
			else
				local view = mgr.ViewMgr:get(_viewname.FUBEN_DAY_REWARD)
				if view then
					view:onCloseSelfView()
				end 

				local view = mgr.ViewMgr:get(_viewname.FUBEN_DAY)
				if view then
					view:closeSelfView()
				end 

				local view = mgr.ViewMgr:get(_viewname.PACK)
				if view then
					view:closeSelfView()
				end 

				G_GoToView(data)
				self:onCloseSelfView()
				return 
			end
			
		end 
	end 
end

function ProMessageView:setGotoView( id  )
	-- body
	local getfromView = conf.Item:FromView(id)
	local stype=conf.Item:getType(id)
	if getfromView then 
		for k ,v in pairs(getfromView) do 
			local widget = self.Panel_clone_0:clone()
			local name = widget:getChildByName("Text_title_5") --
			local describe = widget:getChildByName("Text_7") --
			local img = widget:getChildByName("Image_15_8")
			local modeLab = widget:getChildByName("Text_2")--副本模式
			
			local goto = widget:getChildByName("Button_1") 
			goto:setTouchEnabled(false)
			
			widget:setTouchEnabled(true )
			widget.data = v
			widget:addTouchEventListener(handler(self, self.onbtnGoto))

			if stype == pack_type.MATERIAL  then--果实材料
				modeLab:setVisible(true)
				local mode = conf.Item:getJumpMode(id)
				modeLab:setString(mode[k])
				local nameFont = conf.Item:getJumpFont(id)
				local desc = conf.Item:getItemjumpDesc(id)
				describe:setString(desc[k][1])
				name:setString(nameFont[k])
				--local src = "res/views/ui_res/imagefont/%s.png"
				--img:loadTexture(string.format(src, conf.Item:getJumpFont(id)))
				self.stype = stype

				--判读章节是否开启
				self._curHardLevel = v[2]--章节模式
				local max
			    if self._curHardLevel == 2 then
			        max = cache.Copy:getBaseFbMax()
			        self.chapter = math.floor((max%200000)/100)
			    elseif self._curHardLevel == 3 then
			        max = cache.Copy:getSuperFbMax()
			        self.chapter = math.floor((max%300000)/100)
			    elseif self._curHardLevel == 7 then
			        max = cache.Copy:getEmengFbMax()
			        self.chapter = math.floor((max%700000)/100)
			    end 



			    widget.isOpen = true--标记关卡是否开启

			    local lv = cache.Player:getLevel()
			    if  tonumber(v[2]) ==  3 and lv < 40 then
			    	 widget.isOpen = false
			    	 --G_TipsOfstr(string.format(res.str.COPY_DESC14, 40))
			    elseif tonumber(v[2]) == 7 and lv < 60 then
			    	 widget.isOpen = false
			    	--G_TipsOfstr(string.format(res.str.COPY_DESC20, 60))
			    end

			   self.chapterIdx = max % 100
			   if self.chapter < v[3] then
			   	 widget.isOpen = false
			   elseif self.chapter == v[3] and self.chapterIdx < v[4] then
				   	 widget.isOpen = false
		
			   end 

			   print(v[3],v[4],"==========")
			   print( self.chapter, self.chapterIdx)

			  
			else
				local t 
				if type(v[#v]) == "table" and  type(v[#v][1]) == "table" then 

					t = conf.Role:getSysOpne(v[#v][1][1],v[#v][1][2])
				else
					t = conf.Role:getSysOpne(v[1],v[2])
				end 

				
				if t then 
					name:setString(t.buy_tl)
					describe:setString(t.dec)
				else
					debugprint("在人物升级提示开启 里面没有....")
				end 
			end
			

			img:setVisible(false)
			self.ListView:pushBackCustomItem(widget)
		end 
	else
		--self.inbg:setContentSize(self.inbg:getContentSize().width,
		--	self.inbg:getContentSize().height - self.ListView:getContentSize().height)
	end 
end

function ProMessageView:onbgclose(sender,eventype  )
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end 
end

--设置属性
function ProMessageView:setPro( Part,propertys,localflag )
	-- body
	local atk = 0
	local hp = 0
    --暴击
	local cri = 0
	--暴击伤害
	local crihurt = 0
	--抗暴
	local defcri = 0 
	--闪避
	local dodge = 0
	--命中
	local hit = 0
	if localflag then 
		if Part == 1 then 
			atk = conf.Item:getLocalEquipAtt(self.data.mId)
			hp = conf.Item:getLocalEquipHp(self.data.mId)
			crihurt = conf.Item:getLocalEquipCrithurt(self.data.mId)
		elseif Part == 2 then 
			atk = conf.Item:getLocalEquipAtt(self.data.mId)
			hit = conf.Item:getLocalEquipAtt(self.data.mId)
		elseif Part == 3  then 
			hp = conf.Item:getLocalEquipHp(self.data.mId)
			defcri = conf.Item:getLocalEquipdefmingzhong(self.data.mId)
		elseif Part == 4 then
			atk = conf.Item:getLocalEquipAtt(self.data.mId)
			hp =conf.Item:getLocalEquipHp(self.data.mId)
			crihurt =conf.Item:getLocalEquipCrithurt(self.data.mId)
		elseif  Part == 5 then 
			hp = conf.Item:getLocalEquipHp(self.data.mId)
			dodge = conf.Item:getLocalEquipdshanbi(self.data.mId)
		elseif  Part == 6 then 
			atk =conf.Item:getLocalEquipAtt(self.data.mId)
			cri = conf.Item:getLocalEquipCrit(self.data.mId)
		else
			local cardid = conf.Item:getCardId(self.data.mId,1)
			atk = conf.Card:getAtt(cardid)
			hp = conf.Card:getHp(cardid)
		end	
	else
		--todo
		if Part == 1 then 
			atk = mgr.ConfMgr.getItemAtK(propertys)
			hp = mgr.ConfMgr.getItemHp(propertys)
			crihurt = mgr.ConfMgr.getCritSh(propertys)
		elseif Part == 2 then 
			atk = mgr.ConfMgr.getItemAtK(propertys)
			hit = mgr.ConfMgr.getHit(propertys)
		elseif Part == 3  then 
			hp = mgr.ConfMgr.getItemHp(propertys)
			defcri = mgr.ConfMgr.getResistantCrit(propertys)
		elseif Part == 4 then
			atk = mgr.ConfMgr.getItemAtK(propertys)
			hp = mgr.ConfMgr.getItemHp(propertys)
			crihurt = mgr.ConfMgr.getCritSh(propertys)
		elseif  Part == 5 then 
			hp = mgr.ConfMgr.getItemHp(propertys)
			dodge = mgr.ConfMgr.getDodge(propertys)
		elseif  Part == 6 then 
			atk = mgr.ConfMgr.getItemAtK(propertys)
			cri = mgr.ConfMgr.getCrit(propertys)
		else
			atk = mgr.ConfMgr.getItemAtK(propertys)
			hp = mgr.ConfMgr.getItemHp(propertys)
		end	
	end

	

	local bl=0
	local function _insetPro(png,v )
		-- body
		local k = pos 
		if v and  v > 0 then 
			bl = bl +1 
			local dec = self.PanelAttribute:getChildByName("Image__"..bl)
			dec:setVisible(true)
			dec:loadTexture(png)

			local value = dec:getChildByName("Text_32_"..bl)
			value:setString(v)

			local w =  dec:getContentSize().width  
			value:setPositionX(w+5)
			
		end
	end

	_insetPro(res.font.ATK,atk)
	_insetPro(res.font.HP,hp)
	_insetPro(res.font.CRIT,cri)
	_insetPro(res.font.CRIT_SH,crihurt)
	_insetPro(res.font.JR,defcri)
	_insetPro(res.font.MZ,hit)
	_insetPro(res.font.SB,dodge)
end

function ProMessageView:setDscribe( shuom )
	-- body
	self.dec:setString(shuom)
end

function ProMessageView:setData( data,localflag )
	self.data=data
	--print("----------------------begin------------------------")
	if localflag then --特殊处理本地表 
		data.propertys = {}--
	end

	local type=conf.Item:getType(data.mId)
	local lv=conf.Item:getItemQuality(data.mId)
	self:setFrameQuality(lv)

	local name=conf.Item:getName(data.mId,data.propertys)
	self:setName(name)
	
	local itemSrc=conf.Item:getSrc(data.mId,data.propertys)

	local path =conf.Item:getItemSrcbymid(data.mId,data.propertys)
	--[[if type == pack_type.SPRITE then 
        path=mgr.PathMgr.getImageHeadPath(itemSrc)
    else
    	 path=mgr.PathMgr.getItemImagePath(itemSrc)
    end]]--

	self:setBImage(path)

	
	for i = 1 , 3 do 
		self.PanelAttribute:getChildByName("Image__"..i):setVisible(false)
		--self["Pro"..i.."dec"]:setVisible(false)
	end 
	self.dec:setVisible(false)
	if type == pack_type.PRO then
		self.dec:setVisible(true)
		self:setDscribe(conf.Item:getItemDescribe(data.mId))
	elseif type == pack_type.MATERIAL then
		self.dec:setVisible(true)
		self:setDscribe(conf.Item:getItemDescribe(data.mId))
	else
		local part=conf.Item:getItemPart(data.mId)--
		self:setPro(part,data.propertys,localflag)
	end

	self:setGotoView(data.mId)
end

--设置图像
function ProMessageView:setBImage(imgpath)
	-- self.spr:setVisible(false)
	 self.spr:loadTexture(imgpath)

end
function ProMessageView:setFrameQuality(lv)
	local framePath=res.btn.FRAME[lv]
	debugprint("path"..framePath)
	self.BtnFrame:loadTextureNormal(framePath)
	self.LabName:setColor(COLOR[lv])
	self:addStar(lv)
end
--设置物品名字
function ProMessageView:setName(name)
	self.LabName:setString(name)
end
--添加星星
function ProMessageView:addStar( num )
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.IconStar:getContentSize().height
	local iconwidth=self.IconStar:getContentSize().width
	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setAnchorPoint(cc.p(0,0.5))
		sprite:setPosition(0+sprite:getContentSize().width*(i-1),iconheight/2)
		self.IconStar:addChild(sprite)
	end
end


function ProMessageView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return ProMessageView