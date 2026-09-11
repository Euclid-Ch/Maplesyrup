

function WorldMapManager.activateSearchInputField(self)
  if self.searchInputField == nil then
    return
  end
  local input = self.searchInputField.TextInputComponent
  if input ~= nil then
    input:ActivateInputField()
    return
  end
  local guiInput = self.searchInputField.TextGUIRendererInputComponent
  if guiInput ~= nil then
    guiInput:ActivateInputField()
    return
  end
end

function WorldMapManager.appendMobDropItems(self, lines, mobId, prefix)
  local items = self:getRewardItemNames(mobId)
  for i = 1, #items do
    local item = items[i]
    lines[#lines + 1] = {
      type = "item",
      text = prefix .. item.name,
      itemId = item.id
    }
  end
end

function WorldMapManager.appendMonsterLines(self, lines, mobList, mapId)
  local expanded = self.expandedMonstersByMap[mapId]
  if expanded == nil then
    expanded = {}
    self.expandedMonstersByMap[mapId] = expanded
  end
  for i = 1, #mobList do
    local m = mobList[i]
    local rewardSet = self.rewardItemsByMob[m.id]
    if rewardSet ~= nil and ___MOD.next(rewardSet) ~= nil then
      local isExpanded = expanded[m.id] == true
      lines[#lines + 1] = {
        type = "monster",
        id = m.id,
        text = self:getMobDisplayText(m.id)
      }
      if isExpanded then
        self:appendMobDropItems(lines, m.id, "- ")
      end
    end
  end
end

