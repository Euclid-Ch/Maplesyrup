

function WeaponAttackMotion.getAllAttackMotions(self)
  self:initializeAttackMotions()
  local result = {}
  local added = {}

  local function addMotion(motion)
    if ___MOD.type(motion) ~= "string" or motion == "" or added[motion] then
      return
    end
    added[motion] = true
    ___MOD.table.insert(result, motion)
  end

  for _, motionGroup in ___MOD.pairs(self.attackMotion) do
    if motionGroup.melee ~= nil or motionGroup.shoot ~= nil then
      for _, motion in ___MOD.ipairs(motionGroup.melee or {}) do
        addMotion(motion)
      end
      for _, motion in ___MOD.ipairs(motionGroup.shoot or {}) do
        addMotion(motion)
      end
    else
      for _, motion in ___MOD.ipairs(motionGroup) do
        addMotion(motion)
      end
    end
  end
  for _, motions in ___MOD.pairs(self.finalAttackMotion) do
    for _, motion in ___MOD.ipairs(motions) do
      addMotion(motion)
    end
  end
  addMotion(self.proneAttackMotion)
  return result
end

function WeaponAttackMotion.getFinalAttackMotion(self, weaponType)
  self:initializeAttackMotions()
  local motions = self.finalAttackMotion[weaponType]
  if motions == nil or #motions == 0 then
    return nil
  end
  return motions[___MOD._GlobalRand32:randomIntegerRange(1, #motions)]
end

function WeaponAttackMotion.initializeAttackMotions(self)
  if ___MOD.next(self.attackMotion) ~= nil and ___MOD.next(self.finalAttackMotion) ~= nil then
    return
  end
  self.attackMotion[___MOD._WeaponType.ONE_HANDED_SWORD] = {
    "swingO1",
    "swingO2",
    "swingO3",
    "stabO1",
    "stabO2"
  }
  self.attackMotion[___MOD._WeaponType.ONE_HANDED_AXE] = {
    "swingO1",
    "swingO2",
    "swingO3",
    "stabO1",
    "stabO2"
  }
  self.attackMotion[___MOD._WeaponType.ONE_HANDED_MACE] = {
    "swingO1",
    "swingO2",
    "swingO3",
    "stabO1",
    "stabO2"
  }
  self.attackMotion[___MOD._WeaponType.DAGGER] = {
    "swingO1",
    "swingO2",
    "swingO3",
    "stabO1",
    "stabO2"
  }
  self.attackMotion[___MOD._WeaponType.BLADE] = {
    "swingD1",
    "swingD2",
    "stabD1"
  }
  self.attackMotion[___MOD._WeaponType.TWO_HANDED_SWORD] = {
    "swingT1",
    "swingT2",
    "swingT3",
    "stabO1",
    "stabO2"
  }
  self.attackMotion[___MOD._WeaponType.TWO_HANDED_AXE] = {
    "swingT1",
    "swingT2",
    "swingT3",
    "stabO1",
    "stabO2"
  }
  self.attackMotion[___MOD._WeaponType.TWO_HANDED_MACE] = {
    "swingT1",
    "swingT2",
    "swingT3",
    "stabO1",
    "stabO2"
  }
  self.attackMotion[___MOD._WeaponType.SPEAR] = {
    "swingP1",
    "swingP2",
    "stabT1",
    "stabT2"
  }
  self.attackMotion[___MOD._WeaponType.POLEARM] = {
    "swingP1",
    "swingP2",
    "stabT1",
    "stabT2"
  }
  self.attackMotion[___MOD._WeaponType.BOW] = {
    melee = {"swingT1", "swingT3"},
    shoot = {"shoot1"}
  }
  self.attackMotion[___MOD._WeaponType.CROSSBOW] = {
    melee = {"swingT1", "stabT1"},
    shoot = {"shoot2"}
  }
  self.attackMotion[___MOD._WeaponType.CLAW] = {
    melee = {"stabO1", "stabO2"},
    shoot = {"swingO1", "swingO3"}
  }
  self.attackMotion[___MOD._WeaponType.KNUCKLE] = {"stabO1", "stabO2"}
  self.attackMotion[___MOD._WeaponType.GUN] = {
    melee = {
      "swingT1",
      "swingT2",
      "swingT3"
    },
    shoot = {"shot"}
  }
  self.attackMotion[___MOD._WeaponType.STAFF] = {"swingO2"}
  self.attackMotion[___MOD._WeaponType.WAND] = {"swingO2"}
  self.attackMotion[___MOD._WeaponType.BARE_HANDS] = {"stabO1"}
  self.finalAttackMotion[___MOD._WeaponType.CLAW] = {"swingOF"}
  self.finalAttackMotion[___MOD._WeaponType.SPEAR] = {"swingPF", "stabTF"}
  self.finalAttackMotion[___MOD._WeaponType.POLEARM] = {"swingPF", "stabTF"}
  self.finalAttackMotion[___MOD._WeaponType.ONE_HANDED_SWORD] = {"swingOF", "stabOF"}
  self.finalAttackMotion[___MOD._WeaponType.ONE_HANDED_AXE] = {"swingOF", "stabOF"}
  self.finalAttackMotion[___MOD._WeaponType.ONE_HANDED_MACE] = {"swingOF", "stabOF"}
  self.finalAttackMotion[___MOD._WeaponType.TWO_HANDED_SWORD] = {"swingTF", "stabOF"}
  self.finalAttackMotion[___MOD._WeaponType.TWO_HANDED_AXE] = {"swingTF", "stabOF"}
  self.finalAttackMotion[___MOD._WeaponType.TWO_HANDED_MACE] = {"swingTF", "stabOF"}
  self.finalAttackMotion[___MOD._WeaponType.BOW] = {"shootF"}
  self.finalAttackMotion[___MOD._WeaponType.CROSSBOW] = {"shoot2"}
end

function WeaponAttackMotion.OnBeginPlay(self)
  self:initializeAttackMotions()
end
