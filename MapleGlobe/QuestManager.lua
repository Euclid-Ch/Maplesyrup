

function QuestManager.checkQuest(self, playerEntity, questID, state)
  local check = true
  local checkData = self:getCheckByQuestID(questID)
  if ___MOD.isvalid(checkData) then
    local map = playerEntity.CurrentMapName
    local mapId = ___MOD.tonumber(map:match("_(.*)$")) or 0
    local player = playerEntity.Player
    local job = player.Job
    local level = player.Level
    local qc = playerEntity.QuestComponent
    local c
    if state == 0 then
      c = checkData.canStart
    elseif state == 1 or state == 2 then
      c = checkData.inProgress
    end
    if c ~= nil then
      for k, v in ___MOD.pairs(c) do
        if k == "job" then
          local find = false
          for _, j in ___MOD.pairs(v) do
            if j == job then
              find = true
            end
          end
          if not find then
            check = false
          end
        elseif k == "level" then
          if v > level then
            check = false
          end
        elseif k == "lvmin" then
          if v > level then
            check = false
          end
        elseif k == "lvmax" then
          if not ___MOD._WorldConstants.isTestWorld then
            local lvMax = ___MOD.tonumber(v)
            if lvMax ~= nil and level > lvMax + 20 then
              check = false
            end
          end
        elseif k == "premium" or k == "worldmax" or k == "worldmin" then
          check = false
        elseif k == "quest" then
          local qCheck = true
          for _, cquest in ___MOD.pairs(v) do
            if cquest.id ~= nil and not qc:isQuestStateMatched(cquest.id, self:normalizeQuestConditionState(cquest.state)) then
              qCheck = false
            end
          end
          if not qCheck then
            check = false
          end
        elseif k == "fieldEnter" then
          local find = false
          for _, f in ___MOD.pairs(v) do
            if f ~= nil and f ~= 0 and f ~= 999999999 and f == mapId then
              find = true
            end
          end
          if not find then
            check = false
          end
        elseif k == "mob" then
          local mobCheck = true
          for _, m in ___MOD.pairs(v) do
            local mobID = m.id
            local count = m.count
            if count > qc:getMobCount(questID, mobID) then
              mobCheck = false
            end
          end
          if not mobCheck then
            check = false
          end
        elseif k == "item" then
          local allCheck = true
          for _, i in ___MOD.pairs(v) do
            local have = self:getQuestOwnedItemCount(playerEntity, i.id)
            local need = i.count
            if need == 0 or need == nil then
              if have ~= 0 then
                allCheck = false
              end
            elseif need ~= nil and have < need then
              allCheck = false
            end
          end
          if not allCheck then
            check = false
          end
        elseif k == "infoex" then
          local infoNumber = c.infoNumber or questID
          local hasNamedVariable = false
          for _, ex in ___MOD.pairs(v) do
            if ___MOD.type(ex) == "table" and ex.exVariable ~= nil and ex.exVariable ~= "" then
              hasNamedVariable = true
              break
            end
          end
          local matched = false
          if hasNamedVariable then
            matched = true
            for _, ex in ___MOD.pairs(v) do
              local exVariable = ___MOD.type(ex) == "table" and ex.exVariable or "Ex"
              if qc:getQuestEx(infoNumber, exVariable) ~= self:unwrap(ex) then
                matched = false
                break
              end
            end
          else
            local questEx = qc:getQuestEx(infoNumber, "Ex")
            for _, ex in ___MOD.pairs(v) do
              if questEx == self:unwrap(ex) then
                matched = true
                break
              end
            end
          end
          if not matched then
            check = false
          end
        elseif k == "info" then
          local infoNumber = c.infoNumber or questID
          local questEx = qc:getQuestEx(infoNumber, "Ex")
          local matched = false
          for _, info in ___MOD.pairs(v) do
            if info == "" or questEx == info then
              matched = true
              break
            end
          end
          if not matched then
            check = false
          end
        elseif k == "subJobFlags" then
          local PSJF = 0
          if PSJF ~= v then
            check = false
          end
        elseif k == "buff" then
          local buffId = ___MOD.tonumber(v) or 0
          local hasBuff = ___MOD._ScriptLogic:hasBuffBySkillID(playerEntity, -buffId)
          if not hasBuff then
            check = false
          end
        elseif k == "skill" and not self:checkQuestSkillCondition(playerEntity, v) then
          check = false
        end
      end
    end
  end
  return check
end

