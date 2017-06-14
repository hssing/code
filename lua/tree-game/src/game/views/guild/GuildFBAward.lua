--[[
  --物品获得界面
]]
local GuildFBAward=class("GuildFBAward",base.BaseView)

function GuildFBAward:init()
  self.showtype=view_show_type.TOP
  self.view=self:addSelfView()

  self.btnsure = self.view:getChildByName("Image_bg"):getChildByName("Button_buy_more") 
  self.btnsure:addTouchEventListener(handler(self, self.onbtnSureCallback))


  self:initDec()
 
end

function GuildFBAward:initDec( ... )
    -- body
    self.view:getChildByName("Image_bg"):getChildByName("Text_1"):setString(res.str.GUILD_DEC_15)
    self.btnsure:getChildByName("Text_1_2_4"):setString(res.str.GUILD_DEC_16)
end

function GuildFBAward:setData( data )
    self.data = data
    if data.get == 0 then
        self.btnsure:setEnabled(false)
        self.btnsure:setBright(false)
    end
    local items = data.awards
    local startx = 222 - 160*(#items - 1)
    for i=1, 3 do
        local baseItem = self.view:getChildByName("Panel"):getChildByName("Panel_c_"..i)
        if i>#items then
            baseItem:setVisible(false)
        else
            debugprint("______________________________________[GuildFbAward]:", items[i][1])
            baseItem:setPositionX(startx + 160*(i-1))
            local img = baseItem:getChildByName("Button_frame_"..i):getChildByName("Image_head_"..i)
            local path= conf.Item:getItemSrcbymid(items[i][1])
            img:loadTexture(path)
            local txt = baseItem:getChildByName("Text_name_"..i)
            local str = conf.Item:getName(items[i][1]).."x"..items[i][2]
            txt:setString(str)
            local lv=conf.Item:getItemQuality(items[i][1])
            local framePath=res.btn.FRAME[lv]
            local kuang = baseItem:getChildByName("Button_frame_"..i)
            kuang:loadTextureNormal(framePath)
            txt:setColor(COLOR[lv])
        end    
    end
end

function GuildFBAward:onbtnSureCallback(sender_,eventype )
    if eventype == ccui.TouchEventType.ended then
        mgr.NetMgr:send(117012,{fbId=self.data.fbId})
        self:onCloseSelfView()
    end 
end

function GuildFBAward:onCloseSelfView()
    self:closeSelfView()
end

return GuildFBAward