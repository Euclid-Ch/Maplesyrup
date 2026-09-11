

function DedicatedMonsterLogic.buildLivePositions(self, mapLife, playerId)

end

function DedicatedMonsterLogic.canSpawnMobForPlayer(self, lp, playerId, curTime, reset, pt)

end

function DedicatedMonsterLogic.canTargetPlayer(self, mob, player)
  if not mob or not mob.CurrentMap then
    return false
  end
  local mapLife = mob.CurrentMap.MapLifeComponent
  if not self:isEnabledMap(mob.CurrentMap) then
    return true
  end
  if not self:isDedicatedMob(mapLife, mob) then
    return true
  end
  if not player then
    return false
  end
  return self:isPoolKeyOwnedByPlayer(player, self:getOwnerPlayerId(mapLife, mob))
end

function DedicatedMonsterLogic.clearAll(self, mapLife)

end

function DedicatedMonsterLogic.clearMobTracking(self, mapLife, mob)

end

function DedicatedMonsterLogic.clearPoolStateForInactivePools(self, mapLife, runtime, currentPlayers, currentPools)

end

function DedicatedMonsterLogic.createMobByLifePoolForPlayer(self, mapLife, lp, playerId)

end

function DedicatedMonsterLogic.ensurePlayerLiveMob(self, mapLife, playerId)
  local t = mapLife.liveMobByPlayerId[playerId]
  if not t then
    t = {}
    mapLife.liveMobByPlayerId[playerId] = t
  end
  return t
end

function DedicatedMonsterLogic.ensurePlayerOrder(self, runtime, playerId)

end

function DedicatedMonsterLogic.ensurePoolState(self, lp, playerId)
  local t = lp.dedicatedStateByPlayerId[playerId]
  if not t then
    t = {
      mobCount = 0,
      rAfter = lp.rAfter or 0
    }
    lp.dedicatedStateByPlayerId[playerId] = t
  end
  return t
end

function DedicatedMonsterLogic.ensureRuntimeTables(self, mapLife)

end

function DedicatedMonsterLogic.getAuthorizedPools(self, runtime, currentPools, currentPlayers, poolMembers)

end

function DedicatedMonsterLogic.getCurrentPoolKey(self, player)
  if not player or not player.Player then
    return ""
  end
  local poolKey = player.Player.DedicatedMobPoolKey or ""
  if poolKey ~= "" then
    return poolKey
  end
  if player.CurrentMap and self:isEnabledMap(player.CurrentMap) then
    local runtime = self:ensureRuntimeTables(player.CurrentMap.MapLifeComponent)
    local playerId = player.Player.PlayerId or ""
    local runtimeKey = runtime.playerPoolKeyByPlayerId[playerId]
    if runtimeKey and runtimeKey ~= "" then
      return runtimeKey
    end
  end
  local playerId = player.Player.PlayerId or ""
  if playerId == "" then
    return ""
  end
  return self:makePlayerPoolKey(playerId)
end

function DedicatedMonsterLogic.getCurrentPoolUsageCount(self, map)
  if not map or not self:isEnabledMap(map) then
    return 0
  end
  local users = ___MOD._UserService:GetUsersByMapName(map.Name)
  local partyCounts = {}
  for _, user in ___MOD.pairs(users) do
    if user and user.Player then
      local partyId = user.Player.PartyId or 0
      if 0 < partyId then
        partyCounts[partyId] = (partyCounts[partyId] or 0) + 1
      end
    end
  end
  local poolKeys = {}
  for _, user in ___MOD.pairs(users) do
    if user and user.Player then
      local playerId = user.Player.PlayerId or ""
      if playerId ~= "" then
        local partyId = user.Player.PartyId or 0
        local poolKey = ""
        if 0 < partyId and (partyCounts[partyId] or 0) >= 2 then
          poolKey = self:makePartyPoolKey(partyId)
        else
          poolKey = self:makePlayerPoolKey(playerId)
        end
        poolKeys[poolKey] = true
      end
    end
  end
  local count = 0
  for _, _ in ___MOD.pairs(poolKeys) do
    count = count + 1
  end
  return count
end

function DedicatedMonsterLogic.getOwnerPlayerId(self, mapLife, mob)
  if not mob or not mob.MobComponent then
    return ""
  end
  local owner = mob.MobComponent.dedicatedOwnerPlayerId
  if owner and owner ~= "" then
    return owner
  end
  return mapLife.mobOwnerByEntityId[mob.Id] or ""
end

function DedicatedMonsterLogic.getPartyLeaderPlayerId(self, user)

end

function DedicatedMonsterLogic.getPlayerCap(self, mapLife)
  local mobCapacityMin = mapLife.mobCapacityMin
  local mobCapacityMax = mapLife.mobCapacityMax
  local controllerCount = 1
  local cap = 0
  if controllerCount < mobCapacityMin * 2 then
    cap = mobCapacityMin + (mobCapacityMax - mobCapacityMin) * (2 * controllerCount - mobCapacityMin) / (3 * mobCapacityMin)
  else
    cap = mobCapacityMax
  end
  return ___MOD.math.floor(cap + 0.5)
