

function UseItemManager.addTeleportMap(self, senderUserId)

end

function UseItemManager.applyConsumeItemBuff(self, user, itemID, duration)

end

function UseItemManager.applyTeleportScrollPosition(self)
  local mapList = self._T.teleportMapList or {}
  local visibleCount = self:getTeleportVisibleRowCount()
  local maxScroll = ___MOD.math.max(0, #mapList - visibleCount)
  if maxScroll <= 0 then
    self._T.teleportScrollIndex = 0
    self._T.teleportScrollPosition = 0
  else
    local idx = ___MOD.math.max(0, ___MOD.math.min(self._T.teleportScrollIndex or 0, maxScroll))
    self._T.teleportScrollIndex = idx
    self._T.teleportScrollPosition = idx / maxScroll
  end
  self:updateTeleportScrollUI()
  self:updateTeleportUIList()
end

function UseItemManager.canOpenTeleportUIInCurrentMap(self)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) then
    return false
  end
  local mapInfo = user.CurrentMap and user.CurrentMap.MapInfoComponent or nil
  if mapInfo == nil then
    return true
  end
  local teleportFieldLimit = ___MOD._FieldLimit ~= nil and ___MOD._FieldLimit.UnableToUseTeleportItem or nil
  if teleportFieldLimit ~= nil and mapInfo:checkFieldLimit(teleportFieldLimit) then
    ___MOD._UINotice:showAlertUI("순간이동이 불가능한 지역입니다.")
    return false
  end
  return true
end

function UseItemManager.canUseTeleportItemByLevelClient(self)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or user.Player == nil then
    return false
  end
  if (___MOD.tonumber(user.Player.Level) or 0) < 10 then
    ___MOD._UINotice:showAlertUI("레벨 10 이상만 사용 가능합니다.")
    return false
  end
  return true
end

function UseItemManager.canUseTeleportItemByLevelServer(self, user, userId)

end

function UseItemManager.clearMiracleCubeSessionIdClient(self)
  self._T.miracleCubeSessionId = nil
end

function UseItemManager.clearMiracleCubeUIStateClient(self)
  if self._T.miracleCubeEscapeEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.KeyDownEvent, self._T.miracleCubeEscapeEvent)
    self._T.miracleCubeEscapeEvent = nil
  end
  if self._T.miracleCubeOpened == true then
    self._T.miracleCubeOpened = false
    ___MOD._UIWindowLogic:setOpenedUICount(-1)
  end
  self._T.miracleCubeItemId = nil
end

function UseItemManager.clearTeleportInputFieldClient(self)
  local inputField = self._T.teleportInputField
  if inputField == nil then
    return
  end
  if inputField.TextInputComponent ~= nil then
    inputField.TextInputComponent.Text = ""
  end
  if inputField.TextGUIRendererInputComponent ~= nil then
    inputField.TextGUIRendererInputComponent.Text = ""
  end
  if inputField.TextComponent ~= nil then
    inputField.TextComponent.Text = ""
  end
end

function UseItemManager.clearTeleportSelectionClient(self)
  if (self._T.teleportSelectedIndex or 0) <= 0 then
    return
  end
  self._T.teleportSelectedIndex = 0
  self:updateTeleportUIList()
end

function UseItemManager.closeMiracleCubeUI(self)
  local cube = self.miracleCube
  if ___MOD.isvalid(cube) and cube.MiracleCubeUIComponent ~= nil then
    cube.MiracleCubeUIComponent:cleanupCubeUI()
    cube:Destroy()
    return
  end
  self:onMiracleCubeUICleanupClient(cube)
end

function UseItemManager.closeTeleportUI(self)
  self:teleportInitUI()
  self:clearTeleportInputFieldClient()
  local root = self._T.teleportRoot
  if root ~= nil then
    root:SetEnable(false)
  end
  if self._T.teleportEscapeEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.KeyDownEvent, self._T.teleportEscapeEvent)
    self._T.teleportEscapeEvent = nil
  end
  if self._T.teleportOpened == true then
    self._T.teleportOpened = false
    ___MOD._UIWindowLogic:setOpenedUICount(-1)
  end
  ___MOD._UIWindowLogic:ensureOpenedUICountAtLeastVisibleWindows()
end

function UseItemManager.closeTryMacroUI(self)
  self:tryMacroInitUI()
  local root = self._T.tryMacroRoot
  if root == nil then
    return
  end
  root:SetEnable(false)
  if self._T.tryMacroEscapeEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.KeyDownEvent, self._T.tryMacroEscapeEvent)
    self._T.tryMacroEscapeEvent = nil
  end
  if self._T.tryMacroOpened == true then
    self._T.tryMacroOpened = false
    ___MOD._UIWindowLogic:setOpenedUICount(-1)
  end
end

function UseItemManager.completeInventorySlotExpand(self, user, selected)

end

function UseItemManager.confirmTeleportCharacterMove(self, targetName, mapName, mapId)
  if ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    return
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(mapName) then
    mapName = ___MOD.tostring(mapId or 0)
  end
  local msg = ___MOD.string.format("%s 님은 다음맵에 있습니다.\r\n정말 이동하시겠습니까?\r\n[%s]", targetName, mapName)
  ___MOD._UINotice:showYesNoUI(msg, function()
    self:closeTeleportUI()
    local soundRUID = ___MOD.__RUIDManager:get("Game.img.UseShopItem")
    if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
      ___MOD._SoundService:PlaySound(soundRUID, 1)
    end
    self:teleportMoveToMap(mapId)
  end)
end

function UseItemManager.consumeTeleportItemServer(self, user, userId)

end

function UseItemManager.detectMacroAllowIdleInDedicatedMap(self, user)

end

function UseItemManager.detectMacroApplyInvincible(self, target, invincibleUntil)

end

function UseItemManager.detectMacroCancelAll(self, reason)

end

function UseItemManager.detectMacroCancelByUserId(self, targetuserid, reason)

end

function UseItemManager.detectMacroCloseClient(self)
  self:detectMacroInitUI()
  local root = self._T.detectMacroRoot
  if root ~= nil then
    root:SetEnable(false)
  end
  self:detectMacroStopWatch()
  self:detectMacroReleaseInvincibleClient()
  if self._T.detectMacroOpened == true then
    self._T.detectMacroOpened = false
    ___MOD._UIWindowLogic:setOpenedUICount(-1)
  end
  self.detectMacroUiPersistentOpen = false
  self.detectMacroUiPersistentUrl = ""
end

function UseItemManager.detectMacroCreateExternalCid(self)

end

function UseItemManager.detectMacroEnsureServerState(self)

end

function UseItemManager.detectMacroFinalizeByEventUserId(self, eventUserId, reason)

end

function UseItemManager.detectMacroFinalizeByUserId(self, targetuserid, success, reason)

end

function UseItemManager.detectMacroForceFailByLogout(self, senderUserId)

end

function UseItemManager.detectMacroGetBlockReason(self, user, automatic)

end

function UseItemManager.detectMacroGetReceiveCooldownRemain(self, targetuserid)

end

function UseItemManager.detectMacroGetUrlQueryParam(self, url, key)

end

function UseItemManager.detectMacroHasActiveStateByUserId(self, userId)

end

function UseItemManager.detectMacroHasLiveMob(self, user)

end

function UseItemManager.detectMacroHeartbeat(self, senderUserId)

end

function UseItemManager.detectMacroInitUI(self)
  local currentRoot = self._T.detectMacroRoot
  local currentWebView = self._T.detectMacroWebView
  if self._T.detectMacroInitialized == true and ___MOD.isvalid(currentRoot) and ___MOD.isvalid(currentWebView) then
    return
  end
  local root = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/DetectMacro")
  if not ___MOD.isvalid(root) then
    return
  end
  self._T.detectMacroInitialized = true
  self._T.detectMacroRoot = root
  self._T.detectMacroWebView = root:GetChildByName("WebView")
  if self.detectMacroUiPersistentOpen == true then
    root:SetEnable(true)
    ___MOD._UIWindowLogic:moveToTopLayer(root)
    if ___MOD.isvalid(self._T.detectMacroWebView) and self._T.detectMacroWebView.WebViewComponent ~= nil then
      self._T.detectMacroWebView.WebViewComponent.ClickingEnabled = true
      self._T.detectMacroWebView.WebViewComponent.HoveringEnabled = true
      local currentUrl = ___MOD.tostring(self.detectMacroUiPersistentUrl or "")
      if not ___MOD._UtilLogic:IsNilorEmptyString(currentUrl) then
        self._T.detectMacroWebView.WebViewComponent.Url = currentUrl
      end
    end
  else
    root:SetEnable(false)
  end
