--
-- Author: Your Name
-- Date: 2015-08-07 20:35:20
--


local ChatSensitiveWordsConf = class("ChatSensitiveWordsConf", base.BaseConf)

function ChatSensitiveWordsConf:init(  )
	-- body
	local data = require("res.conf.filter_text")
	--dump(self.conf)
	data = data["filter"]
	self.words = {}

	---------将敏感字符，以键值的形式存储
	for i=1,#data do
		self.words[data[i]] = data[i]
	end

	self.chatSensitiveWords = require("res.conf.SensitiveWorlds")

	--local temData = require("res.conf.SensitiveWorlds")
	-- for k1,v1 in pairs(temData) do
	-- 	if type(v1) == "table" then
	-- 		for k2,v2 in pairs(v1) do
	-- 			if type(v2) == "table" then
	-- 				for k3,v3 in pairs(v2) do
	-- 					self.chatSensitiveWords[v3] = v3
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end

	--dump(self.chatSensitiveWords)
	
end

function ChatSensitiveWordsConf:isContentSpecialChar( msg )

		local len = string.len(msg)
		for i=1,len - 1 do
			for j=i+1,len do
				local subWords = string.sub(msg, i,j)
				--local subLen = string.utf8len(subWords)
				if subWords and self.words[subWords] then
					return true
				end
			end
		end

	return false

end

function ChatSensitiveWordsConf:checkChatWords( msg )
	
	-- 	local len = string.len(msg)
	-- 	for i=1,len - 1 do
	-- 		for j=i+1,len do
	-- 			local subWords = string.sub(msg, i,j)
	-- 			if subWords and (self.words[subWords] or self.chatSensitiveWords[subWords] )then
	-- 				return true
	-- 			end
	-- 		end
	-- 	end
	-- return false

	local data = {}
	local weight = 0
	for i,v in pairs(self.chatSensitiveWords) do
		local s,e = string.find(msg, v["pattern"])
		if s and e then
			weight = weight + v["weight"]
			data[#data + 1] = v
		end
	end

	if weight >= 1 then
		return true
	end

	return false

end







return ChatSensitiveWordsConf