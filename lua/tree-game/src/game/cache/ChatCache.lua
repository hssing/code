--
-- Author: Your Name
-- Date: 2015-08-08 11:12:06
--

local ChatCach = class("ChatCach", base.BaseCache)

function ChatCach:init( )
	-- body
	self.chatData = {}
	self.chatData[1] = {}
	self.chatData[2] = {}
	self.chatData[3] = {}
	self.chatData[4] = {}
	if proxy.Chat then
		proxy.Chat:init()
	end
	if cache and cache.Player then
		cache.Player:_setChatNumber(0)
	end
end

function ChatCach:saveData( chatData )
	-- body
	self.chatData = chatData
end

function ChatCach:readData(  )
	-- body
	if self.chatData == nil then
		--todo
		local data = {}
		data[1] = {}
		data[2] = {}
		data[3] = {}
		data[4] = {}
		return data
	end

	return self.chatData
end

function ChatCach:addData( data,index )

	local len = #self.chatData[index]
	if len >= 20 then
		table.remove(self.chatData[index],1)
		len = len - 1
	end
	self.chatData[index][len + 1] = data
	
end





return ChatCach