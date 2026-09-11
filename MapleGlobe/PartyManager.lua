

function PartyManager.broadCastingPartyRequest(self, type, partyId, senderPlayerId, pm, chatMsg)

end

function PartyManager.dispatchPartyRequestToUser(self, type, partyId, user, userId, pm, chatMsg)

end

function PartyManager.getPartyMemberCount(self, members)
  local count = 0
  if members ~= nil then
    for _, pm in ___MOD.pairs(members) do
      if pm ~= nil then
        count = count + 1
      end
    end
  end
  return count
end

function PartyManager.invitedParty(self, level, job, name, partyId, inviterId)
  local user = ___MOD._UserService.LocalPlayer
  local player = user.Player
  local fadeMsg = ___MOD.string.format("Lv.%d %s\n'%s'님의\n파티초대 입니다", level, job, name)
  ___MOD._FadeYesNo:createFadeYesNo(1, 5, false, fadeMsg, nil, function(result)
    self:responseInviteParty(result, partyId, inviterId, player.Name, player.PlayerId)
  end, 1, nil, "party_invite_" .. inviterId)
end

function PartyManager.invitePartyToServer(self, user, userId, receiverName)

end

function PartyManager.responseInviteParty(self, response, partyId, inviterId, responderName, responderId, senderUserId)

end

function PartyManager.tryChangeLeader(self, prevLeaderName, newLeaderName, senderUserId)

end

function PartyManager.tryCreateParty(self, senderUserId)

end

function PartyManager.tryDispatchPartyRequestLocal(self, type, partyId, senderPlayerId, pm, chatMsg)

end

function PartyManager.tryInviteParty(self, receiverName)
  local user = ___MOD._UserService.LocalPlayer
  local player = user.Player
  if not ___MOD._CheckNameUtils:is_valid_name(receiverName, false) then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "잘못된 캐릭터 이름입니다.")
    return
  end
  if player.Name == receiverName then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "자기 자신은 초대할 수 없습니다.")
    return
  end
  if player.PartyId > 0 then
    local findPMme = user.PartyUIComponent:findPartyMemberByName(player.Name)
    if findPMme == nil then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "가입 된 파티가 없습니다.")
      return
    end
    if not findPMme.isLeader then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "파티 초대는 파티장만 가능합니다.")
      return
    end
    if self:getPartyMemberCount(user.PartyUIComponent.partyMembers) >= 6 then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "더 이상 파티 초대는 불가능합니다")
      return
    end
  end
  self:tryInvitePartyToServer(receiverName)
end

function PartyManager.tryInvitePartyToServer(self, receiverName, senderUserId)

end

function PartyManager.tryKickMember(self, name, senderUserId)

end

function PartyManager.tryLeaveParty(self, senderUserId)

end

function PartyManager.updatePartyMemberMinimapIcon(self, target)
  ___MOD._UIMiniMap:updateTargetIcon(target.PlayerComponent.UserId)
end
