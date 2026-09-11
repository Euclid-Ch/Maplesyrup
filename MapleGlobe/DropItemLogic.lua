

function DropItemLogic.canDropGoToFoothold(self, map, startPosition, targetX, targetY)

end

function DropItemLogic.canRestoreTradeAvailable(self, itemId)

end

function DropItemLogic.canTakeDrop(self, user, dropPool)

end

function DropItemLogic.canUseDedicatedDropOwnerId(self, user, ownerID)
  if not user or not user.CurrentMap then
    return false
  end
  if not ___MOD._DedicatedMonsterLogic:isEnabledMap(user.CurrentMap) then
    return true
  end
  if ___MOD._DedicatedMonsterLogic:isPoolKeyOwnedByPlayer(user, ownerID) then
    return true
  end
  local currentPoolKey = ___MOD._DedicatedMonsterLogic:getCurrentPoolKey(user)
  if currentPoolKey == "" then
    return false
  end
  local partyId = user.Player and user.Player.PartyId or 0
  if partyId <= 0 then
    return false
  end
  local partyKey = ___MOD._DedicatedMonsterLogic:makePartyPoolKey(partyId)
  if currentPoolKey ~= partyKey then
    return false
  end
  local mapUsers = ___MOD._UserService:GetUsersByMapName(user.CurrentMap.Name)
  for _, mapUser in ___MOD.pairs(mapUsers) do
    if mapUser and mapUser.Player and mapUser.Player.PartyId == partyId then
      local playerId = mapUser.Player.PlayerId or ""
      if playerId ~= "" and ownerID == ___MOD._DedicatedMonsterLogic:makePlayerPoolKey(playerId) then
        return true
      end
    end
  end
  return false
end

function DropItemLogic.canUserPickupIcebox(self, user)

end

function DropItemLogic.canUserPickupMysteryCube(self, user)

end

function DropItemLogic.canUserSeeDedicatedDrop(self, user, dropPool)
  if not user or not dropPool then
    return false
  end
  local poolKey = dropPool.dedicatedPoolKey or ""
  if poolKey == "" then
    return true
  end
  if ___MOD._DedicatedMonsterLogic:isPoolKeyOwnedByPlayer(user, poolKey) then
    return true
  end
  local currentPoolKey = ___MOD._DedicatedMonsterLogic:getCurrentPoolKey(user)
  local partyId = user.Player and user.Player.PartyId or 0
  if partyId <= 0 then
    return false
  end
  local partyKey = ___MOD._DedicatedMonsterLogic:makePartyPoolKey(partyId)
  if currentPoolKey ~= partyKey then
    return false
  end
  local mapUsers = ___MOD._UserService:GetUsersByMapName(user.CurrentMap.Name)
  for _, mapUser in ___MOD.pairs(mapUsers) do
    if mapUser and mapUser.Player and mapUser.Player.PartyId == partyId then
      local playerId = mapUser.Player.PlayerId or ""
      if playerId ~= "" and poolKey == ___MOD._DedicatedMonsterLogic:makePlayerPoolKey(playerId) then
        return true
      end
    end
  end
  return false
end

function DropItemLogic.canUserSeeDrop(self, user, dropPool)

end

function DropItemLogic.createDrop(self, map, itemID, quantity, ownerID, ownPartyID, ownType, sourceID, sourceType, sourcePlayerName, curPos, x2, delay, byPet, iEquip, questId)

end

function DropItemLogic.createHDrop(self, map)

end

function DropItemLogic.getDedicatedDropPoolKey(self, map, ownerID, ownPartyID, sourceID)
  if not ___MOD._DedicatedMonsterLogic:isEnabledMap(map) then
    return ""
  end
  local resolvedOwnerID = ownerID or ""
  if resolvedOwnerID == "" and sourceID ~= nil and sourceID ~= "" then
    local sourceNum = ___MOD.tonumber(sourceID) or 0
    if sourceNum <= 0 or 10000000 <= sourceNum then
      resolvedOwnerID = sourceID
    end
  end
  local mapUsers = ___MOD._UserService:GetUsersByMapName(map.Name)
  for _, mapUser in ___MOD.pairs(mapUsers) do
    if mapUser and mapUser.Player and mapUser.Player.PlayerId == resolvedOwnerID then
      return ___MOD._DedicatedMonsterLogic:getCurrentPoolKey(mapUser)
    end
  end
  if 0 < ownPartyID then
    return ___MOD._DedicatedMonsterLogic:makePartyPoolKey(ownPartyID)
  end
  if resolvedOwnerID ~= "" then
    return ___MOD._DedicatedMonsterLogic:makePlayerPoolKey(resolvedOwnerID)
  end
  return ""
end

function DropItemLogic.getPickupLogSourceType(self, dropSourceType)

end

function DropItemLogic.handlePickupDrop(self, id, pickedByPet, petId, hi, senderUserId)

end

function DropItemLogic.handlePickupDropItem(self, id, pickedByPet, petId, hi, senderUserId)

end

function DropItemLogic.handlePickupDropItemNew(self, id, pickedByPet, petId, hi, senderUserId)

end

function DropItemLogic.isConsumeOnPickupItem(self, itemId)

end

function DropItemLogic.isIceboxDropPool(self, dropPool)

end

function DropItemLogic.isIceboxItem(self, itemId)

end

function DropItemLogic.isMysteryCubeDropPool(self, dropPool)

end

function DropItemLogic.isMysteryCubeItem(self, itemId)

end

function DropItemLogic.isPrivateVisibleDropItem(self, itemId)

end

function DropItemLogic.makeDropTradeSN(self, dropID)

end

function DropItemLogic.normalizeDropSourceType(self, sourceType)

