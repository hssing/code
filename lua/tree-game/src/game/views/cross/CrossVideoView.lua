--[[
CrossVideoView 王者之战的录像
]]--

local CrossVideoView = class("CrossVideoView",base.BaseView)

function CrossVideoView:ctor()
	-- body
end

function CrossVideoView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()
	G_FitScreen(self, "Image_40")

	self.listview = self.view:getChildByName("ListView_1")
	self.item = self.view:getChildByName("Panel_7_0")
	self.item:getChildByName("Button_23"):setTitleText(res.str.CONTEST_TEXT14)

	
	local dec = self.view:getChildByName("Panel_1"):getChildByName("Text_13_0")
	dec:setString(res.str.RES_GG_22)

	self.lab_other = self.view:getChildByName("Panel_1"):getChildByName("Text_13")
	self.lab_other:setString("")
end
--观看录像
function CrossVideoView:onBtnVidoCallBack( sender_,eventtype  )
	-- body
	if eventtype == ccui.TouchEventType.ended then 
		local data = {frId = sender_.frId}
		proxy.copy:onSFight(123013,data)
	end 
end

function CrossVideoView:setolditem()
	-- body
	local item = self.item:clone()
	self.listview:pushBackCustomItem(item)

	--录像按钮
	local btn = item:getChildByName("Button_23")
	--btn.frId =v.frId
	btn:addTouchEventListener(handler(self, self.onBtnVidoCallBack))
end

function CrossVideoView:initItem(v,k)
	-- body
	local item = self.item:clone()
	
	--录像按钮
	local btn = item:getChildByName("Button_23")
	btn.frId =v.frId
	btn:addTouchEventListener(handler(self, self.onBtnVidoCallBack))

	local name1 = item:getChildByName("Text_22_24")
	local name2 = item:getChildByName("Text_22_24_0")

	name1:setString(self.playerdata[1].namePre.."."..self.playerdata[1].roleName)
	name2:setString(self.playerdata[2].namePre.."."..self.playerdata[2].roleName)

	local img_1 = item:getChildByName("Image_60")
	local img_2 = item:getChildByName("Image_60_1")

	local lab_text = item:getChildByName("Text_22_24_1")
	lab_text:setString("")

	local win = string.sub(v.win,-2,-1)
	--print(win)
	--local right =  string.sub(v.win,-3,-4)
	--local left =  string.sub(v.win,-5,-6)
	--print(tonumber(self.playerdata[1].index),tonumber(win))
	if tonumber(self.playerdata[1].index) == tonumber(win) then
		img_1:loadTexture(res.font.WIN)
		img_2:loadTexture(res.font.LOSE)
		lab_text:setString( string.format(res.str.RES_GG_21,name1:getString()))
	else
		img_1:loadTexture(res.font.LOSE)
		img_2:loadTexture(res.font.WIN)
		lab_text:setString( string.format(res.str.RES_GG_21,name2:getString()))
	end

	if k then
		if tonumber(self.playerdata[1].win) > tonumber(self.playerdata[2].win) then
			img_1:loadTexture(res.font.LOSE)
			img_2:loadTexture(res.font.WIN)
			lab_text:setString( string.format(res.str.RES_GG_21,name2:getString()))
		else
			img_1:loadTexture(res.font.WIN)
			img_2:loadTexture(res.font.LOSE)
			lab_text:setString( string.format(res.str.RES_GG_21,name1:getString()))
		end
	end

	self.listview:pushBackCustomItem(item)
end

function CrossVideoView:sortdata(data,hehe)
	-- body
	local t = data
	local r_t = { {},{} }
	if hehe == 16 then -- 
		for k ,v in pairs(t) do 
			if v.index == 1 or v.index == 9 or v.index == 12 or v.index == 13 
				or v.index ==2 or v.index == 10 or v.index == 11 or v.index == 14 then 

				r_t[1] = v 
			else
				r_t[2] = v 
			end
		end
	elseif hehe == 8 then 
		for k ,v in pairs(t) do 
			if v.index == 1 or v.index == 16 or v.index == 12 or v.index == 5 
			   or v.index == 2 or v.index == 15 or v.index == 11 or v.index == 6 then
				r_t[1] = v 
			else
				r_t[2] = v 
			end
		end
	elseif hehe == 4 then
		for k ,v in pairs(t) do 
			if v.index == 1 or v.index == 16 or v.index == 8 or v.index == 9
				or  v.index == 2 or v.index == 15 or v.index == 10 or v.index == 7 then

				r_t[1] = v 
			else
				r_t[2] = v 
			end
		end
	else
		for k ,v in pairs(t) do 
			if v.index == 1 or v.index == 16 or v.index == 8 or v.index == 9
				or v.index == 12 or v.index == 5 or v.index == 13 or v.index == 4 then
				r_t[1] = v 
			else
				r_t[2] = v 
			end
		end
	end
	return r_t
end

function CrossVideoView:setPlayerData( data,hh )
	-- body
	self.playerdata = self:sortdata(data,hh)
	local iswin = 0
	for k ,v in pairs(self.playerdata) do 
		iswin = math.max(v.win,iswin)
	end
	--local iswin = math.max(self.playerdata[1].win,self.playerdata[2].win)
	self.win = {}
	self.lose = {}

	--self.pos = 1
	for k ,v in pairs(self.playerdata) do 
		if v.win == iswin then
			self.lose = v 
			--self.pos = k
		else
			self.win = v 
		end
	end
	self.lab_other:setString(self.win.namePre.."."..self.win.roleName)
	proxy.Cross:send_123014({index = self.lose.index})		
end

function CrossVideoView:setData(data)
	-- body
	self.data = data
	--列表
	self.listview:removeAllItems()
	for k ,v in pairs(data.frList) do 
		if #data.frList == 1 then
			self:initItem(v,k)
		else
			self:initItem(v)
		end
	end
end


function CrossVideoView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return CrossVideoView