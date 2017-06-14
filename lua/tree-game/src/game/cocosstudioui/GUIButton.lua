
--此Button封装3个特性
--1     创建红点
--2     添加特效
--3     添加音效
local GUIButton=class("GUIButton")

local RedPointImagePath="res/views/ui_res/icon/emailNUM.png"


function GUIButton:ctor(button,callback,pointdata,efffect)
	self.button = button
	self.button:setPressedActionEnabled(true)

	self.button:setZoomScale(-0.3) --设置默认 按下状态缩小

	--self.button:setScale9Enabled(true)
	--self.button:setBright(false)
	self.Effect= efffect
	if pointdata then
		self:addRedPoint(self.button,pointdata)
	end
	if callback  then
		self:setEventListener(callback)
	end
end
--创建红点
function GUIButton:addRedPoint( button,pointdata)
	--背景
	local imagepath=pointdata.ImagePath
	local numBg = ccui.ImageView:create(imagepath or RedPointImagePath)
	numBg:setAnchorPoint(cc.p(0.5,0.5))
	numBg:setPosition(button:getContentSize().width-pointdata.x,button:getContentSize().height-pointdata.y)
	numBg:setVisible(false)
	button:addChild(numBg)

	--数字
	local table={
		font = "Arial",
		size = 20,
		color = cc.c3b(255, 255, 255), 
		text = "0",
	}
	self.num=display.newTTFLabel(table)
	self.num:setAnchorPoint(cc.p(0.5,0.5))
	self.num:setPosition(numBg:getContentSize().width/2,numBg:getContentSize().height/2)
	numBg:addChild(self.num)
	self.numBg=numBg
end
function GUIButton:setNumber(num)
	if not self.num then return end 
	self.num:setString(math.min(num,99))
	if num>-1 then
			self.numBg:setVisible(num > 0)
	else
			self.numBg:setVisible(true)
			self.num:setVisible(false)
	end
end

function GUIButton:init()

end
--得到按钮自身实例
function GUIButton:getInstance()
	return self.button
end
function GUIButton:_playMusic()
	
end
function GUIButton:setEventListener( fun )

	local function previousCallback(sender, eventType)
		fun(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self:_playMusic()
    	elseif eventType == ccui.TouchEventType.ended then

	    elseif eventType == ccui.TouchEventType.canceled then
	    end
	end
	self.button:addTouchEventListener(previousCallback)
end

return GUIButton