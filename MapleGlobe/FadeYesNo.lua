

function FadeYesNo.applyMobileFadeYesNoSpawnPosition(self, fade, offsetY)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  if not ___MOD.isvalid(fade) or fade.UITransformComponent == nil then
    return
  end
  local size = fade.UITransformComponent.RectSize
  local halfWidth = (size ~= nil and ___MOD.tonumber(size.x) or 0) * 0.5
  local halfHeight = (size ~= nil and ___MOD.tonumber(size.y) or 0) * 0.5
  local position = self:getMobileFadeYesNoPosition(offsetY, halfWidth, halfHeight)
  fade.UITransformComponent.anchoredPosition = position
end

function FadeYesNo.cleanupFadeYesNoEntry(self, entry, destroyEntity)
  if entry == nil then
    return
  end
  if 0 < (___MOD.tonumber(entry.closeTimer) or 0) then
    ___MOD._TimerService:ClearTimer(entry.closeTimer)
  end
  entry.closeTimer = 0
  if 0 < (___MOD.tonumber(entry.positionTimer) or 0) then
    ___MOD._TimerService:ClearTimer(entry.positionTimer)
  end
  entry.positionTimer = 0
  if ___MOD.isvalid(entry.showTween) then
    entry.showTween:Destroy()
  end
  entry.showTween = nil
  if ___MOD.isvalid(entry.closeTween) then
    entry.closeTween:Destroy()
  end
  entry.closeTween = nil
  if entry.okHandler ~= nil and ___MOD.isvalid(entry.okButton) then
    entry.okButton:DisconnectEvent(___MOD.ButtonClickEvent, entry.okHandler)
  end
  entry.okHandler = nil
  if entry.cancelHandler ~= nil and ___MOD.isvalid(entry.cancelButton) then
    entry.cancelButton:DisconnectEvent(___MOD.ButtonClickEvent, entry.cancelHandler)
  end
  entry.cancelHandler = nil
  if destroyEntity and ___MOD.isvalid(entry.entity) then
    entry.entity:Destroy()
  end
end

function FadeYesNo.closeFadeYesNoByKey(self, requestKey)
  if ___MOD._UtilLogic:IsNilorEmptyString(requestKey) then
    return
  end
  local prevId = self.fadeYesNoByKey[requestKey]
  if prevId == nil then
    return
  end
  self.fadeYesNoByKey[requestKey] = nil
  local prevEntry = self.fadeYesNo[prevId]
  if prevEntry == nil then
    return
  end
  self.fadeYesNo[prevId] = nil
  self:cleanupFadeYesNoEntry(prevEntry, true)
end

