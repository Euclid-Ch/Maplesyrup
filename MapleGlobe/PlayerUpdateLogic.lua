

function PlayerUpdateLogic.addHP(self, user, deltaHP)

end

function PlayerUpdateLogic.addMP(self, user, deltaMP)

end

function PlayerUpdateLogic.clearHealTrackByPlayerId(self, playerId)

end

function PlayerUpdateLogic.coliisionDetectFloat(self, ap)
  local user = ___MOD._UserService.LocalPlayer
  local rb = user.RigidbodyComponent
  local p1 = self.prevPos
  if p1 == nil then
    return
  end
  local xm1, ym1 = p1[1], p1[2]
  local xm2, ym2 = ap[1], ap[2]
  if xm1 == xm2 and ym1 == ym2 then
    return
  end
  local segDx = xm2 - xm1
  local segDy = ym2 - ym1
  if 0.25 < segDx * segDx + segDy * segDy then
    return
  end
  local curMap = user.CurrentMap
  local platform = curMap.PlatformInfoComponent
  local footholdComp = curMap.FootholdComponent
  local output = {}
  ___MOD._FootholdLogic:getCrossCandidate(curMap, xm1, ym1, xm2, ym2, output)
  local S = 100

  local function roundi(v)
    if v < 0 then
      return ___MOD.math.floor(v - 0.5)
    end
    return ___MOD.math.floor(v + 0.5)
  end

  local Ax = roundi(xm1 * S)
  local Ay = roundi(-ym1 * S)
  local Bx = roundi(xm2 * S)
  local By = roundi(-ym2 * S)
  local dxm = Bx - Ax
  local dym = By - Ay
  if dxm == 0 and dym == 0 then
    return
  end
  local tCollide = 1
  local qFirstCollide = 2
  local pfhFirstCollideCW, pfhFirstCollideCCW
  local bestCW_x1, bestCW_y1, bestCW_x2, bestCW_y2 = 0, 0, 0, 0
  local bestCCW_x1, bestCCW_y1, bestCCW_x2, bestCCW_y2 = 0, 0, 0, 0
  local lastFH = user.PlayerVariables.lastFoothold
  for i = 1, #output do
    local fh = output[i]
    if 0 >= fh.Variance.x then
      local lZmass = platform.ZMass[fh.Id]
      if lZmass ~= platform.baseZMass and lZmass ~= platform.ZMass[lastFH] then
        goto lbl_333
      end
    end
    local pA = fh.StartPoint
    local pB = fh.EndPoint
    local Cx = roundi(pA.x * S)
    local Cy = roundi(-pA.y * S)
    local Dx = roundi(pB.x * S)
    local Dy = roundi(-pB.y * S)
    local dxf = Dx - Cx
    local dyf = Dy - Cy
    local v22 = dxf * (Ay - Cy) - dyf * (Ax - Cx)
    local v23 = dxf * (By - Cy) - dyf * (Bx - Cx)
    if not (0 < v22) and not (v23 < 0) and (v22 ~= 0 or v23 ~= 0) then
      local v24 = dxm * (Cy - Ay) - dym * (Cx - Ax)
      local v25 = dxm * (Dy - Ay) - dym * (Dx - Ax)
      if v24 < 0 then
        if v25 < 0 then
          goto lbl_333
        end
      else
      end
      if not (0 < v24) or not (0 < v25) then
        local pfhCW = fh
        local pfhCCW = fh
        local cw_x1, cw_y1, cw_x2, cw_y2 = Cx, Cy, Dx, Dy
        local ccw_x1, ccw_y1, ccw_x2, ccw_y2 = Cx, Cy, Dx, Dy
        if v24 == 0 then
          local prev = fh.PreviousFootholdId
          if not (prev ~= 0 and self:isBlockedArea(curMap, prev, fh.Id, xm2, ym2)) then
            goto lbl_333
          end
          pfhCCW = footholdComp:GetFoothold(prev)
          pfhCW = fh
          local pPrevA = pfhCCW.StartPoint
          local pPrevB = pfhCCW.EndPoint
          ccw_x1 = roundi(pPrevA.x * S)
          ccw_y1 = roundi(-pPrevA.y * S)
          ccw_x2 = roundi(pPrevB.x * S)
          ccw_y2 = roundi(-pPrevB.y * S)
        elseif v25 == 0 then
          local next = fh.NextFootholdId
          if not (next ~= 0 and self:isBlockedArea(curMap, fh.Id, next, xm2, ym2)) then
            goto lbl_333
          end
          pfhCW = footholdComp:GetFoothold(next)
          pfhCCW = fh
          local pNextA = pfhCW.StartPoint
          local pNextB = pfhCW.EndPoint
          cw_x1 = roundi(pNextA.x * S)
          cw_y1 = roundi(-pNextA.y * S)
          cw_x2 = roundi(pNextB.x * S)
          cw_y2 = roundi(-pNextB.y * S)
        end
        local v27 = ___MOD.math.abs(dxm * dyf - dym * dxf)
        if v27 ~= 0 then
          local v28 = Cx * Dy + Ay * dxf - Ax * dyf - Cy * Dx
          local v29 = ___MOD.math.abs(v28)
          local left = tCollide * v29
          local right = qFirstCollide * v27
          if not (left > right) then
            if right == left then
              if pfhFirstCollideCW and 0 > self:get_cross_product(bestCW_x1, bestCW_y1, bestCW_x2, bestCW_y2, cw_x1, cw_y1) then
                pfhFirstCollideCW = pfhCW
                bestCW_x1, bestCW_y1, bestCW_x2, bestCW_y2 = cw_x1, cw_y1, cw_x2, cw_y2
              end
              if pfhFirstCollideCCW and 0 > self:get_cross_product(bestCCW_x1, bestCCW_y1, bestCCW_x2, bestCCW_y2, ccw_x2, ccw_y2) then
                pfhFirstCollideCCW = pfhCCW
                bestCCW_x1, bestCCW_y1, bestCCW_x2, bestCCW_y2 = ccw_x1, ccw_y1, ccw_x2, ccw_y2
              end
            else
              tCollide = v27
              qFirstCollide = v29
              pfhFirstCollideCW = pfhCW
              pfhFirstCollideCCW = pfhCCW
              bestCW_x1, bestCW_y1, bestCW_x2, bestCW_y2 = cw_x1, cw_y1, cw_x2, cw_y2
              bestCCW_x1, bestCCW_y1, bestCCW_x2, bestCCW_y2 = ccw_x1, ccw_y1, ccw_x2, ccw_y2
            end
          end
        end
      end
    end
    ::lbl_333::
  end
  if not pfhFirstCollideCW or not pfhFirstCollideCCW then
    return
  end
  local blockCount = (self._T.cdfBlockCount or 0) + 1
  self._T.cdfBlockCount = blockCount
  if 120 < blockCount then
    if blockCount == 121 then
      ___MOD.log_warning("coliisionDetectFloat: 연속 보정 한도 초과, 착지 전까지 벽뚫 보정 중단")
    end
    return
  end
  rb.IsBlockVerticalLine = true
  local scaleFactor = qFirstCollide / tCollide
  local newX = xm1 + (xm2 - xm1) * scaleFactor
  local newY = ym1 + (ym2 - ym1) * scaleFactor
  local movingLeft = xm1 > xm2
  if movingLeft then
    newX = newX + 0.02
  else
    newX = newX - 0.02
  end
  newY = newY + 0.02
  rb:SetWorldPosition(___MOD.FastVector2(newX, newY))
  ap[1] = newX
  ap[2] = newY
