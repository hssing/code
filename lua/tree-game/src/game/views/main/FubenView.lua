--[[
	竞技场 , 数码大赛
]]
local FubenView=class("FubenView",base.BaseView)
local _rootPath ="res/views/ui_res/bg/"

function FubenView:ctor()
	-- body	
end

function FubenView:init()

	self.showtype=view_show_type.UI
	--self.ShowAll = true
	self.view=self:addSelfView()

	self.ListView=self.view:getChildByName("ListView")
	self:setData()
	self:initListView()

	local scene =  mgr.SceneMgr:getMainScene()
    if scene then 
        scene:addHeadView()
    end
end 

function FubenView:setData()
	-- body
	self.listActive = conf.active:getallFuben()
end

function FubenView:initListView()
	-- body
	for k ,v in pairs(self.listActive) do 
		
		local img = ccui.ImageView:create()
		img:loadTexture(_rootPath..v.src..".png")
		img:setTouchEnabled(true)

		img.lv = v.lv
		img.id = v.id 
		img.tips = ""
		if v.show_tips and v.show_tips~="" then 
			img.tips = v.show_tips
		end
		img:addTouchEventListener(handler(self,self.imgbtnCall))
		

		if v.lv > cache.Player:getLevel() then 
			local suo_iocn  = display.newSprite(res.icon.FUBENSUO)
			local x = img:getContentSize().width*0.2
			local y = img:getContentSize().height*0.5
			suo_iocn:setPosition(x,y)
			suo_iocn:addTo(img)

			local suo_font = display.newSprite(res.font.FUBENSUO)
			local x = img:getContentSize().width*0.5
			local y = img:getContentSize().height*0.5
			suo_font:setPosition(x,y)
			suo_font:addTo(img)
		else
			local count = 0
			if  img.id == 1 then
				count = cache.Player:getAthleticsCout()
				if count > 0 then
					self:addRedPoint(img, count)
				end
			elseif img.id == 2 then
				local has = cache.Player:getTowerNumber()
				--print("++++++++++++++++++++++++++++++++++++++++++++++++++++", has)
				if has==1 then
					self:addRedPoint(img, 0)
				end	
			elseif img.id == 3 then --驯兽师大赛报名
				count = cache.Player:getBaoMingNumber()
				if count > 0 then
					self:addRedPoint(img, count)
				end
			elseif img.id == 4 then --挖矿
				--print("----------------------------"..)
				count = cache.Player:getDigNumber()
				debugprint("count = "..count)
				if count > 0 then
					self:addRedPoint(img, 0)
				end
			elseif img.id == 5 then --阵营战
				count = cache.Player:getCamp()
				if count > 0 then
					self:addRedPoint(img, 0)
				end
			elseif img.id == 6 then --跨服
				count = cache.Player:getCrossRedpoint()
				if count > 0 then
					self:addRedPoint(img, 0)
				end
			elseif img.id == 7 then --
				count = cache.Player:getDayFubenNumber()
				if count > 0 then
					self:addRedPoint(img, 0)
				end
			elseif img.id == 8 then

			end
		end 
		if img.id == 8 then
		else
			self.ListView:pushBackCustomItem(img)
		end
	end 
end

--创建红点
function FubenView:addRedPoint(parent_, num_)
		--背景
		local numBg = ccui.ImageView:create("res/views/ui_res/other/pack_other/other_redpoint.png")
		numBg:setAnchorPoint(cc.p(0.5,0.5))
		numBg:setPosition(parent_:getContentSize().width-25,parent_:getContentSize().height-25)
		parent_:addChild(numBg)
		--数字
		if num_ > 0 or num_ == -1  then
			local table={
					font = "Arial",
					size = 20,
					color = cc.c3b(255, 255, 255), 
					text = "0",
			}
			local num=display.newTTFLabel(table)
			num:setAnchorPoint(cc.p(0.5,0.5))
			num:setPosition(numBg:getContentSize().width/2,numBg:getContentSize().height/2)
			numBg:addChild(num)
			num:setString(num_)
		end
		
end

function FubenView:imgbtnCall( sender,eventype )
	-- body
	if eventype == ccui.TouchEventType.ended then
		if sender.lv > cache.Player:getLevel() then 
			local str = string.format(res.str.SYS_OPNE_LV, sender.lv)
			if sender.tips ~= "" then 
				str = sender.tips
			end
			G_TipsOfstr(str)
			return 
		end 
		
		if sender.id == 1 then 
			self:Toarean()
		elseif sender.id == 2 then 
			self:ToTumo()
		elseif sender.id == 3 then 
			--todo
			self:ToXunShoushi()
		elseif sender.id == 4 then
			--todo
			self:ToWangKuang()
		elseif sender.id == 5 then
			self:ToCampWar()
		elseif  sender.id == 6 then
			--todo
			self:ToCrossWar()
		elseif sender.id == 7 then
			self:ToDayFubenWar()
		elseif sender.id  == 8 then
			self:ToBossWar()
		end
	end 
end

function FubenView:ToBossWar()
	-- body
	proxy.Boss:send_126005()
end

function FubenView:ToCrossWar()
	-- body
	
	--local view = mgr.ViewMgr:showView(_viewname.CROSS_WAR_MAIN)
	proxy.Cross:send_123001()
end

function FubenView:ToDayFubenWar()
	-- body
	--mgr.ViewMgr:showView(_viewname.FUBEN_DAY)
	proxy.DayFuben:send121001()
	mgr.NetMgr:wait(521001)
end

--竞技
function FubenView:Toarean()
		mgr.NetMgr:send(114001)
end

--屠魔
function FubenView:ToTumo()
	print("发送爬塔信息")
		mgr.NetMgr:send(115001,{isRest=0})
end
--驯兽师大赛
function FubenView:ToXunShoushi()
	-- body
	proxy.Contest:sendContest()
	mgr.NetMgr:wait(519001)
end
--挖矿
function FubenView:ToWangKuang()
	-- body
	local data = {roleId = cache.Player:getRoleInfo().roleId }
	proxy.Dig:sendDigMainMsg(data)
	mgr.NetMgr:wait(520002)
	--local view = mgr.ViewMgr:showView(_viewname.DIG_MIAN)
	--view:playActionCallBack()
end
--阵营战
function FubenView:ToCampWar( ... )
	-- body
	proxy.Camp:send120101()
	mgr.NetMgr:wait(520101)
end

function FubenView:nextStep(id)
	-- body
	for k ,v in pairs(self.ListView:getItems()) do 
		if v.id == id then 
			self:imgbtnCall(v,ccui.TouchEventType.ended)
		end 
	end  
end

function FubenView:onCloseSelfView()
	G_mainView()
end 
return FubenView