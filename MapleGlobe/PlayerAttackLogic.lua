

function PlayerAttackLogic.actionPlayerAttackClient(self, attacker, sad, soulArrowSkillID)
  local attackData = ___MOD.SkillAttackData()
  attackData:fromTable(sad)
  local user = ___MOD._UserService.LocalPlayer
  local weaponType = attacker.AfterImageComponent:getAfterimagePathByWeapon()
  local weaponInfo = self:getWeaponInfo(attacker)
  local ctx = ___MOD._PlayerAttackLogic_Melee:initSkillCtx(attacker, attackData.skillID, attackData.skillLevel, weaponInfo, attackData.finalAttackSkillID > 0, false, true)
  local isMeteorShower = ___MOD._PlayerAttackLogic_Magic:isFootholdMeteorSkill(attackData.skillID)
  if attackData.finishAttack then
    ctx.finishAttack = true
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(attackData.motion) then
    local taming = attacker.TamingMobComponent
    if taming ~= nil and taming.onTaming then
      ___MOD._PlayerStateLogic:changeState(attacker, "SIT")
      taming:playActionMotionClient(attacker, attackData.motion)
    else
      attacker.PlayerActionComponent:playOnceClient(attackData.motion, attackData.playRate, attacker, true, false)
    end
  end
  if ___MOD._SkillLogic:isTrembleAttackSkill(attackData.skillID) then
    ___MOD._ExtendedEffectService:effectTrembleClient(0.25, true, attackData.firstAttackDelay / 1000, 0, false)
  end
  if ___MOD._SkillLogic:isComboFinishAttack(attackData.skillID) then
    local combo = attacker.ComboComponent.comboCount
    ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, ctx.skillID, 0, attacker, 1.0, ___MOD.FastVector3.zero:Clone(), ctx.skillData.finish[___MOD.tostring(combo)], false, false, nil)
  elseif attackData.skillID == ___MOD._SkillBook.Explosion_211_2111002 or attackData.skillID == ___MOD._SkillBook.Big_Bang_212_2121001 or attackData.skillID == ___MOD._SkillBook.Big_Bang_222_2221001 or attackData.skillID == ___MOD._SkillBook.Big_Bang_232_2321001 then
    local lt = ctx.skillLevelData.lt
    local rb = ctx.skillLevelData.rb
    local explosionLt, explosionRb
    if (lt == nil or rb == nil) and (attackData.skillID == ___MOD._SkillBook.Big_Bang_212_2121001 or attackData.skillID == ___MOD._SkillBook.Big_Bang_222_2221001 or attackData.skillID == ___MOD._SkillBook.Big_Bang_232_2321001) then
      explosionLt = ___MOD.FastVector2(-200, -150)
      explosionRb = ___MOD.FastVector2(200, 150)
    else
      explosionLt = lt * 100
      explosionRb = rb * 100
    end
    ___MOD._ExtendedEffectService:makeExplosionAnimation(attacker.CurrentMap, ctx.skillData.special, attacker.TransformComponent:WorldPositionAsFastVector3(), explosionLt, explosionRb, 0, attacker)
  end
  if ctx.playDefaultAttackAfterimage then
    local startFrameIndex = attacker.AfterImageComponent:getAfterImageData2(attackData.motion)
    ctx.startFrameIndex = startFrameIndex
    if startFrameIndex ~= nil then
      ctx.box = attacker.AfterImageComponent:makeAfterImageBox(attackData.motion)
    end
  end
  ___MOD._TimerService:SetTimerOnce(function()
    if ctx.skillData ~= nil then
      local afterimageInfo, startFrameIndex = ___MOD._PlayerAttackLogic_Melee:resolveAfterimageData(attacker, ctx)
      if afterimageInfo ~= nil then
        local sprite = afterimageInfo[afterimageInfo.StartFrameIndex]
        ___MOD._ExtendedEffectService:playSkillAfterimageLocal(attacker, sprite, attackData.playRate, ___MOD.FastVector3.zero:Clone(), false)
      end
    end
    if ctx.playDefaultAttackAfterimage and not ___MOD._PlayerAttackLogic_Melee:isNotPlayAfterimageSkill(attackData.skillID) then
      attacker.AfterImageComponent:playAfterImage(weaponType, attackData.motion, attackData.playRate, attacker)
      local weaponType_ = weaponInfo.weaponType
      if weaponInfo.subWeaponID > 0 then
        weaponType_ = ___MOD._WeaponType:getWeaponTypeByItemID(weaponInfo.subWeaponID)
      end
      local attackSound = ___MOD._WeaponType:getAttackSoundByWeaponType(weaponType_, attackData.attackType == ___MOD._SkillAttackType.Shoot)
      local attackSoundRUID = ___MOD.__RUIDManager:get(attackSound)
      if not ___MOD._UtilLogic:IsNilorEmptyString(attackSoundRUID) and ___MOD._PlayerAttackLogic_Melee:shouldPlayAttackSound(attacker) and (weaponInfo.subWeaponID > 0 and attackData.skillID == 0 or weaponInfo.subWeaponID == 0) then
        ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(attackSoundRUID, attacker, attacker, 1)
      end
    end
  end, attackData.firstAttackDelay / 1000)
  local hitCount = 0
  for i = 1, 100 do
    if ctx.hitData ~= nil then
      local eff = ctx.hitData[i]
      if eff ~= nil then
        hitCount = hitCount + 1
      else
        break
      end
    end
  end
  local hitIndex = 0
  if ctx.skillID == ___MOD._SkillBook.Charged_Blow_121_1211002 then
    hitIndex = attacker.AfterImageComponent.chargeType - 1
  else
    hitCount = 0
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
  local playerPos = attacker.TransformComponent:PositionAsFastVector3():Clone():ToVector2()
  local meteorHitIndex = 0
  local meteorSpawnDelay = 0
  if isMeteorShower then
    meteorHitIndex = ___MOD._PlayerAttackLogic_Magic:getMeteorHitIndex(ctx)
    meteorSpawnDelay = ___MOD._PlayerAttackLogic_Magic:getMakeFootholdEffectDelay(attacker.PlayerActionComponent, ctx, attackData.firstAttackDelay / 1000)
    if ctx.skillData ~= nil and ctx.skillData.tile ~= nil and ctx.skillLevelData ~= nil then
      local pos = attacker.TransformComponent:WorldPositionAsFastVector3()
      ___MOD._ExtendedEffectService:makeFootholdEffectGlobalXSpacing(attacker.CurrentMap, ctx.skillData.tile, pos:ToVector2(), ctx.skillLevelData.lt * 100, ctx.skillLevelData.rb * 100, meteorSpawnDelay, ___MOD.math.max(1, ctx.skillLevelData.mobCount or #sad.targets), nil, attacker)
    end
    ___MOD._TimerService:SetTimerOnce(function()
      for _, target in ___MOD.ipairs(sad.targets) do
        local mob = target.mob
        if ___MOD.isvalid(mob) then
          ___MOD._PlayerAttackLogic_Magic:playMeteorMobHitEffectClient(attacker, ctx, mob, meteorHitIndex)
        end
      end
    end, meteorSpawnDelay)
  end
  local fallingMobs = {}
  for _, target in ___MOD.ipairs(sad.targets) do
    local mob = target.mob
    if ___MOD.isvalid(mob) then
      fallingMobs[#fallingMobs + 1] = mob
    end
  end
  ___MOD._PlayerAttackLogic_Melee:playFallingAnimationOnCast(attacker, ctx, fallingMobs)
  local mobs = {}
  local targets = sad.flag >> 16 & 65535
  local hits = sad.flag & 65535
  local damageDelays = {}
  for index, target in ___MOD.ipairs(sad.targets) do
    local t = target
    local mob = t.mob
    if attackData.attackType == ___MOD._SkillAttackType.Shoot then
      mobs[#mobs + 1] = mob
    end
    local hitData = t.hitData
    local damages = {}
    local criticals = {}
    local mobFaceLeft = mob.MovementComponent:IsFaceLeft()
    local mobPos = mob.TransformComponent.Position:ToVector2()
    for i, v in ___MOD.ipairs(hitData.hits) do
      local dd = v
      damageDelays[i] = dd.delay
      damages[i] = dd.damage
      criticals[i] = dd.critical
    end
    local hasHitDamage = false
    for di = 1, #damages do
      if 0 < (damages[di] or 0) then
        hasHitDamage = true
        break
      end
    end
    local playHitEffectWithoutDamage = self:isComboTempestStatusOnlyTarget(attackData.skillID, mob)
    for i, v in ___MOD.ipairs(hitData.hits) do
      local dd = v
      local isDragonStrikeHitEffect = attackData.skillID == ___MOD._SkillBook.Dragon_Strike_512_5121001
      local hitEffectDelay = isDragonStrikeHitEffect and 0 or dd.delay / 1000
      ___MOD._TimerService:SetTimerOnce(function()
        local canPlayDemolitionSound = attackData.skillID ~= ___MOD._SkillBook.Demolition_512_5121004 or i == 1
        if canPlayDemolitionSound then
          ___MOD._PlayerAttackLogic_Melee:playAttackSound(attacker, mob, attackData.skillID, mob.MobComponent.overrideMobID ~= 0 and mob.MobComponent.overrideMobID or mob.MobComponent.id)
        end
        if not hasHitDamage and not playHitEffectWithoutDamage then
          return
        end
        if attackData.skillID == 0 or attackData.skillID == ___MOD._SkillBook.Sacrifice_131_1311005 or attackData.skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
          local hitAni = mob.HitAnimationComponent
          local keyBase = attackData.attackType == ___MOD._WeaponAttackType.SHOOT and "mace" or "sword"
          local faceDir = attackData.isFaceLeft and -1 or 1
          local key = keyBase .. (faceDir == -1 and 1 or 2)
          local hitPos = self:getHitPoint(mob, ctx.box)
          hitAni:playHitAnimation(key, attacker, mob, hitPos)
        elseif ___MOD._SkillLogic:isThrowBombSkill(attackData.skillID) or attackData.attackType ~= ___MOD._SkillAttackType.Shoot or attackData.skillID == ___MOD._SkillBook.Arrow_Bomb__Bow_310_3101005 then
          local hitOffset = ___MOD._PlayerAttackLogic:getHitOffset(mob, playerPos, mobPos, ctx.box, attackData.isFaceLeft, mobFaceLeft, false)
          local hitPoint
          if ctx.box ~= nil then
            hitPoint = self:getHitPoint(mob, ctx.box)
          end
          if hitPoint ~= nil then
            hitOffset = ___MOD.FastVector3(hitPoint.x - mobPos.x, hitPoint.y - mobPos.y, 0)
          end
          local effectTarget = mob
          local hd, blastHitRoot
          local chargeType = attacker.AfterImageComponent.chargeType
          if ctx.skillID == ___MOD._SkillBook.Blast_122_1221009 and ctx.hitData ~= nil then
            blastHitRoot = ctx.hitData[1]
          end
          if ctx.hitData ~= nil and ctx.skillID ~= 0 and not ___MOD._PlayerSkillLogic:isDisorder(ctx.skillID) and ctx.skillID ~= ___MOD._SkillBook.Sacrifice_131_1311005 then
            hd = ctx.hitData.pos and ctx.hitData or ctx.hitData[hitIndex + 1]
          end
          if blastHitRoot ~= nil then
            hd = blastHitRoot[chargeType + 1]
          end
          if hd ~= nil then
            if hd.pos == 3 or ctx.skillID == ___MOD._SkillBook.Assaulter_421_4211002 then
              hitOffset = ___MOD.FastVector3.zero:Clone()
              hitOffset.y = mob.MobComponent.spriteSize.y / 2
            elseif hd.pos == 2 then
              effectTarget = mob.MobComponent.head
              hitOffset = ___MOD.FastVector3.zero:Clone()
            end
          end
          if isDragonStrikeHitEffect then
            effectTarget = mob.CurrentMap
            local hitX = hitPoint ~= nil and hitPoint.x or mobPos.x
            hitOffset = ___MOD.FastVector3(hitX, mobPos.y, 0)
          end
          if ___MOD._PlayerAttackLogic_Magic:isChainLightningLikeSkill(attackData.skillID) then
            local visualCenterOffset = self:getMobVisualCenterOffset(mob)
            effectTarget = mob
            hitOffset = ___MOD.FastVector3(visualCenterOffset.x, visualCenterOffset.y, 0)
          end
          local c = true
          if attackData.skillID == ___MOD._SkillBook.Arrow_Bomb__Bow_310_3101005 then
            if 1 < index then
              hitIndex = 1
            else
              c = false
            end
          end
          if c and (attackData.skillID ~= ___MOD._SkillBook.Double_Stab_400_4001334 or ___MOD._PlayerAttackLogic:isFirstAttack(index)) then
            if attackData.skillID ~= ___MOD._SkillBook.Chain_Lightning_222_2221006 and not isDragonStrikeHitEffect and (hd == nil or hd.pos ~= 2 and hd.pos ~= 3) then
              effectTarget = mob.CurrentMap
              hitOffset = hitOffset + ___MOD.FastVector3(mobPos.x, mobPos.y, 0)
            end
            local isMagicClaw = ctx.skillID == ___MOD._SkillBook.Magic_Claw_200_2001005 or ctx.skillID == ___MOD._SkillBook.Magic_Claw_1200_12001003 or ctx.skillID == ___MOD._SkillBook.Soul_Driver_1111_11111006 or ctx.skillID == ___MOD._SkillBook.Vampire_1410_14101006
            local canPlayMagicClawHit = not isMagicClaw or i == 1
            local canPlayDemolitionHit = ctx.skillID ~= ___MOD._SkillBook.Demolition_512_5121004 or i == 1
            if not isMeteorShower and (ctx.skillID ~= ___MOD._SkillBook.Double_Stab_400_4001334 or ___MOD._PlayerAttackLogic:isFirstAttack(index)) and canPlayMagicClawHit and canPlayDemolitionHit then
              if ctx.skillID == ___MOD._SkillBook.Barrage_512_5121007 or ctx.skillID == ___MOD._SkillBook.Barrage_1511_15111004 then
                local barrageHit0 = not ctx.skillData.hit0 and ctx.hitData and ctx.hitData[1]
                local barrageHit1 = not ctx.skillData.hit1 and ctx.hitData and ctx.hitData[2]
                if i == 1 then
                  local playHitIndex = hitIndex
                  local playHitData = ctx.hitData
                  local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, playHitIndex, effectTarget, 1.0, hitOffset, playHitData, false, sad.isFaceLeft, nil)
                  ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
                  if barrageHit0 ~= nil then
                    local hitEffects0 = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, 0, effectTarget, 1.0, hitOffset, {barrageHit0}, false, sad.isFaceLeft, nil)
                    ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects0, attacker)
                  end
                  if barrageHit1 ~= nil then
                    local hitEffects1 = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, 0, effectTarget, 1.0, hitOffset, {barrageHit1}, false, sad.isFaceLeft, nil)
                    ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects1, attacker)
                  end
                end
              else
                local playHitIndex = playHitEffectWithoutDamage and 0 or hitIndex
                local playHitData = ctx.hitData
                if blastHitRoot ~= nil then
                  playHitIndex = chargeType
                  playHitData = blastHitRoot
                end
                local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, playHitIndex, effectTarget, 1.0, hitOffset, playHitData, false, sad.isFaceLeft, nil)
                ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
              end
            end
          end
        end
        if sad.chainLightningInfo ~= nil then
          local chainLightningInfo = sad.chainLightningInfo[index]
          ___MOD._PlayerAttackLogic_Magic:spawnChainLineTo(chainLightningInfo.startPos, chainLightningInfo.endPos, 0.5, nil, nil, nil, attacker, attackData.skillID)
        end
      end, hitEffectDelay)
    end
    local lastAttackDelay = hitData.hits[#hitData.hits].delay / 1000
    if attackData.skillID ~= ___MOD._SkillBook.Heavens_Hammer_122_1221011 and attackData.skillID ~= ___MOD._SkillBook.Hypnotize_522_5221009 and not self:isComboTempestStatusOnlyTarget(attackData.skillID, mob) then
      self:displayDamageByAttackerClient(attacker, mob, damages, criticals, damageDelays)
    end
  end
  if ___MOD._PlayerSkillLogic:isDisorder(attackData.skillID) and ___MOD.mob.MobAIComponent ~= nil and ___MOD.mob.MobAIComponent:isControllingByMe() then
    ___MOD.mob.MobAIComponent:chaseTarget(nil, false)
  end
  if attackData.attackType == ___MOD._SkillAttackType.Shoot then
    local item = ___MOD._ItemManager:getItemById(attackData.starItemID)
    local bullet
    if item ~= nil then
      bullet = item.bullet
    end
    local bulletDelay = ___MOD._PlayerAttackLogic_Shoot:getBulletDelay(attackData.starItemID, attackData.skillID, 0)
    local shootDelay = ___MOD._PlayerAttackLogic_Shoot:getShootDelay(attackData.skillID, attackData.firstAttackDelay) / 1000
    local passThrough = ___MOD._PlayerAttackLogic_Shoot:isPassThroughSkill(attackData.skillID)
    local shootRange = ___MOD._PlayerAttackLogic_Shoot:getShootStartRange(attackData.skillID)
    local mapleRange = attackData.shootRange
    local pos = attacker.TransformComponent:PositionAsFastVector3()
    local startPos = pos:Clone():ToVector2()
    if attackData.isFaceLeft then
      startPos.x = startPos.x - shootRange
    else
      startPos.x = startPos.x + shootRange
    end
    startPos.y = startPos.y + 0.28
    local boxShape = ___MOD._PlayerAttackLogic_Shoot:makeBoxShapeFromLtRb(startPos, ___MOD.FastVector2(-mapleRange, 1), ___MOD.FastVector2.zero:Clone(), attackData.isFaceLeft)
    local range = mapleRange / 100
    local shootPathMobs = {}
    local hitMobCount = ___MOD._PlayerAttackLogic_Shoot:findHitMobInTrapezoid(startPos.x, shootRange, range, startPos.y, 4, shootPathMobs, attackData.isFaceLeft, boxShape, attacker, nil)
    if ___MOD._SkillLogic:isThrowBombSkill(attackData.skillID) then
      if 0 < targets then
        return
      end
      local maxCharge = ___MOD._SkillLogic:getMaxGaugeTime(attackData.skillID)
      local t = maxCharge * attackData.chargePer / 1000
      ___MOD._PlayerAttackLogic_Shoot:createGrenadeClient(attacker.CurrentMap, attacker, attackData.skillID, attackData.skillLevel, pos, t, attackData.isFaceLeft)
    else
      ___MOD._PlayerAttackLogic_Shoot:createBulletClient(attacker.CurrentMap, attacker, mobs, hits, bulletDelay, shootDelay, startPos, bullet, weaponInfo.weaponType, attackData.isFaceLeft, attackData.attackType == ___MOD._SkillAttackType.Magic, passThrough, boxShape, mapleRange, soulArrowSkillID, ctx)
    end
  end
end

function PlayerAttackLogic.afterDead(self, attacker, mob, delay)

end

function PlayerAttackLogic.applyPendingWindWalkAttackBoost(self, attacker, sad)
  if attacker == nil or attacker.CalcDamageComponent == nil or sad == nil then
    return
  end
  sad.windWalkSkillLevel = ___MOD.tonumber(attacker.CalcDamageComponent.windWalkAttackSkillLevel) or 0
  sad.vanishSkillLevel = ___MOD.tonumber(attacker.CalcDamageComponent.vanishAttackSkillLevel) or 0
  attacker.CalcDamageComponent.windWalkAttackSkillLevel = 0
  attacker.CalcDamageComponent.vanishAttackSkillLevel = 0
  attacker.CalcDamageComponent.sparkAttackDamage = 0
end

function PlayerAttackLogic.applyServerAttackResult(self, targetData, damages, criticals, skillID)

end

function PlayerAttackLogic.beforeAttackMob(self, attacker, mob, skillID, skillLevel, totalDamage, delay)

end

function PlayerAttackLogic.broadcastPlayerAttack(self, attacker, sad)

end

function PlayerAttackLogic.calcDamage(self, attacker, mob, skillID, skillLevel, attackCount, attackMotion, finalAttackSkillID, targetCount, bulletSlot, mobOrder, chargePer, finishAttack)

end

function PlayerAttackLogic.calcDamageClient(self, attacker, mob, skillID, skillLevel, attackCount, damageDelays, attackMotion, finalAttackSkillID, targetCount, bulletSlot, mobOrder, chargePer, finishAttack)
  local damages = self._bufDamages
  local criticals = self._bufCriticals
  damages, criticals = attacker.CalcDamageComponent:makePlayerDamageInfo(attacker, mob, skillID, skillLevel, attackCount, attackMotion, finalAttackSkillID, targetCount, bulletSlot, mobOrder, chargePer, finishAttack)
  if self:isComboTempestStatusOnlyTarget(skillID, mob) then
    self:clearAttackDamages(damages, criticals)
  end
  if self:isSanctuarySkill(skillID) then
    self:overrideSanctuaryDamages(mob, damages, criticals)
  end
  self:overrideComboTempestDamages(mob, damages, criticals)
  local highestDamage = 0
  for i = 1, #damages do
    if highestDamage < damages[i] then
      highestDamage = damages[i]
    end
  end
  return damages, criticals, highestDamage
end

function PlayerAttackLogic.canUseAttackSkillByCooldown(self, attacker, skillID, skillLevelData, currentTime)
  local cooldownSec = ___MOD._PlayerSkillLogic:getSkillLevelDataCooltimeSec(skillLevelData, skillID)
  if cooldownSec <= 0 then
    return true
  end
  local endTime = ___MOD._PlayerSkillLogic:getSkillCooldownEndTime(attacker, skillID)
  local tolerance = ___MOD.math.min(cooldownSec * 0.1, 2.0)
  return endTime <= currentTime + tolerance
end

function PlayerAttackLogic.canUseVanishAttackBoost(self, attacker)
  if attacker == nil or attacker.Player == nil or attacker.SkillComponent == nil then
    return false
  end
  local job = attacker.Player.Job
  return 1410 <= job and job <= 1412 and attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Vanish_1410_14100005) > 0
