

function MobAttackLogic.doMobSkill(self, mob, skillId, skillLevel, delay)

end

function MobAttackLogic.doMobSkill_statChange(self, mob, skillID, skillLevel, msld, delay)

end

function MobAttackLogic.doMobSkill_summon(self, mob, skillID, skillLevel, msld, delay)

end

function MobAttackLogic.doMobSkill_userStatChange(self, mob, skillID, skillLevel, msld, delay)

end

function MobAttackLogic.findDamagedByMobInRect(self, box)
  local user = ___MOD._UserService.LocalPlayer
  local damagedByMob = user.CurrentMap.MapLifeComponent.damagedByMob
  if not damagedByMob or not ___MOD.isvalid(damagedByMob) then
    return
  end
  local damagedByMobEntity = damagedByMob.Entity
  local ai = damagedByMobEntity.MobAIComponent
  if not ai.active then
    return
  end
  local trigger = damagedByMobEntity.TriggerComponent
  if not trigger or not trigger.Enable then
    return
  end
  local bodyRect = ___MOD._NumberUtils:triggerToBox(trigger)
  if ___MOD._NumberUtils:intersectBox(box, bodyRect) then
    return damagedByMobEntity
  else
    return nil
  end
end

function MobAttackLogic.findHitSummonedInRect(self, box, out, maxCount)
  local user = ___MOD._UserService.LocalPlayer
  local pool = user.CurrentMap.MapLifeComponent.summonPool.pool
  local count = 0
  for _, summon in ___MOD.pairs(pool) do
    local trigger = summon.TriggerComponent
    if trigger.Enable ~= false then
      local bodyRect = ___MOD._NumberUtils:triggerToBox(trigger)
      if ___MOD._NumberUtils:intersectBox(box, bodyRect) then
        count = count + 1
        out[#out + 1] = summon
      end
    end
  end
  return count
end

function MobAttackLogic.findTargetByLtRb(self, mob, lt, rb, pos, faceLeft, triggerGroupName)
  lt = lt:Clone() / 100
  rb = rb:Clone() / 100
  local center, size = ___MOD._OffsetUtils:calcNormalizedBox(lt, rb, faceLeft)
  local simulator = ___MOD._CollisionService:GetSimulator(mob.CurrentMapName)
  self._T.overlapList = {}
  local ret = {}
  local found = simulator:OverlapBoxAllFast(triggerGroupName, pos + center, size, 0, self._T.overlapList)
  if 0 < found then
    local dedicated = ___MOD._DedicatedMonsterLogic
    local useDedicated = dedicated and dedicated:isEnabledMap(mob.CurrentMap)
    for i = 1, found do
      local t = self._T.overlapList[i]
      local target = t.Entity
      if (not useDedicated or triggerGroupName ~= "Player" or dedicated:canTargetPlayer(mob, target)) and (not useDedicated or triggerGroupName ~= "Monster" or dedicated:isSameOwnerMob(mob, target)) then
        ret[#ret + 1] = target
      end
    end
  end
  return ret
end

function MobAttackLogic.isDazzledMobByMe(self, mob)
  local temporary = mob.MobTemporaryStatComponent
  local iPid = ___MOD._PlayerUtils:get_LocalUser_iPlayerID()
  return temporary:getValue(___MOD._MTS.Dazzle) == iPid
end

function MobAttackLogic.letMobChasePuppet(self, puppet, chase)
  local summon = puppet.SummonComponent
  if not (summon ~= nil and ___MOD.isvalid(summon)) or not summon.active then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local mobs = puppet.CurrentMap:GetChildComponentsByTypeName("MobAIComponent")
  for i = 1, #mobs do
    local ai = mobs[i]
    local m = ai.Entity.MobComponent
    if ai.active and not m:isDead() then
      if chase then
        if ai.Target ~= nil then
          ai:chaseTarget(puppet, true)
          ___MOD.log("letMobChasePuppet target:puppet chase:true")
        end
      elseif ai.Target == puppet then
        ai:chaseTarget(nil, false)
        ___MOD.log("letMobChasePuppet target:nil chase:false")
      end
    end
  end
end

function MobAttackLogic.processAttack(self, mob, attackIdx, dwData)
  local m = mob.MobComponent
  local ai = mob.MobAIComponent
  local temporary = mob.MobTemporaryStatComponent
  local templateID = m.template and m.template.mobId or 0
  local attackInfo = ___MOD._MobManager:getMobAttackInfo(templateID, attackIdx)
  if ai.doFirstAttack then
    ai.doFirstAttack = false
  end
  local isDazzledMob = 0 < temporary:getValue(___MOD._MTS.Dazzle)
  local isDazzledMobByMe = self:isDazzledMobByMe(mob)
  if isDazzledMob and not self:isDazzledMobByMe(mob) then
    return
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  if attackInfo ~= nil then
    local range = attackInfo.range
    local mobPos = mob.TransformComponent:WorldPositionAsFastVector3():ToVector2()
    if range ~= nil then
      if attackInfo.type == ___MOD._MobAttackType.Range_0 then
        ___MOD._TimerService:SetTimerOnce(function()
          if mob == nil or mob.MobComponent == nil then
            return
          end
          if mob.MobComponent:isDead() then
            return
          end
          if attackInfo.tremble then
            ___MOD._ExtendedEffectService:effectTrembleClient(0.3, true, 0, 0, false)
          end
          local left = m.faceLeft
          local lt = range.lt
          local rb = range.rb
          local attackRc = ___MOD._NumberUtils:makeBoxShapeFromLtRb(mobPos, lt, rb, left)
          local colliderVisualizer = mob:GetComponent(___MOD.MobAttackColliderVisualizer)
          if colliderVisualizer ~= nil then
            colliderVisualizer:Clear()
            colliderVisualizer:DrawBox(mob.CurrentMap, 1, attackRc)
          end
          if not isDazzledMob then
            local userRc = ___MOD._NumberUtils:triggerToBox(localPlayer.TriggerComponent)
            if ___MOD._NumberUtils:intersectBox(attackRc, userRc) then
              if attackInfo.jumpAttack and not localPlayer.RigidbodyComponent:IsOnGround() and not localPlayer.PlayerActionComponent.isClimbing then
                return
              end
              localPlayer.PlayerHitComponent:attackedByMob(mob, attackInfo, attackIdx)
            end
            self._T.summoned = {}
            local summoned = self._T.summoned
            self:findHitSummonedInRect(attackRc, summoned, 2)
            for i = 1, #summoned do
              local summon = summoned[i]
              summon.SummonComponent:SetDamaged(0, mob, attackIdx, 0)
            end
          end
          self._T.mobs = {}
          local mobs = self._T.mobs
          local mobCount = ___MOD._FindMobLogic:findHitMobInRect(attackRc, mobs, 15, nil, 0, 0, 0, true, localPlayer)
          if 0 < mobCount then
            for i = 1, #mobs do
              local foundMob = mobs[i]
              foundMob.MobComponent:setDamagedByMobAttack(mob, attackIdx)
            end
          end
        end, attackInfo.attackAfter / 1000)
      elseif attackInfo.type == ___MOD._MobAttackType.Shoot_1 then
        ___MOD._TimerService:SetTimerOnce(function()
          if mob == nil then
            return
          end
          if mob.MobComponent:isDead() then
            return
          end
          if attackInfo.tremble then
            ___MOD._ExtendedEffectService:effectTrembleClient(0.3, true, attackInfo.attackAfter / 1000, 0, false)
          end
          local targetId = dwData[1]
          if ___MOD._UtilLogic:IsNilorEmptyString(targetId) then
            return
          end
          local target = ___MOD._EntityService:GetEntity(targetId)
          if not target then
            return
          end
          local left = m.faceLeft
          local sp = range.sp:Clone()
          sp.y = -sp.y * 0.01
          sp.x = sp.x * (left and 1 or -1) * 0.01
          local startPos = mobPos + sp
          local targetPos = target.TransformComponent:WorldPositionAsFastVector3()
          local dist = startPos:Distance(targetPos:ToVector2())
          local nRange = range.r * 0.01
          if dist < nRange + 0.5 then
            if not isDazzledMob and target == localPlayer then
              localPlayer.PlayerHitComponent:attackedByMob(mob, attackInfo, attackIdx)
            elseif not isDazzledMob and target.SummonComponent then
              target.SummonComponent:SetDamaged(0, mob, attackIdx, 0)
            elseif target.MobComponent then
              target.MobComponent:setDamagedByMobAttack(mob, attackIdx)
            end
          end
        end, attackInfo.attackAfter / 1000)
      elseif attackInfo.type == ___MOD._MobAttackType.Pierce_2 then
        ___MOD._TimerService:SetTimerOnce(function()
          if mob == nil then
            return
          end
          if mob.MobComponent:isDead() then
            return
          end
          if attackInfo.tremble then
            ___MOD._ExtendedEffectService:effectTrembleClient(0.3, true, 0, 0, false)
          end
          local hitX = dwData[1]
          local hitY = dwData[2]
          if hitX == nil or hitY == nil then
            return
          end
          local hitPos = ___MOD.Vector2(hitX, hitY)
          local left = m.faceLeft
          local sp = range.sp:Clone()
          sp.y = -sp.y * 0.01
          sp.x = sp.x * (left and 1 or -1) * 0.01
          local rangeLen = range.r * 0.01
          local startPos = mobPos + sp
          local destPos = self:setBallDestPoint(startPos, hitPos, left, rangeLen)
          ai:createMobAttackBallClient(startPos, destPos, attackIdx)
        end, attackInfo.attackAfter / 1000)
      elseif attackInfo.type == ___MOD._MobAttackType.Area_3 then
        local selectedLane = dwData
        local lt, rb = range.lt, range.rb
        local left = m.faceLeft
        if selectedLane == nil or #selectedLane == 0 then
          return
        end
        local currentMap = mob.CurrentMap
        for i = 1, #selectedLane do
          local lane = selectedLane[i]
          local x, y = lane[2], lane[3]
          ___MOD._ExtendedEffectService:playAnimationOnMap(currentMap, attackInfo.areaWarning, ___MOD.Vector3(x, y, 0), nil, nil, nil, false, false, nil, nil)
        end
        ai.lastAreaAttack = ___MOD._UtilLogic.ServerElapsedSeconds
        ___MOD._TimerService:SetTimerOnce(function()
          if mob == nil then
            return
          end
          if mob.MobComponent:isDead() then
            return
          end
          if attackInfo.tremble then
            ___MOD._ExtendedEffectService:effectTrembleClient(0.3, true, 0, 0, false)
          end
          local colliderVisualizer = mob:GetComponent(___MOD.MobAttackColliderVisualizer)
          if colliderVisualizer ~= nil then
            colliderVisualizer:Clear()
          end
          for i = 1, #selectedLane do
            local lane = selectedLane[i]
            local x, y = lane[2], lane[3]
            local attackRc = ___MOD._NumberUtils:makeBoxShapeFromLtRb(___MOD.Vector2(x, y), lt, rb, left)
            if colliderVisualizer ~= nil then
              colliderVisualizer:DrawBox(mob.CurrentMap, i, attackRc)
            end
            if not isDazzledMob then
              local userRc = ___MOD._NumberUtils:triggerToBox(localPlayer.TriggerComponent)
              if ___MOD._NumberUtils:intersectBox(attackRc, userRc) then
                if ___MOD._ShaolinChiefPriestBattleLogic:shouldUseFixedRatioAttackClient(templateID, attackInfo) then
                  ___MOD._ShaolinChiefPriestBattleLogic:executeFixedAttackClient(mob, attackInfo, attackIdx)
                else
                  localPlayer.PlayerHitComponent:attackedByMob(mob, attackInfo, attackIdx)
                end
              end
              self._T.summoned = {}
              local summoned = self._T.summoned
              self:findHitSummonedInRect(attackRc, summoned, 2)
              for i = 1, #summoned do
                local summon = summoned[i]
                summon.SummonComponent:SetDamaged(0, mob, attackIdx, 0)
              end
            end
            self._T.mobs = {}
            local mobs = self._T.mobs
            local mobCount = ___MOD._FindMobLogic:findHitMobInRect(attackRc, mobs, 15, nil, 0, 0, 0, true, localPlayer)
            if 0 < mobCount then
              for i = 1, #mobs do
                local foundMob = mobs[i]
                foundMob.MobComponent:setDamagedByMobAttack(mob, attackIdx)
              end
            end
          end
        end, attackInfo.attackAfter / 1000)
      end
    end
    if attackInfo.effect ~= nil then
      local effectType = attackInfo.effect.effectType or 0
      ___MOD._TimerService:SetTimerOnce(function()
        if effectType == 2 then
          local rangeLt = range and range.lt
          local rangeRb = range and range.rb
          ___MOD._ExtendedEffectService:makeFallingAnimation(mob.CurrentMap, attackInfo.effect, mob.TransformComponent:WorldPositionAsFastVector3(), m.faceLeft, 0, 0, nil, rangeLt, rangeRb)
        else
          ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, 0, 0, mob, 1.0, ___MOD.FastVector3.zero:Clone(), attackInfo.effect, false, not mob.SpriteRendererComponent.FlipX, "mobAttackEffect")
        end
      end, attackInfo.effectAfter / 1000)
    end
    local effect0 = attackInfo.effect0
    if effect0 ~= nil then
      do
        local effectType = effect0.effectType or 0
        if effectType == 1 then
          local delay = effect0.delay or 0
          ___MOD._ExtendedEffectService:makeFootholdEffect(mob.CurrentMap, effect0, mob.TransformComponent:WorldPositionAsFastVector3():ToVector2(), nil, nil, delay / 1000)
        else
          ___MOD._TimerService:SetTimerOnce(function()
            ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, 0, 0, mob, 1.0, ___MOD.FastVector3.zero:Clone(), attackInfo.effect0, false, not mob.SpriteRendererComponent.FlipX, "mobAttackEffect")
          end, attackInfo.effectAfter / 1000)
        end
      end
    end
  end