function QuestManager.checkQuestSkillCondition(self, playerEntity, skillList)
  local skillComponent = playerEntity.SkillComponent
  if not ___MOD.isvalid(skillComponent) then
    return false
  end
  for _, skillData in ___MOD.pairs(skillList) do
    local skillID = ___MOD.tonumber(skillData.id) or 0
    local acquire = ___MOD.tonumber(skillData.acquire)
    local hasSkill = 0 < skillID and skillComponent:hasSkill(skillID)
    if acquire == 1 then
      if not hasSkill then
        return false
      end
    elseif (acquire == nil or acquire == 0 or acquire == -1) and hasSkill then
      return false
    end
  end
  return true
end

function QuestManager.copyLeafValues(self, t, parentActs, path)
  path = path or {}
  for k, v in ___MOD.pairs(t) do
    if k == "_type" then
    elseif ___MOD.type(v) == "table" then
      local unwrapped = ___MOD._WzUtils:unwrapValue(v)
      if unwrapped ~= nil and unwrapped ~= v then
        local ref = parentActs
        for i = 1, #path do
          local key = path[i]
          if ref[key] == nil then
            ref[key] = {}
          end
          ref = ref[key]
        end
        ref[k] = unwrapped
      else
        ___MOD.table.insert(path, k)
        self:copyLeafValues(v, parentActs, path)
        ___MOD.table.remove(path)
      end
    else
      local ref = parentActs
      for i = 1, #path do
        local key = path[i]
        if ref[key] == nil then
          ref[key] = {}
        end
        ref = ref[key]
      end
      ref[k] = v
    end
  end
end

function QuestManager.deepCache(self, node)
  local function recurse(src)
    local result = {}

    for k, v in ___MOD.pairs(src) do
      if k == "_type" then
      elseif ___MOD.type(v) == "table" then
        local hasOnlyValueAndType = true
        local count = 0
        for subKey, _ in ___MOD.pairs(v) do
          if subKey ~= "value" and subKey ~= "_type" then
            hasOnlyValueAndType = false
          end
          count = count + 1
        end
        local unwrapped = ___MOD._WzUtils:unwrapValue(v)
        if hasOnlyValueAndType and unwrapped ~= nil and count <= 2 then
          result[k] = unwrapped
        else
          result[k] = recurse(v)
        end
      else
        result[k] = v
      end
    end
    return result
  end

  return recurse(node)
end

function QuestManager.getActByQuestID(self, questID)
  return self.actList[questID]
end

