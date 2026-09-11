

function JsonUtils.getJSONEscapeMap(self)
  local map = self._T.jsonEscapeMap
  if map ~= nil and map[34] ~= nil then
    return map
  end
  map = {}
  for i = 0, 31 do
    map[___MOD.string.char(i)] = ___MOD.string.format("\\u%04X", i)
  end
  map["\b"] = "\\b"
  map["\t"] = "\\t"
  map["\n"] = "\\n"
  map["\f"] = "\\f"
  map["\r"] = "\\r"
  map["\""] = "\\\""
  map["\\"] = "\\\\"
  map[34] = "\""
  map[92] = "\\"
  map[47] = "/"
  map[98] = "\b"
  map[102] = "\f"
  map[110] = "\n"
  map[114] = "\r"
  map[116] = "\t"
  self._T.jsonEscapeMap = map
  return map
end

function JsonUtils.parseJSON(self, str, decodeUnicode)
  local str_sub = ___MOD.string.sub
  local str_find = ___MOD.string.find
  local str_byte = ___MOD.string.byte
  local t_concat = ___MOD.table.concat
  local tonumber = ___MOD.tonumber
  if ___MOD.type(str) ~= "string" then
    ___MOD.error("Expected JSON string, got " .. ___MOD.type(str), 2)
  end
  local len = #str
  local endPos = len + 1
  local pos = 1
  local utf8Char
  if decodeUnicode then
    utf8Char = ___MOD.utf8 and ___MOD.utf8.char or ___MOD.string.char
  end
  local strBuf, escMap, parseValue

  local function parseString()
    pos = pos + 1
    local p = str_find(str, "[\\\"]", pos)
    if p == nil then
      ___MOD.error("Unterminated string at " .. pos)
    end
    if str_byte(str, p) == 34 then
      local value = str_sub(str, pos, p - 1)
      pos = p + 1
      return value
    end
    if strBuf == nil then
      strBuf = {}
    end
    if escMap == nil then
      escMap = self._T.jsonEscapeMap
      if escMap == nil or escMap[34] == nil then
        escMap = self:getJSONEscapeMap()
      end
    end
    local bufIdx = 0
    while true do
      if p > pos then
        bufIdx = bufIdx + 1
        strBuf[bufIdx] = str_sub(str, pos, p - 1)
      end
      if str_byte(str, p) == 34 then
        pos = p + 1
        return t_concat(strBuf, "", 1, bufIdx)
      end
      local nextByte = str_byte(str, p + 1)
      local mapped = escMap[nextByte]
      bufIdx = bufIdx + 1
      if mapped ~= nil then
        strBuf[bufIdx] = mapped
        p = p + 2
      elseif nextByte == 117 then
        local code = tonumber(str_sub(str, p + 2, p + 5), 16)
        if code ~= nil then
          if utf8Char ~= nil then
            strBuf[bufIdx] = utf8Char(code)
          else
            strBuf[bufIdx] = str_sub(str, p, p + 5)
          end
        else
          strBuf[bufIdx] = "???? "
        end
        p = p + 6
      else
        strBuf[bufIdx] = str_sub(str, p, p + 1)
        p = p + 2
      end
      pos = p
      p = str_find(str, "[\\\"]", pos)
      if p == nil then
        ___MOD.error("Unterminated string")
      end
    end
  end

  function parseValue()
    local c = str_byte(str, pos)
    if c == 34 then
      return parseString()
    elseif c == 123 then
      pos = pos + 1
      local obj = {}
      c = str_byte(str, pos)
      if c ~= nil and c <= 32 then
        pos = str_find(str, "%S", pos) or endPos
      end
      if str_byte(str, pos) == 125 then
        pos = pos + 1
        return obj
      end
      while true do
        if str_byte(str, pos) ~= 34 then
          ___MOD.error("Expected key at " .. pos)
        end
        local key = parseString()
        c = str_byte(str, pos)
        if c ~= nil and c <= 32 then
          pos = str_find(str, "%S", pos) or endPos
        end
        if str_byte(str, pos) ~= 58 then
          ___MOD.error("Expected ':' at " .. pos)
        end
        pos = pos + 1
        c = str_byte(str, pos)
        if c ~= nil and c <= 32 then
          pos = str_find(str, "%S", pos) or endPos
        end
        obj[key] = parseValue()
        c = str_byte(str, pos)
        if c ~= nil and c <= 32 then
          pos = str_find(str, "%S", pos) or endPos
          c = str_byte(str, pos)
        end
        if c == 44 then
          pos = pos + 1
          c = str_byte(str, pos)
          if c ~= nil and c <= 32 then
            pos = str_find(str, "%S", pos) or endPos
          end
        elseif c == 125 then
          pos = pos + 1
          return obj
        else
          ___MOD.error("Expected ',' or '}' at " .. pos)
        end
      end
    elseif c == 91 then
      pos = pos + 1
      local arr = {}
      local arrIdx = 1
      c = str_byte(str, pos)
      if c ~= nil and c <= 32 then
        pos = str_find(str, "%S", pos) or endPos
      end
      if str_byte(str, pos) == 93 then
        pos = pos + 1
        return arr
      end
      while true do
        arr[arrIdx] = parseValue()
        arrIdx = arrIdx + 1
        c = str_byte(str, pos)
        if c ~= nil and c <= 32 then
          pos = str_find(str, "%S", pos) or endPos
          c = str_byte(str, pos)
        end
        if c == 44 then
          pos = pos + 1
          c = str_byte(str, pos)
          if c ~= nil and c <= 32 then
            pos = str_find(str, "%S", pos) or endPos
          end
        elseif c == 93 then
          pos = pos + 1
          return arr
        else
          ___MOD.error("Expected ',' or ']' at " .. pos)
        end
      end
    elseif c ~= nil and (48 <= c and c <= 57 or c == 45) then
      local p = str_find(str, "[^0-9%.eE%+%-]", pos) or endPos
      local num = tonumber(str_sub(str, pos, p - 1))
      pos = p
      return num
    elseif c == 116 then
      pos = pos + 4
      return true
    elseif c == 102 then
      pos = pos + 5
      return false
    elseif c == 110 then
      pos = pos + 4
      return nil
    else
      ___MOD.error("Unexpected char at " .. pos)
    end
  end

  local c = str_byte(str, pos)
  if c ~= nil and c <= 32 then
    pos = str_find(str, "%S", pos) or endPos
  end
  if len < pos then
    ___MOD.error("Empty JSON")
  end
  return parseValue()
