

function MobManager.getMobAttackInfo(self, mobID, attackIdx)
  local mob = self:getMonster(mobID)
  if mob == nil then
    return nil
  end
  local mobAttack = mob.attack
  if mobAttack == nil then
    return nil
  end
  return mobAttack[attackIdx]
end

function MobManager.getMobSkillInfo(self, mobId, idx)
  local skills = self:getMobSkills(mobId)
  if skills == nil then
    return nil
  end
  return skills[idx]
end

function MobManager.getMobSkills(self, mobId)
  local info = self:getMonsterEntry(mobId, "info")
  if info == nil then
    return nil
  end
  return info.skill
end

function MobManager.getMonster(self, mobId)
  local mob = self:loadMob(mobId)
  if mob == nil then
    return nil
  end
  return mob
end

function MobManager.getMonsterEntry(self, mobId, key)
  local mob = self:getMonster(mobId)
  if mob == nil then
    return nil
  end
  local entry = mob[key]
  return entry
end

function MobManager.getTotalDelayAction(self, mobID, key)
  local ret = 0
  local data = self:getMonsterEntry(mobID, key)
  if data ~= nil then
    ret = data.totalDelay
  end
  return ret
end

function MobManager.loadMob(self, mobId)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local mobCache = self.mobData[mobId] or nil

  local function splitNameAndIndex(dirName)
    local base, num = dirName:match("^(.-)(%d+)$")
    if base then
      return base, ___MOD.tonumber(num)
    else
      return dirName, nil
    end
  end

  if mobCache == nil then
    local mobData = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Mob_wz", ___MOD.string.format("%07d.img", mobId))
    if mobData == nil then
      ___MOD.log_error("[loadMob] Monster 정보를 Mob.wz에서 찾을 수 없습니다. : " .. mobId)
      return nil
    end
    if ___MOD.type(mobData) ~= "table" then
      ___MOD.log_error("[loadMob] Monster data is not table: " .. mobId)
      return nil
    end
    local mob = {}
    for dirName, dir in ___MOD.pairs(mobData) do
      local key, index = splitNameAndIndex(dirName)
      if key == "info" then
        mob.info = self:parseInfo(mobId, dir)
      elseif key == "skill" then
        local skillCount = mob.skillCount or 0
        mob.skillCount = skillCount + 1
        mob[dirName] = ___MOD._WzUtils:parseAnimation(dir)
      elseif key == "attack" then
        local mobAttack = mob.attack
        if mobAttack == nil then
          mob.attack = {}
          mobAttack = mob.attack
        end
        local attackCount = mob.attackCount or 0
        mob.attackCount = attackCount + 1
        mob[dirName] = ___MOD._WzUtils:parseAnimation(dir)
        local info = dir.info
        if info then
          local mobAttackInfo = ___MOD.MobAttackInfo()
          mobAttackInfo:parseData(index, info)
          mobAttack[index] = mobAttackInfo
        end
      else
        mob[dirName] = ___MOD._WzUtils:parseAnimation(dir)
      end
    end
    local link = mob.info and mob.info.link or 0
    if link and 0 < link then
      local src = self.mobData[link] or nil
      if src == nil then
        src = self:loadMob(link)
      end
      if src and 0 < link and src then
        for k, v in ___MOD.pairs(src) do
          if k ~= "info" then
            mob[k] = v
          end
        end
      end
    end
    if mob.fly ~= nil then
      mob.info.movementType = ___MOD._MobMovementType.FLY
    elseif mob.jump ~= nil and mob.move ~= nil then
      mob.info.movementType = ___MOD._MobMovementType.JUMP
    elseif mob.move ~= nil then
      mob.info.movementType = ___MOD._MobMovementType.MOVE
    else
      mob.info.movementType = ___MOD._MobMovementType.STOP
    end
    self.mobData[mobId] = mob
    return mob
  end
  return mobCache
end

function MobManager.OnBeginPlay(self)
  self.mobData = {}
  ___MOD._WzUtils.genericCollectionCaches.Mob_wz = nil
