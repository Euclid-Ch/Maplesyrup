

function MobKnockbackLogic.clampKnockbackMapEdge(self, mob)
  if not (___MOD.isvalid(mob) and ___MOD.isvalid(mob.MobComponent)) or mob.MobComponent:isDead() then
    return
  end
  local map = mob.CurrentMap
  if not (___MOD.isvalid(map) and ___MOD.isvalid(map.MapInfoComponent)) or map.MapInfoComponent.fieldType ~= 14 then
    return
  end
  local mv = mob.MovementComponent
  if not ___MOD.isvalid(mv) then
    return
  end
  local minX = map.MapComponent.LeftBottom.x + 0.1
  local maxX = map.MapComponent.RightTop.x - 0.1
  local pos = mob.TransformComponent.WorldPosition:ToVector2()
  if minX <= pos.x and maxX >= pos.x then
    return
  end
  local clampedX = ___MOD.math.min(maxX, ___MOD.math.max(minX, pos.x))
  local newY = pos.y
  local footholds = map.FootholdComponent
  if ___MOD.isvalid(footholds) then
    local fh = footholds:Raycast(___MOD.Vector2(clampedX, pos.y + 0.5), ___MOD.Vector2.down, 5)
    if fh == nil then
      fh = footholds:Raycast(___MOD.Vector2(clampedX, pos.y), ___MOD.Vector2.up, 5)
    end
    if fh ~= nil then
      local groundY = fh:GetYByX(clampedX)
      if newY < groundY then
        newY = groundY + 0.01
      end
    end
  end
  mv:SetWorldPosition(___MOD.Vector2(clampedX, newY))
  mv:Stop()
  local rb = mob.MobRigidbodyComponent
  if ___MOD.isvalid(rb) then
    rb:SetForce(___MOD.FastVector2.zero:Clone())
  end
end

function MobKnockbackLogic.updateFlyKnockbackPath(self, mob, hitByLeft, knockbackType, senderUid, mobPosSnapshot)
  local kb = mob.MobKnockbackComponent
  local ai = mob.MobAIComponent
  local rb = mob.MobRigidbodyComponent
  local map = mob.CurrentMap
  local boundLt, boundRb = map.MapComponent:GetBound()
  local minX = boundLt.x + 0.1
  local maxX = boundRb.x - 0.1
  local mobPos = mobPosSnapshot or mob.TransformComponent.WorldPosition:ToVector2()
  local sqrt = ___MOD.math.sqrt
  local elapse = 0
  local knockbackMoveEnd = 0.35
  if knockbackType == 2 then
    knockbackMoveEnd = 0.5
  end
  local interruptedEnd = knockbackMoveEnd + 0.2
  local timelines = {}
  local timelineIndex = 0
  local currentX = mobPos.x
  local currentY = mobPos.y

  local function makeDistance(x1, y1, x2, y2)
    return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
  end

  kb:setShoeAttr(___MOD.math.max(0, knockbackType), 1, 1)
  local knockbackSpeed = rb.WalkSpeed * mob.MobComponent.flySpeed / 100
  if ___MOD.isvalid(map.MapInfoComponent) and map.MapInfoComponent.fieldType == 14 then
    local flyKnockbackSpeed = knockbackSpeed * 1.5
    if 0 < flyKnockbackSpeed then
      local moveDirX = hitByLeft and 1 or -1
      local movableDist = ___MOD.math.max(0, 0 < moveDirX and maxX - mobPos.x or mobPos.x - minX)
      knockbackMoveEnd = ___MOD.math.min(knockbackMoveEnd, movableDist / flyKnockbackSpeed)
      interruptedEnd = knockbackMoveEnd + 0.2
    end
  end

  local function makeFlyCommand(cmd, v, duration)
    timelines[timelineIndex + 1] = {
      cmd,
      {v, duration},
      0
    }
    timelineIndex = timelineIndex + 1
    return duration
  end

  local function makeCommand(cmd, value, nextTime)
    timelines[timelineIndex + 1] = {
      cmd,
      value,
      nextTime
    }
    timelineIndex = timelineIndex + 1
  end

  local inputX = 1
  if not hitByLeft then
    inputX = -1
  end
  makeCommand(___MOD._MobActionPartType.HitMotion, 1, 0)
  makeFlyCommand(___MOD._MobActionPartType.KnockbackFly, inputX, 0)
  makeFlyCommand(___MOD._MobActionPartType.KnockbackFly, 0, knockbackMoveEnd)
  makeCommand(___MOD._MobActionPartType.HitMotion, 0, interruptedEnd)
  if 0 < timelineIndex then
    map.LifeControllerComponent2:requestControl(mob, timelines, timelineIndex, ___MOD._CommandGroup.Knockback, nil, ___MOD.isvalid(ai.Target), senderUid)
  end