function FadeYesNo.createFadeYesNo(self, backgroundType, iconType, onlyCancelBtn, message, closeDuration, BtCallback, alignment, forceMSWPosX, requestKey)
  local previousId, offsetY
  if not ___MOD._UtilLogic:IsNilorEmptyString(requestKey) then
    previousId = self.fadeYesNoByKey[requestKey]
    local previousEntry = previousId ~= nil and self.fadeYesNo[previousId] or nil
    if previousEntry ~= nil then
      offsetY = ___MOD.tonumber(previousEntry.slot)
    end
  end
  self:closeFadeYesNoByKey(requestKey)
  if offsetY == nil or offsetY < 0 then
    offsetY = self:getAvailableFadeYesNoSlot()
  else
    offsetY = ___MOD.math.max(0, ___MOD.math.floor(offsetY))
  end
  local model = ___MOD._EntryService:GetModelIdByName("Model_FadeYesNo")
  local fade = ___MOD._SpawnService:SpawnByModelId(model, "FadeYesNo", self:getFadeYesNoSpawnPosition(offsetY), self.parent)
  local entry = {
    entity = fade,
    closeTimer = 0,
    positionTimer = 0,
    showTween = nil,
    closeTween = nil,
    key = requestKey,
    slot = offsetY,
    okButton = nil,
    cancelButton = nil,
    okHandler = nil,
    cancelHandler = nil
  }
  self.fadeYesNo[fade.Id] = entry
  if not ___MOD._UtilLogic:IsNilorEmptyString(requestKey) then
    self.fadeYesNoByKey[requestKey] = fade.Id
  end
  local icon = fade:GetChildByName("icon")
  local message_ = fade:GetChildByName("message")
  local BtOK = fade:GetChildByName("BtOK")
  local BtCancel = fade:GetChildByName("BtCancel")
  entry.okButton = BtOK
  entry.cancelButton = BtCancel
  local iconRUID = ""
  if 0 <= (___MOD.tonumber(iconType) or 0) then
    iconRUID = ___MOD.__RUIDManager:get(___MOD.string.format("UI.UIWindow.FadeYesNo.icon%d", iconType))
  end
  local backgrndPath, backgrndRUID
  if 1 < backgroundType then
    backgrndPath = ___MOD.string.format("UI.UIWindow.FadeYesNo.backgrnd%d", backgroundType)
    backgrndRUID = ___MOD.__RUIDManager:get(backgrndPath)
  else
    backgrndPath = "UI.UIWindow.FadeYesNo.backgrnd"
    backgrndRUID = ___MOD.__RUIDManager:get(backgrndPath)
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(backgrndRUID) then
    ___MOD.log_error("존재하지 않는 RUID")
    fade:Destroy()
    return
  end
  fade.SpriteGUIRendererComponent.ImageRUID = backgrndRUID
  local backgrndSize = ___MOD._UIManager:getImageSize(backgrndPath)
  if backgrndSize ~= nil then
    fade.UITransformComponent.RectSize = ___MOD.FastVector2(backgrndSize.x, backgrndSize.y)
  else
    local prevSize = fade.UITransformComponent.RectSize
    local w = prevSize and ___MOD.tonumber(prevSize.x) or 320
    local h = prevSize and ___MOD.tonumber(prevSize.y) or 180
    fade.UITransformComponent.RectSize = ___MOD.FastVector2(w, h)
  end
  self:applyMobileFadeYesNoSpawnPosition(fade, offsetY)
  local showIcon = not ___MOD._UtilLogic:IsNilorEmptyString(iconRUID)
  if icon ~= nil then
    icon:SetEnable(showIcon)
    icon:SetVisible(showIcon)
    if showIcon and icon.SpriteGUIRendererComponent ~= nil then
      icon.SpriteGUIRendererComponent.ImageRUID = iconRUID
    end
  end
  local text = message_.BitmapFontRendererComponent
  text.richText = true
  text.alignmentType = alignment
  text.fadeYesNoBackgroundType = backgroundType
  text.forceMSWPosX = ___MOD.tonumber(forceMSWPosX) or -9999
  local useMSW = text:shouldUseMSWFont()
  if useMSW and ___MOD.isvalid(message_.UITransformComponent) then
    local fixedH = 0
    if backgroundType == 1 or backgroundType == 7 or backgroundType == 8 or backgroundType == 9 then
      fixedH = 100
    elseif backgroundType == 2 or backgroundType == 3 or backgroundType == 4 or backgroundType == 6 then
      fixedH = 68
    elseif backgroundType == 5 then
      fixedH = 82
    end
    if 0 < fixedH then
      local tr = message_.UITransformComponent
      tr.RectSize = ___MOD.FastVector2(tr.RectSize.x or 1, fixedH)
      tr.anchoredPosition = ___MOD.FastVector2(tr.anchoredPosition and tr.anchoredPosition.x or 0, 0)
    end
  end
  local maxLineW = 0
  if fade.UITransformComponent ~= nil then
    local baseW = ___MOD.tonumber(fade.UITransformComponent.RectSize.x) or 0
    local isLoginNoticeLayout = forceMSWPosX == 66
    if isLoginNoticeLayout then
      maxLineW = ___MOD.math.max(150, ___MOD.math.floor(baseW - forceMSWPosX - 38))
    else
      local padding = showIcon and 120 or 80
      maxLineW = ___MOD.math.max(150, ___MOD.math.floor(baseW - padding))
    end
  end
  text.maxLineWidth = maxLineW
  text.text = message
  text.tokens = ___MOD._BitmapFontService:tokenizeRich(text.text, text.color, text.richText, true)
  text.info = ___MOD._BitmapFontService:measureRich(text.tokens, text.font, text.startPos, maxLineW, 6, alignment)
  if alignment == ___MOD._BitmapFontAlignmentType.Left then
    message_.UITransformComponent.anchoredPosition.x = 0
  end
  text:drawText()
  if useMSW and forceMSWPosX then
    local targetPosX = ___MOD.tonumber(forceMSWPosX) or 0
    local tr = message_.UITransformComponent
    tr.anchoredPosition = ___MOD.FastVector2(targetPosX, tr.anchoredPosition and tr.anchoredPosition.y or 0)
    entry.positionTimer = ___MOD._TimerService:SetTimerOnce(function()
      entry.positionTimer = 0
      if not (self.fadeYesNo[fade.Id] == entry and ___MOD.isvalid(fade) and ___MOD.isvalid(message_)) or message_.UITransformComponent == nil then
        return
      end
      local delayedTr = message_.UITransformComponent
      delayedTr.anchoredPosition = ___MOD.FastVector2(targetPosX, delayedTr.anchoredPosition and delayedTr.anchoredPosition.y or 0)
    end, 0.05)
  end

  local function BtClickCallback(result)
    if self.fadeYesNo[fade.Id] ~= entry then
      return
    end
    self.fadeYesNo[fade.Id] = nil
    if entry.key ~= nil and self.fadeYesNoByKey[entry.key] == fade.Id then
      self.fadeYesNoByKey[entry.key] = nil
    end
    self:cleanupFadeYesNoEntry(entry, false)
    if BtCallback then
      BtCallback(result)
    end
    if not ___MOD.isvalid(fade) or fade.CanvasGroupComponent == nil then
      return
    end
    fade.CanvasGroupComponent.Interactable = false
    self.fadeYesNoClosing[fade.Id] = entry
    entry.closeTween = ___MOD._TweenLogic:PlayTween(1, 0, 0.5, ___MOD.EaseType.Linear, function(v)
      if self.fadeYesNoClosing[fade.Id] == entry and ___MOD.isvalid(fade) and fade.CanvasGroupComponent ~= nil then
        fade.CanvasGroupComponent.GroupAlpha = v
      end
    end)
    if ___MOD.isvalid(entry.closeTween) then
      entry.closeTween:SetOnEndCallback(function()
        if self.fadeYesNoClosing[fade.Id] == entry then
          self.fadeYesNoClosing[fade.Id] = nil
        end
        entry.closeTween = nil
        if ___MOD.isvalid(fade) then
          fade:Destroy()
        end
      end)
    elseif ___MOD.isvalid(fade) then
      self.fadeYesNoClosing[fade.Id] = nil
      fade:Destroy()
    end
  end

  if closeDuration then
    entry.closeTimer = ___MOD._TimerService:SetTimerOnce(function()
      BtClickCallback(false)
    end, closeDuration)
  end
  if onlyCancelBtn then
    BtOK:SetEnable(false)
  else
    entry.okHandler = BtOK:ConnectEvent(___MOD.ButtonClickEvent, function()
      BtClickCallback(true)
    end)
  end
  entry.cancelHandler = BtCancel:ConnectEvent(___MOD.ButtonClickEvent, function()
    BtClickCallback(false)
  end)
  entry.showTween = ___MOD._TweenLogic:PlayTween(0, 1, 0.5, ___MOD.EaseType.Linear, function(v)
    if self.fadeYesNo[fade.Id] == entry and ___MOD.isvalid(fade) and fade.CanvasGroupComponent ~= nil then
      fade.CanvasGroupComponent.GroupAlpha = v
    end
  end)
  if ___MOD.isvalid(entry.showTween) then
    entry.showTween:SetOnEndCallback(function()
      if self.fadeYesNo[fade.Id] == entry then
        entry.showTween = nil
      end
    end)
  end
  ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.Invite"), 1)