end

function PlayerUpdateLogic.connectMouseMoveEvent(self)
  self:disconnectMouseMoveEvent()
  self._T.mouseEvent = ___MOD._InputService:ConnectEvent(___MOD.MouseMoveEvent, self.onMouseMove)
end

function PlayerUpdateLogic.disconnectMouseMoveEvent(self)
  if self._T.mouseEvent then
    ___MOD._InputService:DisconnectEvent(___MOD.MouseMoveEvent, self._T.mouseEvent)
    self._T.mouseEvent = nil
  end
end

function PlayerUpdateLogic.doHeal(self, user, delta, show)

end

function PlayerUpdateLogic.doHealMP(self, user, delta)

end

function PlayerUpdateLogic.ensureBerserkLoopLocal(self, player)
  local key = self:getBerserkLoopKey(player)
  if ___MOD._UtilLogic:IsNilorEmptyString(key) then
    return
  end
  if self._T.berserkEffectTimers[key] ~= nil then
    return
  end
  self:playBerserkEffectLocal(player)
  self._T.berserkEffectTimers[key] = ___MOD._TimerService:SetTimerRepeat(function()
    if player == nil or player.Player == nil or player.PlayerVariables == nil or player.Player:isDead() or player.PlayerVariables.berserkActive ~= true then
      self:stopBerserkLoopLocal(player)
      return
    end
    self:playBerserkEffectLocal(player)
  end, 1.5, 1.5)
