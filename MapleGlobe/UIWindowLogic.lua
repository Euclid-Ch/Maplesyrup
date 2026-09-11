

function UIWindowLogic.applyWindowMagnet(self, movingEntity, uiDelta)
  if not ___MOD.isvalid(movingEntity) then
    return ___MOD.FastVector2.zero
  end
  local tr = movingEntity.UITransformComponent
  if tr == nil then
    return ___MOD.FastVector2.zero
  end
  local currentPos = tr.anchoredPosition
  local proposed = ___MOD.FastVector2(currentPos.x + uiDelta.x, currentPos.y + uiDelta.y)
  local freeProposed = ___MOD.FastVector2(proposed.x, proposed.y)
  local movingId = movingEntity.Id
  local state = self.windowMagnetState[movingId]
  if ___MOD.type(state) ~= "table" then
    state = {
      locked = false,
      dragStartX = currentPos.x,
      dragStartY = currentPos.y,
      breakAccum = 0
    }
  end
  local snapDist = ___MOD.tonumber(self.windowMagnetSnapDist) or 12
  local breakDist = ___MOD.tonumber(self.windowMagnetBreakDist) or 36
  local breakDeadzone = ___MOD.tonumber(self.windowMagnetBreakDeadzone) or 4
  local minOverlapY = ___MOD.tonumber(self.windowMagnetMinOverlapY) or 24
  local screenRect = self:getUIScreenRect()
  local movingMagnetOffsetX = self:getWindowMagnetOffsetX(movingEntity)

  local function applyVerticalCornerSnap(mRect, anchorRect)
    local topDiff = ___MOD.math.abs(mRect.top - anchorRect.top)
    local botDiff = ___MOD.math.abs(mRect.bottom - anchorRect.bottom)
    if topDiff <= snapDist and topDiff <= botDiff then
      proposed.y = anchorRect.top - mRect.h * (1 - mRect.py)
    elseif botDiff <= snapDist then
      proposed.y = anchorRect.bottom + mRect.h * mRect.py
    end
  end

  if ___MOD.type(state) == "table" and state.locked == true then
    local movingRect = self:getWindowRect(movingEntity, proposed)
    if movingRect == nil then
      self.windowMagnetState[movingId] = nil
      return proposed
    end
    if state.mode == "screen_left" then
      proposed.x = screenRect.left + movingRect.w * movingRect.px - movingMagnetOffsetX
      local absX = ___MOD.math.abs(uiDelta.x)
      local absY = ___MOD.math.abs(uiDelta.y)
      if breakDeadzone < absX and absX >= absY * 1.25 then
        state.breakAccum = (state.breakAccum or 0) + (absX - breakDeadzone)
      else
        state.breakAccum = ___MOD.math.max(0, (state.breakAccum or 0) - 1)
      end
      if breakDist <= state.breakAccum then
        state.locked = false
        state.mode = nil
        state.breakAccum = 0
        self.windowMagnetState[movingId] = state
        return freeProposed
      end
      self.windowMagnetState[movingId] = state
      return proposed
    elseif state.mode == "screen_right" then
      proposed.x = screenRect.right - movingRect.w * (1 - movingRect.px) - movingMagnetOffsetX
      local absX = ___MOD.math.abs(uiDelta.x)
      local absY = ___MOD.math.abs(uiDelta.y)
      if breakDeadzone < absX and absX >= absY * 1.25 then
        state.breakAccum = (state.breakAccum or 0) + (absX - breakDeadzone)
      else
        state.breakAccum = ___MOD.math.max(0, (state.breakAccum or 0) - 1)
      end
      if breakDist <= state.breakAccum then
        state.locked = false
        state.mode = nil
        state.breakAccum = 0
        self.windowMagnetState[movingId] = state
        return freeProposed
      end
      self.windowMagnetState[movingId] = state
      return proposed
    elseif state.mode == "screen_top" then
      proposed.y = screenRect.top - movingRect.h * (1 - movingRect.py)
      local absX = ___MOD.math.abs(uiDelta.x)
      local absY = ___MOD.math.abs(uiDelta.y)
      if breakDeadzone < absY and absY >= absX * 1.25 then
        state.breakAccum = (state.breakAccum or 0) + (absY - breakDeadzone)
      else
        state.breakAccum = ___MOD.math.max(0, (state.breakAccum or 0) - 1)
      end
      if breakDist <= state.breakAccum then
        state.locked = false
        state.mode = nil
        state.breakAccum = 0
        self.windowMagnetState[movingId] = state
        return freeProposed
      end
      self.windowMagnetState[movingId] = state
      return proposed
    end
    local anchorEntity = ___MOD._EntityService:GetEntity(state.anchorId)
    local anchorRect = self:getWindowRect(anchorEntity, nil)
    if anchorRect ~= nil and movingRect ~= nil then
      if state.mode == "left_to_right" then
        proposed.x = anchorRect.right + movingRect.w * movingRect.px - movingMagnetOffsetX
      elseif state.mode == "right_to_left" then
        proposed.x = anchorRect.left - movingRect.w * (1 - movingRect.px) - movingMagnetOffsetX
      end
      movingRect = self:getWindowRect(movingEntity, proposed)
      if movingRect ~= nil then
        applyVerticalCornerSnap(movingRect, anchorRect)
      end
      local absX = ___MOD.math.abs(uiDelta.x)
      local absY = ___MOD.math.abs(uiDelta.y)
      if breakDeadzone < absX and absX >= absY * 1.25 then
        state.breakAccum = (state.breakAccum or 0) + (absX - breakDeadzone)
      else
        state.breakAccum = ___MOD.math.max(0, (state.breakAccum or 0) - 1)
      end
      if breakDist <= state.breakAccum then
        state.locked = false
        state.anchorId = nil
        state.mode = nil
        state.breakAccum = 0
        self.windowMagnetState[movingId] = state
        return freeProposed
      else
        self.windowMagnetState[movingId] = state
      end
      return proposed
    end
    self.windowMagnetState[movingId] = nil
  end
  local movingRect = self:getWindowRect(movingEntity, proposed)
  if movingRect == nil then
    return proposed
  end
  local best
  local bestDiff = snapDist + 1
  for i = #self.UIWindow, 1, -1 do
    local otherId = self.UIWindow[i]
    if otherId ~= movingId then
      local other = ___MOD._EntityService:GetEntity(otherId)
      if ___MOD.isvalid(other) and other.Enable then
        local oRect = self:getWindowRect(other, nil)
        if oRect ~= nil then
          local overlapY = ___MOD.math.min(movingRect.top, oRect.top) - ___MOD.math.max(movingRect.bottom, oRect.bottom)
          if minOverlapY <= overlapY then
            local d1 = ___MOD.math.abs(movingRect.left - oRect.right)
            if snapDist >= d1 and bestDiff > d1 then
              bestDiff = d1
              best = {
                anchorId = otherId,
                mode = "left_to_right",
                anchorRect = oRect
              }
            end
            local d2 = ___MOD.math.abs(movingRect.right - oRect.left)
            if snapDist >= d2 and bestDiff > d2 then
              bestDiff = d2
              best = {
                anchorId = otherId,
                mode = "right_to_left",
                anchorRect = oRect
              }
            end
          end
        end
      end
    end
  end
  local miniMapTags = {
    "miniMapMini",
    "miniMapMax",
    "miniMapNone"
  }
  for _, tag in ___MOD.ipairs(miniMapTags) do
    local mm = ___MOD._EntityService:GetEntityByTag(tag)
    if ___MOD.isvalid(mm) and mm.Enable and mm.Visible and mm.Id ~= movingId then
      local mmRect = self:getWindowRect(mm, nil)
      if mmRect ~= nil then
        local overlapY = ___MOD.math.min(movingRect.top, mmRect.top) - ___MOD.math.max(movingRect.bottom, mmRect.bottom)
        if minOverlapY <= overlapY then
          local d1 = ___MOD.math.abs(movingRect.left - mmRect.right)
          if snapDist >= d1 and bestDiff > d1 then
            bestDiff = d1
            best = {
              anchorId = mm.Id,
              mode = "left_to_right",
              anchorRect = mmRect
            }
          end
          local d2 = ___MOD.math.abs(movingRect.right - mmRect.left)
          if snapDist >= d2 and bestDiff > d2 then
            bestDiff = d2
            best = {
              anchorId = mm.Id,
              mode = "right_to_left",
              anchorRect = mmRect
            }
          end
        end
      end
    end
  end
  if best ~= nil then
    if best.mode == "left_to_right" then
      proposed.x = best.anchorRect.right + movingRect.w * movingRect.px - movingMagnetOffsetX
    else
      proposed.x = best.anchorRect.left - movingRect.w * (1 - movingRect.px) - movingMagnetOffsetX
    end
    movingRect = self:getWindowRect(movingEntity, proposed)
    if movingRect ~= nil then
      applyVerticalCornerSnap(movingRect, best.anchorRect)
    end
    self.windowMagnetState[movingId] = {
      locked = true,
      anchorId = best.anchorId,
      mode = best.mode,
      breakAccum = 0,
      dragStartX = state.dragStartX,
      dragStartY = state.dragStartY
    }
  else
    local screenBestMode
    local screenBestDiff = snapDist + 1
    local dLeft = ___MOD.math.abs(movingRect.left - screenRect.left)
    if snapDist >= dLeft and screenBestDiff > dLeft then
      screenBestDiff = dLeft
      screenBestMode = "screen_left"
    end
    local dRight = ___MOD.math.abs(movingRect.right - screenRect.right)
    if snapDist >= dRight and screenBestDiff > dRight then
      screenBestDiff = dRight
      screenBestMode = "screen_right"
    end
    local dTop = ___MOD.math.abs(movingRect.top - screenRect.top)
    if snapDist >= dTop and screenBestDiff > dTop then
      screenBestDiff = dTop
      screenBestMode = "screen_top"
    end
    if screenBestMode == "screen_left" then
      proposed.x = screenRect.left + movingRect.w * movingRect.px - movingMagnetOffsetX
      self.windowMagnetState[movingId] = {
        locked = true,
        mode = "screen_left",
        breakAccum = 0,
        dragStartX = state.dragStartX,
        dragStartY = state.dragStartY
      }
    elseif screenBestMode == "screen_right" then
      proposed.x = screenRect.right - movingRect.w * (1 - movingRect.px) - movingMagnetOffsetX
      self.windowMagnetState[movingId] = {
        locked = true,
        mode = "screen_right",
        breakAccum = 0,
        dragStartX = state.dragStartX,
        dragStartY = state.dragStartY
      }
    elseif screenBestMode == "screen_top" then
      proposed.y = screenRect.top - movingRect.h * (1 - movingRect.py)
      self.windowMagnetState[movingId] = {
        locked = true,
        mode = "screen_top",
        breakAccum = 0,
        dragStartX = state.dragStartX,
        dragStartY = state.dragStartY
      }
    else
      self.windowMagnetState[movingId] = state
    end
  end
  return proposed
