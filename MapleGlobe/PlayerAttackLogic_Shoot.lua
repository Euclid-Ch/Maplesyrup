

function PlayerAttackLogic_Shoot.afterAttack(self, attacker, skillID, skillLevel, totalDamage, mobCount, attackCount)

end

function PlayerAttackLogic_Shoot.afterAttackMob(self, attacker, mob, skillID, skillLevel, totalDamage, deadlyAttack, delay)

end

function PlayerAttackLogic_Shoot.calcPoisonTickDamage(self, mobMaxHP, skillLevel)
  local ratio = 1.0E-5 * skillLevel * skillLevel + 2.3E-4 * skillLevel + 0.02154
  local dmg = mobMaxHP * ratio
  return ___MOD.math.max(1, ___MOD.math.floor(dmg + 0.5))
end

function PlayerAttackLogic_Shoot.canIgnoreStartFootholdBlockSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Angel_Ray_232_2321007 or skillID == ___MOD._SkillBook.Holy_Arrow_230_2301005 or skillID == ___MOD._SkillBook.Paralyze_212_2121006 or skillID == ___MOD._SkillBook.Fire_Arrow_210_2101004 or skillID == ___MOD._SkillBook.Fire_Arrow_1210_12101002 or skillID == ___MOD._SkillBook.Element_Composition_211_2111006 or skillID == ___MOD._SkillBook.Element_Composition_221_2211006 or skillID == ___MOD._SkillBook.Avenger_411_4111005 or skillID == ___MOD._SkillBook.Avenger_1411_14111002 or skillID == ___MOD._SkillBook.Hurricane_312_3121004 or skillID == ___MOD._SkillBook.Piercing_Arrow_322_3221001 or skillID == ___MOD._SkillBook.Cold_Beam_220_2201004 or skillID == ___MOD._SkillBook.Fire_Demon_212_2121003 or skillID == ___MOD._SkillBook.Ice_Demon_222_2221003 or skillID == ___MOD._SkillBook.Fire_Strike_1211_12111006
end

function PlayerAttackLogic_Shoot.canShootAttack(self, attacker, skillID)
  local job = attacker.Player.Job
  if (300 <= job and job <= 322 or 1300 <= job and job <= 1322 or skillID == ___MOD._SkillBook.Three_Snails_000_1000 or skillID == ___MOD._SkillBook.Three_Snails_1000_10001000 or skillID == ___MOD._SkillBook.Three_Snails_2000_20001000 or skillID == ___MOD._SkillBook.Three_Snails_2001_20011000 or skillID == ___MOD._SkillBook.Battleship_Cannon_522_5221007 or skillID == ___MOD._SkillBook.Battleship_Torpedo_522_5221008) and not attacker.ExtendPlayerControllerComponent.inSwimMap and not attacker.RigidbodyComponent:IsOnGround() then
    return false
  end
  return true
end

function PlayerAttackLogic_Shoot.checkUseConsumeClient(self, player, skillID, skillLevelData, bulletItemID, bulletCount, consumeBulletCount)
  local pa = player.PlayerActionComponent
  local inventory = player.CInventoryComponent
  local job = player.Player.Job
  local itemType = "표창"
  local shadowPartner = 1
  if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.ShadowPartner) ~= 0 and skillID ~= ___MOD._SkillBook.Shadow_Stars_412_4121006 then
    shadowPartner = 2
  end
  if skillID == ___MOD._SkillBook.Shadow_Meso_411_4111004 then
    consumeBulletCount = 0
  end
  if skillID == ___MOD._SkillBook.Taunt_422_4221003 then
    consumeBulletCount = 0
  end
  if skillID == ___MOD._SkillBook.Combo_Smash_2110_21100004 or skillID == ___MOD._SkillBook.Combo_Fenrir_2111_21110004 then
    consumeBulletCount = 0
  end
  if skillID == ___MOD._SkillBook.Rapid_Fire_522_5221004 then
    consumeBulletCount = 1
  end
  if skillID == ___MOD._SkillBook.Flamethrower_521_5211004 then
    local item = 2331000
    if 0 >= inventory:getItemCount(item) then
      bulletCount = 1
    end
  elseif skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 then
    local item = 2332000
    if 0 >= inventory:getItemCount(item) then
      bulletCount = 1
    end
  end
  if consumeBulletCount ~= 0 and (bulletItemID == 0 or consumeBulletCount > bulletCount) then
    bulletItemID, bulletCount = inventory:findFirstThrowing(consumeBulletCount)
  end
  if (skillID == ___MOD._SkillBook.Shadow_Stars_412_4121006 or player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.NonComsumeBullet) == 0) and consumeBulletCount ~= 0 and (bulletItemID == 0 or consumeBulletCount > bulletCount) and not ___MOD._PlayerAttackLogic:isShootAttackSkill(skillID) then
    itemType = "표창"
    if ___MOD._SkillLogic:getJobClass(job) == 5 then
      itemType = "불릿"
    elseif ___MOD._SkillLogic:getJobClass(job) == 3 then
      itemType = "화살"
    end
    pa:displayAttackMessage(___MOD.string.format("%s을 모두 소비하였습니다.", itemType))
    if not ___MOD._PlayerSkillLogic:isBattleshipMounted(player) then
      ___MOD._PlayerAttackLogic:tryPlayerAttack(player, 0, 0, true, 0.0)
    end
    return -1
  end
  local sld = skillLevelData
  if skillID ~= 0 then
    local s = player.Player
    local hpCon = sld.hpCon
    if 0 < hpCon and hpCon > s.HP then
      pa:displayAttackMessage("스킬을 사용하는 데 필요한 HP가 부족합니다.")
      return -2
    end
    local mpCon = sld.mpCon
    if player.QuestComponent:getQuestEx(99999, "fj") == "1" and ___MOD._PlayerSkillLogic:isDoubleJumpSkill(skillID) then
      mpCon = 0
    end
    if 0 < mpCon and player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Infinity) == 0 then
      local amp, incMP = ___MOD._CalcDamageLogic:getAmplification(player, skillID)
      if amp ~= 100 then
        mpCon = mpCon * (incMP * 0.01)
      end
      local concentrate = player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Concentrate)
      if concentrate ~= 0 then
        local delta = mpCon * 0.01 * concentrate
        mpCon = ___MOD.math.max(0, mpCon - delta)
      end
      if mpCon > s.MP then
        pa:displayAttackMessage("스킬을 사용하는 데 필요한 MP가 부족합니다.")
        return -2
      end
    end
    local bulletConsume = sld.bulletConsume
    if skillID == ___MOD._SkillBook.Combo_Smash_2110_21100004 or skillID == ___MOD._SkillBook.Combo_Fenrir_2111_21110004 then
      bulletConsume = 0
    end
    if skillID == ___MOD._SkillBook.Rapid_Fire_522_5221004 then
      bulletConsume = 1
    end
    if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 and skillID ~= ___MOD._SkillBook.Shadow_Stars_412_4121006 then
      bulletConsume = 0
    end
    if 0 < bulletConsume then
      if bulletCount < bulletConsume then
        bulletItemID, bulletCount = inventory:findFirstThrowing(bulletConsume)
      end
      if bulletConsume > bulletCount then
        pa:displayAttackMessage(___MOD.string.format("스킬을 사용하는 데 필요한 %s이 부족합니다.", itemType))
        return -2
      end
    end
    local itemConsume = sld.itemConsume
    if itemConsume ~= 0 then
      local itemConsumeAmount = sld.itemConsumeAmount
      if itemConsumeAmount > inventory:getItemCount(itemConsume) then
        local itemName = ___MOD._StringPoolManager:getItemName(itemConsume)
        pa:displayAttackMessage(___MOD.string.format("스킬을 사용하는 데 필요한 %s의 개수가 부족합니다.", itemName))
        return -2
      end
    end
    local moneyConsume = sld.moneyConsume * shadowPartner
    if moneyConsume ~= 0 and moneyConsume > inventory:getMeso() then
      pa:displayAttackMessage("스킬을 사용하는 데 필요한 메소가 부족합니다.")
      return -2
    end
    if skillID == ___MOD._SkillBook.Dragon_Roar_131_1311006 or skillID == ___MOD._SkillBook.Super_Dragon_Roar_900_9001001 or skillID == ___MOD._SkillBook.Super_Dragon_Roar_900_9001006 then
      local deltaHP = ___MOD.math.floor(50 * ((s.MaxHP + player.PlayerSecondaryAbilityComponent.MaxHP) * 0.01))
      if deltaHP > s.HP then
        pa:displayAttackMessage("스킬을 사용하는 데 필요한 HP가 부족합니다.")
        return -2
      end
    elseif skillID == ___MOD._SkillBook.MP_Recovery_510_5101005 then
      local x = skillLevelData.x
      local maxHP = player.Player.MaxHP + player.PlayerSecondaryAbilityComponent.MaxHP
      local deltaHP = maxHP * 0.01 * x
      if deltaHP > s.HP then
        pa:displayAttackMessage("스킬을 사용하는 데 필요한 HP가 부족합니다.")
        return -2
      end
    elseif ___MOD._SkillLogic:isComboFinishAttack(skillID) then
      if 0 >= player.ComboComponent.comboCount then
        return -3
      end
    elseif skillID == ___MOD._SkillBook.Chakra_421_4211001 then
      local maxHP = player.Player.MaxHP + player.PlayerSecondaryAbilityComponent.MaxHP
      local halfHP = maxHP * 0.5
      if halfHP < player.Player.HP then
        return -2
      end
    elseif skillID == ___MOD._SkillBook.Charged_Blow_121_1211002 and player.AfterImageComponent.chargeType == 0 then
      return -3
    end
  end
  if skillID == ___MOD._SkillBook.Shadow_Stars_412_4121006 and bulletItemID ~= 0 then
    local item = ___MOD._ItemManager:getItemById(bulletItemID)
    player.Player.bulletPAD = item ~= nil and (item.incPAD or 0) or 0
  end
  return 0
