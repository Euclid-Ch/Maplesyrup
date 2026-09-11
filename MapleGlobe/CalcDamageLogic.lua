

function CalcDamageLogic.applyAdminFixedDamage(self, attacker, damages, criticals)
  local fixedDamage = self:getAdminFixedDamage(attacker)
  if fixedDamage <= 0 or damages == nil then
    return
  end
  for i = 1, #damages do
    damages[i] = fixedDamage
    if criticals ~= nil then
      criticals[i] = false
    end
  end
end

function CalcDamageLogic.applyAdminFixedSingleDamage(self, attacker, damage)
  local fixedDamage = self:getAdminFixedDamage(attacker)
  if fixedDamage <= 0 then
    return damage
  end
  return fixedDamage
end

function CalcDamageLogic.applyAranMultiTargetDamageRate(self, attacker, damages, targetCount)
  local count = ___MOD.tonumber(targetCount) or 1
  if not damages or count <= 1 then
    return
  end
  if not (___MOD.isvalid(attacker) and attacker.Player) or not ___MOD._JobLogic:isAran(attacker.Player.Job) then
    return
  end
  local rate = self:getAranMultiTargetDamageRate(attacker.Player.Level, count)
  if 1 <= rate then
    return
  end
  for i = 1, #damages do
    local damage = ___MOD.tonumber(damages[i]) or 0
    if 0 < damage then
      damages[i] = ___MOD.math.max(1, ___MOD.math.floor(damage * rate))
    end
  end
end

function CalcDamageLogic.applyAttackDamageRateBoost(self, damages, skillID, skillLevel)
  if damages == nil or skillID <= 0 or skillLevel <= 0 then
    return
  end
  local levelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
  local damageRate = levelData ~= nil and (___MOD.tonumber(levelData.damage) or 0) or 0
  if damageRate <= 0 then
    return
  end
  local bonusRate = ___MOD.math.max(0, damageRate - 100) * 0.01
  for i = 1, #damages do
    local damage = ___MOD.tonumber(damages[i]) or 0
    if 0 < damage then
      damages[i] = ___MOD.math.max(1, ___MOD.math.floor(damage + damage * bonusRate))
    end
  end
end

function CalcDamageLogic.applyHiddenAttackDamageBoost(self, attacker, damages)
  if attacker == nil or attacker.CalcDamageComponent == nil or damages == nil then
    return
  end
  local windWalkSkillLevel = ___MOD.tonumber(attacker.CalcDamageComponent.windWalkAttackSkillLevel) or 0
  self:applyAttackDamageRateBoost(damages, ___MOD._SkillBook.Wind_Walk_1310_13101006, windWalkSkillLevel)
  local vanishSkillLevel = ___MOD.tonumber(attacker.CalcDamageComponent.vanishAttackSkillLevel) or 0
  self:applyAttackDamageRateBoost(damages, ___MOD._SkillBook.Vanish_1410_14100005, vanishSkillLevel)
end

function CalcDamageLogic.applyPDRateFinalDamage(self, attacker, mob, damages)
  if damages == nil then
    return
  end
  local damageMultiplier = self:getPDRateAdjustedDamageMultiplier(attacker, mob)
  if 1 <= damageMultiplier then
    return
  end
  local logEnabled = ___MOD.Environment:IsMakerPlay()
  local beforeTotalDamage = 0
  local afterTotalDamage = 0
  for i = 1, #damages do
    local damage = ___MOD.tonumber(damages[i]) or 0
    if 0 < damage then
      local adjustedDamage = ___MOD.math.max(1, ___MOD.math.floor(damage * damageMultiplier))
      if logEnabled then
        beforeTotalDamage = beforeTotalDamage + damage
        afterTotalDamage = afterTotalDamage + adjustedDamage
      end
      damages[i] = adjustedDamage
    end
  end
  if logEnabled then
    local mobInfo = mob.MobComponent.template
    local pdRate = ___MOD.math.max(0, ___MOD.tonumber(mobInfo.pdRate) or 0)
    local ss = attacker.PlayerSecondaryAbilityComponent
    local ignoreTargetDEF = ss ~= nil and ss:getTotalIgnoreTargetDEF() or 0
    local effectivePDRate = ___MOD.math.max(0, ___MOD.math.min(100, pdRate) - ___MOD.math.min(100, ignoreTargetDEF))
    local mobId = mob.MobComponent.id
    ___MOD.log(___MOD.string.format("[PDRateFinalDamage] mobId=%s pdRate=%.2f ignoreTargetDEF=%.2f effectivePDRate=%.2f multiplier=%.4f before=%d after=%d", ___MOD.tostring(mobId), pdRate, ignoreTargetDEF, effectivePDRate, damageMultiplier, ___MOD.math.floor(beforeTotalDamage), ___MOD.math.floor(afterTotalDamage)))
  end
end

