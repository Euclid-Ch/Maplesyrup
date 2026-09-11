

function StringPoolManager.findNameByString(self, typeName, keyword)
  local function normalizeTypeName(s)
    s = ___MOD.tostring(s)

    s, ___MOD._ = s:gsub("%.img$", "")
    s, ___MOD._ = s:gsub("^%s+", ""):gsub("%s+$", "")
    return s
  end

  local result = {}
  if ___MOD.type(keyword) ~= "string" or keyword == "" then
    return result
  end
  typeName = normalizeTypeName(typeName)
  local bucket = self.stringCache[typeName]
  if ___MOD.type(bucket) ~= "table" then
    for k, v in ___MOD.pairs(self.stringCache) do
      if normalizeTypeName(k):lower() == typeName:lower() and ___MOD.type(v) == "table" then
        bucket = v
        break
      end
    end
    if ___MOD.type(bucket) ~= "table" then
      return result
    end
  end
  local kw = keyword
  for itemID, name in ___MOD.pairs(bucket) do
    if ___MOD.type(name) == "string" and ___MOD.string.find(name, kw, 1, true) ~= nil then
      result[#result + 1] = {
        id = ___MOD.tonumber(itemID) or itemID,
        name = name
      }
    end
  end
  ___MOD.table.sort(result, function(a, b)
    local an, bn = ___MOD.type(a.id) == "number", ___MOD.type(b.id) == "number"
    if an and bn then
      return a.id < b.id
    end
    if an ~= bn then
      return an
    end
    return ___MOD.tostring(a.id) < ___MOD.tostring(b.id)
  end)
  return result
end

function StringPoolManager.getItemName(self, itemID)
  local itemName = ""
  if self.itemNameCache[itemID] then
    itemName = self.itemNameCache[itemID]
  else
    local category = itemID // 1000000
    if category == 1 then
      itemName = self:getStringPool(___MOD.string.format("Eqp.img/Eqp/%s/%d/name", ___MOD._EquipManager:getStringCategoryNameById(itemID), itemID))
    elseif category == 2 then
      itemName = self:getStringPool(___MOD.string.format("Consume.img/%d/name", itemID))
    elseif category == 3 then
      itemName = self:getStringPool(___MOD.string.format("Ins.img/%d/name", itemID))
    elseif category == 4 then
      itemName = self:getStringPool(___MOD.string.format("Etc.img/Etc/%d/name", itemID))
    elseif category == 5 then
      itemName = self:getStringPool(___MOD.string.format("Cash.img/%d/name", itemID))
      if ___MOD._ItemManager:isPet(itemID) then
        itemName = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Pet.img/%d/name", itemID))
      end
    end
    self.itemNameCache[itemID] = itemName
  end
  return itemName
end

function StringPoolManager.getMapCategoryById(self, mapId)
  if 10000 <= mapId and mapId < 3000000 then
    return "maple"
  elseif mapId < 200000000 then
    return "victoria"
  elseif mapId < 300000000 then
    return "ossyria"
  elseif mapId < 400000000 then
    return "elin"
  elseif mapId < 600000000 then
    return "thai"
  elseif mapId < 690000000 then
    return "global"
  elseif mapId < 710000000 then
    return "china"
  elseif mapId < 750000000 then
    return "taiwan"
  elseif mapId < 810000000 then
    return "japan"
  elseif 900000000 <= mapId then
    return "etc"
  end
  return ""
end

function StringPoolManager.getMapName(self, mapID)
  if mapID == 999999999 then
    return ""
  end
  return self:getStringPool(___MOD.string.format("Map.img/%s/%d/mapName", self:getMapCategoryById(mapID), mapID))
end

function StringPoolManager.getMobName(self, mobID)
  return self:getStringPool(___MOD.string.format("Mob.img/%d/name", mobID))
end

function StringPoolManager.getSkillName(self, skillID)
  return self:getStringPool(___MOD.string.format("Skill.img/%07d/name", skillID))
end

function StringPoolManager.getStringPool(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.cache
  local pos = 1
  while node do
    local s, e = find(path, "/", pos, true)
    local key = s and sub(path, pos, s - 1) or sub(path, pos)
    node = node[key]
    if not node then
      cacheTbl[path] = ""
      return ""
    end
    if not s then
      local v = ___MOD._WzUtils:getString(node, "")
      cacheTbl[path] = v
      return v
    end
    pos = s + 1
  end
end

function StringPoolManager.getStringPoolTable(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.cache
  local pos = 1
  while node do
    local s, e = find(path, "/", pos, true)
    local key = s and sub(path, pos, s - 1) or sub(path, pos)
    node = node[key]
    if not node then
      cacheTbl[path] = ""
      return nil
    end
    if not s then
      local v = node or nil
      cacheTbl[path] = v
      return v
    end
    pos = s + 1
  end
end

function StringPoolManager.getToolTipDesc(self, mapID, toolTipID)
  return self:getStringPool(___MOD.string.format("ToolTipHelp.img/Mapobject/%d/%d/Desc", mapID, toolTipID))
end

function StringPoolManager.getToolTipTitle(self, mapID, toolTipID)
  return self:getStringPool(___MOD.string.format("ToolTipHelp.img/Mapobject/%d/%d/Title", mapID, toolTipID))
end

function StringPoolManager.loadStringPool(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable("String_wz")
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  local skipkeys = {
    ["MonsterBook.img"] = true
  }
  for i = 1, count do
    local key = get(ds, i, 1)
    if not skipkeys[key] then
      local trimmed, _ = key:gsub("%.img$", "")
      local data = get(ds, i, 2)
      data = ___MOD._WzUtils:parseWzData(data)
      if ___MOD.type(data) == "table" then
        self.stringCache[trimmed] = {}
        for k, v in ___MOD.pairs(data) do
          if trimmed == "Eqp" then
            for part, vv in ___MOD.pairs(v) do
              for itemID, vvv in ___MOD.pairs(vv) do
                self.stringCache[trimmed][___MOD.tonumber(itemID)] = ___MOD._WzUtils:getString(vvv.name, "")
              end
            end
          elseif trimmed == "Cash" or trimmed == "Consume" or trimmed == "Ins" then
            for type, vv in ___MOD.pairs(v) do
              if type == "name" then
                self.stringCache[trimmed][___MOD.tonumber(k)] = ___MOD._WzUtils:getString(vv, "")
              end
            end
          elseif trimmed == "Etc" then
            for itemID, vv in ___MOD.pairs(v) do
              for type, vvv in ___MOD.pairs(vv) do
                if type == "name" then
                  self.stringCache[trimmed][___MOD.tonumber(itemID)] = ___MOD._WzUtils:getString(vvv, "")
                end
              end
            end
          elseif trimmed == "Map" then
            for area, vv in ___MOD.pairs(v) do
              for t, vvv in ___MOD.pairs(vv) do
                if t == "mapName" then
                  self.stringCache[trimmed][___MOD.tonumber(area)] = ___MOD._WzUtils:getString(vvv, "")
                end
              end
            end
          else
            local name = v.name
            if name ~= nil then
              local value = ___MOD._WzUtils:getString(name, "")
              self.stringCache[trimmed][___MOD.tonumber(k)] = value
            end
          end
        end
        self.cache[key] = data
        count1 = count1 + 1
      end
    end
  end
  ___MOD.log(___MOD.string.format("Loaded String.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
  ___MOD.setmetatable(self.pathValueCache, {__mode = "kv"})
  ___MOD._DataLoadManager:compeletedLoad()
end
