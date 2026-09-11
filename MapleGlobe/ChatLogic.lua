

function ChatLogic.activateChatField(self)
  if ___MOD._UtilLogic.ElapsedSeconds - self.lastTypingTime < 0.1 then
    return
  end
  if #___MOD._UINotice.noitceUIList > 0 then
    return
  end
  if ___MOD._TradingLogic.tradingRoom ~= nil then
    local inputField = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/TradingRoom/Chat")
    if not inputField.TextInputComponent.IsFocused then
      inputField.TextInputComponent:ActivateInputField()
    end
    return
  end
  if self:toggleMobileChatBoard(true) then
    return
  end
  local inputField = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/StatusBar/base/chatText")
  local e = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat")
  if not inputField.TextInputComponent.IsFocused then
    e.ChatLogComponent:activateChatTextField(true)
    inputField.TextInputComponent:ActivateInputField()
  end
end

function ChatLogic.addChatLog(self, messageType, message)
  self:addChatLog_(messageType, message, "")
end

function ChatLogic.addChatLog_(self, messageType, message, from)
  if messageType == ___MOD._ChatMessageType.Whisper and not ___MOD._UtilLogic:IsNilorEmptyString(from) then
    self.lastWhisperSender = from
  end
  local wrapSource = message or ""
  local itemMetaMarker
  if messageType == ___MOD._ChatMessageType.ItemSpeaker then
    wrapSource, itemMetaMarker = self:parseItemSpeakerMetaMarker(wrapSource)
  end
  local megaphoneChannel, megaphoneSenderName
  local hasMegaphoneMarker = self:isMegaphoneRenderMessage(messageType, wrapSource)
  if hasMegaphoneMarker then
    local parsedMessage
    parsedMessage, megaphoneChannel, megaphoneSenderName = self:parseMegaphoneRenderMessage(wrapSource)
    wrapSource = parsedMessage or ""
  end
  local useMobileChat = self:isMobileChatUIActive()
  if useMobileChat then
    local mobileSource = wrapSource
    if messageType == ___MOD._ChatMessageType.ItemSpeaker and not ___MOD._UtilLogic:IsNilorEmptyString(itemMetaMarker) then
      mobileSource = ___MOD.string.format("%s{#MIT:%s#}", mobileSource, itemMetaMarker)
    end
    self:updateMobileChatLatest(messageType, mobileSource, ___MOD.tonumber(megaphoneChannel) or 0)
    return
  end
  local EmptyChatLog = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyChatLog")
  local EmptyText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyEntity")
  local clp = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat").ChatLogComponent
  local p = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat/ChatLog")
  if clp.isMini then
    p = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat/ChatLog_mini")
  end
  local useMSWChatWrap = ___MOD._FontLogic.UseMSWFont and messageType ~= ___MOD._ChatMessageType.SpeakerWorldInstance
  local wrapWidth = self:getChatLogTextWidth() - 12
  if hasMegaphoneMarker and megaphoneChannel ~= nil then
    local megaphoneSpacingWidth = self:getChatLogWrapTextWidth("             ")
    wrapWidth = ___MOD.math.max(120, wrapWidth - megaphoneSpacingWidth)
  end
  local splitMessage
  if useMSWChatWrap then
    splitMessage = self:wrapChatLogMSWTextByWidth(wrapSource, wrapWidth)
  else
    splitMessage = self:wrapChatLogTextByWidth(wrapSource, wrapWidth)
  end
  local message_ = {}
  for i, line in ___MOD.ipairs(splitMessage) do
    message_[i] = line
  end
  if hasMegaphoneMarker and 0 < #message_ and megaphoneChannel ~= nil then
    local markerTag = ""
    if not ___MOD._UtilLogic:IsNilorEmptyString(megaphoneSenderName) then
      markerTag = ___MOD.string.format("{#MPN:%s#}", megaphoneSenderName)
    end
    message_[1] = ___MOD.string.format("%s#M%04d# %s", markerTag, megaphoneChannel, message_[1])
  end
  if messageType == ___MOD._ChatMessageType.ItemSpeaker and 0 < #message_ and not ___MOD._UtilLogic:IsNilorEmptyString(itemMetaMarker) then
    message_[1] = ___MOD.string.format("%s{#MIT:%s#}", message_[1], itemMetaMarker)
  end
  if #message_ <= 1 then
    clp:addSlotItem(messageType, message_[1] or "", nil)
  else
    local slotEntries = {}
    for i = 1, #message_ do
      ___MOD.table.insert(slotEntries, {
        messageType = messageType,
        message = message_[i]
      })
    end
    clp:addSlotItems(slotEntries)
  end
  if self._T.swindleChatType[messageType] then
    local getSwindleWarn = ___MOD._EtcManager:getSwindleWarning(message)
    if getSwindleWarn then
      self:addChatLog(___MOD._ChatMessageType.Blue, getSwindleWarn)
    end
  end
end

function ChatLogic.addWhisperHistory(self, target)
  local isDuplicate, dupIndex = false, 0
  for i, name in ___MOD.pairs(self.whisperHistory) do
    if name == target then
      isDuplicate, dupIndex = true, i
      break
    end
  end
  if isDuplicate then
    ___MOD.table.remove(self.whisperHistory, dupIndex)
  end
  ___MOD.table.insert(self.whisperHistory, target)
  if #self.whisperHistory > 10 then
    ___MOD.table.remove(self.whisperHistory, 1)
  end
end

function ChatLogic.applyItemSpeakerTooltip(self, logEntity, meta)
  self:clearItemSpeakerTooltip(logEntity)
  if not ___MOD.isvalid(logEntity) or ___MOD.type(meta) ~= "table" then
    return
  end
  if ___MOD.tonumber(meta.itemId) == nil or ___MOD.tonumber(meta.itemId) <= 0 then
    return
  end
  if self._T.itemSpeakerMetaByLogEntity == nil then
    self._T.itemSpeakerMetaByLogEntity = {}
  end
  self._T.itemSpeakerMetaByLogEntity[logEntity] = meta
  self:bindItemSpeakerLogTouch(logEntity)
end

function ChatLogic.applyMegaphoneIconX(self, logEntity, iconX)
  if not ___MOD.isvalid(logEntity) or iconX == nil then
    return
  end
  local base = logEntity:GetChildByName("MegaphoneBase")
  if ___MOD.isvalid(base) and base.UITransformComponent ~= nil then
    base.UITransformComponent.anchoredPosition.x = iconX
  end
  for i = 1, 4 do
    local num = logEntity:GetChildByName("MegaphoneNum" .. ___MOD.tostring(i))
    if ___MOD.isvalid(num) and num.UITransformComponent ~= nil then
      num.UITransformComponent.anchoredPosition.x = iconX + 24 + (i - 1) * 12
    end
  end
end

