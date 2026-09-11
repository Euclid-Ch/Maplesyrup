

function TamingMobManager.getCharacterTamingMob(self, tamingMobId, motion)
  local data = self.characterData[tamingMobId]
  if not motion or motion == "" then
    return data
  end
  local byId = self.characterMotionCache[tamingMobId]
  if not byId then
    byId = {}
    self.characterMotionCache[tamingMobId] = byId
  end
  local cached = byId[motion]
  if cached then
    return cached
  end
  local rawMotion = data and data[motion] or nil
  if ___MOD.type(rawMotion) ~= "table" then
    return nil
  end
  local parsed = self:parseCharacterTamingMobMotion(tamingMobId, motion, rawMotion, false, tamingMobId)
  byId[motion] = parsed
  return parsed
end

function TamingMobManager.getCharacterTamingMobNodeByPath(self, path)
  local cached = ___MOD.rawget(self.pathValueCache, path)
  if cached then
    return cached
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(path) then
    return nil
  end
  local split = ___MOD._UtilLogic:Split(path, "/")
  if split == nil or #split < 2 then
    return nil
  end
  local root = split[1]
  if root ~= "TamingMob" then
    return nil
  end
  local tamingMobId = ___MOD.tonumber(split[2])
  if not tamingMobId then
    return nil
  end
  local node = self.characterData[tamingMobId]
  if ___MOD.type(node) ~= "table" then
    return nil
  end
  for i = 3, #split do
    node = node[split[i]]
    if node == nil then
      self.pathValueCache[path] = nil
      return nil
    end
  end
  self.pathValueCache[path] = node
  return node
end

function TamingMobManager.getCharacterTamingMobRUID(self, tamingMobId, motion, frameIndex, layerIndex)
  local path = ___MOD.string.format("TamingMob/%08d/%s/%d/%d", tamingMobId, motion, frameIndex, layerIndex)
  return self:getCharacterTamingMobRUIDByPath(path)
end

function TamingMobManager.getCharacterTamingMobRUIDByPath(self, path)
  local node = self:getCharacterTamingMobNodeByPath(path)
  if ___MOD.type(node) ~= "table" then
    return ""
  end
  local imageKey = ___MOD._WzUtils:getString(node.image, "")
  if ___MOD._UtilLogic:IsNilorEmptyString(imageKey) then
    return ""
  end
  return ___MOD.__RUIDManager:get(imageKey)
end

function TamingMobManager.getCharacterTamingMobSaddle(self, tamingMobId, motion)
  if tamingMobId <= 0 or motion == nil or motion == "" then
    return nil
  end
  local byId = self.saddleMotionCache[tamingMobId]
  if byId == nil then
    byId = {}
    self.saddleMotionCache[tamingMobId] = byId
  end
  local cached = byId[motion]
  if cached ~= nil then
    return cached
  end
  local saddleItemIds = {
    1912000,
    1912011,
    1912005
  }
  for _, saddleItemId in ___MOD.ipairs(saddleItemIds) do
    local saddleRoot = self.characterData[saddleItemId]
    if ___MOD.type(saddleRoot) == "table" then
      local saddleByMob = saddleRoot[___MOD.tostring(tamingMobId)] or saddleRoot[tamingMobId]
      if ___MOD.type(saddleByMob) == "table" then
        local rawMotion = saddleByMob[motion]
        if ___MOD.type(rawMotion) == "table" then
          local parsed = self:parseCharacterTamingMobMotion(tamingMobId, motion, rawMotion, true, saddleItemId)
          byId[motion] = parsed
          return parsed
        end
      end
    end
  end
  return nil
end

function TamingMobManager.getLinkedTamingMobData(self, characterTamingMobId)
  local linkedTamingMobId = self:getLinkedTamingMobId(characterTamingMobId)
  if linkedTamingMobId <= 0 then
    return nil
  end
  return self.tamingMobData[linkedTamingMobId]
end

function TamingMobManager.getLinkedTamingMobId(self, characterTamingMobId)
  local characterData = self.characterData[characterTamingMobId]
  if ___MOD.type(characterData) ~= "table" then
    return 0
  end
  local info = characterData.info
  if ___MOD.type(info) ~= "table" then
    return 0
  end
  return ___MOD._WzUtils:getInteger(info.tamingMob, 0)
end

function TamingMobManager.getTamingMob(self, tamingMobId)
  return self.tamingMobData[tamingMobId]
end

function TamingMobManager.getTamingMobData(self, tamingMobId)
  local data = self.tamingMobData[tamingMobId]
  if data then
    return data
  end
  return self.characterData[tamingMobId]
end

