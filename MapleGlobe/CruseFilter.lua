

function CruseFilter.filterChar(self, src, filterChars, ignoreNewLine)
  local out = {}
  for i = 1, #src do
    local b = ___MOD.string.byte(src, i)
    local ch = src:sub(i, i)
    local allow = 32 <= b or not ignoreNewLine and (b == 13 or b == 10)
    if allow and not self:strchrIgnoreCase(filterChars, ch) then
      out[#out + 1] = ch
    end
  end
  return ___MOD.table.concat(out)
end

function CruseFilter.isCharEqual(self, chr1, chr2)
  return ___MOD.string.lower(chr1) == ___MOD.string.lower(chr2)
end

function CruseFilter.searchSubstring(self, text, pattern)
  if pattern == nil or pattern == "" then
    return false
  end
  return ___MOD.string.find(text, pattern, 1, true) ~= nil
end

function CruseFilter.strchrIgnoreCase(self, str, chr)
  for i = 1, #str do
    local c = str:sub(i, i)
    if self:isCharEqual(c, chr) then
      return i
    end
  end
  return nil
end