end

function UseItemManager.detectMacroIsExcludedMap(self, user)

end

function UseItemManager.detectMacroIsHunting(self, user)

end

function UseItemManager.detectMacroIsMapTransitioning(self, user)

end

function UseItemManager.detectMacroMarkHunting(self, user)

end

function UseItemManager.detectMacroOpenClient(self, url, externalCid)
  self:detectMacroInitUI()
  local root = self._T.detectMacroRoot
  local web = self._T.detectMacroWebView
  if root == nil or web == nil then
    return
  end
  local alreadyOpened = self.detectMacroUiPersistentOpen == true or self._T.detectMacroOpened == true or root.EnabledInHierarchy
  if self.detectMacroUiPersistentOpen ~= true then
    self.detectMacroUiPersistentOpen = true
  end
  if self._T.detectMacroOpened ~= true then
    self._T.detectMacroOpened = true
    ___MOD._UIWindowLogic:setOpenedUICount(1)
  end
  root:SetEnable(true)
  ___MOD._UIWindowLogic:moveToTopLayer(root)
  if web.WebViewComponent ~= nil then
    web.WebViewComponent.ClickingEnabled = true
    web.WebViewComponent.HoveringEnabled = true
    local query = ""
    if not ___MOD._UtilLogic:IsNilorEmptyString(externalCid) then
      query = ___MOD.string.format("?cid=%s", ___MOD._HttpService:UrlEncode(externalCid))
    end
    self.detectMacroUiPersistentUrl = url .. query
    web.WebViewComponent.Url = self.detectMacroUiPersistentUrl
  end
  if alreadyOpened ~= true then
    local user = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(user) and user.PlayerHitComponent ~= nil then
      user.PlayerHitComponent.hitTime = ___MOD.math.max(user.PlayerHitComponent.hitTime, ___MOD._UtilLogic.ServerElapsedSeconds + 21)
    end
  end
  self._T.detectMacroReported = false
  self:detectMacroStartWatch()
end

function UseItemManager.detectMacroPollUrl(self)
  local root = self._T.detectMacroRoot
  local web = self._T.detectMacroWebView
  if root == nil or web == nil or not root.EnabledInHierarchy then
    return
  end
  if self._T.detectMacroReported == true then
    return
  end
  self:detectMacroHeartbeat()
  if web.WebViewComponent == nil then
    return
  end
  local url = web.WebViewComponent.Url or ""
  if ___MOD._UtilLogic:IsNilorEmptyString(url) then
    return
  end
  self.detectMacroUiPersistentUrl = ___MOD.tostring(url)
  if ___MOD.string.find(url, "https://mapleplanet.co.kr/Macro/Macro/Macro/success.php", 1, true) ~= nil then
    self._T.detectMacroReported = true
    self:detectMacroReportResult(true, url)
    return
  end
  if ___MOD.string.find(url, "https://mapleplanet.co.kr/Macro/Macro/Macro/fail.php", 1, true) ~= nil then
    self._T.detectMacroReported = true
    self:detectMacroReportResult(false, url)
    return
  end
end

function UseItemManager.detectMacroRandomInteger(self, minValue, maxValue)

end

function UseItemManager.detectMacroReleaseInvincible(self, target)

end

function UseItemManager.detectMacroReleaseInvincibleClient(self)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or user.PlayerHitComponent == nil then
    return
  end
  user.PlayerHitComponent.hitTime = ___MOD._UtilLogic.ServerElapsedSeconds + 1
end

function UseItemManager.detectMacroReportResult(self, success, pageUrl, senderUserId)

end

function UseItemManager.detectMacroRescheduleAllAutoChecks(self, minSec, maxSec)

end

function UseItemManager.detectMacroRestoreClient(self, retryCount)
  if self.detectMacroUiPersistentOpen ~= true then
    return
  end
  local currentRoot = self._T.detectMacroRoot
  local currentWeb = self._T.detectMacroWebView
  if ___MOD.isvalid(currentRoot) and ___MOD.isvalid(currentWeb) then
    currentRoot:SetEnable(true)
    ___MOD._UIWindowLogic:moveToTopLayer(currentRoot)
    if self._T.detectMacroWatchTimer == nil then
      self:detectMacroStartWatch()
    end
    return
  end
  self._T.detectMacroInitialized = false
  self._T.detectMacroRoot = nil
  self._T.detectMacroWebView = nil
  self:detectMacroInitUI()
  local root = self._T.detectMacroRoot
  local web = self._T.detectMacroWebView
  if root == nil or web == nil then
    if 0 < (___MOD.tonumber(retryCount) or 0) then
      ___MOD._TimerService:SetTimerOnce(function()
        self:detectMacroRestoreClient((___MOD.tonumber(retryCount) or 0) - 1)
      end, 0.1)
    end
    return
  end
  root:SetEnable(true)
  ___MOD._UIWindowLogic:moveToTopLayer(root)
  if web.WebViewComponent ~= nil then
    web.WebViewComponent.ClickingEnabled = true
    web.WebViewComponent.HoveringEnabled = true
    local currentUrl = ___MOD.tostring(self.detectMacroUiPersistentUrl or "")
    local webUrl = ___MOD.tostring(web.WebViewComponent.Url or "")
    if ___MOD._UtilLogic:IsNilorEmptyString(webUrl) and not ___MOD._UtilLogic:IsNilorEmptyString(currentUrl) then
      web.WebViewComponent.Url = currentUrl
    end
  end
  self:detectMacroStartWatch()
end

function UseItemManager.detectMacroScheduleNextAutoCheck(self, user, minSec, maxSec)

end

function UseItemManager.detectMacroShowFailNotice(self, reason)
  ___MOD._UINotice:showAlertUI("거짓말 탐지기 인증에 실패하여 마을로 이동됩니다.")
end

function UseItemManager.detectMacroShowSuccessNotice(self)
  ___MOD._UINotice:showAlertUI("거짓말 탐지기 테스트에 무사히 통과하셨습니다. 협조해 주셔서 감사합니다. Enjoy Your Life 메이플플래닛!")
end

function UseItemManager.detectMacroStart(self, requester, target)

end

function UseItemManager.detectMacroStartAuto(self, target)

end

function UseItemManager.detectMacroStartForced(self, requester, target)

end

function UseItemManager.detectMacroStartInternal(self, requester, target, automatic, ignoreReceiveCooldown)

end

function UseItemManager.detectMacroStartWatch(self)
  self:detectMacroStopWatch()
  self._T.detectMacroWatchTimer = ___MOD._TimerService:SetTimerRepeat(function()
    self:detectMacroPollUrl()
  end, 1, 0)
end

function UseItemManager.detectMacroStopWatch(self)
  if self._T.detectMacroWatchTimer ~= nil then
    ___MOD._TimerService:ClearTimer(self._T.detectMacroWatchTimer)
    self._T.detectMacroWatchTimer = nil
  end
end

function UseItemManager.detectMacroVerifySuccess(self, state, pageUrl)

end

function UseItemManager.effectConsumeItem(self, user, itemID)

end

function UseItemManager.findMobInItemRange(self, user, targetMobId, left, right, top, bottom)

end