end

function UIWindowLogic.beginWindowDrag(self, entity)
  if not ___MOD.isvalid(entity) then
    return
  end
  local tr = entity.UITransformComponent
  local p = tr ~= nil and tr.anchoredPosition or ___MOD.FastVector2.zero
  self.windowMagnetState[entity.Id] = {
    locked = false,
    dragStartX = p.x,
    dragStartY = p.y,
    breakAccum = 0
  }
end

function UIWindowLogic.clearData(self)
  self.UIWindow = {}
  self.UI = {}
  self.Queued = false
  self.HoverdUI = nil
  self.openedUICount = 0
  self.openWebNotice = false
  self.openWebUserList = false
  self.openWebUserRank = false
  self.openDelivery = false
  self.firstWebNotice = true
  self.windowMagnetState = {}
end

function UIWindowLogic.clearHoverdUI(self)
  if ___MOD.isvalid(self.HoverdUI) then
    self.HoverdUI = nil
  end
end

function UIWindowLogic.closeAranSkillGuideIfOpen(self)
  local guide = ___MOD._EntityService:GetEntityByPath("/ui/TopLayerGroup/AranSkillGuide")
  if ___MOD.isvalid(guide) and guide.Enable then
    local localPlayer = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(localPlayer) and localPlayer.SkillUIComponent ~= nil then
      localPlayer.SkillUIComponent:closeAranSkillGuide()
    else
      guide:SetEnable(false)
    end
    return true
  end
  return false
