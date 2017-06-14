local PathMgr=class("PathMgr")


local ITEM_PATH_ROOT="res/itemicon/"


local HEAD_PATH_ROOT="res/head/"

local HEAD_PATH_ROOT="res/head/"


function PathMgr.getItemImagePath(itemsrc)
	local path = nil
	if cc.FileUtils:getInstance():isFileExist(ITEM_PATH_ROOT..itemsrc..".png") then 
		path = cc.FileUtils:getInstance():fullPathForFilename(ITEM_PATH_ROOT..itemsrc..".png")
	else
		print("没有"..ITEM_PATH_ROOT..itemsrc..".png的资源")
		--path = CCFileUtils:getInstance():fullPathForFilename(ITEM_PATH_ROOT.."401001.png")
	end
	
	return path

end

function PathMgr.getImageHeadPath(itemsrc)
	local path = nil
	if cc.FileUtils:getInstance():isFileExist(HEAD_PATH_ROOT..itemsrc..".png") then 
		path = cc.FileUtils:getInstance():fullPathForFilename(HEAD_PATH_ROOT..itemsrc..".png")
	else
		print("没有"..HEAD_PATH_ROOT..itemsrc..".png的资源")
		--path = CCFileUtils:getInstance():fullPathForFilename(ITEM_PATH_ROOT.."401001.png")
	end
	
	return path

end













return PathMgr