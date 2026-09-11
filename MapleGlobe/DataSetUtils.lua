

function DataSetUtils.getData(self, path, keyTitle, key, valueTitle)
  local dataSet = ___MOD._DataService:GetTable(path)
  local row = dataSet:FindRow(keyTitle, key)
  if row ~= nil then
    return row:GetItem(valueTitle) or ""
  end
  return nil
end

function DataSetUtils.shuffleTable(self, t)
  for i = #t, 2, -1 do
    local j = ___MOD.math.random(1, i)
    t[i], t[j] = t[j], t[i]
  end
  return t
end

function DataSetUtils.spairs(self, tbl)
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

function DataSetUtils.split(self, str, sep)
  local out = {}
  if str == nil or str == "" then
    return out
  end
  sep = sep or ","
  local pos = 1
  while true do
    local s, e = ___MOD.string.find(str, sep, pos, true)
    if not s then
      ___MOD.table.insert(out, ___MOD.string.sub(str, pos))
      break
    end
    ___MOD.table.insert(out, ___MOD.string.sub(str, pos, s - 1))
    pos = e + 1
  end
  return out
end
