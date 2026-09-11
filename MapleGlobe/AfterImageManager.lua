

function AfterImageManager.getAfterIamageAnim(self, weaponKey, masteryLevel, motionKey, charge)
  local path
  if charge then
    path = ___MOD.string.format("%s.img/charge/%d/%s", weaponKey, masteryLevel, motionKey)
  else
    path = ___MOD.string.format("%s.img/%d/%s", weaponKey, masteryLevel, motionKey)
  end
  local getCache = self.getAfterImageCache[path]
  if getCache and getCache[5] then
    return getCache[5]
  end
  local startFrameIdx, node = self:getAfterImageData(weaponKey, masteryLevel, motionKey, charge)
  if not startFrameIdx or not node then
    return nil
  end
  node = node[___MOD.tostring(startFrameIdx)]
  if node then
    local anim = ___MOD._WzUtils:parseAnimation(node)
    if not getCache then
      self.getAfterImageCache[path] = {}
      getCache = self.getAfterImageCache[path]
    end
    getCache[5] = anim
    return anim
  end
  return nil
end

function AfterImageManager.getAfterImageData(self, weaponKey, masteryLevel, motionKey, charge)
  local path
  if charge then
    path = ___MOD.string.format("%s.img/charge/%d/%s", weaponKey, masteryLevel, motionKey)
  else
    path = ___MOD.string.format("%s.img/%d/%s", weaponKey, masteryLevel, motionKey)
  end
  local getCache = self.getAfterImageCache[path]
  if getCache and getCache[3] and getCache[4] then
    return getCache[3], getCache[4]
  end
  local node = self:getAfterImageNode(path)
  if node and ___MOD.type(node) == "table" then
    for frameIdx, frame in ___MOD.pairs(node) do
      local idx = ___MOD.tonumber(frameIdx)
      if idx then
        if not getCache then
          self.getAfterImageCache[path] = {}
          getCache = self.getAfterImageCache[path]
        end
        getCache[3] = idx
        getCache[4] = node
        return idx, node
      end
    end
  end
  return nil, nil
end

function AfterImageManager.getAfterImageLtRb(self, weaponKey, masteryLevel, motionKey, charge)
  local path
  if charge then
    path = ___MOD.string.format("%s.img/charge/%d/%s", weaponKey, masteryLevel, motionKey)
  else
    path = ___MOD.string.format("%s.img/%d/%s", weaponKey, masteryLevel, motionKey)
  end
  local getCache = self.getAfterImageCache[path]
  if getCache and getCache[1] and getCache[2] then
    return getCache[1], getCache[2]
  end
  local node = self:getAfterImageNode(path)
  if node then
    local lt = ___MOD._WzUtils:getVector(node.lt, nil)
    local rb = ___MOD._WzUtils:getVector(node.rb, nil)
    if not getCache then
      self.getAfterImageCache[path] = {}
      getCache = self.getAfterImageCache[path]
    end
    getCache[1] = lt
    getCache[2] = rb
    return lt, rb
  end
  return nil, nil
end

