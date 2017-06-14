

local VipTipsView = class("VipTipsView",base.BaseView)
function VipTipsView:init()
	-- body
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	local panle = self.view:getChildByName("Panel_1")
	panle:addTouchEventListener(handler(self, self.onpanleClose))

	self.panel = panle

	G_FitScreen(self,"Image_1")
end

function VipTipsView:onpanleClose(send,eventype)
	-- body
	if eventype == ccui.TouchEventType.ended then
		self:onCloseSelfView()
	end
end

function VipTipsView:setData(viplv)
	-- body
	local _armature1 = mgr.BoneLoad:loadArmature(404086,4)
	_armature1:setPosition(display.cx,display.cy+20)
	_armature1:addTo(self.view)

	
	local armature = mgr.BoneLoad:loadArmature(404846,0)
	armature:setPosition(display.cx,display.cy+200)
	armature:addTo(self.view)

	local function run( spr )
		-- body
		--local a1 = cc.MoveTo:create(1.0,cc.p(spr:getPositionX(),display.cy+320)) 开始位置
		local a1 =  cc.MoveTo:create(0.08,cc.p(spr:getPositionX(),display.cy+190))  -- 下
		local a2 =  cc.MoveTo:create(0.12,cc.p(spr:getPositionX(),display.cy+260)) --  上
		local a3 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),display.cy+200)) -- 下
		local a4 =  cc.MoveTo:create(0.1,cc.p(spr:getPositionX(),display.cy+230)) -- 上
		local a5 =  cc.MoveTo:create(0.05,cc.p(spr:getPositionX(),display.cy+210))--最后停留

		local sequence = cc.Sequence:create(a1,a2,a3,a4,a5)
		spr:runAction(sequence)
	end

	armature:getAnimation():setFrameEventCallFunc(function( bone,event,originFrameIndex,intcurrentFrameIndex )
		-- body
		local strnum=tostring(viplv)
		local num1 = string.sub(strnum,1,1)
		local num2 = string.sub(strnum,2)
		local spr
		if event == "a1" then 
			spr = display.newSprite(res.other.NUMBER[tonumber(num1)])
			spr:setPositionX(display.cx+95) --x  --第一个数字 开始位置
			spr:setPositionY(display.cy+320) -- y 
			spr:addTo(self.view)

			run(spr)

		elseif event == "a2" then 
			if tonumber(num2) ~= 0 then 
				spr = display.newSprite(res.other.NUMBER[tonumber(num2)])
			else
				spr = display.newSprite(res.other.NUMBER[10])
			end
			spr:setPositionX(display.cx+150) ----第2个数字 开始位置
			spr:setPositionY(display.cy+320)
			spr:addTo(self.view)

			run(spr)
		end
	end)
end

function VipTipsView:onCloseSelfView()
	-- body
	self:closeSelfView()
end

return VipTipsView