

function BaseManager.getStandardPDD(self, job, level)
  local levelTable = self.standardPDD[job]
  if not levelTable then
    return 0
  end
  local closestLevel
  for k, _ in ___MOD.pairs(levelTable) do
    if k <= level and (closestLevel == nil or k > closestLevel) then
      closestLevel = k
    end
  end
  if closestLevel == nil then
    local minLevel = ___MOD.math.huge
    for k, _ in ___MOD.pairs(levelTable) do
      if k < minLevel then
        minLevel = k
      end
    end
    closestLevel = minLevel
  end
  return levelTable[closestLevel]
end

function BaseManager.loadBase(self)
  local dataset = ___MOD._DataService:GetTable("Base_wz")
  local rowCount = dataset:GetRowCount()
  local get = dataset.GetCell
  for i = 1, rowCount do
    local key = get(dataset, i, 1)
    local data = ___MOD._WzUtils:parseWzData(get(dataset, i, 2))
    if ___MOD.type(data) == "table" then
      if key == "StandardPDD.img" then
        for job, v in ___MOD.pairs(data) do
          self.standardPDD[___MOD.tonumber(job)] = {}
          for level, pdd in ___MOD.pairs(v) do
            self.standardPDD[___MOD.tonumber(job)][___MOD.tonumber(level)] = ___MOD._WzUtils:getInteger(pdd, 0)
          end
        end
      end
      self.count = self.count + 1
    end
  end
  local time = ___MOD._UtilLogic.ElapsedSeconds
  ___MOD.log(___MOD.string.format("Loaded Base.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end