end

function PlayerAttackLogic.checkCanAttack(self, attacker, skillID)
  local ts = attacker.PlayerTemporaryStatComponent
  local morphId = ts:getValue(___MOD._CTS.Morph)
  if ___MOD._PlayerSkillLogic:isWindArcherMorphAttackSkill(skillID) and morphId ~= 1003 and morphId ~= 1103 then
    local pa = attacker.PlayerActionComponent
    local current = ___MOD._UtilLogic.ElapsedSeconds
    if pa.nextDisplayAttackMessageTime == 0 or current >= pa.nextDisplayAttackMessageTime then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에만 사용할 수 있는 스킬입니다.")
      pa.nextDisplayAttackMessageTime = current + 0.5
    end
    return false
  end
  if morphId ~= 0 and morphId ~= 1000 and morphId ~= 1100 and morphId ~= 1001 and morphId ~= 1101 and morphId ~= 1003 and morphId ~= 1103 then
    local canCancelMorph = true
    local morphSkillId = ts:getSkillID(___MOD._CTS.Morph)
    if morphSkillId < 0 then
      local item = ___MOD._ItemManager:getItemById(-morphSkillId)
      if item ~= nil and item.noCancelMouse then
        canCancelMorph = false
      end
    end
    local pa = attacker.PlayerActionComponent
    local current = ___MOD._UtilLogic.ElapsedSeconds
    if pa.nextDisplayAttackMessageTime == 0 or current >= pa.nextDisplayAttackMessageTime then
      if canCancelMorph then
        ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에는 할 수 없습니다. 오른쪽 위의 아이콘을 우클릭하여 변신을 해제할 수 있습니다.")
      else
        ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에는 할 수 없습니다.")
      end
      pa.nextDisplayAttackMessageTime = current + 0.5
    end
    return false
  end
  if ts:getValue(___MOD._CTS.Stun) ~= 0 then
    return false
  end
  if ts:getValue(___MOD._CTS.Attract) ~= 0 then
    return false
  end
  return true
end

function PlayerAttackLogic.checkWeapon(self, weapon, weaponItem)
  if weapon ~= nil then
    local weaponType = ___MOD.math.floor(weaponItem / 10000) % 100
    if weapon == weaponType then
      return true
    end
  end
  return false
end

