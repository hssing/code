--[[
	系统公告
]]
local NoticesView=class("NoticesView",base.BaseView)

function NoticesView:init()
	-- body
	proxy.Login:setLoginBool()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()



	local btn_inyouxi = self.view:getChildByName("btn_in")
	btn_inyouxi:addTouchEventListener(handler(self, self.onbtnStartGame))

	self.item = self.view:getChildByName("Panel_2")

	self.listView = self.view:getChildByName("ListView_2")

    G_FitScreen(self, "Image_7")
end


function NoticesView:setData()
	-- body
	self.data = conf.Gonggao:getAllItem() --cache.Fortune:getGonggao()
	printt(self.data )
	table.sort( self.data, function( a,b )
		-- body
		return a.index < b.index
	end )

	self:initListView()
end


function NoticesView:initListView()

	-- body
	for k ,v in pairs(self.data) do 
		local item = self.item:clone()
		item:setVisible(true)
		item:getChildByName("Text_1"):setString(res.str.RES_GG_07) 

		local _title = item:getChildByName("Text_title")
		_title:setString(v.title)

		local _tx_time = item:getChildByName("Text_title_0")

		local str = string.gsub(v.timeStr,"=",":")
		_tx_time:setString(str)

		local txt_all = item:getChildByName("Text_title_0_0")
		txt_all:ignoreContentAdaptWithSize(false)
		txt_all:setString(v.contentStr)

		self.listView:pushBackCustomItem(item)
	end 
end

function NoticesView:onbtnStartGame( sender,eventtype  )
	-- body
	if  eventtype == ccui.TouchEventType.ended then
        self:onCloseSelfView()
	end
end

function NoticesView:onCloseSelfView()
    --开始新手引导
    mgr.Guide:startGuide()
    --传递渠道信息
    sdk:extendInfoSubmit(3001)
    --显示聊天 ICON
  	local maintoplayerview = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
  	local mainView = mgr.ViewMgr:get(_viewname.MAIN)
 	local roleView = mgr.ViewMgr:get(_viewname.ROLE)
  	
  	if  maintoplayerview and mainView and not roleView then
       maintoplayerview.btnChat:setVisible(true)
   	end


    self.super.onCloseSelfView(self)
end

return NoticesView