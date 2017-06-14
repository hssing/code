--
-- Author: Your Name
-- Date: 2015-08-10 16:12:45
--


local FriendCache = class("FriendCache", base.BaseCache)


function FriendCache:init( )
	-- body
	self.data = {}
	self.data[1] = {}
	self.data[2] = {}
	self.data[3] = {}

	self.close = false
end

---保存好友数据
function FriendCache:saveFriendData( data )
	-- body
	self.data = data
end

-----读取好友数据
function FriendCache:readFriendData(  )
	-- body

	return self.data
end

------------保存是否从 好友、聊天界面跳转到 阵容对比界面
function FriendCache:jumpToAthleticComp( flag )
	-- body
	self.jumped = flag
end

function FriendCache:getJumpFlag(  )
	-- body
	return self.jumped
end
--只是关闭对比界面
function FriendCache:setOnlyClose( flag )
	-- body
	self.close = flag
end

function FriendCache:getOnlyClose( ... )
	-- body
	return self.close
end










return FriendCache