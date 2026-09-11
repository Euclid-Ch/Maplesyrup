

function PlayerUtils.get_iPlayerID(self, playerId)
  return ___MOD.tonumber(___MOD._UtilLogic:Replace(playerId, "_", ""))
end

function PlayerUtils.get_LocalUser_iPlayerID(self)
  local user = ___MOD._UserService.LocalPlayer
  local playerID = user.Player.PlayerId
  return self:get_iPlayerID(playerID)
end

function PlayerUtils.playerIdToUserId(self, playerId)
  return playerId:match("^[^_]+") or playerId
end

function PlayerUtils.validPlayer(self, userID)

end