function ChatLogic.bindItemSpeakerLogTouch(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  if self._T.itemSpeakerTouchBoundByLogEntity == nil then
    self._T.itemSpeakerTouchBoundByLogEntity = {}
  end
  if self._T.itemSpeakerTouchBoundByLogEntity[logEntity] == true then
    return
  end
  if logEntity.UITouchReceiveComponent == nil then
    logEntity:AddComponent(___MOD.UITouchReceiveComponent)
  end
  if logEntity.SpriteGUIRendererComponent ~= nil then
    logEntity.SpriteGUIRendererComponent.RaycastTarget = true
  end
  logEntity:ConnectEvent(___MOD.UITouchUpEvent, function()
    self:onItemSpeakerLogTouchUp(logEntity)
  end)
  self._T.itemSpeakerTouchBoundByLogEntity[logEntity] = true
end

function ChatLogic.bindMegaphoneIconTouchEvent(self, iconEntity, logEntity)
  if not ___MOD.isvalid(iconEntity) or not ___MOD.isvalid(logEntity) then
    return
  end
  self:ensureMegaphoneStateTables()
  if iconEntity.UITouchReceiveComponent == nil then
    iconEntity:AddComponent(___MOD.UITouchReceiveComponent)
  end
  if self._T.megaphoneTouchBoundByIconEntity[iconEntity] then
    return
  end
  self._T.megaphoneTouchBoundByIconEntity[iconEntity] = true
  iconEntity:ConnectEvent(___MOD.UITouchUpEvent, function()
    self:onMegaphoneIconTouchUp(logEntity)
  end)
end

function ChatLogic.buildMSWCharWidthCache(self, fontSize)
  if self._T.mswCharWidthCacheBySize == nil then
    self._T.mswCharWidthCacheBySize = {}
  end
  if self._T.mswCharHeightBySize == nil then
    self._T.mswCharHeightBySize = {}
  end
  if self._T.mswHangulWidthBySize == nil then
    self._T.mswHangulWidthBySize = {}
  end
  if self._T.mswFallbackWidthBySize == nil then
    self._T.mswFallbackWidthBySize = {}
  end
  local size = ___MOD.tonumber(fontSize) or 20
  if self._T.mswCharWidthCacheBySize[size] ~= nil then
    return
  end
  local probe = self:ensureMSWWidthProbeEntity()
  if not ___MOD.isvalid(probe) or probe.TextGUIRendererComponent == nil then
    return
  end
  local txt = probe.TextGUIRendererComponent
  txt.FontSize = size
  local map = {}
  map[32] = 5.63
  map[10] = 0
  local seedChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz[]():.,+-*/%<>!?'\"# "
  for _, cp in ___MOD.utf8.codes(seedChars) do
    if map[cp] == nil then
      local ok, w = ___MOD.pcall(function()
        return ___MOD.tonumber(txt:GetPreferredWidth(___MOD.utf8.char(cp)))
      end)
      map[cp] = ok and w and 0 < w and w or 0
    end
  end
  local okH, h = ___MOD.pcall(function()
    return ___MOD.tonumber(txt:GetPreferredHeight(" ", 50))
  end)
  local okW, hangulW = ___MOD.pcall(function()
    return ___MOD.tonumber(txt:GetPreferredWidth("가"))
  end)
  local okF, fallbackW = ___MOD.pcall(function()
    return ___MOD.tonumber(txt:GetPreferredWidth("A"))
  end)
  self._T.mswCharWidthCacheBySize[size] = map
  self._T.mswCharHeightBySize[size] = okH and h and 0 < h and h or size
  self._T.mswHangulWidthBySize[size] = okW and hangulW and 0 < hangulW and hangulW or 10
  self._T.mswFallbackWidthBySize[size] = okF and fallbackW and 0 < fallbackW and fallbackW or 6
end

function ChatLogic.changeChatTarget(self, target)
  local chatTargetTable = {
    "모두에게",
    "귓속말",
    "파티에게",
    "친구에게",
    "길드에게",
    "연합에게",
    "채널에게",
    "그룹에게"
  }
  if chatTargetTable[target] == nil then
    return
  end
  if self:tryOpenMobileChatBoardWithTarget(target) then
    return
  end
  local chat = ___MOD._UserService.LocalPlayer.PlayerChatComponent
  if self.selectTarget.Enable then
    self.selectTarget.Enable = false
  end
  self:setChatTargetText(chatTargetTable[target])
  chat.chatTarget = target
  self:activateChatField()
end

function ChatLogic.clearChatLog(self)
  local clp = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat").ChatLogComponent
  clp:clearSlotItem()
end

function ChatLogic.clearItemSpeakerTooltip(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  if self._T.itemSpeakerMetaByLogEntity ~= nil then
    self._T.itemSpeakerMetaByLogEntity[logEntity] = nil
  end
  if self._T.itemSpeakerTooltipActiveLog == logEntity then
    self:hideItemSpeakerTooltipPopup()
  end
end

function ChatLogic.clearLogEntry(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  self:issueLogRenderToken(logEntity)
  local text = logEntity:GetChildByName("Text")
  if ___MOD.isvalid(text) and text.BitmapFontRendererComponent ~= nil then
    text.BitmapFontRendererComponent.richText = false
    text.BitmapFontRendererComponent.text = ""
    text.BitmapFontRendererComponent:drawText()
  end
  self:setMegaphoneSenderName(logEntity, "")
  self:setMegaphoneIconVisible(logEntity, nil)
  self:hideItemSpeakerInlineName(logEntity)
  self:clearItemSpeakerTooltip(logEntity)
end

function ChatLogic.closeMegaphoneUI(self)
  local ui = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Megaphone")
  local itemUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone")
  self:setMegaphoneInputText("")
  if ___MOD.isvalid(ui) then
    ui.Enable = false
  end
  if ___MOD.isvalid(itemUI) then
    itemUI.Enable = false
  end
  self:resetItemMegaphoneSelectionUI()
  self._T.megaphoneItemId = 5072000
end

function ChatLogic.decodeItemSpeakerMeta(self, marker)
  if ___MOD._UtilLogic:IsNilorEmptyString(marker) then
    return nil
  end
  local ok, meta = ___MOD.pcall(function()
    return ___MOD._HttpService:JSONDecode(marker)
  end)
  if not ok or ___MOD.type(meta) ~= "table" then
    return nil
  end
  return meta
end

function ChatLogic.drawText(self, messageType, message)
  local clp = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat").ChatLogComponent
  local p = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat/ChatLog")
  if clp.isMini then
    p = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat/ChatLog_mini")
  end
  local EmptyChatLog = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyChatLog")
  local a
  if ___MOD.isvalid(EmptyChatLog) then
    a = ___MOD._SpawnService:SpawnByEntity(EmptyChatLog, "Log", ___MOD.FastVector3.zero:Clone(), p)
  else
    a = ___MOD._SpawnService:SpawnByModelId("model://da3beae6-4ac5-4d7c-bc02-aabcca491a74", "Log", ___MOD.FastVector3.zero:Clone(), p)
  end
  a.Visible = false
  a:SetEnable(true)
  local backgroundRenderer = a.SpriteGUIRendererComponent
  if backgroundRenderer ~= nil then
    backgroundRenderer.Enable = false
  end
  local b = ___MOD._SpawnService:SpawnByModelId("model://e4d11ce4-b192-49a7-9da0-1f40c3e040aa", "Text", ___MOD.FastVector3.zero:Clone(), a)
  local transform = b.UITransformComponent
  transform.AlignmentOption = ___MOD.AlignmentType.Left
  transform.Pivot.x = 0
  transform.anchoredPosition.x = 12
  b:AddComponent(___MOD.BitmapFontRendererComponent)
  b:AddComponent(___MOD.TextGUIRendererComponent)
  local g = b.BitmapFontRendererComponent
  g.font = ___MOD._BitmapFontType.Gulim9pt
  g.convertEscapedNewline = false
  local textEntity = a:GetChildByName("Text")
  if ___MOD.isvalid(textEntity) and textEntity.UITransformComponent ~= nil then
    textEntity.UITransformComponent.RectSize.x = self:getChatLogTextWidth()
  end
  if ___MOD.isvalid(textEntity) and textEntity.BitmapFontRendererComponent ~= nil then
    textEntity.BitmapFontRendererComponent.font = ___MOD._BitmapFontType.Gulim9pt
    textEntity.BitmapFontRendererComponent.convertEscapedNewline = false
  end
  self:renderLogEntry(a, messageType, message)
  if backgroundRenderer ~= nil then
    backgroundRenderer.Enable = true
  end
  return a
end

function ChatLogic.ensureItemMegaphoneSlot(self)
  local icon = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone/Item/icon")
  if not ___MOD.isvalid(icon) then
    return
  end
  local slotRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone/Item")
  if icon.SpriteGUIRendererComponent == nil then
    icon:AddComponent(___MOD.SpriteGUIRendererComponent)
  end
  if icon.SpriteGUIRendererComponent ~= nil then
    icon.SpriteGUIRendererComponent.RaycastTarget = true
  end
  if icon.TooltipComponent == nil then
    icon:AddComponent(___MOD.TooltipComponent)
  end
  if icon.TooltipComponent ~= nil then
    icon.TooltipComponent.type = ___MOD._TooltipType.INVENTORY
  end
  if icon.UISlotItemComponent == nil then
    icon:AddComponent(___MOD.UISlotItemComponent)
  end
  if icon.UIElementClickInteractionComponent == nil then
    icon:AddComponent(___MOD.UIElementClickInteractionComponent)
  end
  if icon.UIElementClickInteractionComponent ~= nil then
    icon.UIElementClickInteractionComponent.type = ___MOD._UIElementType.UI_SLOT_ITEM
    icon.UIElementClickInteractionComponent.disable = false
    icon.UIElementClickInteractionComponent.Transition = 0
  end
  if icon.UITouchReceiveComponent == nil then
    icon:AddComponent(___MOD.UITouchReceiveComponent)
  end
  if self._T.itemMegaphoneIconTouchBound ~= true then
    icon:ConnectEvent(___MOD.UITouchUpEvent, function()
      local selectedItemId = ___MOD.tonumber(self._T.itemMegaphoneSelectedItemId) or 0
      if 0 < selectedItemId then
        self:resetItemMegaphoneSelectionUI()
      end
    end)
    self._T.itemMegaphoneIconTouchBound = true
  end
  if ___MOD.isvalid(slotRoot) then
    if slotRoot.UIElementClickInteractionComponent == nil then
      slotRoot:AddComponent(___MOD.UIElementClickInteractionComponent)
    end
    if slotRoot.UIElementClickInteractionComponent ~= nil then
      slotRoot.UIElementClickInteractionComponent.type = ___MOD._UIElementType.UI_SLOT_ITEM
      slotRoot.UIElementClickInteractionComponent.disable = false
      slotRoot.UIElementClickInteractionComponent.Transition = 0
    end
  end
end

function ChatLogic.ensureItemSpeakerInlineNameEntity(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return nil
  end
  local nameEntity = logEntity:GetChildByName("ItemSpeakerInlineName")
  if not ___MOD.isvalid(nameEntity) then
    local emptyText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyEntity")
    if not ___MOD.isvalid(emptyText) then
      return nil
    end
    nameEntity = ___MOD._SpawnService:SpawnByEntity(emptyText, "ItemSpeakerInlineName", ___MOD.FastVector3.zero:Clone(), logEntity)
    if not ___MOD.isvalid(nameEntity) then
      return nil
    end
    nameEntity.Visible = false
    if nameEntity.BitmapFontRendererComponent == nil then
      nameEntity:AddComponent(___MOD.BitmapFontRendererComponent)
      nameEntity:AddComponent(___MOD.TextGUIRendererComponent)
    end
    if nameEntity.UITransformComponent ~= nil then
      nameEntity.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
      nameEntity.UITransformComponent.Pivot.x = 0
      nameEntity.UITransformComponent.anchoredPosition.y = 0
    end
  end
  return nameEntity
end

function ChatLogic.ensureItemSpeakerTooltipProxy(self)
  if ___MOD.isvalid(self._T.itemSpeakerTooltipProxy) then
    return self._T.itemSpeakerTooltipProxy
  end
  local tempGroup = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
  local emptyEntity = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyEntity")
  if not ___MOD.isvalid(tempGroup) or not ___MOD.isvalid(emptyEntity) then
    return nil
  end
  local proxy = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "ItemSpeakerTooltipProxy", ___MOD.FastVector3.zero:Clone(), tempGroup)
  if not ___MOD.isvalid(proxy) then
    return nil
  end
  if proxy.TooltipComponent == nil then
    proxy:AddComponent(___MOD.TooltipComponent)
  end
  if proxy.UITransformComponent ~= nil then
    proxy.UITransformComponent.anchoredPosition = ___MOD.FastVector2(10000, 10000)
  end
  proxy.Visible = false
  self._T.itemSpeakerTooltipProxy = proxy
  return proxy
end

function ChatLogic.ensureMegaphoneIcon(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  local base = logEntity:GetChildByName("MegaphoneBase")
  if not ___MOD.isvalid(base) then
    base = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "MegaphoneBase", ___MOD.FastVector3.zero:Clone(), logEntity)
    base.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    base.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    base.UITransformComponent.anchoredPosition = ___MOD.FastVector2(12, -2)
    base.UITransformComponent.RectSize = ___MOD.FastVector2(96, 24)
    base.Visible = false
    self:bindMegaphoneIconTouchEvent(base, logEntity)
  end
  for i = 1, 4 do
    local name = "MegaphoneNum" .. ___MOD.tostring(i)
    local num = logEntity:GetChildByName(name)
    if not ___MOD.isvalid(num) then
      num = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", name, ___MOD.FastVector3.zero:Clone(), logEntity)
      num.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      num.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
      num.UITransformComponent.anchoredPosition = ___MOD.FastVector2(36 + (i - 1) * 12, -9)
      num.UITransformComponent.RectSize = ___MOD.FastVector2(10, 12)
      num.Visible = false
      self:bindMegaphoneIconTouchEvent(num, logEntity)
    end
  end
end

function ChatLogic.ensureMegaphoneStateTables(self)
  if self._T.megaphoneSenderByLogEntity == nil then
    self._T.megaphoneSenderByLogEntity = {}
  end
  if self._T.megaphoneTouchBoundByIconEntity == nil then
    self._T.megaphoneTouchBoundByIconEntity = {}
  end
end

function ChatLogic.ensureMegaphoneUIBindings(self)
  if self._T.megaphoneBound ~= true then
    local ui = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Megaphone")
    if ___MOD.isvalid(ui) then
      local btYes = ui:GetChildByName("BtYes")
      local btNo = ui:GetChildByName("BtNo")
      local textEntity = ui:GetChildByName("Text")
      if ___MOD.isvalid(btYes) then
        btYes:ConnectEvent(___MOD.ButtonClickEvent, function()
          self:sendMegaphoneFromUI()
        end)
      end
      if ___MOD.isvalid(btNo) then
        btNo:ConnectEvent(___MOD.ButtonClickEvent, function()
          self:closeMegaphoneUI()
        end)
      end
      if ___MOD.isvalid(textEntity) then
        textEntity:ConnectEvent(___MOD.TextInputSubmitEvent, function()
          self:sendMegaphoneFromUI()
        end)
      end
      self._T.megaphoneBound = true
    end
  end
  if self._T.itemMegaphoneBound ~= true then
    local itemUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone")
    if ___MOD.isvalid(itemUI) then
      local btYes = itemUI:GetChildByName("BtYes")
      local btNo = itemUI:GetChildByName("BtNo")
      local textEntity = itemUI:GetChildByName("Text")
      if ___MOD.isvalid(btYes) then
        btYes:ConnectEvent(___MOD.ButtonClickEvent, function()
          self:sendMegaphoneFromUI()
        end)
      end
      if ___MOD.isvalid(btNo) then
        btNo:ConnectEvent(___MOD.ButtonClickEvent, function()
          self:closeMegaphoneUI()
        end)
      end
      if ___MOD.isvalid(textEntity) then
        textEntity:ConnectEvent(___MOD.TextInputSubmitEvent, function()
          self:sendMegaphoneFromUI()
        end)
      end
      self._T.itemMegaphoneBound = true
    end
  end
end

function ChatLogic.ensureMSWWidthProbeEntity(self)
  local parent = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  if not ___MOD.isvalid(parent) then
    parent = ___MOD._EntityService:GetEntityByPath("/ui/DefaultGroup")
  end
  local probe = self._T.mswWidthProbeEntity
  if ___MOD.isvalid(probe) and probe.TextGUIRendererComponent ~= nil then
    if ___MOD.isvalid(parent) and probe.Parent ~= parent then
      probe:AttachTo(parent)
    end
    return probe
  end
  if not ___MOD.isvalid(parent) then
    return nil
  end
  probe = ___MOD._SpawnService:SpawnByModelId("model://e4d11ce4-b192-49a7-9da0-1f40c3e040aa", "__MSWWidthProbe", ___MOD.FastVector3.zero:Clone(), parent)
  if not ___MOD.isvalid(probe) then
    return nil
  end
  if probe.TextGUIRendererComponent == nil then
    probe:AddComponent(___MOD.TextGUIRendererComponent)
  end
  if probe.UITransformComponent ~= nil then
    probe.UITransformComponent.anchoredPosition = ___MOD.FastVector2(9999, 9999)
    probe.UITransformComponent.RectSize = ___MOD.FastVector2(1, 1)
  end
  probe.Visible = false
  self._T.mswWidthProbeEntity = probe
  return probe
end

function ChatLogic.extractMegaphoneSenderName(self, renderMsg, markerSenderName)
  if not ___MOD._UtilLogic:IsNilorEmptyString(markerSenderName) then
    return markerSenderName
  end
  local sender = ___MOD.string.match(renderMsg or "", "^(.-)%s:%s")
  if ___MOD._UtilLogic:IsNilorEmptyString(sender) then
    return ""
  end
  sender = ___MOD.string.gsub(sender, "^%s+", "")
  sender = ___MOD.string.gsub(sender, "%s+$", "")
  sender = ___MOD.string.gsub(sender, "^<[^>]+>%s*", "")
  return sender
end

function ChatLogic.getActiveMegaphoneUIEntity(self)
  local itemId = self._T.megaphoneItemId or 5072000
  return self:getMegaphoneUIEntity(itemId)
end

function ChatLogic.getChatLogMSWFontSize(self)
  return 24
end

function ChatLogic.getChatLogTextWidth(self)
  return self.chatLogTextWidth
end

function ChatLogic.getChatLogWrapTextWidth(self, text)
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return 0
  end
  return self:getTextWidth(text, ___MOD._BitmapFontType.Gulim9pt)
end

function ChatLogic.getMegaphoneInputText(self)
  local ui = self:getActiveMegaphoneUIEntity()
  if not ___MOD.isvalid(ui) then
    return ""
  end
  local textEntity = ui:GetChildByName("Text")
  if not ___MOD.isvalid(textEntity) then
    return ""
  end
  local text = ""
  if textEntity.TextInputComponent ~= nil then
    text = textEntity.TextInputComponent.Text or ""
  elseif textEntity.TextGUIRendererInputComponent ~= nil then
    text = textEntity.TextGUIRendererInputComponent.Text or ""
  elseif textEntity.TextComponent ~= nil then
    text = textEntity.TextComponent.Text or ""
  end
  text = ___MOD.string.gsub(text or "", "^%s+", "")
  text = ___MOD.string.gsub(text, "%s+$", "")
  return text
end

function ChatLogic.getMegaphoneSenderName(self, logEntity)
  self:ensureMegaphoneStateTables()
  return self._T.megaphoneSenderByLogEntity[logEntity] or ""
end

function ChatLogic.getMegaphoneUIEntity(self, itemId)
  if itemId == 5076000 then
    return ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone")
  end
  return ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Megaphone")
end

function ChatLogic.getMSWPreferredWidthCached(self, text, fontSize)
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return 0
  end
  local size = ___MOD.tonumber(fontSize) or self:getChatLogMSWFontSize()
  self:buildMSWCharWidthCache(size)
  local cacheBySize = self._T.mswCharWidthCacheBySize
  if cacheBySize == nil then
    return 0
  end
  local map = cacheBySize[size]
  if map == nil then
    return 0
  end
  local width = 0
  local hangulWidth = self._T.mswHangulWidthBySize and self._T.mswHangulWidthBySize[size] or 10
  local fallbackWidth = self._T.mswFallbackWidthBySize and self._T.mswFallbackWidthBySize[size] or 6
  local probe = self:ensureMSWWidthProbeEntity()
  local txt = ___MOD.isvalid(probe) and probe.TextGUIRendererComponent or nil
  if txt ~= nil then
    txt.FontSize = size
  end
  for _, cp in ___MOD.utf8.codes(text) do
    local w = map[cp]
    if w == nil then
      if cp == 32 then
        w = 5.63
      elseif self:isHangulOrHanjaCodePoint(cp) then
        w = hangulWidth
      elseif txt ~= nil then
        local ok, measured = ___MOD.pcall(function()
          return ___MOD.tonumber(txt:GetPreferredWidth(___MOD.utf8.char(cp)))
        end)
        w = ok and measured and 0 < measured and measured or fallbackWidth
      else
        w = fallbackWidth
      end
      map[cp] = w
    end
    if w <= 0 then
      if cp == 10 or cp == 9 then
        w = 0
      else
        w = fallbackWidth
      end
    end
    width = width + w
  end
  return width
end

function ChatLogic.getRenderedMSWTextWidth(self, textEntity, text)
  if not ___MOD.isvalid(textEntity) or ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return 0
  end
  local textGUI = textEntity.TextGUIRendererComponent
  if textGUI == nil then
    return 0
  end
  local ok, width = ___MOD.pcall(function()
    return ___MOD.tonumber(textGUI:GetPreferredWidth(text))
  end)
  if not ok or width == nil or width <= 0 then
    return 0
  end
  return width
end

function ChatLogic.getTextWidth(self, text, font)
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return 0
  end
  local width = 0
  local targetFont = font or ___MOD._BitmapFontType.Gulim9pt
  for _, cp in ___MOD.utf8.codes(text) do
    local sz = ___MOD._BitmapFontManager:getGlyphSize(targetFont, cp)
    local gw = sz and sz.x or 0
    if gw <= 0 then
      gw = 6
    end
    width = width + gw
  end
  return width
end

function ChatLogic.HandleTextInputSubmitEvent(self, event)
  local e = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat")
  e.ChatLogComponent:activateChatTextField(false)
  self.lastTypingTime = ___MOD._UtilLogic.ElapsedSeconds
  self.ignoreWhisperHotkeyUntil = ___MOD._UtilLogic.ElapsedSeconds + 0.5
end

function ChatLogic.hideItemSpeakerInlineName(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  local nameEntity = logEntity:GetChildByName("ItemSpeakerInlineName")
  if not ___MOD.isvalid(nameEntity) or nameEntity.BitmapFontRendererComponent == nil then
    return
  end
  nameEntity.BitmapFontRendererComponent.richText = false
  nameEntity.BitmapFontRendererComponent.text = ""
  nameEntity.BitmapFontRendererComponent:drawText()
  nameEntity.Visible = false
end

function ChatLogic.hideItemSpeakerTooltipPopup(self)
  local proxy = self._T.itemSpeakerTooltipProxy
  if ___MOD.isvalid(proxy) and proxy.TooltipComponent ~= nil then
    proxy.TooltipComponent:showTooltip(false)
  end
  if self._T.itemSpeakerTooltipDistanceWatcher ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.MouseMoveEvent, self._T.itemSpeakerTooltipDistanceWatcher)
    self._T.itemSpeakerTooltipDistanceWatcher = nil
  end
  self._T.itemSpeakerTooltipActiveLog = nil
end

function ChatLogic.isHangulOrHanjaCodePoint(self, cp)
  if cp == nil then
    return false
  end
  if 4352 <= cp and cp <= 4607 then
    return true
  end
  if 12592 <= cp and cp <= 12687 then
    return true
  end
  if 44032 <= cp and cp <= 55203 then
    return true
  end
  if 19968 <= cp and cp <= 40959 then
    return true
  end
  if 13312 <= cp and cp <= 19903 then
    return true
  end
  if 63744 <= cp and cp <= 64255 then
    return true
  end
  if 194560 <= cp and cp <= 195103 then
    return true
  end
  return false
end

function ChatLogic.isLogRenderTokenCurrent(self, logEntity, token)
  if not ___MOD.isvalid(logEntity) then
    return false
  end
  if self._T.logRenderTokenByEntity == nil then
    return false
  end
  return self._T.logRenderTokenByEntity[logEntity] == token
end

function ChatLogic.isMegaphoneRenderMessage(self, messageType, message)
  if messageType == ___MOD._ChatMessageType.SpeakerWorldInstance then
    return true
  end
  if messageType == ___MOD._ChatMessageType.ItemSpeaker and ___MOD.string.find(message or "", "#M", 1, true) ~= nil then
    return true
  end
  return false
end

function ChatLogic.isMobileChatUIActive(self)
  local localPlayer = ___MOD._UserService.LocalPlayer
  local useMobileChat = ___MOD.Environment:IsMobilePlatform()
  if ___MOD.isvalid(localPlayer) and localPlayer.Player ~= nil and localPlayer.Player.init then
    useMobileChat = localPlayer.Player:isMobileUIPlatform()
  end
  local observerDesktop = ___MOD._ObserverUtilLogic ~= nil and ___MOD._ObserverUtilLogic:IsObserverDesktopUIActive()
  return useMobileChat and not observerDesktop
end

function ChatLogic.issueLogRenderToken(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return 0
  end
  if self._T.logRenderTokenSeq == nil then
    self._T.logRenderTokenSeq = 0
  end
  if self._T.logRenderTokenByEntity == nil then
    self._T.logRenderTokenByEntity = {}
  end
  self._T.logRenderTokenSeq = self._T.logRenderTokenSeq + 1
  local token = self._T.logRenderTokenSeq
  self._T.logRenderTokenByEntity[logEntity] = token
  return token
end

function ChatLogic.OnBeginPlay(self)
  self.colorTable = {
    [___MOD._ChatMessageType.Blue] = {
      ___MOD.Color.FromHexCode("#66CCFF"),
      ___MOD.Color(0, 0, 0, 0)
    },
    [___MOD._ChatMessageType.Red] = {
      ___MOD.Color.FromHexCode("#FFAAAA"),
      ___MOD.Color(0, 0, 0, 0)
    },
    [___MOD._ChatMessageType.Yellow] = {
      ___MOD.Color.FromHexCode("#FFFF00"),
      ___MOD.Color(0, 0, 0, 0)
    },
    [___MOD._ChatMessageType.ItemSpeaker] = {
      ___MOD.Color.FromHexCode("#462706"),
      ___MOD.Color(1, 0.86, 0, 0.87)
    },
    [___MOD._ChatMessageType.System] = {
      ___MOD.Color.FromHexCode("#BBBBBB"),
      ___MOD.Color(0, 0, 0, 0)
    },
    [___MOD._ChatMessageType.NormalChat] = {
      ___MOD.Color.white,
      ___MOD.Color(0, 0, 0, 0)
    },
    [___MOD._ChatMessageType.Creator] = {
      ___MOD.Color.black,
      ___MOD.Color(1, 1, 1, 0.69)
    },
    [___MOD._ChatMessageType.Channel] = {
      ___MOD.Color.FromHexCode("#003F7F"),
      ___MOD.Color(0.79, 0.9, 1, 0.8)
    },
    [___MOD._ChatMessageType.SpeakerWorldInstance] = {
      ___MOD.Color.FromHexCode("#770042"),
      ___MOD.Color(1, 0.74, 0.86, 0.8)
    },
    [___MOD._ChatMessageType.Whisper] = {
      ___MOD.Color.FromHexCode("#00FF00"),
      ___MOD.Color(0, 0, 0, 0)
    },
    [___MOD._ChatMessageType.Party] = {
      ___MOD.Color.FromHexCode("#FF99CC"),
      ___MOD.Color(0, 0, 0, 0)
    },
    [___MOD._ChatMessageType.Friend] = {
      ___MOD.Color.FromHexCode("#FF9900"),
      ___MOD.Color(0, 0, 0, 0)
    },
    [___MOD._ChatMessageType.Guild] = {
      ___MOD.Color.FromHexCode("#E1ACFE"),
      ___MOD.Color(0, 0, 0, 0)
    }
  }
  self.chatTargetText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat/chatTarget/Text")
  self.selectTarget = ___MOD._EntityService:GetEntity("954e9882-79b5-4997-831f-2947eed83756")
  self._T.megaphoneBound = false
  self._T.itemMegaphoneBound = false
  self._T.megaphoneItemId = 5072000
  self._T.itemMegaphoneSelectedItemId = 0
  self._T.itemMegaphoneSelectedInvType = 0
  self._T.itemMegaphoneSelectedInvSlot = 0
  self._T.itemSpeakerMetaByLogEntity = {}
  self._T.itemSpeakerTouchBoundByLogEntity = {}
  self._T.itemSpeakerTooltipActiveLog = nil
  self._T.itemSpeakerTooltipProxy = nil
  self._T.itemSpeakerTooltipDistanceWatcher = nil
  self._T.swindleChatType = {
    [___MOD._ChatMessageType.Alliance] = true,
    [___MOD._ChatMessageType.Channel] = true,
    [___MOD._ChatMessageType.Friend] = true,
    [___MOD._ChatMessageType.Guild] = true,
    [___MOD._ChatMessageType.ItemSpeaker] = true,
    [___MOD._ChatMessageType.NormalChat] = true,
    [___MOD._ChatMessageType.Party] = true,
    [___MOD._ChatMessageType.Whisper] = true
  }
  self:buildMSWCharWidthCache(self:getChatLogMSWFontSize())
  local megaphoneUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Megaphone")
  if ___MOD.isvalid(megaphoneUI) then
    megaphoneUI.Enable = false
  end
  local itemMegaphoneUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone")
  if ___MOD.isvalid(itemMegaphoneUI) then
    itemMegaphoneUI.Enable = false
  end
end

function ChatLogic.onItemMegaphoneDropItem(self, itemId, invType, invSlot, ieqp)
  local itemMegaphoneUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone")
  if not ___MOD.isvalid(itemMegaphoneUI) or not itemMegaphoneUI.Enable then
    return
  end
  self:ensureItemMegaphoneSlot()
  local icon = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone/Item/icon")
  if ___MOD.isvalid(icon) and icon.UISlotItemComponent ~= nil then
    icon.UISlotItemComponent:set(itemId, invType, invSlot, ieqp)
  end
  local cash = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone/Item/icon/cash")
  if ___MOD.isvalid(cash) then
    cash.Visible = ieqp ~= nil and ieqp.flag & ___MOD._ItemFlag.Protect ~= 0
  end
  local itemName = ___MOD._StringPoolManager:getItemName(itemId) or ""
  local name = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone/Item/itemname/Text")
  if ___MOD.isvalid(name) and name.BitmapFontRendererComponent ~= nil then
    name.Visible = true
    name:SetEnable(true)
    name.BitmapFontRendererComponent.text = itemName
    name.BitmapFontRendererComponent:drawText()
  end
  self._T.itemMegaphoneSelectedItemId = itemId
  self._T.itemMegaphoneSelectedInvType = invType
  self._T.itemMegaphoneSelectedInvSlot = invSlot
end

function ChatLogic.onItemSpeakerLogTouchUp(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  local metaByLog = self._T.itemSpeakerMetaByLogEntity or {}
  local meta = metaByLog[logEntity]
  if ___MOD.type(meta) ~= "table" then
    self:hideItemSpeakerTooltipPopup()
    return
  end
  self:showItemSpeakerTooltipPopup(logEntity, meta)
end

function ChatLogic.onMegaphoneIconTouchUp(self, logEntity)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  local senderName = self:getMegaphoneSenderName(logEntity)
  if ___MOD._UtilLogic:IsNilorEmptyString(senderName) then
    return
  end
  local localUser = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(localUser) and ___MOD.isvalid(localUser.Player) and senderName == localUser.Player.Name then
    return
  end
  self:showWhisperUIWithDefault(senderName)
end

function ChatLogic.openMegaphoneUI(self)
  self._T.megaphoneItemId = 5072000
  self:openMegaphoneUIByItem(self._T.megaphoneItemId)
end

function ChatLogic.openMegaphoneUIByItem(self, itemId)
  if itemId <= 0 then
    itemId = 5072000
  end
  self._T.megaphoneItemId = itemId
  self:ensureMegaphoneUIBindings()
  local normalUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Megaphone")
  local itemUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone")
  if ___MOD.isvalid(normalUI) then
    normalUI.Enable = false
  end
  if ___MOD.isvalid(itemUI) then
    itemUI.Enable = false
  end
  local ui = self:getMegaphoneUIEntity(itemId)
  if not ___MOD.isvalid(ui) then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "Megaphone UI를 찾을 수 없습니다.")
    return
  end
  if itemId == 5076000 then
    self:ensureItemMegaphoneSlot()
  end
  ui.Enable = true
  if itemId == 5076000 then
    self:resetItemMegaphoneSelectionUI()
  end
  ___MOD._UIWindowLogic:moveToTopLayer(ui)
  local textEntity = ui:GetChildByName("Text")
  local localPlayer = ___MOD._UserService.LocalPlayer
  local isMobileUIPlatform = ___MOD.isvalid(localPlayer) and localPlayer.Player ~= nil and self:isMobileChatUIActive()
  if not isMobileUIPlatform and ___MOD.isvalid(textEntity) then
    if textEntity.TextInputComponent ~= nil then
      textEntity.TextInputComponent:ActivateInputField()
    elseif textEntity.TextGUIRendererInputComponent ~= nil then
      textEntity.TextGUIRendererInputComponent:ActivateInputField()
    end
  end
end

function ChatLogic.parseItemSpeakerMetaMarker(self, message)
  local raw = message or ""
  local marker = ___MOD.string.match(raw, "{#MIT:([^#]+)#}")
  if marker ~= nil then
    raw = ___MOD.string.gsub(raw, "{#MIT:[^#]+#}", "", 1)
  end
  return raw, marker
end

function ChatLogic.parseMegaphoneRenderMessage(self, message)
  local raw = message or ""
  local num = ___MOD.string.match(raw, "#M(%d+)#")
  local senderName = ___MOD.string.match(raw, "{#MPN:([^#]+)#}")
  if senderName ~= nil then
    raw = ___MOD.string.gsub(raw, "{#MPN:[^#]+#}", "", 1)
  end
  if num == nil then
    return raw, nil, senderName
  end
  local ch = ___MOD.tonumber(num) or 0
  if ch < 0 then
    ch = 0
  end
  if 9999 < ch then
    ch = 9999
  end
  local clean = ___MOD.string.gsub(raw, "#M%d+#", "", 1)
  clean = ___MOD.string.gsub(clean, "  +", " ")
  clean = ___MOD.string.gsub(clean, "^%s+", "")
  return clean, ch, senderName
end

function ChatLogic.prepareItemSpeakerTooltip(self, meta)
  local itemId = ___MOD.tonumber(meta and meta.itemId) or 0
  if itemId <= 0 then
    return nil
  end
  local proxy = self:ensureItemSpeakerTooltipProxy()
  if not ___MOD.isvalid(proxy) or proxy.TooltipComponent == nil then
    return nil
  end
  local tooltip = proxy.TooltipComponent
  tooltip.id = itemId
  local linkedEquipInfo
  if ___MOD.type(meta.equipInfo) == "table" then
    linkedEquipInfo = ___MOD.InventoryEquip()
    linkedEquipInfo:fromTable(meta.equipInfo)
  end
  if itemId // 1000000 == 1 then
    tooltip.type = ___MOD._TooltipType.EQUIP
    if linkedEquipInfo ~= nil then
      tooltip.equip = linkedEquipInfo
    else
      local eqp = ___MOD._EquipManager:getItemById(itemId)
      if eqp ~= nil then
        tooltip.equip = eqp:addInventoryEquip()
      else
        tooltip.equip = nil
      end
    end
  else
    tooltip.type = ___MOD._TooltipType.INVENTORY
    if linkedEquipInfo ~= nil then
      tooltip.equip = linkedEquipInfo
    else
      local item = ___MOD._ItemManager:getItemById(itemId)
      if item ~= nil then
        tooltip.equip = item:addInventoryItem()
      else
        tooltip.equip = nil
      end
    end
  end
  return tooltip
end

function ChatLogic.renderItemSpeakerInlineName(self, logEntity, renderMsg, itemMeta)
  local prefix, tail = ___MOD.string.match(renderMsg or "", "^(.-:%s*)(.*)$")
  if prefix == nil then
    self:hideItemSpeakerInlineName(logEntity)
    return renderMsg
  end
  local itemName = ""
  if ___MOD.type(itemMeta) == "table" and not ___MOD._UtilLogic:IsNilorEmptyString(itemMeta.itemName) then
    itemName = ___MOD.tostring(itemMeta.itemName)
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(itemName) then
    self:hideItemSpeakerInlineName(logEntity)
    return renderMsg
  end
  local itemText = ___MOD.string.format("[%s]", itemName)
  if ___MOD.string.sub(tail or "", 1, #itemText) ~= itemText then
    self:hideItemSpeakerInlineName(logEntity)
    return renderMsg
  end
  local body = ___MOD.string.sub(tail, #itemText + 1)
  body = ___MOD.string.gsub(body or "", "^%s*", "")
  local itemWidth = self:getTextWidth(itemText, ___MOD._BitmapFontType.Gulim9pt)
  local spaceWidth = ___MOD.math.max(1, self:getTextWidth(" ", ___MOD._BitmapFontType.Gulim9pt))
  local gapWidth = self:getTextWidth(" ", ___MOD._BitmapFontType.Gulim9pt)
  local useMSWFont = false
  local nameEntity = self:ensureItemSpeakerInlineNameEntity(logEntity)
  if nameEntity and nameEntity.BitmapFontRendererComponent ~= nil then
    local font = nameEntity.BitmapFontRendererComponent
    useMSWFont = font:shouldUseMSWFont() == true
    nameEntity.Visible = false
    if useMSWFont then
      local preferredItemWidth = self:getMSWPreferredWidthCached(itemText, self:getChatLogMSWFontSize())
      if preferredItemWidth ~= nil and 0 < preferredItemWidth then
        itemWidth = preferredItemWidth
        if nameEntity.UITransformComponent ~= nil then
          local currentH = nameEntity.UITransformComponent.RectSize.y or 0
          nameEntity.UITransformComponent.RectSize = ___MOD.FastVector2(preferredItemWidth, currentH)
        end
      end
      spaceWidth = 5.63
      gapWidth = 5.63
    end
    local spaceCount = ___MOD.math.max(1, ___MOD.math.floor((itemWidth + gapWidth + (spaceWidth - 1)) / spaceWidth))
    local spacer = ___MOD.string.rep(" ", spaceCount)
    if nameEntity.UITransformComponent ~= nil then
      local namePosX = 12 + self:getTextWidth(prefix, ___MOD._BitmapFontType.Gulim9pt)
      if useMSWFont then
        local preferredPrefixWidth = self:getMSWPreferredWidthCached(prefix, self:getChatLogMSWFontSize())
        if preferredPrefixWidth ~= nil and 0 < preferredPrefixWidth then
          namePosX = 12 + preferredPrefixWidth
        end
        namePosX = namePosX - 6
      end
      nameEntity.UITransformComponent.anchoredPosition.x = namePosX
    end
    font.font = ___MOD._BitmapFontType.Gulim9pt
    font.richText = false
    font.startPos = ___MOD.FastVector2.zero:Clone()
    font.text = itemText
    font.color = ___MOD.Color.FromHexCode("#5c36f6")
    font:drawText()
    nameEntity.Visible = true
    if ___MOD._UtilLogic:IsNilorEmptyString(body) then
      return prefix .. spacer
    end
    return prefix .. spacer .. body
  end
  local spaceCount = ___MOD.math.max(1, ___MOD.math.floor((itemWidth + gapWidth + (spaceWidth - 1)) / spaceWidth))
  local spacer = ___MOD.string.rep(" ", spaceCount)
  if ___MOD._UtilLogic:IsNilorEmptyString(body) then
    return prefix .. spacer
  end
  return prefix .. spacer .. body
end

function ChatLogic.renderLogEntry(self, logEntity, messageType, message)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  local renderToken = self:issueLogRenderToken(logEntity)
  logEntity.SpriteGUIRendererComponent.Color = self.colorTable[messageType][2]
  local text = logEntity:GetChildByName("Text")
  if not ___MOD.isvalid(text) or text.BitmapFontRendererComponent == nil then
    return
  end
  local chatLogTextWidth = self:getChatLogTextWidth()
  if text.UITransformComponent ~= nil then
    text.UITransformComponent.RectSize.x = chatLogTextWidth
  end
  local renderMsg = message or ""
  local itemMetaMarker
  if messageType == ___MOD._ChatMessageType.ItemSpeaker then
    renderMsg, itemMetaMarker = self:parseItemSpeakerMetaMarker(renderMsg)
  end
  local ch, iconX, megaphoneSender
  local isMegaphoneMSW = false
  self:setMegaphoneSenderName(logEntity, "")
  if self:isMegaphoneRenderMessage(messageType, renderMsg) then
    local markerSenderName
    renderMsg, ch, markerSenderName = self:parseMegaphoneRenderMessage(renderMsg)
    if ch ~= nil then
      self:setMegaphoneSenderName(logEntity, self:extractMegaphoneSenderName(renderMsg, markerSenderName))
      local sender, chatBody = ___MOD.string.match(renderMsg, "^(.-)%s:%s(.*)$")
      if sender ~= nil then
        megaphoneSender = sender
        local font = text.BitmapFontRendererComponent
        local isMSW = font:shouldUseMSWFont()
        isMegaphoneMSW = isMSW == true
        local senderWidth = 0
        if isMSW then
          senderWidth = nil
        else
          senderWidth = 12 + self:getTextWidth(sender .. " ", ___MOD._BitmapFontType.Gulim9pt)
        end
        iconX = senderWidth
        if isMSW then
          renderMsg = ___MOD.string.format("%s                   : %s", sender, chatBody)
        else
          renderMsg = ___MOD.string.format("%s             : %s", sender, chatBody)
        end
      end
    end
  end
  if not self:isLogRenderTokenCurrent(logEntity, renderToken) then
    return
  end
  self:setMegaphoneIconVisible(logEntity, ch)
  if iconX ~= nil and not isMegaphoneMSW then
    self:applyMegaphoneIconX(logEntity, iconX)
  end
  local itemMeta
  if messageType == ___MOD._ChatMessageType.ItemSpeaker then
    itemMeta = self:decodeItemSpeakerMeta(itemMetaMarker)
    renderMsg = self:renderItemSpeakerInlineName(logEntity, renderMsg, itemMeta)
  else
    self:hideItemSpeakerInlineName(logEntity)
  end
  if not self:isLogRenderTokenCurrent(logEntity, renderToken) then
    return
  end
  local textColor = self.colorTable[messageType][1]
  if text.TextGUIRendererComponent ~= nil and text.TextGUIRendererComponent.EnableInHierarchy then
    text.TextGUIRendererComponent.FontColor = textColor
  end
  text.BitmapFontRendererComponent.richText = false
  text.BitmapFontRendererComponent.startPos = ___MOD.FastVector2.zero:Clone()
  text.BitmapFontRendererComponent.text = renderMsg
  text.BitmapFontRendererComponent.color = textColor
  text.BitmapFontRendererComponent:drawText()
  if text.UITransformComponent ~= nil then
    text.UITransformComponent.RectSize.x = chatLogTextWidth
  end
  if ch ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(megaphoneSender) and text.BitmapFontRendererComponent:shouldUseMSWFont() then
    local renderedSenderWidth = self:getRenderedMSWTextWidth(text, megaphoneSender .. " ")
    if 0 < renderedSenderWidth then
      iconX = 17 + ___MOD.math.floor(renderedSenderWidth + 0.5)
      self:applyMegaphoneIconX(logEntity, iconX)
    end
  end
  if not self:isLogRenderTokenCurrent(logEntity, renderToken) then
    return
  end
  if messageType == ___MOD._ChatMessageType.ItemSpeaker then
    self:applyItemSpeakerTooltip(logEntity, itemMeta)
  else
    self:clearItemSpeakerTooltip(logEntity)
  end
end

function ChatLogic.resetItemMegaphoneSelectionUI(self)
  self._T.itemMegaphoneSelectedItemId = 0
  self._T.itemMegaphoneSelectedInvType = 0
  self._T.itemMegaphoneSelectedInvSlot = 0
  local icon = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone/Item/icon")
  if ___MOD.isvalid(icon) and icon.TooltipComponent ~= nil then
    icon.TooltipComponent.id = 0
    icon.TooltipComponent.equip = nil
  end
  if ___MOD.isvalid(icon) and icon.UISlotItemComponent ~= nil then
    icon.UISlotItemComponent:clearPotentialOutline()
    icon.UISlotItemComponent.invType = 0
    icon.UISlotItemComponent.invSlot = 0
  end
  if ___MOD.isvalid(icon) and icon.SpriteGUIRendererComponent ~= nil then
    icon.SpriteGUIRendererComponent.ImageRUID = "3e9d52ed52d64794bbd6f72bab8ee3d9"
  end
  local cash = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone/Item/icon/cash")
  if ___MOD.isvalid(cash) then
    cash.Visible = false
  end
  local name = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemMegaphone/Item/itemname/Text")
  if ___MOD.isvalid(name) then
    name.Visible = true
    name:SetEnable(true)
    if name.TextGUIRendererComponent ~= nil then
      name.TextGUIRendererComponent.Text = ""
    end
    if name.TextComponent ~= nil then
      name.TextComponent.Text = ""
    end
    if name.BitmapFontRendererComponent ~= nil then
      name.BitmapFontRendererComponent.text = ""
      name.BitmapFontRendererComponent:drawText()
    end
  end
end

function ChatLogic.sendMegaphoneFromUI(self)
  local message = self:getMegaphoneInputText()
  if ___MOD._UtilLogic:IsNilorEmptyString(message) then
    local megaphoneItemId = self._T.megaphoneItemId or 5072000
    if megaphoneItemId == 5076000 then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "아이템확성기 메시지를 입력해주세요.")
    else
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "고성능확성기 메시지를 입력해주세요.")
    end
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or not ___MOD.isvalid(user.PlayerChatComponent) then
    return
  end
  local soundPath = "Game.img.UseShopItem"
  local soundRUID = ___MOD.__RUIDManager:get(soundPath)
  if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
    ___MOD._SoundService:PlaySound(soundRUID, 1)
  end
  local megaphoneItemId = self._T.megaphoneItemId or 5072000
  local linkedItemId = 0
  local linkedInvType = 0
  local linkedInvSlot = 0
  if megaphoneItemId == 5076000 then
    linkedItemId = ___MOD.tonumber(self._T.itemMegaphoneSelectedItemId) or 0
    linkedInvType = ___MOD.tonumber(self._T.itemMegaphoneSelectedInvType) or 0
    linkedInvSlot = ___MOD.tonumber(self._T.itemMegaphoneSelectedInvSlot) or 0
    if linkedItemId <= 0 then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "아이템확성기에 등록할 아이템을 올려주세요.")
      return
    end
  end
  user.PlayerChatComponent:SendMegaphoneWithItemPayload(message, megaphoneItemId, linkedItemId, linkedInvType, linkedInvSlot)
  self:closeMegaphoneUI()
end

function ChatLogic.setChatTargetText(self, target)
  if not ___MOD.isvalid(self.chatTargetText) or self.chatTargetText.BitmapFontRendererComponent == nil then
    return
  end
  local font = self.chatTargetText.BitmapFontRendererComponent
  font.richText = false
  font.text = target
  font:drawText()
end

function ChatLogic.setMegaphoneIconVisible(self, logEntity, channelOrNil)
  self:ensureMegaphoneIcon(logEntity)
  local isMiniChat = false
  local chatEntity = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat")
  if ___MOD.isvalid(chatEntity) and chatEntity.ChatLogComponent ~= nil then
    isMiniChat = chatEntity.ChatLogComponent.isMini == true
  end
  self:updateMegaphoneIconLayout(logEntity, isMiniChat)
  local base = logEntity:GetChildByName("MegaphoneBase")
  local textEntity = logEntity:GetChildByName("Text")
  if not ___MOD.isvalid(base) or not ___MOD.isvalid(textEntity) then
    return
  end
  local textTransform = textEntity.UITransformComponent
  if channelOrNil == nil then
    base.Visible = false
    for i = 1, 4 do
      local num = logEntity:GetChildByName("MegaphoneNum" .. ___MOD.tostring(i))
      if ___MOD.isvalid(num) then
        num.Visible = false
      end
    end
    textTransform.anchoredPosition.x = 12
    return
  end
  base.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get("UI.UIWindow.Megaphone.ch0")
  base.Visible = true
  local channel = ___MOD.math.floor(___MOD.tonumber(channelOrNil) or 0)
  if channel < 0 then
    channel = 0
  end
  if 9999 < channel then
    channel = 9999
  end
  local digits = ___MOD.string.format("%04d", channel)
  for i = 1, 4 do
    local d = digits:sub(i, i)
    local num = logEntity:GetChildByName("MegaphoneNum" .. ___MOD.tostring(i))
    if ___MOD.isvalid(num) then
      num.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get("UI.UIWindow.Megaphone.Num." .. d)
      num.Visible = true
    end
  end
  textTransform.anchoredPosition.x = 12
end

function ChatLogic.setMegaphoneInputText(self, value)
  local ui = self:getActiveMegaphoneUIEntity()
  if not ___MOD.isvalid(ui) then
    return
  end
  local textEntity = ui:GetChildByName("Text")
  if not ___MOD.isvalid(textEntity) then
    for _, child in ___MOD.pairs(ui.Children) do
      if child.TextInputComponent ~= nil or child.TextGUIRendererInputComponent ~= nil then
        textEntity = child
        break
      end
    end
  end
  if not ___MOD.isvalid(textEntity) then
    return
  end
  if textEntity.TextInputComponent ~= nil then
    textEntity.TextInputComponent.Text = value
  end
  if textEntity.TextGUIRendererInputComponent ~= nil then
    textEntity.TextGUIRendererInputComponent.Text = value
  end
  if textEntity.TextComponent ~= nil then
    textEntity.TextComponent.Text = value
  end
  if textEntity.TextGUIRendererComponent ~= nil then
    textEntity.TextGUIRendererComponent.Text = value
  end
end

function ChatLogic.setMegaphoneSenderName(self, logEntity, senderName)
  self:ensureMegaphoneStateTables()
  self._T.megaphoneSenderByLogEntity[logEntity] = senderName or ""
end

function ChatLogic.setWhisperTarget(self, target)
  local chat = ___MOD._UserService.LocalPlayer.PlayerChatComponent
  target = ___MOD._RichTextUtils:stripRichTextCommands(target)
  self.lastWhisperSender = target
  chat.chatTarget = ___MOD._ChatTargetType.Whisper
  chat.whisperTarget = target
  self:setChatTargetText(target)
end

function ChatLogic.showItemSpeakerTooltipPopup(self, logEntity, meta)
  local itemId = ___MOD.tonumber(meta.itemId) or 0
  if itemId <= 0 then
    self:hideItemSpeakerTooltipPopup()
    return
  end
  local tooltip = self:prepareItemSpeakerTooltip(meta)
  if tooltip == nil then
    return
  end
  self._T.itemSpeakerTooltipActiveLog = logEntity
  self._T.itemSpeakerTooltipAnchorCursorPos = ___MOD._UIUtilLogic:getCursorUIPosition()
  tooltip:showTooltip(true)
  tooltip:tooltipMoveToMouse()
  if tooltip.mouseEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.MouseMoveEvent, tooltip.mouseEvent)
    tooltip.mouseEvent = nil
  end
  self:startItemSpeakerTooltipDistanceWatcher(logEntity)
end

function ChatLogic.showMobileItemSpeakerTooltipPopup(self, logEntity, meta, touchPoint)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) or localPlayer.Player == nil or not localPlayer.Player:isMobileUIPlatform() then
    return
  end
  local itemId = ___MOD.tonumber(meta and meta.itemId) or 0
  if itemId <= 0 then
    self:hideItemSpeakerTooltipPopup()
    return
  end
  local tooltip = self:prepareItemSpeakerTooltip(meta)
  if tooltip == nil then
    return
  end
  if self._T.itemSpeakerTooltipDistanceWatcher ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.MouseMoveEvent, self._T.itemSpeakerTooltipDistanceWatcher)
    self._T.itemSpeakerTooltipDistanceWatcher = nil
  end
  self._T.itemSpeakerTooltipActiveLog = logEntity
  self._T.itemSpeakerTooltipAnchorCursorPos = nil
  tooltip._T.mobileTooltipTouchPoint = touchPoint
  tooltip:showTooltip(true)
