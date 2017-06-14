----分页按钮管理器
local PageButton=class("PageButton")



function PageButton:ctor()
	self.size = 1
	self.prvButton =  nil --上一个高亮button
	self.ListButton={}
end

function PageButton:btnCallBack(send,eventtype,noClick)
	if eventtype == ccui.TouchEventType.ended then
	   local isChange
		if self._BtnCallBack and send then
            isChange = self._BtnCallBack(send._type,eventtype,noClick)
		end
	   if isChange then
            self:updateButtonState(send,self.prvButton,true)
            self.prvButton=send--记录高亮Button
	   end
	end
end

function PageButton:updateButtonState(nowbutton,prvbutton,bl)
		if nowbutton == prvbutton then return end
		self:setButtonState(nowbutton,bl)
		self:setButtonState(prvbutton,not bl)
end

---设置选中btn
function PageButton:setSelectButton(index_)
    if self.prvButton ~= self.ListButton[index_] then
        local send = self.ListButton[index_]
        self:updateButtonState(send,self.prvButton,true)
    end
end

function PageButton:setButtonState(button,bl)
	if button then
		button:setHighlighted(bl)
		button:setTouchEnabled(not bl)
		self.prvButton=button--记录高亮Button
	end
end
function PageButton:setBtnCallBack( fun )
	self._BtnCallBack=fun
end


function PageButton:addButton(button)

	self.ListButton[self.size]=button
	button._type=self.size
		--debugprint("buttonindex:"..button._type)
	self.size=self.size+1
	--button:setPressedActionEnabled(true)
	button:addTouchEventListener(handler(self,self.btnCallBack))
	button:setTouchEnabled(true)
	--setFocusEnabled
	
end
function PageButton:initClick(index)
	self:btnCallBack(self.ListButton[index],ccui.TouchEventType.ended, true)
end

function PageButton:addButtonByTags(view_,...)
	for k,v in pairs({...}) do
		 local btn=view_:getChildByTag(v)
		 self:addButton(btn)
	end
end

function PageButton:getSelectedIndex()
	if self.prvButton ~= nil then
		return self.prvButton._type
	else
		return -1
	end
end

function PageButton:init()

end






return PageButton