--[[--
图片文字
]]

local BaseNum = class("BaseNum", function()
    return display.newBatchNode(res.texture["num"]..".png")
end)


---------------------------
--创建数字图片
--@param {value(数字值)，type(图片类型，默认numA),spacing(图片间距)}
function BaseNum:ctor(params)--value,type)
    self.type = params.type or "numA"
    self.spacing = params.spacing or 0
    self:createNumImg(params.value)
    self:setCascadeOpacityEnabled(true)
end

---------------------------
--创建图片
function BaseNum:createNumImg(value)
    if value then
        if self.numList then
            for key, var in pairs(self.numList) do
                var:removeFromParent()
            end
        end
        self.numList = {}
        local imgWidth = 0
        local newValue = value .. ""
        local length = string.len(newValue)  
        for i=1, length do
            local newTag = string.sub(newValue,i,i)
            local newName = "#" .. self.type .. "_" .. newTag .. ".png"
            local newNumImg = display.newSprite(newName)
            self:addChild(newNumImg)
            if imgWidth == 0 then
                imgWidth = newNumImg:getContentSize().width + self.spacing
            end
            newNumImg:setPosition(imgWidth*(i-1),0)
            table.insert(self.numList, newNumImg)
        end
    end
end

---------------------------
--设置数据
function BaseNum:setValue(value)
    self:createNumImg(value)
end

function BaseNum:setString(value)
    self:createNumImg(value)
    self:center()
end

---------------------------
--设置数字类型
function BaseNum:setType(value)
    self.type = value
end

---------------------------
--设置间距
function BaseNum:setSpacing(value)
    self.spacing = value
end

---------------------------
--获取大小
--return width,height
function BaseNum:getSize()
    local target = self.numList[#self.numList]
    local targetSize = target:getContentSize()
    return {width = targetSize.width + target:getPositionX(), height = targetSize.height}
end

function BaseNum:center()
    local width = -self.spacing
    local height = 0
    for i = 1, #self.numList do
		local img = self.numList[i]
		img:align(display.LEFT_CENTER)
        img:setPositionX(width)
		local size = img:getContentSize()
        if height == 0 then
            height = size.height
        end
        if i == #self.numList then
            width = width + size.width
        else
            width = width + size.width + self.spacing
        end
	end
	self:setContentSize(cc.size(width,height))
end

return BaseNum