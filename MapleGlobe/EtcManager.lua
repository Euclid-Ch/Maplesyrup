

function EtcManager.getItemMakeUIInfo(self, user)
  local player = user.Player
  local jobID = player.Job
  local level = player.Level
  local jobGroup = jobID % 1000 // 100
  local jobKey = ___MOD.math.floor(2 ^ (jobGroup - 1))
  local sortedCategory = {}
  local makableInfo = {}
  self:getMakableItemList(0, user, makableInfo, sortedCategory)
  self:getMakableItemList(jobKey, user, makableInfo, sortedCategory)
  for category, itemList in ___MOD.pairs(makableInfo) do
    if category == 425 then
      ___MOD.table.sort(itemList, function(a, b)
        local aLast = a.itemID % 100
        local bLast = b.itemID % 100
        if aLast ~= bLast then
          return aLast < bLast
        end
        local aMid = a.itemID // 100 % 100
        local bMid = b.itemID // 100 % 100
        return aMid < bMid
      end)
    else
      ___MOD.table.sort(itemList, function(a, b)
        return a.itemID < b.itemID
      end)
    end
  end
  local categoryKeys = ___MOD.table.keys(makableInfo)
  local categoryPriority = {
    [425] = 1,
    [200] = 2,
    [400] = 3
  }
  ___MOD.table.sort(categoryKeys, function(a, b)
    local aPriority = categoryPriority[a] or 999999
    local bPriority = categoryPriority[b] or 999999
    if aPriority ~= bPriority then
      return aPriority < bPriority
    end
    return a < b
  end)
  for _, category in ___MOD.ipairs(categoryKeys) do
    if category ~= 425 then
      sortedCategory[#sortedCategory + 1] = {
        param = category,
        name = ___MOD._EquipManager:getCategoryKoName(category)
      }
    end
  end
  return makableInfo, sortedCategory
end

