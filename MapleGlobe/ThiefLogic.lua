

function ThiefLogic.playerHideAndShow(self, player, interval)
  self:playerHideAndShowLocal(player, interval)
  self:playerHideAndShowRemote(player, interval)
end

function ThiefLogic.playerHideAndShowLocal(self, player, interval)
  player.AvatarRendererComponent.Enable = false
  ___MOD._TimerService:SetTimerOnce(function()
    player.AvatarRendererComponent.Enable = true
  end, interval)
end

function ThiefLogic.playerHideAndShowRemote(self, player, interval, senderUserId)

end
