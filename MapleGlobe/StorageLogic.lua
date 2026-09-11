

function StorageLogic.allocSlotId(self, storage)

end

function StorageLogic.clearUserStorage(self, user)

end

function StorageLogic.clearUserStorageByOwnerId(self, ownerId)

end

function StorageLogic.cloneStorageEquipInfo(self, equipInfo)

end

function StorageLogic.cloneTable(self, src)

end

function StorageLogic.createEmptyStorageData(self)

end

function StorageLogic.deserializeStorage(self, raw)

end

function StorageLogic.ensureUserStorage(self, user)

end

function StorageLogic.ensureUserStorageByOwnerId(self, ownerId)

end

function StorageLogic.getInvTypeByItemId(self, itemId)

end

function StorageLogic.getLegacyStorageTableName(self, id)

end

function StorageLogic.getStorageCapacity(self, invType)

end

function StorageLogic.getStorageListByUser(self, user, invType)

end

function StorageLogic.getStorageMesoByUser(self, user)

end

function StorageLogic.getStorageOwnerId(self, user)

end

function StorageLogic.getStoragePutFee(self)

end

function StorageLogic.getStorageTableName(self, ownerId)

end

function StorageLogic.isOnlyItem(self, item, equipInfo)

end

function StorageLogic.isSameStorageItemMeta(self, a, b)

end

function StorageLogic.isStorageDataEmpty(self, storage)

end

function StorageLogic.isTradeBlockedOrQuestItem(self, item, equipInfo)

end

function StorageLogic.loadStorageByUserData(self, user, raw)

end

function StorageLogic.makeStorageItemStack(self, invType, slotId, itemId, count, equipInfo)

end

function StorageLogic.normalizeStoragePutEquipInfo(self, equipInfo, isCash)

end

function StorageLogic.openStorageUIClient(self, userId, npcId)

end

function StorageLogic.preloadUserStorage(self, user)

end

function StorageLogic.reindexStorageSlotIds(self, storage)

end

function StorageLogic.saveUserStorageByOwnerId(self, ownerId)

end

function StorageLogic.serializeStorage(self, storage)

end

function StorageLogic.serializeStorageByUser(self, user)

end

function StorageLogic.serializeStorageEquipInfo(self, equipInfo)

end

function StorageLogic.serializeStorageItemStack(self, stack)

end

function StorageLogic.toJsonSafeTable(self, src)

end

function StorageLogic.tryDepositMesoByUser(self, user, amount)

end

function StorageLogic.tryPutItemByUser(self, user, invType, slot, count)

end

function StorageLogic.tryTakeItemByUser(self, user, invType, slotId, count)

end

function StorageLogic.tryWithdrawMesoByUser(self, user, amount)

end
