

function WzUtils.getBoolean(self, data, default)
  local v = self:unwrapValue(data)
  if v == nil then
    return default
  end
  if ___MOD.type(v) == "boolean" then
    return v
  end
  local num = ___MOD.tonumber(v)
  if num == nil then
    return default
  end
  return num ~= 0
end

function WzUtils.getDouble(self, data, default)
  local v = self:unwrapValue(data)
  if v == nil then
    return default
  end
  return ___MOD.tonumber(v) or default
end

function WzUtils.getFastVector(self, data, default)
  if data == nil then
    return default
  end
  local x = ___MOD.tonumber(data.x) or 0
  local y = ___MOD.tonumber(data.y) or 0
  return ___MOD.FastVector2(x, y)
end

function WzUtils.getImageRUID(self, data, default)
  local path = data and data.image
  if ___MOD._UtilLogic:IsNilorEmptyString(path) then
    return default
  end
  local RUID = ___MOD.__RUIDManager:get(path)
  return RUID
end

function WzUtils.getInteger(self, data, default)
  local v = self:unwrapValue(data)
  if v == nil then
    return default
  end
  return ___MOD.tonumber(v) or default
end

function WzUtils.getSize(self, data, default)
  if data == nil then
    return default
  end
  local w = ___MOD.tonumber(data._width) or 0
  local h = ___MOD.tonumber(data._height) or 0
  return ___MOD.Vector2(w, h)
end

function WzUtils.getString(self, data, default)
  local v = self:unwrapValue(data)
  if v == nil then
    return default
  end
  if ___MOD.type(v) == "string" then
    return v
  end
  return v or default
end

function WzUtils.getVector(self, data, default)
  if data == nil then
    return default
  end
  local x = ___MOD.tonumber(data.x) or 0
  local y = ___MOD.tonumber(data.y) or 0
  return ___MOD.Vector2(x, y)
end

