

function FootholdLogic.canGoThrough(self, map, startPos, hitPt, originFh)
  local direction = ___MOD.Vector2.Normalize(hitPt - startPos)
  local distance = ___MOD.Vector2.Distance(hitPt, startPos)
  local fhc = map.FootholdComponent
  local allThroughs = fhc:RaycastAll(startPos, direction, distance)
  local delta = hitPt - startPos
  local getZMass = self.getZMass
  local zMass = originFh == 0 and 0 or getZMass(self, map, originFh)
  local pFirstCollide = 1
  local qFirstCollide = 2
  local firstCollideCW = 0
  local firstCollideCCW = 0
  local crossProduct = ___MOD._NumberUtils.crossProduct
  local nu = ___MOD._NumberUtils
  local isBlockedArea = self.isBlockedArea
  local getFoothold = fhc.GetFoothold
  local abs = ___MOD.math.abs
  for _, fh in ___MOD.ipairs(allThroughs) do
    local fhZMass = getZMass(self, map, fh.Id)
    if 0 < fh.Variance.x or originFh == 0 or fhZMass == 0 or fhZMass == zMass then
      local ground = fh.EndPoint - fh.StartPoint
      local c1 = crossProduct(nu, ground, startPos - fh.StartPoint)
      local c2 = crossProduct(nu, ground, hitPt - fh.StartPoint)
      if c1 <= 0 and 0 <= c2 and (c1 ~= 0 or c2 ~= 0) then
        local c3 = crossProduct(nu, hitPt - startPos, fh.StartPoint - startPos)
        local c4 = crossProduct(nu, hitPt - startPos, fh.EndPoint - startPos)
        if (not (c3 < 0) or not (c4 < 0)) and (c3 <= 0 or c4 <= 0) then
          local prevId = 0
          local nextId = 0
          if c3 ~= 0 then
            if c4 == 0 then
              nextId = fh.NextFootholdId
              if nextId == 0 or isBlockedArea(self, map, fh.Id, nextId, hitPt) then
                goto lbl_213
              end
              prevId = fh.Id
            else
              prevId = fh.Id
              nextId = fh.Id
            end
          else
            prevId = fh.PreviousFootholdId
            if prevId ~= 0 and not isBlockedArea(self, map, prevId, fh.Id, hitPt) then
              nextId = fh.Id
              local v23 = abs(crossProduct(nu, delta, ground))
              local v24 = abs(crossProduct(nu, ground, startPos) + crossProduct(nu, fh.StartPoint, fh.EndPoint))
              local nextFh = getFoothold(fhc, nextId)
              local prevFh = getFoothold(fhc, prevId)
              local firstCollideCWFh = getFoothold(fhc, firstCollideCW)
              local firstCollideCCWFh = getFoothold(fhc, firstCollideCCW)
              local v25 = qFirstCollide * v23 - pFirstCollide * v24
              if v25 == 0 then
                local k1a = nextFh.StartPoint - firstCollideCWFh.StartPoint
                local k1b = firstCollideCWFh.EndPoint - firstCollideCWFh.StartPoint
                local k2a = prevFh.EndPoint - firstCollideCCWFh.StartPoint
                local k2b = firstCollideCCWFh.EndPoint - firstCollideCCWFh.StartPoint
                local value1 = crossProduct(nu, k1b, k1a)
                local value2 = crossProduct(nu, k2b, k2a)
                if value1 < 0 then
                  firstCollideCW = nextFh.Id
                end
                if value2 < 0 then
                  firstCollideCCW = prevFh.Id
                end
              elseif 0 < v25 then
                pFirstCollide = v23
                qFirstCollide = v24
                firstCollideCW = nextFh.Id
                firstCollideCCW = prevFh.Id
              end
            end
          end
        end
      end
    end
    ::lbl_213::
  end
  if firstCollideCW ~= 0 and firstCollideCCW ~= 0 then
    local scaleFactor = qFirstCollide / pFirstCollide
    local collisionPos = delta * scaleFactor + startPos
    hitPt.x = collisionPos.x
    hitPt.y = collisionPos.y
    return false
  end
  return true
end

function FootholdLogic.getCrossCandidate(self, map, x1, y1, x2, y2, output)
  local RTree = map.RTree
  local l, t, r, b
  if x2 <= x1 then
    l = x2
    r = x1
  else
    l = x1
    r = x2
  end
  if y1 <= y2 then
    t = y2
    b = y1
  else
    t = y1
    b = y2
  end
  RTree:SearchMSW(l, t, r, b, output)
end

function FootholdLogic.getFootholdAbove_withDistance(self, map, x, y, yMax)
  local pos = ___MOD.FastVector2(x, y)
  local raycast = map.FootholdComponent:Raycast(pos, self.up, yMax)
  if raycast ~= nil then
    return raycast.Id, raycast:GetYByX(x)
  end
  return nil, nil
