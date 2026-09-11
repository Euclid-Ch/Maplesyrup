

function MobileUITransferLogic.appendToWarpData(self, warpDataTable, user)

end

function MobileUITransferLogic.applyWarpData(self, userEntity, warpDataTable)

end

function MobileUITransferLogic.copyWarpData(self, sourceWarpData, targetWarpData)

end

function MobileUITransferLogic.isValidMobileChatPos(self, saved, positionX, positionY)

end

function MobileUITransferLogic.parseMobileChatWarpPos(self, warpDataTable)

end

function MobileUITransferLogic.restoreMobileChatPosClient(self, saved, positionX, positionY)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  ___MOD._UIMobileHudLayout:RestoreMobileChatPosition(saved, positionX, positionY)
end

function MobileUITransferLogic.restorePendingMobileChatPos(self, player, userId)

end

function MobileUITransferLogic.setMobileActionSlotSettingBoxOpen(self, user, settingBoxOpen)

end

function MobileUITransferLogic.setMobileChatPos(self, user, chatPos)

end

function MobileUITransferLogic.updateMobileChatPos(self, chatPos, senderUserId)

end
