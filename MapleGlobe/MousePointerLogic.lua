

function MousePointerLogic.applyCursorPositionOffset(self, cursorPos, cursor)
  local cursorPosTemp = self.cursorPosTemp
  local offsetX = self.cursorPivotOffset.x
  local offsetY = self.cursorPivotOffset.y
  cursorPosTemp[1] = cursorPos.x + offsetX
  cursorPosTemp[2] = cursorPos.y + offsetY
end

function MousePointerLogic.applyCursorRenderer(self)
  local cursor = self.cursorEntity
  if not ___MOD.isvalid(cursor) or cursor.SpriteGUIRendererComponent == nil or cursor.UITransformComponent == nil then
    return
  end
  self:cacheDefaultCursorRUID()
  self:cacheCursorAnimations()
  cursor:SetEnable(true)
  cursor:SetVisible(true)
  cursor.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  cursor.UITransformComponent.RectSize = ___MOD.FastVector2(48, 56)
  cursor.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
  cursor.SpriteGUIRendererComponent:SetAlpha(1)
  cursor.SpriteGUIRendererComponent.RaycastTarget = false
  if cursor.AnimationSpriteComponent == nil then
    cursor:AddComponent(___MOD.AnimationSpriteComponent)
  end
  if cursor.AnimationSpriteComponent ~= nil then
    cursor.AnimationSpriteComponent.loop = true
    cursor.AnimationSpriteComponent.disappearWhenAnimationOnceEnd = false
    cursor.AnimationSpriteComponent:changeScale(2)
  end
  self:applyCursorState("default")
end

function MousePointerLogic.applyCursorState(self, stateName)
  local cursor = self.cursorEntity
  if not ___MOD.isvalid(cursor) or cursor.UITransformComponent == nil or cursor.AnimationSpriteComponent == nil then
    return
  end
  if self.currentCursorState == stateName then
    return
  end
  self:cacheCursorAnimations()
  local state = self._T.cursorAnimations and self._T.cursorAnimations[stateName] or nil
  if state == nil then
    return
  end
  if stateName == "pressed" then
    cursor.UITransformComponent.RectSize = ___MOD.FastVector2(50, 46)
  else
    cursor.UITransformComponent.RectSize = ___MOD.FastVector2(48, 56)
  end
  cursor.AnimationSpriteComponent:setChildPosition(___MOD.FastVector3.zero:Clone())
  cursor.AnimationSpriteComponent:setWzSprite(state, false)
  cursor.AnimationSpriteComponent:SetPaused(false)
  self.currentCursorState = stateName
  self:moveCursorToTopInParent()
end

function MousePointerLogic.buildSingleFrameCursorState(self, ruid)
  if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    return nil
  end
  local frame = ___MOD.SpriteFrame()
  frame.RUID = ruid
  frame.spriteSize = ___MOD.FastVector2(24, 28)
  frame.originUI = ___MOD.FastVector2(0, 0)
  frame.originUIFlip = ___MOD.FastVector2(0, 0)
  frame.delay = 1000
  return {
    anim = {frame},
    RUIDs = {ruid},
    asynced = true,
    ["repeat"] = 0,
    zigzag = false
  }
end