end

function PlayerAttackLogic_Shoot.checkWall(self, map, skillID, startPos, targetPos, isMagic)
  if isMagic and skillID ~= ___MOD._SkillBook.Energy_Bolt_200_2001004 then
    return
  end
  local direction = ___MOD.Vector2.Normalize(targetPos - startPos)
  local dist = ___MOD.Vector2.Distance(targetPos, startPos)
  local fhc = map.FootholdComponent
  local throughs = fhc:RaycastAll(startPos, direction, dist)
  ___MOD.table.sort(throughs, function(a, b)
    local aDist = ___MOD.Vector2.Distance(startPos, a:GetCenter())
    local bDist = ___MOD.Vector2.Distance(startPos, b:GetCenter())
    return aDist < bDist
  end)
  if ___MOD.next(throughs) ~= nil then
    for _, v in ___MOD.ipairs(throughs) do
      local fh = v
      if ___MOD.math.abs(fh.Variance.y) == 1 and map.ChainFootHoldComponent:checkWall(fh.Id) then
        return true, fh:GetCenter()
      end
    end
  end
  return false
end

function PlayerAttackLogic_Shoot.createBulletClient(self, map, attacker, mobs, bulletCount, bulletDelay, shootDelay, startPos, bullet, weaponType, isFaceLeft, isMagic, passThrough, boxShape, range, soulArrowSkillID, ctx)
  local player = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(attacker) and ___MOD.isvalid(attacker.Player) and attacker ~= player and attacker.Player.AdminHidden == true then
    return
  end
  local ballAni
  local hasBall = false
  local hitData = ctx.hitData
  local fixedHit = false
  local stickerBulletID = 0
  local stickerBulletAnim, stickerHitAnim, stickerHitSound
  local useStickerBulletAnim = false
  local canUseStickerBullet = weaponType == ___MOD._WeaponType.CLAW
  local isCashStickerBullet = false
  local isLocal = attacker == player
  local skillEffectOpacity = isLocal and player.UISystemOptionComponent.selfSkillEffectOpacity or player.UISystemOptionComponent.otherSkillEffectOpacity
  local skillEffectAlpha = ___MOD.math.max(0, ___MOD.math.min(100, ___MOD.tonumber(skillEffectOpacity) or 100)) / 100
  if canUseStickerBullet then
    if isLocal then
      stickerBulletID = attacker.PlayerVariables ~= nil and (___MOD.tonumber(attacker.PlayerVariables.StickerBulletID) or 0) or 0
    else
      local stickerMap = player.PlayerVariables.StickerBulletIDs or nil
      stickerBulletID = stickerMap ~= nil and (___MOD.tonumber(stickerMap[___MOD.tostring(attacker.Player.PlayerId)]) or 0) or 0
    end
  end
  isCashStickerBullet = stickerBulletID // 1000 == 5021
  if stickerBulletID ~= 0 and isCashStickerBullet then
    local stickerItem = ___MOD._ItemManager:getItemById(stickerBulletID)
    if stickerItem ~= nil then
      local stickerBullet = stickerItem.bullet
      if stickerBullet ~= nil and stickerBullet.anim ~= nil then
        stickerBulletAnim = stickerBullet
      end
      local stickerHit = stickerItem.hit
      if stickerHit ~= nil and stickerHit.anim ~= nil then
        stickerHitAnim = {stickerHit}
      end
      stickerHitSound = ___MOD.string.format("CashEffect.img.%08d.Hit", stickerBulletID)
    end
  else
    stickerBulletID = 0
  end
  if ctx.skillID ~= ___MOD._SkillBook.Chain_Lightning_222_2221006 then
    if ctx.skillData ~= nil then
      local ball = ctx.skillData.ball
      if ball ~= nil then
        ballAni = ball
        hasBall = true
      end
      local charLevel = ctx.skillData.charLevel
      if charLevel ~= nil then
        local levelKey = "10"
        local level = attacker.Player.Level
        local data
        if 10 <= level then
          local d = charLevel[levelKey]
          if d ~= nil then
            data = d
          end
        end
        if 15 <= level then
          levelKey = "15"
          local d = charLevel[levelKey]
          if d ~= nil then
            data = d
          end
        end
        if 20 <= level then
          levelKey = "20"
          local d = charLevel[levelKey]
          if d ~= nil then
            data = d
          end
        end
        if 25 <= level then
          levelKey = "25"
          local d = charLevel[levelKey]
          if d ~= nil then
            data = d
          end
        end
        if 40 <= level then
          levelKey = "40"
          local d = charLevel[levelKey]
          if d ~= nil then
            data = d
          end
        end
        if 50 <= level then
          levelKey = "50"
          local d = charLevel[levelKey]
          if d ~= nil then
            data = d
          end
        end
        if data ~= nil and data.ball ~= nil then
          ballAni = data.ball
          hasBall = true
        end
      end
    end
    if ctx.skillLevelData ~= nil then
      if ctx.skillLevelData.ball ~= nil then
        ballAni = ctx.skillLevelData.ball
        hasBall = true
      end
      if ctx.skillLevelData.hit ~= nil then
        hitData = ctx.skillLevelData.hit
        fixedHit = true
      end
    end
    if ballAni == nil then
      if ___MOD.isvalid(attacker.Player) and attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 and attacker.PlayerTemporaryStatComponent:getSkillID(___MOD._CTS.NonComsumeBullet) == ___MOD._SkillBook.Shadow_Stars_412_4121006 then
        local preConsumedItemID = ___MOD.tonumber(attacker.Player.preConsumedBulletItemID) or 0
        if preConsumedItemID ~= 0 then
          local preConsumedItem = ___MOD._ItemManager:getItemById(preConsumedItemID)
          if preConsumedItem ~= nil then
            bullet = preConsumedItem.bullet
          end
        end
      end
      ballAni = bullet
    end
  end
  if not hasBall and stickerBulletAnim ~= nil then
    ballAni = stickerBulletAnim
    useStickerBulletAnim = true
  end
  if stickerHitAnim ~= nil then
    hitData = stickerHitAnim
    fixedHit = true
  end
  if not hasBall and soulArrowSkillID ~= ___MOD._SkillBook.Shadow_Stars_412_4121006 then
    local skillData = ___MOD._SkillManager:getSkill(soulArrowSkillID)
    if skillData ~= nil and skillData.ball ~= nil then
      ballAni = skillData.ball
      hasBall = true
    end
  end
  local BULLET_SPEED_SCALE = 1.6666666666666667
  local bulletSpeed = self:getBulletSpeedBySkill(ctx.skillID)
  local modelName = "Bullet"
  local pool = attacker.PlayerVariables.bulletPool
  if hasBall then
    modelName = "BallBullet"
    pool = attacker.PlayerVariables.ballBulletPool
  end
  local model = ___MOD._EntryService:GetModelIdByName(modelName)
  local hitCount = 0
  if hitData ~= nil and not fixedHit then
    for i = 1, 100 do
      local eff = hitData[i]
      if eff ~= nil then
        hitCount = hitCount + 1
      else
        break
      end
    end
  end
  local hitIndex = 0
  if 0 < hitCount then
    hitIndex = ___MOD._GlobalRand32:randomIntegerRange(0, hitCount - 1)
  end
  if ctx.skillID == ___MOD._SkillBook.Arrow_Bomb__Bow_310_3101005 then
    hitIndex = 0
  end
  if fixedHit then
    hitIndex = 0
  end
  for index = 1, bulletCount do
    local delay = (index - 1) * bulletDelay + shootDelay
    local hitPt
    local shootRange = self:getShootStartRange(ctx.skillID)
    local mapleRange = range ~= nil and range or self:getShootSkillRange(attacker, ctx.skillID, weaponType)
    local range = mapleRange / 100
    if isFaceLeft then
      hitPt = startPos - ___MOD.FastVector2(range - shootRange, 0)
    else
      hitPt = startPos + ___MOD.FastVector2(range - shootRange, 0)
    end
    local baseY = 0.07
    local fanShapeOffset = baseY * (2 * (index - 1) - (bulletCount - 1))
    local plannedMainMob, plannedMainHitOffset
    if 0 < #mobs then
      plannedMainMob = mobs[1]
      local plannedMainMobPos = plannedMainMob.TransformComponent:WorldPositionAsFastVector3():ToVector2()
      local plannedMainHitPt = self:getHitPointByBox(plannedMainMob, boxShape)
      plannedMainHitOffset = plannedMainHitPt - plannedMainMobPos
      if ctx.skillID == ___MOD._SkillBook.Double_Shot_500_5001003 and index == 1 then
        plannedMainHitOffset.x = plannedMainHitOffset.x + 0.15 * (isFaceLeft and 1 or -1)
      end
    end
    if ballAni ~= nil then
      ___MOD._TimerService:SetTimerOnce(function()
        if not isMagic and ctx.skillID ~= ___MOD._SkillBook.Hurricane_312_3121004 and ctx.skillID ~= ___MOD._SkillBook.Hurricane_1311_13111002 then
          local attackSound = ___MOD._WeaponType:getAttackSoundByWeaponType(ctx.weaponInfo.weaponType, true)
          local attackSoundRUID = ___MOD.__RUIDManager:get(attackSound)
          if attackSoundRUID ~= nil and attackSoundRUID ~= "" and ___MOD._PlayerAttackLogic_Melee:shouldPlayAttackSound(attacker) then
            ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(attackSoundRUID, attacker, attacker, 1)
          end
        end
        if (ctx.skillID == ___MOD._SkillBook.Inferno_311_3111003 or ctx.skillID == ___MOD._SkillBook.Blizzard_321_3211003) and 0 < #mobs and ctx.skillData.special ~= nil then
          local pos = mobs[1].TransformComponent:WorldPositionAsFastVector3()
          if ctx.skillData.tile ~= nil then
            ___MOD._ExtendedEffectService:makeFootholdEffect(attacker.CurrentMap, ctx.skillData.tile, pos:ToVector2(), ctx.skillLevelData.lt * 100, ctx.skillLevelData.rb * 100, nil, attacker)
          end
          if ctx.skillData.special ~= nil then
            ___MOD._ExtendedEffectService:makeFallingAnimation(attacker.CurrentMap, ctx.skillData.special, pos, attacker.PlayerControllerComponent.LookDirectionX == -1, ctx.skillID, ctx.skillLevel, attacker)
          end
        end
        if skillEffectAlpha <= 0 then
          return
        end
        local bulletObj = ___MOD._ObjectPool:pick(pool, "bullet", model, startPos:ToVector3(), map, false)
        bulletObj.BulletComponent.returnPool = pool
        local bc = bulletObj.BulletComponent
        bc.LastFacingLeft = nil
        bc.skillID = ctx.skillID
        bc.shootDirectionX = isFaceLeft and -1 or 1
        bc.stickerBulletID = useStickerBulletAnim and stickerBulletID or 0
        bc.ignoredNearTargetReleaseOnce = false
        bc.startDelay = 0
        bc.fanShapeShootOffset = 0
        bc.target = nil
        bc.targetHitOffset = ___MOD.FastVector3.zero:Clone()
        bc.targetPos = ___MOD.FastVector3.zero:Clone()
        bc.isMobAttack = false
        bc.parent = nil
        bulletObj.TransformComponent.WorldZRotation = 0
        local asp = bulletObj.AnimationSpriteComponent
        asp:setWzSprite(ballAni, false)
        asp.noApplyAlpha = true
        asp:setSpriteEntitiesAlpha(skillEffectAlpha)
        local rotatePeriod = ballAni.rotatePeriod or 0
        if rotatePeriod ~= 0 then
          asp:setRotate(rotatePeriod / 1000)
        end
        if #mobs <= 0 or passThrough then
          local distance = startPos:Distance(hitPt)
          local pxPerSec = bulletSpeed * BULLET_SPEED_SCALE
          if pxPerSec <= 0 then
            pxPerSec = 1.0
          end
          local duration = distance / pxPerSec
          local playerPos = attacker.TransformComponent.Position
          asp:setLeftFacing(hitPt.x < playerPos.x)
          bc.Enable = false
          hitPt.y = hitPt.y - fanShapeOffset
          local startPos = playerPos:ToVector2()
          startPos.y = startPos.y + 0.28
          if (not ctx or not self:isPassThroughSkill(ctx.skillID)) and not ___MOD._FootholdLogic:canGoThrough(map, startPos, hitPt, attacker.PlayerVariables.lastFoothold) then
            local d = ___MOD.Vector2.Distance(hitPt, startPos)
            duration = d / pxPerSec
          end
          local tween = ___MOD._TweenLogic:MoveTo(bulletObj, hitPt, duration, ___MOD.EaseType.Linear)
          tween:SetOnEndCallback(function()
            ___MOD._ObjectPool:release(pool, bulletObj, false)
          end)
        else
          asp:setLeftFacing(useStickerBulletAnim and isFaceLeft or false)
          local mob = plannedMainMob
          if mob == nil or plannedMainHitOffset == nil then
            ___MOD._ObjectPool:release(pool, bulletObj, false)
            return
          end
          local hitPos = ___MOD.FastVector3(plannedMainHitOffset.x, plannedMainHitOffset.y, 0)
          bc.fanShapeShootOffset = fanShapeOffset
          bc.target = mob
          bc.targetHitOffset = hitPos
          bc.Enable = true
          bc.bulletSpeed = bulletSpeed
        end
        bulletObj:SetEnable(true)
        if #mobs <= 0 or passThrough then
          bc.Enable = false
        end
        if (bulletDelay ~= 0 or bulletDelay == 0 and index == 1) and not hasBall and ctx.skillID ~= ___MOD._SkillBook.Hurricane_312_3121004 and ctx.skillID ~= ___MOD._SkillBook.Hurricane_1311_13111002 then
          local attackSound2 = ___MOD._WeaponType:getAttackSoundByWeaponType(weaponType, true)
          ___MOD.attackSoundRUID = ___MOD.__RUIDManager:get(attackSound2)
          if ___MOD.attackSoundRUID ~= nil and ___MOD.attackSoundRUID ~= "" and ___MOD._PlayerAttackLogic_Melee:shouldPlayAttackSound(attacker) then
            ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(___MOD.attackSoundRUID, attacker, attacker, 1)
          end
        end
      end, delay)
    else
    end
    for _, mob in ___MOD.ipairs(mobs) do
      local plannedMobPos = mob.TransformComponent:WorldPositionAsFastVector3():ToVector2()
      local plannedHitPt = self:getHitPointByBox(mob, boxShape)
      local plannedShootHitOffset = plannedHitPt - plannedMobPos
      local distance = startPos:Distance(plannedHitPt)
      local ballDelay = (index - 1) * bulletDelay + shootDelay + distance * 0.15
      if bulletDelay == 0 then
        ballDelay = ballDelay + (index - 1) * 0.12
      end
      ___MOD._TimerService:SetTimerOnce(function()
        local mobFaceLeft = mob.MovementComponent:IsFaceLeft()
        ___MOD._PlayerAttackLogic_Melee:playAttackSound(attacker, mob, ctx.skillID, mob.MobComponent.id)
        if ___MOD._PlayerAttackLogic_Melee:shouldPlayAttackSound(attacker) and stickerBulletID ~= 0 and not ___MOD._UtilLogic:IsNilorEmptyString(stickerHitSound) then
          ___MOD._SoundUtils:broadcastCashStickerHitSoundAtPosLocal(stickerHitSound, mob, 1, isLocal)
        end
        local hitPos = ___MOD.FastVector3(plannedShootHitOffset.x, plannedShootHitOffset.y, 0)
        hitPos.y = hitPos.y - fanShapeOffset
        if ctx.skillID == ___MOD._SkillBook.Cold_Beam_220_2201004 then
          hitPos = ___MOD.FastVector3.zero:Clone()
          hitPos.y = mob.MobComponent.spriteSize.y / 2
        end
        if (ctx.skillID == ___MOD._SkillBook.Mortal_Blow_311_3110001 or ctx.skillID == ___MOD._SkillBook.Mortal_Blow_321_3210001) and ctx.finishAttack then
          ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, 0, mob, 1.0, hitPos, ctx.skillData.special, false, not isFaceLeft, nil)
        end
        if stickerHitAnim ~= nil then
          ___MOD._ExtendedEffectService:playHlafSkillAnimationLocal(attacker, mob, hitPos, stickerHitAnim[1], isFaceLeft)
        elseif hitData ~= nil then
          local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, ctx.skillID, hitIndex, mob, 1.0, hitPos, hitData, false, isFaceLeft, nil)
          ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
        else
          local hitAni = mob.HitAnimationComponent
          local key = "mace"
          local faceDir = isFaceLeft and -1 or 1
          key = key .. (faceDir == -1 and 1 or 2)
          hitPos = ___MOD._PlayerAttackLogic:getHitPoint(mob, boxShape)
          hitAni:playHitAnimation(key, attacker, mob, hitPos)
        end
      end, ballDelay)
    end
  end
