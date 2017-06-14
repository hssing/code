--
-- Author: Your Name
-- Date: 2015-07-29 20:31:22
--
require("json")

--local srcPath = "res/views/ui_res/face/"
local srcPath = res.btn.FACIALICONPATH
local bgPath = "res/views/ui_res/face/dialog_box.png"
local WIDTH = 300

local MessageItem = class("MessageItem",function(  )
	-- body
	--return cc.Menu:create()
	return ccui.RichText:create()
end)


function MessageItem:init(data,maxWidth,minWidth,minHeight)
	-- body
-- <msg>
-- 	<text>terttre</text>
-- 	<img><img>
-- <msg>
	
	self.data = data
	-- {
	-- 	{text="7",fontName="",size=22,color={244,34,34}},
	-- 	{image="res/views/ui_res/icon/icon_addFace.png"},
	-- 	-- {text="tertetretteteery",fontName="",size=22,color={0,255,34}},
	-- 	-- {image="res/views/ui_res/icon/icon_addFace.png"},
	-- 	-- {text="tertetretteteery",fontName="",size=34,color={244,34,34}},
	-- 	-- {image="res/views/ui_res/icon/icon_addFace.png"},
	-- 	-- {text="tertetretteteery",fontName="",size=34,color={0,0,255}},
	-- 	-- {image="res/views/ui_res/icon/icon_addFace.png"},
	-- 	-- {text="tertetretteteery",fontName="",size=34,color={244,34,34}},
	-- 	-- {image="res/views/ui_res/icon/icon_addFace.png"},
	-- }
	self.maxWidth = maxWidth
	self.minWidth = minWidth
	self.minHeight = minHeight
	self:initView()

	self:setContentSize(self:getRealSize())
	self:ignoreContentAdaptWithSize(false)

	return self

end

function MessageItem:initWithStr(data,maxWidth,minWidth,minHeight )
	-- body
	local tableData = self:encodeStr2Table(data)

	return self:init(tableData,maxWidth,minWidth,minHeight)

end


-------------------使用 <img></img>的标签来标示图片

function MessageItem:encodeStr2Table( msg )
	-- body
	local i = 0
	local j = 0
	local textIdx = 1
	local imgIdx = 1
	local msgData = {}
	repeat
		i,j = string.find(msg,"%[%d%d%]",j+1)

		

		if i and j then
			local img = string.sub(msg, i,j)
			local text = string.sub(msg, textIdx,i-1)
			textIdx = j + 1
			local TextTable = {}
			if text ~= "" then
				TextTable.text = text
				table.insert(msgData,TextTable)
			end


			local ImgTable = {}
			local x,y = string.find(img, "%d%d")
			ImgTable.name = string.sub(img, x,y)
			table.insert(msgData,ImgTable)
		else
			local text = string.sub(msg, textIdx,string.len(msg))
			local TextTable = {}
			if text ~= "" then
				TextTable.text = text
				table.insert(msgData,TextTable)
			end
			break
		end

	until false

		return msgData

end


function MessageItem:initView( )
		-- body

		for i=1,#self.data do
		
			local data = self.data[i]
			if data.text and string.len(data.text) > 0  then
				--todo
				local fontName 
				local fontSize
				local opacity
				local color

				--字体颜色
				if data.color then
					color = cc.c3b(data.color[1],data.color[2],data.color[3])
				else
					--todo
					color = cc.c3b(255,255,255)
				end

				--字体名称
				if data.fontName then
					--todo
					fontName = data.fontName
				else
					--todo
					fontName = res.ttf[1]
				end

				--字体大小
				if data.size then
					--todo
					fontSize = data.size
				else
					--todo
					fontSize = 22
				end
				--透明度
				if data.opacity then
					opacity = data.opacity
				else
						--todo
					opacity = 255
				end

				local textEle = ccui.RichElementText:create(1,color,opacity,data.text,fontName,fontSize)
				self:pushBackElement(textEle)

			elseif data.name then
				--todo
				local fileName = res.btn.FACIALICONPATH .. data.name .. ".png"

				if not cc.FileUtils:getInstance():isFileExist(fileName) then
					local textEle = ccui.RichElementText:create(1,cc.c3b(255,255,255),255,"["..data.name.."]",
						res.ttf[1],22)
					self:pushBackElement(textEle)
					--G_TipsOfstr("表情资源不存在")
				else
					local imageEle = ccui.RichElementImage:create(2,cc.c3b(0,0,0),255,fileName)
					self:pushBackElement(imageEle)
					
				end

			end

		end	

end

function MessageItem:addBg(  )
	-- body
end

function MessageItem:getRealSize( )
	-- body
	self:formatText()
	local renderSize = self:getVirtualRendererSize()
		--如果文本长度小于气泡长度，

	if renderSize.width <= self.minWidth then
		--todo
		--dump(cc.size(self.minWidth,self.minHeight))
		return cc.size(self.minWidth,self.minHeight)
	else
		--todo
		local lineNum =math.ceil(renderSize.width / self.maxWidth)
		local height = lineNum * renderSize.height
		if lineNum > 1 then
			--height = height + lineNum * 10
		end
		local width = renderSize.width

		if width >= self.maxWidth then
			width = self.maxWidth
		end

		if height < self.minHeight then
			--todo
			height = self.minHeight
		end


		return cc.size(width,height)
	end
end


return MessageItem