function UseItemManager.findTeleportInputFieldClient(self, root)
  if root == nil then
    return nil
  end
  local stack = {root}
  while 0 < #stack do
    local cur = stack[#stack]
    stack[#stack] = nil
    if cur ~= nil then
      if cur.TextInputComponent ~= nil or cur.TextGUIRendererInputComponent ~= nil then
        return cur
      end
      for _, child in ___MOD.pairs(cur.Children) do
        if child ~= nil then
          stack[#stack + 1] = child
        end
      end
    end
  end
  return nil
end

function UseItemManager.getColorLensTargetFace(self, currentFace, itemId)
  if itemId < 5152100 or 5152107 < itemId or currentFace <= 0 then
    return 0
  end
  local baseFace = currentFace // 1000 * 1000 + currentFace % 100
  local targetFace = baseFace + itemId % 10 * 100
  local faceRuid = ___MOD.__RUIDManager:getByCollection("MSWRUID", ___MOD.tostring(targetFace))
  if ___MOD._UtilLogic:IsNilorEmptyString(faceRuid) or faceRuid == "None" then
    return 0
  end
  return targetFace
end

function UseItemManager.getDeathPenaltySkipReasonForConsumeItem(self, user, itemId)

end

function UseItemManager.getMiracleCubeItemIdClient(self)
  local cubeItemId = ___MOD.tonumber(self._T.miracleCubeItemId) or ___MOD.tonumber(self.miracleCubeItemId) or 5062000
  if cubeItemId ~= 5062000 and cubeItemId ~= 2800000 then
    return 5062000
  end
  return cubeItemId
end

function UseItemManager.getMiracleCubeItemNameClient(self)
  local cubeItemId = self:getMiracleCubeItemIdClient()
  if cubeItemId == 2800000 then
    return "수상한 큐브"
  end
  return "미라클 큐브"
end

function UseItemManager.getMiracleCubeRerollCostByReqLevel(self, reqLevel, senderUserId)

end

function UseItemManager.getMiracleCubeSessionIdClient(self)
  local current = self._T.miracleCubeSessionId
  if not ___MOD._UtilLogic:IsNilorEmptyString(current) then
    return current
  end
  current = ___MOD.string.format("%06d", ___MOD.math.random(100000, 999999))
  self._T.miracleCubeSessionId = current
  return current
end

function UseItemManager.getPendingInventorySlotExpandIncrease(self, user)

end

function UseItemManager.getTeleportInputNameClient(self)
  local inputField = self._T.teleportInputField
  if inputField == nil then
    return ""
  end
  local name = ""
  if inputField.TextInputComponent ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(inputField.TextInputComponent.Text) then
    name = ___MOD.tostring(inputField.TextInputComponent.Text)
  elseif inputField.TextGUIRendererInputComponent ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(inputField.TextGUIRendererInputComponent.Text) then
    name = ___MOD.tostring(inputField.TextGUIRendererInputComponent.Text)
  elseif inputField.TextComponent ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(inputField.TextComponent.Text) then
    name = ___MOD.tostring(inputField.TextComponent.Text)
  end
  name, ___MOD._ = ___MOD.string.gsub(name, "^%s*(.-)%s*$", "%1")
  return name
end

function UseItemManager.getTeleportMapDisplayName(self, mapId)
  local mapName = ___MOD._MapUtils:getMapNameById(mapId)
  if ___MOD._UtilLogic:IsNilorEmptyString(mapName) or mapName == "알 수 없음" then
    mapName = ___MOD.tostring(mapId)
  end
  return mapName
end

function UseItemManager.getTeleportVisibleRowCount(self)
  return 5
end

function UseItemManager.getTryMacroTargetName(self)
  local textEntity = self._T.tryMacroText
  if textEntity == nil then
    return ""
  end
  local name = ""
  if textEntity.TextInputComponent ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(textEntity.TextInputComponent.Text) then
    name = ___MOD.tostring(textEntity.TextInputComponent.Text)
  elseif textEntity.TextComponent ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(textEntity.TextComponent.Text) then
    name = ___MOD.tostring(textEntity.TextComponent.Text)
  end
  name, ___MOD._ = ___MOD.string.gsub(name, "^%s*(.-)%s*$", "%1")
  return name
end

function UseItemManager.HandleTeleportMouseMoveEvent(self, event)
  if self._T.teleportOpened ~= true then
    return
  end
  if self._T.teleportClickScrollBar ~= true then
    return
  end
  if self._T.teleportPrev == nil or self._T.teleportBar == nil then
    return
  end
  if self._T.teleportPrev.UITransformComponent == nil or self._T.teleportBar.UITransformComponent == nil then
    return
  end
  local mapList = self._T.teleportMapList or {}
  local visibleCount = self:getTeleportVisibleRowCount()
  local maxScroll = ___MOD.math.max(0, #mapList - visibleCount)
  if maxScroll <= 0 then
    self._T.teleportScrollIndex = 0
    self._T.teleportScrollPosition = 0
    self:applyTeleportScrollPosition()
    return
  end
  local itemCount = ___MOD.math.max(1, maxScroll)
  local index, barY = ___MOD._OffsetUtils:calcScrollByCursorPos(itemCount, self._T.teleportScrollYSize or 88, self._T.teleportBarBaseY or -51, self._T.teleportPrevBaseY or -13, self._T.teleportPrev)
  self._T.teleportBar.UITransformComponent.anchoredPosition.y = barY
  self._T.teleportScrollIndex = ___MOD.math.max(0, ___MOD.math.min(itemCount, index))
  self._T.teleportScrollPosition = (self._T.teleportScrollIndex or 0) / itemCount
  self:applyTeleportScrollPosition()
end

function UseItemManager.HandleTeleportMouseScrollEvent(self, event)
  if self._T.teleportOpened ~= true then
    return
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  local last = self._T.teleportLastWheelAt or 0
  if now - last < 0.08 then
    return
  end
  self._T.teleportLastWheelAt = now
  local layout = self._T.teleportLayout
  if layout == nil or not layout.EnabledInHierarchy then
    return
  end
  local hoveredUT = layout.UITransformComponent
  if hoveredUT == nil then
    return
  end
  local ancpos = hoveredUT.anchoredPosition:Clone()
  local size = hoveredUT.RectSize
  local lb, rt = ancpos - size / 2, ancpos + size / 2
  local cursorPos = ___MOD._InputService:GetCursorPosition()
  local toLocal = ___MOD._UILogic:ScreenToLocalUIPosition(cursorPos, hoveredUT)
  if toLocal.x >= lb.x and toLocal.x <= rt.x and toLocal.y >= lb.y and toLocal.y <= rt.y then
    local delta = event.ScrollDelta
    if 0 < delta then
      self:teleportChangeScroll(1)
    else
      self:teleportChangeScroll(-1)
    end
  end
end

function UseItemManager.hasCreatedEquipInInventoryOrTamingSlot(self, user, createdItemId)

end

function UseItemManager.hasStrongerConsumeItemBuffClient(self, user, item)
  if user == nil or user.PlayerTemporaryStatComponent == nil or item == nil then
    return false
  end
  local statMap = {
    pad = ___MOD._CTS.Pad,
    mad = ___MOD._CTS.Mad,
    pdd = ___MOD._CTS.Pdd,
    mdd = ___MOD._CTS.Mdd,
    acc = ___MOD._CTS.Acc,
    eva = ___MOD._CTS.Eva,
    speed = ___MOD._CTS.Speed,
    jump = ___MOD._CTS.Jump
  }
  local temporary = user.PlayerTemporaryStatComponent
  for field, stat in ___MOD.pairs(statMap) do
    local value = ___MOD.tonumber(item[field]) or 0
    if 0 < value then
      local data = temporary:getTemporaryStatData(stat)
      if data ~= nil then
        local remaining = (data.endTime or 0) - ___MOD._UtilLogic.ServerElapsedSeconds
        local existingValue = ___MOD.tonumber(data.value) or 0
        if 0 < remaining and value < existingValue then
          return true
        end
      end
    end
  end
  return false
end

function UseItemManager.hasTeleportItemServer(self, user)

end

function UseItemManager.isDojoPotionExhaustedClient(self, user, itemId)
  return self:isDojoPotionItem(itemId) and self:isDojoPotionLimitedMap(user) and ___MOD._DojoRaidUILogic.remainingPotion <= 0
end

function UseItemManager.isDojoPotionItem(self, itemId)
  local itemType = itemId // 10000
  return itemType == 200 or itemType == 201 or itemType == 202 or itemType == 205
end

function UseItemManager.isDojoPotionLimitedMap(self, user)
  if not (___MOD.isvalid(user) and ___MOD.isvalid(user.CurrentMap)) or user.CurrentMap.MapInfoComponent == nil then
    return false
  end
  local mapId = user.CurrentMap.MapInfoComponent.mapID or 0
  return ___MOD._MapManager:isDojoField(mapId)
end

function UseItemManager.isHPPotion(self, itemID)
  local itemType = itemID // 10000
  if itemType == 200 or itemType == 201 or itemType == 202 or itemType == 205 then
    local item = ___MOD._ItemManager:getItemById(itemID)
    if item == nil then
      return
    end
    local hpR = item.hpR
    if hpR ~= nil and hpR ~= 0 then
      return true
    end
    local hp = item.hp
    if hp ~= nil and hp ~= 0 then
      return true
    end
  end
  return false
end

function UseItemManager.isMegaphoneCashItem(self, itemId)
  if self._T.megaphoneCashItemMap == nil then
    self._T.megaphoneCashItemMap = {
      [5072000] = true,
      [5076000] = true
    }
  end
  return self._T.megaphoneCashItemMap[itemId] == true
end

function UseItemManager.isMiracleCubeUIOpenServer(self, userId)

end

function UseItemManager.isMPPotion(self, itemID)
  local itemType = itemID // 10000
  if itemType == 200 or itemType == 201 or itemType == 202 or itemType == 205 then
    local item = ___MOD._ItemManager:getItemById(itemID)
    if item == nil then
      return
    end
    local mpR = item.mpR
    if mpR ~= nil and mpR ~= 0 then
      return true
    end
    local mp = item.mp
    if mp ~= nil and mp ~= 0 then
      return true
    end
  end
  return false
end

function UseItemManager.isPetPotionOverheal(self, user, petPotionType)

end

function UseItemManager.isPotentialChangeBlockedRewardEquip(self, itemId)
  return ___MOD._EquipManager:isPotentialChangeBlockedEquip(itemId)
end

function UseItemManager.isTeleportBlockedMap(self, mapId)

end

function UseItemManager.OnBeginPlay(self)
  self._T.nextCanUse = 0
  if self:IsServer() then
    self._T.miracleCubeUiOpenUsers = {}
    self:detectMacroEnsureServerState()
  end
  if self:IsClient() then
    self:tryMacroInitUI()
    self:detectMacroInitUI()
    self:closeTryMacroUI()
    if self.detectMacroUiPersistentOpen == true then
      self:detectMacroRestoreClient(8)
    else
      self:detectMacroCloseClient()
    end
    self:teleportInitUI()
  end
end

function UseItemManager.onClickTeleportMove(self)
  local targetName = self:getTeleportInputNameClient()
  if not ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    self:requestTeleportCharacterMove(targetName)
    return
  end
  local mapList = self._T.teleportMapList or {}
  local selectedIndex = self._T.teleportSelectedIndex or 0
  if selectedIndex <= 0 or selectedIndex > #mapList then
    ___MOD._UINotice:showAlertUI("이동할 맵을 선택해주세요.")
    return
  end
  local mapId = ___MOD.tonumber(mapList[selectedIndex]) or 0
  if mapId <= 0 then
    return
  end
  local mapName = self:getTeleportMapDisplayName(mapId)
  local msg = ___MOD.string.format("다음 맵으로 순간이동하시겠습니까?\r\n[%s]", mapName)
  ___MOD._UINotice:showYesNoUI(msg, function()
    self:closeTeleportUI()
    local soundRUID = ___MOD.__RUIDManager:get("Game.img.UseShopItem")
    if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
      ___MOD._SoundService:PlaySound(soundRUID, 1)
    end
    self:teleportMoveToRegisteredMap(selectedIndex)
  end)
end

function UseItemManager.onClickTeleportRemove(self)
  local mapList = self._T.teleportMapList or {}
  local selectedIndex = self._T.teleportSelectedIndex or 0
  if selectedIndex <= 0 or selectedIndex > #mapList then
    ___MOD._UINotice:showAlertUI("삭제할 맵을 선택해주세요.")
    return
  end
  local mapId = ___MOD.tonumber(mapList[selectedIndex]) or 0
  if mapId <= 0 then
    return
  end
  local mapName = self:getTeleportMapDisplayName(mapId)
  local msg = ___MOD.string.format("다음 맵을 순간이동 리스트에서\r\n삭제하시겠습니까?\r\n[%s]", mapName)
  ___MOD._UINotice:showYesNoUI(msg, function()
    self:removeTeleportMap(selectedIndex)
  end)
end

function UseItemManager.onClickTryMacroYes(self)
  local targetName = self:getTryMacroTargetName()
  if ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "상대방을 찾을 수 없습니다.")
    return
  end
  self:requestTryMacro(targetName)
  self:closeTryMacroUI()
end

function UseItemManager.OnMapEnter(self)
  self:tryMacroInitUI()
  self:detectMacroInitUI()
  self:closeTryMacroUI()
  if self.detectMacroUiPersistentOpen == true then
    self:detectMacroRestoreClient(8)
  end
  self:teleportInitUI()
  self:closeTeleportUI()
end

function UseItemManager.onMiracleCubeKeyDown(self, event)
  if event.key ~= ___MOD.KeyboardKey.Escape then
    return
  end
  ___MOD._UIWindowLogic:suppressEscapeOnce()
  self:closeMiracleCubeUI()
end

function UseItemManager.onMiracleCubeRerollServer(self, slot, mesoCost, consumeCube, equipULID, cubeSessionId, cubeItemId, senderUserId)

end

function UseItemManager.onMiracleCubeUICleanupClient(self, cube)
  self:setMiracleCubeUIOpenServer(false)
  self:clearMiracleCubeUIStateClient()
  if cube ~= nil then
    for i = #___MOD._UIWindowLogic.UIWindow, 1, -1 do
      if ___MOD._UIWindowLogic.UIWindow[i] == cube.Id then
        ___MOD.table.remove(___MOD._UIWindowLogic.UIWindow, i)
      end
    end
  end
  ___MOD._UIWindowLogic:ensureOpenedUICountAtLeastVisibleWindows()
  if cube == nil or self.miracleCube == cube then
    self.miracleCube = nil
  end
end

function UseItemManager.onPetLifeWaterDisplayInfoClient(self, pets)
  local lifeWater = self.petLifeWater
  if ___MOD.isvalid(lifeWater) and lifeWater.PetLifeWaterUIComponent ~= nil then
    lifeWater.PetLifeWaterUIComponent:applyPetDisplayInfo(pets)
  end
end

function UseItemManager.onTeleportKeyDown(self, event)
  if event.key ~= ___MOD.KeyboardKey.Escape then
    return
  end
  ___MOD._UIWindowLogic:suppressEscapeOnce()
  self:closeTeleportUI()
end

function UseItemManager.onTeleportSelectRow(self, index)
  local mapList = self._T.teleportMapList or {}
  local dataIndex = (self._T.teleportScrollIndex or 0) + index
  if dataIndex <= 0 or dataIndex > #mapList then
    return
  end
  self._T.teleportSelectedIndex = dataIndex
  self:updateTeleportUIList()
end

function UseItemManager.onTryMacroKeyDown(self, event)
  if event.key ~= ___MOD.KeyboardKey.Escape then
    return
  end
  local root = self._T.tryMacroRoot
  if root == nil or not root.EnabledInHierarchy then
    return
  end
  self:closeTryMacroUI()
end

function UseItemManager.onUseCashItemServer(self, itemId, data, senderUserId)

end

function UseItemManager.onUseItemClient(self, invType, slotId, byPet, petPotionType)
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if not byPet and now < self._T.nextCanUse then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local inventory = user.CInventoryComponent
  if user.PlayerSettingsComponent ~= nil and user.PlayerSettingsComponent:isItemUseBlocked(user) then
    return
  end
  local player = ___MOD._UserService.LocalPlayer
  if player.Player:isDead() then
    return
  end
  local itemStack = inventory:getItemStack(invType, slotId)
  if itemStack == nil then
    return
  end
  local temporary = user.PlayerTemporaryStatComponent
  if temporary:getValue(___MOD._CTS.Attract) ~= 0 then
    return
  end
  if temporary:getValue(___MOD._CTS.StopPotion) ~= 0 then
    return
  end
  local itemId = itemStack.ItemId
  local itemQuantity = user.CInventoryComponent:getItemCount(itemId)
  local category = itemId // 1000000
  if category == 1 then
    return
  end
  if self:isDojoPotionExhaustedClient(user, itemId) then
    if not byPet then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "더 이상 소비 아이템을 사용할 수 없습니다.")
    end
    return
  end
  local item = ___MOD._ItemManager:getItemById(itemId)
  if item == nil then
    return
  end
  local itemType = itemId // 10000
  if itemId == 5041000 then
    if not self:canUseTeleportItemByLevelClient() then
      return
    end
    self:toggleTeleportUI()
    return
  end
  if itemId == 5450000 then
    local udc = user.UtilDlgComponent
    if ___MOD.isvalid(udc) then
      if udc:isInteractBlockedClient() then
        return
      end
      udc:markInteractPendingClient()
    end
  end

  local function func()
    local soundPath = ___MOD.string.format("Item.img.0%d.Use", itemId)
    local soundRUID = ___MOD.__RUIDManager:get(soundPath)
    if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
      ___MOD._SoundService:PlaySound(soundRUID, 1)
    end
    self:onUseItemServer(itemId, {
      slot = slotId,
      byPet = byPet,
      petPotionType = petPotionType
    })
  end

  if category == 2 then
    if not byPet and self:hasStrongerConsumeItemBuffClient(user, item) then
      ___MOD._UINotice:showYesNoUI("현재 적용되어 있는 수치가\r\n 아이템의 수치보다 높습니다.\r\n\r\n그래도 사용하시겠습니까?", func, nil)
      return
    end
    if 200 <= itemType and itemType <= 202 then
    elseif itemType == 219 then
      if itemId == 2190000 or itemId == 2190001 then
        self:openTryMacroUI()
      end
      return
    elseif itemType == 204 or itemType == 206 or itemType == 207 or itemType == 224 or itemType == 231 or itemType == 232 or itemType == 233 then
      return
    elseif itemType == 203 then
      local moveTo = item.moveTo
      local ignoreContinent = item.ignoreContinent
      local field = user.CurrentMap.MapInfoComponent
      if field:checkFieldLimit(___MOD._FieldLimit.UnableToUsePortalScroll) or moveTo == field.mapID then
        ___MOD._UINotice:showAlertUI("이 곳에서는 사용할 수 없습니다")
        return
      end
      if moveTo == 999999999 then
        if field.returnMap == 999999999 then
          ___MOD._UINotice:showAlertUI("그 곳으로는 이동할 수 없습니다.")
          return
        elseif field.returnMap == field.mapID then
          return
        end
      elseif moveTo == 0 then
        return
      elseif not ignoreContinent and not ___MOD._MapManager:isConnected(field.mapID, moveTo) then
        ___MOD._UINotice:showAlertUI("그 곳으로는 이동할 수 없습니다.")
        return
      end
    elseif itemType == 210 then
      if user.CurrentMap.MapInfoComponent:checkFieldLimit(___MOD._FieldLimit.UnableToUseSummonItem) then
        ___MOD._UINotice:showAlertUI("이 곳에서는 사용할 수 없습니다.")
        return
      end
      ___MOD._UINotice:showYesNoUI("지나친 호기심은 레벨 업을\r\n방해할 수도 있습니다.\r\n\r\n정말로 보따리를 푸시겠습니까?", func, nil)
      return
    elseif itemType == 212 then
      local petOwner = user.PetOwnerComponent
      if petOwner == nil or petOwner.pet == nil and petOwner.pet2 == nil and petOwner.pet3 == nil then
        return
      end
    elseif itemType == 243 then
      if player.UtilDlgComponent:isRunning() then
        return
      end
    elseif itemType == 280 then
      if itemId == 2800000 then
        self:spawnMiracleCubeUI(2800000)
        return
      end
    elseif itemType == 246 then
      ___MOD._MagnifierLogic:set(itemId, slotId)
      return
    elseif itemType == 250 and 2500000 <= itemId and itemId <= 2500015 and player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.ExpBuff) ~= 0 then
      ___MOD._UINotice:showYesNoUI("이미 동일한 종류의 버프가 적용중입니다.\r\n사용 시 기존 적용된 버프가 사라집니다.\r\n\r\n그래도 사용하시겠습니까?", func, 36)
      return
    end
    func()
  elseif category == 3 then
    if itemType == 301 then
      user.PlayerActionComponent:trySitPortableChair(itemId)
    end
  elseif category == 4 then
    if itemType == 422 then
      ___MOD._UIWindowLogic:showRaiseUI(itemId)
      return
    end
  elseif category == 5 then
    if itemType == 501 then
      local function useActiveEffectItem()
        self:onUseCashItemServer(itemId, {slot = slotId})
      end

      local equipInfo = itemStack.EquipInfo
      local activeEffectItem = user.ActiveEffectItemComponent
      local activeItemId = activeEffectItem ~= nil and (___MOD.tonumber(activeEffectItem.activeItemId) or 0) or 0
      local isActivating = activeItemId ~= itemId
      if isActivating and equipInfo ~= nil and (equipInfo.flag & ___MOD._ItemFlag.EquipTradeBlock ~= 0 or equipInfo.flag & ___MOD._ItemFlag.TradeCash ~= 0) then
        ___MOD._UINotice:showYesNoUI("사용 후에는 거래할 수 없는 아이템입니다.\r\n\r\n사용하시겠습니까?", useActiveEffectItem, nil)
        return
      end
      useActiveEffectItem()
    elseif itemType == 500 or itemType == 599 or itemId == 5031000 or itemId == 5031001 then
      local data = {slot = slotId}
      self:onUseCashItemServer(itemId, data)
    elseif itemType == 545 then
      local soundRUID = ___MOD.__RUIDManager:get("Game.img.UseShopItem")
      if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
        ___MOD._SoundService:PlaySound(soundRUID, 1)
      end
      local data = {slot = slotId}
      self:onUseCashItemServer(itemId, data)
    elseif itemType == 507 then
      if self:isMegaphoneCashItem(itemId) then
        if (itemId == 5072000 or itemId == 5076000) and (user.Player.Level or 0) < 30 then
          ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "레벨 30 이상만 사용 가능합니다.")
          return
        end
        ___MOD._ChatLogic:openMegaphoneUIByItem(itemId)
      end
      return
    elseif itemType == 506 then
      if itemId == 5062000 then
        self:spawnMiracleCubeUI(5062000)
      end
    elseif itemType == 518 then
      if itemId == 5180000 then
        self:spawnPetLifeWater(slotId)
      end
    elseif itemType == 505 then
      if itemId == 5050000 or itemId == 5050001 then
        local msg = "사용시 투자한 AP가 모두 초기화 되며 AP를 재투자 할 수 있습니다.\r\n\r\n정말 사용하시겠습니까?"
        if itemId == 5050001 then
          msg = "사용시 투자한 SP가 모두 초기화 되며 SP를 재투자 할 수 있습니다.\r\n\r\n정말 사용하시겠습니까?"
        end

        local function func2()
          local soundRUID = ___MOD.__RUIDManager:get("Game.img.UseShopItem")
          if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
            ___MOD._SoundService:PlaySound(soundRUID, 1)
          end
          self:onUseCashItemServer(itemId, {slot = slotId})
        end

        ___MOD._UINotice:showYesNoUI(msg, func2, nil)
        return
      end
    elseif itemType == 515 then
      if 5152100 <= itemId and itemId <= 5152107 then
        local targetFace = self:getColorLensTargetFace(user.Player.Face, itemId)
        if targetFace <= 0 then
          ___MOD._UINotice:showAlertUI("컬러렌즈를 사용할 수 없는 성형입니다.")
          return
        end
        if targetFace == user.Player.Face then
          ___MOD._UINotice:showAlertUI("이미 동일한 색상의 렌즈를 사용중입니다.")
          return
        end

        local function useColorLens()
          local soundRUID = ___MOD.__RUIDManager:get("Game.img.UseShopItem")
          if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
            ___MOD._SoundService:PlaySound(soundRUID, 1)
          end
          self:onUseCashItemServer(itemId, {slot = slotId})
        end

        local itemName = ___MOD._StringPoolManager:getItemName(itemId)
        ___MOD._UINotice:showYesNoUI(___MOD.string.format("%s를\r\n사용하시겠습니까?", itemName), useColorLens, nil)
        return
      end
    elseif itemType == 512 then
      local weatherMapInfo = user.CurrentMap and user.CurrentMap.MapInfoComponent or nil
      if ___MOD.isvalid(weatherMapInfo) and weatherMapInfo:checkFieldLimit(___MOD._FieldLimit.UnableToUseCashWeather) then
        ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "이곳에서는 사용할 수 없습니다.")
        return
      end
      local weatherItemName = ___MOD._StringPoolManager:getItemName(itemId)
      ___MOD._UINotice:showInputUILimit(___MOD.string.format("#c[#e%s#n]#\r\n함께 전할 메시지를 입력해 주세요.", weatherItemName), "", 40, function(noticeEntity, inputText, comboVal)
        local soundRUID = ___MOD.__RUIDManager:get("Game.img.UseShopItem")
        if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
          ___MOD._SoundService:PlaySound(soundRUID, 1)
        end
        self:onUseCashItemServer(itemId, {slot = slotId, message = inputText})
      end, nil)
      return
    elseif itemType == 552 then
      if itemId == 5520000 then
        self:spawnKarmaScissors()
      end
    elseif itemType == 580 and 5800001 <= itemId and itemId <= 5800007 then
      local function func2()
        local soundRUID = ___MOD.__RUIDManager:get("Game.img.UseShopItem")

        if not ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
          ___MOD._SoundService:PlaySound(soundRUID, 1)
        end
        self:onUseCashItemServer(itemId, {slot = slotId})
      end

      local itemName = ___MOD._StringPoolManager:getItemName(itemId)
      ___MOD._UINotice:showYesNoUI(___MOD.string.format("#c[#e%s#n]#\r\n\r\n교환권을 정말 사용하시겠습니까?\r\n#e사용 시 환불이 불가능합니다.#n", itemName), func2, nil)
      return
    end
  end
  self._T.nextCanUse = now + 0.2
