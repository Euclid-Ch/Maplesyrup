

function PlayerKeyActionFunction.loadKeyAction(self)
  local keyDownAction = {}
  keyDownAction[___MOD._KeyConfigActionType.EQUIP] = self.onEquip
  keyDownAction[___MOD._KeyConfigActionType.INVENTORY] = self.onInventory
  keyDownAction[___MOD._KeyConfigActionType.TO_ALL] = self.onToAll
  keyDownAction[___MOD._KeyConfigActionType.WHISPER] = self.onWhisper
  keyDownAction[___MOD._KeyConfigActionType.TO_PARTY] = self.onToParty
  keyDownAction[___MOD._KeyConfigActionType.TO_FRIEND] = self.onToFriend
  keyDownAction[___MOD._KeyConfigActionType.SHORTCUT] = self.onShortCut
  keyDownAction[___MOD._KeyConfigActionType.QUICKSLOT] = self.onQuickslot
  keyDownAction[___MOD._KeyConfigActionType.CHATPLUS] = self.onChatPlus
  keyDownAction[___MOD._KeyConfigActionType.GUILD] = self.onGuild
  keyDownAction[___MOD._KeyConfigActionType.TO_GUILD] = self.onToGuild
  keyDownAction[___MOD._KeyConfigActionType.PARTY] = self.onParty
  keyDownAction[___MOD._KeyConfigActionType.ABILITY] = self.onAbility
  keyDownAction[___MOD._KeyConfigActionType.NOTIFICATION] = self.onNotification
  keyDownAction[___MOD._KeyConfigActionType.MONSTERBOOK] = self.onMonsterbook
  keyDownAction[___MOD._KeyConfigActionType.CASHSHOP] = self.onCashshop
  keyDownAction[___MOD._KeyConfigActionType.TO_ALLIANCE] = self.onToAlliance
  keyDownAction[___MOD._KeyConfigActionType.FIND_PARTY] = self.onFindParty
  keyDownAction[___MOD._KeyConfigActionType.MEDAL] = self.onMedal
  keyDownAction[___MOD._KeyConfigActionType.EXPEDITION] = self.onExpedition
  keyDownAction[___MOD._KeyConfigActionType.SKILL] = self.onSkill
  keyDownAction[___MOD._KeyConfigActionType.FRIEND] = self.onFriend
  keyDownAction[___MOD._KeyConfigActionType.WORLDMAP] = self.onWorldmap
  keyDownAction[___MOD._KeyConfigActionType.SIT] = self.onSit
  keyDownAction[___MOD._KeyConfigActionType.CHAT_NPC] = self.onChatNPC
  keyDownAction[___MOD._KeyConfigActionType.TO_CHANNEL] = self.onToChannel
  keyDownAction[___MOD._KeyConfigActionType.DPS] = self.onDps
  keyDownAction[___MOD._KeyConfigActionType.MESSENGER] = self.onMessenger
  keyDownAction[___MOD._KeyConfigActionType.MINIMAP] = self.onMinimap
  keyDownAction[___MOD._KeyConfigActionType.QUEST] = self.onQuest
  keyDownAction[___MOD._KeyConfigActionType.KEYCONFIG] = self.onKeyconfig
  keyDownAction[___MOD._KeyConfigActionType.CHAT] = self.onChat
  keyDownAction[___MOD._KeyConfigActionType.EMOTION_1] = function()
    self:onEmotion(1)
  end
  keyDownAction[___MOD._KeyConfigActionType.EMOTION_2] = function()
    self:onEmotion(2)
  end
  keyDownAction[___MOD._KeyConfigActionType.EMOTION_3] = function()
    self:onEmotion(3)
  end
  keyDownAction[___MOD._KeyConfigActionType.EMOTION_4] = function()
    self:onEmotion(4)
  end
  keyDownAction[___MOD._KeyConfigActionType.EMOTION_5] = function()
    self:onEmotion(5)
  end
  keyDownAction[___MOD._KeyConfigActionType.EMOTION_6] = function()
    self:onEmotion(6)
  end
  keyDownAction[___MOD._KeyConfigActionType.EMOTION_7] = function()
    self:onEmotion(7)
  end
  keyDownAction[___MOD._KeyConfigActionType.JUMP] = self.onJump
  local keyHoldAction = {}
  keyHoldAction[___MOD._KeyConfigActionType.ATTACK] = self.onAttack
  keyHoldAction[___MOD._KeyConfigActionType.LOOT] = self.onLoot
  return keyDownAction, keyHoldAction
