local BaseThing = class("BaseThing",function()
    return display.newNode()
end)

BaseThing._FILTERS = {
        -- colors
        {"GRAY",{0.2, 0.3, 0.5, 0.1}},
        {"RGB",{1, 0.5, 0.3}}, -- 可以
        {"HUE", {90}},
        {"BRIGHTNESS", {0.3}},
        {"SATURATION", {0}},--5
        {"CONTRAST", {2}},----------
        {"EXPOSURE", {1}},----------ok
        {"GAMMA", {2}},
        {"HAZE", {0.1, 0.2}},
        -- blurs
        {"GAUSSIAN_VBLUR", {70}}, --10
        {"GAUSSIAN_HBLUR", {7}},
        {"ZOOM_BLUR", {4, 1.3, 1.3}},
        {"MOTION_BLUR", {5, 135}},
        -- others
        {"SHARPEN", {1, 1}},
        {{"GRAY", "GAUSSIAN_VBLUR", "GAUSSIAN_HBLUR"}, {nil, {10}, {10}}},
        {{"BRIGHTNESS", "CONTRAST"}, {{0.1}, {4}}},
        {{"HUE", "SATURATION", "BRIGHTNESS"}, {{240}, {1.5}, {-0.4}}},
}

function BaseThing:ctor(id_)
    self._cardId = id_
    ---大小
    self._box = nil
    ---特效下层
    self._bottomEffLayer = display.newNode()
    self:addChild(self._bottomEffLayer)
    ---脚下信息
    self._footNode = display.newNode()
    self:addChild(self._footNode)
    ---身体层
    self._bodyNode = display.newNode()
    self:addChild(self._bodyNode)
    self._bodyNode:setCascadeOpacityEnabled(true)
    ---动作管理    
    self._actionMgr = mgr.playerAction.new(self)
    self._playerName = ccui.Text:create("",res.ttf[1],24)
    local isScale = true
    self.pScale = G_CardScale(id_)
    -- if cache.Fight:getType() == 1 then
    --     local fData = cache.Fight:getData()
    --     local fConf = conf.Copy:getFbInfo(fData.sId)
    --     local list = fConf.boss_id or {}
    --     for i=1, #list do
    --         local id = conf.Card:getModel(list[i].."")
    --         if id.."" == id_ then
    --             isScale = false
    --             break
    --         end
    --     end
    -- end
    -- if isScale == true then
    --     self.pScale = G_CardScale(id_)
    -- end
    self._imgSource = "res/cards/"..id_..".png"
    self:createBodyImg(self._imgSource)
    ---头顶信息
    self:addChild(self._playerName)
    self._headNode = display.newNode()
    self:addChild(self._headNode)
    self._playerName:setString(conf.Card:getName(id_))
    
    ---特效上层
    self._topEffLayer = display.newNode()
    self:addChild(self._topEffLayer)

    --self:showFilter(12)
end

---------------------
---- public
---------------------
function BaseThing:thingScale(id_)
    if cache.Fight:getType() == 1 then
        local fData = cache.Fight:getData()
        local fConf = conf.Copy:getFbInfo(fData.sId)
        local list = fConf.boss_id or {}
        for i=1, #list do
            local id = conf.Card:getModel(list[i].."")
            if id.."" == id_ then
                self.pScale = 0.8
                self.body:setScale(self.pScale)
                break
            end
        end
    end   
end

---获取卡牌id
function BaseThing:getCardId()
    return self._cardId
end

---------------------------
--创建骨骼
--@param id_ 
function BaseThing:createBone(id_)
    mgr.BoneLoad:addLoad(id_, function()
        self.body = ccs.Armature:create()
        self.body:init(id_)
        self._box = self.body:getBoundingBox()
        self._bodyNode:addChild(self.body)
        self.body:getAnimation():play("idle")
        self:_createHeadBar()
        self:playAction(1001)
    end)
end

---------------------------
--创建图片
function BaseThing:createBodyImg(imgName_)
    self.body = display.newSprite(imgName_,{scale9=true})
    self._bodyNode:addChild(self.body)
    self.body:setScale(self.pScale)
    self._box = self.body:getBoundingBox()
    --self.body:setAnchorPoint(0,0)
    self.body:setPositionY(self._box.height/2)
    self:_createHeadBar()
    self:playAction(1001)
    self._playerName:setPositionY(self._box.height)
end

function BaseThing:showFilter(index_, delay_)
    --self.body:setVisible(false)
    if self._filterSprite then
        self._filterSprite:removeSelf()
        self._filterSprite = nil
    end
    local curFilter = BaseThing._FILTERS[index_]
    local filters, params = unpack(curFilter)
    if params and #params == 0 then
        params = nil
    end
    self._filterSprite = display.newFilteredSprite(self._imgSource, filters, params)
        :addTo(self._bodyNode, 10)
    self._filterSprite:setScale(self.pScale)
    self._filterSprite:setAnchorPoint(cc.p(0, 0))
    local ret = self._filterSprite:getBoundingBox()
    self._filterSprite:setPosition(-ret.width/2, 0)
    local delay = cc.DelayTime:create(delay_ or 0.1)
    local callFun = cc.CallFunc:create(function()
        if self._filterSprite then
            self._filterSprite:removeSelf()
            self._filterSprite = nil
        end
        self.body:setVisible(true)
    end)
    local seq = cc.Sequence:create(delay, callFun)
    self:runAction(seq)
end

---------------------------
--播放动作
--@param id_ 
function BaseThing:playAction(action_, params_)
    if self.body then
        self._actionMgr:changeAction(action_, params_)
    end    
end


---------------------------
--获取角色中心点
function BaseThing:getCenterH()
    if self._box then
        return self._box.height/2
    end
    return 60
end

---------------------------
--销毁
function BaseThing:dispose()
    self:removeFromParent()
end

---------------------
---- private
---------------------

---------------------------
--创建头顶信息|子类重写
function BaseThing:_createHeadBar()
end

return BaseThing