end

function PlayerAttackLogic_Shoot.createGrenadeClient(self, map, attacker, skillID, skillLevel, startPos, chargeTime, isFaceLeft)
  if ___MOD.isvalid(attacker) and ___MOD.isvalid(attacker.Player) and attacker ~= ___MOD._UserService.LocalPlayer and attacker.Player.AdminHidden == true then
    return
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData == nil then
    return
  end
  local grenade = ___MOD._SpawnService:SpawnByModelId("model://9b6e1401-3bf3-4059-b6d8-62442621b418", "grenade", startPos, map)
  local g = grenade.GrenadeComponent
  local ac = grenade.AnimationSpriteComponent
  local ball = skillData.ball
  if ball ~= nil then
    ac:setWzSprite(ball, false)
    ac.loop = true
  end
  local pxPerUnit = 100.0
  local base = 600.0 / pxPerUnit
  local speed = chargeTime * base
  local vx = isFaceLeft and -speed or speed
  local vy = speed
  g.owner = attacker
  g:SetState(startPos:ToVector2(), vx, vy)
  local gval = -19.6
  g:SetPhysics(100.0, 3.0, 0.0, gval)
  g:SetVMax(0, 0)
  g.skillID = skillID
  g.skillLevel = skillLevel
end

function PlayerAttackLogic_Shoot.filterOnlyLiveMobs(self, hit, temp, output, attacker)
  if hit <= 0 then
    return 0
  end
  for k in ___MOD.pairs(output) do
    output[k] = nil
  end
  local homingEntity
  local count = 0
  local dedicated = ___MOD._DedicatedMonsterLogic
  local useDedicated = dedicated and dedicated:isEnabledMap(attacker.CurrentMap)
  for _, c in ___MOD.ipairs(temp) do
    local t = c
    local mob = c.Entity.MobComponent
    if mob ~= nil and t.EnableInHierarchy and not mob:isDead() and c.Entity.Enable and not mob.damagedByMob and not mob.suspended and (not useDedicated or dedicated:isOwnedMob(attacker, mob.Entity)) then
      local mts = c.Entity.MobTemporaryStatComponent
      if mts ~= nil and mts:getValue(___MOD._MTS.Dazzle) == 0 and mts:getValue(___MOD._MTS.Homing) ~= 0 and (mts:getOwner(___MOD._MTS.Homing) == attacker.Player.PlayerId or attacker.PlayerVariables.homingMob == c.Entity) then
        homingEntity = mob.Entity
        break
      end
    end
  end
  if homingEntity ~= nil then
    output[1] = homingEntity
    count = 1
  end
  for _, c in ___MOD.ipairs(temp) do
    local t = c
    local mob = c.Entity.MobComponent
    if mob ~= nil and t.EnableInHierarchy and not mob:isDead() and c.Entity.Enable and not mob.damagedByMob and not mob.suspended and (not useDedicated or dedicated:isOwnedMob(attacker, mob.Entity)) then
      local mts = c.Entity.MobTemporaryStatComponent
      if mts:getValue(___MOD._MTS.Dazzle) == 0 then
        local e = mob.Entity
        if homingEntity == nil or e ~= homingEntity then
          count = count + 1
          output[count] = e
        end
      end
    end
  end
  return count
