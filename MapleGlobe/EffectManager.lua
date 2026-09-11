

function EffectManager.applySetEffectOffset(self, target)
  local targetVariables = target.PlayerVariables
  local offset = targetVariables.setEffMotionOffset
  if offset == nil then
    return
  end
  local totalX = offset.motionX or 0
  local totalY = (offset.motionY or 0) + (offset.proneY or 0)
  local appliedX = offset.appliedX or 0
  local appliedY = offset.appliedY or 0
  if appliedX == totalX and appliedY == totalY then
    return
  end
  local deltaX = totalX - appliedX
  local deltaY = totalY - appliedY
  local targetPool = targetVariables.setEffAnimationPool
  if targetPool ~= nil then
    for _, effectEntity in ___MOD.pairs(targetPool) do
      if ___MOD.isvalid(effectEntity) then
        local transform = effectEntity.TransformComponent
        local pos = transform:PositionAsFastVector3()
        transform.Position = ___MOD.FastVector3(pos.x + deltaX, pos.y + deltaY, pos.z)
      end
    end
  end
  offset.appliedX = totalX
  offset.appliedY = totalY
end

function EffectManager.getDirection(self, path)
  return self.directionCache[path]
end

function EffectManager.getEffect(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.cache
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

function EffectManager.getMapEffect(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.mapCache
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

function EffectManager.getNode(self, path)
  if ___MOD._UtilLogic:IsNilorEmptyString(path) then
    return nil
  end
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.cache
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
      local tbl
      cacheTbl[path] = node
      return node
    end
    pos = s + 1
  end
end

function EffectManager.getUIEffect(self, path)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cached = ___MOD.rawget(cacheTbl, path)
  if cached then
    return cached
  end
  local node = self.uiCache
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

function EffectManager.loadDirection(self)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local cache = {}
  local node = self.cache
  local list = {
    "Direction.img",
    "Direction1.img",
    "Direction2.img",
    "Direction3.img",
    "Direction4.img",
    "Direction_CN.img"
  }
  for _, path in ___MOD.pairs(list) do
    local directionData = node[path]
    if ___MOD.isvalid(directionData) then
      for key, d in ___MOD.pairs(directionData) do
        if key ~= "sound" and key ~= "effect" then
          for scene, dd in ___MOD.pairs(d) do
            local p = ___MOD.string.format("Effect/%s/%s/%s", path, key, scene)
            cache[p] = {}
            if ___MOD.type(dd) == "table" then
              for index, data in ___MOD.pairs(dd) do
                local type = ___MOD._WzUtils:getInteger(data.type, 0)
                if type == ___MOD._EffectDirectionType.imageMove then
                  local imageMove = ___MOD.ImageMove()
                  imageMove.visual = ___MOD._WzUtils:getString(data.visual, "")
                  imageMove.start = ___MOD._WzUtils:getInteger(data.start, 0)
                  imageMove.x = ___MOD._WzUtils:getInteger(data.x, 0)
                  imageMove.x1 = ___MOD._WzUtils:getInteger(data.x1, 0)
                  imageMove.y = ___MOD._WzUtils:getInteger(data.y, 0)
                  imageMove.y1 = ___MOD._WzUtils:getInteger(data.y1, 0)
                  imageMove.z = ___MOD._WzUtils:getInteger(data.z, 0)
                  imageMove.sound = ___MOD._WzUtils:getString(data.sound, "")
                  imageMove.duration = ___MOD._WzUtils:getInteger(data.duration, 0)
                  cache[p][index] = imageMove
                elseif type == ___MOD._EffectDirectionType.transferField then
                  local transferField = ___MOD.TransferField()
                  transferField.field = ___MOD._WzUtils:getInteger(data.field, 999999999)
                  transferField.start = ___MOD._WzUtils:getInteger(data.start, 0)
                  transferField.z = ___MOD._WzUtils:getInteger(data.z, 0)
                  cache[p][index] = transferField
                elseif type == ___MOD._EffectDirectionType.avatarSetting then
                  local avatarSetting = ___MOD.AvatarSetting()
                  avatarSetting.start = ___MOD._WzUtils:getInteger(data.start, 0)
                  local items = {}
                  for i = 1, 25 do
                    local v = data[___MOD.tostring(i)]
                    if v ~= nil then
                      items[i] = v
                    end
                  end
                  avatarSetting.equipItems = items
                  cache[p][index] = avatarSetting
                elseif type == ___MOD._EffectDirectionType.avatarAction then
                  local avatarAction = ___MOD.AvatarAction()
                  avatarAction.action = ___MOD._WzUtils:getString(data.action, "")
                  avatarAction.start = ___MOD._WzUtils:getInteger(data.start, 0)
                  cache[p][index] = avatarAction
                elseif type == ___MOD._EffectDirectionType.playSound then
                  local playSound = ___MOD.PlaySound()
                  playSound.sound = ___MOD._WzUtils:getString(data.sound, "")
                  playSound.start = ___MOD._WzUtils:getInteger(data.start, 0)
                  cache[p][index] = playSound
                elseif type == ___MOD._EffectDirectionType.targetEffect and path == "Direction_CN.img" then
                  local targetEffect = ___MOD.TargetEffect()
                  targetEffect.visual = ___MOD._WzUtils:getString(data.visual, "")
                  targetEffect.start = ___MOD._WzUtils:getInteger(data.start, 0)
                  targetEffect.npcID = ___MOD._WzUtils:getInteger(data.npcID, 0)
                  cache[p][index] = targetEffect
                end
              end
            end
          end
        end
      end
    end
  end
  self.directionCache = cache
end

function EffectManager.loadEffect(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable("Effect_wz")
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  for i = 1, count do
    local key = get(ds, i, 1)
    local data = get(ds, i, 2)
    data = ___MOD._WzUtils:parseWzData(data)
    if ___MOD.type(data) == "table" then
      self.cache[key] = data
      count1 = count1 + 1
    end
  end
  self:loadSetEff()
  self:loadDirection()
  self:loadSummonEff()
  ___MOD.log(___MOD.string.format("Loaded Effect.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
  time = ___MOD._UtilLogic.ElapsedSeconds
  ds = ___MOD._DataService:GetTable("UI_wz")
  count = ds:GetRowCount()
  get = ds.GetCell
  count1 = 0
  local loadkeys = {
    ["tutorial.img"] = true
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
  ___MOD.log(___MOD.string.format("Loaded UI.wz Effect (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
  time = ___MOD._UtilLogic.ElapsedSeconds
  ds = ___MOD._DataService:GetTable("Map_Effect_wz")
  count = ds:GetRowCount()
  get = ds.GetCell
  count1 = 0

  local function normalizeMapEffect(node)
    local nodeType = ___MOD.type(node)
    if nodeType == "table" then
      for k, v in ___MOD.pairs(node) do
        node[k] = normalizeMapEffect(v)
      end
      return node
    elseif nodeType == "string" then
      return ___MOD.string.gsub(node, "^Map_Effect", "Map", 1)
    end
    return node
  end

  for i = 1, count do
    local key = get(ds, i, 1)
    local data = get(ds, i, 2)
    data = ___MOD._WzUtils:parseWzData(data)
    if ___MOD.type(data) == "table" then
      data = normalizeMapEffect(data)
      self.mapCache[key] = data
      count1 = count1 + 1
    end
  end
  ___MOD.log(___MOD.string.format("Loaded Map_Effect.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, count1))
  ___MOD._DataLoadManager:compeletedLoad()
end

function EffectManager.loadSetEff(self)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local node = self.cache
  local setEffData = node["SetEff.img"]
  local setEff = {}
  local setEffIndexByItem = {}
  local setEffSlotCount = {}
  if setEffData then
    for key, data in ___MOD.pairs(setEffData) do
      if data then
        setEff[key] = {}
        local info = data.info
        local cash = ___MOD._WzUtils:getString(data.cash, "")
        local name = ___MOD._WzUtils:getString(data.name, "")
        if info then
          setEff[key].cash = cash
          setEff[key].name = name
          setEff[key].info = {}
          local slotCount = 0
          for k, v in ___MOD.pairs(info) do
            local inventorySlot = k
            local itemList = v
            if itemList then
              slotCount = slotCount + 1
              setEff[key].info[inventorySlot] = {}
              for _, itemID in ___MOD.pairs(itemList) do
                local parsedItemId = ___MOD._WzUtils:getInteger(itemID, 0)
                setEff[key].info[inventorySlot][_] = parsedItemId
                if parsedItemId ~= 0 then
                  local indexRow = setEffIndexByItem[parsedItemId]
                  if indexRow == nil then
                    indexRow = {}
                    setEffIndexByItem[parsedItemId] = indexRow
                  end
                  ___MOD.table.insert(indexRow, {key, inventorySlot})
                end
              end
            end
          end
          setEffSlotCount[key] = slotCount
        end
        local effdata = data.effect
        if effdata then
          local fixed = effdata.fixed or 0
          setEff[key].fixed = fixed
        end
        local backgrndData = data.backgrnd
        if backgrndData then
          local backgrndFixed = backgrndData.fixed or 0
          setEff[key].backgrndFixed = backgrndFixed
        end
      end
    end
  end
  self.setEffCache = setEff
  self.setEffIndexByItem = setEffIndexByItem
  self.setEffSlotCount = setEffSlotCount
end

function EffectManager.loadSummonEff(self)
  local find = ___MOD.string.find
  local sub = ___MOD.string.sub
  local cacheTbl = self.pathValueCache
  local node = self.cache
  local summonData = node["Summon.img"]
  local summon = {}
  if ___MOD.isvalid(summonData) then
    for key, data in ___MOD.pairs(summonData) do
      local keyNum = ___MOD.tonumber(key)
      summon[keyNum] = {}
      if ___MOD.isvalid(data) then
        summon[keyNum].delay = data.delay
        summon[keyNum] = ___MOD._WzUtils:parseAnimation(data)
      end
    end
    self.summonEffCache = summon
  end
end

function EffectManager.playSetEffect(self, target, path, key, poolKey, isBackgrnd)
  if not ___MOD.isvalid(target) then
    return
  end
  local targetVariables = target.PlayerVariables
  local pool = targetVariables.effectHalfObjPool
  local effectTarget = target
  local syncLayerTarget = target
  local effectPosition
  local setEff = self.setEffCache[key]
  local fixed
  if setEff ~= nil then
    if isBackgrnd then
      fixed = setEff.backgrndFixed
    else
      fixed = setEff.fixed
    end
  end
  local useDirectionFacing = fixed == 0
  if targetVariables ~= nil and targetVariables.getHead ~= nil then
    local head = targetVariables:getHead()
    if ___MOD.isvalid(head) then
      effectTarget = head
      effectPosition = ___MOD.FastVector2(0, -0.65)
    end
  end
  local effect = self:getEffect(path)
  if effect == nil or effect.anim == nil or effect.anim[1] == nil then
    self:releaseSetEffect(target, poolKey)
    return
  end
  local faceLeft = true
  if useDirectionFacing then
    local controller = target.ExtendPlayerControllerComponent
    if ___MOD.isvalid(controller) then
      faceLeft = 0 > controller.LookDirectionX
    end
  end
  local renderZ = 0
  if isBackgrnd and effect.z == nil then
    renderZ = 1
  end
  local effectEntity = ___MOD._ExtendedEffectService:makeEffect(effectTarget, effect, pool, faceLeft, true, true, true, syncLayerTarget, renderZ, effectPosition)
  if not ___MOD.isvalid(effectEntity) then
    self:releaseSetEffect(target, poolKey)
    return
  end
  local motionOffset = targetVariables.setEffMotionOffset
  if motionOffset ~= nil then
    local motionOffsetX = motionOffset.appliedX or 0
    local motionOffsetY = motionOffset.appliedY or 0
    if motionOffsetX ~= 0 or motionOffsetY ~= 0 then
      local offsetTransform = effectEntity.TransformComponent
      local basePos = offsetTransform:PositionAsFastVector3()
      offsetTransform.Position = ___MOD.FastVector3(basePos.x + motionOffsetX, basePos.y + motionOffsetY, basePos.z)
    end
  end
  targetVariables.setEffAnimationPool[poolKey] = effectEntity
end

function EffectManager.playSetEffectList(self, target, setEffList)
  local targetVariables = target.PlayerVariables
  local targetPool = targetVariables.setEffAnimationPool
  local currentSetEffList = targetVariables.setEffList or {}
  local nextSetEffList = setEffList or {}
  for key, _ in ___MOD.pairs(currentSetEffList) do
    if not nextSetEffList[key] then
      self:releaseSetEffect(target, key)
      self:releaseSetEffect(target, key .. ":backgrnd")
    end
  end
  for key, _ in ___MOD.pairs(nextSetEffList) do
    local hasEffect = targetPool[key]
    if not ___MOD.isvalid(hasEffect) then
      self:playSetEffect(target, "SetEff.img/" .. key .. "/effect", key, key, false)
    end
    local backgrndPoolKey = key .. ":backgrnd"
    local hasBackgrnd = targetPool[backgrndPoolKey]
    if not ___MOD.isvalid(hasBackgrnd) then
      self:playSetEffect(target, "SetEff.img/" .. key .. "/backgrnd", key, backgrndPoolKey, true)
    end
  end
  targetVariables.setEffList = nextSetEffList
end

function EffectManager.refreshSetEffectFacing(self, target, faceLeft)
  if not ___MOD.isvalid(target) then
    return
  end
  local targetVariables = target.PlayerVariables
  if not ___MOD.isvalid(targetVariables) then
    return
  end
  local targetPool = targetVariables.setEffAnimationPool
  if targetPool == nil then
    return
  end
  local setEffList = targetVariables.setEffList or {}
  for key, _ in ___MOD.pairs(setEffList) do
    local setEff = self.setEffCache[key]
    if setEff ~= nil then
      local effectEntity = targetPool[key]
      if setEff.fixed == 0 and ___MOD.isvalid(effectEntity) then
        local asc = effectEntity.AnimationSpriteComponent
        if ___MOD.isvalid(asc) then
          asc:setLeftFacing(faceLeft)
        end
      end
      local backgrndEntity = targetPool[key .. ":backgrnd"]
      if setEff.backgrndFixed == 0 and ___MOD.isvalid(backgrndEntity) then
        local asc = backgrndEntity.AnimationSpriteComponent
        if ___MOD.isvalid(asc) then
          asc:setLeftFacing(faceLeft)
        end
      end
    end
  end
end

function EffectManager.releaseSetEffect(self, target, key)
  if not ___MOD.isvalid(target) then
    return
  end
  local targetVariables = target.PlayerVariables
  local hasSetEffect = targetVariables.setEffAnimationPool[key]
  if ___MOD.isvalid(hasSetEffect) then
    ___MOD._ObjectPool:release(targetVariables.effectHalfObjPool, hasSetEffect, false)
    targetVariables.setEffAnimationPool[key] = nil
  end
end

function EffectManager.setSetEffectProneOffset(self, target, proneOffsetY)
  if not ___MOD.isvalid(target) then
    return
  end
  local targetVariables = target.PlayerVariables
  if not ___MOD.isvalid(targetVariables) then
    return
  end
  local offset = targetVariables.setEffMotionOffset
  if offset == nil then
    offset = {}
    targetVariables.setEffMotionOffset = offset
  end
  offset.proneY = proneOffsetY
  self:applySetEffectOffset(target)
end

function EffectManager.syncSetEffectMotionOffset(self, target, offsetX, offsetY)
  if not ___MOD.isvalid(target) then
    return
  end
  local targetVariables = target.PlayerVariables
  if not ___MOD.isvalid(targetVariables) then
    return
  end
  local offset = targetVariables.setEffMotionOffset
  if offset == nil then
    offset = {}
    targetVariables.setEffMotionOffset = offset
  end
  offset.motionX = offsetX
  offset.motionY = offsetY
  self:applySetEffectOffset(target)
end

function EffectManager.updateEquipSetEffect(self, target, mswCody, hair)
  if not ___MOD.isvalid(target) then
    return
  end
  local player = target.Player
  local equipCom = target.EquipmentComponent
  if not ___MOD.isvalid(player) or not ___MOD.isvalid(equipCom) then
    return
  end
  if mswCody then
    self:playSetEffectList(target, nil)
    return
  end
  local equipment = equipCom.equipment
  if not equipment or ___MOD.next(equipment) == nil then
    self:playSetEffectList(target, nil)
    return
  end
  local setEffList = {}
  local equippedItemSet = {}

  local function getSlotItem(slotIdx, subSlotIdx)
    local slot = equipment[slotIdx]
    if not slot then
      return nil
    end
    local subSlot = slot[subSlotIdx]
    return subSlot
  end

  local function isDiabledSlot(slotIdx)
    local slot = equipment[slotIdx]
    if not slot then
      return false
    end
    return slot.disabled or false
  end

  local function applySlot(slotIdx, output)
    local sticker = getSlotItem(slotIdx, ___MOD._EquipmentSubSlotType.STICKER)
    local main = getSlotItem(slotIdx, ___MOD._EquipmentSubSlotType.MAIN)
    if isDiabledSlot(slotIdx) then
      if sticker ~= nil then
        output[sticker.itemId] = true
      end
      return
    end
    if sticker ~= nil then
      output[sticker.itemId] = true
      return
    end
    if main ~= nil then
      output[main.itemId] = true
      return
    end
  end

  local setHair = player.Hair
  if hair ~= nil and 0 < hair then
    setHair = hair
  end
  if setHair ~= nil and 0 < setHair then
    equippedItemSet[setHair] = true
  end
  for slotIdx, _ in ___MOD.pairs(equipment) do
    applySlot(slotIdx, equippedItemSet)
  end
  local matchedSlotBySet = {}
  local matchedSlotCount = {}
  local setEffIndexByItem = self.setEffIndexByItem
  for itemId, _ in ___MOD.pairs(equippedItemSet) do
    local matchedSets = setEffIndexByItem[itemId]
    if matchedSets ~= nil then
      for i = 1, #matchedSets do
        local matched = matchedSets[i]
        local setKey = matched[1]
        local inventorySlot = matched[2]
        local slotMap = matchedSlotBySet[setKey]
        if slotMap == nil then
          slotMap = {}
          matchedSlotBySet[setKey] = slotMap
        end
        if slotMap[inventorySlot] ~= true then
          slotMap[inventorySlot] = true
          matchedSlotCount[setKey] = (matchedSlotCount[setKey] or 0) + 1
        end
      end
    end
  end
  for setKey, requiredSlotCount in ___MOD.pairs(self.setEffSlotCount) do
    if (matchedSlotCount[setKey] or 0) == requiredSlotCount then
      setEffList[setKey] = 1
    end
  end
  self:playSetEffectList(target, setEffList)
end
