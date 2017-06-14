local SelectHeadView=class("SelectHeadView",base.BaseView)

function SelectHeadView:init(  )
	self.view=self:addSelfView()
	self.ListView=self.view:getChildByName("ListView")
	self.Clone_Panel=self.view:getChildByName("Panel_clone")
	self:initAllPanle()
	
	
    G_FitScreen(self,"Image_3")
    
end
function SelectHeadView:getColnePnale()
	return self.Clone_Panel:clone()
end
function SelectHeadView:initAllPanle( data )
	local size=1
	local panle=nil
	local currVip =  checkint(cache.Player:getVip()) == 0  and 1 or checkint(cache.Player:getVip())
	local sex = cache.Player:getRoleSex()

	local headList=conf.head:getItems(currVip,sex)
	table.sort(headList,function( a,b )
		-- body
		 return a.lv < b.lv 
	end)


	for i=1,#headList do 
		local data = headList[i]
		local headpanle=CreateClass("views.role.HeadPanle")
		headpanle:init(self,data.id)
		headpanle:setData(data)
		if size == 1 then
			panle=ccui.Widget:create()
			panle:setContentSize(self.ListView:getContentSize().width,headpanle:getContentSize().height)
			self.ListView:pushBackCustomItem(panle)
		end
		headpanle:setPosition((size-1)*164+headpanle:getContentSize().width/2,headpanle:getContentSize().height/2)
		panle:addChild(headpanle)
		size=size+1
		if size > 3 then
			size=1
		end
	end
	

end




return SelectHeadView