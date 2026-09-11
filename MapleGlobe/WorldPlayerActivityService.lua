

function WorldPlayerActivityService.adminItemRemoveUlid(self, equipInfo)

end

function WorldPlayerActivityService.applyEnterControlToClient(self, canEnterDailyGift, canEnterMaker, canEnterDelivery, canEnterGuild)
  if canEnterDailyGift == false then
    local dailyGift = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/DailyGift")
    if ___MOD.isvalid(dailyGift) and dailyGift.Enable then
      ___MOD._UIWindowLogic:enableUI(dailyGift)
    end
  end
  if canEnterMaker == false then
    local maker = ___MOD._UIWindowLogic:getUI("Maker")
    if ___MOD.isvalid(maker) and maker.Enable then
      if maker.MakerUIComponent ~= nil then
        maker.MakerUIComponent:onBtCancel()
      else
        ___MOD._UIWindowLogic:setUI("Maker", nil)
        maker:Destroy()
      end
    end
  end
  if canEnterDelivery == false then
    local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
    if ___MOD.isvalid(delivery) and delivery.Enable then
      ___MOD._UIWindowLogic:enableUI(delivery)
    end
  end
  if canEnterGuild == false then
    local userList = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList")
    if ___MOD.isvalid(userList) and userList.Enable and ___MOD._UserListUILogic ~= nil and ___MOD._UserListUILogic.currentTab == "Guild" then
      ___MOD._UIWindowLogic:enableUI(userList)
    end
    local guildSkill = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildSkill")
    if ___MOD.isvalid(guildSkill) and guildSkill.Enable then
      guildSkill:SetEnable(false)
    end
  end
end

function WorldPlayerActivityService.closeWebLogoutBlockingUIClient(self, user)
  if not ___MOD.isvalid(user) then
    return
  end
  if user.CashShopComponent ~= nil and user.CashShopComponent.inCashShop == true then
    user.CashShopComponent:closeCashShopUIClient()
  else
    local cashShopGroup = ___MOD._EntityService:GetEntityByPath("/ui/CashShopGroup")
    if cashShopGroup ~= nil then
      cashShopGroup:SetEnable(false)
    end
  end
  if user.AuctionComponent ~= nil and user.AuctionComponent.inAuction == true then
    user.AuctionComponent:closeAuctionUIClient()
  else
    local auctionGroup = ___MOD._EntityService:GetEntityByPath("/ui/ITCUIGroup")
    if auctionGroup ~= nil then
      auctionGroup:SetEnable(false)
    end
  end
end

function WorldPlayerActivityService.enqueue(self, type, msg, senderPlayerId, senderName, receiverPlayerId, receiverName, msg2)

end

function WorldPlayerActivityService.findAdminTargetUser(self, playerId, accountId)

end

function WorldPlayerActivityService.flush(self)

end

function WorldPlayerActivityService.getFriendReceivers(self, users, friendName)

end

function WorldPlayerActivityService.getMegaphoneChannelTag(self, channel)

end

function WorldPlayerActivityService.handleDeliveryArrived(self, t)

end

function WorldPlayerActivityService.handleEffectConsumeItem(self, t, u)

end

function WorldPlayerActivityService.handleFriendChat(self, t, u)

end

function WorldPlayerActivityService.handleFriendRequest(self, t)

end

function WorldPlayerActivityService.handleGuildChat(self, t, u)

end

function WorldPlayerActivityService.handleInviteFriend(self, t)

end

function WorldPlayerActivityService.handleInviteParty(self, t)

end

function WorldPlayerActivityService.handleMegaphone(self, t, u)

end

function WorldPlayerActivityService.handlePartyJobUpdate(self, t, p)

end

function WorldPlayerActivityService.handlePartyLevelUpdate(self, t, p)

end

function WorldPlayerActivityService.handlePartyRequest(self, t, p)

end

function WorldPlayerActivityService.handlePlayerLogin(self, t, u)

end

function WorldPlayerActivityService.handlePlayerLogout(self, t, u)

end

function WorldPlayerActivityService.handleResponse(self, response)

end

function WorldPlayerActivityService.handleScrollNotice(self, t, u)

end

function WorldPlayerActivityService.handleToMessage(self, t)

end

function WorldPlayerActivityService.handleWebAdminAccountInfoUpdate(self, t)

end