function EtcManager.getMakableItemList(self, jobGroup, user, makableInfo, sortedCategory)
  local player = user.Player
  local makerSkillID = ___MOD._SkillManager:get_novice_skill_as_race(___MOD._SkillBook.Maker_000_1007, user.Player.Job)
  local makerSLV = user.SkillComponent:getSkillLevel(makerSkillID)
  local inventory = user.CInventoryComponent
  local equipment = user.EquipmentComponent
  local quest = user.QuestComponent
  local list = self.itemMakeFromJob[jobGroup]
  if not list then
    return
  end
  for itemID, itemInfo in ___MOD.pairs(list) do
    if (not (itemInfo.reqLevel > 0) or not (player.Level < itemInfo.reqLevel)) and (not (0 < itemInfo.reqSkillLevel) or not (makerSLV < itemInfo.reqSkillLevel)) and (not (0 < itemInfo.reqItem) or not (0 >= inventory:getItemCount(itemInfo.reqItem))) and (not (0 < itemInfo.reqEquip) or equipment:hasItem(itemInfo.reqEquip)) and (not (0 < itemInfo.reqQuest) or quest:getQuestState(itemInfo.reqQuest) == itemInfo.reqQuestState) then
      local category = itemID // 10000
      local itemType = category // 100
      if itemType ~= 1 then
        if itemType == 2 then
          category = 200
        elseif itemType == 4 and category ~= 425 then
          category = 400
        end
      end
      local outCategory = makableInfo[category]
      if outCategory == nil then
        makableInfo[category] = {}
        outCategory = makableInfo[category]
      end
      outCategory[#outCategory + 1] = itemInfo
    end
  end
end

function EtcManager.getNode(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.cache
  local pos = 1
  while node do
    local s, e = find(path, "/", pos, true)
    local key = s and sub(path, pos, s - 1) or sub(path, pos)
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
end

function EtcManager.getScriptInfo(self, scriptName)
  return self.scriptInfo[scriptName]
end

function EtcManager.getSwindleWarning(self, input)
  local swindleData = self.swindle
  local maxIdx = self._T.swindleMaxIdx
  local matchedType
  for typeIdx = maxIdx, 0, -1 do
    local group = swindleData[typeIdx]
    if group then
      for i = 1, #group.word do
        local word = group.word[i]
        if not ___MOD._UtilLogic:IsNilorEmptyString(word) and ___MOD._CruseFilter:searchSubstring(input, word) then
          matchedType = typeIdx
          break
        end
      end
    end
    if matchedType then
      break
    end
  end
  if not matchedType then
    return nil
  end
  local cur = ___MOD._UtilLogic.ElapsedSeconds
  local lastWarn = self._T.lastWarn
  if cur - lastWarn < 60 then
    return nil
  end
  local group = swindleData[matchedType]
  if not group or 0 >= #group.warn then
    return nil
  end
  local idx = ___MOD._GlobalRand32:randomIntegerRange(1, #group.warn)
  local warnMsg = group.warn[idx]
  if ___MOD._UtilLogic:IsNilorEmptyString(warnMsg) then
    return nil
  end
  self._T.lastWarn = cur
  return warnMsg
end

function EtcManager.getTip(self, job, level)
  local cur = ___MOD._UtilLogic.ElapsedSeconds
  local path
  local tips = self.tipsInfo
  for i = 1, #tips do
    local tip = tips[i]
    if level >= tip.levelMin and level <= tip.levelMax and (tip.job == 0 or 1 << job - 1 & tip.job ~= 0) and cur - self._T.lastTip >= tip.interval then
      self._T.lastTip = cur
      if ___MOD._GlobalRand32:randomIntegerRange(0, 99) >= tip.all then
        path = ___MOD.string.format("Tips.img/%s", tip.tip)
        break
      end
      path = "Tips.img/all"
      break
    end
  end
  if not path then
    return nil
  end
  local entry = self:getNode(path)
  if not entry or ___MOD.type(entry) ~= "table" then
    return nil
  end
  local count = 0
  if self.tipsPropCount[path] then
    count = self.tipsPropCount[path]
  else
    for _, _ in ___MOD.pairs(entry) do
      count = count + 1
    end
    self.tipsPropCount[path] = count
  end
  if count <= 0 then
    return nil
  end
  local idx = ___MOD._GlobalRand32:randomIntegerRange(1, count) - 1
  local tipmsg = entry[___MOD.tostring(idx)]
  if tipmsg then
    return ___MOD._WzUtils:getString(tipmsg, nil)
  end
  return nil
end

function EtcManager.loadEtc(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable("Etc_wz")
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  local loadkeys = {
    ["MakeCharInfo.img"] = true,
    ["ScriptInfo.img"] = true,
    ["ItemMake.img"] = true
  }
  if self:IsClient() then
    loadkeys["Tips.img"] = true
    loadkeys["Swindle.img"] = true
  end
  for i = 1, count do
    local key = get(ds, i, 1)
    if loadkeys[key] then
      local data = ___MOD._WzUtils:parseWzData(get(ds, i, 2))
      if ___MOD.type(data) == "table" then
        self.cache[key] = data
        count1 = count1 + 1
      end
    end
  end
  self:parseMakeCharInfo()
  self:parseScriptInfo()
  self:parseItemMake()
  if self:IsClient() then
    self:parseTipsInfo()
    self:parseSwindle()
  end
  ___MOD.log(___MOD.string.format("Loaded Etc.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
  ___MOD._DataLoadManager:compeletedLoad()
end

function EtcManager.parseItemMake(self)
  local make = self:getNode("ItemMake.img")
  local itemJobCache = self.itemMakeFromJob
  local itemIDCache = self.itemMakeFromItemID
  local categoryCache = self.itemMakeCategory
  for jobGroupStr, flagNode in ___MOD.pairs(make) do
    local jobGroup = ___MOD.tonumber(jobGroupStr)
    if jobGroup then
      if not itemJobCache[jobGroup] then
        itemJobCache[jobGroup] = {}
      end
      for itemIDStr, itemInfo in ___MOD.pairs(flagNode) do
        local itemID = ___MOD.tonumber(itemIDStr)
        if itemID then
          local makerItem = ___MOD.MakerItem()
          makerItem.flag = jobGroup
          makerItem.itemID = itemID
          makerItem.reqLevel = ___MOD._WzUtils:getInteger(itemInfo.reqLevel, 0)
          makerItem.reqSkillLevel = ___MOD._WzUtils:getInteger(itemInfo.reqSkillLevel, 0)
          makerItem.reqItem = ___MOD._WzUtils:getInteger(itemInfo.reqItem, 0)
          makerItem.reqEquip = ___MOD._WzUtils:getInteger(itemInfo.reqEquip, 0)
          makerItem.itemNum = ___MOD._WzUtils:getInteger(itemInfo.itemNum, 0)
          makerItem.tuc = ___MOD._WzUtils:getInteger(itemInfo.tuc, 0)
          makerItem.catalyst = ___MOD._WzUtils:getInteger(itemInfo.catalyst, 0)
          makerItem.meso = ___MOD._WzUtils:getInteger(itemInfo.meso, 0)
          local reqQuestNode = itemInfo.reqQuest
          if reqQuestNode then
            for questID, entry in ___MOD.pairs(reqQuestNode) do
              local qid = ___MOD.tonumber(questID)
              if qid then
                local state = ___MOD._WzUtils:getInteger(entry, 0)
                if state == 2 then
                  state = ___MOD._QuestStateType.complete
                elseif state == 3 then
                  state = ___MOD._QuestStateType.inProgress
                end
                makerItem.reqQuest = qid
                makerItem.reqQuestState = state
              end
            end
          end
          local rRewardNode = itemInfo.randomReward
          if rRewardNode then
            for nodeIdx, rRewardInfo in ___MOD.pairs(rRewardNode) do
              local idx = ___MOD.tonumber(nodeIdx)
              if idx then
                idx = idx + 1
                local item = ___MOD._WzUtils:getInteger(rRewardInfo.item, 0)
                local itemNum = ___MOD._WzUtils:getInteger(rRewardInfo.itemNum, 0)
                local prob = ___MOD._WzUtils:getInteger(rRewardInfo.prob, 0)
                makerItem:insertRandomReward(idx, item, itemNum, prob)
              end
            end
          end
          local recipeNode = itemInfo.recipe
          if recipeNode then
            for nodieIdx, recipeInfo in ___MOD.pairs(recipeNode) do
              local idx = ___MOD.tonumber(nodieIdx)
              if idx then
                idx = idx + 1
                local item = ___MOD._WzUtils:getInteger(recipeInfo.item, 0)
                local count = ___MOD._WzUtils:getInteger(recipeInfo.count, 0)
                makerItem:insertRecipe(idx, item, count)
              end
            end
          end
          itemJobCache[jobGroup][itemID] = makerItem
          itemIDCache[itemID] = makerItem
        end
      end
    end
  end
end

function EtcManager.parseMakeCharInfo(self)
  local charInfo = ___MOD._EtcManager:getNode("MakeCharInfo.img")
  for k, v in ___MOD.pairs(charInfo) do
    self.makeCharInfo[k] = {}
    for parts, v in ___MOD.pairs(v) do
      local type = ___MOD.tonumber(parts)
      if type then
        type = type + 1
        self.makeCharInfo[k][type] = {}
        for i, id in ___MOD.pairs(v) do
          local index = ___MOD.tonumber(i)
          if index then
            index = index + 1
            self.makeCharInfo[k][type][index] = ___MOD._WzUtils:getInteger(id, 0)
          end
        end
      end
    end
  end
  self._T.lastTip = 0
end

function EtcManager.parseScriptInfo(self)
  local scriptInfo = ___MOD._EtcManager:getNode("ScriptInfo.img")
  for k, v in ___MOD.pairs(scriptInfo) do
    self.scriptInfo[k] = ___MOD._WzUtils:getString(v, "")
  end
end

function EtcManager.parseSwindle(self)
  local swindle = ___MOD._EtcManager:getNode("Swindle.img")
  local alSwindle = self.swindle
  for i = 1, 100 do
    local entry = swindle[___MOD.tostring(i - 1)]
    if not entry then
      break
    end
    local swindleEntry = ___MOD.Swindle()
    for j = 1, 100 do
      local word = entry.word[___MOD.tostring(j - 1)]
      if not word then
        break
      end
      swindleEntry.word[j] = word
    end
    for j = 1, 100 do
      local warn = entry.warn[___MOD.tostring(j - 1)]
      if not warn then
        break
      end
      swindleEntry.warn[j] = warn
    end
    alSwindle[i] = swindleEntry
  end
  self._T.swindleMaxIdx = #alSwindle
  self._T.lastWarn = 0
end

function EtcManager.parseTipsInfo(self)
  local tips = ___MOD._EtcManager:getNode("Tips.img")
  local cache = self.tipsInfo
  for i, node in ___MOD.pairs(tips.info) do
    local idx = ___MOD.tonumber(i)
    if idx then
      local tipsInfo = ___MOD.TipsInfo()
      tipsInfo.levelMin = ___MOD._WzUtils:getInteger(node.levelMin, 0)
      tipsInfo.levelMax = ___MOD._WzUtils:getInteger(node.levelMax, 0)
      tipsInfo.interval = ___MOD._WzUtils:getInteger(node.interval, 0) / 1000
      tipsInfo.all = ___MOD._WzUtils:getInteger(node.all, 0)
      tipsInfo.tip = ___MOD._WzUtils:getString(node.tip, "")
      tipsInfo.job = ___MOD._WzUtils:getInteger(node.job, 0)
      cache[idx + 1] = tipsInfo
    end
  end
end