end

function DropItemLogic.removeDrop(self, map, dropID, leaveType, pickUpBy, explodeDelay, userId)

end

function DropItemLogic.sendMakeEnterFieldPacket(self, map, enterType, ctx, userId)

end

function DropItemLogic.sendMakeEnterFieldPacketToObservers(self, map, enterType, ctx, dropPool)

end

function DropItemLogic.sendMakeLeaveFieldPacket(self, map, dropID, leaveType, pickUpBy, explodeDelay, userId)

end

function DropItemLogic.sendPlayerDropTradeLog(self, dropPool, receiver, itemID, quantity, itemSN, equipInfo)

end

function DropItemLogic.setPickupEnabled(self, enabled)
  self.pickupEnabled = enabled
end

function DropItemLogic.shouldHideQuestDropFromUser(self, user, dropPool)

end

function DropItemLogic.SyncVisibleDropsToObserver_ServerOnly(self, observedUser, observerUserId)

end

function DropItemLogic.tryPetPickupDrop(self, pet)
  if not self.pickupEnabled then
    return
  end
  if ___MOD._UIWindowLogic.openDelivery then
    return
  end
  local cur = ___MOD._UtilLogic.ElapsedSeconds
  local petId = pet.PetComponent ~= nil and pet.PetComponent.ULID or nil
  if ___MOD._UtilLogic:IsNilorEmptyString(petId) then
    return
  end
  if self._T.nextPickupPetRequestByULID == nil then
    self._T.nextPickupPetRequestByULID = {}
  end
  local nextRequest = self._T.nextPickupPetRequestByULID[petId] or 0
  if cur < nextRequest then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local player = user.Player
  local owner = pet.PetComponent.owner
  if owner == nil or owner ~= user or player:isDead() then
    return
  end
  local dedicatedMap = ___MOD._DedicatedMonsterLogic:isEnabledMap(user.CurrentMap)
  local simulator = ___MOD._CollisionService:GetSimulator(pet)
  self._T.overlap = {}
  local overlap = self._T.overlap
  local t = pet.TriggerComponent
  local box = ___MOD._NumberUtils:triggerToBox(t)
  local count = simulator:OverlapAllFast("Item", box, overlap)
  if 0 < count then
    for i = 1, count do
      local e = overlap[i].Entity
      local drop = e.CDropItemComponent
      local enterCtx = drop.dropEnterFieldCtx
      if drop.bByPet then
        local ownType = enterCtx.ownType
        local ownerID = enterCtx.ownerID
        local canPickupDedicatedDrop = not dedicatedMap or self:canUseDedicatedDropOwnerId(user, ownerID)
        if (dedicatedMap and canPickupDedicatedDrop or cur - drop.tCreateTime >= 30 or ___MOD._UtilLogic:IsNilorEmptyString(enterCtx.sourceID) or (ownType ~= ___MOD._DropOwnType.UserOwn_0 or ownerID == player.PlayerId) and (ownType ~= ___MOD._DropOwnType.PartyOwn_1 or ownerID == ___MOD.tostring(player.PartyId))) and canPickupDedicatedDrop and drop.Enable and drop.nState == 3 and drop.bReal and 3 <= cur - drop.tLastTryPickUp then
          self:handlePickupDropItemNew(drop.dropID, true, pet.PetComponent.ULID, 11)
          drop.tLastTryPickUp = cur
          self._T.nextPickupPetRequestByULID[petId] = cur + 0.05
          break
        end
      end
    end
  end
end

function DropItemLogic.tryPickupDrop(self)
  if not self.pickupEnabled then
    return
  end
  if ___MOD._UIWindowLogic.openDelivery then
    return
  end
  local cur = ___MOD._UtilLogic.ElapsedSeconds
  local nextRequest = self._T.nextPickupRequest or 0
  if cur < nextRequest then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local player = user.Player
  if player:isDead() then
    self._T.nextPickupRequest = cur + 0.1
    return
  end
  local dedicatedMap = ___MOD._DedicatedMonsterLogic:isEnabledMap(user.CurrentMap)
  local simulator = ___MOD._CollisionService:GetSimulator(user)
  self._T.overlap = {}
  local overlap = self._T.overlap
  local t = user.PlayerVariables.playerPosTrigger
  local box = ___MOD._NumberUtils:triggerToBox(t)
  local count = simulator:OverlapAllFast("Item", box, overlap)
  if 0 < count then
    for i = 1, count do
      local trigger = overlap[i]
      if trigger.EnableInHierarchy then
        local e = trigger.Entity
        local drop = e.CDropItemComponent
        local enterCtx = drop.dropEnterFieldCtx
        local ownType = enterCtx.ownType
        local ownerID = enterCtx.ownerID
        local canPickupDedicatedDrop = not dedicatedMap or self:canUseDedicatedDropOwnerId(user, ownerID)
        if (dedicatedMap and canPickupDedicatedDrop or cur - drop.tCreateTime >= 30 or ___MOD._UtilLogic:IsNilorEmptyString(enterCtx.sourceID) or (ownType ~= ___MOD._DropOwnType.UserOwn_0 or ownerID == player.PlayerId) and (ownType ~= ___MOD._DropOwnType.PartyOwn_1 or ownerID == ___MOD.tostring(player.PartyId))) and canPickupDedicatedDrop and drop.Enable and drop.nState == 3 and drop.bReal and 3 <= cur - drop.tLastTryPickUp then
          self:handlePickupDropItemNew(drop.dropID, false, nil, 11)
          drop.tLastTryPickUp = cur
          self._T.nextPickupRequest = cur + 0.1
          break
        end
      end
    end
  end
end
