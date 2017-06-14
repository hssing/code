local DebugView=class("DebugView",base.BaseView)

function DebugView:ctor()

end

function DebugView:init()
	self.showtype= view_show_type.TOP
	-- self.view=self:addSelfView()
	-- local Panel=self.view:getChildByName("Panel")
	-- local size=7
	-- for i=1,size do 
	-- 	local btn=Panel:getChildByTag(i)
	-- 	btn:addTouchEventListener(handler(self,self.CallBack))
	-- end
	

	local dy = display.height

	self.btn1 = self:addButton("<<<",20,dy-20,30)
	self.btn1:addTouchEventListener(function(s_,t_)
			if t_ == ccui.TouchEventType.ended then
				mgr.ViewMgr:closeView(_viewname.DEBUG)
				cc.Director:getInstance():setDisplayStats(false)
			end
		end)

	self:addButton2("Test",20,dy-65,130,70):addTouchEventListener(function(sender_,etype_)
			if etype_ == ccui.TouchEventType.ended then
				mgr.ViewMgr:showView(_viewname.DEBUG_TEST)
			end
		end)
	self:addButton("fighting",20,dy-155,79):addTouchEventListener(function(sender_,etype_)
			if etype_ == ccui.TouchEventType.ended then
				mgr.SceneMgr:LoadingScene(_scenename.FIGHT)
				fight_test = true
			end
		end)
	self:addButton("NetTest",20,dy-180,79):addTouchEventListener(function(sender_,etype_)
			if etype_ == ccui.TouchEventType.ended then
				local reqData = {
					-- msgId = 114001,
					-- msgId = 114002,
					-- tarId = {low = 5000,high= 0,},
					-- uId = {low = 5000,high= 0,},
					-- msgId = 104002,
					-- index = 200001,
					-- packIndex = {[1]=221061001,},
					-- stype = 40411,
					-- count = 15,
					-- msgId = 501005,
					-- roleName="aa",
					msgId = 115001,
					isRest = 0,

				}
				-- mgr.NetMgr:send(reqData.msgId,reqData)
				if self.hand  == nil then
					game.GameSdkHelper:getInstance():setDelegate(handler(self,self.onResult))
				end
				G_TipsOfstr("aaaa1")
			end
		end)

	self:addButton("NetTest2",20,dy-205,79):addTouchEventListener(function(sender_,etype_)
			if etype_ == ccui.TouchEventType.ended then
			    local reqData = {
					msgId = 102003,
					fId = 410011,

				}
				-- mgr.NetMgr:send(reqData.msgId,reqData)
				-- sdk:pay(6)
				sdk:logout()
				G_TipsOfstr("bbb")
			end
		end)
end

function DebugView:onResult(code,str)
	G_TipsOfstr("code>>"..code..">>json>>"..str)
end


function DebugView:CallBack( send_,eventtype )
	if eventtype == ccui.TouchEventType.ended then
		if send_:getTag() == 1 then 
			mgr.ViewMgr:showView(_viewname.DEBUG_TEST)
			-- mgr.NetMgr:connect("127.0.0.1","8000")
		elseif send_:getTag() == 2 then
			-- mgr.NetMgr:close()
		elseif send_:getTag() == 3 then
			-- mgr.NetMgr:testLogin()
		elseif send_:getTag() == 4 then
			mgr.NetMgr:testCommand("aa bb cc")
		end
	end

end

function DebugView:addButton(text_,x_,y_,w_)
    local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:setScale9Enabled(true)
    button:setCapInsets(cc.rect(11,11,15,15))
    button:loadTextureNormal(res.btn.TEST_UP)
    button:setTitleText(text_)
    button:setPosition(cc.p(x_,y_))
    -- button:setContentSize(w_,button:getContentSize().height)
    button:setContentSize(cc.size(w_,25))
    self:addChild(button)
    return button;

end

function DebugView:addButton2(text_,x_,y_,w_,h_)
    local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:setScale9Enabled(true)
    button:setCapInsets(cc.rect(11,11,15,15))
    button:loadTextureNormal(res.btn.TEST_UP)
    button:setTitleText(text_)
    button:setPosition(cc.p(x_,y_))
    -- button:setContentSize(w_,button:getContentSize().height)
    button:setContentSize(cc.size(w_,h_))
    self:addChild(button)
    return button;
end

return DebugView