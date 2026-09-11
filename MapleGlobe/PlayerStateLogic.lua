

function PlayerStateLogic.changeState(self, player, state)
  if not player or not player.StateComponent then
    return
  end
  local taming = player.TamingMobComponent
  if taming and taming.onTaming and state ~= "DEAD" then
    local renderState = "SIT"
    local actualState = "SIT"
    if state == "IDLE" or state == "MOVE" or state == "JUMP" or state == "FALL" or state == "FLY" or state == "CLIMB" or state == "LADDER" then
      renderState = state
    end
    if state == "IDLE" or state == "MOVE" or state == "CLIMB" or state == "LADDER" then
      actualState = state
    end
    if taming.renderStateName ~= renderState then
      taming.renderStateName = renderState
    end
    self.lastState = actualState
    if player.StateComponent.CurrentStateName ~= actualState then
      player.StateComponent:ChangeState(actualState)
    end
    return
  end
  if taming and taming.renderStateName ~= "" then
    taming.renderStateName = ""
  end
  self.lastState = state
  player.StateComponent:ChangeState(state)
end
