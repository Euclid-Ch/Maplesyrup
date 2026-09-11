

function WorldConstants.applyLiveInstanceFlags(self, liveInstanceIds)

end

function WorldConstants.buildChannelRowsForUI(self)

end

function WorldConstants.buildChannelRowsVersion(self, rows)

end

function WorldConstants.canTransferToWorldInstanceId(self, worldInstanceId)

end

function WorldConstants.createPlanetChannelSenderTag(self)

end

function WorldConstants.enableBtEmergency(self)
  local btEmergency = ___MOD._EntityService:GetEntity("c93e8576-2d20-44f0-a6ff-36401517364d")
  btEmergency:ConnectEvent(___MOD.TouchReleaseEvent, self.onBtEmergency)
  btEmergency:SetEnable(true)
end

function WorldConstants.finishRefreshLiveInstanceFlags(self, liveInstanceIds)

end

function WorldConstants.flushInstanceListCallbacks(self, result, response)

end

function WorldConstants.getChannelRowsForUI(self)

end

function WorldConstants.getCurrentWorldInstanceIndex(self)

end

function WorldConstants.getInstanceStatusLogging(self)

end

function WorldConstants.getWorldInstanceIndexById(self, worldInstanceId)

end

function WorldConstants.getWorldInstanceInfoEntryById(self, worldInstanceId)

end

function WorldConstants.getWorldName(self)

end

function WorldConstants.getWorldNameWithChannel(self)

end

function WorldConstants.getWorldNameWithChannelByID(self, id)

end

function WorldConstants.HandleWorldEmergencyEvent(self, event)
  self:mayDayMyWorld(event.enable)
end

function WorldConstants.isCashShopAuctionBlockedCurrentMap(self, user)
  if not (user ~= nil and ___MOD.isvalid(user)) or user.CurrentMap == nil or user.CurrentMap.MapInfoComponent == nil then
    return false
  end
  local mapId = ___MOD.tonumber(user.CurrentMap.MapInfoComponent.mapID or 0) or 0
  return self:isCashShopAuctionBlockedMap(mapId)
end

function WorldConstants.isCashShopAuctionBlockedMap(self, mapId)
  return 914000000 <= mapId and mapId <= 914000500
end

function WorldConstants.isTokyoKrAccount(self, userId)

end

function WorldConstants.loadCurrentInstanceMaxUserCount(self)

end

function WorldConstants.mayDayMyWorld(self, enable)

end

function WorldConstants.OnBeginPlay(self)
  self.worldName["64b9fefe2f664c189a4c1be40b6e8062"] = "플래닛"
  self.worldName["95fdb334b18445dd89582b03b46f3325"] = "원정대"
  self.worldName["5d7d8115e1ea49a7a0539f65ddc7d8d3"] = "DEV"
  self.worldName["652657e8f2884fbb897b57c451265d67"] = "Fast"
  self.worldIds["플래닛"] = "64b9fefe2f664c189a4c1be40b6e8062"
  self.worldIds["원정대"] = "95fdb334b18445dd89582b03b46f3325"
  self.worldIds.DEV = "5d7d8115e1ea49a7a0539f65ddc7d8d3"
  self.worldIds.Fast = "652657e8f2884fbb897b57c451265d67"
  if self:IsServer() then
    local division = ___MOD._WorldInstanceService:GetDivision()
    self.istokyo = division == ___MOD.Division.Tokyo
    local islive = ___MOD.Environment:IsPublishedPlay() and "_live" or ""
    local refresh_interval = 30
    self.refresh_worldInstanceInfo_timer = ___MOD._TimerService:SetTimerRepeat(self.onTimer, refresh_interval)
    local senderTag = self:createPlanetChannelSenderTag()
    self:requestInstanceList(nil, senderTag, senderTag)
    local checkMapV = ___MOD._EntityService:GetEntityByPath("/maps/Planet")
    local checkMapP = ___MOD._EntityService:GetEntityByPath("/maps/PQ")
    local checkMapFast = ___MOD._EntityService:GetEntityByPath("/maps/Fast")
    if checkMapV ~= nil and ___MOD.isvalid(checkMapV.MapSettingComponent) then
      self.worldId = "64b9fefe2f664c189a4c1be40b6e8062"
    elseif checkMapP ~= nil and ___MOD.isvalid(checkMapP.MapSettingComponent) then
      self.worldId = "95fdb334b18445dd89582b03b46f3325"
    end
    if checkMapV ~= nil and ___MOD.isvalid(checkMapV.MapSettingComponent) and checkMapP ~= nil and ___MOD.isvalid(checkMapP.MapSettingComponent) then
      self.worldId = "5d7d8115e1ea49a7a0539f65ddc7d8d3"
      islive = ""
    end
    if checkMapFast ~= nil and ___MOD.isvalid(checkMapFast.MapSettingComponent) then
      self.worldId = "652657e8f2884fbb897b57c451265d67"
    end
    self.worldInstanceId = ___MOD._WorldInstanceService.WorldInstanceId
    self.worldPlayerActivityServiceURL = "https://suis.mapleplanet.co.kr/HttpService" .. islive
    self.worldRequestServiceURL = "https://suis.mapleplanet.co.kr/HttpService" .. islive
    self.worldLogServiceURL = "https://suis.mapleplanet.co.kr/LogService" .. islive
    self:loadCurrentInstanceMaxUserCount()
    self:startInstanceStatusLogging()
    ___MOD.log(___MOD.string.format("World Instance has been Initiallized. [WorldName : %s, WorldID : %s]", self.worldName[self.worldId], self.worldId))
  end
end

function WorldConstants.onBtEmergency(self)
  local message = self.emergency and "정말 비상사태를 종료하시겠습니까?" or "정말 비상사태를 선언하시겠습니까?"
  ___MOD._UINotice:showYesNoUI(message, function(base)
    self:requestWorldEmergency()
    if ___MOD.isvalid(base) then
      base:Destroy()
    end
  end, nil)
end

function WorldConstants.OnEndPlay(self)

end

function WorldConstants.OnSyncProperty(self, name, value)
  if name == "currentInstanceIdx" then
    local player = ___MOD._UserService.LocalPlayer
    if player == nil then
      return
    end
    player.UIStatusBar.nameToolTip.TooltipComponent.text = ___MOD.string.format("%s / %s-%d / %s", player.PlayerComponent.ProfileCode, ___MOD._WorldConstants.worldName[___MOD._WorldConstants.worldId], value, player.Player.Name)
  end
end

function WorldConstants.onTimer(self)

end

function WorldConstants.refreshLiveInstanceFlags(self)

end

function WorldConstants.refreshLiveInstanceFlagsAsync(self, callback)

end

function WorldConstants.requestInstanceList(self, callback, senderPlayerId, senderName)

end

function WorldConstants.requestWorldEmergency(self, senderUserId)

end

function WorldConstants.startInstanceStatusLogging(self)

end

function WorldConstants.updateInstanceList(self, response)

end
