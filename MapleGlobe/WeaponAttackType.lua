

function WeaponAttackType.getWeaponAttackType(self, weaponType)
  if weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponType == ___MOD._WeaponType.DAGGER or weaponType == ___MOD._WeaponType.BLADE or weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD or weaponType == ___MOD._WeaponType.TWO_HANDED_AXE or weaponType == ___MOD._WeaponType.TWO_HANDED_MACE or weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.POLEARM or weaponType == ___MOD._WeaponType.KNUCKLE or weaponType == ___MOD._WeaponType.BARE_HANDS then
    return ___MOD._WeaponAttackType.MELEE
  elseif weaponType == ___MOD._WeaponType.BOW or weaponType == ___MOD._WeaponType.CROSSBOW or weaponType == ___MOD._WeaponType.CLAW or weaponType == ___MOD._WeaponType.GUN then
    return ___MOD._WeaponAttackType.SHOOT
  elseif weaponType == ___MOD._WeaponType.STAFF or weaponType == ___MOD._WeaponType.WAND then
    return ___MOD._WeaponAttackType.MAGIC
  end
  return ___MOD._WeaponAttackType.UNKNOWN
end

function WeaponAttackType.getWeaponAttackTypeName(self, attackType)
  if attackType == ___MOD._WeaponAttackType.MELEE then
    return "MELEE"
  elseif attackType == ___MOD._WeaponAttackType.MAGIC then
    return "MAGIC"
  elseif attackType == ___MOD._WeaponAttackType.SHOOT then
    return "SHOOT"
  elseif attackType == ___MOD._WeaponAttackType.UNKNOWN then
    return "UNKNOWN"
  end
  return "INVALID"
end
