

function MobFlyLogic.updateMovePath(self, mob)
  local ai = mob.MobAIComponent
  local kb = mob.MobKnockbackComponent
  local rb = mob.MobRigidbodyComponent
  if not (___MOD.isvalid(rb) and ___MOD.isvalid(kb)) or not ___MOD.isvalid(ai) then
    ai:enableNextControlTimer(0.1, false)
    local hasAI = ai ~= nil and 1 or 0
    local hasKnockback = kb ~= nil and 1 or 0
    local hasRigid = rb ~= nil and 1 or 0
    ___MOD.log_warning(___MOD.string.format("hasAI: %d  hasKnockback: %d  hasRigid: %d", hasAI, hasKnockback, hasRigid))
    return
  end
  local target = ai.Target
  local nextAction = 0
  local inputX, inputY
  local mobPos = mob.TransformComponent.WorldPosition
  local mobX = mobPos.x
  local mobY = mobPos.y
  local abs = ___MOD.math.abs
  local sqrt = ___MOD.math.sqrt
  local platformInfo = mob.CurrentMap.PlatformInfoComponent
  local platforms = platformInfo.Platforms
  local elapse = 0.09
  local timelines = {}
  local timelineIndex = 0
  local lastDuration = 0
  local currentX, currentY = mobX, mobY

  local function makeDistance(x1, y1, x2, y2)
    return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
  end

  local function makeCommand(cmd, targetX, targetY, platformLeftX, platformRightX, layer)
    timelines[timelineIndex + 1] = {
      cmd,
      {
        targetX,
        targetY,
        platformLeftX,
        platformRightX,
        layer
      }
    }
    timelineIndex = timelineIndex + 1
  end

  if ___MOD.isvalid(target) then
    local targetPos = target.TransformComponent:WorldPositionAsFastVector3()
    local boundLt, boundRb = mob.CurrentMap.MapComponent:GetBound()

    local function jitterInBound(base, jitterMin, jitterMax, boundMin, boundMax)
      local lo = ___MOD.math.max(base + jitterMin, boundMin)
      local hi = ___MOD.math.min(base + jitterMax, boundMax)
      if lo > hi then
        return base
      end
      return lo + ___MOD._GlobalRand32:randomDouble() * (hi - lo)
    end

    targetPos.x = jitterInBound(targetPos.x, -1.2, 1.2, boundLt.x, boundRb.x)
    targetPos.y = jitterInBound(targetPos.y, -0.8, 0.0, boundLt.y, boundRb.y)
    makeCommand(___MOD._MobActionPartType.Fly, targetPos.x, targetPos.y, 0, 0, "Npc")
    if 0 < timelineIndex then
      mob.CurrentMap.LifeControllerComponent2:requestControl(mob, timelines, timelineIndex, ___MOD._CommandGroup.Fly, nil, ___MOD.isvalid(ai.Target))
    end
    nextAction = ___MOD._GlobalRand32:randomIntegerRange(500, 1000) / 1000
    ai:enableNextControlTimer(nextAction, false)
  else
    nextAction = ___MOD._GlobalRand32:randomIntegerRange(5000, 10000) / 1000
    local platformCandidates = {}
    local platformCandidatesNum = 0

    local function findTryingPlatformCandidates(range, allowSlope)
      for i = 1, #platforms do
        local checkPlatform = platforms[i]
        local left = checkPlatform.left
        local right = checkPlatform.right
        if left.x ~= right.x then
          local centerX = (left.x + right.x) / 2
          local centerY = (left.y + right.y) / 2
          local distance = makeDistance(mobX, mobY, centerX, centerY)
          if range == nil or range > distance then
            local leftY = checkPlatform.left.y
            local rightY = checkPlatform.right.y
            local leftX = checkPlatform.left.x
            local rightX = checkPlatform.right.x
            platformCandidates[platformCandidatesNum + 1] = checkPlatform
            platformCandidatesNum = platformCandidatesNum + 1
          end
        end
      end
    end

    local level = {36, 72}
    for i = 1, 3 do
      findTryingPlatformCandidates(level[i], false)
      if 0 < platformCandidatesNum then
        break
      end
    end
    if platformCandidatesNum == 0 then
      findTryingPlatformCandidates(nil, true)
    end
    if 0 < platformCandidatesNum then
      local function makeFloatingYOffset()
        return ___MOD._GlobalRand32:randomIntegerRange(-9, 50) / 100
      end

      local platform = platformCandidates[___MOD._GlobalRand32:randomIntegerRange(1, platformCandidatesNum)]
      local platformWidth = platform.right.x - platform.left.x
      local destX = platform.left.x + ___MOD._GlobalRand32:randomDouble() * platformWidth
      local destRatio = (destX - platform.left.x) / platformWidth
      local destY = platform.left.y + (platform.right.y - platform.left.y) * destRatio + makeFloatingYOffset()
      local moveToTargetPlatform = true
      makeCommand(___MOD._MobActionPartType.Fly, destX, destY, platform.left.x, platform.right.x, "Npc")
      mob.CurrentMap.LifeControllerComponent2:requestControl(mob, timelines, timelineIndex, ___MOD._CommandGroup.Fly, nil, ___MOD.isvalid(ai.Target))
    end
    ai:enableNextControlTimer(nextAction, false)
  end
end
