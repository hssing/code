
local BattleHead=class("BattleHead",function (  )
		return ccui.Widget:create()
	end)

function BattleHead:ctor()
end
function BattleHead:init(parent,pos)
	self.pos=pos
	self.parent=parent

	self.view=parent:getBattleClone()
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)

	--选中状态
	self.Image_State =self.view:getChildByName("Image_state")
	--宠物icon 
	self.ImgHead=self.view:getChildByName("Button"):getChildByName("Image")
	--开启等级
	self.Text_lock=self.view:getChildByName("Text_lock")
	--底图上的加号按钮
	self.ImageAdd = self.view:getChildByName("Image_1")

	self.btnframe = self.view:getChildByName("Button")
	self.btnframe:addTouchEventListener(handler(self,self.onCallBack))

	self:initData()

end

function BattleHead:initData()
	-- body
	self.Image_State:setVisible(false)
	self.ImgHead:setVisible(false)
	self.ImageAdd:setVisible(true)
	self.btnframe:setTouchEnabled(false)

	self.btnframe:loadTextureNormal(res.btn.FRAME[1])

	self.lock_lv = conf.Open:getLockLv(self.pos)
	self.Text_lock:setString("LV."..self.lock_lv..res.str.DUI_DEC_05)
	self.Text_lock:setVisible(true)

	local palylv=cache.Player:getLevel()
	if palylv >= self.lock_lv then 
		self.Text_lock:setVisible(false)
		self.btnframe:setTouchEnabled(true)		
	end 
end

function BattleHead:playAction()
	-- body
	--debugprint("特效")
	local palylv=cache.Player:getLevel()
	if  not self.data and palylv >= self.lock_lv and  not self.view:getChildByName("effofname") then 
		local params =  {id=404808, x=self.view:getContentSize().width/2,
		y=self.view:getContentSize().height/2,
		addTo=self.view,playIndex=1,addName = "effofname"}
		mgr.effect:playEffect(params)
	end 
end
---------------------------------------------------------------------
function BattleHead:setData(data)
	if self.view:getChildByName("effofname") then 
		self.view:getChildByName("effofname"):removeFromParent()
	end 

	self.data = data 

	self.Text_lock:setVisible(false)
	self.ImageAdd:setVisible(false)

	local Quality=conf.Item:getItemQuality(data.mId)
	local path = conf.Item:getItemSrcbymid(data.mId,data.propertys)

	local framePath=res.btn.FRAME[Quality]
	self.btnframe:loadTextureNormal(framePath)

	self.ImgHead:setVisible(true)
	self.ImgHead:ignoreContentAdaptWithSize(true)
	self.ImgHead:loadTexture(path)
end 

function BattleHead:setSelectState( flag )
	-- body
	self.Image_State:setVisible(flag)
	if flag then 
		local params =  {id=404835, x =self.Image_State:getContentSize().width/2,
		y = self.Image_State:getContentSize().height/2,addTo = self.Image_State,addName = "effofname"}
		mgr.effect:playEffect(params)
	else
		if self.Image_State:getChildByName("effofname") then 
			self.Image_State:getChildByName("effofname"):removeSelf()
		end 
	end 

end

function BattleHead:addCallBack( fun )
	-- body
	self.callback=fun
end

function BattleHead:onCallBack( send,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		if self.data then --有宠物的时候是选择
			if self.callback then
				--print("-----".."callback")
				self.callback(self.pos,send)
			end
		else --打开上阵要上阵的位置
			-- for i = 1 , 6 do 
			-- 	local flag = true
			-- 	for k ,v in pairs(self.parent.BattleData) do 
			-- 		if conf.Item:getBattlePropertyTo(v) == i then
			-- 			flag=false
			-- 			break
			-- 		end 
			-- 	end 
			-- 	if flag then
					local stype = 11--11上阵,12下阵,13换阵
					mgr.ViewMgr:showView(_viewname.BATTLE_LIST):setData(self.pos,stype) 
					local ids = {1009}
           			 mgr.Guide:continueGuide__(ids)
				-- 	break
				-- end 
			--end 
		end 
	end 
end

--清楚数据
function BattleHead:clear()
	-- body
	self.data  =  nil 
	self:initData()

end

function BattleHead:getData(  )
	return self.data
end


return BattleHead