end

function PlayerKeyActionFunction.onAbility(self)
  local e = ___MOD._EntityService:GetEntity("29b143eb-9d7b-4126-a92a-05e73b019d83")
  if ___MOD._AranLogic:isBlockedIntroWindow("CharacterStat") and not e.Enable then
    return
  end
  ___MOD._UIWindowLogic:enableUI(e)
end

function PlayerKeyActionFunction.onAttack(self)
  local user = ___MOD._UserService.LocalPlayer
  local basicAttackPressed = ___MOD._PlayerKeyActionFunction._T.basicAttackPressed
  ___MOD._PlayerKeyActionFunction._T.basicAttackPressed = false
  if user and (user.CashShopComponent and user.CashShopComponent.inCashShop or user.AuctionComponent and user.AuctionComponent.inAuction) then
    return
  end
  if ___MOD._AranLogic:tryConsumePendingFinalBlowAction(user) then
    return
  end
  if basicAttackPressed and ___MOD._AranLogic:tryUseAranComboCommandSkill(user) then
    return
  end
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(user)
  if weaponInfo.valid or weaponInfo.weaponType == ___MOD._WeaponType.BARE_HANDS then
    local type = weaponInfo.weaponType
    local isShoot = false
    if type == ___MOD._WeaponType.BOW or type == ___MOD._WeaponType.CROSSBOW or type == ___MOD._WeaponType.CLAW or type == ___MOD._WeaponType.GUN then
      isShoot = true
    end
    if ___MOD._AranLogic:tryReserveAranCommandSkill(user, basicAttackPressed) then
      return
    end
    local attackResult = ___MOD._PlayerAttackLogic:tryPlayerAttack(user, 0, 0, not isShoot, 0.0)
    if attackResult then
      ___MOD._AranLogic:recordBasicAttack(user, ___MOD._UtilLogic.ServerElapsedSeconds)
    end
  end
end

function PlayerKeyActionFunction.onCashshop(self)

end

function PlayerKeyActionFunction.onChat(self)
  local user = ___MOD._UserService.LocalPlayer
  if user ~= nil and (user.CashShopComponent ~= nil and user.CashShopComponent.inCashShop or user.AuctionComponent ~= nil and user.AuctionComponent.inAuction) then
    return
  end
  ___MOD._ChatLogic:activateChatField()
end

function PlayerKeyActionFunction.onChatNPC(self)
  local user = ___MOD._UserService.LocalPlayer
  if user ~= nil and (user.CashShopComponent ~= nil and user.CashShopComponent.inCashShop or user.AuctionComponent ~= nil and user.AuctionComponent.inAuction) then
    return
  end
  local udc = user.UtilDlgComponent
  local s = ___MOD._PlayerKeyActionFunction
  if not udc:isRunning() then
    local userPos = user.TransformComponent:WorldPositionAsFastVector3()
    local circle = ___MOD.CircleShape(userPos:ToVector2(), 2)
    local simulator = ___MOD._CollisionService:GetSimulator(user)
    s._T.overlap = {}
    local overlap = s._T.overlap
    local count = simulator:OverlapAllFast("NPC_Dc", circle, overlap)
    local nearNpc
    if 0 < count then
      local nearDst = ___MOD.math.huge
      for i = 1, #overlap do
        local t = overlap[i]
        local e = t.Entity
        local npc = e.ExtendNpcComponent
        local isSummonTest = ___MOD.isvalid(e.SummonComponent) and e.SummonComponent.nSkillID == 10001013
        if not isSummonTest and ___MOD.isvalid(npc) and t.EnableInHierarchy and e.Visible and not npc.template.talkMouseOnly then
          if 1 < count then
            local npcPos = e.TransformComponent:WorldPositionAsFastVector3()
            local dx, dy = userPos.x - npcPos.x, userPos.y - npcPos.y
            local dst = dx * dx + dy + dy
            if nearDst > dst then
              nearNpc = npc
              nearDst = dst
            end
          else
            nearNpc = npc
          end
        end
      end
    end
    if nearNpc then
      nearNpc:onTouch()
      return
    end
  end
  udc.skipTypingEffect = true
  udc:onNpcTalkButton()
