

function PlayerAttackLogic_FinalAttack.getFinalAttackIDListBySkillID(self, skillID)
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData ~= nil then
    local finalAttack = skillData.finalAttack
    if finalAttack ~= nil then
      return finalAttack
    end
  end
  return nil
end

function PlayerAttackLogic_FinalAttack.tryRegisterFinalAttack(self, player, attackSkillID, attackSkillLevel, weaponType, delay)
  if player.Player.Job >= 1000 and player.Player.Job <= 1512 and player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.FinalAttack) == 0 then
    return
  end
  local finalAttackInfo = self:getFinalAttackIDListBySkillID(attackSkillID)
  local mapleWeaponType = ___MOD.math.floor(weaponType / 10) % 100
  if finalAttackInfo ~= nil then
    local finalAttackSkillID = 0
    local finalAttackSkillLevel = 0
    for skillID, v in ___MOD.pairs(finalAttackInfo) do
      local slv = player.SkillComponent:getSkillLevel(skillID)
      if slv ~= 0 then
        for _, wt in ___MOD.pairs(v) do
          if wt == mapleWeaponType then
            finalAttackSkillID = skillID
            finalAttackSkillLevel = slv
            break
          end
        end
      end
    end
    if finalAttackSkillID ~= 0 then
      local finalAttack = ___MOD._SkillManager:getSkillLevelData(finalAttackSkillID, finalAttackSkillLevel)
      if finalAttack ~= nil then
        local prop = finalAttack.prop
        if prop >= ___MOD._GlobalRand32:randomIntegerRange(1, 100) then
          local faInfo = ___MOD.FinalAttackInfo()
          faInfo.finalAttackSkillID = finalAttackSkillID
          faInfo.lastAttackSkillID = attackSkillID
          faInfo.lastAttackSkillLevel = attackSkillLevel
          faInfo.weaponType = mapleWeaponType
          faInfo.startTime = ___MOD._UtilLogic.ElapsedSeconds + delay
          player.PlayerActionComponent.finalAttackInfo = faInfo
        end
      end
    end
  end
end
