

function UILoading.cancelMapFadeWatchdog(self)
  local timerId = self._T.mapFadeWatchdogTimerId
  if timerId ~= nil and timerId ~= 0 then
    ___MOD._TimerService:ClearTimer(timerId)
  end
  self._T.mapFadeWatchdogTimerId = nil
  self._T.mapFadeWatchdogToken = (self._T.mapFadeWatchdogToken or 0) + 1
  self._T.mapFadeStartMapId = nil
  self._T.mapFadeExpectedMapId = nil
  self._T.mapFadeExpectedConfirmed = nil
  self._T.mapFadeResyncAttempts = nil
  self._T.mapFadeResyncRequested = nil
  self._T.mapFadeResyncSentToken = nil
end

function UILoading.clearDataLoadDetailText(self)
  self:setDataLoadDetailText("")
end

function UILoading.completedDataLoading(self)
  local entity = ___MOD._UserService.LocalPlayer
  ___MOD._MousePointerLogic:initialize()
  if not self.isWarp then
    local camera = self:ensureLoginCamera()
    if ___MOD.isvalid(camera) and camera.TransformComponent ~= nil then
      camera.TransformComponent.Position = ___MOD.FastVector3(0, -1.5, 0)
    end
    ___MOD._SoundService:PlayBGM(___MOD.__RUIDManager:get("BgmUI.img.Title"), 1)
  end
  ___MOD._TimerService:SetTimerOnce(function()
    self:clearDataLoadDetailText()
    self.DataLoadText:SetEnable(false)
    if self.Loading == nil then
      self.Loading = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/DataLoading")
    end
    self.Loading:SetEnable(false)
    local all = ___MOD._EntityService:GetEntityByPath("/ui/LoginFrame/all")
    local tween = ___MOD._TweenLogic:MakeNativeTween(0, 1, 2, ___MOD.EaseType.Linear, all.SpriteGUIRendererComponent, "SetAlpha")
    tween.AutoDestroy = true
    tween:Play()
    if self.isWarp then
      ___MOD._PlayerDataLogic:tryInitPlayerFromClientByPlayerId()
    end
  end, 1)
end

function UILoading.completePlanetFadeInState(self)
  local fade = self.LoadingFade
  if not ___MOD.isvalid(fade) then
    fade = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/LoadingFade")
    self.LoadingFade = fade
  end
  if ___MOD.isvalid(fade) and fade.SpriteGUIRendererComponent ~= nil then
    fade.SpriteGUIRendererComponent.RaycastTarget = false
  end
  self.changedMap = false
  self:cancelMapFadeWatchdog()
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) then
    local ok, err = ___MOD.pcall(function()
      if self.playerFirstLoading and user.PlayerHitComponent ~= nil then
        user.PlayerHitComponent.hitTime = ___MOD._UtilLogic.ServerElapsedSeconds + 2
      end
      if ___MOD.isvalid(user.RigidbodyComponent) then
        user.RigidbodyComponent:PositionReset()
      end
    end)
    if not ok then
      ___MOD.log_error("[MapFade] 완료 처리 중 오류: ", ___MOD.tostring(err))
      self:reportMapFadeWatchdog(___MOD.string.format("[MapFade] 완료 처리 중 오류. err=%s", ___MOD.tostring(err)))
    end
    if user.PlayerActionComponent ~= nil then
      user.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.ChangeMap, false)
    end
  end
  self.playerFirstLoading = false
end

function UILoading.ensureLoginCamera(self)
  local camera = ___MOD._LoginLogic.camera
  if ___MOD.isvalid(camera) then
    return camera
  end
  local loadingMap = ___MOD._EntityService:GetEntityByPath("/maps/LoadingMap")
  if not ___MOD.isvalid(loadingMap) then
    ___MOD.log_warning("UILoading.ensureLoginCamera: LoadingMap is nil")
    return nil
  end
  camera = ___MOD._SpawnService:SpawnByModelId("model://d38e411b-c0b7-43ec-91f8-dc57d8145186", "Camera", ___MOD.FastVector3.zero:Clone(), loadingMap)
  if not ___MOD.isvalid(camera) then
    ___MOD.log_warning("UILoading.ensureLoginCamera: failed to spawn login camera")
    return nil
  end
  ___MOD._LoginLogic.camera = camera
  ___MOD._CameraService.TransitionBlendType = ___MOD.CameraBlendType.Cut
  if camera.CameraComponent ~= nil then
    ___MOD._CameraService:SwitchCameraTo(camera.CameraComponent)
  end
  ___MOD.log_warning("UILoading.ensureLoginCamera: recreated missing login camera")
  return camera