function CalcDamageLogic.calcAttackDamage(self, attacker, skillID, attackMotion, mastery, isMagic, targetCount, bulletSlot, hitIndex, masteryPad)
  local secondaryStat = attacker.PlayerSecondaryAbilityComponent
  if not ___MOD.isvalid(secondaryStat) then
    return
  end
  local ts = attacker.PlayerTemporaryStatComponent
  local allStatR = 0
  if ts ~= nil then
    allStatR = ___MOD.tonumber(ts:getValue(___MOD._CTS.AllStatR)) or 0
  end
  local baseSTR = ___MOD.tonumber(attacker.Player.STR) or 0
  local baseDEX = ___MOD.tonumber(attacker.Player.DEX) or 0
  local baseINT = ___MOD.tonumber(attacker.Player.INT) or 0
  local baseLUK = ___MOD.tonumber(attacker.Player.LUK) or 0
  local bonusSTR = 0
  local bonusDEX = 0
  local bonusINT = 0
  local bonusLUK = 0
  if 0 < allStatR then
    bonusSTR = ___MOD.math.floor(baseSTR * allStatR * 0.01)
    bonusDEX = ___MOD.math.floor(baseDEX * allStatR * 0.01)
    bonusINT = ___MOD.math.floor(baseINT * allStatR * 0.01)
    bonusLUK = ___MOD.math.floor(baseLUK * allStatR * 0.01)
  end
  local str = baseSTR + secondaryStat.STR + bonusSTR
  local dex = baseDEX + secondaryStat.DEX + bonusDEX
  local int = baseINT + secondaryStat.INT + bonusINT
  local luk = baseLUK + secondaryStat.LUK + bonusLUK
  local primary = 0
  local secondary = 0
  local weaponMinConst = 0
  local weaponMaxConst = 0
  local damageConst = 1
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(attacker)
  local weaponType = weaponInfo.weaponType
  local hasNoAttackMotion = ___MOD._UtilLogic:IsNilorEmptyString(attackMotion)
  local lowerAttackMotion = hasNoAttackMotion and "" or ___MOD.string.lower(attackMotion)
  local isStab = ___MOD.string.find(lowerAttackMotion, "stab") ~= nil or false
  local isSwing = ___MOD.string.find(lowerAttackMotion, "swing") ~= nil or false
  local rand32 = attacker.CalcDamageComponent.playerDamageRandSeed
  local useSwingDamageConst = isSwing
  if skillID == ___MOD._SkillBook.Blast_122_1221009 and (weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponType == ___MOD._WeaponType.TWO_HANDED_MACE) then
    useSwingDamageConst = rand32:randomIntegerRange(1, 100) <= 50
  end
  if (skillID == ___MOD._SkillBook.Brandish_1111_11111004 or skillID == ___MOD._SkillBook.Brandish_112_1121008) and hitIndex == 2 and (weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.POLEARM or weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponType == ___MOD._WeaponType.TWO_HANDED_MACE or weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponType == ___MOD._WeaponType.TWO_HANDED_AXE) then
    isSwing = false
    isStab = true
  end
  if weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponType == ___MOD._WeaponType.WAND or weaponType == ___MOD._WeaponType.STAFF then
    weaponMinConst = 3.2
    weaponMaxConst = 4.4
  elseif weaponType == ___MOD._WeaponType.TWO_HANDED_AXE or weaponType == ___MOD._WeaponType.TWO_HANDED_MACE then
    weaponMinConst = 3.4
    weaponMaxConst = 4.8
  elseif weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.POLEARM then
    weaponMinConst = 3.0
    weaponMaxConst = 5.0
  elseif weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD then
    weaponMinConst = 4.0
    weaponMaxConst = 4.0
  elseif weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD then
    weaponMinConst = 4.6
    weaponMaxConst = 4.6
  elseif weaponType == ___MOD._WeaponType.KNUCKLE then
    weaponMinConst = 4.8
    weaponMaxConst = 4.8
  elseif weaponType == ___MOD._WeaponType.BOW then
    weaponMinConst = 3.4
    weaponMaxConst = 3.4
  elseif weaponType == ___MOD._WeaponType.CROSSBOW or weaponType == ___MOD._WeaponType.DAGGER or weaponType == ___MOD._WeaponType.GUN or weaponType == ___MOD._WeaponType.CLAW then
    weaponMinConst = 3.6
    weaponMaxConst = 3.6
  elseif weaponType == ___MOD._WeaponType.BARE_HANDS then
    weaponMinConst = 2.6
    weaponMaxConst = 4.8
  end
  if weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.POLEARM then
    primary = str
    secondary = dex
    if skillID == ___MOD._SkillBook.Dragon_Roar_131_1311006 then
      weaponMinConst = 4
      weaponMaxConst = 4
    elseif weaponType == ___MOD._WeaponType.SPEAR then
      weaponMinConst = hasNoAttackMotion and 5 or isSwing and 3 or 5
      weaponMaxConst = hasNoAttackMotion and 5 or isSwing and 3 or 5
    elseif weaponType == ___MOD._WeaponType.POLEARM then
      if ___MOD._JobLogic:isAran(attacker.Player.Job) and not isSwing then
        isSwing = true
      end
      weaponMinConst = hasNoAttackMotion and 5 or isSwing and 5 or 3
      weaponMaxConst = hasNoAttackMotion and 5 or isSwing and 5 or 3
    end
  elseif not ___MOD._UtilLogic:IsNilorEmptyString(attackMotion) and not self:isShootAction(attackMotion) and (weaponType == ___MOD._WeaponType.BOW or weaponType == ___MOD._WeaponType.CROSSBOW) then
    primary = dex
    secondary = str
    weaponMinConst = 3.4
    weaponMaxConst = 3.4
    damageConst = 0.6666666666666666
  elseif not ___MOD._UtilLogic:IsNilorEmptyString(attackMotion) and not self:isShootAction(attackMotion) and weaponType == ___MOD._WeaponType.CLAW then
    primary = luk
    secondary = str + dex
    weaponMinConst = 1
    weaponMaxConst = 1
    damageConst = 0.6666666666666666
  elseif attackMotion == "proneStab" then
    primary = str
    secondary = dex
    weaponMinConst = 1
    weaponMaxConst = 1
    damageConst = 0.041666666666666664
  elseif weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponType == ___MOD._WeaponType.DAGGER then
    local job = attacker.Player.Job
    local hundredsDigit = ___MOD.math.floor(job / 100) % 10
    local isThiefJob = hundredsDigit == 4
    if isThiefJob and weaponType == ___MOD._WeaponType.DAGGER then
      primary = luk
      secondary = str + dex
    else
      primary = str
      secondary = dex
      weaponMinConst = 4
      weaponMaxConst = 4
    end
  elseif weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponType == ___MOD._WeaponType.STAFF or weaponType == ___MOD._WeaponType.WAND then
    primary = str
    secondary = dex
    weaponMinConst = hasNoAttackMotion and 4.4 or useSwingDamageConst and 4.4 or 3.2
    weaponMaxConst = hasNoAttackMotion and 4.4 or useSwingDamageConst and 4.4 or 3.2
  elseif weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD then
    primary = str
    secondary = dex
  elseif weaponType == ___MOD._WeaponType.TWO_HANDED_AXE or weaponType == ___MOD._WeaponType.TWO_HANDED_MACE then
    primary = str
    secondary = dex
    weaponMinConst = hasNoAttackMotion and 4.8 or useSwingDamageConst and 4.8 or 3.4
    weaponMaxConst = hasNoAttackMotion and 4.8 or useSwingDamageConst and 4.8 or 3.4
  elseif weaponType == ___MOD._WeaponType.BOW or weaponType == ___MOD._WeaponType.CROSSBOW then
    primary = dex
    secondary = str
  elseif weaponType == ___MOD._WeaponType.CLAW then
    primary = luk
    secondary = str + dex
  elseif weaponType == ___MOD._WeaponType.KNUCKLE then
    primary = str
    secondary = dex
  elseif weaponType == ___MOD._WeaponType.GUN then
    primary = dex
    secondary = str
  end
  local firstPAD = attacker.Player.PAD
  local secondaryPAD = secondaryStat:getTotalPAD()
  local masteryPadValue = ___MOD.tonumber(masteryPad) or 0
  local padBeforeAmmo = firstPAD + secondaryPAD + masteryPadValue
  local pad = padBeforeAmmo
  local ammoPad = 0
  local ammoItemId = 0
  local useShadowStarsPAD = false
  local shadowStarsPAD = 0
  local pts = attacker.PlayerTemporaryStatComponent
  if weaponType == ___MOD._WeaponType.CLAW and pts ~= nil and pts:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 and pts:getSkillID(___MOD._CTS.NonComsumeBullet) == ___MOD._SkillBook.Shadow_Stars_412_4121006 then
    useShadowStarsPAD = true
    shadowStarsPAD = attacker.Player.bulletPAD or 0
  end
  if useShadowStarsPAD then
    ammoPad = shadowStarsPAD
    pad = pad + ammoPad
  elseif bulletSlot ~= -1 and bulletSlot ~= 0 then
    local inventory = attacker.CInventoryComponent
    local stack = inventory:getItemStack(___MOD._InventorySlotType.USE, bulletSlot)
    if stack ~= nil then
      local item = ___MOD._ItemManager:getItemById(stack.ItemId)
      if item ~= nil then
        local incPAD = item.incPAD
        ammoPad = ___MOD.tonumber(incPAD) or 0
        ammoItemId = stack.ItemId
        pad = pad + ammoPad
      end
    end
  elseif attacker.EquipmentComponent:hasSlotItem(___MOD._EquipmentSlotType.WEAPON, ___MOD._EquipmentSubSlotType.MAIN) then
    ammoPad = ___MOD.tonumber(attacker.Player.bulletPAD) or 0
    pad = pad + ammoPad
  end
  if weaponType == ___MOD._WeaponType.BARE_HANDS and (attacker.Player.Job >= 500 and attacker.Player.Job <= 522 or attacker.Player.Job >= 1500 and attacker.Player.Job <= 1512) then
    primary = str
    secondary = dex
    pad = pad + 1
  end
  local skillLevel = 0
  local skillLevelData
  if skillID ~= 0 then
    skillLevel = attacker.SkillComponent:getSkillLevel(skillID)
    skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
  end
  local minDamage, maxDamage = 0, 0
  if isMagic then
    if skillID == ___MOD._SkillBook.Heal_230_2301002 then
      local healRate = 0
      healRate = (1 + targetCount * 0.3) / targetCount
      local hp = skillLevelData.HP * 0.01
      secondary = luk
      local min = int * 0.2
      local max = int * 0.8
      weaponMinConst = 1.5
      weaponMaxConst = 1.5
      damageConst = 0.5
      local firstMAD = attacker.Player.MAD
      local secondaryMAD = secondaryStat:getTotalMAD()
      local mad = firstMAD + secondaryMAD
      minDamage = damageConst * healRate * hp * (min * weaponMinConst + secondary) * mad / 100
      maxDamage = damageConst * healRate * hp * (max * weaponMaxConst + secondary) * mad / 100
    else
      local firstMAD = attacker.Player.MAD
      local secondaryMAD = secondaryStat:getTotalMAD()
      local mad = firstMAD + secondaryMAD
      primary = mad
      local v0 = mad * 0.058
      secondary = v0 * v0 + int * 0.5
      weaponMinConst = 3.3
      weaponMaxConst = 3.3
      damageConst = 1
      minDamage = damageConst * (primary * (0.9 * ((10 + mastery * 5) / 100)) * weaponMinConst + secondary) * skillLevelData.MAD / 100
      maxDamage = damageConst * (primary * weaponMaxConst + secondary) * skillLevelData.MAD / 100
    end
  else
    local r = 0.9 * ((10 + mastery * 5) / 100)
    if skillID == ___MOD._SkillBook.Lucky_Seven_400_4001344 or skillID == ___MOD._SkillBook.Lucky_Seven_1400_14001004 or skillID == ___MOD._SkillBook.Triple_Throw_412_4121007 or skillID == ___MOD._SkillBook.Triple_throw_1411_14111005 then
      r = 0.5
      primary = luk
      secondary = 0
      weaponMinConst = 5
      weaponMaxConst = 5
      damageConst = 1
    end
    minDamage = damageConst * (primary * (weaponMinConst * r) + secondary) * pad / 100
    maxDamage = damageConst * (primary * weaponMaxConst + secondary) * pad / 100
  end
  if ___MOD.Environment.IsMakerPlay then
  end
  if minDamage < 0 or maxDamage < 0 or minDamage > maxDamage then
    ___MOD._WorldLogService:logHack(attacker, -522, ___MOD.string.format("[CalcAttackDamage][InvalidRange] user=%s skill=%d isMagic=%s weaponType=%d min=%.2f max=%.2f pad=%.2f playerPAD=%d secondaryPAD=%d PADEquip=%d masteryPad=%d primary=%.2f secondary=%.2f STR=%d DEX=%d INT=%d LUK=%d secSTR=%d secDEX=%d secINT=%d secLUK=%d playerMAD=%d secondaryMAD=%d MADEquip=%d", ___MOD.tostring(attacker.Player.PlayerId), ___MOD.tonumber(skillID) or 0, ___MOD.tostring(isMagic), ___MOD.tonumber(weaponType) or 0, ___MOD.tonumber(minDamage) or 0, ___MOD.tonumber(maxDamage) or 0, ___MOD.tonumber(pad) or 0, ___MOD.tonumber(firstPAD) or 0, ___MOD.tonumber(secondaryPAD) or 0, ___MOD.tonumber(secondaryStat.PADEquip) or 0, ___MOD.tonumber(masteryPad) or 0, ___MOD.tonumber(primary) or 0, ___MOD.tonumber(secondary) or 0, ___MOD.tonumber(str) or 0, ___MOD.tonumber(dex) or 0, ___MOD.tonumber(int) or 0, ___MOD.tonumber(luk) or 0, ___MOD.tonumber(secondaryStat.STR) or 0, ___MOD.tonumber(secondaryStat.DEX) or 0, ___MOD.tonumber(secondaryStat.INT) or 0, ___MOD.tonumber(secondaryStat.LUK) or 0, ___MOD.tonumber(attacker.Player.MAD) or 0, ___MOD.tonumber(secondaryStat:getTotalMAD()) or 0, ___MOD.tonumber(secondaryStat.MADEquip) or 0))
  end
  return minDamage, maxDamage
