--
-- Author: Your Name
-- Date: 2015-08-05 21:17:26
--


local GiftPackCodeView = class("GiftPackCodeView", base.BaseView)


function GiftPackCodeView:init(  )
	-- body
	self.showtype=view_show_type.UI
	self.view=self:addSelfView()

	self.panel = self.view:getChildByName("Panel_1")
	self.btnSure = self.panel:getChildByName("Button_ok")
	local codeLabel = self.panel:getChildByName("TextField_code")

	self.codeLabel = cc.ui.UIInput.new({-------------礼包码文本框
			image = res.image.TRANSPARENT,
		    x = codeLabel:getPositionX(),
		    y = codeLabel:getPositionY(),
		    size = cc.size(codeLabel:getContentSize().width,codeLabel:getContentSize().height)
		})

	self.panel:addChild(self.codeLabel)
	self.codeLabel:setFontName(codeLabel:getFontName())
	self.codeLabel:setFontSize(codeLabel:getFontSize())
	self.codeLabel:setPlaceHolder(res.str.ACTIVE_TEXT19)
	codeLabel:removeFromParent()

	self.panel:getChildByName("Text_3"):setString(res.str.ACTIVE_TEXT17)
	self.panel:getChildByName("Text_4"):setString(res.str.ACTIVE_TEXT18)
	self.btnSure:setTitleText(res.str.HSUI_DESC12)


	self.btnSure:addTouchEventListener(handler(self,self.btnSureClickUp))

end

-----通过礼包码领取礼包
function GiftPackCodeView:btnSureClickUp(sender,eType )
	-- body
	if eType == ccui.TouchEventType.ended then
		local code = string.trim(self.codeLabel:getText())
		if code then
			proxy.GiftPackCode:reqGetGift(code)
		end
	end
end







return GiftPackCodeView