

function UIMobileJoystickLogic.clearMobileNpcTouchCandidate(self)
  self._T.mobileNpcTouchId = nil
  self._T.mobileNpcTouchStartX = nil
  self._T.mobileNpcTouchStartY = nil
  self._T.mobileNpcTouchStartTime = nil
  self._T.mobileNpcTouchCandidateObjID = nil
end

function UIMobileJoystickLogic.connectMobileNpcTouchCorrection(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  if self.mobileNpcScreenTouchHandler == nil then
    self.mobileNpcScreenTouchHandler = ___MOD._InputService:ConnectEvent(___MOD.ScreenTouchEvent, self.onMobileNpcScreenTouch)
  end
  if self.mobileNpcScreenTouchReleaseHandler == nil then
    self.mobileNpcScreenTouchReleaseHandler = ___MOD._InputService:ConnectEvent(___MOD.ScreenTouchReleaseEvent, self.onMobileNpcScreenTouchRelease)
  end
end

function UIMobileJoystickLogic.findMobileNpcAtScreenPoint(self, screenPoint)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or not ___MOD.isvalid(user.CurrentMap) then
    return nil
  end
  local simulator = ___MOD._CollisionService:GetSimulator(user)
  if simulator == nil then
    return nil
  end
  self._T.mobileNpcTouchOverlap = self._T.mobileNpcTouchOverlap or {}
  local overlap = self._T.mobileNpcTouchOverlap
  ___MOD.table.clear(overlap)
  local worldPoint = ___MOD._UILogic:ScreenToWorldPosition(screenPoint)
  local radius = ___MOD.math.max(0.01, ___MOD.tonumber(self.mobileNpcTapWorldRadius) or 0.12)
  local circle = ___MOD.CircleShape(worldPoint, radius)
  local count = simulator:OverlapAllFast("NPC_Dc", circle, overlap)
  if count <= 0 then
    return nil
  end
  local nearestNpc
  local nearestDistance = ___MOD.math.huge
  for i = 1, #overlap do
    local trigger = overlap[i]
    local entity = trigger ~= nil and trigger.Entity or nil
    local npc = ___MOD.isvalid(entity) and entity.ExtendNpcComponent or nil
    if ___MOD.isvalid(npc) and ___MOD.isvalid(entity) and entity.Visible and trigger.EnableInHierarchy and not ___MOD._UtilLogic:IsNilorEmptyString(npc.objID) then
      local npcPos = entity.TransformComponent:WorldPositionAsFastVector3()
      local dx = worldPoint.x - npcPos.x
      local dy = worldPoint.y - npcPos.y
      local distance = dx * dx + dy * dy
      if nearestDistance > distance then
        nearestNpc = entity
        nearestDistance = distance
      end
    end
  end
  return nearestNpc
end

function UIMobileJoystickLogic.Initialize(self)
  self:setMobileJoystickVisible(true)
end

function UIMobileJoystickLogic.isMobileNpcTapBlockedByUI(self, screenPoint)
  if self:isScreenPointBlockedByWindowUI(screenPoint) then
    return true
  end
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) then
    return false
  end
  if user.PlayerSettingsComponent ~= nil and user.PlayerSettingsComponent:isInShopUI(user) then
    return true
  end
  if ___MOD._TradingLogic ~= nil and ___MOD._TradingLogic.tradingRoom ~= nil then
    return true
  end
  return false
end

function UIMobileJoystickLogic.isScreenPointBlockedByMobileHudPanel(self, screenPoint, path)
  local panel = ___MOD._EntityService:GetEntityByPath(path)
  if self:isScreenPointInsideUIEntity(screenPoint, panel) then
    return true
  end
  return false
end