end

function PlayerAttackLogic_Shoot.findHitMobInTrapezoid(self, x0, x1, x2, y, r, output, left, finalBoxShape, entity, targetMob)
  local boxShape = finalBoxShape
  local simulator = ___MOD._CollisionService:GetSimulator(entity)

  local function wipe(t)
    for k in ___MOD.pairs(t) do
      t[k] = nil
    end
  end

  local function copyTable(src, dst, n)
    wipe(dst)
    for i = 1, n do
      dst[i] = src[i]
    end
  end

  local bestCount = 0
  local bestOutput = {}
  local bestBox
  local i = 1
  while x1 < x2 do
    local range = x2 - x1
    local height = x1 / r
    local box = self:makeBoxShape(___MOD.Vector2(x0, y), ___MOD.Vector2(0, -0.5), ___MOD.Vector2(range, height * 2), left)
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD._ColliderUtils:d(___MOD._UserService.LocalPlayer.CurrentMap, i, box)
    end
    entity.CurrentMap.MapObjectPool.overlapList = {}
    local collisionGroups = ___MOD.CollisionGroups.Monster
    local fromMob = false
    if not targetMob and ___MOD.isvalid(entity.MobComponent) then
      collisionGroups = ___MOD.CollisionGroups.Player
      fromMob = true
    end
    local hit = simulator:OverlapAllFast(collisionGroups, box, entity.CurrentMap.MapObjectPool.overlapList)
    if fromMob then
      if 0 < hit then
        wipe(output)
        for idx = 1, hit do
          output[idx] = entity.CurrentMap.MapObjectPool.overlapList[idx]
        end
        if boxShape ~= nil then
          boxShape.Angle = box.Angle
          boxShape.Size = box.Size
          boxShape.Position = box.Position
        end
        return hit
      end
    else
      local tempOut = {}
      local count = self:filterOnlyLiveMobs(hit, entity.CurrentMap.MapObjectPool.overlapList, tempOut, entity)
      if 0 < count then
        local first = tempOut[1]
        local homingFound = false
        if first ~= nil and first.MobTemporaryStatComponent ~= nil and first.MobTemporaryStatComponent:getValue(___MOD._MTS.Homing) ~= 0 and (first.MobTemporaryStatComponent:getOwner(___MOD._MTS.Homing) == entity.Player.PlayerId or entity.PlayerVariables.homingMob == first) then
          homingFound = true
        end
        if homingFound then
          copyTable(tempOut, output, count)
          if boxShape ~= nil then
            boxShape.Angle = box.Angle
            boxShape.Size = box.Size
            boxShape.Position = box.Position
          end
          return count
        end
        if bestCount == 0 then
          bestCount = count
          copyTable(tempOut, bestOutput, count)
          bestBox = box
        end
      end
    end
    x1 = x1 + 0.2
    if left then
      x0 = x0 - 0.2
    else
      x0 = x0 + 0.2
    end
    i = i + 1
  end
  if 0 < bestCount then
    copyTable(bestOutput, output, bestCount)
    if boxShape ~= nil and bestBox ~= nil then
      boxShape.Angle = bestBox.Angle
      boxShape.Size = bestBox.Size
      boxShape.Position = bestBox.Position
    end
    return bestCount
  end
  return 0
end

function PlayerAttackLogic_Shoot.findHitMobInTrapezoidRect(self, x0, x1, x2, y, adjustVerticalRange, r, output, left, finalBoxShape, entity, targetMob, useRect)
  local boxShape = finalBoxShape
  local simulator = ___MOD._CollisionService:GetSimulator(entity)

  local function wipe(t)
    for k in ___MOD.pairs(t) do
      t[k] = nil
    end
  end

  local function copyTable(src, dst, n)
    wipe(dst)
    for i = 1, n do
      dst[i] = src[i]
    end
  end

  local bestCount = 0
  local bestOutput = {}
  local bestBox
  local i = 1
  while x1 < x2 do
    local range = x2 - x1
    local height = useRect and adjustVerticalRange / 100 or x1 / r
    local box = self:makeBoxShape(___MOD.Vector2(x0, y), ___MOD.Vector2(0, -0.5), ___MOD.Vector2(range, height * 2), left)
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD._ColliderUtils:d(___MOD._UserService.LocalPlayer.CurrentMap, i, box)
    end
    entity.CurrentMap.MapObjectPool.overlapList = {}
    local collisionGroups = ___MOD.CollisionGroups.Monster
    local fromMob = false
    if not targetMob and ___MOD.isvalid(entity.MobComponent) then
      collisionGroups = ___MOD.CollisionGroups.Player
      fromMob = true
    end
    local hit = simulator:OverlapAllFast(collisionGroups, box, entity.CurrentMap.MapObjectPool.overlapList)
    if fromMob then
      if 0 < hit then
        wipe(output)
        for idx = 1, hit do
          output[idx] = entity.CurrentMap.MapObjectPool.overlapList[idx]
        end
        if boxShape ~= nil then
          boxShape.Angle = box.Angle
          boxShape.Size = box.Size
          boxShape.Position = box.Position
        end
        return hit
      end
    else
      local tempOut = {}
      local count = self:filterOnlyLiveMobs(hit, entity.CurrentMap.MapObjectPool.overlapList, tempOut, entity)
      if 0 < count then
        local first = tempOut[1]
        local homingFound = false
        if first ~= nil and first.MobTemporaryStatComponent ~= nil and first.MobTemporaryStatComponent:getValue(___MOD._MTS.Homing) ~= 0 and (first.MobTemporaryStatComponent:getOwner(___MOD._MTS.Homing) == entity.Player.PlayerId or entity.PlayerVariables.homingMob == first) then
          homingFound = true
        end
        if homingFound then
          copyTable(tempOut, output, count)
          if boxShape ~= nil then
            boxShape.Angle = box.Angle
            boxShape.Size = box.Size
            boxShape.Position = box.Position
          end
          return count
        end
        if bestCount == 0 then
          bestCount = count
          copyTable(tempOut, bestOutput, count)
          bestBox = box
        end
      end
    end
    x1 = x1 + 0.2
    if left then
      x0 = x0 - 0.2
    else
      x0 = x0 + 0.2
    end
    i = i + 1
  end
  if 0 < bestCount then
    copyTable(bestOutput, output, bestCount)
    if boxShape ~= nil and bestBox ~= nil then
      boxShape.Angle = bestBox.Angle
      boxShape.Size = bestBox.Size
      boxShape.Position = bestBox.Position
    end
    return bestCount
  end
  return 0
end

function PlayerAttackLogic_Shoot.getAranSwingMasterySkillID(self, skillID)
  if skillID == ___MOD._SkillBook.hidden_Full_Swing__Double_Swing_2111_21110007 or skillID == ___MOD._SkillBook.hidden_Full_Swing__Triple_Swing_2111_21110008 then
    return ___MOD._SkillBook.Full_Swing_2111_21110002
  elseif skillID == ___MOD._SkillBook.hidden_Over_Swing__Double_Swing_2112_21120009 or skillID == ___MOD._SkillBook.hidden_Over_Swing__Triple_Swing_2112_21120010 then
    return ___MOD._SkillBook.Over_Swing_2112_21120002
  end
  return 0
end

function PlayerAttackLogic_Shoot.getBulletDelay(self, bulletItemId, skillId, def)
  if bulletItemId // 10000 == 207 or bulletItemId // 1000 == 5021 or skillId == 4111004 then
    return 0.12
  elseif skillId == 3111006 or skillId == 3211006 or skillId == 13111001 or skillId == 33001000 or skillId == 33111001 then
    return 0.06
  elseif skillId == 5221007 then
    return 0.12
  elseif skillId == 5001003 or skillId == 5210000 then
    return 0.24
  else
    return def
  end
end