function MousePointerLogic.cacheCursorAnimations(self)
  if self._T.cursorAnimations ~= nil then
    return
  end
  local basic = ___MOD._WzUtils:ParseGenericWzCollectionWZ("UI_wz", "Basic.img")
  if ___MOD.type(basic) ~= "table" then
    return
  end
  local cursorRoot = ___MOD._WzUtils:getWzTbl(basic, "Cursor")
  if ___MOD.type(cursorRoot) ~= "table" then
    return
  end
  self._T.cursorAnimations = {
    default = ___MOD._WzUtils:parseAnimation(___MOD._WzUtils:getWzTbl(cursorRoot, "0")),
    hover = ___MOD._WzUtils:parseAnimation(___MOD._WzUtils:getWzTbl(cursorRoot, "1")),
    scrollbar_h = ___MOD._WzUtils:parseAnimation(___MOD._WzUtils:getWzTbl(cursorRoot, "8")),
    scrollbar_v = ___MOD._WzUtils:parseAnimation(___MOD._WzUtils:getWzTbl(cursorRoot, "7")),
    tooltip = ___MOD._WzUtils:parseAnimation(___MOD._WzUtils:getWzTbl(cursorRoot, "5")),
    pick = ___MOD._WzUtils:parseAnimation(___MOD._WzUtils:getWzTbl(cursorRoot, "11")),
    pressed = ___MOD._WzUtils:parseAnimation(___MOD._WzUtils:getWzTbl(cursorRoot, "12"))
  }
end

function MousePointerLogic.cacheDefaultCursorRUID(self)
  if ___MOD._UtilLogic:IsNilorEmptyString(self.defaultCursorRUID) then
    local ruid = ___MOD.__RUIDManager:get("UI.Basic.Cursor.0.0")
    if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
      self.defaultCursorRUID = ruid
    end
  end
end

function MousePointerLogic.cachePressedCursorRUID(self)
  if ___MOD._UtilLogic:IsNilorEmptyString(self.pressedCursorRUID) then
    local ruid = ___MOD.__RUIDManager:get("UI.Basic.Cursor.12.0")
    if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
      self.pressedCursorRUID = ruid
    end
  end
end

function MousePointerLogic.clearCursorOverrideRUID(self)
  if ___MOD._UtilLogic:IsNilorEmptyString(self.overrideCursorRUID) and self._T.cursorAnimations ~= nil and self._T.cursorAnimations.override == nil then
    return
  end
  self.overrideCursorRUID = ""
  if self._T.cursorAnimations ~= nil then
    self._T.cursorAnimations.override = nil
  end
  if self.currentCursorState == "override" then
    self.currentCursorState = ""
  end
  self:refreshCursorState()
end

function MousePointerLogic.clearInvalidHoveredButton(self)
  if self.hoveredButton == nil then
    return false
  end
  if not ___MOD.isvalid(self.hoveredButton) then
    self.hoveredButton = nil
    self.hoveredButtonCursorState = ""
    return true
  end
  if not self.hoveredButton.EnabledInHierarchy or not self.hoveredButton.VisibleInHierarchy then
    self.hoveredButton = nil
    self.hoveredButtonCursorState = ""
    return true
  end
  if not self:isCursorInsideUIEntity(self.hoveredButton) then
    self.hoveredButton = nil
    self.hoveredButtonCursorState = ""
    return true
  end
  return false
end

function MousePointerLogic.clearInvalidHoveredNpc(self)
  if self.hoveredNpc == nil then
    return false
  end
  if not ___MOD.isvalid(self.hoveredNpc) or not self.hoveredNpc.Visible then
    self.hoveredNpc = nil
    return true
  end
  return false
end

function MousePointerLogic.connectHoverCleanupTimer(self)
  self:disconnectHoverCleanupTimer()
  self.hoverCleanupTimer = ___MOD._TimerService:SetTimerRepeat(self.handleHoverCleanupTimer, 0.3)
end

function MousePointerLogic.connectMouseClickEvents(self)
  self:disconnectMouseClickEvents()
  self.mouseDownEvent = ___MOD._InputService:ConnectEvent(___MOD.KeyDownEvent, self.onMousePointerKeyDown)
  self.mouseUpEvent = ___MOD._InputService:ConnectEvent(___MOD.KeyReleaseEvent, self.onMousePointerKeyUp)
end

function MousePointerLogic.connectMouseMoveEvent(self)
  self:disconnectMouseMoveEvent()
  self.mouseMoveEvent = ___MOD._InputService:ConnectEvent(___MOD.MouseMoveEvent, self.updateMousePointerPosition)
end

