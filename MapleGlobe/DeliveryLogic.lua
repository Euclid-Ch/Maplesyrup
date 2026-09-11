

function DeliveryLogic.applySendDraftSnapshotToClient(self, userId, slotSnapshot, meso)

end

function DeliveryLogic.applySendSlotClient(self, slotId, stackData)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) or delivery.DeliveryUIComponent == nil then
    return
  end
  delivery.DeliveryUIComponent:applySendSlotFromServer(slotId, stackData)
end

function DeliveryLogic.beginActionLock(self, userId)

end

function DeliveryLogic.blockDeliveryByFieldLimit(self, user)

end

function DeliveryLogic.blockDeliveryByFieldLimitClient(self)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or user.CurrentMap == nil or user.CurrentMap.MapInfoComponent == nil then
    return false
  end
  if self:isDeliveryBlockedMapId(___MOD.tonumber(user.CurrentMap.MapInfoComponent.mapID or 0) or 0) then
    ___MOD._UINotice:showAlertUI("현재 맵에서는 택배 시스템 이용이 불가능합니다.")
    return true
  end
  if not user.CurrentMap.MapInfoComponent:checkFieldLimit(___MOD._FieldLimit.ParcelOpenLimit) then
    return false
  end
  ___MOD._UINotice:showAlertUI("현재 맵에서는 택배 시스템 이용이 불가능합니다.")
  return true
end

function DeliveryLogic.buildDeliveryRequestItem(self, src)

end

function DeliveryLogic.buildDeliveryRequestSignature(self, toName, memo, meso, nodeItems)

end

function DeliveryLogic.calcDeliveryBaseCostServer(self)

end

function DeliveryLogic.calcDeliveryFeeClient(self, sendMeso)
  sendMeso = ___MOD.math.max(0, sendMeso or 0)
  if sendMeso < 100000 then
    return 0
  end
  return ___MOD.math.floor(sendMeso * 0.08 + 1.0E-4)
end

function DeliveryLogic.calcDeliveryFeeServer(self, sendMeso)

end

function DeliveryLogic.canCancelSentMailboxClient(self, node)
  if ___MOD.type(node) ~= "table" then
    return false
  end
  if (___MOD.tonumber(node.state or 0) or 0) ~= 0 then
    return false
  end
  if node.received == true then
    return false
  end
  if (___MOD.tonumber(node.receivePending or 0) or 0) == 1 then
    return false
  end
  local createAtUnix = ___MOD.math.floor(___MOD.tonumber(node.createAtUnix or 0) or 0)
  if createAtUnix <= 0 then
    return false
  end
  local elapsed = ___MOD.os.time() - createAtUnix
  if elapsed < 0 then
    elapsed = 0
  end
  return elapsed <= (self.deliveryCancelWindowSeconds or 600)
end

function DeliveryLogic.canCancelSentMailboxNode(self, node)

end

function DeliveryLogic.cancelSendDraft(self, senderUserId)

end

function DeliveryLogic.cancelSendDraftByUser(self, user)

end

function DeliveryLogic.canSendItem(self, itemStack)

end

function DeliveryLogic.clearLoginMailboxNoticeByUser(self, user)

end

function DeliveryLogic.clearPendingCancel(self, userId, deliveryId)

end

function DeliveryLogic.clearPendingReceive(self, userId, deliveryId)

end

function DeliveryLogic.clearPendingSend(self, userId)

end

function DeliveryLogic.clearSendDraftState(self, userId, sendSlots)

end

function DeliveryLogic.clearSendRequestKey(self, userId)

end

function DeliveryLogic.clearSendSlotClient(self, slotId)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) or delivery.DeliveryUIComponent == nil then
    return
  end
  delivery.DeliveryUIComponent:clearSendSlot(slotId)
end

function DeliveryLogic.clearUserRuntimeStateByUserId(self, userId, preservePendingSend)

end

function DeliveryLogic.cloneDeliveryEquipInfo(self, equipInfo)

end

function DeliveryLogic.cloneDeliveryValue(self, value)

end

function DeliveryLogic.collectDeletableMailboxDeleteIds(self, mailbox, deleteIds)

end

function DeliveryLogic.completeDeliverySendSuccess(self, user, userId, toName, requestKey, nodeItems, sendMeso, responseMsg)

end

function DeliveryLogic.copyMailboxForClient(self, mailbox)

end

function DeliveryLogic.copyMailboxNode(self, src)

end