function PlayerAttackLogic_Shoot.getBulletSpeedBySkill(self, skillID)
  local bulletSpeed = 4.0
  if skillID == ___MOD._SkillBook.Energy_Bolt_200_2001004 or skillID == ___MOD._SkillBook.Fire_Demon_212_2121003 or skillID == ___MOD._SkillBook.Ice_Demon_222_2221003 then
    bulletSpeed = 3.5
  end
  return bulletSpeed
end

function PlayerAttackLogic_Shoot.getHitPointByBox(self, mob, box)
  local ret = self:intersectBox(box, self:triggerToBox(mob.TriggerComponent))
  if ret ~= nil then
    return ret
  end
  local p = ___MOD._PlayerAttackLogic:getMobVisualCenterWorldPos(mob)
  return p:ToVector2()
end

function PlayerAttackLogic_Shoot.getShootDelay(self, skillId, def)
  if skillId == 0 then
    return def
  end
  if skillId == ___MOD._SkillBook.Piercing_Arrow_322_3221001 then
    local skill = ___MOD._SkillManager:getSkill(___MOD._SkillBook.Piercing_Arrow_322_3221001)
    local ball = skill.ball
    local delay = def
    if ball ~= nil then
      delay = ball.anim[1].delay or def
    end
    return delay
  elseif skillId == ___MOD._SkillBook.Wind_Shot_1311_13111007 or skillId == ___MOD._SkillBook.Angel_Ray_232_2321007 then
    return 561
  elseif skillId == ___MOD._SkillBook.Shark_Wave_1511_15111007 then
    return 449
  elseif skillId == ___MOD._SkillBook.Wind_Walk_1310_13101006 then
    return 618
  elseif skillId == ___MOD._SkillBook.Burst_Fire_521_5210000 then
    return 90
  elseif skillId == ___MOD._SkillBook.Double_Shot_500_5001003 then
    return 90
  elseif skillId == ___MOD._SkillBook.Battleship_Cannon_522_5221007 then
    return 180
  elseif skillId == ___MOD._SkillBook.Battleship_Torpedo_522_5221008 then
    return 600
  elseif skillId == ___MOD._SkillBook.Dragons_Breath_312_3121003 or skillId == ___MOD._SkillBook.Dragons_Breath_322_3221003 then
    return 500
  elseif skillId == ___MOD._SkillBook.Three_Snails_000_1000 or skillId == ___MOD._SkillBook.Three_Snails_1000_10001000 or skillId == ___MOD._SkillBook.Three_Snails_2000_20001000 or skillId == ___MOD._SkillBook.Three_Snails_2001_20011000 then
    return 300
  else
    return def
  end
end

function PlayerAttackLogic_Shoot.getShootSkillRange(self, player, skillId, weaponType)
  if skillId ~= 0 then
    local skillLevel = player.SkillComponent:getSkillLevel(skillId)
    local levelData = ___MOD._SkillManager:getSkillLevelData(skillId, skillLevel)
    if levelData ~= nil and 0 < levelData.range then
      return levelData.range
    end
    if skillId == ___MOD._SkillBook.Taunt_412_4121003 or skillId == ___MOD._SkillBook.Taunt_422_4221003 then
      return 300
    end
    if skillId == ___MOD._SkillBook.Fire_Arrow_210_2101004 or skillId == ___MOD._SkillBook.Fire_Arrow_1210_12101002 then
      return 350
    end
    if skillId == ___MOD._SkillBook.Holy_Arrow_230_2301005 then
      return 320
    end
    if skillId == ___MOD._SkillBook.Three_Snails_000_1000 or skillId == ___MOD._SkillBook.Three_Snails_1000_10001000 or skillId == ___MOD._SkillBook.Three_Snails_2000_20001000 or skillId == ___MOD._SkillBook.Three_Snails_2001_20011000 then
      return 300
    end
    if skillId == ___MOD._SkillBook.Battleship_Cannon_522_5221007 or skillId == ___MOD._SkillBook.Battleship_Torpedo_522_5221008 then
      return 400
    end
  end
  local base, rangeLevelData = 200
  if 300 <= player.Player.Job and player.Player.Job <= 322 then
    base = 300
    local rangeSkillLevel = player.SkillComponent:getSkillLevel(___MOD._SkillBook.The_Eye_of_Amazon_300_3000002)
    if 0 < rangeSkillLevel then
      rangeLevelData = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.The_Eye_of_Amazon_300_3000002, rangeSkillLevel)
    end
  elseif 400 <= player.Player.Job and player.Player.Job <= 434 then
    base = 200
    local rangeSkillLevel = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Keen_Eyes_400_4000001)
    if 0 < rangeSkillLevel then
      rangeLevelData = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Keen_Eyes_400_4000001, rangeSkillLevel)
    end
  elseif player.Player.Job >= 1300 and player.Player.Job <= 1312 then
    base = 300
    local rangeSkillLevel = player.SkillComponent:getSkillLevel(___MOD._SkillBook.The_Eye_of_Amazon_1300_13000001)
    if 0 < rangeSkillLevel then
      rangeLevelData = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.The_Eye_of_Amazon_1300_13000001, rangeSkillLevel)
    end
  elseif player.Player.Job >= 1400 and player.Player.Job <= 1412 then
    local rangeSkillLevel = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Keen_Eyes_1400_14000001)
    if 0 < rangeSkillLevel then
      rangeLevelData = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Keen_Eyes_1400_14000001, rangeSkillLevel)
    end
  elseif weaponType == ___MOD._WeaponType.GUN then
    base = 300
  elseif weaponType == ___MOD._WeaponType.WAND or weaponType == ___MOD._WeaponType.STAFF then
    base = 300
  end
  if rangeLevelData ~= nil then
    base = base + rangeLevelData.range
  end
  return base
end

function PlayerAttackLogic_Shoot.getShootStartRange(self, skillID)
  if skillID == ___MOD._SkillBook.Three_Snails_000_1000 or skillID == ___MOD._SkillBook.Three_Snails_1000_10001000 or skillID == ___MOD._SkillBook.Three_Snails_2000_20001000 or skillID == ___MOD._SkillBook.Three_Snails_2001_20011000 or skillID == ___MOD._SkillBook.Energy_Bolt_200_2001004 or skillID == ___MOD._SkillBook.Fire_Arrow_210_2101004 or skillID == ___MOD._SkillBook.Fire_Arrow_1210_12101002 or skillID == ___MOD._SkillBook.Holy_Arrow_230_2301005 or skillID == ___MOD._SkillBook.Chain_Lightning_222_2221006 or skillID == ___MOD._SkillBook.Final_Attack__Bow_310_3100001 or skillID == ___MOD._SkillBook.Final_Attack__Crossbow_320_3200001 then
    return 0.3
  elseif skillID == ___MOD._SkillBook.Battleship_Cannon_522_5221007 then
    return 0.4
  elseif skillID == ___MOD._SkillBook.Mortal_Blow_311_3110001 or skillID == ___MOD._SkillBook.Mortal_Blow_321_3210001 or skillID == ___MOD._SkillBook.Soul_Blade_1110_11101004 or skillID == ___MOD._SkillBook.Shark_Wave_1511_15111007 or skillID == ___MOD._SkillBook.Combo_Smash_2110_21100004 or skillID == ___MOD._SkillBook.Combo_Fenrir_2111_21110004 then
    return 0
  end
  return 0.7
end

function PlayerAttackLogic_Shoot.getTriggerBoxFromLtRb(self, lt, rb, left)
  local size = ___MOD.Vector2(rb.x - lt.x, rb.y - lt.y)
  local center = ___MOD.Vector2.zero
  local abs = ___MOD.math.abs
  if abs(lt.x) > abs(rb.x) then
    center.x = -abs(lt.x) + size.x / 2
  else
    center.x = abs(rb.x) - size.x / 2
  end
  if abs(lt.y) > abs(rb.y) then
    center.y = abs(lt.y) - size.y / 2
  else
    center.y = -abs(rb.y) + size.y / 2
  end
  if not left then
    center.x = -center.x
  end
  return center / 100, size / 100
end

function PlayerAttackLogic_Shoot.handlePickpocket(self, attacker, mob, damages)

end

function PlayerAttackLogic_Shoot.intersectBox(self, b1, b2)
  local box1, box2 = b1, b2
  local box1Left = box1.Position.x - box1.Size.x / 2
  local box1Right = box1.Position.x + box1.Size.x / 2
  local box1Bottom = box1.Position.y - box1.Size.y / 2
  local box1Top = box1.Position.y + box1.Size.y / 2
  local box2Left = box2.Position.x - box2.Size.x / 2
  local box2Right = box2.Position.x + box2.Size.x / 2
  local box2Bottom = box2.Position.y - box2.Size.y / 2
  local box2Top = box2.Position.y + box2.Size.y / 2
  local interLeft = ___MOD.math.max(box1Left, box2Left)
  local interRight = ___MOD.math.min(box1Right, box2Right)
  local interBottom = ___MOD.math.max(box1Bottom, box2Bottom)
  local interTop = ___MOD.math.min(box1Top, box2Top)
  local interCenterX = (interLeft + interRight) / 2
  local interCenterY = (interBottom + interTop) / 2
  if interLeft > interRight or interBottom > interTop then
    return nil
  end
  return ___MOD.FastVector2(interCenterX, interCenterY)
end

