

function AntiRepeat.clearRepeat(self)
  local countLimit = self.countLimit
  countLimit[1] = 20
  countLimit[2] = 100
  countLimit[3] = 500
  local repeatCount = self.repeatCount
  repeatCount[1] = 0
  repeatCount[2] = 0
  repeatCount[3] = 0
  self.lastPos = ___MOD.FastVector2(0, 0)
end

function AntiRepeat.OnBeginPlay(self)
  self:clearRepeat()
end

function AntiRepeat.tryRepeat(self, type)
  if type < ___MOD._AntiRepeatType.Buff or type > ___MOD._AntiRepeatType.Hurricane then
    ___MOD.log_error("[tryRepat] 타입 오류! 1-버프 2-공격 3-폭시", type)
    return
  end
  local pos = ___MOD._UserService.LocalPlayer.TransformComponent:WorldPositionAsFastVector3()
  local lastPos = self.lastPos
  local dx = ___MOD.math.abs(lastPos[1] - pos[1])
  local dy = ___MOD.math.abs(lastPos[2] - pos[2])
  local repeatCount = self.repeatCount
  if 0.06 <= dx or 1.5 <= dy then
    lastPos[1] = pos[1]
    lastPos[2] = pos[2]
    repeatCount[type] = 0
    return true
  elseif repeatCount[type] < self.countLimit[type] then
    repeatCount[type] = repeatCount[type] + 1
    return true
  else
    return false
  end
end