end

function PlayerUpdateLogic.get_cross_product(self, xOrg, yOrg, x1, y1, x2, y2)
  return (y2 - yOrg) * (x1 - xOrg) - (y1 - yOrg) * (x2 - xOrg)
end

function PlayerUpdateLogic.getBerserkLoopKey(self, player)
  if player == nil or player.Player == nil then
    return ""
  end
  return ___MOD.tostring(player.Player.PlayerId)
end

function PlayerUpdateLogic.getBerserkShouldActive(self, player)
  if player == nil or player.Player == nil then
    return false
  end
  if player.Player:isDead() then
    return false
  end
  local sld = self:getBerserkSkillLevelData(player)
  if sld == nil then
    return false
  end
  local maxHP = ___MOD.tonumber(player.Player.MaxHP) or 0
  maxHP = maxHP + player.PlayerSecondaryAbilityComponent.MaxHP
  if maxHP <= 0 then
    return false
  end
  local hpRate = (___MOD.tonumber(player.Player.HP) or 0) * 100 / maxHP
  return hpRate <= (___MOD.tonumber(sld.x) or 0)
end

function PlayerUpdateLogic.getBerserkSkillLevelData(self, player)
  if player == nil then
    return nil
  end
  local slv = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Berserk_132_1320006)
  if slv == nil or slv <= 0 then
    return nil
  end
  return ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Berserk_132_1320006, slv)
end

function PlayerUpdateLogic.getEndureSkillID(self, player)
  local job = player.Player.Job
  if 100 <= job and job <= 132 then
    return ___MOD._SkillBook.Endure_100_1000002
  elseif 410 <= job and job <= 412 then
    return ___MOD._SkillBook.Endure_410_4100002
  elseif 420 <= job and job <= 422 then
    return ___MOD._SkillBook.Endure_420_4200001
  elseif 431 <= job and job <= 434 then
    return ___MOD._SkillBook.Endure_431_4310000
  end
  return 0
end

function PlayerUpdateLogic.isBlockedArea(self, map, fhId1, fhId2, xWorld, yWorld)
  local fh1 = map.FootholdComponent:GetFoothold(fhId1)
  local fh2 = map.FootholdComponent:GetFoothold(fhId2)
  local S = 100

  local function roundi(v)
    if v < 0 then
      return ___MOD.math.floor(v - 0.5)
    end
    return ___MOD.math.floor(v + 0.5)
  end

  local function X(v)
    return roundi(v * S)
  end

  local function Y(v)
    return roundi(-v * S)
  end

  local m_x2 = X(fh2.EndPoint.x)
  local m_y2 = Y(fh2.EndPoint.y)
  local m_x1 = X(fh1.StartPoint.x)
  local m_y1 = Y(fh1.StartPoint.y)
  local v8 = X(fh1.EndPoint.x)
  local pfh1a = Y(fh1.EndPoint.y)
  local x = X(xWorld)
  local y = Y(yWorld)
  local v9 = (v8 - m_x1) * (m_y2 - m_y1) - (m_x2 - m_x1) * (pfh1a - m_y1)
  local v10 = v8 - m_x1
  if v9 <= 0 then
    if (y - m_y1) * v10 - (x - m_x1) * (pfh1a - m_y1) <= 0 and (y - Y(fh2.StartPoint.y)) * (m_x2 - X(fh2.StartPoint.x)) - (x - X(fh2.StartPoint.x)) * (m_y2 - Y(fh2.StartPoint.y)) <= 0 then
      return false
    end
  elseif (y - m_y1) * v10 - (x - m_x1) * (pfh1a - m_y1) <= 0 or (y - Y(fh2.StartPoint.y)) * (m_x2 - X(fh2.StartPoint.x)) - (x - X(fh2.StartPoint.x)) * (m_y2 - Y(fh2.StartPoint.y)) <= 0 then
    return false
  end
  return true