function QuestManager.getAllQuestByNpcID(self, playerEntity, npcID)
  local canStart = {}
  local inProgress = {}
  local allowedArea51Quests = self.area51AllowedQuestIDs or {}
  local qc = playerEntity.QuestComponent
  if not ___MOD.isvalid(qc) then
    return
  end
  local sortedKeys = self.npcQuestIDsByNpcID[npcID] or {}
  for _, k in ___MOD.ipairs(sortedKeys) do
    local c = self.checkList[k]
    if ___MOD.isvalid(c) then
      local state = qc:getQuestState(k)
      local repeatableReady = state == 2 and self:isRepeatableQuestReady(playerEntity, k)
      local effectiveState = repeatableReady and 0 or state
      if effectiveState == 0 then
        if c.canStart ~= nil and c.canStart.npc == npcID and self:checkQuest(playerEntity, k, 0) then
          local questInfo = self:getQuestInfoByQuestID(k)
          if questInfo.area ~= 51 or allowedArea51Quests[questInfo.questID] then
            canStart[#canStart + 1] = {questInfo = questInfo, state = false}
          end
        end
      elseif effectiveState == 1 then
        if c.canStart ~= nil and c.canStart.npc == npcID then
          local questInfo = self:getQuestInfoByQuestID(k)
          canStart[#canStart + 1] = {questInfo = questInfo, state = true}
        end
        local cc = false
        if c.inProgress ~= nil and c.inProgress.npc ~= nil and c.inProgress.npc ~= 0 and c.inProgress.npc == npcID then
          cc = true
        end
        if (c.inProgress == nil or c.inProgress.npc == nil or c.inProgress.npc == 0) and c.canStart ~= nil and c.canStart.npc ~= nil and c.canStart.npc ~= 0 and c.canStart.npc == npcID then
          cc = true
        end
        if cc then
          local canComplete = self:checkQuest(playerEntity, k, 1)
          local questInfo = self:getQuestInfoByQuestID(k)
          inProgress[#inProgress + 1] = {questInfo = questInfo, state = canComplete}
        end
      end
    end
  end
  return canStart, inProgress
end

function QuestManager.getAllQuestInfo(self)
  local ret = {}
  local sortedKeys = self.sortedQuestIDs
  for _, k in ___MOD.ipairs(sortedKeys) do
    local questInfo = self.questInfo[k]
    if ___MOD.isvalid(questInfo) then
      local c = self.checkList[k]
      if ___MOD.isvalid(c) and c.canStart ~= nil then
        ret[#ret + 1] = questInfo
      end
    end
  end
  return ret
end

function QuestManager.getAutoAcceptQuestInfoList(self, playerEntity)
  local autoAcceptList = {}
  if not ___MOD.isvalid(playerEntity) then
    return autoAcceptList
  end
  local qc = playerEntity.QuestComponent
  if not ___MOD.isvalid(qc) then
    return autoAcceptList
  end
  local candidateQuestIDs = self.sortedAutoAcceptQuestIDs or {}
  if #candidateQuestIDs <= 0 then
    return autoAcceptList
  end
  local allowedArea51Quests = self.area51AllowedQuestIDs or {}
  for _, questID in ___MOD.ipairs(candidateQuestIDs) do
    local info = self.questInfo[questID]
    if info ~= nil then
      local blockedByArea = info.area == 51 and not allowedArea51Quests[questID]
      if not blockedByArea then
        local state = qc:getQuestState(questID)
        local repeatableReady = state == 2 and self:isRepeatableQuestReady(playerEntity, questID)
        local effectiveState = repeatableReady and 0 or state
        if effectiveState == 0 and self:checkQuest(playerEntity, questID, 0) then
          autoAcceptList[#autoAcceptList + 1] = {questInfo = info, state = 0}
        end
      end
    end
  end
  return autoAcceptList
end

function QuestManager.getAutoQuestInfoLists(self, playerEntity)
  local autoStartList = {}
  local autoCompleteList = {}
  if not ___MOD.isvalid(playerEntity) then
    return autoStartList, autoCompleteList
  end
  local qc = playerEntity.QuestComponent
  if not ___MOD.isvalid(qc) then
    return autoStartList, autoCompleteList
  end
  local allowedArea51Quests = self.area51AllowedQuestIDs or {}
  for questID, info in ___MOD.pairs(self.questInfo) do
    if info ~= nil then
      local blockedByArea = info.area == 51 and not allowedArea51Quests[questID]
      if not blockedByArea then
        local state = qc:getQuestState(questID)
        local repeatableReady = state == 2 and self:isRepeatableQuestReady(playerEntity, questID)
        local effectiveState = repeatableReady and 0 or state
        if info.autoStart and effectiveState == 0 and self:checkQuest(playerEntity, questID, 0) then
          autoStartList[#autoStartList + 1] = {questInfo = info, state = 0}
        end
        if info.autoComplete and effectiveState == 1 and self:checkQuest(playerEntity, questID, 1) then
          autoCompleteList[#autoCompleteList + 1] = {questInfo = info, state = 2}
        end
      end
    end
  end

  local function sortByQuestID(a, b)
    local aq = a.questInfo and a.questInfo.questID or 0
    local bq = b.questInfo and b.questInfo.questID or 0
    return aq < bq
  end

  ___MOD.table.sort(autoStartList, sortByQuestID)
  ___MOD.table.sort(autoCompleteList, sortByQuestID)
  return autoStartList, autoCompleteList
end

function QuestManager.getCheckByQuestID(self, questID)
  return self.checkList[questID]
end

function QuestManager.getContinuityQuest(self, questID)
  local questInfo = self:getQuestInfoByQuestID(questID)
  if questInfo == nil then
    return nil
  end
  local parent = questInfo.parent
  if parent == nil then
    return nil
  end
  local ret = {}
  for _, v in ___MOD.pairs(self:getAllQuestInfo()) do
    if v.parent == parent then
      ret[#ret + 1] = v
    end
  end
  return ret
end

function QuestManager.getNode(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached ~= nil then
    return cached
  end
  local node = self.cache
  local pos = 1
  while node do
    local s = find(path, "/", pos, true)
    local key
    if s then
      key = sub(path, pos, s - 1)
    else
      key = sub(path, pos)
    end
    node = node[key]
    if not node then
      cacheTbl[path] = nil
      return nil
    end
    if not s then
      cacheTbl[path] = node
      return node
    end
    pos = s + 1
  end
  return nil
end

function QuestManager.getQuestInfo(self, playerEntity, state)
  local player = playerEntity.Player
  if not ___MOD.isvalid(player) then
    return
  end
  local job = player.Job
  local level = player.Level
  local qc = playerEntity.QuestComponent
  if not ___MOD.isvalid(qc) then
    return
  end
  local ret = {}
  if state == 0 then
    local sortedKeys = self.sortedQuestIDs
    local map = playerEntity.CurrentMapName
    local mapId = ___MOD.tonumber(map:match("_(.*)$")) or 0
    for _, k in ___MOD.ipairs(sortedKeys) do
      local s = qc:getQuestState(k)
      if s == nil or s == 0 or s == 2 and self:isRepeatableQuestReady(playerEntity, k) then
        local questInfo = self.questInfo[k]
        if ___MOD.isvalid(questInfo) and questInfo.d0 ~= nil then
          local c = self.checkList[k]
          if ___MOD.isvalid(c) and c.canStart ~= nil then
            local check = true
            for ck, cv in ___MOD.pairs(c.canStart) do
              if ck == "job" then
                local find = false
                for _, j in ___MOD.pairs(cv) do
                  if j == job then
                    find = true
                  end
                end
                if not find then
                  check = false
                end
              elseif ck == "level" then
                if level < cv then
                  check = false
                end
              elseif ck == "lvmin" then
                if level < cv then
                  check = false
                end
              elseif ck == "lvmax" then
                if not ___MOD._WorldConstants.isTestWorld then
                  local lvMax = ___MOD.tonumber(cv)
                  if lvMax ~= nil and level > lvMax + 20 then
                    check = false
                  end
                end
              elseif ck == "premium" or ck == "worldmax" or ck == "worldmin" then
                check = false
              elseif ck == "quest" then
                local qCheck = true
                for _, cquest in ___MOD.pairs(cv) do
                  if cquest.id ~= nil and not qc:isQuestStateMatched(cquest.id, self:normalizeQuestConditionState(cquest.state)) then
                    qCheck = false
                  end
                end
                if not qCheck then
                  check = false
                end
              elseif ck == "fieldEnter" then
                local find = false
                for _, f in ___MOD.pairs(cv) do
                  if f ~= nil and f ~= 0 and f ~= 999999999 and f == mapId then
                    find = true
                  end
                end
                if not find then
                  check = false
                end
              elseif ck == "item" then
                local allCheck = true
                for _, i in ___MOD.pairs(cv) do
                  local have = self:getQuestOwnedItemCount(playerEntity, i.id)
                  local need = i.count
                  if need == 0 or need == nil then
                    if have ~= 0 then
                      allCheck = false
                    end
                  elseif need ~= nil and have < need then
                    allCheck = false
                  end
                end
                if not allCheck then
                  check = false
                end
              elseif ck == "infoex" then
                local infoNumber = c.canStart.infoNumber or k
                local questEx = qc:getQuestEx(infoNumber, "Ex")
                local matched = false
                for _, ex in ___MOD.pairs(cv) do
                  if questEx == self:unwrap(ex) then
                    matched = true
                    break
                  end
                end
                if not matched then
                  check = false
                end
              elseif ck == "info" then
                local infoNumber = c.canStart.infoNumber or k
                local questEx = qc:getQuestEx(infoNumber, "Ex")
                local matched = false
                for _, info in ___MOD.pairs(cv) do
                  if info == "" or questEx == info then
                    matched = true
                    break
                  end
                end
                if not matched then
                  check = false
                end
              elseif ck == "subJobFlags" then
                local PSJF = 0
                if PSJF ~= cv then
                  check = false
                end
              elseif ck == "buff" then
                local buffId = ___MOD.tonumber(cv) or 0
                local hasBuff = ___MOD._ScriptLogic:hasBuffBySkillID(playerEntity, -buffId)
                if not hasBuff then
                  check = false
                end
              elseif ck == "skill" and not self:checkQuestSkillCondition(playerEntity, cv) then
                check = false
              end
              if questInfo.area == 51 then
                check = false
              end
            end
            if check then
              ret[#ret + 1] = questInfo
            end
          end
        end
      end
    end
  else
    local sortedKeys = {}
    local questData = qc:getQuestDataByState(state)
    for k, _ in ___MOD.pairs(questData) do
      sortedKeys[#sortedKeys + 1] = ___MOD.tonumber(k)
    end
    ___MOD.table.sort(sortedKeys, function(a, b)
      return (a or 0) < (b or 0)
    end)
    for _, k in ___MOD.ipairs(sortedKeys) do
      local questInfo = self.questInfo[k]
      if ___MOD.isvalid(questInfo) then
        ret[#ret + 1] = questInfo
      end
    end
    return ret
  end
  return ret
end

function QuestManager.getQuestInfoByNpcID(self, player, npcID)
  local canStart, inProgress = ___MOD._QuestManager:getAllQuestByNpcID(player, npcID)
  local canCompleteList = {}
  local canStartList = {}
  local inProgressList = {}
  local completeMap = {}
  local inProgMap = {}
  if 0 < #inProgress then
    for _, v in ___MOD.ipairs(inProgress) do
      if v.state then
        canCompleteList[#canCompleteList + 1] = v
        completeMap[v.questInfo.questID] = true
      end
    end
    for _, v in ___MOD.ipairs(inProgress) do
      local qid = v.questInfo.questID
      if not v.state and not completeMap[qid] and not inProgMap[qid] then
        inProgressList[#inProgressList + 1] = v
        inProgMap[qid] = true
      end
    end
  end
  if 0 < #canStart then
    for _, v in ___MOD.ipairs(canStart) do
      if not v.state then
        canStartList[#canStartList + 1] = v
      end
    end
    for _, v in ___MOD.ipairs(canStart) do
      local qid = v.questInfo.questID
      if v.state and not completeMap[qid] and not inProgMap[qid] then
        inProgressList[#inProgressList + 1] = v
        inProgMap[qid] = true
      end
    end
  end
  return canStartList, inProgressList, canCompleteList
end

function QuestManager.getQuestInfoByQuestID(self, questID)
  return self.questInfo[questID]
end

function QuestManager.getQuestItemInfo(self, itemID)
  return self.questItemInfo[itemID]
end

function QuestManager.getQuestItemMaxCount(self, questID, itemID)
  local checkData = self.checkList[questID]
  if not ___MOD.isvalid(checkData) then
    return nil
  end
  local inProgress = checkData.inProgress
  if not ___MOD.isvalid(inProgress) then
    return nil
  end
  local items = inProgress.item
  if not ___MOD.isvalid(items) then
    return nil
  end
  for _, i in ___MOD.pairs(items) do
    if i.id == itemID then
      return i.count
    end
  end
  return nil
end

function QuestManager.getQuestOwnedItemCount(self, playerEntity, itemId)
  local inventoryCount = 0
  if playerEntity ~= nil and playerEntity.CInventoryComponent ~= nil then
    inventoryCount = playerEntity.CInventoryComponent:getItemCount(itemId)
  end
  if 0 < itemId and itemId // 1000000 == 1 then
    local equipment = playerEntity ~= nil and playerEntity.EquipmentComponent or nil
    if equipment ~= nil and equipment:hasItem(itemId) == true then
      inventoryCount = inventoryCount + 1
    end
  end
  return inventoryCount
end

function QuestManager.getSayByQuestID(self, questID)
  return self.sayList[questID]
end

function QuestManager.isQuest2337CompletionMigrationTarget(self, playerId)
  if ___MOD._UtilLogic:IsNilorEmptyString(playerId) then
    return false
  end
  return self.quest2337CompletionMigrationPlayerIds[playerId] == true
end

function QuestManager.isRepeatableQuestReady(self, playerEntity, questID)
  local checkData = self.checkList[questID]
  if not ___MOD.isvalid(checkData) then
    return false
  end
  local canStart = checkData.canStart
  if not ___MOD.isvalid(canStart) or canStart.interval == nil then
    return false
  end
  local intervalMin = ___MOD.tonumber(canStart.interval) or 0
  local qc = playerEntity.QuestComponent
  if not ___MOD.isvalid(qc) then
    return false
  end
  if qc:getQuestState(questID) ~= 2 then
    return false
  end
  if intervalMin <= 0 then
    return true
  end
  local lastTime = 0
  local questData = qc.questData
  if questData ~= nil then
    local q = questData[questID]
    if q ~= nil and q.state ~= nil and q.state.time ~= nil then
      lastTime = q.state.time
    end
  end
  local now = ___MOD.DateTime.UtcNow.Elapsed
  return now - lastTime >= intervalMin * 60 * 1000
end

function QuestManager.loadQuest(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable("Quest_wz")
  local count = ds:GetRowCount()
  local getCell = ds.GetCell
  local cache = self.cache
  local count1 = 0
  local loadkeys = {QuestData = true}
  for i = 1, count do
    local key = getCell(ds, i, 1)
    if loadkeys[key] then
      local json = getCell(ds, i, 2)
      local data = ___MOD._WzUtils:parseWzData(json)
      if ___MOD.type(data) == "table" then
        if key == "QuestData" then
          self:removeExcludedQuestData(data)
        end
        cache[key] = data
        count1 = count1 + 1
      end
    end
  end
  self:parseQuestData()
  ___MOD.log(___MOD.string.format("Loaded Quest.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
  ___MOD._DataLoadManager:compeletedLoad()
end

function QuestManager.migrateQuest2337CompletionTime(self, questComponent, playerId)
  if questComponent == nil or not self:isQuest2337CompletionMigrationTarget(playerId) then
    return false
  end
  local questID = 2337
  local questData = questComponent.questData
  local quest = questData and questData[questID] or nil
  if quest == nil or quest.state == nil then
    return false
  end
  if quest.state.time ~= nil then
    return false
  end
  local state = quest.state.state
  if state ~= ___MOD._QuestStateType.inProgress and state ~= ___MOD._QuestStateType.complete then
    return false
  end
  quest.state.time = 63912727568051
  return true
end

function QuestManager.normalizeQuestConditionState(self, state)
  local rawState = ___MOD._WzUtils:unwrapValue(state)
  local requiredState = ___MOD.tonumber(rawState)
  if requiredState == nil then
    return ___MOD._QuestStateType.canStart
  end
  return requiredState
end

function QuestManager.parseQuestData(self)
  local questData = ___MOD._QuestManager:getNode("QuestData")
  if not questData then
    return
  end
  local questInfos = {}
  local actList = {}
  local sayList = {}
  local checkList = {}
  local autoAcceptQuestIDs = {}
  local npcQuestIDsByNpcID = {}
  local sortedIds = {}
  for k, _ in ___MOD.pairs(questData) do
    local strKey = ___MOD.tostring(k)
    local numPart = strKey:gsub("%.img$", "")
    local id = ___MOD.tonumber(numPart)
    if id ~= nil and self.excludedQuestIDs[id] ~= true then
      sortedIds[#sortedIds + 1] = id
    end
  end
  ___MOD.table.sort(sortedIds, function(a, b)
    return (a or 0) < (b or 0)
  end)
  for _, id in ___MOD.ipairs(sortedIds) do
    local v = questData[___MOD.tostring(id) .. ".img"]
    if v ~= nil then
      local questInfoNode = v.QuestInfo
      if ___MOD.isvalid(questInfoNode) then
        local getString = ___MOD._WzUtils.getString
        local getInt = ___MOD._WzUtils.getInteger
        local getBool = ___MOD._WzUtils.getBoolean
        local name = getString(___MOD._WzUtils, questInfoNode.name, "")
        local parent = getString(___MOD._WzUtils, questInfoNode.parent, nil)
        local typeStr = getString(___MOD._WzUtils, questInfoNode.type, "")
        local d0 = getString(___MOD._WzUtils, questInfoNode["0"], nil)
        local d1 = getString(___MOD._WzUtils, questInfoNode["1"], nil)
        local d2 = getString(___MOD._WzUtils, questInfoNode["2"], nil)
        local area = getInt(___MOD._WzUtils, questInfoNode.area, 0)
        local demandSummary = getString(___MOD._WzUtils, questInfoNode.demandSummary, "")
        local rewardSummary = getString(___MOD._WzUtils, questInfoNode.rewardSummary, "")
        local order = getInt(___MOD._WzUtils, questInfoNode.order, 0)
        local autoStart = getBool(___MOD._WzUtils, questInfoNode.autoStart, false)
        local autoComplete = getBool(___MOD._WzUtils, questInfoNode.autoComplete, false)
        local autoAccept = getBool(___MOD._WzUtils, questInfoNode.autoAccept, false)
        local questInfoStruct = ___MOD.QuestInfo()
        questInfoStruct.name = name
        questInfoStruct.parent = parent
        questInfoStruct.type = typeStr
        questInfoStruct.d0 = d0
        questInfoStruct.d1 = d1
        questInfoStruct.d2 = d2
        questInfoStruct.area = area
        questInfoStruct.demandSummary = demandSummary
        questInfoStruct.rewardSummary = rewardSummary
        questInfoStruct.order = order
        questInfoStruct.autoStart = autoStart
        questInfoStruct.autoComplete = autoComplete
        questInfoStruct.autoAccept = autoAccept
        questInfoStruct.questID = id
        questInfos[id] = questInfoStruct
        if autoAccept then
          autoAcceptQuestIDs[#autoAcceptQuestIDs + 1] = id
        end
      end
      local actNode = v.Act
      local acts = {}
      if ___MOD.isvalid(actNode) then
        local canStart = actNode["0"]
        local inProgress = actNode["1"]
        if ___MOD.isvalid(canStart) and canStart._type ~= "unknown" then
          acts.canStart = self:deepCache(canStart)
        end
        if ___MOD.isvalid(inProgress) and inProgress._type ~= "unknown" then
          acts.inProgress = self:deepCache(inProgress)
        end
      end
      local sayNode = v.Say
      local says = {}
      if ___MOD.isvalid(sayNode) then
        local canStartSay = sayNode["0"]
        local inProgressSay = sayNode["1"]
        if ___MOD.isvalid(canStartSay) then
          says.canStart = {}
          for i = 0, 100 do
            local dn = ___MOD._WzUtils:getString(canStartSay[___MOD.string.format("%d", i)], nil)
            if dn ~= nil and dn ~= "" then
              says.canStart[i] = dn
            else
              says.canStart.count = i
              break
            end
          end
          says.canStart.yes = {}
          local yes = canStartSay.yes
          if ___MOD.isvalid(yes) then
            for i = 0, 100 do
              local dn = ___MOD._WzUtils:getString(yes[___MOD.string.format("%d", i)], nil)
              if dn ~= nil and dn ~= "" then
                says.canStart.yes[i] = dn
              else
                says.canStart.yes.count = i
                break
              end
            end
          end
          says.canStart.no = {}
          local no = canStartSay.no
          if ___MOD.isvalid(no) then
            for i = 0, 100 do
              local dn = ___MOD._WzUtils:getString(no[___MOD.string.format("%d", i)], nil)
              if dn ~= nil and dn ~= "" then
                says.canStart.no[i] = dn
              else
                says.canStart.no.count = i
                break
              end
            end
          end
          says.canStart.lost = {}
          local lost = canStartSay.lost
          if ___MOD.isvalid(lost) then
            for i = 0, 100 do
              local dn = ___MOD._WzUtils:getString(lost[___MOD.string.format("%d", i)], nil)
              if dn ~= nil and dn ~= "" then
                says.canStart.lost[i] = dn
              else
                says.canStart.lost.count = i
                break
              end
            end
          end
          says.canStart.stop = {}
          local stop = canStartSay.stop
          if ___MOD.isvalid(stop) and stop._type ~= "unknown" then
            for key, tbl in ___MOD.pairs(stop) do
              if ___MOD.type(tbl) == "table" then
                says.canStart.stop[key] = {}
                for innerKey, value in ___MOD.pairs(tbl) do
                  if innerKey ~= "_type" then
                    says.canStart.stop[key][innerKey] = self:unwrap(value)
                  end
                end
              end
            end
          end
          says.canStart.ask = ___MOD._WzUtils:getInteger(canStartSay.ask, nil)
          says.canStart.playerAvatar = ___MOD._WzUtils:getInteger(canStartSay.playerAvatar, 0) ~= 0
        end
        if ___MOD.isvalid(inProgressSay) then
          says.inProgress = {}
          for i = 0, 100 do
            local dn = ___MOD._WzUtils:getString(inProgressSay[___MOD.string.format("%d", i)], nil)
            if dn ~= nil and dn ~= "" then
              says.inProgress[i] = dn
            else
              says.inProgress.count = i
              break
            end
          end
          says.inProgress.yes = {}
          local yes = inProgressSay.yes
          if ___MOD.isvalid(yes) then
            for i = 0, 100 do
              local dn = ___MOD._WzUtils:getString(yes[___MOD.string.format("%d", i)], nil)
              if dn ~= nil and dn ~= "" then
                says.inProgress.yes[i] = dn
              else
                says.inProgress.yes.count = i
                break
              end
            end
          end
          says.inProgress.no = {}
          local no = inProgressSay.no
          if ___MOD.isvalid(no) then
            for i = 0, 100 do
              local dn = ___MOD._WzUtils:getString(no[___MOD.string.format("%d", i)], nil)
              if dn ~= nil and dn ~= "" then
                says.inProgress.no[i] = dn
              else
                says.inProgress.no.count = i
                break
              end
            end
          end
          says.inProgress.lost = {}
          local lost = inProgressSay.lost
          if ___MOD.isvalid(lost) then
            for i = 0, 100 do
              local dn = ___MOD._WzUtils:getString(lost[___MOD.string.format("%d", i)], nil)
              if dn ~= nil and dn ~= "" then
                says.inProgress.lost[i] = dn
              else
                says.inProgress.lost.count = i
                break
              end
            end
          end
          says.inProgress.stop = {}
          local stop = inProgressSay.stop
          if ___MOD.isvalid(stop) and stop._type ~= "unknown" then
            for key, tbl in ___MOD.pairs(stop) do
              if ___MOD.type(tbl) == "table" then
                says.inProgress.stop[key] = {}
                says.inProgress.stop[key].answer = ___MOD._WzUtils:getInteger(stop.answer, nil)
                for innerKey, value in ___MOD.pairs(tbl) do
                  if innerKey ~= "_type" then
                    says.inProgress.stop[key][innerKey] = self:unwrap(value)
                  end
                end
              end
            end
          end
          says.inProgress.ask = ___MOD._WzUtils:getInteger(inProgressSay.ask, nil)
          says.inProgress.playerAvatar = ___MOD._WzUtils:getInteger(inProgressSay.playerAvatar, 0) ~= 0
        end
      end
      local checkNode = v.Check
      local checks = {}
      if ___MOD.isvalid(checkNode) then
        local canStartCheck = checkNode["0"]
        local inProgressCheck = checkNode["1"]
        if ___MOD.isvalid(canStartCheck) then
          checks.canStart = self:deepCache(canStartCheck)
        end
        if ___MOD.isvalid(inProgressCheck) then
          checks.inProgress = self:deepCache(inProgressCheck)
        end
      end
      actList[id] = acts
      sayList[id] = says
      checkList[id] = checks
    end
  end

  local function appendNpcQuestID(npcID, questID)
    if npcID == nil or npcID == 0 then
      return
    end
    local questIDs = npcQuestIDsByNpcID[npcID]
    if questIDs == nil then
      questIDs = {}
      npcQuestIDsByNpcID[npcID] = questIDs
    end
    if questIDs[questID] == true then
      return
    end
    questIDs[#questIDs + 1] = questID
    questIDs[questID] = true
  end

  local questItemInfo = {}
  for questId, checks in ___MOD.pairs(checkList) do
    local inProgress = checks and checks.inProgress
    local items = inProgress and inProgress.item
    local canStart = checks and checks.canStart
    if canStart ~= nil then
      appendNpcQuestID(canStart.npc, questId)
    end
    if inProgress ~= nil then
      appendNpcQuestID(inProgress.npc, questId)
    end
    if ___MOD.isvalid(items) then
      for _, item in ___MOD.pairs(items) do
        if item.id ~= nil and item.count ~= nil and questItemInfo[item.id] == nil then
          questItemInfo[item.id] = {
            questId = questId,
            count = item.count
          }
        end
      end
    end
  end
  for npcID, questIDs in ___MOD.pairs(npcQuestIDsByNpcID) do
    local orderedQuestIDs = {}
    for _, questID in ___MOD.ipairs(questIDs) do
      orderedQuestIDs[#orderedQuestIDs + 1] = questID
    end
    ___MOD.table.sort(orderedQuestIDs, function(a, b)
      return (a or 0) < (b or 0)
    end)
    npcQuestIDsByNpcID[npcID] = orderedQuestIDs
  end
  self.questInfo = questInfos
  self.actList = actList
  self.sayList = sayList
  self.checkList = checkList
  self.questItemInfo = questItemInfo
  self.npcQuestIDsByNpcID = npcQuestIDsByNpcID
  self.sortedQuestIDs = sortedIds
  local sortedCheckIds = {}
  for id, _ in ___MOD.pairs(checkList) do
    sortedCheckIds[#sortedCheckIds + 1] = id
  end
  ___MOD.table.sort(sortedCheckIds, function(a, b)
    return (a or 0) < (b or 0)
  end)
  self.sortedCheckQuestIDs = sortedCheckIds
  self.sortedAutoAcceptQuestIDs = autoAcceptQuestIDs
end

function QuestManager.removeExcludedQuestData(self, questData)
  for questID, _ in ___MOD.pairs(self.excludedQuestIDs) do
    questData[___MOD.tostring(questID) .. ".img"] = nil
  end
end

function QuestManager.tryAutoAcceptQuest(self, playerEntity, questID)

end

function QuestManager.tryAutoAcceptQuests(self, playerEntity)

end

function QuestManager.unwrap(self, v)
  return ___MOD._WzUtils:unwrapValue(v)
end
