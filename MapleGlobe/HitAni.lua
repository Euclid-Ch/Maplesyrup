

function HitAni.createDefault(self, skillID, charLevel, SLV, weaponItemID, action, mobCount, bulletItemID)
  if mobCount <= 0 then
    return nil
  end
  local hitAni = {}
  for i = 1, mobCount do
    if bulletItemID and 0 < bulletItemID and self:is_correct_bullet_cashitem(weaponItemID, bulletItemID) then
      do
        local cashBullet = ___MOD._ItemManager:getItemById(bulletItemID)
        hitAni[i] = cashBullet.hit
      end
    elseif skillID and 0 < skillID then
      if skillID == 3221001 or skillID == 5121007 or skillID == 15111004 then
        hitAni[i] = ___MOD._SkillManager:getHitUOLByIndex(skillID, charLevel, SLV, i)
      else
        hitAni[i] = ___MOD._SkillManager:getRandomHitUOL(skillID, charLevel, SLV)
      end
    else
      local weapon_type = self:get_weapon_type(weaponItemID)
      local path
      if weapon_type == 30 or weapon_type == 33 or weapon_type == 40 or weapon_type == 31 or weapon_type == 41 or weapon_type == 43 or weapon_type == 44 then
        path = "hit.img/sword"
      elseif weapon_type == 32 or weapon_type == 42 or weapon_type == 45 or weapon_type == 46 or weapon_type == 47 or weapon_type == 38 or weapon_type == 37 or weapon_type == 49 or weapon_type == 48 or weapon_type == 39 then
        path = "hit.img/mace"
      end
      if self:is_final_action(action) then
        path = ___MOD.string.format("%s%s", path, "F")
      else
        local rand = ___MOD._GlobalRand32:randomIntegerRange(1, 2)
        path = ___MOD.string.format("%s%s", path, ___MOD.tostring(rand))
      end
      hitAni[i] = ___MOD._AfterImageManager:getAnim(path)
    end
  end
  return hitAni
end

function HitAni.createFirst(self, skillID, mobCount)
  if mobCount <= 0 then
    return nil
  end
  local hitAni = {}
  for i = 1, mobCount do
    hitAni[i] = ___MOD._SkillManager:getHitUOLByIndex(skillID, 0, 0, i == 1 and 1 or 2)
  end
  return hitAni
end

function HitAni.createHitAni(self, skillID, charLevel, SLV, weaponItemID, action, mobCount, attackInfo, bulletItemID)
  if skillID == nil or skillID == 0 or ___MOD._SkillManager:getSkill(skillID) == nil then
    return self:createDefault(skillID, charLevel, SLV, weaponItemID, action, mobCount, bulletItemID)
  elseif skillID == 5121007 then
    return self:createMultipleLayer(skillID, 1)
  elseif skillID == 4211004 then
    return self:createShuffle(skillID, SLV, mobCount)
  elseif skillID == 3101005 or skillID == 3121006 or skillID == 3221005 or skillID == 5211002 then
    return self:createFirst(skillID, mobCount)
  else
    return self:createDefault(skillID, charLevel, SLV, weaponItemID, action, mobCount, bulletItemID)
  end
end

function HitAni.createMultipleLayer(self, skillID, idx)
  return nil
end

function HitAni.createShuffle(self, skillID, SLV, mobCount)
  if mobCount <= 0 then
    return nil
  end
  local hitAni = {}
  for i = 1, mobCount do
    hitAni[i] = ___MOD._SkillManager:getRandomHitUOL(skillID, 0, SLV)
  end
  return hitAni
end

function HitAni.get_weapon_type(self, itemID)
  if itemID // 1000000 ~= 1 then
    return 0
  end
  local result = itemID // 10000 % 100
  if 30 <= result and result <= 34 or 37 <= result and result <= 49 then
    return result
  else
    return 0
  end
end

function HitAni.is_correct_bullet_cashitem(self, weaponItemID, itemID)
  local weapon_type = self:get_weapon_type(weaponItemID)
  if weapon_type == 47 then
    return itemID // 1000 == 5021
  end
  return false
end

function HitAni.is_final_action(self, action)
  return action == 8 or action == 12 or action == 15 or action == 18 or action == 21 or action == 36 or action == 39
end