function WorldMapManager.buildNameList(self, ids, type)
  local list = {}
  local localPlayer = type == "npc" and ___MOD._UserService.LocalPlayer or nil
  local questComponent = ___MOD.isvalid(localPlayer) and localPlayer.QuestComponent or nil
  for i = 1, #ids do
    local id = ids[i]
    local name = ""
    if type == "npc" then
      if not (not ___MOD._NpcManager:isQuestConditionNpc(id) or ___MOD._NpcManager:isNpcVisibleForQuest(id, questComponent)) then
        goto lbl_74
      end
      name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Npc.img/%d/name", id))
    else
      name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Mob.img/%d/name", id))
    end
    if ___MOD._UtilLogic:IsNilorEmptyString(name) then
      name = ___MOD.tostring(id)
    end
    list[#list + 1] = {id = id, name = name}
    ::lbl_74::
  end
  ___MOD.table.sort(list, function(a, b)
    return a.name < b.name
  end)
  return list
end

function WorldMapManager.buildSearchLines(self, mapId)
  if self.searchOverrideActive then
    if self.searchOverrideQuery ~= nil then
      self.searchOverrideLines = self:buildSearchLinesByQuery(self.searchOverrideQuery, mapId)
    end
    return self.searchOverrideLines
  end
  local life = self:getMapLifeIds(mapId)
  local npcList = self:buildNameList(life.npcs, "npc")
  local mobList = self:buildNameList(life.mobs, "monster")
  local lines = {}
  if #npcList == 0 and #mobList == 0 then
    if not life.hasData and life.pending then
      lines[1] = {type = "empty", text = ""}
    elseif not life.hasData then
      lines[1] = {type = "empty", text = ""}
    else
      lines[1] = {type = "empty", text = ""}
    end
    return lines
  end
  for i = 1, #npcList do
    local n = npcList[i]
    lines[#lines + 1] = {
      type = "npc",
      id = n.id,
      text = n.name
    }
  end
  self:appendMonsterLines(lines, mobList, mapId)
  return lines
end

function WorldMapManager.buildSearchLinesByQuery(self, query, mapId)
  local text = ___MOD.tostring(query or "")
  text, ___MOD._ = ___MOD.string.gsub(text, "^%s*(.-)%s*$", "%1")
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return {}
  end
  local mode = "auto"
  local lower = ___MOD.string.lower(text)
  if ___MOD.string.sub(lower, 1, 2) == "m:" then
    mode = "monster"
    text = ___MOD.string.sub(text, 3)
  elseif ___MOD.string.sub(lower, 1, 4) == "mob:" then
    mode = "monster"
    text = ___MOD.string.sub(text, 5)
  elseif ___MOD.string.sub(lower, 1, 8) == "monster:" then
    mode = "monster"
    text = ___MOD.string.sub(text, 9)
  elseif ___MOD.string.sub(lower, 1, 2) == "i:" then
    mode = "item"
    text = ___MOD.string.sub(text, 3)
  elseif ___MOD.string.sub(lower, 1, 5) == "item:" then
    mode = "item"
    text = ___MOD.string.sub(text, 6)
  elseif ___MOD.string.sub(text, 1, 4) == "몬스터:" then
    mode = "monster"
    text = ___MOD.string.sub(text, 5)
  elseif ___MOD.string.sub(text, 1, 2) == "몬:" then
    mode = "monster"
    text = ___MOD.string.sub(text, 3)
  elseif ___MOD.string.sub(text, 1, 2) == "몹:" then
    mode = "monster"
    text = ___MOD.string.sub(text, 3)
  elseif ___MOD.string.sub(text, 1, 4) == "아이템:" then
    mode = "item"
    text = ___MOD.string.sub(text, 5)
  elseif ___MOD.string.sub(text, 1, 2) == "템:" then
    mode = "item"
    text = ___MOD.string.sub(text, 3)
  end
  text, ___MOD._ = ___MOD.string.gsub(text, "^%s*(.-)%s*$", "%1")
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return {}
  end
  self:ensureSearchIndex()
  local queryLower = ___MOD.string.lower(text)
  local queryId = ___MOD.tonumber(text)
  local matchedMobSet = {}
  if mode ~= "item" then
    for i = 1, #self.searchMobIds do
      local mobId = self.searchMobIds[i]
      if queryId ~= nil and mobId == queryId then
        matchedMobSet[mobId] = true
      else
        local name = self:getMobNameCached(mobId)
        if not ___MOD._UtilLogic:IsNilorEmptyString(name) then
          local nameLower = ___MOD.string.lower(name)
          if ___MOD.string.find(nameLower, queryLower, 1, true) ~= nil then
            matchedMobSet[mobId] = true
          end
        end
      end
    end
  end
  local matchedItemSet = {}
  if mode ~= "monster" then
    for i = 1, #self.searchItemIds do
      local itemId = self.searchItemIds[i]
      if queryId ~= nil and itemId == queryId then
        matchedItemSet[itemId] = true
      else
        local name = self:getItemNameCached(itemId)
        if not ___MOD._UtilLogic:IsNilorEmptyString(name) then
          local nameLower = ___MOD.string.lower(name)
          if ___MOD.string.find(nameLower, queryLower, 1, true) ~= nil then
            matchedItemSet[itemId] = true
          end
        end
      end
    end
  end
  local resultMobSet = {}
  for mobId, _ in ___MOD.pairs(matchedMobSet) do
    resultMobSet[mobId] = true
  end
  if mode ~= "monster" then
    for itemId, _ in ___MOD.pairs(matchedItemSet) do
      local mobs = self.rewardMobsByItem[itemId]
      if mobs ~= nil then
        for mobId, _ in ___MOD.pairs(mobs) do
          resultMobSet[mobId] = true
        end
      end
    end
  end
  local ids = {}
  for mobId, _ in ___MOD.pairs(resultMobSet) do
    ids[#ids + 1] = mobId
  end
  local itemIds = {}
  for itemId, _ in ___MOD.pairs(matchedItemSet) do
    itemIds[#itemIds + 1] = itemId
  end
  ___MOD.table.sort(itemIds)
  local lines = {}
  if #ids == 0 and #itemIds == 0 then
    lines[1] = {
      type = "empty",
      text = "검색 결과가 없습니다."
    }
    return lines
  end
  for i = 1, #itemIds do
    local itemId = itemIds[i]
    local name = self:getItemNameCached(itemId)
    lines[#lines + 1] = {
      type = "search_item",
      text = name,
      itemId = itemId
    }
  end
  if 0 < #ids then
    local mobList = self:buildNameList(ids, "monster")
    self:appendMonsterLines(lines, mobList, mapId)
  end
  return lines
end

function WorldMapManager.changeSearchScroll(self, movingDirection)
  if self.currentSearchMapId == 0 or 0 >= self.searchScrollMax then
    return
  end
  local delta = 0 < movingDirection and -1 or 1
  self.searchScrollIndex = ___MOD.math.max(0, ___MOD.math.min(self.searchScrollMax, self.searchScrollIndex + delta))
  self:showMapMonsterList(self.currentSearchMapId)
end

function WorldMapManager.closeWorldMap(self)
  local wasOpen = self.worldMap ~= nil and self.worldMap.Enable == true
  if self.escapeEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.KeyDownEvent, self.escapeEvent)
    self.escapeEvent = nil
  end
  if self.mouseClickEvent then
    ___MOD._InputService:DisconnectEvent(___MOD.KeyReleaseEvent, self.mouseClickEvent)
    self.mouseClickEvent = nil
  end
  self.worldMap:SetEnable(false)
  self.currentWorldMap = {}
  if wasOpen then
    ___MOD._UIWindowLogic:setOpenedUICount(-1)
  end
  ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.MenuUp"), 1)
end

function WorldMapManager.collectReviveMobIds(self, mobId, bucket, visited)
  if mobId <= 0 then
    return
  end
  if visited[mobId] == true then
    return
  end
  visited[mobId] = true
  local mobData = ___MOD._MobManager:getMonster(mobId)
  local info = mobData ~= nil and mobData.info or nil
  local reviveList = info ~= nil and info.revive or nil
  if reviveList ~= nil then
    for i = 1, #reviveList do
      local reviveId = ___MOD.tonumber(reviveList[i]) or 0
      if not (reviveId <= 0) then
        local rewardSet = self.rewardItemsByMob[reviveId]
        if rewardSet ~= nil and ___MOD.next(rewardSet) ~= nil then
          bucket[reviveId] = true
        end
        self:collectReviveMobIds(reviveId, bucket, visited)
      end
    end
  end
  visited[mobId] = nil
end

function WorldMapManager.ensureRewardCache(self)
  if self.rewardLoaded then
    return
  end
  self.rewardLoaded = true
  local dataset = ___MOD._DataService:GetTable("Reward_Client")
  if dataset == nil then
    return
  end
  for i = 1, dataset:GetRowCount() do
    local row = dataset:GetRow(i)
    if row ~= nil then
      local mobId = ___MOD.tonumber(row:GetItem("dropperid")) or 0
      local itemId = ___MOD.tonumber(row:GetItem("itemid")) or 0
      local questId = ___MOD.tonumber(row:GetItem("questid")) or 0
      if 0 < mobId and 0 < itemId and (questId == nil or questId <= 0) and itemId // 10000 ~= 238 then
        local bucket = self.rewardItemsByMob[mobId]
        if bucket == nil then
          bucket = {}
          self.rewardItemsByMob[mobId] = bucket
        end
        bucket[itemId] = true
      end
    end
  end
end

function WorldMapManager.ensureSearchIndex(self)
  if self.searchIndexLoaded then
    return
  end
  self.searchIndexLoaded = true
  self:ensureWorldMapSearchData()
  self:ensureRewardCache()
  local mobSet = {}
  local itemSet = {}
  for _, entry in ___MOD.pairs(self.worldMapSearchDataCache) do
    if entry ~= nil and entry.mobs ~= nil then
      for id, _ in ___MOD.pairs(entry.mobs) do
        mobSet[id] = true
      end
    end
  end
  local mobsByItem = {}
  for mobId, items in ___MOD.pairs(self.rewardItemsByMob) do
    if mobId ~= nil then
      mobSet[mobId] = true
    end
    if items ~= nil then
      for itemId, _ in ___MOD.pairs(items) do
        itemSet[itemId] = true
        local bucket = mobsByItem[itemId]
        if bucket == nil then
          bucket = {}
          mobsByItem[itemId] = bucket
        end
        bucket[mobId] = true
      end
    end
  end
  self.rewardMobsByItem = mobsByItem
  self.searchMobIds = {}
  for id, _ in ___MOD.pairs(mobSet) do
    self.searchMobIds[#self.searchMobIds + 1] = id
  end
  ___MOD.table.sort(self.searchMobIds)
  self.searchItemIds = {}
  for id, _ in ___MOD.pairs(itemSet) do
    self.searchItemIds[#self.searchItemIds + 1] = id
  end
  ___MOD.table.sort(self.searchItemIds)
end

function WorldMapManager.ensureSearchInputUI(self)
  if self.searchPanel == nil then
    return
  end
  if self.searchItem_model == "" then
    self.searchItem_model = ___MOD._EntryService:GetModelIdByName("Model_ListBoxItem")
  end

  local function safeNumber(value, default)
    if value == nil or value ~= value then
      return default
    end
    return value
  end

  local parent = self.searchListParent
  if parent == nil then
    local bg = self.searchPanel:GetChildByName("backgrnd_1")
    parent = bg or self.searchPanel
    self.searchListParent = parent
  end
  if parent == nil or parent.UITransformComponent == nil then
    return
  end
  if self.searchBox == nil then
    self.searchBox = self.searchPanel:GetChildByName("SearchBox")
  end
  if self.searchBtn == nil then
    self.searchBtn = self.searchPanel:GetChildByName("SearchBtn")
  end
  if self.searchBox ~= nil then
    if self.searchBox.SpriteGUIRendererComponent ~= nil then
      self.searchBox.SpriteGUIRendererComponent.RaycastTarget = true
    end
    if self.searchBox.UITouchReceiveComponent == nil then
      self.searchBox:AddComponent(___MOD.UITouchReceiveComponent)
    end
    if self.searchBoxClickEvent == nil then
      self.searchBoxClickEvent = self.searchBox:ConnectEvent(___MOD.UITouchUpEvent, function()
        self:activateSearchInputField()
      end)
    end
  end
  local rect = parent.UITransformComponent.RectSize
  local rectWidth = safeNumber(rect.x, 200)
  local paddingX = safeNumber(self.searchLeftPadding, 0)
  local paddingY = safeNumber(self.searchTopPadding, 0)
  local inputHeight = safeNumber(self.searchInputHeight, 24)
  local inputGap = safeNumber(self.searchInputGap, 6)
  local buttonWidth = safeNumber(self.searchInputButtonWidth, 50)
  if self.searchBox ~= nil and self.searchBox.UITransformComponent ~= nil then
    local sbRect = self.searchBox.UITransformComponent.RectSize
    inputHeight = safeNumber(sbRect.y, inputHeight)
  end
  self.searchInputHeight = inputHeight
  local fieldWidth = rectWidth - paddingX * 2 - buttonWidth - inputGap
  fieldWidth = ___MOD.math.max(80, fieldWidth)
  if self.searchInputRoot == nil then
    if self.searchBox ~= nil then
      self.searchInputRoot = self.searchBox
    else
      local root = ___MOD._SpawnService:SpawnByModelId(self.searchItem_model, "SearchInputRoot", ___MOD.FastVector3.zero:Clone(), parent)
      root.SpriteGUIRendererComponent:SetAlpha(0)
      root.SpriteGUIRendererComponent.RaycastTarget = false
      root.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      root.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
      root.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, 0)
      self.searchInputRoot = root
    end
  end
  if self.searchInputRoot ~= nil and self.searchInputRoot ~= self.searchBox then
    self.searchInputRoot.UITransformComponent.RectSize = ___MOD.FastVector2(rectWidth, ___MOD.math.max(0, inputHeight + inputGap + paddingY))
  end
  if self.searchInputField == nil and self.searchBox ~= nil then
    local prebuilt = self.searchBox:GetChildByName("SearchText")
    if prebuilt ~= nil then
      self.searchInputField = prebuilt
      self.searchUsePrebuiltText = true
    end
  end
  if self.searchInputField == nil then
    self.searchUsePrebuiltText = false
    local fieldParent = self.searchBox or self.searchInputRoot
    if fieldParent ~= nil then
      local field = ___MOD._SpawnService:SpawnByModelId(self.searchItem_model, "SearchInputField", ___MOD.FastVector3.zero:Clone(), fieldParent)
      field.SpriteGUIRendererComponent.Color = ___MOD.FastColor(1, 1, 1, 0)
      field.SpriteGUIRendererComponent.RaycastTarget = true
      local fieldButton = field.ButtonComponent
      if fieldButton ~= nil then
        fieldButton.Enable = false
      end
      self.searchInputField = field
    end
  end
  if self.searchInputField ~= nil then
    if self.searchInputSubmitEvent == nil and self.searchInputField ~= nil then
      self.searchInputSubmitEvent = self.searchInputField:ConnectEvent(___MOD.TextInputSubmitEvent, self.onSearchInputSubmit)
    end
    local field = self.searchInputField
    field.SpriteGUIRendererComponent.RaycastTarget = true
    if not self.searchUsePrebuiltText then
      if field.TextGUIRendererComponent ~= nil then
        field.TextGUIRendererComponent.Enable = false
      end
      if field.TextGUIRendererInputComponent ~= nil then
        field.TextGUIRendererInputComponent.Enable = false
      end
    end
    if not self.searchUsePrebuiltText then
      if field.TextComponent == nil then
        field:AddComponent(___MOD.TextComponent)
      end
      if field.TextInputComponent == nil then
        field:AddComponent(___MOD.TextInputComponent)
      end
      field.TextComponent.Text = field.TextComponent.Text or ""
      field.TextComponent.FontColor = ___MOD.FastColor.black
      field.TextComponent.FontSize = 18
      field.TextComponent.Alignment = ___MOD.TextAlignmentType.MiddleLeft
      field.TextComponent.Enable = true
      field.TextInputComponent.AutoClear = false
      field.TextInputComponent.Text = field.TextComponent.Text or ""
      field.TextInputComponent.Enable = true
      field.TextInputComponent.LineType = 0
    end
    if field.UITouchReceiveComponent == nil then
      field:AddComponent(___MOD.UITouchReceiveComponent)
    end
    field:ConnectEvent(___MOD.UITouchUpEvent, function()
      self:activateSearchInputField()
    end)
    if not self.searchUsePrebuiltText then
      local target = self.searchBox or self.searchInputRoot
      if target ~= nil and target.UITransformComponent ~= nil then
        local tRect = target.UITransformComponent.RectSize
        local width = safeNumber(tRect.x, fieldWidth)
        local height = safeNumber(tRect.y, inputHeight)
        self.searchInputField.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Center
        self.searchInputField.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0.5)
        self.searchInputField.UITransformComponent.anchoredPosition = ___MOD.FastVector2(3, 0)
        self.searchInputField.UITransformComponent.RectSize = ___MOD.FastVector2(___MOD.math.max(20, width - 12), ___MOD.math.max(10, height - 6))
      end
    end
  end
  if self.searchBtn ~= nil then
    self.searchInputButton = self.searchBtn
    local btnComp = self.searchBtn.ButtonComponent
    if btnComp ~= nil then
      btnComp.Enable = true
    end
    if self.searchButtonClickEvent == nil then
      self.searchButtonClickEvent = self.searchBtn:ConnectEvent(___MOD.ButtonClickEvent, self.onSearchButtonClick)
    end
  end
  if self.searchInputButton ~= nil and self.searchInputButton ~= self.searchBtn then
    self.searchInputButton.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    self.searchInputButton.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    self.searchInputButton.UITransformComponent.anchoredPosition = ___MOD.FastVector2(paddingX + fieldWidth + inputGap, -paddingY)
    self.searchInputButton.UITransformComponent.RectSize = ___MOD.FastVector2(buttonWidth, inputHeight)
  end
end

function WorldMapManager.ensureSearchListUI(self)
  if self.searchPanel == nil then
    return
  end
  if self.searchItem_model == "" then
    self.searchItem_model = ___MOD._EntryService:GetModelIdByName("Model_ListBoxItem")
  end

  local function safeNumber(value, default)
    if value == nil or value ~= value then
      return default
    end
    return value
  end

  local parent = self.searchListParent
  if parent == nil then
    local bg = self.searchPanel:GetChildByName("backgrnd_1")
    parent = bg or self.searchPanel
    self.searchListParent = parent
  end
  if self.searchPanel.UITouchReceiveComponent == nil then
    self.searchPanel:AddComponent(___MOD.UITouchReceiveComponent)
    self.searchPanel:ConnectEvent(___MOD.UITouchEnterEvent, function()
      self.searchPanelHovered = true
    end)
    self.searchPanel:ConnectEvent(___MOD.UITouchExitEvent, function()
      self.searchPanelHovered = false
    end)
  end
  if self.searchPanel.SpriteGUIRendererComponent ~= nil then
    self.searchPanel.SpriteGUIRendererComponent.RaycastTarget = true
  end
  if self.searchScrollEvent == nil then
    self.searchScrollEvent = ___MOD._InputService:ConnectEvent(___MOD.MouseScrollEvent, self.onSearchMouseScroll)
  end
  if self.searchListRoot == nil then
    local root = ___MOD._SpawnService:SpawnByModelId(self.searchItem_model, "SearchListRoot", ___MOD.FastVector3.zero:Clone(), parent)
    root.SpriteGUIRendererComponent:SetAlpha(0)
    root.SpriteGUIRendererComponent.RaycastTarget = false
    root.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    root.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    root.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, 0)
    local rect = parent.UITransformComponent.RectSize
    root.UITransformComponent.RectSize = ___MOD.FastVector2(safeNumber(rect.x, 200), safeNumber(rect.y, 200))
    self.searchListRoot = root
  end
  if self.searchListRoot.UITouchReceiveComponent == nil then
    self.searchListRoot:AddComponent(___MOD.UITouchReceiveComponent)
    self.searchListRoot:ConnectEvent(___MOD.UITouchEnterEvent, function()
      self.searchPanelHovered = true
    end)
    self.searchListRoot:ConnectEvent(___MOD.UITouchExitEvent, function()
      self.searchPanelHovered = false
    end)
  end
  if self.searchListRoot.SpriteGUIRendererComponent ~= nil then
    self.searchListRoot.SpriteGUIRendererComponent.RaycastTarget = true
  end
  local maxItems = self.searchMaxItems
  local current = #self.searchItem_pool
  local baseRect = parent.UITransformComponent.RectSize
  local paddingX = safeNumber(self.searchLeftPadding, 0)
  local paddingY = safeNumber(self.searchTopPadding, 0)
  local lineHeight = safeNumber(self.searchLineHeight, 20)
  local rectWidth = safeNumber(baseRect.x, 200)
  local inputHeight = safeNumber(self.searchInputHeight, 0)
  local inputGap = safeNumber(self.searchInputGap, 0)
  local listOffsetY = inputHeight + inputGap
  self:ensureSearchInputUI()
  local scrollWidth = 0
  local scrollGap = 6
  if self.searchScrollRoot ~= nil and self.searchScrollRoot.UITransformComponent ~= nil then
    scrollWidth = safeNumber(self.searchScrollRoot.UITransformComponent.RectSize.x, 0)
  end
  local width = rectWidth - paddingX * 2 - scrollWidth - scrollGap
  width = ___MOD.math.max(100, width)
  if self.searchListRoot ~= nil then
    local listHeight = ___MOD.math.max(0, safeNumber(baseRect.y, 200) - listOffsetY)
    self.searchListRoot.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, -listOffsetY)
    self.searchListRoot.UITransformComponent.RectSize = ___MOD.FastVector2(rectWidth, listHeight)
  end
  for i = 1, current do
    local entry = self.searchItem_pool[i]
    local item = entry.entity
    local transform = item.UITransformComponent
    transform.anchoredPosition = ___MOD.FastVector2(paddingX, -paddingY - (i - 1) * lineHeight)
    transform.RectSize = ___MOD.FastVector2(width, lineHeight)
  end
  if maxItems <= current then
    return
  end
  for i = current + 1, maxItems do
    local item = ___MOD._SpawnService:SpawnByModelId(self.searchItem_model, "SearchItem", ___MOD.FastVector3.zero:Clone(), self.searchListRoot)
    item.SpriteGUIRendererComponent:SetAlpha(0)
    item.SpriteGUIRendererComponent.RaycastTarget = true
    local transform = item.UITransformComponent
    transform.AlignmentOption = ___MOD.AlignmentType.TopLeft
    transform.Pivot = ___MOD.FastVector2(0, 1)
    transform.anchoredPosition = ___MOD.FastVector2(paddingX, -paddingY - (i - 1) * lineHeight)
    transform.RectSize = ___MOD.FastVector2(width, lineHeight)
    if item.TextGUIRendererComponent ~= nil then
      item.TextGUIRendererComponent.Enable = false
    end
    local icon = ___MOD._SpawnService:SpawnByModelId(self.searchItem_model, "icon", ___MOD.FastVector3.zero:Clone(), item)
    icon.SpriteGUIRendererComponent.RaycastTarget = false
    icon.SpriteGUIRendererComponent:SetAlpha(1)
    icon.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    icon.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    icon.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, -2)
    icon.UITransformComponent.RectSize = ___MOD.FastVector2(22, 22)
    if icon.TextGUIRendererComponent ~= nil then
      icon.TextGUIRendererComponent.Enable = false
    end
    if icon.ButtonComponent ~= nil then
      icon:RemoveComponent(___MOD.ButtonComponent)
    end
    local textEntity = ___MOD._SpawnService:SpawnByModelId(self.searchItem_model, "text", ___MOD.FastVector3.zero:Clone(), item)
    textEntity.SpriteGUIRendererComponent:SetAlpha(0)
    textEntity.SpriteGUIRendererComponent.RaycastTarget = false
    if textEntity.TextGUIRendererComponent ~= nil then
      textEntity.TextGUIRendererComponent.Enable = false
    end
    if textEntity.ButtonComponent ~= nil then
      textEntity:RemoveComponent(___MOD.ButtonComponent)
    end
    textEntity.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    textEntity.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    textEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(26, -3)
    textEntity.UITransformComponent.RectSize = ___MOD.FastVector2(width - 26, lineHeight)
    textEntity:AddComponent(___MOD.BitmapFontRendererComponent)
    item:SetEnable(false)
    ___MOD.table.insert(self.searchItem_pool, {
      entity = item,
      icon = icon,
      text = textEntity.BitmapFontRendererComponent,
      textEntity = textEntity,
      clickEvent = nil
    })
  end
