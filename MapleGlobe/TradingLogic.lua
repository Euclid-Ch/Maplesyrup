

function TradingLogic.acceptedOtherClient(self)
  if not ___MOD.isvalid(self.tradingRoom) then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local other = user.TradingComponent.other
  if not ___MOD.isvalid(other) then
    return
  end
  if not ___MOD.isvalid(other.Player) then
    return
  end
  self.tradingRoom.TradingRoomUIComponent:acceptedOther(other)
end

function TradingLogic.applyTradingUIPositions(self)
  if ___MOD.isvalid(self.tradingRoom) and ___MOD.isvalid(self.tradingRoom.UITransformComponent) then
    self.tradingRoom.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-232, -11)
  end
  local inventory = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Inventory")
  if ___MOD.isvalid(inventory) and ___MOD.isvalid(inventory.UITransformComponent) then
    if inventory.Enable ~= true then
      ___MOD._UIWindowLogic:enableUI(inventory)
    end
    inventory.UITransformComponent.anchoredPosition = ___MOD.FastVector2(507, 174)
  end
end

function TradingLogic.canReceiveTradeOnlyItems(self, receiver, tradeItems)

end

function TradingLogic.chatClient(self, senderIsMe, text)
  if not ___MOD.isvalid(self.tradingRoom) then
    return
  end
  self.tradingRoom.TradingChatComponent:addChat(senderIsMe, text)
end

function TradingLogic.createTradingRoomClient(self)
  if ___MOD.isvalid(self.tradingRoom) then
    self:applyTradingUIPositions()
    ___MOD._UserService.LocalPlayer.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.Trading, true)
    ___MOD._UserService.LocalPlayer.PlayerActionComponent:stopInteractionMovementClient(___MOD._UserService.LocalPlayer)
    ___MOD._DropItemLogic:setPickupEnabled(false)
    return
  end
  local model = ___MOD._EntryService:GetModelIdByName("Model_TradingRoom")
  self.tradingRoom = ___MOD._SpawnService:SpawnByModelId(model, "TradingRoom", ___MOD.FastVector3.zero:Clone(), ___MOD._EntityService:GetEntityByPath("/ui/UIGroup"))
  self:applyTradingUIPositions()
  ___MOD._UserService.LocalPlayer.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.Trading, true)
  ___MOD._UserService.LocalPlayer.PlayerActionComponent:stopInteractionMovementClient(___MOD._UserService.LocalPlayer)
  ___MOD._DropItemLogic:setPickupEnabled(false)
end

function TradingLogic.doTrade(self, user1, user2)

end

function TradingLogic.getValidTradeOther(self, user)

end

function TradingLogic.hasExpiredTradeItem(self, tradeItems)

end

function TradingLogic.hasExpireSoonTradeItem(self, tradeItems)

end

function TradingLogic.invitedTradeClient(self, inviterName)
  local msg = ___MOD.string.format("'%s' 님의\n교환신청 입니다.", inviterName)
  ___MOD._FadeYesNo:createFadeYesNo(1, 2, false, msg, nil, function(result)
    self:tryAcceptTrade(result)
  end, 1, nil, "trade_invite_" .. inviterName)
end

function TradingLogic.inviteTrade(self, name)
  local user = ___MOD._UserService.LocalPlayer
  local player = user.Player
  if user.TradingComponent.isTrading then
    return
  end
  if name == player.Name then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "캐릭터를 찾을 수 없습니다.")
    return
  end
  local found = false
  for userId, user in ___MOD.pairs(___MOD._UserService.UserEntities) do
    if user.Player.Name == name then
      found = true
      break
    end
  end
  if not found then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "캐릭터를 찾을 수 없습니다.")
    return
  end
  user.TradingComponent.isTrading = true
  self:inviteTradeToServer(name)
end

function TradingLogic.inviteTradeToServer(self, name, senderUserId)

end

function TradingLogic.isOnlyItem(self, itemId)

end

function TradingLogic.isTradeItemExpired(self, itemStack)