end

function PlayerUpdateLogic.OnBeginPlay(self)
  self._T.dt = 0
  self._T.nextHPHeal = {}
  self._T.nextMPHeal = {}
  self._T.nextPotentialRecovery = {}
  self._T.nextHPHealR = {}
  self._T.lastEndureLevel = 0
  self._T.lastX = 0
  self._T.lastY = 0
  if self:IsClient() then
    local user = ___MOD._UserService.LocalPlayer
    self.transform = user.TransformComponent
    self.rb = user.RigidbodyComponent
    self.state = user.StateComponent
    self.action = user.PlayerActionComponent
    self.pv = user.PlayerVariables
    self.petOwner = user.PetOwnerComponent
    self._T.frame = 0
    self._T.isBlockVerticalLine = false
    self._T.nextDropPetScanTime = 0
    self._T.pets = {}
    self._T.petNearDir = {}
    self._T.tipTick = 0
    self._T.berserkEffectTimers = {}
    self._T.berserkEffectEntities = {}
    self._T.nextBerserkSyncTime = 0
    self._T.nextBerserkVisualUpdateTime = 0
  end
end

function PlayerUpdateLogic.onMouseMove(self)
  local mapInfo = self.mapInfo
  if not ___MOD.isvalid(mapInfo) then
    return
  end
  local wp = ___MOD._UIUtilLogic:getCursorWorldPosition()
  local tc = mapInfo:checkAndShow(wp)
  local prev = self.tooltipByMouse
  if prev ~= nil and prev ~= tc then
    local prevTooltip = prev.Entity
    if prevTooltip.Visible then
      prevTooltip:SetVisible(false)
    end
  end
  self.tooltipByMouse = tc
end

