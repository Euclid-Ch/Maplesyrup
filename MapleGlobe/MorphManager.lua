

function MorphManager.getMorph(self, morphID)
  return self.morphData[morphID]
end

function MorphManager.loadMorph(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local dataset = ___MOD._DataService:GetTable("Morph_wz")
  local d = {}
  if dataset ~= nil then
    local rowCount = dataset:GetRowCount()
    for i = 1, rowCount do
      ___MOD.id = ___MOD.tonumber(___MOD._UtilLogic:Replace(dataset:GetCell(i, "key"), ".img", ""))
      ___MOD.data = ___MOD._WzUtils:parseWzData(dataset:GetCell(i, "data"))
      if ___MOD.type(___MOD.data) == "table" then
        d[___MOD.id] = {}
        for dirName, dir in ___MOD.pairs(___MOD.data) do
          if dirName == "info" then
            local info = ___MOD.MorphInfo()
            info:loadData(dir)
            d[___MOD.id][dirName] = info
          else
            d[___MOD.id][dirName] = ___MOD._WzUtils:parseAnimation(dir)
          end
          self.count = self.count + 1
        end
      end
    end
    self.morphData = d
  end
  ___MOD.log(___MOD.string.format("Loaded Morph.wz (Full) (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end
