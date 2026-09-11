

function UserListUILogic.bindBlacklistActionButtons(self)
  local addButton = self.blacklistAddButton
  if ___MOD.isvalid(addButton) then
    addButton:SetEnable(true)
    if addButton.UIButtonComponent == nil and addButton.UITouchReceiveComponent == nil then
      addButton:AddComponent(___MOD.UITouchReceiveComponent)
    end
    if addButton.UIButtonComponent ~= nil then
      addButton.UIButtonComponent.Enable = true
    end
    if addButton.ButtonComponent ~= nil then
      addButton.ButtonComponent.Enable = true
    end
    if self._T.blacklistAddBoundId ~= addButton.Id then
      addButton:ConnectEvent(___MOD.ButtonClickEvent, function()
        self:onClickBlacklistBtAdd()
      end)
      addButton:ConnectEvent(___MOD.UITouchDownEvent, function()
        self:onClickBlacklistBtAdd()
      end)
      addButton:ConnectEvent(___MOD.UITouchUpEvent, function()
        self:onClickBlacklistBtAdd()
      end)
      self._T.blacklistAddBoundId = addButton.Id
    end
  end
  local removeButton = self.blacklistRemoveButton
  if ___MOD.isvalid(removeButton) then
    removeButton:SetEnable(true)
    if removeButton.UIButtonComponent == nil and removeButton.UITouchReceiveComponent == nil then
      removeButton:AddComponent(___MOD.UITouchReceiveComponent)
    end
    if removeButton.UIButtonComponent ~= nil then
      removeButton.UIButtonComponent.Enable = true
    end
    if removeButton.ButtonComponent ~= nil then
      removeButton.ButtonComponent.Enable = true
    end
    if self._T.blacklistRemoveBoundId ~= removeButton.Id then
      removeButton:ConnectEvent(___MOD.ButtonClickEvent, function()
        self:onClickBlacklistBtRemove()
      end)
      removeButton:ConnectEvent(___MOD.UITouchDownEvent, function()
        self:onClickBlacklistBtRemove()
      end)
      removeButton:ConnectEvent(___MOD.UITouchUpEvent, function()
        self:onClickBlacklistBtRemove()
      end)
      self._T.blacklistRemoveBoundId = removeButton.Id
    end
  end
end

function UserListUILogic.bindBlacklistActionButtonsOnBeginPlay(self)
  local maxTry = 20
  for i = 1, maxTry do
    self:resolveBlacklistViewRefs()
    self:bindBlacklistActionButtons()
    local addBound = ___MOD.isvalid(self.blacklistAddButton) and self._T.blacklistAddBoundId == self.blacklistAddButton.Id
    local removeReady = not ___MOD.isvalid(self.blacklistRemoveButton) or self._T.blacklistRemoveBoundId == self.blacklistRemoveButton.Id
    if addBound and removeReady then
      return
    end
    ___MOD.wait(0.05)
  end
end

function UserListUILogic.bindBlacklistScrollEvents(self)
  local function bindButton(buttonEntity, onClick)
    if not ___MOD.isvalid(buttonEntity) then
      return
    end
    if buttonEntity.UIButtonComponent == nil and buttonEntity.UITouchReceiveComponent == nil then
      buttonEntity:AddComponent(___MOD.UITouchReceiveComponent)
    end
    if buttonEntity.UIButtonComponent ~= nil then
      buttonEntity:ConnectEvent(___MOD.ButtonClickEvent, onClick)
    else
      buttonEntity:ConnectEvent(___MOD.UITouchDownEvent, onClick)
    end
  end

  bindButton(self.blacklistScrollPrev, function()
    self:onClickBlacklistScrollPrev()
  end)
  bindButton(self.blacklistScrollNext, function()
    self:onClickBlacklistScrollNext()
  end)
  if ___MOD.isvalid(self.blacklistScrollRoot) and self.blacklistScrollRoot.UITouchReceiveComponent == nil and self.blacklistScrollRoot.UIButtonComponent == nil then
    self.blacklistScrollRoot:AddComponent(___MOD.UITouchReceiveComponent)
  end
  if ___MOD.isvalid(self.blacklistScrollBar) then
    if self.blacklistScrollBar.UIButtonComponent == nil and self.blacklistScrollBar.UITouchReceiveComponent == nil then
      self.blacklistScrollBar:AddComponent(___MOD.UITouchReceiveComponent)
    end
    if self.blacklistScrollBar.UIButtonComponent ~= nil then
      self.blacklistScrollBar:ConnectEvent(___MOD.ButtonStateChangeEvent, function(event)
        if event.state == ___MOD.ButtonState.Pressed then
          self.blacklistClickScrollBar = true
        elseif event.state == ___MOD.ButtonState.Released then
          self.blacklistClickScrollBar = false
        end
      end)
    else
      self.blacklistScrollBar:ConnectEvent(___MOD.UITouchDownEvent, function()
        self.blacklistClickScrollBar = true
      end)
      self.blacklistScrollBar:ConnectEvent(___MOD.UITouchUpEvent, function()
        self.blacklistClickScrollBar = false
      end)
    end
  end
  self:updateBlacklistScrollMetric()
