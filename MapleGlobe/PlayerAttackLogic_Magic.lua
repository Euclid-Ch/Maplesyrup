

function PlayerAttackLogic_Magic.getChainLineBallState(self, skillID, index)
  local chainSkillID = skillID or ___MOD._SkillBook.Chain_Lightning_222_2221006
  local skill = ___MOD._SkillManager:getSkill(chainSkillID)
  local ball = skill and skill.ball or nil
  if chainSkillID == ___MOD._SkillBook.Energy_Orb_512_5121002 or chainSkillID == ___MOD._SkillBook.Spark_1511_15111006 then
    return ball and ball["0"] or ball or nil
  end
  return ball and ball[___MOD.tostring(index % 3)] or nil
end

function PlayerAttackLogic_Magic.getMakeFootholdEffectDelay(self, pa, ctx, defaultDelay)
  if ctx == nil then
    return defaultDelay
  end
  if self:isFootholdMeteorSkill(ctx.skillID) then
    return 0.36
  end
  local attackDelays = pa:getAttackDelay(ctx.motion)
  if attackDelays ~= nil and attackDelays[1] ~= nil then
    return attackDelays[1] / 1000
  end
  return defaultDelay
end

function PlayerAttackLogic_Magic.getMeteorHitIndex(self, ctx)
  local hitCount = 0
  for i = 1, 100 do
    if ctx.hitData ~= nil then
      local eff = ctx.hitData[i] or ctx.hitData[i]
      if eff ~= nil then
        hitCount = hitCount + 1
      else
        break
      end
    end
  end
  if hitCount <= 0 then
    return 0
  end
  return ___MOD._GlobalRand32:randomIntegerRange(0, hitCount - 1)
end

function PlayerAttackLogic_Magic.getMeteorSelectedHitData(self, ctx, hitIndex)
  if ctx.hitData == nil then
    return nil
  end
  return ctx.hitData.pos and ctx.hitData or ctx.hitData[hitIndex + 1]
end

function PlayerAttackLogic_Magic.getMeteorTargetMobs(self, attacker, ctx, targets)
  local box = ctx.box
  if box == nil then
    return {}
  end
  local boxSize = box.Size
  return ___MOD._PlayerAttackLogic:findValidMobs(attacker, box.Position, boxSize, 0, targets, false)
end

function PlayerAttackLogic_Magic.isChainLightningLikeSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Chain_Lightning_222_2221006 or skillID == ___MOD._SkillBook.Energy_Orb_512_5121002 or skillID == ___MOD._SkillBook.Spark_1511_15111006
end

function PlayerAttackLogic_Magic.isFootholdMeteorSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Meteor_Shower_212_2121007 or skillID == ___MOD._SkillBook.Blizzard_222_2221007 or skillID == ___MOD._SkillBook.Genesis_232_2321008 or skillID == ___MOD._SkillBook.Meteor_Shower_1211_12111003
end