function PlayerUpdateLogic.OnUpdate(self, delta)
  local user = ___MOD._UserService.LocalPlayer
  if not user then
    return
  end
  local p = user.Player
  if not p.init then
    return
  end
  self._T.frame = (self._T.frame + 1) % 60
  local cur = ___MOD._UtilLogic.ElapsedSeconds
  ___MOD._PlayerSkillLogic_Teleport:checkTeleport(cur)
  self:updateTrembleEffect(cur)
  self.HP_dt = self.HP_dt + delta
  self.MP_dt = self.MP_dt + delta
  local curPos = self.transform:WorldPositionAsFastVector3():ToVector2()
  if self.lastX ~= curPos[1] or self.lastY ~= curPos[2] then
    self.lastX = curPos[1]
    self.lastY = curPos[2]
    self.HP_dt = 0
  end
  self.action:update()
  if cur >= (self._T.nextBerserkVisualUpdateTime or 0) then
    self._T.nextBerserkVisualUpdateTime = cur + 0.1
    self:updateBerserkEffectsClient(user)
  end
  local toolTipTemp = self.toolTipTemp
  local mapInfo = user.CurrentMap.MapInfoComponent
  if mapInfo then
    mapInfo:getNearToolTip(self.toolTipTemp, curPos)
    local charToolTip = self.charToolTip
    for key, tthInfo in ___MOD.pairs(toolTipTemp) do
      local tc = tthInfo.tc
      if self.tooltipByMouse == tc then
        charToolTip[key] = nil
      elseif not charToolTip[key] then
        local rect = tthInfo.rect
        local center = rect:getCenter()
        tc:setToolTip(center.x, center.y, tthInfo.title, tthInfo.desc)
        charToolTip[key] = tc
      end
    end
    for key, tc in ___MOD.pairs(charToolTip) do
      if not toolTipTemp[key] then
        tc.Entity.Visible = false
        charToolTip[key] = nil
      end
    end
  end
  self._T.tipTick = self._T.tipTick + 1
  if self._T.tipTick >= 800 then
    self._T.tipTick = 0
    if mapInfo and not mapInfo:isEventMap(false) then
      local job = ___MOD.math.floor(p.Job % 1000 / 100)
      local level = p.Level
      local tip = ___MOD._EtcManager:getTip(job, level)
      if tip then
        local msg = ___MOD.string.format("[메이플팁] %s", tip)
        ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Yellow, msg)
      end
    end
  end
  local velocity = self.rb.RealMoveVelocity
  local state = self.state.CurrentStateName
  local isOnGround = self.rb:IsOnGround()
  if isOnGround or self.action.isClimbing then
    self._T.cdfBlockCount = 0
  end
  if not isOnGround and not self.action.isClimbing and self.canCDF then
    self:coliisionDetectFloat(curPos)
  end
  if mapInfo and mapInfo.swim then
    self.FalldownTick = 0
  elseif isOnGround or self.action.isClimbing or velocity.y > -0.05 then
    if isOnGround and self.FalldownTick >= 30 then
      local dmg = ___MOD.math.max(1, ___MOD.math.floor(36 - 336 / (self.FalldownTick - 18)))
      user.PlayerHitComponent:setDamaged(dmg, nil, nil, nil, nil, nil, false)
    end
    self.FalldownTick = 0
  elseif velocity.y <= -0.05 then
    self.FalldownTick = self.FalldownTick + self._T.frame % 2
  end
  local dt1 = self.HP_dt
  local dt2 = self.MP_dt
  if self.action.isClimbing then
    local endureLevel = user.SkillComponent:getSkillLevel(self:getEndureSkillID(user))
    if self._T.lastEndureLevel ~= endureLevel and 0 < endureLevel then
      self._T.lastEndureLevel = endureLevel
      local skillData = ___MOD._SkillManager:getSkill(self:getEndureSkillID(user))
      local skillLevelData = skillData.level[endureLevel]
      if 0 < endureLevel and skillLevelData ~= nil then
        local endureTime = skillLevelData.time
        self.endureTime = endureTime
      end
    end
    if 0 < self.endureTime and dt1 >= self.endureTime then
      self:tryHealHP()
      self.HP_dt = self.HP_dt - self.endureTime
    end
  else
    if 10 <= dt1 then
      self:tryHealHP()
      self.HP_dt = self.HP_dt - 10
    end
    self:UpdateChasingDropForPet(cur, user)
  end
  if 10 <= dt2 then
    self:tryHealMP()
    self.MP_dt = self.MP_dt - 10
  end
  self.prevPos = curPos
end

function PlayerUpdateLogic.playBerserkEffectLocal(self, player)
  if player == nil or player.Player == nil or player.PlayerVariables == nil then
    return
  end
  if player.Player:isDead() or player.PlayerVariables.berserkActive ~= true then
    self:stopBerserkLoopLocal(player)
    return
  end
  local skillData = ___MOD._SkillManager:getSkill(___MOD._SkillBook.Berserk_132_1320006)
  if skillData == nil or skillData.effect == nil then
    return
  end
  local key = self:getBerserkLoopKey(player)
  self:releaseBerserkEffectEntities(self._T.berserkEffectEntities[key])
  local faceLeft = false
  if player.ExtendPlayerControllerComponent ~= nil then
    faceLeft = player.ExtendPlayerControllerComponent.LookDirectionX == -1
  end
  self._T.berserkEffectEntities[key] = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, ___MOD._SkillBook.Berserk_132_1320006, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), skillData.effect, false, faceLeft, nil)
end

