

function DamageDecRate.adjustDamageDecRate(self, skillID, skillLevel, damages, order, isFinalSlashBlast, decStep)
  local rate = 0.0
  if isFinalSlashBlast then
    rate = self.damageDecRate[1][order]
  elseif skillID == ___MOD._SkillBook.Sudden_Raid_434_4341004 then
    rate = self.damageDecRate[5] and self.damageDecRate[5][order] or 0.0
  elseif skillID == ___MOD._SkillBook.Iron_Arrow__Crossbow_320_3201005 then
    rate = self.damageDecRate[2][order] or 0.0
  elseif skillID == ___MOD._SkillBook.Piercing_Arrow_322_3221001 or skillID == ___MOD._SkillBook.Mortal_Blow_311_3110001 then
    rate = self.damageDecRate[4][order] or 0.0
  elseif skillID == ___MOD._SkillBook.Chain_Lightning_222_2221006 or skillID == ___MOD._SkillBook.Energy_Orb_512_5121002 or skillID == ___MOD._SkillBook.Blaze_2218_22181001 or skillID == ___MOD._SkillBook.Spark_1511_15111006 then
    rate = self.damageDecRate[3][order] or 0.0
  elseif skillID == ___MOD._SkillBook.Arrow_Bomb__Bow_310_3101005 then
    rate = (decStep or 0) * 0.01
  end
  if 0 < rate then
    for i = 1, 16 do
      if damages[i] ~= nil and damages[i] ~= 0 then
        damages[i] = ___MOD.math.floor(___MOD.math.min(___MOD.math.max(1, ___MOD.math.floor(damages[i] * rate), 1)))
      end
    end
  end
end

function DamageDecRate.getVerticalAdjustOfAttackRange(self, skillID)
  if skillID == ___MOD._SkillBook.Iron_Arrow__Crossbow_320_3201005 or skillID == ___MOD._SkillBook.Wind_Piercing_1311_13111006 or skillID == ___MOD._SkillBook.Taunt_412_4121003 or skillID == ___MOD._SkillBook.Taunt_422_4221003 or skillID == ___MOD._SkillBook.Dragon_Roar_131_1311006 then
    return 10
  end
  if skillID == ___MOD._SkillBook.Golden_Eagle_321_3211005 then
    return 12
  end
  if skillID == ___MOD._SkillBook.Arrow_Blow_300_3001004 or skillID == ___MOD._SkillBook.Blizzard_321_3211003 or skillID == ___MOD._SkillBook.Piercing_Arrow_322_3221001 or skillID == ___MOD._SkillBook.Dragons_Breath_322_3221003 or skillID == ___MOD._SkillBook.Mortal_Blow_311_3110001 then
    return 20
  end
  if skillID == ___MOD._SkillBook.Avenger_411_4111005 or skillID == ___MOD._SkillBook.Avenger_1411_14111002 then
    return 36
  end
  if skillID == ___MOD._SkillBook.Soul_Blade_1110_11101004 or skillID == ___MOD._SkillBook.Shark_Wave_1511_15111007 or skillID == ___MOD._SkillBook.Combo_Smash_2110_21100004 or skillID == ___MOD._SkillBook.Combo_Fenrir_2111_21110004 then
    return 60
  end
  if skillID == ___MOD._SkillBook.Spark_1511_15111006 then
    return 150
  end
  return 0
end

function DamageDecRate.getVerticalAdjustOfAttackRange_(self, a1)
  local LOC_A9634B_PLUS1 = 11101004
  local LOC_40684B = 4221003
  if a1 <= LOC_A9634B_PLUS1 then
    if a1 ~= LOC_A9634B_PLUS1 then
      if a1 <= 3221003 then
        if a1 ~= 3221003 and a1 ~= 3001004 and a1 ~= 3121003 then
          if a1 ~= 3201005 then
            if a1 ~= 3221001 then
              return 0
            end
            return 20
          end
          return 10
        end
        return 20
      end
      if a1 ~= 4111005 then
        if a1 ~= 4121003 and a1 ~= LOC_40684B then
          return 0
        end
        return 10
      end
      return 36
    end
    return 60
  end
  if a1 <= 21100004 then
    if a1 ~= 21100004 then
      if a1 == 13111006 then
        return 10
      elseif a1 == 14111002 then
        return 36
      elseif a1 == 15111006 then
        return 150
      end
      if a1 ~= 15111007 then
        return 0
      end
    end
    return 60
  end
  if a1 == 21110004 then
    return 60
  end
  if a1 == 33101001 then
    return 20
  end
  if a1 ~= 33121005 then
    return 0
  end
  return 12
end

function DamageDecRate.OnBeginPlay(self)
  self.damageDecRate[1] = {
    0.666667,
    0.222222,
    0.074074,
    0.024691,
    0.00823,
    0.002743,
    9.14E-4,
    3.05E-4,
    1.02E-4,
    3.3E-5,
    1.1E-5,
    4.0E-6,
    1.0E-6,
    0.0,
    0.0
  }
  self.damageDecRate[2] = {
    1.0,
    0.9,
    0.81,
    0.729,
    0.6561,
    0.59049,
    0.531441,
    0.478296,
    0.430467,
    0.38741,
    0.348678,
    0.31381,
    0.282429,
    0.254186,
    0.228767
  }
  self.damageDecRate[3] = {
    1.0,
    0.7,
    0.49,
    0.343,
    0.2401,
    0.16807,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  }
  self.damageDecRate[4] = {
    1.0,
    1.2,
    1.44,
    1.728,
    2.0736,
    2.48832,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  }
  self.damageDecRate[5] = {
    1.0,
    1.0,
    1.0,
    0.95,
    0.95,
    0.95,
    0.9,
    0.9,
    0.9,
    0.85,
    0.85,
    0.85,
    0.8,
    0.8,
    0.8
  }
end
