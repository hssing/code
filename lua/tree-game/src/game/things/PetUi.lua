--宠物形象
local PetUi =class("PetUi",function ()
	return display.newSprite()
end)

local _rootPath ="res/cards/"
local _suffix = ".png"

function PetUi:ctor(id,propertys,src)
	local path_id

	if id and propertys and conf.Item:getType(id) == pack_type.SPRITE then
		_rootPath ="res/cards/"
		path_id=conf.Item:getModel(id,propertys)
	elseif id and propertys and conf.Item:getType(id) == pack_type.PRO then 
		_rootPath = "res/itemicon/"
		path_id=conf.Item:getModelPro(id)
	else
		path_id=src
	end
	local node= cc.Sprite:create(_rootPath..path_id.._suffix)
	--print("path_id = "..path_id)
	if not node then
		--print("id "..path_id)
		node = cc.Sprite:create("res/itemicon/".."202010003".._suffix)
	end
	self:setContentSize(node:getContentSize())
	node:setAnchorPoint(cc.p(0.5,0.5))
	node:setPosition(node:getContentSize().width/2,node:getContentSize().height/2)
	self:setAnchorPoint(cc.p(0.5,0.5))
	self.node=node

	-- self.drawNode = cc.DrawNode:create()
	-- self:addChild(self.drawNode,255)	
	-- self.drawNode:clear()
	-- local points={
	-- cc.p(self:getPositionX(),self:getPositionY()),
	-- cc.p(self:getPositionX()+self:getContentSize().width,self:getPositionY()),
	-- cc.p(self:getPositionX()+self:getContentSize().width,self:getPositionY()+self:getContentSize().height),
	-- cc.p(self:getPositionX(),self:getPositionY()+self:getContentSize().height),
	-- }

	-- local table={}
	-- table.fillColor=cc.c4f(1,0,0,0.5)
	-- table.borderColor=cc.c4f(0,0,1,1)
	-- table.borderWidth=2
	
	-- self.drawNode:drawPolygon(points,table)

	self:addChild(node)
end
function PetUi:isColl( pos )
	local pp=self.node:getPosition()
	local spr_pos=self.node:getParent():convertToWorldSpace(cc.p(self.node:getPositionX(),self.node:getPositionY()))
	local spr_x=spr_pos.x
	local spr_y=spr_pos.y

	local spr_w=self.node:getContentSize().width
	local spr_h=self.node:getContentSize().height

	if pos.x < (spr_x-spr_w*3/8) or  pos.x > (spr_x+spr_w*3/8) or pos.y < (spr_y-spr_h*3/8) or pos.y > (spr_y + spr_h*3/8) then
		return false
	end
	return true
end
function PetUi:init()

end


















return PetUi