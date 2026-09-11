

function UIManager.buildImageSizeCache(self)
  self.imageSizeCache = {}
  for _, root in ___MOD.pairs(self.uiCache) do
    self:collectImageSize(root)
  end
end

function UIManager.collectImageSize(self, node)
  if ___MOD.type(node) ~= "table" then
    return
  end
  local image = node.image
  if ___MOD.type(image) == "string" and image ~= "" then
    local w = ___MOD.tonumber(node._width)
    local h = ___MOD.tonumber(node._height)
    if w ~= nil and h ~= nil and 0 < w and 0 < h then
      self.imageSizeCache[image] = ___MOD.FastVector2(w * 2, h * 2)
    end
  end
  for _, v in ___MOD.pairs(node) do
    if ___MOD.type(v) == "table" then
      self:collectImageSize(v)
    end
  end
end

function UIManager.getChatBalloon(self, path)
  local cache = self.cache[path]
  if cache ~= nil then
    return cache
  end
  local node = ___MOD._WzUtils:getWzTbl(self.uiCache, path)
  if node == nil then
    return
  end
  local chatBalloon = self:parseChatBalloon(node)
  self.cache[path] = chatBalloon
  return chatBalloon
end

function UIManager.getImage(self, path)
  local node = self:getNode(path)
  if node then
    local mapleImage = ___MOD.MapleImage()
    local image = node.image
    if ___MOD._UtilLogic:IsNilorEmptyString(image) then
      return nil
    end
    local size = ___MOD._WzUtils:getSize(node, nil)
    if size == nil then
      return nil
    end
    mapleImage.RUID = ___MOD.__RUIDManager:get(image)
    mapleImage.size = size * 2
    return mapleImage
  end
  return nil
end

function UIManager.getImageSize(self, imageKey)
  return self.imageSizeCache[imageKey]
end

function UIManager.getImageSizeByPath(self, path)
  local node = self:getNode(path)
  if node and not ___MOD._UtilLogic:IsNilorEmptyString(node.image) then
    return self:getImageSize(node.image)
  end
  return ___MOD.Vector2(0, 0)
end

function UIManager.getMobGage(self, mobID)
  return self:getRUID(___MOD.string.format("UIWindow.img/MobGage/Mob/%d", mobID))
end

function UIManager.getNameTag(self, path)
  local cache = self.cache[path]
  if cache ~= nil then
    return cache
  end
  local node = ___MOD._WzUtils:getWzTbl(self.uiCache, path)
  if node == nil then
    return
  end
  local nameTag = self:parseNameTag(node)
  self.cache[path] = nameTag
  return nameTag
end

function UIManager.getNode(self, path)
  local cache = self.cache[path]
  if cache ~= nil then
    return cache
  end
  local node = ___MOD._WzUtils:getWzTbl(self.uiCache, path)
  if node == nil then
    return
  end
  self.cache[path] = node
  return node
end

function UIManager.getRUID(self, path)
  local node = self:getNode(path)
  if node then
    local image = node.image
    if not ___MOD._UtilLogic:IsNilorEmptyString(image) then
      return ___MOD.__RUIDManager:get(image)
    end
  end
  return nil
end

