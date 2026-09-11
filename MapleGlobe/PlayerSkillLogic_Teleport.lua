

function PlayerSkillLogic_Teleport.checkTeleport(self, now)
  local user = ___MOD._UserService.LocalPlayer
  local updater = ___MOD._PlayerUpdateLogic
  local camera = user.CameraComponent
  local teleport = updater.teleport
  if teleport ~= nil then
    if teleport.valid then
      if now >= teleport.start then
        local pos = user.TransformComponent:WorldPositionAsFastVector3()
        camera.SoftZone.x = ___MOD.math.max(0.5, ___MOD.math.min(10, 0.1 + ___MOD.math.abs(teleport.position.x - pos.x)))
        camera.SoftZone.y = ___MOD.math.max(0.75, ___MOD.math.min(10, 0.1 + ___MOD.math.abs(teleport.position.y - pos.y)))
        if teleport.byPortal then
          camera.Damping.x = 0.45
          camera.Damping.y = 1
        else
          camera.Damping.x = 2.5
          camera.Damping.y = 3.9
        end
        self:tryDoingTeleport(user, teleport)
      end
    elseif now > teleport.coolTimeEnd then
      updater.teleport = nil
      self:resetCamera()
    end
    return true
  end
  return false
end

function PlayerSkillLogic_Teleport.resetCamera(self)
  local camera = ___MOD._UserService.LocalPlayer.CameraComponent
  camera.SoftZone.x = 0.5
  camera.SoftZone.y = 0.75
  camera.Damping.x = 2.5
  camera.Damping.y = 3.9
end

function PlayerSkillLogic_Teleport.tryDoingTeleport(self, user, teleport)
  ___MOD._PlayerUpdateLogic.canCDF = false
  ___MOD._PlayerUpdateLogic.prevPos = nil
  teleport.valid = false
  local move = user.MovementComponent
  local rb = user.RigidbodyComponent
  if move.EnableInHierarchy then
    move:SetWorldPosition(teleport.position)
  else
    rb:SetWorldPosition(teleport.position)
  end
  local isCorkscrew = teleport.skillId == ___MOD._SkillBook.Corkscrew_Blow_510_5101004 or teleport.skillId == ___MOD._SkillBook.Corkscrew_Blow_1510_15101003
  if isCorkscrew then
    user.MovementComponent:Stop()
  end
  ___MOD._PlayerVecCtrl.teleport = true
  if teleport.playEffect then
    local path = "BasicEff.img/Teleport"
    if teleport.byPortal then
      local fromPos = teleport.from
      ___MOD._ExtendedEffectService:playEffectAnimationLocal(path, ___MOD._AnimationType.effectBackTarget, ___MOD._EffectAnimationSubType.halfScale, ___MOD.FastVector3.zero:Clone(), false, 1.0, false, user, nil, true, 10)
      ___MOD._ExtendedEffectService:playEffectAnimationRemote(path, ___MOD._AnimationType.effectBackTarget, ___MOD._EffectAnimationSubType.halfScale, ___MOD.FastVector3.zero:Clone(), false, 1.0, false, user, false, user, nil, true, 10)
    else
      ___MOD._ExtendedEffectService:playEffectAnimationLocal(path, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, ___MOD.FastVector3.zero:Clone(), false, 1.0, false, user, nil, true, 10)
      ___MOD._ExtendedEffectService:playEffectAnimationRemote(path, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, ___MOD.FastVector3.zero:Clone(), false, 1.0, false, user, false, user, nil, true, 10)
    end
  end
  teleport.coolTimeEnd = 0.6 + teleport.start
end