end

function UseItemManager.onUseItemServer(self, itemId, data, senderUserId)

end

function UseItemManager.onUsePetLifeWaterResultClient(self, resultCode)
  local lifeWater = self.petLifeWater
  if resultCode == "SUCCESS" then
    local soundPath = "Game.img.UseShopItem"
    local soundRUID = ___MOD.__RUIDManager:get(soundPath)
    ___MOD._SoundService:PlaySound(soundRUID, 1)
  end
  if ___MOD.isvalid(lifeWater) and lifeWater.PetLifeWaterUIComponent ~= nil then
    lifeWater.PetLifeWaterUIComponent:onUseResult(resultCode)
  end
end

function UseItemManager.openTeleportUI(self)
  if not self:canUseTeleportItemByLevelClient() then
    return
  end
  if not self:canOpenTeleportUIInCurrentMap() then
    return
  end
  self:teleportInitUI()
  local root = self._T.teleportRoot
  if root == nil then
    return
  end
  if self._T.teleportOpened == true then
    return
  end
  self._T.teleportOpened = true
  root:SetEnable(true)
  ___MOD._UIWindowLogic:moveToTopLayer(root)
  ___MOD._UIWindowLogic:setOpenedUICount(1)
  self._T.teleportScrollIndex = 0
  self._T.teleportScrollPosition = 0
  self:applyTeleportScrollPosition()
  self:requestTeleportMapList()
  if self._T.teleportEscapeEvent == nil then
    self._T.teleportEscapeEvent = ___MOD._InputService:ConnectEvent(___MOD.KeyDownEvent, function(event)
      self:onTeleportKeyDown(event)
    end)
  end