function DeliveryLogic.copySendSlotSnapshot(self, sendSlots)

end

function DeliveryLogic.endActionLock(self, userId)

end

function DeliveryLogic.enqueueDeliveryCancelComplete(self, userId, playerName, deliveryId)

end

function DeliveryLogic.enqueueDeliveryCancelPendingReset(self, userId, playerName, deliveryId)

end

function DeliveryLogic.enqueueDeliveryCancelPrepare(self, userId, playerName, deliveryId)

end

function DeliveryLogic.enqueueDeliveryReceiveComplete(self, userId, playerName, deliveryId)

end

function DeliveryLogic.enqueueDeliveryReceivePendingReset(self, userId, playerName, deliveryId)

end

function DeliveryLogic.enqueueDeliverySendComplete(self, userId, playerName, requestKey, callback)

end

function DeliveryLogic.enqueueDeliverySendPrepare(self, userId, playerName, req, callback)

end

function DeliveryLogic.enqueueDeliverySendRollbackFailure(self, userId, playerName, requestKey, reason, pendingEntry)

end

function DeliveryLogic.enqueueDeliverySendRollbackSuccess(self, userId, playerName, requestKey, callback)

end

function DeliveryLogic.enqueueSystemDelivery(self, userId, playerName, memo, expireDays, requestKey, callback)

end

function DeliveryLogic.enqueueSystemItemDelivery(self, userId, playerName, memo, expireDays, requestKey, items, callback)

end

function DeliveryLogic.findUserByName(self, playerName)

end

function DeliveryLogic.findUserByPlayerId(self, playerId)

end

function DeliveryLogic.getCancelSentMailboxBlockMessage(self, user, node)

end

function DeliveryLogic.getCancelSentMailboxClientBlockMessage(self, node)
  if ___MOD.type(node) ~= "table" then
    return "발송 정보가 올바르지 않습니다."
  end
  local state = ___MOD.tonumber(node.state or 0) or 0
  if state == 3 and (___MOD.tonumber(node.receivePending or 0) or 0) == 1 then
    return "이미 발송 취소 처리 중인 택배입니다."
  end
  if state == 3 then
    return "이미 발송취소된 택배입니다."
  end
  if state == 2 then
    return "이미 삭제된 택배입니다."
  end
  if state == 4 then
    return "상대방이 폐기한 택배입니다."
  end
  if node.received == true or state == 1 then
    return "상대방이 이미 수령한 택배입니다."
  end
  if (___MOD.tonumber(node.receivePending or 0) or 0) == 1 then
    return "상대방이 이미 수령 처리 중인 택배입니다."
  end
  local createAtUnix = ___MOD.math.floor(___MOD.tonumber(node.createAtUnix or 0) or 0)
  if createAtUnix <= 0 then
    return "발송 시간을 확인할 수 없어 취소할 수 없습니다."
  end
  local elapsed = ___MOD.os.time() - createAtUnix
  if elapsed < 0 then
    elapsed = 0
  end
  if elapsed > (self.deliveryCancelWindowSeconds or 600) then
    return "발송 후 10분이 지난 택배는 취소할 수 없습니다."
  end
  local receiveBlockMessage = self:getReceiveMailboxClientBlockMessage(node)
  if not ___MOD._UtilLogic:IsNilorEmptyString(receiveBlockMessage) then
    return receiveBlockMessage
  end
  return ""
end

function DeliveryLogic.getDeliveryPayloadMeso(self, payload)

end

function DeliveryLogic.getExpireTextClient(self, node)
  if node == nil then
    return ""
  end
  local state = ___MOD.tonumber(node.state or 0) or 0
  local sendPending = ___MOD.tonumber(node.sendPending or 0) or 0
  if sendPending == 1 then
    return "발송중"
  end
  local pending = ___MOD.tonumber(node.receivePending or 0) or 0
  if pending == 1 then
    if state == 3 then
      return "취소중"
    end
    return "수령중"
  end
  if state == 3 then
    return "발송취소"
  end
  if state == 2 then
    return "삭제"
  end
  if state == 4 then
    return "폐기"
  end
  if node.received then
    return "수령완료"
  end
  local remainSec = (node.expireAt or 0) - ___MOD._UtilLogic.ServerElapsedSeconds
  if remainSec <= 0 then
    return "만료"
  end
  local days = ___MOD.math.max(1, ___MOD.math.ceil(remainSec / 86400))
  return ___MOD.tostring(days) .. "일"