end

function FootholdLogic.getFootholdClosest(self, map, x, y, ptHitX)
  local fhc = map.FootholdComponent
  if fhc == nil then
    return x, y
  end
  local mapInfo = map.MapInfoComponent
  local mbr = mapInfo:getMapBound()
  local mbrLeft = mbr.left + 0.1
  local mbrRight = mbr.right - 0.1
  local minimum = ___MOD.math.huge
  local closestFoothold, pcx, pcy
  for _, f in ___MOD.pairs(fhc:GetFootholdAll()) do
    local fh = f
    local x1, y1 = fh.StartPoint.x, fh.StartPoint.y
    local x2, y2 = fh.EndPoint.x, fh.EndPoint.y
    if x1 < x2 then
      local hitX = ptHitX - x < 0
      if x < ptHitX then
        if x > x1 then
          goto lbl_127
        end
        hitX = ptHitX - x < 0
      end
      if (not ((not (ptHitX < 0) or not hitX) and (not (0 < ptHitX) or hitX)) or x >= x2) and y1 <= y + 1.0 and y2 <= y + 1.0 then
        local xDist, yDist
        if ptHitX <= x then
          if ptHitX < x then
            xDist = x2 - x
          else
            xDist = (x1 + x2) * 0.5 - x
          end
        else
          xDist = x1 - x
        end
        if ptHitX <= x then
          if x <= ptHitX then
            yDist = (y2 + y1) * 0.5
          else
            yDist = y2
          end
        else
          yDist = y1
        end
        local dx = xDist
        local dy = yDist - y
        local dist = dx * dx + dy * dy
        if minimum > dist then
          local xPos = x1
          if x > xPos and (x >= x2 or 0 <= x - (xPos + x2) * 0.5) then
            xPos = x2
          end
          local t = (xPos - x1) / (x2 - x1)
          local yPos = y1 + (y2 - y1) * t
          if mbrLeft >= xPos then
            xPos = mbrLeft
          elseif mbrRight <= xPos then
            xPos = mbrRight
          end
          if self:isPointInMBR(map, xPos, yPos) then
            pcx = xPos
            pcy = yPos
            minimum = dist
            closestFoothold = fh
          end
        end
      end
    end
    ::lbl_127::
  end
  if closestFoothold == nil then
    if x <= mbrLeft then
      x = mbrLeft
    elseif mbrRight <= x then
      x = mbrRight
    end
    for _, f in ___MOD.pairs(fhc:GetFootholdAll()) do
      local fh = f
      local x1, y1 = fh.StartPoint.x, fh.StartPoint.y
      local x2, y2 = fh.EndPoint.x, fh.EndPoint.y
      if x1 < x2 then
        local centerX = (x1 + x2) * 0.5
        local centerY = (y1 + y2) * 0.5
        local dx = centerX - x
        local dy = centerY - y
        local MinY = dx * dx + dy * dy
        if minimum > MinY then
          local x1Candidate
          if x > x1 then
            if x < x2 then
              local mid = centerX
              if x - mid < 0 then
                x1Candidate = x1
              else
                x1Candidate = x2
              end
            else
              x1Candidate = x2
            end
          else
            x1Candidate = x1
          end
          local t = (x1Candidate - x1) / (x2 - x1)
          local y2Pos = y1 + (y2 - y1) * t
          if mbrLeft >= x1Candidate then
            x1Candidate = mbrLeft
          elseif mbrRight <= x1Candidate then
            x1Candidate = mbrRight
          end
          if self:isPointInMBR(map, x1Candidate, y2Pos) then
            pcx = x1Candidate
            pcy = y2Pos
            minimum = MinY
            closestFoothold = fh
          end
        end
      end
    end
  end
  return pcx and pcx or x, pcy and pcy or y
end

