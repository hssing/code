--[[

]]


local MsgPacket = class("MsgPacket")
MsgPacket.FLAG_LEN = 2 -- 前两位，消息长度
MsgPacket.TYPE_LEN = 1 -- 
local ByteArray = require("message.ByteArray")
local Protocol  = require("message.Protocol")

function MsgPacket:ctor()
  self:init()
end

function MsgPacket:init()
  self.msgBuf = MsgPacket.cBA()
  self._tmpBuf = MsgPacket.cBA()
  self._length = 1
  self._after = 1
  self._readLen = false
end

function MsgPacket.cBA()
  return ByteArray.new()
end

function MsgPacket.createPacket(msgDef,msgBodyTable)
  local buf = MsgPacket.cBA()
  buf:setEndian("ENDIAN_BIG")
  buf:writeInt(1)             --预留长度位置
  buf:writeInt(msgDef.method) --消息号
  buf:writeInt(1)             --发送时间
  MsgPacket.writeMsg(buf,msgDef,msgBodyTable)
  buf:setPos(1)               --把下标重置到第一位
  buf:writeInt(buf:getLen()-4)--写入长度
  return buf
end

--用table.getn()或者#方法取不到长度时，请用此方法试试
local function tableSize(ttable)
  local size = 0
  if (ttable == nil or type(ttable) ~= "table") then
    return 0
  end
  for k, v in pairs(ttable) do
    size = size + 1
  end
  return size
end