function TamingMobManager.loadTamingMob(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local totalCount = 0
  local characterCount = 0
  local tamingMobCount = 0
  local characterCache = {}
  local characterWz = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "TamingMob")
  if ___MOD.type(characterWz) == "table" then
    for key, data in ___MOD.pairs(characterWz) do
      local id = ___MOD.tonumber(___MOD._UtilLogic:Replace(key, ".img", ""))
      if id then
        characterCache[id] = data
        characterCount = characterCount + 1
        totalCount = totalCount + 1
      end
    end
  end
  self.characterData = characterCache
  local tamingMobCache = {}
  local dataset = ___MOD._DataService:GetTable("TamingMob_wz")
  if dataset ~= nil then
    local rowCount = dataset:GetRowCount()
    for i = 1, rowCount do
      local id = ___MOD.tonumber(___MOD._UtilLogic:Replace(dataset:GetCell(i, "key"), ".img", ""))
      local data = ___MOD._WzUtils:parseWzData(dataset:GetCell(i, "data"))
      if id and ___MOD.type(data) == "table" then
        tamingMobCache[id] = data
        tamingMobCount = tamingMobCount + 1
        totalCount = totalCount + 1
      end
    end
  end
  self.tamingMobData = tamingMobCache
  self.count = totalCount
  ___MOD.log(___MOD.string.format("Loaded TamingMob data (%.2f secs) Character:%d TamingMob:%d", ___MOD._UtilLogic.ElapsedSeconds - time, characterCount, tamingMobCount))
  ___MOD._DataLoadManager:compeletedLoad()
end