end

function FadeYesNo.getAvailableFadeYesNoSlot(self)
  local usedSlots = {}
  for _, entry in ___MOD.pairs(self.fadeYesNo) do
    if entry ~= nil and ___MOD.isvalid(entry.entity) and ___MOD.tonumber(entry.slot) ~= nil then
      usedSlots[___MOD.math.max(0, ___MOD.math.floor(___MOD.tonumber(entry.slot)))] = true
    end
  end
  for _, entry in ___MOD.pairs(self.fadeYesNoClosing) do
    if entry ~= nil and ___MOD.isvalid(entry.entity) and ___MOD.tonumber(entry.slot) ~= nil then
      usedSlots[___MOD.math.max(0, ___MOD.math.floor(___MOD.tonumber(entry.slot)))] = true
    end
  end
  local slot = 0
  while usedSlots[slot] == true do
    slot = slot + 1
  end
  return slot
end

function FadeYesNo.getFadeYesNoSpawnPosition(self, offsetY)
  if ___MOD.Environment:IsMobilePlatform() then
    local position = self:getMobileFadeYesNoPosition(offsetY, 0, 0)
    local x = position.x
    local y = position.y
    return ___MOD.FastVector3(x, y, 0)
  end
  return ___MOD.FastVector3(266, -416 + offsetY * 20, 0)
