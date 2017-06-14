
local TestScene = class("TestScene", base.BaseScene)

function TestScene:ctor()
    -- app:createTitle(self,"Login Scene")

    --mgr.ViewMgr:loadUI(res.views.ui.Login):addTo(self)
     cc.ui.UILabel.new(
        {text = "vertical listView",
        size = 24,
        color = display.COLOR_RED})
        :align(display.CENTER, 120, 520)
        :addTo(self)
    self.lv = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
       -- bg = res.image.RED_PONT,
        bgScale9 = true,
        async = true, --异步加载
        viewRect = cc.rect(200, 80, 120, 400),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener8))
        :addTo(self,100)

    self.lv:setDelegate(handler(self, self.sourceDelegate))

    self.lv:reload()
end
function TestScene:loading(callback)
	-- local view=mgr.ViewMgr:createView(_viewname.LOGIN)
	-- self:addView(view)
	callback()
end
function TestScene:sourceDelegate(listView, tag, idx)
    -- print(string.format("TestUIListViewScene tag:%s, idx:%s", tostring(tag), tostring(idx)))
    if cc.ui.UIListView.COUNT_TAG == tag then
        return 100
    elseif cc.ui.UIListView.CELL_TAG == tag then
        local item
        local content

        item = self.lv:dequeueItem()
        if not item then
            item = self.lv:newItem()
            content = cc.ui.UILabel.new(
                    {text = "item"..idx,
                    size = 20,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    color = display.COLOR_WHITE})
            item:addContent(content)
        else
            content = item:getContent()
        end
        content:setString("item:" .. idx)
        item:setItemSize(120, 80)

        return item
    else
    end
end

function TestScene:touchListener8(event)
    local listView = event.listView
     print("async list view clicked idx:" ..11)
    if "clicked" == event.name then
        print("async list view clicked idx:" .. event.itemPos)
    end
end

function TestScene:onEnter()
  print("onEnter")
end

function TestScene:onExit()
  print("onExit")
end

return TestScene
