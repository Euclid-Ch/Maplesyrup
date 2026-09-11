

function SkillManager.ensureAttackTypeLoaded(self)
  if not self.fastLoad then
    return
  end
  if self.attackTypeData ~= nil and ___MOD.next(self.attackTypeData) ~= nil then
    return
  end
  local all = {}
  for _, data in ___MOD.ipairs(self.attackTypeRaw) do
    data = ___MOD._WzUtils:parseWzData(data)
    if ___MOD.type(data) == "table" then
      local parsed = self:parseAttackTypeData(data)
      for attackTypeId, attackType in ___MOD.pairs(parsed) do
        all[attackTypeId] = attackType
      end
    end
  end
  self.attackTypeData = all
end

function SkillManager.ensureMobSkillLoaded(self)
  if not self.fastLoad then
    return
  end
  if self.mobSkillData ~= nil and ___MOD.next(self.mobSkillData) ~= nil then
    return
  end
  local all = {}
  for _, data in ___MOD.ipairs(self.mobSkillRaw) do
    data = ___MOD._WzUtils:parseWzData(data)
    if ___MOD.type(data) == "table" then
      local parsed = self:parseMobSkillData(data)
      for skillID, levelTbl in ___MOD.pairs(parsed) do
        if all[skillID] == nil then
          all[skillID] = {}
        end
        for lvl, mobSkill in ___MOD.pairs(levelTbl) do
          all[skillID][lvl] = mobSkill
        end
      end
    end
  end
  self.mobSkillData = all
end

function SkillManager.ensureSkillLoaded(self, jobId)
  if not self.fastLoad then
    return
  end
  local jobKey = ___MOD.string.format("%04d", jobId)
  if self.skillData[jobKey] ~= nil then
    return
  end
  local compressed = self.skillRaw[jobKey]
  if compressed == nil then
    return
  end
  local data = self.skillRaw[jobKey]
  data = ___MOD._WzUtils:parseWzData(data)
  if ___MOD.type(data) ~= "table" then
    return
  end
  local skillBook = {}
  self.skillData[jobKey] = skillBook
  self:parseJobSkillBook(jobId, data, skillBook, compressed)
end