end

function UIWindowLogic.closeMobileUIByPriority(self)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) or localPlayer.Player == nil or not localPlayer.Player:isMobileUIPlatform() then
    return false
  end
  if self:closeAranSkillGuideIfOpen() then
    return true
  end
  if ___MOD._UseItemManager ~= nil and ___MOD._UseItemManager._T ~= nil and ___MOD._UseItemManager._T.detectMacroOpened == true then
    return true
  end
  if #___MOD._UINotice.noitceUIList > 0 then
    return true
  end
  local quickClose = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileQuickCloseBtn")
  if ___MOD.isvalid(quickClose) and quickClose.UIMobileQuickCloseButton ~= nil and quickClose.UIMobileQuickCloseButton:closeMobileOnlyTopPanel() then
    return true
  end
  return self:closeTopUIByMobileQuickButton()
end

function UIWindowLogic.closeTopUIByMobileQuickButton(self)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) or localPlayer.Player == nil or not localPlayer.Player:isMobileUIPlatform() then
    return false
  end
  if not localPlayer.Player.init then
    return false
  end
  if self.openedUICount <= 0 then
    return false
  end
  local list = self.UIWindow
  local layer = #list
  for i = layer, 1, -1 do
    local entity = ___MOD._EntityService:GetEntity(list[i])
    if not entity then
      ___MOD.table.remove(list, i)
    elseif entity and entity.Enable then
      self:enableUI(entity)
      return true
    end
  end
  return false