end

function DeliveryLogic.getOrCreateSendRequestKey(self, userId, signature)

end

function DeliveryLogic.getReceiveMailboxBlockMessage(self, user, node, allowExpiredItem)

end

function DeliveryLogic.getReceiveMailboxClientBlockMessage(self, node)
  if node == nil then
    return "수령 정보가 올바르지 않습니다."
  end
  if not self:hasEnoughReceiveSpaceClient(node) then
    return "인벤토리 공간이 부족합니다."
  end
  return ""
end

function DeliveryLogic.getSendItemBlockMessage(self, itemStack)

end

function DeliveryLogic.getUserSendMeso(self, user)

end

function DeliveryLogic.getUserSendSlotItemCount(self, user, itemId)

end

function DeliveryLogic.getUserSendSlots(self, user)

end

function DeliveryLogic.grantMailboxRewards(self, user, node, deliveryId)

end

function DeliveryLogic.grantPendingDeliveryCancel(self, user, pendingEntry, deliveryId)

end

function DeliveryLogic.hasDeliveryTradeOnceItem(self, node)

end

function DeliveryLogic.hasEnoughReceiveSpace(self, user, node, preserveTransferFlag)

end

function DeliveryLogic.hasEnoughReceiveSpaceClient(self, node)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or node == nil then
    return false
  end
  local inventory = user.CInventoryComponent
  if inventory == nil then
    return false
  end
  local needs = {}
  local items = node.items
  if items ~= nil and 0 < #items then
    for i = 1, #items do
      local itemData = items[i]
      if itemData ~= nil then
        local itemId = 0
        local count = 0
        if itemData.ItemId ~= nil then
          itemId = ___MOD.tonumber(itemData.ItemId or 0) or 0
          count = ___MOD.tonumber(itemData.Count or 0) or 0
        else
          itemId = ___MOD.tonumber(itemData.itemId or 0) or 0
          count = ___MOD.tonumber(itemData.count or 0) or 0
        end
        if 0 < itemId and 0 < count then
          local invType = itemId // 1000000
          needs[invType] = (needs[invType] or 0) + 1
        end
      end
    end
  elseif 0 < (___MOD.tonumber(node.itemId or 0) or 0) and 0 < (___MOD.tonumber(node.itemCount or 0) or 0) then
    local invType = (___MOD.tonumber(node.itemId or 0) or 0) // 1000000
    needs[invType] = 1
  end
  for invType, need in ___MOD.pairs(needs) do
    local space = ___MOD.tonumber(inventory:getSpaceSlotCount(invType) or 0) or 0
    if need > space then
      return false
    end
  end
  return true
end

function DeliveryLogic.hasReceivableMailbox(self, mailbox)

end

function DeliveryLogic.isAdminDeliverySenderValue(self, value)

end

function DeliveryLogic.isDeliveryBlockedMapId(self, mapid)

end

function DeliveryLogic.isDeliveryItemExpired(self, itemStack)

end

function DeliveryLogic.isDeliveryItemExpireSoon(self, itemStack)

end

function DeliveryLogic.isDeliveryNodeItemExpired(self, node)

end

function DeliveryLogic.isDeliveryNodeItemExpireSoon(self, node)

end

function DeliveryLogic.isDeliveryPetItem(self, itemStack)

end

function DeliveryLogic.isDeliveryReceivePendingStale(self, node)

end

function DeliveryLogic.isDeliverySentByCurrentPlayer(self, user, node)

end

function DeliveryLogic.isParcelOpenLimitedByUser(self, user)
  if not ___MOD.isvalid(user) or user.CurrentMap == nil or user.CurrentMap.MapInfoComponent == nil then
    return false
  end
  if self:isDeliveryBlockedMapId(___MOD.tonumber(user.CurrentMap.MapInfoComponent.mapID or 0) or 0) then
    return true
  end
  return user.CurrentMap.MapInfoComponent:checkFieldLimit(___MOD._FieldLimit.ParcelOpenLimit)
end

function DeliveryLogic.logDeliverySendFailure(self, user, pendingEntry, reason, deliveryId)

end

function DeliveryLogic.makeDefaultDeliveryEquipInfo(self, itemId)

end

function DeliveryLogic.makeDeliveryReceiveEquipInfo(self, user, itemId, rawEquipInfo, preserveTransferFlag)

end

function DeliveryLogic.makeDeliveryTradeSN(self, deliveryId)

end

