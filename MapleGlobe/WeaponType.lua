

function WeaponType.getAttackSoundByWeaponType(self, type, shoot)
  local soundPath = ""
  if type == self.ONE_HANDED_SWORD or type == self.ONE_HANDED_AXE or type == self.DAGGER then
    soundPath = "Weapon.img.swordS.Attack"
  elseif type == self.TWO_HANDED_SWORD or type == self.TWO_HANDED_AXE then
    soundPath = "Weapon.img.swordL.Attack"
  elseif type == self.ONE_HANDED_MACE or type == self.TWO_HANDED_MACE or type == self.STAFF or type == self.WAND then
    soundPath = "Weapon.img.mace.Attack"
  elseif type == self.SPEAR then
    soundPath = "Weapon.img.spear.Attack"
  elseif type == self.POLEARM then
    soundPath = "Weapon.img.poleArm.Attack"
  elseif type == self.BOW then
    soundPath = "Weapon.img.bow.Attack"
    if shoot then
      soundPath = soundPath .. "2"
    end
  elseif type == self.CROSSBOW then
    soundPath = "Weapon.img.cBow.Attack"
    if shoot then
      soundPath = soundPath .. "2"
    end
  elseif type == self.CLAW then
    soundPath = "Weapon.img.tGlove.Attack"
    if shoot then
      soundPath = soundPath .. "2"
    end
  elseif type == self.KNUCKLE then
    soundPath = "Weapon.img.knuckle.Attack"
    if shoot then
      soundPath = soundPath .. "2"
    end
  elseif type == self.GUN then
    soundPath = "Weapon.img.gun.Attack"
    if shoot then
      soundPath = soundPath .. "2"
    end
  elseif type == self.BARE_HANDS then
    soundPath = "Weapon.img.barehands.Attack"
    if shoot then
      soundPath = soundPath .. "2"
    end
  elseif type == self.BLADE then
    soundPath = "Weapon.img.swordB.Attack"
  end
  return soundPath
end

function WeaponType.getWeaponNameByType(self, type)
  if type == self.ONE_HANDED_SWORD then
    return "ONE_HANDED_SWORD"
  elseif type == self.ONE_HANDED_AXE then
    return "ONE_HANDED_AXE"
  elseif type == self.ONE_HANDED_MACE then
    return "ONE_HANDED_MACE"
  elseif type == self.DAGGER then
    return "DAGGER"
  elseif type == self.BLADE then
    return "BLADE"
  elseif type == self.TWO_HANDED_SWORD then
    return "TWO_HANDED_SWORD"
  elseif type == self.TWO_HANDED_AXE then
    return "TWO_HANDED_AXE"
  elseif type == self.TWO_HANDED_MACE then
    return "TWO_HANDED_MACE"
  elseif type == self.SPEAR then
    return "SPEAR"
  elseif type == self.POLEARM then
    return "POLEARM"
  elseif type == self.BOW then
    return "BOW"
  elseif type == self.CROSSBOW then
    return "CROSSBOW"
  elseif type == self.CLAW then
    return "CLAW"
  elseif type == self.KNUCKLE then
    return "KNUCKLE"
  elseif type == self.GUN then
    return "GUN"
  elseif type == self.STAFF then
    return "STAFF"
  elseif type == self.WAND then
    return "WAND"
  elseif type == self.BARE_HANDS then
    return "BARE_HANDS"
  else
    return "UNKNOWN"
  end
end

function WeaponType.getWeaponTypeByItemID(self, weaponID)
  return weaponID // 1000
end