function SkillManager.extractSkillOrder(self, rawData)
  if ___MOD.type(rawData) ~= "string" then
    return nil
  end
  local skillPos = ___MOD.string.find(rawData, "\"skill\"", 1, true)
  if skillPos == nil then
    return nil
  end
  local blockStart = ___MOD.string.find(rawData, "{", skillPos, true)
  if blockStart == nil then
    return nil
  end
  local order = {}
  local seen = {}
  local depth = 1
  local i = blockStart + 1
  local n = ___MOD.string.len(rawData)
  while i <= n and 0 < depth do
    local ch = ___MOD.string.sub(rawData, i, i)
    if ch == "\"" then
      local j = i + 1
      while n >= j do
        local cj = ___MOD.string.sub(rawData, j, j)
        if cj == "\\" then
          j = j + 2
        else
          if cj == "\"" then
            break
          end
          j = j + 1
        end
      end
      local key = ___MOD.string.sub(rawData, i + 1, j - 1)
      local k = j + 1
      while n >= k do
        local wk = ___MOD.string.sub(rawData, k, k)
        if wk == " " or wk == "\t" or wk == "\r" or wk == "\n" then
          k = k + 1
        else
          break
        end
      end
      if depth == 1 and ___MOD.string.sub(rawData, k, k) == ":" then
        k = k + 1
        while n >= k do
          local wk = ___MOD.string.sub(rawData, k, k)
          if wk == " " or wk == "\t" or wk == "\r" or wk == "\n" then
            k = k + 1
          else
            break
          end
        end
        local skillId = ___MOD.tonumber(key)
        if skillId ~= nil and ___MOD.string.sub(rawData, k, k) == "{" and seen[skillId] ~= true then
          seen[skillId] = true
          order[#order + 1] = skillId
        end
      end
      i = j
    elseif ch == "{" then
      depth = depth + 1
    elseif ch == "}" then
      depth = depth - 1
    end
    i = i + 1
  end
  if #order <= 0 then
    return nil
  end
  return order
end

function SkillManager.get_novice_skill_as_race(self, skillID, jobID)
  if jobID // 100 == 22 or jobID == 2001 then
    return skillID + 20010000
  else
    return skillID + 10000000 * (jobID // 1000)
  end
end

function SkillManager.getAttackType(self, attackTypeId)
  if self.fastLoad then
    self:ensureAttackTypeLoaded()
  end
  return self.attackTypeData[attackTypeId] or nil
end

function SkillManager.getAttackTypeLevelData(self, attackTypeId, level)
  if level <= 0 then
    return nil
  end
  local attackType = self:getAttackType(attackTypeId)
  if attackType == nil or attackType.level == nil then
    return nil
  end
  return attackType.level[level] or nil
end

function SkillManager.getHitUOLByIndex(self, skillID, charLevel, SLV, idx)
  local skill = self:getSkill(skillID)
  if skill == nil then
    return
  end
  local hit = skill.hit
  if hit == nil then
    return
  end
  return hit[idx]
end

function SkillManager.getMobSkill(self, skillId, level)
  if self.fastLoad then
    self:ensureMobSkillLoaded()
  end
  local mobSkill = self.mobSkillData
  return mobSkill[skillId] and mobSkill[skillId][level] or nil
end

function SkillManager.getRandomHitUOL(self, skillID, charLevel, SLV)
  local skill = self:getSkill(skillID)
  if skill == nil then
    return
  end
  local hit = skill.hit
  if hit == nil then
    return
  end
  local hitCount = #hit
  if hitCount == 0 then
    return
  end
  return hit[___MOD._GlobalRand32:randomIntegerRange(1, hitCount)]
end

function SkillManager.getSkill(self, skillId)
  local jobId = skillId // 10000
  if jobId == 1 then
    jobId = 0
  end
  local jobKey = ___MOD.string.format("%04d", jobId)
  if self.fastLoad then
    self:ensureSkillLoaded(jobId)
  end
  local skillBook = self.skillData[jobKey] or nil
  if skillBook == nil or skillBook.skill == nil then
    return nil
  end
  return skillBook.skill[skillId] or nil
end

function SkillManager.getSkillBook(self, jobId)
  local jobKey = ___MOD.string.format("%04d", jobId)
  if self.fastLoad then
    self:ensureSkillLoaded(jobId)
  end
  local skillBook = self.skillData[jobKey] or nil
  if skillBook == nil then
    return nil
  end
  return skillBook
end

function SkillManager.getSkillLevelData(self, skillId, level)
  if level <= 0 then
    return
  end
  local skill = self:getSkill(skillId)
  if skill == nil then
    return
  end
  return skill.level[level]
end

function SkillManager.getSkillsByJobId(self, jobId)
  local jobKey = ___MOD.string.format("%04d", jobId)
  if self.fastLoad then
    self:ensureSkillLoaded(jobId)
  end
  local skillBook = self.skillData[jobKey] or nil
  if skillBook == nil or skillBook.skill == nil then
    return nil
  end
  return skillBook.skill
end

function SkillManager.loadSkill(self)
  if self:IsServer() then
    self.fastLoad = ___MOD.Environment:IsMakerPlay()
  end
  if self.fastLoad then
    self:loadSkillLazy()
  else
    self:loadSkillFull()
  end
end

function SkillManager.loadSkillFull(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local id, json, data, jobId, skillId
  local skillCache = {}
  local combinedMobSkill = {}
  local combinedAttackType = {}
  self.count = 0
  self.mobSkillData = {}
  self.attackTypeData = {}
  self.skillData = {}
  local dataset = ___MOD._DataService:GetTable("Skill_wz")
  if dataset ~= nil then
    local rowCount = dataset:GetRowCount()
    for i = 1, rowCount do
      id = ___MOD._UtilLogic:Replace(dataset:GetCell(i, "key"), ".img", "")
      data = dataset:GetCell(i, "data")
      if data ~= nil then
        data = ___MOD._WzUtils:parseWzData(data)
        jobId = ___MOD.tonumber(id)
        if jobId == nil then
          if id == "MobSkill" then
            local mobPart = self:parseMobSkillData(data)
            for msId, levelTbl in ___MOD.pairs(mobPart) do
              combinedMobSkill[msId] = combinedMobSkill[msId] or {}
              for lvl, mobSkill in ___MOD.pairs(levelTbl) do
                combinedMobSkill[msId][lvl] = mobSkill
              end
            end
          elseif id == "Attacktype" then
            local attackPart = self:parseAttackTypeData(data)
            for attackTypeId, attackType in ___MOD.pairs(attackPart) do
              combinedAttackType[attackTypeId] = attackType
            end
          end
        else
          local jobKey = ___MOD.string.format("%04d", jobId)
          skillCache[jobKey] = {}
          local skillBook = skillCache[jobKey]
          self:parseJobSkillBook(jobId, data, skillBook, dataset:GetCell(i, "data"))
        end
      end
    end
  end
  self.skillData = skillCache
  self.mobSkillData = combinedMobSkill
  self.attackTypeData = combinedAttackType
  ___MOD.log(___MOD.string.format("Loaded Skill.wz (Full) (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end

function SkillManager.loadSkillLazy(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  self.skillRaw = {}
  self.mobSkillRaw = {}
  self.attackTypeRaw = {}
  self.skillData = {}
  self.mobSkillData = {}
  self.attackTypeData = {}
  self.count = 0
  local dataset = ___MOD._DataService:GetTable("Skill_wz")
  if dataset ~= nil then
    local rowCount = dataset:GetRowCount()
    for i = 1, rowCount do
      local rawKey = dataset:GetCell(i, "key")
      local id = ___MOD._UtilLogic:Replace(rawKey, ".img", "")
      local dataTbl = dataset:GetCell(i, "data")
      if dataTbl ~= nil then
        if id == "MobSkill" then
          ___MOD.table.insert(self.mobSkillRaw, dataTbl)
        elseif id == "Attacktype" then
          ___MOD.table.insert(self.attackTypeRaw, dataTbl)
        else
          local clean = ___MOD.tostring(id)
          clean, ___MOD._ = clean:gsub("^Skill/", ""):gsub("^Skill", "")
          clean, ___MOD._ = clean:gsub("[^%d]", "")
          local jobId = ___MOD.tonumber(clean)
          if jobId ~= nil then
            local jobKey = ___MOD.string.format("%04d", jobId)
            self.skillRaw[jobKey] = dataTbl
          end
        end
      end
    end
  end
  local jobCount = 0
  for _ in ___MOD.pairs(self.skillRaw) do
    jobCount = jobCount + 1
  end
  ___MOD.log(___MOD.string.format("Indexed Skill.wz (Lazy) (%.2f secs) RawJobCount : %d", ___MOD._UtilLogic.ElapsedSeconds - time, jobCount))
  ___MOD._DataLoadManager:compeletedLoad()
end

function SkillManager.parseAttackTypeData(self, data)
  local ret = {}
  for dirName, dir in ___MOD.pairs(data) do
    local attackTypeId = ___MOD.tonumber(dirName)
    if attackTypeId ~= nil and ___MOD.type(dir) == "table" then
      ret[attackTypeId] = {}
      local attackType = ret[attackTypeId]
      attackType.info = ___MOD._WzUtils:getString(dir.info, "")
      if dir.level ~= nil then
        attackType.level = self:parseSkillLevelData(dir.level)
      else
        attackType.level = {}
      end
    end
  end
  return ret
end

function SkillManager.parseJobSkillBook(self, jobId, data, skillBook, rawData)
  if ___MOD.type(data) ~= "table" then
    return
  end
  local skills, skillId
  for dirName, dir in ___MOD.pairs(data) do
    if dirName == "info" then
      skillBook.info = {}
      local bookIcon = dir.icon or nil
      if bookIcon and self:IsClient() then
        skillBook.info.icon = ___MOD.__RUIDManager:get(bookIcon.image)
      end
    elseif dirName == "skill" and ___MOD.type(dir) == "table" then
      skillBook.skill = {}
      skillBook.skillOrder = self:extractSkillOrder(rawData) or {}
      for skillIdStr, skill in ___MOD.pairs(dir) do
        skillId = ___MOD.tonumber(skillIdStr) or 0
        if skillId ~= 0 then
          skillBook.skill[skillId] = {}
          skills = skillBook.skill[skillId]
          if ___MOD.type(skill) == "table" then
            for keyName, key in ___MOD.pairs(skill) do
              if ___MOD.string.find(keyName, "icon", 1, true) == 1 and self:IsClient() then
                skills[keyName] = ___MOD.__RUIDManager:get(key.image)
                if ___MOD.type(key) == "table" then
                  local w = ___MOD.tonumber(key._width)
                  local h = ___MOD.tonumber(key._height)
                  if w ~= nil and h ~= nil then
                    skills[keyName .. "Size"] = ___MOD.FastVector2(w * 2, h * 2)
                  end
                end
              elseif keyName == "level" then
                skills.level = self:parseSkillLevelData(key)
                skills.fixedMasterLevel = #skills.level
              elseif keyName == "action" then
                skills.action = {}
                if ___MOD.type(key) ~= "table" then
                  skills.action["0"] = ___MOD._WzUtils:getString(key, "")
                elseif key._type == "string" then
                  skills.action["0"] = ___MOD._WzUtils:getString(key, "")
                else
                  for k, value in ___MOD.pairs(key) do
                    skills.action[k] = ___MOD._WzUtils:getString(value, "")
                  end
                end
              elseif keyName == "finalAttack" then
                skills.finalAttack = {}
                if ___MOD.type(key) == "table" then
                  for k, value in ___MOD.pairs(key) do
                    skills.finalAttack[___MOD.tonumber(k)] = {}
                    if ___MOD.type(value) == "table" then
                      for _, weaponType in ___MOD.pairs(value) do
                        ___MOD.table.insert(skills.finalAttack[___MOD.tonumber(k)], ___MOD._WzUtils:getInteger(weaponType, 0))
                      end
                    end
                  end
                end
              elseif keyName == "elemAttr" then
                local e = ___MOD._WzUtils:getString(key, "")
                skills.elemAttr = e == "" and "" or ___MOD.string.upper(e)
              elseif keyName == "req" then
                skills.req = {}
                if ___MOD.type(key) == "table" then
                  for skillIdReq, levelNode in ___MOD.pairs(key) do
                    local reqId = ___MOD.tonumber(skillIdReq)
                    if reqId then
                      skills.req[reqId] = ___MOD._WzUtils:getInteger(levelNode, 0)
                    end
                  end
                end
              elseif keyName == "afterimage" then
                skills[keyName] = {}
                if ___MOD.type(key) == "table" then
                  for k, v in ___MOD.pairs(key) do
                    skills[keyName][k] = ___MOD._AfterImageManager:parseMotions(v, k, -1, jobId, skillId, false)
                  end
                end
              elseif keyName == "hit" then
                skills[keyName] = {}
                if ___MOD.type(key) ~= "table" then
                elseif key._type == nil then
                  for hk, hv in ___MOD.pairs(key) do
                    if skillId == ___MOD._SkillBook.Charged_Blow_121_1211002 then
                      for idx, v in ___MOD.pairs(hv) do
                        skills[keyName][___MOD.tonumber(idx)] = ___MOD._WzUtils:parseAnimation(v)
                      end
                    elseif skillId == ___MOD._SkillBook.Blast_122_1221009 then
                      local idx = ___MOD.tonumber(hk)
                      if idx ~= nil and ___MOD.type(hv) == "table" then
                        local parsed = {}
                        for chargeIdx, chargeValue in ___MOD.pairs(hv) do
                          local chargeNum = ___MOD.tonumber(chargeIdx)
                          if chargeNum ~= nil then
                            parsed[chargeNum + 1] = ___MOD._WzUtils:parseAnimation(chargeValue)
                          end
                        end
                        skills[keyName][idx + 1] = parsed
                      end
                    else
                      local idx = ___MOD.tonumber(hk)
                      if idx then
                        skills[keyName][idx + 1] = ___MOD._WzUtils:parseAnimation(hv)
                      end
                    end
                  end
                else
                  skills[keyName][1] = ___MOD._WzUtils:parseAnimation(key)
                end
              elseif ___MOD.string.match(keyName, "^hit%d+$") then
                if key._type ~= nil then
                  skills[keyName] = ___MOD._WzUtils:parseAnimation(key)
                elseif key["0"] ~= nil and key["0"]["0"] ~= nil then
                  skills[keyName] = ___MOD._WzUtils:parseAnimation(key["0"])
                  if skills[keyName] ~= nil then
                    if skills[keyName].pos == nil and key.pos ~= nil then
                      skills[keyName].pos = ___MOD._WzUtils:getInteger(key.pos, 0)
                    end
                    if skills[keyName].hitAfter == nil and key.hitAfter ~= nil then
                      skills[keyName].hitAfter = ___MOD._WzUtils:getInteger(key.hitAfter, 0)
                    end
                    if skills[keyName]["repeat"] == nil and key["repeat"] ~= nil then
                      skills[keyName]["repeat"] = ___MOD._WzUtils:getInteger(key["repeat"], -1) + 1
                    end
                    if skills[keyName].z == nil and key.z ~= nil then
                      skills[keyName].z = ___MOD._WzUtils:getInteger(key.z, 0)
                    end
                  end
                elseif key["0"] ~= nil then
                  skills[keyName] = ___MOD._WzUtils:parseAnimation(key)
                else
                  skills[keyName] = {}
                  for lvl, value in ___MOD.pairs(key) do
                    if ___MOD.type(value) == "table" then
                      skills[keyName][lvl] = ___MOD._WzUtils:parseAnimation(value)
                    end
                  end
                end
              elseif keyName == "invisible" then
                skills.invisible = ___MOD._WzUtils:getBoolean(key, false)
              elseif keyName == "tile" then
                local tile = ___MOD.FootholdEffect()
                tile:parseData(key)
                skills.tile = tile
              elseif keyName == "weapon" or keyName == "weapon " then
                skills.weapon = ___MOD._WzUtils:getInteger(key, 0)
              elseif keyName == "subWeapon" then
                skills.subWeapon = ___MOD._WzUtils:getInteger(key, 0)
              elseif keyName == "masterLevel" then
                skills.masterLevel = ___MOD._WzUtils:getInteger(key, 0)
              elseif keyName == "CharLevel" then
                skills.charLevel = {}
                if ___MOD.type(key) == "table" then
                  for levelStr, levelNode in ___MOD.pairs(key) do
                    if ___MOD.type(levelNode) ~= "table" then
                      skills.charLevel[levelStr] = levelNode
                    else
                      skills.charLevel[levelStr] = {}
                      local hit = levelNode.hit
                      if hit ~= nil then
                        skills.charLevel[levelStr].hit = {}
                        for hk, hv in ___MOD.pairs(hit) do
                          local hkNum = ___MOD.tonumber(hk)
                          if hkNum ~= nil then
                            skills.charLevel[levelStr].hit[hkNum + 1] = ___MOD._WzUtils:parseAnimation(hv)
                          end
                        end
                      end
                      local effect = levelNode.effect
                      if effect ~= nil then
                        skills.charLevel[levelStr].effect = ___MOD._WzUtils:parseAnimation(effect)
                      end
                      local hit0 = levelNode.hit0
                      if hit0 ~= nil then
                        skills.charLevel[levelStr].hit0 = ___MOD._WzUtils:parseAnimation(hit0)
                      end
                      local hit1 = levelNode.hit1
                      if hit1 ~= nil then
                        skills.charLevel[levelStr].hit1 = ___MOD._WzUtils:parseAnimation(hit1)
                      end
                      local ball = levelNode.ball
                      if ball ~= nil then
                        skills.charLevel[levelStr].ball = ___MOD._WzUtils:parseAnimation(ball)
                      end
                    end
                  end
                end
              elseif keyName == "prepare" then
                local prepare = ___MOD.SkillPrepare()
                prepare:parseData(key)
                skills[keyName] = prepare
              elseif keyName == "mob" or keyName == "mob0" then
                local mob = ___MOD.MobSkillMob()
                mob:parseData(key)
                skills[keyName] = mob
              elseif keyName == "stopEffect" then
                skills[keyName] = {}
                if key._type == nil then
                  for hk, hv in ___MOD.pairs(key) do
                    skills[keyName][hk] = ___MOD._WzUtils:parseAnimation(hv)
                  end
                else
                  skills[keyName] = ___MOD._WzUtils:parseAnimation(key)
                end
              elseif ___MOD.string.find(keyName, "effect") or keyName == "ball" or keyName == "special" or keyName == "affected" or keyName == "keydown0" or keyName == "keydown" or keyName == "keydownend" or keyName == "finish" or keyName == "state" then
                skills[keyName] = {}
                if (skillId == ___MOD._SkillBook.Inferno_311_3111003 or skillId == ___MOD._SkillBook.Arrow_Rain_1311_13111000 or skillId == ___MOD._SkillBook.Arrow_Rain_311_3111004 or skillId == ___MOD._SkillBook.Blizzard_321_3211003 or skillId == ___MOD._SkillBook.Arrow_Eruption_321_3211004 or skillId == ___MOD._SkillBook.Combo_Tempest_2112_21120006) and keyName == "special" then
                  local fa = ___MOD.FallingAnimation()
                  fa:parseData(key)
                  skills[keyName] = fa
                elseif (skillId == ___MOD._SkillBook.Shadow_Partner_411_4111002 or skillId == ___MOD._SkillBook.Shadow_Partner_1411_14111000) and keyName == "special" then
                  for action, value in ___MOD.pairs(key) do
                    if ___MOD.type(value) == "table" then
                      local anim = ___MOD._WzUtils:parseAnimation(value)
                      if action ~= "dead" and action ~= "sit" then
                        for k, v in ___MOD.ipairs(anim.anim) do
                          local a = v
                          local motionInfo = ___MOD._MotionDataManager:getMotionData(action)[k]
                          a.delay = ___MOD.math.abs(motionInfo.delay)
                        end
                      end
                      if action == "stand1" or action == "stand2" or action == "alert" then
                        anim.zigzag = true
                      end
                      skills[keyName][action] = anim
                    end
                  end
                elseif (skillId == ___MOD._SkillBook.Explosion_211_2111002 or skillId == ___MOD._SkillBook.Big_Bang_212_2121001 or skillId == ___MOD._SkillBook.Big_Bang_222_2221001 or skillId == ___MOD._SkillBook.Big_Bang_232_2321001) and keyName == "special" then
                  local ea = ___MOD.ExplosionAnimation()
                  ea:parseData(key)
                  skills[keyName] = ea
                elseif key._type ~= nil or keyName == "keydown0" or keyName == "keydown" or keyName == "keydownend" then
                  skills[keyName] = ___MOD._WzUtils:parseAnimation(key)
                elseif keyName == "state" then
                  if skillId == ___MOD._SkillBook.Combo_Attack_1111_11111001 or skillId == ___MOD._SkillBook.Combo_Attack_111_1111002 or skillId == ___MOD._SkillBook.Advanced_combo_1111_11110005 or skillId == ___MOD._SkillBook.Advanced_Combo_Attack_112_1120003 then
                    for i = 0, 5 do
                      skills[keyName][___MOD.tonumber(i)] = ___MOD._WzUtils:parseAnimation_(key, i)
                    end
                  else
                    skills[keyName] = ___MOD._WzUtils:parseAnimation(key)
                  end
                elseif key["0"] ~= nil then
                  if key["0"]["0"] ~= nil then
                    for lvl, sub in ___MOD.pairs(key) do
                      skills[keyName][lvl] = ___MOD._WzUtils:parseAnimation(sub)
                    end
                  else
                    skills[keyName] = ___MOD._WzUtils:parseAnimation(key)
                  end
                else
                  for lvl, value in ___MOD.pairs(key) do
                    if ___MOD.type(value) == "table" then
                      skills[keyName][lvl] = ___MOD._WzUtils:parseAnimation(value)
                    end
                  end
                end
              elseif keyName == "disable" then
                skills.disable = ___MOD._WzUtils:getBoolean(key, false)
              elseif keyName == "timeLimited" then
                skills.timeLimited = ___MOD._WzUtils:getBoolean(key, false)
              elseif keyName == "mDoor" or keyName == "cDoor" or keyName == "Frame" then
                skills[keyName] = ___MOD._WzUtils:parseAnimation(key)
              elseif keyName == "summon" then
                local summon = {}
                summon.pSkill = skills
                summon.attackInfo = {}
                summon.skillInfo = {}
                for actionName, action in ___MOD.pairs(key) do
                  summon[actionName] = {}
                  local name, idx = self:split_tail_number(actionName)
                  if idx and name == "attack" then
                    local attackInfo = ___MOD.SummonAttackInfo()
                    attackInfo:parseData(skillId, action.info)
                    summon.attackInfo[idx] = attackInfo
                  elseif not idx or name == "skill" then
                  end
                  summon[actionName] = ___MOD._WzUtils:parseAnimation(action)
                end
                skills.summon = summon
              end
              self.count = self.count + 1
            end
          end
        end
      end
    end
  end
end

function SkillManager.parseMobSkillData(self, data)
  local ret = {}
  for dirName, dir in ___MOD.pairs(data) do
    local skillID = ___MOD.tonumber(dirName)
    if skillID then
      ret[skillID] = {}
      local levelData = dir.level
      if levelData ~= nil then
        for level, v in ___MOD.pairs(levelData) do
          local mobSkill = ___MOD.MobSkill()
          mobSkill:parseData(v)
          ret[skillID][___MOD.tonumber(level)] = mobSkill
        end
      end
    end
  end
  return ret
end

function SkillManager.parseSkillLevelData(self, skill)
  local entryTable = {}
  for level, base in ___MOD.pairs(skill) do
    local skillLevel = ___MOD.tonumber(level)
    if skillLevel then
      entryTable[skillLevel] = {}
      local entry = entryTable[skillLevel]
      entry.fixDamage = ___MOD._WzUtils:getInteger(base.fixdamage, 0)
      entry.attackCount = ___MOD._WzUtils:getInteger(base.attackCount, 0)
      entry.mobCount = ___MOD._WzUtils:getInteger(base.mobCount, 0)
      entry.time = ___MOD._WzUtils:getInteger(base.time, 0)
      entry.subTime = ___MOD._WzUtils:getInteger(base.subTime, 0)
      entry.mpCon = ___MOD._WzUtils:getInteger(base.mpCon, 0)
      entry.hpCon = ___MOD._WzUtils:getInteger(base.hpCon, 0)
      entry.damage = ___MOD._WzUtils:getInteger(base.damage, 0)
      if entry.damage == 0 then
        entry.damage = ___MOD._WzUtils:getInteger(base.dmg, 0)
      end
      entry.mastery = ___MOD._WzUtils:getInteger(base.mastery, 0)
      entry.damR = ___MOD._WzUtils:getInteger(base.damR, 0)
      entry.dot = ___MOD._WzUtils:getInteger(base.dot, 0)
      entry.dotTime = ___MOD._WzUtils:getInteger(base.dotTime, 0)
      entry.mesoR = ___MOD._WzUtils:getInteger(base.mesoR, 0)
      entry.SPEED = ___MOD._WzUtils:getInteger(base.speed, 0)
      entry.JUMP = ___MOD._WzUtils:getInteger(base.jump, 0)
      entry.PAD = ___MOD._WzUtils:getInteger(base.pad, 0)
      entry.MAD = ___MOD._WzUtils:getInteger(base.mad, 0)
      entry.PDD = ___MOD._WzUtils:getInteger(base.pdd, 0)
      entry.MDD = ___MOD._WzUtils:getInteger(base.mdd, 0)
      entry.EVA = ___MOD._WzUtils:getInteger(base.eva, 0)
      entry.ACC = ___MOD._WzUtils:getInteger(base.acc, 0)
      entry.HP = ___MOD._WzUtils:getInteger(base.hp, 0)
      entry.mHPr = ___MOD._WzUtils:getInteger(base.mhpR, 0)
      entry.MP = ___MOD._WzUtils:getInteger(base.mp, 0)
      entry.mMPr = ___MOD._WzUtils:getInteger(base.mmpR, 0)
      entry.prop = ___MOD._WzUtils:getInteger(base.prop, 0)
      entry.missprop = ___MOD._WzUtils:getInteger(base.missprop, 0)
      entry.subProp = ___MOD._WzUtils:getInteger(base.subProp, 0)
      entry.cooltime = ___MOD._WzUtils:getInteger(base.cooltime, 0)
      entry.ASRr = ___MOD._WzUtils:getInteger(base.asrR, 0)
      entry.TERr = ___MOD._WzUtils:getInteger(base.terR, 0)
      entry.EMDD = ___MOD._WzUtils:getInteger(base.emdd, 0)
      entry.EMHP = ___MOD._WzUtils:getInteger(base.emhp, 0)
      entry.EMMP = ___MOD._WzUtils:getInteger(base.emmp, 0)
      entry.EPAD = ___MOD._WzUtils:getInteger(base.epad, 0)
      entry.EPDD = ___MOD._WzUtils:getInteger(base.epdd, 0)
      entry.cr = ___MOD._WzUtils:getInteger(base.cr, 0)
      entry.t = ___MOD._WzUtils:getDouble(base.t, 0)
      entry.u = ___MOD._WzUtils:getDouble(base.u, 0)
      entry.v = ___MOD._WzUtils:getDouble(base.v, 0)
      entry.w = ___MOD._WzUtils:getDouble(base.w, 0)
      entry.x = ___MOD._WzUtils:getDouble(base.x, 0)
      entry.y = ___MOD._WzUtils:getDouble(base.y, 0)
      entry.z = ___MOD._WzUtils:getDouble(base.z, 0)
      entry.PADr = ___MOD._WzUtils:getInteger(base.padR, 0)
      entry.PADx = ___MOD._WzUtils:getInteger(base.padX, 0)
      entry.MADr = ___MOD._WzUtils:getInteger(base.madR, 0)
      entry.MADx = ___MOD._WzUtils:getInteger(base.madX, 0)
      entry.PDDr = ___MOD._WzUtils:getInteger(base.pddR, 0)
      entry.MDDr = ___MOD._WzUtils:getInteger(base.mddR, 0)
      entry.EVAr = ___MOD._WzUtils:getInteger(base.evaR, 0)
      entry.ACCr = ___MOD._WzUtils:getInteger(base.accR, 0)
      entry.IMPr = ___MOD._WzUtils:getInteger(base.ignoreMobpdpR, 0)
      entry.IMDr = ___MOD._WzUtils:getInteger(base.ignoreMobDamR, 0)
      entry.CD = ___MOD._WzUtils:getInteger(base.criticalDamage, 0)
      entry.CDMin = ___MOD._WzUtils:getInteger(base.criticaldamageMin, 0)
      entry.CDMax = ___MOD._WzUtils:getInteger(base.criticaldamageMax, 0)
      entry.EXPr = ___MOD._WzUtils:getInteger(base.expR, 0)
      entry.Er = ___MOD._WzUtils:getInteger(base.er, 0)
      entry.Ar = ___MOD._WzUtils:getInteger(base.ar, 0)
      entry.OCr = ___MOD._WzUtils:getInteger(base.overChargeR, 0)
      entry.DCr = ___MOD._WzUtils:getInteger(base.disCountR, 0)
      entry.PDamr = ___MOD._WzUtils:getInteger(base.pdR, 0)
      entry.MDamr = ___MOD._WzUtils:getInteger(base.mdR, 0)
      entry.psdJump = ___MOD._WzUtils:getInteger(base.psdJump, 0)
      entry.psdSpeed = ___MOD._WzUtils:getInteger(base.psdSpeed, 0)
      entry.itemConsumeAmount = ___MOD._WzUtils:getInteger(base.itemConNo, 0)
      entry.bulletCount = ___MOD._WzUtils:getInteger(base.bulletCount, 0)
      entry.bulletConsume = ___MOD._WzUtils:getInteger(base.bulletConsume, 0)
      entry.itemConsume = ___MOD._WzUtils:getInteger(base.itemCon, 0)
      entry.moneyConsume = ___MOD._WzUtils:getInteger(base.moneyCon, 0)
      entry.optionalItemCost = ___MOD._WzUtils:getInteger(base.itemConsume, 0)
      entry.morph = ___MOD._WzUtils:getInteger(base.morph, 0)
      entry.action = ___MOD._WzUtils:getString(base.action, "")
      entry.range = ___MOD._WzUtils:getInteger(base.range, 0)
      if base.ball ~= nil then
        entry.ball = ___MOD._WzUtils:parseAnimation(base.ball)
      end
      if base.mob ~= nil then
        local mobIcon = ___MOD.MobSkillMob()
        mobIcon:parseData(base.mob)
        entry.mob = mobIcon
      end
      if base.mob0 ~= nil then
        local mobIcon0 = ___MOD.MobSkillMob()
        mobIcon0:parseData(base.mob0)
        entry.mob0 = mobIcon0
      end
      if base.hit ~= nil then
        entry.hit = {}
        if base.hit._type == nil then
          for key, value in ___MOD.pairs(base.hit) do
            local hitKey = ___MOD.tonumber(key)
            if hitKey ~= nil then
              entry.hit[hitKey + 1] = ___MOD._WzUtils:parseAnimation(value)
            end
          end
        else
          entry.hit[1] = ___MOD._WzUtils:parseAnimation(base.hit)
        end
      end
      local lt = ___MOD._WzUtils:getFastVector(base.lt, ___MOD.FastVector2.zero:Clone())
      local rb = ___MOD._WzUtils:getFastVector(base.rb, ___MOD.FastVector2.zero:Clone())
      if lt ~= ___MOD.FastVector2.zero:Clone() or rb ~= ___MOD.FastVector2.zero:Clone() then
        local ltPos = ___MOD.FastVector2(lt.x / 100, lt.y / 100)
        local rbPos = ___MOD.FastVector2(rb.x / 100, rb.y / 100)
        entry.lt = ltPos
        entry.rb = rbPos
      end
    end
  end
  return entryTable
end

function SkillManager.split_tail_number(self, str)
  local base, num = str:match("^(.-)(%d+)$")
  if not base then
    return str, nil
  end
  return base, ___MOD.tonumber(num)
end
