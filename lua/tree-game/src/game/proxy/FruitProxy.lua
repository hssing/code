--
-- Author: Your Name
-- Date: 2015-12-17 17:08:43
--

local FruitProxy = class("FruitProxy", base.BaseProxy)

function FruitProxy:init(  )
	-- body
	self:add(525001,self.reqFruitinfoCallback)
	self:add(525002,self.reqFluitComposeCallback)
	self:add(525003,self.reqSellProCallbacl)

end


function FruitProxy:reqFruitinfo( findex,pageType )
	-- body
	self.fIdx = findex
	self.pageType = pageType
	self:send(125001,{fIndex = findex,pageType = pageType})
	--self:wait(525001)
end


function FruitProxy:reqFruitinfoCallback( data )
	printt(data)
	print("==========reqFruitinfoCallback==============")
	if data.status == 0 then
		data.fIdx = self.fIdx
		local view = mgr.ViewMgr:get(_viewname.FRUIT_COMPOSE_PAGE)
		if view then
			view:setData(data)
		else 
			local view1 = mgr.ViewMgr:showView(_viewname.FRUIT_COMPOSE_PAGE)
			if view1 then
				view1:setData(data)
			end
		end

		
	end
end


function FruitProxy:reqFluitCompose(fruitHole,idx )
	-- body
	self:send(125002,{fruitHoleId = fruitHole,fightSeq = idx})
	self:wait(525002)
end

function FruitProxy:reqFluitComposeCallback( data )
	if data.status == 0 then
		--合成成功，关闭界面
		local view = mgr.ViewMgr:get(_viewname.FRUIT_COMPOSE)
		if view then
			view:closeSelfView()
		end

		local view =  mgr.ViewMgr:get(_viewname.FRUIT_COMPOSE_PAGE)
		if view then
			view:composeCallback(data)
		end


	end
end

function FruitProxy:reqSellPro( index,num )
	-- body
	self:send(125003,{index = index,num = num})
	self:wait(525003)
end

function FruitProxy:reqSellProCallbacl( data )
	 if data.status == 0 then
	 	local view = mgr.ViewMgr:get(_viewname.FRUIT_COMPOSE_SELL)
	 	if view then
	 		view:sellSucc()
	 	end
	 end
end



return FruitProxy