end

function PlayerKeyActionFunction.onChatPlus(self)
  if ___MOD._ChatLogic:toggleMobileChatBoard(false) then
    return
  end
  local e = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Chat")
  if e ~= nil and e.ChatLogComponent ~= nil and e.ChatLogComponent.isMini then
    local chatText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/StatusBar/base/chatText")
    if chatText ~= nil and chatText.TextInputComponent ~= nil then
      local isMiniTextInputOpened = chatText.Enable == true
      local isMiniTextInputFocused = chatText.TextInputComponent.IsFocused
      if isMiniTextInputOpened and not isMiniTextInputFocused then
        e.ChatLogComponent:activateChatTextField(false)
        return
      end
    end
  end
  e.ChatLogComponent:switchMode()
end

function PlayerKeyActionFunction.onDps(self)
  local mini = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterSmall")
  local meter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeter")
  local bigMeter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterBig")
  if ___MOD.isvalid(bigMeter) and bigMeter.Enable then
    ___MOD._UIWindowLogic:enableUI(bigMeter)
    bigMeter.Visible = false
    return
  end
  if ___MOD.isvalid(meter) and meter.Enable then
    ___MOD._Dojang:openDojoDamageMeterBigClient()
    return
  end
  if ___MOD.isvalid(mini) and mini.Enable then
    ___MOD._Dojang:openDojoDamageMeterSmallClient()
    return
  end
  ___MOD._Dojang:openDojoDamageMeterMiniClient()
end

function PlayerKeyActionFunction.onEmotion(self, type)
  local user = ___MOD._UserService.LocalPlayer
  user.Player:emote(user, type)
end

function PlayerKeyActionFunction.onEquip(self)
  local e = ___MOD._EntityService:GetEntity("f32867c8-1d50-4a8d-a942-04ff709497d4")
  if ___MOD._AranLogic:isBlockedIntroWindow("Equipment") and not e.Enable then
    return
  end
  ___MOD._UIWindowLogic:enableUI(e)
end

function PlayerKeyActionFunction.onExpedition(self)

end

function PlayerKeyActionFunction.onFindParty(self)

end

function PlayerKeyActionFunction.onFriend(self)
  ___MOD._UserListUILogic:showUI("Friend")
end

function PlayerKeyActionFunction.onGuild(self)
  ___MOD._UserListUILogic:showUI("Guild")
end

function PlayerKeyActionFunction.onInventory(self)
  local e = ___MOD._EntityService:GetEntity("12f881d4-d93b-4865-86ca-2d1e74164581")
  if ___MOD._AranLogic:isBlockedIntroWindow("Inventory") and not e.Enable then
    return
  end
  ___MOD._UIWindowLogic:enableUI(e)
end

function PlayerKeyActionFunction.onJump(self)
  ___MOD._PlayerSkillLogic:tryDoubleJump(___MOD._UserService.LocalPlayer, false)
end

function PlayerKeyActionFunction.onKeyconfig(self)
  local e = ___MOD._EntityService:GetEntity("6ce18a6f-b9fe-486f-8d2b-abd7e3efefec")
  ___MOD._UIWindowLogic:enableUI(e)
end

function PlayerKeyActionFunction.onLoot(self)
  ___MOD._DropItemLogic:tryPickupDrop()
end

function PlayerKeyActionFunction.onMedal(self)

end