end

function UIWindowLogic.createFloatNotice(self, type, text, duration, disableRichText)
  local floatNotice = self:getUI("FloatNotice")
  if ___MOD.isvalid(floatNotice) then
    floatNotice:Destroy()
    self.UI.FloatNotice = nil
  end
  local model = ___MOD._EntryService:GetModelIdByName("Model_FloatNotice")
  local ui = self:createUI("FloatNotice", model, false)
  ui.FloatNoticeComponent:setFloatNotice(type, text, duration, disableRichText)
end

function UIWindowLogic.createUI(self, key, model, enable)
  local UIGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  local UI = ___MOD._SpawnService:SpawnByModelId(model, key, ___MOD.FastVector3(0, 0, 0), UIGroup)
  if ___MOD.isvalid(UI) then
    local prevUI = self:getUI(key)
    if ___MOD.isvalid(prevUI) then
      if prevUI.Enable then
        ___MOD._UIWindowLogic:enableUI(prevUI)
      end
      prevUI:Destroy()
    end
    self:setUI(key, UI)
    if UI.Enable then
      UI.Enable = false
    end
    if enable then
      ___MOD._UIWindowLogic:enableUI(UI)
    end
  end
  return UI
end

function UIWindowLogic.destroyUI(self, key)
  local UI = self:getUI(key)
  if ___MOD.isvalid(UI) then
    if UI.Enable then
      ___MOD._UIWindowLogic:enableUI(UI)
    end
    UI:Destroy()
    self:setUI(key, nil)
  end
end

function UIWindowLogic.enableUI(self, e)
  if not ___MOD.isvalid(e) then
    return
  end
  local enable = not e.Enable
  local uiName = e.Name
  if enable and ___MOD._AranLogic:isBlockedIntroWindow(uiName) then
    return
  end
  if uiName == "KeyConfig" and ___MOD._KeyConfigUILogic.isEnableUI then
    ___MOD.wait(0.1)
    ___MOD._UserService.LocalPlayer.KeyConfigUIComponent:clickedBtCancle()
    return
  end
  if uiName == "QuestAlram" then
    return
  end
  if uiName == "WebNotice" then
    self.openWebNotice = enable
  end
  if uiName == "WebUserList" then
    self.openWebUserList = enable
  end
  if uiName == "WebUserRank" then
    self.openWebUserRank = enable
  end
  if uiName == "Delivery" then
    self.openDelivery = enable
  end
  if enable then
    self:recoverWindowPositionOnOpen(e)
    ___MOD._UIWindowLogic:moveToTopLayer(e)
    self.openedUICount = self.openedUICount + 1
    if e.Name == "utilDlg" then
      e.Enable = true
    end
    local event = ___MOD.EnableUIEvent()
    event.uiName = e.Name
    self:SendEvent(event)
  else
    if e.Name == "Notice" or e.Name == "Notice2" or ___MOD.string.find(e.Name, "miniMap") ~= nil then
      return
    end
    if e.Name ~= "utilDlg" then
      self.openedUICount = ___MOD.math.max(self.openedUICount - 1, 0)
    end
    local event = ___MOD.DisableUIEvent()
    event.uiName = e.Name
    self:SendEvent(event)
    ___MOD._UIElementLogic:disableClone()
  end
  if e.Name ~= "utilDlg" then
    e.Enable = enable
    if enable then
      ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.MenuUp"), 1)
    else
      ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.MenuDown"), 1)
    end
  end
end

function UIWindowLogic.endWindowDrag(self, entity)
  if not ___MOD.isvalid(entity) then
    return
  end
  self.windowMagnetState[entity.Id] = nil
