--[[
	GuildNoticesView ++公会动态
]]

local GuildNoticesView = class("GuildNoticesView", base.BaseView)

function GuildNoticesView:init()
	-- body
	self.bottomType = 1
	self.ShowAll=true
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.item = self.view:getChildByName("Panel_2")
	self.listView = self.view:getChildByName("ListView_2")

	G_FitScreen(self,"Image_7")
end

function GuildNoticesView:setData()
	-- body
	self.data =  cache.Guild:getDongtaiMsg()
	print("--------------**************-")
	self:initListView()
end


function GuildNoticesView:initListView()

	-- body
	for k ,v in pairs(self.data) do 
		local item = self.item:clone()
		item:setVisible(true)

		local strtable = string.split(v, "#")

		local _tx_time = item:getChildByName("Text_title_0")
		_tx_time:setString(strtable[1])

		local txt_all = item:getChildByName("Text_title_0_0")
		txt_all:ignoreContentAdaptWithSize(false)
		txt_all:setString(strtable[2])

		self.listView:pushBackCustomItem(item)
	end 
end

function GuildNoticesView:onbtnStartGame( sender,eventtype  )
	-- body
	if  eventtype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
	end
end

function GuildNoticesView:onCloseSelfView()
 	G_MainGuild()
end

return GuildNoticesView