end

function FadeYesNo.getMobileFadeYesNoPosition(self, offsetY, halfWidth, halfHeight)
  local layoutRect, statusRect
  if ___MOD._UIMobileHudLayout ~= nil then
    layoutRect = ___MOD._UIMobileHudLayout:getCurrentMobileLayoutRect()
    statusRect = ___MOD._UIMobileHudLayout:getMobileStatusBarRect()
  end
  if layoutRect == nil then
    local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
    local width = ___MOD.tonumber(___MOD._UILogic.ScreenWidth) or 1920
    local height = ___MOD.tonumber(___MOD._UILogic.ScreenHeight) or 1080
    if ___MOD.isvalid(uiGroup) and uiGroup.UITransformComponent ~= nil and uiGroup.UITransformComponent.RectSize ~= nil then
      local size = uiGroup.UITransformComponent.RectSize
      width = ___MOD.tonumber(size.x) or width
      height = ___MOD.tonumber(size.y) or height
    end
    local halfLayoutWidth = width * 0.5
    local halfLayoutHeight = height * 0.5
    layoutRect = {
      left = -halfLayoutWidth,
      right = halfLayoutWidth,
      top = halfLayoutHeight,
      bottom = -halfLayoutHeight
    }
  end
  local x = (layoutRect.left + layoutRect.right) * 0.5
  local baseTop = layoutRect.bottom + 200
  if statusRect ~= nil then
    x = (statusRect.left + statusRect.right) * 0.5
    baseTop = statusRect.top
  end
  local marginX = ___MOD.math.max(0, ___MOD.tonumber(self.mobileFadeYesNoMarginX) or 0)
  local marginY = ___MOD.math.max(0, ___MOD.tonumber(self.mobileFadeYesNoMarginY) or 0)
  local safeHalfWidth = ___MOD.math.max(0, ___MOD.tonumber(halfWidth) or 0)
  local safeHalfHeight = ___MOD.math.max(0, ___MOD.tonumber(halfHeight) or 0)
  x = x + (___MOD.tonumber(self.mobileFadeYesNoOffsetX) or 0)
  local y = baseTop + safeHalfHeight + marginY + (___MOD.tonumber(self.mobileFadeYesNoOffsetY) or 0) + (___MOD.tonumber(offsetY) or 0) * (___MOD.tonumber(self.mobileFadeYesNoStackOffsetY) or 20)
  x = ___MOD.math.max(layoutRect.left + safeHalfWidth + marginX, ___MOD.math.min(layoutRect.right - safeHalfWidth - marginX, x))
  y = ___MOD.math.max(layoutRect.bottom + safeHalfHeight + marginY, ___MOD.math.min(layoutRect.top - safeHalfHeight - marginY, y))
  return ___MOD.FastVector2(x, y)
end

function FadeYesNo.resetFadeYesNo(self)
  for _, entry in ___MOD.pairs(self.fadeYesNo) do
    self:cleanupFadeYesNoEntry(entry, true)
  end
  for _, entry in ___MOD.pairs(self.fadeYesNoClosing) do
    self:cleanupFadeYesNoEntry(entry, true)
  end
  self.fadeYesNo = {}
  self.fadeYesNoByKey = {}
  self.fadeYesNoClosing = {}
end