end

function UseItemManager.openTryMacroUI(self)
  self:tryMacroInitUI()
  local root = self._T.tryMacroRoot
  if root == nil then
    return
  end
  if self._T.tryMacroOpened ~= true then
    self._T.tryMacroOpened = true
    ___MOD._UIWindowLogic:setOpenedUICount(1)
  end
  root:SetEnable(true)
  ___MOD._UIWindowLogic:moveToTopLayer(root)
  if self._T.tryMacroEscapeEvent == nil then
    self._T.tryMacroEscapeEvent = ___MOD._InputService:ConnectEvent(___MOD.KeyDownEvent, function(event)
      self:onTryMacroKeyDown(event)
    end)
  end
  local textEntity = self._T.tryMacroText
  if textEntity ~= nil then
    if textEntity.TextInputComponent ~= nil then
      textEntity.TextInputComponent.Text = ""
      local localPlayer = ___MOD._UserService.LocalPlayer
      if not ___MOD.isvalid(localPlayer) or localPlayer.Player == nil or not localPlayer.Player:isMobileUIPlatform() then
        textEntity.TextInputComponent:ActivateInputField()
      end
    end
    if textEntity.TextComponent ~= nil then
      textEntity.TextComponent.Text = ""
    end
  end
end

function UseItemManager.playSkillBookResultEffect(self, user, userId, bookName, success, canTry)

