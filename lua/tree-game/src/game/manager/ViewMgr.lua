--[[--
View Ui 管理器


]]
local ViewMgr = class("ViewMgr")

local viewPackageRoot="game"

local ui_res_suffix = ".csb"

function ViewMgr:ctor()
	self._Views={}
end

---当前场景显示view
function ViewMgr:showView(viewname,zOrder_,isRepeat)
	local view=self:createView(viewname,isRepeat,viewname)

	--主界面 showView 时，那些界面要显示/隐藏聊天ICON
	local  hidelist = {}
	hidelist[_viewname.ROLE] = false
	hidelist[_viewname.GUILD_LIST] = false
	hidelist[_viewname.ROLE_BUY_TILI] = true
	hidelist[_viewname.OPEN_FUNC] = true
		-------------------显示隐藏蛋疼的聊天 按钮
		local mainView =  mgr.ViewMgr:get(_viewname.MAIN)
		if mainView and hidelist[viewname]  then
			
		else
			local maintoplayerview = mgr.ViewMgr:get(_viewname.MAIN_TOP_LAYER)
	    	if  maintoplayerview and tolua.isnull(maintoplayerview.btnChat) == false then
	        	if viewname == _viewname.MAIN_TOP_LAYER then
	     			maintoplayerview.btnChat:setVisible(true)
	     		else
	     			maintoplayerview.btnChat:setVisible(false)
	     		end
	     	end
		end


	mgr.SceneMgr:getNowShowScene():addView(view,zOrder_)
	return view
end

function ViewMgr:loadingView(viewname,data)
	
end

function ViewMgr:get(viewname_)
	local __view =  self._Views[viewname_]
	if tolua.isnull(__view) then return nil end
	return __view
end

function ViewMgr:createView(viewName,isRepeat,rootviewName,index)
		local  view=self._Views[viewName]
		if  view ==  nil or  tolua.isnull(view) then
				local viewPackageName = "game.views." .. (rootviewName or viewName)
		   	debugprint("View:"..viewName.."被创建","viewPath:  "..viewPackageName)
		    local viewClass = require(viewPackageName)
		    view = viewClass.new()
		    view.__name = viewName
		    self._Views[viewName] = view
		    view:init(index)--初始化  
		    if view.viewSave then
		    		debugprint("____________________________________对象retain", viewName)
		    		view:retain()
		    end
		else
				if isRepeat then
					local Mark = "_1"
					return self:createView(viewName..Mark,isRepeat,rootviewName)
				end
		end
		if view.ShowAll then
				--debugprint("____________________________________隐藏head", viewName)
  		  local scene =  mgr.SceneMgr:getMainScene()
		    if scene then 
		        scene:closeHeadView()
		    end
  	end
    return view
end

function ViewMgr:showTipsView(viewname,data_)
	-- body
	local __view =  self:get(viewname)
	if __view then 
		self:closeView(viewname)		
	end
	__view=self:createView(viewname,nil,viewname,nil)
	--__view:setData(data_)
	mgr.SceneMgr:getNowShowScene():addView(__view)
	return __view
end

function ViewMgr:hideView(name)
	local view = self._Views[name]
	if view then
		view:onHide()
	else
		debugprint(name.."不存在")
	end
end

function ViewMgr:setallLayerCansee(flag,viewName_)
	-- body
	--flag =    flag or  true 
	if self._Views then 
		for k ,v in pairs(self._Views) do

			if k ~= "login.LoginView" and k~="guide.GuideView" and (viewName_ and  k~=viewName_) then 
	
				if not tolua.isnull(v) then

					v:setVisible(flag)
				end 
				--v:setTouchEnabled(flag)
			end
		end
	end
end

function ViewMgr:closeView(name)
	local view = self._Views[name]

	if view then
		if not tolua.isnull(view) then
			view:close()
		end
		if view.viewSave then
				debugprint("____________________________________对象release", name)
	    	view:release()
	  end
	  self._Views[name] = nil
	else
		debugprint(name.."不存在")
	end
end

function ViewMgr:closeAllView()
	for k,v in pairs(self._Views) do
		if not tolua.isnull(v) then
			v:close()
		end
	end
	self._Views={}
end

function ViewMgr:loadUI(filename)
	print("views/ui_res/"..filename..ui_res_suffix)
	local node = cc.uiloader:load("views/"..filename..ui_res_suffix)
	local frameSize = cc.Director:getInstance():getVisibleSize()
    node:setContentSize(frameSize)
	ccui.Helper:doLayout(node)
	return node
end
--预加载 那些界面卡顿比较明显的
function ViewMgr:needPreAdd()
	-- body
	local t = {
		--"FormationView",
		--"PetDetailView",
		--"SpirteLvUpView",
		--"ActiveZhaocaiView",
		"ShopView",
		--"RoleView",
		--"GuildSearchView",
		--"GuizeView",

	}
	for k ,v in pairs (t) do 
		self:loadUI(v)
	end 
end


return ViewMgr