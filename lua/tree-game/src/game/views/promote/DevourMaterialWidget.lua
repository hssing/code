local DevourMaterialWidget = class("DevourMaterialWidget",
	function ( )
		return ccui.Widget:create()
end)

function DevourMaterialWidget:init(parent)
	self.callbackfun = nil --回调

	self.view=parent:getWidgetClone()

	self.parent=parent

	self:setContentSize(self.view:getContentSize())

	self.view:setPosition(0,0)

	self:addChild(self.view)
	--品质框
	self.btnframe=self.view:getChildByName("Button_frame")
	--头像 
	self.imghead=self.btnframe:getChildByName("Image")
	--等级
	self.LableLv=self.btnframe:getChildByName("Image_lv_25_21"):getChildByName("Text_lv")
	--经验
	self.labelexp=self.view:getChildByName("Image_30"):getChildByName("Text_exp")
	--复选框
	self.checkbox=self.view:getChildByName("CheckBox"):setSelected(false)
	self.checkbox:addEventListener(handler(self,self.onCheckBoxCallBack))
	--名字
	self.LableName=self.view:getChildByName("Image_zb_bg_29_23"):getChildByName("Text_name1_22")

	--升级 突破选择
	self._btn_choose = self.view:getChildByName("Button_choose")
	self._btn_choose:addTouchEventListener(handler(self,self.onChooseCallBack))
	--self._btn_choose:addEventListener(handler(self,self.onChooseCallBack))
	-- self.isSelect == true

	self._exp = 0

	self.spr7s = self.view:getChildByName("Image_2")
	self.spr7s:setVisible(false)
	--self:initDec()
	self._btn_choose:getChildByName("Text_1_0_9"):setString(res.str.SELECT_PET_DESC1)


	
end
function DevourMaterialWidget:checkTuihua()
	-- body
	local lv = self.data.propertys[304] and  self.data.propertys[304].value or 1
	local jianghua = self.data.propertys[310] and self.data.propertys[310].value or 0
	local jie = self.data.propertys[307] and self.data.propertys[307].value or 0

	if lv > 1 or  jianghua > 0 or  jie >0  or checkint(self.conf_data.zhuan) > 0 then 
		local data = {}
		data.richtext = {
			{text=res.str.PROMOTEN_DEC1,fontSize=24,color=cc.c3b(255,255,255)},
			{text=res.str.PROMOTEN_DEC2,fontSize=24,color=cc.c3b(255,0,0)},
			{text=res.str.PROMOTEN_DEC3,fontSize=24,color=cc.c3b(255,255,255)},
			{text=res.str.PROMOTEN_DEC4,fontSize=24,color=cc.c3b(255,0,0)},
			{text=res.str.PROMOTEN_DEC5,fontSize=24,color=cc.c3b(255,255,255)},
		}

		---res.str.COMPOSE_CARD;
		data.sure = function( ... )
			-- body
			local view = mgr.ViewMgr:showView(_viewname.TUIVIEW)
			view:setData(self.data)
			self.parent:closeSelfView()
		end
		data.cancel = function( ... )
			-- body
		end
		data.surestr =  res.str.COMPOSE_CARD_SURE
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,true)
		return true
	end 

	return false 
end


function DevourMaterialWidget:onChooseCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self:checkTuihua() then 
			return 
		end  

   		local data = {};
		--data.richtext = str;
		data.surestr= "确定"
		data.sure = function ( ... )
			local view=mgr.ViewMgr:get(_viewname.PROMOTE_LV)
			if view._petTargetUp then 
				view._petTargetUp:setuseData(self:getData())
			end
			self.parent:closeSelfView()
		end
		data.richtext={
		{text=res.str.DEVOUR_DEC1,fontSize=24,color=cc.c3b(255,255,255)},
		{text=res.str.DEVOUR_DEC2,fontSize=24,color=cc.c3b(255,0,0)},
		{text=res.str.DEVOUR_DEC3,fontSize=24},
		}
		data.cancel = function ( ... )
			-- self.checkbox:setSelected(true) 
			-- fun()
		end
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,true)

		--[[local function cancelcallbcak()
		   
		end 

		local data = {};

		data.richtext = res.str.PROMOTE_CARD_CLEAR;
		data.sure = surecallbcak
		data.cancel = cancelcallbcak
		data.surestr = res.str.SURE
		mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data)]]--

	end