end

function CalcDamageLogic.calcDamage(self, attacker, mob, skillID, skillLevel, attackMotion, attackCount, finalAttackSkillID, targetCount, bulletSlot, mobOrder, chargePer, finishAttack)
  local damages = {}
  local criticals = {}
  local counter = 0
  local attackType = self:getSkillAttackType(skillID)
  if attackType == ___MOD._SkillAttackType.Magic then
    damages, criticals, counter = ___MOD._CalcDamageLogic:calcDamage_MDamagePvM(attacker, mob, skillID, skillLevel, attackMotion, attackCount, targetCount, mobOrder, chargePer)
  else
    damages, criticals, counter = ___MOD._CalcDamageLogic:calcDamage_PDamagePvM(attacker, mob, skillID, skillLevel, attackMotion, attackCount, finalAttackSkillID, bulletSlot, mobOrder, chargePer, finishAttack, targetCount)
  end
  return damages, criticals, counter
end

function CalcDamageLogic.calcDamage_MDamageMvM(self, user, attackMob, targetMob, attackInfo)
  local rand = user.CalcDamageComponent:getMobDamageRandSeed()
  local attackMobTemporary = attackMob.MobTemporaryStatComponent
  local attackMobTemplate = attackMob.MobComponent.template
  local targetMobTemporary = targetMob.MobTemporaryStatComponent
  local targetMobTemplate = targetMob.MobComponent.template
  local MA = 0
  MA = attackMobTemplate.maDamage + attackMobTemporary:getValue(___MOD._MTS.Mad)
  local nMobMADR = attackMobTemporary:getValue(___MOD._MTS.MadR)
  MA = MA + nMobMADR * 0.01 * nMobMADR
  local MD = targetMobTemplate.pdDamage
  local nMobMDR = targetMobTemporary:getValue(___MOD._MTS.Mdr)
  MD = MD + nMobMDR * 0.01 * nMobMDR
  local reduce, amp, dmg = 0, 0, 0
  if 0 < MD then
    reduce = ___MOD.math.floor(0.5 * MD) + rand:randomIntegerRange(1, ___MOD.math.floor(0.1 * MD))
  end
  amp = ___MOD.math.floor(0.8 * MA) + rand:randomIntegerRange(1, ___MOD.math.floor(0.05 * MA))
  dmg = ___MOD.math.floor(MA * (amp + 100) / 100) - reduce
  return dmg
end

function CalcDamageLogic.calcDamage_MDamageMvP(self, player, mob, mobAttack, rand)
  local eMob = mob.MobComponent
  if not ___MOD.isvalid(eMob) then
    return nil
  end
  local ss = player.PlayerSecondaryAbilityComponent
  local mdd = player.Player.MDD + ss.MDD
  local str = player.Player.STR + ss.STR
  local int = player.Player.INT + ss.INT
  local dex = player.Player.DEX + ss.DEX
  local luk = player.Player.LUK + ss.LUK
  local mobMad = 0
  local mtsMad = 0
  local mobInfo = mob.MobComponent.template
  if ___MOD.isvalid(mobInfo) then
    mobMad = mobInfo.maDamage
  end
  mobMad = mobMad + mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Mad)
  local mobMadR = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.MadR)
  mobMad = ___MOD.math.max(0, mobMad + mobMad * 0.01 * mobMadR)
  local minRand = mobMad * 0.75
  local maxRand = mobMad * 0.8
  local r = rand:randomDoubleRange(minRand, maxRand)
  local t = r * mobMad * 0.01
  local base = str / 7 + luk / 5 + dex / 6 + mdd
  local mod = 0
  local jobClass = ___MOD._SkillLogic:getJobClass(player.Player.Job)
  if jobClass == 2 then
    mod = base * 0.3
  else
    mod = base * 0.25
  end
  local reduce = 0
  local mesoCost = 0
  local damage = t - mod
  local magicUp = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.MagicUp)
  if magicUp ~= 0 then
    damage = damage * (magicUp * 0.01)
  end
  if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.MesoGuard) ~= 0 then
    reduce, mesoCost = self:getMesoGuardReduce(player, damage)
    damage = damage - reduce
  end
  damage = ___MOD.math.floor(damage)
  damage = ___MOD.math.max(1, damage)
  return damage, reduce, mesoCost
end

function CalcDamageLogic.calcDamage_MDamageMvS(self, mobEntity, attackInfo, nSLV, rand)
  local mob = mobEntity.MobComponent
  if mob == nil then
    return nil
  end
  local ms = mobEntity.MobTemporaryStatComponent
  local template = mob.template
  if template == nil then
    return nil
  end
  local nMobMAD = template.maDamage + ms:getValue(___MOD._MTS.Mad)
  local nMobMADR = ms:getValue(___MOD._MTS.MadR)
  nMobMAD = nMobMAD + nMobMADR * 0.01 * nMobMADR
  local a = nMobMAD * 0.1
  local b = nMobMAD * 0.8
  if a > b then
    a, b = b, a
  end
  local rInt = rand:randomIntegerRange(0, 9999999)
  local u = rInt * 1.00000010000001E-7
  local v4 = a + (b - a) * u
  return ___MOD.math.floor(40 / (nSLV + 70) * nMobMAD * v4 * 0.01)
end