function UIMobileJoystickLogic.isScreenPointBlockedByWindowUI(self, screenPoint)
  if self:isScreenPointBlockedByMobileHudPanel(screenPoint, "/ui/UIGroup/MobileChat/MobileChatBoard") then
    return true
  end
  if self:isScreenPointBlockedByMobileHudPanel(screenPoint, "/ui/UIGroup/MobileKeyConfig") then
    return true
  end
  if self:isScreenPointBlockedByMobileHudPanel(screenPoint, "/ui/UIGroup/MobileMenu/MobileMenuBg") then
    return true
  end
  for i = #___MOD._UIWindowLogic.UIWindow, 1, -1 do
    local window = ___MOD._EntityService:GetEntity(___MOD._UIWindowLogic.UIWindow[i])
    if self:isScreenPointInsideUIEntity(screenPoint, window) then
      return true
    end
  end
  for _, ui in ___MOD.pairs(___MOD._UIWindowLogic.UI) do
    if self:isScreenPointInsideUIEntity(screenPoint, ui) then
      return true
    end
  end
  for _, notice in ___MOD.pairs(___MOD._UINotice.noitceUIList) do
    if self:isScreenPointInsideUIEntity(screenPoint, notice) then
      return true
    end
  end
  return false
end

function UIMobileJoystickLogic.isScreenPointInsideMobileJoystick(self, screenPoint)
  if not ___MOD.isvalid(self._T.mobileJoystick) then
    self:prepareMobileJoystickClient()
  end
  if not ___MOD.isvalid(self._T.mobileJoystick) or self._T.mobileJoystick.UITransformComponent == nil then
    return false
  end
  local transform = self._T.mobileJoystick.UITransformComponent
  local rectSize = transform.RectSize
  if rectSize == nil then
    return false
  end
  local localPos = ___MOD._UILogic:ScreenToLocalUIPosition(screenPoint, transform)
  local halfX = ___MOD.math.max(0, (___MOD.tonumber(rectSize.x) or 0) * ___MOD.math.max(0, ___MOD.tonumber(self.mobileNpcTapJoystickRangeScaleX) or 0))
  local halfY = ___MOD.math.max(0, (___MOD.tonumber(rectSize.y) or 0) * ___MOD.math.max(0, ___MOD.tonumber(self.mobileNpcTapJoystickRangeScaleY) or 0))
  return halfX >= ___MOD.math.abs(localPos.x) and halfY >= ___MOD.math.abs(localPos.y)
end

function UIMobileJoystickLogic.isScreenPointInsideUIEntity(self, screenPoint, entity)
  if not ___MOD.isvalid(entity) or not entity.EnabledInHierarchy then
    return false
  end
  local transform = entity.UITransformComponent
  if transform ~= nil and transform.RectSize ~= nil then
    local localPos = ___MOD._UILogic:ScreenToLocalUIPosition(screenPoint, transform)
    local rectSize = transform.RectSize
    local pivot = transform.Pivot or ___MOD.FastVector2(0.5, 0.5)
    local minX = -rectSize.x * pivot.x
    local maxX = rectSize.x * (1 - pivot.x)
    local minY = -rectSize.y * pivot.y
    local maxY = rectSize.y * (1 - pivot.y)
    if minX <= localPos.x and maxX >= localPos.x and minY <= localPos.y and maxY >= localPos.y then
      return true
    end
  end
  if entity.Children ~= nil then
    for _, child in ___MOD.pairs(entity.Children) do
      if self:isScreenPointInsideUIEntity(screenPoint, child) then
        return true
      end
    end
  end
  return false
end

function UIMobileJoystickLogic.OnEndPlay(self)
  if self.mobileNpcScreenTouchHandler ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.ScreenTouchEvent, self.mobileNpcScreenTouchHandler)
    self.mobileNpcScreenTouchHandler = nil
  end
  if self.mobileNpcScreenTouchReleaseHandler ~= nil then
    ___MOD._InputService:DisconnectEvent(___MOD.ScreenTouchReleaseEvent, self.mobileNpcScreenTouchReleaseHandler)
    self.mobileNpcScreenTouchReleaseHandler = nil
  end
end