end

function TradingLogic.isTradeItemExpireSoon(self, itemStack)

end

function TradingLogic.isTradePetItem(self, itemStack)

end

function TradingLogic.leaveTrade(self, user, type, meso)

end

function TradingLogic.leaveTradingRoomClient(self, msgType, meso)
  local hasTradingRoom = ___MOD.isvalid(self.tradingRoom)
  if not hasTradingRoom and msgType == ___MOD._TradingMsgType.OTHER_CANCEL then
    ___MOD._UserService.LocalPlayer.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.Trading, false)
    ___MOD._DropItemLogic:setPickupEnabled(true)
    return
  end
  local msg
  if msgType == ___MOD._TradingMsgType.OTHER_CANCEL then
    msg = "상대방이 교환을 취소했습니다."
  elseif msgType == ___MOD._TradingMsgType.NOT_ENOUGH_SLOT then
    msg = "인벤토리 공간이 부족하여 교환에 실패했습니다."
  elseif msgType == ___MOD._TradingMsgType.UNIQUE_LIMIT_EXCEEDED then
    msg = "고유 아이템의 소지 한도를 초과하여 거래를 실패했습니다."
  elseif msgType == ___MOD._TradingMsgType.COMPLETE_TRADE then
    msg = "교환이 성사되었습니다.\r\n결과를 확인해 주세요."
  elseif msgType == ___MOD._TradingMsgType.COMPLETE_TRADE_WITH_MESO then
    meso = meso or 0
    local meso_forat_thousands = ___MOD._MathUtils:format_thousands_for(meso)
    msg = ___MOD.string.format("교환이 성사되었습니다.\r\n수수료를 제외하고 %s메소를\r\n받았습니다. 결과를 확인해 주세요.", meso_forat_thousands)
  end
  if msg then
    ___MOD._UINotice:showAlertUI(msg)
  end
  if ___MOD.isvalid(self.tradingRoom) then
    if self.tradingRoom.TradingRoomUIComponent ~= nil then
      self.tradingRoom.TradingRoomUIComponent:hideItemTooltips()
    end
    self.tradingRoom:Destroy()
    self.tradingRoom = nil
  end
  ___MOD._UserService.LocalPlayer.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.Trading, false)
  ___MOD._DropItemLogic:setPickupEnabled(true)
end

function TradingLogic.makeTradeSessionId(self)

end

function TradingLogic.resetTradeInvitePendingClient(self)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or user.TradingComponent == nil then
    return
  end
  if user.TradingComponent.accepted == false then
    user.TradingComponent.isTrading = false
  end
end

function TradingLogic.setItemClient(self, other, tdSlot, itemStack)
  if not ___MOD.isvalid(self.tradingRoom) then
    return
  end
  self.tradingRoom.TradingRoomUIComponent:setSlotItem(other, tdSlot, itemStack)
end

function TradingLogic.setMesoClient(self, other, meso)
  if not ___MOD.isvalid(self.tradingRoom) then
    return
  end
  self.tradingRoom.TradingRoomUIComponent:setMeso(other, meso)
end

function TradingLogic.setTradeOK(self, other)
  if not ___MOD.isvalid(self.tradingRoom) then
    return
  end
  self.tradingRoom.TradingRoomUIComponent:setTradeOK(other)
end

function TradingLogic.tradingFee(self, meso)
  local fee = 0.0
  if 100000 <= meso then
    fee = 0.06
  end
  return meso - ___MOD.math.floor(meso * fee / 10) * 10
end

function TradingLogic.tryAcceptTrade(self, ok, senderUserId)

end

function TradingLogic.tryAddMeso(self, meso, senderUserId)

end

function TradingLogic.tryChat(self, text, senderUserId)

end

function TradingLogic.tryLeaveTrade(self, senderUserId)

end

function TradingLogic.trySetItem(self, invType, invSlot, tdSlot, count, senderUserId)

end

function TradingLogic.tryTradeOK(self, senderUserId)

end