function FootholdLogic.getFootholdRandom(self, map, count, range)
  if count == 0 then
    return
  end
  local rcArea = range
  local elementsToPlace = count * 2
  local randArray = ___MOD._TableUtils:get_random_unique_array(0, elementsToPlace, elementsToPlace)
  local rcLeft = ___MOD.math.floor((rcArea.Position.x - rcArea.Size.x / 2) * 100)
  local rcRight = ___MOD.math.floor((rcArea.Position.x + rcArea.Size.x / 2) * 100)
  local rcTop = ___MOD.math.floor((rcArea.Position.y + rcArea.Size.y / 2) * 100)
  local rcBottom = ___MOD.math.floor((rcArea.Position.y - rcArea.Size.y / 2) * 100)
  local nStart = rcLeft
  local nGrid = (rcRight - rcLeft + 1) / elementsToPlace
  local returned = 0
  local output = {}
  for _, elem in ___MOD.ipairs(randArray) do
    local x = nStart + ___MOD._GlobalRand32:randomIntegerRange(0, nGrid - 1) + nGrid * elem
    local lYPos = {}
    self:getFootholdRange(map, x / 100, rcTop / 100, rcBottom / 100, lYPos)
    if #lYPos ~= 0 then
      local randomPoint = lYPos[___MOD._GlobalRand32:randomIntegerRange(1, #lYPos)]
      returned = returned + 1
      output[#output + 1] = ___MOD.Vector3(x / 100, randomPoint, 0)
      if count <= returned then
        break
      end
    end
  end
  return output
end

function FootholdLogic.getFootholdRange(self, map, x, y1, y2, output)
  local fh = map.FootholdComponent
  if not fh then
    return
  end
  local yMin = ___MOD.math.min(y1, y2)
  local yMax = ___MOD.math.max(y1, y2)
  local visited = {}

  local function getFoothold(footholds)
    for _, f in ___MOD.ipairs(footholds) do
      local foothold = f
      local fhId = foothold.Id
      if visited[fhId] == nil then
        visited[fhId] = 1
        local y = foothold:GetYByX(x)
        if y >= yMin and y <= yMax then
          output[#output + 1] = y
        end
      end
    end
  end

  local centerY = (y1 + y2) / 2
  local dist = ___MOD.math.abs(y1 - y2)
  local fhUP = fh:RaycastAll(___MOD.Vector2(x, centerY), ___MOD.Vector2.up, dist)
  local fhDOWN = fh:RaycastAll(___MOD.Vector2(x, centerY), ___MOD.Vector2.down, dist)
  getFoothold(fhUP)
  getFoothold(fhDOWN)
end

function FootholdLogic.getFootholdUnderneath(self, entity, offsetY)
  local pos = entity.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  pos[2] = pos[2] + offsetY
  local raycast = entity.CurrentMap.FootholdComponent:Raycast(pos, self.down, 1000)
  if raycast ~= nil then
    return raycast.Id
  end
  return 0
end

function FootholdLogic.getFootholdUnderneath_withDistance(self, map, x, y, yMin)
  local pos = ___MOD.FastVector2(x, y)
  local raycast = map.FootholdComponent:Raycast(pos, self.down, yMin)
  if raycast ~= nil then
    return raycast.Id, raycast:GetYByX(x)
  end
  return nil, nil
end

function FootholdLogic.getFootholdUnderneathByPoint(self, map, x, y)
  local pos = ___MOD.FastVector2(x, y)
  local raycast = map.FootholdComponent:Raycast(pos, self.down, 1000)
  if raycast ~= nil then
    return raycast.Id
  end
  return 0
end

function FootholdLogic.getForwardLink(self, map, _fh, dir, x, len)
  local fh = _fh
  if fh == nil then
    return nil
  end
  if dir == 0 then
    return fh
  end
  local remainingLen = len
  local var = fh.Variance
  local footholdLen
  if dir < 0 then
    footholdLen = var.x * (x - fh.StartPoint.x)
  else
    footholdLen = var.x * (fh.EndPoint.x - x)
  end
  remainingLen = remainingLen - footholdLen
  local fhs = map.FootholdComponent
  local min = ___MOD.math.min
  while 0 < remainingLen do
    if dir < 0 then
      local prevId = fh.PreviousFootholdId
      if prevId == 0 then
        return nil
      end
      fh = fhs:GetFoothold(prevId)
    else
      local nextId = fh.NextFootholdId
      if nextId == 0 then
        return nil
      end
      fh = fhs:GetFoothold(nextId)
    end
    remainingLen = remainingLen - min(remainingLen, fh.Length)
  end
  return fh
end

function FootholdLogic.getZMass(self, map, fhId)
  return map.PlatformInfoComponent.ZMass[fhId] or 0
end

function FootholdLogic.isBlockedArea(self, map, fhId1, fhId2, pos)
  local fh1 = map.FootholdComponent:GetFoothold(fhId1)
  local fh2 = map.FootholdComponent:GetFoothold(fhId2)
  local v1 = fh1.EndPoint - fh1.StartPoint
  local v2 = fh2.EndPoint - fh1.StartPoint
  local v9 = ___MOD._NumberUtils:crossProduct(v1, v2)
  local c1 = ___MOD._NumberUtils:crossProduct(pos - fh1.StartPoint, fh1.EndPoint - fh1.StartPoint)
  local c2 = ___MOD._NumberUtils:crossProduct(pos - fh2.StartPoint, fh2.EndPoint - fh2.StartPoint)
  if v9 <= 0 then
    if c1 <= 0 and 0 <= c2 then
      return false
    end
  elseif c1 <= 0 or 0 <= c2 then
    return false
  end
  return true
end

function FootholdLogic.isPointInMBR(self, map, x, y)
  local mapInfo = map.MapInfoComponent
  if mapInfo == nil then
    return false
  end
  local bound = mapInfo:getMapBound()
  return x >= bound.left and x <= bound.right and y >= bound.bottom and y <= bound.top
end
