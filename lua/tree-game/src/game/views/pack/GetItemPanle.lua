local pet=require("game.things.PetUi")
local GetItemPanle=class("GetItemPanle",function()
	return ccui.Widget:create()
	end
	)
function GetItemPanle:init(panle,index)
	self.view=panle:getClone()
	self.index=index
	self:addChild(self.view)
	self:setAnchorPoint(self.view:getAnchorPoint())
	self.view:setVisible(true)

	self.view:setScale(0.95)

	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(self.view:getContentSize().width/2,self.view:getContentSize().height/2)
	--点击触摸文字
	

	self.LabName=self.view:getChildByName("Text_name")
	self.IconStar=self.view:getChildByName("Panel_star")
	self.BtnFrame=self.view:getChildByName("Button_frame")
	self.Image=self.BtnFrame:getChildByName("Image_head")
	self.imgCount = self.view:getChildByName("img_Count")
	self.line = self.view:getChildByName("Image_15")


	self.spr1=self.BtnFrame:getChildByName("Image_head")
	self.spr2 = self.view:getChildByName("Image_spr")
	self.spr2:setVisible(false)
end


function GetItemPanle:setBImage(imgpath)
	 self.spr1:loadTexture(imgpath)
end

function GetItemPanle:setBImage2( imgpath )
	-- body
	self.spr2:loadTexture(imgpath)
end

function  GetItemPanle:setFrameQuality( lv )
	-- body
	local framePath=res.btn.FRAME[lv]
	self.BtnFrame:loadTextureNormal(framePath)
	self.LabName:setColor(COLOR[lv])
end

--设置物品名字
function GetItemPanle:setName(name)
	self.LabName:setString(name)
end

--添加星星
function GetItemPanle:addStar( num )
	local starpath=res.image.STAR
	local size=num
	local iconheight=self.IconStar:getContentSize().height
	local iconwidth=self.IconStar:getContentSize().width

	--local 
	local sprite=display.newSprite(starpath)
	local w = (sprite:getContentSize().width-5)*size
	local strposX = (iconwidth -w)/2 + sprite:getContentSize().width/2

	for i=1,size do
		local sprite=display.newSprite(starpath)
		sprite:setScale(0.8)
		sprite:setPosition(strposX+(sprite:getContentSize().width- 5)*(i-1),iconheight/2)
		self.IconStar:addChild(sprite)
	end
end

function GetItemPanle:setCountImage( count )
	-- body
	if count>1 then 
		self.imgCount:setVisible(true)
		self.imgCount:loadTexture(res.font.LUCKY[count-1])
	else
		self.imgCount:setVisible(false)
	end	
end

function GetItemPanle:setLinevis( ... )
	-- body
	self.line:setVisible(false)
end

-- flag2 是宝箱开启 
function GetItemPanle:setData( data_ ,flag ,flag2,flag3)
	self.data=data_
	--printt(self.data)
	local type=conf.Item:getType(self.data.mId)
	self.Item_type=type
	if flag then 
		local propertys = vector2table(self.data.propertys,"type")
		self.data.propertys = propertys		
	end
	self.spr2:setVisible(false)
	self.BtnFrame:setVisible(false)
	if flag2 then 
		--self.BtnFrame:setVisible(true)	
	else
		--self.spr2:setVisible(true)
	end	

	self.imgCount:setVisible(false)
	local lv=conf.Item:getItemQuality(self.data.mId)--品级
	--print("cao  ni mei a "..lv )
	local name=conf.Item:getName(self.data.mId,self.data.propertys)
	
	if self.Item_type == pack_type.SPRITE then
		local node = pet.new(self.data.mId,self.data.propertys)
		
		node.node:setScale(res.card.choujiang[tostring(lv)])
		

		local posx,posy = self.spr2:getPosition()
		node:setPosition(posx,posy+15)
		self.view:addChild(node,100)
		self.view:reorderChild(self.imgCount,200)
		self.view:reorderChild(self.IconStar,200)
		if not flag3 then 
			self:setCountImage(self.data.amount)

		else
			name = name.."x"..self.data.amount
			self:setCountImage(1)
		end
		--end
	else
		name = name.."x"..self.data.amount
		self.BtnFrame:setVisible(true)
		if self.Item_type == pack_type.EQUIPMENT then 
			if flag3 then 
				self:setCountImage(1)
			else
				self:setCountImage(self.data.amount)
			end
			
		end 
	end	
	local path=conf.Item:getItemSrcbymid(self.data.mId,self.data.propertys)
	self:setBImage(path)
	
	self:setFrameQuality(lv)
	self.LabName:setColor(COLOR[lv])

	
	self:addStar(lv)
	
	self:setName(name)

	--[[local path=mgr.PathMgr.getItemImagePath(itemSrc)
	if path then
		self:setBImage(path)
		self:setBImage2(path)
	end]]--


	--是否暴击
	if data_.bj and data_.bj > 0 then
		self.view:getChildByName("Image_1"):setVisible(true)
	end
	
	
end


return GetItemPanle