end

function WorldMapManager.ensureWorldMapSearchData(self)
  if self.worldMapSearchLoaded then
    return
  end
  local dataset = ___MOD._DataService:GetTable("WorldMapSearchData")
  if dataset == nil then
    return
  end
  self.worldMapSearchLoaded = true

  local function normalizeList(value)
    if value == nil then
      return ""
    end
    local text = ___MOD.tostring(value)
    text, ___MOD._ = ___MOD.string.gsub(text, "^%s*\"(.*)\"%s*$", "%1")
    text, ___MOD._ = ___MOD.string.gsub(text, "^%s*'(.*)'%s*$", "%1")
    return text
  end

  local function addMobIds(value, bucket)
    local text = normalizeList(value)
    if ___MOD._UtilLogic:IsNilorEmptyString(text) then
      return
    end
    for token in ___MOD.string.gmatch(text, "([^,]+)") do
      local trimmed, _ = ___MOD.string.gsub(token, "^%s*(.-)%s*$", "%1")
      local id = ___MOD.tonumber(trimmed)
      if id ~= nil and 0 < id then
        bucket[id] = true
      end
    end
  end

  local function addNpcIds(value, bucket)
    local text = normalizeList(value)
    if ___MOD._UtilLogic:IsNilorEmptyString(text) then
      return
    end
    for token in ___MOD.string.gmatch(text, "([^,]+)") do
      local trimmed, _ = ___MOD.string.gsub(token, "^%s*(.-)%s*$", "%1")
      local id = ___MOD.tonumber(trimmed)
      if id ~= nil and 0 < id and ___MOD._NpcConstants:checkCanSpawn(id) then
        bucket[id] = true
      end
    end
  end

  for i = 1, dataset:GetRowCount() do
    local row = dataset:GetRow(i)
    if row ~= nil then
      local mapId = ___MOD.tonumber(row:GetItem("mapid")) or 0
      if 0 < mapId then
        local entry = self.worldMapSearchDataCache[mapId]
        if entry == nil then
          entry = {
            mobs = {},
            npcs = {}
          }
          self.worldMapSearchDataCache[mapId] = entry
        end
        addMobIds(row:GetItem("mobid"), entry.mobs)
        addNpcIds(row:GetItem("npcid"), entry.npcs)
      end
    end
  end
