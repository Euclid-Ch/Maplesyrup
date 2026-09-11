

function SummonedPacket.attack(self, t)
  local user = ___MOD._UserService.LocalPlayer
  local dwSummonedID = t[1] or ""
  local summon = self:getSummon_Client(dwSummonedID)
  if summon == nil then
    ___MOD.log("풀에 존재하지 않는 Summoned", dwSummonedID)
    return
  end
  local summonComponent = summon.SummonComponent
  if summonComponent.owner == user then
    return
  end
  local ctx = ___MOD.SummonAttackCtx()
  ctx:fromTable(t)
  summon.SummonComponent:OnAttack(ctx)
end

function SummonedPacket.beholdersEffect(self, t)
  local user = ___MOD._UserService.LocalPlayer
  local dwSummonedID = t[1] or ""
  local type = t[2] or 0
  local summon = self:getSummon_Client(dwSummonedID)
  if summon == nil then
    return
  end
  local summonComponent = summon.SummonComponent
  if summonComponent.owner == user then
    return
  end
  summonComponent:PlayBeholdersEffect(type)
end

function SummonedPacket.DoBeholdersBuff(self, summon, type)

end

function SummonedPacket.DoBeholdersHealing(self, summon)

end

function SummonedPacket.enterField(self, map, summon, targetUser, initialAttackAble)

end

function SummonedPacket.enterField_ToClient(self, t)
  local ctx = ___MOD.SummonedEnterFieldCtx()
  ctx:fromTable(t)
  local owner = ctx.owner
  if owner == nil or not ___MOD.isvalid(owner) then
    ___MOD.log("존재하지 않는 Owner")
    return
  end
  local curMap = owner.CurrentMap
  local mapLife = curMap.MapLifeComponent
  local summonPool = mapLife.summonPool
  if summonPool:getSummon_Client(ctx.dwSummonedID) then
    ___MOD.log("이미 존재하는 Summoned", ctx.dwSummonedID)
    return
  end
  summonPool:requestStaleSummonRemoveCheck_Client(owner, ctx.skillID, ctx.dwSummonedID)
  local pos = ctx.pos
  if pos == nil and owner.TransformComponent ~= nil then
    pos = owner.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
    ctx.pos = pos
  end
  local summon = ___MOD._ObjectPool:pick(curMap.MapObjectPool.summonPool, "Summon", ___MOD._EntryService:GetModelIdByName("Summon_Test"), nil, curMap, false)
  summonPool:createSummon_Client(ctx.dwSummonedID, summon)
  summon.SummonComponent:Init(ctx.owner, ctx.dwSummonedID, ctx.SLV, ctx.skillID, ctx.moveAbility, ctx.assistType, pos, ctx.enterType, ctx.tExpiration, ctx.initialAttackAble)
end

function SummonedPacket.forceRemove_ToClient(self, dwSummonedID, leaveType)
  local summon = self:getSummon_Client(dwSummonedID)
  if summon == nil then
    return
  end
  summon.SummonComponent:OnRemove(leaveType)
end

function SummonedPacket.getObservedUser_Client(self)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not (localPlayer ~= nil and ___MOD.isvalid(localPlayer)) or ___MOD._ObserverService == nil or localPlayer.PlayerComponent == nil then
    return nil
  end
  local observedUserProfileCode = ___MOD._ObserverService:GetObservedUserProfileCode(localPlayer.PlayerComponent.ProfileCode)
  if observedUserProfileCode == nil or observedUserProfileCode == "" then
    return nil
  end
  local observedUser = ___MOD._UserService:GetUserByProfileCode(observedUserProfileCode)
  if observedUser == nil then
    return nil
  end
  local observedUserEntity = ___MOD._UserService:GetUserEntityByUserId(observedUser.UserId)
  if ___MOD.isvalid(observedUserEntity) then
    return observedUserEntity
  end
  return nil
end

function SummonedPacket.getSummon_Client(self, dwSummonedID)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(localPlayer) then
    local summon = self:getSummonFromMap_Client(localPlayer.CurrentMap, dwSummonedID)
    if summon ~= nil then
      return summon
    end
  end
  local observedUser = self:getObservedUser_Client()
  if ___MOD.isvalid(observedUser) then
    local summon = self:getSummonFromMap_Client(observedUser.CurrentMap, dwSummonedID)
    if summon ~= nil then
      return summon
    end
  end
  return nil
end

function SummonedPacket.getSummonFromMap_Client(self, map, dwSummonedID)
  if not (map ~= nil and ___MOD.isvalid(map)) or map.MapLifeComponent == nil then
    return nil
  end
  local summonPool = map.MapLifeComponent.summonPool
  if summonPool == nil then
    return nil
  end
  return summonPool:getSummon_Client(dwSummonedID)
end

function SummonedPacket.hit(self, t)
  local user = ___MOD._UserService.LocalPlayer
  local dwSummonedID = t[1] or ""
  local summon = self:getSummon_Client(dwSummonedID)
  if summon == nil then
    ___MOD.log("풀에 존재하지 않는 Summoned", dwSummonedID)
    return
  end
  local summonComponent = summon.SummonComponent
  if summonComponent.owner == user then
    return
  end
  local ctx = ___MOD.SummonHitCtx()
  ctx:fromTable(t)
  summonComponent:OnHit(ctx)
end

function SummonedPacket.leaveField(self, map, summon)

end

function SummonedPacket.leaveField_ToClient(self, dwSummonedID, leaveType)
  local summon = self:getSummon_Client(dwSummonedID)
  if summon == nil then
    ___MOD.log("풀에 존재하지 않는 Summoned", dwSummonedID)
    return
  end
  summon.SummonComponent:OnRemove(leaveType)
end

function SummonedPacket.move(self, t)
  local owner = t[1] or nil
  if owner == nil or not ___MOD.isvalid(owner) then
    return
  end
  local dwSummonedID = t[2] or ""
  local curMap = owner.CurrentMap
  local mapLife = curMap.MapLifeComponent
  local summon = mapLife.summonPool:getSummon_Client(dwSummonedID)
  if summon == nil then
    ___MOD.log("풀에 존재하지 않는 Summoned", dwSummonedID)
    return
  end
  summon.SummonComponent:OnMove(t)
end

function SummonedPacket.onAttack(self, t, senderUserId)

end

function SummonedPacket.onBeholdersBuff(self, t, senderUserId)

end

function SummonedPacket.onCheckRemove(self, dwSummonedID, leaveType, senderUserId)

end

function SummonedPacket.onHit(self, t, senderUserId)

end

function SummonedPacket.onMove(self, t, senderUserId)

end
