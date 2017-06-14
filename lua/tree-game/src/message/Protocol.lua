--[[
    R : Unsigned Varint Int   1~4bit
    r : Varint Int        1~4bit     
 I : Unsigned Int     4bit                   uint32
 i : Int            4bit                     int32
 H : Unsigned Short     2bit                 uint16
 h : Short          2bit                     int16
 S : String         dynamic      
 b : byte (unsigned char)   1bit 0~255       uint8
 c : char (signed byte)   1bit -127~128      int8
    f : float         4bit         
 d : double         8bit       
 T   :                                        int64
 $O  :  结构        $区分是单个结构还是结构数组  O是结构名
 &..&  vector<..>     比如&O& = vector<O>结构数组   &S& = vector<S>字符串数组

]]
local msgDef = require("message.MsgDef")

local Protocol = Protocol or {}

local function getProtocol(typeName, methodCode, ver)
  ver = ver or 0
  methodCode = string.format("%s",methodCode)
  assert(msgDef[typeName][methodCode], "Can not find ".. typeName .." protocol in method:"..methodCode.."!")
  --local oldTable = pro[typeName][methodCode][ver]
  local oldTable = msgDef[typeName][methodCode]
  assert(oldTable, "Can not find "..typeName.." protocol in method:"..methodCode.." ver:"..ver.."!")
  local newTable = {} 
   newTable.ver = ver
   newTable.method = methodCode
   newTable.fmt = oldTable.fmt
   newTable.keys = oldTable.keys
  return newTable
end

--获取发送消息数据类型的定义
function Protocol.getSend(methodCode, ver)
  return getProtocol("send", methodCode, ver)
end

--获取接收消息数据类型的定义
function Protocol.getReceive(methodCode, ver)
  return getProtocol("receive", methodCode, ver)
end

--组装structName结构类型的vector结构定义
function Protocol.getStruct(structName, ver)
  return getProtocol("struct", structName, ver)
end

--组装基础类型的vector结构定义
function Protocol.getVectorF(type,value)
  local newTable = {}
  if (value > 0) then
    newTable.ver = 0
    newTable.method = type
    newTable.fmt = {}
    newTable.keys = {}
    for i=1,value do
      newTable.fmt[i] = type
      newTable.keys[i] = i
    end
  end
  return newTable
end

return Protocol