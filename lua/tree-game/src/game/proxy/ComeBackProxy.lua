--
-- Author: Your Name
-- Date: 2015-09-09 21:56:57
--
local ComeBackProxy = class("ComeBackProxy", base.BaseProxy)

function ComeBackProxy:init(  )
	self:add(516065,self.reqGiftInfoCallback)
	self:add(516066,self.reqAwardCallback)
end


function ComeBackProxy:reqGiftInfo(  )
	self:send(116065)
	self:wait(516065)
end

function ComeBackProxy:reqGiftInfoCallback( data )
	print("======reqGiftInfoCallback========")
	printt(data)
	if data.status == 0 then
		
		local view = mgr.ViewMgr:get(_viewname.COMEBACK)
		if view then
		   view:setData(data)
		end


	end
end

--请求领取奖励
--0.钻石，1刀具
function  ComeBackProxy:reqGetAward( atype )
	print(atype)
	self:send(116066,{gotType = atype})
end

function ComeBackProxy:reqAwardCallback( data )
	--dump(data)

	if data.status == 0 then
		local view  = mgr.ViewMgr:get(_viewname.COMEBACK)
		if view then
			view:getAwardSucc(data)
		end

		 local items = {}

		for k,v in pairs(data["items"]) do
			local index = 1
			for k2,v2 in pairs(items) do
				if v.mId == v2.mId then
					v2.amount = v2.amount + v.amount
					break
				end
				index = index + 1
			end
			if index > #items then
				items[#items + 1] = v
			end
		end

		--dump(items)

		local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		if view then
			view:setData(items,true,true)
			view:setButtonVisible(false)
			view:setSureBtnTile(res.str.HSUI_DESC12)
		end
	end
end



return ComeBackProxy