function PlayerAttackLogic_Magic.onAttack_ChainLightning(self, attacker, attackDelay, ctx, hitDelayInfo, actionLockDelay)
  local function getMobCenterWorldPos(mob)
    return ___MOD._PlayerAttackLogic:getMobVisualCenterWorldPos(mob)
  end

  local function dist2(pos, mob)
    local mobPosition = mob.TransformComponent:WorldPositionAsFastVector3()
    local dx = mobPosition.x - pos.x
    local dy = mobPosition.y - pos.y
    return dx * dx + dy * dy
  end

  local step = 0.5
  local maxCount = ___MOD.math.max(___MOD.math.tointeger(___MOD.tonumber(ctx.skillLevelData.mobCount) or 1) or 1, 1)
  if ctx.skillID == ___MOD._SkillBook.Chain_Lightning_222_2221006 then
    maxCount = ___MOD.math.min(maxCount, 15)
  end
  local shootRange = 0.6
  local mapleRange = 300
  mapleRange = (ctx.skillID == ___MOD._SkillBook.Energy_Orb_512_5121002 or ctx.skillID == ___MOD._SkillBook.Spark_1511_15111006) and ___MOD.tonumber(ctx.skillLevelData.range) or mapleRange
  local range = mapleRange / 100
  local chainJumpRange = 1.5
  if ctx.skillID == ___MOD._SkillBook.Spark_1511_15111006 then
    chainJumpRange = range
  end
  local delay = 0.1
  local isFaceLeft = attacker.PlayerControllerComponent.LookDirectionX == -1
  local sp = ___MOD._UserService.LocalPlayer.TransformComponent:WorldPositionAsFastVector3():Clone()
  sp.y = sp.y + 0.28
  if isFaceLeft then
    sp.x = sp.x - shootRange
  else
    sp.x = sp.x + shootRange
  end
  local boxShape = ___MOD._PlayerAttackLogic_Shoot:makeBoxShapeFromLtRb(sp:ToVector2(), ___MOD.FastVector2(-mapleRange, 1), ___MOD.FastVector2.zero:Clone(), isFaceLeft)
  local damages = {}
  local criticals = {}
  local damageDelays = {}
  local mobs = {}
  local attackDelays = {}
  local chains = {}
  local m = {}
  local hitMobCount = ___MOD._PlayerAttackLogic_Shoot:findHitMobInTrapezoid(sp.x, shootRange, range, sp.y, 4, m, isFaceLeft, boxShape, ___MOD._UserService.LocalPlayer, nil)
  local playerInputX = attacker.PlayerControllerComponent.LookDirectionX
  if 0 < hitMobCount then
    ___MOD.table.sort(m, function(a, b)
      return dist2(sp, a) < dist2(sp, b)
    end)
    local firstMob = m[1]
    if ___MOD.isvalid(firstMob) then
      mobs[#mobs + 1] = firstMob
      attackDelays[#attackDelays + 1] = attackDelay
      local firstPos = getMobCenterWorldPos(firstMob)
      chains[#chains + 1] = {sp, firstPos}
      local chainMobs = {}
      local chainMobCount = ___MOD._FindMobLogic:findHitMobByChainLightning(firstMob, chainMobs, maxCount, isFaceLeft, chainJumpRange, attacker)
      local previousCenter = firstPos
      for i = 2, chainMobCount do
        local nextMob = chainMobs[i]
        local nextCenter = getMobCenterWorldPos(nextMob)
        mobs[#mobs + 1] = nextMob
        attackDelays[#attackDelays + 1] = attackDelay + (i - 1) * delay
        chains[#chains + 1] = {previousCenter, nextCenter}
        previousCenter = nextCenter
      end
      for i = 1, #attackDelays do
        ___MOD._TimerService:SetTimerOnce(function()
          local pos = chains[i]
          self:spawnChainLineTo(pos[1], pos[2], step, nil, nil, nil, attacker, ctx.skillID)
          local mob = mobs[i]
          local mobCenter = getMobCenterWorldPos(mob)
          local mobOrigin = mob.TransformComponent:WorldPositionAsFastVector3()
          local hitOffset = ___MOD.FastVector3(mobCenter.x - mobOrigin.x, mobCenter.y - mobOrigin.y, 0)
          local hitAnimData = ctx.hitData
          if ctx.skillID == ___MOD._SkillBook.Energy_Orb_512_5121002 and ctx.skillData ~= nil and ctx.skillData.hit ~= nil then
            hitAnimData = ctx.skillData.hit
          end
          ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, 0, mob, 1.0, hitOffset, hitAnimData, false, isFaceLeft, nil)
          ___MOD._PlayerAttackLogic_Melee:playAttackSound(attacker, mob, ctx.skillID, mob.MobComponent.id)
        end, attackDelays[i])
      end
      local attackerPosSnapshot = attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
      for i = 1, #mobs do
        local mob = mobs[i]
        local attackDelay_ = attackDelays[i]
        local damageDelays_ = {}
        damageDelays_[1] = attackDelay_ * 1000
        local damages_, criticals_, highestDamage = ___MOD._PlayerAttackLogic:calcDamageClient(attacker, mob, ctx.skillID, ctx.skillLevel, 1, damageDelays_, ctx.motion, 0, 0, 0, i, 0.0, false)
        damages[#damages + 1] = damages_
        criticals[#criticals + 1] = criticals_
        damageDelays[#damageDelays + 1] = damageDelays_
        ___MOD._PlayerAttackLogic:displaySkillDamageByAttackerClient(attacker, mob, ctx.skillID, damages_, criticals_, damageDelays_)
        local totalDamage, deadlyAttack = ___MOD._PlayerAttackLogic:onAttackClient(attacker, mob, damages_)
      end
    end
  end
  local sad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(ctx.skillID, ctx.skillLevel, sp:ToVector2(), playerInputX, #mobs, #hitDelayInfo, ctx.motion, ___MOD._SkillAttackType.Melee, mobs, damages, criticals, damageDelays, hitDelayInfo[1], ctx.playRate, isFaceLeft, 0, 0, 0, 0, 0, chains, 0.0, false, nil)
  sad.clientActionLockDelay = actionLockDelay
  ___MOD._PlayerAttackLogic:applyPendingWindWalkAttackBoost(attacker, sad)
  ___MOD._PlayerAttackLogic:onPlayerAttack(attacker, sad:toTable())
  ___MOD._PlayerAttackLogic:trySparkChainAttack(attacker, ctx.skillID, mobs, damageDelays[1] ~= nil and damageDelays[1][1] or hitDelayInfo[1])
  ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(attacker)
end

function PlayerAttackLogic_Magic.onAttack_Explosion(self, attacker, ctx, motion, chargePer)
  if ctx.skillData ~= nil and ctx.skillLevelData ~= nil then
    local lt = ctx.skillLevelData.lt
    local rb = ctx.skillLevelData.rb
    local explosionLt, explosionRb
    if (lt == nil or rb == nil) and (ctx.skillID == ___MOD._SkillBook.Big_Bang_212_2121001 or ctx.skillID == ___MOD._SkillBook.Big_Bang_222_2221001 or ctx.skillID == ___MOD._SkillBook.Big_Bang_232_2321001) then
      explosionLt = ___MOD.FastVector2(-200, -150)
      explosionRb = ___MOD.FastVector2(200, 150)
    else
      explosionLt = lt * 100
      explosionRb = rb * 100
    end
    local prepare = ctx.skillData.prepare
    if prepare ~= nil then
      attacker.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.ExplosionSequence, true)
      attacker.PlayerActionComponent:playOnceClient(prepare.action, 1.0, attacker, false, true)
      if prepare.anim ~= nil then
        ___MOD._PlayerAttackLogic:playSkillEffect(attacker, ctx.skillID, 0, prepare.anim, 1.0)
      end
      local skillIdStr = ___MOD.string.format("%07d", ctx.skillID)
      ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", skillIdStr), attacker, 1)
      ___MOD._TimerService:SetTimerOnce(function()
        attacker.PlayerActionComponent:playOnceClient(motion, 1.0, attacker, true, false)
        if ctx.skillData.effect ~= nil then
          ___MOD._PlayerAttackLogic:playSkillEffect(attacker, ctx.skillID, 0, ctx.skillData.effect, 1.0)
        end
        local ctx = ___MOD._PlayerAttackLogic_Melee:initSkillCtx(attacker, ctx.skillID, ctx.skillLevel, ctx.weaponInfo, false, false, false)
        local attackEndDelay = ___MOD._PlayerSkillLogic:getSkillActionLockDelaySec(attacker, ctx.skillID, motion, 0, 0)
        ___MOD._PlayerAttackLogic_Melee:onAttack(attacker, ctx, {0}, 0, 0, 0, chargePer, false, nil, nil, attackEndDelay)
        ___MOD._TimerService:SetTimerOnce(function()
          if ___MOD.isvalid(attacker) then
            attacker.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.ExplosionSequence, false)
          end
        end, attackEndDelay)
      end, prepare.totalDelay / 1000)
      ___MOD._ExtendedEffectService:makeExplosionAnimation(attacker.CurrentMap, ctx.skillData.special, attacker.TransformComponent:WorldPositionAsFastVector3(), explosionLt, explosionRb, prepare.totalDelay / 1000, attacker)
    elseif ctx.skillData.special ~= nil then
      ___MOD._ExtendedEffectService:makeExplosionAnimation(attacker.CurrentMap, ctx.skillData.special, attacker.TransformComponent:WorldPositionAsFastVector3(), explosionLt, explosionRb, 0, attacker)
    end
  end
end

function PlayerAttackLogic_Magic.onAttack_MeteorShower(self, attacker, ctx, actionDelay, chargePer, actionLockDelay)
  if ctx.skillData == nil or ctx.skillLevelData == nil then
    return
  end
  local targets = ___MOD.math.max(1, ctx.skillLevelData.mobCount or 1)
  local mobs = self:getMeteorTargetMobs(attacker, ctx, targets)
  local hitIndex = self:getMeteorHitIndex(ctx)
  local totalDelaySec = actionDelay + 1.8
  local totalDelayMs = ___MOD.math.floor(totalDelaySec * 1000 + 0.5)
  local damages = {}
  local criticals = {}
  local delays = {}
  local highestDamages = {}
  local attackerPosSnapshot = attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
  for i = 1, #mobs do
    local mob = mobs[i]
    local tempDamageDelays = {}
    local damages_, criticals_, highestDamage = ___MOD._PlayerAttackLogic:calcDamageClient(attacker, mob, ctx.skillID, ctx.skillLevel, ctx.attackCount, tempDamageDelays, ctx.motion, 0, 0, 0, i, chargePer, false)
    local damageDelays = {}
    for j = 1, #damages_ do
      damageDelays[j] = totalDelayMs
    end
    damages[i] = damages_
    criticals[i] = criticals_
    delays[i] = damageDelays
    highestDamages[i] = highestDamage
  end
  if ctx.skillData.tile ~= nil then
    local pos = attacker.TransformComponent:WorldPositionAsFastVector3()
    ___MOD._ExtendedEffectService:makeFootholdEffectGlobalXSpacing(attacker.CurrentMap, ctx.skillData.tile, pos:ToVector2(), ctx.skillLevelData.lt * 100, ctx.skillLevelData.rb * 100, actionDelay, targets, nil, attacker)
  end
  ___MOD._TimerService:SetTimerOnce(function()
    for i = 1, #mobs do
      local mob = mobs[i]
      if ___MOD.isvalid(mob) then
        self:playMeteorMobHitEffectClient(attacker, ctx, mob, hitIndex)
      end
    end
  end, actionDelay)
  local playerInputX = attacker.PlayerControllerComponent.LookDirectionX
  local sendMobs = {}
  local sendDamages = {}
  local sendCriticals = {}
  local sendDelays = {}
  for i = 1, #mobs do
    local mob = mobs[i]
    if ___MOD.isvalid(mob) then
      sendMobs[#sendMobs + 1] = mob
      sendDamages[#sendDamages + 1] = damages[i]
      sendCriticals[#sendCriticals + 1] = criticals[i]
      sendDelays[#sendDelays + 1] = delays[i]
      ___MOD._PlayerAttackLogic:displaySkillDamageByAttackerClient(attacker, mob, ctx.skillID, damages[i], criticals[i], delays[i])
      local totalDamage, deadlyAttack = ___MOD._PlayerAttackLogic:onAttackClient(attacker, mob, damages[i])
    end
  end
  local sad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(ctx.skillID, ctx.skillLevel, attackerPosSnapshot, playerInputX, #sendMobs, ctx.attackCount, ctx.motion, ___MOD._SkillAttackType.Melee, sendMobs, sendDamages, sendCriticals, sendDelays, 0, ctx.playRate, ctx.isFaceLeft, 0, 0, 0, 0, 0, nil, chargePer, false, nil)
  sad.clientActionLockDelay = actionLockDelay
  ___MOD._PlayerAttackLogic:applyPendingWindWalkAttackBoost(attacker, sad)
  ___MOD._PlayerAttackLogic:onPlayerAttack(attacker, sad:toTable())
  ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(attacker)
end

function PlayerAttackLogic_Magic.playEffect(self, attacker, ctx, totalDelay, weaponType)
  attacker.PlayerActionComponent:playOnceClient(ctx.motion, ctx.playRate, attacker, true, false)
  if ctx.effectData ~= nil then
    ___MOD._PlayerAttackLogic:playSkillEffect(attacker, ctx.skillID, ctx.effectIndex, ctx.effectData, ctx.playRate)
  end
  if ctx.skillID == ___MOD._SkillBook.Energy_Orb_512_5121002 and ctx.skillData ~= nil and ctx.skillData.effect0 ~= nil then
    ___MOD._PlayerAttackLogic:playSkillEffect(attacker, ctx.skillID, 1, nil, ctx.playRate)
  elseif self:isFootholdMeteorSkill(ctx.skillID) and ctx.skillData ~= nil and ctx.skillData.effect0 ~= nil then
    ___MOD._PlayerAttackLogic:playSkillEffect(attacker, ctx.skillID, 0, ctx.skillData.effect0, ctx.playRate)
  end
  local skillIdStr = ___MOD.string.format("%07d", ctx.skillID)
  ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", skillIdStr), attacker, 1)
end

function PlayerAttackLogic_Magic.playMeteorMobHitEffectClient(self, attacker, ctx, mob, hitIndex)
  local hitData = self:getMeteorSelectedHitData(ctx, hitIndex)
  if hitData == nil then
    return
  end
  local playerPos = attacker.TransformComponent:PositionAsFastVector3():Clone():ToVector2()
  local mobPos = mob.TransformComponent.Position:ToVector2()
  local mobFaceLeft = mob.MovementComponent:IsFaceLeft()
  local effectTarget = mob
  local hitOffset = ___MOD._PlayerAttackLogic:getHitOffset(mob, playerPos, mobPos, ctx.box, ctx.isFaceLeft, mobFaceLeft, false)
  local hitPoint
  if ctx.box ~= nil then
    hitPoint = ___MOD._PlayerAttackLogic:getHitPoint(mob, ctx.box)
  end
  if hitPoint ~= nil then
    hitOffset = ___MOD.FastVector3(hitPoint.x - mobPos.x, hitPoint.y - mobPos.y, 0)
  end
  if hitData.pos == 3 then
    hitOffset = ___MOD.FastVector3.zero:Clone()
    hitOffset.y = mob.MobComponent.spriteSize.y / 2
  elseif hitData.pos == 2 then
    effectTarget = mob.MobComponent.head
    hitOffset = ___MOD.FastVector3.zero:Clone()
  else
    effectTarget = mob.CurrentMap
    hitOffset = hitOffset + ___MOD.FastVector3(mobPos.x, mobPos.y, 0)
  end
  ___MOD._PlayerAttackLogic_Melee:playAttackSound(attacker, mob, ctx.skillID, mob.MobComponent.overrideMobID ~= 0 and mob.MobComponent.overrideMobID or mob.MobComponent.id)
  local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, hitIndex, effectTarget, 1.0, hitOffset, ctx.hitData, false, true, nil)
  ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
end

function PlayerAttackLogic_Magic.spawnChainLineTo(self, startPos, targetPos, step, countPerBatch, batchDelay, angleOverride, ownerEntity, skillID)
  local sampleBall = self:getChainLineBallState(skillID, 0)
  if sampleBall == nil then
    return
  end
  local pool = ___MOD._UserService.LocalPlayer.PlayerVariables.skillBallPool
  step = step or 0.5
  countPerBatch = countPerBatch or 3
  batchDelay = batchDelay or 0.1
  local vx = targetPos.x - startPos.x
  local vy = targetPos.y - startPos.y
  local dist = ___MOD.math.sqrt(vx * vx + vy * vy)
  if dist <= 1.0E-4 then
    dist = 0
  end
  local totalCount = ___MOD.math.max(1, ___MOD.math.ceil(dist / step))
  local ux, uy = 0, 0
  if 0 < dist then
    ux = vx / dist
    uy = vy / dist
  end
  local dx = ux * step
  local dy = uy * step
  local angleDeg = angleOverride
  if angleDeg == nil then
    angleDeg = ___MOD.math.deg(___MOD.math.atan(uy, ux))
  end
  for idx = 0, totalCount - 1 do
    local x = startPos.x + dx * idx
    local y = startPos.y + dy * idx
    local b1 = self:getChainLineBallState(skillID, idx)
    if b1 ~= nil then
      local bulletObj = ___MOD._ObjectPool:pick(pool, "chain", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", ___MOD.FastVector3(x, y, 0), ___MOD._UserService.LocalPlayer.CurrentMap, false)
      bulletObj.TransformComponent.ZRotation = angleDeg
      local asp = bulletObj.AnimationSpriteComponent
      local isEnergyOrb = (skillID or 0) == ___MOD._SkillBook.Energy_Orb_512_5121002
      asp.releasePool = pool
      asp.loop = false
      if isEnergyOrb then
        asp:setSingleFrameStateFade(b1, 255, 0, 0.2)
      else
        asp:setWzSprite(b1, false)
      end
      ___MOD._ExtendedEffectService:applySkillEffectAlpha(bulletObj, ownerEntity)
      bulletObj.Enable = true
      bulletObj.Visible = true
    end
  end
end

function PlayerAttackLogic_Magic.tryMagicAttack(self, attacker, skillID, skillLevel, pa, weaponInfo, isFinalAttack, chargePer)
  if pa.isClimbing or pa.sitting then
    return false
  end
  if attacker.Player:isDead() then
    return false
  end
  if not attacker.ExtendPlayerControllerComponent.inSwimMap and not attacker.RigidbodyComponent:IsOnGround() then
    return false
  end
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  if skillID == ___MOD._SkillBook.Energy_Orb_512_5121002 and attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.EnergyCharge) == 0 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "에너지가 완충된 상태에서만 사용할 수 있는 스킬입니다.")
    pa.enableNextAttackTime = currentTime + 0.3
    return false
  end
  local ctx = ___MOD._PlayerAttackLogic_Melee:initSkillCtx(attacker, skillID, skillLevel, weaponInfo, isFinalAttack, false, false)
  if ctx.skillData ~= nil and ctx.skillData.weapon ~= nil and not ___MOD._PlayerAttackLogic:checkWeapon(ctx.skillData.weapon, weaponInfo.itemID) then
    pa:displayAttackMessage("장착한 무기로는 사용할 수 없는 스킬입니다.")
    pa.enableNextAttackTime = currentTime + 0.1
    return false
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion) then
    pa:displayAttackMessage("알 수 없는 오류가 발생하여 공격에 실패했습니다.")
    pa.enableNextAttackTime = currentTime + 0.1
    return false
  end
  if ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(attacker, skillID, ctx.skillLevelData, 0, 0, 0) ~= 0 then
    pa.enableNextAttackTime = currentTime + 0.1
    return false
  end
  local isFaceLeft = attacker.ExtendPlayerControllerComponent.LookDirectionX == -1
  local startFrameIndex, sprites = attacker.AfterImageComponent:getAfterImageData2(ctx.motion)
  local hitDelayInfo, lastAttackDelay = ___MOD._PlayerAttackLogic:makeHitDelayInfo(pa, ctx, sprites)
  local prepare = ctx.skillData.prepare
  local prepareDelay = 0
  if prepare ~= nil then
    prepareDelay = prepare.totalDelay / 1000
  end
  local totalActionDelay = pa:getTotalSkillActionDelay(ctx.motion, skillID) + prepareDelay
  local actionLockDelay = ___MOD._PlayerSkillLogic:getSkillActionLockDelaySec(attacker, skillID, ctx.motion, 0, prepareDelay)
  local attackDelay = lastAttackDelay ~= nil and lastAttackDelay or totalActionDelay
  ___MOD._PlayerStateLogic:changeState(attacker, "SKILL_ATTACK")
  if ___MOD._AntiRepeat:tryRepeat(___MOD._AntiRepeatType.Attack) then
    if self:isChainLightningLikeSkill(skillID) then
      self:onAttack_ChainLightning(attacker, attackDelay, ctx, hitDelayInfo, actionLockDelay)
    elseif skillID == ___MOD._SkillBook.Explosion_211_2111002 or skillID == ___MOD._SkillBook.Big_Bang_212_2121001 or skillID == ___MOD._SkillBook.Big_Bang_222_2221001 or skillID == ___MOD._SkillBook.Big_Bang_232_2321001 then
      self:onAttack_Explosion(attacker, ctx, ctx.motion, chargePer)
    elseif self:isFootholdMeteorSkill(skillID) then
      local firstAttackDelay = self:getMakeFootholdEffectDelay(pa, ctx, attackDelay)
      self:onAttack_MeteorShower(attacker, ctx, firstAttackDelay, chargePer, actionLockDelay)
    else
      ___MOD._PlayerAttackLogic_Shoot:onAttack(attacker, 0, 1, attackDelay * 1000, skillID, skillLevel, weaponInfo.weaponType, ctx.motion, hitDelayInfo, ctx, true, 0, chargePer, nil, actionLockDelay)
    end
  else
    return false
  end
  if skillID ~= ___MOD._SkillBook.Explosion_211_2111002 and skillID ~= ___MOD._SkillBook.Big_Bang_212_2121001 and skillID ~= ___MOD._SkillBook.Big_Bang_222_2221001 and skillID ~= ___MOD._SkillBook.Big_Bang_232_2321001 then
    self:playEffect(attacker, ctx, totalActionDelay, weaponInfo.weaponType)
  end
  ___MOD._PlayerSkillLogic:logSkillActionLockClient(attacker, "Magic", skillID, ctx.motion, actionLockDelay, attackDelay * 1000, totalActionDelay)
  pa.enableNextAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds + actionLockDelay
  pa.enableNextTeleportTime = ___MOD._UtilLogic.ServerElapsedSeconds + 0.3
  return true
end
