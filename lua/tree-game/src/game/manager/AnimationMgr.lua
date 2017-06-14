local AnimationMgr=class("AnimationMgr")
--添加骨骼文件信息
function AnimationMgr:addInfoAsync(fname_)
  --  cclog("AnimationMgr:addInfoAsync>>%s",fname_)
    --  ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("assets_common/skeleton/users/"..fName..".ExportJson",dataLoaded)
    --  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/assets_common/skeleton/users/"..fName..".ExportJson",dataLoaded)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/skeleton/"..fname_.."/"..fname_..".ExportJson")
end



-- --添加信息
-- function AnimationMgr:addInfoAsync(fname_)
--   --  cclog("AnimationMgr:addInfoAsync>>%s",fname_)
--     --  ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("assets_common/skeleton/users/"..fName..".ExportJson",dataLoaded)
--     --  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/assets_common/skeleton/users/"..fName..".ExportJson",dataLoaded)
--     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/effects/"..fname_.."/"..fname_..".ExportJson")
-- end


function AnimationMgr:create(sName)
    self:addInfoAsync(sName)
    return ccs.Armature:create(sName)
end



return AnimationMgr