end

function ChatLogic.showWhisperUI(self)
  if self.ignoreWhisperHotkeyUntil > ___MOD._UtilLogic.ElapsedSeconds then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local initialTarget = self.lastWhisperSender
  ___MOD._UINotice:showComboBoxUIDefault("귓속말 상대를 입력하세요.", self.whisperHistory, true, initialTarget, function(base, target)
    if ___MOD._UtilLogic:IsNilorEmptyString(target) then
      ___MOD._UINotice:showAlertUI("상대를 입력해주세요.")
      return
    elseif target == user.Player.Name then
      ___MOD._UINotice:showAlertUI("자신에게는 귓속말을 할 수 없습니다.")
      return
    end
    self:setWhisperTarget(target)
    self:addWhisperHistory(target)
    ___MOD._UINotice:removeUINotice(base)
    if ___MOD.isvalid(base) then
      base:Destroy()
    end
  end, true)
end

function ChatLogic.showWhisperUIWithDefault(self, defaultTarget)
  if self.ignoreWhisperHotkeyUntil > ___MOD._UtilLogic.ElapsedSeconds then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local initialTarget = defaultTarget
  if ___MOD._UtilLogic:IsNilorEmptyString(initialTarget) then
    initialTarget = self.lastWhisperSender
  end
  ___MOD._UINotice:showComboBoxUIDefault("귓속말 상대를 입력하세요.", self.whisperHistory, true, initialTarget, function(base, target)
    if ___MOD._UtilLogic:IsNilorEmptyString(target) then
      ___MOD._UINotice:showAlertUI("상대를 입력해주세요.")
      return
    elseif target == user.Player.Name then
      ___MOD._UINotice:showAlertUI("자신에게는 귓속말을 할 수 없습니다.")
      return
    end
    self:setWhisperTarget(target)
    self:addWhisperHistory(target)
    ___MOD._UINotice:removeUINotice(base)
    if ___MOD.isvalid(base) then
      base:Destroy()
    end
  end, true)