function WzUtils.getWzTbl(self, node, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local pos = 1
  while node do
    local s, e = find(path, "/", pos, true)
    local key = s and sub(path, pos, s - 1) or sub(path, pos)
    node = node[key]
    if not node then
      cacheTbl[path] = ""
      return nil
    end
    if not s then
      local v = node or nil
      cacheTbl[path] = v
      return v
    end
    pos = s + 1
  end
end

function WzUtils.intToARGB(self, v)
  v = v % 4294967296
  local a = v >> 24 & 255
  local r = v >> 16 & 255
  local g = v >> 8 & 255
  local b = v & 255
  local k = 0.00392156862745098
  return a * k, r * k, g * k, b * k
end

function WzUtils.parseAnimation(self, dir)
  return self:parseAnimation_(dir, nil)
end

function WzUtils.parseAnimation_(self, dir, parseIndex)
  local cache = {}
  cache.anim = {}
  cache.RUIDs = {}
  cache.asynced = false
  local anim = cache.anim
  local isClient = self:IsClient()
  if ___MOD.type(dir) ~= "table" then
    ___MOD.log_warning("[parseAnimation] 입력된 값 Table이 아닙니다. : " .. ___MOD.tostring(dir))
    return nil
  end
  local totalDelay = 0
  local unionBox
  local idx = 1
  for key, value in ___MOD.pairs(dir) do
    local keyStr = ___MOD.tostring(key):lower()
    local frameIndex = ___MOD.tonumber(keyStr)
    if parseIndex == nil or frameIndex == parseIndex then
      if frameIndex ~= nil then
        if ___MOD.type(value) == "table" then
          local lt = ___MOD._WzUtils:getFastVector(value.lt, nil)
          local rb = ___MOD._WzUtils:getFastVector(value.rb, nil)
          local collisionOffset, boxSize
          if lt ~= nil and rb ~= nil then
            collisionOffset, boxSize = ___MOD._NumberUtils:getTriggerBoxFromLtRb(lt, rb, true)
            if not isClient then
              unionBox = self:updateUnionBox(unionBox, collisionOffset, boxSize)
            end
          end
          if not isClient then
            totalDelay = totalDelay + ___MOD._WzUtils:getInteger(value.delay, 100)
          else
            local frame = ___MOD.SpriteFrame()
            local imageKey = ___MOD._WzUtils:getString(value.image, "")
            local ruid = ___MOD.__RUIDManager:get(imageKey)
            if not ___MOD._UtilLogic:IsNilorEmptyString(imageKey) and imageKey:find("afterimage") and (ruid == "" or ruid == nil) then
              local dotPos = imageKey:match("^(.*)%.")
              if dotPos then
                imageKey = dotPos
                ruid = ___MOD.__RUIDManager:get(imageKey)
              end
              if ruid == "" or ruid == nil then
                dotPos = imageKey:match("^(.*)%.")
                if dotPos then
                  imageKey = dotPos
                  ruid = ___MOD.__RUIDManager:get(imageKey)
                end
              end
            end
            frame.RUID = ruid
            if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
              cache.RUIDs[#cache.RUIDs + 1] = ruid
            end
            local w = ___MOD._WzUtils:getInteger(value._width, 0)
            local h = ___MOD._WzUtils:getInteger(value._height, 0)
            frame.spriteSize = ___MOD.FastVector2(w, h)
            local spriteSize = frame.spriteSize
            local originP = ___MOD._WzUtils:getFastVector(value.origin, ___MOD.FastVector2(0, 0))
            local offsetX, offsetY = ___MOD._OffsetUtils:GetEvenPivotOffset(spriteSize.x, spriteSize.y, originP.x, originP.y, false)
            frame.originOffset = ___MOD.FastVector3(offsetX / 100.0, offsetY / 100.0, 0)
            frame.originOffsetFlip = ___MOD.FastVector3(-offsetX / 100.0, offsetY / 100.0, 0)
            offsetX, offsetY = ___MOD._OffsetUtils:GetEvenPivotOffset(spriteSize.x, spriteSize.y, originP.x, originP.y, true)
            frame.originHalfOffset = ___MOD.FastVector3(offsetX / 100.0, offsetY / 100.0, 0)
            frame.originHalfOffsetFlip = ___MOD.FastVector3(-offsetX / 100.0, offsetY / 100.0, 0)
            frame.originUI = ___MOD.FastVector2(offsetX, offsetY)
            frame.originUIFlip = ___MOD.FastVector2(-offsetX, offsetY)
            if collisionOffset ~= nil and boxSize ~= nil then
              frame.collisionOffset = collisionOffset
              frame.boxSize = boxSize
            else
              frame.collisionOffset = ___MOD.FastVector2(0, 0)
              frame.boxSize = ___MOD.FastVector2(0, 0)
            end
            frame.delay = ___MOD._WzUtils:getInteger(value.delay, 100)
            totalDelay = totalDelay + frame.delay
            frame.A0 = ___MOD._WzUtils:getInteger(value.a0, 255)
            frame.A1 = ___MOD._WzUtils:getInteger(value.a1, frame.A0)
            frame.A0 = frame.A0 / 255
            frame.A1 = frame.A1 / 255
            frame.Z0 = ___MOD._WzUtils:getInteger(value.z0, 100)
            frame.Z1 = ___MOD._WzUtils:getInteger(value.z1, frame.Z0)
            frame.Z0 = frame.Z0 / 100
            frame.Z1 = frame.Z1 / 100
            frame.Z = ___MOD._WzUtils:getInteger(value.z, nil)
            local head = ___MOD._WzUtils:getFastVector(value.head, ___MOD.FastVector2(0, 0))
            frame.head = ___MOD.FastVector3(head.x / 100, -head.y / 100, 0)
            frame.moveType = ___MOD._WzUtils:getInteger(value.moveType, 0)
            frame.moveH = ___MOD._WzUtils:getInteger(value.moveH, 0)
            frame.moveW = ___MOD._WzUtils:getInteger(value.moveW, 0)
            frame.moveP = ___MOD._WzUtils:getInteger(value.moveP, 0)
            frameIndex = frameIndex + 1
            if parseIndex ~= nil then
              frameIndex = idx
              idx = idx + 1
            end
            anim[frameIndex] = frame
          end
        end
      elseif keyStr == "speak" then
        cache.speak = {}
        local speak = cache.speak
        if ___MOD.type(value) == "table" then
          for i2, v2 in ___MOD.pairs(value) do
            local si = ___MOD.tonumber(i2)
            if si then
              si = si + 1
              speak[si] = ___MOD._WzUtils:getString(v2, "")
            end
          end
        end
      elseif keyStr == "zigzag" then
        cache.zigzag = ___MOD._WzUtils:getBoolean(value, false)
      elseif keyStr == "special" then
        cache.special = ___MOD._WzUtils:getBoolean(value, false)
      elseif keyStr == "effect" then
        cache.effect = ___MOD._WzUtils:getString(value, "")
      elseif keyStr == "repeat" then
        cache["repeat"] = ___MOD._WzUtils:getInteger(value, -1) + 1
      elseif keyStr == "pos" then
        cache.pos = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "z" then
        cache.z = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "renderabovetarget" then
        cache.renderAboveTarget = ___MOD._WzUtils:getBoolean(value, false)
      elseif keyStr == "damage" then
        cache.damage = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "dir" then
        cache.dir = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "obstacle" then
        cache.obstacle = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "disease" then
        cache.disease = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "level" then
        cache.level = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "hitafter" then
        cache.hitAfter = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "rotateperiod" then
        cache.rotatePeriod = ___MOD._WzUtils:getInteger(value, 0)
      elseif keyStr == "rect" then
        cache.rect = {}
        local rect = cache.rect
        for i = 0, 100 do
          local rectIdx = ___MOD.tostring(i)
          local rectNode = value[rectIdx]
          if not rectNode == nil then
            break
          end
          local rectInfo = ___MOD.MobRect()
          local lt = ___MOD._WzUtils:getFastVector(rectNode.lt, nil)
          local rb = ___MOD._WzUtils:getFastVector(rectNode.rb, nil)
          if lt ~= nil and rb ~= nil then
            local center, size = ___MOD._NumberUtils:getTriggerBoxFromLtRb(lt, rb, true)
            rectInfo.collisionOffset = center
            rectInfo.boxSize = size
          else
            rectInfo.collisionOffset = ___MOD.FastVector2(0, 0)
            rectInfo.boxSize = ___MOD.FastVector2(0, 0)
          end
        end
      end
    end
  end
  if not isClient and unionBox ~= nil then
    cache.unionBoxOffset = unionBox.offset
    cache.unionBoxSize = unionBox.size
  end
  cache.totalDelay = totalDelay
  return cache
end

function WzUtils.ParseGenericWzCollectionWZ(self, collectionName, key)
  local ds = self.genericCollectionCaches[collectionName] or nil
  if ds == nil then
    ds = ___MOD._DataService:GetTable(collectionName)
    if ds == nil then
      ___MOD.log_error("[ParseGenericWzCollectionWZ] Collection을 찾을 수 없습니다. : " .. collectionName)
      return nil
    end
    self.genericCollectionCaches[collectionName] = ds
  end
  local r = ds:FindRow("key", key)
  if r == nil then
    return nil
  end
  local data = r:GetItem("data")
  if data == nil then
    return nil
  end
  return self:parseWzData(data)
end

function WzUtils.parseWzData(self, data)
  if ___MOD.type(data) == "table" then
    return data
  end
  if ___MOD.type(data) ~= "string" then
    return nil
  end
  local okRaw, rawParsed = ___MOD.pcall(function()
    return ___MOD._JsonUtils:parseJSON(data)
  end)
  if okRaw then
    return rawParsed
  end
  return nil
end

function WzUtils.unwrapValue(self, data)
  if ___MOD.type(data) == "table" and data ~= nil and data.value ~= nil then
    return data.value
  end
  return data
end

function WzUtils.updateUnionBox(self, unionBox, center, size)
  if center == nil or size == nil or size.x <= 0 or 0 >= size.y then
    return unionBox
  end
  if unionBox == nil then
    unionBox = {}
    unionBox.offset = ___MOD.FastVector2(center.x, center.y)
    unionBox.size = ___MOD.FastVector2(size.x, size.y)
    return unionBox
  end
  local halfX = size.x * 0.5
  local halfY = size.y * 0.5
  local left = center.x - halfX
  local right = center.x + halfX
  local bottom = center.y - halfY
  local top = center.y + halfY
  local unionOffset = unionBox.offset
  local unionSize = unionBox.size
  local unionHalfX = unionSize.x * 0.5
  local unionHalfY = unionSize.y * 0.5
  local unionLeft = unionOffset.x - unionHalfX
  local unionRight = unionOffset.x + unionHalfX
  local unionBottom = unionOffset.y - unionHalfY
  local unionTop = unionOffset.y + unionHalfY
  if left < unionLeft then
    unionLeft = left
  end
  if right > unionRight then
    unionRight = right
  end
  if bottom < unionBottom then
    unionBottom = bottom
  end
  if top > unionTop then
    unionTop = top
  end
  unionBox.offset = ___MOD.FastVector2((unionLeft + unionRight) * 0.5, (unionBottom + unionTop) * 0.5)
  unionBox.size = ___MOD.FastVector2(unionRight - unionLeft, unionTop - unionBottom)
  return unionBox
end