end

function DedicatedMonsterLogic.getVisualAlpha(self, mob, viewer)
  if not mob or not mob.CurrentMap then
    return 1
  end
  local mapLife = mob.CurrentMap.MapLifeComponent
  if not self:isEnabledMap(mob.CurrentMap) then
    return 1
  end
  if not self:isDedicatedMob(mapLife, mob) then
    return 1
  end
  local viewerPoolKey = self:getCurrentPoolKey(viewer)
  if viewerPoolKey == "" or self:isPoolKeyOwnedByPlayer(viewer, self:getOwnerPlayerId(mapLife, mob)) then
    return 1
  end
  return 0.1
end

function DedicatedMonsterLogic.initMobByIDForPlayer(self, mapLife, mobID, position, summonType, dwData, mobType, faceLeft, playerId)

end

function DedicatedMonsterLogic.isDedicatedMob(self, mapLife, mob)
  if not self:isEnabledMap(mapLife.Entity) then
    return false
  end
  return mob and mob.MobComponent and mob.MobComponent.dedicatedMonster
end

function DedicatedMonsterLogic.isEnabledMap(self, map)
  if not map then
    local localPlayer = ___MOD._UserService.LocalPlayer
    map = localPlayer and localPlayer.CurrentMap or nil
  end
  if not map then
    return false
  end
  local cache = self._T.enabledMapCache
  if not cache then
    self._T.enabledMapCache = {}
    cache = self._T.enabledMapCache
  end
  local mapId = map.Id
  local cached = cache[mapId]
  if cached ~= nil then
    return cached
  end
  local mapInfo = map and map.MapInfoComponent or nil
  local mapID = mapInfo and mapInfo.mapID or 0
  local enabled = false
  for i = 1, #self.enabledMapIds do
    if self.enabledMapIds[i] == mapID then
      enabled = true
      break
    end
  end
  cache[mapId] = enabled
  return enabled
end

function DedicatedMonsterLogic.isOwnedMob(self, player, mob)
  if not player or not player.CurrentMap then
    return false
  end
  local mapLife = player.CurrentMap.MapLifeComponent
  if not self:isEnabledMap(player.CurrentMap) then
    return true
  end
  if not self:isDedicatedMob(mapLife, mob) then
    return true
  end
  return self:isPoolKeyOwnedByPlayer(player, self:getOwnerPlayerId(mapLife, mob))
end

function DedicatedMonsterLogic.isPoolKeyOwnedByPlayer(self, player, ownerKey)
  if not (player and player.Player) or ownerKey == nil or ownerKey == "" then
    return false
  end
  if self:getCurrentPoolKey(player) == ownerKey then
    return true
  end
  local playerId = player.Player.PlayerId or ""
  if playerId ~= "" and ownerKey == self:makePlayerPoolKey(playerId) then
    return true
  end
  local partyId = player.Player.PartyId or 0
  if 0 < partyId and ownerKey == self:makePartyPoolKey(partyId) then
    return true
  end
  return false
end

function DedicatedMonsterLogic.isSameOwnerMob(self, sourceMob, targetMob)
  if not sourceMob or not sourceMob.CurrentMap then
    return false
  end
  local mapLife = sourceMob.CurrentMap.MapLifeComponent
  if not self:isEnabledMap(sourceMob.CurrentMap) then
    return true
  end
  if not self:isDedicatedMob(mapLife, sourceMob) or not self:isDedicatedMob(mapLife, targetMob) then
    return true
  end
  return self:getOwnerPlayerId(mapLife, sourceMob) == self:getOwnerPlayerId(mapLife, targetMob)
end

function DedicatedMonsterLogic.makePartyPoolKey(self, partyId)
  return "party:" .. ___MOD.tostring(partyId)
end

function DedicatedMonsterLogic.makePlayerPoolKey(self, playerId)
  return "player:" .. playerId
end

function DedicatedMonsterLogic.migrateOrphanedPools(self, mapLife, runtime, poolKeyChanges, currentPools, previousPools)

end

function DedicatedMonsterLogic.mobPtInBox(self, lp, pt)

end

function DedicatedMonsterLogic.onMobRemoved(self, lp, mob, force)

end

function DedicatedMonsterLogic.registerDedicatedMob(self, mapLife, mob, playerId)

end

function DedicatedMonsterLogic.resetDedicatedPool(self, mapLife, runtime, poolKey)

end

function DedicatedMonsterLogic.resolvePoolKeyForUser(self, mapLife, user, partyCounts)

end

function DedicatedMonsterLogic.setPlayerPoolKey(self, user, poolKey)

end

function DedicatedMonsterLogic.transferPoolOwnership(self, mapLife, runtime, oldKey, newKey, carryAuthorization)

end

function DedicatedMonsterLogic.tryCreateMob(self, mapLife, curTime, reset)

end