function DeliveryLogic.markDeliveryNodeDeletedByExpiredItem(self, user, node, userId)

end

function DeliveryLogic.normalizeMailboxNode(self, row, nowSec)

end

function DeliveryLogic.normalizeSentMailboxNode(self, row, nowSec)

end

function DeliveryLogic.notifyDeliverySendCompletedClient(self)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) or delivery.DeliveryUIComponent == nil then
    return
  end
  delivery.DeliveryUIComponent:onSendCompleted()
end

function DeliveryLogic.notifyDeliverySendStateUnknown(self, user, userId, message)

end

function DeliveryLogic.openDeliveryUIAfterPingClient(self)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) then
    return
  end
  ___MOD._UIWindowLogic:enableUI(delivery)
  if delivery.Enable then
    ___MOD._DeliveryLogic:requestSendSlots()
    if delivery.DeliveryUIComponent ~= nil then
      delivery.DeliveryUIComponent:onOpenDelivery()
    end
  end
end

function DeliveryLogic.openDeliveryUIClient(self)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if ___MOD.isvalid(delivery) and delivery.Enable == true then
    ___MOD._UIWindowLogic:enableUI(delivery)
    return
  end
  if ___MOD._WorldConstants.canEnterDelivery ~= true then
    ___MOD._UINotice:showAlertUI("택배 기능이 일시적으로 제한됩니다.\r\n\r\n잠시 후 다시 시도해 주세요.")
    return
  end
  if self:blockDeliveryByFieldLimitClient() then
    return
  end
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) or player.PlayerComponent == nil then
    return
  end
  self:requestOpenDeliveryUI()
end

function DeliveryLogic.parseDeliveryCreateAtUnixFromRow(self, row)

end

function DeliveryLogic.pushMailboxToClient(self, user)

end

function DeliveryLogic.receiveMailboxItem(self, user, itemData, sourceUserID, preserveTransferFlag)

end

function DeliveryLogic.recordDeliveryRemoveItemLogs(self, user, items)

end

function DeliveryLogic.recoverPendingCancelByUser(self, user, mailbox)

end

function DeliveryLogic.recoverPendingReceiveByUser(self, user, mailbox)

end

function DeliveryLogic.requestDeliverySendConfirmInfo(self, toName, memo, sendMeso, senderUserId)

end

function DeliveryLogic.requestMailbox(self, senderUserId)

end

function DeliveryLogic.requestMailboxByUser(self, user)

end

function DeliveryLogic.requestMailboxByUserInternal(self, user, showLoginNotice)

end

function DeliveryLogic.requestMailboxOnLoginByUser(self, user)

end

function DeliveryLogic.requestOpenDeliveryUI(self, senderUserId)

end

function DeliveryLogic.requestSendSlots(self, senderUserId)

end

function DeliveryLogic.requestSentMailbox(self, senderUserId)

end

function DeliveryLogic.requestSentMailboxByUser(self, user)

end

function DeliveryLogic.requestSentMailboxByUserInternal(self, user)

end

function DeliveryLogic.restoreDeliveryNodeToInventory(self, user, node, preserveTransferFlag)

end

function DeliveryLogic.restorePendingSendDraftByEntry(self, user, pendingEntry)

end

function DeliveryLogic.rollbackPendingSendByUser(self, userId, playerName, fallbackUser, alertMessage)

end

function DeliveryLogic.sendDeliveryItemTradeLogs(self, tradeSN, senderUserID, receiverUserID, moveType, items)

end

function DeliveryLogic.sendDeliveryNodeTradeLogs(self, tradeSN, senderUserID, receiverUserID, moveType, node, meso)

end

function DeliveryLogic.serializeDeliveryItemStack(self, stack)

end

function DeliveryLogic.setDeliveryInteractionBlockedClient(self, blocked)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) or delivery.DeliveryUIComponent == nil then
    return
  end
  delivery.DeliveryUIComponent:setRequestInteractionBlocked(blocked)
end

function DeliveryLogic.setMailboxClient(self, mailbox)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) or delivery.DeliveryUIComponent == nil then
    return
  end
  delivery.DeliveryUIComponent:setMailboxFromServer(mailbox)
end

function DeliveryLogic.setSendMesoClient(self, meso)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) or delivery.DeliveryUIComponent == nil then
    return
  end
  delivery.DeliveryUIComponent:setSendMesoFromServer(meso)
end