function MousePointerLogic.disconnectHoverCleanupTimer(self)
  if self.hoverCleanupTimer ~= nil then
    ___MOD._TimerService:ClearTimer(self.hoverCleanupTimer)
    self.hoverCleanupTimer = nil
  end
end

function MousePointerLogic.disconnectMouseClickEvents(self)
  if self.mouseDownEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.KeyDownEvent, self.mouseDownEvent)
    self.mouseDownEvent = nil
  end
  if self.mouseUpEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.KeyReleaseEvent, self.mouseUpEvent)
    self.mouseUpEvent = nil
  end
end

function MousePointerLogic.disconnectMouseMoveEvent(self)
  if self.mouseMoveEvent ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.MouseMoveEvent, self.mouseMoveEvent)
    self.mouseMoveEvent = nil
  end
end

function MousePointerLogic.ensureCursorEntity(self)
  if ___MOD.Environment:IsMobilePlatform() then
    return
  end
  if ___MOD.isvalid(self.cursorEntity) then
    if self.cursorEntity.EnabledInHierarchy then
      return
    end
    self.cursorEntity = nil
  end
  local pointerParent = self:getMousePointerParent()
  if not ___MOD.isvalid(pointerParent) then
    return
  end
  local cursor = pointerParent:GetChildByName("__MousePointer")
  if not ___MOD.isvalid(cursor) then
    cursor = ___MOD._SpawnService:SpawnByModelId(self.cursorModelId, "__MousePointer", ___MOD.FastVector3.zero:Clone(), pointerParent)
  end
  if ___MOD.isvalid(cursor) and not cursor.EnabledInHierarchy then
    local fallbackParent = self:getMousePointerFallbackParent()
    if ___MOD.isvalid(fallbackParent) and fallbackParent ~= pointerParent then
      local fallbackCursor = fallbackParent:GetChildByName("__MousePointer")
      if not ___MOD.isvalid(fallbackCursor) then
        fallbackCursor = ___MOD._SpawnService:SpawnByModelId(self.cursorModelId, "__MousePointer", ___MOD.FastVector3.zero:Clone(), fallbackParent)
      end
      if ___MOD.isvalid(fallbackCursor) then
        cursor = fallbackCursor
      end
    end
  end
  if not ___MOD.isvalid(cursor) then
    return
  end
  self.cursorEntity = cursor
  self.currentCursorState = ""
  self:applyCursorRenderer()
  self:moveCursorToTopInParent()
end

function MousePointerLogic.getDefaultCursorRUID(self)
  self:cacheDefaultCursorRUID()
  if ___MOD._UtilLogic:IsNilorEmptyString(self.defaultCursorRUID) then
    local ruid = ___MOD.__RUIDManager:get("UI.Basic.Cursor.0.0")
    if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
      self.defaultCursorRUID = ruid
    end
  end
  return self.defaultCursorRUID
end

function MousePointerLogic.getEmptySpriteTemplate(self)
  local emptySprite = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")
  if ___MOD.isvalid(emptySprite) then
    return emptySprite
  end
  return nil
end

function MousePointerLogic.getMousePointerFallbackParent(self)
  local parent = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
  if ___MOD.isvalid(parent) then
    return parent
  end
  return ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
end

function MousePointerLogic.getMousePointerParent(self)
  local parent = ___MOD._EntityService:GetEntityByPath("/ui/TopLayerGroup")
  if ___MOD.isvalid(parent) then
    return parent
  end
  parent = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
  if ___MOD.isvalid(parent) then
    return parent
  end
  return ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
end

function MousePointerLogic.getPressedCursorRUID(self)
  self:cachePressedCursorRUID()
  if ___MOD._UtilLogic:IsNilorEmptyString(self.pressedCursorRUID) then
    local ruid = ___MOD.__RUIDManager:get("UI.Basic.Cursor.12.0")
    if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
      self.pressedCursorRUID = ruid
    end
  end
  return self.pressedCursorRUID
end

