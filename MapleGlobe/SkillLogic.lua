

function SkillLogic.calcBeginnerSP(self, player)
  local job = player.Player.Job
  local totalCount = 0
  if job < 1000 then
    local skills = {
      1000,
      1001,
      1002
    }
    for _, skill in ___MOD.pairs(skills) do
      local slv = player.SkillComponent:getSkillLevel(skill)
      if 0 < slv then
        totalCount = totalCount + slv
      end
    end
  elseif job < 2000 then
    local skills = {
      10001000,
      10001001,
      10001002
    }
    for _, skill in ___MOD.pairs(skills) do
      local slv = player.SkillComponent:getSkillLevel(skill)
      if 0 < slv then
        totalCount = totalCount + slv
      end
    end
  elseif ___MOD._JobLogic:isAran(job) then
    local skills = {
      20001000,
      20001001,
      20001002
    }
    for _, skill in ___MOD.pairs(skills) do
      local slv = player.SkillComponent:getSkillLevel(skill)
      if 0 < slv then
        totalCount = totalCount + slv
      end
    end
  elseif ___MOD._JobLogic:isEvan(job) then
    local skills = {
      20011000,
      20011001,
      20011002
    }
    for _, skill in ___MOD.pairs(skills) do
      local slv = player.SkillComponent:getSkillLevel(skill)
      if 0 < slv then
        totalCount = totalCount + slv
      end
    end
  end
  local level = player.Player.Level
  local remainSP = ___MOD.math.max(0, ___MOD.math.min(6, level - 1) - totalCount)
  return remainSP
end

function SkillLogic.checkCanUpSP(self, player, skillID)
  local jobID = self:getJobIdFromSkillId(skillID)
  local jobTier = self:getJobTier(jobID)
  if jobTier <= 1 then
    return true
  end
  local sp = player.Player.SP
  if self._T.jobUseSP == nil then
    self._T.jobUseSP = {}
    for i = 1, 3 do
      if self._T.jobUseSP[i] == nil then
        self._T.jobUseSP[i] = 0
        local totalSP = 0
        for sid, v in ___MOD.pairs(player.SkillComponent.skills) do
          local jt = self:getJobTier(self:getJobIdFromSkillId(sid))
          if jt == i then
            totalSP = totalSP + v.skillLevel
          end
        end
        self._T.jobUseSP[i] = totalSP
      end
    end
  end
  local needPoint = 61
  if 210 <= jobID and jobID <= 232 then
    needPoint = 67
  end
  if jobTier == 3 then
    needPoint = needPoint + 121
  elseif jobTier == 4 then
    needPoint = needPoint + 121 + 151
  end
  local total = 0
  for i = 1, jobTier - 1 do
    total = total + self._T.jobUseSP[i]
  end
  if total + sp - needPoint <= 0 then
    local msg = "1차 스킬이 부족합니다."
    if jobTier == 3 then
      msg = "1차 또는 2차 스킬이 부족합니다."
    elseif jobTier == 4 then
      msg = "1차 또는 2차 또는 3차\r\n스킬이 부족합니다."
    end
    ___MOD._UINotice:showAlertUI(msg)
    return false
  end
  return true
end

function SkillLogic.clearUseSP(self)
  if self._T.jobUseSP ~= nil then
    for i = 1, 4 do
      self._T.jobUseSP[i] = nil
    end
  end
  self._T.jobUseSP = nil
end

function SkillLogic.getComboDamageParam(self, player, skillID)
  local combo = player.ComboComponent
  if combo.comboCount <= 0 then
    return 100
  end
  local comobLevelData = combo.comboLevelData
  if comobLevelData ~= nil then
    if ___MOD.next(comobLevelData) == nil then
      combo:initComboClient()
      comobLevelData = combo.comboLevelData
    end
    local baseDamage = comobLevelData.damage
    local comboCount = player.ComboComponent.comboCount
    local comboSkillLevel = combo.comboSkillLevel
    local book = ___MOD._SkillBook
    if skillID == book.Panic_1111_11111002 or skillID == book.Panic__Axe_111_1111004 or skillID == book.Panic__Sword_111_1111003 or skillID == book.Coma_1111_11111003 or skillID == book.Coma_Axe_111_1111006 or skillID == book.Coma_Sword_111_1111005 then
      local damRRate = {
        0,
        0,
        30,
        80,
        150,
        230,
        250,
        270,
        290,
        305,
        320
      }
      local damR = damRRate[comboCount + 1] or 0
      local t = (comboSkillLevel - 1) / 29
      baseDamage = baseDamage + damR * (1 + 4 * t) / 5
    else
      local damRRate = {
        0,
        0,
        5,
        10,
        15,
        20,
        24,
        28,
        32,
        36,
        40
      }
      local damR = damRRate[comboCount + 1]
      baseDamage = baseDamage + damR * (comboSkillLevel - 1) / 29
    end
    return baseDamage
  end
  return 100
