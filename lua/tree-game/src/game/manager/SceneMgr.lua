local SceneMgr = class("SceneMgr")

local scenePackageRoot="game"


function SceneMgr:ctor()
	 self._scenes 			= {}	--
	 self._currScene 		= nil --当前显示场景
	self._isEnterScene = false  --是否进入场景中
end

function SceneMgr:runNameScene(scene_name,args)
	local scene=self:createScene(scene_name,args)
	self:runScene(scene)
	return scene
end

function SceneMgr:runScene( scene , ...)
	self._currScene=scene --记录当前显示场景
	display.replaceScene(scene)
	return scene
end

---!!!!
function SceneMgr:getMainScene()
	return self._scenes[_scenename.MAIN]
end

function SceneMgr:getNowShowScene()
	return self._currScene
end

function SceneMgr:checkCurScene()
    return self._currScene.name
end

function SceneMgr:createScene(scene_name,args)
	local scene=self._scenes[scene_name]
	if scene == nil or tolua.isnull(scene) then
		local scenePackageName = "game.scenes." .. scene_name
   	 	debugprint("Scene:"..scene_name.."被创建")
   	 	local sceneClass = require(scenePackageName)
   	 	--print(unpack(checktable(args)))
    	scene = sceneClass.new(unpack(checktable(args)))
    	scene.name = scene_name
    	self._scenes[scene_name]=scene
	end
	return scene
end

---场景切换
function SceneMgr:LoadingScene(scene_name,args,noShowLodingScene)
		---检查是否已在当前场景
		if (self._currScene and self._currScene.name == scene_name) then return end
		---不要重复加载
		if self._isEnterScene == false then
				self._isEnterScene = true
				--------------------------------------------------------------------------
				if scene_name ~= _scenename.FIGHT then  --除了进入战斗场景清理效果，进入战斗前要预加载资源
						debugprint("_________________________________________","动画资源释放")
						mgr.BoneLoad:removeAllArmature()
				end
				--------------------------------------------------------------------------
				--是否加载主界面
				if args and args.loadMainView == false then
						load_main_view = false
				end
				 
				--------------------------------------------------------------------------
				local loading_scene=self:createScene(scene_name,args)
				local function sceneCallback() --第二层回调 场景加载完 回调
						load_main_view = true
						self:runScene(loading_scene)
						self._isEnterScene = false

						--场景切换完成
						loading_scene:changeSceneCompleteCall(function()
								if args and args.completeCallFun then args.completeCallFun() end
					      if loading_scene["checkLoginUpdate"] then
					      	loading_scene:checkLoginUpdate()
					    	end
						end)      
				end
				loading_scene:loading(sceneCallback)
		end
end

--@param flag_ 是否要检查更新
--切换至登录场景
function SceneMgr:LoginSceneWithUpdateCheck(flag_,func_)
	local args = {}
	if func_ then
		args.completeCallFun = func_
	end

	mgr.SceneMgr:LoadingScene(_scenename.LOGIN,args,{})
end

function SceneMgr:joinPreScene()
		mgr.SceneMgr:LoadingScene(_scenename.PRE)
end

function SceneMgr:playPreSceneVideo()
		--self:getNowShowScene():playVoide()
end

function SceneMgr:updateEnterScene()
		local sceneClass = require("game.scenes.LoginScene").new()
		sceneClass.name = "LoginScene"
    self._scenes["LoginScene"]=sceneClass
		sceneClass:changeSceneCompleteCall(function()
	      if sceneClass["createLoginView"] then
	      		sceneClass:createLoginView()
	    	end
		end)
		self._currScene=sceneClass
		display.replaceScene(sceneClass)
end

return SceneMgr