function PlayerUpdateLogic.playIronBodyEffectLocal(self, player)
  local effectAlpha = ___MOD._ExtendedEffectService:getSkillEffectAlpha(player)
  if effectAlpha <= 0 then
    return
  end
  local avatar = ___MOD._SpawnService:SpawnByModelId("model://8c68f39a-0157-4bdb-9324-0ce898738899", "cloneAvatar", ___MOD.FastVector3.zero:Clone(), player)
  avatar:AddComponent(___MOD.AvatarRendererComponent)
  avatar:AddComponent(___MOD.CostumeManagerComponent)
  local costume = player.CostumeManagerComponent
  for i = 1, 19 do
    local t = ___MOD.MapleAvatarItemCategory.CastFrom(i)
    avatar.CostumeManagerComponent:SetEquip(t, costume:GetEquip(t))
  end
  avatar.CostumeManagerComponent.UseCustomEquipOnly = costume.UseCustomEquipOnly
  local body = avatar.AvatarRendererComponent:GetBodyEntity()
  local state = "alert"
  if player.StateComponent.CurrentStateName == "CLIMB" then
    state = "rope"
  elseif player.StateComponent.CurrentStateName == "LADDER" then
    state = "ladder"
  elseif player.StateComponent.CurrentStateName == "JUMP" then
    state = "jump"
  elseif player.StateComponent.CurrentStateName == "FLY" then
    state = "fly"
  end
  local ev = ___MOD.ActionStateChangedEvent(state, state, 1, ___MOD.SpriteAnimClipPlayType.Loop, 0, 0)
  body:SendEvent(ev)
  local transform = avatar.TransformComponent
  local renderer = avatar.AvatarRendererComponent
  local sign = player.ExtendPlayerControllerComponent.LookDirectionX == 1 and -1 or 1
  renderer.OrderInLayer = 5
  renderer.SortingLayer = "Effect"
  transform.Scale = ___MOD.FastVector3(sign, 1, 1)
  local baseAlpha = 0.85 * effectAlpha
  renderer:SetAlpha(baseAlpha)
  local tweener = ___MOD._TweenLogic:MakeTween(0, 1, 0.4, ___MOD.EaseType.Linear, function(val)
    avatar.Visible = true
    renderer:SetAlpha(baseAlpha * (1 - val))
    transform.Scale = ___MOD.FastVector3((1 + val * 2) * sign, 1 + val * 2, 1)
  end)
  tweener.AutoDestroy = true
  tweener:SetOnEndCallback(function()
    avatar.Visible = false
    avatar:Destroy()
  end)
  tweener:Play()
end

function PlayerUpdateLogic.playIronBodyEffectRemote(self, senderUserId)

end

function PlayerUpdateLogic.prepareChangeMapPosition(self, user)
  if user ~= ___MOD._UserService.LocalPlayer then
    return
  end
  self.canCDF = false
  self.prevPos = nil
  if ___MOD.isvalid(user.RigidbodyComponent) then
    user.RigidbodyComponent.IsBlockVerticalLine = false
  end
end

function PlayerUpdateLogic.releaseBerserkEffectEntities(self, entities)
  if entities == nil then
    return
  end
  for i = 1, #entities do
    local e = entities[i]
    if ___MOD.isvalid(e) then
      e.Visible = false
      local asc = e.AnimationSpriteComponent
      if ___MOD.isvalid(asc) then
        asc:release()
      end
    end
  end
end

function PlayerUpdateLogic.resetProperty(self)
  self._T.dt = 0
  self._T.nextHPHeal = {}
  self._T.nextMPHeal = {}
  self._T.nextPotentialRecovery = {}
  self._T.nextHPHealR = {}
  self._T.lastEndureLevel = 0
  self._T.lastX = 0
  self._T.lastY = 0
  if self:IsClient() then
    local user = ___MOD._UserService.LocalPlayer
    self.transform = user.TransformComponent
    self.rb = user.RigidbodyComponent
    self.state = user.StateComponent
    self.action = user.PlayerActionComponent
    self.pv = user.PlayerVariables
    self.petOwner = user.PetOwnerComponent
    self._T.frame = 0
    self._T.isBlockVerticalLine = false
    self._T.nextDropPetScanTime = 0
    self._T.pets = {}
    self._T.petNearDir = {}
    self._T.tipTick = 0
    self._T.berserkEffectTimers = {}
    self._T.berserkEffectEntities = {}
    self._T.nextBerserkSyncTime = 0
    self._T.nextBerserkVisualUpdateTime = 0
  end
end

function PlayerUpdateLogic.setHP(self, user, hp)

end

function PlayerUpdateLogic.setMP(self, user, mp)

end

