

function PlayerAttackLogic_Melee.calculateHitBox(self, attacker, ctx, isFaceLeft)
  if ctx.skillID == ___MOD._SkillBook.Blast_122_1221009 and ctx.afterimageInfo ~= nil then
    local afterImageLt = ___MOD._WzUtils:getVector(ctx.afterimageInfo.lt, nil)
    local afterImageRb = ___MOD._WzUtils:getVector(ctx.afterimageInfo.rb, nil)
    if afterImageLt and afterImageRb then
      local center, size = ___MOD._OffsetUtils:calcNormalizedBox(afterImageLt / 100, afterImageRb / 100, isFaceLeft)
      return ___MOD.BoxShape(center, size, 0)
    end
  end
  local lt = ctx.skillLevelData.lt
  local rb = ctx.skillLevelData.rb
  if (lt == nil or rb == nil) and (ctx.skillID == ___MOD._SkillBook.Big_Bang_212_2121001 or ctx.skillID == ___MOD._SkillBook.Big_Bang_222_2221001 or ctx.skillID == ___MOD._SkillBook.Big_Bang_232_2321001) then
    lt = ___MOD.Vector2(-2.0, -1.5)
    rb = ___MOD.Vector2(2.0, 1.5)
  end
  if lt and rb then
    if ctx.skillID == ___MOD._SkillBook.Heal_230_2301002 then
      lt = lt * 0.6
      rb = rb * 0.6
    end
    local center, size = ___MOD._OffsetUtils:calcNormalizedBox(lt, rb, isFaceLeft)
    return ___MOD.BoxShape(center, size, 0)
  end
  if ctx.skillLevelData.range ~= 0 then
    local center, size = ___MOD._OffsetUtils:calcNormalizedBox(___MOD.Vector2(-(ctx.skillLevelData.range / 100), -0.8), ___MOD.Vector2(0.0, 0.2), isFaceLeft)
    return ___MOD.BoxShape(center, size, 0)
  end
  if ctx.skillID == ___MOD._SkillBook.Savage_Blow_420_4201005 then
    local center, size = ___MOD._OffsetUtils:calcNormalizedBox(___MOD.Vector2(-0.85, -0.3), ___MOD.Vector2(-0.25, -0.15), isFaceLeft)
    return ___MOD.BoxShape(center, size, 0)
  elseif ctx.skillID == ___MOD._SkillBook.Magic_Claw_1200_12001003 or ctx.skillID == ___MOD._SkillBook.Magic_Claw_200_2001005 then
    local center, size = ___MOD._OffsetUtils:calcNormalizedBox(___MOD.Vector2(-3.0, -0.8), ___MOD.Vector2(0.0, 0.8), isFaceLeft)
    return ___MOD.BoxShape(center, size, 0)
  end
  if ctx.afterimageInfo ~= nil then
    local afterImageLt = ___MOD._WzUtils:getVector(ctx.afterimageInfo.lt, nil)
    local afterImageRb = ___MOD._WzUtils:getVector(ctx.afterimageInfo.rb, nil)
    if afterImageLt and afterImageRb then
      local center, size = ___MOD._OffsetUtils:calcNormalizedBox(afterImageLt / 100, afterImageRb / 100, isFaceLeft)
      return ___MOD.BoxShape(center, size, 0)
    end
  end
  return ___MOD.BoxShape(___MOD.Vector2.zero, ___MOD.Vector2.zero, 0)
end

function PlayerAttackLogic_Melee.findPartyMembersByHeal(self, player, skillData, skillLevelData)
  local targets = {}
  local lt = skillLevelData.lt
  local rb = skillLevelData.rb
  local t = ___MOD._MobAttackLogic:findTargetByLtRb(player, lt * 100, rb * 100, player.TransformComponent:WorldPositionAsFastVector3():ToVector2(), player.PlayerControllerComponent.LookDirectionX == -1, "Player")
  local partyID = player.Player.PartyId
  for _, p in ___MOD.pairs(t) do
    if ___MOD.isvalid(p) and (player.Player.PlayerId == p.Player.PlayerId or partyID ~= 0 and partyID == p.Player.PartyId) then
      targets[#targets + 1] = p
    end
  end
  return targets
end

function PlayerAttackLogic_Melee.getRangeDelay(self, skillID)
  local aranRangeDelay = ___MOD._AranLogic:getRangeDelayForLocalPlayer(skillID)
  if 0 < aranRangeDelay then
    return aranRangeDelay
  end
  if skillID == ___MOD._SkillBook.Slash_Blast_100_1001005 or skillID == ___MOD._SkillBook.Slash_Blast_1100_11001003 or skillID == ___MOD._SkillBook.Air_Strike_522_5221003 then
    return 0.09
  elseif skillID == ___MOD._SkillBook.Final_Toss_2111_21110003 then
    return 0.08
  elseif skillID == ___MOD._SkillBook.Shockwave_511_5111006 or skillID == ___MOD._SkillBook.Shockwave_1511_15111003 then
    return 0.15
  elseif skillID == ___MOD._SkillBook.Brandish_112_1121008 or skillID == ___MOD._SkillBook.Brandish_1111_11111004 then
    return 0.035
  elseif skillID == ___MOD._SkillBook.Heavens_Hammer_122_1221011 or skillID == ___MOD._SkillBook.Combo_Tempest_2112_21120006 then
    return 0.05
  elseif skillID == ___MOD._SkillBook.Ninja_Storm_412_4121008 or skillID == ___MOD._SkillBook.Rolling_Spin_2111_21110006 then
    return 0.06
  elseif skillID == ___MOD._SkillBook.Storm_Break_1310_13101005 then
    return 0.1
  end
  return 0
end

function PlayerAttackLogic_Melee.initSkillAttackData(self, skillID, skillLevel, playerPos, playerInputX, targets, hits, motion, attackType, mobs, damages, criticals, delays, firstAttackDelay, playRate, isFaceLeft, finalAttackSkillID, starItemID, range, targetCount, bulletSlot, chainLightningInfo, chargePer, finishAttack, mesoExplosionInfo)
  local sad = ___MOD.SkillAttackData()
  local flag = (targets & 65535) << 16 | hits & 65535
  sad.flag = flag
  sad.skillID = skillID
  sad.skillLevel = skillLevel
  sad.motion = motion
  sad.attackType = attackType
  sad.isFaceLeft = isFaceLeft
  sad.firstAttackDelay = firstAttackDelay
  sad.playRate = playRate
  sad.starItemID = starItemID
  sad.shootRange = range
  sad.finalAttackSkillID = finalAttackSkillID
  sad.targetCount = targetCount
  sad.bulletSlot = bulletSlot
  if chainLightningInfo ~= nil then
    local chainLightnings = {}
    for i = 1, #chainLightningInfo do
      local info = ___MOD.ChainLightningInfo()
      info.startPos = chainLightningInfo[i][1]
      info.endPos = chainLightningInfo[i][2]
      chainLightnings[i] = info
    end
    sad.chainLightningInfo = chainLightnings
  end
  if mesoExplosionInfo ~= nil then
    sad.mesoExplosionInfo = mesoExplosionInfo
  end
  local targets_ = {}
  for i = 1, #mobs do
    local targetData = ___MOD.TargetData()
    local mob = mobs[i]
    local hit = ___MOD.HitData()
    local hits_ = {}
    local hitCount = hits
    if skillID == ___MOD._SkillBook.Meso_Explosion_421_4211006 then
      hitCount = #damages[i]
    end
    for j = 1, hitCount do
      local damageData = ___MOD.DamageData()
      damageData.damage = damages[i][j]
      damageData.critical = criticals[i][j]
      damageData.delay = delays[i][j]
      hits_[j] = damageData
    end
    hit.hits = hits_
    targetData.hitData = hit
    targetData.mob = mob
    targetData.targetPos = mob.TransformComponent.WorldPosition:ToVector2()
    targets_[i] = targetData
  end
  sad.targets = targets_
  sad.chargePer = chargePer
  sad.finishAttack = finishAttack
  sad.playerPos = playerPos
  sad.playerInputX = playerInputX
  return sad
end

function PlayerAttackLogic_Melee.initSkillCtx(self, attacker, skillID, skillLevel, weaponInfo, isFinalAttack, isShoot, remote)
  local skillData, skillLevelData
  local isFaceLeft = attacker.ExtendPlayerControllerComponent.LookDirectionX == -1
  if 0 < skillID then
    skillData = ___MOD._SkillManager:getSkill(skillID)
    if skillData == nil then
      return
    end
    skillLevelData = skillData.level[skillLevel]
    if skillLevelData == nil then
      return
    end
  end
  local motion, effectIndex, playDefault, hitIndex = ___MOD._PlayerAttackLogic:setSkillMotion(attacker, skillData, skillID, skillLevel, weaponInfo, isFinalAttack, isShoot, remote)
  local ctx = ___MOD.SkillContext()
  ctx.skillID = skillID
  ctx.skillLevel = skillLevel
  ctx.skillData = skillData
  ctx.skillLevelData = skillLevelData
  ctx.weaponInfo = weaponInfo
  ctx.motion = motion
  if skillID == ___MOD._SkillBook.Piercing_Arrow_322_3221001 and ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion) then
    ctx.motion = "shoot2"
  elseif skillID == ___MOD._SkillBook.Assassinate_422_4221001 and ___MOD._PlayerSkillLogic:isAssassinateFollowUpActive(attacker) then
    ctx.motion = "assassinationS"
  end
  ctx.effectIndex = effectIndex
  ctx.playDefaultAttackAfterimage = playDefault
  ctx.playRate = ___MOD._PlayerAttackLogic:getAttackPlayRate(attacker, skillID)
  if skillID == ___MOD._SkillBook.Flame_Gear_1211_12111005 then
    ctx.mistSpawnPositionSnapshot = attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  end
  if hitIndex ~= 0 then
    ctx.hitIndex = hitIndex
  end
  if skillID == ___MOD._SkillBook.Double_Stab_400_4001334 then
    ctx.playRate = ctx.playRate * 0.85
  end
  ctx.attackCount = 1
  if skillID == 0 and weaponInfo.subWeaponID // 1000 == ___MOD._WeaponType.BLADE then
    ctx.attackCount = 2
  end
  if 0 < skillID then
    ctx.attackCount = ___MOD.math.max(1, ctx.skillLevelData.attackCount or 1)
    ctx.hitData, ctx.effectData = self:resolveHitEffectData(attacker, skillData)
    ctx.afterimageInfo, ctx.startFrameIndex = self:resolveAfterimageData(attacker, ctx)
    ctx.box = self:calculateHitBox(attacker, ctx, isFaceLeft)
    ctx.box.Position = ctx.box.Position + attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  end
  ctx.isFaceLeft = isFaceLeft
  return ctx
