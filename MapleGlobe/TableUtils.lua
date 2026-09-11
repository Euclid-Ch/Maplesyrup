

function TableUtils.clone(self, t)
  local r = {}
  for k, v in ___MOD.pairs(t) do
    r[k] = v
  end
  return r
end

function TableUtils.deepCopy(self, t, seen)
  if ___MOD.type(t) ~= "table" then
    return t
  end
  if seen and seen[t] then
    return seen[t]
  end
  seen = seen or {}
  local copy = {}
  seen[t] = copy
  for k, v in ___MOD.pairs(t) do
    copy[self:deepCopy(k, seen)] = self:deepCopy(v, seen)
  end
  local mt = ___MOD.getmetatable(t)
  if mt then
    ___MOD.setmetatable(copy, mt)
  end
  return copy
end

function TableUtils.get_random_unique_array(self, start, range, count)
  local out = {}
  if range <= 0 or count <= 0 then
    return out
  end
  local pool = {}
  for i = 1, range do
    pool[i] = start + (i - 1)
  end
  local maxPick = count
  if range < maxPick then
    maxPick = range
  end
  for i = 1, maxPick do
    local idx = ___MOD._GlobalRand32:randomIntegerRange(1, #pool)
    out[i] = pool[idx]
    pool[idx] = pool[#pool]
    pool[#pool] = nil
  end
  return out
end

function TableUtils.isContains(self, t, obj)
  for i = 1, #t do
    if t[i] == obj then
      return true
    end
  end
  return false
end

function TableUtils.len(self, t)
  local n = 0
  for _ in ___MOD.pairs(t) do
    n = n + 1
  end
  return n
end

function TableUtils.shuffle(self, t)
  for i = #t, 2, -1 do
    local j = ___MOD.math.random(1, i)
    t[i], t[j] = t[j], t[i]
  end
end

function TableUtils.spairs(self, tbl)
  local ks = {}
  for k in ___MOD.pairs(tbl) do
    ks[#ks + 1] = k
  end
  ___MOD.table.sort(ks)
  local i = 0
  return function()
    i = i + 1
    local k = ks[i]
    if k ~= nil then
      return k, tbl[k]
    end
  end
end

function TableUtils.unique(self, t)
  local seen, out = {}, {}
  for i = 1, #t do
    local v = t[i]
    if v ~= nil and not seen[v] then
      seen[v] = true
      out[#out + 1] = v
    end
  end
  return out
end