end

function ChatLogic.startItemSpeakerTooltipDistanceWatcher(self, logEntity)
  if self._T.itemSpeakerTooltipDistanceWatcher ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.MouseMoveEvent, self._T.itemSpeakerTooltipDistanceWatcher)
    self._T.itemSpeakerTooltipDistanceWatcher = nil
  end
  local threshold = ___MOD.tonumber(self.itemSpeakerTooltipHideDistance) or 90
  local anchor = self._T.itemSpeakerTooltipAnchorCursorPos
  self._T.itemSpeakerTooltipDistanceWatcher = ___MOD._InputService:ConnectEvent(___MOD.MouseMoveEvent, function()
    if self._T.itemSpeakerTooltipActiveLog ~= logEntity then
      return
    end
    if anchor == nil then
      self:hideItemSpeakerTooltipPopup()
      return
    end
    local cursor = ___MOD._UIUtilLogic:getCursorUIPosition()
    local dx = (___MOD.tonumber(cursor.x) or 0) - (___MOD.tonumber(anchor.x) or 0)
    local dy = (___MOD.tonumber(cursor.y) or 0) - (___MOD.tonumber(anchor.y) or 0)
    local dist = ___MOD.math.sqrt(dx * dx + dy * dy)
    if dist > threshold then
      self:hideItemSpeakerTooltipPopup()
    end
  end)
