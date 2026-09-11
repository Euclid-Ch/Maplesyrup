

function WorldLogService.appendAuctionRequestKey(self, entry, row)

end

function WorldLogService.appendMesoAfter(self, contents, player)

end

function WorldLogService.buildAuctionLogContents(self, row)

end

function WorldLogService.buildAuctionTargetUser(self, row)

end

function WorldLogService.buildBossPartyMembers(self, users)

end

function WorldLogService.buildDeliveryItems(self, items)

end

function WorldLogService.buildDeliveryTargetUser(self, accountId, nickname)

end

function WorldLogService.buildLogItemGainItems(self, items, omitDefaultEquipOptions, includeNegativeItems)

end

function WorldLogService.buildMakerGemEntries(self, gems)

end

function WorldLogService.buildMakerItemEntry(self, itemId, itemCount, equipInfo)

end

function WorldLogService.buildMakerRecipeEntries(self, recipeList)

end

function WorldLogService.buildPotentialReadableLogTarget(self, equipInfo)

end

function WorldLogService.buildTradeItems(self, tradeItems)

end

function WorldLogService.buildTradeOptions(self, equipInfo)

end

function WorldLogService.buildTradeParticipants(self, player1, player2)

end

function WorldLogService.buildUser(self, player)

end

function WorldLogService.enqueue(self, payload)

end

function WorldLogService.flush(self)

end

function WorldLogService.getDefaultEquipLogFlag(self, equipData)

end

function WorldLogService.getEquipReqLevelForLog(self, equipInfo)

end

function WorldLogService.getLogEquipULID(self, equipInfo)

end

function WorldLogService.getPlayerMesoAfter(self, player)

end

function WorldLogService.isAdminPlayer(self, player)

end

function WorldLogService.isDefaultEquipLogOptions(self, equipInfo)

end

function WorldLogService.logAuctionBuy(self, player, row)

end

function WorldLogService.logAuctionBuyerReward(self, player, row)

end

function WorldLogService.logAuctionCancel(self, player, row)

end

function WorldLogService.logAuctionLocker(self, player, item, action2)

end

function WorldLogService.logAuctionRegister(self, player, row)

end

function WorldLogService.logAuctionRegisterUi(self, player, action2, itemStack, quantity, price, invType, invSlot)

end

function WorldLogService.logAuctionReturn(self, player, row)

end

function WorldLogService.logAuctionSellerReward(self, player, row, rewardMeso)

end

function WorldLogService.logBoss(self, player, action, bossId, partyMembers)

end

function WorldLogService.logCashShopCharge(self, player, action2_str, itemId, itemName, chargePoint, remainingPoint, totalPoint)

end

function WorldLogService.logCashShopCoupon(self, player, couponId, couponKey, requestKey, deliveryId)

end

function WorldLogService.logCashShopLocker(self, player, item, action2)

end

function WorldLogService.logCashShopPurchase(self, player, items, usedPoint, remainingPoint, action2)

end

function WorldLogService.logCashShopRebate(self, player, item, refundPoint, remainingPoint)

end

function WorldLogService.logCashShopRefund(self, player, item)

end

function WorldLogService.logChangeChannel(self, player, id)

end

function WorldLogService.logChangeMap(self, player, prevmap)

end

function WorldLogService.logChangeMapFail(self, player, nextmap, portal)

end

function WorldLogService.logChangeNickName(self, accountid, playerid, nickname, changednickname)

end

function WorldLogService.logCharacterCreate(self, accountid, playerid, nickname)

end

function WorldLogService.logCharacterDelete(self, accountid, playerid, nickname)

end

function WorldLogService.logChat(self, player, type, chat)

end

function WorldLogService.logChatWhisper(self, player, receivername, chat)

end

function WorldLogService.logDeliveryCancel(self, player, targetid, targetname, items, meso, deliveryid)

end

function WorldLogService.logDeliveryDelete(self, player, targetid, targetname, items, meso, deliveryid, reason)

end

function WorldLogService.logDeliveryReceive(self, player, senderid, sendername, items, meso, deliveryid)

end

function WorldLogService.logDeliverySend(self, player, receiverid, receivername, items, meso, deliveryid)

end

function WorldLogService.logDeliverySendFail(self, player, receiverid, receivername, items, meso, deliveryid, reason)

end

function WorldLogService.logDeliverySendSlot(self, player, action2, slotid, itemid, itemcount, equipInfo, itemSN, remain)

end

function WorldLogService.logDojang(self, player, action_, contents_)

end

function WorldLogService.logDonationKing(self, player, seasonId, mapId, amount, total, requestKey, challengeVersion)

end

function WorldLogService.logDonationKingReview(self, playerId, playerName, seasonId, mapId, amount, requestKey, challengeVersion, deductionState, beforeMeso, afterMeso, requestStatus, responseCode, deliveryStatus, reviewReason)