function CalcDamageLogic.calcDamage_MDamagePvM(self, attacker, mob, skillID, skillLevel, attackMotion, attackCount, targetCount, mobOrder, chargePer)
  local damages = {}
  local criticals = {}
  local normalMaxDamage = ___MOD._PlayerConstants.MAX_DAMAGE
  local criticalMaxDamage = ___MOD._PlayerConstants.MAX_CRITICAL_DAMAGE
  local levelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
  local s = attacker.Player
  local ss = attacker.PlayerSecondaryAbilityComponent
  local ts = attacker.PlayerTemporaryStatComponent
  local rand32 = attacker.CalcDamageComponent:getPlayerDamageRandSeed()
  local sr = attacker.CalcDamageComponent:getStatRandSeed()
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(attacker)
  local mastery = 0
  local mobEva = 0
  local mobMdd = 0
  local mobInfo = mob.MobComponent.template
  if ___MOD.isvalid(mobInfo) then
    mobEva = ___MOD.math.min(___MOD._PlayerConstants.MAX_EVA, mobInfo.eva + mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Eva))
    mobMdd = mobInfo.pdDamage
    local mdr = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Mdr)
    mobMdd = mobMdd + mobMdd * 0.01 * mdr
    mobMdd = ___MOD.math.min(___MOD._PlayerConstants.MAX_MDD, ___MOD.math.max(0, mobMdd))
  end
  local allStatR = ___MOD.tonumber(ts:getValue(___MOD._CTS.AllStatR)) or 0
  local baseINT = ___MOD.tonumber(s.INT) or 0
  local baseLUK = ___MOD.tonumber(s.LUK) or 0
  local bonusINT = 0
  local bonusLUK = 0
  if allStatR ~= 0 then
    bonusINT = ___MOD.math.floor(baseINT * allStatR * 0.01)
    bonusLUK = ___MOD.math.floor(baseLUK * allStatR * 0.01)
  end
  local int = baseINT + ss.INT + bonusINT
  local luk = baseLUK + ss.LUK + bonusLUK
  local acc = 5 * (int // 10 + luk // 10)
  if levelData ~= nil then
    mastery = levelData.mastery
  end
  local amp = self:getAmplification(attacker, skillID)
  local appliedSkillDamageRate = amp * 0.01
  local totalDamageRate = ___MOD.tonumber(ss.PotentialIncDAMr) or 0
  totalDamageRate = totalDamageRate + (___MOD.tonumber(ts:getValue(___MOD._CTS.DojangDamR)) or 0)
  if mob.MobComponent.boss then
    totalDamageRate = totalDamageRate + ss:getTotalBossDamageRate()
  end
  local totalDamageMul = 1 + totalDamageRate * 0.01
  local eMob = mob.MobComponent
  if not ___MOD.isvalid(eMob) then
    return nil
  end
  local levelDelta = ___MOD.math.max(0, eMob.level - s.Level)
  local accr = 100 * acc / (10 * levelDelta + 255)
  local mCounter = self:getCounterDamage(mob, skillID)
  local minDamage, maxDamage = self:calcAttackDamage(attacker, skillID, attackMotion, mastery, true, targetCount, -1, 0, 0)
  for i = 1, attackCount do
    if 0 < skillID and levelData ~= nil and 0 < levelData.fixDamage then
      accr = 100 * s.Level / (150 * levelDelta + 255)
      local accRateMin = accr * 0.7
      local accRateMax = accr * 1.3
      if mobEva > sr:randomIntegerRange(accRateMin, accRateMax) then
        damages[i] = 0
        criticals[i] = false
      else
        damages[i] = levelData.fixDamage
        criticals[i] = false
        local accRateMin = accr * 0.5
        local accRateMax = accr * 1.2
        if mobEva > sr:randomIntegerRange(accRateMin, accRateMax) then
          damages[i] = 0
          criticals[i] = false
        else
          damages[i] = levelData.fixDamage
          criticals[i] = false
          local damage = 0
          local critical = false
          damage = rand32:randomIntegerRange(minDamage, maxDamage)
          if mobEva > sr:randomIntegerRange(accRateMin, accRateMax) then
            damages[i] = 0
            criticals[i] = false
          else
            local mdd = rand32:randomIntegerRange(5 * mobMdd, 6 * mobMdd) / 10
            if mdd ~= 0 then
              damage = damage - mdd
            end
            if mob.MobTemporaryStatComponent:getValue(___MOD._MTS.MImmune) ~= 0 or mCounter ~= 0 then
              damages[i] = 1
              criticals[i] = false
            elseif attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Seal) ~= 0 then
              damages[i] = 0
              criticals[i] = false
            else
              if s.Level < eMob.level then
                local damageDec = 100 - (eMob.level - s.Level)
                damage = damage * (damageDec * 0.01)
              end
              damage = ___MOD._CalcDamageLogic_Element:getDamageAdjustedByElemAttr(attacker, mob, damage * appliedSkillDamageRate, skillID, skillLevel)
              if ___MOD._SkillLogic:isKeyDownSkill(skillID) then
                damage = damage * chargePer
              end
              if not ___MOD._SkillLogic:isIgnoreMGuardUpSkill(skillID) then
                local mGuardUp = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.MGuardUp)
                if mGuardUp ~= 0 then
                  damage = damage * (mGuardUp * 0.01)
                end
              end
              damage = damage * totalDamageMul
              local criticalProp = ss.CriticalRate
              local criticalPropRate = ___MOD.tonumber(ss.PotentialIncCrRate) or 0
              if 0 < criticalPropRate then
                criticalProp = criticalProp + criticalPropRate
              end
              local tsCriticalRate = 0
              if ts then
                local tsBuffCriticalRate = ___MOD.tonumber(ts:getValue(___MOD._CTS.CriticalRate)) or 0
                local tsComboCriticalRate = ___MOD.tonumber(ts:getValue(___MOD._CTS.ComboAttackCriticalRate)) or 0
                tsCriticalRate = ___MOD.math.max(0, tsBuffCriticalRate + tsComboCriticalRate)
              end
              if 0 < tsCriticalRate then
                criticalProp = criticalProp + tsCriticalRate
              end
              criticalProp = ___MOD.math.max(0, ___MOD.math.min(100, criticalProp))
              local baseCriticalDamage = ___MOD.tonumber(ss.CriticalDamage) or 0
              local criticalDamage = baseCriticalDamage / 100
              local tsCriticalDamageBonus = 0
              if ts then
                local tsBuffCriticalDamage = ___MOD.math.max(0, ___MOD.tonumber(ts:getValue(___MOD._CTS.CriticalDamage)) or 0)
                local tsComboCriticalDamage = ___MOD.math.max(0, ___MOD.tonumber(ts:getValue(___MOD._CTS.ComboAttackCriticalDamage)) or 0)
                tsCriticalDamageBonus = (tsBuffCriticalDamage + tsComboCriticalDamage) / 100
              end
              if not ___MOD._SkillLogic:isIgnoreCriticalSkill(skillID) and criticalProp >= rand32:randomIntegerRange(1, 100) then
                critical = true
                local criticalBaseDamage = 0 < appliedSkillDamageRate and damage / appliedSkillDamageRate or damage
                local incDam = criticalBaseDamage * (criticalDamage + tsCriticalDamageBonus)
                damage = damage + incDam
              end
              damage = damage + self:getFinalTossDamageBonus(mob, damage, appliedSkillDamageRate)
              criticals[i] = critical
              local maxDamageLimit = critical and criticalMaxDamage or normalMaxDamage
              damages[i] = ___MOD.math.min(___MOD.math.max(1, ___MOD.math.floor(damage)), maxDamageLimit)
              if mob.MobTemporaryStatComponent:getValue(___MOD._MTS.HardSkin) ~= 0 and not critical then
                damages[i] = 1
              end
            end
          end
        end
      end
    end
  end
  ___MOD._DamageDecRate:adjustDamageDecRate(skillID, skillLevel, damages, mobOrder, false, levelData ~= nil and levelData.x or 0)
  self:applyAranMultiTargetDamageRate(attacker, damages, targetCount)
  self:applyHiddenAttackDamageBoost(attacker, damages)
  self:applyPDRateFinalDamage(attacker, mob, damages)
  self:applyAdminFixedDamage(attacker, damages, criticals)
  return damages, criticals, mCounter
end

function CalcDamageLogic.calcDamage_MDamageSvM(self, owner, mobEntity, skillID, SLV)
  local mob = mobEntity.MobComponent
  if mob == nil then
    return nil
  end
  local ms = mobEntity.MobTemporaryStatComponent
  local mobTemplate = mob.template
  if mobTemplate == nil then
    return nil
  end
  local p = owner.Player
  local ss = owner.PlayerSecondaryAbilityComponent
  if not p or not ss then
    return nil
  end
  local levelData = ___MOD._SkillManager:getSkillLevelData(skillID, SLV)
  if not levelData then
    return nil
  end
  local MAD = levelData.MAD
  local rand_dmg = owner.CalcDamageComponent:getPlayerDamageRandSeed()
  local rand_miss = owner.CalcDamageComponent:getDamageMissRandSeed()
  local INT, LUK = p.INT + ss.INT, p.LUK + ss.LUK
  local acc = ___MOD.math.floor(5 * (INT // 10 + LUK // 10))
  local eva = ___MOD.math.clamp(mobTemplate.eva + ms:getValue(___MOD._MTS.Eva), 0, 999)
  local levelDelta = ___MOD.math.max(mobTemplate.level - p.Level, 0)
  local hitBase = acc * 100 / (levelDelta * 10 + 255)
  local hitRoll = rand_miss:randomDoubleRange(hitBase * 0.5, hitBase * 1.2)
  if eva > hitRoll or mobTemplate.invincible then
    return 0
  end
  if ms:getValue(___MOD._MTS.MImmune) ~= 0 then
    return 1
  end
  local pMAD = ___MOD.math.clamp(p.MAD + ss:getTotalMAD(), 0, ___MOD._PlayerConstants.MAX_MAD)
  local mastery = (levelData.mastery * 5 + 10) * 0.009000000000000001
  local madMin = ___MOD.math.min(pMAD, pMAD * mastery)
  local madMax = ___MOD.math.max(pMAD, pMAD * mastery)
  local madRoll = rand_dmg:randomDoubleRange(madMin, madMax)
  local damage = (INT * 0.5 + pMAD * 0.058 * (pMAD * 0.058) + madRoll * 3.3) * MAD * 0.01
  return self:applyAdminFixedSingleDamage(owner, ___MOD.math.floor(___MOD.math.max(1, ___MOD._CalcDamageLogic_Element:getDamageAdjustedByElemAttr(owner, mobEntity, damage, skillID, SLV))))
end

function CalcDamageLogic.calcDamage_MesoExplosion(self, player, mob, skillID, skillLevel, mesos)
  local damages = {}
  local criticals = {}
  local skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
  if skillLevelData == nil then
    return nil
  end
  local x = skillLevelData.x
  local rand32 = player.CalcDamageComponent:getPlayerDamageRandSeed()
  for _, meso in ___MOD.ipairs(mesos) do
    if meso == 0 then
      break
    end
    local minDamage = 0
    if meso <= 1000 then
      minDamage = 50 * x * 0.5 * (meso * 0.82 + 28) / 5300
    else
      minDamage = 50 * x * 0.5 * meso / (meso + 5300)
    end
    local maxDamage = minDamage * 2
    local damage = ___MOD.math.floor(___MOD.math.max(1, (rand32:randomIntegerRange(minDamage, maxDamage))))
    damages[#damages + 1] = damage
    criticals[#criticals + 1] = false
  end
  self:applyAdminFixedDamage(player, damages, criticals)
  return damages, criticals
end

function CalcDamageLogic.calcDamage_PDamageMvM(self, user, attackMob, targetMob, attackInfo)
  local rand = user.CalcDamageComponent:getMobDamageRandSeed()
  local attackMobTemporary = attackMob.MobTemporaryStatComponent
  local attackMobTemplate = attackMob.MobComponent.template
  local targetMobTemporary = targetMob.MobTemporaryStatComponent
  local targetMobTemplate = targetMob.MobComponent.template
  local PA = 0
  if attackInfo and 0 < attackInfo.paDamage then
    PA = attackInfo.paDamage + attackMobTemporary:getValue(___MOD._MTS.Pad)
  else
    PA = attackMobTemplate.paDamage + attackMobTemporary:getValue(___MOD._MTS.Pad)
  end
  local nMobPADR = attackMobTemporary:getValue(___MOD._MTS.PadR)
  PA = PA + nMobPADR * 0.01 * nMobPADR
  local PD = targetMobTemplate.pdDamage
  local nMobPDR = targetMobTemporary:getValue(___MOD._MTS.Pdr)
  PD = PD + nMobPDR * 0.01 * nMobPDR
  local reduce, amp, dmg = 0, 0, 0
  if 0 < PD then
    reduce = ___MOD.math.floor(0.5 * PD) + rand:randomIntegerRange(1, ___MOD.math.floor(0.1 * PD))
  end
  amp = ___MOD.math.floor(0.8 * PA) + rand:randomIntegerRange(1, ___MOD.math.floor(0.05 * PA))
  dmg = ___MOD.math.floor(PA * (amp + 100) / 100) - reduce
  return dmg
end

function CalcDamageLogic.calcDamage_PDamageMvP(self, player, mob, mobAttack, rand)
  local eMob = mob.MobComponent
  if not ___MOD.isvalid(eMob) then
    return nil
  end
  local ss = player.PlayerSecondaryAbilityComponent
  local pdd = player.Player.PDD + ss.PDD
  local str = player.Player.STR + ss.STR
  local int = player.Player.INT + ss.INT
  local dex = player.Player.DEX + ss.DEX
  local luk = player.Player.LUK + ss.LUK
  local mobPad = 0
  local mtsPad = 0
  if mobAttack and 0 < mobAttack.paDamage then
    mobPad = mobAttack.paDamage
  else
    local mobInfo = mob.MobComponent.template
    if mobInfo then
      mobPad = mobInfo.paDamage
    end
  end
  mobPad = mobPad + mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Pad)
  local mobPadR = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.PadR)
  mobPad = ___MOD.math.max(0, mobPad + mobPad * 0.01 * mobPadR)
  local level = player.Player.Level
  local minRand = mobPad * 0.8
  local maxRand = mobPad * 0.85
  local r = rand:randomDoubleRange(minRand, maxRand)
  local jobClass = ___MOD._SkillLogic:getJobClass(player.Player.Job)
  if jobClass == 5 then
    jobClass = 0
  end
  local standardPDD = ___MOD._BaseManager:getStandardPDD(jobClass, level)
  local t = r * mobPad * 0.01
  local base = 0
  if jobClass == 1 then
    local v0 = (luk + dex) / 4 + int / 9
    local v1 = str * 2 / 7
    base = ___MOD.math.floor(v0 + v1)
  else
    local v0 = int / 9 + dex * 2 / 7 + str * 0.4
    local v1 = luk / 4
    base = ___MOD.math.floor(v0 + v1)
  end
  local mod = base * 0.00125
  local fac = 0
  if pdd < standardPDD then
    local opt = level / 550 + mod + 0.28
    if level >= eMob.level then
      fac = opt * (pdd - standardPDD) * 13 / (level - eMob.level + 13)
    else
      fac = opt * (pdd - standardPDD) * 1.3
    end
  else
    fac = base / 900 + (level / 1300 + 0.28) * (pdd - standardPDD) * 0.7
  end
  local invincible = player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Invincible)
  local def = t - (fac + (mod + 0.28) * pdd)
  local damage = def - invincible * def / 100
  local reduce = 0
  local mesoCost = 0
  local powerUp = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.PowerUp)
  if powerUp ~= 0 then
    damage = damage * (powerUp * 0.01)
  end
  if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.MesoGuard) ~= 0 then
    reduce, mesoCost = self:getMesoGuardReduce(player, damage)
    damage = damage - reduce
  end
  damage = ___MOD.math.floor(damage)
  damage = ___MOD.math.max(1, damage)
  return damage, reduce, mesoCost