end

function SkillLogic.getCooltime(self, skillID)
  if skillID == ___MOD._SkillBook.Recoil_Shot_520_5201006 then
    return 1.3
  end
  if skillID == ___MOD._SkillBook.Combat_Step_2100_21001001 then
    return 1
  end
  return 0
end

function SkillLogic.getElementByCharge(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Fire_Charge_Sword_121_1211003 or skillID == book.Flame_Charge_BW_121_1211004 then
    return ___MOD._MobElementType.Fire
  elseif skillID == book.Ice_Charge_Sword_121_1211005 or skillID == book.Blizzard_Charge_BW_121_1211006 or skillID == book.Snow_Charge_2111_21111005 then
    return ___MOD._MobElementType.Ice
  elseif skillID == book.Thunder_Charge_Sword_121_1211007 or skillID == book.Lightning_Charge_BW_121_1211008 or skillID == book.Lightning_Charge_1510_15101006 then
    return ___MOD._MobElementType.Light
  elseif skillID == book.Holy_Charge__Sword_122_1221003 or skillID == book.Divine_Charge__BW_122_1221004 or skillID == book.Soul_Charge_1111_11111007 then
    return ___MOD._MobElementType.Holy
  end
  return ___MOD._MobElementType.Physical
end

function SkillLogic.getJobClass(self, job)
  return ___MOD.math.floor(job % 1000 / 100)
end

function SkillLogic.getJobGroupFromJobId(self, jobId)
  if not jobId or jobId <= 0 then
    return 0
  end
  local hundredsDigit = ___MOD.math.floor(jobId / 100) % 10
  if 1 <= hundredsDigit and hundredsDigit <= 5 then
    return hundredsDigit
  end
  return 0
end

function SkillLogic.getJobGroupFromSkillId(self, skillId)
  local jobId = self:getJobIdFromSkillId(skillId)
  local group = self:getJobGroupFromJobId(jobId)
  return group
end

function SkillLogic.getJobIdFromSkillId(self, skillId)
  if not skillId or skillId <= 0 then
    return 0
  end
  local jobCode = ___MOD.math.floor(skillId / 10000)
  if jobCode < 10000 then
    return jobCode
  end
  return ___MOD.math.floor(jobCode / 10)
end

function SkillLogic.getJobTier(self, job)
  if job == 0 or job == 1000 or job == 2000 or job == 3000 then
    return 0
  end
  local last2 = job % 100
  if last2 == 0 then
    return 1
  end
  local last1 = last2 % 10
  if last1 == 0 then
    return 2
  elseif last1 == 1 then
    return 3
  elseif last1 == 2 then
    return 4
  end
  return -1
end

function SkillLogic.getMaxGaugeTime(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Big_Bang_212_2121001 or skillID == book.Big_Bang_222_2221001 or skillID == book.Big_Bang_232_2321001 or skillID == book.Corkscrew_Blow_510_5101004 or skillID == book.Grenade_520_5201002 or skillID == book.Poison_Bomb_1411_14111006 or skillID == book.Corkscrew_Blow_1510_15101003 or skillID == book.Monster_Magnet_112_1121001 or skillID == book.Monster_Magnet_122_1221001 or skillID == book.Monster_Magnet_132_1321001 then
    return 1000
  elseif skillID == book.Piercing_Arrow_322_3221001 then
    return 900
  elseif skillID == book.Final_Cut_434_4341002 then
    return 600
  elseif skillID == book.Ice_Breath_2212_22121000 or skillID == book.Fire_Breath__2215_22151001 then
    return 500
  elseif skillID == book.Final_Cut_434_4341002 then
    return 600
  elseif skillID == book.Monster_Bomb_434_4341003 then
    return 1200
  elseif skillID == book.Hurricane_312_3121004 or skillID == book.Hurricane_1311_13111002 then
    return 2000
  end
  return 1000
end

function SkillLogic.getMobColorByMTS(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == 1000 or skillID == book.Poison_Breath_210_2101005 or skillID == book.Poison_Mist_211_2111003 or skillID == book.Element_Composition_211_2111006 then
    return ___MOD.Color.FromHexCode("#5B8F3B")
  elseif skillID == 1004 or skillID == book.Ice_Charge_Sword_121_1211005 or skillID == book.Blizzard_Charge_BW_121_1211006 or skillID == book.Cold_Beam_220_2201004 or skillID == book.Ice_Strike_221_2211002 or skillID == book.Element_Composition_221_2211006 or skillID == book.Elquines_212_2121005 or skillID == book.Blizzard_321_3211003 or skillID == book.Ice_Splitter_521_5211005 or skillID == book.Blizzard_222_2221007 or skillID == book.Snow_Charge_2111_21111005 or skillID == book.Combo_Tempest_2112_21120006 or skillID == book.Frostprey_322_3221005 then
    return ___MOD.Color.FromHexCode("#A9DDFE")
  elseif skillID == book.Flame_Gear_1211_12111005 or skillID == book.Inferno_311_3111003 or skillID == book.Flamethrower_521_5211004 or skillID == book.Fire_Demon_212_2121003 then
    return ___MOD.Color.FromHexCode("#FFA0A0")
  elseif skillID == book.Paralyze_212_2121006 then
    return ___MOD.Color.FromHexCode("#B3B3B3")
  elseif skillID == book.Ice_Demon_222_2221003 then
    return ___MOD.Color.FromHexCode("#5BB4FF")
  end
  return nil
end

function SkillLogic.getRecommendedTierSpendLimit(self, player, jobTier)
  if player == nil then
    return 0
  end
  if jobTier == 1 then
    local limit = 61
    local playerJob = ___MOD.tonumber(player.Player.Job) or 0
    if 200 <= playerJob and playerJob <= 232 then
      limit = 67
    end
    return limit
  elseif jobTier == 2 then
    return 121
  elseif jobTier == 3 then
    return 151
  end
  return 0
end

function SkillLogic.getSkillType(self, skillID)
  if skillID <= 0 then
    return ___MOD._SkillType.unkownSkill
  end
  local book = ___MOD._SkillBook
  if skillID == book.Useful_Haste_000_8000 or skillID == book.Useful_Mystic_Door_000_8001 or skillID == book.Useful_Sharp_Eyes_000_8002 or skillID == book.Useful_Hyper_Body_000_8003 or skillID == book.Useful_Haste_1000_10008000 or skillID == book.Useful_Mystic_Door_1000_10008001 or skillID == book.Useful_Sharp_Eyes_1000_10008002 or skillID == book.Useful_Hyper_Body_1000_10008003 or skillID == book.Useful_Haste_2000_20008000 or skillID == book.Useful_Mystic_Door_2000_20008001 or skillID == book.Useful_Sharp_Eyes_2000_20008002 or skillID == book.Useful_Hyper_Body_2000_20008003 or skillID == book.Useful_Haste_2001_20018000 or skillID == book.Useful_Mystic_Door_2001_20018001 or skillID == book.Useful_Sharp_Eyes_2001_20018002 or skillID == book.Useful_Hyper_Body_2001_20018003 or skillID == book.Combo_Drain_2110_21100005 then
    return ___MOD._SkillType.activeSkill
  end
  local digit = skillID // 1000 % 10
  if digit == 1 then
    return ___MOD._SkillType.activeSkill
  elseif digit == 0 then
    return ___MOD._SkillType.passiveSkill
  else
    return ___MOD._SkillType.unkownSkill
  end
end

function SkillLogic.isBeginnerSkill(self, skillID)
  local skills = {
    1000,
    1001,
    1002,
    10001000,
    10001001,
    10001002,
    20001000,
    20001001,
    20001002,
    20011000,
    20011001,
    20011002
  }
  for _, s in ___MOD.pairs(skills) do
    if s == skillID then
      return true
    end
  end
  return false
end

function SkillLogic.isCanNotJumpAttack(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Magic_Claw_1200_12001003 or skillID == book.Magic_Claw_200_2001005 or skillID == book.Thunder_Bolt_220_2201005 or skillID == book.Ice_Strike_221_2211002 or skillID == book.Shining_Ray_231_2311004 or skillID == book.Arrow_Rain_311_3111004 or skillID == book.Arrow_Rain_1311_13111000 or skillID == book.Arrow_Eruption_321_3211004 or skillID == book.Shockwave_1511_15111003 or skillID == book.Shockwave_511_5111006 or skillID == book.Storm_Break_1310_13101005
end

function SkillLogic.isCanUseSkillOnLadder(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Chakra_421_4211001 or skillID == book.Dash_500_5001005 or skillID == book.Dash_1500_15001003 or skillID == book.Combat_Step_2100_21001001 or skillID == book.Meso_Explosion_421_4211006 then
    return false
  end
  return true
end

function SkillLogic.isComboFinishAttack(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Coma_1111_11111003 or skillID == book.Coma_Axe_111_1111006 or skillID == book.Coma_Sword_111_1111005 or skillID == book.Panic_1111_11111002 or skillID == book.Panic__Axe_111_1111004 or skillID == book.Panic__Sword_111_1111003 then
    return true
  end
  return false
end

function SkillLogic.isCooltimeSkill(self, skillID)
  if self:getCooltime(skillID) ~= 0 then
    return true
  end
  return false
end

function SkillLogic.isDragonRoar(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Dragon_Roar_131_1311006 or skillID == book.Super_Dragon_Roar_900_9001001 or skillID == book.Super_Dragon_Roar_900_9001006 then
    return true
  end
  return false
end

function SkillLogic.isHeal(self, skillID)
  return skillID == ___MOD._SkillBook.Heal_230_2301002
end

function SkillLogic.isIgnoreCriticalSkill(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Blizzard_321_3211003 or skillID == book.Shadow_Meso_411_4111004 or skillID == book.Assassinate_422_4221001 then
    return true
  end
  return false
end

function SkillLogic.isIgnoreMGuardUpSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Shadow_Meso_411_4111004
end

function SkillLogic.isIgnorePDefSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Sacrifice_131_1311005 or skillID == book.Assaulter_421_4211002 or skillID == book.Demolition_512_5121004
end

function SkillLogic.isIgnorePGuardUpSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Shadow_Meso_411_4111004
end

function SkillLogic.isKeyDownSkill(self, skillID)
  if skillID == 3221001 or skillID == 5201002 or skillID == 2121001 or skillID == 5101004 or skillID == 2221001 or skillID == 2321001 or skillID == 4341002 or skillID == 4341003 or skillID == 3121004 or skillID == 5221004 or skillID == 22121000 or skillID == 14111006 or skillID == 22151001 or skillID == 15101003 or skillID == 13111002 or skillID == ___MOD._SkillBook.Monster_Magnet_112_1121001 or skillID == ___MOD._SkillBook.Monster_Magnet_122_1221001 or skillID == ___MOD._SkillBook.Monster_Magnet_132_1321001 then
    return true
  end
  return false
end

function SkillLogic.isMoveAffectedSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Dash_500_5001005 or skillID == book.Dash_1500_15001003 or skillID == book.Combat_Step_2100_21001001 or skillID == book.Wings_520_5201005
end

function SkillLogic.isNoClearSkill(self, skillID)
  local jobID = self:getJobIdFromSkillId(skillID)
  return jobID == 0 or jobID == 1000 or jobID == 2000 or jobID == 2001 or jobID == 3000
end

function SkillLogic.isRushAttackSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Rush_112_1121006 or skillID == book.Rush_122_1221007 or skillID == book.Rush_132_1321003 or skillID == book.Final_Charge_2110_21100002
end

function SkillLogic.isTeleportAttackSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Backspin_Blow_510_5101002 or skillID == book.Corkscrew_Blow_510_5101004 or skillID == book.Corkscrew_Blow_1510_15101003 or self:isRushAttackSkill(skillID)
end

function SkillLogic.isTeleportSkill(self, skillId)
  local book = ___MOD._SkillBook
  return skillId == book.Teleport_210_2101002 or skillId == book.Teleport_220_2201002 or skillId == book.Teleport_230_2301001 or skillId == book.Teleport_800_8001001 or skillId == book.Teleport_900_9001002 or skillId == book.Teleport_900_9001007 or skillId == book.Teleport_1210_12101003 or skillId == book.Teleport_2210_22101001 or skillId == book.Soul_Rush_1110_11101005
end

function SkillLogic.isThrowBombSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Grenade_520_5201002 or skillID == book.Poison_Bomb_1411_14111006
end

function SkillLogic.isTrembleAttackSkill(self, skillID)
  if self:isDragonRoar(skillID) or skillID == ___MOD._SkillBook.Shout_111_1111008 then
    return true
  end
  return false
end

function SkillLogic.shouldConfirmInvestForNextTier(self, player, skillID, gainLevel)
  if player == nil or player.SkillComponent == nil then
    return false
  end
  gainLevel = ___MOD.math.max(1, ___MOD.tonumber(gainLevel) or 1)
  local jobID = self:getJobIdFromSkillId(skillID)
  local jobTier = self:getJobTier(jobID)
  if jobTier < 1 or 3 < jobTier then
    return false
  end
  local recommendedLimit = self:getRecommendedTierSpendLimit(player, jobTier)
  if recommendedLimit <= 0 then
    return false
  end
  local usedSP = 0
  for sid, entry in ___MOD.pairs(player.SkillComponent.skills) do
    local parsedSkillID = ___MOD.tonumber(sid) or 0
    if not (parsedSkillID <= 0) and ___MOD.type(entry) == "table" then
      local tier = self:getJobTier(self:getJobIdFromSkillId(parsedSkillID))
      if tier == jobTier then
        usedSP = usedSP + ___MOD.math.max(0, ___MOD.tonumber(entry.skillLevel) or 0)
      end
    end
  end
  return recommendedLimit < usedSP + gainLevel
end

function SkillLogic.updateUseSP(self, jobTier, delta)
  if self._T.jobUseSP ~= nil and self._T.jobUseSP[jobTier] ~= nil then
    self._T.jobUseSP[jobTier] = self._T.jobUseSP[jobTier] + delta
  end
end
