

function Physics.getWingsFallSpeedMaxY(self, skillID, skillLevel)
  local skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
  if skillLevelData ~= nil then
    local x = skillLevelData.x
    local vy = x * self.jumpSpeed / 1000 / self.fallSpeed
    return vy
  end
  return 1.0
end
