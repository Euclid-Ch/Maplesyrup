

function PlayerDataLogic.clearAutoSaveTimer(self, user)

end

function PlayerDataLogic.deinitPlayer(self, user)

end

function PlayerDataLogic.getPlayerData(self, user, playerId)

end

function PlayerDataLogic.HandleUserReconnectEvent(self, event)
  local UserId = event.UserId
  local user = ___MOD._UserService:GetUserEntityByUserId(UserId)
  if not (___MOD.isvalid(user) and ___MOD.isvalid(user.Player)) or not user.Player.init then
    return
  end
  ___MOD._Dojang:resetDojoDamageMeterSessionClient(false, UserId)
  local curMap = user.CurrentMap
  if not ___MOD.isvalid(curMap) then
    return
  end
  if ___MOD.isvalid(curMap.MapLifeComponent) then
    curMap.MapLifeComponent:syncMistsToUser(UserId)
  end
  if not ___MOD.isvalid(curMap.LifeControllerComponent2) then
    return
  end
  curMap.LifeControllerComponent2:redistributeControllers(curMap, user)
end

function PlayerDataLogic.initializeDailyGiftQuestEx(self, user)

end

function PlayerDataLogic.initPlayer(self, userId, playerId, isWarpLogin)

end

function PlayerDataLogic.initPlayerFromClient(self, index, senderUserId)

end

function PlayerDataLogic.initPlayerToClient(self, loadedName, restoredTemporaryStatUIDatas, forceDesktopObserver)
  ___MOD._CameraService:ZoomTo(100, 0)
  if ___MOD._ServerConstants.Use_MSW_Fade then
    local black = ___MOD._EntityService:GetEntity("9e3982b5-ec71-434a-9220-195f2b3c6450")
    black:SetEnable(false)
  end
  local frame = ___MOD._EntityService:GetEntityByPath("/ui/LoginFrame")
  if frame ~= nil then
    frame:SetEnable(false)
  end
  ___MOD._UILoading.playerFirstLoading = true
  local user = ___MOD._UserService.LocalPlayer
  ___MOD._EntityService:GetEntityByPath("/ui/UIGroup"):SetEnable(true)
  local useMobilePlatform = ___MOD.Environment:IsMobilePlatform() and not forceDesktopObserver
  if useMobilePlatform then
    user.PlayerVariables:setMobilePlatformClient(true)
    user.PlayerVariables:setMobilePlatform(true)
    if ___MOD.isvalid(user.SkillUIComponent) then
      user.SkillUIComponent:refreshMobileSPUpButtonAppearances()
    end
  else
    user.PlayerVariables:setMobilePlatformClient(false)
    user.PlayerVariables:setMobilePlatform(false)
  end
  if user.PlayerHitComponent ~= nil then
    user.PlayerHitComponent.hitTime = ___MOD.math.max(user.PlayerHitComponent.hitTime, ___MOD._UtilLogic.ServerElapsedSeconds + 5)
  end
  user.UISystemOptionComponent:applyLoadedFontInfoType()
  local playerPos = ___MOD._SpawnService:SpawnByModelId(___MOD._EntryService:GetModelIdByName("PlayerPosTriggerEntity"), "PlayerPosTrigger", ___MOD.FastVector3.zero:Clone(), user)
  user.PlayerVariables.playerPosTrigger = playerPos.TriggerComponent
  if useMobilePlatform then
    local mobileStatusBar = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileStatusBar")
    local mobileChat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
    local mobileShortcutMenu = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileShortcutMenu")
    local mobileMenu = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileMenu")
    local mobileKeyConfig = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileKeyConfig")
    local mobileQuickCloseBtn = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileQuickCloseBtn")
    if ___MOD.isvalid(mobileStatusBar) and mobileStatusBar.UIMobileStatusBar ~= nil then
      mobileStatusBar.UIMobileStatusBar:Initialize(loadedName)
    end
    if ___MOD.isvalid(mobileChat) and mobileChat.UIMobileChat ~= nil then
      mobileChat.UIMobileChat:Initialize()
    end
    if ___MOD.isvalid(mobileShortcutMenu) and mobileShortcutMenu.UIMobileShortcutMenu ~= nil then
      mobileShortcutMenu.UIMobileShortcutMenu:Initialize()
    end
    if ___MOD.isvalid(mobileMenu) and mobileMenu.UIMobileMenu ~= nil then
      mobileMenu.UIMobileMenu:Initialize()
    end
    if ___MOD.isvalid(mobileKeyConfig) and mobileKeyConfig.UIMobileKeyConfig ~= nil then
      mobileKeyConfig.UIMobileKeyConfig:Initialize()
    end
    if ___MOD.isvalid(mobileQuickCloseBtn) and mobileQuickCloseBtn.UIMobileQuickCloseButton ~= nil then
      mobileQuickCloseBtn.UIMobileQuickCloseButton:Initialize()
    end
    ___MOD._MobileActionSlotLogic:setMobileActionSlotsVisible(true)
    ___MOD._MobileActionSlotLogic:setMobileActionSlotToggleVisible(true)
    ___MOD._UIMobileJoystickLogic:setMobileJoystickVisible(true)
    ___MOD._UIMobileHudLayout:ApplyMobileHudLayoutDeferred()
  else
    user.UIStatusBar:Initialize(loadedName)
    user.UIStatusBar:setQuickSlotVisible(true)
    user.UIStatusBar:setChatVisible(true)
  end
  if forceDesktopObserver then
    ___MOD._AdminCommandLogic:toggleObserveUIToClient(true)
  end
  user.CharacterStatUIComponent:Initialize(loadedName)
  if restoredTemporaryStatUIDatas ~= nil and ___MOD.next(restoredTemporaryStatUIDatas) ~= nil then
    user.CharacterStatUIComponent:recalcStat(restoredTemporaryStatUIDatas)
  end
  ___MOD._PlayerUpdateLogic:connectMouseMoveEvent()