end

function UIWindowLogic.ensureOpenedUICountAtLeastVisibleWindows(self)
  local visibleCount = 0
  for i = 1, #self.UIWindow do
    local entity = ___MOD._EntityService:GetEntity(self.UIWindow[i])
    if ___MOD.isvalid(entity) and entity.Enable then
      visibleCount = visibleCount + 1
    end
  end
  if visibleCount > self.openedUICount then
    self.openedUICount = visibleCount
  end
end

function UIWindowLogic.equalsHoverdUI(self, entity)
  return self.HoverdUI == entity
end

function UIWindowLogic.getUI(self, key)
  return self.UI[key]
end

function UIWindowLogic.getUIScreenRect(self)
  local SW, SH = ___MOD._UILogic.ScreenWidth, ___MOD._UILogic.ScreenHeight
  local refW, refH = 1920, 1080
  local curAspect, refAspect = SW / SH, refW / refH
  local halfW, halfH
  if curAspect < refAspect then
    halfW = refW / 2
    halfH = halfW / curAspect
  else
    halfH = refH / 2
    halfW = halfH * curAspect
  end
  return {
    left = -halfW,
    right = halfW,
    top = halfH,
    bottom = -halfH
  }
end

function UIWindowLogic.getWindowMagnetOffsetX(self, entity)
  if not ___MOD.isvalid(entity) then
    return 0
  end
  if entity.Name == "Inventory" then
    local player = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(player) and player.CInventoryComponent ~= nil and player.CInventoryComponent.isFullMode == true then
      return 425
    end
  end
  return 0
end

function UIWindowLogic.getWindowMagnetPosition(self, entity, pos)
  if not ___MOD.isvalid(entity) then
    return pos
  end
  local offsetX = self:getWindowMagnetOffsetX(entity)
  if offsetX ~= 0 then
    return ___MOD.FastVector2(pos.x + offsetX, pos.y)
  end
  return pos
end

function UIWindowLogic.getWindowRect(self, entity, posOverride)
  if not ___MOD.isvalid(entity) then
    return nil
  end
  local tr = entity.UITransformComponent
  if tr == nil then
    return nil
  end
  local size = tr.RectSize or ___MOD.FastVector2.zero
  local pos = self:getWindowMagnetPosition(entity, posOverride or tr.anchoredPosition)
  if entity.Name == "Inventory" then
    local player = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(player) and player.CInventoryComponent ~= nil and player.CInventoryComponent.isFullMode == true then
      size = ___MOD.FastVector2(size.x + 850, size.y)
    end
  end
  local pivot = tr.Pivot or ___MOD.FastVector2(0.5, 0.5)
  local left = pos.x - size.x * pivot.x
  local bottom = pos.y - size.y * pivot.y
  return {
    x = pos.x,
    y = pos.y,
    w = size.x,
    h = size.y,
    px = pivot.x,
    py = pivot.y,
    left = left,
    right = left + size.x,
    bottom = bottom,
    top = bottom + size.y
  }
end

function UIWindowLogic.getWindowRoot(self, entity)
  if not ___MOD.isvalid(entity) then
    return nil
  end
  local current = entity
  while ___MOD.isvalid(current) do
    local currentId = current.Id
    for i = 1, #self.UIWindow do
      if self.UIWindow[i] == currentId then
        return current
      end
    end
    current = current.Parent
  end
  return nil
end

