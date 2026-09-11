

function _RUIDManager.get(self, path)
  return self.cache[path] or ""
end

function _RUIDManager.getByCollection(self, collection, path)
  local byCollection = self.collectionCache[collection]
  if byCollection == nil then
    return ""
  end
  return byCollection[path] or ""
end

function _RUIDManager.getKeyByValue(self, value)
  if ___MOD._UtilLogic:IsNilorEmptyString(value) then
    return ""
  end
  local cached = self.reverseCache[value]
  if cached ~= nil then
    return cached
  end
  for k, v in ___MOD.pairs(self.cache) do
    if v == value then
      self.reverseCache[value] = k
      return k
    end
  end
  self.reverseCache[value] = ""
  return ""
end

function _RUIDManager.loadRUID(self)
  self:loadRUIDData("UIRUID")
  self:loadRUIDData("ItemRUID")
  self:loadRUIDData("MSWRUID")
  self:loadRUIDData("CharacterRUID")
  self:loadRUIDData("NpcRUID")
  self:loadRUIDData("MobRUID")
  self:loadRUIDData("SkillRUID")
  self:loadRUIDData("MapRUID")
  self:loadRUIDData("ObjRUID")
  self:loadRUIDData("BackRUID")
  self:loadRUIDData("SoundRUID")
  self:loadRUIDData("EffectRUID")
  self:loadRUIDData("ReactorRUID")
  self:loadRUIDData("MorphRUID")
  ___MOD._DataLoadManager:compeletedLoad()
  self.loadCompleted = true
end

function _RUIDManager.loadRUIDData(self, collection)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable(collection)
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  local byCollection = self.collectionCache[collection]
  if byCollection == nil then
    byCollection = {}
    self.collectionCache[collection] = byCollection
  end
  for i = 1, count do
    local key = get(ds, i, 1)
    local value = get(ds, i, 2)
    self.cache[key] = value
    byCollection[key] = value
    count1 = count1 + 1
  end
  ___MOD.log(___MOD.string.format("Loaded %s Table (%.2f secs) Count : %d", collection, ___MOD._UtilLogic.ElapsedSeconds - time, count1))
end