function PlayerKeyActionFunction.onMenu(self, byEsc)
  local user = ___MOD._UserService.LocalPlayer
  local auctionBlocked = user ~= nil and user.AuctionComponent ~= nil and (user.AuctionComponent.inAuction == true or user.AuctionComponent:isAuctionOpenPendingClient())
  if user ~= nil and auctionBlocked then
    return
  end
  if byEsc and user ~= nil and user.CashShopComponent ~= nil and user.CashShopComponent.inCashShop then
    return
  end
  local observerDesktop = ___MOD._ObserverUtilLogic ~= nil and ___MOD._ObserverUtilLogic:IsObserverDesktopUIActive()
  if ___MOD.isvalid(user) and user.Player ~= nil and user.Player:isMobileUIPlatform() and not observerDesktop then
    if byEsc and ___MOD._UIWindowLogic:closeMobileUIByPriority() then
      return
    end
    local mobileMenu = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileMenu")
    if ___MOD.isvalid(mobileMenu) and mobileMenu.UIMobileMenu ~= nil then
      if byEsc then
        mobileMenu.UIMobileMenu:onClickMobileMenu()
      else
        mobileMenu.UIMobileMenu:toggleMobileMenu()
      end
    end
    return
  end
  local shortcut = ___MOD._EntityService:GetEntity("e6ddb17d-c7c7-410a-b4bf-22d861e72b32")
  if shortcut.Enable then
    shortcut.CanvasGroupComponent.GroupAlpha = 0
    shortcut.Enable = false
    local pa = ___MOD.isvalid(user) and user.PlayerActionComponent or nil
    if pa ~= nil then
      pa:setUIControlLock(___MOD._ControllEnableType.ShortCut, false)
    end
    local tween = ___MOD._PlayerKeyActionFunction._T.shortcutTween
    if tween then
      tween:Destroy()
      ___MOD._PlayerKeyActionFunction._T.shortcutTween = nil
    end
  end
  local menu = ___MOD._EntityService:GetEntity("636a407f-147d-4f58-b238-94dd77900777")
  if menu.Enable then
    menu.CanvasGroupComponent.GroupAlpha = 0
    menu.Enable = false
    local pa = ___MOD.isvalid(user) and user.PlayerActionComponent or nil
    if pa ~= nil then
      pa:setUIControlLock(___MOD._ControllEnableType.GameMenu, false)
    end
    local tween = ___MOD._PlayerKeyActionFunction._T.menuTween
    if tween then
      tween:Destroy()
      ___MOD._PlayerKeyActionFunction._T.menuTween = nil
    end
  else
    if byEsc then
      local worldMap = ___MOD._EntityService:GetEntity("fcddd1e0-9c8a-45d6-b526-2f854044c088")
      if worldMap ~= nil and worldMap.EnabledInHierarchy then
        return
      end
    end
    ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.DlgNotice"), 1)
    menu.Enable = true
    local pa = ___MOD.isvalid(user) and user.PlayerActionComponent or nil
    if pa ~= nil then
      pa:setUIControlLock(___MOD._ControllEnableType.GameMenu, true)
      pa:stopInteractionMovementClient(user)
    end
    if menu.GameMenuComponent ~= nil then
      menu.GameMenuComponent:initializeKeyboardSelection()
    end
    ___MOD._PlayerKeyActionFunction._T.menuTween = ___MOD._TweenLogic:PlayTween(0, 1, 0.2, ___MOD.EaseType.Linear, function(v)
      menu.CanvasGroupComponent.GroupAlpha = v
    end)
    ___MOD._PlayerKeyActionFunction._T.menuTween:SetOnEndCallback(function()
      ___MOD._PlayerKeyActionFunction._T.menuTween = nil
    end)
  end
end

function PlayerKeyActionFunction.onMessenger(self)

end

function PlayerKeyActionFunction.onMinimap(self)
  ___MOD._UIMiniMap:onMinimapKey()
end

function PlayerKeyActionFunction.onMobileChatNPC(self)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  if user ~= nil and (user.CashShopComponent ~= nil and user.CashShopComponent.inCashShop or user.AuctionComponent ~= nil and user.AuctionComponent.inAuction) then
    return
  end
  local udc = user.UtilDlgComponent
  local s = ___MOD._PlayerKeyActionFunction
  if not udc:isRunning() then
    local userPos = user.TransformComponent:WorldPositionAsFastVector3()
    local circle = ___MOD.CircleShape(userPos:ToVector2(), 2)
    local simulator = ___MOD._CollisionService:GetSimulator(user)
    s._T.mobileNpcOverlap = {}
    local overlap = s._T.mobileNpcOverlap
    local count = simulator:OverlapAllFast("NPC_Dc", circle, overlap)
    local nearNpc
    if 0 < count then
      local nearDst = ___MOD.math.huge
      for i = 1, #overlap do
        local t = overlap[i]
        local e = t.Entity
        local npc = e.ExtendNpcComponent
        local isSummonTest = ___MOD.isvalid(e.SummonComponent) and e.SummonComponent.nSkillID == 10001013
        if not isSummonTest and ___MOD.isvalid(npc) and t.EnableInHierarchy and e.Visible and not npc.template.talkMouseOnly then
          if 1 < count then
            local npcPos = e.TransformComponent:WorldPositionAsFastVector3()
            local dx, dy = userPos.x - npcPos.x, userPos.y - npcPos.y
            local dst = dx * dx + dy + dy
            if nearDst > dst then
              nearNpc = npc
              nearDst = dst
            end
          else
            nearNpc = npc
          end
        end
      end
    end
    if nearNpc then
      nearNpc:onMobileShortcutTouch()
      return
    end
  end
  udc.skipTypingEffect = true
  udc:onNpcTalkButton()