function PlayerAttackLogic.clearAttackDamages(self, damages, criticals)
  for i = 1, #damages do
    damages[i] = 0
    if criticals then
      criticals[i] = false
    end
  end
end

function PlayerAttackLogic.clearAttackInfoClient(self)
  self._T.attackInfo = nil
end

function PlayerAttackLogic.clearUserAttackLogWatcher(self, watcherUserId)

end

function PlayerAttackLogic.decreaseSparkChainAttackCounter(self, attacker, sad, now)

end

function PlayerAttackLogic.displayDamage(self, attacker, mob, damages, criticals, delays, senderUserId)

end

function PlayerAttackLogic.displayDamageByAttackerClient(self, attacker, mob, damages, criticals, delays)
  if not self:shouldDisplayDamageByAttacker(attacker) then
    return
  end
  self:displayDamageClient(mob, damages, criticals, delays, attacker)
end

function PlayerAttackLogic.displayDamageClient(self, mob, damages, criticals, delays, attacker)
  if attacker and not self:shouldDisplayDamageByAttacker(attacker) then
    return
  end
  mob.CurrentMap.DamageEffectComponent:show(mob, ___MOD._DamageEffectType.Red, damages, criticals, delays, 0, mob.MobComponent.head.TransformComponent:PositionAsFastVector3())
end

function PlayerAttackLogic.displayOtherDamageClient(self, mob, damages, criticals, delays, attacker)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not localPlayer or not localPlayer.UISystemOptionComponent then
    self:displayDamageClient(mob, damages, criticals, delays, attacker)
    return
  end
  if attacker and not self:shouldDisplayDamageByAttacker(attacker) then
    return
  end
  self:displayDamageClient(mob, damages, criticals, delays, attacker)
end

function PlayerAttackLogic.displaySkillDamageByAttackerClient(self, attacker, mob, skillID, damages, criticals, delays)
  if not self:shouldDisplayDamageByAttacker(attacker) then
    return
  end
  if not ___MOD.isvalid(mob) or mob.MobComponent == nil or mob.MobComponent.head == nil or mob.CurrentMap == nil or mob.CurrentMap.DamageEffectComponent == nil then
    return
  end
  mob.CurrentMap.DamageEffectComponent:showPlayerSkillDamage(attacker, mob, skillID, ___MOD._DamageEffectType.Red, damages, criticals, delays, 0, mob.MobComponent.head.TransformComponent:PositionAsFastVector3())
end

function PlayerAttackLogic.doNormalAttack(self, attacker, isShoot)

end

function PlayerAttackLogic.doPlayerAttack(self, attacker, sad, skillLevelData, handleAttackCooldown)

end

function PlayerAttackLogic.dropItemByMob(self, mob, owner, ownType, partyId, delay)

end

function PlayerAttackLogic.dropItemBySteal(self, mob, user)

end

function PlayerAttackLogic.findValidHitReactor(self, attacker, position, size, angle)
  local overlap = {}
  local simulator = ___MOD._CollisionService:GetSimulator(attacker.CurrentMap.CurrentMapName)
  local found = simulator:OverlapBoxAllFast("Reactor", position, size, angle, overlap)
  if found <= 0 then
    return nil
  end
  for i = 1, found do
    local trigger = overlap[i]
    local entity = trigger.Entity
    local reactor = entity.ReactorComponent
    if ___MOD.isvalid(reactor) and reactor.spawned and reactor:isHitTypeReactor() and trigger.EnableInHierarchy then
      return reactor
    end
  end
end

function PlayerAttackLogic.findValidMobs(self, attacker, position, size, angle, mobCount, isHeal, mobBoxScale)
  attacker.Player.overlapMonsters = {}
  local simulator = ___MOD._CollisionService:GetSimulator(attacker.CurrentMap.CurrentMapName)
  local found = simulator:OverlapBoxAllFast("Monster", position, size, angle, attacker.Player.overlapMonsters)
  if found <= 0 then
    return {}
  end
  local attackBox = ___MOD.BoxShape(position, size, angle)
  local scale = ___MOD.tonumber(mobBoxScale) or 1.0
  if scale <= 0 then
    scale = 1.0
  end
  self._bufMobs = self._bufMobs or {}
  local mobs = self._bufMobs
  local n = 0
  local homingMob
  self._T._bufMobSeen = self._T._bufMobSeen or {}
  local seen = self._T._bufMobSeen
  self._T._bufMobHitPoints = self._T._bufMobHitPoints or {}
  local hitPoints = self._T._bufMobHitPoints
  local dedicated = ___MOD._DedicatedMonsterLogic
  local useDedicated = dedicated and dedicated:isEnabledMap(attacker.CurrentMap)
  for k, _ in ___MOD.pairs(seen) do
    seen[k] = nil
  end
  for k, _ in ___MOD.pairs(hitPoints) do
    hitPoints[k] = nil
  end
  for i = 1, found do
    local trigger = attacker.Player.overlapMonsters[i]
    if trigger and trigger.EnableInHierarchy then
      local mob = trigger.Entity
      if ___MOD.isvalid(mob) and mob.Enable and not mob.MobComponent:isDead() and not mob.MobComponent.damagedByMob and not mob.MobComponent.suspended then
        local mobBox = ___MOD._NumberUtils:triggerToBox(trigger)
        if mobBox ~= nil then
          local sortBox = mobBox
          if scale ~= 1.0 then
            local scaledMobBox = ___MOD.BoxShape(mobBox.Position, mobBox.Size * scale, mobBox.Angle)
            if ___MOD.Environment:IsMakerPlay() then
              ___MOD._ColliderUtils:d(attacker.CurrentMap, 9102, scaledMobBox)
            end
            sortBox = scaledMobBox
          end
          local hitPoint = ___MOD._NumberUtils:intersectBox(attackBox, sortBox)
          if hitPoint == nil then
            hitPoint = mob.TransformComponent.WorldPosition:ToVector2()
          end
          if (not useDedicated or dedicated:isOwnedMob(attacker, mob)) and not seen[mob] and (not isHeal or mob.MobComponent.undead) then
            local mts = mob.MobTemporaryStatComponent
            if mts:getValue(___MOD._MTS.Dazzle) == 0 then
              seen[mob] = true
              hitPoints[mob] = hitPoint
              n = n + 1
              mobs[n] = mob
              if homingMob == nil then
                local mts = mob.MobTemporaryStatComponent
                if mts ~= nil and mts:getValue(___MOD._MTS.Homing) ~= 0 and (mts:getOwner(___MOD._MTS.Homing) == attacker.Player.PlayerId or attacker.PlayerVariables.homingMob == mob) then
                  homingMob = mob
                end
              end
            end
          end
        end
      end
    end
  end
  for i = n + 1, #mobs do
    mobs[i] = nil
  end
  if n <= 0 then
    return {}
  end
  if n == 1 then
    self._bufSortedMobs = self._bufSortedMobs or {}
    local out = self._bufSortedMobs
    out[1] = mobs[1]
    for i = 2, #out do
      out[i] = nil
    end
    return out
  end
  self._T._bufMobKeys = self._T._bufMobKeys or {}
  local keys = self._T._bufMobKeys
  local validCount = 0
  for i = 1, n do
    local m = mobs[i]
    if ___MOD.isvalid(m) and m.TransformComponent ~= nil then
      local p = hitPoints[m]
      if p == nil then
        p = m.TransformComponent.WorldPosition:ToVector2()
      end
      validCount = validCount + 1
      keys[validCount] = keys[validCount] or {}
      keys[validCount].ent = m
      keys[validCount].x = p.x
    end
  end
  n = validCount
  for i = n + 1, #keys do
    keys[i] = nil
  end
  local lookX = attacker.PlayerControllerComponent and attacker.PlayerControllerComponent.LookDirectionX or 1
  local xAsc = 0 <= lookX
  local sortKeys = {}
  for i = 1, n do
    sortKeys[i] = keys[i]
  end
  ___MOD.table.sort(sortKeys, function(A, B)
    if xAsc then
      return A.x < B.x
    end
    return A.x > B.x
  end)
  self._bufSortedMobs = self._bufSortedMobs or {}
  local out = self._bufSortedMobs
  local take = ___MOD.math.min(mobCount, n)
  for i = 1, #out do
    out[i] = nil
  end
  if take <= 0 then
    return out
  end
  local idx = 1
  if homingMob ~= nil and 1 <= take then
    out[1] = homingMob
    idx = 2
  end
  for i = 1, n do
    if take < idx then
      break
    end
    local e = sortKeys[i].ent
    if homingMob == nil or e ~= homingMob then
      out[idx] = e
      idx = idx + 1
    end
  end
  if out[1] == nil and 1 <= take then
    out[1] = sortKeys[1].ent
  end
  for i = take + 1, #out do
    out[i] = nil
  end
  return out
end

function PlayerAttackLogic.getAttackPlayRate(self, attacker, skillID)
  local pa = attacker.PlayerActionComponent
  local speed = pa:getCurrentSkillActionSpeed(skillID)
  return (speed + 10) / 16
end

function PlayerAttackLogic.getAttackType(self, attacker, skillID, weaponInfo)
  local attackType = ___MOD._SkillAttackType.Melee
  if skillID == ___MOD._SkillBook.Energy_Orb_512_5121002 then
    return ___MOD._SkillAttackType.Magic
  end
  if skillID == ___MOD._SkillBook.Combo_Smash_2110_21100004 or skillID == ___MOD._SkillBook.Combo_Fenrir_2111_21110004 then
    return ___MOD._SkillAttackType.Shoot
  end
  if self:isMeleeAttackSkill(skillID) or attacker.StateComponent.CurrentStateName == "PRONE" then
    return ___MOD._SkillAttackType.Melee
  end
  if attacker.Player.Job >= 200 and attacker.Player.Job <= 232 or attacker.Player.Job >= 1200 and attacker.Player.Job <= 1212 then
    if skillID == 0 then
      return ___MOD._SkillAttackType.Melee
    end
    return ___MOD._SkillAttackType.Magic
  end
  if weaponInfo.attackType == ___MOD._WeaponAttackType.SHOOT or self:isShootAttackSkill(skillID) then
    attackType = ___MOD._SkillAttackType.Shoot
  elseif weaponInfo.attackType == ___MOD._WeaponAttackType.MAGIC then
    attackType = ___MOD._SkillAttackType.Magic
  end
  return attackType
end

function PlayerAttackLogic.getExpectedAttackHitCountServer(self, attacker, skillID, attackType, levelData)

end

function PlayerAttackLogic.getExpectedAttackHitsServer(self, attacker, sad, ld)

end

function PlayerAttackLogic.getHitOffset(self, mob, playerPos, mobPos, box, playerFaceLeft, mobFaceLeft, isRelativeOffset)
  if box == nil then
    if isRelativeOffset then
      return ___MOD.FastVector3.zero:Clone()
    end
    return ___MOD.FastVector3.zero:Clone()
  end
  local faceDir = playerFaceLeft and -1 or 1
  local halfX = box.Size.x * 0.5
  local boxSizeY = box.Size.y
  local baseX = box.Position.x
  local baseY = box.Position.y
  local hitLeft = baseX - halfX * faceDir
  local hitRight = baseX + halfX * faceDir
  local hitTop = baseY + boxSizeY
  local hitBottom = baseY - boxSizeY
  if hitLeft > hitRight then
    hitLeft, hitRight = hitRight, hitLeft
  end
  if hitTop < hitBottom then
    hitTop, hitBottom = hitBottom, hitTop
  end
  local boxBOffset = mob.TriggerComponent.BoxOffset
  local boxBSize = mob.TriggerComponent.BoxSize
  local boxBPos = mobPos + boxBOffset
  local mobLeft = boxBPos.x - boxBSize.x * 0.5
  local mobRight = boxBPos.x + boxBSize.x * 0.5
  local mobTop = boxBPos.y + boxBSize.y
  local mobBottom = boxBPos.y - boxBSize.y
  local overlapLeft = ___MOD.math.max(hitLeft, mobLeft)
  local overlapRight = ___MOD.math.min(hitRight, mobRight)
  local x
  if overlapLeft < overlapRight then
    x = (overlapLeft + overlapRight) * 0.5
  else
    local mobFaceDir = mob.MovementComponent:IsFaceLeft() and -1 or 1
    x = mobFaceDir == -1 and mobLeft or mobRight
  end
  local overlapBottom = ___MOD.math.max(hitBottom, mobBottom)
  local overlapTop = ___MOD.math.min(hitTop, mobTop)
  local y
  if overlapBottom < overlapTop then
    y = (overlapBottom + overlapTop) * 0.5
  else
    y = (mobBottom + mobTop) * 0.5
  end
  if isRelativeOffset then
    return ___MOD.Vector3(x, y, 0)
  else
    return ___MOD.Vector3(x - mobPos.x, y - mobPos.y, 0)
  end
