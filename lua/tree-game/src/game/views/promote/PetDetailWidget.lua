
local PetHeadWidget=require("game.views.promote.PetHeadWidget")

local PetDetailWidget=class("PetDetailWidget",function ( ... )
	-- body
	return ccui.Widget:create()
end)

function PetDetailWidget:ctor(panel )
	self:init(panel)
end
function PetDetailWidget:init(panel)
	self.view=panel:clone()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setAnchorPoint(cc.p(0,0))
	self.view:setPosition(0,0)
	self:setAnchorPoint(cc.p(0,0))
	self:addChild(self.view)

	self.Image_Bg=self.view:getChildByName("Image")

	self.initHeight=self.Image_Bg:getContentSize().height-50

	self.Image_Title=self.view:getChildByName("Image_10_0"):getChildByName("Image_titile")

	self.HeadClone=self.view:getChildByName("Panel_7"):setVisible(false)

	self.lab = self.HeadClone:getChildByName("Text_head_name")

	self.dec = self.view:getChildByName("Text_2")
	self.dec:setString("")

	self.RichTextList={}
	self.ImageHeadList={}
end
function PetDetailWidget:setTitleData( titlepath )
	if titlepath  then
		self.Image_Title:ignoreContentAdaptWithSize(true)
		self.Image_Title:loadTexture(titlepath)
	end
	-- self:updatePanelSize(data)
end
function PetDetailWidget:setWidgetPosition(x,y)
	local posx=x
	local posy=self:getHeight()-self:getContentSize().height
	self:setPosition(posx,y+posy)
end
function PetDetailWidget:updatePanelSize(table,_data)
	--self.dec:setString("")

	for i,v in ipairs(self.RichTextList) do
		v:removeFromParent()
	end
	for i,v in ipairs(self.ImageHeadList) do
		v:removeFromParent()
	end

	self.ImageHeadList={}
	self.RichTextList={}
	local starx=0
	local stary=0
	local index=1
	local height = 0
	local fontSize=22

	
	if table.Label then
		for i=1,#table.Label do
			local v = table.Label[i]

			local lab_name = display.newTTFLabel({
				text = "【"..v.Name.."】",
				font = self.lab:getName(),
				size = fontSize,
				color = v.color,
				align = cc.TEXT_ALIGNMENT_LEFT,
				valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
				--dimensions = cc.size(self.view:getContentSize().width-100, 0),
				x = 15,
				y = self:getContentSize().height/2-20-height,
			})
			lab_name:setAnchorPoint(cc.p(0,1))
			lab_name:addTo(self.view)

			local lab = display.newTTFLabel({
				text = v.Text,
				font = self.lab:getName(),
				size = fontSize,
				color = v.color,
				align = cc.TEXT_ALIGNMENT_LEFT,
				valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
				dimensions = cc.size(self.view:getContentSize().width*0.7, 0),
				x = 15+lab_name:getContentSize().width,
				y = self:getContentSize().height/2-20-height,
			})
			lab:setAnchorPoint(cc.p(0,1))
			lab:addTo(self.view)
			
			--print("lab.szie "..lab:getContentSize().height)
			height = height + lab:getContentSize().height

			self.RichTextList[#self.RichTextList+1]=lab
			self.RichTextList[#self.RichTextList+1]=lab_name

			--height=height+fontSize+10
			--local Richtext=ccui.RichText:create()
			--Richtext:setAnchorPoint(cc.p(0,0))
			--[[if table.Label[i].ImageIcon then
				local Image=ccui.RichElementImage:create(1,cc.c3b(255,255,255),255,res.image.RED_PONT)
				Richtext:pushBackElement(Image)
			end]]--
			--[[local dec="["..table.Label[i].Name.."]"..table.Label[i].Text
			if dec then
				local text=ccui.RichElementText:create(1,cc.c3b(255,255,255),255,dec,fontname,fontSize)
				Richtext:pushBackElement(text)
			end
			-- Richtext:setContentSize(width,height)
			Richtext:formatText()
			local w=Richtext:getVirtualRendererSize().width
			-- debugprint("w:"..Richtext:getVirtualRendererSize().width)
			Richtext:setPosition(w/2+50,-height+50)
			self.RichTextList[#self.RichTextList+1]=Richtext
			self:addChild(Richtext)]]--
		end
	end

		--亲密信息
	local ImageHeadData=table.ImageHeadData
	if ImageHeadData  then
		local offsetY=20
		for i=1,#ImageHeadData.effect_ids do
			local data={}
			data.id=ImageHeadData.effect_ids[i]
			data.skillname=ImageHeadData.effect_names[i]
			data.plus=ImageHeadData.plus[i]
			local widget=PetHeadWidget.new(self.HeadClone)

			widget:setLabelColor(false)
			if not table.isFriend and  G_CheckFriend_qm(ImageHeadData.effect_ids[i]) then 
				widget:setLabelColor(true)
			end
			--[[for k,v in pairs(_data) do
				if v.mId == ImageHeadData.effect_ids[i] then
					widget:setLabelColor(true)
					break
				end
			end]]--

			widget:updatePanel(data)
			local h=widget:getContentSize().height+offsetY
			widget:setPosition((i+1)%2*300+40,-math.floor((i-1)/2)*h-70)
			self:addChild(widget)
			height=height+i%2*h
			self.ImageHeadList[#self.ImageHeadList+1]=widget
		end
	else
		--self.dec:setString(res.str.DEC_NEW_44)
	end
	local w=self.Image_Bg:getContentSize().width
	self.Image_Bg:setContentSize(w,self.initHeight+height)
end

function PetDetailWidget:setDecValue( value )
	-- body
	self.dec:setString(value)
end

function PetDetailWidget:getHeight(  )
	-- body
	return self.Image_Bg:getContentSize().height
end







return PetDetailWidget