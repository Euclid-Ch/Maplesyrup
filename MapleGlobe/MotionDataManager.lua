

function MotionDataManager.cacheMotionData(self, motionname, info)
  self.motionData[motionname] = info
  local totalDelay = 0
  for _, frame in ___MOD.pairs(info or {}) do
    totalDelay = totalDelay + ___MOD.math.abs(___MOD.tonumber(frame.delay) or 0)
  end
  local totalDelaySec = totalDelay / 1000
  self.motionTotalDelaySec[motionname] = totalDelaySec
  self.motionMinDelaySec[motionname] = totalDelaySec * 0.75
end

function MotionDataManager.getMotionData(self, motionname)
  if self.motionData[motionname] then
    return self.motionData[motionname]
  end
  local data = ___MOD._DataService:GetTable("MotionData")
  local row = data:FindRow("motionName", motionname)
  if not row then
    ___MOD.log("[MotionData] 존재하지 않는 모션 이름: " .. motionname)
    return {}
  end
  local rawInfo = row:GetItem("info")
  local info = ___MOD._HttpService:JSONDecode(rawInfo)
  self:cacheMotionData(motionname, info)
  return info
end

function MotionDataManager.getMotionDelayAtAttackSpeed(self, motionname, attackSpeed)
  local speed = ___MOD.math.min(9, ___MOD.math.max(2, attackSpeed))
  return self:getMotionTotalDelaySec(motionname) * (speed + 10) / 16
end

function MotionDataManager.getMotionMinDelay(self, motionname)
  if self.motionMinDelaySec[motionname] == nil then
    self:getMotionTotalDelaySec(motionname)
  end
  return ___MOD.tonumber(self.motionMinDelaySec[motionname]) or 0
end

function MotionDataManager.getMotionTotalDelaySec(self, motionname)
  if self.motionTotalDelaySec[motionname] == nil then
    local info = self:getMotionData(motionname)
    if self.motionTotalDelaySec[motionname] == nil then
      self:cacheMotionData(motionname, info)
    end
  end
  return ___MOD.tonumber(self.motionTotalDelaySec[motionname]) or 0
end

function MotionDataManager.loadMotion(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local data = ___MOD._DataService:GetTable("MotionData")
  local rows = data:GetAllRow()
  for _, row in ___MOD.ipairs(rows) do
    local motionname = row:GetItem("motionName")
    local rawInfo = row:GetItem("info")
    local info = ___MOD._HttpService:JSONDecode(rawInfo)
    self:cacheMotionData(motionname, info)
  end
  ___MOD.log(___MOD.string.format("Loaded MotionData (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, #rows))
  ___MOD._DataLoadManager:compeletedLoad()
end
