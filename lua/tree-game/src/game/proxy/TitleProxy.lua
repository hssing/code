--
-- Author: Your Name
-- Date: 2015-09-09 12:00:59
--

local TitleProxy = class("TitleProxy", base.BaseProxy)

function TitleProxy:init(  )

	self:add(501301,self.reqTitleCallback)--请求称号
	self:add(501303,self.reqHeadIconCallback)--请求头像

	self:add(501302,self.reqReplaceTitleCallback)--请求佩戴称号
	self:add(501304,self.reqReplaceHeadCallback)--请求更换头像
end



--请求称号
function TitleProxy:reqTitle( )
	self:send(101301)
	self:wait(501301)
end

function TitleProxy:reqTitleCallback( data )
	-- body
	if data.status == 0 then
		local view = mgr.ViewMgr:showView(_viewname.TITLE)
		if view then
			view:setData(data)
		end
	end                   
   
end



--请求佩戴称号
function TitleProxy:reqReplaceTitle( id )
	self:send(101302,{titleId = id })
end

function TitleProxy:reqReplaceTitleCallback( data )
	if data.status == 0 then
		local view = mgr.ViewMgr:get(_viewname.TITLE)
		if view then
			view:changeTileSucc()
		end

		cache.Player:setRoleTitle(data.titleId)

		local view = mgr.ViewMgr:get(_viewname.ROLE)
		if view then
			view:updateUi()
		end
	end
end



--请求头像
function TitleProxy:reqHeadIcon(  )
	self:send(101303)
	self:wait(501303)
end

function TitleProxy:reqHeadIconCallback( data )
	if data.status == 0 then
		 --头像选择  
		local view = mgr.ViewMgr:showView(_viewname.SELECT_HEAD)
		if view then
			view:setData(data)
		end
	end
end




--请求更换头像
function TitleProxy:reqReplaceHead( hId )
	self:send(101304,{headId = hId})
end


function TitleProxy:reqReplaceHeadCallback( data )
	if data.status == 0 then
		 --头像选择  
		local view = mgr.ViewMgr:get(_viewname.SELECT_HEAD)
		if view then
			view:changeHeadSucc()
		end

		local view = mgr.ViewMgr:get(_viewname.ROLE)
		if view then
			view:changeHeadSucc(data["headId"])
		end

		local id = cache.Player:getRoleSex() * 100000 + data["headId"]
		cache.Player:setHead(id)
		local  view = mgr.ViewMgr:get(_viewname.HEAD)
		if view then
			view:updateUi()
		end

		G_TipsOfstr(res.str.HEAD_TIPS1)
	end
end




return TitleProxy