end

function PlayerAttackLogic.getHitPlayDelay(self, totalFrameDelay, hitIndex, totalHits)
  if totalHits <= 1 then
    return totalFrameDelay
  end
  local interval = totalFrameDelay / totalHits
  return interval * hitIndex
end

function PlayerAttackLogic.getHitPoint(self, mob, box)
  local mobBox = ___MOD._NumberUtils:triggerToBox(mob.TriggerComponent)
  local intersect = ___MOD._NumberUtils:intersectBox(box, mobBox)
  if ___MOD.Environment:IsMakerPlay() then
    ___MOD._ColliderUtils:d(mob.CurrentMap, 1, box)
    ___MOD._ColliderUtils:d(mob.CurrentMap, 2, mobBox)
  end
  local hitPt = intersect and intersect:ToVector3() or self:getMobVisualCenterWorldPos(mob)
  return hitPt
end

function PlayerAttackLogic.getMobVisualCenterOffset(self, mob)
  local asc = mob.AnimationSpriteComponent
  if asc ~= nil and asc._T ~= nil then
    local anim = asc._T.currentAnim
    local idx = asc._T.currentFrameIndex
    if anim ~= nil and idx ~= nil and 0 < idx then
      local frame = anim[idx]
      if frame ~= nil then
        local mobFaceLeft = mob.MovementComponent ~= nil and mob.MovementComponent:IsFaceLeft() or false
        local off = mobFaceLeft and frame.originOffset or frame.originOffsetFlip
        if off ~= nil then
          return ___MOD.FastVector3(off.x, off.y, 0)
        end
      end
    end
  end
  local centerY = mob.MobComponent ~= nil and mob.MobComponent.spriteSize ~= nil and mob.MobComponent.spriteSize.y * 0.5 or 0
  return ___MOD.FastVector3(0, centerY, 0)
end

function PlayerAttackLogic.getMobVisualCenterWorldPos(self, mob)
  local p = mob.TransformComponent:WorldPositionAsFastVector3():Clone()
  local off = self:getMobVisualCenterOffset(mob)
  p.x = p.x + off.x
  p.y = p.y + off.y
  return p
end

