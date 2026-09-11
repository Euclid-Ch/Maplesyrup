

function MobWalkLogic.updateMovePath(self, mob)
  local m = mob.MobComponent
  local ai = mob.MobAIComponent
  local kb = mob.MobKnockbackComponent
  local rb = mob.MobRigidbodyComponent
  if not ___MOD.isvalid(rb) then
    if ___MOD.isvalid(ai) then
      ai:enableNextControlTimer(0.1, false)
    end
    return
  end
  local curMap = mob.CurrentMap
  local mobPos = mob.TransformComponent:WorldPositionAsFastVector3()
  local underFhId = ___MOD._FootholdLogic:getFootholdUnderneath(mob, 0.05)
  local outBoundMob = not ___MOD._NumberUtils:pointInRect(mobPos:ToVector2(), m.mapBound) or underFhId == 0
  local fh = rb.LastFoothold
  if fh == 0 and not outBoundMob then
    ai:enableNextControlTimer(0.1, false)
    return
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  if now < ai.NextActionTime then
    ai:enableNextControlTimer(___MOD.math.max(ai.NextActionTime - now, 0) + 0.1, false)
    return
  end
  local target = ai.Target
  local nextAction = 0
  local newInputX
  local mobX = mobPos.x
  if ___MOD.isvalid(target) and ai.LocalUnchaseTick < 30 then
    nextAction = ___MOD._GlobalRand32:randomIntegerRange(1000, 1600) / 1000
    local targetX = target.TransformComponent:WorldPositionAsFastVector3()[1]
    newInputX = mobX < targetX and 1 or -1
  else
    nextAction = ___MOD._GlobalRand32:randomIntegerRange(1000, 3000) / 1000
    newInputX = ___MOD._GlobalRand32:randomIntegerRange(-1, 1)
  end
  local platforms = curMap.PlatformInfoComponent
  local timelines = {}
  local timelineIndex = 0
  local lastTimeline = 0
  local playerFh = ___MOD._UserService.LocalPlayer.PlayerVariables.lastFoothold
  if playerFh == 0 or platforms.ZMass[playerFh] ~= ai.LocalStartChaseZMass then
    ai.LocalUnchaseTick = ai.LocalUnchaseTick + 1
  end

  local function makeCommand(cmd, value, timeline, nextActionTime, reset)
    timelines[timelineIndex + 1] = {
      cmd,
      value,
      timeline - lastTimeline,
      nextActionTime,
      reset
    }
    timelineIndex = timelineIndex + 1
    lastTimeline = timeline
  end

  makeCommand(___MOD._MobActionPartType.Move, newInputX, 0, nextAction, outBoundMob)
  ai.NextRandomJump = ___MOD.math.max(ai.NextRandomJump, now + 1)
  kb:setShoeAttr(0, nil, nil)
  if 0 < timelineIndex then
    curMap.LifeControllerComponent2:requestControl(mob, timelines, timelineIndex, ___MOD._CommandGroup.Move, nil, ___MOD.isvalid(ai.Target))
  end
  ai:enableNextControlTimer(nextAction, false)
end

function MobWalkLogic.updateMovePathStop(self, mob)
  local m = mob.MobComponent
  local ai = mob.MobAIComponent
  local kb = mob.MobKnockbackComponent
  local rb = mob.MobRigidbodyComponent
  if not ___MOD.isvalid(rb) then
    if ___MOD.isvalid(ai) then
      ai:enableNextControlTimer(0.1, false)
    end
    return
  end
  local mobPos = mob.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  local underFhId = ___MOD._FootholdLogic:getFootholdUnderneath(mob, 0.05)
  local reset = not ___MOD._NumberUtils:pointInRect(mobPos, m.mapBound) or underFhId == 0
  local fh = rb.LastFoothold
  if fh == 0 and not reset then
    ai:enableNextControlTimer(0.1, false)
    return
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  if now < ai.NextActionTime then
    ai:enableNextControlTimer(___MOD.math.max(ai.NextActionTime - now, 0) + 0.1, false)
    return
  end
  local target = ai.Target
  local nextAction = ___MOD._GlobalRand32:randomIntegerRange(240, 390) / 1000
  local newInputX = m.faceLeft and -1 or 1
  local mobX = mobPos[1]
  local validTarget = ___MOD.isvalid(target)
  if validTarget and ai.LocalUnchaseTick < 30 then
    local targetX = target.TransformComponent:WorldPositionAsFastVector3()[1]
    newInputX = mobX < targetX and 1 or -1
  end
  local platforms = mob.CurrentMap.PlatformInfoComponent
  local timelines = {}
  local timelineIndex = 0
  local lastTimeline = 0
  local playerFh = ___MOD._UserService.LocalPlayer.PlayerVariables.lastFoothold
  if playerFh == 0 or platforms.ZMass[playerFh] ~= ai.LocalStartChaseZMass then
    ai.LocalUnchaseTick = ai.LocalUnchaseTick + 1
  end

  local function makeCommand(cmd, value, timeline, nextActionTime, reset)
    timelines[timelineIndex + 1] = {
      cmd,
      value,
      timeline - lastTimeline,
      nextActionTime,
      reset
    }
    timelineIndex = timelineIndex + 1
    lastTimeline = timeline
  end

  makeCommand(___MOD._MobActionPartType.Move, newInputX, 0, nextAction, reset)
  ai.NextRandomJump = ___MOD.math.max(ai.NextRandomJump, now + 1)
  kb:setShoeAttr(0, nil, nil)
  if 0 < timelineIndex then
    mob.CurrentMap.LifeControllerComponent2:requestControl(mob, timelines, timelineIndex, ___MOD._CommandGroup.Move, nil, ___MOD.isvalid(ai.Target))
  end
  ai:enableNextControlTimer(nextAction, false)
end