end

function CalcDamageLogic.calcDamage_PDamageMvS(self, mobEntity, attackInfo, nSLV, rand)
  local mob = mobEntity.MobComponent
  if mob == nil then
    return nil
  end
  local ms = mobEntity.MobTemporaryStatComponent
  local template = mob.template
  if template == nil then
    return nil
  end
  local nMobPAD = 0
  if attackInfo and 0 < attackInfo.paDamage then
    nMobPAD = attackInfo.paDamage + ms:getValue(___MOD._MTS.Pad)
  else
    nMobPAD = template.paDamage + ms:getValue(___MOD._MTS.Pad)
  end
  local nMobPADR = ms:getValue(___MOD._MTS.PadR)
  nMobPAD = nMobPAD + nMobPADR * 0.01 * nMobPADR
  local a = nMobPAD * 0.1
  local b = nMobPAD * 0.85
  if a > b then
    a, b = b, a
  end
  local rInt = rand:randomIntegerRange(0, 9999999)
  local u = rInt * 1.00000010000001E-7
  local v4 = a + (b - a) * u
  return ___MOD.math.floor(40 / (nSLV + 70) * nMobPAD * v4 * 0.01)
end

function CalcDamageLogic.calcDamage_PDamagePvM(self, attacker, mob, skillID, skillLevel, attackMotion, attackCount, finalAttackSkillID, bulletSlot, mobOrder, chargePer, finishAttack, targetCount, damageRandOverride, statRandOverride)
  local damages = {}
  local criticals = {}
  local normalMaxDamage = ___MOD._PlayerConstants.MAX_DAMAGE
  local criticalMaxDamage = ___MOD._PlayerConstants.MAX_CRITICAL_DAMAGE
  local levelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
  local damageRateLevelData = self:getAppliedDamageRateLevelData(attacker, skillID, skillLevel, levelData)
  local s = attacker.Player
  local ss = attacker.PlayerSecondaryAbilityComponent
  local ts = attacker.PlayerTemporaryStatComponent
  local rand32 = damageRandOverride
  if rand32 == nil then
    rand32 = attacker.CalcDamageComponent:getPlayerDamageRandSeed()
  end
  local sr = statRandOverride
  if sr == nil then
    sr = attacker.CalcDamageComponent:getStatRandSeed()
  end
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(attacker)
  local mastery, acc, masteryPad = 0, 0, 0
  if weaponInfo.valid then
    mastery, acc, ___MOD._, ___MOD._, masteryPad = ___MOD._MasteryLogic:getMastery(attacker, weaponInfo.weaponType, weaponInfo.attackType)
  end
  acc = s.ACC + ss:getTotalACC() + acc
  local eMob = mob.MobComponent
  if not ___MOD.isvalid(eMob) then
    return nil
  end
  local mobEva = 0
  local mobPdd = 0
  local mobInfo = mob.MobComponent.template
  if ___MOD.isvalid(mobInfo) then
    mobEva = ___MOD.math.min(___MOD._PlayerConstants.MAX_EVA, mobInfo.eva + mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Eva))
    mobPdd = mobInfo.pdDamage
    local pdr = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Pdr)
    local tauntIndex = ___MOD._MTS.Taunt
    local taunt = tauntIndex ~= nil and mob.MobTemporaryStatComponent:getValue(tauntIndex) or 0
    if mobInfo.boss then
      taunt = 0
    end
    if taunt ~= 0 then
      pdr = pdr + taunt
    end
    mobPdd = mobPdd + mobPdd * 0.01 * pdr
    mobPdd = ___MOD.math.min(___MOD._PlayerConstants.MAX_PDD, ___MOD.math.max(0, mobPdd))
  end
  local levelDelta = ___MOD.math.max(0, eMob.level - s.Level)
  local accRate = 100 * acc / (10 * levelDelta + 255)
  local accRateMin = accRate * 0.7
  local accRateMax = accRate * 1.3
  local criticalProp = ss.CriticalRate
  local criticalPropRate = ___MOD.tonumber(ss.PotentialIncCrRate) or 0
  if 0 < criticalPropRate then
    criticalProp = criticalProp + criticalPropRate
  end
  local tsCriticalRate = 0
  if ts then
    local tsBuffCriticalRate = ___MOD.tonumber(ts:getValue(___MOD._CTS.CriticalRate)) or 0
    local tsComboCriticalRate = ___MOD.tonumber(ts:getValue(___MOD._CTS.ComboAttackCriticalRate)) or 0
    tsCriticalRate = ___MOD.math.max(0, tsBuffCriticalRate + tsComboCriticalRate)
  end
  if 0 < tsCriticalRate then
    criticalProp = criticalProp + tsCriticalRate
  end
  criticalProp = ___MOD.math.max(0, ___MOD.math.min(100, criticalProp))
  local baseCriticalDamage = ___MOD.tonumber(ss.CriticalDamage) or 0
  local criticalDamage = baseCriticalDamage / 100
  local tsCriticalDamageBonus = 0
  if ts then
    local tsBuffCriticalDamage = ___MOD.math.max(0, ___MOD.tonumber(ts:getValue(___MOD._CTS.CriticalDamage)) or 0)
    local tsComboCriticalDamage = ___MOD.math.max(0, ___MOD.tonumber(ts:getValue(___MOD._CTS.ComboAttackCriticalDamage)) or 0)
    tsCriticalDamageBonus = (tsBuffCriticalDamage + tsComboCriticalDamage) / 100
  end
  local pCounter = self:getCounterDamage(mob, skillID)
  local appliedSkillDamageRate = 1
  local totalDamageRate = ___MOD.tonumber(ss.PotentialIncDAMr) or 0
  totalDamageRate = totalDamageRate + (___MOD.tonumber(ts:getValue(___MOD._CTS.DojangDamR)) or 0)
  if mob.MobComponent.boss then
    totalDamageRate = totalDamageRate + ss:getTotalBossDamageRate()
  end
  local totalDamageMul = 1 + totalDamageRate * 0.01
  local ignoreTargetDEF = ss:getTotalIgnoreTargetDEF()
  ignoreTargetDEF = ___MOD.math.max(0, ___MOD.math.min(100, ignoreTargetDEF))
  local homingSkillID = mob.MobTemporaryStatComponent:getSkillID(___MOD._MTS.Homing)
  local homingOwner = mob.MobTemporaryStatComponent:getOwner(___MOD._MTS.Homing)
  if homingSkillID == ___MOD._SkillBook.Bullseye_522_5220011 and (homingOwner == attacker.Player.PlayerId or attacker.PlayerVariables.homingMob == mob) then
    local sld = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Bullseye_522_5220011, attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Bullseye_522_5220011))
    if sld then
      totalDamageMul = totalDamageMul + sld.x / 100
    end
  end
  local hasBullet = 0 < bulletSlot or ts:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 and ts:getSkillID(___MOD._CTS.NonComsumeBullet) == ___MOD._SkillBook.Shadow_Stars_412_4121006 and 0 < (___MOD.tonumber(attacker.Player.preConsumedBulletItemID) or 0)
  for i = 1, attackCount do
    if ts:getValue(___MOD._CTS.ShadowPartner) ~= 0 and 1 < attackCount and hasBullet then
      local lastIdx = attackCount // 2
      if i > lastIdx then
        local sid = ___MOD._SkillBook.Shadow_Partner_411_4111002
        if attacker.Player.Job >= 1400 and attacker.Player.Job <= 1412 then
          sid = ___MOD._SkillBook.Shadow_Partner_1411_14111000
        end
        local slv = attacker.SkillComponent:getSkillLevel(sid)
        local ld = ___MOD._SkillManager:getSkillLevelData(sid, slv)
        local damage_ = skillID ~= 0 and ld.y or ld.x
        criticals[i] = criticals[i - lastIdx]
        local maxDamageLimit = criticals[i] and criticalMaxDamage or normalMaxDamage
        damages[i] = ___MOD.math.min(___MOD.math.max(1, ___MOD.math.floor(damages[i - lastIdx] * (damage_ * 0.01))), maxDamageLimit)
    end
    else
      local damage = 0
      local critical = false
      local compCritical = false
      local minDamage, maxDamage = self:calcAttackDamage(attacker, skillID, attackMotion, mastery, false, 0, bulletSlot, i, masteryPad)
      damage = rand32:randomIntegerRange(minDamage, maxDamage)
      if skillID == ___MOD._SkillBook.Flamethrower_521_5211004 or skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 then
        local inventory = attacker.CInventoryComponent
        if skillID == ___MOD._SkillBook.Flamethrower_521_5211004 then
          local item = inventory:findFirstItem(2331000)
          if item == 0 then
            damage = damage * 0.5
          end
        end
        if skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 then
          local item = inventory:findFirstItem(2332000)
          if item == 0 then
            damage = damage * 0.5
          end
        end
      elseif skillID == ___MOD._SkillBook.Hypnotize_522_5221009 then
        damages[i] = 0
        criticals[i] = false
        goto lbl_1035
      end
      if not mob.MobComponent.boss and finishAttack and (skillID == ___MOD._SkillBook.Mortal_Blow_311_3110001 or skillID == ___MOD._SkillBook.Mortal_Blow_321_3210001 or skillID == ___MOD._SkillBook.Strafe_321_3211006) then
        damages[i] = mob.MobComponent.maxHP
        criticals[i] = true
      else
        if skillID == ___MOD._SkillBook.Heavens_Hammer_122_1221011 and mob.MobComponent.boss then
          damages[i] = sr:randomIntegerRange(450000, 499999)
          goto lbl_1035
        elseif skillID == ___MOD._SkillBook.Snipe_322_3221007 and not mob.MobComponent.boss then
          damages[i] = sr:randomIntegerRange(300000, 500000)
          criticals[i] = true
          goto lbl_1035
        elseif skillID == ___MOD._SkillBook.Barrage_512_5121007 or skillID == ___MOD._SkillBook.Barrage_1511_15111004 then
          if i == 5 then
            damage = damage * 2
          elseif i == 6 then
            damage = damage * 4
          end
        elseif skillID == ___MOD._SkillBook.Demolition_512_5121004 and i == 8 then
          compCritical = true
          if criticalDamage < 2 then
            criticalDamage = 2
          end
        end
        if mobEva > sr:randomIntegerRange(accRateMin, accRateMax) then
          damages[i] = 0
          criticals[i] = false
        elseif attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Darkness) ~= 0 and sr:randomIntegerRange(1, 100) <= 50 then
          damages[i] = 0
          criticals[i] = false
        else
          if skillID ~= 0 and levelData ~= nil then
            if (skillID == ___MOD._SkillBook.Taunt_412_4121003 or skillID == ___MOD._SkillBook.Taunt_422_4221003) and not mob.MobComponent.boss then
              damage = damage * 0.2
            else
              if 0 < levelData.fixDamage then
                if mobEva > sr:randomIntegerRange(accRateMin, accRateMax) then
                  damages[i] = 0
                  criticals[i] = false
                  goto lbl_1035
                end
                damages[i] = levelData.fixDamage
                criticals[i] = false
                goto lbl_1035
              end
              if skillID == ___MOD._SkillBook.Snipe_322_3221007 then
                appliedSkillDamageRate = 30.0
                damage = damage * appliedSkillDamageRate
              elseif 0 < finalAttackSkillID then
                local finalAttackSLV = attacker.SkillComponent:getSkillLevel(finalAttackSkillID)
                local finalAttack = ___MOD._SkillManager:getSkillLevelData(finalAttackSkillID, finalAttackSLV)
                if finalAttack ~= nil and 0 < finalAttack.damage then
                  appliedSkillDamageRate = finalAttack.damage / 100
                  damage = damage * appliedSkillDamageRate
                end
              elseif damageRateLevelData ~= nil and 0 < damageRateLevelData.damage then
                local dam = damageRateLevelData.damage
                if skillID == ___MOD._SkillBook.Spark_1511_15111006 then
                  local sparkDamage = self:getSparkDamageRate(attacker)
                  if 0 < sparkDamage then
                    dam = sparkDamage
                  end
                end
                if skillID == ___MOD._SkillBook.Flamethrower_521_5211004 or skillID == ___MOD._SkillBook.Ice_Splitter_521_5211005 then
                  local slv = attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Elemental_Boost_522_5220001)
                  if 0 < slv then
                    local sld = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Elemental_Boost_522_5220001, slv)
                    if sld then
                      dam = dam + sld.damage
                    end
                  end
                end
                appliedSkillDamageRate = dam / 100
                damage = damage * appliedSkillDamageRate
              end
            end
          end
          if skillID == ___MOD._SkillBook.Shadow_Meso_411_4111004 then
            local sld = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
            if sld ~= nil then
              local moneyConsume = sld.moneyConsume
              local base = moneyConsume / 2
              local min = base
              local max = base * 3
              damage = 10 * ___MOD.math.floor(rand32:randomIntegerRange(min, max))
              if sld.prop >= rand32:randomIntegerRange(1, 100) then
                damage = damage * ((100 + sld.x) * 0.01)
                critical = true
              end
            end
          end
          if s.Level < eMob.level then
            local damageDec = 100 - (eMob.level - s.Level)
            damage = damage * (damageDec * 0.01)
          end
          damage = ___MOD._CalcDamageLogic_Element:getDamageAdjustedByElemAttr(attacker, mob, damage, skillID, skillLevel)
          local base = damage
          local main = ___MOD._CalcDamageLogic_Element:getDamageAdjustedByChargedElemAttr(attacker, mob, base)
          main = ___MOD._CalcDamageLogic_Element:getDamageAdjustedByPhysicalElemAttr(attacker, mob, main, skillID, true)
          local assist = ___MOD._CalcDamageLogic_Element:getDamageAdjustedByAssistChargedElemAttr(attacker, mob, base)
          damage = main + assist
          if not ___MOD._SkillLogic:isIgnorePDefSkill(skillID) then
            local effectivePdd = mobPdd
            if 0 < ignoreTargetDEF then
              effectivePdd = effectivePdd * (1 - ignoreTargetDEF * 0.01)
            end
            local pdd = rand32:randomIntegerRange(5 * effectivePdd, 6 * effectivePdd) / 10
            damage = damage - pdd
          end
          damage = ___MOD.math.floor(damage)
          if attacker.PlayerVariables.berserkActive and not ___MOD._SkillLogic:isDragonRoar(skillID) then
            local berserkSLV = attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Berserk_132_1320006)
            if berserkSLV ~= nil and 0 < berserkSLV then
              local berserkLevelData = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Berserk_132_1320006, berserkSLV)
              if berserkLevelData ~= nil then
                local berserkDamage = ___MOD.tonumber(berserkLevelData.damage) or 0
                if 0 < berserkDamage then
                  damage = damage * ((100 + berserkDamage) / 100)
                end
              end
            end
          end
          if skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
            local elapsedSec = self:getAssassinateElapsedSeconds(attacker, skillID, levelData)
            if 0 < elapsedSec then
              local multiplier = ___MOD.math.floor(elapsedSec / 2) + 1
              damage = damage * multiplier
            end
          end
          local comboDamage = ___MOD._SkillLogic:getComboDamageParam(attacker, skillID)
          if comboDamage ~= 100 then
            damage = damage * (comboDamage / 100)
          end
          if chargePer ~= 0 and ___MOD._SkillLogic:isKeyDownSkill(skillID) then
            damage = damage * chargePer
          end
          if finishAttack and skillID == ___MOD._SkillBook.Assassinate_422_4221001 and levelData ~= nil then
            local finishCriticalProp = (___MOD.tonumber(levelData.prop) or 0) + criticalProp
            finishCriticalProp = ___MOD.math.max(0, ___MOD.math.min(100, finishCriticalProp))
            local finishCriticalDamage = ___MOD.tonumber(levelData.CD) or 100
            if 0 < finishCriticalProp and finishCriticalProp >= rand32:randomIntegerRange(1, 100) then
              critical = true
              damage = damage * (finishCriticalDamage / 100 + tsCriticalDamageBonus)
            end
          end
          if not ___MOD._SkillLogic:isIgnoreCriticalSkill(skillID) or compCritical then
            if criticalProp >= rand32:randomIntegerRange(1, 100) or compCritical then
              critical = true
              local criticalBaseDamage = 0 < appliedSkillDamageRate and damage / appliedSkillDamageRate or damage
              local criDam = criticalBaseDamage * (criticalDamage + tsCriticalDamageBonus)
              damage = damage + criDam
            end
            if mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Stun) ~= 0 then
              local slv = attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Stun_Mastery_511_5110000)
              if 0 < slv then
                local sm = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Stun_Mastery_511_5110000, slv)
                if sm ~= nil and rand32:randomIntegerRange(1, 100) <= sm.prop then
                  damage = damage * (sm.damage * 0.01)
                  critical = true
                end
              end
            end
          end
          damage = damage + self:getFinalTossDamageBonus(mob, damage, appliedSkillDamageRate)
          damage = damage * totalDamageMul
          local isIgnorePImmune = skillID == ___MOD._SkillBook.Snipe_322_3221007 or skillID == ___MOD._SkillBook.Heavens_Hammer_122_1221011
          if not isIgnorePImmune and (mob.MobTemporaryStatComponent:getValue(___MOD._MTS.PImmune) ~= 0 or pCounter ~= 0) then
            damages[i] = 1
            criticals[i] = false
          elseif 0 < skillID and attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Seal) ~= 0 then
            damages[i] = 0
            criticals[i] = false
          else
            if not ___MOD._SkillLogic:isIgnorePGuardUpSkill(skillID) then
              local pGuardUp = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.PGuardUp)
              if pGuardUp ~= 0 then
                damage = damage * (pGuardUp * 0.01)
              end
            end
            criticals[i] = critical
            local maxDamageLimit = critical and criticalMaxDamage or normalMaxDamage
            damages[i] = ___MOD.math.min(___MOD.math.max(1, ___MOD.math.floor(damage)), maxDamageLimit)
            if not isIgnorePImmune and mob.MobTemporaryStatComponent:getValue(___MOD._MTS.HardSkin) ~= 0 and not critical then
              damages[i] = 1
            end
          end
        end
      end
    end
    ::lbl_1035::
  end
  ___MOD._DamageDecRate:adjustDamageDecRate(skillID, skillLevel, damages, mobOrder, (skillID == ___MOD._SkillBook.Slash_Blast_100_1001005 or skillID == ___MOD._SkillBook.Slash_Blast_1100_11001003) and finalAttackSkillID ~= 0, levelData ~= nil and levelData.x or 0)
  self:applyAranMultiTargetDamageRate(attacker, damages, targetCount or 1)
  self:applyHiddenAttackDamageBoost(attacker, damages)
  self:applyPDRateFinalDamage(attacker, mob, damages)
  self:applyAdminFixedDamage(attacker, damages, criticals)
  return damages, criticals, pCounter
