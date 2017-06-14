local CollisionRect = class("CollisionRect",function ()
	return cc.DrawNode:create()
end)

function CollisionRect:ctor( rect )
	local points={
	cc.p(rect.x,rect.y),
	cc.p(rect.x+rect.width,rect.y),
	cc.p(rect.x+rect.width,rect.y+rect.height),
	cc.p(rect.x,rect.y+rect.height),
	}
	local table={}
	table.fillColor=cc.c4f(1,0,0,0.5)
	table.borderColor=cc.c4f(0,0,1,1)
	table.borderWidth=2
	self:drawPolygon(points,table)
end

return CollisionRect