end

function UseItemManager.removeTeleportMap(self, selectedIndex, senderUserId)

end

function UseItemManager.removeUsedItem(self, user, itemId, consumeInvType, consumeSlot)

end

function UseItemManager.requestClickedRaise(self, questID, consumeItemID, senderUserId)

end

function UseItemManager.requestPetLifeWaterDisplayInfoServer(self, senderUserId)

end

function UseItemManager.requestRaise(self, questID, senderUserId)

end

function UseItemManager.requestTeleportCharacterMove(self, targetName, senderUserId)

end

function UseItemManager.requestTeleportMapList(self, senderUserId)

end

function UseItemManager.requestTryMacro(self, targetName, senderUserId)

end

function UseItemManager.responseRaise(self, questID, qrData)
  local raise = ___MOD._UIWindowLogic:getUI("Raise")
  if ___MOD.isvalid(raise) then
    local raiseUI = raise.RaiseUIComponent
    if ___MOD.isvalid(raiseUI) and raiseUI.questID == questID then
      raise.RaiseUIComponent:setQRData(qrData)
    end
  end
end

function UseItemManager.setMiracleCubeUIOpenServer(self, isOpen, senderUserId)

end

function UseItemManager.setTeleportRowSelectedVisual(self, row, selected)
  if row == nil then
    return
  end
  local toTextColor = selected and ___MOD.FastColor.white or ___MOD.FastColor.black
  local toBaseColor = selected and ___MOD.Color.FromHexCode("#4287BC") or ___MOD.FastColor(1, 1, 1, 0)
  if row.SpriteGUIRendererComponent ~= nil then
    row.SpriteGUIRendererComponent.Color = toBaseColor
  end
  local mapName = row:GetChildByName("Mapname")
  if mapName == nil then
    mapName = row:GetChildByName("Name")
  end
  self:setTeleportTextColor(mapName, toTextColor)
end

function UseItemManager.setTeleportTextColor(self, target, color)
  if target == nil then
    return
  end
  if target.BitmapFontRendererComponent ~= nil then
    target.BitmapFontRendererComponent.color = color
    target.BitmapFontRendererComponent:drawText()
  end
end

function UseItemManager.spawnKarmaScissors(self)
  local karma = self.karmaScissors
  if karma == nil then
    local modelId = ___MOD._EntryService:GetModelIdByName("Model_KarmaScissors")
    local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
    self.karmaScissors = ___MOD._SpawnService:SpawnByModelId(modelId, "karmaScissors", ___MOD.FastVector3.zero:Clone(), uiGroup)
  end
end