end

function MobAttackLogic.setBallDestPoint(self, start, hit, left, rangeLen)
  local startX, startY = start.x, -start.y
  local hitX, hitY = hit.x, -hit.y
  local x = hitX
  local dx
  if left then
    dx = startX - hitX
  else
    dx = hitX - startX
  end
  local y = hitY
  local dy = hitY - startY
  if dx <= 0 then
    x = startX - 0.01
    if not left then
      x = startX + 0.01
    end
    dx = 0.01
    dy = 0
    y = startY
  end
  local v11 = dx
  local v12 = 0.6
  if 0.6 < ___MOD.math.abs(dy / dx) then
    if dy <= 0 then
      v11 = 0.6
      v12 = -dx
    end
    y = v11 * v12 + startY
    dy = y - startY
  end
  local lenSq = dx * dx + dy * dy
  local scale = rangeLen / ___MOD.math.sqrt(dx * dx + dy * dy)
  local destX = (x - startX) * scale + startX
  local destY = scale * (y - startY) + startY
  return ___MOD.Vector2(destX, -destY)
end

function MobAttackLogic.showHeal(self, mob, delta)
  local values = {delta}
  local criticals = {false}
  local delays = {0}
  local deff = mob.CurrentMap.DamageEffectComponent
  if deff then
    local head = mob.MobComponent.head
    if head ~= nil then
      deff:show(mob, ___MOD._DamageEffectType.Blue, values, criticals, delays, 0, head.TransformComponent:PositionAsFastVector3())
    end
  end