end

function ChatLogic.toggleMobileChatBoard(self, ignoreFocusedInput)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) or localPlayer.Player == nil or not self:isMobileChatUIActive() then
    return false
  end
  local mobileChat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  if not ___MOD.isvalid(mobileChat) or mobileChat.UIMobileChat == nil then
    return false
  end
  mobileChat.UIMobileChat:toggleMobileChatBoard(ignoreFocusedInput)
  return true
end

function ChatLogic.tryOpenMobileChatBoardWithTarget(self, target)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) or localPlayer.Player == nil or not self:isMobileChatUIActive() then
    return false
  end
  local mobileChat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  if ___MOD.isvalid(mobileChat) and mobileChat.UIMobileChat ~= nil then
    mobileChat.UIMobileChat:openMobileChatBoardWithTarget(target)
  end
  return true
end

function ChatLogic.updateMegaphoneIconLayout(self, logEntity, isMini)
  if not ___MOD.isvalid(logEntity) then
    return
  end
  local base = logEntity:GetChildByName("MegaphoneBase")
  if ___MOD.isvalid(base) and base.UITransformComponent ~= nil then
    base.UITransformComponent.anchoredPosition.y = isMini and -13 or -2
  end
  for i = 1, 4 do
    local num = logEntity:GetChildByName("MegaphoneNum" .. ___MOD.tostring(i))
    if ___MOD.isvalid(num) and num.UITransformComponent ~= nil then
      num.UITransformComponent.anchoredPosition.x = 36 + (i - 1) * 12
      num.UITransformComponent.anchoredPosition.y = isMini and -20 or -9
      num.UITransformComponent.RectSize = ___MOD.FastVector2(10, 12)
    end
  end
