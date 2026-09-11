

function ObserverUtilLogic.ApplyMobileGameplayUI(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  self:SetObserverPlatformUIEntity("/ui/UIGroup/StatusBar", false)
  self:SetObserverPlatformUIEntity("/ui/UIGroup/QuickSlot", false)
  self:SetObserverPlatformUIEntity("/ui/UIGroup/Chat", false)
  self:SetObserverPlatformUIEntity("/ui/UIGroup/MobileStatusBar", true)
  local mobileChat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  if ___MOD.isvalid(mobileChat) then
    if mobileChat.UIMobileChat ~= nil then
      mobileChat.UIMobileChat:setMobileChatBoardVisible(false)
    end
    self:SetObserverPlatformUIEntity("/ui/UIGroup/MobileChat", true)
  end
  local mobileShortcut = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileShortcutMenu")
  if ___MOD.isvalid(mobileShortcut) and mobileShortcut.UIMobileShortcutMenu ~= nil then
    mobileShortcut.UIMobileShortcutMenu:Initialize()
  end
  local mobileMenu = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileMenu")
  if ___MOD.isvalid(mobileMenu) and mobileMenu.UIMobileMenu ~= nil then
    mobileMenu.UIMobileMenu:Initialize()
  end
  local mobileKeyConfig = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileKeyConfig")
  if ___MOD.isvalid(mobileKeyConfig) and mobileKeyConfig.UIMobileKeyConfig ~= nil then
    mobileKeyConfig.UIMobileKeyConfig:Initialize()
  end
  local mobileQuickClose = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileQuickCloseBtn")
  if ___MOD.isvalid(mobileQuickClose) and mobileQuickClose.UIMobileQuickCloseButton ~= nil then
    mobileQuickClose.UIMobileQuickCloseButton:Initialize()
  end
  if ___MOD._MobileActionSlotLogic ~= nil then
    ___MOD._MobileActionSlotLogic:setMobileActionSlotsVisible(true)
    ___MOD._MobileActionSlotLogic:setMobileActionSlotToggleVisible(true)
  end
  if ___MOD._UIMobileJoystickLogic ~= nil then
    ___MOD._UIMobileJoystickLogic:setMobileJoystickVisible(true)
  end
  if ___MOD._UIMobileHudLayout ~= nil then
    ___MOD._UIMobileHudLayout:ApplyMobileHudLayoutDeferred()
  end
end

function ObserverUtilLogic.ApplyObservedCharacterStatSnapshot_Client(self, data)
  local player = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(player) and player.CharacterStatUIComponent ~= nil then
    player.CharacterStatUIComponent:applyObservedCharacterStatSnapshot(data)
  end
end

function ObserverUtilLogic.ApplyObservedQuickSlotSnapshot_Client(self, data)
  local player = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(player) and player.KeyConfigUIComponent ~= nil then
    player.KeyConfigUIComponent:applyObservedQuickSlotSnapshot(data)
  end
end

function ObserverUtilLogic.ApplyObserverCameraZoom(self)
  local zoomPercent = self.ObserverPreviousZoomRatio
  if self.ObserverViewActive then
    if ___MOD.Environment:IsMobilePlatform() then
      zoomPercent = self.ObserverZoomPercentMobile
    else
      zoomPercent = self.ObserverZoomPercentPC
    end
  end
  ___MOD._CameraService:ZoomTo(zoomPercent, self.ObserverZoomDuration)
end

function ObserverUtilLogic.ApplyObserverDesktopUI(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  if ___MOD._MobileActionSlotLogic ~= nil then
    ___MOD._MobileActionSlotLogic:stopAllMobileActionSlotPresses()
  end
  local mobilePaths = {
    "/ui/UIGroup/MobileStatusBar",
    "/ui/UIGroup/MobileChat",
    "/ui/UIGroup/MobileShortcutMenu",
    "/ui/UIGroup/MobileMenu",
    "/ui/UIGroup/MobileKeyConfig",
    "/ui/UIGroup/MobileQuickCloseBtn",
    "/ui/UIGroup/MobileActionSlots",
    "/ui/UIGroup/MobileActionSlotSetting",
    "/ui/UIGroup/UIJoystick"
  }
  for _, path in ___MOD.ipairs(mobilePaths) do
    self:SetObserverPlatformUIEntity(path, false)
  end
  local player = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(player) and player.UIStatusBar ~= nil then
    player.UIStatusBar:hideMobileExpTooltip()
  end
  if ___MOD.isvalid(player) and player.Player ~= nil and player.UIStatusBar ~= nil and not player.UIStatusBar.init then
    player.UIStatusBar:Initialize(player.Player.Name)
  end
  if ___MOD.isvalid(player) and player.UIStatusBar ~= nil then
    player.UIStatusBar:preparePCStatusBarEvents()
  end
  if ___MOD.isvalid(player) and player.KeyConfigUIComponent ~= nil and (player.KeyConfigUIComponent.quickSlotTable == nil or ___MOD.next(player.KeyConfigUIComponent.quickSlotTable) == nil) then
    player.KeyConfigUIComponent:initializeQuickSlotTable()
  end
  if ___MOD.isvalid(player) and player.ShortCutComponent ~= nil then
    player.ShortCutComponent:preparePCShortCut()
  end
  local gameMenu = ___MOD._EntityService:GetEntity("636a407f-147d-4f58-b238-94dd77900777")
  if ___MOD.isvalid(gameMenu) and gameMenu.GameMenuComponent ~= nil then
    gameMenu.GameMenuComponent:preparePCGameMenu()
  end
  self:SetObserverPlatformUIEntity("/ui/UIGroup/StatusBar", true)
  self:SetObserverPlatformUIEntity("/ui/UIGroup/QuickSlot", true)
  self:SetObserverPlatformUIEntity("/ui/UIGroup/Chat", true)
end

function ObserverUtilLogic.BuildObservedCharacterStatSnapshot_ServerOnly(self, user)

end

function ObserverUtilLogic.BuildObservedQuickSlotSnapshot_ServerOnly(self, user)

end

function ObserverUtilLogic.FormatObservedStat_ServerOnly(self, baseValue, addValue, tempValue)

end

function ObserverUtilLogic.GetFullAuto(self)
  return self.FullAuto
end

function ObserverUtilLogic.GetObservedMapName(self)
  local observedMapName = ___MOD._ObserverService:GetObservedMapName(___MOD._UserService.LocalPlayer.PlayerComponent.ProfileCode)
  if observedMapName == nil then
    return nil
  end
  local observedMap = ___MOD._EntityService:GetEntityByPath("/maps/" .. observedMapName)
  if observedMap == nil then
    return nil
  end
  return observedMapName
end

function ObserverUtilLogic.GetObservedTempStatValue_ServerOnly(self, user, flag)

end

function ObserverUtilLogic.GetObservedUserInfo(self)
  local observedUserProfileCode = ___MOD._ObserverService:GetObservedUserProfileCode(___MOD._UserService.LocalPlayer.PlayerComponent.ProfileCode)
  ___MOD.log(observedUserProfileCode)
  if observedUserProfileCode == nil or observedUserProfileCode == "" then
    return nil
  end
  local observedUser = ___MOD._UserService:GetUserByProfileCode(observedUserProfileCode)
  local observedUserEntity = ___MOD._UserService:GetUserEntityByUserId(observedUser.UserId)
  ___MOD.log(observedUserEntity.CurrentMap.Name)
  if observedUserEntity.CurrentMap.Name == nil then
    return nil
  end
  local observedUserInfo = ___MOD.ObservedUserInfo()
  observedUserInfo.UserId = observedUser.UserId
  observedUserInfo.ProfileCode = observedUser.ProfileCode
  observedUserInfo.CurrentMapName = observedUserEntity.CurrentMap.Name
  return observedUserInfo
end

function ObserverUtilLogic.GetObserverAdminIds(self)

end

function ObserverUtilLogic.GetObserverUsersId(self, observedUserId)

end

function ObserverUtilLogic.GetObserverUsersIdByMapName(self, mapName)

end

function ObserverUtilLogic.GetUserIdsByMapNameWithObservers(self, mapName)

end

function ObserverUtilLogic.HandleKeyHoldEvent(self, event)
  if event.key == ___MOD.KeyboardKey.LeftArrow then
    self:MoveCamera(___MOD._DirectionEunm.Left)
  elseif event.key == ___MOD.KeyboardKey.RightArrow then
    self:MoveCamera(___MOD._DirectionEunm.Right)
  elseif event.key == ___MOD.KeyboardKey.UpArrow then
    self:MoveCamera(___MOD._DirectionEunm.Up)
  elseif event.key == ___MOD.KeyboardKey.DownArrow then
    self:MoveCamera(___MOD._DirectionEunm.Down)
  end
end

function ObserverUtilLogic.HandleObserveUserWorldRequestResult_ServerOnly(self, result, t, observedUserProfileCode, observerUserId)

end

function ObserverUtilLogic.InitializeCamSetting(self)
  local cam = ___MOD._ObserverService:GetObserverCamera()
  if cam == nil then
    return
  end
  local observedMap = ___MOD._ObserverService:GetObservedMapName(___MOD._UserService.LocalPlayer.PlayerComponent.ProfileCode)
  local map = ___MOD._EntityService:GetEntityByPath("/maps/" .. observedMap)
  ___MOD.log(map)
  local lb, rt = map.MapComponent:GetBound()
  cam.CameraComponent.UseCustomBound = true
  cam.CameraComponent.LeftBottom = lb
  cam.CameraComponent.RightTop = rt
end

function ObserverUtilLogic.IsAdmin(self, userId)

end

function ObserverUtilLogic.IsObserverDesktopUIActive(self)
  return ___MOD.Environment:IsMobilePlatform() and self.ObserverViewActive
end

function ObserverUtilLogic.MoveCamera(self, dir)
  if ___MOD.Environment:IsMakerPlay() then
    return
  end
  local cam = ___MOD._ObserverService:GetObserverCamera()
  if cam == nil then
    return
  end
  if dir == ___MOD._DirectionEunm.Left then
    cam.TransformComponent:Translate(-0.05, 0)
    return
  elseif dir == ___MOD._DirectionEunm.Right then
    cam.TransformComponent:Translate(0.05, 0)
    return
  elseif dir == ___MOD._DirectionEunm.Up then
    cam.TransformComponent:Translate(0, 0.05)
    return
  elseif dir == ___MOD._DirectionEunm.Down then
    cam.TransformComponent:Translate(0, -0.05)
    return
  end
end

function ObserverUtilLogic.ObserveMap(self, mapName, observerUserProfileCode)
  self:ObserveMap_Server(mapName, observerUserProfileCode)
end

function ObserverUtilLogic.ObserveMap_Server(self, mapName, observerUserProfileCode, senderUserId)

end

function ObserverUtilLogic.ObserveMap_ServerOnly(self, mapName, observerUserProfileCode)

end

function ObserverUtilLogic.ObserveUser(self, observedUserProfileCode, observerUserProfileCode)
  self:ObserveUser_Server(observedUserProfileCode, observerUserProfileCode)
end

function ObserverUtilLogic.ObserveUser_Server(self, observedUserProfileCode, observerUserProfileCode, senderUserId)

end

function ObserverUtilLogic.ObserveUser_ServerOnly(self, observedUserProfileCode, observerUserProfileCode)

end

function ObserverUtilLogic.ObserveUserOrWarp_ServerOnly(self, observedUserProfileCode, observerUserProfileCode, observerUserId)

end

function ObserverUtilLogic.OnBeginPlay(self)

end

function ObserverUtilLogic.OnSyncFullAuto(self, isFullAuto)
  self.FullAuto = isFullAuto
end

function ObserverUtilLogic.OnSyncStopObserve(self)
  if self.ObserverUtilsEntity == nil then
    self:SetActiveObserverUtilsEntity(nil, true)
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(localPlayer) and localPlayer.KeyConfigUIComponent ~= nil then
    localPlayer.KeyConfigUIComponent.observerQuickSlotProfileCode = ""
    localPlayer.KeyConfigUIComponent.pendingObserverQuickSlotProfileCode = ""
    localPlayer.KeyConfigUIComponent:restoreLocalQuickSlots()
  end
  self.ObserverUtilsEntity.ObserverUtilsComponent:OnSyncStopObserve()
end

function ObserverUtilLogic.OnUpdate(self, delta)
  if ___MOD._UtilLogic:IsNilorEmptyString(self.PendingAutoObserveUserKey) then
    return
  end
  if ___MOD._UtilLogic.ElapsedSeconds < self.PendingAutoObserveNextTime then
    return
  end
  self.PendingAutoObserveTryCount = self.PendingAutoObserveTryCount + 1
  if self:TryAutoObserveFromUI(self.PendingAutoObserveUserKey) then
    self.PendingAutoObserveUserKey = ""
    self.PendingAutoObserveTryCount = 0
    self.PendingAutoObserveNextTime = 0
    return
  end
  if self.PendingAutoObserveTryCount >= 20 then
    self.PendingAutoObserveUserKey = ""
    self.PendingAutoObserveTryCount = 0
    self.PendingAutoObserveNextTime = 0
    return
  end
  self.PendingAutoObserveNextTime = ___MOD._UtilLogic.ElapsedSeconds + 0.5
end

function ObserverUtilLogic.PrepareAutoObserveAfterWarp(self, observedUserKey)
  local key = ___MOD.tostring(observedUserKey or "")
  if ___MOD._UtilLogic:IsNilorEmptyString(key) then
    return
  end
  self.PendingAutoObserveUserKey = key
  self.PendingAutoObserveTryCount = 0
  self.PendingAutoObserveNextTime = ___MOD._UtilLogic.ElapsedSeconds + 1.5
end

function ObserverUtilLogic.RefreshObserverClientUI(self, isObserving)
  self:SetObserverViewState(isObserving)
  if ___MOD._UIMiniMap ~= nil then
    ___MOD._UIMiniMap:createMiniMap()
  end
  local player = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(player) and player.UIStatusBar ~= nil then
    player.UIStatusBar:refreshObserverStatusBar()
  end
  if ___MOD.isvalid(player) and player.CharacterStatUIComponent ~= nil then
    player.CharacterStatUIComponent:refreshObserverCharacterStat()
  end
  if ___MOD.isvalid(player) and player.KeyConfigUIComponent ~= nil then
    player.KeyConfigUIComponent:refreshObserverQuickSlot()
  end
  ___MOD._TimerService:SetTimerOnce(function()
    local localPlayer = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(localPlayer) and localPlayer.UIStatusBar ~= nil then
      localPlayer.UIStatusBar:refreshObserverStatusBar()
    end
    if ___MOD.isvalid(localPlayer) and localPlayer.CharacterStatUIComponent ~= nil then
      localPlayer.CharacterStatUIComponent:refreshObserverCharacterStat()
    end
    if ___MOD.isvalid(localPlayer) and localPlayer.KeyConfigUIComponent ~= nil then
      localPlayer.KeyConfigUIComponent:refreshObserverQuickSlot()
    end
  end, 0.3)
end

function ObserverUtilLogic.RefreshObserverPresentationState(self)
  local shouldActivate = self.ObserverPanelOpen or self.ObserverSessionActive
  local defaultGroup = ___MOD._EntityService:GetEntityByPath("/ui/DefaultGroup")
  if shouldActivate then
    if not self.ObserverViewActive then
      self.ObserverPreviousZoomRatio = ___MOD._CameraService.currentZoomRatio
      if ___MOD.isvalid(defaultGroup) then
        self.ObserverDefaultGroupWasEnabled = defaultGroup.Enable
        self.ObserverDefaultGroupWasVisible = defaultGroup.Visible
        self.ObserverDefaultGroupStateCaptured = true
      end
    end
    self.ObserverViewActive = true
    self:ApplyObserverDesktopUI()
    if ___MOD.isvalid(defaultGroup) then
      defaultGroup:SetEnable(false)
      defaultGroup:SetVisible(false)
    end
    self:ApplyObserverCameraZoom()
    ___MOD._TimerService:SetTimerOnce(function()
      if self.ObserverViewActive then
        self:ApplyObserverCameraZoom()
      end
    end, 0.3)
    return
  end
  if not self.ObserverViewActive then
    return
  end
  self.ObserverViewActive = false
  self:ApplyMobileGameplayUI()
  if ___MOD.isvalid(defaultGroup) and self.ObserverDefaultGroupStateCaptured then
    defaultGroup:SetEnable(self.ObserverDefaultGroupWasEnabled)
    defaultGroup:SetVisible(self.ObserverDefaultGroupWasVisible)
  end
  self.ObserverDefaultGroupStateCaptured = false
  self:ApplyObserverCameraZoom()
end

function ObserverUtilLogic.RequestObservedCharacterStatSnapshot_Server(self, senderUserId)

end

function ObserverUtilLogic.RequestObservedQuickSlotSnapshot_Server(self, senderUserId)

end

function ObserverUtilLogic.RequestObserveUserInOtherInstance_ServerOnly(self, observedUserProfileCode, observerUserId)

end

function ObserverUtilLogic.ResolveObservedUserProfileCode_ServerOnly(self, observedUserKey)

end

function ObserverUtilLogic.SetActiveObserverUtilsEntity(self, parent, isActive)
  if parent == nil then
    parent = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
    if parent == nil then
      parent = ___MOD._EntityService:GetEntityByPath("/ui/DefaultGroup")
    end
  end
  if self.ObserverUtilsEntity ~= nil and ___MOD.isvalid(self.ObserverUtilsEntity) then
    self.ObserverUtilsEntity:SetEnable(isActive)
    self:SetObserverPanelOpen(isActive)
    return
  end
  self.ObserverUtilsEntity = nil
  local modelId = ___MOD._EntryService:GetModelIdByName("Model_ObserverUtils")
  local entites = ___MOD._EntityService:GetEntitiesSpawnedByModelId(modelId)
  if entites ~= nil and entites[1] ~= nil and entites[1].ObserverUtilsComponent ~= nil then
    self.ObserverUtilsEntity = entites[1]
  end
  if self.ObserverUtilsEntity == nil then
    self.ObserverUtilsEntity = ___MOD._SpawnService:SpawnByModelId(modelId, "ObserverUtils", ___MOD.Vector3.zero, parent)
  end
  if self.ObserverUtilsEntity ~= nil then
    self.ObserverUtilsEntity:SetEnable(isActive)
    self:SetObserverPanelOpen(isActive)
  end
end

function ObserverUtilLogic.SetFullAuto(self, isFullAuto)
  self.FullAuto = isFullAuto
  self:SetFullAuto_Server(isFullAuto)
end

function ObserverUtilLogic.SetFullAuto_Server(self, isFullAuto, senderUserId)

end

function ObserverUtilLogic.SetFullAuto_ServerOnly(self, observerUserId, isFullAuto, needSync)

end

function ObserverUtilLogic.SetObserverPanelOpen(self, isOpen)
  self.ObserverPanelOpen = isOpen
  self:RefreshObserverPresentationState()
end

function ObserverUtilLogic.SetObserverPlatformUIEntity(self, path, enable)
  local entity = ___MOD._EntityService:GetEntityByPath(path)
  if not ___MOD.isvalid(entity) then
    return
  end
  entity:SetEnable(enable)
  entity:SetVisible(enable)
end

function ObserverUtilLogic.SetObserverViewState(self, isObserving)
  self.ObserverSessionActive = isObserving
  self:RefreshObserverPresentationState()
end

function ObserverUtilLogic.StartObservedUserAttackLog_ServerOnly(self, observedUserProfileCode, observerUserProfileCode)

end

function ObserverUtilLogic.StopObserve(self, observerUserProfileCode)
  self:StopObserve_Server(observerUserProfileCode)
end

function ObserverUtilLogic.StopObserve_Server(self, observerUserProfileCode, senderUserId)

end

function ObserverUtilLogic.StopObserve_ServerOnly(self, observerUserProfileCode)

end

function ObserverUtilLogic.StopObservedUserAttackLog_ServerOnly(self, observerUserProfileCode)

end

function ObserverUtilLogic.SyncFullAuto(self, userId, isFullAuto, senderUserId)

end

function ObserverUtilLogic.SyncObservedQuickSlotToObserver_ServerOnly(self, observedUserProfileCode, observerUserProfileCode)

end

function ObserverUtilLogic.SyncObservedUserEquipmentToObserver_ServerOnly(self, observedUserProfileCode, observerUserProfileCode, retryCount)

end

function ObserverUtilLogic.SyncObservedUserMoveToInstanceRoom(self, observedUserProfileCode, instanceKey)
  local evt = ___MOD.OnObservedUserMoveToInstanceRoom()
  evt.ObservedUserProfileCode = observedUserProfileCode
  evt.InstanceKey = instanceKey
  if self.ObserverUtilsEntity ~= nil then
    self.ObserverUtilsEntity:SendEvent(evt)
  end
end

function ObserverUtilLogic.SyncObservedUserMoveToStaticRoom(self, observedUserProfileCode)
  local evt = ___MOD.OnObservedUserMoveToStaticRoom()
  evt.ObservedUserProfileCode = observedUserProfileCode
  if self.ObserverUtilsEntity ~= nil then
    self.ObserverUtilsEntity:SendEvent(evt)
  end
end

function ObserverUtilLogic.SyncObservedUserWarpWorldInstance(self, observedUserProfileCode, worldInstanceId)
  local evt = ___MOD.OnObservedUserWarpWorldInstance()
  evt.ObservedUserProfileCode = observedUserProfileCode
  evt.WorldInstanceId = worldInstanceId
  if self.ObserverUtilsEntity ~= nil then
    self.ObserverUtilsEntity:SendEvent(evt)
  end
end

function ObserverUtilLogic.SyncUserMapVisualsToObservers_ServerOnly(self, observedUserId)

end

function ObserverUtilLogic.SyncUserMapVisualsToObserversRetry_ServerOnly(self, observedUserId, retryCount)

end

function ObserverUtilLogic.TraceUser_InstanceRoom_ServerOnly(self, observerUserId, observedUserProfileCode, instanceKey)

end

function ObserverUtilLogic.TraceUser_StaticRoom_ServerOnly(self, observerUserId, observedUserProfileCode)

end

function ObserverUtilLogic.TraceUser_Warp_ServerOnly(self, observedUserProfileCode, newWorldInstanceId, userId)

end

function ObserverUtilLogic.TryAutoObserveFromUI(self, observedUserKey)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not (___MOD.isvalid(localPlayer) and localPlayer.Player ~= nil and localPlayer.Player.init) or localPlayer.PlayerComponent == nil or localPlayer.CurrentMap == nil then
    return false
  end
  self:SetActiveObserverUtilsEntity(nil, true)
  if not (self.ObserverUtilsEntity ~= nil and ___MOD.isvalid(self.ObserverUtilsEntity)) or self.ObserverUtilsEntity.ObserverUtilsComponent == nil then
    return false
  end
  return self.ObserverUtilsEntity.ObserverUtilsComponent:AutoObserveUser(observedUserKey)
end
