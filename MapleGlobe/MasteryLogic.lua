

function MasteryLogic.canUseSkill(self, jobCode, skillId)
  return self:jobCodeToGroup(jobCode) == self:skillIdToGroup(skillId)
end

function MasteryLogic.getIncEvadeSkill(self, player)
  local job = player.Player.Job
  local skills = {
    ___MOD._SkillBook.Nimble_Body_400_4000000,
    ___MOD._SkillBook.Nimble_Body_1400_14000000,
    ___MOD._SkillBook.Bullet_Time_500_5000000,
    ___MOD._SkillBook.Quick_Motion_1500_15000000
  }
  local y = 0
  for k, skillID in ___MOD.pairs(skills) do
    if self:canUseSkill(job, skillID) then
      local skillLevel = player.SkillComponent:getSkillLevel(skillID)
      if 0 < skillLevel then
        local skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
        if skillLevelData ~= nil then
          y = skillLevelData.y
          break
        end
      end
    end
  end
  local BOFID = ___MOD._PlayerConstants:getBOFSkillID(job)
  if BOFID then
    local _, _, _, z = self:getMasteryBySkill(player, BOFID)
    y = y + z
  end
  local ts = player.PlayerTemporaryStatComponent
  local tsEva = ts:getValue(___MOD._CTS.Eva)
  y = y + tsEva
  return y, tsEva
end

