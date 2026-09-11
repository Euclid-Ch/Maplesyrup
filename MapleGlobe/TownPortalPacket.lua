

function TownPortalPacket.enterField(self, map, door, enterType, targetUser)

end

function TownPortalPacket.enterField_ToClient(self, ownerID, pos, enterType)
  local user = ___MOD._UserService.LocalPlayer
  local curMap = user.CurrentMap
  local tpPool = curMap.MapLifeComponent.townPortalPool
  local tp = tpPool:getDoor_Client(ownerID)
  if tp then
    return
  end
  local townPortal = ___MOD._ObjectPool:pick(curMap.MapObjectPool.townPortalPool, "Door", ___MOD._EntryService:GetModelIdByName("TownPortal"), pos:ToVector3(), curMap, false)
  townPortal.TownPortalComponent:onTownPortalCreated(ownerID, enterType, false)
  tpPool:insertDoor_Client(ownerID, townPortal)
end

function TownPortalPacket.leaveField(self, map, door, leaveType, targetUser)

end

function TownPortalPacket.leaveField_ToClient(self, ownerID, leaveType)
  local user = ___MOD._UserService.LocalPlayer
  local curMap = user.CurrentMap
  local tpPool = curMap.MapLifeComponent.townPortalPool
  local tp = tpPool:getDoor_Client(ownerID)
  if tp then
    tp.TownPortalComponent:leaveField(leaveType)
    tpPool:removeDoor_Client(ownerID)
  end
end

function TownPortalPacket.tryEnterTownPortal(self, isTown, ownerID, senderUserId)

end