end

function JsonUtils.tableToJSON(self, value)
  local type = ___MOD.type
  local tostring = ___MOD.tostring
  local pairs = ___MOD.pairs
  local gsub = ___MOD.string.gsub
  local find = ___MOD.string.find
  local huge = ___MOD.math.huge
  local escMap = self._T.jsonEscapeMap
  if escMap == nil then
    escMap = self:getJSONEscapeMap()
  end
  local out = {}
  local seen = {}
  local encode

  function encode(v, outIdx)
    local t = type(v)
    if t == "string" then
      if 64 < #v and not find(v, "[%c\"\\]") then
        out[outIdx] = "\""
        out[outIdx + 1] = v
        out[outIdx + 2] = "\""
        return outIdx + 3
      else
        out[outIdx] = "\"" .. gsub(v, "[%c\"\\]", escMap, #v) .. "\""
        return outIdx + 1
      end
    elseif t == "number" then
      if v ~= v or v == huge or v == -huge then
        out[outIdx] = "null"
      else
        out[outIdx] = tostring(v)
      end
      return outIdx + 1
    elseif t == "boolean" then
      out[outIdx] = v and "true" or "false"
      return outIdx + 1
    elseif t == "table" then
      if seen[v] then
        out[outIdx] = "null"
        return outIdx + 1
      end
      seen[v] = true
      local isArr = v[1] ~= nil
      local arrLen = 0
      if isArr then
        local cnt = 0
        for k, _ in pairs(v) do
          if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
            isArr = false
            break
          end
          cnt = cnt + 1
          if k > arrLen then
            arrLen = k
          end
        end
        isArr = isArr and 0 < cnt and cnt == arrLen
      end
      if isArr then
        out[outIdx] = "["
        outIdx = encode(v[1], outIdx + 1)
        for i = 2, arrLen do
          out[outIdx] = ","
          outIdx = encode(v[i], outIdx + 1)
        end
        out[outIdx] = "]"
        outIdx = outIdx + 1
      else
        local objectStart = outIdx
        out[outIdx] = "{"
        outIdx = outIdx + 1
        for k, val in pairs(v) do
          if type(k) ~= "string" then
            k = tostring(k)
          end
          out[outIdx] = "\"" .. gsub(k, "[%c\"\\]", escMap, #k) .. "\":"
          outIdx = encode(val, outIdx + 1)
          out[outIdx] = ","
          outIdx = outIdx + 1
        end
        if outIdx == objectStart + 1 then
          out[outIdx] = "}"
          outIdx = outIdx + 1
        else
          out[outIdx - 1] = "}"
        end
      end
      seen[v] = nil
      return outIdx
    elseif t == "nil" then
      out[outIdx] = "null"
      return outIdx + 1
    else
      local s = tostring(v)
      out[outIdx] = "\"" .. gsub(s, "[%c\"\\]", escMap, #s) .. "\""
      return outIdx + 1
    end
  end

  local outIdx = encode(value, 1)
  return ___MOD.table.concat(out, "", 1, outIdx - 1)
end