end

function CalcDamageLogic.calcDamage_PDamageSvM(self, owner, mobEntity, skillID, SLV)
  local mob = mobEntity.MobComponent
  if mob == nil then
    return nil
  end
  local ms = mobEntity.MobTemporaryStatComponent
  local mobTemplate = mob.template
  if mobTemplate == nil then
    return nil
  end
  local p = owner.Player
  local ss = owner.PlayerSecondaryAbilityComponent
  if not p or not ss then
    return nil
  end
  local levelData = ___MOD._SkillManager:getSkillLevelData(skillID, SLV)
  if not levelData then
    return nil
  end
  local PAD = levelData.PAD
  local rand_dmg = owner.CalcDamageComponent:getPlayerDamageRandSeed()
  local rand_miss = owner.CalcDamageComponent:getDamageMissRandSeed()
  local acc = ___MOD.math.clamp(p.ACC + ss:getTotalACC(), 0, 999)
  local eva = ___MOD.math.clamp(mobTemplate.eva + ms:getValue(___MOD._MTS.Eva), 0, 999)
  local levelDelta = ___MOD.math.max(mobTemplate.level - p.Level, 0)
  local hitBase = acc * 100 / (levelDelta * 10 + 255)
  local hitRoll = rand_miss:randomDoubleRange(hitBase * 0.7, hitBase * 1.3)
  if eva > hitRoll or mobTemplate.invincible then
    return 0
  end
  if ms:getValue(___MOD._MTS.PImmune) ~= 0 then
    return 1
  end
  local damageMul = 0.7 + rand_dmg:randomDouble() * 0.3
  local baseStat = (p.DEX + ss.DEX) * damageMul * 2.5 + (p.STR + ss.STR)
  local damage = baseStat * PAD * 0.01
  damage = ___MOD._CalcDamageLogic_Element:getDamageAdjustedByElemAttr(owner, mobEntity, damage, skillID, SLV)
  damage = ___MOD._CalcDamageLogic_Element:getDamageAdjustedByPhysicalElemAttr(owner, mobEntity, damage, skillID, false)
  return self:applyAdminFixedSingleDamage(owner, ___MOD.math.floor(___MOD.math.max(1, damage)))