end

function WorldMapManager.getItemNameCached(self, itemId)
  local name = self.itemNameCache[itemId]
  if name ~= nil then
    return name
  end
  name = ___MOD._StringPoolManager:getItemName(itemId)
  if ___MOD._UtilLogic:IsNilorEmptyString(name) then
    name = ___MOD.tostring(itemId)
  end
  self.itemNameCache[itemId] = name
  return name
end

function WorldMapManager.getMapLifeIds(self, mapId)
  local cached = self.mapLifeCache[mapId]
  if cached ~= nil then
    return cached
  end
  self:ensureWorldMapSearchData()
  self:ensureRewardCache()
  local mobSet = {}
  local npcSet = {}
  local hasData = false
  local cachedData = self.worldMapSearchDataCache[mapId]
  if cachedData ~= nil then
    hasData = true
    for id, _ in ___MOD.pairs(cachedData.mobs) do
      mobSet[id] = true
    end
    for id, _ in ___MOD.pairs(cachedData.npcs) do
      npcSet[id] = true
    end
  end
  local reviveMobSet = {}
  for id, _ in ___MOD.pairs(mobSet) do
    self:collectReviveMobIds(id, reviveMobSet, {})
  end
  for id, _ in ___MOD.pairs(reviveMobSet) do
    mobSet[id] = true
  end
  local mobs = {}
  for id, _ in ___MOD.pairs(mobSet) do
    ___MOD.table.insert(mobs, id)
  end
  local npcs = {}
  for id, _ in ___MOD.pairs(npcSet) do
    ___MOD.table.insert(npcs, id)
  end
  local result = {
    mobs = mobs,
    npcs = npcs,
    mapLoaded = false,
    hasData = hasData,
    pending = false
  }
  self.mapLifeCache[mapId] = result
  return result
end

function WorldMapManager.getMobDisplayText(self, mobId)
  local name = self:getMobNameCached(mobId)
  local mobData = ___MOD._MobManager:getMonster(mobId)
  local info = mobData ~= nil and mobData.info or nil
  local level = info ~= nil and info.level or 0
  if 0 < level then
    return ___MOD.string.format("%s (LV. %d)", name, level)
  end
  return name
end

function WorldMapManager.getMobNameCached(self, mobId)
  local name = self.mobNameCache[mobId]
  if name ~= nil then
    return name
  end
  name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Mob.img/%d/name", mobId))
  if ___MOD._UtilLogic:IsNilorEmptyString(name) then
    name = ___MOD.tostring(mobId)
  end
  self.mobNameCache[mobId] = name
  return name
end

function WorldMapManager.getRewardItemNames(self, mobId)
  self:ensureRewardCache()
  local bucket = self.rewardItemsByMob[mobId]
  if bucket == nil then
    return {}
  end
  local itemIds = {}
  for itemId, _ in ___MOD.pairs(bucket) do
    ___MOD.table.insert(itemIds, itemId)
  end
  ___MOD.table.sort(itemIds)
  local names = {}
  for i = 1, #itemIds do
    local itemId = itemIds[i]
    local name = ___MOD._StringPoolManager:getItemName(itemId)
    if ___MOD._UtilLogic:IsNilorEmptyString(name) then
      name = ___MOD.tostring(itemId)
    end
    ___MOD.table.insert(names, {id = itemId, name = name})
  end
  return names
end

function WorldMapManager.getSearchInputText(self)
  if self.searchInputField == nil then
    return ""
  end
  local input = self.searchInputField.TextInputComponent
  if input ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(input.Text) then
    return input.Text
  end
  local guiInput = self.searchInputField.TextGUIRendererInputComponent
  if guiInput ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(guiInput.Text) then
    return guiInput.Text
  end
  local text = self.searchInputField.TextComponent
  if text ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(text.Text) then
    return text.Text or ""
  end
  local guiText = self.searchInputField.TextGUIRendererComponent
  if guiText ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(guiText.Text) then
    return guiText.Text
  end
  return ""
end

function WorldMapManager.hasRewardDataInReviveChain(self, mobId, visited)
  if mobId <= 0 then
    return false
  end
  if visited[mobId] == true then
    return false
  end
  visited[mobId] = true
  local rewardSet = self.rewardItemsByMob[mobId]
  if rewardSet ~= nil and ___MOD.next(rewardSet) ~= nil then
    visited[mobId] = nil
    return true
  end
  local mobData = ___MOD._MobManager:getMonster(mobId)
  local info = mobData ~= nil and mobData.info or nil
  local reviveList = info ~= nil and info.revive or nil
  if reviveList ~= nil then
    for i = 1, #reviveList do
      local reviveId = ___MOD.tonumber(reviveList[i]) or 0
      if 0 < reviveId and self:hasRewardDataInReviveChain(reviveId, visited) then
        visited[mobId] = nil
        return true
      end
    end
  end
  visited[mobId] = nil
  return false
end

function WorldMapManager.hidePath(self)
  local path = self.mapPath
  if path == nil then
    return
  end
  path:SetEnable(false)
end

function WorldMapManager.hideSearchItem(self, entry)
  if entry.clickEvent ~= nil then
    entry.entity:DisconnectEvent(___MOD.ButtonClickEvent, entry.clickEvent)
    entry.clickEvent = nil
  end
  entry.entity:SetEnable(false)