end

function MobKnockbackLogic.updateKnockbackPath(self, mob, hitByLeft, knockbackType, delay, forceEndPos, baseDistance, knockbackMoveScale, knockbackWalkSpeedScale, knockbackWalkDragScale, id, senderUid, mobPosSnapshot)
  local kb = mob.MobKnockbackComponent
  local ai = mob.MobAIComponent
  local rb = mob.MobRigidbodyComponent
  local fh = rb.LastFoothold
  if ai.CachedMoveAbility <= 0 then
    return
  end
  local map = mob.CurrentMap
  local minX = map.MapComponent.LeftBottom.x + 0.1
  local maxX = map.MapComponent.RightTop.x - 0.1
  local mobPos = mobPosSnapshot or mob.TransformComponent.WorldPosition:ToVector2()
  local knockbackMoveEnd = 0.2
  local moveScale = knockbackMoveScale or 1
  local walkSpeedScale = knockbackWalkSpeedScale or 1
  local walkDragScale = knockbackWalkDragScale or 1
  local interruptedEndTime = 0.6
  if knockbackType == 2 then
    knockbackMoveEnd = 0.5
  elseif knockbackType == 3 then
    local baseDist = baseDistance
    local baseTime = 0.13
    local distance = mobPos:Distance(forceEndPos)
    knockbackMoveEnd = distance * (baseTime / baseDist)
  elseif knockbackType == 4 then
    local baseDist = baseDistance
    local baseTime = 0.1
    local distance = mobPos:Distance(forceEndPos)
    knockbackMoveEnd = distance * (baseTime / baseDist)
  elseif knockbackType == 5 then
    local baseTime = 0.1
    local distance = mobPos:Distance(forceEndPos)
    knockbackMoveEnd = distance * baseTime / ___MOD.math.max(0.01, moveScale)
    interruptedEndTime = interruptedEndTime / moveScale
  end
  if ___MOD.isvalid(map.MapInfoComponent) and map.MapInfoComponent.fieldType == 14 then
    local knockbackSpeed = kb:getKnockbackWalkSpeed(knockbackType, walkSpeedScale)
    if 0 < knockbackSpeed then
      local moveDirX = hitByLeft and 1 or -1
      local movableDist = ___MOD.math.max(0, 0 < moveDirX and maxX - mobPos.x or mobPos.x - minX)
      knockbackMoveEnd = ___MOD.math.min(knockbackMoveEnd, movableDist / knockbackSpeed)
    end
  end
  local interruptedEnd = knockbackType == 5 and knockbackMoveEnd + interruptedEndTime or knockbackMoveEnd + 0.6
  local elapse = 0
  local timelines = {}
  local timelineIndex = 0
  local lastTimeline = 0

  local function makeCommand(cmd, value, timeline, val2, val3, val4, val5)
    timelines[timelineIndex + 1] = {
      cmd,
      value,
      timeline - lastTimeline,
      val2 or 0,
      val3 or 1,
      val4 or 1,
      val5 or false
    }
    timelineIndex = timelineIndex + 1
    lastTimeline = timeline
  end

  local function resetCommands()
    timelines = {}
    timelineIndex = 0
    lastTimeline = 0
  end

  local inputX = hitByLeft and -1 or 1
  if id == nil then
  end
  local ignoreDead = id
  makeCommand(___MOD._MobActionPartType.HitMotion, 1, 0, nil, 1, 1, ignoreDead)
  if knockbackType ~= -1 then
    makeCommand(___MOD._MobActionPartType.Knockback, inputX, 0, knockbackType, walkSpeedScale, walkDragScale, ignoreDead)
    makeCommand(___MOD._MobActionPartType.Knockback, 0, knockbackMoveEnd, 0, 1, 1, ignoreDead)
    makeCommand(___MOD._MobActionPartType.HitMotion, 0, interruptedEnd, nil, 1, 1, ignoreDead)
  end
  if 0 < timelineIndex then
    map.LifeControllerComponent2:requestControl(mob, timelines, timelineIndex, ___MOD._CommandGroup.Knockback, ignoreDead, ___MOD.isvalid(ai.Target), ai.Controller and ai.Controller.PlayerComponent.UserId or senderUid)
  end
end