end

function UILoading.HandleFadeInStartEvent(self, event)
  ___MOD._StackMessageLogic:resetMessagePool()
end

function UILoading.HandleFadeOutStartEvent(self, event)
  self.changedMap = true
  self:startMapFadeWatchdog()
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) and user.PlayerActionComponent ~= nil then
    user.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.ChangeMap, true)
  end
end

function UILoading.initLoading(self)
  self.Loading = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/DataLoading")
  self.LoadingBg = self.Loading:GetChildByName("LoadingBg")
  self.LoadingCircle = self.Loading:GetChildByName("LoadingCircle")
  self.LoadingFade = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/LoadingFade")
  self.DataLoadText = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/DataLoading/DataLoadText")
  self.DataLoadText_1 = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/DataLoading/DataLoadText_1")
  self.black = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/black")
end

function UILoading.loadingFadeIn(self, duration, delay, fromLogin)
  if self._T.fadeInTween then
    self._T.fadeInTween:Destroy()
  end
  local c = self.LoadingFade.SpriteGUIRendererComponent.Color
  c.a = 1
  self.LoadingFade.SpriteGUIRendererComponent.Color = c
  self.LoadingFade.SpriteGUIRendererComponent.RaycastTarget = true
  if fromLogin then
    local frame = ___MOD._EntityService:GetEntityByPath("/ui/LoginFrame")
    if frame ~= nil then
      frame:SetEnable(false)
    end
  end

  local function startFade()
    if self._T.fadeOutTween then
      self._T.fadeOutTween:Destroy()
    end
    self._T.fadeOutTween = ___MOD._TweenLogic:PlayTween(1, 0, duration, ___MOD.EaseType.Linear, function(v)
      if v < 0 then
        v = 0
      end
      if 1 < v then
        v = 1
      end
      local cc = self.LoadingFade.SpriteGUIRendererComponent.Color
      cc.a = v
      self.LoadingFade.SpriteGUIRendererComponent.Color = cc
      if v <= 0.001 then
        ___MOD._StackMessageLogic:resetMessagePool()
        self.LoadingFade.SpriteGUIRendererComponent.RaycastTarget = false
        self._T.fadeOutTween = nil
        self.inTransferField = false
        if ___MOD.isvalid(___MOD._UserService.LocalPlayer) then
          local localPlayer = ___MOD._UserService.LocalPlayer
          localPlayer.PlayerSecondaryAbilityComponent:syncMovementStatsClient()
          localPlayer.PlayerActionComponent:setPlayerControl(true)
        end
      end
    end)
    self._T.fadeOutTween.AutoDestroy = true
  end

  ___MOD._TweenLogic:PlayTween(0, 0, delay, ___MOD.EaseType.Linear, function(_)
    startFade()
  end).AutoDestroy = true
end

function UILoading.loadingFadeOut(self, duration, fadeInCallback)
  self.LoadingFade.SpriteGUIRendererComponent.RaycastTarget = true
  local c = self.LoadingFade.SpriteGUIRendererComponent.Color
  c.a = 0
  ___MOD._TimerService:SetTimerOnce(function()
    self.LoadingFade.SpriteGUIRendererComponent.Color = c
    self.black:SetEnable(false)
  end, 0.6)
  local user = ___MOD._UserService.LocalPlayer
  if user then
    user.PlayerActionComponent:setPlayerControl(false)
  end
  ___MOD._StackMessageLogic:resetMessagePool()
  if self._T.fadeOutTween then
    self._T.fadeOutTween:Destroy()
  end
  self._T.fadeInTween = ___MOD._TweenLogic:PlayTween(0, 1, duration, ___MOD.EaseType.Linear, function(v)
    if v < 0 then
      v = 0
    end
    if 1 < v then
      v = 1
    end
    local cc = self.LoadingFade.SpriteGUIRendererComponent.Color
    cc.a = v
    self.LoadingFade.SpriteGUIRendererComponent.Color = cc
    if 0.999 <= v then
      if fadeInCallback then
        fadeInCallback()
      end
      self._T.fadeInTween = nil
    end
  end)
  self._T.fadeInTween.AutoDestroy = true
  self.inTransferField = true
end

