

function MapUtilLogic.findClosestObjectTile(self, worldPos, mapName)
  local bestMatch
  local shortestDistance = ___MOD.math.huge
  local objects = ___MOD._EntityService:GetEntitiesByTag("CustomObject")
  for _, obj in ___MOD.ipairs(objects) do
    if ___MOD.isvalid(obj) and ___MOD.isvalid(obj.ExtendObjectComponent) and obj.CurrentMapName == mapName then
      local comp = obj.ExtendObjectComponent
      local center = obj.TransformComponent.WorldPosition
      local width = comp.width * 0.01
      local height = comp.height * 0.01
      local left = center.x - width / 2.0
      local right = center.x + width / 2.0
      local top = center.y + height / 2.0
      local bottom = center.y - height / 2.0
      local inX = left <= worldPos.x and right >= worldPos.x
      local inY = bottom <= worldPos.y and top >= worldPos.y
      if inX then
        local dist = ___MOD.math.abs(worldPos.y - top)
        if shortestDistance > dist then
          shortestDistance = dist
          bestMatch = obj
        end
      end
    end
  end
  return bestMatch
end

function MapUtilLogic.getDropPoiont(self, worldPos, dir)
  return ___MOD.Vector2.zero
end

function MapUtilLogic.getFootholdTile(self, worldPos, mapName)
  local tiles = ___MOD._EntityService:GetEntitiesByTag("CustomTile")
  local layerGroups = {}
  for _, tile in ___MOD.ipairs(tiles) do
    if ___MOD.isvalid(tile) and tile.CurrentMapName == mapName then
      local comp = tile.ExtendTileComponent
      local center = tile.TransformComponent.WorldPosition
      local width = comp.width * 0.01
      local height = comp.height * 0.01
      local tileLeft = center.x - width / 2.0
      local tileRight = center.x + width / 2.0
      local tileTopY = center.y + height / 2.0
      if tileLeft <= worldPos.x and tileRight >= worldPos.x then
        local dist = ___MOD.math.abs(worldPos.y - tileTopY)
        local layer = tile.SpriteRendererComponent.SortingLayer or 0
        local current = layerGroups[layer]
        if not current or dist < current.distance then
          layerGroups[layer] = {
            tile = tile,
            distance = dist,
            layer = layer
          }
        end
      end
    end
  end
  local filtered = {}
  for _, entry in ___MOD.pairs(layerGroups) do
    ___MOD.table.insert(filtered, entry)
  end
  if #filtered == 0 then
    return self:findClosestObjectTile(worldPos, mapName)
  end
  local DISTANCE_EPSILON = 0.03
  ___MOD.table.sort(filtered, function(a, b)
    if ___MOD.math.abs(a.distance - b.distance) <= DISTANCE_EPSILON then
      return a.layer > b.layer
    else
      return a.distance < b.distance
    end
  end)
  local best = filtered[1]
  if best.distance >= 0.2 then
    return self:findClosestObjectTile(worldPos, mapName)
  end
  return filtered[1].tile
end

function MapUtilLogic.getFormattedMapPath(self, mapID)
  local mapIdStr = ___MOD.string.format("%09d", mapID)
  return "map_" .. mapIdStr
end

function MapUtilLogic.getLadderEntity(self, worldPos, width, height, mapName)
  local function GetSquaredDistance(pos1, pos2)
    local dx = pos1.x - pos2.x

    local dy = pos1.y - pos2.y
    return dx * dx + dy * dy
  end

  local function GetOverlapArea(rect1, rect2)
    local left1 = rect1.x - rect1.width / 2
    local right1 = rect1.x + rect1.width / 2
    local top1 = rect1.y + rect1.height / 2
    local bottom1 = rect1.y - rect1.height / 2
    local left2 = rect2.x - rect2.width / 2
    local right2 = rect2.x + rect2.width / 2
    local top2 = rect2.y + rect2.height / 2
    local bottom2 = rect2.y - rect2.height / 2
    local overlapWidth = ___MOD.math.max(0, ___MOD.math.min(right1, right2) - ___MOD.math.max(left1, left2))
    local overlapHeight = ___MOD.math.max(0, ___MOD.math.min(top1, top2) - ___MOD.math.max(bottom1, bottom2))
    return overlapWidth * overlapHeight
  end

  local function GetLayerValue(layerName)
    if ___MOD.type(layerName) == "string" then
      return ___MOD.tonumber(___MOD.string.match(layerName, "%d+")) or 0
    end
    return 0
  end

  local worldRect = {
    x = worldPos.x,
    y = worldPos.y,
    width = width * 0.01,
    height = height * 0.01
  }
  local objects = ___MOD._EntityService:GetEntitiesByTag("CustomObject")
  local candidates = {}
  local epsilon = 0.001
  for _, tile in ___MOD.ipairs(objects) do
    if ___MOD.isvalid(tile) and tile.CurrentMapName == mapName then
      local comp = tile.ExtendObjectComponent
      local center = tile.TransformComponent.WorldPosition
      local tileRect = {
        x = center.x,
        y = center.y,
        width = comp.width * 0.01,
        height = comp.height * 0.01
      }
      local overlap = GetOverlapArea(worldRect, tileRect)
      if 0 < overlap then
        local tileArea = tileRect.width * tileRect.height
        local sqDist = GetSquaredDistance(worldPos, center)
        local score = overlap / (tileArea + epsilon) / (sqDist + epsilon)
        local layer = GetLayerValue(tile.SpriteRendererComponent.SortingLayer)
        ___MOD.table.insert(candidates, {
          entity = tile,
          score = score,
          layer = layer
        })
      end
    end
  end
  if #candidates == 0 then
    return nil
  end
  local maxLayer = -___MOD.math.huge
  for _, c in ___MOD.ipairs(candidates) do
    if maxLayer < c.layer then
      maxLayer = c.layer
    end
  end
  local topLayerCandidates = {}
  for _, c in ___MOD.ipairs(candidates) do
    if c.layer == maxLayer then
      ___MOD.table.insert(topLayerCandidates, c)
    end
  end
  local best = topLayerCandidates[1]
  for i = 2, #topLayerCandidates do
    if topLayerCandidates[i].score > best.score then
      best = topLayerCandidates[i]
    end
  end
  return best.entity
end

function MapUtilLogic.getPlayerCount(self, mapEntity)
  local playersArr = ___MOD._UserService:GetUsersByMapComponent(mapEntity.MapComponent)
  local count = 0
  if ___MOD.isvalid(playersArr) then
    for _, v in ___MOD.pairs(playersArr) do
      if ___MOD.isvalid(v) then
        count = count + 1
      end
    end
  end
  return count
end