end

function ChatLogic.updateMobileChatLatest(self, messageType, message, channelNumber)
  local mobileChat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  if ___MOD.isvalid(mobileChat) and mobileChat.UIMobileChat ~= nil then
    mobileChat.UIMobileChat:updateLatestChat(messageType, message, channelNumber)
  end
end

function ChatLogic.wrapChatLogMSWTextByWidth(self, text, wrapWidth)
  local source = text or ""
  local widthLimit = ___MOD.math.max(1, ___MOD.tonumber(wrapWidth) or 1)
  local lines = {}
  local currentLine = ""
  local currentWidth = 0
  if ___MOD.string.find(source, "\r", 1, true) ~= nil then
    source = ___MOD.string.gsub(source, "\r\n", "\n")
    source = ___MOD.string.gsub(source, "\n\r", "\n")
    source = ___MOD.string.gsub(source, "\r", "\n")
  end
  for _, cp in ___MOD.utf8.codes(source) do
    if cp == 10 then
      ___MOD.table.insert(lines, currentLine)
      currentLine = ""
      currentWidth = 0
    else
      local ch = ___MOD.utf8.char(cp)
      local charWidth = self:getMSWPreferredWidthCached(ch, self:getChatLogMSWFontSize())
      if currentLine ~= "" and widthLimit < currentWidth + charWidth then
        ___MOD.table.insert(lines, currentLine)
        currentLine = ch
        currentWidth = charWidth
      else
        currentLine = currentLine .. ch
        currentWidth = currentWidth + charWidth
      end
    end
  end
  if currentLine ~= "" or #lines == 0 then
    ___MOD.table.insert(lines, currentLine)
  end
  return lines
end

function ChatLogic.wrapChatLogTextByWidth(self, text, wrapWidth)
  local source = text or ""
  return ___MOD._BitmapFontService:wrapTextByWidth(source, ___MOD._BitmapFontType.Gulim9pt, wrapWidth, false)
end