function UILoading.OnEndPlay(self)
  self:cancelMapFadeWatchdog()
end

function UILoading.planetFadeIn(self, delay, duration)
  local fade = self.LoadingFade
  if not ___MOD.isvalid(fade) then
    self.LoadingFade = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/LoadingFade")
    fade = self.LoadingFade
  end
  if not ___MOD.isvalid(fade) or fade.SpriteGUIRendererComponent == nil then
    self:completePlanetFadeInState()
    return
  end
  local t1 = self._T.fadeInTween1
  if t1 then
    t1:Destroy()
    self._T.fadeInTween1 = nil
  end
  local t2 = self._T.fadeInTween2
  if t2 then
    t2:Destroy()
    self._T.fadeInTween2 = nil
  end
  local fadeGeneration = self._T.mapFadeWatchdogToken or 0
  local fadeStarted = false
  local tween1 = ___MOD._TweenLogic:PlayTween(0, 1, delay, ___MOD.EaseType.Linear, function(v)
    if self._T.mapFadeWatchdogToken ~= fadeGeneration then
      return
    end
    if 0.999 <= v and not fadeStarted then
      fadeStarted = true
      self._T.fadeInTween1 = nil
      if not ___MOD.isvalid(fade) or fade.SpriteGUIRendererComponent == nil then
        self:completePlanetFadeInState()
        return
      end
      self.changedMap = false
      local localPlayer = ___MOD._UserService.LocalPlayer
      local currentMap = ___MOD.isvalid(localPlayer) and localPlayer.CurrentMap or nil
      local mapInfo = ___MOD.isvalid(currentMap) and currentMap.MapInfoComponent or nil
      if self._T.mapFadeOnUserEnterGeneration ~= fadeGeneration then
        self._T.mapFadeOnUserEnterGeneration = fadeGeneration
        if mapInfo and (not ___MOD._UtilLogic:IsNilorEmptyString(mapInfo.onUserEnter) or not ___MOD._UtilLogic:IsNilorEmptyString(mapInfo.onFirstUserEnter)) then
          local ok, err = ___MOD.pcall(function()
            mapInfo:runOnUserEnter()
          end)
          if not ok then
            ___MOD.log_error("[MapFade] onUserEnter 실행 오류: ", ___MOD.tostring(err))
            self:reportMapFadeWatchdog(___MOD.string.format("[MapFade] onUserEnter 실행 오류. mapID=%d err=%s", ___MOD.tonumber(mapInfo.mapID) or 0, ___MOD.tostring(err)))
          end
        end
      end
      if ___MOD.isvalid(localPlayer) and localPlayer.CameraComponent ~= nil then
        localPlayer.CameraComponent.Damping = ___MOD.Vector2(2.5, 3.9)
      end
      local sprite = fade.SpriteGUIRendererComponent
      local tween2 = ___MOD._TweenLogic:MakeNativeTween(1, 0, duration, ___MOD.EaseType.Linear, sprite, "SetAlpha")
      self._T.fadeInTween2 = tween2
      tween2.AutoDestroy = true
      tween2:SetOnEndCallback(function()
        if self._T.mapFadeWatchdogToken ~= fadeGeneration then
          return
        end
        self._T.fadeInTween2 = nil
        self:completePlanetFadeInState()
      end)
      tween2:Play()
    end
  end)
  tween1.AutoDestroy = true
  if not fadeStarted then
    self._T.fadeInTween1 = tween1
  end
end

function UILoading.planetFadeOut(self)
  local fade = self.LoadingFade
  if not ___MOD.isvalid(fade) then
    self.LoadingFade = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/LoadingFade")
    fade = self.LoadingFade
  end
  if not ___MOD.isvalid(fade) or fade.SpriteGUIRendererComponent == nil then
    return
  end
  local fadeSpr = fade.SpriteGUIRendererComponent
  fadeSpr:SetAlpha(1)
  fadeSpr.RaycastTarget = true
end