function MousePointerLogic.handleHoverCleanupTimer(self)
  if self:clearInvalidHoveredButton() then
    self:refreshCursorState()
  end
end

function MousePointerLogic.initialize(self)
  self:refreshPublishedCursor()
  if ___MOD.Environment:IsPublishedPlay() then
    ___MOD._InputService:SetCursor("ba3aeb3a4bef41a3825417770daa03b2", ___MOD.FastVector2.zero:Clone())
    ___MOD._InputService:SetCursorVisible(false)
  end
  local isMobile = ___MOD.Environment:IsMobilePlatform()
  if not isMobile then
    self:cacheDefaultCursorRUID()
    self:cachePressedCursorRUID()
    self:cacheCursorAnimations()
    self:ensureCursorEntity()
  end
  self:connectMouseClickEvents()
  if not isMobile then
    self:connectHoverCleanupTimer()
    self:updateMousePointerPosition()
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  self.nextHoveredNpcUpdateTime = now + 0.1
  self.nextPublishedCursorRefreshTime = now + 5.0
  self.initialized = true
end

function MousePointerLogic.isCursorInsideUIEntity(self, target)
  if not ___MOD.isvalid(target) or not ___MOD.isvalid(target.UITransformComponent) then
    return false
  end
  if not target.EnabledInHierarchy or not target.VisibleInHierarchy then
    return false
  end
  local tr = target.UITransformComponent
  local uiMode = tr.UIMode
  if uiMode ~= nil and ___MOD.tostring(uiMode) == "World" then
    return false
  end
  local size = tr.RectSize
  if size == nil then
    return false
  end
  local cursorPos = ___MOD._InputService:GetCursorPosition()
  local localPos = ___MOD._UILogic:ScreenToLocalUIPosition(cursorPos, tr)
  local pivot = tr.Pivot or ___MOD.FastVector2(0.5, 0.5)
  local width = size.x or 0
  local height = size.y or 0
  local left = -width * pivot.x
  local right = left + width
  local bottom = -height * pivot.y
  local top = bottom + height
  return left <= localPos.x and right >= localPos.x and bottom <= localPos.y and top >= localPos.y
end

function MousePointerLogic.isItemSkillTooltipCursorActive(self)
  return 0 < (___MOD.tonumber(self.activeItemSkillTooltipCount) or 0)
end

function MousePointerLogic.moveCursorToTopInParent(self)
  local cursor = self.cursorEntity
  if not ___MOD.isvalid(cursor) or not ___MOD.isvalid(cursor.Parent) then
    return
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if now < (___MOD.tonumber(self._T.nextMousePointerTopOrderTime) or 0) then
    return
  end
  self._T.nextMousePointerTopOrderTime = now + 0.1
  local parent = cursor.Parent
  local tempParent = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
  if tempParent == parent then
    tempParent = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  end
  if ___MOD.isvalid(tempParent) and tempParent ~= parent then
    cursor:AttachTo(tempParent)
    cursor:AttachTo(parent)
  end
end

function MousePointerLogic.OnEndPlay(self)
  self:disconnectHoverCleanupTimer()
  self:disconnectMouseClickEvents()
end

function MousePointerLogic.onItemSkillTooltipHidden(self)
  local count = ___MOD.tonumber(self.activeItemSkillTooltipCount) or 0
  if 0 < count then
    self.activeItemSkillTooltipCount = count - 1
  else
    self.activeItemSkillTooltipCount = 0
  end
  self:refreshCursorState()
end

function MousePointerLogic.onItemSkillTooltipShown(self)
  self.activeItemSkillTooltipCount = (___MOD.tonumber(self.activeItemSkillTooltipCount) or 0) + 1
  self:refreshCursorState()
end

