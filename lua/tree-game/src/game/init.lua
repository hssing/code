--------------------------------------------
-- @game init
--[[--
游戏初始化

--]]

require("game.global_define")

require("game.global_var")
--消息版本
require("game.msg_version")
--调试参数
require("game.debug_config")

require("game.MyUserDefault")

require("game.common.common_functions.lua")

-- quick框架本身不加载计时器 自己手动加载 
scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

--资源
res = require("game.assets.res")

--基础类
base = require("game.base.init")

--管理器
mgr = require("game.manager.init")

--公共包
common = require("game.common.init")



--控件
gui = require("game.cocosstudioui.init")

--控制器
proxy = require("game.proxy.init")

--缓存数据
cache = require("game.cache.init")

conf = require("game.conf.init")

