function AfterImageManager.getAfterImageNode(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.afterImage
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
      cacheTbl[path] = node
      return node
    end
    pos = s + 1
  end
end

function AfterImageManager.getAnim(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.afterImage
  local pos = 1
  while node do
    local s, e = find(path, "/", pos, true)
    local key = s and sub(path, pos, s - 1) or sub(path, pos)
    node = node[key]
    if not node then
      cacheTbl[path] = nil
      return nil
    end
    if not s then
      local anim
      if node then
        anim = ___MOD._WzUtils:parseAnimation(node)
      end
      cacheTbl[path] = anim
      return anim
    end
    pos = s + 1
  end
end

function AfterImageManager.loadData(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local dataCache = {}
  local hitEffectCache = {}
  local afterImage = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Afterimage")
  if ___MOD.type(afterImage) ~= "table" then
    ___MOD.log("Afterimage data is not table")
    afterImage = {}
  end
  self.afterImage = afterImage
  for weaponKey, weaponData in ___MOD.pairs(afterImage) do
    local trimmedKey, k = ___MOD.string.gsub(weaponKey, "%.img$", "")
    if trimmedKey ~= "blank" and trimmedKey == "hit" then
      hitEffectCache = self:parseHit(weaponData, trimmedKey)
    else
    end
  end
  self.data = dataCache
  self.hitEffect = hitEffectCache
  ___MOD.log(___MOD.string.format("Loaded Afterimage Data (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end

function AfterImageManager.parseAfterimage(self, data, weaponKey)
  local result = {}
  for masteryKey, masteryValue in ___MOD.pairs(data) do
    result[masteryKey] = {}
    local isSubMastery = false
    for k, _ in ___MOD.pairs(masteryValue) do
      if ___MOD.tonumber(k) then
        isSubMastery = true
        break
      end
    end
    if isSubMastery then
      for subMasteryKey, motions in ___MOD.pairs(masteryValue) do
        local data = self:parseMotions(motions, weaponKey, 0, 0, 0, true)
        result[masteryKey][subMasteryKey] = data
      end
    else
      result[masteryKey] = self:parseMotions(masteryValue, weaponKey, ___MOD.tonumber(masteryKey), 0, 0, false)
    end
  end
  return result
end

function AfterImageManager.parseHit(self, data, weaponKey)
  local result = {}
  for key, d in ___MOD.pairs(data) do
    result[key] = {}
    result[key].anim = {}
    local count = 0
    for frameName, frameData in ___MOD.pairs(d) do
      if frameName == "fixed" then
        local fixedValue = frameData
        if ___MOD.type(frameData) == "table" and frameData.fixed ~= nil then
          fixedValue = frameData.fixed
        end
        result[key][frameName] = ___MOD._WzUtils:getInteger(fixedValue, 0)
      elseif ___MOD.type(frameData) == "table" then
        local ruidPath = ""
        ruidPath = ___MOD.string.format("Character.Afterimage.hit.%s.%s", ___MOD.tostring(key), ___MOD.tostring(frameName))
        result[key].anim[___MOD.tonumber(frameName + 1)] = {
          A0 = ___MOD._WzUtils:getInteger(frameData.a0, 255),
          A1 = ___MOD._WzUtils:getInteger(frameData.a1, 255),
          Z0 = 1,
          Z1 = 1,
          width = frameData._width,
          height = frameData._height,
          origin = ___MOD._WzUtils:getFastVector(frameData.origin, ___MOD.FastVector2.zero:Clone()),
          z = ___MOD._WzUtils:getInteger(frameData.z, 0),
          RUID = ___MOD.__RUIDManager:get(ruidPath),
          delay = ___MOD._WzUtils:getInteger(frameData.delay, 100)
        }
        count = count + 1
      end
    end
    result[key].SpriteSize = count
  end
  return result
end

function AfterImageManager.parseMotions(self, motions, weaponKey, masteryLevel, skillbook, skillID, charge)
  local motionSet = {}
  for motionName, motionData in ___MOD.pairs(motions) do
    local motion = {}
    local startFrameIndex
    for key, spriteData in ___MOD.pairs(motionData) do
      if key == "lt" or key == "rb" then
        motion[key] = ___MOD._WzUtils:getVector(spriteData, ___MOD.FastVector2.zero:Clone())
        self.count = self.count + 1
      elseif ___MOD.tonumber(key) or key == "charge" then
        local frameIndex = key
        if key ~= "charge" and (not startFrameIndex or startFrameIndex > ___MOD.tonumber(frameIndex)) then
          startFrameIndex = ___MOD.tonumber(frameIndex)
        end
        motion[frameIndex] = {}
        local c = 0
        if masteryLevel == -1 then
          motion[frameIndex] = ___MOD._WzUtils:parseAnimation(spriteData)
        end
        for spriteIdxStr, sprite in ___MOD.pairs(spriteData) do
          local spriteIdx = ___MOD.tonumber(spriteIdxStr)
          if spriteIdx and ___MOD.type(sprite) == "table" then
            local ruid = ""
            c = c + 1
            ruid = ___MOD.__RUIDManager:get(sprite.image)
            motion[frameIndex][spriteIdxStr] = {
              origin = ___MOD._WzUtils:getFastVector(sprite.origin, ___MOD.FastVector2.zero:Clone()),
              delay = ___MOD._WzUtils:getInteger(sprite.delay, 0),
              a1 = ___MOD._WzUtils:getInteger(sprite.a1, 255),
              ruid = ruid,
              width = sprite._width,
              height = sprite._height
            }
          end
        end
        motion[frameIndex].SpriteSize = c
        self.count = self.count + 1
      end
    end
    motion.StartFrameIndex = startFrameIndex or 0
    motionSet[motionName] = motion
  end
  return motionSet
end
