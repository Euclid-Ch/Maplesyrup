

function UIMobileHudLayout.applyMobileActionSlotsLayout(self, openX, openY, hiddenOffsetX)
  if ___MOD._MobileActionSlotLogic ~= nil then
    ___MOD._MobileActionSlotLogic:ApplyMobileActionSlotLayout(openX, openY, hiddenOffsetX)
    return
  end
  self:setTargetPosition("/ui/UIGroup/MobileActionSlots", openX, openY)
end

function UIMobileHudLayout.applyMobileChatBoardLayout(self, visibleRect, layoutRect, boardWidth, boardHeight, boardScale)
  local chat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  local board = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat/MobileChatBoard")
  if not ___MOD.isvalid(chat) or chat.UITransformComponent == nil or not ___MOD.isvalid(board) then
    return
  end
  local chatTransform = chat.UITransformComponent
  local chatSize = chatTransform.RectSize or self:getBaseSize("/ui/UIGroup/MobileChat", chatTransform)
  local chatPivot = chatTransform.Pivot or ___MOD.FastVector2(0.5, 0.5)
  local parentLeft = chatTransform.anchoredPosition.x - chatSize.x * chatPivot.x
  local parentY = visibleRect.top + chatTransform.anchoredPosition.y
  local visualWidth = boardWidth * boardScale
  local openX = layoutRect.left + visualWidth * 0.5 - parentLeft
  local openY = (layoutRect.top + layoutRect.bottom) * 0.5 - parentY
  local chatComponent = chat:GetComponent("script.UIMobileChat")
  if chatComponent == nil then
    return
  end
  chatComponent:ApplyMobileChatBoardLayout(openX, openY, boardWidth, boardHeight, boardScale)
end

function UIMobileHudLayout.applyMobileChatPosition(self, defaultY)
  local hadSavedPosition = self.mobileChatPositionSaved == true
  if self.mobileChatPositionSaved == true and self:IsMobileChatPositionInBounds(self.mobileChatPositionX, self.mobileChatPositionY) then
    self:setTargetPosition("/ui/UIGroup/MobileChat", self.mobileChatPositionX, self.mobileChatPositionY)
    return
  end
  self.mobileChatPositionSaved = false
  self.mobileChatPositionX = 0
  self.mobileChatPositionY = 0
  self:setTargetPosition("/ui/UIGroup/MobileChat", 0, defaultY)
  if hadSavedPosition then
    self:SyncMobileChatPositionToServer()
  end
end