function UILoading.recoverMapFadeAfterTimeout(self)
  local token = self._T.mapFadeWatchdogToken or 0
  local user = ___MOD._UserService.LocalPlayer
  local currentMap = ___MOD.isvalid(user) and user.CurrentMap or nil
  local currentMapInfo = ___MOD.isvalid(currentMap) and currentMap.MapInfoComponent or nil
  local actualMapId = ___MOD.isvalid(currentMapInfo) and ___MOD.tonumber(currentMapInfo.mapID) or 0
  local expectedMapId = ___MOD.tonumber(self._T.mapFadeExpectedMapId) or 0
  if expectedMapId <= 0 and ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
    expectedMapId = ___MOD.tonumber(user.Player.Map) or 0
  end
  local startMapId = ___MOD.tonumber(self._T.mapFadeStartMapId) or 0
  local resyncAttempts = ___MOD.tonumber(self._T.mapFadeResyncAttempts) or 0
  local expectedMapConfirmed = self._T.mapFadeExpectedConfirmed == true
  local requiresMapResync = actualMapId <= 0 or expectedMapId <= 0 or actualMapId ~= expectedMapId
  if not requiresMapResync and actualMapId == startMapId and not expectedMapConfirmed then
    requiresMapResync = true
  end
  if requiresMapResync then
    if resyncAttempts < self.mapFadeResyncMaxAttempts then
      if resyncAttempts == 0 then
        ___MOD.log_warning("[MapFadeWatchdog] Client map did not reach the target; requesting server resync. actual=", actualMapId, " expected=", expectedMapId)
      end
      self:reportMapFadeWatchdog(___MOD.string.format("[MapFadeWatchdog] 이동 미확인, 서버 재전송 요청. actual=%d expected=%d start=%d attempts=%d", actualMapId, expectedMapId, startMapId, resyncAttempts + 1))
      self._T.mapFadeResyncRequested = true
      self._T.mapFadeResyncAttempts = resyncAttempts + 1
      if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
        self._T.mapFadeResyncSentToken = token
        user.Player:requestMapTransferResync(token)
      end
      self:scheduleMapFadeWatchdog(self.mapFadeResyncRetryInterval)
      return
    end
    ___MOD.log_error("[MapFadeWatchdog] Resync did not converge after ", resyncAttempts, " attempts; forcing FadeIn to unblock the player. actual=", actualMapId, " expected=", expectedMapId)
    self:reportMapFadeWatchdog(___MOD.string.format("[MapFadeWatchdog] 재전송 %d회 미수렴, 강제 FadeIn 언블록. actual=%d expected=%d", resyncAttempts, actualMapId, expectedMapId))
  end
  if ___MOD.isvalid(currentMapInfo) and ___MOD._PlayerUpdateLogic.mapInfo ~= currentMapInfo then
    ___MOD.log_warning("[MapFadeWatchdog] 맵 진입 상태 미적용 감지; 재적용. mapID=", actualMapId)
    self:reportMapFadeWatchdog(___MOD.string.format("[MapFadeWatchdog] 맵 진입 상태 미적용 감지, 재적용. mapID=%d", actualMapId))
    local okRecover, recoverErr = ___MOD.pcall(function()
      currentMapInfo:recoverClientMapEnter()
    end)
    if not okRecover then
      ___MOD.log_error("[MapFadeWatchdog] 진입 상태 재적용 오류: ", ___MOD.tostring(recoverErr))
      self:reportMapFadeWatchdog(___MOD.string.format("[MapFadeWatchdog] 진입 상태 재적용 오류. mapID=%d err=%s", actualMapId, ___MOD.tostring(recoverErr)))
    end
  end
  local fade = self.LoadingFade
  if not ___MOD.isvalid(fade) then
    fade = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/LoadingFade")
    self.LoadingFade = fade
  end
  local fadeSprite = ___MOD.isvalid(fade) and fade.SpriteGUIRendererComponent or nil
  if fadeSprite == nil then
    ___MOD.log_warning("[MapFadeWatchdog] LoadingFade is missing; releasing the map transition lock.")
    self:reportMapFadeWatchdog(___MOD.string.format("[MapFadeWatchdog] LoadingFade 소실, 잠금만 해제. mapID=%d", actualMapId))
    self:completePlanetFadeInState()
    return
  end
  local alpha = fadeSprite.Color.a
  if alpha <= 0.001 then
    self:reportMapFadeWatchdog(___MOD.string.format("[MapFadeWatchdog] 완료 콜백 유실, 완료 처리 수행. mapID=%d", actualMapId))
    self:completePlanetFadeInState()
    return
  end
  local currentMapName = ___MOD.isvalid(user) and ___MOD.tostring(user.CurrentMapName or "") or ""
  ___MOD.log_warning("[MapFadeWatchdog] FadeIn did not complete within the watchdog window; forcing recovery. map=", currentMapName)
  self:reportMapFadeWatchdog(___MOD.string.format("[MapFadeWatchdog] FadeIn 미완료, 강제 복구. mapID=%d map=%s", actualMapId, currentMapName))
  self:planetFadeIn(0, 0.5)
