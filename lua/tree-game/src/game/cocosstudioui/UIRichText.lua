local UIRichText = class("UIRichText",function ( ... )
	return cc.Node:create()
end)

local lable_path = res.ttf[1]

function UIRichText:ctor()
	--文本列表容器
	self._ListText = {}
	self._TextSize = nil
    self._LineLabelNode = {}
    self._Line = 1
    self.MaxHList =  {}
    self:setContentSize(100,100)
end

function UIRichText:pushBackElement( tabletext )
	local lenght = #self._ListText+1
	self:insertElement(tabletext,lenght)
end
function UIRichText:insertElement(tabletext,index)
	table.insert(self._ListText,index,tabletext)
end


function UIRichText:formatText()
    local starx = 0
    local stary = 0
    local maxwidth = self._TextSize.width
    local maxHeight= self._TextSize.height
    local maxH = 0

	for i=1,# self._ListText do
		local r_text =  self._ListText[i]
        local get_label = self:createLable(r_text.text,r_text.fontSize,maxwidth - starx)
        -- print("size:"..#get_label)
        for i=1,#get_label do
            local label__ = get_label[i]
            label__:setAnchorPoint(cc.p(0,0.5))
            label__:setPosition(starx,0)
            if r_text.color then
                  label__:setColor(r_text.color)
            end
            local h = label__:getContentSize().height
            local w = label__:getContentSize().width
            if maxH == 0 then
                maxH = h
            else
                maxH = math.max(maxH,h)
            end
            if starx + w > maxwidth then
                starx = 0
                self.MaxHList[# self.MaxHList+1]=maxH
                self._Line = self._Line +1
                maxH = h
            end
            if not self._LineLabelNode[self._Line] then
                self._LineLabelNode[self._Line]=cc.Node:create()
                self:addChild(self._LineLabelNode[self._Line])
            end
            label__:setPositionX(starx)
            starx = starx + label__:getContentSize().width
            self._LineLabelNode[self._Line]:setContentSize(0,maxH)
            self._LineLabelNode[self._Line]:addChild(label__)
        end
	end
    local hh = 0
    for i=1,#self._LineLabelNode do
         self._LineLabelNode[i]:setPosition(0,hh-self._LineLabelNode[i]:getContentSize().height/2)
        hh = hh - self._LineLabelNode[i]:getContentSize().height
    end
    self:setContentSize(cc.size(self._TextSize.width,math.abs(hh)))

    -- local rect  =cc.rect(0,0,self._TextSize.width,-self._TextSize.height)

    -- local draw = require("game.cocosstudioui.CollisionRect").new(rect)

    -- self:addChild(draw)
end
function UIRichText:setContentSize( width, height)
        if  height ~= nil then 
		   self._TextSize = cc.size(width,height)
        else
            self._TextSize = width
         end
end
function UIRichText:getContentSize(  )
        return self._TextSize 
end
function UIRichText:getLineSting(str,maxwidth,fontsize)
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local  lenght=str:len()
    local pos=1
    local width=0
    local stringSize=0
    while pos<=lenght do
        local l=0
        if string.byte(str,pos) >= arr[5] then
            l=5
            width=fontsize
        elseif string.byte(str,pos) >= arr[4] then
            l=4
             width=fontsize
        elseif string.byte(str,pos) >= arr[3] then
            l=3
             width=fontsize
        elseif string.byte(str,pos) >= arr[2] then
            l=2
             width=fontsize
        elseif string.byte(str,pos) >= arr[1] then
            l=1
             width=fontsize/2
        end
        stringSize=stringSize+width
        if stringSize > maxwidth then
        	return string.sub(str,1,pos-1),pos
        end
        pos=pos+l
    end
    return str,lenght
end

function UIRichText:createLable(str,fontsize,maxwidth)

	local _label = {}
	local s_length = str:len()
	local start_pos = 1
	local end_pos = 1
     local Intercept_str=string.sub(str,start_pos,s_length)
	-- local maxwidth = self._TextSize.width
	
	while start_pos <  s_length do
		local str__,string_pos=self:getLineSting(Intercept_str,maxwidth,fontsize)

		end_pos = string_pos -1

		_label[#_label+1] =  cc.Label:createWithTTF(str__, lable_path, fontsize, cc.size(0,0))

		 maxwidth = self._TextSize.width
        -- str = string.sub(str,end_pos +1,s_length)
        start_pos = start_pos + end_pos 

        -- print("str__"..str__)

        Intercept_str=string.sub(str,start_pos,s_length)
	end
	return _label


	 -- if cc.FileUtils:getInstance():isFileExist(font) then
  --       label = cc.Label:createWithTTF(text, font, size, dimensions, textAlign, textValign)
  --       if label then
  --           label:setColor(color)
  --       end
  --   else
  --       label = cc.Label:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
  --       if label then
  --           label:setTextColor(color)
  --       end
  --   end
end















return UIRichText