function UseItemManager.spawnMiracleCubeUI(self, cubeItemId)
  if cubeItemId ~= 5062000 and cubeItemId ~= 2800000 then
    cubeItemId = 5062000
  end
  local player = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(player) then
    ___MOD._PlayerSkillLogic:interruptHurricaneSkillsByAbnormalStatus(player)
  end
  self.miracleCubeItemId = cubeItemId
  self._T.miracleCubeItemId = cubeItemId
  local cube = self.miracleCube
  if ___MOD.isvalid(cube) and cube.MiracleCubeUIComponent ~= nil and cube.EnabledInHierarchy then
    self:setMiracleCubeUIOpenServer(true)
    cube.MiracleCubeUIComponent:updateCubeItemVisualState()
    cube.MiracleCubeUIComponent:updateRemainText()
    cube.MiracleCubeUIComponent:updateRetryButtonState()
    if self._T.miracleCubeEscapeEvent == nil then
      self._T.miracleCubeEscapeEvent = ___MOD._InputService:ConnectEvent(___MOD.KeyDownEvent, function(event)
        self:onMiracleCubeKeyDown(event)
      end)
    end
    self:getMiracleCubeSessionIdClient()
    return
  end
  self:clearMiracleCubeUIStateClient()
  if ___MOD.isvalid(cube) then
    cube:Destroy()
    ___MOD.wait(0)
  end
  self.miracleCube = nil
  local modelId = ___MOD._EntryService:GetModelIdByName("Model_MiracleCube")
  local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  if ___MOD._UtilLogic:IsNilorEmptyString(modelId) or not ___MOD.isvalid(uiGroup) then
    ___MOD.log_error("[MiracleCube] UI 컨텍스트 준비 실패: model=", ___MOD.tostring(modelId), ", parent=", ___MOD.tostring(uiGroup))
    return
  end
  local staleCube = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/miracleCube")
  if ___MOD.isvalid(staleCube) then
    staleCube:Destroy()
    ___MOD.wait(0)
  end
  self.miracleCube = ___MOD._SpawnService:SpawnByModelId(modelId, "miracleCube", ___MOD.FastVector3.zero:Clone(), uiGroup)
  if not ___MOD.isvalid(self.miracleCube) or self.miracleCube.MiracleCubeUIComponent == nil then
    staleCube = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/miracleCube")
    if ___MOD.isvalid(staleCube) then
      staleCube:Destroy()
      ___MOD.wait(0)
    end
    self.miracleCube = ___MOD._SpawnService:SpawnByModelId(modelId, "miracleCube", ___MOD.FastVector3.zero:Clone(), uiGroup)
  end
  if not ___MOD.isvalid(self.miracleCube) or self.miracleCube.MiracleCubeUIComponent == nil then
    ___MOD.log_error("[MiracleCube] UI 스폰 실패: model=", ___MOD.tostring(modelId), ", parent=", ___MOD.tostring(uiGroup))
    self.miracleCube = nil
    return
  end
  ___MOD._UIWindowLogic:moveToTopLayer(self.miracleCube)
  if self._T.miracleCubeOpened ~= true then
    self._T.miracleCubeOpened = true
    ___MOD._UIWindowLogic:setOpenedUICount(1)
  end
  if self._T.miracleCubeEscapeEvent == nil then
    self._T.miracleCubeEscapeEvent = ___MOD._InputService:ConnectEvent(___MOD.KeyDownEvent, function(event)
      self:onMiracleCubeKeyDown(event)
    end)
  end
  self:setMiracleCubeUIOpenServer(true)
  self:getMiracleCubeSessionIdClient()
end

function UseItemManager.spawnPetLifeWater(self, useSlot)
  local lifeWater = self.petLifeWater
  if not ___MOD.isvalid(lifeWater) then
    local modelId = ___MOD._EntryService:GetModelIdByName("Model_PetLifeWater")
    local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
    if ___MOD._UtilLogic:IsNilorEmptyString(modelId) or not ___MOD.isvalid(uiGroup) then
      return
    end
    self.petLifeWater = ___MOD._SpawnService:SpawnByModelId(modelId, "petLifeWater", ___MOD.FastVector3.zero:Clone(), uiGroup)
    lifeWater = self.petLifeWater
  end
  if ___MOD.isvalid(lifeWater) and lifeWater.PetLifeWaterUIComponent ~= nil then
    lifeWater.PetLifeWaterUIComponent.lifeWaterSlot = useSlot
  end
end

function UseItemManager.startInventorySlotExpandScript(self, user, itemId, cashUseSlot)

end

function UseItemManager.syncTeleportMapList(self, mapList)
  local cleanList = {}
  if ___MOD.type(mapList) == "table" then
    for _, mapId in ___MOD.ipairs(mapList) do
      mapId = ___MOD.tonumber(mapId) or 0
      if 0 < mapId then
        cleanList[#cleanList + 1] = mapId
        if 10 <= #cleanList then
          break
        end
      end
    end
  end
  self._T.teleportMapList = cleanList
  local visibleCount = self:getTeleportVisibleRowCount()
  self._T.teleportScrollIndex = ___MOD.math.max(0, ___MOD.math.min(self._T.teleportScrollIndex or 0, ___MOD.math.max(0, #cleanList - visibleCount)))
  self:updateTeleportUIList()
  self:applyTeleportScrollPosition()
end

function UseItemManager.teleportChangeScroll(self, direction)
  local mapList = self._T.teleportMapList or {}
  local visibleCount = self:getTeleportVisibleRowCount()
  local maxScroll = ___MOD.math.max(0, #mapList - visibleCount)
  if maxScroll <= 0 then
    self._T.teleportScrollIndex = 0
    self._T.teleportScrollPosition = 0
    self:updateTeleportScrollUI()
    return
  end
  if direction < 0 then
    self._T.teleportScrollIndex = ___MOD.math.min(maxScroll, (self._T.teleportScrollIndex or 0) + 1)
  else
    self._T.teleportScrollIndex = ___MOD.math.max(0, (self._T.teleportScrollIndex or 0) - 1)
  end
  self._T.teleportScrollPosition = (self._T.teleportScrollIndex or 0) / ___MOD.math.max(1, maxScroll)
  self:applyTeleportScrollPosition()
end

function UseItemManager.teleportInitUI(self)
  if self._T.teleportInitialized then
    return
  end
  local root = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/TeleportItem")
  if root == nil then
    return
  end
  self._T.teleportInitialized = true
  self._T.teleportOpened = false
  self._T.teleportSelectedIndex = 1
  self._T.teleportScrollIndex = 0
  self._T.teleportScrollPosition = 0
  self._T.teleportMapList = {}
  self._T.teleportRoot = root
  self._T.teleportLayout = root:GetChildByName("layout")
  self._T.teleportBtMove = root:GetChildByName("BtMove")
  self._T.teleportBtAdd = root:GetChildByName("BtAdd")
  self._T.teleportBtRemove = root:GetChildByName("BtRemove")
  self._T.teleportBtExit = root:GetChildByName("BtClose")
  self._T.teleportInputField = self:findTeleportInputFieldClient(root)
  local scroll = root:GetChildByName("Scroll")
  self._T.teleportScroll = scroll
  if scroll ~= nil then
    self._T.teleportPrev = scroll:GetChildByName("prev")
    self._T.teleportNext = scroll:GetChildByName("next")
    self._T.teleportBar = scroll:GetChildByName("bar")
  end
  self._T.teleportClickScrollBar = false
  self._T.teleportScrollYSize = 88
  if self._T.teleportPrev ~= nil and self._T.teleportPrev.UITransformComponent ~= nil then
    self._T.teleportPrevBaseY = self._T.teleportPrev.UITransformComponent.anchoredPosition.y
  else
    self._T.teleportPrevBaseY = -13
  end
  if self._T.teleportBar ~= nil and self._T.teleportBar.UITransformComponent ~= nil then
    self._T.teleportBarBaseY = self._T.teleportBar.UITransformComponent.anchoredPosition.y
  else
    self._T.teleportBarBaseY = -51
  end
  self._T.teleportRows = {}
  for i = 1, 10 do
    local row = self._T.teleportLayout and self._T.teleportLayout:GetChildByName("MapList" .. i) or nil
    self._T.teleportRows[i] = row
    if row ~= nil then
      row:ConnectEvent(___MOD.UITouchDownEvent, function()
        self:onTeleportSelectRow(i)
      end)
    end
  end
  if self._T.teleportLayout ~= nil and self._T.teleportLayout.ScrollLayoutGroupComponent ~= nil then
    self._T.teleportLayout.ScrollLayoutGroupComponent.UseScroll = false
  end
  if self._T.teleportPrev ~= nil then
    self._T.teleportPrev:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:teleportChangeScroll(1)
    end)
  end
  if self._T.teleportNext ~= nil then
    self._T.teleportNext:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:teleportChangeScroll(-1)
    end)
  end
  if self._T.teleportBar ~= nil then
    if self._T.teleportBar.UIButtonComponent == nil and self._T.teleportBar.ButtonComponent == nil and self._T.teleportBar.UITouchReceiveComponent == nil then
      self._T.teleportBar:AddComponent(___MOD.UITouchReceiveComponent)
    end
    self._T.teleportBar:ConnectEvent(___MOD.UITouchDownEvent, function()
      self._T.teleportClickScrollBar = true
    end)
    self._T.teleportBar:ConnectEvent(___MOD.UITouchUpEvent, function()
      self._T.teleportClickScrollBar = false
    end)
    if self._T.teleportBar.UIButtonComponent ~= nil or self._T.teleportBar.ButtonComponent ~= nil then
      self._T.teleportBar:ConnectEvent(___MOD.ButtonStateChangeEvent, function(event)
        if event.state == ___MOD.ButtonState.Pressed then
          self._T.teleportClickScrollBar = true
        elseif event.state == ___MOD.ButtonState.Released then
          self._T.teleportClickScrollBar = false
        end
      end)
    end
  end
  if self._T.teleportBtAdd ~= nil then
    self._T.teleportBtAdd:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:addTeleportMap()
    end)
  end
  if self._T.teleportBtRemove ~= nil then
    self._T.teleportBtRemove:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickTeleportRemove()
    end)
  end
  if self._T.teleportBtMove ~= nil then
    self._T.teleportBtMove:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickTeleportMove()
    end)
  end
  if self._T.teleportBtExit ~= nil then
    self._T.teleportBtExit:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:closeTeleportUI()
    end)
  end
  local inputField = self._T.teleportInputField
  if inputField ~= nil then
    inputField:ConnectEvent(___MOD.UITouchDownEvent, function()
      self:clearTeleportSelectionClient()
    end)
    inputField:ConnectEvent(___MOD.TextInputValueChangeEvent, function(value)
      self:clearTeleportSelectionClient()
    end)
  end
  root:SetEnable(false)
  self:updateTeleportUIList()