function UIManager.loadUI(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable("UI_wz")
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  local loadkeys = {
    ["ChatBalloon.img"] = true,
    ["NameTag.img"] = true,
    ["UIWindow.img"] = true
  }
  for i = 1, count do
    local key = get(ds, i, 1)
    if loadkeys[key] then
      local data = get(ds, i, 2)
      data = ___MOD._WzUtils:parseWzData(data)
      if ___MOD.type(data) == "table" then
        self.uiCache[key] = data
        count1 = count1 + 1
      end
    end
  end
  self:buildImageSizeCache()
  self:parseDefaultNameTag()
  ___MOD.log(___MOD.string.format("Loaded UI.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
  ___MOD._DataLoadManager:compeletedLoad()
end

function UIManager.parseChatBalloon(self, node)
  if node.arrow ~= nil then
    return self:parseChatBalloonFrame(node, node.clr)
  end
  if node["0"] == nil then
    return nil
  end
  local frameKeys = {}
  for key, v in ___MOD.pairs(node) do
    local frameIndex = ___MOD.tonumber(key)
    if frameIndex ~= nil and ___MOD.type(v) == "table" and v.arrow ~= nil then
      ___MOD.table.insert(frameKeys, frameIndex)
    end
  end
  ___MOD.table.sort(frameKeys)
  local cache = {
    isAnimation = true,
    frames = {}
  }
  for _, frameIndex in ___MOD.ipairs(frameKeys) do
    local frame = self:parseChatBalloonFrame(node[___MOD.tostring(frameIndex)], node.clr)
    if frame ~= nil then
      ___MOD.table.insert(cache.frames, frame)
    end
  end
  if #cache.frames == 0 then
    return nil
  end
  return cache
end

function UIManager.parseChatBalloonFrame(self, node, clr)
  if node.arrow == nil then
    return nil
  end
  local cache = {}
  for category, v in ___MOD.pairs(node) do
    if category == "delay" then
      cache.delay = ___MOD._WzUtils:getInteger(v, 100)
    else
      cache[category] = {}
      local to = cache[category]
      if category == "clr" then
        local color = ___MOD._WzUtils:getInteger(v, 0)
        local a, r, g, b = ___MOD._WzUtils:intToARGB(color)
        to.color = ___MOD.FastColor(r, g, b, a)
      elseif ___MOD.type(v) ~= "table" then
        cache[category] = nil
      else
        local image = v.image or ""
        to.ruid = ___MOD.__RUIDManager:get(image)
        local width, height = v._width or 1, v._height or 1
        to.size = ___MOD.FastVector3(width * 2, height * 2, 0)
        local origin = ___MOD._WzUtils:getFastVector(v.origin, ___MOD.FastVector2.zero:Clone())
        local originX, originY = ___MOD._OffsetUtils:GetEvenPivotOffset(width, height, origin.x, origin.y, true)
        to.origin = ___MOD.FastVector3(originX, originY, 0)
      end
    end
  end
  if cache.clr == nil then
    cache.clr = {}
    local color = ___MOD._WzUtils:getInteger(clr, 0)
    local a, r, g, b = ___MOD._WzUtils:intToARGB(color)
    cache.clr.color = ___MOD.FastColor(r, g, b, a)
  end
  return cache
end

function UIManager.parseDefaultNameTag(self)
  local default = {
    w = {},
    c = {},
    e = {},
    clr = {}
  }
  default.clr.color = ___MOD.FastColor.white
  default.w.ruid = "07d0744e0e5743a69743e636a8880354"
  default.w.size = ___MOD.FastVector3(5, 30, 0)
  local originX, originY = ___MOD._OffsetUtils:GetEvenPivotOffset(5, 30, 5, 4, false)
  default.w.origin = ___MOD.FastVector3(originX, originY, 0)
  default.c.ruid = "184b741385eb4bb48ff2d024e2e4998b"
  default.c.size = ___MOD.FastVector3(8, 30, 0)
  originX, originY = ___MOD._OffsetUtils:GetEvenPivotOffset(8, 30, 0, 4, false)
  default.c.origin = ___MOD.FastVector3(originX, originY, 0)
  default.e.ruid = "123e4fd0e2fa40a482d2ffe75d3f5cc6"
  default.e.size = ___MOD.FastVector3(5, 30, 0)
  originX, originY = ___MOD._OffsetUtils:GetEvenPivotOffset(5, 30, 0, 4, false)
  default.e.origin = ___MOD.FastVector3(originX, originY, 0)
  self.cache["NameTag.img/0"] = default
end

function UIManager.parseNameTag(self, node)
  if node.w == nil then
    return
  end
  local cache = {}
  for category, v in ___MOD.pairs(node) do
    cache[category] = {}
    local to = cache[category]
    if category == "clr" then
      local color = ___MOD._WzUtils:getInteger(v, 0)
      local a, r, g, b = ___MOD._WzUtils:intToARGB(color)
      to.color = ___MOD.FastColor(r, g, b, a)
    elseif ___MOD.type(v) ~= "table" then
      cache[category] = nil
    else
      local image = v.image or ""
      to.ruid = ___MOD.__RUIDManager:get(image)
      local width, height = v._width or 1, v._height or 1
      to.size = ___MOD.FastVector3(width * 2, height * 2, 0)
      local origin = ___MOD._WzUtils:getFastVector(v.origin, ___MOD.FastVector2.zero:Clone())
      local originX, originY = ___MOD._OffsetUtils:GetEvenPivotOffset(width, height, origin.x, origin.y, true)
      to.origin = ___MOD.FastVector3(originX, originY, 0)
    end
  end
  return cache
end