end

function WorldLogService.logEquipmentChange(self, player, action2, itemId, beforeEquip, afterEquip)

end

function WorldLogService.logExternalDataAccess(self, player, action, contents)

end

function WorldLogService.logGuildAction(self, player, action2, guildId, guildName, targetPlayerId, targetName, details)

end

function WorldLogService.logHack(self, player, hackid, text)

end

function WorldLogService.logItemBook(self, player, bookItemid, action)

end

function WorldLogService.logItemDrop(self, player, items, meso, action2, sourceType, sourceId)

end

function WorldLogService.logItemFlow(self, player, logTitle, flowType, itemId, quantity, starttime, source, sourceID, itemSN, remain, equipInfo, saleId)

end

function WorldLogService.logItemFlowBatchWithContext(self, player, logTitle, flowType, items, starttime, source, sourceID, saleId, worldAction2, worldSource)

end

function WorldLogService.logItemFlowWithContext(self, player, logTitle, flowType, itemId, quantity, starttime, source, sourceID, itemSN, remain, equipInfo, saleId, worldAction2, worldSource)

end

function WorldLogService.logItemGain(self, player, items, sourceType, sourceId, meso, sourcePlayerId, sourcePlayerName)

end

function WorldLogService.logItemMiracleCube(self, player, beforeEquip, afterEquip, cubeItemId, mesoCost, cubeSessionId, cubeItemSN)

end

function WorldLogService.logItemProtect(self, player, action2, itemId, beforeEquip, afterEquip, mesoCost)

end

function WorldLogService.logItemScroll(self, player, action, beforeItem, afterItem, scrollItemId)

end

function WorldLogService.logItemUse(self, player, useItemid, action)

end

function WorldLogService.logLevelup(self, player)

end

function WorldLogService.logLogin(self, player)

end

function WorldLogService.logLogout(self, player)

end

function WorldLogService.logLogoutTry(self, player)

end

function WorldLogService.logMacro(self, player, action2)

end

function WorldLogService.logMacroByUser(self, user, action2)

end

function WorldLogService.logMaker(self, player, action2, contents)

end

function WorldLogService.logMakerCraft(self, player, action2, sourceItem, recipeItems, mesoCost, mountCatalyst, catalystItemId, gemItems, resultItems)

end

function WorldLogService.logMakerCrystal(self, player, sourceItemId, sourceItemCount, resultItemId)

end

function WorldLogService.logMakerDisassemble(self, player, sourceItemId, sourceEquipInfo, rewardItems, mesoCost)

end

function WorldLogService.logMesoPickupAgg(self, player, pickupCount, mesoAmount, startTime)

end

function WorldLogService.logMobKill(self, player, mobID, isBoss, ownerType, partyID, partyMembers)

end

function WorldLogService.logMobKillPlayerAgg(self, player, killCount, startTime)

end

function WorldLogService.logRunScript(self, player, scriptName, resolvedName, npcId, itemNpcId)

end

function WorldLogService.logSkillAttackUse(self, player, skillId, skillLevel)

end

function WorldLogService.logStorageInput(self, player, invType, itemId, itemCount, equipInfo)

end

function WorldLogService.logStorageMesoInput(self, player, amount)

end

function WorldLogService.logStorageMesoOutput(self, player, amount)

end

function WorldLogService.logStorageOutput(self, player, invType, itemId, itemCount, equipInfo)

end

function WorldLogService.logTrade(self, player, targetplayer, participants, tradeSessionId)

end

function WorldLogService.logTradeRequest(self, player, targetplayer, action, tradeSessionId)

end

function WorldLogService.logUpdateQuestEx(self, player, npcid, qid, qkey, qvalue)

end

function WorldLogService.logUpdateQuestState(self, player, npcid, qid, state)

end

function WorldLogService.logUserReport(self, player, targetname, reason, description, cost)

end

function WorldLogService.normalizeCompactEquipLogInfo(self, equipInfo)

end

function WorldLogService.normalizeItemSourceType(self, sourceType)

end

function WorldLogService.normalizeTransactionLogItemCount(self, itemId, itemCount)

end

function WorldLogService.nowIso8601(self)

end

function WorldLogService.OnBeginPlay(self)

end

function WorldLogService.OnEndPlay(self)

end

function WorldLogService.parseAuctionPayloadFromRow(self, row)

end

function WorldLogService.resolveItemFlowAction2(self, logTitle, flowType, source)

end

function WorldLogService.shouldLogTransactionItem(self, itemId, itemCount)

end

function WorldLogService.stripCompactEquipLogAliases(self, logInfo)

end

function WorldLogService.utcDateTimeTextToKST(self, utcText)

end