end

function WorldMapManager.OnBeginPlay(self)
  local worldMap = ___MOD._EntityService:GetEntity("fcddd1e0-9c8a-45d6-b526-2f854044c088")
  self.worldMap = worldMap
  self.backgrnd = worldMap:GetChildByName("backgrnd")
  self.mapSpot_model = ___MOD._EntryService:GetModelIdByName("Model_WorldMapSpot")
  self.mapLink_model = ___MOD._EntryService:GetModelIdByName("Model_WorldMapLink")
  self.mapSpot_parent = worldMap:GetChildByName("MapSpot")
  self.mapLink_parent = worldMap:GetChildByName("MapLink")
  self.searchPanel = worldMap:GetChildByName("Search")
  self.searchItem_model = ___MOD._EntryService:GetModelIdByName("Model_ListBoxItem")
  if self.searchPanel ~= nil then
    self.searchBox = self.searchPanel:GetChildByName("SearchBox")
    self.searchBtn = self.searchPanel:GetChildByName("SearchBtn")
  end
  local mapPos = worldMap:GetChildByName("MapPos")
  self.curPos = mapPos:GetChildByName("curPos")
  self.mapSpot_rectSize_cache[1] = ___MOD.FastVector2(40, 40)
  self.mapSpot_rectSize_cache[2] = ___MOD.FastVector2(28, 28)
  self.mapSpot_rectSize_cache[3] = ___MOD.FastVector2(40, 40)
  self.mapSpot_rectSize_cache[4] = ___MOD.FastVector2(26, 26)
  local scrollRoot = self.searchPanel and self.searchPanel:GetChildByName("Scroll") or nil
  if scrollRoot ~= nil and scrollRoot.WorldMapSearchScrollComponent ~= nil then
    scrollRoot.WorldMapSearchScrollComponent.manager = self
    scrollRoot.WorldMapSearchScrollComponent.searchPanel = self.searchPanel
    scrollRoot.WorldMapSearchScrollComponent:updateMetrics()
  end
  self:ensureSearchInputUI()
  local closeBtn = worldMap:GetChildByName("CloseBtn")
  if closeBtn ~= nil then
    closeBtn:ConnectEvent(___MOD.ButtonClickEvent, function()
      if self.escapeEvent ~= nil then
        ___MOD._InputService:DisconnectEvent(___MOD.KeyDownEvent, self.escapeEvent)
        self.escapeEvent = nil
      end
      if self.mouseClickEvent ~= nil then
        ___MOD._InputService:DisconnectEvent(___MOD.KeyReleaseEvent, self.mouseClickEvent)
        self.mouseClickEvent = nil
      end
      self.currentWorldMap = {}
    end)
  end
end

function WorldMapManager.onEscapeKeyDown(self, event)
  if event.key == ___MOD.KeyboardKey.Escape then
    if self.currentWorldMap then
      local parentMap = self.currentWorldMap.parentMap
      if ___MOD._UtilLogic:IsNilorEmptyString(parentMap) then
        self:closeWorldMap()
        return
      end
      self:showWorldMap(parentMap)
      ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.SelectMap"), 1)
    else
      self:closeWorldMap()
    end
  end
end

function WorldMapManager.onMouseRightClick(self, event)
  if event.key == ___MOD.KeyboardKey.Mouse1 and self.currentWorldMap then
    local parentMap = self.currentWorldMap.parentMap
    if ___MOD._UtilLogic:IsNilorEmptyString(parentMap) then
      return
    end
    self:showWorldMap(parentMap)
    ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.SelectMap"), 1)
  end
end

function WorldMapManager.onSearchButtonClick(self)
  local query = self:getSearchInputText()
  self:performWorldMapSearch(query)
end

function WorldMapManager.onSearchInputSubmit(self, event)
  local query = self:getSearchInputText()
  self:performWorldMapSearch(query)
end

function WorldMapManager.onSearchMouseMove(self, event)
  if self.searchScrollRoot == nil or not self.searchScrollRoot.EnabledInHierarchy then
    return
  end
  if not self.searchScrollBarPressed then
    return
  end
  if self.searchScrollPrev == nil then
    return
  end
  local itemCount = ___MOD.math.max(1, self.searchScrollMax)
  local index, barY = ___MOD._OffsetUtils:calcScrollByCursorPos(itemCount, self.searchScrollYSize, self.searchScrollBarBaseY, self.searchScrollPrevBaseY, self.searchScrollPrev)
  self.searchScrollIndex = ___MOD.math.max(0, ___MOD.math.min(self.searchScrollMax, index))
  if self.searchScrollBar ~= nil then
    self.searchScrollBar.UITransformComponent.anchoredPosition.y = barY
  end
  self:showMapMonsterList(self.currentSearchMapId)
end

function WorldMapManager.onSearchMouseScroll(self, event)
  if ___MOD._UIWindowLogic:isCursorBlockedByHigherWindow(self.worldMap) then
    return
  end
  if not self.searchPanelHovered and not ___MOD._InputService:IsPointerOverUI() then
    return
  end
  if self.currentSearchMapId == 0 or 0 >= self.searchScrollMax then
    return
  end
  local delta = event.ScrollDelta
  if delta == 0 then
    return
  end
  if 0 < delta then
    self:changeSearchScroll(1)
  else
    self:changeSearchScroll(-1)
  end
end

function WorldMapManager.performWorldMapSearch(self, query)
  local text = ___MOD.tostring(query or "")
  text, ___MOD._ = ___MOD.string.gsub(text, "^%s*(.-)%s*$", "%1")
  self.searchOverrideQuery = text

  local function countHangul(s)
    local count = 0
    local utf8 = ___MOD.require("utf8")
    for _, cp in utf8.codes(s) do
      if 44032 <= cp and cp <= 55203 then
        count = count + 1
      end
    end
    return count
  end

  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    self.searchOverrideActive = true
    self.searchOverrideQuery = nil
    self.searchOverrideLines = {
      {
        type = "empty",
        text = "검색어를 입력해 주세요."
      }
    }
    self.searchScrollIndex = 0
    self:showMapMonsterList(-1)
    return
  end
  if countHangul(text) < 2 then
    self.searchOverrideActive = true
    self.searchOverrideQuery = nil
    self.searchOverrideLines = {
      {
        type = "empty",
        text = "검색어는 2글자 이상 입력해 주세요."
      }
    }
    self.searchScrollIndex = 0
    self:showMapMonsterList(-1)
    return
  end
  local mapId = -1
  self.searchRequestToken = (self.searchRequestToken or 0) + 1
  local token = self.searchRequestToken
  self:setSearchLoading(true)
  ___MOD._TimerService:SetTimerOnce(function()
    if token ~= self.searchRequestToken then
      return
    end
    self.searchOverrideLines = self:buildSearchLinesByQuery(text, mapId)
    self.searchOverrideActive = true
    self.searchScrollIndex = 0
    self.expandedMonstersByMap[mapId] = {}
    self.selectedSearchEntryByMap[mapId] = nil
    self:showMapMonsterList(mapId)
    self:setSearchLoading(false)
  end, 0)
end

function WorldMapManager.scheduleSearchRerender(self)
  if self.searchRerenderPending then
    return
  end
  self.searchRerenderPending = true
  self.searchRerenderTimer = ___MOD._TimerService:SetTimerOnce(function()
    self.searchRerenderPending = false
    if self.currentSearchMapId ~= 0 then
      self:showMapMonsterList(self.currentSearchMapId)
    end
  end, 0.05)
end

