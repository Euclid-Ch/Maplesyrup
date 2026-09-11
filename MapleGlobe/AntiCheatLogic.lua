

function AntiCheatLogic.appendCraftMaterialEntry(self, materials, itemID, quantity)

end

function AntiCheatLogic.appendItemOptionEntry(self, options, optionType, value)

end

function AntiCheatLogic.appendNumericItemOption(self, options, optionType, value)

end

function AntiCheatLogic.appendPotentialItemOptionChanges(self, changes, beforeItem, afterItem, itemID)

end

function AntiCheatLogic.appendPotentialItemOptions(self, options, item, itemID, includeEmptyPotentialOptions)

end

function AntiCheatLogic.appendUseScrollOptionChange(self, changes, beforeItem, afterItem, optionType, key)

end

function AntiCheatLogic.applyAutoBan(self, attacker, reasonText, banCode)

end

function AntiCheatLogic.applyAutoBanDelayed(self, attacker, reasonText, banCode)

end

function AntiCheatLogic.assertForHack(self, user, hackID, data, autoban)

end

function AntiCheatLogic.buildCraftMaterialsFromExchangeList(self, exchangeList)

end

function AntiCheatLogic.buildItemOptionList(self, equipInfo, itemID, baseUpgradeCount, includeEmptyPotentialOptions)

end

function AntiCheatLogic.buildItemOptionLogString(self, equipInfo, itemID, baseUpgradeCount, includeEmptyPotentialOptions)

end

function AntiCheatLogic.buildPotentialOptionList(self, equipInfo, itemID)

end

function AntiCheatLogic.buildPotentialOptionLogString(self, equipInfo, itemID)

end

function AntiCheatLogic.buildUseScrollChangeList(self, beforeItem, afterItem, itemID, baseUpgradeCount)

end

function AntiCheatLogic.checkTeleportKill(self, attacker, mob, skillID, skillLevel)

end

function AntiCheatLogic.enqueueAutoBanRequest(self, attacker, reasonText, banCode)

end

function AntiCheatLogic.getAllowedDeadlyAttackDistance(self, attacker, skillID, skillLevel)

end

function AntiCheatLogic.getCraftItemName(self, itemID)

end

function AntiCheatLogic.getCraftItemSN(self, equipInfo)

end

function AntiCheatLogic.getItemOptionReqLevel(self, item, itemID)

end

function AntiCheatLogic.getItemOptionValue(self, item, key)

end

function AntiCheatLogic.getPotentialItemOptionValue(self, item, itemID, poKey)

end

function AntiCheatLogic.getSpeedHackExceptionDuration(self, reason)

end

function AntiCheatLogic.getSpeedHackExceptionReasonBySkill(self, skillID)

end

function AntiCheatLogic.logHack(self, user, hackID, data, isBanned, hackCount)

end

function AntiCheatLogic.normalizeItemOptionEquipInfo(self, equipInfo)

end

function AntiCheatLogic.recordUserHistory(self, userID)

end

function AntiCheatLogic.registerDeadlyAttackViolation(self, attacker, mob, skillID, skillLevel, distance, allowedDistance)

end

function AntiCheatLogic.registerPickupDistanceViolation(self, attacker, dropPos, distance, allowedDistance, pickedByPet)

end

function AntiCheatLogic.registerTeleportKillViolation(self, attacker, mob, skillID, skillLevel, lastPos, currentPos, elapsed, distance, speed)

end

function AntiCheatLogic.sendAuctionEventLog(self, eventType, saleId, requestSN, extra, user)

end

function AntiCheatLogic.sendCraftItemLog(self, craftType, result, targetItemID, targetItemQuantity, beforeEquipInfo, resultEquipInfo, materials, user)

end

function AntiCheatLogic.sendCreateCharacterLog(self, isAdmin, name, level, job, mapID, userID, playerID)

end

function AntiCheatLogic.sendCreateItemLog(self, createType, itemID, quantity, starttime, source, sourceID, user, itemSN, remain, itemOption)

end

function AntiCheatLogic.sendCreateItemLogWithSaleId(self, createType, itemID, quantity, starttime, source, sourceID, user, itemSN, remain, itemOption, saleId)

end

function AntiCheatLogic.sendDeleteCharacterLog(self, isAdmin, name, level, job, mapID, userID, playerID)

end

function AntiCheatLogic.sendDiffrentDropMapPlayerMap(self, userID, playerMapID, dropMapID)

end

function AntiCheatLogic.sendDiffrentMapID(self, userID, playerMapID, mapInfoMapID)

end

function AntiCheatLogic.sendFieldBossKillLog(self, mob, killer, userCount)

end

function AntiCheatLogic.sendHackLog(self, userID, title, detail, cnt)

end

function AntiCheatLogic.sendKeyConfigSnapshot(self, user)

end

function AntiCheatLogic.sendMapMoveLog(self, moveType, user, beforeMap, afterMap)

end

function AntiCheatLogic.sendMobJumpHackLog(self, user, mob)

end

function AntiCheatLogic.sendMSWWorldLog(self, logTitle, details, user)

end

function AntiCheatLogic.sendPotentialUpgradeLog(self, potentialType, itemID, remain, targetItemID, targetItemSN, beforeItem, afterItem, user)

end

function AntiCheatLogic.sendQuestLog(self, questID, state, user)

end

function AntiCheatLogic.sendRemoveItemLog(self, removeType, itemID, quantity, starttime, user, itemSN, remain, itemOption)

end

function AntiCheatLogic.sendRemoveItemLogWithSaleId(self, removeType, itemID, quantity, starttime, user, itemSN, remain, itemOption, saleId)

end

function AntiCheatLogic.sendScreenShotLog(self, desc)
  local result = ___MOD._AntiCheatService:SendScreenShotLog(desc)
end

function AntiCheatLogic.sendSpeedHackExceptionBySkill(self, user, skillID)

end

function AntiCheatLogic.sendSpeedHackExceptionLog(self, user, duration, reason)

end

function AntiCheatLogic.sendTradeLog(self, SN, senderUserID, receiverUserID, moveType, itemID, quantity, itemSN, remain, equipInfo)

end

function AntiCheatLogic.sendTradeLogWithSaleId(self, SN, senderUserID, receiverUserID, moveType, itemID, quantity, itemSN, remain, equipInfo, saleId)

end

function AntiCheatLogic.sendUseMoveSkillLog(self, skillID, user)

end

function AntiCheatLogic.sendUserConnectFlowLog(self, type, user)

end

function AntiCheatLogic.sendUserReportHackLog(self, reporter, reported, reportDescription)

end

function AntiCheatLogic.sendUseScrollLog(self, scrollItemID, remain, result, targetItemID, targetItemSN, beforeItem, afterItem, baseUpgradeCount, user)

end

function AntiCheatLogic.sendUseScrollLogWithType(self, logType, scrollItemID, remain, result, targetItemID, targetItemSN, beforeItem, afterItem, baseUpgradeCount, user)

end

function AntiCheatLogic.shouldBlockDeadlyAttack(self, attacker, mob, skillID, skillLevel, damages)

end