function PlayerAttackLogic.getRandomAttackMotion(self, attacker, weaponInfo, shoot)
  local weaponType = weaponInfo.subWeaponID > 0 and ___MOD._WeaponType:getWeaponTypeByItemID(weaponInfo.subWeaponID) or weaponInfo.weaponType
  local list = ___MOD._WeaponAttackMotion.attackMotion[weaponType]
  if shoot then
    local shootList = list.shoot or {"swingO1", "swingO3"}
    return shootList[___MOD._GlobalRand32:randomIntegerRange(1, #shootList)]
  end
  if list == nil then
    return
  end
  if attacker.RigidbodyComponent:IsOnGround() and attacker.PlayerSettingsComponent:isKeyPressed("DownArrow") then
    return "proneStab"
  end
  if not shoot then
    local pick = list[___MOD._GlobalRand32:randomIntegerRange(1, #list)]
    if pick == nil then
      local melee = list.melee
      pick = melee[___MOD._GlobalRand32:randomIntegerRange(1, #melee)]
    end
    return pick
  end
end

function PlayerAttackLogic.getServerActionLockFallbackDelay(self, sad)
  if sad.attackType == ___MOD._SkillAttackType.Shoot then
    return 1
  end
  return 0
end

function PlayerAttackLogic.getServerActionLockPrepareDelay(self, sad)
  local skillData = ___MOD._SkillManager:getSkill(sad.skillID)
  if skillData == nil or skillData.prepare == nil then
    return 0
  end
  local totalDelay = ___MOD.tonumber(skillData.prepare.totalDelay) or 0
  return totalDelay / 1000
end

function PlayerAttackLogic.getSkillActionLockSoftGrace(self, serverDelay, clientDelay)
  local baseDelay = ___MOD.math.max(serverDelay, clientDelay)
  return ___MOD.math.max(0.35, baseDelay * 0.35)
end

function PlayerAttackLogic.getSkillActionLockStrongGrace(self, serverDelay, clientDelay)
  local baseDelay = ___MOD.math.max(serverDelay, clientDelay)
  return ___MOD.math.max(0.7, baseDelay * 0.75)
end

function PlayerAttackLogic.getSkillMinDelay(self, skillID)
  if self._T.skillMinDelayCache == nil then
    self._T.skillMinDelayCache = {}
  end
  local cachedDelay = self._T.skillMinDelayCache[skillID]
  if cachedDelay ~= nil then
    return cachedDelay
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData == nil then
    return 0
  end
  local prepareDelay = 0
  if skillData.prepare ~= nil then
    prepareDelay = ___MOD.math.max(0, ___MOD.tonumber(skillData.prepare.totalDelay) or 0) / 1000
  end
  local minDelay

  local function addMotion(motion)
    if ___MOD.type(motion) ~= "string" or motion == "" then
      return
    end
    if ___MOD._MotionDataManager:getMotionMinDelay(motion) <= 0 then
      return
    end
    local delay = ___MOD._PlayerSkillLogic:getSkillMinActionLockDelaySec(skillID, motion, 0, prepareDelay)
    if 0 < delay and (minDelay == nil or delay < minDelay) then
      minDelay = delay
    end
  end

  local action = skillData.action
  if action ~= nil then
    for index = 0, #action do
      addMotion(action[___MOD.tostring(index)])
    end
  end
  local levels = skillData.level
  if levels ~= nil then
    for level = 1, #levels do
      local levelData = levels[level]
      if levelData ~= nil then
        addMotion(levelData.action)
      end
    end
  end
  if minDelay == nil then
    for _, motion in ___MOD.ipairs(___MOD._WeaponAttackMotion:getAllAttackMotions()) do
      addMotion(motion)
    end
  end
  local delay = ___MOD.math.max(0, minDelay or 0)
  if 0 < delay then
    self._T.skillMinDelayCache[skillID] = delay
  end
  return delay
end

function PlayerAttackLogic.getWeaponInfo(self, attacker)
  local slot = ___MOD._EquipmentSlotType.WEAPON
  local weaponInfo = ___MOD.WeaponInfo()
  if attacker.EquipmentComponent:hasSlotItem(slot, ___MOD._EquipmentSubSlotType.MAIN) then
    local slot_ = attacker.EquipmentComponent.equipment[slot]
    local equip = slot_[___MOD._EquipmentSubSlotType.MAIN].equip
    if equip ~= nil then
      local itemID = equip.itemId
      local weaponType = ___MOD._WeaponType:getWeaponTypeByItemID(itemID)
      local weaponAttackType = ___MOD._WeaponAttackType:getWeaponAttackType(weaponType)
      local subWeaponID = 0
      if ___MOD._PlayerConstants:isDualBlade(attacker.Player.Job) and attacker.EquipmentComponent:hasSlotItem(___MOD._EquipmentSlotType.SHIELD, ___MOD._EquipmentSubSlotType.MAIN) then
        local subEquip = attacker.EquipmentComponent.equipment[___MOD._EquipmentSlotType.SHIELD][___MOD._EquipmentSubSlotType.MAIN].equip
        subWeaponID = subEquip.itemId
      end
      weaponInfo.valid = true
      weaponInfo.itemID = itemID
      weaponInfo.weaponType = weaponType
      weaponInfo.attackType = weaponAttackType
      weaponInfo.subWeaponID = subWeaponID
      weaponInfo.disabled = slot_.disabled
    end
  else
    weaponInfo.valid = false
    weaponInfo.itemID = 0
    weaponInfo.weaponType = ___MOD._WeaponType.BARE_HANDS
    weaponInfo.attackType = ___MOD._WeaponAttackType.MELEE
    weaponInfo.disabled = false
  end
  return weaponInfo
end

function PlayerAttackLogic.hasComboTempestTemporaryStat(self, mob)
  if not mob or not mob.MobTemporaryStatComponent then
    return false
  end
  return mob.MobTemporaryStatComponent:getValue(___MOD._MTS.ComboTempest) > 0
end

function PlayerAttackLogic.increaseSparkChainAttackCounter(self, attacker, sad, now)

end

function PlayerAttackLogic.isComboTempestStatusOnlyTarget(self, skillID, mob)
  if skillID ~= ___MOD._SkillBook.Combo_Tempest_2112_21120006 then
    return false
  end
  if not mob or not mob.MobComponent then
    return false
  end
  if mob.MobTemporaryStatComponent and mob.MobTemporaryStatComponent:getValue(___MOD._MTS.ComboTempest) > 0 then
    return false
  end
  return not mob.MobComponent.boss
end

function PlayerAttackLogic.isFinalAttackActionLockSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Final_Attack__Sword_110_1100002 or skillID == ___MOD._SkillBook.Final_Attack__Axe_110_1100003 or skillID == ___MOD._SkillBook.Final_Attack__Sword_120_1200002 or skillID == ___MOD._SkillBook.Final_Attack__BW_120_1200003 or skillID == ___MOD._SkillBook.Final_Attack__Spear_130_1300002 or skillID == ___MOD._SkillBook.Final_Attack__Pole_Arm_130_1300003 or skillID == ___MOD._SkillBook.Final_Attack__Bow_310_3100001 or skillID == ___MOD._SkillBook.Final_Attack__Crossbow_320_3200001 or skillID == ___MOD._SkillBook.Final_Attack_1110_11101002 or skillID == ___MOD._SkillBook.Final_Attack_1310_13101002
end

function PlayerAttackLogic.isFirstAttack(self, index)
  return index == 1
end

function PlayerAttackLogic.isMeleeAttackSkill(self, skillID)
  if skillID == ___MOD._SkillBook.Sommersault_Kick_500_5001002 or skillID == ___MOD._SkillBook.Flash_Fist_500_5001001 or skillID == ___MOD._SkillBook.Thunder_Bolt_220_2201005 or skillID == ___MOD._SkillBook.Disorder_400_4001002 or skillID == ___MOD._SkillBook.Disorder_1400_14001002 or skillID == ___MOD._SkillBook.Magic_Claw_200_2001005 or skillID == ___MOD._SkillBook.Magic_Claw_1200_12001003 or skillID == ___MOD._SkillBook.Power_KnockBack_310_3101003 or skillID == ___MOD._SkillBook.Power_KnockBack_320_3201003 or skillID == ___MOD._SkillBook.Invisible_Shot_520_5201001 or skillID == ___MOD._SkillBook.Blank_Shot_520_5201004 or skillID == ___MOD._SkillBook.Ice_Strike_221_2211002 or skillID == ___MOD._SkillBook.Shining_Ray_231_2311004 or skillID == ___MOD._SkillBook.Arrow_Rain_311_3111004 or skillID == ___MOD._SkillBook.Arrow_Rain_1311_13111000 or skillID == ___MOD._SkillBook.Arrow_Eruption_321_3211004 or skillID == ___MOD._SkillBook.Flamethrower_521_5211004 or skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 or skillID == ___MOD._SkillBook.Heavens_Hammer_122_1221011 or skillID == ___MOD._SkillBook.Ninja_Storm_412_4121008 or skillID == ___MOD._SkillBook.Rolling_Spin_2111_21110006 or skillID == ___MOD._SkillBook.Ninja_Ambush_412_4121004 or skillID == ___MOD._SkillBook.Ninja_Ambush_422_4221004 or skillID == ___MOD._SkillBook.Air_Strike_522_5221003 or skillID == ___MOD._SkillBook.Poison_Mist_211_2111003 or skillID == ___MOD._SkillBook.Flame_Gear_1211_12111005 or skillID == ___MOD._SkillBook.Fire_Pillar_1210_12101006 or skillID == ___MOD._SkillBook.Storm_Break_1310_13101005 or skillID == ___MOD._SkillBook.Vampire_1410_14101006 then
    return true
  end
  return false
end

function PlayerAttackLogic.isProneAttackBlockedSkill(self, skillID)
  if skillID == ___MOD._SkillBook.Disorder_400_4001002 or skillID == ___MOD._SkillBook.Disorder_1400_14001002 or skillID == ___MOD._SkillBook.Band_of_Thieves_421_4211004 then
    return true
  end
  return false
end

function PlayerAttackLogic.isSanctuarySkill(self, skillID)
  return skillID == ___MOD._SkillBook.Heavens_Hammer_122_1221011
end

function PlayerAttackLogic.isShadowPartnerJobGroup(self, attacker)

end

function PlayerAttackLogic.isShootAttackSkill(self, skillID)
  if skillID == ___MOD._SkillBook.Three_Snails_000_1000 or skillID == ___MOD._SkillBook.Three_Snails_1000_10001000 or skillID == ___MOD._SkillBook.Three_Snails_2000_20001000 or skillID == ___MOD._SkillBook.Three_Snails_2001_20011000 or skillID == ___MOD._SkillBook.Taunt_422_4221003 or skillID == ___MOD._SkillBook.Soul_Blade_1110_11101004 or skillID == ___MOD._SkillBook.Combo_Smash_2110_21100004 or skillID == ___MOD._SkillBook.Combo_Fenrir_2111_21110004 or skillID == ___MOD._SkillBook.Shadow_Meso_411_4111004 or skillID == ___MOD._SkillBook.Shark_Wave_1511_15111007 then
    return true
  end
  return false
end

function PlayerAttackLogic.isSkillLtRbUnionBoxCheckSkipSkill(self, skillID)

end

function PlayerAttackLogic.logAttackHitCountServer(self, attacker, sad, hits, expectedHits)

end

function PlayerAttackLogic.logSkillLtRbUnionBoxMiss(self, attacker, mob, sad, skillLevelData, targetIndex)

end

function PlayerAttackLogic.makeHitDelayInfo(self, pa, ctx, afterimageSprites)
  local ret = {}
  local lastAttackDelay = 0

  local function insertAttackDelay(i, delay, applyPlayRate)
    local d = applyPlayRate and delay * ctx.playRate or delay
    ret[i] = d * 1000
    if i == 1 then
      lastAttackDelay = d
    end
  end

  local skillID = ctx.skillID
  if skillID == ___MOD._SkillBook.Spear_Crusher_131_1311001 or skillID == ___MOD._SkillBook.Pole_Arm_Crusher_131_1311002 then
    for i = 1, ctx.attackCount do
      local sd = ctx.skillData["effect" .. i]
      if sd ~= nil and sd.anim[1] ~= nil then
        insertAttackDelay(i, sd.anim[1].delay / 1000, true)
      end
    end
  elseif skillID == ___MOD._SkillBook.Savage_Blow_420_4201005 then
    local anim = ctx.skillData.effect and ctx.skillData.effect.anim
    if anim ~= nil then
      for i = 1, ctx.skillLevelData.attackCount do
        insertAttackDelay(i, 0.25 + 0.15 * (i - 1), true)
      end
    end
  elseif skillID == ___MOD._SkillBook.Magic_Claw_200_2001005 or skillID == ___MOD._SkillBook.Magic_Claw_1200_12001003 then
    insertAttackDelay(1, 0.36, true)
    insertAttackDelay(2, 0.48, true)
  elseif skillID == ___MOD._SkillBook.Arrow_Rain_1311_13111000 or skillID == ___MOD._SkillBook.Arrow_Rain_311_3111004 or skillID == ___MOD._SkillBook.Arrow_Eruption_321_3211004 then
    insertAttackDelay(1, 0.85, true)
  elseif skillID == ___MOD._SkillBook.Double_Stab_400_4001334 then
    insertAttackDelay(1, 0.4, true)
    insertAttackDelay(2, 0.52, true)
    lastAttackDelay = 0.4 * ctx.playRate
  elseif skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
    insertAttackDelay(1, 0.5, true)
    insertAttackDelay(2, 1.06, true)
    insertAttackDelay(3, 1.3, true)
  elseif skillID == ___MOD._SkillBook.Double_Uppercut_510_5101003 then
    insertAttackDelay(1, 0.3, true)
    insertAttackDelay(2, 0.78, true)
  elseif skillID == ___MOD._SkillBook.Brandish_112_1121008 or skillID == ___MOD._SkillBook.Brandish_1111_11111004 then
    insertAttackDelay(1, 0.36, true)
    insertAttackDelay(2, 0.72, true)
  elseif skillID == ___MOD._SkillBook.Demolition_512_5121004 then
    insertAttackDelay(1, 0, true)
    insertAttackDelay(2, 0.3, true)
    insertAttackDelay(3, 0.73, true)
    insertAttackDelay(4, 1.06, true)
    insertAttackDelay(5, 1.4, true)
    insertAttackDelay(6, 1.53, true)
    insertAttackDelay(7, 1.77, true)
    insertAttackDelay(8, 2.0, true)
  elseif skillID == ___MOD._SkillBook.Barrage_512_5121007 or skillID == ___MOD._SkillBook.Barrage_1511_15111004 then
    insertAttackDelay(1, 0.5, true)
    insertAttackDelay(2, 0.76, true)
    insertAttackDelay(3, 1.02, true)
    insertAttackDelay(4, 1.23, true)
    insertAttackDelay(5, 1.6, true)
    insertAttackDelay(6, 1.86, true)
  elseif skillID == ___MOD._SkillBook.Soul_Driver_1111_11111006 then
    insertAttackDelay(1, 1.8, true)
    insertAttackDelay(2, 1.95, true)
    insertAttackDelay(3, 2.1, true)
    insertAttackDelay(4, 2.25, true)
  elseif skillID == ___MOD._SkillBook.Vampire_1410_14101006 then
    insertAttackDelay(1, 1.8, true)
    insertAttackDelay(2, 1.98, true)
    insertAttackDelay(3, 2.43, true)
    insertAttackDelay(4, 2.79, true)
  elseif skillID == ___MOD._SkillBook.Combo_Tempest_2112_21120006 then
    insertAttackDelay(1, 2.88, true)
    insertAttackDelay(2, 3.08, true)
    insertAttackDelay(3, 3.28, true)
    insertAttackDelay(4, 3.48, true)
  elseif skillID == ___MOD._SkillBook.hidden_Full_Swing__Double_Swing_2111_21110007 or skillID == ___MOD._SkillBook.hidden_Over_Swing__Double_Swing_2112_21120009 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000014 then
    insertAttackDelay(1, 0, true)
    insertAttackDelay(2, 0.1, true)
  elseif skillID == ___MOD._SkillBook.hidden_Over_Swing__Triple_Swing_2112_21120010 or skillID == ___MOD._SkillBook.hidden_Full_Swing__Triple_Swing_2111_21110008 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000015 then
    insertAttackDelay(1, 0.33, true)
    insertAttackDelay(2, 0.43, true)
  elseif skillID == ___MOD._SkillBook.Fire_Arrow_210_2101004 or skillID == ___MOD._SkillBook.Fire_Arrow_1210_12101002 or skillID == ___MOD._SkillBook.Holy_Arrow_230_2301005 or skillID == ___MOD._SkillBook.Snipe_322_3221007 then
    insertAttackDelay(1, 0.6, true)
  elseif skillID == ___MOD._SkillBook.Final_Attack__Bow_310_3100001 or skillID == ___MOD._SkillBook.Final_Attack__Crossbow_320_3200001 then
    insertAttackDelay(1, 0.5, true)
  elseif ctx.afterimageInfo ~= nil then
    local delay = pa:getTargetSkillFrameTotalDelay(ctx.motion, ctx.startFrameIndex - 1, skillID)
    insertAttackDelay(1, delay, true)
  elseif afterimageSprites ~= nil then
    local i, totalDelay = 1, pa:getTargetSkillFrameTotalDelay(ctx.motion, ctx.startFrameIndex - 1, skillID)
    local fallbackTotalDelay = totalDelay
    for k, v in ___MOD.pairs(afterimageSprites) do
      if ___MOD.tonumber(k) and v ~= nil then
        fallbackTotalDelay = fallbackTotalDelay + v.delay / 1000
        if 1 < i then
          totalDelay = totalDelay + v.delay / 1000
        end
        if v.a1 == 0 then
          insertAttackDelay(i, totalDelay, true)
          i = i + 1
        end
      end
    end
    if #ret == 0 then
      insertAttackDelay(1, 0.23, true)
    end
  else
    if ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion) then
      return 0, 0
    end
    local delay = pa:getAttackDelay(ctx.motion)
    insertAttackDelay(1, delay[1] / 1000, true)
    if 1 < ctx.attackCount then
      insertAttackDelay(2, delay[2] / 1000, true)
    end
  end
  return ret, lastAttackDelay
end

function PlayerAttackLogic.notifyUserAttackLog(self, attacker, sad, totalDamage, targets, hits)

end

function PlayerAttackLogic.notifyUserAttackLogSummary(self, attacker, skillID, skillLevel, totalDamage, targets, hits, source, attackType)

end

function PlayerAttackLogic.onAttackClient(self, attacker, mob, damages)
  local totalDamage, deadlyAttack = mob.MobComponent:onAttackClient(attacker, damages)
  return totalDamage, deadlyAttack
end

function PlayerAttackLogic.onDamageByMob(self, attacker, mob, skillID, skillLevel, totalDelay, counter, damages)

end

function PlayerAttackLogic.onDamageByMobWithDamages(self, attacker, mob, damages, criticals, damageDelay, showDamage)

end

function PlayerAttackLogic.onDeadlyAttack(self, mob, delay)

end

function PlayerAttackLogic.onPlayerAttack(self, attacker, sad, senderUserId)

end

function PlayerAttackLogic.overrideComboTempestDamages(self, mob, damages, criticals)
  if not self:hasComboTempestTemporaryStat(mob) or not mob.MobComponent then
    return
  end
  local hit = false
  for i = 1, #damages do
    if 0 < damages[i] then
      hit = true
      break
    end
  end
  if not hit then
    return
  end
  local damage = mob.MobComponent.maxHP
  for i = 1, #damages do
    damages[i] = 0
    if criticals then
      criticals[i] = false
    end
  end
  if #damages <= 0 then
    damages[1] = damage
    if criticals then
      criticals[1] = false
    end
  else
    damages[1] = damage
  end
end

function PlayerAttackLogic.overrideSanctuaryDamages(self, mob, damages, criticals)
  if mob == nil or mob.MobComponent == nil or mob.MobComponent.boss then
    return
  end
  local currentHP = mob.MobComponent.HP or 0
  local damage = 0
  if 1 < currentHP then
    damage = currentHP - 1
  end
  for i = 1, #damages do
    damages[i] = 0
    if criticals ~= nil then
      criticals[i] = false
    end
  end
  if #damages == 0 then
    damages[1] = damage
    if criticals ~= nil then
      criticals[1] = false
    end
  else
    damages[1] = damage
  end
end

function PlayerAttackLogic.playSkillEffect(self, attacker, skillID, effectIndex, specialData, playRate, forceBackLayer)
  local offset = ___MOD.FastVector3.zero:Clone()
  if skillID == ___MOD._SkillBook.Double_Shot_500_5001003 then
    local direction = attacker.ExtendPlayerControllerComponent.LookDirectionX
    local x = direction == -1 and -0.36 or 0.36
    offset = offset + ___MOD.FastVector3(x, 0.24, 0)
  elseif skillID == ___MOD._SkillBook.Hypnotize_522_5221009 then
    local direction = attacker.ExtendPlayerControllerComponent.LookDirectionX
    local x = direction == -1 and -0.33 or 0.33
    offset = offset + ___MOD.FastVector3(x, 0.26, 0)
  elseif skillID == ___MOD._SkillBook.Burst_Fire_521_5210000 then
    local direction = attacker.ExtendPlayerControllerComponent.LookDirectionX
    local x = direction == -1 and -0.4 or 0.4
    offset = offset + ___MOD.FastVector3(x, 0.26, 0)
  elseif skillID == ___MOD._SkillBook.Blank_Shot_520_5201004 then
    local direction = attacker.ExtendPlayerControllerComponent.LookDirectionX
    local x = direction == -1 and -0.41 or 0.41
    offset = offset + ___MOD.FastVector3(x, 0.26, 0)
  end
  if attacker.PlayerActionComponent.isClimbing then
    offset.x = offset.x + 0.07
  end
  local target = attacker
  if skillID == ___MOD._SkillBook.Shockwave_1511_15111003 or skillID == ___MOD._SkillBook.Shockwave_511_5111006 or skillID == ___MOD._SkillBook.Flamethrower_521_5211004 or skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 then
    target = attacker.CurrentMap
    offset = attacker.TransformComponent:PositionAsFastVector3()
    if skillID == ___MOD._SkillBook.Flamethrower_521_5211004 or skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 then
      local direction = attacker.ExtendPlayerControllerComponent.LookDirectionX
      local x = direction == -1 and -0.36 or 0.36
      offset = offset + ___MOD.FastVector3(x, 0.24, 0)
    end
  end
  local ret = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, skillID, effectIndex, target, playRate, offset, specialData, false, attacker.ExtendPlayerControllerComponent.LookDirectionX == -1, nil, forceBackLayer, attacker)
  ___MOD._ExtendedEffectService:playSkillAnimationRemote(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, skillID, effectIndex, target, playRate, offset, specialData, false, attacker.ExtendPlayerControllerComponent.LookDirectionX == -1, nil, forceBackLayer, attacker)
  return ret
end

function PlayerAttackLogic.receiveAttackInfoClient(self, attackInfo)
  if self._T.attackInfo == nil then
    self._T.attackInfo = {
      tenSecondBySkill = {},
      recent = {}
    }
  end
  local state = self._T.attackInfo
  local now = ___MOD._UtilLogic.ElapsedSeconds
  local skillID = ___MOD.tonumber(attackInfo.skillID) or 0
  local skillLevel = ___MOD.tonumber(attackInfo.skillLevel) or 0
  local key = ___MOD.tostring(skillID) .. ":" .. ___MOD.tostring(skillLevel)
  local attackType = ___MOD.tonumber(attackInfo.attackType) or 0
  local attackDamage = ___MOD.tonumber(attackInfo.totalDamage) or 0
  local attackTargets = ___MOD.tonumber(attackInfo.targets) or 0
  local attackHits = ___MOD.tonumber(attackInfo.hits) or 0
  local attackerName = ___MOD.tostring(attackInfo.attackerName or "")
  local profileCode = ___MOD.tostring(attackInfo.profileCode or "")
  local source = ___MOD.tostring(attackInfo.source or "")
  if state.tenSecondBySkill == nil then
    state.tenSecondBySkill = {}
  end
  local tenStat = state.tenSecondBySkill[key]
  if tenStat == nil then
    tenStat = {
      startTime = now,
      skillID = skillID,
      skillLevel = skillLevel,
      attackCount = 0,
      totalDamage = 0,
      targets = 0,
      hits = 0,
      lastAttackerName = "",
      lastProfileCode = "",
      lastSource = "",
      lastAttackType = 0
    }
    state.tenSecondBySkill[key] = tenStat
  end
  tenStat.attackCount = tenStat.attackCount + 1
  tenStat.totalDamage = tenStat.totalDamage + attackDamage
  tenStat.targets = tenStat.targets + attackTargets
  tenStat.hits = tenStat.hits + attackHits
  tenStat.lastAttackerName = attackerName
  tenStat.lastProfileCode = profileCode
  tenStat.lastSource = source
  tenStat.lastAttackType = attackType
  local record = {
    time = now,
    skillID = skillID,
    skillLevel = skillLevel,
    attackType = attackType,
    attackDamage = attackDamage,
    attackTargets = attackTargets,
    attackHits = attackHits,
    attackerName = attackerName,
    profileCode = profileCode,
    source = source
  }
  state.recent[#state.recent + 1] = record
  while #state.recent > 120 do
    ___MOD.table.remove(state.recent, 1)
  end
  local chatMessage = ___MOD.string.format("[AttackInfo][%s] %s skill=%d lv=%d type=%d damage=%d targets=%d hits=%d", ___MOD.tostring(record.source), ___MOD.tostring(record.attackerName), record.skillID, record.skillLevel, record.attackType, record.attackDamage, record.attackTargets, record.attackHits)
  ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Yellow, chatMessage)
  if now - (___MOD.tonumber(tenStat.startTime) or now) >= 10 then
    local tenMessage = ___MOD.string.format("[AttackInfo10s][%s] %s skill=%d lv=%d type=%d uses=%d damage=%d targets=%d hits=%d", ___MOD.tostring(tenStat.lastSource), ___MOD.tostring(tenStat.lastAttackerName), tenStat.skillID, tenStat.skillLevel, ___MOD.tonumber(tenStat.lastAttackType) or 0, tenStat.attackCount, tenStat.totalDamage, tenStat.targets, tenStat.hits)
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, tenMessage)
    state.tenSecondBySkill[key] = nil
  end
end

function PlayerAttackLogic.recordSkillActionLog(self, attacker, sad, totalDamage)
  if not self:shouldLogAttackSkillUse(sad.skillID) then
    return
  end
  if attacker == nil or attacker.Player == nil or attacker.PlayerVariables == nil then
    return
  end
  local pv = attacker.PlayerVariables
  if pv.skillActionLogStats == nil then
    pv.skillActionLogStats = {}
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local stat = pv.skillActionLogStats[sad.skillID]
  if stat == nil then
    stat = {
      useCount = 0,
      totalDamage = 0,
      elapsedTime = 0,
      lastUseTime = now,
      delay = self:getSkillMinDelay(sad.skillID)
    }
    pv.skillActionLogStats[sad.skillID] = stat
  end
  if stat.useCount > 0 then
    stat.elapsedTime = stat.elapsedTime + ___MOD.math.max(0, now - (___MOD.tonumber(stat.lastUseTime) or now))
  end
  stat.lastUseTime = now
  stat.useCount = stat.useCount + 1
  stat.totalDamage = stat.totalDamage + totalDamage
  if stat.useCount >= 100 then
    local skillName = ___MOD._StringPoolManager:getSkillName(sad.skillID) or ___MOD.tostring(sad.skillID)
    ___MOD._AntiCheatService:SendActionLog(3, attacker.Player.UserId, {
      skillName,
      stat.delay,
      stat.useCount,
      stat.totalDamage,
      stat.elapsedTime
    })
    pv.skillActionLogStats[sad.skillID] = nil
  end
end

function PlayerAttackLogic.refreshSummonAttackAbleTimeClient(self, attacker)
  if attacker ~= ___MOD._UserService.LocalPlayer then
    return
  end
  if not (attacker ~= nil and ___MOD.isvalid(attacker.CurrentMap)) or attacker.CurrentMap.MapLifeComponent == nil then
    return
  end
  local summonPool = attacker.CurrentMap.MapLifeComponent.summonPool
  if summonPool == nil or summonPool.pool == nil then
    return
  end
  local attackAbleTime = ___MOD._UtilLogic.ElapsedSeconds + 30
  for _, summonEntity in ___MOD.pairs(summonPool.pool) do
    if ___MOD.isvalid(summonEntity) and summonEntity.SummonComponent ~= nil and summonEntity.SummonComponent.owner == attacker then
      summonEntity.SummonComponent:RefreshAttackAbleTime(attacker, attackAbleTime)
    end
  end
end

function PlayerAttackLogic.reserveAranComboGainOnFirstHit(self, attacker, skillID, totalDamage, mobCount, attackCount, firstHitDelay)

end

function PlayerAttackLogic.resetPendingHiddenAttackBoost(self, attacker)
  if attacker == nil or attacker.CalcDamageComponent == nil then
    return
  end
  attacker.CalcDamageComponent.windWalkAttackSkillLevel = 0
  attacker.CalcDamageComponent.vanishAttackSkillLevel = 0
  attacker.CalcDamageComponent.sparkAttackDamage = 0
end

function PlayerAttackLogic.setSkillMotion(self, attacker, skillData, skillID, skillLevel, weaponInfo, isFinalAttack, isShoot, remote)
  local action = skillData ~= nil and skillData.action or nil
  local skillLevelData = skillData ~= nil and skillData.level[skillLevel] or nil
  if isFinalAttack then
    return ___MOD._WeaponAttackMotion:getFinalAttackMotion(weaponInfo.weaponType), 0, true
  end
  local aranMotion, aranEffectIndex, aranPlayDefault = ___MOD._AranLogic:getBasicAttackMotion(attacker, skillID)
  if aranMotion then
    return aranMotion, aranEffectIndex, aranPlayDefault
  end
  local book = ___MOD._SkillBook
  local motion, effectIndex, playDefault = "", 0, false
  if action ~= nil then
    if skillID == book.Brandish_112_1121008 or skillID == book.Brandish_1111_11111004 then
      if weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_AXE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_MACE then
        motion = action["1"]
        effectIndex = 1
      else
        motion = action["0"]
      end
    else
      motion = action[___MOD.tostring(___MOD._GlobalRand32:randomIntegerRange(0, #action))]
      if motion == nil then
        motion = skillLevelData.action
      end
      if skillID == book.Steal_420_4201004 then
        playDefault = true
      end
    end
  else
    local isPowerKnockback = skillID == book.Power_KnockBack_310_3101003 or skillID == book.Power_KnockBack_320_3201003
    if skillID == book.Power_Strike_100_1001004 or skillID == 11001002 or skillID == book.Slash_Blast_100_1001005 or skillID == book.Slash_Blast_1100_11001003 or skillID == book.Double_Stab_400_4001334 or skillID == book.Disorder_400_4001002 or skillID == book.Disorder_1400_14001002 or ___MOD._SkillLogic:isComboFinishAttack(skillID) or skillID == book.Charged_Blow_121_1211002 or skillID == book.Sacrifice_131_1311005 then
      if not remote then
        motion = ___MOD._PlayerAttackLogic:getRandomAttackMotion(attacker, weaponInfo, false)
      end
      playDefault = true
    elseif skillID == book.Band_of_Thieves_421_4211004 then
      if not remote then
        motion = self:getRandomAttackMotion(attacker, weaponInfo, false)
      end
    elseif skillID == book.Lucky_Seven_400_4001344 or skillID == book.Triple_Throw_412_4121007 or skillID == book.Triple_throw_1411_14111005 or skillID == book.Lucky_Seven_1400_14001004 or skillID == book.Double_Shot_300_3001005 or skillID == book.Double_Shot_1300_13001003 or skillID == book.Arrow_Blow_300_3001004 or skillID == book.Cold_Beam_220_2201004 or skillID == book.Thunder_Bolt_220_2201005 or skillID == book.Drain_410_4101005 or skillID == book.Arrow_Bomb__Bow_310_3101005 or skillID == book.Iron_Arrow__Crossbow_320_3201005 or skillID == book.Invisible_Shot_520_5201001 or skillID == book.Strafe_311_3111006 or skillID == book.Strafe_321_3211006 or skillID == book.Strafe_1311_13111001 or skillID == book.Mortal_Blow_311_3110001 or skillID == book.Mortal_Blow_321_3210001 or skillID == book.Inferno_311_3111003 or skillID == book.Arrow_Rain_311_3111004 or skillID == book.Arrow_Rain_1311_13111000 or skillID == book.Blizzard_321_3211003 or skillID == book.Arrow_Eruption_321_3211004 or skillID == book.Shadow_Meso_411_4111004 then
      if not remote then
        motion = self:getRandomAttackMotion(attacker, weaponInfo, true)
      end
      playDefault = true
    elseif skillID == book.Three_Snails_000_1000 or skillID == book.Three_Snails_1000_10001000 or skillID == book.Three_Snails_2000_20001000 or skillID == book.Three_Snails_2001_20011000 or skillID == book.Energy_Bolt_200_2001004 or skillID == book.Magic_Claw_200_2001005 or skillID == book.Magic_Claw_1200_12001003 or skillID == book.Fire_Demon_212_2121003 or skillID == book.Ice_Demon_222_2221003 then
      if not remote then
        motion = self:getRandomAttackMotion(attacker, weaponInfo, true)
      end
    elseif skillID == book.Dragons_Breath_312_3121003 or skillID == book.Dragons_Breath_322_3221003 or skillID == book.Snipe_322_3221007 then
      local m = "shoot1"
      if weaponInfo.weaponType == ___MOD._WeaponType.CROSSBOW then
        m = "shoot2"
      end
      motion = m
    elseif skillID == book.Hypnotize_522_5221009 then
      motion = "shot"
    elseif isPowerKnockback then
      local l = {}
      if weaponInfo.weaponType == ___MOD._WeaponType.BOW then
        l = {"swingT1", "swingT3"}
      elseif weaponInfo.weaponType == ___MOD._WeaponType.CROSSBOW then
        l = {"swingT1", "stabT1"}
      end
      local hitIndex = ___MOD._GlobalRand32:randomIntegerRange(1, #l)
      motion = l[hitIndex]
    elseif skillID == 0 then
      if not remote then
        motion = self:getRandomAttackMotion(attacker, weaponInfo, isShoot)
      end
      playDefault = true
    else
      motion = skillLevelData.action
    end
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(motion) and (skillID == book.Big_Bang_212_2121001 or skillID == book.Big_Bang_222_2221001 or skillID == book.Big_Bang_232_2321001) then
    motion = "magic6"
  end
  return motion, effectIndex, playDefault
end

function PlayerAttackLogic.setUserAttackLogWatcher(self, watcherUserId, targetProfileCode, targetName)

end

function PlayerAttackLogic.shouldCheckAttackSkillCooldown(self, skillID, skillData, skillLevelData)
  if skillID <= 0 or skillLevelData == nil then
    return false
  end
  local cooldownSec = ___MOD._PlayerSkillLogic:getSkillLevelDataCooltimeSec(skillLevelData, skillID)
  if cooldownSec <= 0 then
    return false
  end
  if skillData ~= nil and skillData.summon ~= nil then
    return false
  end
  return true
end

function PlayerAttackLogic.shouldDisplayDamageByAttacker(self, attacker)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not localPlayer or not localPlayer.UISystemOptionComponent then
    return true
  end
  return attacker == localPlayer or localPlayer.UISystemOptionComponent.enableOtherDamageDisplay
end

function PlayerAttackLogic.shouldEnforceHitCountByJob(self, attacker)

end

function PlayerAttackLogic.shouldLogAttackSkillUse(self, skillID)
  if skillID <= 0 then
    return false
  end
  if skillID == ___MOD._SkillBook.Spark_1511_15111006 then
    return false
  end
  if ___MOD._SkillLogic:isKeyDownSkill(skillID) then
    return false
  end
  return true
end

function PlayerAttackLogic.shouldLogSkillActionLockEarly(self, pv, now, remain, serverDelay, clientDelay)
  local softGrace = self:getSkillActionLockSoftGrace(serverDelay, clientDelay)
  if remain <= softGrace then
    pv.serverActionLockEarlyCount = 0
    pv.serverActionLockEarlyWindowStart = 0
    pv.serverActionLockEarlyMaxRemain = 0
    return false
  end
  local windowStart = ___MOD.tonumber(pv.serverActionLockEarlyWindowStart) or 0
  if windowStart <= 0 or 5 < now - windowStart then
    pv.serverActionLockEarlyWindowStart = now
    pv.serverActionLockEarlyCount = 0
    pv.serverActionLockEarlyMaxRemain = 0
  end
  pv.serverActionLockEarlyCount = pv.serverActionLockEarlyCount + 1
  pv.serverActionLockEarlyMaxRemain = ___MOD.math.max(___MOD.tonumber(pv.serverActionLockEarlyMaxRemain) or 0, remain)
  local strongGrace = self:getSkillActionLockStrongGrace(serverDelay, clientDelay)
  if remain > strongGrace and pv.serverActionLockEarlyCount >= 2 then
    return true
  end
  return pv.serverActionLockEarlyCount >= 3
end

function PlayerAttackLogic.shouldSkipSkillActionLockServerCheck(self, sad)
  if sad.skillID == ___MOD._SkillBook.Spark_1511_15111006 then
    return true
  end
  if sad.finalAttackSkillID > 0 or sad.finishAttack or self:isFinalAttackActionLockSkill(sad.skillID) then
    return true
  end
  if sad.skillID == ___MOD._SkillBook.Explosion_211_2111002 or sad.skillID == ___MOD._SkillBook.Big_Bang_212_2121001 or sad.skillID == ___MOD._SkillBook.Big_Bang_222_2221001 or sad.skillID == ___MOD._SkillBook.Big_Bang_232_2321001 then
    return true
  end
  if ___MOD._SkillLogic:isKeyDownSkill(sad.skillID) then
    return true
  end
  return false
end

function PlayerAttackLogic.shouldSkipSkillLtRbUnionBoxCheck(self, sad, targetIndex)

end

function PlayerAttackLogic.shouldUseClientHitCount(self, attackType)
  return attackType == ___MOD._SkillAttackType.Magic or attackType == ___MOD._SkillAttackType.Skill or attackType == ___MOD._SkillAttackType.Summon
end

function PlayerAttackLogic.truncateAttackHitsServer(self, targetData, hitLimit)

end

function PlayerAttackLogic.tryApplyAllPotentialOnHit(self, attacker, mob)

end

function PlayerAttackLogic.tryApplyPotentialAutoStealOnHit(self, attacker, mob)

end

function PlayerAttackLogic.tryApplyPotentialDarknessOnHit(self, attacker, mob)

end

function PlayerAttackLogic.tryApplyPotentialFreezeOnHit(self, attacker, mob)

end

function PlayerAttackLogic.tryApplyPotentialPoisonOnHit(self, attacker, mob)

end

function PlayerAttackLogic.tryApplyPotentialRecoverOnHit(self, attacker)

end

function PlayerAttackLogic.tryApplyPotentialRecoverOnKill(self, user)

end

function PlayerAttackLogic.tryApplyPotentialSealOnHit(self, attacker, mob)

end

function PlayerAttackLogic.tryApplyPotentialSlowOnHit(self, attacker, mob)

end

function PlayerAttackLogic.tryApplyPotentialStunOnHit(self, attacker, mob)

end

function PlayerAttackLogic.tryApplyUnidentifiedPotentialDropByMob(self, mob, equip)

end

function PlayerAttackLogic.tryMobKnockback(self, attacker, mob, skillID, skillLevel, totalDelay, totalDamage, deadlyAttack, highestDamage, isMelee, weaponInfo, attackerPosSnapshot, mobPosSnapshot, hitIndex, playerInputX)

end

function PlayerAttackLogic.tryPlayerAttack(self, attacker, skillID, skillLevel, isMeleeAttack, chargePer, forceTarget)
  local pa = attacker.PlayerActionComponent
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local ts = attacker.PlayerTemporaryStatComponent
  self:resetPendingHiddenAttackBoost(attacker)
  local darkSightSkillID = 0
  local vanishSkillLevel = 0
  if ts:getTemporaryStatData(___MOD._CTS.DarkSight) ~= nil then
    darkSightSkillID = ts:getSkillID(___MOD._CTS.DarkSight)
    vanishSkillLevel = self:canUseVanishAttackBoost(attacker) and attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Vanish_1410_14100005) or 0
    if vanishSkillLevel <= 0 and skillID ~= ___MOD._SkillBook.Assaulter_421_4211002 and skillID ~= ___MOD._SkillBook.Assassinate_422_4221001 then
      ts:resetTemporaryStat(darkSightSkillID)
      pa.enableNextAttackTime = now + 0.25
      return false
    end
  end
  if pa.isClimbing or pa.isAttacking or pa.sitting then
    return false
  end
  if ___MOD._PlayerAttackLogic:isProneAttackBlockedSkill(skillID) and ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.DownArrow) then
    return false
  end
  if ___MOD._PlayerSkillLogic:shouldBlockOtherActionByExclusiveKeydown(attacker, skillID, false) then
    return false
  end
  if pa.enableNextAttackTime ~= 0 and now < pa.enableNextAttackTime or now < pa.enableNextBuffTime + 0.2 then
    return false
  end
  if attacker.Player:isDead() then
    return false
  end
  if not ___MOD._PlayerSkillLogic:isBattleshipMounted(attacker) and attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.TamingMob) ~= 0 then
    return false
  end
  if ___MOD._PlayerSkillLogic:isBattleshipMounted(attacker) then
    if skillID == 0 then
      return false
    end
    if not ___MOD._PlayerSkillLogic:canUseSkillOnBattleship(skillID) then
      return false
    end
  end
  if ___MOD._SkillLogic:isRushAttackSkill(skillID) and not attacker.RigidbodyComponent:IsOnGround() then
    return false
  end
  if skillID == 0 then
    local ts = attacker.PlayerTemporaryStatComponent
    local morphSkillId = ts:getSkillID(___MOD._CTS.Morph)
    if morphSkillId == 5101007 then
      attacker.PlayerTemporaryStatComponent:resetTemporaryStat(morphSkillId)
      pa.enableNextAttackTime = now + 0.5
      return false
    end
  end
  if not self:checkCanAttack(attacker, skillID) then
    return false
  end
  local weaponInfo = self:getWeaponInfo(attacker)
  local isPirate = attacker.Player.Job >= 500 and attacker.Player.Job <= 532 or attacker.Player.Job >= 1500 and attacker.Player.Job <= 1512
  local ignoreValidCheck = isPirate and skillID ~= ___MOD._SkillBook.Double_Shot_500_5001003
  if weaponInfo.disabled or not weaponInfo.valid and not ignoreValidCheck then
    pa:displayAttackMessage("무기를 장착하지 않아 공격할 수 없습니다.")
    pa.enableNextAttackTime = now + 0.1
    return false
  end
  if not ___MOD._PlayerSkillLogic:checkCanUseSkillByWeapon(skillID, weaponInfo) then
    pa.enableNextAttackTime = now + 0.1
    return
  end
  local attackType = self:getAttackType(attacker, skillID, weaponInfo)
  local forceAction = ""
  local forcedTarget = forceTarget
  if skillID ~= ___MOD._SkillBook.Mortal_Blow_311_3110001 and skillID ~= ___MOD._SkillBook.Mortal_Blow_321_3210001 and skillID ~= ___MOD._SkillBook.Piercing_Arrow_322_3221001 and attackType == ___MOD._SkillAttackType.Shoot then
    local motion = self:getRandomAttackMotion(attacker, weaponInfo, false)
    local startFrameIndex = attacker.AfterImageComponent:getAfterImageData2(motion)
    if startFrameIndex ~= nil then
      ___MOD.box = attacker.AfterImageComponent:makeAfterImageBox(motion)
      local reactor = ___MOD._PlayerAttackLogic:findValidHitReactor(attacker, ___MOD.box.Position, ___MOD.box.Size, ___MOD.box.Angle)
      if reactor ~= nil and skillID == 0 then
        forceAction = motion
        isMeleeAttack = true
      end
      if (weaponInfo.weaponType == ___MOD._WeaponType.BOW or weaponInfo.weaponType == ___MOD._WeaponType.CROSSBOW or weaponInfo.weaponType == ___MOD._WeaponType.CLAW) and skillID ~= ___MOD._SkillBook.Arrow_Eruption_321_3211004 and skillID ~= ___MOD._SkillBook.Arrow_Rain_311_3111004 and skillID ~= ___MOD._SkillBook.Arrow_Rain_1311_13111000 and skillID ~= ___MOD._SkillBook.Power_KnockBack_310_3101003 and skillID ~= ___MOD._SkillBook.Power_KnockBack_320_3201003 and skillID ~= ___MOD._SkillBook.Dragons_Breath_312_3121003 and skillID ~= ___MOD._SkillBook.Dragons_Breath_322_3221003 and skillID ~= ___MOD._SkillBook.Avenger_411_4111005 and skillID ~= ___MOD._SkillBook.Avenger_1411_14111002 and not ___MOD._PlayerAttackLogic_Shoot:isNotMeleeAttackByNearMob(skillID) then
        if ___MOD.Environment:IsMakerPlay() then
          ___MOD._ColliderUtils:d(attacker.CurrentMap, 9101, ___MOD.box)
        end
        ___MOD.box.Size = ___MOD.box.Size * 0.8
        local mobs = ___MOD._PlayerAttackLogic:findValidMobs(attacker, ___MOD.box.Position, ___MOD.box.Size, ___MOD.box.Angle, 1, false, 0.7)
        if 0 < #mobs then
          forcedTarget = mobs[1]
          local job = attacker.Player.Job
          local mortalID = 0
          if job == 311 or job == 312 then
            mortalID = ___MOD._SkillBook.Mortal_Blow_311_3110001
          elseif job == 321 or job == 322 then
            mortalID = ___MOD._SkillBook.Mortal_Blow_321_3210001
          end
          if mortalID ~= 0 then
            local mortalSLV = attacker.SkillComponent:getSkillLevel(mortalID)
            if 0 < mortalSLV then
              local mortalLevel = ___MOD._SkillManager:getSkillLevelData(mortalID, mortalSLV)
              if mortalLevel ~= nil then
                local prop = mortalLevel.prop
                if prop >= ___MOD._GlobalRand32:randomIntegerRange(1, 100) then
                  ___MOD._PlayerAttackLogic:tryPlayerAttack(attacker, mortalID, mortalSLV, false, 0.0, nil)
                  return
                end
              end
            end
          end
          forceAction = motion
          isMeleeAttack = true
          skillID = 0
          skillLevel = 0
        end
      end
    end
  end
  if darkSightSkillID ~= 0 then
    ts:resetTemporaryStat(darkSightSkillID)
    if 0 < vanishSkillLevel and attacker.CalcDamageComponent ~= nil then
      attacker.CalcDamageComponent.vanishAttackSkillLevel = vanishSkillLevel
    end
  end
  if ts:getTemporaryStatData(___MOD._CTS.WindWalk) ~= nil then
    local windWalkSkillID = ts:getSkillID(___MOD._CTS.WindWalk)
    local windWalkSkillLevel = ts:getSkillLevel(___MOD._CTS.WindWalk)
    if windWalkSkillLevel <= 0 then
      windWalkSkillLevel = attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Wind_Walk_1310_13101006)
    end
    ts:resetTemporaryStat(windWalkSkillID)
    if attacker.CalcDamageComponent ~= nil then
      attacker.CalcDamageComponent.windWalkAttackSkillLevel = windWalkSkillLevel
    end
  end
  ___MOD._PlayerUpdateLogic.HP_dt = 0
  local result = false
  if attackType == ___MOD._SkillAttackType.Shoot and not isMeleeAttack then
    result = ___MOD._PlayerAttackLogic_Shoot:tryShootAttack(attacker, skillID, skillLevel, pa, weaponInfo, false, chargePer, weaponInfo.attackType == ___MOD._WeaponAttackType.MAGIC, forcedTarget)
  elseif attackType == ___MOD._SkillAttackType.Melee or isMeleeAttack then
    result = ___MOD._PlayerAttackLogic_Melee:tryMeleeAttack(attacker, skillID, skillLevel, pa, weaponInfo, false, chargePer, forceAction, false, nil, forcedTarget)
  elseif attackType == ___MOD._SkillAttackType.Magic then
    result = ___MOD._PlayerAttackLogic_Magic:tryMagicAttack(attacker, skillID, skillLevel, pa, weaponInfo, false, chargePer)
  end
  if not result then
    self:resetPendingHiddenAttackBoost(attacker)
  end
  return result
end

function PlayerAttackLogic.trySparkChainAttack(self, attacker, sourceSkillID, sourceMobs, baseDelayMs)
  if attacker == nil or attacker.PlayerTemporaryStatComponent == nil or attacker.SkillComponent == nil or attacker.CalcDamageComponent == nil then
    return
  end
  if sourceSkillID == ___MOD._SkillBook.Spark_1511_15111006 or sourceMobs == nil or #sourceMobs <= 0 then
    return
  end
  local sparkDamage = ___MOD.tonumber(attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Spark)) or 0
  if sparkDamage <= 0 then
    return
  end
  local sparkSkillID = ___MOD._SkillBook.Spark_1511_15111006
  local sparkSkillLevel = ___MOD.tonumber(attacker.PlayerTemporaryStatComponent:getSkillLevel(___MOD._CTS.Spark)) or 0
  if sparkSkillLevel <= 0 then
    sparkSkillLevel = attacker.SkillComponent:getSkillLevel(sparkSkillID)
  end
  if sparkSkillLevel <= 0 then
    return
  end
  local sparkLevelData = ___MOD._SkillManager:getSkillLevelData(sparkSkillID, sparkSkillLevel)
  if sparkLevelData == nil then
    return
  end
  local maxCount = ___MOD.math.tointeger(___MOD.tonumber(sparkLevelData.mobCount) or 0) or 0
  if maxCount <= 0 then
    return
  end
  local sourceMob
  for _, mob in ___MOD.ipairs(sourceMobs) do
    if ___MOD.isvalid(mob) and mob.MobComponent ~= nil and not mob.MobComponent:isDead() then
      sourceMob = mob
      break
    end
  end
  if sourceMob == nil then
    return
  end

  local function getMobCenterWorldPos(mob)
    return self:getMobVisualCenterWorldPos(mob)
  end

  local step = 0.5
  local mapleRange = ___MOD.tonumber(sparkLevelData.range) or 300
  local range = mapleRange / 100
  local delay = 0.1
  local playerInputX = attacker.PlayerControllerComponent.LookDirectionX
  local isFaceLeft = playerInputX == -1
  local mobs = {}
  local attackDelays = {}
  local chains = {}
  local sourcePosition = getMobCenterWorldPos(sourceMob)
  local verticalAdjustRange = ___MOD._DamageDecRate:getVerticalAdjustOfAttackRange(sparkSkillID)
  local baseRectHeight = 0.01
  local firstSearchCenterX = sourcePosition.x + (isFaceLeft and -range * 0.5 or range * 0.5)
  local firstSearchCenterY = sourcePosition.y - baseRectHeight * 0.5
  local firstSearchHeight = baseRectHeight + verticalAdjustRange * 2 / 100
  local firstSearchBox = ___MOD.BoxShape(___MOD.Vector2(firstSearchCenterX, firstSearchCenterY), ___MOD.Vector2(range, firstSearchHeight), 0)
  local firstSearchMobs = {}
  local firstSearchRawCount = ___MOD._FindMobLogic:findHitMobInRect(firstSearchBox, firstSearchMobs, 1, sourceMob, 0, 0, 0, false, attacker)
  local firstSearchCount = firstSearchRawCount & 65535
  if firstSearchCount ~= 1 then
    return
  end
  local firstSparkMob = firstSearchMobs[1]
  if not ___MOD.isvalid(firstSparkMob) then
    return
  end
  local chainMobs = {}
  local chainMobCount = ___MOD._FindMobLogic:findHitMobByChainLightning(firstSparkMob, chainMobs, maxCount, isFaceLeft, range, attacker)
  if chainMobCount <= 0 then
    return
  end
  local previousCenter = getMobCenterWorldPos(sourceMob)
  local baseDelay = ___MOD.math.max(0, (baseDelayMs or 0) / 1000)
  for i = 1, chainMobCount do
    local nextMob = chainMobs[i]
    local nextCenter = getMobCenterWorldPos(nextMob)
    mobs[#mobs + 1] = nextMob
    attackDelays[#attackDelays + 1] = baseDelay + i * delay
    chains[#chains + 1] = {previousCenter, nextCenter}
    previousCenter = nextCenter
  end
  local damages = {}
  local criticals = {}
  local damageDelays = {}
  local attackerPosSnapshot = attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
  local sparkSkillData = ___MOD._SkillManager:getSkill(sparkSkillID)
  attacker.CalcDamageComponent.sparkAttackDamage = sparkDamage
  for i = 1, #mobs do
    local mob = mobs[i]
    local attackDelay = attackDelays[i]
    local damageDelays_ = {
      ___MOD.math.floor(attackDelay * 1000 + 0.5)
    }
    local damages_, criticals_, highestDamage = self:calcDamageClient(attacker, mob, sparkSkillID, sparkSkillLevel, 1, damageDelays_, "", 0, 0, 0, i, 0.0, false)
    damages[i] = damages_
    criticals[i] = criticals_
    damageDelays[i] = damageDelays_
    ___MOD._TimerService:SetTimerOnce(function()
      if not ___MOD.isvalid(mob) then
        return
      end
      local chain = chains[i]
      if chain ~= nil then
        ___MOD._PlayerAttackLogic_Magic:spawnChainLineTo(chain[1], chain[2], step, nil, nil, nil, attacker, sparkSkillID)
      end
      local hitAnimData = sparkSkillData ~= nil and (sparkSkillData.hit or sparkSkillData.hit0) or nil
      if hitAnimData ~= nil then
        local mobCenter = getMobCenterWorldPos(mob)
        local mobOrigin = mob.TransformComponent:WorldPositionAsFastVector3()
        local hitOffset = ___MOD.FastVector3(mobCenter.x - mobOrigin.x, mobCenter.y - mobOrigin.y, 0)
        local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, sparkSkillID, 0, mob, 1.0, hitOffset, hitAnimData, false, isFaceLeft, nil)
        ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
      end
      ___MOD._PlayerAttackLogic_Melee:playAttackSound(attacker, mob, sparkSkillID, mob.MobComponent.overrideMobID ~= 0 and mob.MobComponent.overrideMobID or mob.MobComponent.id)
    end, attackDelay)
    self:displaySkillDamageByAttackerClient(attacker, mob, sparkSkillID, damages_, criticals_, damageDelays_)
    local totalDamage, deadlyAttack = self:onAttackClient(attacker, mob, damages_)
  end
  attacker.CalcDamageComponent.sparkAttackDamage = 0
  local sad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(sparkSkillID, sparkSkillLevel, attackerPosSnapshot, playerInputX, #mobs, 1, "", ___MOD._SkillAttackType.Melee, mobs, damages, criticals, damageDelays, damageDelays[1][1], 1.0, isFaceLeft, 0, 0, 0, 0, 0, chains, 0.0, false, nil)
  sad.sparkDamage = sparkDamage
  self:onPlayerAttack(attacker, sad:toTable())
end

function PlayerAttackLogic.validateSkillActionLockServer(self, attacker, sad, now)
  if attacker == nil or attacker.PlayerVariables == nil or self:shouldSkipSkillActionLockServerCheck(sad) then
    return
  end
  local pv = attacker.PlayerVariables
  local fallbackDelay = self:getServerActionLockFallbackDelay(sad)
  local prepareDelay = self:getServerActionLockPrepareDelay(sad)
  local serverDelay = ___MOD._PlayerSkillLogic:getSkillActionLockDelaySec(attacker, sad.skillID, sad.motion, fallbackDelay, prepareDelay)
  local clientDelay = ___MOD.tonumber(sad.clientActionLockDelay) or 0
  if serverDelay <= 0 and clientDelay <= 0 then
    return
  end
  local nextAllowed = ___MOD.tonumber(pv.serverNextAttackTime) or 0
  local remain = nextAllowed - now
  local isEarly = self:shouldLogSkillActionLockEarly(pv, now, remain, serverDelay, clientDelay)
  local userID = 0
  if attacker.Player ~= nil then
    userID = attacker.Player.UserId
  end
  if isEarly then
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD.log_warning("[ActionLock][S][EARLY]", "user", userID, "skill", sad.skillID, "motion", sad.motion or "", "remain", remain, "serverLock", serverDelay, "clientLock", clientDelay, "first", sad.firstAttackDelay, "count", pv.serverActionLockEarlyCount, "maxRemain", pv.serverActionLockEarlyMaxRemain, "next", nextAllowed, "now", now)
    end
    ___MOD._WorldLogService:logHack(attacker, -30000, ___MOD.string.format([[
  [ActionLock][S][EARLY]

  User : %d
  Skill : %d
  Motion : %s
  Remain : %.3f
  ServerLock : %.3f
  ClientLock : %.3f
  FirstAttackDelay : %d
  EarlyCount : %d
  MaxRemain : %.3f
  NextAllowed : %.3f
  Now : %.3f
  LastServerLock : %.3f]], userID, sad.skillID, sad.motion or "", remain, serverDelay, clientDelay, ___MOD.tonumber(sad.firstAttackDelay) or 0, ___MOD.tonumber(pv.serverActionLockEarlyCount) or 0, ___MOD.tonumber(pv.serverActionLockEarlyMaxRemain) or 0, nextAllowed, now, ___MOD.tonumber(pv.serverLastActionLockDelay) or 0))
  end
  if 0 < serverDelay then
    pv.serverNextAttackTime = now + serverDelay
    pv.serverLastActionLockDelay = serverDelay
  end
end