end

function PlayerAttackLogic_Melee.isCanAttack(self, attacker, weaponInfo, ctx)
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  local pa = attacker.PlayerActionComponent
  if ctx.skillData ~= nil then
    local checkPirate = false
    if attacker.Player.Job >= 500 and attacker.Player.Job <= 532 or attacker.Player.Job >= 1500 and attacker.Player.Job <= 1512 then
      checkPirate = true
      if weaponInfo.valid and weaponInfo.weaponType ~= ___MOD._WeaponType.KNUCKLE and weaponInfo.weaponType ~= ___MOD._WeaponType.GUN then
        checkPirate = false
      end
    end
    if not checkPirate and (ctx.skillID == ___MOD._SkillBook.Flash_Fist_500_5001001 or ctx.skillData.weapon ~= nil and not ___MOD._PlayerAttackLogic:checkWeapon(ctx.skillData.weapon, weaponInfo.itemID)) then
      pa:displayAttackMessage("장착한 무기로는 사용할 수 없는 스킬입니다.")
      pa.enableNextAttackTime = currentTime + 0.1
      return false, 0
    end
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion) then
    pa:displayAttackMessage("알 수 없는 오류가 발생하여 공격에 실패했습니다.")
    pa.enableNextAttackTime = currentTime + 0.1
    return false, 0
  end
  local bulletItemID, bulletCount, bulletConsume, slot = 0, 0, 0, 0
  if attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.ShadowPartner) ~= 0 then
    bulletCount = bulletCount * 2
  end
  if ctx.skillLevelData ~= nil and 0 < ctx.skillLevelData.bulletConsume or ctx.skillID == ___MOD._SkillBook.Arrow_Rain_1311_13111000 or ctx.skillID == ___MOD._SkillBook.Arrow_Rain_311_3111004 or ctx.skillID == ___MOD._SkillBook.Arrow_Eruption_321_3211004 or ctx.skillID == ___MOD._SkillBook.Flamethrower_521_5211004 or ctx.skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 then
    bulletConsume = ctx.skillLevelData.bulletConsume ~= 0 and ctx.skillLevelData.bulletConsume or 1
    local inventory = attacker.CInventoryComponent
    bulletItemID, bulletCount, slot = inventory:findFirstThrowing(bulletCount)
  end
  local result = ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(attacker, ctx.skillID, ctx.skillLevelData, bulletItemID, bulletCount, bulletConsume)
  if result ~= 0 then
    pa.enableNextAttackTime = currentTime + 0.1
    return false, slot
  end
  return true, slot
end

function PlayerAttackLogic_Melee.isDelayRangeAttackSkill(self, skillID)
  if skillID == ___MOD._SkillBook.Slash_Blast_100_1001005 or skillID == ___MOD._SkillBook.Slash_Blast_1100_11001003 or skillID == ___MOD._SkillBook.Slash_Blast_1100_11001003 or ___MOD._SkillLogic:isComboFinishAttack(skillID) or skillID == ___MOD._SkillBook.Charged_Blow_121_1211002 or skillID == ___MOD._SkillBook.Heavens_Hammer_122_1221011 then
    return true
  end
  return false
end

function PlayerAttackLogic_Melee.isNotPlayAfterimageSkill(self, skillID)
  if skillID == ___MOD._SkillBook.Thunder_Bolt_220_2201005 or skillID == ___MOD._SkillBook.Final_Blow_2112_21120005 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000016 then
    return true
  end
end

function PlayerAttackLogic_Melee.isNotRecalcRectByAfterimage(self, skillID)
  if skillID == ___MOD._SkillBook.Steal_420_4201004 or skillID == ___MOD._SkillBook.Invisible_Shot_520_5201001 or ___MOD._SkillLogic:isComboFinishAttack(skillID) or skillID == ___MOD._SkillBook.Charged_Blow_121_1211002 or skillID == ___MOD._SkillBook.Arrow_Rain_1311_13111000 or skillID == ___MOD._SkillBook.Arrow_Rain_311_3111004 or skillID == ___MOD._SkillBook.Arrow_Eruption_321_3211004 then
    return true
  end
end

