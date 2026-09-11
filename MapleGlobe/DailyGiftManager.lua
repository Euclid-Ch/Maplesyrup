

function DailyGiftManager.canGainDailyGiftReward(self, user, itemID, quantity, flag)

end

function DailyGiftManager.claimDailyGiftServerOnly(self, user, userId)

end

function DailyGiftManager.getDailyGift(self, day)
  return self.dailyGift[day]
end

function DailyGiftManager.getDailyGiftFlag(self, day)
  local gift = self.dailyGift[day]
  if gift == nil then
    return 0
  end
  return gift.flag or 0
end

function DailyGiftManager.getDailyGiftItemID(self, day)
  local gift = self.dailyGift[day]
  if gift == nil then
    return 0
  end
  return gift.itemID or 0
end

function DailyGiftManager.getDailyGiftQuantity(self, day)
  local gift = self.dailyGift[day]
  if gift == nil then
    return 0
  end
  return gift.quantity or 0
end

function DailyGiftManager.getDailyGiftTable(self)
  return self.dailyGift
end

function DailyGiftManager.loadDailyGift(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local dataset = ___MOD._DataService:GetTable("DailyGift")
  local cache = {}
  local count = 0
  if dataset ~= nil then
    local rowCount = dataset:GetRowCount()
    local get = dataset.GetCell
    for i = 1, rowCount do
      local day = ___MOD.tonumber(get(dataset, i, "day")) or ___MOD.tonumber(get(dataset, i, 1))
      local itemID = ___MOD.tonumber(get(dataset, i, "itemID")) or ___MOD.tonumber(get(dataset, i, 2))
      local quantity = ___MOD.tonumber(get(dataset, i, "quantity")) or ___MOD.tonumber(get(dataset, i, 3))
      local flag = ___MOD.tonumber(get(dataset, i, "flag")) or ___MOD.tonumber(get(dataset, i, 4)) or 0
      if day ~= nil and 1 <= day and day <= 28 and itemID ~= nil and quantity ~= nil then
        cache[day] = {
          itemID = itemID,
          quantity = quantity,
          flag = flag
        }
        count = count + 1
      end
    end
  end
  self.dailyGift = cache
  self.count = count
  ___MOD.log(___MOD.string.format("Loaded DailyGift (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end

function DailyGiftManager.onDailyGiftClaimResultClient(self, success, message, claimedDay, mobCount, lastDate)
  local player = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(player) and player.QuestComponent ~= nil then
    player.QuestComponent.questEx[77777] = player.QuestComponent.questEx[77777] or {}
    player.QuestComponent.questEx[77777].dailyGift_day = ___MOD.tostring(claimedDay or 0)
    player.QuestComponent.questEx[77777].dailyGift_mob = ___MOD.tostring(mobCount or 0)
    local kst = ___MOD.DateTime.UtcNow + ___MOD.TimeSpan.FromHours(9)
    player.QuestComponent.questEx[77777].dailyGift_date = kst:ToFormattedString("yyyyMMdd")
    player.QuestComponent.questEx[77777].dailyGift_lastdate = ___MOD.tostring(lastDate or "")
  end
  local dailyGift = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/DailyGift")
  if ___MOD.isvalid(dailyGift) and dailyGift.DailyGiftComponent ~= nil then
    dailyGift.DailyGiftComponent:applyClaimResultClient(success, claimedDay, mobCount, lastDate)
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(message) then
    ___MOD._UINotice:showAlertUI(message)
  end
end

function DailyGiftManager.requestClaimDailyGiftServer(self, senderUserId)

end

function DailyGiftManager.syncDailyGiftQuestExClient(self, mobCount, claimedDay, date, lastDate)
  local player = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(player) and player.QuestComponent ~= nil then
    player.QuestComponent.questEx[77777] = player.QuestComponent.questEx[77777] or {}
    player.QuestComponent.questEx[77777].dailyGift_mob = ___MOD.tostring(mobCount or 0)
    player.QuestComponent.questEx[77777].dailyGift_day = ___MOD.tostring(claimedDay or 0)
    player.QuestComponent.questEx[77777].dailyGift_date = ___MOD.tostring(date or "")
    player.QuestComponent.questEx[77777].dailyGift_lastdate = ___MOD.tostring(lastDate or "")
  end
  local dailyGift = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/DailyGift")
  if ___MOD.isvalid(dailyGift) and dailyGift.Enable and dailyGift.DailyGiftComponent ~= nil then
    dailyGift.DailyGiftComponent:setupDailyGift()
  end
end