function UIMobileHudLayout.ApplyMobileHudLayout(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  self:prepareBasePositions()
  self:prepareBaseSizes()
  local wideWeight = self:getWideWeight()
  local tabletWeight = self:getTabletWeight()
  local visibleRect = self:getMobileVisibleRect()
  local layoutRect = self:getEstimatedMobileLayoutRect(visibleRect)
  local layoutWidth = ___MOD.math.max(1, layoutRect.right - layoutRect.left)
  local layoutHeight = ___MOD.math.max(1, layoutRect.top - layoutRect.bottom)
  local leftInset = layoutRect.left - visibleRect.left
  local rightInset = visibleRect.right - layoutRect.right
  local topInset = visibleRect.top - layoutRect.top
  local bottomInset = layoutRect.bottom - visibleRect.bottom
  local statusBarHeight = 200
  local expBarHeight = 30
  local statusBarY = bottomInset + statusBarHeight * 0.5 + self.mobileStatusBarTabletOffsetY * tabletWeight
  local statusBarBottomY = visibleRect.bottom + statusBarY - statusBarHeight * 0.5
  local expBarY = layoutRect.bottom - statusBarBottomY + expBarHeight * 0.5
  local joystickOffsetX = leftInset + self.mobileJoystickTabletOffsetX * tabletWeight
  local joystickOffsetY = bottomInset + self.mobileJoystickTabletOffsetY * tabletWeight
  local actionSlotsX = self:getMobileActionSlotsLayoutX(visibleRect, layoutRect, tabletWeight)
  local actionSlotsY = self:getMobileActionSlotsLayoutY(visibleRect, layoutRect, tabletWeight)
  local actionSlotsHiddenOffsetX = self:getMobileActionSlotsHiddenOffsetX(visibleRect, layoutRect)
  local actionSlotToggleOffsetX = self.mobileActionSlotTogglePhoneOffsetX + (self.mobileActionSlotToggleTabletOffsetX - self.mobileActionSlotTogglePhoneOffsetX) * tabletWeight
  local actionSlotToggleOffsetY = self.mobileActionSlotTogglePhoneOffsetY + (self.mobileActionSlotToggleTabletOffsetY - self.mobileActionSlotTogglePhoneOffsetY) * tabletWeight
  local actionSlotToggleX = actionSlotsX + actionSlotToggleOffsetX
  local actionSlotToggleY = actionSlotsY + actionSlotToggleOffsetY
  local statusBackgroundY = actionSlotToggleY - statusBarY
  local screenCenterX = (visibleRect.left + visibleRect.right) * 0.5
  local actionSlotSettingX = self:getMobileActionSlotSettingLayoutX(actionSlotToggleX)
  local mobileQuickCloseX = visibleRect.right + actionSlotToggleX - screenCenterX
  local shortcutY = ___MOD.math.max(layoutRect.bottom + 120, ___MOD.math.min(layoutRect.top - 120, 220))
  local shortcutX = self:getMobileShortcutLayoutX(visibleRect, layoutRect)
  local mobileChatY = -150 - topInset
  local mobileChatBoardScale = self:getFitScale(self.mobileChatBoardBaseWidth, self.mobileChatBoardBaseHeight, layoutWidth, layoutHeight, self.mobileChatBoardMinScale, self.mobileChatBoardMaxScale)
  local mobileChatBoardWidth = self.mobileChatBoardBaseWidth
  local mobileChatBoardHeight = self.mobileChatBoardBaseHeight
  local mobileMenuPanelScale = self:getFitScale(self.mobileMenuPanelBaseWidth, self.mobileMenuPanelBaseHeight, layoutWidth, layoutHeight, self.mobileMenuPanelMinScale, self.mobileMenuPanelMaxScale)
  local mobileMenuPanelWidth = self.mobileMenuPanelBaseWidth
  local mobileMenuPanelHeight = self.mobileMenuPanelBaseHeight
  self:setTargetSize("/ui/UIGroup/MobileStatusBar", layoutWidth, statusBarHeight)
  self:setTargetPosition("/ui/UIGroup/MobileStatusBar", 0, statusBarY)
  self:setTargetPosition("/ui/UIGroup/MobileStatusBar/background", 0, statusBackgroundY)
  self:setTargetSize("/ui/UIGroup/MobileStatusBar/ExpGauge", layoutWidth, expBarHeight)
  self:setTargetPosition("/ui/UIGroup/MobileStatusBar/ExpGauge", 0, expBarY)
  self:setTargetSize("/ui/UIGroup/MobileStatusBar/ExpGauge/expBarBg", layoutWidth, expBarHeight)
  self:setTargetSize("/ui/UIGroup/MobileStatusBar/ExpGauge/mobileExpBar", layoutWidth, expBarHeight)
  self:setTargetPosition("/ui/UIGroup/MobileStatusBar/LevelNameBG", 200, 90)
  self:applyMobileActionSlotsLayout(actionSlotsX, actionSlotsY, actionSlotsHiddenOffsetX)
  self:setTargetPosition("/ui/UIGroup/MobileActionSlotSetting", actionSlotSettingX, actionSlotToggleY)
  self:setTargetPosition("/ui/UIGroup/MobileQuickCloseBtn", mobileQuickCloseX, actionSlotToggleY)
  self:applyTarget("/ui/UIGroup/UIJoystick", joystickOffsetX, joystickOffsetY)
  self:setTargetPosition("/ui/UIGroup/MobileShortcutMenu", shortcutX, shortcutY)
  self:applyMobileChatPosition(mobileChatY)
  self:applyTargetToBasePosition("/ui/UIGroup/MainNotice", "/ui/UIGroup/MainLogo", 0, 0)
  self:applyTargetToBasePosition("/ui/UIGroup/MainQuest", "/ui/UIGroup/MainNotice", 0, 0)
  self:applyTargetToBasePosition("/ui/UIGroup/MobileMenu", "/ui/UIGroup/BtNotice", -rightInset, -topInset)
  self:applyMobileMenuLayout(visibleRect, layoutRect, mobileMenuPanelWidth, mobileMenuPanelHeight, mobileMenuPanelScale)
  self:applyMobileChatBoardLayout(visibleRect, layoutRect, mobileChatBoardWidth, mobileChatBoardHeight, mobileChatBoardScale)
  self:applyMobileStackMessageLayout(visibleRect, layoutRect)
end

function UIMobileHudLayout.ApplyMobileHudLayoutDeferred(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  self:ApplyMobileHudLayout()
  ___MOD._TimerService:SetTimerOnce(function()
    self:ApplyMobileHudLayout()
  end, 0.1)
end

function UIMobileHudLayout.applyMobileMenuLayout(self, visibleRect, layoutRect, panelWidth, panelHeight, panelScale)
  local menu = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileMenu")
  local panel = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileMenu/MobileMenuBg")
  if not ___MOD.isvalid(menu) or menu.UITransformComponent == nil or not ___MOD.isvalid(panel) then
    return
  end
  local menuTransform = menu.UITransformComponent
  local parentX = visibleRect.right + menuTransform.anchoredPosition.x
  local parentY = visibleRect.top + menuTransform.anchoredPosition.y
  local visualWidth = panelWidth * panelScale
  local openX = layoutRect.right - visualWidth * 0.5 - parentX
  local openY = (layoutRect.top + layoutRect.bottom) * 0.5 - parentY
  local closedX = openX + visualWidth + 80
  local menuComponent = menu:GetComponent("script.UIMobileMenu")
  if menuComponent == nil then
    return
  end
  menuComponent:ApplyMobileMenuLayout(openX, openY, closedX, openY, panelWidth, panelHeight, panelScale)
end

function UIMobileHudLayout.applyMobileStackMessageLayout(self, visibleRect, layoutRect)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local parent = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/StackMessage")
  if not ___MOD.isvalid(parent) or parent.UITransformComponent == nil then
    return
  end
  local transform = parent.UITransformComponent
  local rectSize = transform.RectSize
  local pivot = transform.Pivot
  local position = transform.anchoredPosition
  local width = rectSize ~= nil and (rectSize.x or 0) or 0
  local pivotX = pivot ~= nil and (pivot.x or 0.5) or 0.5
  local positionY = position ~= nil and (position.y or 0) or 0
  local leftInset = 0
  if visibleRect ~= nil and layoutRect ~= nil and visibleRect.left ~= nil and layoutRect.left ~= nil then
    leftInset = ___MOD.math.max(0, layoutRect.left - visibleRect.left)
  end
  transform.AlignmentOption = ___MOD.AlignmentType.BottomLeft
  transform.anchoredPosition = ___MOD.FastVector2(leftInset + 20 + width * pivotX, positionY)
end

function UIMobileHudLayout.applyTarget(self, path, offsetX, offsetY)
  local target = ___MOD._EntityService:GetEntityByPath(path)
  if not ___MOD.isvalid(target) or target.UITransformComponent == nil then
    return
  end
  local transform = target.UITransformComponent
  local basePosition = self:getBasePosition(path, transform)
  transform.anchoredPosition = ___MOD.FastVector2(basePosition.x + offsetX, basePosition.y + offsetY)
end

function UIMobileHudLayout.applyTargetToBasePosition(self, targetPath, sourcePath, offsetX, offsetY)
  local source = ___MOD._EntityService:GetEntityByPath(sourcePath)
  if not ___MOD.isvalid(source) or source.UITransformComponent == nil then
    return
  end
  local basePosition = self:getBasePosition(sourcePath, source.UITransformComponent)
  self:setTargetPosition(targetPath, basePosition.x + offsetX, basePosition.y + offsetY)
end

function UIMobileHudLayout.FitMobileChatPositionInBounds(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local chat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  if not ___MOD.isvalid(chat) or chat.UITransformComponent == nil then
    return
  end
  local transform = chat.UITransformComponent
  local size = transform.RectSize
  if size == nil then
    return
  end
  local pivot = transform.Pivot or ___MOD.FastVector2(0.5, 0.5)
  local scaleX = 1
  local scaleY = 1
  if transform.Scale ~= nil then
    scaleX = ___MOD.math.abs(___MOD.tonumber(transform.Scale.x) or 1)
    scaleY = ___MOD.math.abs(___MOD.tonumber(transform.Scale.y) or 1)
  end
  local visibleRect = self:getMobileVisibleRect()
  local layoutRect = self:getEstimatedMobileLayoutRect(visibleRect)
  local width = size.x * scaleX
  local height = size.y * scaleY
  local minX = layoutRect.left + width * pivot.x
  local maxX = layoutRect.right - width * (1 - pivot.x)
  local minY = layoutRect.bottom - visibleRect.top + height * pivot.y
  local maxY = layoutRect.top - visibleRect.top - height * (1 - pivot.y)
  if minX > maxX or minY > maxY then
    self:ResetMobileChatPosition()
    self:SyncMobileChatPositionToServer()
    return
  end
  local currentX = ___MOD.tonumber(transform.anchoredPosition.x) or 0
  local currentY = ___MOD.tonumber(transform.anchoredPosition.y) or 0
  local nextX = ___MOD.math.max(minX, ___MOD.math.min(maxX, currentX))
  local nextY = ___MOD.math.max(minY, ___MOD.math.min(maxY, currentY))
  if nextX == currentX and nextY == currentY then
    self:RefreshMobileChatBoardLayout()
    return
  end
  transform.anchoredPosition.x = nextX
  transform.anchoredPosition.y = nextY
  self.mobileChatPositionSaved = true
  self.mobileChatPositionX = nextX
  self.mobileChatPositionY = nextY
  self:RefreshMobileChatBoardLayout()
  self:SyncMobileChatPositionToServer()
end

function UIMobileHudLayout.FitMobileTooltipPositionInBounds(self, positionX, positionY, tooltipWidth, tooltipHeight, rightMargin)
  local x = ___MOD.tonumber(positionX) or 0
  local y = ___MOD.tonumber(positionY) or 0
  if not ___MOD.Environment:IsMobilePlatform() then
    return ___MOD.FastVector2(x, y)
  end
  local layoutRect = self:getCurrentMobileLayoutRect()
  local width = ___MOD.math.max(0, ___MOD.tonumber(tooltipWidth) or 0)
  local height = ___MOD.math.max(0, ___MOD.tonumber(tooltipHeight) or 0)
  local margin = ___MOD.math.max(0, ___MOD.tonumber(rightMargin) or 0)
  local minX = layoutRect.left
  local maxX = layoutRect.right - width - margin
  local minY = layoutRect.bottom + height
  local maxY = layoutRect.top
  if minX > maxX then
    x = minX
  else
    x = ___MOD.math.max(minX, ___MOD.math.min(x, maxX))
  end
  if minY > maxY then
    y = maxY
  else
    y = ___MOD.math.max(minY, ___MOD.math.min(y, maxY))
  end
  return ___MOD.FastVector2(x, y)
end

function UIMobileHudLayout.getBasePosition(self, path, transform)
  local basePositions = self._T.mobileHudBasePositions
  local basePosition = basePositions[path]
  if basePosition == nil then
    basePosition = self:getDefinedBasePosition(path, transform)
    basePositions[path] = basePosition
  end
  return basePosition
end

function UIMobileHudLayout.getBaseSize(self, path, transform)
  local baseSizes = self._T.mobileHudBaseSizes
  local baseSize = baseSizes[path]
  if baseSize == nil then
    baseSize = self:getDefinedBaseSize(path, transform)
    baseSizes[path] = baseSize
  end
  return baseSize
end

function UIMobileHudLayout.getCurrentAspect(self)
  local width = ___MOD._UILogic.ScreenWidth
  local height = ___MOD._UILogic.ScreenHeight
  if width == nil or height == nil or width <= 0 or height <= 0 then
    return self.baseAspect
  end
  if width >= height then
    return width / height
  end
  return height / width
end

function UIMobileHudLayout.getCurrentMobileLayoutRect(self)
  local visibleRect = self:getMobileVisibleRect()
  return self:getEstimatedMobileLayoutRect(visibleRect)
end

function UIMobileHudLayout.getDefinedBasePosition(self, path, transform)
  if path == "/ui/UIGroup/MobileStatusBar" then
    return ___MOD.FastVector2(0, 115)
  elseif path == "/ui/UIGroup/MobileActionSlots" then
    return ___MOD.FastVector2(70, -50)
  elseif path == "/ui/UIGroup/UIJoystick" then
    return ___MOD.FastVector2(400, -200)
  elseif path == "/ui/UIGroup/MobileShortcutMenu" then
    return ___MOD.FastVector2(-10, 220)
  elseif path == "/ui/UIGroup/MobileChat" then
    return ___MOD.FastVector2(0, -150)
  elseif path == "/ui/UIGroup/MobileStatusBar/LevelNameBG" then
    return ___MOD.FastVector2(180, 90)
  elseif path == "/ui/UIGroup/MobileStatusBar/ExpGauge" then
    return ___MOD.FastVector2(0, 0)
  elseif path == "/ui/UIGroup/MobileChat/MobileChatBoard" then
    return ___MOD.FastVector2(-240, -360)
  elseif path == "/ui/UIGroup/MainNotice" then
    return ___MOD.FastVector2(67, 38)
  elseif path == "/ui/UIGroup/MainQuest" then
    return ___MOD.FastVector2(67, -44)
  end
  local current = transform.anchoredPosition
  if current ~= nil then
    return ___MOD.FastVector2(current.x or 0, current.y or 0)
  end
  return ___MOD.FastVector2(0, 0)
end

function UIMobileHudLayout.getDefinedBaseSize(self, path, transform)
  if path == "/ui/UIGroup/MobileStatusBar/ExpGauge/expBarBg" then
    return ___MOD.FastVector2(self.expBarBaseWidth, 30)
  elseif path == "/ui/UIGroup/MobileStatusBar/ExpGauge/mobileExpBar" then
    return ___MOD.FastVector2(self.expBarBaseWidth, 30)
  elseif path == "/ui/UIGroup/MobileChat" then
    return ___MOD.FastVector2(683, 54)
  elseif path == "/ui/UIGroup/MobileChat/MobileChatBoard" then
    return ___MOD.FastVector2(865.8, 984)
  end
  local current = transform.RectSize
  if current ~= nil then
    return ___MOD.FastVector2(current.x or 0, current.y or 0)
  end
  return ___MOD.FastVector2(0, 0)
end

function UIMobileHudLayout.getEstimatedMobileLayoutRect(self, visibleRect)
  local wideWeight = self:getWideWeight()
  local tabletWeight = self:getTabletWeight()
  local leftInset = self.maxLeftOffset * wideWeight
  local rightInset = self.maxRightOffset * wideWeight
  local topInset = self.maxTopOffset * wideWeight
  local bottomInset = self.maxBottomOffset * tabletWeight
  local rect = self._T.mobileHudLayoutRect
  if rect == nil then
    rect = {}
    self._T.mobileHudLayoutRect = rect
  end
  rect.left = visibleRect.left + leftInset
  rect.right = visibleRect.right - rightInset
  rect.top = visibleRect.top - topInset
  rect.bottom = visibleRect.bottom + bottomInset
  return rect
end

function UIMobileHudLayout.getFitScale(self, baseWidth, baseHeight, targetWidth, targetHeight, minScale, maxScale)
  local widthScale = targetWidth / ___MOD.math.max(1, baseWidth)
  local heightScale = targetHeight / ___MOD.math.max(1, baseHeight)
  local scale = ___MOD.math.min(widthScale, heightScale)
  return ___MOD.math.max(minScale, ___MOD.math.min(maxScale, scale))
end

function UIMobileHudLayout.getMobileActionSlotSettingLayoutX(self, actionSlotToggleX)
  return actionSlotToggleX - self.mobileActionSlotControlLayoutWidth
end

function UIMobileHudLayout.getMobileActionSlotsHiddenOffsetX(self, visibleRect, layoutRect)
  local layoutWidth = ___MOD.math.max(1, layoutRect.right - layoutRect.left)
  return ___MOD.math.max(800, layoutWidth * 0.5)
end

function UIMobileHudLayout.getMobileActionSlotsLayoutX(self, visibleRect, layoutRect, tabletWeight)
  local margin = self.mobileActionSlotsPhoneMarginRight + (self.mobileActionSlotsTabletMarginRight - self.mobileActionSlotsPhoneMarginRight) * tabletWeight
  local visualOffset = self.mobileActionSlotsPhoneVisualOffsetX + (self.mobileActionSlotsTabletVisualOffsetX - self.mobileActionSlotsPhoneVisualOffsetX) * tabletWeight
  return layoutRect.right - visibleRect.right - margin + visualOffset
end

function UIMobileHudLayout.getMobileActionSlotsLayoutY(self, visibleRect, layoutRect, tabletWeight)
  local margin = self.mobileActionSlotsPhoneMarginBottom + (self.mobileActionSlotsTabletMarginBottom - self.mobileActionSlotsPhoneMarginBottom) * tabletWeight
  local visualOffset = self.mobileActionSlotsPhoneVisualOffsetY + (self.mobileActionSlotsTabletVisualOffsetY - self.mobileActionSlotsPhoneVisualOffsetY) * tabletWeight
  return layoutRect.bottom - visibleRect.bottom + margin + visualOffset
end

function UIMobileHudLayout.GetMobileChatDefaultY(self)
  local visibleRect = self:getMobileVisibleRect()
  local layoutRect = self:getEstimatedMobileLayoutRect(visibleRect)
  return -150 - (visibleRect.top - layoutRect.top)
end

function UIMobileHudLayout.GetMobileChatPositionData(self)
  return {
    saved = self.mobileChatPositionSaved == true,
    x = ___MOD.tonumber(self.mobileChatPositionX) or 0,
    y = ___MOD.tonumber(self.mobileChatPositionY) or 0
  }
end

function UIMobileHudLayout.getMobileShortcutLayoutX(self, visibleRect, layoutRect)
  local shortcut = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileShortcutMenu")
  if not ___MOD.isvalid(shortcut) then
    return layoutRect.right - visibleRect.right
  end
  local shortcutComponent = shortcut:GetComponent("script.UIMobileShortcutMenu")
  if shortcutComponent == nil then
    return layoutRect.right - visibleRect.right
  end
  return layoutRect.right - visibleRect.right - shortcutComponent:GetMobileShortcutButtonRightLocalX()
end

function UIMobileHudLayout.getMobileStatusBarRect(self)
  local visibleRect = self:getMobileVisibleRect()
  local layoutRect = self:getEstimatedMobileLayoutRect(visibleRect)
  local tabletWeight = self:getTabletWeight()
  local statusBarHeight = 200
  local bottomInset = layoutRect.bottom - visibleRect.bottom
  local centerY = visibleRect.bottom + bottomInset + statusBarHeight * 0.5 + self.mobileStatusBarTabletOffsetY * tabletWeight
  local halfWidth = (layoutRect.right - layoutRect.left) * 0.5
  local halfHeight = statusBarHeight * 0.5
  return {
    left = -halfWidth,
    right = halfWidth,
    top = centerY + halfHeight,
    bottom = centerY - halfHeight
  }
end

function UIMobileHudLayout.getMobileVisibleRect(self)
  local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  local aspect = self:getCurrentAspect()
  local referenceAspect = 1.7777777777777777
  local halfWidth = 960
  local halfHeight = 540
  if ___MOD.isvalid(uiGroup) and uiGroup.UITransformComponent ~= nil and uiGroup.UITransformComponent.RectSize ~= nil then
    local size = uiGroup.UITransformComponent.RectSize
    if size.x ~= nil and size.y ~= nil and size.x > 0 and size.y > 0 then
      halfWidth = size.x * 0.5
      halfHeight = size.y * 0.5
    elseif aspect < referenceAspect then
      halfWidth = 960
      halfHeight = halfWidth / aspect
    else
      halfHeight = 540
      halfWidth = halfHeight * aspect
    end
  elseif aspect < referenceAspect then
    halfWidth = 960
    halfHeight = halfWidth / aspect
  else
    halfHeight = 540
    halfWidth = halfHeight * aspect
  end
  local rect = self._T.mobileHudVisibleRect
  if rect == nil then
    rect = {}
    self._T.mobileHudVisibleRect = rect
  end
  rect.left = -halfWidth
  rect.right = halfWidth
  rect.top = halfHeight
  rect.bottom = -halfHeight
  return rect
end

function UIMobileHudLayout.getTabletWeight(self)
  local aspect = self:getCurrentAspect()
  local delta = self.tabletAspectThreshold - aspect
  if delta <= 0 then
    return 0
  end
  return ___MOD.math.min(1, ___MOD.math.max(0, delta / self.tabletAspectFullRange))
end

function UIMobileHudLayout.getWideWeight(self)
  local aspect = self:getCurrentAspect()
  local delta = aspect - self.baseAspect
  if delta <= self.aspectDeadZone then
    return 0
  end
  return ___MOD.math.min(1, ___MOD.math.max(0, (delta - self.aspectDeadZone) / self.aspectFullOffsetRange))
end

function UIMobileHudLayout.IsMobileChatPositionInBounds(self, positionX, positionY)
  if not ___MOD.Environment:IsMobilePlatform() then
    return false
  end
  local chat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  if not ___MOD.isvalid(chat) or chat.UITransformComponent == nil then
    return false
  end
  local transform = chat.UITransformComponent
  local size = transform.RectSize or self:getBaseSize("/ui/UIGroup/MobileChat", transform)
  local pivot = transform.Pivot or ___MOD.FastVector2(0.5, 0.5)
  local scaleX = 1
  local scaleY = 1
  if transform.Scale ~= nil then
    scaleX = ___MOD.math.abs(___MOD.tonumber(transform.Scale.x) or 1)
    scaleY = ___MOD.math.abs(___MOD.tonumber(transform.Scale.y) or 1)
  end
  local x = ___MOD.tonumber(positionX) or 0
  local y = ___MOD.tonumber(positionY) or 0
  local width = size.x * scaleX
  local height = size.y * scaleY
  local visibleRect = self:getMobileVisibleRect()
  local layoutRect = self:getEstimatedMobileLayoutRect(visibleRect)
  local left = x - width * pivot.x
  local right = x + width * (1 - pivot.x)
  local top = visibleRect.top + y + height * (1 - pivot.y)
  local bottom = visibleRect.top + y - height * pivot.y
  return left >= layoutRect.left and right <= layoutRect.right and top <= layoutRect.top and bottom >= layoutRect.bottom
end

function UIMobileHudLayout.prepareBasePositions(self)
  if self._T.mobileHudBasePositions == nil then
    self._T.mobileHudBasePositions = {}
  end
end

function UIMobileHudLayout.prepareBaseSizes(self)
  if self._T.mobileHudBaseSizes == nil then
    self._T.mobileHudBaseSizes = {}
  end
end

function UIMobileHudLayout.RefreshMobileChatBoardLayout(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local visibleRect = self:getMobileVisibleRect()
  local layoutRect = self:getEstimatedMobileLayoutRect(visibleRect)
  local layoutWidth = ___MOD.math.max(1, layoutRect.right - layoutRect.left)
  local layoutHeight = ___MOD.math.max(1, layoutRect.top - layoutRect.bottom)
  local boardScale = self:getFitScale(self.mobileChatBoardBaseWidth, self.mobileChatBoardBaseHeight, layoutWidth, layoutHeight, self.mobileChatBoardMinScale, self.mobileChatBoardMaxScale)
  self:applyMobileChatBoardLayout(visibleRect, layoutRect, self.mobileChatBoardBaseWidth, self.mobileChatBoardBaseHeight, boardScale)
end

function UIMobileHudLayout.ResetMobileChatPosition(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  self.mobileChatPositionSaved = false
  self.mobileChatPositionX = 0
  self.mobileChatPositionY = 0
  self:setTargetPosition("/ui/UIGroup/MobileChat", 0, self:GetMobileChatDefaultY())
  self:RefreshMobileChatBoardLayout()
end

function UIMobileHudLayout.RestoreMobileChatPosition(self, saved, positionX, positionY)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local restoredX = ___MOD.tonumber(positionX)
  local restoredY = ___MOD.tonumber(positionY)
  if saved ~= true or restoredX == nil or restoredY == nil or restoredX ~= restoredX or restoredY ~= restoredY or ___MOD.math.abs(restoredX) > 10000 or ___MOD.math.abs(restoredY) > 10000 then
    self.mobileChatPositionSaved = false
    self.mobileChatPositionX = 0
    self.mobileChatPositionY = 0
    return
  end
  self.mobileChatPositionSaved = true
  self.mobileChatPositionX = restoredX
  self.mobileChatPositionY = restoredY
end

function UIMobileHudLayout.setTargetPosition(self, path, x, y)
  local target = ___MOD._EntityService:GetEntityByPath(path)
  if not ___MOD.isvalid(target) or target.UITransformComponent == nil then
    return
  end
  target.UITransformComponent.anchoredPosition = ___MOD.FastVector2(x, y)
end

function UIMobileHudLayout.setTargetSize(self, path, width, height)
  local target = ___MOD._EntityService:GetEntityByPath(path)
  if not ___MOD.isvalid(target) or target.UITransformComponent == nil then
    return
  end
  target.UITransformComponent.RectSize = ___MOD.FastVector2(width, height)
end

function UIMobileHudLayout.SyncMobileChatPositionToServer(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) then
    return
  end
  ___MOD._MobileUITransferLogic:updateMobileChatPos(self:GetMobileChatPositionData())
end

function UIMobileHudLayout.TrySetMobileChatPosition(self, positionX, positionY)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local nextX = ___MOD.tonumber(positionX) or 0
  local nextY = ___MOD.tonumber(positionY) or 0
  if not self:IsMobileChatPositionInBounds(nextX, nextY) then
    self:ResetMobileChatPosition()
    return
  end
  self.mobileChatPositionSaved = true
  self.mobileChatPositionX = nextX
  self.mobileChatPositionY = nextY
  self:setTargetPosition("/ui/UIGroup/MobileChat", nextX, nextY)
  self:RefreshMobileChatBoardLayout()
end