function MousePointerLogic.onMousePointerKeyDown(self, event)
  if event.key ~= ___MOD.KeyboardKey.Mouse0 then
    return
  end
  if ___MOD.Environment:IsMobilePlatform() then
    self._T.mobileMouseNpcCandidate = nil
    if not ___MOD._InputService:IsPointerOverUI() then
      self:updateHoveredNpc()
      if ___MOD.isvalid(self.hoveredNpc) and ___MOD.isvalid(self.hoveredNpc.ExtendNpcComponent) then
        self._T.mobileMouseNpcCandidate = self.hoveredNpc
      end
    end
  end
  local cursor = self.cursorEntity
  if not ___MOD.isvalid(cursor) or cursor.UITransformComponent == nil then
    return
  end
  self.isMouseLeftDown = true
  self:refreshCursorState()
end

function MousePointerLogic.onMousePointerKeyUp(self, event)
  if event.key ~= ___MOD.KeyboardKey.Mouse0 then
    return
  end
  if ___MOD.Environment:IsMobilePlatform() then
    local npcCandidate = self._T.mobileMouseNpcCandidate
    self._T.mobileMouseNpcCandidate = nil
    self:tryTouchHoveredSummonTest()
    if ___MOD._InputService:IsPointerOverUI() then
      return
    end
    if not (___MOD.isvalid(npcCandidate) and npcCandidate.Visible) or not ___MOD.isvalid(npcCandidate.ExtendNpcComponent) then
      return
    end
    if ___MOD.isvalid(self.hoveredNpc) and self.hoveredNpc ~= npcCandidate then
      return
    end
    npcCandidate.ExtendNpcComponent:onTouch()
    return
  end
  local cursor = self.cursorEntity
  if not ___MOD.isvalid(cursor) or cursor.UITransformComponent == nil then
    return
  end
  self.isMouseLeftDown = false
  self:tryTouchHoveredSummonTest()
  self:refreshCursorState()
end

function MousePointerLogic.onUIButtonHover(self, button, cursorState)
  if not ___MOD.isvalid(button) then
    return
  end
  self.hoveredButton = button
  self.hoveredButtonCursorState = cursorState or ""
  self:refreshCursorState()
end

function MousePointerLogic.onUIButtonHoverExit(self, button)
  local cursor = self.cursorEntity
  if not ___MOD.isvalid(cursor) or cursor.UITransformComponent == nil then
    return
  end
  if self.hoveredButton == button then
    self.hoveredButton = nil
    self.hoveredButtonCursorState = ""
  end
  self:refreshCursorState()
end

function MousePointerLogic.onUIElementPicked(self)
  self.isUIElementPicked = true
  self:refreshCursorState()
end

function MousePointerLogic.onUIElementReleased(self)
  self.isUIElementPicked = false
  self:refreshCursorState()
end

function MousePointerLogic.OnUpdate(self, delta)
  if self.initialized then
    if not ___MOD.Environment:IsMobilePlatform() then
      self:updateMousePointerPosition()
    end
    local now = ___MOD._UtilLogic.ElapsedSeconds
    if now >= self.nextHoveredNpcUpdateTime then
      self.nextHoveredNpcUpdateTime = now + 0.1
      self:updateHoveredNpc()
    end
    if now >= self.nextPublishedCursorRefreshTime then
      self.nextPublishedCursorRefreshTime = now + 5.0
      self:refreshPublishedCursor()
    end
  end
end

function MousePointerLogic.refreshCursorState(self)
  self:clearInvalidHoveredNpc()
  if not ___MOD._UtilLogic:IsNilorEmptyString(self.overrideCursorRUID) then
    self:applyCursorState("override")
    return
  end
  if self:isItemSkillTooltipCursorActive() then
    self:applyCursorState("tooltip")
    return
  end
  if self.isUIElementPicked then
    self:applyCursorState("pick")
    return
  end
  if self.isMouseLeftDown then
    self:applyCursorState("pressed")
    return
  end
  if ___MOD.isvalid(self.hoveredButton) then
    local hoverState = ___MOD._UtilLogic:IsNilorEmptyString(self.hoveredButtonCursorState) and "hover" or self.hoveredButtonCursorState
    self:applyCursorState(hoverState)
    return
  end
  if ___MOD.isvalid(self.hoveredNpc) then
    self:applyCursorState("hover")
    return
  end
  self:applyCursorState("default")