end

function CalcDamageLogic.calcFixedDamageRateMvP(self, player, fixDamR)
  local maxHP = player.Player.MaxHP + player.PlayerSecondaryAbilityComponent.MaxHP
  local damage = ___MOD.math.floor(maxHP * fixDamR / 100)
  local reduce = 0
  local mesoCost = 0
  if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.MesoGuard) ~= 0 then
    reduce, mesoCost = self:getMesoGuardReduce(player, damage)
    damage = damage - reduce
  end
  return ___MOD.math.max(1, ___MOD.math.floor(damage)), reduce, mesoCost
end

function CalcDamageLogic.checkMDamageMiss(self, player, mob, rand)
  local s = player.Player
  local ss = player.PlayerSecondaryAbilityComponent
  local ts = player.PlayerTemporaryStatComponent
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(player)
  local incEva = 0
  local tsValue = 0
  if weaponInfo.valid then
    incEva, tsValue = ___MOD._MasteryLogic:getIncEvadeSkill(player)
  end
  local eva = s.EVA + ss.EVA + tsValue + incEva + s.bonusEVA
  eva = ___MOD.math.max(0, ___MOD.math.min(___MOD._PlayerConstants.MAX_EVA, eva))
  local level = player.Player.Level
  local mobLevel = mob.MobComponent.level
  local finalEva = 0
  if level >= mobLevel then
    finalEva = eva
  else
    eva = eva - (mobLevel - level) // 2
    if 0 < eva then
      finalEva = eva
    else
      finalEva = 0
    end
  end
  local mobAcc = 0
  local mobInfo = mob.MobComponent.template
  if ___MOD.isvalid(mobInfo) then
    mobAcc = mobInfo.acc + mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Acc)
    local accR = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.AccR)
    mobAcc = ___MOD.math.max(0, ___MOD.math.min(___MOD._PlayerConstants.MAX_ACC, mobAcc + mobAcc * 0.01 * accR))
  end
  mobAcc = ___MOD.math.max(mob.MobComponent.minimumAttackACC, mobAcc)
  local darknessMissProp = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Darkness) or 0
  darknessMissProp = ___MOD.math.max(0, ___MOD.math.min(100, darknessMissProp))
  if 0 < darknessMissProp and darknessMissProp >= rand:randomIntegerRange(1, 100) then
    return true
  end
  local r = rand:randomDoubleRange(finalEva * 0.1, finalEva)
  return mobAcc <= r
end

function CalcDamageLogic.checkPDamageMiss(self, player, mob, rand)
  local s = player.Player
  local ss = player.PlayerSecondaryAbilityComponent
  local ts = player.PlayerTemporaryStatComponent
  local jobClass = ___MOD._SkillLogic:getJobClass(s.Job)
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(player)
  local incEva = 0
  local tsValue = 0
  if weaponInfo.valid then
    incEva, tsValue = ___MOD._MasteryLogic:getIncEvadeSkill(player)
  end
  local eva = s.EVA + ss.EVA + tsValue + incEva + s.bonusEVA
  eva = ___MOD.math.max(0, ___MOD.math.min(___MOD._PlayerConstants.MAX_EVA, eva))
  local level = player.Player.Level
  local mobLevel = mob.MobComponent.level
  local finalEva = 0
  if level >= mobLevel then
    finalEva = eva
  else
    eva = eva - (mobLevel - level) // 2
    if 0 < eva then
      finalEva = eva
    else
      finalEva = 0
    end
  end
  local mobAcc = 0
  local mobInfo = mob.MobComponent.template
  if ___MOD.isvalid(mobInfo) then
    mobAcc = mobInfo.acc + mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Acc)
    local accR = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.AccR)
    mobAcc = ___MOD.math.max(0, ___MOD.math.min(___MOD._PlayerConstants.MAX_ACC, mobAcc + mobAcc * 0.01 * accR))
  end
  mobAcc = ___MOD.math.max(mob.MobComponent.minimumAttackACC, mobAcc)
  local darknessMissProp = mob.MobTemporaryStatComponent:getValue(___MOD._MTS.Darkness) or 0
  darknessMissProp = ___MOD.math.max(0, ___MOD.math.min(100, darknessMissProp))
  if 0 < darknessMissProp and darknessMissProp >= rand:randomIntegerRange(1, 100) then
    return true
  end
  local rate = finalEva / (mobAcc * 4.5) * 100
  if jobClass == 4 then
    rate = ___MOD.math.max(5, ___MOD.math.min(95, rate))
  else
    rate = ___MOD.math.max(2, ___MOD.math.min(80, rate))
  end
  local r = rand:randomIntegerRange(0, 100)
  return rate > r