function UIWindowLogic.HandleKeyDownEvent(self, event)
  local key = event.key
  if not ___MOD.isvalid(___MOD._UserService.LocalPlayer) then
    return
  end
  if not ___MOD._UserService.LocalPlayer.Player.init then
    return
  end
  if key == ___MOD.KeyboardKey.Escape then
    local suppressUntil = self._T.suppressEscapeUntil
    if suppressUntil ~= nil and suppressUntil > ___MOD._UtilLogic.ElapsedSeconds then
      self._T.suppressEscapeUntil = nil
      return
    end
    local localPlayer = ___MOD._UserService.LocalPlayer
    if localPlayer.Player ~= nil and localPlayer.Player:isMobileUIPlatform() then
      ___MOD._PlayerKeyActionFunction:onMenu(true)
      return
    end
    if self:closeAranSkillGuideIfOpen() then
      return
    end
    if ___MOD._UseItemManager ~= nil and ___MOD._UseItemManager._T ~= nil and ___MOD._UseItemManager._T.detectMacroOpened == true then
      return
    end
    if #___MOD._UINotice.noitceUIList > 0 then
      return
    end
    if self.chatInputField.TextInputComponent.IsFocused then
      local e = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat")
      e.ChatLogComponent:activateChatTextField(false)
    end
    if 0 >= self.openedUICount then
      local shortcut = ___MOD._EntityService:GetEntity("e6ddb17d-c7c7-410a-b4bf-22d861e72b32")
      if shortcut.Enable then
        local pa = ___MOD.isvalid(___MOD._UserService.LocalPlayer) and ___MOD._UserService.LocalPlayer.PlayerActionComponent or nil
        if pa ~= nil then
          pa:setUIControlLock(___MOD._ControllEnableType.ShortCut, false)
        end
        shortcut.CanvasGroupComponent.GroupAlpha = 0
        shortcut.Enable = false
        return
      end
      ___MOD._PlayerKeyActionFunction:onMenu(true)
      return
    end
    local list = self.UIWindow
    local layer = #list
    for i = layer, 1, -1 do
      local entity = ___MOD._EntityService:GetEntity(list[i])
      if not entity then
        ___MOD.table.remove(list, i)
      elseif entity and entity.Enable then
        self:enableUI(entity)
        break
      end
    end
  end
end

function UIWindowLogic.isCursorBlockedByAnyWindow(self)
  for i = #self.UIWindow, 1, -1 do
    local window = ___MOD._EntityService:GetEntity(self.UIWindow[i])
    if self:isCursorInsideWindow(window) then
      return true
    end
  end
  return false
end

function UIWindowLogic.isCursorBlockedByHigherWindow(self, entity)
  local windowRoot = self:getWindowRoot(entity)
  if not ___MOD.isvalid(windowRoot) then
    return false
  end
  local entityId = windowRoot.Id
  local entityIndex = 0
  for i = 1, #self.UIWindow do
    if self.UIWindow[i] == entityId then
      entityIndex = i
      break
    end
  end
  if entityIndex <= 0 then
    return false
  end
  for i = #self.UIWindow, entityIndex + 1, -1 do
    local windowId = self.UIWindow[i]
    local window = ___MOD._EntityService:GetEntity(windowId)
    if self:isCursorInsideWindow(window) then
      return true
    end
  end
  return false
end

function UIWindowLogic.isCursorInsideWindow(self, entity)
  if not ___MOD.isvalid(entity) or not entity.EnabledInHierarchy then
    return false
  end
  local tr = entity.UITransformComponent
  if tr == nil then
    return false
  end
  local cursorPos = ___MOD._InputService:GetCursorPosition()
  local localPos = ___MOD._UILogic:ScreenToLocalUIPosition(cursorPos, tr)
  local anchoredPosition = tr.anchoredPosition
  local size = tr.RectSize
  local pivot = tr.Pivot or ___MOD.FastVector2(0.5, 0.5)
  local left = anchoredPosition.x - size.x * pivot.x
  local right = left + size.x
  local bottom = anchoredPosition.y - size.y * pivot.y
  local top = bottom + size.y
  if left <= localPos.x and right >= localPos.x and bottom <= localPos.y and top >= localPos.y then
    return true
  end
  if entity.Children ~= nil then
    for _, child in ___MOD.pairs(entity.Children) do
      if self:isCursorInsideWindow(child) then
        return true
      end
    end
  end
  return false
end

function UIWindowLogic.isOpenUI(self)
  if self.openWebNotice or self.openWebUserList or self.openWebUserRank or self.openDelivery or #___MOD._UINotice.noitceUIList > 0 then
    return true
  end
  return false
end

function UIWindowLogic.moveToTopLayer(self, entity)
  if self.Queued then
    return
  end
  self.Queued = true
  local entityId = entity.Id
  local list = self.UIWindow
  local layer = #list
  local idx
  for i = layer, 1, -1 do
    if list[i] == entityId then
      idx = i
      break
    end
  end
  if idx and idx == layer then
    self.Queued = false
    return
  end
  if idx then
    ___MOD.table.remove(list, idx)
  end
  ___MOD.table.insert(list, entityId)
  local parent = entity.Parent
  entity:AttachTo(self.TempGroup)
  entity:AttachTo(parent)
  self.Queued = false
end