function PlayerAttackLogic_Shoot.isNotMeleeAttackByNearMob(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Three_Snails_000_1000 or skillID == book.Three_Snails_1000_10001000 or skillID == book.Three_Snails_2000_20001000 or skillID == book.Three_Snails_2001_20011000 or skillID == book.Mortal_Blow_311_3110001 or skillID == book.Mortal_Blow_321_3210001 then
    return true
  end
  return false
end

function PlayerAttackLogic_Shoot.isPassThroughSkill(self, skillId)
  local book = ___MOD._SkillBook
  return skillId == book.Fire_Arrow_210_2101004 or skillId == book.Fire_Arrow_1210_12101002 or skillId == book.Iron_Arrow__Crossbow_320_3201005 or skillId == book.Avenger_411_4111005 or skillId == book.Battleship_Torpedo_522_5221008 or skillId == book.Avenger_1411_14111002 or skillId == book.Piercing_Arrow_322_3221001 or skillId == book.Cold_Beam_220_2201004 or skillId == book.Invisible_Shot_520_5201001 or skillId == book.Fire_Demon_212_2121003 or skillId == book.Ice_Demon_222_2221003 or skillId == book.Dragons_Breath_312_3121003 or skillId == book.Dragons_Breath_322_3221003 or skillId == book.Taunt_412_4121003 or skillId == book.Taunt_422_4221003 or skillId == book.Soul_Blade_1110_11101004 or skillId == book.Combo_Smash_2110_21100004 or skillId == book.Combo_Fenrir_2111_21110004 or skillId == book.Fire_Strike_1211_12111006 or skillId == book.Wind_Piercing_1311_13111006 or skillId == book.Shark_Wave_1511_15111007
end

function PlayerAttackLogic_Shoot.isStraightPassThroughSkill(self, skillId)
  local book = ___MOD._SkillBook
  return skillId == book.Iron_Arrow__Crossbow_320_3201005 or skillId == book.Piercing_Arrow_322_3221001 or skillId == book.Wind_Piercing_1311_13111006
end

function PlayerAttackLogic_Shoot.makeBoxShape(self, origin, anchor, size, left)
  anchor.x = anchor.x + 0.5
  anchor.y = anchor.y + 0.5
  if left then
    anchor.x = anchor.x - 1.0
  end
  return ___MOD.BoxShape(origin + size * anchor, size, 0)
end

function PlayerAttackLogic_Shoot.makeBoxShapeFromLtRb(self, origin, lt, rb, left)
  local center, size = self:getTriggerBoxFromLtRb(lt, rb, left)
  return ___MOD.BoxShape(origin + center, size, 0)
end

function PlayerAttackLogic_Shoot.onAttack(self, attacker, itemId, bulletCount, totalActionDelay, skillID, skillLevel, weaponType, attackMotion, hitDelayInfo, ctx, isMagic, bulletSlot, chargePer, forceTarget, actionLockDelay)
  local item = ___MOD._ItemManager:getItemById(itemId)
  local bullet
  if item ~= nil then
    bullet = item.bullet
  end
  if attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.NonComsumeBullet) == 0 and (item == nil or bullet == nil) and not ___MOD._PlayerAttackLogic:isShootAttackSkill(skillID) and not isMagic then
    ___MOD.log("존재하지 않는 아이템 또는 불릿정보 없음 Id:", itemId)
    return
  end
  local pos = attacker.TransformComponent:PositionAsFastVector3()
  local startPos = pos:Clone():ToVector2()
  local map = attacker.CurrentMap
  local shootRange = self:getShootStartRange(skillID)
  local isFaceLeft = attacker.ExtendPlayerControllerComponent.LookDirectionX == -1
  local mapleRange = self:getShootSkillRange(attacker, skillID, weaponType)
  local range = mapleRange / 100
  if isFaceLeft then
    startPos.x = startPos.x - shootRange
  else
    startPos.x = startPos.x + shootRange
  end
  startPos.y = startPos.y + 0.28
  local currentFh = attacker.RigidbodyComponent:GetCurrentFoothold()
  local currentFhId = currentFh ~= nil and currentFh.Id or 0
  local startCanGoThrough = ___MOD._FootholdLogic:canGoThrough(map, startPos, pos:ToVector2(), attacker.PlayerVariables.lastFoothold)
  if not (not startCanGoThrough and isMagic) or self:canIgnoreStartFootholdBlockSkill(skillID) then
  else
    return
  end
  local boxShape = self:makeBoxShapeFromLtRb(startPos, ___MOD.FastVector2(-mapleRange, 1), ___MOD.FastVector2.zero:Clone(), isFaceLeft)
  local adjustVerticalRange = ___MOD._DamageDecRate:getVerticalAdjustOfAttackRange(skillID)
  if 0 < adjustVerticalRange then
    boxShape.Size.y = boxShape.Size.y + adjustVerticalRange * 2 / 100
  end
  if ___MOD.Environment:IsMakerPlay() then
    ___MOD._ColliderUtils:drawBox(attacker.CurrentMap, boxShape.Position, boxShape.Size)
  end
  local hitMobCount
  local mobs = {}
  local useRect = skillID == ___MOD._SkillBook.Soul_Blade_1110_11101004 or skillID == ___MOD._SkillBook.Shark_Wave_1511_15111007 or skillID == ___MOD._SkillBook.Combo_Smash_2110_21100004 or skillID == ___MOD._SkillBook.Combo_Fenrir_2111_21110004 or self:isStraightPassThroughSkill(skillID)
  hitMobCount = self:findHitMobInTrapezoidRect(startPos.x, shootRange, range, startPos.y, adjustVerticalRange, 4, mobs, isFaceLeft, boxShape, attacker, nil, useRect)
  local firstHitMob = ___MOD.isvalid(forceTarget) and forceTarget.CurrentMap == map and forceTarget.MobComponent ~= nil and not forceTarget.MobComponent:isDead() and forceTarget or nil
  local passThrough = self:isPassThroughSkill(skillID)
  local hitPtTable = {}
  local bulletDelayItemID = itemId
  local pts = attacker.PlayerTemporaryStatComponent
  if pts:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 and pts:getSkillID(___MOD._CTS.NonComsumeBullet) == ___MOD._SkillBook.Shadow_Stars_412_4121006 then
    bulletDelayItemID = ___MOD.tonumber(attacker.Player.preConsumedBulletItemID) or itemId
  end
  local bulletDelay = self:getBulletDelay(bulletDelayItemID, skillID, 0)
  local shootDelay = self:getShootDelay(skillID, totalActionDelay) / 1000
  local mobCount = 0 < skillID and (ctx.skillLevelData.mobCount or 1) or 1
  if 0 < hitMobCount and (not ___MOD.isvalid(forceTarget) or forceTarget.CurrentMap ~= map or forceTarget.MobComponent == nil or not not forceTarget.MobComponent:isDead()) then
    local function isHomingMob(e)
      local mts = e and e.MobTemporaryStatComponent

      return mts ~= nil and mts:getValue(___MOD._MTS.Homing) ~= 0 and (mts:getOwner(___MOD._MTS.Homing) == attacker.Player.PlayerId or attacker.PlayerVariables.homingMob == e)
    end

    local function getDistance(e)
      if ___MOD.isvalid(e) and e.TriggerComponent ~= nil then
        local pt = self:intersectBox(self:triggerToBox(e.TriggerComponent), boxShape)
        if pt == nil then
          return ___MOD.math.huge
        end
        return startPos:Distance(pt)
      end
      return startPos:Distance(e.TransformComponent:PositionAsFastVector3():ToVector2())
    end

    if 1 < hitMobCount then
      ___MOD.table.sort(mobs, function(a, b)
        local ah = isHomingMob(a)
        local bh = isHomingMob(b)
        if ah ~= bh then
          return ah
        end
        return getDistance(a) < getDistance(b)
      end)
    end
    local mobs_ = {}
    local wallCheckStart = ___MOD.Vector2(pos.x, startPos.y)
    for k, m in ___MOD.ipairs(mobs) do
      local mobBox = ___MOD._NumberUtils:triggerToBox(m.TriggerComponent)
      local targetPt = ___MOD._NumberUtils:intersectBox(mobBox, boxShape)
      local mobNearEdge
      if targetPt ~= nil then
        local mobHalf = mobBox.Size.x * 0.5
        local mobNearX = isFaceLeft and mobBox.Position.x + mobHalf or mobBox.Position.x - mobHalf
        mobNearEdge = ___MOD.Vector2(mobNearX, targetPt.y)
      end
      local canGoThrough = mobNearEdge ~= nil and ___MOD._FootholdLogic:canGoThrough(map, wallCheckStart, mobNearEdge, attacker.PlayerVariables.lastFoothold)
      if canGoThrough or targetPt ~= nil and useRect and targetPt.y < startPos.y then
        mobs_[#mobs_ + 1] = m
        if not passThrough and skillID ~= ___MOD._SkillBook.Inferno_311_3111003 and skillID ~= ___MOD._SkillBook.Blizzard_321_3211003 or mobCount <= #mobs_ then
          break
        end
      end
    end
    if not passThrough then
      firstHitMob = mobs_[1]
    end
    mobs = mobs_
    hitMobCount = #mobs_
  end
  if ctx.skillID == ___MOD._SkillBook.Mortal_Blow_311_3110001 or ctx.skillID == ___MOD._SkillBook.Mortal_Blow_321_3210001 then
    if 0 < #mobs then
      local mob = mobs[1]
      if mob ~= nil and not mob.MobComponent.boss then
        local hp = mob.MobComponent.maxHP * ctx.skillLevelData.x * 0.01
        if hp >= mob.MobComponent.HP and ctx.skillLevelData.y >= ___MOD._GlobalRand32:randomIntegerRange(1, 100) then
          ctx.finishAttack = true
        end
      end
    end
  elseif ctx.skillID == ___MOD._SkillBook.Strafe_321_3211006 and 0 < #mobs then
    local mob = mobs[1]
    if mob ~= nil and not mob.MobComponent.boss then
      local temporary = mob.MobTemporaryStatComponent
      if (temporary:getValue(___MOD._MTS.Freeze) ~= 0 or temporary:getValue(___MOD._MTS.ComboTempest) ~= 0) and ctx.skillLevelData.prop >= ___MOD._GlobalRand32:randomIntegerRange(1, 100) then
        ctx.finishAttack = true
      end
    end
  end
  if ctx.skillID == ___MOD._SkillBook.Avenger_1411_14111002 or ctx.skillID == ___MOD._SkillBook.Avenger_411_4111005 or ctx.skillID == ___MOD._SkillBook.Piercing_Arrow_322_3221001 then
    bulletCount = 1
  end
  if skillID == ___MOD._SkillBook.Combo_Fenrir_2111_21110004 then
    bulletCount = ___MOD.math.max(bulletCount, ctx.attackCount or 1)
  end
  if attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.ShadowPartner) ~= 0 then
    bulletCount = bulletCount * 2
  end
  if not ___MOD._SkillLogic:isThrowBombSkill(skillID) then
    local soulArrowSkillID = 0
    if attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 then
      local sid = attacker.PlayerTemporaryStatComponent:getSkillID(___MOD._CTS.NonComsumeBullet)
      if sid ~= ___MOD._SkillBook.Shadow_Stars_412_4121006 then
        soulArrowSkillID = sid
      end
    end
    self:createBulletClient(map, attacker, mobs, bulletCount, bulletDelay, shootDelay, startPos, bullet, weaponType, isFaceLeft, isMagic, passThrough, boxShape, mapleRange, soulArrowSkillID, ctx)
  end
  local delays = {}
  local damages = {}
  local criticals = {}
  if skillID == ___MOD._SkillBook.Arrow_Bomb__Bow_310_3101005 and firstHitMob ~= nil then
    local levelData = ctx.skillLevelData
    if levelData ~= nil then
      mobs = {}
      mobs[1] = firstHitMob
      local m = ___MOD._PlayerAttackLogic:findValidMobs(attacker, firstHitMob.TransformComponent:WorldPositionAsFastVector3(), ctx.box.Size, 0, levelData.mobCount + 1, false)
      for _, v in ___MOD.pairs(m) do
        if v ~= firstHitMob then
          mobs[#mobs + 1] = v
          if #mobs >= levelData.mobCount then
            break
          end
        end
      end
    end
  end
  local playerInputX = attacker.PlayerControllerComponent.LookDirectionX
  local damageTargetCount = ___MOD.math.max(1, #mobs)
  if 0 < #mobs then
    local attackerPosSnapshot = attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
    for index, mob in ___MOD.ipairs(mobs) do
      local hitPt = self:getHitPointByBox(mob, boxShape)
      local distance = startPos:Distance(hitPt)
      local shootHitOffset = ___MOD.FastVector2.zero:Clone()
      if mob ~= nil then
        shootHitOffset = hitPt - mob.TransformComponent:PositionAsFastVector3():ToVector2()
      end
      local ballDelay = shootDelay * 1000 + distance * 150
      local damageDelays = {}
      for i = 1, bulletCount do
        damageDelays[i] = ballDelay
        damageDelays[i] = damageDelays[i] + (i - 1) * (bulletDelay * 1000)
        if bulletDelay == 0 then
          damageDelays[i] = damageDelays[i] + (i - 1) * 120
        end
        if skillID == ___MOD._SkillBook.Arrow_Bomb__Bow_310_3101005 and 1 < index then
          damageDelays[i] = damageDelays[1] + 200
          ___MOD._TimerService:SetTimerOnce(function()
            local mobFaceLeft = mob.MovementComponent:IsFaceLeft()
            local mobPos = mob.TransformComponent.Position:ToVector2()
            local hitPos = ___MOD.FastVector3(shootHitOffset.x, shootHitOffset.y, 0)
            local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, skillID, 1, mob, 1.0, hitPos, ctx.hitData, false, false, nil)
            ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
            ___MOD._PlayerAttackLogic_Melee:playAttackSound(attacker, mob, skillID, mob.MobComponent.id)
          end, damageDelays[i] / 1000)
        end
      end
      local damages_, criticals_, highestDamage = ___MOD._PlayerAttackLogic:calcDamageClient(attacker, mob, ctx.skillID, ctx.skillLevel, bulletCount, damageDelays, attackMotion, 0, damageTargetCount, bulletSlot, index, chargePer, ctx.finishAttack)
      damages[#damages + 1] = damages_
      criticals[#criticals + 1] = criticals_
      delays[#delays + 1] = damageDelays
      local totalDelay = ballDelay / 1000 + bulletDelay * (bulletCount - 1)
      local totalDamage, deadlyAttack = ___MOD._PlayerAttackLogic:onAttackClient(attacker, mob, damages_)
      if ctx.skillID ~= ___MOD._SkillBook.Hypnotize_522_5221009 and not ___MOD._PlayerAttackLogic:isComboTempestStatusOnlyTarget(ctx.skillID, mob) then
        ___MOD._PlayerAttackLogic:displaySkillDamageByAttackerClient(attacker, mob, ctx.skillID, damages_, criticals_, damageDelays)
      end
    end
  end
  local pts = attacker.PlayerTemporaryStatComponent
  local starItemID = itemId
  if pts:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 and pts:getSkillID(___MOD._CTS.NonComsumeBullet) == ___MOD._SkillBook.Shadow_Stars_412_4121006 then
    starItemID = ___MOD.tonumber(attacker.Player.preConsumedBulletItemID) or 0
  end
  local sad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(ctx.skillID, ctx.skillLevel, startPos, playerInputX, #mobs, bulletCount, ctx.motion, ___MOD._SkillAttackType.Shoot, mobs, damages, criticals, delays, totalActionDelay, ctx.playRate, isFaceLeft, 0, starItemID, mapleRange, damageTargetCount, bulletSlot, nil, chargePer, ctx.finishAttack, nil)
  sad.clientActionLockDelay = actionLockDelay
  ___MOD._PlayerAttackLogic:applyPendingWindWalkAttackBoost(attacker, sad)
  ___MOD._PlayerAttackLogic:onPlayerAttack(attacker, sad:toTable())
  ___MOD._PlayerAttackLogic:trySparkChainAttack(attacker, ctx.skillID, mobs, delays[1] ~= nil and delays[1][1] or totalActionDelay)
  ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(attacker)
end

function PlayerAttackLogic_Shoot.onUseConsume(self, player, skillID, skillLevelData, attackType, isMagic)

end

function PlayerAttackLogic_Shoot.playEffect(self, attacker, ctx, totalDelay, weaponType)
  local taming = attacker.TamingMobComponent
  if taming and taming.onTaming and not ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion) then
    ___MOD._PlayerStateLogic:changeState(attacker, "SIT")
    taming:playActionMotionClient(attacker, ctx.motion)
  elseif not ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion) then
    local rate = ctx.playRate
    if ctx.skillID == ___MOD._SkillBook.Recoil_Shot_520_5201006 then
      rate = 0.5
    end
    attacker.PlayerActionComponent:playOnceClient(ctx.motion, rate, attacker, true, false)
  end
  if ctx.skillID ~= ___MOD._SkillBook.Rapid_Fire_522_5221004 and ctx.effectData ~= nil then
    ___MOD._PlayerAttackLogic:playSkillEffect(attacker, ctx.skillID, ctx.effectIndex, ctx.effectData, ctx.playRate)
  end
  if ctx.skillID ~= ___MOD._SkillBook.Rapid_Fire_522_5221004 then
    local skillIdStr = ___MOD.string.format("%07d", ctx.skillID)
    ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", skillIdStr), attacker, 1)
  end
end

function PlayerAttackLogic_Shoot.playMpEaterEffectClient(self, attacker, mpEaterSkillID)
  local mpEaterSkillData = ___MOD._SkillManager:getSkill(mpEaterSkillID)
  if mpEaterSkillData ~= nil and mpEaterSkillData.effect ~= nil then
    ___MOD._PlayerSkillLogic:playOneShotEffect(attacker, mpEaterSkillID, mpEaterSkillData.effect)
  end
end

function PlayerAttackLogic_Shoot.setSkillMotion(self)

end

function PlayerAttackLogic_Shoot.triggerToBox(self, t)
  return ___MOD.BoxShape(t.Entity.TransformComponent:WorldPositionAsFastVector3():ToVector2() + t.ColliderOffset, t.BoxSize, 0)
end

function PlayerAttackLogic_Shoot.tryShootAttack(self, attacker, skillID, skillLevel, pa, weaponInfo, isFinalAttack, chargePer, isMagic, forceTarget)
  if pa.isClimbing or pa.sitting then
    return false
  end
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  if attacker.Player:isDead() then
    return false
  end
  if skillID == ___MOD._SkillBook.Double_Shot_500_5001003 then
    local slv = attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Burst_Fire_521_5210000)
    if 0 < slv then
      skillID = ___MOD._SkillBook.Burst_Fire_521_5210000
      skillLevel = slv
    end
  elseif skillID == ___MOD._SkillBook.Homing_Beacon_521_5211006 then
    local slv = attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Bullseye_522_5220011)
    if 0 < slv then
      skillID = ___MOD._SkillBook.Bullseye_522_5220011
      skillLevel = slv
    end
  end
  local ctx = ___MOD._PlayerAttackLogic_Melee:initSkillCtx(attacker, skillID, skillLevel, weaponInfo, isFinalAttack, true, false)
  if ctx.skillData ~= nil and ctx.skillData.weapon ~= nil and not ___MOD._PlayerAttackLogic:checkWeapon(ctx.skillData.weapon, weaponInfo.itemID) then
    pa:displayAttackMessage("장착한 무기로는 사용할 수 없는 스킬입니다.")
    pa.enableNextAttackTime = currentTime + 0.1
    return false
  end
  if not ___MOD._SkillLogic:isThrowBombSkill(skillID) and ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion) then
    pa:displayAttackMessage("알 수 없는 오류가 발생하여 공격에 실패했습니다.")
    pa.enableNextAttackTime = currentTime + 0.1
    return false
  end
  local finalAttackSkillID = 0
  if isFinalAttack and pa.finalAttackInfo ~= nil then
    finalAttackSkillID = pa.finalAttackInfo.finalAttackSkillID
  end
  local s = attacker.Player
  local inventory = attacker.CInventoryComponent
  local bulletCount = ___MOD.math.max(1, ctx.skillLevelData ~= nil and ctx.skillLevelData.bulletCount or 1)
  if ctx.skillLevelData ~= nil and 0 < ctx.skillLevelData.bulletConsume then
    bulletCount = ctx.skillLevelData.bulletConsume
  end
  if skillID == ___MOD._SkillBook.Wind_Shot_1311_13111007 then
    bulletCount = 3
  end
  if finalAttackSkillID == ___MOD._SkillBook.Final_Attack_1310_13101002 then
    bulletCount = 1
    ctx.attackCount = 1
  end
  local b = bulletCount
  if attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.ShadowPartner) ~= 0 then
    b = b * 2
  end
  if ___MOD._SkillLogic:isThrowBombSkill(skillID) then
    b = 0
  end
  if skillID == ___MOD._SkillBook.Taunt_422_4221003 then
    b = 0
  end
  local itemId, count, slot = inventory:findFirstThrowing(b)
  local result = self:checkUseConsumeClient(attacker, skillID, ctx.skillLevelData, itemId, count, b)
  if result ~= 0 then
    if result == -2 then
      pa.enableNextAttackTime = currentTime + 0.1
    end
    return false
  end
  if not self:canShootAttack(attacker, skillID) then
    return false
  end
  if isFinalAttack then
    pa:clearActionTimer()
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
  end
  local hitDelayInfo, lastAttackDelay = ___MOD._PlayerAttackLogic:makeHitDelayInfo(pa, ctx, sprites)
  if finalAttackSkillID == ___MOD._SkillBook.Final_Attack_1310_13101002 then
    lastAttackDelay = 0.5 * ctx.playRate
    hitDelayInfo = {
      [1] = lastAttackDelay * 1000
    }
  end
  if ctx.skillID == 0 then
    ___MOD._PlayerStateLogic:changeState(attacker, "NORMAL_ATTACK")
  else
    ___MOD._PlayerStateLogic:changeState(attacker, "SKILL_ATTACK")
  end
  local totalActionDelay = not (not ctx.motion or ___MOD._UtilLogic:IsNilorEmptyString(ctx.motion)) and pa:getTotalSkillActionDelay(ctx.motion, skillID) or 1
  local actionLockDelay = ___MOD._PlayerSkillLogic:getSkillActionLockDelaySec(attacker, skillID, ctx.motion, 1, 0)
  if attacker.TamingMobComponent ~= nil and attacker.TamingMobComponent.onTaming then
    local tamingMotion = ctx.motion
    if tamingMotion ~= nil and tamingMotion ~= "" then
      local tamingDelay = ___MOD._PlayerSkillLogic:getSkillActionLockDelaySec(attacker, skillID, tamingMotion, actionLockDelay, 0)
      if tamingDelay ~= nil and 0 < tamingDelay then
        actionLockDelay = tamingDelay
      end
    end
  end
  local attackDelay = lastAttackDelay ~= nil and lastAttackDelay or totalActionDelay
  if ___MOD._SkillLogic:isCooltimeSkill(skillID) then
    local cooltime = ___MOD._SkillLogic:getCooltime(skillID)
    if cooltime ~= 0 then
      local canUseSkills = attacker.PlayerVariables.canUseSkills
      if canUseSkills == nil then
        canUseSkills = {}
        attacker.PlayerVariables.canUseSkills = canUseSkills
      end
      canUseSkills[skillID] = ___MOD._UtilLogic.ServerElapsedSeconds + cooltime
      canUseSkills[___MOD.tostring(skillID)] = nil
    end
  end
  if ctx.playDefaultAttackAfterimage and not isFinalAttack then
    ___MOD._TimerService:SetTimerOnce(function()
      attacker.AfterImageComponent:playAfterImage(attacker.AfterImageComponent:getAfterimagePathByWeapon(), ctx.motion, ctx.playRate, attacker)
      local attackSound = ___MOD._WeaponType:getAttackSoundByWeaponType(weaponInfo.weaponType, false)
      local attackSoundRUID = ___MOD.__RUIDManager:get(attackSound)
      if attackSoundRUID ~= nil and attackSoundRUID ~= "" then
        ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(attackSoundRUID, attacker, attacker, 1)
      end
    end, attackDelay)
  end
  if not ctx.playDefaultAttackAfterimage and ctx.afterimageInfo and ctx.afterimageInfo.StartFrameIndex then
    ___MOD._TimerService:SetTimerOnce(function()
      local sprite = ctx.afterimageInfo[ctx.afterimageInfo.StartFrameIndex]
      if sprite ~= nil then
        ___MOD._ExtendedEffectService:playSkillAfterimageLocal(attacker, sprite, ctx.playRate, ___MOD.FastVector3.zero:Clone(), false)
      end
    end, attackDelay)
  end
  if ___MOD._AntiRepeat:tryRepeat(___MOD._AntiRepeatType.Attack) then
    if ___MOD._SkillLogic:isThrowBombSkill(skillID) then
      local sp = attacker.TransformComponent:PositionAsFastVector3()
      local maxCharge = ___MOD._SkillLogic:getMaxGaugeTime(skillID) / 1000
      local chargeRate = ___MOD.math.max(0.1, ___MOD.math.min(1.0, ___MOD.tonumber(chargePer) or 0.1))
      local t = ___MOD.math.min(maxCharge, ___MOD.math.max(maxCharge / 10, maxCharge * chargeRate))
      local playerInputX = attacker.PlayerControllerComponent.LookDirectionX
      local facingLeft = playerInputX == -1
      self:createGrenadeClient(attacker.CurrentMap, attacker, skillID, skillLevel, sp, t, facingLeft)
      local sad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(ctx.skillID, ctx.skillLevel, sp:ToVector2(), playerInputX, 0, bulletCount, ctx.motion, ___MOD._SkillAttackType.Shoot, {}, {}, {}, {}, totalActionDelay, ctx.playRate, attacker.PlayerControllerComponent.LookDirectionX == -1, 0, itemId, 0, 0, -1, nil, chargePer, false, nil)
      sad.clientActionLockDelay = actionLockDelay
      ___MOD._PlayerAttackLogic:applyPendingWindWalkAttackBoost(attacker, sad)
      ___MOD._PlayerAttackLogic:onPlayerAttack(attacker, sad:toTable())
      ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(attacker)
    else
      self:onAttack(attacker, itemId, bulletCount, attackDelay * 1000, skillID, skillLevel, weaponInfo.weaponType, ctx.motion, hitDelayInfo, ctx, false, slot, chargePer, forceTarget, actionLockDelay)
    end
    self:playEffect(attacker, ctx, totalActionDelay, weaponInfo.weaponType)
    if attacker.TamingMobComponent ~= nil and attacker.TamingMobComponent.onTaming and ctx.motion ~= nil and ctx.motion ~= "" then
      pa:reserveTamingActionLock(actionLockDelay)
    end
    if skillID == ___MOD._SkillBook.Recoil_Shot_520_5201006 then
      if attacker.PlayerVariables.wingsTimer ~= nil then
        ___MOD._PlayerSkillLogic:endWings(attacker, ___MOD._SkillBook.Wings_520_5201005)
      end
      local lv = skillLevel
      if lv < 1 then
        lv = 1
      end
      if 20 < lv then
        lv = 20
      end
      local base = 2.5
      local max = 4.0
      local t = (lv - 1) / 19.0
      local v = base + (max - base) * t
      local dir = -attacker.PlayerControllerComponent.LookDirectionX
      ___MOD._PlayerVecCtrl:SetImpactNext(v * dir, v)
    end
    if not isFinalAttack then
      local finalAttackDelay = attackDelay
      ___MOD._PlayerAttackLogic_FinalAttack:tryRegisterFinalAttack(attacker, skillID, skillLevel, weaponInfo.weaponType, finalAttackDelay)
    end
  else
    pa.enableNextAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds + 0.3
    return false
  end
  if not ___MOD._SkillLogic:isMoveAffectedSkill(skillID) and not ___MOD._SkillLogic:isCooltimeSkill(skillID) then
    ___MOD._PlayerSkillLogic:logSkillActionLockClient(attacker, "Shoot", skillID, ctx.motion, actionLockDelay, attackDelay * 1000, totalActionDelay)
    pa.enableNextAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds + actionLockDelay
    pa.enableNextRushTime = ___MOD._UtilLogic.ServerElapsedSeconds + 0.3
  else
    pa.enableNextAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds + 0.2
  end
  return true
end

function PlayerAttackLogic_Shoot.tryUseConsume(self, player, skillID, attackType, isMagic, senderUserId)

end