end

function DevourMaterialWidget:addCallBack( fun )
	self.callbackfun=fun
end
function DevourMaterialWidget:onCheckBoxCallBack(send,eventype )
	local quality = conf.Item:getItemQuality(self.data.mId)
	local atype = conf.Item:getType(self.data.mId)
	local fun =function (  )
	 	--print("============"..#self.parent:getSelectPetListData())
	    local bl=self.callbackfun(eventype,self.data)
		if not bl and #self.parent:getSelectPetListData() > 0  then
			G_TipsMoveUpStr(res.str.DEVOUR_DEC4)
			self.checkbox:setSelected(bl) 
		end
   	 end

	if eventype == 0 then  --勾选
		if  atype ~= pack_type.PRO and quality > 3 then
			if self:checkTuihua() then 
				self.checkbox:setSelected(false) 
				return 
			end 

			self.checkbox:setSelected(false) 
			local data = {};
			--data.richtext = str;
			data.surestr= "确定"
			data.sure = function ( ... )
				self.checkbox:setSelected(true) 
				fun()
			end
			data.richtext={
			{text=res.str.DEVOUR_DEC1,fontSize=24,color=cc.c3b(255,255,255)},
			{text=res.str.DEVOUR_DEC2,fontSize=24,color=cc.c3b(255,0,0)},
			{text=res.str.DEVOUR_DEC3,fontSize=24},
			}
			data.cancel = function ( ... )
				-- self.checkbox:setSelected(true) 
				-- fun()
			end
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(data,true)
		else
			fun()
		end
	else--不勾选
		fun()
	end
end
function DevourMaterialWidget:getData(  )
	return self.data
end

function DevourMaterialWidget:setData(data)
	self.data=data

	self.checkbox:setSelected(false)

	local conf_data = conf.Item:getItemConf(self.data.mId)
	self.conf_data = conf_data
	self.spr7s:setVisible(false)
	if checkint(conf_data.zhuan) > 0 then
		self.spr7s:setVisible(true)
		self.spr7s:loadTexture(res.icon.ZHUANFRAME[conf_data.zhuan])
	end

	
	self._btn_choose:setEnabled(true)
	self._btn_choose:setBright(true)

	local quality = conf.Item:getItemQuality(data.mId)
	local lv = mgr.ConfMgr.getLv(data.propertys)
	local exp = 0
	local atype = conf.Item:getType(data.mId)
	if atype ~= pack_type.PRO then 
		exp = conf.CardExp:getExp(conf.Item:getItemSjPre(data.mId),lv)
	else
		exp = conf.Item:getExp(data.mId)
	end
	-- self._exp=exp
	local name = conf.Item:getName(data.mId,data.propertys)
	local framePath=res.btn.FRAME[quality]
	local itemSrc=conf.Item:getSrc(data.mId,data.propertys)
	local atype = conf.Item:getType(data.mId)
	
	local path
	if atype == pack_type.PRO then 
		exp = conf.Item:getExp(data.mId)
		path=mgr.PathMgr.getItemImagePath(itemSrc)
	elseif  atype == pack_type.SPRITE then
		--todo
		 path=mgr.PathMgr.getImageHeadPath(itemSrc)
	end 

	self.imghead:loadTexture(path)

	self.labelexp:setString(exp)

	self.LableLv:setString(lv)
	self.LableName:setString(name)
	self.LableName:setColor(COLOR[quality])
	self.btnframe:loadTextureNormal(framePath)
end
function DevourMaterialWidget:setSelected(bl )
	self.checkbox:setSelected(bl)
end

function DevourMaterialWidget:getExp()
	return self._exp
end

function DevourMaterialWidget:setbtnVis(indext  )
	-- body
	if indext == 2 then 
		self._btn_choose:setVisible(true)
		self.checkbox:setVisible(false)
	end
end

function DevourMaterialWidget:setBtnfalse()
	-- body
	self._btn_choose:setEnabled(false)
	self._btn_choose:setBright(false)
end
















return DevourMaterialWidget