function TamingMobManager.parseCharacterTamingMobMotion(self, tamingMobId, motion, rawMotion, isSaddle, ruidSourceId)
  local cache = {}
  cache.anim = {}
  cache.navels = {}
  cache.RUIDs = {}
  cache.layers = {}
  cache.asynced = false
  local anim = cache.anim
  local layerCachesByIndex = {}
  local frameKeys = {}
  for key, value in ___MOD.pairs(rawMotion) do
    local frameIndex = ___MOD.tonumber(key)
    if frameIndex then
      frameKeys[#frameKeys + 1] = frameIndex
    elseif key == "zigzag" then
      cache.zigzag = ___MOD._WzUtils:getBoolean(value, false)
    elseif key == "repeat" then
      cache["repeat"] = ___MOD._WzUtils:getInteger(value, 0)
    end
  end
  ___MOD.table.sort(frameKeys)
  for seq = 1, #frameKeys do
    local rawFrameKey = frameKeys[seq]
    local frameNode = rawMotion[___MOD.tostring(rawFrameKey)]
    if ___MOD.type(frameNode) ~= "table" then
      frameNode = rawMotion[rawFrameKey]
    end
    if ___MOD.type(frameNode) == "table" then
      local layerIndices = {}
      for subKey, subValue in ___MOD.pairs(frameNode) do
        local layerIndex = ___MOD.tonumber(subKey)
        if layerIndex ~= nil and ___MOD.type(subValue) == "table" then
          layerIndices[#layerIndices + 1] = layerIndex
        end
      end
      if #layerIndices == 0 then
        layerIndices[1] = 0
      else
        ___MOD.table.sort(layerIndices)
      end
      local forceSingleLayer = #layerIndices == 1
      for _, layerIndex in ___MOD.ipairs(layerIndices) do
        local spriteNode = frameNode[___MOD.tostring(layerIndex)]
        if ___MOD.type(spriteNode) ~= "table" then
          spriteNode = frameNode[layerIndex]
        end
        if ___MOD.type(spriteNode) ~= "table" and layerIndex == 0 then
          spriteNode = frameNode
        end
        if ___MOD.type(spriteNode) == "table" then
          local actualLayerIndex = forceSingleLayer and 0 or layerIndex
          local mergedNode = {}
          for subKey, subValue in ___MOD.pairs(spriteNode) do
            mergedNode[subKey] = subValue
          end
          if mergedNode.delay == nil then
            mergedNode.delay = frameNode.delay
          end
          if mergedNode.map == nil then
            mergedNode.map = frameNode.map
          end
          local layerZValue = mergedNode.z
          if layerZValue == nil then
            layerZValue = frameNode.z
          end
          local numericZ = ___MOD.tonumber(layerZValue)
          if numericZ ~= nil then
            mergedNode.z = numericZ
          else
            mergedNode.z = nil
          end
          local frameAnim = ___MOD._WzUtils:parseAnimation_({
            ["0"] = mergedNode
          }, 0)
          if frameAnim and frameAnim.anim and frameAnim.anim[1] then
            local layerCache = layerCachesByIndex[actualLayerIndex]
            if layerCache == nil then
              layerCache = {
                anim = {},
                navels = {},
                RUIDs = {},
                asynced = false,
                layerIndex = actualLayerIndex,
                layerType = "front",
                layerOrder = 0
              }
              layerCachesByIndex[actualLayerIndex] = layerCache
            end
            local frame = frameAnim.anim[1]
            if frame.RUID == "" then
              frame.RUID = self:getCharacterTamingMobRUID(ruidSourceId, motion, rawFrameKey, layerIndex)
            end
            local animIndex = #layerCache.anim + 1
            layerCache.anim[animIndex] = frame
            local navelNode = mergedNode.map and mergedNode.map.navel or nil
            if navelNode ~= nil then
              local navel = ___MOD._WzUtils:getFastVector(navelNode, ___MOD.FastVector2(0, 0))
              layerCache.navels[animIndex] = ___MOD.FastVector2(navel.x / 100, navel.y / 100)
            end
            if frame.RUID ~= "" then
              layerCache.RUIDs[#layerCache.RUIDs + 1] = frame.RUID
            end
            layerCache.totalDelay = (layerCache.totalDelay or 0) + (frame.delay or 100)
            if layerCache.layerZKey == nil or layerCache.layerZKey == "" then
              layerCache.layerZKey = ___MOD._WzUtils:getString(layerZValue, "")
            end
            local zKey = ___MOD.tostring(layerCache.layerZKey):lower()
            if zKey == "saddlerear" then
              layerCache.layerType = "saddleRear"
              layerCache.layerOrder = -2
            elseif zKey == "saddlefront" then
              layerCache.layerType = "saddleFront"
              layerCache.layerOrder = -1
            elseif zKey == "tamingmobrear" then
              layerCache.layerType = "rear"
              layerCache.layerOrder = -1
            elseif zKey == "tamingmobmid" then
              layerCache.layerType = "mid"
              layerCache.layerOrder = 0
            else
              layerCache.layerType = "front"
              layerCache.layerOrder = 1
            end
          end
        end
      end
    end
  end
  local layerIndices = {}
  for layerIndex, _ in ___MOD.pairs(layerCachesByIndex) do
    layerIndices[#layerIndices + 1] = layerIndex
  end
  ___MOD.table.sort(layerIndices)
  local primaryLayer
  local totalDelay = 0
  for _, layerIndex in ___MOD.ipairs(layerIndices) do
    local layerCache = layerCachesByIndex[layerIndex]
    cache.layers[#cache.layers + 1] = layerCache
    if primaryLayer == nil or (___MOD.tonumber(primaryLayer.layerOrder) or 0) < (___MOD.tonumber(layerCache.layerOrder) or 0) then
      primaryLayer = layerCache
    end
    totalDelay = ___MOD.math.max(totalDelay, ___MOD.tonumber(layerCache.totalDelay) or 0)
  end
  local layer0Cache = layerCachesByIndex[0]
  if not isSaddle and layer0Cache ~= nil and ___MOD.type(layer0Cache.anim) == "table" and ___MOD.type(layer0Cache.navels) == "table" then
    for _, layerIndex in ___MOD.ipairs(layerIndices) do
      local layerCache = layerCachesByIndex[layerIndex]
      if layerCache ~= nil and layerIndex ~= 0 and ___MOD.type(layerCache.anim) == "table" then
        for animIndex = 1, #layerCache.anim do
          local frame = layerCache.anim[animIndex]
          local baseNavel = layer0Cache.navels and layer0Cache.navels[animIndex] or nil
          local currentNavel = layerCache.navels and layerCache.navels[animIndex] or nil
          if frame ~= nil and ___MOD.type(baseNavel) == "table" and ___MOD.type(currentNavel) == "table" then
            local deltaX = currentNavel.x - baseNavel.x
            local deltaY = currentNavel.y - baseNavel.y
            if deltaX ~= 0 or deltaY ~= 0 then
              if frame.originOffset ~= nil then
                frame.originOffset = ___MOD.FastVector3(frame.originOffset.x - deltaX, frame.originOffset.y + deltaY, frame.originOffset.z or 0)
              end
              if frame.originOffsetFlip ~= nil then
                frame.originOffsetFlip = ___MOD.FastVector3(frame.originOffsetFlip.x + deltaX, frame.originOffsetFlip.y + deltaY, frame.originOffsetFlip.z or 0)
              end
              if frame.originHalfOffset ~= nil then
                frame.originHalfOffset = ___MOD.FastVector3(frame.originHalfOffset.x - deltaX, frame.originHalfOffset.y + deltaY, frame.originHalfOffset.z or 0)
              end
              if frame.originHalfOffsetFlip ~= nil then
                frame.originHalfOffsetFlip = ___MOD.FastVector3(frame.originHalfOffsetFlip.x + deltaX, frame.originHalfOffsetFlip.y + deltaY, frame.originHalfOffsetFlip.z or 0)
              end
              if frame.originUI ~= nil then
                frame.originUI = ___MOD.FastVector2(frame.originUI.x - deltaX * 100, frame.originUI.y + deltaY * 100)
              end
              if frame.originUIFlip ~= nil then
                frame.originUIFlip = ___MOD.FastVector2(frame.originUIFlip.x + deltaX * 100, frame.originUIFlip.y + deltaY * 100)
              end
            end
          end
        end
      end
    end
  end
  if primaryLayer ~= nil then
    cache.anim = primaryLayer.anim
    cache.navels = primaryLayer.navels
    cache.RUIDs = primaryLayer.RUIDs
  end
  cache.totalDelay = totalDelay
  return cache
end