end

function PlayerKeyActionFunction.onMonsterbook(self)

end

function PlayerKeyActionFunction.onNotification(self)
  ___MOD._UserService.LocalPlayer.QuestComponent:toggleQuestAlram()
end

function PlayerKeyActionFunction.onParty(self)
  ___MOD._UserListUILogic:showUI("Party")
end

function PlayerKeyActionFunction.onQuest(self)
  local e = ___MOD._EntityService:GetEntity("51a6a73e-b746-4fca-b347-91050575c75f")
  ___MOD._UIWindowLogic:enableUI(e)
end

function PlayerKeyActionFunction.onQuickslot(self)

end

function PlayerKeyActionFunction.onShortCut(self)
  local user = ___MOD._UserService.LocalPlayer
  if user ~= nil and (user.CashShopComponent ~= nil and user.CashShopComponent.inCashShop or user.AuctionComponent ~= nil and user.AuctionComponent.inAuction) then
    return
  end
  local observerDesktop = ___MOD._ObserverUtilLogic ~= nil and ___MOD._ObserverUtilLogic:IsObserverDesktopUIActive()
  if ___MOD.isvalid(user) and user.Player ~= nil and user.Player:isMobileUIPlatform() and not observerDesktop then
    local mobileShortcut = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileShortcutMenu")
    if ___MOD.isvalid(mobileShortcut) and mobileShortcut.UIMobileShortcutMenu ~= nil then
      mobileShortcut.UIMobileShortcutMenu:toggleMobileShortcut()
    end
    return
  end
  local shortCut = ___MOD._EntityService:GetEntity("e6ddb17d-c7c7-410a-b4bf-22d861e72b32")
  local menu = ___MOD._EntityService:GetEntity("636a407f-147d-4f58-b238-94dd77900777")
  if menu.Enable then
    local pa = ___MOD.isvalid(user) and user.PlayerActionComponent or nil
    if pa ~= nil then
      pa:setUIControlLock(___MOD._ControllEnableType.GameMenu, false)
    end
    menu.CanvasGroupComponent.GroupAlpha = 0
    menu.Enable = false
    local tween = ___MOD._PlayerKeyActionFunction._T.menuTween
    if tween then
      tween:Destroy()
      ___MOD._PlayerKeyActionFunction._T.menuTween = nil
    end
  end
  if shortCut.Enable then
    local pa = ___MOD.isvalid(user) and user.PlayerActionComponent or nil
    if pa ~= nil then
      pa:setUIControlLock(___MOD._ControllEnableType.ShortCut, false)
    end
    shortCut.CanvasGroupComponent.GroupAlpha = 0
    shortCut.Enable = false
    local tween = ___MOD._PlayerKeyActionFunction._T.shortcutTween
    if tween then
      tween:Destroy()
      ___MOD._PlayerKeyActionFunction._T.shortcutTween = nil
    end
  else
    ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.MenuUp"), 1)
    shortCut.Enable = true
    local pa = ___MOD.isvalid(user) and user.PlayerActionComponent or nil
    if pa ~= nil then
      pa:setUIControlLock(___MOD._ControllEnableType.ShortCut, true)
    end
    if ___MOD.isvalid(user) and user.ShortCutComponent ~= nil then
      user.ShortCutComponent:initializeKeyboardSelection()
    end
    ___MOD._PlayerKeyActionFunction._T.shortcutTween = ___MOD._TweenLogic:PlayTween(0, 1, 0.2, ___MOD.EaseType.Linear, function(v)
      shortCut.CanvasGroupComponent.GroupAlpha = v
    end)
    ___MOD._PlayerKeyActionFunction._T.shortcutTween:SetOnEndCallback(function()
      ___MOD._PlayerKeyActionFunction._T.shortcutTween = nil
    end)
  end