end

function CalcDamageLogic.getAdminFixedDamage(self, attacker)
  if attacker == nil or attacker.CalcDamageComponent == nil then
    return 0
  end
  local fixedDamage = ___MOD.tonumber(attacker.CalcDamageComponent.adminFixedDamage) or 0
  if fixedDamage <= 0 then
    return 0
  end
  return ___MOD.math.max(1, ___MOD.math.floor(fixedDamage))
end

function CalcDamageLogic.getAmplification(self, attacker, skillID)
  local incMPCon = 100
  local job = attacker.Player.Job
  local amplificationSkillID = 0
  if job == 211 or job == 212 then
    amplificationSkillID = ___MOD._SkillBook.Element_Amplification_211_2110001
  elseif job == 221 or job == 222 then
    amplificationSkillID = ___MOD._SkillBook.Element_Amplification_221_2210001
  elseif job == 1211 or job == 1212 then
    amplificationSkillID = ___MOD._SkillBook.Element_Amplification_1211_12110001
  elseif 2215 <= job and job <= 2218 then
    amplificationSkillID = ___MOD._SkillBook.Magic_Amplification_2215_22150000
  end
  if amplificationSkillID == 0 then
    return 100, 100
  end
  if attacker.PlayerTemporaryStatComponent == nil then
    return 100, 100
  end
  if attacker.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Amplification) == 0 then
    return 100, 100
  end
  local amplificationSkillLevel = attacker.SkillComponent:getSkillLevel(amplificationSkillID)
  local levelData = ___MOD._SkillManager:getSkillLevelData(amplificationSkillID, amplificationSkillLevel)
  local result = 100
  if levelData ~= nil then
    local attackSkillLevel = attacker.SkillComponent:getSkillLevel(skillID)
    local attackSkillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, attackSkillLevel)
    if attackSkillLevelData ~= nil and attackSkillLevelData.MAD ~= nil and 0 < attackSkillLevelData.MAD then
      incMPCon = levelData.x
      result = levelData.y
    end
  end
  return result, incMPCon
end

function CalcDamageLogic.getAppliedDamageRateLevelData(self, attacker, skillID, skillLevel, baseLevelData)
  if skillID ~= ___MOD._SkillBook.Charged_Blow_121_1211002 then
    return baseLevelData
  end
  if not ___MOD.isvalid(attacker) or attacker.SkillComponent == nil then
    return baseLevelData
  end
  local advChargeLevel = attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Advanced_Charge_122_1220010)
  if advChargeLevel == nil or advChargeLevel <= 0 then
    return baseLevelData
  end
  local advChargeLevelData = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Advanced_Charge_122_1220010, advChargeLevel)
  if advChargeLevelData == nil or 0 >= (advChargeLevelData.damage or 0) then
    return baseLevelData
  end
  return advChargeLevelData
end

function CalcDamageLogic.getAranMultiTargetDamageRate(self, playerLevel, targetCount)
  local level = ___MOD.math.max(0, ___MOD.tonumber(playerLevel) or 0)
  local count = ___MOD.math.max(1, ___MOD.math.min(6, ___MOD.tonumber(targetCount) or 1))
  local correctionRate = 0
  local originalAdditionalTargetRate = (level / 10 + 20) / 100
  local additionalTargetRate = originalAdditionalTargetRate + correctionRate
  return (1 + (count - 1) * additionalTargetRate) / count
end

function CalcDamageLogic.getAssassinateElapsedSeconds(self, attacker, skillID, levelData)
  if not (skillID == ___MOD._SkillBook.Assassinate_422_4221001 and ___MOD.isvalid(attacker)) or levelData == nil then
    return 0
  end
  local pv = attacker.PlayerVariables
  if pv == nil then
    return 0
  end
  local maxTime = ___MOD.tonumber(levelData.time) or 0
  if maxTime <= 0 then
    return 0
  end
  local elapsed = ___MOD.tonumber(pv.assassinateDarkSightElapsedSec) or 0
  if elapsed <= 0 then
    local startTime = ___MOD.tonumber(pv.darkSightStartTime) or 0
    if 0 < startTime then
      elapsed = ___MOD.math.max(0, ___MOD._UtilLogic.ServerElapsedSeconds - startTime)
    end
  end
  return ___MOD.math.min(maxTime, elapsed)
end

function CalcDamageLogic.getCounterDamage(self, mob, skillID)
  if not ___MOD.isvalid(mob) or not ___MOD.isvalid(mob.MobComponent) then
    return 0
  end
  local temporary = mob.MobTemporaryStatComponent
  local AT = self:getSkillAttackType(skillID)
  local n, w
  if AT == ___MOD._SkillAttackType.Magic then
    n = temporary:getValue(___MOD._MTS.MCounter)
    w = temporary:getY(___MOD._MTS.MCounter)
  else
    n = temporary:getValue(___MOD._MTS.PCounter)
    w = temporary:getY(___MOD._MTS.PCounter)
  end
  if 0 < w then
    return n + (___MOD._GlobalRand32:randomIntegerRange(1, w) - 1) - w // 2
  end
  return n
end

function CalcDamageLogic.getFinalTossDamageBonus(self, mob, damage, appliedSkillDamageRate)
  local mts = mob and mob.MobTemporaryStatComponent
  if not mts then
    return 0
  end
  local finalTossRate = ___MOD.tonumber(mts:getValue(___MOD._MTS.FinalToss)) or 0
  if finalTossRate <= 0 then
    return 0
  end
  local baseDamage = 0 < appliedSkillDamageRate and damage / appliedSkillDamageRate or damage
  return baseDamage * finalTossRate * 0.01
end

function CalcDamageLogic.getMesoGuardReduce(self, player, damage)
  local realDamage = ___MOD.math.floor(___MOD.math.min(damage or 0, 50000000))
  if realDamage <= 0 then
    return 0, 0
  end
  local slv = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Meso_Guard_421_4211005)
  if slv <= 0 then
    return 0, 0
  end
  local levelData = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Meso_Guard_421_4211005, slv)
  if levelData == nil then
    return 0, 0
  end
  local reduceRate = 50
  local mesoCostRate = levelData.x
  local reduceDamage = ___MOD.math.floor(realDamage * reduceRate / 100)
  local money = player.CInventoryComponent:getMeso()
  local mesoCost = 0
  if 0 < mesoCostRate then
    local mesoNeed = ___MOD.math.floor(reduceDamage * mesoCostRate / 100)
    mesoCost = mesoNeed
    if money < mesoNeed then
      reduceDamage = ___MOD.math.floor(money * 100 / mesoCostRate)
      mesoCost = reduceDamage / 2
    end
    mesoCost = ___MOD.math.min(money, mesoCost)
  end
  if reduceDamage < 0 then
    reduceDamage = 0
  elseif realDamage < reduceDamage then
    reduceDamage = realDamage
  end
  return reduceDamage, ___MOD.math.max(0, mesoCost)
end

function CalcDamageLogic.getPDRateAdjustedDamageMultiplier(self, attacker, mob)
  if attacker == nil or mob == nil or mob.MobComponent == nil then
    return 1
  end
  local mobInfo = mob.MobComponent.template
  if not ___MOD.isvalid(mobInfo) then
    return 1
  end
  local pdRate = ___MOD.math.max(0, ___MOD.tonumber(mobInfo.pdRate) or 0)
  if pdRate <= 0 then
    return 1
  end
  local ignoreTargetDEF = 0
  local ss = attacker.PlayerSecondaryAbilityComponent
  if ss ~= nil then
    ignoreTargetDEF = ss:getTotalIgnoreTargetDEF()
  end
  local effectivePDRate = ___MOD.math.max(0, ___MOD.math.min(100, pdRate) - ___MOD.math.min(100, ignoreTargetDEF))
  if effectivePDRate <= 0 then
    return 1
  end
  return ___MOD.math.max(0, 100 - effectivePDRate) * 0.01
end

function CalcDamageLogic.getSkillAttackType(self, skillID)
  if skillID == 0 then
    return ___MOD._SkillAttackType.Melee
  elseif skillID == ___MOD._SkillBook.Energy_Orb_512_5121002 then
    return ___MOD._SkillAttackType.Melee
  elseif ___MOD._SkillLogic:getJobGroupFromSkillId(skillID) == 2 then
    return ___MOD._SkillAttackType.Magic
  end
  return ___MOD._SkillAttackType.Melee
end

function CalcDamageLogic.getSparkDamageRate(self, attacker)
  if attacker == nil or attacker.CalcDamageComponent == nil then
    return 0
  end
  return ___MOD.tonumber(attacker.CalcDamageComponent.sparkAttackDamage) or 0
end

function CalcDamageLogic.isShootAction(self, motion)
  local isShoot = ___MOD.string.find(motion, "shoot") ~= nil
  if not isShoot then
    return motion == "swingO1" or motion == "swingO2" or motion == "swingO3" or motion == "avenger" or motion == "vampire"
  end
  return isShoot
end
