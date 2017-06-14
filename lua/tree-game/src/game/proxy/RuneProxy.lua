--符文网络请求 信息接受

local RuneProxy = class("RuneProxy",base.BaseProxy)

function RuneProxy:init( ... )
	-- body
	self:add(520201,self.ChangeCallBack)
	---self:add(520202,self.TuoxiaCallBack)
	self:add(520203,self.lvCallBack)

	self.pos = 1
end
--请求更换符文
function RuneProxy:send120201(param)
	-- body
	debugprint("请求更换符文")
	printt(param)

	self.pos = string.sub(param.index,3,3)
	print("self.pos = "..self.pos)
	self:send(120201,param)
end
--更换符文放回
function RuneProxy:ChangeCallBack(data_)
	-- body
	if data_.status == 0 then 
		if not  data_.changeInfos then
			return 
		end
		for k ,j in pairs(data_.changeInfos) do 
			if not j.itemBaseInfo then
				break
			end
			for i , v in pairs(j.itemBaseInfo) do 
				if v.index >= 600000 then --穿在身上的信息系更新
					if v.amount == 0 then --移除
						cache.Rune:removeUseInfo(v)
					else
						cache.Rune:addUseInfo(v)
					end
				elseif v.index >= 500000 then --在背包--符文更新
					if v.amount == 0 then --移除
						cache.Rune:removepackInfo(v)	
					else 
						--todo
						v.new = true
						cache.Rune:addpackInfo(v)
						local type_= conf.Item:getType(v.mId)	
						NEW_ITEM_APCK_AMOUNT[type_] = NEW_ITEM_APCK_AMOUNT[type_] + v.amount
					end
				end
			end
		end

		local view1 = mgr.ViewMgr:get(_viewname.FORMATION)
		if view1 then
			view1:setData(self.pos)
		end

		local view2 = mgr.ViewMgr:get(_viewname.RUNE_MSG)
		if view2 then

			local _data = cache.Rune:getUseinfoVec()
			if #_data == 0 then
				view2:onCloseSelfView()
			else
				view2:setData(_data)
				view2:setCurSelect()
			end
			--view2:setData() 
		end


	elseif 21400005 == data_.status then
		G_TipsOfstr(res.str.DEC_NEW_34)
	elseif  21400006 == data_.status then
		G_TipsOfstr(res.str.DEC_NEW_46)
	else
		G_TipsError(data_.status)
	end
end
--请求脱下符文
function RuneProxy:send120202(param)
	-- body
	debugprint("请求脱下符文")
	printt(param)
	self:send(120202,param)
	self:wait(520202)
end

function RuneProxy:TuoxiaCallBack( data_ )
	-- body
	if data_.status == 0 then 

	else

	end
end
--请求符文升级
function RuneProxy:send120203( param )
	-- body
	debugprint("请求符文升级")
	printt(param)
	self:send(120203,param)
	self:wait(520203)
end

function RuneProxy:lvCallBack( data_ )
	-- body
	if data_.status == 0 then 
		local view = mgr.ViewMgr:get(_viewname.RUNE_LV)
		if view then
			--setData:setData()
			view:setServerCallBack(data_)
		end
	elseif 20010001 == data_.status then
		G_TipsOfstr(res.str.NO_ENOUGH_JB)
	else
		G_TipsError(data_.status)
	end
end


return RuneProxy