function PlayerAttackLogic_Melee.onAttack(self, attacker, ctx, hitDelayInfo, totalDelay, finalAttackSkillID, bulletSlot, chargePer, isFinishAttack, lastAttackMobs, forceTarget, actionLockDelay)
  if not ___MOD._AntiRepeat:tryRepeat(___MOD._AntiRepeatType.Attack) then
    return -1
  end
  local isFaceLeft = attacker.ExtendPlayerControllerComponent.LookDirectionX == -1
  local playerPos = attacker.TransformComponent:PositionAsFastVector3():Clone():ToVector2()
  local assassinateState
  local isAssassinateFollowUp = isFinishAttack == true
  if ctx.skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
    assassinateState = ___MOD._PlayerSkillLogic:getAssassinateState(attacker)
    if isAssassinateFollowUp and assassinateState ~= nil and assassinateState.followUpTargetPos ~= nil then
      playerPos = assassinateState.followUpTargetPos
    end
  end
  local box = ctx.box
  local isStab = ___MOD.string.find(ctx.motion, "stab") ~= nil
  if isStab then
    box.Size.y = box.Size.y + 0.1
  end
  local position = box.Position
  local targets = 1
  if ctx.skillID > 0 then
    targets = ___MOD.math.max(1, ctx.skillLevelData.mobCount)
  else
    targets = ___MOD._AranLogic:getDefaultAttackMobCount(attacker, targets)
  end
  if isAssassinateFollowUp then
    targets = 10
    box.Position = playerPos
    position = box.Position
  end
  if ctx.skillID == ___MOD._SkillBook.Band_of_Thieves_421_4211004 then
    targets = 1
  end
  local mobs
  if ___MOD.isvalid(forceTarget) and forceTarget.CurrentMap == attacker.CurrentMap and forceTarget.MobComponent ~= nil and not forceTarget.MobComponent:isDead() then
    mobs = {forceTarget}
  else
    mobs = ___MOD._PlayerAttackLogic:findValidMobs(attacker, position, box.Size, 0, targets, ___MOD._SkillLogic:isHeal(ctx.skillID))
  end
  if ctx.skillID == ___MOD._SkillBook.Assassinate_422_4221001 and not isAssassinateFollowUp and 1 < #mobs then
    local maxCount = ___MOD.math.max(1, ctx.skillLevelData.mobCount or 1)

    local function getDistance(e)
      if ___MOD.isvalid(e) and e.TriggerComponent ~= nil then
        local pt = ___MOD._PlayerAttackLogic_Shoot:intersectBox(___MOD._PlayerAttackLogic_Shoot:triggerToBox(e.TriggerComponent), box)
        if pt == nil then
          return ___MOD.math.huge
        end
        return playerPos:Distance(pt)
      end
      return playerPos:Distance(e.TransformComponent:PositionAsFastVector3():ToVector2())
    end

    ___MOD.table.sort(mobs, function(a, b)
      return getDistance(a) < getDistance(b)
    end)
    while maxCount < #mobs do
      ___MOD.table.remove(mobs)
    end
  end
  if ctx.skillID == ___MOD._SkillBook.Assassinate_422_4221001 and not isAssassinateFollowUp then
    local limitedMobs = {}
    local maxCount = ___MOD.math.max(1, ctx.skillLevelData.mobCount or 1)
    for mi = 1, ___MOD.math.min(maxCount, #mobs) do
      limitedMobs[#limitedMobs + 1] = mobs[mi]
    end
    mobs = limitedMobs
  end
  if ctx.skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
    assassinateState.lastHitHasTarget = 0 < #mobs
  end
  if ctx.skillID == ___MOD._SkillBook.Assassinate_422_4221001 and isAssassinateFollowUp then
    local firstMob = lastAttackMobs ~= nil and lastAttackMobs[1] or nil
    local matchedMob
    if firstMob ~= nil then
      for mi = 1, #mobs do
        if mobs[mi] == firstMob then
          matchedMob = firstMob
          break
        end
      end
    end
    if matchedMob ~= nil then
      mobs = {matchedMob}
    else
      mobs = {}
    end
  end
  if ctx.skillID == ___MOD._SkillBook.Assassinate_422_4221001 and not isAssassinateFollowUp and 0 < #mobs then
    local followUpTargetPos = ___MOD._PlayerSkillLogic:getAssassinateFollowUpTargetPos(attacker)
    if followUpTargetPos ~= nil then
      assassinateState.followUpTargetPos = followUpTargetPos
      local followUpBoxPos = followUpTargetPos + (ctx.box.Position - playerPos)
      local followUpBox = ___MOD.BoxShape(followUpBoxPos, box.Size, box.Angle)
      ___MOD._PlayerSkillLogic:scheduleAssassinateFinishAttack(attacker, ctx.skillID, ctx.skillLevel, mobs)
    end
  end
  if #mobs <= 0 then
    if isFinishAttack == true then
      return -2
    end
    if ctx.skillID == 0 then
      local reactor = ___MOD._PlayerAttackLogic:findValidHitReactor(attacker, position, box.Size, box.Angle)
      if reactor ~= nil then
        reactor:requestHitReactor(attacker, hitDelayInfo[1] / 1000)
        return -1
      end
    end
  end
  self:playFallingAnimationOnCast(attacker, ctx, mobs)
  if ctx.skillID == ___MOD._SkillBook.Assaulter_421_4211002 then
    if #mobs <= 0 then
      return -2
    end
    if not ___MOD._PlayerSkillLogic_Teleport:tryRegisterTeleport(attacker, ctx.skillID, ctx.skillLevel, nil, nil, false, 250) then
      return -2
    end
  end
  if ___MOD.Environment:IsMakerPlay() then
    ___MOD._ColliderUtils:drawBox(attacker.CurrentMap, position, box.Size)
  end
  local healTargetCount = 0
  if ___MOD._SkillLogic:isHeal(ctx.skillID) then
    healTargetCount = healTargetCount + #mobs
    local partyTargets = self:findPartyMembersByHeal(attacker, ctx.skillData, ctx.skillLevelData)
    healTargetCount = healTargetCount + #partyTargets
  end

  local function TakeNearestMobs(list, px, py, maxCount)
    if list == nil or #list == 0 or maxCount <= 0 then
      return {}
    end

    local function getDistSq(e)
      local p = e.TransformComponent:PositionAsFastVector3():ToVector2()
      local dx = p.x - px
      local dy = p.y - py
      return dx * dx + dy * dy
    end

    if 1 < #list then
      ___MOD.table.sort(list, function(a, b)
        return getDistSq(a) < getDistSq(b)
      end)
    end
    local out = {}
    local n = ___MOD.math.min(maxCount, #list)
    for i = 1, n do
      out[#out + 1] = list[i]
    end
    return out
  end

  local function TakeNearestExceptFirst(list, px, py, maxCount)
    if list == nil or #list == 0 or maxCount <= 0 then
      return {}
    end
    local tmp = {}
    for i = 1, #list do
      tmp[#tmp + 1] = list[i]
    end
    return TakeNearestMobs(tmp, px, py, maxCount)
  end

  local left = attacker.ExtendPlayerControllerComponent.LookDirectionX == -1
  if self:isDelayRangeAttackSkill(ctx.skillID) then
    if 0 < #mobs then
      local firstMob = mobs[1]
      if firstMob ~= nil then
        local levelData = ctx.skillLevelData
        if levelData ~= nil then
          local mobPos = firstMob.TransformComponent:PositionAsFastVector3():Clone():ToVector2()
          local range = levelData.range
          local info = ctx.afterimageInfo
          local lt, rb
          if info ~= nil then
            lt, rb = ___MOD._WzUtils:getVector(info.lt, nil), ___MOD._WzUtils:getVector(info.rb, nil)
          elseif levelData.lt ~= nil and levelData.rb ~= nil then
            lt = levelData.lt * 100
            rb = levelData.rb * 100
          end
          if lt == nil or rb == nil then
            return -1
          end
          if range ~= 0 then
            lt.x = ___MOD.math.min(lt.x, -range)
          end
          local boxShape = ___MOD._PlayerAttackLogic_Shoot:makeBoxShapeFromLtRb(attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2(), lt, rb, left)
          local mobss = ___MOD._PlayerAttackLogic:findValidMobs(attacker, boxShape.Position, boxShape.Size, 0, targets, false)
          if 0 < #mobss then
            local maxCount = ___MOD.math.min(targets, #mobss)
            mobs = TakeNearestMobs(mobss, mobPos.x, mobPos.y, maxCount)
          end
        end
      end
    end
  elseif ctx.skillID == ___MOD._SkillBook.Band_of_Thieves_421_4211004 and 0 < #mobs then
    local firstMob = mobs[1]
    if firstMob ~= nil then
      local levelData = ctx.skillLevelData
      if levelData ~= nil then
        local center, size = ___MOD._OffsetUtils:calcNormalizedBox(levelData.lt, levelData.rb, isFaceLeft)
        local b = ___MOD.BoxShape(center, size, 0)
        local pos = firstMob.TransformComponent:WorldPositionAsFastVector3():ToVector2()
        b.Position = b.Position + pos
        if ___MOD.Environment:IsMakerPlay() then
          ___MOD._ColliderUtils:drawBox(attacker.CurrentMap, pos, size)
        end
        local t = levelData.mobCount
        local m = ___MOD._PlayerAttackLogic:findValidMobs(attacker, firstMob.TransformComponent:WorldPositionAsFastVector3():ToVector2(), b.Size, 0, t, false)
        mobs = TakeNearestMobs(m, pos.x, pos.y, t)
      end
    end
  end
  local hitIndex = 0
  if ctx.skillID == ___MOD._SkillBook.Charged_Blow_121_1211002 then
    hitIndex = attacker.AfterImageComponent.chargeType - 1
  else
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
    hitIndex = ___MOD._GlobalRand32:randomIntegerRange(0, hitCount - 1)
  end
  local delays = {}
  local damages = {}
  local criticals = {}
  local damageTargetCount = ___MOD.math.max(1, #mobs)
  if ___MOD._SkillLogic:isHeal(ctx.skillID) then
    damageTargetCount = ___MOD.math.max(1, healTargetCount)
  end
  local i = 1
  local playerInputX = attacker.PlayerControllerComponent.LookDirectionX
  local useHitIdxList = {}
  local attackerPosSnapshot = attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
  for _, m in ___MOD.ipairs(mobs) do
    local mob = m
    local damageDelays = {}
    local damages_, criticals_, highestDamage = ___MOD._PlayerAttackLogic:calcDamageClient(attacker, mob, ctx.skillID, ctx.skillLevel, ctx.attackCount, damageDelays, ctx.motion, finalAttackSkillID, damageTargetCount, bulletSlot, i, chargePer, isFinishAttack == true)
    local hasHitDamage = false
    for di = 1, #damages_ do
      if 0 < (damages_[di] or 0) then
        hasHitDamage = true
        break
      end
    end
    local playHitEffectWithoutDamage = ___MOD._PlayerAttackLogic:isComboTempestStatusOnlyTarget(ctx.skillID, mob)
    damages[#damages + 1] = damages_
    criticals[#criticals + 1] = criticals_
    for index, d in ___MOD.ipairs(hitDelayInfo) do
      local delay = d
      if isAssassinateFollowUp then
        delay = delay + 100
      end
      local rangeDelay = self:getRangeDelay(ctx.skillID) * 1000
      if 0 < rangeDelay then
        delay = delay + (i - 1) * rangeDelay
      end
      if ctx.skillID == ___MOD._SkillBook.Invisible_Shot_520_5201001 or ctx.skillID == ___MOD._SkillBook.Charged_Blow_121_1211002 or ctx.skillID == ___MOD._SkillBook.Energy_Blast_511_5111002 or ctx.skillID == ___MOD._SkillBook.Energy_Blast_1510_15101005 then
        delay = delay + (_ - 1) * 100
      elseif ctx.skillID == ___MOD._SkillBook.Explosion_211_2111002 or ctx.skillID == ___MOD._SkillBook.Shining_Ray_231_2311004 then
        delay = delay + (_ - 1) * 50
      elseif ctx.skillID == ___MOD._SkillBook.Flamethrower_521_5211004 or ctx.skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 then
        delay = delay + (_ - 1) * 50
      end
      if ctx.skillID == ___MOD._SkillBook.Band_of_Thieves_421_4211004 and 1 < _ then
        delay = delay + 250
      end
      local finalDelay = delay
      damageDelays[#damageDelays + 1] = finalDelay
      ___MOD._TimerService:SetTimerOnce(function()
        if ctx.skillID == ___MOD._SkillBook.Band_of_Thieves_421_4211004 then
          if _ == 1 then
            hitIndex = 0
            self._T.bofAvail = {
              1,
              2,
              3,
              4,
              5
            }
          else
            local avail = self._T.bofAvail
            if avail == nil or #avail == 0 then
              avail = {
                1,
                2,
                3,
                4,
                5
              }
              self._T.bofAvail = avail
            end
            local pick = ___MOD._GlobalRand32:randomIntegerRange(1, #avail)
            local rand = avail[pick]
            ___MOD.table.remove(avail, pick)
            hitIndex = rand
          end
        end
        local canPlayDemolitionSound = ctx.skillID ~= ___MOD._SkillBook.Demolition_512_5121004 or index == 1
        if canPlayDemolitionSound then
          if finalAttackSkillID ~= 0 then
            local skillHitPath = ___MOD.__RUIDManager:get(___MOD.string.format("Skill.img.%d.Hit", finalAttackSkillID))
            if not ___MOD._UtilLogic:IsNilorEmptyString(skillHitPath) then
              ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(skillHitPath, attacker, mob, 1)
            else
              self:playAttackSound(attacker, mob, ctx.skillID, mob.MobComponent.id)
            end
          else
            self:playAttackSound(attacker, mob, ctx.skillID, mob.MobComponent.id)
          end
        end
        if not hasHitDamage and not playHitEffectWithoutDamage then
          return
        end
        local mobFaceLeft = mob.MovementComponent:IsFaceLeft()
        local mobPos = mob.TransformComponent.Position:ToVector2()
        local hitOffset = ___MOD._PlayerAttackLogic:getHitOffset(mob, playerPos, mobPos, ctx.box, isFaceLeft, mobFaceLeft, false)
        local effectTarget = mob
        local hitData, blastHitRoot
        local chargeType = attacker.AfterImageComponent.chargeType
        if ctx.skillID == ___MOD._SkillBook.Blast_122_1221009 and ctx.hitData ~= nil then
          blastHitRoot = ctx.hitData[1]
        end
        if ctx.hitData ~= nil and ctx.skillID ~= 0 and not ___MOD._PlayerSkillLogic:isDisorder(ctx.skillID) and ctx.skillID ~= ___MOD._SkillBook.Sacrifice_131_1311005 then
          hitData = ctx.hitData.pos and ctx.hitData or ctx.hitData[hitIndex + 1]
        end
        if blastHitRoot ~= nil then
          hitData = blastHitRoot[chargeType + 1]
        end
        if hitData ~= nil then
          if hitData.pos == 3 or ctx.skillID == ___MOD._SkillBook.Assaulter_421_4211002 then
            hitOffset = ___MOD.FastVector3.zero:Clone()
            hitOffset.y = mob.MobComponent.spriteSize.y / 2
          elseif hitData.pos == 2 then
            effectTarget = mob.MobComponent.head
            hitOffset = ___MOD.FastVector3.zero:Clone()
          end
        end
        if ctx.skillID == 0 or ctx.skillID == ___MOD._SkillBook.Sacrifice_131_1311005 or ctx.skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
          local hitAni = mob.HitAnimationComponent
          local keyBase = ctx.weaponInfo.weaponAttackType == ___MOD._WeaponAttackType.SHOOT and "mace" or "sword"
          local faceDir = ctx.isFaceLeft and -1 or 1
          local key = keyBase .. (faceDir == -1 and 1 or 2)
          local hitPos = ___MOD._PlayerAttackLogic:getHitPoint(mob, box)
          hitAni:playHitAnimation(key, attacker, mob, hitPos)
        elseif hitData or playHitEffectWithoutDamage then
          local hitPoint
          if box then
            hitPoint = ___MOD._PlayerAttackLogic:getHitPoint(mob, box)
          end
          if hitPoint then
            hitOffset = ___MOD.FastVector3(hitPoint.x - mobPos.x, hitPoint.y - mobPos.y, 0)
          end
          if ctx.skillID == ___MOD._SkillBook.Dragon_Strike_512_5121001 then
            effectTarget = mob.CurrentMap
            local hitX = hitPoint and hitPoint.x or mobPos.x
            hitOffset = ___MOD.FastVector3(hitX, mobPos.y, 0)
          end
          if ctx.skillID ~= ___MOD._SkillBook.Dragon_Strike_512_5121001 and (not hitData or hitData.pos ~= 2 and hitData.pos ~= 3) then
            effectTarget = mob.CurrentMap
            hitOffset = hitOffset + ___MOD.FastVector3(mobPos.x, mobPos.y, 0)
          end
          local isMagicClaw = ctx.skillID == ___MOD._SkillBook.Magic_Claw_200_2001005 or ctx.skillID == ___MOD._SkillBook.Magic_Claw_1200_12001003 or ctx.skillID == ___MOD._SkillBook.Soul_Driver_1111_11111006 or ctx.skillID == ___MOD._SkillBook.Vampire_1410_14101006
          local canPlayMagicClawHit = not isMagicClaw or index == 1
          local canPlayDemolitionHit = ctx.skillID ~= ___MOD._SkillBook.Demolition_512_5121004 or index == 1
          if (ctx.skillID ~= ___MOD._SkillBook.Double_Stab_400_4001334 or ___MOD._PlayerAttackLogic:isFirstAttack(index)) and canPlayMagicClawHit and canPlayDemolitionHit then
            if ctx.skillID == ___MOD._SkillBook.Barrage_512_5121007 or ctx.skillID == ___MOD._SkillBook.Barrage_1511_15111004 then
              local barrageHit0 = ctx.skillData.hit0
              local barrageHit1 = ctx.skillData.hit1
              if index == 1 then
                local barrageHitPath = ___MOD.__RUIDManager:get(___MOD.string.format("Skill.img.%d.Hit", ctx.skillID))
                if not ___MOD._UtilLogic:IsNilorEmptyString(barrageHitPath) and self:shouldPlayAttackSound(attacker) then
                  ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(barrageHitPath, attacker, mob, 1)
                end
                local playHitIndex = hitIndex
                local playHitData = ctx.hitData
                local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, playHitIndex, effectTarget, 1.0, hitOffset, playHitData, false, isFaceLeft, nil)
                ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
                if barrageHit0 then
                  local hitEffects0 = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, 0, effectTarget, 1.0, hitOffset, {barrageHit0}, false, isFaceLeft, nil)
                  ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects0, attacker)
                end
                if barrageHit1 then
                  local hitEffects1 = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, 0, effectTarget, 1.0, hitOffset, {barrageHit1}, false, isFaceLeft, nil)
                  ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects1, attacker)
                end
              end
            else
              local playHitIndex = playHitEffectWithoutDamage and 0 or hitIndex
              local playHitData = ctx.hitData
              if playHitEffectWithoutDamage and not playHitData and ctx.skillData and ctx.skillData.hit0 then
                playHitData = {
                  ctx.skillData.hit0
                }
              end
              if blastHitRoot then
                playHitIndex = chargeType
                playHitData = blastHitRoot
              end
              local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, playHitIndex, effectTarget, 1.0, hitOffset, playHitData, false, isFaceLeft, nil)
              ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
            end
          end
        end
      end, ctx.skillID == ___MOD._SkillBook.Dragon_Strike_512_5121001 and 0 or delay / 1000)
    end
    delays[#delays + 1] = damageDelays
    if ctx.skillID ~= ___MOD._SkillBook.Heavens_Hammer_122_1221011 and not playHitEffectWithoutDamage then
      ___MOD._PlayerAttackLogic:displaySkillDamageByAttackerClient(attacker, mob, ctx.skillID, damages_, criticals_, damageDelays)
    end
    local totalDamage, deadlyAttack = ___MOD._PlayerAttackLogic:onAttackClient(attacker, mob, damages_)
    ___MOD._TimerService:SetTimerOnce(function()
      if ctx.skillID == ___MOD._SkillBook.Backspin_Blow_510_5101002 or ctx.skillID == ___MOD._SkillBook.Corkscrew_Blow_510_5101004 or ctx.skillID == ___MOD._SkillBook.Corkscrew_Blow_1510_15101003 then
        attacker.PlayerHitComponent.hitTime = ___MOD._UtilLogic.ServerElapsedSeconds + 1
      elseif ___MOD._SkillLogic:isRushAttackSkill(ctx.skillID) then
        attacker.PlayerHitComponent.hitTime = ___MOD.math.max(attacker.PlayerHitComponent.hitTime, ___MOD._UtilLogic.ServerElapsedSeconds + 1)
      end
    end, ___MOD.math.max(0, damageDelays[1] / 1000 - 0.2))
    i = i + 1
  end
  if 0 < #mobs then
    ___MOD._TimerService:SetTimerOnce(function()
      self:onFirstAttackClient(attacker, ctx, mobs)
    end, delays[1][1] / 1000)
  end
  local sad = self:initSkillAttackData(ctx.skillID, ctx.skillLevel, attackerPosSnapshot, playerInputX, #mobs, ctx.attackCount, ctx.motion, ___MOD._SkillAttackType.Melee, mobs, damages, criticals, delays, hitDelayInfo[1], ctx.playRate, isFaceLeft, finalAttackSkillID, 0, 0, damageTargetCount, bulletSlot, nil, chargePer, isFinishAttack == true, nil)
  sad.clientActionLockDelay = actionLockDelay
  ___MOD._PlayerAttackLogic:applyPendingWindWalkAttackBoost(attacker, sad)
  ___MOD._PlayerAttackLogic:onPlayerAttack(attacker, sad:toTable())
  ___MOD._PlayerAttackLogic:trySparkChainAttack(attacker, ctx.skillID, mobs, delays[1] ~= nil and delays[1][1] or hitDelayInfo[1])
  ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(attacker)
  return 1
end

function PlayerAttackLogic_Melee.onFirstAttackClient(self, attacker, ctx, mobs)
  if ___MOD._SkillLogic:isTeleportAttackSkill(ctx.skillID) then
    if ctx.skillID == ___MOD._SkillBook.Backspin_Blow_510_5101002 and 0 < #mobs then
      attacker.PlayerActionComponent.enableNextTeleportTime = ___MOD._UtilLogic.ServerElapsedSeconds + 2.0
    end
    local range = 140
    if ctx.skillID == ___MOD._SkillBook.Corkscrew_Blow_510_5101004 or ctx.skillID == ___MOD._SkillBook.Corkscrew_Blow_1510_15101003 then
      local skillLevelData = ___MOD._SkillManager:getSkillLevelData(ctx.skillID, ctx.skillLevel)
      if skillLevelData ~= nil then
        range = 140
      end
    elseif ___MOD._SkillLogic:isRushAttackSkill(ctx.skillID) then
      local skillLevelData = ___MOD._SkillManager:getSkillLevelData(ctx.skillID, ctx.skillLevel)
      if skillLevelData then
        range = ___MOD.math.floor(___MOD.math.abs(skillLevelData.rb.x - skillLevelData.lt.x) * 65 + 0.5)
      end
    elseif ctx.skillID == ___MOD._SkillBook.Assaulter_421_4211002 then
      range = 250
    end
    ___MOD._PlayerSkillLogic_Teleport:tryRegisterTeleport(attacker, ctx.skillID, ctx.skillLevel, nil, nil, false, range)
  end
end

function PlayerAttackLogic_Melee.playAttackSound(self, attacker, target, skillID, targetMobID)
  if not self:shouldPlayAttackSound(attacker) then
    return
  end
  local skillHitPath = ___MOD.__RUIDManager:get(___MOD.string.format("Skill.img.%d.Hit", skillID))
  if not ___MOD._UtilLogic:IsNilorEmptyString(skillHitPath) and skillID ~= ___MOD._SkillBook.Barrage_512_5121007 and skillID ~= ___MOD._SkillBook.Barrage_1511_15111004 then
    ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(skillHitPath, attacker, target, 1)
  else
    local mobHitPath = ___MOD.__RUIDManager:get(___MOD.string.format("Mob.img.%07d.Damage", targetMobID))
    if not ___MOD._UtilLogic:IsNilorEmptyString(mobHitPath) then
      ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(mobHitPath, attacker, target, 1)
    end
  end
end

function PlayerAttackLogic_Melee.playComboTempestBackgroundEffect(self, attacker)
  if not ___MOD._ExtendedEffectService:shouldPlaySkillEffect(attacker) then
    return
  end
  local effect = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/BackGroundEffect")
  if not effect or not effect.SpriteGUIRendererComponent then
    return
  end
  local t = self._T
  t.comboTempestBackgroundSeq = (t.comboTempestBackgroundSeq or 0) + 1
  local seq = t.comboTempestBackgroundSeq
  local renderer = effect.SpriteGUIRendererComponent
  effect:SetEnable(true)
  renderer.Color.a = 0
  local fadeIn = ___MOD._TweenLogic:PlayTween(0, 0.4, 1, ___MOD.EaseType.Linear, function(a)
    if t.comboTempestBackgroundSeq ~= seq then
      return
    end
    if ___MOD.isvalid(effect) and effect.SpriteGUIRendererComponent then
      effect.SpriteGUIRendererComponent.Color.a = a
    end
  end)
  fadeIn.AutoDestroy = true
  fadeIn:SetOnEndCallback(function()
    if t.comboTempestBackgroundSeq ~= seq then
      return
    end
    if not ___MOD.isvalid(effect) or not effect.SpriteGUIRendererComponent then
      return
    end
    ___MOD._TimerService:SetTimerOnce(function()
      if t.comboTempestBackgroundSeq ~= seq then
        return
      end
      if not ___MOD.isvalid(effect) or not effect.SpriteGUIRendererComponent then
        return
      end
      effect.SpriteGUIRendererComponent.Color.a = 0.4
      local fadeOut = ___MOD._TweenLogic:PlayTween(0.4, 0, 1, ___MOD.EaseType.Linear, function(a)
        if t.comboTempestBackgroundSeq ~= seq then
          return
        end
        if ___MOD.isvalid(effect) and effect.SpriteGUIRendererComponent then
          effect.SpriteGUIRendererComponent.Color.a = a
        end
      end)
      fadeOut.AutoDestroy = true
      fadeOut:SetOnEndCallback(function()
        if t.comboTempestBackgroundSeq ~= seq then
          return
        end
        if ___MOD.isvalid(effect) and effect.SpriteGUIRendererComponent then
          effect.SpriteGUIRendererComponent.Color.a = 0
          effect:SetEnable(false)
        end
      end)
    end, 5)
  end)
end

function PlayerAttackLogic_Melee.playEffect(self, attacker, ctx, totalDelay, hitDelayInfo, isFinalAttack)
  local taming = attacker.TamingMobComponent
  if taming and taming.onTaming and not ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion) then
    ___MOD._PlayerStateLogic:changeState(attacker, "SIT")
    taming:playActionMotionClient(attacker, ctx.motion)
  else
    attacker.PlayerActionComponent:playOnceClient(ctx.motion, ctx.playRate, attacker, true, false)
  end
  if ctx.skillID > 0 and not isFinalAttack then
    local effect
    if ctx.skillID ~= ___MOD._SkillBook.Spear_Crusher_131_1311001 and ctx.skillID ~= ___MOD._SkillBook.Pole_Arm_Crusher_131_1311002 and ctx.skillID ~= ___MOD._SkillBook.Dragon_Fury_Spear_131_1311003 and ctx.skillID ~= ___MOD._SkillBook.Dragon_Fury_Pole_Arm_131_1311004 then
      effect = ctx.effectData
    end
    if ctx.skillID == ___MOD._SkillBook.Blast_122_1221009 then
      ctx.effectIndex = attacker.AfterImageComponent.chargeType
    elseif ctx.skillID == ___MOD._SkillBook.Charged_Blow_121_1211002 then
      ctx.effectIndex = attacker.AfterImageComponent.chargeType
    end
    ___MOD._PlayerAttackLogic:playSkillEffect(attacker, ctx.skillID, ctx.effectIndex, effect, ctx.playRate)
    for i = 0, 10 do
      local e = ctx.skillData["effect" .. i]
      if e ~= nil then
        ___MOD._PlayerAttackLogic:playSkillEffect(attacker, ctx.skillID, 0, e, ctx.playRate)
      else
        break
      end
    end
    local skillID = ctx.skillID
    if skillID == ___MOD._SkillBook.hidden_Full_Swing__Double_Swing_2111_21110007 or skillID == ___MOD._SkillBook.hidden_Over_Swing__Double_Swing_2112_21120009 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000014 then
      skillID = ___MOD._SkillBook.Double_Swing_2100_21000002
    elseif skillID == ___MOD._SkillBook.hidden_Full_Swing__Triple_Swing_2111_21110008 or skillID == ___MOD._SkillBook.hidden_Over_Swing__Triple_Swing_2112_21120010 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000015 then
      skillID = ___MOD._SkillBook.Triple_Swing_2110_21100001
    elseif skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000016 then
      skillID = ___MOD._SkillBook.Final_Blow_2112_21120005
    end
    ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%d.Use", skillID), attacker, 1)
  end
  if ctx.skillID == ___MOD._SkillBook.Boomerang_Step_422_4221007 then
    ___MOD._ThiefLogic:playerHideAndShow(attacker, 0.6)
  elseif ctx.skillID == ___MOD._SkillBook.Assaulter_421_4211002 then
    local remain = "BasicEff.img/Assaulter/remain"
    local effect = "BasicEff.img/Assaulter/effect"
    local effect0 = "BasicEff.img/Assaulter/effect0"
    local isFaceLeft = attacker.PlayerControllerComponent.LookDirectionX == -1
    local remainEffect = ___MOD._ExtendedEffectService:playEffectAnimationLocal(remain, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, attacker.TransformComponent.Position, false, 1.0, isFaceLeft, attacker.CurrentMap, nil, false, 0)
    ___MOD._ExtendedEffectService:playEffectAnimationRemote(remain, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, attacker.TransformComponent.Position, false, 1.0, isFaceLeft, attacker.CurrentMap, true, attacker, nil, false, 0)
    ___MOD._ExtendedEffectService:playEffectAnimationLocal(effect, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, ___MOD.FastVector3.zero:Clone(), false, 1.0, isFaceLeft, attacker, nil, false, 0)
    ___MOD._ExtendedEffectService:playEffectAnimationRemote(effect, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, ___MOD.FastVector3.zero:Clone(), false, 1.0, isFaceLeft, attacker, true, attacker, nil, false, 0)
    ___MOD._ExtendedEffectService:playEffectAnimationLocal(effect0, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, ___MOD.FastVector3.zero:Clone(), false, 1.0, isFaceLeft, attacker, nil, false, 0)
    ___MOD._ExtendedEffectService:playEffectAnimationRemote(effect0, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, ___MOD.FastVector3.zero:Clone(), false, 1.0, isFaceLeft, attacker, true, attacker, nil, false, 0)
  end
  if ___MOD._SkillLogic:isComboFinishAttack(ctx.skillID) then
    local counter = attacker.ComboComponent
    if counter ~= nil then
      local combo = counter.comboCount
      ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, ctx.skillID, 0, attacker, 1.0, ___MOD.FastVector3.zero:Clone(), ctx.skillData.finish[___MOD.tostring(combo)], false, false, nil)
    end
  end
  if ___MOD._SkillLogic:isTrembleAttackSkill(ctx.skillID) then
    ___MOD._ExtendedEffectService:effectTrembleClient(0.25, true, hitDelayInfo[1] / 1000, 0, false)
  end
end

function PlayerAttackLogic_Melee.playFallingAnimationOnCast(self, attacker, ctx, mobs)
  if not mobs or #mobs <= 0 then
    return
  end
  if not ctx.skillData or not ctx.skillData.special then
    return
  end
  if ctx.skillID == ___MOD._SkillBook.Arrow_Rain_1311_13111000 or ctx.skillID == ___MOD._SkillBook.Arrow_Rain_311_3111004 or ctx.skillID == ___MOD._SkillBook.Combo_Tempest_2112_21120006 then
    local pos = attacker.TransformComponent:WorldPositionAsFastVector3()
    if ctx.skillID == ___MOD._SkillBook.Combo_Tempest_2112_21120006 then
      self:playComboTempestBackgroundEffect(attacker)
    end
    ___MOD._ExtendedEffectService:makeFallingAnimation(attacker.CurrentMap, ctx.skillData.special, pos, attacker.PlayerControllerComponent.LookDirectionX == -1, ctx.skillID, ctx.skillLevel, attacker)
  elseif ctx.skillID == ___MOD._SkillBook.Arrow_Eruption_321_3211004 then
    for _, mob in ___MOD.pairs(mobs) do
      if ___MOD.isvalid(mob) then
        local pos = mob.TransformComponent:WorldPositionAsFastVector3()
        ___MOD._ExtendedEffectService:makeFallingAnimation(attacker.CurrentMap, ctx.skillData.special, pos, attacker.PlayerControllerComponent.LookDirectionX == -1, ctx.skillID, ctx.skillLevel, attacker)
      end
    end
  end
end

function PlayerAttackLogic_Melee.resolveAfterimageData(self, attacker, ctx)
  local aiType = attacker.AfterImageComponent:getAfterimagePathByWeapon()
  local skillAfterimage = ctx.skillData.afterimage
  if skillAfterimage ~= nil then
    local ai = skillAfterimage[aiType]
    if ai ~= nil then
      if ai.lt ~= nil or ai.rb ~= nil then
        return ai, ai.StartFrameIndex or 1
      end
      local pick = ai[ctx.motion]
      if pick ~= nil then
        if pick.lt ~= nil or pick.rb ~= nil then
          return pick, pick.StartFrameIndex or 1
        end
        local directFrame = pick["0"] or pick[0] or pick["1"] or pick[1]
        if ___MOD.type(directFrame) == "table" and (directFrame.lt ~= nil or directFrame.rb ~= nil) then
          return directFrame, directFrame.StartFrameIndex or pick.StartFrameIndex or 1
        end
        return pick, pick.StartFrameIndex
      end
      if ctx.skillID == 1221009 then
        local fallbackPick, fallbackKey
        for key, value in ___MOD.pairs(ai) do
          if ___MOD.type(value) == "table" then
            if fallbackPick ~= nil then
              fallbackPick = nil
              fallbackKey = nil
              break
            end
            fallbackPick = value
            fallbackKey = key
          end
        end
        if fallbackPick ~= nil then
          if fallbackPick.lt ~= nil or fallbackPick.rb ~= nil then
            return fallbackPick, fallbackPick.StartFrameIndex or 1
          end
          local directFrame = fallbackPick["0"] or fallbackPick[0] or fallbackPick["1"] or fallbackPick[1]
          if ___MOD.type(directFrame) == "table" and (directFrame.lt ~= nil or directFrame.rb ~= nil) then
            return directFrame, directFrame.StartFrameIndex or fallbackPick.StartFrameIndex or 1
          end
          return fallbackPick, fallbackPick.StartFrameIndex or 1
        end
      end
      if ctx.skillID == 1221009 then
        for _, value in ___MOD.pairs(ai) do
          if ___MOD.type(value) == "table" then
            local frame = value["0"] or value[0] or value["1"] or value[1]
            if frame == nil then
              for frameKey, frameValue in ___MOD.pairs(value) do
                if ___MOD.tostring(frameKey) == "0" or ___MOD.tostring(frameKey) == "1" then
                  frame = frameValue
                  break
                end
              end
            end
            if frame == nil then
              for _, frameValue in ___MOD.pairs(value) do
                if ___MOD.type(frameValue) == "table" and (frameValue.lt ~= nil or frameValue.rb ~= nil) then
                  frame = frameValue
                  break
                end
              end
            end
            if ___MOD.type(frame) == "table" and (frame.lt ~= nil or frame.rb ~= nil) then
              local parsed = {
                lt = frame.lt,
                rb = frame.rb,
                StartFrameIndex = 1
              }
              return parsed, 1
            end
          end
        end
      end
    end
  end
  if ctx.playDefaultAttackAfterimage then
    local startIndex, sprites, motion = attacker.AfterImageComponent:getAfterImageData2(ctx.motion)
    return motion, startIndex
  end
  return nil, 1
end

function PlayerAttackLogic_Melee.resolveHitEffectData(self, attacker, skillData)
  local charLevel = skillData.charLevel
  if not charLevel then
    local hit = skillData.hit
    if not hit and skillData.hit0 then
      hit = {
        skillData.hit0
      }
    end
    return hit, skillData.effect
  end
  local level = attacker.Player.Level
  local data, bestLevel
  for k, v in ___MOD.pairs(charLevel) do
    local keyLevel = ___MOD.tonumber(k)
    if keyLevel ~= nil and level >= keyLevel and v ~= nil and (bestLevel == nil or bestLevel < keyLevel) then
      bestLevel = keyLevel
      data = v
    end
  end
  if not data then
    local hit = skillData.hit
    if not hit and skillData.hit0 then
      hit = {
        skillData.hit0
      }
    end
    return hit, skillData.effect
  end
  local hit = data.hit
  if not hit and data.hit0 then
    hit = {
      data.hit0
    }
  end
  return hit, data.effect
end

function PlayerAttackLogic_Melee.shouldPlayAttackSound(self, attacker)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not localPlayer or not localPlayer.UISystemOptionComponent then
    return true
  end
  return attacker == localPlayer or localPlayer.UISystemOptionComponent.enableOtherSkillHitSound
end

function PlayerAttackLogic_Melee.tryMeleeAttack(self, attacker, skillID, skillLevel, pa, weaponInfo, isFinalAttack, chargePer, forceMotion, isFinishAttack, lastAttackMobs, forceTarget)
  if pa.isClimbing or pa.sitting then
    return false
  end
  if attacker.Player:isDead() then
    return false
  end
  if not attacker.ExtendPlayerControllerComponent.inSwimMap and ___MOD._SkillLogic:isCanNotJumpAttack(skillID) and not attacker.RigidbodyComponent:IsOnGround() then
    return false
  end
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  local ctx = self:initSkillCtx(attacker, skillID, skillLevel, weaponInfo, isFinalAttack, false, false)
  if skillID == ___MOD._SkillBook.Shockwave_511_5111006 or skillID == ___MOD._SkillBook.Shockwave_1511_15111003 then
    local morphValue = attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Morph)
    if morphValue ~= 1000 and morphValue ~= 1100 and morphValue ~= 1001 and morphValue ~= 1101 then
      return false
    end
  elseif skillID == ___MOD._SkillBook.Demolition_512_5121004 then
    local morphValue = attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Morph)
    if morphValue ~= 1000 and morphValue ~= 1100 and morphValue ~= 1001 and morphValue ~= 1101 then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에만 사용할 수 있는 스킬입니다.")
      pa.enableNextAttackTime = currentTime + 0.3
      return false
    end
  elseif skillID == ___MOD._SkillBook.Snatch_512_5121005 then
    local morphValue = attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Morph)
    if morphValue ~= 1001 and morphValue ~= 1101 then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에만 사용할 수 있는 스킬입니다.")
      pa.enableNextAttackTime = currentTime + 0.3
      return false
    end
  elseif (skillID == ___MOD._SkillBook.Energy_Blast_511_5111002 or skillID == ___MOD._SkillBook.Energy_Blast_1510_15101005 or skillID == ___MOD._SkillBook.Energy_Drain_511_5111004 or skillID == ___MOD._SkillBook.Energy_Drain_1511_15111001) and attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.EnergyCharge) == 0 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "에너지가 완충된 상태에서만 사용할 수 있는 스킬입니다.")
    pa.enableNextAttackTime = currentTime + 0.3
    return false
  end
  local check, slot = self:isCanAttack(attacker, weaponInfo, ctx)
  if not check then
    return false
  end
  if skillID == ___MOD._SkillBook.Demolition_512_5121004 or skillID == ___MOD._SkillBook.Barrage_512_5121007 or skillID == ___MOD._SkillBook.Barrage_1511_15111004 then
    local box = ctx.box
    local targets = 1
    if 0 < ctx.skillID and ctx.skillLevelData ~= nil then
      targets = ___MOD.math.max(1, ctx.skillLevelData.mobCount)
    end
    local mobs = ___MOD._PlayerAttackLogic:findValidMobs(attacker, box.Position, box.Size, 0, targets, false)
    if mobs == nil or #mobs <= 0 then
      pa.enableNextAttackTime = currentTime + 0.1
      return false
    end
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(forceMotion) then
    ctx.motion = forceMotion
  end
  if isFinishAttack == true and skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
    ctx.motion = "assassinationS"
    pa:playOnceClient(ctx.motion, ctx.playRate, attacker, true, false)
    pa:playOnce(ctx.motion, ctx.playRate, attacker)
  end
  if skillID == ___MOD._SkillBook.hidden_Full_Swing__Double_Swing_2111_21110007 then
    ctx.motion = "fullSwingDouble"
    ctx.afterimageInfo = self:resolveAfterimageData(attacker, ctx)
  elseif skillID == ___MOD._SkillBook.hidden_Full_Swing__Triple_Swing_2111_21110008 then
    ctx.motion = "fullSwingTriple"
    ctx.afterimageInfo = self:resolveAfterimageData(attacker, ctx)
  elseif skillID == ___MOD._SkillBook.hidden_Over_Swing__Double_Swing_2112_21120009 then
    ctx.motion = "overSwingDouble"
    ctx.afterimageInfo = self:resolveAfterimageData(attacker, ctx)
  elseif skillID == ___MOD._SkillBook.hidden_Over_Swing__Triple_Swing_2112_21120010 then
    ctx.motion = "overSwingTriple"
    ctx.afterimageInfo = self:resolveAfterimageData(attacker, ctx)
  end
  local finalAttackSkillID = 0
  if isFinalAttack or isFinishAttack then
    pa:clearActionTimer()
  end
  if isFinalAttack then
    local finalAttackInfo = pa.finalAttackInfo
    if finalAttackInfo == nil then
      return false
    end
    finalAttackSkillID = finalAttackInfo.finalAttackSkillID
    local finalAttackSkill = ___MOD._SkillManager:getSkill(finalAttackInfo.finalAttackSkillID)
    if finalAttackInfo ~= nil then
      ctx.hitData = finalAttackSkill.hit
    end
  end
  local normalMotion, sprites, startFrameIndex
  if ctx.playDefaultAttackAfterimage then
    startFrameIndex, sprites = attacker.AfterImageComponent:getAfterImageData2(ctx.motion)
    ctx.startFrameIndex = startFrameIndex
    if sprites ~= nil and not self:isNotPlayAfterimageSkill(ctx.skillID) and not self:isNotRecalcRectByAfterimage(ctx.skillID) and ctx.skillID ~= ___MOD._SkillBook.Blast_122_1221009 then
      ctx.box = attacker.AfterImageComponent:makeAfterImageBox(ctx.motion)
    end
  end
  local hitDelayInfo, lastAttackDelay = ___MOD._PlayerAttackLogic:makeHitDelayInfo(pa, ctx, sprites)
  local totalActionDelay = ___MOD._AranLogic:getBasicAttackTotalActionDelay(attacker, skillID, ___MOD._PlayerSkillLogic:getSkillActionLockDelaySec(attacker, skillID, ctx.motion, 0, 0))
  if skillID == ___MOD._SkillBook.Final_Charge_2110_21100002 then
    totalActionDelay = ___MOD.math.max(0.5, totalActionDelay)
  end
  local attackDelay = lastAttackDelay ~= nil and lastAttackDelay or totalActionDelay
  if isFinishAttack == true then
    ctx.attackCount = 1
    hitDelayInfo = {
      [1] = 0
    }
    lastAttackDelay = 0
    attackDelay = 0
  elseif skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
    ctx.attackCount = 3
  end
  if skillID == ___MOD._SkillBook.Double_Stab_400_4001334 then
    attackDelay = attackDelay * 0.85
  elseif skillID == ___MOD._SkillBook.Heal_230_2301002 then
    attackDelay = attackDelay * 0.5
  end
  local sprite
  if not ctx.playDefaultAttackAfterimage and not isFinalAttack then
    local spriteStartFrameIndex = ctx.startFrameIndex
    if ctx.afterimageInfo ~= nil and ctx.afterimageInfo.StartFrameIndex then
      spriteStartFrameIndex = ctx.afterimageInfo.StartFrameIndex
    end
    if ctx.afterimageInfo ~= nil and spriteStartFrameIndex then
      sprite = ctx.afterimageInfo[___MOD.tostring(spriteStartFrameIndex)]
      if sprite ~= nil and not self:isNotRecalcRectByAfterimage(ctx.skillID) then
        ctx.box = attacker.AfterImageComponent:makeAttackInfo(ctx.afterimageInfo, sprite)
      end
    end
  end
  if ctx.skillID == ___MOD._SkillBook.Savage_Blow_420_4201005 then
    ctx.box = ___MOD._NumberUtils:makeBoxShapeFromLtRb(attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2(), ___MOD.Vector2(-85, -30), ___MOD.Vector2(-25, -15), ctx.isFaceLeft)
  end
  if skillID == ___MOD._SkillBook.Assaulter_421_4211002 then
    local box = ctx.box
    local targets = ctx.skillLevelData ~= nil and ___MOD.math.max(1, ctx.skillLevelData.mobCount) or 1
    local mobs = ___MOD._PlayerAttackLogic:findValidMobs(attacker, box.Position, box.Size, 0, targets, false)
    if mobs == nil or #mobs <= 0 then
      pa.enableNextAttackTime = currentTime + 0.1
      return false
    end
  end
  local attackResult = self:onAttack(attacker, ctx, hitDelayInfo, lastAttackDelay, finalAttackSkillID, slot, chargePer, isFinishAttack, lastAttackMobs, forceTarget, totalActionDelay)
  if attackResult ~= -2 then
    if attackResult == 1 and (skillID == ___MOD._SkillBook.Demolition_512_5121004 or skillID == ___MOD._SkillBook.Barrage_512_5121007 or skillID == ___MOD._SkillBook.Barrage_1511_15111004) then
      attacker.PlayerHitComponent.hitTime = currentTime + 1.5
    end
    if skillID == 0 then
      if attacker.StateComponent.CurrentStateName ~= "PRONE" then
        ___MOD._PlayerStateLogic:changeState(attacker, "NORMAL_ATTACK")
      end
    else
      ___MOD._PlayerStateLogic:changeState(attacker, "SKILL_ATTACK")
    end
    if ctx.playDefaultAttackAfterimage and not self:isNotPlayAfterimageSkill(ctx.skillID) then
      ___MOD._TimerService:SetTimerOnce(function()
        attacker.AfterImageComponent:playAfterImage(attacker.AfterImageComponent:getAfterimagePathByWeapon(), ctx.motion, ctx.playRate, attacker)
        local weaponType = weaponInfo.weaponType
        if weaponInfo.subWeaponID > 0 then
          weaponType = ___MOD._WeaponType:getWeaponTypeByItemID(weaponInfo.subWeaponID)
        end
        local attackSound = ___MOD._WeaponType:getAttackSoundByWeaponType(weaponType, false)
        local attackSoundRUID = ___MOD.__RUIDManager:get(attackSound)
        if attackSoundRUID ~= nil and attackSoundRUID ~= "" and (weaponInfo.subWeaponID > 0 and skillID == 0 or weaponInfo.subWeaponID == 0) then
          ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(attackSoundRUID, attacker, attacker, 1)
        end
      end, attackDelay)
    end
    if sprite ~= nil and skillID ~= ___MOD._SkillBook.Barrage_512_5121007 and skillID ~= ___MOD._SkillBook.Blast_122_1221009 and skillID ~= ___MOD._SkillBook.Barrage_1511_15111004 then
      ___MOD._TimerService:SetTimerOnce(function()
        if attacker.AfterImageComponent:shouldUseSnowChargeAfterimage(ctx.motion) then
          attacker.AfterImageComponent:playAfterImage(attacker.AfterImageComponent:getAfterimagePathByWeapon(), ctx.motion, ctx.playRate, attacker)
        else
          ___MOD._ExtendedEffectService:playSkillAfterimageLocal(attacker, sprite, ctx.playRate, ___MOD.FastVector3.zero:Clone(), false)
        end
      end, attackDelay)
    end
    if not isFinishAttack then
      self:playEffect(attacker, ctx, lastAttackDelay, hitDelayInfo, isFinalAttack)
    end
    if attacker.TamingMobComponent ~= nil and attacker.TamingMobComponent.onTaming and ctx.motion ~= nil and ctx.motion ~= "" then
      pa:reserveTamingActionLock(totalActionDelay)
    end
    local finalAttackDelay = lastAttackDelay + 0.1
    if not isFinalAttack then
      ___MOD._PlayerAttackLogic_FinalAttack:tryRegisterFinalAttack(attacker, skillID, skillLevel, weaponInfo.weaponType, finalAttackDelay)
    end
    ___MOD._PlayerSkillLogic:logSkillActionLockClient(attacker, "Melee", skillID, ctx.motion, totalActionDelay, hitDelayInfo[1] or 0, totalActionDelay)
    pa.enableNextAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds + totalActionDelay
    if (skillID == ___MOD._SkillBook.Double_Swing_2100_21000002 or skillID == ___MOD._SkillBook.Triple_Swing_2110_21100001 or skillID == ___MOD._SkillBook.Final_Blow_2112_21120005 or skillID == ___MOD._SkillBook.Final_Charge_2110_21100002 or skillID == ___MOD._SkillBook.hidden_Full_Swing__Double_Swing_2111_21110007 or skillID == ___MOD._SkillBook.hidden_Full_Swing__Triple_Swing_2111_21110008 or skillID == ___MOD._SkillBook.hidden_Over_Swing__Double_Swing_2112_21120009 or skillID == ___MOD._SkillBook.hidden_Over_Swing__Triple_Swing_2112_21120010 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000014 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000015 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000016) and attacker == ___MOD._UserService.LocalPlayer then
      pa:reserveDisablePlayerControl(totalActionDelay)
    end
    if (skillID == ___MOD._SkillBook.Brandish_112_1121008 or skillID == ___MOD._SkillBook.Brandish_1111_11111004) and attacker == ___MOD._UserService.LocalPlayer and pa._T ~= nil then
      local userId = attacker.PlayerComponent.UserId
      local token = (pa._T.brandishEarlyActionReleaseToken or 0) + 1
      pa._T.brandishEarlyActionReleaseToken = token
      pa:_setCtlTimerOnce(userId, function()
        if not ___MOD.isvalid(attacker) or attacker ~= ___MOD._UserService.LocalPlayer then
          return
        end
        local currentPa = attacker.PlayerActionComponent
        if currentPa == nil or currentPa._T == nil or currentPa._T.brandishEarlyActionReleaseToken ~= token then
          return
        end
        if attacker.StateComponent ~= nil and attacker.StateComponent.CurrentStateName == "SKILL_ATTACK" then
          currentPa:endAttackState()
          currentPa:setMovementLock(___MOD._ControllEnableType.ActionAnimation, false)
        end
      end, totalActionDelay)
    end
    if skillID == ___MOD._SkillBook.Boomerang_Step_422_4221007 then
      pa.enableNextBuffTime = ___MOD.math.max(pa.enableNextBuffTime, ___MOD._UtilLogic.ServerElapsedSeconds + 0.8 * ctx.playRate)
      pa.enableNextBoomerangStepTime = ___MOD._UtilLogic.ServerElapsedSeconds + 1.2 * ctx.playRate
      if attacker.PlayerHitComponent ~= nil then
        attacker.PlayerHitComponent.hitTime = ___MOD.math.max(attacker.PlayerHitComponent.hitTime, ___MOD._UtilLogic.ServerElapsedSeconds + 0.75 * ctx.playRate)
      end
    end
    local rushDelay
    if ___MOD._SkillLogic:isRushAttackSkill(skillID) then
      rushDelay = 2
      local rushTargets = ___MOD._PlayerAttackLogic:findValidMobs(attacker, ctx.box.Position, ctx.box.Size, 0, 1, false)
      if not rushTargets or #rushTargets <= 0 then
        rushDelay = 0.2
      end
    elseif not ___MOD._SkillLogic:isMoveAffectedSkill(skillID) then
      rushDelay = 1.0
    end
    if rushDelay then
      pa.enableNextRushTime = ___MOD._UtilLogic.ServerElapsedSeconds + rushDelay
    end
  end
  return true
end
