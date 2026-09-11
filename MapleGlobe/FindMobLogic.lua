

function FindMobLogic.checkMobInTrapezoid(self, x0, x1, x2, y, r, left, mob, finalBoxShape)
  local boxShape = finalBoxShape
  local mobBox = ___MOD._NumberUtils:triggerToBox(mob.TriggerComponent)
  local origin = ___MOD.FastVector2(0, 0)
  local anchor = ___MOD.FastVector2(0, -0.5)
  local size = ___MOD.FastVector2(0, 0)
  local i = 1
  while x1 < x2 do
    local range = x2 - x1
    local height = x1 / r
    origin[1] = x0
    origin[2] = y
    size[1] = range
    size[2] = height * 2
    self:makeBoxShape(origin, anchor, size, left, boxShape)
    local p = ___MOD._NumberUtils:intersectBox(boxShape, mobBox)
    if p then
      return true
    end
    x1 = x1 + 0.2
    if left then
      x0 = x0 - 0.2
    else
      x0 = x0 + 0.2
    end
    i = i + 1
  end
  return false
end

function FindMobLogic.findHitDazzledMobInRect(self, box, output, maxCount, owner)
  local simulator = ___MOD._CollisionService:GetSimulator(___MOD._UserService.LocalPlayer)
  local overlap = simulator:OverlapAll("Monster", box)
  local count = 0
  local dedicated = owner and ___MOD._DedicatedMonsterLogic or nil
  local useDedicated = dedicated and owner.CurrentMap and dedicated:isEnabledMap(owner.CurrentMap)
  for i = 1, #overlap do
    if maxCount <= count then
      break
    end
    local trigger = overlap[i]
    local mobEntity = trigger.Entity
    local mob = mobEntity.MobComponent
    if trigger.EnableInHierarchy and mob.EnableInHierarchy and not mob:isDead() and mob.init and not mob.suspended and not mob.damagedByMob and (not useDedicated or dedicated:isOwnedMob(owner, mob.Entity)) then
      local temporary = mobEntity.MobTemporaryStatComponent
      if temporary:getValue(___MOD._MTS.Dazzle) ~= 0 then
        output[#output + 1] = mob.Entity
        count = count + 1
      end
    end
  end
  return count
end

function FindMobLogic.findHitMobByChainLightning(self, firstMob, output, maxCount, isFaceLeft, horizontalRange, owner)
  if output == nil or maxCount <= 0 or horizontalRange <= 0 then
    return 0
  end
  if not ___MOD.isvalid(firstMob) or not ___MOD.isvalid(firstMob.TransformComponent) then
    return 0
  end
  local firstMobComponent = firstMob.MobComponent
  if not ___MOD.isvalid(firstMobComponent) or not firstMobComponent.EnableInHierarchy then
    return 0
  end
  if not (not firstMobComponent:isDead() and firstMobComponent.init) or firstMobComponent.suspended or firstMobComponent.damagedByMob then
    return 0
  end
  local firstTemporary = firstMob.MobTemporaryStatComponent
  if firstTemporary == nil or firstTemporary:getValue(___MOD._MTS.Dazzle) ~= 0 then
    return 0
  end
  local dedicated = owner and ___MOD._DedicatedMonsterLogic or nil
  local useDedicated = dedicated and owner.CurrentMap and dedicated:isEnabledMap(owner.CurrentMap)
  if useDedicated and not dedicated:isOwnedMob(owner, firstMob) then
    return 0
  end
  local hitSet = {}
  output[#output + 1] = firstMob
  hitSet[firstMob] = true
  local count = 1
  local currentMob = firstMob
  local firstPosition = firstMob.TransformComponent:WorldPositionAsFastVector3()
  local firstClampX = 4.0
  local verticalHalfRange = 1.5
  while maxCount > count and ___MOD.isvalid(currentMob) and ___MOD.isvalid(currentMob.TransformComponent) do
    local currentPosition = currentMob.TransformComponent:WorldPositionAsFastVector3()
    local rectLeft, rectRight
    if isFaceLeft then
      rectLeft = ___MOD.math.max(firstPosition[1] - firstClampX, currentPosition[1] - horizontalRange)
      rectRight = currentPosition[1]
    else
      rectLeft = currentPosition[1]
      rectRight = ___MOD.math.min(firstPosition[1] + firstClampX, currentPosition[1] + horizontalRange)
    end
    local rectCenter = ___MOD.Vector2((rectLeft + rectRight) * 0.5, currentPosition[2])
    local rectSize = ___MOD.Vector2(rectRight - rectLeft, verticalHalfRange * 2)
    local searchShape = ___MOD.BoxShape(rectCenter, rectSize, 0)
    local candidates = {}
    local rawCount = self:findHitMobInRect(searchShape, candidates, 10, currentMob, 0, 0, 0, false, owner)
    local candidateCount = rawCount & 65535
    local nextMob
    local nearestDistanceSquared = ___MOD.math.huge
    for i = 1, candidateCount do
      local candidate = candidates[i]
      if ___MOD.isvalid(candidate) and not hitSet[candidate] and ___MOD.isvalid(candidate.TransformComponent) then
        local candidatePosition = candidate.TransformComponent:WorldPositionAsFastVector3()
        local dx = candidatePosition[1] - currentPosition[1]
        local dy = candidatePosition[2] - currentPosition[2]
        local distanceSquared = dx * dx + dy * dy
        if nearestDistanceSquared > distanceSquared then
          nearestDistanceSquared = distanceSquared
          nextMob = candidate
        end
      end
    end
    if nextMob == nil then
      break
    end
    output[#output + 1] = nextMob
    hitSet[nextMob] = true
    currentMob = nextMob
    count = count + 1
  end
  return count
end

function FindMobLogic.findHitMobInRect(self, box, output, maxCount, except, wishMobID, priorBuffID, wishTemplateID, includeDazzled, owner)
  local simulator = ___MOD._CollisionService:GetSimulator(___MOD._UserService.LocalPlayer)
  local overlap = simulator:OverlapAll("Monster", box)
  local count = 0
  local count_prior = 0
  local dedicated = owner and ___MOD._DedicatedMonsterLogic or nil
  local useDedicated = dedicated and owner.CurrentMap and dedicated:isEnabledMap(owner.CurrentMap)

  local function isValidTarget(trigger)
    if trigger == nil or not trigger.EnableInHierarchy then
      return false
    end
    local mobEntity = trigger.Entity
    local mob = mobEntity and mobEntity.MobComponent or nil
    if mob == nil or not mob.EnableInHierarchy then
      return false
    end
    if not (not mob:isDead() and mob.init) or mob.suspended or mob.damagedByMob then
      return false
    end
    if except and except == mob.Entity then
      return false
    end
    if wishTemplateID and 0 < wishTemplateID and wishTemplateID ~= mob.id then
      return false
    end
    if useDedicated and not dedicated:isOwnedMob(owner, mob.Entity) then
      return false
    end
    return true
  end

  local function isPriorTarget(mobEntity)
    if priorBuffID == nil or priorBuffID <= 0 or mobEntity == nil then
      return false
    end
    local mts = mobEntity.MobTemporaryStatComponent
    return mts ~= nil and mts:getSkillID(___MOD._MTS.Poison) == priorBuffID
  end

  for i = 1, #overlap do
    if maxCount <= count then
      break
    end
    local trigger = overlap[i]
    local mob = trigger.Entity.MobComponent
    if trigger.EnableInHierarchy and mob.EnableInHierarchy and not mob:isDead() and mob.init and not mob.suspended and not mob.damagedByMob and (not except or except ~= mob.Entity) and (not (wishTemplateID and 0 < wishTemplateID) or wishTemplateID == mob.id) and (not useDedicated or dedicated:isOwnedMob(owner, mob.Entity)) then
      local mobTemporary = mob.Entity.MobTemporaryStatComponent
      if includeDazzled or mobTemporary:getValue(___MOD._MTS.Dazzle) == 0 then
        if priorBuffID and 0 < priorBuffID and mobTemporary:getSkillID(___MOD._MTS.Poison) == priorBuffID then
          count_prior = count_prior + 1
        end
        output[#output + 1] = mob.Entity
        count = count + 1
      end
    end
  end
  return count | count_prior << 16
end

function FindMobLogic.findHitMobInTrapezoid(self, x0, x1, x2, y, r, output, left, finalBoxShape)
  local boxShape = finalBoxShape
  local origin = ___MOD.FastVector2(0, 0)
  local anchor = ___MOD.FastVector2(0, -0.5)
  local size = ___MOD.FastVector2(0, 0)
  local i = 1
  while x1 < x2 do
    local range = x2 - x1
    local height = x1 / r
    origin[1] = x0
    origin[2] = y
    size[1] = range
    size[2] = height * 2
    self:makeBoxShape(origin, anchor, size, left, boxShape)
    local count = self:findHitMobInRect(boxShape, output, 15, nil, 0, 0, 0, false, nil)
    if 0 < count then
      return count
    end
    x1 = x1 + 0.2
    if left then
      x0 = x0 - 0.2
    else
      x0 = x0 + 0.2
    end
    i = i + 1
  end
  return 0
end

function FindMobLogic.findLiveMobPointInRect(self, mapLife, output, box, maxCount, except, excludeBoss, owner)

end

function FindMobLogic.findNearestMob(self, pos, dazzeld, owner)
  local lt = self.nearestMob_lt
  local rb = self.nearestMob_rb
  local box = ___MOD._NumberUtils:makeBoxShapeFromLtRb(pos, lt, rb, true)
  local mobs = {}
  local result
  if dazzeld then
    result = self:findHitDazzledMobInRect(box, mobs, 5, owner)
  else
    result = self:findHitMobInRect(box, mobs, 10, nil, 0, 0, 0, false, owner)
  end
  if result == 0 then
    return nil
  end
  local nearest
  local dst = ___MOD.math.huge
  for i = 1, result do
    local mob = mobs[i]
    local mobPos = mob.TransformComponent:WorldPositionAsFastVector3()
    local dx = mobPos[1] - pos.x
    local dy = mobPos[2] - pos.y
    local d = dx * dx + dy * dy
    if dst > d then
      dst = d
      nearest = mob
    end
  end
  return nearest
end

function FindMobLogic.isRectIntersectWithTrapezoid(self, x0, x1, x2, y, r, left, b, finalBoxShape)
  local boxShape = finalBoxShape
  local box = b
  local origin = ___MOD.FastVector2(0, 0)
  local anchor = ___MOD.FastVector2(0, -0.5)
  local size = ___MOD.FastVector2(0, 0)
  local i = 1
  while x1 < x2 do
    local range = x2 - x1
    local height = x1 / r
    origin[1] = x0
    origin[2] = y
    size[1] = range
    size[2] = height * 2
    self:makeBoxShape(origin, anchor, size, left, boxShape)
    local p = ___MOD._NumberUtils:intersectBox(boxShape, box)
    if p then
      return true
    end
    x1 = x1 + 0.2
    if left then
      x0 = x0 - 0.2
    else
      x0 = x0 + 0.2
    end
    i = i + 1
  end
  return false
end

function FindMobLogic.makeBoxShape(self, origin, anchor, size, left, output)
  if output == nil then
    return
  end
  local box = output
  local a = ___MOD.FastVector2(0, 0)
  a[1] = anchor[1] + 0.5
  a[2] = anchor[2] + 0.5
  if left then
    a[1] = a[1] - 1.0
  end
  box.Position = origin + size * a
  box.Size = size
  box.Angle = 0
end