function WorldPlayerActivityService.handleWebAdminItemInfoUpdate(self, t)

end

function WorldPlayerActivityService.handleWebAdminItemRemove(self, t)

end

function WorldPlayerActivityService.handleWebBanScripts(self, t)

end

function WorldPlayerActivityService.handleWebChatBan(self, t)

end

function WorldPlayerActivityService.handleWebDeliveryArrived(self, t)

end

function WorldPlayerActivityService.handleWebEnterControl(self, t)

end

function WorldPlayerActivityService.handleWebJailUser(self, t)

end

function WorldPlayerActivityService.handleWebKick(self, t)

end

function WorldPlayerActivityService.handleWebLogoutAll(self, t)

end

function WorldPlayerActivityService.handleWebMacroAdminUpdate(self, t)

end

function WorldPlayerActivityService.handleWebMacroQuestion(self, t)

end

function WorldPlayerActivityService.handleWebMoveInstance(self, t, u)

end

function WorldPlayerActivityService.handleWebMoveMap(self, t)

end

function WorldPlayerActivityService.handleWebNotice(self, t, u)

end

function WorldPlayerActivityService.handleWebReloadPlayerLocker(self, t)

end

function WorldPlayerActivityService.handleWebReloadShopReward(self, t)

end

function WorldPlayerActivityService.handleWebServerRate(self, t)

end

function WorldPlayerActivityService.isBlackListBlocked(self, receiverUser, senderName)

end

function WorldPlayerActivityService.isMegaphoneChatLogBlocked(self, receiverUser)

end

function WorldPlayerActivityService.nextActivityDedupeKey(self, type, senderPlayerId)

end

function WorldPlayerActivityService.OnBeginPlay(self)

end

function WorldPlayerActivityService.OnEndPlay(self)

end

function WorldPlayerActivityService.prepareReturnToTitleFromWebClient(self, user)
  if not ___MOD.isvalid(user) then
    return
  end
  ___MOD._PlayerKeyActionFunction:onMenu(true)
  if ___MOD._UseItemManager ~= nil then
    ___MOD._UseItemManager:detectMacroForceFailByLogout()
  end
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if ___MOD.isvalid(delivery) and delivery.EnabledInHierarchy then
    ___MOD._DeliveryLogic:cancelSendDraft()
    delivery:SetEnable(false)
  end
end

function WorldPlayerActivityService.removeAdminEquipmentItemBySlotUlid(self, user, slot, subSlot, ulid)

end

function WorldPlayerActivityService.removeAdminInventoryItemBySlotUlid(self, user, invType, slotIndex, ulid)

end

function WorldPlayerActivityService.removeAdminStorageItemBySlotUlid(self, accountId, invType, slotIndex, ulid)

end

function WorldPlayerActivityService.requestReturnToTitleFromWeb(self)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) then
    return
  end
  self:closeWebLogoutBlockingUIClient(user)
  self:prepareReturnToTitleFromWebClient(user)
  if user.CurrentMapName == "LoadingMap" then
    ___MOD._LoginLogic:initLogin(user.PlayerComponent.Nickname, user.PlayerComponent.ProfileCode, true)
    return
  end
  self:returnToTitleFromWebClient()
end

function WorldPlayerActivityService.restoreUnifiedQueue(self, batchMsgs)

end

function WorldPlayerActivityService.returnToTitleFromWebClient(self)
  if ___MOD._ServerConstants.Use_MSW_Fade then
    self._T.webLogoutFadeOutEvent = ___MOD._ScreenTransitionService:ConnectEvent(___MOD.FadeOutEndEvent, function()
      ___MOD._CameraService:ZoomTo(160, 0)
      ___MOD._ScreenTransitionService:DisconnectEvent(___MOD.FadeOutEndEvent, self._T.webLogoutFadeOutEvent)
    end)
    ___MOD._PlayerDataLogic:returnToTitleFromClient()
  elseif ___MOD._UILoading ~= nil then
    ___MOD._UILoading:loadingFadeOut(0.5, function()
      ___MOD._PlayerDataLogic:returnToTitleFromClient()
    end)
  else
    ___MOD._PlayerDataLogic:returnToTitleFromClient()
  end
end

function WorldPlayerActivityService.takeUnifiedPayload(self)

end

function WorldPlayerActivityService.worldBroadcastEffectConsumeItem(self, fieldID, itemID)

end
