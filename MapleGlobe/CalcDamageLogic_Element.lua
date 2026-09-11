

function CalcDamageLogic_Element.getDamageAdjustedByAssistChargedElemAttr(self, player, mob, damage)
  local assistSkillID = player.PlayerTemporaryStatComponent:getSkillID(___MOD._CTS.AssistCharge)
  if assistSkillID == nil or assistSkillID == 0 then
    return 0
  end
  local assistLevel = player.SkillComponent:getSkillLevel(assistSkillID)
  if assistLevel == nil or assistLevel <= 0 then
    return 0
  end
  local element = ___MOD._SkillLogic:getElementByCharge(assistSkillID)
  if element == nil or element == ___MOD._MobElementType.Physical then
    return 0
  end
  local skillLevelData = ___MOD._SkillManager:getSkillLevelData(assistSkillID, assistLevel)
  if skillLevelData == nil then
    return 0
  end
  local mul = (skillLevelData.damage or 0) * 0.01
  local adjust = skillLevelData.z or 0
  local extra = (mul - 1.0) * damage * 0.5
  if extra <= 0 then
    return 0
  end
  local attr = mob.MobComponent.elemAttr[element] or ___MOD._MobElementAttrType.None
  extra = self:getDamageAdjustedByElemAttr_(extra, attr, adjust, 0, 0)
  extra = ___MOD.math.floor(extra)
  if extra < 0 then
    return 0
  end
  return extra
end

function CalcDamageLogic_Element.getDamageAdjustedByChargedElemAttr(self, player, mob, damage)
  if player.AfterImageComponent.chargeType ~= 0 then
    local skillID = self:getMainChargeSkillID(player)
    local originDamage = damage
    if skillID ~= 0 then
      local element = ___MOD._SkillLogic:getElementByCharge(skillID)
      if element ~= ___MOD._MobElementType.Physical then
        local chargeLevel = player.SkillComponent:getSkillLevel(skillID)
        if 0 < chargeLevel then
          local skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, chargeLevel)
          if skillLevelData ~= nil then
            damage = damage * (skillLevelData.damage * 0.01)
            damage = self:getDamageAdjustedByElemAttr_(damage, mob.MobComponent.elemAttr[element] or ___MOD._MobElementAttrType.None, skillLevelData.z, 0, 0)
          end
        end
      end
    end
  end
  return damage
end

function CalcDamageLogic_Element.getDamageAdjustedByElemAttr(self, player, mob, damage, skillID, skillLevel)
  if 0 < skillID and 0 < skillLevel then
    local icePlusDam = false
    local firePlusDam = false
    if mob.MobTemporaryStatComponent:getSkillID(___MOD._MTS.Poison) == ___MOD._SkillBook.Fire_Demon_212_2121003 then
      icePlusDam = true
    elseif mob.MobTemporaryStatComponent:getSkillID(___MOD._MTS.Poison) == ___MOD._SkillBook.Ice_Demon_222_2221003 then
      firePlusDam = true
    end
    if skillID == ___MOD._SkillBook.Element_Composition_211_2111006 then
      local fire = self:getDamageAdjustedByElemAttr_(damage * 0.5, firePlusDam and ___MOD._MobElementAttrType.PlusHalfDamage or mob.MobComponent.elemAttr[___MOD._MobElementType.Fire] or ___MOD._MobElementAttrType.None, 100, 0, 0)
      local poison = self:getDamageAdjustedByElemAttr_(damage * 0.5, mob.MobComponent.elemAttr[___MOD._MobElementType.Poison] or ___MOD._MobElementAttrType.None, 100, 0, 0)
      return fire + poison
    elseif skillID == ___MOD._SkillBook.Element_Composition_221_2211006 then
      local ice = self:getDamageAdjustedByElemAttr_(damage * 0.5, icePlusDam and ___MOD._MobElementAttrType.PlusHalfDamage or mob.MobComponent.elemAttr[___MOD._MobElementType.Ice] or ___MOD._MobElementAttrType.None, 100, 0, 0)
      local light = self:getDamageAdjustedByElemAttr_(damage * 0.5, mob.MobComponent.elemAttr[___MOD._MobElementType.Light] or ___MOD._MobElementAttrType.None, 100, 0, 0)
      return ice + light
    else
      local adjust = 100
      local skillData = ___MOD._SkillManager:getSkill(skillID)
      local skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
      if skillID == ___MOD._SkillBook.Inferno_311_3111003 or skillID == ___MOD._SkillBook.Blizzard_321_3211003 then
        adjust = skillLevelData.x
      end
      if not ___MOD._UtilLogic:IsNilorEmptyString(skillData.elemAttr) or icePlusDam or firePlusDam then
        local attr = mob.MobComponent.elemAttr[skillData.elemAttr] or ___MOD._MobElementAttrType.None
        if icePlusDam then
          if skillData.elemAttr == "I" then
            attr = ___MOD._MobElementAttrType.PlusHalfDamage
          end
        elseif firePlusDam and skillData.elemAttr == "F" then
          attr = ___MOD._MobElementAttrType.PlusHalfDamage
        end
        local elemReset = 0
        if player.Player.Job >= 1200 and player.Player.Job <= 1212 then
          elemReset = player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.ElementReset)
        end
        local d = self:getDamageAdjustedByElemAttr_(damage, attr, adjust, 0, elemReset)
        return d
      end
    end
  end
  return damage
