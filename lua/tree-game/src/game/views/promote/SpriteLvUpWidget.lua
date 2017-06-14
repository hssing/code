local pet= require("game.things.PetUi")

local SpriteLvUpWidget=class("SpriteLvUpWidget",
	function (  )
	-- body
	return ccui.Widget:create()
end)
function SpriteLvUpWidget:ctor(  )
	self._exp   =   nil   ---  获得的经验值
end


local offsetX=50

local offsetY=-190
local __WidgetPos =
{
	cc.p(257+offsetX,543+offsetY),
	cc.p(105.78+offsetX,490+offsetY),
	cc.p(408.64+offsetX,490.45+offsetY),
	cc.p(96.95+offsetX,395.96+offsetY),
	cc.p(438.93+offsetX,396.68+offsetY),
	cc.p(263.40+offsetX,355+offsetY),
}


function SpriteLvUpWidget:init(_parent,pos)
	self._pos=pos
	self._showName = false
	self._parent = _parent
	self.view=_parent:getWidgetClone()
	self.view:setVisible(true)
	self:setContentSize(self.view:getContentSize())
	self.view:setPosition(0,0)
	self:addChild(self.view)

	self.Button=self.view:getChildByName("Button_12_42")
	self.Button:addTouchEventListener(handler(self,self.onCallBack))
	self.Button:setOpacity(0)

	self.Panel_name=self.view:getChildByName("Panel_name")
	self.LabelName=self.Panel_name:getChildByName("Text_pet_name") --宠物名字

	self.Image=self.view:getChildByName("Image_7_39") --从无
	self._pet = nil 
	self:showName(false)
	self:setPosition(__WidgetPos[pos])
	if pos < 6 then 
		self:addandplay()
	end 
end

function SpriteLvUpWidget:setbtnabel(flag )
	-- body
	self.Button:setTouchEnabled(flag)
end

function SpriteLvUpWidget:getPet( )
	-- body
	return self._pet
end

function SpriteLvUpWidget:addandplay()
	-- body
	if not self.view:getChildByName("effofname") then 
		local params =  {id=404808, x=self.view:getContentSize().width/2,
		y=self.view:getContentSize().height/2,
		addTo=self.view,
		endCallFunc=nil,
		from=nil,to=nil, 
		playIndex=0,
		addName = "effofname"}
		mgr.effect:playEffect(params)
	end 

end
function SpriteLvUpWidget:removeEff()
	if self.view:getChildByName("effofname") then 
		self.view:getChildByName("effofname"):removeFromParent()
	end 
end 


function SpriteLvUpWidget:onCallBack( send,enenttype )
	if enenttype ==  ccui.TouchEventType.ended then
		local needexp = self._parent:getNeedExp()
		--print("islimitLV")
		if not self._parent:islimitLV()  then--看看是不是满级
			local view=mgr.ViewMgr:createView(_viewname.DEVOUR_MATERIAL)
			--[[if self._parent.is_stone then
				self._parent:cleanSelectPet()
			end]]--
			---print("o my lea ")
			local  data = {}
			for i = 1 , #EXP_STONE_ID do 
				local tab  = cache.Pack:getItemAllitemByMid(pack_type.PRO,EXP_STONE_ID[i])

				for k ,v in pairs(tab) do 
					for j = 1 , v.amount do
						local dd = clone(v) 
						dd.cout = j.."_"..i
						--print(dd.cout)
						table.insert(data,dd)
					end 
				end 	
			end
			--printt(self._parent:getSelectPetList())
			view:setSelectPetListData(self._parent:getSelectPetList())
			view:setData(self._parent:getAllQualityData(),data)
			view:setNeedExp(needexp)
			view:addCallBack2(handler(self._parent, self._parent.Canlv))
			mgr.ViewMgr:showView(_viewname.DEVOUR_MATERIAL)
			mgr.SceneMgr:getMainScene():closeHeadView()
		end
	end
end

function SpriteLvUpWidget:showName( bl )
		self._showName=bl
		self.Panel_name:setVisible(bl)
end
function SpriteLvUpWidget:restoreSize(  )
	 self.Image:setScaleX(1)
	 self.Image:setScaleY(1)
end
function SpriteLvUpWidget:setData( data )
	self.data=data

	if self.view:getChildByName("effofname") then 
		self.view:getChildByName("effofname"):removeFromParent()
	end 

	local lv=conf.Item:getItemQuality(data.mId)
	local name=conf.Item:getName(data.mId,data.propertys)
	self:setName(name,lv)
	self:addPet(self.data)
end

function SpriteLvUpWidget:setName( name,lv )
	self.LabelName:setString(name)
	self.LabelName:setColor(COLOR[lv])
end

--还原
function SpriteLvUpWidget:restore(  )
	-- body
	self:removePetData()
	self.data = nil 
end
--获得自己的位置
function SpriteLvUpWidget:getPos()
	return self._pos
end

function SpriteLvUpWidget:setBtnVisisble( visible )
	--self.Button:setVisible(visible)
end
-- 所获得的经验
function SpriteLvUpWidget:getExp(  )
		return self._exp
end
function SpriteLvUpWidget:addPet( data)
	self.data=data
	if self._pet  then
		self._pet:removeFromParent()
		self._pet=nil
	end
	--self.Button:setVisible(false)
	local node=pet.new(data.mId,data.propertys)
	--node.node:setScale(0.6)

	local color = conf.Item:getItemQuality(data.mId)
	node.node:setScale(res.card.jinghua[tostring(color)])
	node:setPosition(60,60)
	self._pet=node
	self.view:addChild(node)
end
function SpriteLvUpWidget:getData(  )
	return self.data
end
function SpriteLvUpWidget:removePetData()
	if self._pet  then
		self._pet:removeFromParent()
		self._pet=nil
	end
	self:addandplay()
	self.Button:setVisible(true)
end
--是否已经存在
function SpriteLvUpWidget:isExist()
	if self._pet  then
		return true
	end
	return false
end
return SpriteLvUpWidget