end

function MousePointerLogic.refreshPublishedCursor(self)
  if ___MOD.Environment:IsPublishedPlay() then
    ___MOD._InputService:SetCursor("ba3aeb3a4bef41a3825417770daa03b2", ___MOD.FastVector2.zero:Clone())
    ___MOD._InputService:SetCursorVisible(false)
  end
end

function MousePointerLogic.setCursorOverrideRUID(self, ruid)
  if ___MOD.Environment:IsMobilePlatform() then
    return
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    self:clearCursorOverrideRUID()
    return
  end
  self:cacheCursorAnimations()
  if self._T.cursorAnimations == nil then
    return
  end
  self.overrideCursorRUID = ruid
  self._T.cursorAnimations.override = self:buildSingleFrameCursorState(ruid)
  self.currentCursorState = ""
  self:refreshCursorState()
end

function MousePointerLogic.tryTouchHoveredSummonTest(self)
  local ent = self.hoveredNpc
  if not ___MOD.isvalid(ent) or not ___MOD.isvalid(ent.SummonComponent) then
    return
  end
  if ent.SummonComponent.nSkillID % 10000 ~= 1013 then
    return
  end
  ent.SummonComponent:onSummonTestTouch()
end

function MousePointerLogic.updateHoveredNpc(self)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) then
    if self:clearInvalidHoveredNpc() then
      self:refreshCursorState()
    end
    return
  end
  if ___MOD._InputService:IsPointerOverUI() then
    if self.hoveredNpc ~= nil then
      self.hoveredNpc = nil
      self:refreshCursorState()
    end
    return
  end
  local simulator = ___MOD._CollisionService:GetSimulator(localPlayer)
  if simulator == nil then
    if self:clearInvalidHoveredNpc() then
      self:refreshCursorState()
    end
    return
  end
  self._T.npcHoverOverlap = self._T.npcHoverOverlap or {}
  local overlap = self._T.npcHoverOverlap
  ___MOD.table.clear(overlap)
  local cursorWorldPos = ___MOD._UIUtilLogic:getCursorWorldPosition()
  local circle = ___MOD.CircleShape(cursorWorldPos, 0.02)
  local count = simulator:OverlapAllFast("NPC_Dc", circle, overlap)
  local foundNpc
  if 0 < count then
    for i = 1, #overlap do
      local trigger = overlap[i]
      local ent = trigger ~= nil and trigger.Entity or nil
      if ent.Visible and (___MOD.isvalid(ent) and ___MOD.isvalid(ent.ExtendNpcComponent) or ___MOD.isvalid(ent) and ___MOD.isvalid(ent.SummonComponent) and ent.SummonComponent.nSkillID % 10000 == 1013) then
        foundNpc = ent
        break
      end
    end
  end
  if self.hoveredNpc ~= foundNpc then
    self.hoveredNpc = foundNpc
    self:refreshCursorState()
  end
end

function MousePointerLogic.updateMousePointerPosition(self)
  if ___MOD.Environment:IsMobilePlatform() then
    return
  end
  self:ensureCursorEntity()
  local cursor = self.cursorEntity
  if not ___MOD.isvalid(cursor) or cursor.UITransformComponent == nil then
    return
  end
  local cursorPos = ___MOD._UIUtilLogic:getCursorUIPosition()
  local cursorPosTemp = self.cursorPosTemp
  if cursorPos.x ~= cursorPosTemp[1] or cursorPos.y ~= cursorPosTemp[2] then
    self:applyCursorPositionOffset(cursorPos, cursor)
    cursor.UITransformComponent.anchoredPosition = cursorPosTemp
    self:moveCursorToTopInParent()
  end
end