--组包
function MsgPacket.writeMsg(wBuf,msgDef,wBody)
  local wFmt = msgDef.fmt
  local wKeys = msgDef.keys
  for i = 1,#wFmt do
    local newFmt = wFmt[i]
    local newKey = wKeys[i]
    if newFmt == "b" then
      wBuf:writeByte(wBody[newKey])
    elseif newFmt == "h" then
      wBuf:writeShort(wBody[newKey])
    elseif newFmt == "i" then
      wBuf:writeInt(wBody[newKey])
    elseif newFmt == "L" then
      local tmpInt64 = wBody[newKey]
      if type(tmpInt64) ~= "table" then
        local strArray = string.split(wBody[newKey],"_")    
        tmpInt64 = {}    
        if #strArray  >1 then 
          tmpInt64.high = strArray[1]
          tmpInt64.low = strArray[2]
        else        
          tmpInt64.high = 0
          tmpInt64.low = wBody[newKey]
        end
      end
      wBuf:writeInt64(tmpInt64)
    elseif newFmt == "d" then
      wBuf:writeDouble(wBody[newKey])
    elseif newFmt == "S" then
      wBuf:writeString(wBody[newKey])
    else
      local vfmt = newFmt:sub(1,1)
       if vfmt == "&" then
         local wValue = wBody[newKey]
         if #wValue>0 then
         wBuf:writeUShort(#wValue) 
          vfmt = newFmt:sub(2,2)--取类型
          if vfmt == "$" then --如果是结构类型的，要取结构名
            vfmt = newFmt:sub(3,(#newFmt-1))--取结构名
            for i=1,#wValue do
              MsgPacket.writeMsg(wBuf,Protocol.getStruct(vfmt),wValue[i])
            end
          else
            for i=1,#wValue do
              if type(wValue[i]) == "table" and wValue[i].key ~= nil then
                MsgPacket.writeMsg(wBuf,Protocol.getVectorF(vfmt,tableSize(wValue[i])),wValue[i])
              else
                MsgPacket.writeMsg(wBuf,Protocol.getVectorF(vfmt,1),{wValue[i]})
              end
            end
          end
         end
       elseif vfmt == "$" then
         vfmt = newFmt:sub(2,#newFmt)--取结构名
         MsgPacket.writeMsg(wBuf,Protocol.getStruct(vfmt),wBody[newKey])
       else
         print(newFmt .. " 暂未找到该类型,请检查对应的消息号数据类型")
       end
    end
  end
  return wBuf
end

--[[
b   int8
h   int16
i   int32
L   int64
d   double
S   String

]]
function MsgPacket.readMsg(readBody,readBuf,readDef)
  local rFmt    = readDef.fmt
  local rKeys   = readDef.keys
  for i = 1,#rFmt do
    local rValue = nil
    local newFmt = rFmt[i]
    local newKey = rKeys[i]
    if newFmt == "" or newKey == "" then break end
    if newFmt == "b" then
      rValue = readBuf:readByte()
      readBody[newKey] = rValue
    elseif newFmt == "h" then
      rValue = readBuf:readShort()
      readBody[newKey] = rValue
    elseif newFmt == "i" then
      rValue = readBuf:readInt()
      readBody[newKey] = rValue
    elseif newFmt == "L" then
      rValue = readBuf:readInt64()
      readBody[newKey] = rValue
    elseif newFmt == "d" then
      rValue = readBuf:readDouble()
      readBody[newKey] = rValue
    elseif newFmt == "S" then
      rValue = readBuf:readString()
      readBody[newKey] = rValue
    else
      local vfmt = newFmt:sub(1,1)
      if vfmt == "&" then
        local vStruct = {}
        readBody[newKey] = {}
        rValue = readBuf:readShort()--读取结构长度
        if (rValue > 0) then
          vfmt = newFmt:sub(2,2)--取类型
          if vfmt == "$" then --如果是结构类型的，要取结构名
            vfmt = newFmt:sub(3,(#newFmt-1))--取结构名
            for i=1,rValue do
              vStruct[i] = {}
              vStruct[i]._length = rValue
              MsgPacket.readMsg(vStruct[i],readBuf,Protocol.getStruct(vfmt))
            end
          else
            MsgPacket.readMsg(vStruct,readBuf,Protocol.getVectorF(vfmt,rValue))
          end
        end
        readBody[newKey] = vStruct
      elseif vfmt == "$" then --单个结构
        local vStruct = {}
        vfmt = newFmt:sub(2,#newFmt)--取结构名
        MsgPacket.readMsg(vStruct,readBuf,Protocol.getStruct(vfmt))
        readBody[newKey] = vStruct
      elseif vfmt == "#" then --Map<Integer, Integer>
        local maps = {}
        readBody[newKey] = maps
        rValue = readBuf:readShort()
        maps._size = rValue
        for i = 1, rValue do 
          maps[""..readBuf:readInt()] = readBuf:readInt()
        end
      end
    end
    
    -- print("read_newKey",newKey,rValue)
  end
end

function MsgPacket:splitPacket(byteString)
  ---消息拆分完毕
  if self.msgBuf:getAvailable() == 0 then
    self._length = 1
    self._after = 1
    self.msgBuf = MsgPacket.cBA()
    self._readLen = false
  end
  ---把消息加到缓冲区
  local lastPos = self._after + self.msgBuf:getAvailable()
  self.msgBuf:setPos(lastPos)
  self.msgBuf:writeBuf(byteString)
  self.msgBuf:setPos(self._after)   --上一次读取的位置
  --消息变量
  local t_mid = 0
  local t_ste = 0
  local resultDef = {}
  local resultArray = {}
  --拆包
  while (true) do
    local result = {}
    if(self.msgBuf:getAvailable() >= 4) and self._readLen==false then
      self._length = self.msgBuf:readInt()     --当前消息长度
      self._after  = self.msgBuf:getPos()      --已经读取过的长度
      self._readLen = true
    end

    if (self.msgBuf:getAvailable() >= self._length)  then
      t_mid = self.msgBuf:readInt()            --消息号
      t_ste = self.msgBuf:readInt()            --状态码
      resultDef = Protocol.getReceive(t_mid)
      self.readMsg(result,self.msgBuf,resultDef) --得到单条消息内容
      result.msgId = t_mid --默认会霸占msgId跟status字段
      result.status = t_ste
      self._readLen = false
      self._after  = self.msgBuf:getPos()      --已经读取过的长度
    else
      --剩余消息需要黏包
      print("剩余消息需要黏包!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
      break
    end

    table.insert(resultArray,result) --有可能解析多条消息
    if (self.msgBuf:getAvailable() < 4) then break end    --长度不足一条消息的长度
  end
  return resultArray;
end

return MsgPacket