end

function UserListUILogic.bindBlacklistSlotEvents(self)
  self.blacklistSlotIndexMap = {}
  for i, slot in ___MOD.ipairs(self.blacklistSlots) do
    if ___MOD.isvalid(slot) then
      self.blacklistSlotIndexMap[slot.Id] = i
      local targetIndex = i
      if slot.UITouchReceiveComponent == nil and slot.UIButtonComponent == nil then
        slot:AddComponent(___MOD.UITouchReceiveComponent)
      end
      if slot.UIButtonComponent ~= nil then
        slot:ConnectEvent(___MOD.ButtonClickEvent, function()
          self:onClickBlacklistSlot(targetIndex)
        end)
      else
        slot:ConnectEvent(___MOD.UITouchDownEvent, function()
          self:onClickBlacklistSlot(targetIndex)
        end)
      end
    end
  end
end

function UserListUILogic.bindUserListTabTargets(self)
  local function setTarget(tabInfo, targetName)
    if tabInfo == nil or not ___MOD.isvalid(tabInfo.tab) then
      return
    end
    local tabComponent = tabInfo.tab.UserListTabComponent
    if tabComponent ~= nil then
      tabComponent.target = targetName
    end
  end

  setTarget(self.userList.Friend, "Friend")
  setTarget(self.userList.Party, "Party")
  setTarget(self.userList.Guild, "Guild")
  setTarget(self.userList.Blacklist, "Blacklist")
end

function UserListUILogic.changeTab(self, toTabName)
  if not self.userListInitialized then
    self:OnBeginPlay()
  end
  toTabName = self:normalizeTabName(toTabName)
  if toTabName == "Guild" and ___MOD._WorldConstants.canEnterGuild ~= true then
    if ___MOD._UINotice ~= nil then
      ___MOD._UINotice:showAlertUI("길드 이용이 일시적으로 제한됩니다.\r\n\r\n잠시 후 다시 시도해 주세요.")
    end
    return
  end
  if self.currentTab == toTabName then
    return
  end
  local ui = self.userList[toTabName]
  if ui then
    self.currentTab = toTabName
    ui.view:SetEnable(true)
    ui.tab.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get("UI.UIWindow.Item.New.Tab1.0")
    for key, value in ___MOD.pairs(self.userList) do
      if key ~= toTabName then
        ui = value
        ui.view:SetEnable(false)
        ui.tab.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get("UI.UIWindow.Item.New.Tab0.0")
      end
    end
    if toTabName == "Blacklist" then
      self:renderBlackList()
    elseif toTabName == "Guild" then
      self:renderGuild()
    end
  end
end

function UserListUILogic.changeTabByTabButton(self)
  if not self.userListInitialized then
    self:OnBeginPlay()
  end
  local order = {
    "Friend",
    "Party",
    "Guild",
    "Blacklist"
  }
  local current = self:normalizeTabName(self.currentTab)
  local currentIndex = 1
  for i, tabName in ___MOD.ipairs(order) do
    if tabName == current then
      currentIndex = i
      break
    end
  end
  for offset = 1, #order do
    local nextIndex = (currentIndex - 1 + offset) % #order + 1
    local nextTabName = order[nextIndex]
    if self.userList[nextTabName] ~= nil then
      self:changeTab(nextTabName)
      return
    end
  end
end

function UserListUILogic.collectBlacklistSlots(self)
  self.blacklistSlots = {}
  if not ___MOD.isvalid(self.blacklistLayout) then
    return
  end
  for _, child in ___MOD.pairs(self.blacklistLayout.Children) do
    if ___MOD.isvalid(child) and ___MOD.type(child.Name) == "string" then
      local nameEntity = child:GetChildByName("Name")
      local levelEntity = child:GetChildByName("Level")
      if ___MOD.isvalid(nameEntity) and ___MOD.isvalid(levelEntity) then
        ___MOD.table.insert(self.blacklistSlots, child)
      end
    end
  end
  self:sortBlacklistSlotsByName()
end

function UserListUILogic.ensureBlacklistActionButtonsEnabled(self)
  if ___MOD.isvalid(self.blacklistAddButton) then
    self.blacklistAddButton:SetEnable(true)
    if self.blacklistAddButton.UIButtonComponent ~= nil then
      self.blacklistAddButton.UIButtonComponent.Enable = true
    end
    if self.blacklistAddButton.ButtonComponent ~= nil then
      self.blacklistAddButton.ButtonComponent.Enable = true
    end
  end
  if ___MOD.isvalid(self.blacklistRemoveButton) then
    self.blacklistRemoveButton:SetEnable(true)
    if self.blacklistRemoveButton.UIButtonComponent ~= nil then
      self.blacklistRemoveButton.UIButtonComponent.Enable = true
    end
    if self.blacklistRemoveButton.ButtonComponent ~= nil then
      self.blacklistRemoveButton.ButtonComponent.Enable = true
    end
  end
