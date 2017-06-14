--[[
	探险 界面boss 死亡后获得物品 最多是3个
]]

local AdvgetItemview=class("AdvgetItemview",base.BaseView)

function AdvgetItemview:ctor()

end

function AdvgetItemview:init()
	self.showtype=view_show_type.TOP
	self.view=self:addSelfView()

	self.rewardlist = {}
	local size = 3 
	for i = 1 , 3 do 
		local  Button_frame =self.view:getChildByName("Button_frame"..i)
		local  spr = Button_frame:getChildByName("img_head"..i)
		--spr:ingnore
		local  name = Button_frame:getChildByName("Txt_name"..i) 
		self.rewardlist[i] = {}
		self.rewardlist[i].Button_frame = Button_frame
		self.rewardlist[i].spr = spr
		self.rewardlist[i].name = name
	end	

	local btn = self.view:getChildByName("Button_Sure")
	btn:addTouchEventListener(handler(self, self.closelayer))

	self.text = self.view:getChildByName("Text_27")
	self.text:setVisible(false)

	self:initDec()
end
function AdvgetItemview:initDec()
	-- body
	self.view:getChildByName("Button_Sure"):setTitleText(res.str.SURE)
end

--设置奖励
function AdvgetItemview:setData(data)
	-- body
	for i = 1 , #self.rewardlist do 
		local v = self.rewardlist[i]
		v.Button_frame:setVisible(false)
	end

	if data then 
		for k ,v in pairs(data) do 
			--print("k = "..k)
			local type=conf.Item:getType(v.mId)
			local lv=conf.Item:getItemQuality(v.mId)
			local name=conf.Item:getName(v.mId,v.propertys)
			--local itemSrc=conf.Item:getSrc(v.mId)
			local path =  conf.Item:getItemSrcbymid(v.mId,v.propertys)
			--[[local path=mgr.PathMgr.getItemImagePath(itemSrc)
			if type == pack_type.SPRITE then
				mgr.PathMgr.getImageHeadPath(itemSrc)
			end ]]--

			local framePath=res.btn.FRAME[lv]
			self.rewardlist[k].Button_frame:setVisible(true)
			self.rewardlist[k].Button_frame:loadTextureNormal(framePath)
			self.rewardlist[k].name:setColor(COLOR[lv])
			self.rewardlist[k].name:setString(name)
			self.rewardlist[k].spr:loadTexture(path)
		end
	end
end

function AdvgetItemview:setTextbytable( params_ )
	-- body
	local richText = G_RichText(params_)
	--richText:setAnchorPoint(0,0.5)
	richText:setPosition(-self.text:getPositionX()/2,self.text:getPositionY())
	self.view:addChild(richText,10000)
end


function AdvgetItemview:closelayer(sender,eventtype)
	-- body
	if ccui.TouchEventType.ended  == eventtype then
		self:closeSelfView()
	end
end

return AdvgetItemview