end

function CalcDamageLogic_Element.getDamageAdjustedByElemAttr_(self, damage, attr, adjust, boost, elemeReset)
  if attr == ___MOD._MobElementAttrType.None then
    return damage
  elseif attr == ___MOD._MobElementAttrType.NotDamage then
    local a = ___MOD.math.max(0, (adjust - elemeReset) / 100.0)
    return (1.0 - a) * damage
  elseif attr == ___MOD._MobElementAttrType.HalfDamage then
    local a = ___MOD.math.max(0, (adjust - elemeReset) / 100.0)
    local ad = a * 0.5 + boost
    return (1.0 - ad) * damage
  elseif attr == ___MOD._MobElementAttrType.PlusHalfDamage then
    return ___MOD.math.min(___MOD._PlayerConstants.MAX_DAMAGE, ((adjust - elemeReset) * 0.01 * 0.5 + boost + 1.0) * damage)
  end
  return damage
end

function CalcDamageLogic_Element.getDamageAdjustedByPhysicalElemAttr(self, player, mob, damage, skillID, checkWeaponCharge)
  if not mob or not mob.MobComponent then
    return damage
  end
  if self:hasSkillElement(skillID) then
    return damage
  end
  if checkWeaponCharge and self:hasElementalWeaponCharge(player) then
    return damage
  end
  local attr = mob.MobComponent.elemAttr[___MOD._MobElementType.Physical] or ___MOD._MobElementAttrType.None
  return self:getDamageAdjustedByElemAttr_(damage, attr, 100, 0, 0)
end

function CalcDamageLogic_Element.getMainChargeSkillID(self, player)
  if not player or not player.PlayerTemporaryStatComponent then
    return 0
  end
  local temporary = player.PlayerTemporaryStatComponent
  local skillID = temporary:getSkillID(___MOD._CTS.WeaponCharge)
  if 0 < skillID then
    return skillID
  end
  if 0 < temporary:getValue(___MOD._CTS.SnowCharge) then
    return ___MOD._SkillBook.Snow_Charge_2111_21111005
  end
  return 0
end

function CalcDamageLogic_Element.hasElementalWeaponCharge(self, player)
  if not player or not player.PlayerTemporaryStatComponent then
    return false
  end
  local skillID = self:getMainChargeSkillID(player)
  if skillID <= 0 then
    return false
  end
  local element = ___MOD._SkillLogic:getElementByCharge(skillID)
  return element and element ~= ___MOD._MobElementType.Physical
end

function CalcDamageLogic_Element.hasSkillElement(self, skillID)
  if skillID <= 0 then
    return false
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  return skillData ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(skillData.elemAttr)
end