end

function PlayerDataLogic.markSaveProcess(self, user, processing)

end

function PlayerDataLogic.onInitPlayerFromClientByPlayerId(self, playerId, userId)

end

function PlayerDataLogic.onLeavePlayer(self, userId)

end

function PlayerDataLogic.requestAddBlackList(self, targetName, dateText, senderUserId)

end

function PlayerDataLogic.requestRemoveBlackList(self, targetName, senderUserId)

end

function PlayerDataLogic.resetClient(self)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) then
    return
  end
  if ___MOD._UIElementLogic ~= nil then
    ___MOD._UIElementLogic:disableClone()
  end
  ___MOD._Dojang:resetDojoDamageMeterSessionClient(true)
  user.Player:clearAutoReviveTimerClient()
  if user.PartyUIComponent ~= nil then
    user.PartyUIComponent:clearPartyToClient()
  end
  if user.FriendUIComponent ~= nil then
    user.FriendUIComponent:resetUI()
  end
  user.PlayerNameTagComponent:reset()
  user.PetOwnerComponent:clearDataClient()
  if ___MOD.isvalid(user.UIStatusBar) then
    user.UIStatusBar:resetHuntStats()
  end
  local inventoryUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Inventory")
  if ___MOD.isvalid(inventoryUI) and inventoryUI.InventoryGridComponent ~= nil then
    inventoryUI.InventoryGridComponent.curPos = 1
    inventoryUI.InventoryGridComponent.lastPos = {}
  end
  user.PlayerChatComponent:resetDataClient()
  user.PlayerTemporaryStatComponent:resetDataFromDisconnectClient()
  if user.ActiveEffectItemComponent ~= nil then
    user.ActiveEffectItemComponent:CleanupAllClient()
  end
  user.PlayerVariables:resetData()
  user.PlayerActionComponent:reset()
  user.QuestComponent:resetQuestDataClient()
  ___MOD._FadeYesNo:resetFadeYesNo()
  user.KeyConfigComponent:sendKeyConfigAllRemoveCountEvent()
  user.ComboComponent:resetClient()
  ___MOD._SkillLogic:clearUseSP()
  local energyBar = user.EnergyBarComponent
  if ___MOD.isvalid(energyBar) and energyBar.parent then
    energyBar.parent:SetEnable(false)
  end
  local inventory = ___MOD._EntityService:GetEntity("12f881d4-d93b-4865-86ca-2d1e74164581")
  inventory:SetEnable(false)
  local worldMap = ___MOD._EntityService:GetEntity("fcddd1e0-9c8a-45d6-b526-2f854044c088")
  worldMap:SetEnable(false)
  local webNotice = ___MOD._EntityService:GetEntity("398517db-7604-4860-b1f7-d8dac6165bff")
  webNotice:SetEnable(false)
  local webUserList = ___MOD._EntityService:GetEntity("44c2cf9f-3c47-438c-956e-525f0783b9fe")
  webUserList:SetEnable(false)
  local webUserRank = ___MOD._EntityService:GetEntity("afe102d6-2f75-4056-a3db-16ecc429d4ea")
  webUserRank:SetEnable(false)
  local userInfo = ___MOD._EntityService:GetEntity("adc57890-6604-49b7-8de9-68d5ea9cfa4b")
  userInfo:SetEnable(false)
  local userList = ___MOD._EntityService:GetEntity("503394f3-1410-4a40-a8a5-e719939b88e9")
  userList:SetEnable(false)
  local quest = ___MOD._EntityService:GetEntity("51a6a73e-b746-4fca-b347-91050575c75f")
  quest:SetEnable(false)
  local skill = ___MOD._EntityService:GetEntity("57df9c41-a31d-4719-b17e-fa5d5c662f0d")
  skill:SetEnable(false)
  local equipment = ___MOD._EntityService:GetEntity("f32867c8-1d50-4a8d-a942-04ff709497d4")
  equipment:SetEnable(false)
  local stat = ___MOD._EntityService:GetEntity("29b143eb-9d7b-4126-a92a-05e73b019d83")
  stat:SetEnable(false)
  local keyConfig = ___MOD._EntityService:GetEntity("6ce18a6f-b9fe-486f-8d2b-abd7e3efefec")
  keyConfig:SetEnable(false)
  local gameMenu = ___MOD._EntityService:GetEntity("636a407f-147d-4f58-b238-94dd77900777")
  gameMenu:SetEnable(false)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if delivery ~= nil and delivery.EnabledInHierarchy then
    delivery:SetEnable(false)
  end
  local shortCut = ___MOD._EntityService:GetEntity("e6ddb17d-c7c7-410a-b4bf-22d861e72b32")
  shortCut:SetEnable(false)
  local uiGroup = ___MOD._EntityService:GetEntity("c1ee38e4-b61d-4299-a1dd-d7a9b11f55c5")
  local shop = uiGroup:GetChildByName("Shop")
  if shop ~= nil and shop.EnabledInHierarchy then
    shop:Destroy()
  end
  local miracleCube = uiGroup:GetChildByName("miracleCube")
  if miracleCube ~= nil and miracleCube.EnabledInHierarchy then
    miracleCube:Destroy()
  end
  local karmaScissors = uiGroup:GetChildByName("karmaScissors")
  if karmaScissors ~= nil and karmaScissors.EnabledInHierarchy then
    karmaScissors:Destroy()
  end
  local invcompponent = ___MOD._UserService.LocalPlayer.CInventoryComponent
  local enchantUI = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemEnchant")
  if enchantUI ~= nil and enchantUI.Enable then
    invcompponent:closeItemEnchantUI()
  end
  local itemProtector = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/ItemProtector")
  if itemProtector ~= nil and itemProtector.Enable then
    invcompponent:closeItemProtectorUI()
  end
  local report = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Report")
  if report ~= nil and report.Enable and report.ReportUIComponent ~= nil then
    report.ReportUIComponent:close()
  end
  local raise = ___MOD._UIWindowLogic:getUI("Raise")
  if ___MOD.isvalid(raise) then
    ___MOD._UIWindowLogic:destroyUI("Raise")
  end
  local floatNotice = ___MOD._UIWindowLogic:getUI("FloatNotice")
  if ___MOD.isvalid(floatNotice) then
    ___MOD._UIWindowLogic:destroyUI("FloatNotice")
  end
  ___MOD._UIWindowLogic:clearData()
  ___MOD._LoginLogic.loginStep = 1
  for _, e in ___MOD.pairs(user.Children) do
    if e.Name ~= "AvatarRoot" then
      e:Destroy()
    end
  end
  user:SetVisible(true)
  user.PlayerActionComponent.isClimbing = false
  user.MovementComponent.Enable = true
  user.ExtendPlayerControllerComponent.Enable = true
  user.PlayerActionComponent.Enable = true
  user.ExtendPlayerControllerComponent.FixedLookAt = 0
  local mobileActionSlots = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlots")
  if mobileActionSlots ~= nil then
    ___MOD._MobileActionSlotLogic:resetClientSlotStateForCharacterLoad()
    ___MOD._MobileActionSlotLogic:setMobileActionSlotsVisible(false)
    ___MOD._MobileActionSlotLogic:setMobileActionSlotToggleVisible(false)
    mobileActionSlots.Visible = true
  end
  ___MOD._UIMobileJoystickLogic:setMobileJoystickVisible(false)
  local mobileStatusBar = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileStatusBar")
  if mobileStatusBar ~= nil then
    mobileStatusBar:SetEnable(false)
    mobileStatusBar.Visible = true
  end
  local mobileChat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  if mobileChat ~= nil then
    mobileChat:SetEnable(false)
    mobileChat.Visible = true
  end
  if ___MOD.Environment:IsMobilePlatform() then
    local statusBar = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/StatusBar")
    if statusBar ~= nil then
      statusBar:SetEnable(false)
    end
  end
  ___MOD._PlayerUpdateLogic.mapInfo = nil
  ___MOD._PlayerUpdateLogic:disconnectMouseMoveEvent()
  ___MOD._AntiRepeat:clearRepeat()