end

function UseItemManager.teleportMoveToCharacter(self, targetName, senderUserId)

end

function UseItemManager.teleportMoveToMap(self, mapId, senderUserId)

end

function UseItemManager.teleportMoveToMapInternal(self, user, mapId, userId)

end

function UseItemManager.teleportMoveToRegisteredMap(self, mapIndex, senderUserId)

end

function UseItemManager.toggleTeleportUI(self)
  self:teleportInitUI()
  if self._T.teleportOpened then
    self:closeTeleportUI()
    return
  end
  if not self:canUseTeleportItemByLevelClient() then
    return
  end
  if not self:canOpenTeleportUIInCurrentMap() then
    return
  end
  self:openTeleportUI()
end

function UseItemManager.truncateTeleportMapNameClient(self, mapName)
  if ___MOD._UtilLogic:IsNilorEmptyString(mapName) then
    return mapName or ""
  end
  local maxLength = 10
  local currentLength = 0
  local chars = {}
  for _, codePoint in ___MOD.utf8.codes(mapName) do
    local char = ___MOD.utf8.char(codePoint)
    local charLength = char == " " and 0.5 or 1
    if maxLength < currentLength + charLength then
      local prefix = ___MOD.table.concat(chars)
      local ellipsis = ___MOD.string.sub(prefix, -1) == " " and "..." or " ..."
      return prefix .. ellipsis
    end
    chars[#chars + 1] = char
    currentLength = currentLength + charLength
  end
  return mapName
end

function UseItemManager.tryMacroInitUI(self)
  if self._T.tryMacroInitialized then
    return
  end
  local root = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/TryMacro")
  if root == nil then
    return
  end
  self._T.tryMacroInitialized = true
  self._T.tryMacroRoot = root
  self._T.tryMacroText = root:GetChildByName("Text")
  local btYes = root:GetChildByName("BtYes")
  local btNo = root:GetChildByName("BtNo")
  if btYes ~= nil then
    btYes:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickTryMacroYes()
    end)
  end
  if btNo ~= nil then
    btNo:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:closeTryMacroUI()
    end)
  end
  local textEntity = self._T.tryMacroText
  if textEntity ~= nil then
    textEntity:ConnectEvent(___MOD.TextInputSubmitEvent, function()
      self:onClickTryMacroYes()
    end)
  end
  root:SetEnable(false)
end

function UseItemManager.tryUseItemClient(self, itemId, petPotionType)
  local player = ___MOD._UserService.LocalPlayer
  if player.Player:isDead() then
    return
  end
  if self:isDojoPotionExhaustedClient(player, itemId) then
    return
  end
  if player.PlayerSettingsComponent ~= nil and player.PlayerSettingsComponent:isItemUseBlocked(player) then
    return
  end
  local i, c, slot = ___MOD._UserService.LocalPlayer.CInventoryComponent:findFirstItem(itemId)
  ___MOD._UseItemManager:onUseItemClient(2, slot, true, petPotionType)
end

function UseItemManager.updateTeleportScrollUI(self)
  local mapList = self._T.teleportMapList or {}
  local listCount = #mapList
  local visibleCount = self:getTeleportVisibleRowCount()
  local maxScroll = ___MOD.math.max(0, listCount - visibleCount)
  local idx = ___MOD.math.max(0, ___MOD.math.min(self._T.teleportScrollIndex or 0, maxScroll))
  local enableScroll = 1 < listCount

  local function setButtonEnabled(buttonEntity, enabled)
    if buttonEntity == nil then
      return
    end
    if buttonEntity.ButtonComponent ~= nil then
      buttonEntity.ButtonComponent.Enable = enabled
    end
    if buttonEntity.UIButtonComponent ~= nil then
      buttonEntity.UIButtonComponent.Enable = enabled
    end
  end

  if self._T.teleportScroll ~= nil then
    self._T.teleportScroll:SetEnable(true)
  end
  setButtonEnabled(self._T.teleportPrev, enableScroll and 0 < idx)
  setButtonEnabled(self._T.teleportNext, enableScroll and maxScroll > idx)
  if self._T.teleportBar ~= nil then
    self._T.teleportBar:SetEnable(enableScroll)
    setButtonEnabled(self._T.teleportBar, true)
    if self._T.teleportBar.UITransformComponent ~= nil then
      local baseY = self._T.teleportBarBaseY or -51
      local scrollYSize = self._T.teleportScrollYSize or 88
      local ratio = idx / ___MOD.math.max(1, maxScroll)
      self._T.teleportBar.UITransformComponent.anchoredPosition.y = baseY - scrollYSize * ratio
    end
    if self._T.teleportBar.SpriteGUIRendererComponent ~= nil then
      self._T.teleportBar.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
    end
  end
  if self._T.teleportPrev ~= nil and self._T.teleportPrev.SpriteGUIRendererComponent ~= nil then
    self._T.teleportPrev.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
  end
  if self._T.teleportNext ~= nil and self._T.teleportNext.SpriteGUIRendererComponent ~= nil then
    self._T.teleportNext.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
  end
end

function UseItemManager.updateTeleportUIList(self)
  local mapList = self._T.teleportMapList or {}
  if #mapList <= 0 then
    self._T.teleportSelectedIndex = 0
  else
    local selected = self._T.teleportSelectedIndex
    if selected == nil then
      selected = 1
    end
    if 0 < selected then
      selected = ___MOD.math.max(1, ___MOD.math.min(selected, #mapList))
    else
      selected = 0
    end
    self._T.teleportSelectedIndex = selected
  end
  for i = 1, 10 do
    local row = self._T.teleportRows and self._T.teleportRows[i] or nil
    local dataIndex = (self._T.teleportScrollIndex or 0) + i
    local mapId = ___MOD.tonumber(mapList[dataIndex]) or 0
    if row ~= nil then
      local show = 0 < mapId
      row:SetEnable(show)
      local nameEntity = row:GetChildByName("Mapname")
      if nameEntity == nil then
        nameEntity = row:GetChildByName("Name")
      end
      if nameEntity ~= nil and nameEntity.BitmapFontRendererComponent ~= nil then
        local text = ""
        if show then
          local mapName = self:getTeleportMapDisplayName(mapId)
          text = self:truncateTeleportMapNameClient(mapName)
        end
        nameEntity.BitmapFontRendererComponent.text = text
        nameEntity.BitmapFontRendererComponent:drawText()
      end
      self:setTeleportRowSelectedVisual(row, show and self._T.teleportSelectedIndex == dataIndex)
    end
  end
  self:updateTeleportScrollUI()
end

function UseItemManager.useMaplePointExchangeCouponServer(self, user, userId, itemId, cashUseSlot)

end

function UseItemManager.usePetLifeWaterServer(self, user, userId, itemId, data, cashUseSlot)

end
