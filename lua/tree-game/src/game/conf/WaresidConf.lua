--
-- Author: Your Name
-- Date: 2015-10-13 16:19:28
--
--[[
]]
local WaresidConf = class("WaresidConf",base.BaseConf)

function WaresidConf:init()
  -- body
  self.conf=require("res.conf.waresid")
end

function WaresidConf:getWaresid( channel, price )
  local info = self.conf[channel..""]
  if info then
      return info["price"..price*10]..""
  end
  return "1"
end

return WaresidConf