function UIMobileJoystickLogic.onMobileNpcScreenTouch(self, event)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  self:clearMobileNpcTouchCandidate()
  if not self:isScreenPointInsideMobileJoystick(event.TouchPoint) then
    return
  end
  if self:isMobileNpcTapBlockedByUI(event.TouchPoint) then
    return
  end
  local npcEntity = self:findMobileNpcAtScreenPoint(event.TouchPoint)
  if not ___MOD.isvalid(npcEntity) or npcEntity.ExtendNpcComponent == nil then
    return
  end
  self._T.mobileNpcTouchId = event.TouchId
  self._T.mobileNpcTouchStartX = event.TouchPoint.x
  self._T.mobileNpcTouchStartY = event.TouchPoint.y
  self._T.mobileNpcTouchStartTime = ___MOD._UtilLogic.ElapsedSeconds
  self._T.mobileNpcTouchCandidateObjID = npcEntity.ExtendNpcComponent.objID
end

function UIMobileJoystickLogic.onMobileNpcScreenTouchRelease(self, event)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local touchId = self._T.mobileNpcTouchId
  local objID = self._T.mobileNpcTouchCandidateObjID
  if touchId == nil or objID == nil or touchId ~= event.TouchId then
    self:clearMobileNpcTouchCandidate()
    return
  end
  local startTime = ___MOD.tonumber(self._T.mobileNpcTouchStartTime) or 0
  local maxDuration = ___MOD.math.max(0.05, ___MOD.tonumber(self.mobileNpcTapMaxDuration) or 0.25)
  local elapsed = ___MOD._UtilLogic.ElapsedSeconds - startTime
  if maxDuration < elapsed then
    self:clearMobileNpcTouchCandidate()
    return
  end
  local startX = ___MOD.tonumber(self._T.mobileNpcTouchStartX) or event.TouchPoint.x
  local startY = ___MOD.tonumber(self._T.mobileNpcTouchStartY) or event.TouchPoint.y
  local dx = event.TouchPoint.x - startX
  local dy = event.TouchPoint.y - startY
  local maxMove = ___MOD.math.max(1, ___MOD.tonumber(self.mobileNpcTapMaxMovePixel) or 25)
  if dx * dx + dy * dy > maxMove * maxMove then
    self:clearMobileNpcTouchCandidate()
    return
  end
  if self:isMobileNpcTapBlockedByUI(event.TouchPoint) then
    self:clearMobileNpcTouchCandidate()
    return
  end
  self:clearMobileNpcTouchCandidate()
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) and user.QuestComponent ~= nil then
    user.QuestComponent:runScriptByClickNpc(objID)
  end
end

function UIMobileJoystickLogic.prepareMobileJoystickClient(self)
  self._T.mobileJoystick = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UIJoystick")
end

function UIMobileJoystickLogic.raiseMobileJoystickBlockedUI(self)
  local mainNotice = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MainNotice")
  local mainQuest = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MainQuest")
  if ___MOD.isvalid(mainNotice) and mainNotice.UITransformComponent ~= nil then
    ___MOD._UILogic:SetSiblingIndex(mainNotice.UITransformComponent, 999)
  end
  if ___MOD.isvalid(mainQuest) and mainQuest.UITransformComponent ~= nil then
    ___MOD._UILogic:SetSiblingIndex(mainQuest.UITransformComponent, 999)
  end
end

function UIMobileJoystickLogic.setMobileJoystickVisible(self, visible)
  self:prepareMobileJoystickClient()
  if not ___MOD.isvalid(self._T.mobileJoystick) then
    return
  end
  local shouldShow = visible == true and ___MOD.Environment:IsMobilePlatform()
  local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  if shouldShow and ___MOD.isvalid(uiGroup) then
    uiGroup:SetEnable(true)
    uiGroup:SetVisible(true)
  end
  self._T.mobileJoystick:SetEnable(shouldShow)
  self._T.mobileJoystick:SetVisible(true)
  if shouldShow then
    self:raiseMobileJoystickBlockedUI()
    self:connectMobileNpcTouchCorrection()
  end
end