function UIWindowLogic.recoverWindowPositionOnOpen(self, entity)
  if not self:shouldRecoverWindowPositionOnOpen(entity) then
    return
  end
  local tr = entity.UITransformComponent
  if tr == nil then
    return
  end
  local rect = self:getWindowRect(entity, tr.anchoredPosition)
  if rect == nil then
    return
  end
  local screenRect = self:getUIScreenRect()
  local horizontalMinVisible = 0
  local bottomMinVisible = 40
  if entity.Name == "Inventory" then
    local player = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(player) and player.CInventoryComponent ~= nil and player.CInventoryComponent.isFullMode == true then
      horizontalMinVisible = 80
    end
  end
  local adjusted = false
  if rect.top > screenRect.top then
    tr.anchoredPosition.y = tr.anchoredPosition.y - (rect.top - screenRect.top)
    adjusted = true
    rect = self:getWindowRect(entity, tr.anchoredPosition)
  end
  if rect ~= nil and rect.top < screenRect.bottom + bottomMinVisible then
    tr.anchoredPosition.y = tr.anchoredPosition.y + (screenRect.bottom + bottomMinVisible - rect.top)
    adjusted = true
    rect = self:getWindowRect(entity, tr.anchoredPosition)
  end
  if 0 < horizontalMinVisible then
    if rect ~= nil and rect.right < screenRect.left + horizontalMinVisible then
      tr.anchoredPosition.x = tr.anchoredPosition.x + (screenRect.left + horizontalMinVisible - rect.right)
      adjusted = true
      rect = self:getWindowRect(entity, tr.anchoredPosition)
    end
    if rect ~= nil and rect.left > screenRect.right - horizontalMinVisible then
      tr.anchoredPosition.x = tr.anchoredPosition.x - (rect.left - (screenRect.right - horizontalMinVisible))
      adjusted = true
    end
  else
    if rect ~= nil and rect.left < screenRect.left then
      tr.anchoredPosition.x = tr.anchoredPosition.x + (screenRect.left - rect.left)
      adjusted = true
      rect = self:getWindowRect(entity, tr.anchoredPosition)
    end
    if rect ~= nil and rect.right > screenRect.right then
      tr.anchoredPosition.x = tr.anchoredPosition.x - (rect.right - screenRect.right)
      adjusted = true
    end
  end
  if adjusted then
    self.windowMagnetState[entity.Id] = nil
  end
end

function UIWindowLogic.setHoverdUI(self, entity)
  if not ___MOD.isvalid(self.HoverdUI) then
    self.HoverdUI = entity
  end
end

function UIWindowLogic.setOpenedUICount(self, delta)
  self.openedUICount = ___MOD.math.max(self.openedUICount + delta, 0)
end

function UIWindowLogic.setUI(self, key, ui)
  self.UI[key] = ui
end

function UIWindowLogic.shouldRecoverWindowPositionOnOpen(self, entity)
  if not ___MOD.isvalid(entity) then
    return false
  end
  return entity.Name == "Inventory" or entity.Name == "Equipment" or entity.Name == "Skill" or entity.Name == "Quest" or entity.Name == "CharacterStat" or entity.Name == "UserList" or entity.Name == "KeyConfig" or entity.Name == "PartyHPUI"
end

function UIWindowLogic.showMakerUI(self)
  if ___MOD._WorldConstants.canEnterMaker ~= true then
    ___MOD._UINotice:showAlertUI("메이커 사용이 일시적으로 제한됩니다.\r\n\r\n잠시 후 다시 시도해 주세요.")
    return
  end
  local model = ___MOD._EntryService:GetModelIdByName("Model_Maker")
  local UIGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  local maker = ___MOD._SpawnService:SpawnByModelId(model, "Maker", ___MOD.FastVector3(0, 0, 0), UIGroup)
  maker.MakerUIComponent:init()
end

function UIWindowLogic.showRaiseUI(self, itemID)
  local model = ___MOD._EntryService:GetModelIdByName("Model_Raise")
  local ui = self:createUI("Raise", model, false)
  ui.RaiseUIComponent:init(itemID)
end

function UIWindowLogic.showWheelUI(self, value)
  local model = ___MOD._EntryService:GetModelIdByName("Model_RemainingWheelUI")
  local ui = self:createUI("Wheel", model, false)
  ui.RemainingWheelUIComponent:setValue(value)
end

function UIWindowLogic.suppressEscapeOnce(self)
  self._T.suppressEscapeUntil = ___MOD._UtilLogic.ElapsedSeconds + 0.05
end