function WorldMapManager.setSearchItem(self, entry, line)
  local function parseSearchQueryForItemMatch(raw)
    local text = ___MOD.tostring(raw or "")

    text, ___MOD._ = ___MOD.string.gsub(text, "^%s*(.-)%s*$", "%1")
    if ___MOD._UtilLogic:IsNilorEmptyString(text) then
      return "", "auto"
    end
    local lower = ___MOD.string.lower(text)
    local mode = "auto"
    if ___MOD.string.sub(lower, 1, 2) == "m:" then
      mode = "monster"
      text = ___MOD.string.sub(text, 3)
    elseif ___MOD.string.sub(lower, 1, 4) == "mob:" then
      mode = "monster"
      text = ___MOD.string.sub(text, 5)
    elseif ___MOD.string.sub(lower, 1, 8) == "monster:" then
      mode = "monster"
      text = ___MOD.string.sub(text, 9)
    elseif ___MOD.string.sub(lower, 1, 2) == "i:" then
      mode = "item"
      text = ___MOD.string.sub(text, 3)
    elseif ___MOD.string.sub(lower, 1, 5) == "item:" then
      mode = "item"
      text = ___MOD.string.sub(text, 6)
    elseif ___MOD.string.sub(text, 1, 4) == "???:" then
      mode = "monster"
      text = ___MOD.string.sub(text, 5)
    elseif ___MOD.string.sub(text, 1, 2) == "?:" then
      mode = "monster"
      text = ___MOD.string.sub(text, 3)
    elseif ___MOD.string.sub(text, 1, 2) == "?:" then
      mode = "monster"
      text = ___MOD.string.sub(text, 3)
    elseif ___MOD.string.sub(text, 1, 4) == "???:" then
      mode = "item"
      text = ___MOD.string.sub(text, 5)
    elseif ___MOD.string.sub(text, 1, 2) == "?:" then
      mode = "item"
      text = ___MOD.string.sub(text, 3)
    end
    text, ___MOD._ = ___MOD.string.gsub(text, "^%s*(.-)%s*$", "%1")
    return ___MOD.string.lower(text), mode
  end

  local entity = entry.entity
  local icon = entry.icon
  local text = entry.text
  local textEntity = entry.textEntity
  local button = entity.ButtonComponent
  local tooltip = entity.TooltipComponent
  if entry.clickEvent ~= nil then
    entity:DisconnectEvent(___MOD.ButtonClickEvent, entry.clickEvent)
    entry.clickEvent = nil
  end
  local iconRuid
  local enableClick = false
  local colorPrefix = ""
  local baseColor = ___MOD.FastColor.black
  local queryCached, modeCached
  local queryResolved = false

  local function getSearchQuery()
    if not queryResolved then
      queryCached, modeCached = parseSearchQueryForItemMatch(self.searchOverrideQuery)
      queryResolved = true
    end
    return queryCached, modeCached
  end

  if line.type == "npc" then
    iconRuid = self.searchNpcIconRuid
    enableClick = true
    colorPrefix = "#Cffcc00"
    baseColor = ___MOD.FastColor.white
  elseif line.type == "monster" or line.type == "revive_monster" then
    iconRuid = self.searchMonsterIconRuid
    enableClick = line.type == "monster"
    colorPrefix = "#C33ccff"
    baseColor = ___MOD.FastColor.white
  elseif line.type == "item" then
    local query, mode = getSearchQuery()
    local show = self.searchOverrideActive and not ___MOD._UtilLogic:IsNilorEmptyString(query) and mode ~= "monster"
    if show then
      local name = line.text or ""
      name, ___MOD._ = ___MOD.string.gsub(name, "^%s*%-?%s*", "")
      if ___MOD.string.find(___MOD.string.lower(name), query, 1, true) ~= nil then
        iconRuid = self.searchItemMatchIconRuid
        baseColor = ___MOD.FastColor.white
      end
    end
  elseif line.type == "search_item" then
    iconRuid = self.searchItemMatchIconRuid
    baseColor = ___MOD.FastColor.white
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(iconRuid) then
    icon:SetEnable(false)
  else
    icon.SpriteGUIRendererComponent.ImageRUID = iconRuid
    icon:SetEnable(true)
  end
  if textEntity ~= nil and entity.UITransformComponent ~= nil then
    local rect = entity.UITransformComponent.RectSize
    local rectX = rect and rect.x or 0
    local rectY = rect and rect.y or 0
    if rectX ~= rectX then
      rectX = 0
    end
    if rectY ~= rectY then
      rectY = 0
    end
    local offsetX = ___MOD._UtilLogic:IsNilorEmptyString(iconRuid) and 0 or 26
    textEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(offsetX, -3)
    textEntity.UITransformComponent.RectSize = ___MOD.FastVector2(___MOD.math.max(0, rectX - offsetX), rectY)
  end
  local rawText = line.text or ""
  local displayText = rawText
  local isTruncated = false
  local maxWidth = textEntity ~= nil and textEntity.UITransformComponent.RectSize.x or nil
  local fontType = ___MOD._BitmapFontType.Gulim9pt
  local utf8 = ___MOD.require("utf8")
  local badGlyphs = self.badGlyphByFont[fontType]
  if badGlyphs == nil then
    badGlyphs = {}
    self.badGlyphByFont[fontType] = badGlyphs
  end
  local glyphCache = self.glyphSizeCacheByFont[fontType]
  if glyphCache == nil then
    glyphCache = {}
    self.glyphSizeCacheByFont[fontType] = glyphCache
  end

  local function getGlyphSizeSafe(cp, font)
    if badGlyphs[cp] == true then
      return 6, 14, true
    end
    local cached = glyphCache[cp]
    if cached ~= nil then
      return cached.w, cached.h, false
    end

    local function tryGet()
      local sz = ___MOD._BitmapFontManager:getGlyphSize(font, cp)
      local w1 = sz and sz.x or nil
      local h1 = sz and sz.y or nil
      local w2 = sz and sz[1] or nil
      local h2 = sz and sz[2] or nil
      local w = w2 or 0
      local h = h2 or 0
      local invalid = sz == nil or w2 == nil or h2 == nil or w ~= w or h ~= h or w <= 0 or h <= 0 or w2 ~= nil and (w2 ~= w2 or w2 <= 0) or h2 ~= nil and (h2 ~= h2 or h2 <= 0) or w1 ~= nil and (w1 ~= w1 or w1 <= 0) or h1 ~= nil and (h1 ~= h1 or h1 <= 0)
      return w, h, invalid
    end

    for _ = 1, 3 do
      local w, h, invalid = tryGet()
      if not invalid then
        glyphCache[cp] = {w = w, h = h}
        return w, h, false
      end
    end
    badGlyphs[cp] = true
    return 6, 14, true
  end

  local function sanitizeText(text, font)
    local out = {}
    local removed = false
    for _, cp in utf8.codes(text) do
      if cp < 32 then
        removed = true
      else
        local _, _, invalid = getGlyphSizeSafe(cp, font)
        if not invalid then
          out[#out + 1] = utf8.char(cp)
        else
          removed = true
        end
      end
    end
    if removed then
      return ___MOD.table.concat(out), true
    end
    return text, false
  end

  local function calcWidthSafe(text, font)
    local total = 0
    for _, cp in utf8.codes(text) do
      local w = getGlyphSizeSafe(cp, font)
      total = total + w
    end
    return total
  end

  local hadInvalid = false
  displayText, hadInvalid = sanitizeText(displayText, fontType)
  if ___MOD._UtilLogic:IsNilorEmptyString(displayText) then
    text.text = ""
    text:drawTextArg("", fontType, ___MOD.FastVector2.zero:Clone(), baseColor, false, false, ___MOD.FastColor.clear, true, nil, 0)
    return
  end
  if hadInvalid then
    text.text = ""
    text:drawTextArg("", fontType, ___MOD.FastVector2.zero:Clone(), baseColor, false, false, ___MOD.FastColor.clear, true, nil, 0)
    self:scheduleSearchRerender()
    return
  end

  local function isGlyphValid(cp, font)
    local cached = glyphCache[cp]
    if cached ~= nil then
      return true
    end
    local sz = ___MOD._BitmapFontManager:getGlyphSize(font, cp)
    local w2 = sz and sz[1] or nil
    local h2 = sz and sz[2] or nil
    if w2 == nil or h2 == nil then
      return false
    end
    if w2 ~= w2 or h2 ~= h2 or w2 <= 0 or h2 <= 0 then
      return false
    end
    glyphCache[cp] = {w = w2, h = h2}
    return true
  end

  local function warmGlyphs(text, font)
    for _, cp in utf8.codes(text) do
      if cp < 32 then
        return false
      end
      for _ = 1, 2 do
        if not isGlyphValid(cp, font) then
          return false
        end
      end
    end
    return true
  end

  if not warmGlyphs(displayText, fontType) then
    text.text = ""
    text:drawTextArg("", fontType, ___MOD.FastVector2.zero:Clone(), baseColor, false, false, ___MOD.FastColor.clear, true, nil, 0)
    self:scheduleSearchRerender()
    return
  end
  if maxWidth ~= nil and maxWidth == maxWidth and 0 < maxWidth and not ___MOD._UtilLogic:IsNilorEmptyString(displayText) then
    local width = calcWidthSafe(displayText, fontType)
    if maxWidth < width then
      local ellipsis = sanitizeText("...", fontType)
      if ___MOD._UtilLogic:IsNilorEmptyString(ellipsis) then
        ellipsis = ""
      end
      local ellipsisWidth = calcWidthSafe(ellipsis, fontType)
      local targetWidth = maxWidth - ellipsisWidth
      if targetWidth <= 0 then
        displayText = ellipsis
        isTruncated = true
      else
        local built = {}
        local accWidth = 0
        for _, code in utf8.codes(displayText) do
          local ch = utf8.char(code)
          local chWidth = calcWidthSafe(ch, fontType)
          if targetWidth < accWidth + chWidth then
            break
          end
          built[#built + 1] = ch
          accWidth = accWidth + chWidth
        end
        displayText = ___MOD.table.concat(built) .. ellipsis
        isTruncated = true
      end
    end
    local renderText = colorPrefix .. displayText
    text.text = renderText
    text:drawTextArg(renderText, fontType, ___MOD.FastVector2.zero:Clone(), baseColor, false, false, ___MOD.FastColor.clear, true, nil, 0)
  else
    local renderText = colorPrefix .. displayText
    text.text = renderText
    text:drawTextArg(renderText, fontType, ___MOD.FastVector2.zero:Clone(), baseColor, false, false, ___MOD.FastColor.clear, true, nil, 0)
  end
  if (line.type == "item" or line.type == "search_item") and line.itemId ~= nil and 0 < line.itemId then
    if tooltip == nil then
      entity:AddComponent(___MOD.TooltipComponent)
      tooltip = entity.TooltipComponent
    end
    local itemId = ___MOD.tonumber(line.itemId)
    tooltip.type = ___MOD._TooltipType.INVENTORY
    tooltip.id = itemId
    tooltip.text = ""
    tooltip.maxWidth = 0
    tooltip.equip = nil
    if itemId // 1000000 == 1 then
      local equipItem = ___MOD._EquipManager:getItemById(itemId)
      if equipItem ~= nil then
        tooltip.equip = equipItem:addInventoryEquip()
      end
    end
  elseif isTruncated then
    if tooltip == nil then
      entity:AddComponent(___MOD.TooltipComponent)
      tooltip = entity.TooltipComponent
    end
    tooltip.type = ___MOD._TooltipType.TEXT
    tooltip.text = rawText
    tooltip.maxWidth = 600
  elseif tooltip ~= nil then
    entity:RemoveComponent(___MOD.TooltipComponent)
  end
  if line.type == "item" then
    local query, mode = getSearchQuery()
    local show = self.searchOverrideActive and not ___MOD._UtilLogic:IsNilorEmptyString(query) and mode ~= "monster"
    local name = line.text or ""
    name, ___MOD._ = ___MOD.string.gsub(name, "^%s*%-?%s*", "")
    if show and ___MOD.string.find(___MOD.string.lower(name), query, 1, true) ~= nil then
      entity.SpriteGUIRendererComponent.ImageRUID = self.searchItemMatchBgRuid
      entity.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
    else
      entity.SpriteGUIRendererComponent.Color = ___MOD.FastColor(1, 1, 1, 0)
    end
  elseif line.type == "search_item" then
    entity.SpriteGUIRendererComponent.ImageRUID = self.searchItemMatchBgRuid
    entity.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
  else
    local selected = self.selectedSearchEntryByMap[self.currentSearchMapId]
    local isSelected = selected ~= nil and selected.type == line.type and selected.id == line.id
    if isSelected then
      local selectedRuid = line.type == "npc" and self.searchNpcSelectedBgRuid or self.searchMobSelectedBgRuid
      entity.SpriteGUIRendererComponent.ImageRUID = selectedRuid
      entity.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
    else
      entity.SpriteGUIRendererComponent.Color = ___MOD.FastColor(1, 1, 1, 0)
    end
  end
  button = entity.ButtonComponent
  if enableClick then
    if button ~= nil then
      button.Enable = true
    end
    entry.clickEvent = entity:ConnectEvent(___MOD.ButtonClickEvent, function()
      if line.type == "monster" then
        self:setSelectedSearchEntry(self.currentSearchMapId, "monster", line.id)
        self:toggleMonsterExpand(line.id)
      elseif line.type == "npc" then
        self:setSelectedSearchEntry(self.currentSearchMapId, "npc", line.id)
        self:showMapMonsterList(self.currentSearchMapId)
      end
    end)
  elseif button ~= nil then
    button.Enable = false
  end
  entity:SetEnable(true)
end

function WorldMapManager.setSearchLoading(self, show)
  if self.searchPanel == nil then
    return
  end
  local bg = self.searchBackground
  if bg == nil then
    bg = self.searchPanel:GetChildByName("backgrnd_1")
    self.searchBackground = bg
  end
  if bg == nil then
    return
  end
  local loading = self.searchLoadingEntity
  if loading == nil then
    loading = bg:GetChildByName("Loading")
    self.searchLoadingEntity = loading
  end
  if loading ~= nil then
    loading.Enable = show
  end
  if self.searchListRoot ~= nil then
    self.searchListRoot.Enable = not show
  end
  local scrollRoot = self.searchScrollRoot
  if scrollRoot == nil and self.searchPanel ~= nil then
    scrollRoot = self.searchPanel:GetChildByName("Scroll")
    self.searchScrollRoot = scrollRoot
  end
  if scrollRoot ~= nil then
    scrollRoot.Enable = not show
  end
end

function WorldMapManager.setSelectedSearchEntry(self, mapId, entryType, entryId)
  if mapId == 0 or ___MOD._UtilLogic:IsNilorEmptyString(entryType) then
    return
  end
  self.selectedSearchEntryByMap[mapId] = {type = entryType, id = entryId}
end

function WorldMapManager.showMapMonsterList(self, mapId)
  self:ensureRewardCache()
  self:ensureSearchListUI()
  if #self.searchItem_pool == 0 then
    return
  end
  if self.searchOverrideActive and mapId == 0 then
    mapId = -1
  elseif self.searchOverrideActive and 0 < mapId then
    self.searchOverrideActive = false
    self.searchOverrideLines = {}
  end
  if 0 < mapId then
    self.lastMapSearchId = mapId
  end
  if self.currentSearchMapId ~= mapId then
    self.searchScrollIndex = 0
  end
  self.currentSearchMapId = mapId
  local lines = self:buildSearchLines(mapId)
  local maxItems = #self.searchItem_pool
  local visibleCount = maxItems
  if self.searchListRoot ~= nil then
    local rootRect = self.searchListRoot.UITransformComponent.RectSize
    local usableHeight = (rootRect and rootRect.y or 0) - self.searchTopPadding
    if 0 < usableHeight and 0 < self.searchLineHeight then
      visibleCount = ___MOD.math.max(1, ___MOD.math.min(maxItems, ___MOD.math.floor(usableHeight / self.searchLineHeight)))
    end
  end
  self.searchScrollMax = ___MOD.math.max(0, #lines - visibleCount)
  if self.searchScrollIndex > self.searchScrollMax then
    self.searchScrollIndex = self.searchScrollMax
  end
  self:updateSearchScrollUI()
  if self.searchScrollRoot ~= nil and self.searchScrollRoot.WorldMapSearchScrollComponent ~= nil then
    self.searchScrollRoot.WorldMapSearchScrollComponent:updateBarPosition()
  end
  local display = {}
  for i = 1, visibleCount do
    display[i] = lines[self.searchScrollIndex + i]
  end
  for i = 1, #self.searchItem_pool do
    local entry = self.searchItem_pool[i]
    local line = display[i]
    if line ~= nil then
      self:setSearchItem(entry, line)
    else
      self:hideSearchItem(entry)
    end
  end
end

function WorldMapManager.showPath(self, RUID, pos)
  if ___MOD._UtilLogic:IsNilorEmptyString(RUID) then
    return
  end
  local path = self.mapPath
  if path == nil then
    return
  end
  local transform = path.UITransformComponent
  transform.anchoredPosition = pos
  ___MOD._UpdateManager:insertUpdateEnable(path)
end

function WorldMapManager.showWorldMap(self, imgName)
  if ___MOD._AranLogic:isBlockedIntroWindow("WorldMap") then
    return
  end
  local worldMap = ___MOD._MapManager.worldMap[imgName]
  if worldMap == nil then
    ___MOD.log("존재하지 않는 img입니다.", imgName)
    return
  end
  local currentMapId = ___MOD._MapUtils:getMapIdByName(___MOD._UserService.LocalPlayer.CurrentMapName)
  if self.escapeEvent == nil then
    self.escapeEvent = ___MOD._InputService:ConnectEvent(___MOD.KeyDownEvent, self.onEscapeKeyDown)
  end
  if not self.mouseClickEvent then
    self.mouseClickEvent = ___MOD._InputService:ConnectEvent(___MOD.KeyReleaseEvent, self.onMouseRightClick)
  end
  self.currentWorldMap = worldMap
  self.searchRequestToken = (self.searchRequestToken or 0) + 1
  self.searchOverrideActive = false
  self.searchOverrideQuery = ""
  self.searchOverrideLines = {}
  self.expandedMonstersByMap = {}
  self.selectedSearchEntryByMap = {}
  self.lastMapSearchId = 0
  self.searchScrollIndex = 0
  self.searchScrollMax = 0
  self.searchScrollBarPressed = false
  self.searchPanelHovered = false
  self:setSearchLoading(false)
  self.currentSearchMapId = 0
  for i = 1, #self.searchItem_pool do
    local entry = self.searchItem_pool[i]
    if entry ~= nil and entry.entity ~= nil then
      entry.entity:SetEnable(false)
    end
  end
  if self.searchInputField ~= nil then
    if self.searchInputField.TextInputComponent ~= nil then
      self.searchInputField.TextInputComponent.Text = ""
    end
    if self.searchInputField.TextGUIRendererInputComponent ~= nil then
      self.searchInputField.TextGUIRendererInputComponent.Text = ""
    end
    if self.searchInputField.TextComponent ~= nil then
      self.searchInputField.TextComponent.Text = ""
    end
    if self.searchInputField.TextGUIRendererComponent ~= nil then
      self.searchInputField.TextGUIRendererComponent.Text = ""
    end
  end
  self.curPos:SetEnable(false)
  for i = 1, #self.mapSpot_pool do
    local spot = self.mapSpot_pool[i]
    spot:SetEnable(false)
  end
  for i = 1, #self.mapLink_pool do
    local link = self.mapLink_pool[i]
    link:SetEnable(false)
  end
  if self.mapPath == nil then
    local emptySprite = ___MOD._EntryService:GetModelIdByName("Model_WorldMapPath")
    local path = ___MOD._SpawnService:SpawnByModelId(emptySprite, "path", ___MOD.FastVector3.zero:Clone(), self.mapSpot_parent)
    self.mapPath = path
  end
  self.mapPath:SetEnable(false)
  if worldMap.BaseImg ~= nil then
    self.backgrnd.SpriteGUIRendererComponent.ImageRUID = worldMap.BaseImg.ruid
  end
  if worldMap.MapList ~= nil then
    local curPos
    local mapList = worldMap.MapList
    local needSpawn = #mapList - #self.mapSpot_pool
    for i = 1, needSpawn do
      local spot = ___MOD._SpawnService:SpawnByModelId(self.mapSpot_model, "spot", ___MOD.FastVector3.zero:Clone(), self.mapSpot_parent)
      local worldMapSpot = spot.WorldMapSpotComponent
      spot:ConnectEvent(___MOD.UITouchEnterEvent, worldMapSpot.onTouchEnter)
      spot:ConnectEvent(___MOD.UITouchExitEvent, worldMapSpot.onTouchExit)
      spot:ConnectEvent(___MOD.UITouchUpEvent, worldMapSpot.onTouchUp)
      ___MOD.table.insert(self.mapSpot_pool, spot)
    end
    for i = 1, #mapList do
      local mapPoint = mapList[i]
      local type = mapPoint.type
      local path = ___MOD.string.format("Map.MapHelper.worldMap.mapImage.%d", type)
      local RUID = ___MOD.__RUIDManager:get(path)
      local spotPos = mapPoint.spot
      local spot = self.mapSpot_pool[i]
      spot.UITransformComponent.RectSize = self.mapSpot_rectSize_cache[type + 1]
      spot.UITransformComponent.anchoredPosition = spotPos
      spot.SpriteGUIRendererComponent.ImageRUID = RUID
      local mapPath = mapPoint.path
      local mapPathRUID = mapPath.ruid or ""
      local mapPathRect = mapPath.size
      local mapPathOrigin = mapPath.origin
      local worldmapSpot = spot.WorldMapSpotComponent
      worldmapSpot:setPath(mapPathRUID, mapPathRect, mapPathOrigin)
      worldmapSpot:setMapId(mapPoint.mapNo and mapPoint.mapNo[1] or 0)
      local tooltip = spot.TooltipComponent
      tooltip.worldMap_title = mapPoint.title or ""
      tooltip.worldMap_desc = mapPoint.title or ""
      tooltip.id = mapPoint.mapNo and mapPoint.mapNo[1] or 0
      if curPos == nil then
        local count = mapPoint.mapNo and #mapPoint.mapNo or 0
        for i = 1, count do
          if mapPoint.mapNo[i] == currentMapId then
            curPos = spotPos
            break
          end
        end
      end
    end
    if curPos ~= nil then
      self.curPos.UITransformComponent.anchoredPosition = curPos
      self.curPos:SetEnable(true)
    end
    for i = 1, #mapList do
      local spot = self.mapSpot_pool[i]
      spot:SetEnable(true)
    end
  end
  if worldMap.MapLink ~= nil then
    local mapLink = worldMap.MapLink
    local needSpawn = #mapLink - #self.mapLink_pool
    for i = 1, needSpawn do
      local link = ___MOD._SpawnService:SpawnByModelId(self.mapLink_model, "link", ___MOD.FastVector3.zero:Clone(), self.mapLink_parent)
      local worldMapLink = link.WorldMapLinkComponent
      link:ConnectEvent(___MOD.UITouchUpEvent, worldMapLink.onTouchUp)
      link:ConnectEvent(___MOD.UITouchEnterEvent, worldMapLink.onTouchEnter)
      link:ConnectEvent(___MOD.UITouchExitEvent, worldMapLink.onTouchExit)
      ___MOD.table.insert(self.mapLink_pool, link)
    end
    for i = 1, #mapLink do
      local node = mapLink[i] and mapLink[i].link or nil
      if node ~= nil then
        local linkMap = node.linkMap
        local linkImg = node.linkImg
        local RUID = linkImg.ruid
        local origin = linkImg.origin
        local size = linkImg.size
        local link = self.mapLink_pool[i]
        link.UITransformComponent.RectSize = size
        link.UITransformComponent.anchoredPosition = origin
        local worldMapLink = link.WorldMapLinkComponent
        worldMapLink:set(RUID, linkMap)
      end
    end
    for i = 1, #mapLink do
      local link = self.mapLink_pool[i]
      link:SetEnable(true)
    end
  end
  if not self.worldMap.EnabledInHierarchy then
    ___MOD._UIWindowLogic:enableUI(self.worldMap)
  end
  self:updateSearchScrollUI()
  if currentMapId ~= nil and 0 < currentMapId then
    self:showMapMonsterList(currentMapId)
  end
end

function WorldMapManager.toggleMonsterExpand(self, mobId)
  if self.currentSearchMapId == 0 then
    return
  end
  local expanded = self.expandedMonstersByMap[self.currentSearchMapId]
  if expanded == nil then
    expanded = {}
    self.expandedMonstersByMap[self.currentSearchMapId] = expanded
  end
  local nextState = expanded[mobId] ~= true
  for id, _ in ___MOD.pairs(expanded) do
    expanded[id] = nil
  end
  if nextState then
    expanded[mobId] = true
  end
  self:showMapMonsterList(self.currentSearchMapId)
end

function WorldMapManager.updateSearchScrollUI(self)
  if self.searchScrollRoot == nil then
    return
  end
  local enableScroll = self.currentSearchMapId ~= 0 and 0 < self.searchScrollMax
  if self.searchScrollVisible ~= enableScroll then
    self.searchScrollVisible = enableScroll
  end
  self.searchScrollRoot.Enable = enableScroll
  if self.searchScrollPrev ~= nil and self.searchScrollPrev.ButtonComponent ~= nil then
    self.searchScrollPrev.ButtonComponent.Enable = enableScroll and 0 < self.searchScrollIndex
  end
  if self.searchScrollNext ~= nil and self.searchScrollNext.ButtonComponent ~= nil then
    self.searchScrollNext.ButtonComponent.Enable = enableScroll and self.searchScrollIndex < self.searchScrollMax
  end
  if self.searchScrollBar ~= nil then
    if self.searchScrollBar.ButtonComponent ~= nil then
      self.searchScrollBar.ButtonComponent.Enable = enableScroll
    end
    if self.searchScrollBar.UIButtonComponent ~= nil then
      self.searchScrollBar.UIButtonComponent.Enable = enableScroll
    end
  end
end