function PlayerSkillLogic_Teleport.tryRegisterTeleport(self, user, skillId, skillLevel, portal, targetPortal, forced, forceRange)
  local map = user.CurrentMap
  local teleportInfo = ___MOD._PlayerUpdateLogic.teleport
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if not forced and teleportInfo ~= nil then
    local isPortalCooldown = teleportInfo.byPortal and not teleportInfo.valid
    local canRushAfterPortal = ___MOD._SkillLogic:isRushAttackSkill(skillId) and isPortalCooldown
    if (teleportInfo.valid or now < teleportInfo.coolTimeEnd) and not canRushAfterPortal then
      return false
    end
  end
  local rb = user.RigidbodyComponent
  local currentFh = rb:GetCurrentFoothold()
  local stateName = user.StateComponent.CurrentStateName
  local isClimbing = user.PlayerActionComponent ~= nil and user.PlayerActionComponent.isClimbing
  if not forced and (isClimbing or stateName == "LADDER" or stateName == "CLIMB") then
    return false
  end
  if not forced and currentFh == nil and skillId ~= ___MOD._SkillBook.Assaulter_421_4211002 then
    return false
  end
  local realTargetX, realTargetY
  local mapInfo = map.MapInfoComponent
  local footholds = map.FootholdComponent
  local playerPos = user.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  local dir = 0
  if skillId ~= 0 then
    local levelData = ___MOD._SkillManager:getSkillLevelData(skillId, skillLevel)
    if levelData == nil then
      return false
    end
    if ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(user, skillId, levelData, 0, 0, 0) ~= 0 then
      local info = ___MOD.TeleportCtx()
      info.valid = false
      info.coolTimeEnd = now + 0.1
      info.playEffect = true
      return false
    end
    local up = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.UpArrow) and 1 or 0
    local down = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.DownArrow) and 1 or 0
    local left = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.LeftArrow) and 1 or 0
    local right = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.RightArrow) and 1 or 0
    local dirHorizon = right - left
    local dirVertical = up - down
    local teleportRange = levelData.range
    if ___MOD._SkillLogic:isTeleportAttackSkill(skillId) or skillId == ___MOD._SkillBook.Assaulter_421_4211002 then
      if skillId == ___MOD._SkillBook.Backspin_Blow_510_5101002 then
        dirHorizon = user.PlayerControllerComponent.LookDirectionX == -1 and 1 or -1
      else
        dirHorizon = user.PlayerControllerComponent.LookDirectionX
      end
      dir = dirHorizon
      teleportRange = forceRange
    end
    local targetPosX = playerPos.x + dirHorizon * teleportRange / 100
    local targetPosY = playerPos.y + dirVertical * teleportRange / 100
    if dirHorizon ~= 0 then
      local footholdAbove = footholds:Raycast(___MOD.Vector2(targetPosX, playerPos.y - 0.01), ___MOD.Vector2.up, 1.0)
      local footholdUnder = footholds:Raycast(___MOD.Vector2(targetPosX, playerPos.y + 0.01), ___MOD.Vector2.down, 1.0)
      local aboveY = footholdAbove and footholdAbove:GetYByX(targetPosX) or 0
      local underY = footholdUnder and footholdUnder:GetYByX(targetPosX) or 0
      if footholdUnder ~= nil and footholdAbove ~= nil and aboveY - playerPos.y <= playerPos.y - underY then
        realTargetY = aboveY + 0.01
      elseif footholdUnder ~= nil then
        realTargetY = underY + 0.01
      elseif footholdAbove ~= nil then
        realTargetY = aboveY + 0.01
      end
      if skillId == ___MOD._SkillBook.Backspin_Blow_510_5101002 and footholdUnder ~= nil then
        realTargetY = underY + 0.01
      end
      realTargetX = targetPosX
    else
      if dirVertical ~= 0 then
        local yRange = dirVertical * teleportRange / 100
        if 0 < dirVertical then
          realTargetY = playerPos.y + 0.01
          local footholdAbove = footholds:Raycast(___MOD.Vector2(playerPos.x, targetPosY + 0.01), ___MOD.Vector2.down, 10)
          if footholdAbove ~= nil and footholdAbove ~= currentFh then
            realTargetY = footholdAbove:GetYByX(playerPos.x) + 0.01
          end
        else
          local footholdUnder = footholds:Raycast(___MOD.Vector2(playerPos.x, targetPosY - 0.01), ___MOD.Vector2.up, 10)
          if footholdUnder == nil or footholdUnder == currentFh then
            local underUnderFoothold = footholds:Raycast(___MOD.Vector2(playerPos.x, targetPosY - 0.01), ___MOD.Vector2.down, teleportRange / 100 - 0.01)
            if underUnderFoothold ~= nil then
              local underUnderFootholdY = underUnderFoothold:GetYByX(playerPos.x) + 0.01
              local startPos = ___MOD.Vector2(playerPos.x, underUnderFootholdY)
              if ___MOD._FootholdLogic:canGoThrough(map, startPos, ___MOD.Vector2(playerPos.x, playerPos.y + 0.01), currentFh.Id) then
                realTargetY = underUnderFootholdY
              end
            end
          else
            realTargetY = footholdUnder:GetYByX(playerPos.x) + 0.01
          end
        end
        realTargetX = playerPos.x
      else
      end
    end
  elseif targetPortal and targetPortal.ExtendPortalComponent then
    local portalPos = targetPortal.TransformComponent.WorldPosition:ToVector2()
    realTargetX = portalPos.x
    local underFh = footholds:Raycast(___MOD.Vector2(portalPos.x, portalPos.y + 0.1), ___MOD.Vector2.down, 10)
    if underFh ~= nil then
      realTargetY = underFh:GetYByX(portalPos.x) + 0.01
    end
  end
  if realTargetX ~= nil and realTargetY ~= nil then
    local info = ___MOD.TeleportCtx()
    info.skillId = skillId
    info.valid = true
    info.position = ___MOD.Vector2(realTargetX, realTargetY)
    info.start = now
    info.playEffect = not ___MOD._SkillLogic:isTeleportAttackSkill(skillId) and skillId ~= ___MOD._SkillBook.Assaulter_421_4211002
    if targetPortal == nil then
      info.byPortal = false
      info.coolTimeEnd = now + 0.12
      ___MOD._SoundUtils:playSkillSoundLocal(nil, skillId)
      if ___MOD._SkillLogic:isTeleportAttackSkill(skillId) then
        local d = 0.02
        if skillId == ___MOD._SkillBook.Corkscrew_Blow_1510_15101003 or skillId == ___MOD._SkillBook.Corkscrew_Blow_510_5101004 then
          d = 0.01
        end
        user.MovementComponent:MoveToDirection(___MOD.FastVector2(d * dir, 0), 0)
      else
        ___MOD._PlayerSkillLogic:tryUseSkill(user, skillId, skillLevel, nil)
      end
    else
      if portal and portal.ExtendPortalComponent then
        info.from = portal.TransformComponent:WorldPositionAsFastVector3():ToVector2()
      else
        info.from = ___MOD.FastVector2(playerPos.x, playerPos.y)
      end
      info.byPortal = true
      info.coolTimeEnd = now + 0.12
    end
    ___MOD._PlayerUpdateLogic.teleport = info
    return true
  end
  return false
end