end

function MobAttackLogic.tryDoingAttack(self, mob, targetType, checkRangeOnly)
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local ai = mob.MobAIComponent
  local m = mob.MobComponent
  if ai == nil then
    return false
  end
  if not checkRangeOnly and (ai.attackGraceUntil == 0 or now < (ai.attackGraceUntil or 0)) then
    local remain = 0
    if ai.attackGraceUntil == 0 then
      remain = 1
      ai.attackGraceUntil = ___MOD._UtilLogic.ServerElapsedSeconds + 1
    else
      remain = ___MOD.math.max(0.1, ai.attackGraceUntil - now)
    end
    ai:enableNextControlTimer(remain, false)
    ai:setLocalControlUpdate(true, remain)
    return false
  end
  local forwardDir = ai.InputX == -1
  local mobId = m.id
  local mobData = ___MOD._MobManager:getMonster(mobId)
  local template = m.template
  local attackCount = mobData.attackCount
  local ms = mob.MobTemporaryStatComponent
  if attackCount == nil or attackCount == 0 or template.selfDestruction and attackCount == 1 then
    return false
  end
  if ms:isSet(___MOD._MTS.Seal) or ms:isSet(___MOD._MTS.SealSkill) or ms:isSet(___MOD._MTS.Doom) or ms:isSet(___MOD._MTS.Freeze) or ms:isSet(___MOD._MTS.ComboTempest) or ms:isSet(___MOD._MTS.Stun) then
    ai.NextAttackTime = now + 1
    return false
  end
  local mobPos = mob.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  local target
  if targetType == 0 then
    target = ___MOD._UserService.LocalPlayer
  elseif targetType == 1 then
    target = ___MOD._FindMobLogic:findNearestMob(mobPos, false, nil)
  elseif targetType == 2 then
    target = ___MOD._FindMobLogic:findNearestMob(mobPos, true, nil)
  elseif targetType == 3 then
    target = ai.Target
  end
  if target == nil or target.MobComponent and target.MobComponent.damagedByMob then
    return false
  end
  if target.PlayerTemporaryStatComponent and target.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Morph) == 1002 then
    ai.NextAttackTime = now + 1
    return false
  end
  local targetBox
  if target.TriggerComponent then
    targetBox = ___MOD._NumberUtils:triggerToBox(target.TriggerComponent)
  end
  if targetBox == nil then
    return
  end
  local candidatesAttack = {}
  local curMP = m.MP
  local doFirstAttack = ai.doFirstAttack
  for i = 1, attackCount do
    local attackInfo = ___MOD._MobManager:getMobAttackInfo(m.id, i)
    if attackInfo ~= nil and (attackInfo.type ~= ___MOD._MobAttackType.Area_3 and attackInfo.type ~= ___MOD._MobAttackType.Area_4 or not (now - ai.lastAreaAttack < 2.5)) then
      local conMP = attackInfo.conMP
      if not (curMP - conMP <= 0) then
        if doFirstAttack and attackInfo.doFirst then
          candidatesAttack = {}
          candidatesAttack[1] = attackInfo
          break
        end
        candidatesAttack[#candidatesAttack + 1] = attackInfo
      end
    end
  end
  if #candidatesAttack == 0 then
    ai.NextAttackTime = now + 5
    return false
  end
  local dwData = {}
  for i = #candidatesAttack, 1, -1 do
    local attackInfo = candidatesAttack[i]
    local range = attackInfo.range
    local type = attackInfo.type
    local foundTarget = false
    if type == ___MOD._MobAttackType.Range_0 then
      local left = not mob.SpriteRendererComponent.FlipX
      local lt = range.lt
      local rb = range.rb
      local b1 = ___MOD._NumberUtils:makeBoxShapeFromLtRb(mobPos, lt, rb, left)
      local b2 = targetBox
      if ___MOD._NumberUtils:intersectBox(b1, b2) then
        foundTarget = true
        dwData[i] = {
          target.Id
        }
      else
        b1 = ___MOD._NumberUtils:makeBoxShapeFromLtRb(mobPos, lt, rb, not left)
        if ___MOD._NumberUtils:intersectBox(b1, b2) then
          foundTarget = true
          dwData[i] = {
            target.Id
          }
        end
      end
      if foundTarget and checkRangeOnly then
        return true
      end
    elseif type == ___MOD._MobAttackType.Shoot_1 or type == ___MOD._MobAttackType.Pierce_2 then
      local left = m.faceLeft
      local sp = range.sp
      local spY = -sp.y * 0.01
      local spX = sp.x * (left and 1 or -1) * 0.01
      local startPosX = mobPos[1] + spX
      local startPosY = mobPos[2] + spY
      local r = range.r * 0.01
      local boxShape = ___MOD._NumberUtils:makeBoxShapeFromLtRb(mobPos, ___MOD.FastVector2(-r, 1), ___MOD.FastVector2(0, 0), left)
      local intersect = ___MOD._FindMobLogic:isRectIntersectWithTrapezoid(startPosX, ___MOD.math.abs(spX), r, startPosY, 4, left, targetBox, boxShape)
      if not intersect then
        left = not left
        spX = sp.x * (left and 1 or -1) * 0.01
        startPosX = mobPos[1] + spX
        intersect = ___MOD._FindMobLogic:isRectIntersectWithTrapezoid(startPosX, ___MOD.math.abs(spX), r, startPosY, 4, left, targetBox, boxShape)
      end
      if intersect then
        if checkRangeOnly then
          return true
        end
        if type == ___MOD._MobAttackType.Pierce_2 then
          local trigger = target.TriggerComponent
          local targetBoxSize = trigger.BoxSize
          local targetBoxOffset = trigger.ColliderOffset
          local targetPos = target.TransformComponent:WorldPositionAsFastVector3()
          local centerX = targetBoxOffset.x + targetPos[1]
          local xHit
          if left then
            local rcRight = centerX + targetBoxSize.x / 2
            local front = rcRight - 0.1
            xHit = centerX < front and front or centerX
          else
            local rcLeft = centerX - targetBoxSize.x / 2
            local front = rcLeft + 0.1
            xHit = centerX > front and front or centerX
          end
          local attackBaseY = startPosY
          local centerY = targetBoxOffset.y + targetPos[2]
          local rcTargetTop = centerY + targetBoxSize.y / 2
          local rcTargetBottom = centerY - targetBoxSize.y / 2
          local topInner = rcTargetTop - 0.1
          local bottomInner = rcTargetBottom + 0.1
          local yHit
          if attackBaseY > topInner then
            yHit = topInner
          elseif attackBaseY < bottomInner then
            yHit = bottomInner
          else
            yHit = centerY
          end
          dwData[attackInfo.idx] = {xHit, yHit}
        else
          dwData[attackInfo.idx] = {
            target.Id
          }
        end
        foundTarget = true
      end
    elseif type == ___MOD._MobAttackType.Area_3 then
      local start = range.start
      local areaCount = range.areaCount
      local _attackCount = range.attackCount
      local laneIndexList = ___MOD._TableUtils:get_random_unique_array(start, areaCount, _attackCount)
      local left = not mob.SpriteRendererComponent.FlipX
      local dir = left and -1 or 1
      local lt, rb = range.lt, range.rb
      local cellWidth = rb.x - lt.x
      local cellSpacing = 0 < range.spacing and range.spacing or cellWidth
      local fh = mob.CurrentMap.FootholdComponent
      local selectedLanes = {}
      local targetInfo = {}
      local flag = 0
      local offsetFirst = dir * (cellWidth * 0.5 + cellSpacing * start)
      local offsetLast = dir * (cellWidth * 0.5 + cellSpacing * (start + areaCount - 1))
      local minOffsetX = ___MOD.math.min(offsetFirst + lt.x, offsetLast + lt.x)
      local maxOffsetX = ___MOD.math.max(offsetFirst + rb.x, offsetLast + rb.x)
      local ltTotal = ___MOD.Vector2(minOffsetX, lt.y)
      local rbTotal = ___MOD.Vector2(maxOffsetX, rb.y)
      local b1 = ___MOD._NumberUtils:makeBoxShapeFromLtRb(mobPos, ltTotal, rbTotal, left)
      if ___MOD._NumberUtils:intersectBox(b1, targetBox) then
        foundTarget = true
      end
      if foundTarget then
        if checkRangeOnly then
          return true
        end
        cellWidth = cellWidth / 100
        cellSpacing = cellSpacing / 100
        local currentMap = mob.CurrentMap
        local mobX = mobPos.x
        local mobY = mobPos.y
        local yList = {}
        for i = 1, #laneIndexList do
          local laneIndex = laneIndexList[i]
          local x = mobX + dir * (cellWidth / 2 + cellSpacing * laneIndex)
          yList = {}
          ___MOD._FootholdLogic:getFootholdRange(currentMap, x, mobY + 1, mobY - 1, yList)
          local y = yList[1]
          if y ~= nil then
            selectedLanes[#selectedLanes + 1] = {
              laneIndex,
              x,
              y
            }
          end
        end
        dwData[attackInfo.idx] = selectedLanes
      end
    end
    if not foundTarget then
      ___MOD.table.remove(candidatesAttack, i)
    end
  end
  if #candidatesAttack <= 0 then
    ai.NextAttackTime = now + 0.2
    return false
  end
  local pick = ___MOD._GlobalRand32:randomIntegerRange(1, #candidatesAttack)
  local pickedAttack = candidatesAttack[pick]
  local pickedAttackIdx = pickedAttack.idx
  local playerX = ai.Target.TransformComponent:WorldPositionAsFastVector3().x
  local mobX = mob.TransformComponent:WorldPositionAsFastVector3().x
  local faceLeft = playerX < mobX
  local totalAttackDelay = ___MOD._MobManager:getTotalDelayAction(m.id, "attack" .. pickedAttackIdx) / 1000
  mob.CurrentMap.LifeControllerComponent2:requestControl(mob, {
    {
      ___MOD._MobActionPartType.Flip,
      faceLeft and -1 or 1,
      0,
      0
    },
    {
      ___MOD._MobActionPartType.Attack1,
      0,
      0.1,
      pickedAttackIdx,
      dwData[pickedAttackIdx]
    },
    {
      ___MOD._MobActionPartType.StandMotion,
      faceLeft and -1 or 1,
      totalAttackDelay,
      0
    }
  }, 3, ___MOD._CommandGroup.Attack, nil, ___MOD.isvalid(ai.Target))
  ai.NextAttackTime = now + totalAttackDelay + 0.2
  ai:enableNextControlTimer(totalAttackDelay + 0.2, false)
  ai:setLocalControlUpdate(true, totalAttackDelay + 0.2)
  ai.NextActionTime = now + totalAttackDelay + 0.2
  return true
end

function MobAttackLogic.tryDoingSkill(self, mob)
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local ai = mob.MobAIComponent
  local m = mob.MobComponent
  local temporary = mob.MobTemporaryStatComponent
  if ai.attackGraceUntil == 0 or now < (ai.attackGraceUntil or 0) then
    local remain = 0
    if ai.attackGraceUntil == 0 then
      ai.attackGraceUntil = ___MOD._UtilLogic.ServerElapsedSeconds + 1
      remain = 1
    else
      remain = ___MOD.math.max(0.1, ai.attackGraceUntil - now)
    end
    ai:enableNextControlTimer(remain, false)
    ai:setLocalControlUpdate(true, remain)
    return false
  end
  local skillIdx = ai.prepairSkillIdx
  if skillIdx == 0 or temporary:isSet(___MOD._MTS.Seal) or temporary:isSet(___MOD._MTS.SealSkill) or temporary:isSet(___MOD._MTS.Freeze) or temporary:isSet(___MOD._MTS.ComboTempest) or temporary:isSet(___MOD._MTS.Stun) then
    return false
  end
  if temporary:isSet(___MOD._MTS.Doom) then
    return false
  end
  local skillInfo = ___MOD._MobManager:getMobSkillInfo(m.id, skillIdx)
  if skillInfo == nil then
    return false
  end
  local skill = ___MOD._SkillManager:getMobSkill(skillInfo.skill, skillInfo.level)
  if skill == nil then
    return false
  end
  local action = skillInfo.action
  local actionName = "skill" .. action
  local totalAttackDelay = ___MOD._MobManager:getTotalDelayAction(m.id, actionName) / 1000
  local playerX = ai.Target.TransformComponent.WorldPosition.x
  local mobX = mob.TransformComponent.WorldPosition.x
  local faceLeft = playerX - mobX < 0
  ai.NextAttackTime = now + totalAttackDelay + 0.2
  ai:enableNextControlTimer(totalAttackDelay + 0.2, false)
  ai:setLocalControlUpdate(true, totalAttackDelay + 0.2)
  ai.NextActionTime = now + totalAttackDelay + 0.2
  mob.CurrentMap.LifeControllerComponent2:requestControl(mob, {
    {
      ___MOD._MobActionPartType.Flip,
      faceLeft and -1 or 1,
      0,
      0
    },
    {
      ___MOD._MobActionPartType.Skill1,
      0,
      0.1,
      skillIdx,
      totalAttackDelay
    },
    {
      ___MOD._MobActionPartType.StandMotion,
      faceLeft and -1 or 1,
      totalAttackDelay,
      0
    }
  }, 3, ___MOD._CommandGroup.Skill, nil, ___MOD.isvalid(ai.Target))
  return true
end

function MobAttackLogic.tryFirstAttack(self, mob)
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local ai = mob.MobAIComponent
  local m = mob.MobComponent
  local template = m.template
  local firstAttack = template.firstAttack
  local isDazzledMobByMe = self:isDazzledMobByMe(mob)
  if not firstAttack and not isDazzledMobByMe then
    return
  end
  if ___MOD.isvalid(ai.Target) then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local mobPos = mob.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  local target = ai.Target
  if isDazzledMobByMe then
    local nearestMob = ___MOD._FindMobLogic:findNearestMob(mobPos, false, user)
    if nearestMob and target ~= nearestMob then
      local targetPos = nearestMob.TransformComponent:WorldPositionAsFastVector3()
      local dx = ___MOD.math.abs(mobPos[1] - targetPos[1]) / 10 * 100
      local dy = ___MOD.math.abs(mobPos[2] - targetPos[2]) / 3 * 100
      if self:tryDoingAttack(mob, 1, true) or dx + dy <= 40 then
        ai:chaseTarget(nearestMob, false)
      end
    elseif target ~= nil then
      ai:chaseTarget(nil, false)
    end
  else
    if not firstAttack then
      return
    end
    local dazzledMob = ___MOD._FindMobLogic:findNearestMob(mobPos, true, user)
    if dazzledMob and target ~= dazzledMob then
      local targetPos = dazzledMob.TransformComponent:WorldPositionAsFastVector3()
      local dx = ___MOD.math.abs(mobPos[1] - targetPos[1]) / 10 * 100
      local dy = ___MOD.math.abs(mobPos[2] - targetPos[2]) / 3 * 100
      if self:tryDoingAttack(mob, 2, true) or dx + dy <= 40 then
        ai:chaseTarget(dazzledMob, false)
        return
      end
    end
    if user ~= target then
      local userPos = user.TransformComponent:WorldPositionAsFastVector3()
      local dx = ___MOD.math.abs(mobPos[1] - userPos[1]) / 10 * 100
      local dy = ___MOD.math.abs(mobPos[2] - userPos[2]) / 3 * 100
      if self:tryDoingAttack(mob, 0, true) or dx + dy <= 40 then
        ai:chaseTarget(user, false)
        return
      end
    end
  end
end