function DeliveryLogic.setSentMailboxClient(self, mailbox)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) or delivery.DeliveryUIComponent == nil then
    return
  end
  delivery.DeliveryUIComponent:setSentMailboxFromServer(mailbox)
end

function DeliveryLogic.shouldPreserveAdminDeliveryFlag(self, node)

end

function DeliveryLogic.shouldSuppressDeliveryMeso(self, payload)

end

function DeliveryLogic.showDeliveryAlertClient(self, message)
  if message == nil or message == "" then
    return
  end
  ___MOD._UINotice:showAlertUI(message)
end

function DeliveryLogic.showDeliveryArrivedFadeYesNoClient(self, senderName)
  senderName = ___MOD.tostring(senderName or "")
  local msg = ___MOD.string.format("#e%s#n 님으로부터\r\n택배가 도착했습니다.", senderName)
  ___MOD._FadeYesNo:createFadeYesNo(1, 10, false, msg, 5, function(result)
    if result then
      self:openDeliveryUIClient()
    end
  end, ___MOD._BitmapFontAlignmentType.Center, nil, "delivery_arrived_notice_" .. senderName)
end

function DeliveryLogic.showDeliverySendConfirmClient(self, toName, receiverLevel, receiverJob, memo, sendMeso)
  self:setDeliveryInteractionBlockedClient(false)
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if not ___MOD.isvalid(delivery) or delivery.DeliveryUIComponent == nil then
    return
  end
  local baseCost = 10000
  local fee = self:calcDeliveryFeeClient(sendMeso)
  local jobName = ___MOD._PlayerConstants:getJobNameById(receiverJob)
  if jobName == nil or jobName == "" then
    jobName = ___MOD.tostring(receiverJob)
  end
  local safeToName = ___MOD._RichTextUtils:stripRichTextCommands(___MOD.tostring(toName or ""))
  local msg = ___MOD.string.format("#e닉네임 : #Y%s##n\r\n", safeToName)
  msg = msg .. ___MOD.string.format("#e레벨 : #Y%d##n\r\n", receiverLevel)
  msg = msg .. ___MOD.string.format("#e직업 : #Y%s##n\r\n\r\n", jobName)
  msg = msg .. ___MOD.string.format("#e기본 비용 : 10,000 메소#n\r\n\r\n")
  if 0 < fee then
    msg = msg .. ___MOD.string.format("#e송금 수수료 : %s 메소#n\r\n\r\n", ___MOD._MathUtils:format_thousands_for(fee))
  end
  msg = msg .. ___MOD.string.format("#e#c총 금액 : %s 메소#n#\r\n\r\n", ___MOD._MathUtils:format_thousands_for(baseCost + fee))
  msg = msg .. "택배를 발송하시겠습니까?"
  ___MOD._UINotice:showYesNoUI(msg, function(base)
    if ___MOD.isvalid(base) then
      base:Destroy()
    end
    delivery.DeliveryUIComponent.sendCooldownUntil = ___MOD._UtilLogic.ElapsedSeconds + 5
    self:trySendDelivery(toName, memo)
  end)
end

function DeliveryLogic.showReceivableMailboxFadeYesNoClient(self)
  local msg = "보관함에 수령이 가능한\r\n택배가 있습니다"
  ___MOD._FadeYesNo:createFadeYesNo(1, 10, false, msg, 5, function(result)
    if result then
      self:openDeliveryUIClient()
    end
  end, ___MOD._BitmapFontAlignmentType.Center, nil, "delivery_mailbox_notice")
end

function DeliveryLogic.tryCancelSentMailbox(self, dataIndex, senderUserId)

end

function DeliveryLogic.tryDeleteAllReceivedMailbox(self, senderUserId)

end

function DeliveryLogic.tryDeleteMailbox(self, dataIndex, senderUserId)

end

function DeliveryLogic.tryDiscardMailbox(self, dataIndex, senderUserId)

end

function DeliveryLogic.tryReceiveMailbox(self, dataIndex, senderUserId)

end

function DeliveryLogic.tryReturnSendItem(self, slotId, senderUserId)

end

function DeliveryLogic.trySendDelivery(self, toName, memo, senderUserId)

end

function DeliveryLogic.trySendDeliveryAfterPingForUser(self, requestUserId, toName, memo)

end

function DeliveryLogic.trySetSendItem(self, invType, invSlot, slotId, count, senderUserId)

end

function DeliveryLogic.trySetSendMeso(self, targetMeso, senderUserId)

end
