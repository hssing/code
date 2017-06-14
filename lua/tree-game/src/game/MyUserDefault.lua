
-- 统一管理UserDefault的key
MyUserDefault = MyUserDefault or {}

local user_default_ = cc.UserDefault:getInstance()


----------------------------------保存角色信息--------------------------
-- 如果取到的值不存在，返回默认值自己添加对应的
function MyUserDefault.getIntegerForKey( key_ )
	local key = MyUserDefault.getKey()..key_
	local value_ = user_default_:getIntegerForKey( key )
	return value_
end

function MyUserDefault.setIntegerForKey( key_, value_ )
		assert( key_ and value_, "key and value should not null！！！" )
		local key = MyUserDefault.getKey()..key_
		user_default_:setIntegerForKey( key, value_ )
		user_default_:flush()
end


function MyUserDefault.setStringForKey( key_, value_ )
		assert( key_ and value_, "key and value should not null！！！" )
		local key = MyUserDefault.getKey()..key_
		user_default_:setStringForKey( key, value_ )
		user_default_:flush()
end

function MyUserDefault.getStringForKey( key_ )
		local key = MyUserDefault.getKey()..key_
		local value_ = user_default_:getStringForKey( key )
		return value_
end

function MyUserDefault.getKey()
    return g_var.debug_accountId..g_var.server_id..g_var.channel_id
end
------------------------------------------------------------------------

----------------------------------无key保存专用--------------------------
function MyUserDefault.setAcount( key_, value_ )
		assert( key_ and value_, "key and value should not null！！！" )
		user_default_:setStringForKey( key_, value_ )
		user_default_:flush()
end

function MyUserDefault.getAcount( key_ )
		local value_ = user_default_:getStringForKey( key_ )
		return value_
end

--当前apk_version
function MyUserDefault:getProjectVersion()
	-- body
	local value_ = user_default_:getStringForKey( key_ )
	return value_
end

function MyUserDefault:setProjectVersion(key_,value_)
	-- body
	assert( key_ and value_, "key and value should not null！！！" )
	user_default_:setStringForKey( key_, value_ )
	user_default_:flush()
	--return value_
end

------------------------------------------------------------------------