end

function UILoading.reportMapFadeWatchdog(self, text)
  local reported = self._T.mapFadeReportedLogs
  if reported == nil then
    reported = {}
    self._T.mapFadeReportedLogs = reported
  end
  if reported[text] then
    return
  end
  reported[text] = true
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
    user.Player:reportMapFadeWatchdogServer(text)
  end
end

function UILoading.scheduleMapFadeWatchdog(self, delay)
  local timerId = self._T.mapFadeWatchdogTimerId
  if timerId ~= nil and timerId ~= 0 then
    ___MOD._TimerService:ClearTimer(timerId)
  end
  local token = self._T.mapFadeWatchdogToken or 0
  self._T.mapFadeWatchdogTimerId = ___MOD._TimerService:SetTimerOnce(function()
    if self._T.mapFadeWatchdogToken ~= token then
      return
    end
    self._T.mapFadeWatchdogTimerId = nil
    self:recoverMapFadeAfterTimeout()
  end, delay)
end

function UILoading.setDataLoadDetailText(self, text)
  if self.DataLoadText_1 == nil then
    self:initLoading()
  end
  if self.DataLoadText_1 ~= nil then
    self.DataLoadText_1.TextComponent.Text = text
  end
end

function UILoading.setDataLoading(self)
  ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/DataLoading"):SetEnable(true)
end

function UILoading.setIsWarp(self, warp)
  self.isWarp = warp
end

function UILoading.setMapFadeExpectedMapId(self, mapId, token)
  if self._T.mapFadeWatchdogToken ~= token and self._T.mapFadeResyncSentToken ~= token then
    return
  end
  self._T.mapFadeExpectedMapId = mapId
  self._T.mapFadeExpectedConfirmed = true
end

function UILoading.startMapFadeWatchdog(self)
  local continuingResync = self._T.mapFadeResyncRequested == true
  local confirmedExpectedMapId = self._T.mapFadeExpectedConfirmed == true and self._T.mapFadeExpectedMapId or nil
  local pendingResyncSentToken = continuingResync and self._T.mapFadeResyncSentToken or nil
  local pendingResyncAttempts = continuingResync and (___MOD.tonumber(self._T.mapFadeResyncAttempts) or 1) or 0
  self:cancelMapFadeWatchdog()
  local fadeInTween1 = self._T.fadeInTween1
  if fadeInTween1 then
    fadeInTween1:Destroy()
    self._T.fadeInTween1 = nil
  end
  local fadeInTween2 = self._T.fadeInTween2
  if fadeInTween2 then
    fadeInTween2:Destroy()
    self._T.fadeInTween2 = nil
  end
  local token = (self._T.mapFadeWatchdogToken or 0) + 1
  self._T.mapFadeWatchdogToken = token
  local user = ___MOD._UserService.LocalPlayer
  local currentMap = ___MOD.isvalid(user) and user.CurrentMap or nil
  local currentMapInfo = ___MOD.isvalid(currentMap) and currentMap.MapInfoComponent or nil
  self._T.mapFadeStartMapId = ___MOD.isvalid(currentMapInfo) and ___MOD.tonumber(currentMapInfo.mapID) or 0
  self._T.mapFadeExpectedMapId = ___MOD.tonumber(confirmedExpectedMapId) or ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) and ___MOD.tonumber(user.Player.Map) or 0
  self._T.mapFadeExpectedConfirmed = confirmedExpectedMapId ~= nil
  self._T.mapFadeResyncRequested = continuingResync
  self._T.mapFadeResyncAttempts = pendingResyncAttempts
  self._T.mapFadeResyncSentToken = pendingResyncSentToken
  local watchdogDelay = continuingResync and self.mapFadeResyncRetryInterval or self.mapFadeWatchdogTimeout
  self:scheduleMapFadeWatchdog(watchdogDelay)
end

function UILoading.updateLoadText(self, cur)
  local text = ___MOD.string.format("데이터를 불러오고 있습니다... (%d / %d)", cur, ___MOD._DataLoadManager.TOTAL_LOAD_COUNT_CLIENT)
  if self.DataLoadText == nil then
    self:initLoading()
  end
  self.DataLoadText.TextComponent.Text = text
end
