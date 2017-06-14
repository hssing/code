

local loginItem = class("loginItem",function( ... )
	-- body
	return ccui.Widget:create()
end)

function loginItem:init(Parent)
	-- body
	self.Parent=Parent
	self.view=self.Parent:getClone()
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)
end

function loginItem:getStateString( type )
	-- body
	if type == 2 then 
		return res.str.LOGIN_WEIHU
	elseif type == 1 then 
		return res.str.LOGIN_WEIHU
	else
		--todo
		return res.str.LOGIN_BAOMAN
	end 
end

function loginItem:choosscall( send_,eventtype )
	-- body
	if  eventtype == ccui.TouchEventType.ended then
		local data = send_.data
		local tipsdata = {}
		tipsdata.sure = function( ... )
			-- body
		end
		tipsdata.surestr = res.str.SURE

		if data.type == 3 then 
			tipsdata.richtext =  data.tip_str

			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(tipsdata)
			return 
		elseif data.type == 2 then
			tipsdata.richtext =  data.tip_str
			mgr.ViewMgr:showTipsView(_viewname.TIPS):setData(tipsdata)
			return 
		end 

		self.Parent:setCurrData(data,send_)
	end
end

function loginItem:setData(data_,idx)
	-- body
	self.data = data_
	local ccsize = self.view:getContentSize()

	self.view:removeAllChildren()
	self.btn = {}
	for i,v in pairs(data_) do  


		local item = self.Parent:getCloneBtn()
		item.data = v
		item:setTouchEnabled(false)
		item:loadTextureNormal(res.btn.LOGIN_BTN[1])
		item:addTouchEventListener(handler(self, self.choosscall))

		table.insert(self.btn,item)

		item:setAnchorPoint(cc.p(0.5,1))

		local qu = item:getChildByName("text_num_qu_7")
		qu:setString(v.area_id..res.str.SYS_DEC5)

		local name = item:getChildByName("text_name_9")
		name:setString(v.name)

		local stat = item:getChildByName("text_statue_11")
		stat:setVisible(false)
		stat:setString(self:getStateString(v.type))
		
		local img = item:getChildByName("Image_2")
		img:loadTexture(res.font.LOGIN_TYPE[v.type+1])

		local posx = i%2 == 0 and  ccsize.width/4*3  or ccsize.width/4
		local ky = checkint(i/2) 
		local posy = ccsize.height  - (ky-1) * item:getContentSize().height

		item:setPosition(posx,posy)
		self.view:addChild(item)
	end 
end

function loginItem:BtnChoos( touch )
	-- body

	--printt(touch)
	--print("**************************")
	--printt(self.view:convertToNodeSpace(touch))		
	--print("--------------------------------")
	local pos = self.view:convertToNodeSpace(touch)
	for i = 1 , #self.btn do 
		local v = self.btn[i]
		--print("i "..i)
		--print(v:getPositionX()-v:getContentSize().width/2)
		--print(v:getPositionX()+v:getContentSize().width/2)
		local x1 = v:getPositionX()-v:getContentSize().width/2
		local x2 = v:getPositionX()+v:getContentSize().width/2
		if x1 < pos.x and pos.x<x2 then 
			self:choosscall(v,ccui.TouchEventType.ended)
			break
		end
	end
end

return loginItem