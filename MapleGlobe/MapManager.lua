

function MapManager.activeField(self, field)

end

function MapManager.deactiveField(self, field)

end

function MapManager.finalizeLoadMap(self)
  ___MOD._UILoading:clearDataLoadDetailText()
  self:setAreaCode()
  self:setLetterBoxExcludedMap()
  self:setNeedSkillForFlyMap()
  self:loadMAPDIR()
  local loadTime = ___MOD._UtilLogic.ElapsedSeconds - self.loadMapStartTime
  ___MOD.log(___MOD.string.format("Loaded Map.wz (Full) (%.2f secs) Count : %d", loadTime, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end

function MapManager.getAreaCode(self, mapID)
  local mapGroup = mapID // 10000000
  return self.areaCode[mapGroup] or nil
end

function MapManager.getField(self, mapId)
  local map = self:getMap(mapId)
  if map then
    local field = map.MapInfoComponent
    if field and ___MOD.isvalid(field) then
      return field
    end
  end
  return nil
end

function MapManager.getMap(self, mapId)
  local path = ___MOD.string.format("/maps/map_%09d", mapId)
  local map = ___MOD._EntityService:GetEntityByPath(path)
  if map and ___MOD.isvalid(map) then
    return map
  end
  return nil
end

function MapManager.getMapHelperAnim(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.mapHelper
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
      local v = ___MOD._WzUtils:parseAnimation(node) or nil
      cacheTbl[path] = v
      return v
    end
    pos = s + 1
  end
end

function MapManager.getObejct(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.obj
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

function MapManager.getObjectAnim(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.obj
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
      local v = ___MOD._WzUtils:parseAnimation(node) or nil
      cacheTbl[path] = v
      return v
    end
    pos = s + 1
  end
end

function MapManager.initLoadMap(self)
  self.loadMapStartTime = ___MOD._UtilLogic.ElapsedSeconds
  if self:IsServer() then
    self:loadMapType()
  end
end

function MapManager.isConnected(self, dwFrom, dwTo)
  if dwFrom / 1000000 % 100 == 9 then
    return false
  end
  if dwTo / 1000000 % 100 == 9 then
    return false
  end
  if dwFrom // 10000 == 20009 then
    return false
  end
  if dwTo // 10000 == 20009 then
    return false
  end
  local areaFrom = self:getAreaCode(dwFrom)
  local areaTo = self:getAreaCode(dwTo)
  return areaFrom == areaTo
end

function MapManager.isDojoField(self, mapId)
  return 925020100 <= mapId and mapId <= 925023899
end

function MapManager.isDojoPracticeField(self, mapId)
  return mapId == 925020005 or 925020101 <= mapId and mapId <= 925023801 and mapId % 100 == 1
end

function MapManager.isForbidFallDown(self, map, FHID)
  local mapInfo = map.MapInfoComponent
  local mapID = mapInfo.mapID
  return (self.FHOption[mapID] and self.FHOption[mapID][FHID] or 0) == 1
end

function MapManager.isLetterBoxExcludedMap(self, mapID)
  return self.letterboxExcluded[mapID] ~= nil
end

function MapManager.isNeedSkillForFlyMap(self, mapID)
  return self.needSkillForFlyMapTable[mapID] == true
end

function MapManager.loadBack(self, data)
  local frameData = {}
  frameData.RUID = ___MOD.__RUIDManager:get(data.image)
  frameData.spriteSize = ___MOD.FastVector2(data._width, data._height)
  frameData.originP = ___MOD._WzUtils:getFastVector(data.origin, self.Vector2Zero)
  local originP = frameData.originP
  local spriteSize = frameData.spriteSize
  local mapleBase = ___MOD.FastVector3(spriteSize.x / 2, -spriteSize.y / 2, 0)
  frameData.OriginUI = ___MOD.FastVector2(spriteSize.x / 2, -spriteSize.y) + ___MOD.FastVector2(-originP.x, originP.y)
  frameData.OriginUIFlip = ___MOD.FastVector2(spriteSize.x / 2, -spriteSize.y) + ___MOD.FastVector2(-(spriteSize.x - originP.x), originP.y)
  frameData.OriginOffset = (mapleBase + ___MOD.FastVector3(-originP.x, originP.y, 0)) / 100
  frameData.OriginOffsetFlip = (mapleBase + ___MOD.FastVector3(-(spriteSize.x - originP.x), originP.y, 0)) / 100
  local offsetX, offsetY = ___MOD._OffsetUtils:GetEvenPivotOffset(spriteSize.x, spriteSize.y, originP.x, originP.y, false)
  frameData.originOffset = ___MOD.FastVector3(offsetX / 100.0, offsetY / 100.0, 0)
  local flipOffsetX = ___MOD._MathUtils:alwaysCeil(originP.x - spriteSize.x / 2.0)
  frameData.originOffsetFlip = ___MOD.FastVector3(flipOffsetX / 100.0, offsetY / 100.0, 0)
  return frameData
end

function MapManager.loadFHOption(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable("FHOption")
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  local mapId, fhId, forbidFallDown
  local optTbl = self.FHOption
  local mapDir = self.MAPDIR
  for i = 1, count do
    mapId = ___MOD.tonumber(get(ds, i, 1))
    fhId = ___MOD.tonumber(get(ds, i, 2))
    forbidFallDown = ___MOD.tonumber(get(ds, i, 3))
    local map = optTbl[mapId]
    if map == nil then
      optTbl[mapId] = {}
      map = optTbl[mapId]
    end
    map[fhId] = forbidFallDown
    count1 = count1 + 1
  end
  ___MOD.log(___MOD.string.format("Loaded FHOption Table (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
end

function MapManager.loadMap(self)
  if self:IsClient() then
    self:initLoadMap()
    return
  end
  self:initLoadMap()
  self:loadMapServerAreaCodeStage()
  self:loadMapServerMAPDIRStage()
end

function MapManager.loadMapBackStage(self)
  ___MOD._UILoading:setDataLoadDetailText("- MAP Back Load... -")
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local backData = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Map_wz", "Back")
  if ___MOD.type(backData) ~= "table" then
    ___MOD.log_error("[loadMapBackStage] Map_wz Back data is not table")
    backData = {}
  end
  local backAnims = self.backAnims
  for imgName, img in ___MOD.pairs(backData) do
    local imgName_ = ___MOD._UtilLogic:Replace(imgName, ".img", "")
    backAnims[imgName_] = {}
    local back = backAnims[imgName_]
    for nodeName, node in ___MOD.pairs(img) do
      back[nodeName] = {}
      local back2 = back[nodeName]
      if nodeName == "back" then
        back[nodeName] = ___MOD._WzUtils:parseAnimation(node)
      elseif nodeName == "ani" then
        for key, value in ___MOD.pairs(node) do
          back2[key] = ___MOD._WzUtils:parseAnimation(value)
        end
      else
        ___MOD.log("What's this? : " .. nodeName)
      end
    end
  end
  ___MOD.log(___MOD.string.format("Loaded Map.wz Back (%.2f secs)", ___MOD._UtilLogic.ElapsedSeconds - time))
  ___MOD._DataLoadManager:compeletedLoad()
end

function MapManager.loadMAPDIR(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local datasetNames = {
    "ALL",
    "PQ",
    "Planet"
  }
  local worldNames = {}
  worldNames.ALL = "ALL"
  worldNames.PQ = "원정대"
  worldNames.Planet = "플래닛"
  local count1 = 0
  local MAPDIRTbl = self.MAPDIR

  local function loadDir(dirName)
    local ds = ___MOD._DataService:GetTable(dirName)
    if ds == nil then
      return
    end
    local count = ds:GetRowCount()
    local get = ds.GetCell
    for i = 1, count do
      local mapId = ___MOD.tonumber(get(ds, i, 1))
      if mapId ~= nil then
        if MAPDIRTbl[mapId] == nil then
          count1 = count1 + 1
        end
        MAPDIRTbl[mapId] = worldNames[dirName]
      end
    end
  end

  for _, dirName in ___MOD.ipairs(datasetNames) do
    loadDir(dirName)
  end
  ___MOD.log(___MOD.string.format("Loaded MAPDIR Table (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
end

function MapManager.loadMapFHOptionStage(self)
  ___MOD._UILoading:setDataLoadDetailText("- MAP FHOption Load... -")
  self:loadFHOption()
  ___MOD._DataLoadManager:compeletedLoad()
end

function MapManager.loadMapObjStage(self, objKey)
  ___MOD._UILoading:setDataLoadDetailText(___MOD.string.format("- MAP %s Load... -", objKey))

  function ___MOD.ensureTable(t, key)
    if t[key] == nil then
      t[key] = {}
    end
    return t[key]
  end

  local time = ___MOD._UtilLogic.ElapsedSeconds
  local objData = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Map_wz", objKey)
  if ___MOD.type(objData) ~= "table" then
    ___MOD.log_error("[loadMapObjStage] Map_wz " .. objKey .. " data is not table")
    objData = {}
  end
  local objRoot = self.obj
  for imgName, img in ___MOD.pairs(objData) do
    objRoot[imgName] = img
    if imgName ~= "etc.img" then
      for key, node in ___MOD.pairs(img) do
        for dirName, dir in ___MOD.pairs(node) do
          for subDirName, subDir in ___MOD.pairs(dir) do
            local anims = ___MOD._WzUtils:parseAnimation(subDir)
            local imgName_ = ___MOD._UtilLogic:Replace(imgName, ".img", "")
            local t1 = ___MOD.ensureTable(self.objAnims, imgName_)
            local t2 = ___MOD.ensureTable(t1, key)
            local t3 = ___MOD.ensureTable(t2, dirName)
            t3[subDirName] = anims
            self.count = self.count + 1
          end
        end
      end
    end
  end
  ___MOD.log(___MOD.string.format("Loaded Map.wz %s (%.2f secs)", objKey, ___MOD._UtilLogic.ElapsedSeconds - time))
  ___MOD._DataLoadManager:compeletedLoad()
end

function MapManager.loadMapServerAreaCodeStage(self)

end

function MapManager.loadMapServerMAPDIRStage(self)

end

function MapManager.loadMapType(self)

end

function MapManager.loadMapWorldStage(self)
  ___MOD._UILoading:setDataLoadDetailText("- MAP WorldMap Load... -")
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local worldMapData = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Map_wz", "WorldMap")
  local mapHelperData = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Map_wz", "MapHelper.img")
  if ___MOD.type(worldMapData) ~= "table" then
    ___MOD.log_error("[loadMapWorldStage] Map_wz WorldMap data is not table")
    worldMapData = {}
  end
  if ___MOD.type(mapHelperData) ~= "table" then
    ___MOD.log_error("[loadMapWorldStage] Map_wz MapHelper data is not table")
    mapHelperData = {}
  end
  self.mapHelper = mapHelperData
  self:loadWorldMap(worldMapData)
  ___MOD.log(___MOD.string.format("Loaded Map.wz WorldMap/MapHelper (%.2f secs)", ___MOD._UtilLogic.ElapsedSeconds - time))
  ___MOD._DataLoadManager:compeletedLoad()
end

function MapManager.loadMapZMassStage(self)
  ___MOD._UILoading:setDataLoadDetailText("- MAP zMASS Load... -")
  self:loadZMass()
  ___MOD._DataLoadManager:compeletedLoad()
end

function MapManager.loadWorldMap(self, t)
  local cache = {}
  for imgName, img in ___MOD.pairs(t) do
    imgName = ___MOD._UtilLogic:Replace(imgName, ".img", "")
    cache[imgName] = {}
    local worldMapImgCache = cache[imgName]
    if img.info ~= nil then
      worldMapImgCache.parentMap = ___MOD._WzUtils:getString(img.info.parentMap, "")
    end
    if img.BaseImg ~= nil then
      local baseImg = img.BaseImg["0"]
      if baseImg ~= nil then
        local ruid = ___MOD.__RUIDManager:get(baseImg.image)
        local origin = ___MOD._WzUtils:getFastVector(baseImg.origin, self.Vector2Zero)
        local spriteSize = ___MOD.FastVector2(baseImg._width, baseImg._height)
        worldMapImgCache.BaseImg = {
          ruid = ruid,
          origin = origin,
          size = spriteSize
        }
      end
    end
    if img.MapList ~= nil then
      worldMapImgCache.MapList = {}
      for dirName, dir in ___MOD.pairs(img.MapList) do
        local index = ___MOD.tonumber(dirName)
        if index ~= nil then
          index = index + 1
          local spot = ___MOD._WzUtils:getFastVector(dir.spot, self.Vector2Zero) * 2
          spot.y = -spot.y
          local type = ___MOD._WzUtils:getInteger(dir.type, 0)
          local title = ___MOD._WzUtils:getString(dir.title, "")
          local desc = ___MOD._WzUtils:getString(dir.desc, "")
          local path = {}
          if dir.path ~= nil then
            path.ruid = ___MOD.__RUIDManager:get(dir.path.image)
            path.size = ___MOD.FastVector2(dir.path._width, dir.path._height) * 2
            local origin = ___MOD._WzUtils:getFastVector(dir.path.origin, self.Vector2Zero) * 2
            local originX, originY = ___MOD._OffsetUtils:GetEvenPivotOffset(path.size.x, path.size.y, origin.x, origin.y, false)
            path.origin = ___MOD.FastVector2(originX, originY)
          end
          local mapNo = {}
          if dir.mapNo ~= nil then
            for key, value in ___MOD.pairs(dir.mapNo) do
              local mapNoIndex = ___MOD.tonumber(key)
              if mapNoIndex ~= nil then
                mapNoIndex = mapNoIndex + 1
                local mapId = ___MOD._WzUtils:getInteger(value, 0)
                mapNo[mapNoIndex] = mapId
                if imgName ~= "WorldMap" then
                  self.worldMapImgNameCache[mapId] = imgName
                end
              end
            end
          end
          worldMapImgCache.MapList[index] = {
            spot = spot,
            type = type,
            mapNo = mapNo,
            path = path
          }
        end
      end
    end
    if img.MapLink ~= nil then
      worldMapImgCache.MapLink = {}
      for dirName, dir in ___MOD.pairs(img.MapLink) do
        local index = ___MOD.tonumber(dirName)
        if index ~= nil then
          index = index + 1
          local toolTip = ___MOD._WzUtils:getString(dir.toolTip, "")
          local link = {}
          if dir.link ~= nil then
            if dir.link.linkMap ~= nil then
              link.linkMap = ___MOD._WzUtils:getString(dir.link.linkMap, "")
            end
            if dir.link.linkImg ~= nil then
              link.linkImg = {}
              link.linkImg.ruid = ___MOD.__RUIDManager:get(dir.link.linkImg.image)
              link.linkImg.size = ___MOD.FastVector2(dir.link.linkImg._width, dir.link.linkImg._height) * 2
              local origin = ___MOD._WzUtils:getFastVector(dir.link.linkImg.origin, self.Vector2Zero) * 2
              local originX, originY = ___MOD._OffsetUtils:GetEvenPivotOffset(link.linkImg.size.x, link.linkImg.size.y, origin.x, origin.y, false)
              link.linkImg.origin = ___MOD.FastVector2(originX, originY)
            end
          end
          worldMapImgCache.MapLink[index] = {toolTip = toolTip, link = link}
        end
      end
      if imgName == "WorldMap" then
        local origin = ___MOD.FastVector2.zero:Clone()
        ___MOD.table.sort(worldMapImgCache.MapLink, function(a, b)
          local da = (a.link.linkImg.size - origin):Magnitude()
          local db = (b.link.linkImg.size - origin):Magnitude()
          return da > db
        end)
      end
    end
  end
  self.worldMap = cache
end

function MapManager.loadZMass(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable("zMass")
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  local mapId, fhId, zMass
  local zMassTbl = self.zMass
  local mapDir = self.MAPDIR
  for i = 1, count do
    mapId = ___MOD.tonumber(get(ds, i, 1))
    zMass = ___MOD.tonumber(get(ds, i, 2))
    fhId = ___MOD.tonumber(get(ds, i, 3))
    local map = zMassTbl[mapId]
    if map == nil then
      zMassTbl[mapId] = {}
      map = zMassTbl[mapId]
    end
    map[fhId] = zMass
    count1 = count1 + 1
  end
  ___MOD.log(___MOD.string.format("Loaded zMass Table (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
end

function MapManager.OnEndPlay(self)

end

function MapManager.setAreaCode(self)
  local areaCode = self.areaCode
  areaCode[0] = 0
  areaCode[10] = 1
  areaCode[11] = 2
  areaCode[12] = 1
  areaCode[13] = 1
  areaCode[14] = 1
  areaCode[19] = 1
  areaCode[20] = 3
  areaCode[21] = 3
  areaCode[22] = 4
  areaCode[23] = 5
  areaCode[24] = 6
  areaCode[25] = 7
  areaCode[26] = 8
  areaCode[27] = 10
  areaCode[28] = 3
  areaCode[30] = 9
  areaCode[39] = 30
  areaCode[50] = 50
  areaCode[68] = 60
  areaCode[70] = 70
  areaCode[74] = 74
  areaCode[90] = 90
  areaCode[91] = 90
  areaCode[92] = 90
  areaCode[99] = 90
end

function MapManager.setLetterBoxExcludedMap(self)
  local excluded = self.letterboxExcluded
  excluded[260000110] = 1
  excluded[200090400] = 1
  excluded[200090410] = 1
  excluded[200090310] = 1
  excluded[200090300] = 1
end

function MapManager.setNeedSkillForFlyMap(self)
  local needSkillForFlyMapTable = self.needSkillForFlyMapTable
  needSkillForFlyMapTable[240080000] = true
  needSkillForFlyMapTable[240080040] = true
  needSkillForFlyMapTable[240080041] = true
  needSkillForFlyMapTable[240080100] = true
  needSkillForFlyMapTable[240080101] = true
  needSkillForFlyMapTable[240080200] = true
  needSkillForFlyMapTable[240080201] = true
  needSkillForFlyMapTable[240080300] = true
  needSkillForFlyMapTable[240080301] = true
  needSkillForFlyMapTable[240080400] = true
  needSkillForFlyMapTable[240080401] = true
  needSkillForFlyMapTable[240080500] = true
  needSkillForFlyMapTable[240080501] = true
  needSkillForFlyMapTable[240080600] = true
  needSkillForFlyMapTable[240080601] = true
  needSkillForFlyMapTable[240080700] = true
  needSkillForFlyMapTable[240080701] = true
end

function MapManager.updateField(self)

end

function MapManager.updateMobGen(self)

end
