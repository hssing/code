--
-- Author: Your Name
-- Date: 2015-08-14 17:49:38
--

local GiftPackCodeProxy = class("GiftPackCodeProxy", base.BaseProxy)

function GiftPackCodeProxy:init(  )
	-- body

	--self:add(516051,self.reqGetGiftCallback)
	----礼包码使用返回
	self:add(516051,self.reqGetGiftCallback)

end

----请求领取礼包
function GiftPackCodeProxy:reqGetGift( strKey )
	-- body
	print(strKey.."===========================")
	self:send(116051,{giftCode = strKey})

end

-----请求领取礼包返回
function GiftPackCodeProxy:reqGetGiftCallback( data )
	-- body
	print("==============reqGetGiftCallback=============")
	--dump(data)

	if data.status == 0 then
		--todo
		local view=mgr.ViewMgr:showView(_viewname.PACKGETITEM)
		view:setData(data.itrems,true,true)
		view:setButtonVisible(false)
		view:setSureBtnTile(res.str.HSUI_DESC1)
	elseif data.status == 21070021 then
		G_TipsOfstr(res.str.GIFT_CODE_TIPS1)
	elseif data.status == 21070022 then
		G_TipsOfstr(res.str.GIFT_CODE_TIPS2)
	elseif data.status == 21070023 then
		G_TipsOfstr(res.str.GIFT_CODE_TIPS3)
	elseif data.status == 21070024 then
		G_TipsOfstr(res.str.GIFT_CODE_TIPS4)
	end
	
		
end






return GiftPackCodeProxy