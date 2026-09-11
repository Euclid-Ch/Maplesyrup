

function AranPassManager.canGainAranPassRewards(self, user, rewards)

end

function AranPassManager.canUseAranPass(self, user)

end

function AranPassManager.claimAllAranPassRewardsServerOnly(self, user, userId)

end

function AranPassManager.claimAranPassRewardServerOnly(self, user, rewardIndex, userId)

end

function AranPassManager.createAranPassRewardItemInfo(self, itemID, flag, expTime)

end

function AranPassManager.gainAranPassRewards(self, user, rewards)

end

function AranPassManager.getAranPassClaimKey(self, level)
  return "AranPass_Level_" .. ___MOD.tostring(level)
end

function AranPassManager.getAranPassReward(self, rewardIndex)
  return self:getAranPassRewards()[rewardIndex]
end

function AranPassManager.getAranPassRewardCount(self)
  return #self:getAranPassRewards()
end

function AranPassManager.getAranPassRewardExpireTime(self)
  local expireAt = ___MOD.DateTime(2026, 9, 3, 10, 0, 0, 0) - ___MOD.TimeSpan.FromHours(9)
  return expireAt.Elapsed
end

function AranPassManager.getAranPassRewards(self)
  if self._T.aranPassRewards == nil then
    local expireTime = self:getAranPassRewardExpireTime()
    self._T.aranPassRewards = {
      {
        level = 10,
        itemID = 2430066,
        quantity = 1,
        flag = 1,
        expTime = expireTime
      },
      {
        level = 30,
        itemID = 2430067,
        quantity = 1,
        flag = 1,
        expTime = expireTime
      },
      {
        level = 60,
        itemID = 2430068,
        quantity = 1,
        flag = 1,
        expTime = expireTime
      },
      {
        level = 100,
        itemID = 2430069,
        quantity = 1,
        flag = 1,
        expTime = expireTime
      },
      {
        level = 120,
        itemID = 2430070,
        quantity = 1,
        flag = 1,
        expTime = expireTime
      }
    }
  end
  return self._T.aranPassRewards
end

function AranPassManager.getClaimedBitMaskServerOnly(self, user)

end

function AranPassManager.getPlayerLevelServerOnly(self, user)

end

function AranPassManager.isAranPassClaimed(self, user, level)

end

function AranPassManager.onAranPassClaimResultClient(self, success, message, level, claimedBitMask)
  local aranPass = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/AranPass")
  if ___MOD.isvalid(aranPass) and aranPass.AranPassComponent ~= nil then
    aranPass.AranPassComponent:applyClaimResultClient(success, level, claimedBitMask)
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(message) then
    ___MOD._UINotice:showAlertUI(message)
  end
end

function AranPassManager.onAranPassStateClient(self, isAran, level, claimedBitMask)
  local aranPass = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/AranPass")
  if ___MOD.isvalid(aranPass) and aranPass.AranPassComponent ~= nil then
    aranPass.AranPassComponent:applyStateClient(isAran, level, claimedBitMask)
  end
end

function AranPassManager.requestAranPassStateServer(self, senderUserId)

end

function AranPassManager.requestClaimAllAranPassRewardsServer(self, senderUserId)

end

function AranPassManager.requestClaimAranPassRewardServer(self, rewardIndex, senderUserId)

end

function AranPassManager.syncAranPassStateServerOnly(self, user, userId)

end