function MasteryLogic.getMastery(self, player, weaponType, attackType)
  local job = player.Player.Job
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(player)
  local mastery = 0
  local skillID = 0
  local acc = 0
  local extendCharge = 0
  local pad = 0
  if 110 <= job and job <= 112 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD then
      skillID = ___MOD._SkillBook.Sword_Mastery_110_1100000
    elseif weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_AXE then
      skillID = ___MOD._SkillBook.Axe_Mastery_110_1100001
    end
  elseif 120 <= job and job <= 122 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD then
      skillID = ___MOD._SkillBook.Sword_Mastery_120_1200000
    elseif weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_MACE then
      skillID = ___MOD._SkillBook.BW_Mastery_120_1200001
    end
  elseif 130 <= job and job <= 132 then
    if weaponInfo.weaponType == ___MOD._WeaponType.SPEAR then
      skillID = ___MOD._SkillBook.Spear_Mastery_130_1300000
    elseif weaponInfo.weaponType == ___MOD._WeaponType.POLEARM then
      skillID = ___MOD._SkillBook.Pole_Arm_Mastery_130_1300001
    end
  elseif 310 <= job and job <= 312 then
    skillID = ___MOD._SkillBook.Bow_Mastery_310_3100000
  elseif 320 <= job and job <= 322 then
    skillID = ___MOD._SkillBook.Crossbow_Mastery_320_3200000
  elseif 410 <= job and job <= 412 then
    skillID = ___MOD._SkillBook.Claw_Mastery_410_4100000
  elseif 420 <= job and job <= 422 then
    skillID = ___MOD._SkillBook.Dagger_Mastery_420_4200000
  elseif 510 <= job and job <= 512 then
    if weaponInfo.weaponType == ___MOD._WeaponType.KNUCKLE then
      skillID = ___MOD._SkillBook.Knuckler_Mastery_510_5100001
    end
  elseif 520 <= job and job <= 522 then
    skillID = ___MOD._SkillBook.Gun_Mastery_520_5200000
  elseif 1110 <= job and job <= 1112 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD then
      skillID = ___MOD._SkillBook.Sword_Mastery_1110_11100000
    end
  elseif 1310 <= job and job <= 1312 then
    skillID = ___MOD._SkillBook.Bow_Mastery_1310_13100000
  elseif 1410 <= job and job <= 1412 then
    skillID = ___MOD._SkillBook.Claw_Mastery_1410_14100000
  elseif 1510 <= job and job <= 1512 then
    if weaponInfo.weaponType == ___MOD._WeaponType.KNUCKLE then
      skillID = ___MOD._SkillBook.Knuckle_Mastery_1510_15100001
    end
  elseif 2110 <= job and job <= 2112 and weaponInfo.weaponType == ___MOD._WeaponType.POLEARM then
    skillID = ___MOD._SkillBook.Polearm_Mastery_2110_21100000
  end
  if skillID ~= 0 then
    local skillLevel = player.SkillComponent:getSkillLevel(skillID)
    if 0 < skillLevel then
      local skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
      if skillLevelData ~= nil then
        mastery = skillLevelData.mastery
        acc = skillLevelData.x
        extendCharge = skillLevelData.y
        if extendCharge ~= 0 then
          player.Player.extendChargeStar = extendCharge
        end
      end
    end
  end
  if skillID == ___MOD._SkillBook.Bow_Mastery_310_3100000 then
    local expertSkillID = ___MOD._SkillBook.Bow_Expert_312_3120005
    local expertSkillLevel = player.SkillComponent:getSkillLevel(expertSkillID)
    if 0 < expertSkillLevel then
      local expertSkillLevelData = ___MOD._SkillManager:getSkillLevelData(expertSkillID, expertSkillLevel)
      if expertSkillLevelData ~= nil then
        mastery = expertSkillLevelData.mastery or mastery
        pad = pad + (___MOD.tonumber(expertSkillLevelData.x) or 0)
      end
    end
  elseif skillID == ___MOD._SkillBook.Crossbow_Mastery_320_3200000 then
    local expertSkillID = ___MOD._SkillBook.Marksman_Boost_322_3220004
    local expertSkillLevel = player.SkillComponent:getSkillLevel(expertSkillID)
    if 0 < expertSkillLevel then
      local expertSkillLevelData = ___MOD._SkillManager:getSkillLevelData(expertSkillID, expertSkillLevel)
      if expertSkillLevelData ~= nil then
        mastery = expertSkillLevelData.mastery or mastery
        pad = pad + (___MOD.tonumber(expertSkillLevelData.x) or 0)
      end
    end
  elseif skillID == ___MOD._SkillBook.Bow_Mastery_1310_13100000 then
    local expertSkillID = ___MOD._SkillBook.Bow_Expert_1311_13110003
    local expertSkillLevel = player.SkillComponent:getSkillLevel(expertSkillID)
    if 0 < expertSkillLevel then
      local expertSkillLevelData = ___MOD._SkillManager:getSkillLevelData(expertSkillID, expertSkillLevel)
      if expertSkillLevelData ~= nil then
        mastery = expertSkillLevelData.mastery or mastery
        pad = pad + (___MOD.tonumber(expertSkillLevelData.x) or 0)
      end
    end
  elseif skillID == ___MOD._SkillBook.Polearm_Mastery_2110_21100000 then
    local expertSkillID = ___MOD._SkillBook.High_Mastery_2112_21120001
    local expertSkillLevel = player.SkillComponent:getSkillLevel(expertSkillID)
    if 0 < expertSkillLevel then
      local expertSkillLevelData = ___MOD._SkillManager:getSkillLevelData(expertSkillID, expertSkillLevel)
      if expertSkillLevelData ~= nil then
        mastery = expertSkillLevelData.mastery or mastery
        pad = pad + (___MOD.tonumber(expertSkillLevelData.x) or 0)
      end
    end
  end
  local skills = {
    ___MOD._SkillBook.The_Blessing_of_Amazon_300_3000000,
    ___MOD._SkillBook.Nimble_Body_400_4000000,
    ___MOD._SkillBook.Bullet_Time_500_5000000,
    ___MOD._SkillBook.Nimble_Body_1400_14000000,
    ___MOD._SkillBook.Quick_Motion_1500_15000000
  }
  for k, skillID in ___MOD.pairs(skills) do
    if ___MOD._MasteryLogic:canUseSkill(job, skillID) then
      local m, x = ___MOD._MasteryLogic:getMasteryBySkill(player, skillID)
      if m ~= 0 or x ~= 0 then
        mastery = mastery + m
        acc = acc + x
      end
    end
  end
  if job == 132 then
    local slv = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Beholder_132_1321007)
    if 0 < slv then
      local sld = ___MOD._SkillManager:getSkillLevelData(___MOD._SkillBook.Beholder_132_1321007, slv)
      if sld ~= nil then
        mastery = mastery + sld.mastery
      end
    end
  end
  local BOFID = ___MOD._PlayerConstants:getBOFSkillID(job)
  if BOFID then
    local _, _, _, z = self:getMasteryBySkill(player, BOFID)
    acc = acc + z
  end
  local masteryLevel = ___MOD.tostring(mastery)
  if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.WeaponCharge) ~= 0 or player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.AssistCharge) ~= 0 or player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.SnowCharge) ~= 0 then
    masteryLevel = "charge"
  end
  local ts = player.PlayerTemporaryStatComponent
  local tsAcc = ts:getValue(___MOD._CTS.Acc)
  acc = acc + tsAcc
  if player.AfterImageComponent.lastMastery ~= masteryLevel or player.AfterImageComponent.lastWeaponType ~= weaponInfo.weaponType then
    player.AfterImageComponent.mastery = masteryLevel
    player.AfterImageComponent.lastMastery = masteryLevel
    player.AfterImageComponent.lastWeaponType = weaponInfo.weaponType
  end
  return mastery, acc, tsAcc, extendCharge, pad
end

function MasteryLogic.getMasteryBySkill(self, player, skillID)
  local skillLevel = player.SkillComponent:getSkillLevel(skillID)
  if 0 < skillLevel then
    local skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
    if skillLevelData ~= nil then
      return skillLevelData.mastery, skillLevelData.x, skillLevelData.y, skillLevelData.z
    end
  end
  return 0, 0, 0, 0
end

function MasteryLogic.jobCodeToGroup(self, jobCode)
  return ___MOD.math.floor(jobCode / 100) * 100
end

function MasteryLogic.skillIdToGroup(self, skillId)
  return ___MOD.math.floor(skillId / 10000)
end