end

function MobManager.parseInfo(self, mobId, info)
  local mob = ___MOD.Monster()
  mob.mobId = mobId
  mob.bodyAttack = ___MOD._WzUtils:getBoolean(info.bodyAttack, false)
  mob.undead = ___MOD._WzUtils:getBoolean(info.undead, false)
  mob.pushed = ___MOD._WzUtils:getInteger(info.pushed, 0)
  mob.rareItemDropLevel = ___MOD._WzUtils:getInteger(info.rareItemDropLevel, 0)
  mob.firstAttack = ___MOD._WzUtils:getBoolean(info.firstAttack, false)
  mob.summonType = ___MOD._WzUtils:getInteger(info.summonType, 0)
  mob.category = ___MOD._WzUtils:getInteger(info.category, 0)
  mob.noregen = ___MOD._WzUtils:getBoolean(info.noregen, false)
  mob.noFlip = ___MOD._WzUtils:getBoolean(info.noFlip, false)
  mob.hideName = ___MOD._WzUtils:getBoolean(info.hideName, false)
  mob.level = ___MOD._WzUtils:getInteger(info.level, 0)
  mob.maxHP = ___MOD._WzUtils:getInteger(info.maxHP, 0)
  mob.maxMP = ___MOD._WzUtils:getInteger(info.maxMP, 0)
  mob.hpRecovery = ___MOD._WzUtils:getInteger(info.hpRecovery, 0)
  mob.mpRecovery = ___MOD._WzUtils:getInteger(info.mpRecovery, 0)
  mob.paDamage = ___MOD._WzUtils:getInteger(info.PADamage, 0)
  mob.pdDamage = ___MOD._WzUtils:getInteger(info.PDDamage, 0)
  mob.maDamage = ___MOD._WzUtils:getInteger(info.MADamage, 0)
  mob.mdDamage = ___MOD._WzUtils:getInteger(info.MDDamage, 0)
  mob.pdRate = ___MOD._WzUtils:getInteger(info.PDRate, 0)
  mob.mdRate = ___MOD._WzUtils:getInteger(info.MDRate, 0)
  mob.eva = ___MOD._WzUtils:getInteger(info.eva, 0)
  mob.acc = ___MOD._WzUtils:getInteger(info.acc, 0)
  mob.exp = ___MOD._WzUtils:getInteger(info.exp, 0)
  mob.boss = ___MOD._WzUtils:getBoolean(info.boss, false)
  mob.hpGaugeHide = ___MOD._WzUtils:getBoolean(info.HPgaugeHide, false)
  mob.removeAfter = ___MOD._WzUtils:getInteger(info.removeAfter, 0)
  mob.hpTagBgColor = ___MOD._WzUtils:getInteger(info.hpTagBgcolor, 0)
  mob.hpTagColor = ___MOD._WzUtils:getInteger(info.hpTagColor, 0)
  mob.invincible = ___MOD._WzUtils:getBoolean(info.invincible, false)
  mob.speed = ___MOD._WzUtils:getInteger(info.speed, 0) + 100
  mob.flySpeed = ___MOD._WzUtils:getInteger(info.flySpeed, 0) + 100
  if info.chaseSpeed == nil then
  end
  mob.chaseSpeed = ___MOD._WzUtils:getInteger(info.chaseSpeed, 0) + 100
  mob.fixedDamage = ___MOD._WzUtils:getInteger(info.fixedDamage, 0)
  mob.doNotRemove = ___MOD._WzUtils:getBoolean(info.doNotRemove, false)
  mob.buff = ___MOD._WzUtils:getInteger(info.buff, 0)
  mob.coolDamage = ___MOD._WzUtils:getInteger(info.coolDamage, 0)
  mob.coolDamageProb = ___MOD._WzUtils:getInteger(info.coolDamageProb, 0)
  mob.damagedByMob = ___MOD._WzUtils:getBoolean(info.damagedByMob, false)
  mob.defaultHP = ___MOD._WzUtils:getString(info.defaultHP, "")
  mob.defaultMP = ___MOD._WzUtils:getString(info.defaultMP, "")
  mob.disable = ___MOD._WzUtils:getBoolean(info.disable, false)
  mob.dropItemPeriod = ___MOD._WzUtils:getInteger(info.dropItemPeriod, 0)
  mob.escort = ___MOD._WzUtils:getBoolean(info.escort, false)
  mob.explosiveReward = ___MOD._WzUtils:getBoolean(info.explosiveReward, false)
  mob.fs = ___MOD._WzUtils:getDouble(info.fs, 10.0)
  mob.getCP = ___MOD._WzUtils:getInteger(info.getCP, 0)
  mob.hideHP = ___MOD._WzUtils:getBoolean(info.hideHP, false)
  mob.ignoreFieldOut = ___MOD._WzUtils:getBoolean(info.ignoreFieldOut, false)
  mob.mbookID = ___MOD._WzUtils:getInteger(info.mbookID, 0)
  mob.mobType = ___MOD._WzUtils:getInteger(info.mobType, 0)
  mob.noDoom = ___MOD._WzUtils:getBoolean(info.noDoom, false)
  mob.notAttack = ___MOD._WzUtils:getBoolean(info.notAttack, false)
  mob.onlyNormalAttack = ___MOD._WzUtils:getBoolean(info.onlyNormalAttack, false)
  mob.point = ___MOD._WzUtils:getInteger(info.point, 0)
  mob.publicReward = ___MOD._WzUtils:getBoolean(info.publicReward, false)
  mob.removeOnMiss = ___MOD._WzUtils:getBoolean(info.removeOnMiss, false)
  mob.link = ___MOD._WzUtils:getInteger(info.link, 0)
  if info.selfDestruction then
    local sd = info.selfDestruction
    mob.selfDestructionHP = ___MOD._WzUtils:getInteger(sd.hp, 0)
    local action = ___MOD._WzUtils:getInteger(sd.action, 0)
    mob.selfDestruction = action ~= 0
    mob.firstSelfDestruction = action >> 1 & 1 == 1
  end
  if info.revive then
    mob.revive = {}
    for i = 0, 100 do
      local mobID = info.revive[___MOD.tostring(i)]
      if mobID ~= nil and mobID ~= 0 then
        mob.revive[i + 1] = ___MOD._WzUtils:getInteger(mobID, 0)
      else
        break
      end
    end
  end
  if info.ban then
    mob.ban = {}
    local ban = mob.ban
    local banMap = info.ban.banMap
    ban.banType = ___MOD._WzUtils:getInteger(info.ban.banType, 0)
    if banMap and banMap["0"] then
      banMap = banMap["0"]
      ban.portal = ___MOD._WzUtils:getString(banMap.portal, nil)
      ban.field = ___MOD._WzUtils:getInteger(banMap.field, nil)
    end
    ban.banMsg = ___MOD._WzUtils:getString(info.ban.banMsg, nil)
  end
  if info.skill then
    mob.skill = {}
    for i = 0, 100 do
      local s = info.skill[___MOD.tostring(i)]
      if s == nil then
        break
      end
      local skillInfo = ___MOD.MobSkillInfo()
      skillInfo:parseData(i + 1, s)
      mob.skill[i + 1] = skillInfo
    end
  end
  local elemAttr = ___MOD._WzUtils:getString(info.elemAttr, "")
  mob.elemAttr = self:parseMobElementAttr(elemAttr)
  return mob
end

function MobManager.parseMobElementAttr(self, elemAttr)
  local result = {}
  if ___MOD._UtilLogic:IsNilorEmptyString(elemAttr) then
    return result
  end
  for codeChar, numChar in ___MOD.string.gmatch(elemAttr, "(%a)(%d)") do
    local attrType = ___MOD.tonumber(numChar)
    if attrType ~= nil and codeChar ~= nil then
      result[codeChar] = attrType
    end
  end
  return result
end
