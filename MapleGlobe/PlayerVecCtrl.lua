

function PlayerVecCtrl.Impact(self, user)
  if not self.impactNext_valid then
    return
  end
  local nextVx = self.impactNext_vx
  local nextVy = self.impactNext_vy
  local ignoreSpeedScale = self.impactNext_ignoreSpeedScale
  self.impactNext_valid = false
  local curFx = self.vx
  local curFy = self.vy
  local finalFx = curFx
  local finalFy = curFy
  if nextVx < 0 then
    if nextVx < curFx then
      finalFx = ___MOD.math.max(nextVx, curFx + nextVx)
    end
  elseif 0 < nextVx and nextVx > curFx then
    finalFx = ___MOD.math.min(nextVx, curFx + nextVx)
  end
  if 0 < nextVy then
    if nextVy > curFy then
      finalFy = ___MOD.math.min(nextVy, curFy + nextVy)
    end
  elseif nextVy < 0 and nextVy < curFy then
    finalFy = ___MOD.math.max(nextVy, curFy + nextVy)
  end
  if not ignoreSpeedScale then
    finalFx = finalFx * (100 / user.PlayerSecondaryAbilityComponent:getCurrentSpeedValue())
  end
  user.RigidbodyComponent:SetForce(___MOD.FastVector2(finalFx, finalFy))
end

function PlayerVecCtrl.isImpactMoving(self)
  if self.impactNext_valid then
    return true
  end
  if not self.impactMoveActive then
    return false
  end
  local user = ___MOD._UserService.LocalPlayer
  if user.RigidbodyComponent:IsOnGround() or user.PlayerActionComponent.isClimbing then
    self.impactMoveActive = false
    return false
  end
  return true
end

function PlayerVecCtrl.OnUpdate(self, delta)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) then
    return
  end
  local vx = 0
  local vy = 0
  if not self.isClimbing then
    local mv = user.RigidbodyComponent.RealMoveVelocity
    vx = mv.x / delta
    vy = mv.y / delta
    if 6.7 < vy then
      vy = 6.7
    end
  end
  if not self.canImpact then
    self.vx = 0
    self.vy = 0
  elseif self.teleport then
    self.vx = 0
    self.vy = 0
    self.teleport = false
  else
    self.vx = vx
    self.vy = vy
  end
  if self.impactMoveActive and not self.impactNext_valid and (user.RigidbodyComponent:IsOnGround() or user.PlayerActionComponent.isClimbing) then
    self.impactMoveActive = false
  end
  self:Impact(user)
end

function PlayerVecCtrl.SetImpactNext(self, vx, vy, ignoreSpeedScale)
  if not self.impactNext_valid then
    self.impactNext_vx = 0
    self.impactNext_vy = 0
    self.impactNext_ignoreSpeedScale = false
    self.impactNext_valid = true
  end
  self.impactMoveActive = true
  if ignoreSpeedScale then
    self.impactNext_ignoreSpeedScale = true
  end
  ___MOD._PlayerSkillLogic:endWings(___MOD._UserService.LocalPlayer, ___MOD._SkillBook.Wings_520_5201005)
  if vx < 0 and vx < self.impactNext_vx then
    self.impactNext_vx = ___MOD.math.min(vx + self.impactNext_vx, vx)
  elseif 0 < vx and vx > self.impactNext_vx then
    self.impactNext_vx = ___MOD.math.max(vx + self.impactNext_vx, vx)
  end
  if 0 < vy and vy > self.impactNext_vy then
    self.impactNext_vy = ___MOD.math.max(vy + self.impactNext_vy, vy)
  elseif vy < 0 and vy < self.impactNext_vy then
    self.impactNext_vy = ___MOD.math.min(vy + self.impactNext_vy, vy)
  end
end
