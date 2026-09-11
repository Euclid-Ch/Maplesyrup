

function MapUtils.calculateLandingPosition(self, map, dropPos, jumpHeight)
  local currentPosition = dropPos
  currentPosition.y = currentPosition.y + jumpHeight
  local footholdComponent = map.FootholdComponent
  if footholdComponent == nil then
    ___MOD.log("FootholdComponent가 없습니다.")
    return
  end
  local nearestFoothold = footholdComponent:GetNearestFootholdByPoint(currentPosition, 100)
  if nearestFoothold == nil then
    ___MOD.log("가까운 발판이 없습니다.")
    return
  end
  local direction = ___MOD.FastVector2(0, -1)
  local distance = 100
  local landingFoothold = footholdComponent:Raycast(currentPosition, direction, distance)
  if landingFoothold == nil then
    landingFoothold = nearestFoothold
  end
  local fhBase = ___MOD._EntityService:GetEntity(landingFoothold.OwnerId)
  local layer = fhBase.SpriteRendererComponent.SortingLayer
  local yPos = landingFoothold:GetYByX(currentPosition.x)
  local landingPosition = ___MOD.FastVector3(currentPosition.x, landingFoothold:GetYByX(currentPosition.x), 0)
  local distanceToLanding = currentPosition:Distance(landingPosition:ToVector2())
  return landingPosition, layer, distanceToLanding
end

function MapUtils.getFullNameById(self, mapId)
  local mapCategory = ___MOD._StringPoolManager:getMapCategoryById(mapId)
  local mapName = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Map.img/%s/%d/mapName", mapCategory, ___MOD.tonumber(mapId)))
  local streetName = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Map.img/%s/%d/streetName", mapCategory, ___MOD.tonumber(mapId)))
  if mapName ~= nil and mapName ~= "" and streetName ~= nil and streetName ~= "" then
    return streetName .. " : " .. mapName
  end
  return "알 수 없음"
end

function MapUtils.getMapIdByName(self, mapName)
  local num = ___MOD.string.match(mapName, "^map_(%d+)$")
  return ___MOD.tonumber(num) or 0
end

function MapUtils.getMapNameById(self, mapId)
  local mapCategory = ___MOD._StringPoolManager:getMapCategoryById(___MOD.tonumber(mapId))
  local mapName = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Map.img/%s/%d/mapName", mapCategory, ___MOD.tonumber(mapId)))
  if mapName ~= nil and mapName ~= "" then
    return mapName
  end
  return "알 수 없음"
end

function MapUtils.getStreetNameById(self, mapId)
  local mapCategory = ___MOD._StringPoolManager:getMapCategoryById(___MOD.tonumber(mapId))
  local streetName = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Map.img/%s/%d/streetName", mapCategory, ___MOD.tonumber(mapId)))
  if streetName ~= nil and streetName ~= "" then
    return streetName
  end
  return "알 수 없음"
end
