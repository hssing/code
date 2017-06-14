
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

nous = {}
nous.WritablePath = cc.FileUtils:getInstance():getWritablePath()
nous.platform =cc.Application:getInstance():getTargetPlatform()
nous.isVoide = false

local m_package_path = package.path
print("nous.WritablePath>"..nous.WritablePath)
print(">>>>"..m_package_path)
package.path = string.format("%s?/init.lua;%s?.lua;%ssrc/?.lua;%s",nous.WritablePath,nous.WritablePath, nous.WritablePath,m_package_path)


cc.FileUtils:getInstance():addSearchPath(nous.WritablePath,true)
cc.FileUtils:getInstance():addSearchPath(nous.WritablePath.."src",true)
cc.FileUtils:getInstance():addSearchPath(nous.WritablePath.."res",true)
cc.FileUtils:getInstance():addSearchPath(nous.WritablePath.."res/views",true)
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")
cc.FileUtils:getInstance():addSearchPath("res/views")

print("package.path ="..package.path)
cc.FileUtils:getInstance():setPopupNotify(false)
require("initializer").new():run()