end

function UserListUILogic.ensureBlacklistSlotCapacity(self, targetCount)
  if not ___MOD.isvalid(self.blacklistLayout) then
    return
  end
  if targetCount <= 0 then
    return
  end
  if targetCount <= #self.blacklistSlots then
    return
  end
  local template = self.blacklistSlots[1]
  if not ___MOD.isvalid(template) then
    return
  end
  for i = #self.blacklistSlots + 1, targetCount do
    local cloned = ___MOD._SpawnService:SpawnByEntity(template, "OnlineMember" .. ___MOD.tostring(i), ___MOD.FastVector3.zero:Clone(), self.blacklistLayout, true)
    if not ___MOD.isvalid(cloned) then
      break
    end
    ___MOD.table.insert(self.blacklistSlots, cloned)
  end
  self:sortBlacklistSlotsByName()
end

function UserListUILogic.findBlacklistScrollRoot(self, root)
  if not ___MOD.isvalid(root) then
    return nil
  end
  local stack = {root}
  while 0 < #stack do
    local cur = stack[#stack]
    stack[#stack] = nil
    if ___MOD.isvalid(cur) then
      if cur.Name == "Scroll" then
        local prev = cur:GetChildByName("prev")
        local next = cur:GetChildByName("next")
        local bar = cur:GetChildByName("bar")
        if ___MOD.isvalid(prev) and ___MOD.isvalid(next) and ___MOD.isvalid(bar) then
          return cur
        end
      end
      for _, child in ___MOD.pairs(cur.Children) do
        if ___MOD.isvalid(child) then
          stack[#stack + 1] = child
        end
      end
    end
  end
  return nil
end

function UserListUILogic.getBlacklistNowText(self)
  local kst = ___MOD.DateTime.UtcNow + ___MOD.TimeSpan.FromHours(9)
  local dateText = ___MOD.string.format("%04d-%02d-%02d", kst.Year, kst.Month, kst.Day)
  return {date = dateText}
end

function UserListUILogic.getChildByPath(self, root, childPath)
  if not ___MOD.isvalid(root) then
    return nil
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(childPath) then
    return nil
  end
  local cur = root
  for part in ___MOD.string.gmatch(childPath, "[^/]+") do
    if not ___MOD.isvalid(cur) then
      return nil
    end
    cur = cur:GetChildByName(part)
  end
  return cur
end

function UserListUILogic.getNormalizedBlackList(self)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil or user.Account == nil then
    return {}
  end
  local src = user.Account.BlackList
  if ___MOD.type(src) ~= "table" then
    return {}
  end
  local list = {}
  for key, row in ___MOD.pairs(src) do
    local idxNum = ___MOD.tonumber(key) or 0
    if ___MOD.type(row) == "table" and not ___MOD._UtilLogic:IsNilorEmptyString(row.name) then
      list[#list + 1] = {
        name = row.name,
        date = row.date or "",
        ts = ___MOD.tonumber(row.ts or 0) or 0,
        idx = idxNum
      }
    end
  end
  ___MOD.table.sort(list, function(a, b)
    if a.ts ~= b.ts then
      return a.ts > b.ts
    end
    return a.idx < b.idx
  end)
  while #list > self.blacklistSlotLimit do
    ___MOD.table.remove(list, #list)
  end
  return list
end

function UserListUILogic.hideBlacklistEmptyText(self)
  if not ___MOD.isvalid(self.blacklistView) then
    return
  end
  local stack = {
    self.blacklistView
  }
  while 0 < #stack do
    local cur = stack[#stack]
    stack[#stack] = nil
    if ___MOD.isvalid(cur) then
      if cur.BitmapFontRendererComponent ~= nil then
        local t = ___MOD.tostring(cur.BitmapFontRendererComponent.text or "")
        if t == "없음" then
          cur:SetEnable(false)
        end
      elseif cur.TextComponent ~= nil then
        local t = ___MOD.tostring(cur.TextComponent.Text or "")
        if t == "없음" then
          cur:SetEnable(false)
        end
      end
      for _, child in ___MOD.pairs(cur.Children) do
        if ___MOD.isvalid(child) then
          stack[#stack + 1] = child
        end
      end
    end
  end
end

function UserListUILogic.isBlacklistTabActive(self)
  return self.currentTab == "Blacklist"
end

function UserListUILogic.isCursorInBlacklistArea(self)
  if ___MOD.isvalid(self.blacklistView) and ___MOD._UIWindowLogic:equalsHoverdUI(self.blacklistView) then
    return true
  end
  if ___MOD.isvalid(self.blacklistLayout) and ___MOD._UIWindowLogic:equalsHoverdUI(self.blacklistLayout) then
    return true
  end
  if ___MOD.isvalid(self.userListUI) and ___MOD._UIWindowLogic:equalsHoverdUI(self.userListUI) then
    return true
  end
  return false
end

function UserListUILogic.isCursorInBlacklistTouchArea(self)
  if self.blacklistTouchAreaHovered then
    return true
  end
  if ___MOD.isvalid(self.blacklistTouchArea) and ___MOD._UIWindowLogic:equalsHoverdUI(self.blacklistTouchArea) then
    return true
  end
  return self:isCursorInBlacklistArea()
end

function UserListUILogic.normalizeTabName(self, tabName)
  if tabName == "BlackList" then
    return "Blacklist"
  end
  return tabName
end

function UserListUILogic.OnBeginPlay(self)
  if self.userListInitialized then
    return
  end
  local userListUI = ___MOD._EntityService:GetEntity("503394f3-1410-4a40-a8a5-e719939b88e9")
  self.userListUI = userListUI
  local tab = ___MOD._EntityService:GetEntity("0eba7b36-227b-4542-8846-3f71f6695718")
  if not ___MOD.isvalid(userListUI) or not ___MOD.isvalid(tab) then
    return
  end
  self.userList.Friend = {
    view = userListUI:GetChildByName("Friend"),
    tab = tab:GetChildByName("0")
  }
  self.userList.Party = {
    view = userListUI:GetChildByName("Party"),
    tab = tab:GetChildByName("1")
  }
  self.userList.Guild = {
    view = userListUI:GetChildByName("Guild"),
    tab = tab:GetChildByName("2")
  }
  local blacklistView = userListUI:GetChildByName("BlackList")
  if not ___MOD.isvalid(blacklistView) then
    blacklistView = userListUI:GetChildByName("Blacklist")
  end
  local blacklistTab = tab:GetChildByName("3")
  if ___MOD.isvalid(blacklistView) and ___MOD.isvalid(blacklistTab) then
    self.userList.Blacklist = {view = blacklistView, tab = blacklistTab}
  end
  self:bindUserListTabTargets()
  self.blacklistView = blacklistView
  self:resolveBlacklistViewRefs()
  self.blacklistOnlinePlayersText = self:getChildByPath(blacklistView, "layout/Title/OnlinePlayers/text")
  if not ___MOD.isvalid(self.blacklistOnlinePlayersText) and ___MOD.isvalid(blacklistView) then
    self.blacklistOnlinePlayersText = self:getChildByPath(blacklistView, "layout/Title/OnlinePlayers")
  end
  if not ___MOD.isvalid(self.blacklistOnlinePlayersText) and ___MOD.isvalid(blacklistView) then
    self.blacklistOnlinePlayersText = self:getChildByPath(blacklistView, "layout/Tile/OnlinePlayers")
  end
  if not ___MOD.isvalid(self.blacklistOnlinePlayersText) and ___MOD.isvalid(blacklistView) then
    self.blacklistOnlinePlayersText = blacklistView:GetChildByName("OnlinePlayers")
  end
  if not ___MOD.isvalid(self.blacklistOnlinePlayersText) and ___MOD.isvalid(blacklistView) then
    self.blacklistOnlinePlayersText = blacklistView:GetChildByName("onlinePlayers")
  end
  self.blacklistTouchArea = ___MOD.isvalid(self.blacklistLayout) and self.blacklistLayout or blacklistView
  self.blacklistTouchAreaHovered = false
  if ___MOD.isvalid(self.blacklistTouchArea) and (self.blacklistTouchArea.UITouchReceiveComponent ~= nil or self.blacklistTouchArea.UIButtonComponent ~= nil) then
    self.blacklistTouchArea:ConnectEvent(___MOD.UITouchEnterEvent, function()
      self.blacklistTouchAreaHovered = true
    end)
    self.blacklistTouchArea:ConnectEvent(___MOD.UITouchExitEvent, function()
      self.blacklistTouchAreaHovered = false
    end)
  end
  self.blacklistScrollRoot = self:getChildByPath(userListUI, "Blacklist/Scroll")
  if not ___MOD.isvalid(self.blacklistScrollRoot) then
    self.blacklistScrollRoot = self:findBlacklistScrollRoot(blacklistView)
  end
  self.blacklistScrollPrev = ___MOD.isvalid(self.blacklistScrollRoot) and self.blacklistScrollRoot:GetChildByName("prev") or nil
  self.blacklistScrollNext = ___MOD.isvalid(self.blacklistScrollRoot) and self.blacklistScrollRoot:GetChildByName("next") or nil
  self.blacklistScrollBar = ___MOD.isvalid(self.blacklistScrollRoot) and self.blacklistScrollRoot:GetChildByName("bar") or nil
  if not ___MOD.isvalid(self.blacklistScrollRoot) then
    ___MOD.log_warning("[Blacklist] Scroll root not found")
  end
  if not ___MOD.isvalid(self.blacklistRemoveButton) and ___MOD.isvalid(blacklistView) then
    self.blacklistRemoveButton = blacklistView:GetChildByName("BtDelete")
  end
  self.selectedBlacklistIndex = 0
  self.blacklistScrollIndex = 0
  self:collectBlacklistSlots()
  self:ensureBlacklistSlotCapacity(self.blacklistVisibleSlotCount)
  self:bindBlacklistSlotEvents()
  self:bindBlacklistScrollEvents()
  self:renderBlackList()
  if self.blacklistMouseScrollEvent == nil then
    self.blacklistMouseScrollEvent = ___MOD._InputService:ConnectEvent(___MOD.MouseScrollEvent, function(event)
      self:onBlacklistMouseScroll(event)
    end)
  end
  if self.blacklistMouseMoveEvent == nil then
    self.blacklistMouseMoveEvent = ___MOD._InputService:ConnectEvent(___MOD.MouseMoveEvent, function(event)
      self:onBlacklistMouseMove(event)
    end)
  end
  self:bindBlacklistActionButtonsOnBeginPlay()
  self.userListInitialized = true
end

function UserListUILogic.onBlacklistMouseMove(self, event)
  if not self:isBlacklistTabActive() then
    return
  end
  if not self.blacklistClickScrollBar then
    return
  end
  if not ___MOD.isvalid(self.blacklistScrollPrev) or not ___MOD.isvalid(self.blacklistScrollBar) then
    return
  end
  local list = self:getNormalizedBlackList()
  local maxScroll = ___MOD.math.max(0, #list - self.blacklistVisibleSlotCount)
  if maxScroll <= 0 then
    self.blacklistClickScrollBar = false
    return
  end
  local index, barY = ___MOD._OffsetUtils:calcScrollByCursorPos(maxScroll, self.blacklistScrollYSize, self.blacklistBarBaseY, self.blacklistPrevBaseY, self.blacklistScrollPrev)
  self.blacklistScrollIndex = ___MOD.math.max(0, ___MOD.math.min(maxScroll, index))
  self.blacklistScrollBar.UITransformComponent.anchoredPosition.y = barY
  self:renderBlacklistRows(list)
end

function UserListUILogic.onBlacklistMouseScroll(self, event)
  if not self:isBlacklistTabActive() then
    return
  end
  if not self:isCursorInBlacklistTouchArea() then
    return
  end
  if not ___MOD.isvalid(self.blacklistView) or not self.blacklistView.EnabledInHierarchy then
    return
  end
  if ___MOD._UIWindowLogic:isCursorBlockedByHigherWindow(self.blacklistView) then
    return
  end
  local list = self:getNormalizedBlackList()
  local maxScroll = ___MOD.math.max(0, #list - self.blacklistVisibleSlotCount)
  if maxScroll <= 0 then
    self.blacklistScrollIndex = 0
    return
  end
  local delta = event.ScrollDelta
  if 0 < delta then
    self.blacklistScrollIndex = ___MOD.math.max(0, self.blacklistScrollIndex - 1)
  elseif delta < 0 then
    self.blacklistScrollIndex = ___MOD.math.min(maxScroll, self.blacklistScrollIndex + 1)
  else
    return
  end
  self:renderBlackList()
end

function UserListUILogic.onClickBlacklistBtAdd(self)
  if not self.userListInitialized then
    self:OnBeginPlay()
  end
  if self._T.blacklistAddClickBlockUntil ~= nil and ___MOD._UtilLogic.ElapsedSeconds < self._T.blacklistAddClickBlockUntil then
    return
  end
  self._T.blacklistAddClickBlockUntil = ___MOD._UtilLogic.ElapsedSeconds + 0.15
  ___MOD._UINotice:showInputUI("블랙리스트에 추가할 캐릭터 이름을 입력하세요.", "", function(base, name)
    local normalizedName = ___MOD.tostring(name or "")
    normalizedName = ___MOD.string.gsub(normalizedName, "^%s+", "")
    normalizedName = ___MOD.string.gsub(normalizedName, "%s+$", "")
    if ___MOD._UtilLogic:IsNilorEmptyString(normalizedName) then
      ___MOD._UINotice:showAlertUI("캐릭터 이름을 입력해주세요.")
      if ___MOD.isvalid(base) then
        base:Destroy()
      end
      return
    end
    if not ___MOD._CheckNameUtils:is_valid_name(normalizedName, false) then
      ___MOD._UINotice:showAlertUI("잘못된 캐릭터 이름입니다.")
      if ___MOD.isvalid(base) then
        base:Destroy()
      end
      return
    end
    local localPlayer = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(localPlayer) and ___MOD.isvalid(localPlayer.Player) and normalizedName == localPlayer.Player.Name then
      ___MOD._UINotice:showAlertUI("자기 자신은 블랙리스트에 추가할 수 없습니다.")
      if ___MOD.isvalid(base) then
        base:Destroy()
      end
      return
    end
    local nowText = self:getBlacklistNowText()
    local list = self:getNormalizedBlackList()
    for i = #list, 1, -1 do
      if list[i].name == normalizedName then
        ___MOD.table.remove(list, i)
      end
    end
    ___MOD.table.insert(list, 1, {
      name = normalizedName,
      date = nowText.date,
      ts = ___MOD.os.time()
    })
    while #list > self.blacklistSlotLimit do
      ___MOD.table.remove(list, #list)
    end
    if ___MOD.isvalid(localPlayer) and localPlayer.Account ~= nil then
      self.selectedBlacklistIndex = 1
      self.blacklistScrollIndex = 0
      self:setLocalPlayerBlackList(list)
      self:renderBlackList()
    end
    ___MOD._PlayerDataLogic:requestAddBlackList(normalizedName, nowText.date)
    if ___MOD.isvalid(base) then
      base:Destroy()
    end
  end, true)
end

function UserListUILogic.onClickBlacklistBtRemove(self)
  local list = self:getNormalizedBlackList()
  if self.selectedBlacklistIndex <= 0 or self.selectedBlacklistIndex > #list then
    ___MOD._UINotice:showAlertUI("삭제할 항목을 먼저 선택해주세요.")
    return
  end
  local target = list[self.selectedBlacklistIndex]
  ___MOD.table.remove(list, self.selectedBlacklistIndex)
  if self.selectedBlacklistIndex > #list then
    self.selectedBlacklistIndex = #list
  end
  self:setLocalPlayerBlackList(list)
  self:renderBlackList()
  if target ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(target.name) then
    ___MOD._PlayerDataLogic:requestRemoveBlackList(target.name)
  end
end

function UserListUILogic.onClickBlacklistScrollNext(self)
  local list = self:getNormalizedBlackList()
  local maxScroll = ___MOD.math.max(0, #list - self.blacklistVisibleSlotCount)
  if maxScroll <= 0 then
    return
  end
  self.blacklistScrollIndex = ___MOD.math.min(maxScroll, self.blacklistScrollIndex + 1)
  self:renderBlackList()
end

function UserListUILogic.onClickBlacklistScrollPrev(self)
  local list = self:getNormalizedBlackList()
  local maxScroll = ___MOD.math.max(0, #list - self.blacklistVisibleSlotCount)
  if maxScroll <= 0 then
    return
  end
  self.blacklistScrollIndex = ___MOD.math.max(0, self.blacklistScrollIndex - 1)
  self:renderBlackList()
end

function UserListUILogic.onClickBlacklistSlot(self, slotIndex)
  local list = self:getNormalizedBlackList()
  local dataIndex = self.blacklistScrollIndex + slotIndex
  if slotIndex <= 0 or slotIndex > self.blacklistVisibleSlotCount then
    return
  end
  if dataIndex <= 0 or dataIndex > #list then
    return
  end
  self.selectedBlacklistIndex = dataIndex
  self:renderBlackList()
end

function UserListUILogic.OnEndPlay(self)
  if self.blacklistMouseScrollEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.MouseScrollEvent, self.blacklistMouseScrollEvent)
    self.blacklistMouseScrollEvent = nil
  end
  if self.blacklistMouseMoveEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.MouseMoveEvent, self.blacklistMouseMoveEvent)
    self.blacklistMouseMoveEvent = nil
  end
  self.blacklistClickScrollBar = false
  self.blacklistTouchAreaHovered = false
end

function UserListUILogic.renderBlackList(self)
  local list = self:getNormalizedBlackList()
  if self.selectedBlacklistIndex > #list then
    self.selectedBlacklistIndex = #list
  end
  local maxScroll = ___MOD.math.max(0, #list - self.blacklistVisibleSlotCount)
  if maxScroll < self.blacklistScrollIndex then
    self.blacklistScrollIndex = maxScroll
  end
  if 0 > self.blacklistScrollIndex then
    self.blacklistScrollIndex = 0
  end
  self:updateBlacklistMembersText(#list, self.blacklistSlotLimit)
  self:updateBlacklistScrollUI(#list)
  self:renderBlacklistRows(list)
  self:ensureBlacklistActionButtonsEnabled()
end

function UserListUILogic.renderBlacklistRows(self, list)
  for i, slot in ___MOD.ipairs(self.blacklistSlots) do
    if ___MOD.isvalid(slot) then
      if i <= self.blacklistVisibleSlotCount then
        if #list == 0 then
          if i == 1 then
            self:setBlacklistSlotText(slot:GetChildByName("Name"), "없음")
            self:setBlacklistSlotText(slot:GetChildByName("Level"), "")
            self:setBlacklistSlotSelectVisual(slot, false)
            slot:SetEnable(true)
          else
            self:setBlacklistSlotText(slot:GetChildByName("Name"), "")
            self:setBlacklistSlotText(slot:GetChildByName("Level"), "")
            self:setBlacklistSlotSelectVisual(slot, false)
            slot:SetEnable(false)
          end
        else
          local rowIndex = self.blacklistScrollIndex + i
          local row = list[rowIndex]
          if row == nil then
            self:setBlacklistSlotText(slot:GetChildByName("Name"), "")
            self:setBlacklistSlotText(slot:GetChildByName("Level"), "")
            self:setBlacklistSlotSelectVisual(slot, false)
            slot:SetEnable(false)
          else
            self:setBlacklistSlotText(slot:GetChildByName("Name"), row.name or "")
            self:setBlacklistSlotText(slot:GetChildByName("Level"), row.date or "")
            slot:SetEnable(true)
            self:setBlacklistSlotSelectVisual(slot, self.selectedBlacklistIndex == rowIndex)
          end
        end
      else
        self:setBlacklistSlotText(slot:GetChildByName("Name"), "")
        self:setBlacklistSlotText(slot:GetChildByName("Level"), "")
        self:setBlacklistSlotSelectVisual(slot, false)
        slot:SetEnable(false)
      end
    end
  end
end

function UserListUILogic.renderGuild(self)
  local guild = ___MOD._GuildManager:getGuildEntity()
  if guild then
    local gnc = guild.GuildNoticeComponent
    if gnc then
      gnc:refreshGuildNoticeScroll()
      gnc:startGuildNoticeWatcher()
    end
  end
end

function UserListUILogic.resolveBlacklistViewRefs(self)
  local blacklistView = self.blacklistView
  if not ___MOD.isvalid(blacklistView) and ___MOD.isvalid(self.userListUI) then
    blacklistView = self.userListUI:GetChildByName("BlackList")
    if not ___MOD.isvalid(blacklistView) then
      blacklistView = self.userListUI:GetChildByName("Blacklist")
    end
    self.blacklistView = blacklistView
  end
  if ___MOD.isvalid(blacklistView) then
    self.blacklistLayout = blacklistView:GetChildByName("layout")
    if not ___MOD.isvalid(self.blacklistLayout) then
      self.blacklistLayout = blacklistView:GetChildByName("Layout")
    end
    if not ___MOD.isvalid(self.blacklistLayout) then
      self.blacklistLayout = blacklistView:GetChildByName("list")
    end
    if not ___MOD.isvalid(self.blacklistLayout) then
      self.blacklistLayout = blacklistView:GetChildByName("List")
    end
    if not ___MOD.isvalid(self.blacklistLayout) then
      self.blacklistLayout = blacklistView
    end
  else
    self.blacklistLayout = nil
  end
  self.blacklistAddButton = ___MOD.isvalid(blacklistView) and blacklistView:GetChildByName("BtAdd") or nil
  self.blacklistRemoveButton = ___MOD.isvalid(blacklistView) and blacklistView:GetChildByName("BtRemove") or nil
  if not ___MOD.isvalid(self.blacklistRemoveButton) and ___MOD.isvalid(blacklistView) then
    self.blacklistRemoveButton = blacklistView:GetChildByName("BtDelete")
  end
end

function UserListUILogic.setBlacklistSlotSelectVisual(self, slot, selected)
  if not ___MOD.isvalid(slot) then
    return
  end
  local toTextColor = selected and ___MOD.FastColor.white or ___MOD.FastColor.black
  local toBaseColor = selected and ___MOD.Color.FromHexCode("#4287BC") or ___MOD.FastColor.white
  local nameEntity = slot:GetChildByName("Name")
  local levelEntity = slot:GetChildByName("Level")
  self:setBlacklistTextColor(nameEntity, toTextColor)
  self:setBlacklistTextColor(levelEntity, toTextColor)
  if slot.SpriteGUIRendererComponent ~= nil then
    slot.SpriteGUIRendererComponent.Color = toBaseColor
  end
end

function UserListUILogic.setBlacklistSlotText(self, target, value)
  if not ___MOD.isvalid(target) then
    return
  end
  local safeValue = ""
  if value ~= nil then
    safeValue = ___MOD.tostring(value)
  end
  if target.BitmapFontRendererComponent ~= nil then
    target.BitmapFontRendererComponent.text = safeValue
    ___MOD.pcall(function()
      target.BitmapFontRendererComponent:drawText()
    end)
    return
  end
  if target.TextComponent ~= nil then
    target.TextComponent.Text = safeValue
  end
end

function UserListUILogic.setBlacklistTextColor(self, target, color)
  if not ___MOD.isvalid(target) then
    return
  end
  if target.BitmapFontRendererComponent ~= nil then
    target.BitmapFontRendererComponent.color = color
    ___MOD.pcall(function()
      target.BitmapFontRendererComponent:drawText()
    end)
    return
  end
end

function UserListUILogic.setLocalPlayerBlackList(self, list)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil or user.Account == nil then
    return
  end
  if ___MOD.type(list) ~= "table" then
    user.Account.BlackList = {}
    return
  end
  local cleaned = {}
  for _, row in ___MOD.ipairs(list) do
    if ___MOD.type(row) == "table" and not ___MOD._UtilLogic:IsNilorEmptyString(row.name) then
      cleaned[#cleaned + 1] = {
        name = row.name,
        date = row.date or "",
        ts = ___MOD.tonumber(row.ts or 0) or 0
      }
    end
    if #cleaned >= self.blacklistSlotLimit then
      break
    end
  end
  user.Account.BlackList = cleaned
end

function UserListUILogic.showUI(self, tabName)
  local e = ___MOD._EntityService:GetEntity("503394f3-1410-4a40-a8a5-e719939b88e9")
  if ___MOD._AranLogic:isBlockedIntroWindow("UserList") then
    if ___MOD.isvalid(e) and e.Enable then
      ___MOD._UIWindowLogic:enableUI(e)
    end
    return
  end
  if not self.userListInitialized then
    self:OnBeginPlay()
  end
  tabName = self:normalizeTabName(tabName)
  if self.userList[tabName] == nil then
    return
  end
  if tabName == "Guild" and ___MOD._WorldConstants.canEnterGuild ~= true then
    if ___MOD._UINotice ~= nil then
      ___MOD._UINotice:showAlertUI("길드 이용이 일시적으로 제한됩니다.\r\n\r\n잠시 후 다시 시도해 주세요.")
    end
    return
  end
  local prevTab = self.currentTab
  ___MOD._UserListUILogic:changeTab(tabName)
  if e.Enable and prevTab ~= tabName then
    return
  end
  ___MOD._UIWindowLogic:enableUI(e)
  if tabName == "Guild" and e.Enable then
    self:renderGuild()
  end
end

function UserListUILogic.sortBlacklistSlotsByName(self)
  ___MOD.table.sort(self.blacklistSlots, function(a, b)
    local aName = ___MOD.isvalid(a) and (a.Name or "") or ""
    local bName = ___MOD.isvalid(b) and (b.Name or "") or ""
    local aNum = ___MOD.tonumber(___MOD.string.match(aName, "(%d+)$")) or 999999
    local bNum = ___MOD.tonumber(___MOD.string.match(bName, "(%d+)$")) or 999999
    if aNum ~= bNum then
      return aNum < bNum
    end
    return aName < bName
  end)
end

function UserListUILogic.updateBlacklistMembersText(self, members, capacity)
  if not ___MOD.isvalid(self.blacklistOnlinePlayersText) then
    return
  end
  local text = ___MOD.string.format("%d/%d", members, capacity)
  if self.blacklistOnlinePlayersText.BitmapFontRendererComponent ~= nil then
    self.blacklistOnlinePlayersText.BitmapFontRendererComponent.text = text
    ___MOD.pcall(function()
      self.blacklistOnlinePlayersText.BitmapFontRendererComponent:drawText()
    end)
    return
  end
  if self.blacklistOnlinePlayersText.TextComponent ~= nil then
    self.blacklistOnlinePlayersText.TextComponent.Text = text
  end
end

function UserListUILogic.updateBlacklistScrollMetric(self)
  if not ___MOD.isvalid(self.blacklistScrollPrev) or self.blacklistScrollPrev.UITransformComponent == nil then
    return
  end
  if not ___MOD.isvalid(self.blacklistScrollBar) or self.blacklistScrollBar.UITransformComponent == nil then
    return
  end
  local prevY = self.blacklistScrollPrev.UITransformComponent.anchoredPosition.y
  local barY = self.blacklistScrollBar.UITransformComponent.anchoredPosition.y
  self.blacklistPrevBaseY = prevY
  self.blacklistBarBaseY = barY
end

function UserListUILogic.updateBlacklistScrollUI(self, listCount)
  local enableScroll = listCount > self.blacklistVisibleSlotCount

  local function setButtonEnabled(buttonEntity, enabled)
    if not ___MOD.isvalid(buttonEntity) then
      return
    end
    if buttonEntity.ButtonComponent ~= nil then
      buttonEntity.ButtonComponent.Enable = enabled
    end
    if buttonEntity.UIButtonComponent ~= nil then
      buttonEntity.UIButtonComponent.Enable = enabled
    end
  end

  if ___MOD.isvalid(self.blacklistScrollRoot) then
    self.blacklistScrollRoot:SetEnable(true)
  end
  setButtonEnabled(self.blacklistScrollPrev, enableScroll and self.blacklistScrollIndex > 0)
  local maxScroll = ___MOD.math.max(0, listCount - self.blacklistVisibleSlotCount)
  setButtonEnabled(self.blacklistScrollNext, enableScroll and maxScroll > self.blacklistScrollIndex)
  if ___MOD.isvalid(self.blacklistScrollBar) then
    if self.blacklistClickScrollBar then
      enableScroll = true
    end
    if self.blacklistBarEnabledState ~= enableScroll then
      self.blacklistScrollBar:SetEnable(enableScroll)
      self.blacklistBarEnabledState = enableScroll
    end
    if enableScroll and self.blacklistScrollBar.UITransformComponent ~= nil then
      local maxScroll = ___MOD.math.max(1, listCount - self.blacklistVisibleSlotCount)
      local ratio = self.blacklistScrollIndex / maxScroll
      self.blacklistScrollBar.UITransformComponent.anchoredPosition.y = self.blacklistBarBaseY - self.blacklistScrollYSize * ratio
    end
  end
end
