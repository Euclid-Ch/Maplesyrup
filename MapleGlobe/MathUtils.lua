

function MathUtils.alwaysCeil(self, num)
  if 0 < num then
    return ___MOD.math.ceil(num)
  else
    return ___MOD.math.floor(num)
  end
end

function MathUtils.alwaysFloor(self, num)
  if 0 < num then
    return ___MOD.math.floor(num)
  else
    return ___MOD.math.ceil(num)
  end
end

function MathUtils.decompose_digit(self, n)
  local floor = ___MOD.math.floor
  n = floor(n)
  if n == 0 then
    return {0}
  end
  local t = {}
  while 0 < n do
    local remainder = n % 10
    ___MOD.table.insert(t, 1, remainder)
    n = floor(n / 10)
  end
  return t
end

function MathUtils.format_integer_to_korean(self, n)
  if ___MOD.type(n) ~= "number" then
    return ""
  end
  n = ___MOD.math.floor(n)
  local units = {
    {1.0E8, "억"},
    {10000.0, "만"}
  }
  local parts = {}
  for _, u in ___MOD.ipairs(units) do
    local base, label = u[1], u[2]
    local q = ___MOD.math.floor(n / base)
    if 0 < q then
      parts[#parts + 1] = ___MOD.tostring(q) .. label
      n = ___MOD.math.floor(n % base)
    end
  end
  if 0 < n then
    parts[#parts + 1] = ___MOD.tostring(n)
  end
  return 0 < #parts and ___MOD.table.concat(parts, " ") or "0"
end

function MathUtils.format_thousands_for(self, n)
  local s = ___MOD.tostring(___MOD.math.floor(n))
  local neg = ""
  if s:sub(1, 1) == "-" then
    neg = "-"
    s = s:sub(2)
  end
  local len = #s
  local parts = {}
  for i = len, 1, -3 do
    local start = i - 2
    if start < 1 then
      start = 1
    end
    ___MOD.table.insert(parts, 1, s:sub(start, i))
  end
  return neg .. ___MOD.table.concat(parts, ",")
end

function MathUtils.round(self, num)
  if 0 <= num then
    return ___MOD.math.floor(num + 0.5)
  else
    return ___MOD.math.ceil(num - 0.5)
  end
end

function MathUtils.roundToEvenOffset(self, offset)
  local rounded = ___MOD.math.floor(offset + 0.5)
  if rounded % 2 ~= 0 then
    if offset > rounded then
      return rounded + 1
    else
      return rounded - 1
    end
  end
  return rounded
end

function MathUtils.truncate(self, num)
  return 0 <= num and ___MOD.math.floor(num) or ___MOD.math.ceil(num)
end