end

function PlayerKeyActionFunction.onSit(self)
  local lastSent = ___MOD._PlayerKeyActionFunction._T.lastSentSit or 0
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if now <= lastSent + 0.5 then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local player = user.Player
  local temporary = user.PlayerTemporaryStatComponent
  local state = user.StateComponent
  local rv = user.RigidbodyComponent.RealMoveVelocity
  local pa = user.PlayerActionComponent
  if pa.isClimbing then
    return
  end
  if player:isDead() then
    return
  elseif temporary:getValue(___MOD._CTS.Stun) ~= 0 or temporary:getValue(___MOD._CTS.Attract) ~= 0 or temporary:getValue(___MOD._CTS.Morph) ~= 0 then
    return
  elseif pa:isOnTamingMob() then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "길들인 몬스터 탑승 중에는 할 수 없습니다.")
    ___MOD._PlayerKeyActionFunction._T.lastSentSit = now
    return
  elseif pa.isAlert or rv.x ~= 0 or rv.y ~= 0 then
    return
  end
  if pa.sitting then
    pa:userSitRequest(-1)
  else
    local mapInfo = user.CurrentMap.MapInfoComponent
    local seatIdx = mapInfo:findSeatByPosition(user)
    if 0 < seatIdx then
      pa:userSitRequest(seatIdx)
    else
      local inventory = user.CInventoryComponent
      local portableChairItemID = inventory:findPortableChairItem()
      if 0 < portableChairItemID then
        pa:userPortableChairSitRequest(portableChairItemID)
      end
    end
  end
  ___MOD._PlayerKeyActionFunction._T.lastSentSit = ___MOD._UtilLogic.ElapsedSeconds
end

function PlayerKeyActionFunction.onSkill(self)
  local user = ___MOD._UserService.LocalPlayer
  if user ~= nil and (user.CashShopComponent ~= nil and user.CashShopComponent.inCashShop or user.AuctionComponent ~= nil and user.AuctionComponent.inAuction) then
    return
  end
  local e = ___MOD._EntityService:GetEntity("57df9c41-a31d-4719-b17e-fa5d5c662f0d")
  if ___MOD._AranLogic:isBlockedIntroWindow("Skill") and not e.Enable then
    return
  end
  ___MOD._UIWindowLogic:enableUI(e)
end

function PlayerKeyActionFunction.onToAll(self)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToALL)
end

function PlayerKeyActionFunction.onToAlliance(self)

end

function PlayerKeyActionFunction.onToChannel(self)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToChannel)
end

function PlayerKeyActionFunction.onToFriend(self)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToFriends)
end

function PlayerKeyActionFunction.onToGuild(self)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToGuild)
end

function PlayerKeyActionFunction.onToParty(self)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToParty)
end

function PlayerKeyActionFunction.onWhisper(self)
  if ___MOD._ChatLogic:tryOpenMobileChatBoardWithTarget(___MOD._ChatTargetType.Whisper) then
    return
  end
  ___MOD._ChatLogic:showWhisperUI()
end

function PlayerKeyActionFunction.onWorldmap(self)
  local worldMap = ___MOD._EntityService:GetEntity("fcddd1e0-9c8a-45d6-b526-2f854044c088")
  if ___MOD._AranLogic:isBlockedIntroWindow("WorldMap") then
    if worldMap.Enable then
      ___MOD._WorldMapManager:closeWorldMap()
    end
    return
  end
  local currentMap = ___MOD._MapUtils:getMapIdByName(___MOD._UserService.LocalPlayer.CurrentMapName)
  if currentMap == nil then
    return
  end
  local worldMapImg = ___MOD._MapManager.worldMapImgNameCache[currentMap]
  if worldMapImg ~= nil then
    if worldMap.Enable then
      ___MOD._WorldMapManager:closeWorldMap()
    else
      ___MOD._WorldMapManager:showWorldMap(worldMapImg)
      ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.MenuUp"), 1)
    end
  else
    ___MOD._UINotice:showAlertUI("현재 월드맵 보기가 지원되지 않는 맵에 있습니다.")
  end
end