end

function PlayerDataLogic.resetServer(self, user)

end

function PlayerDataLogic.returnToTitleFromClient(self, senderUserId)

end

function PlayerDataLogic.savePlayerDataWithProcess(self, user, playerId, saveData, reason)

end

function PlayerDataLogic.setAutoSaveTimer(self, user, timer)

end

function PlayerDataLogic.successWarpLogin(self)
  ___MOD._UILoading.isWarp = false
  if not ___MOD._ServerConstants.Use_MSW_Fade then
    ___MOD._UILoading:loadingFadeOut(0.5, nil)
  end
end

function PlayerDataLogic.syncSkillCooltimesClient(self, restoredSkillCooltimes)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or user.PlayerVariables == nil then
    return
  end
  local t = {}
  if ___MOD.type(restoredSkillCooltimes) == "table" then
    for sid, endTime in ___MOD.pairs(restoredSkillCooltimes) do
      local skillId = ___MOD.tonumber(sid) or 0
      local v = ___MOD.tonumber(endTime) or 0
      if 0 < skillId and 0 < v then
        t[skillId] = v
      end
    end
  end
  user.PlayerVariables.skillCooltimes = t
end

function PlayerDataLogic.tryInitPlayerFromClientByPlayerId(self, senderUserId)

end

function PlayerDataLogic.tryReturnToTitle(self, userId)

end