function PlayerUpdateLogic.showHeal(self, player, delta)
  local values = {delta}
  local criticals = {false}
  local delays = {0}
  local deff = player.CurrentMap.DamageEffectComponent
  if deff then
    local pv = player.PlayerVariables
    deff:show(player, ___MOD._DamageEffectType.Blue, values, criticals, delays, 0, pv:getHead().TransformComponent:PositionAsFastVector3())
  end
end

function PlayerUpdateLogic.sign(self, x)
  if 0 < x then
    return 1
  end
  if x < 0 then
    return -1
  end
  return 0
end

function PlayerUpdateLogic.stopBerserkLoopLocal(self, player)
  local key = self:getBerserkLoopKey(player)
  if ___MOD._UtilLogic:IsNilorEmptyString(key) then
    return
  end
  local timer = self._T.berserkEffectTimers[key]
  if timer ~= nil then
    ___MOD._TimerService:ClearTimer(timer)
    self._T.berserkEffectTimers[key] = nil
  end
  self:releaseBerserkEffectEntities(self._T.berserkEffectEntities[key])
  self._T.berserkEffectEntities[key] = nil
end

function PlayerUpdateLogic.syncBerserkActiveServer(self, active, senderUserId)

end

function PlayerUpdateLogic.tryAddHP(self, user, deltaHP)

end

function PlayerUpdateLogic.tryHealHP(self, senderUserId)

end

function PlayerUpdateLogic.tryHealMP(self, senderUserId)

end

function PlayerUpdateLogic.tryPotentialRecovery(self, user)

end

function PlayerUpdateLogic.tryUpdateBerserkState(self, user)

end

function PlayerUpdateLogic.updateBerserkEffectsClient(self, user)
  if user == nil or ___MOD._UtilLogic:IsNilorEmptyString(user.CurrentMapName) then
    return
  end
  local liveKeys = {}
  local localPlayer = ___MOD._UserService.LocalPlayer
  if localPlayer ~= nil and localPlayer.Player ~= nil and localPlayer.PlayerVariables ~= nil then
    local localShouldActive = self:getBerserkShouldActive(localPlayer)
    if localPlayer.PlayerVariables.berserkActive ~= localShouldActive then
      localPlayer.PlayerVariables.berserkActive = localShouldActive
      self:syncBerserkActiveServer(localShouldActive)
    end
    local localKey = self:getBerserkLoopKey(localPlayer)
    if localKey ~= "" then
      liveKeys[localKey] = true
      if localShouldActive == true and not localPlayer.Player:isDead() then
        self:ensureBerserkLoopLocal(localPlayer)
      else
        self:stopBerserkLoopLocal(localPlayer)
      end
    end
  end
  for _, p in ___MOD.pairs(___MOD._UserService:GetUsersByMapName(user.CurrentMapName)) do
    if p ~= nil and p.Player ~= nil and p.PlayerVariables ~= nil then
      local key = self:getBerserkLoopKey(p)
      if key ~= "" then
        liveKeys[key] = true
        if p.PlayerVariables.berserkActive == true and not p.Player:isDead() then
          self:ensureBerserkLoopLocal(p)
        else
          self:stopBerserkLoopLocal(p)
        end
      end
    end
  end
  for key, timer in ___MOD.pairs(self._T.berserkEffectTimers) do
    if liveKeys[key] ~= true then
      if timer ~= nil then
        ___MOD._TimerService:ClearTimer(timer)
      end
      self._T.berserkEffectTimers[key] = nil
      self:releaseBerserkEffectEntities(self._T.berserkEffectEntities[key])
      self._T.berserkEffectEntities[key] = nil
    end
  end
end

