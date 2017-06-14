--[[--

]]

local NetEngine = class("NetEngine")


local SOCKET_TICK_TIME = 0.1 			-- check socket data interval
local SOCKET_RECONNECT_TIME = 5			-- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 3	-- socket failure timeout

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"

local scheduler = require("framework.scheduler")
local socket = require "socket"

function NetEngine.getTime()
	return socket.gettime()
end

function NetEngine:init(onConnected_,onData_,onClose_,onConnectFailure_)
	self.onConnected = onConnected_;
    self.onData = onData_;
    self.onClose = onClose_;
    self.onConnectFailure = onConnectFailure_
    self.host = nil
    self.port = nil
    self.tickScheduler = nil      -- timer for data
    self.connectTimeTickScheduler = nil -- timer for connect timeout
    self.name = 'NetEngine'
    self.tcp = nil
    self.isRetryConnect = nil
    self.isConnected = false
end

function NetEngine:connect(host_, port_)
    if host_ then self.host = host_ end
    if port_ then self.port = port_ end

    assert(self.host or self.port, "Host and port are necessary!")
    print("NetEngine:connect......")
    self.tcp = socket.tcp()
    self.tcp:settimeout(0)

    local function __checkConnect()
        local __succ = self:_connect()
        if __succ then
            self:_onConnected()
        end
        return __succ
    end

    if not __checkConnect() then
    	local __connectTimeTick = function ()
	        self.waitConnect = self.waitConnect or 0
	        self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
            print("checkConnect....")
	        if self.isConnected then return end
	        if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
	        	self.waitConnect = nil
	        	self:_connectFailure()
	        	return
	        end
	        __checkConnect()
	    end
        self.connectTimeTickScheduler = scheduler.scheduleGlobal(__connectTimeTick, SOCKET_TICK_TIME)
    end
end

function NetEngine:send(data_) 
	assert(self.isConnected, self.name.."is not connected.")
	self.tcp:send(data_)
end

function NetEngine:close()
	self:_onDisconnect()
end

function NetEngine:disconnect()
	self:_onDisconnect()
end

------------------------------
----- private
------------------------------

--- When connect a connected socket server, it will return "already connected"
-- @see: http://lua-users.org/lists/lua-l/2009-10/msg00584.html
function NetEngine:_connect()
    local __succ, __status = self.tcp:connect(self.host, self.port)
    return __succ == 1 or __status == STATUS_ALREADY_CONNECTED;
end

function NetEngine:_disconnect()
    self.isConnected = false
    self.tcp:close()
    self.tcp:shutdown()
    if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
    if self.tickScheduler then scheduler.unscheduleGlobal(self.tickScheduler) end
end
 
function NetEngine:_onDisconnect()
    self:_disconnect()
    self.onClose(self)
end

-- connecte success, cancel the connection timerout timer
function NetEngine:_onConnected()
    debugprint("NetEngine:_onConnected..............................")
    self.isConnected = true
    self.onConnected(self)
    if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
    local __tick = function()
        while true do
        	-- if use "*l" pattern, some buffer will be discarded, why?  *l ?
            local __body, __status, __partial = self.tcp:receive("*a")  -- read the package body
            __status = tostring( __status )
            if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
                debugprint( "NetEngine:_onConnected连接关闭， 服务端 端口状态为closed", __status )
                if self.isConnected then
                    self:_onDisconnect()
                else
                    self:_connectFailure()
                end
                break
            end
            
            if (__body and string.len(__body) == 0) or (__partial and string.len(__partial) == 0) then return end
            if __body and __partial then __body = __body .. __partial end

            self.onData(__partial or __body)
        end
    end

	-- start to read TCP data
    self.tickScheduler = scheduler.scheduleGlobal(__tick, SOCKET_TICK_TIME)
end

function NetEngine:_connectFailure(status)
    debugprint( "NetEngine:_connectFailure~~~" )
    self:_disconnect()
    self.onConnectFailure()
end


return NetEngine