function PlayerUpdateLogic.UpdateChasingDropForPet(self, cur, owner)
  local cur = ___MOD._UtilLogic.ElapsedSeconds
  if cur < self._T.nextDropPetScanTime then
    return
  end
  local petOwner = self.petOwner
  if not petOwner:hasAnyPet() then
    self._T.nextDropPetScanTime = cur + 1
    return
  end
  local pets = self._T.pets
  ___MOD.table.clear(pets)
  if ___MOD.isvalid(petOwner.pet) then
    pets[#pets + 1] = petOwner.pet
  end
  if ___MOD.isvalid(petOwner.pet2) then
    pets[#pets + 1] = petOwner.pet2
  end
  if ___MOD.isvalid(petOwner.pet3) then
    pets[#pets + 1] = petOwner.pet3
  end
  local petCount = #pets
  if 0 < petCount then
    for i = 1, petCount do
      local pet = pets[i]
      pet.PetAICompoent.nearDropDirection = 0
    end
  else
    return
  end
  if owner.Player and owner.Player:isDead() then
    return
  end
  local ownerPos = owner.TransformComponent:WorldPositionAsFastVector3()
  local ownerX = ownerPos[1]
  local dedicatedMap = ___MOD._DedicatedMonsterLogic:isEnabledMap(owner.CurrentMap)
  local mapLife = owner.CurrentMap.MapLifeComponent
  if mapLife then
    local dropItemPool = mapLife.dropItemPool
    for dropID, dropEntity in ___MOD.pairs(dropItemPool) do
      if petCount == 0 then
        break
      end
      local drop = dropEntity.CDropItemComponent
      if drop.bByPet and drop.bReal and drop.nState == 3 and 3 <= cur - drop.tLastTryPickUp then
        local dropPos = drop.transform:WorldPositionAsFastVector3()
        local dropX = dropPos[1]
        local dropY = dropPos[2]
        local bestIdx, bestDiff
        for i = 1, petCount do
          local pet = pets[i]
          local petPos = pet.TransformComponent:WorldPositionAsFastVector3()
          local left, right, top, bottom = ownerX - 2.75, ownerX + 2.75, petPos[2] + 0.1, petPos[2] - 0.5
          if dropY > bottom and dropY < top and dropX > left and dropX < right then
            local ownType = drop.ownType
            local ownerID = drop.ownerID
            local sourceID = drop.sourceID
            local canPickupDedicatedDrop = not dedicatedMap or ___MOD._DropItemLogic:canUseDedicatedDropOwnerId(owner, ownerID)
            if dedicatedMap and canPickupDedicatedDrop or not dedicatedMap and (cur - drop.tCreateTime >= 30 or ___MOD._UtilLogic:IsNilorEmptyString(sourceID) or (ownType ~= ___MOD._DropOwnType.UserOwn_0 or ownerID == owner.Player.PlayerId) and (ownType ~= ___MOD._DropOwnType.PartyOwn_1 or ownerID == ___MOD.tostring(owner.Player.PartyId))) then
              local diff = ___MOD.math.abs(dropX - petPos[1])
              if not bestDiff or bestDiff > diff then
                bestDiff = diff
                bestIdx = i
              end
            end
          end
        end
        if bestIdx then
          local pet = pets[bestIdx]
          local petPos = pet.TransformComponent:WorldPositionAsFastVector3()
          pet.PetAICompoent.nearDropDirection = self:sign(dropX - petPos[1])
          pets[bestIdx] = pets[#pets]
          pets[#pets] = nil
          petCount = petCount - 1
        end
      end
    end
  end
end

function PlayerUpdateLogic.updateTrembleEffect(self, cur)
  if self._T.frame % 2 == 0 then
    return
  end
  local tremble = self.tremble
  if tremble == nil then
    return
  end
  if cur < tremble.trembleStart then
    return
  end
  local force = tremble.trembleForce
  if force <= 0 then
    self.tremble = nil
    return
  end
  local cam = ___MOD._UserService.LocalPlayer.CameraComponent
  tremble.termbleLastUpdate = cur
  if cur < tremble.trembleEnd then
    local dForce = ___MOD.math.floor(force * 100)
    local dx = ___MOD._GlobalRand32:randomIntegerRange(-dForce, dForce) / 100
    local dy = ___MOD._GlobalRand32:randomIntegerRange(-dForce, dForce) / 100
    cam.CameraOffset = ___MOD.FastVector2(dx, dy)
    tremble.trembleForce = tremble.trembleForce * tremble.trembleReduction
  else
    cam.CameraOffset = ___MOD.FastVector2.zero:Clone()
    tremble.trembleForce = 0
  end
end
