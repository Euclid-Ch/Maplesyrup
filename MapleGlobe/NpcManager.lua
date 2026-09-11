

function NpcManager.buildNpcDefaultAction(self, info)
  if info == nil or ___MOD._UtilLogic:IsNilorEmptyString(info.default_RUID) then
    return nil
  end
  local spriteSize = info.default_Size or ___MOD.FastVector2(0, 0)
  local originFull = info.default_Origin or ___MOD.FastVector2(0, 0)
  local originHalf = info.default_OriginHalf or originFull
  local frame = ___MOD.SpriteFrame()
  frame.RUID = info.default_RUID
  frame.spriteSize = ___MOD.FastVector2(spriteSize.x, spriteSize.y)
  frame.originOffset = ___MOD.FastVector3(originFull.x / 100.0, originFull.y / 100.0, 0)
  frame.originOffsetFlip = ___MOD.FastVector3(-originFull.x / 100.0, originFull.y / 100.0, 0)
  frame.originHalfOffset = ___MOD.FastVector3(originHalf.x / 100.0, originHalf.y / 100.0, 0)
  frame.originHalfOffsetFlip = ___MOD.FastVector3(-originHalf.x / 100.0, originHalf.y / 100.0, 0)
  frame.originUI = ___MOD.FastVector2(originHalf.x, originHalf.y)
  frame.originUIFlip = ___MOD.FastVector2(-originHalf.x, originHalf.y)
  frame.collisionOffset = ___MOD.FastVector2(0, 0)
  frame.boxSize = ___MOD.FastVector2(0, 0)
  frame.delay = 100
  frame.A0 = 1
  frame.A1 = 1
  frame.Z0 = 1
  frame.Z1 = 1
  frame.Z = 0
  frame.head = ___MOD.FastVector3(0, 0, 0)
  frame.moveType = 0
  frame.moveH = 0
  frame.moveW = 0
  frame.moveP = 0
  local clip = {
    anim = {},
    RUIDs = {
      info.default_RUID
    },
    asynced = false
  }
  clip.anim[1] = frame
  clip.totalDelay = frame.delay
  return clip
end

function NpcManager.ensureNpcLoaded(self, npcId)
  if not self.fastLoad then
    return
  end
  if self.NpcAnims[npcId] ~= nil then
    return
  end
  local data = self.npcRaw[npcId]
  data = ___MOD._WzUtils:parseWzData(data)
  if ___MOD.type(data) ~= "table" then
    return
  end
  local managedCondition = self:isQuestConditionNpc(npcId)
  local npcData = {
    info = nil,
    anims = {},
    conditions = {}
  }
  local anims = npcData.anims
  if data.info then
    npcData.info = self:makeNpcInfo(npcId, data.info)
  end
  for key, dir in ___MOD.pairs(data) do
    if key ~= "info" and ___MOD.type(dir) == "table" then
      if managedCondition and self:isQuestConditionKey(key) then
        ___MOD.table.insert(npcData.conditions, self:parseNpcQuestCondition(key, dir))
      else
        anims[key] = ___MOD._WzUtils:parseAnimation(dir)
      end
    end
  end
  if managedCondition then
    self:sortNpcQuestConditions(npcData.conditions)
  end
  self.NpcAnims[npcId] = npcData
  if self.scriptIndexBuilt then
    local sn = npcData.info and npcData.info._script or nil
    if sn ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(sn) and self.scriptToNpcId[sn] == nil then
      self.scriptToNpcId[sn] = npcId
    end
  end
  local linkId = npcData.info and npcData.info.link or 0
  if 0 < linkId and linkId ~= npcId then
    self:ensureNpcLoaded(linkId)
    local src = self.NpcAnims[linkId]
    if src and src.anims then
      npcData.anims = src.anims
    end
  end
end

function NpcManager.ensureScriptIndexBuilt(self)
  if self.scriptIndexBuilt then
    return
  end
  self.scriptToNpcId = {}
  for npcId, npc in ___MOD.pairs(self.NpcAnims) do
    local info = npc and npc.info
    local sn = info and info._script or nil
    if sn ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(sn) and self.scriptToNpcId[sn] == nil then
      self.scriptToNpcId[sn] = npcId
    end
  end
  if self.fastLoad then
    for npcId, raw in ___MOD.pairs(self.npcRaw) do
      local data = ___MOD._WzUtils:parseWzData(raw)
      if ___MOD.type(data) == "table" and data.info then
        local info = self:makeNpcInfo(npcId, data.info)
        local sn = info and info._script or nil
        if sn ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(sn) and self.scriptToNpcId[sn] == nil then
          self.scriptToNpcId[sn] = npcId
        end
      end
    end
  end
  self.scriptIndexBuilt = true
end

function NpcManager.getMatchedNpcQuestCondition(self, npcId, questComponent)
  if not self:isQuestConditionNpc(npcId) or not ___MOD.isvalid(questComponent) then
    return nil
  end
  if self.fastLoad then
    self:ensureNpcLoaded(npcId)
  end
  local npc = self.NpcAnims[npcId]
  local conditions = npc and npc.conditions or nil
  if conditions == nil then
    return nil
  end
  for i = 1, #conditions do
    local condition = conditions[i]
    local matched = true
    for questId, requiredState in ___MOD.pairs(condition.quests) do
      if questComponent:getQuestState(questId) ~= requiredState then
        matched = false
        break
      end
    end
    if matched then
      return condition
    end
  end
  return nil
end

function NpcManager.getNpcAction(self, npcId, key)
  if self.fastLoad then
    self:ensureNpcLoaded(npcId)
  end
  local npc = self.NpcAnims[npcId]
  return npc and npc.anims and npc.anims[key] or nil
end

function NpcManager.getNpcDefaultAction(self, npcId)
  if self.fastLoad then
    self:ensureNpcLoaded(npcId)
  end
  local npc = self.NpcAnims[npcId]
  if npc == nil then
    return nil
  end
  if npc.defaultClip ~= nil then
    return npc.defaultClip
  end
  local info = npc.info
  if info == nil or ___MOD._UtilLogic:IsNilorEmptyString(info.default_RUID) then
    return nil
  end
  local clip = self:buildNpcDefaultAction(info)
  npc.defaultClip = clip
  return clip
end

function NpcManager.getNpcDefaultTemplate(self, npcId)
  if self.fastLoad then
    self:ensureNpcLoaded(npcId)
  end
  local stand = self:getNpcAction(npcId, "stand")
  local frame = stand and stand.anim and stand.anim[1] or nil
  if frame ~= nil then
    return frame
  end
  local defaultStand = self:getNpcDefaultAction(npcId)
  return defaultStand and defaultStand.anim and defaultStand.anim[1] or nil
end

function NpcManager.getNpcIdByScriptName(self, scriptName)
  if ___MOD._UtilLogic:IsNilorEmptyString(scriptName) then
    return nil
  end
  self:ensureScriptIndexBuilt()
  return self.scriptToNpcId[scriptName]
end

function NpcManager.getNpcInfo(self, npcId)
  if self.fastLoad then
    self:ensureNpcLoaded(npcId)
  end
  local npc = self.NpcAnims[npcId]
  return npc and npc.info or nil
end

function NpcManager.getNpcRandomAnims(self, npcId)
  if self.fastLoad then
    self:ensureNpcLoaded(npcId)
  end
  local npc = self.NpcAnims[npcId]
  if npc == nil or npc.anims == nil then
    return nil
  end
  local cache = {}
  for key, anim in ___MOD.pairs(npc.anims) do
    if anim.special == nil and not self:isNonActionKey(key) then
      cache[key] = anim
    end
  end
  return cache
end

function NpcManager.isNonActionKey(self, key)
  return key == "shop"
end

function NpcManager.isNpcVisibleForQuest(self, npcId, questComponent)
  if not self:isQuestConditionNpc(npcId) then
    return true
  end
  local condition = self:getMatchedNpcQuestCondition(npcId, questComponent)
  if condition ~= nil then
    return condition.hide ~= true
  end
  local info = self:getNpcInfo(npcId)
  return info ~= nil and info.hide ~= true
end

function NpcManager.isQuestConditionKey(self, key)
  return key == "condition" or ___MOD.string.match(key, "^condition%d+$") ~= nil
end

function NpcManager.isQuestConditionNpc(self, npcId)
  self:loadQuestConditionNpcIds()
  return self.questConditionNpcIds[npcId] == true
end

function NpcManager.loadNpc(self)
  if self:IsServer() then
    self.fastLoad = ___MOD.Environment:IsMakerPlay()
  end
  if self.fastLoad then
    self:loadNpcLazy()
  else
    self:loadNpcFull()
  end
end

function NpcManager.loadNpcFull(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local dataset = ___MOD._DataService:GetTable("Npc_wz")
  if dataset == nil then
    ___MOD.log("Npc_wz table not found")
    return
  end
  local rowCount = dataset:GetRowCount()
  local npcCaches = {}
  self.count = 0
  for i = 1, rowCount do
    local id = ___MOD._UtilLogic:Replace(dataset:GetCell(i, "key"), ".img", "")
    local npcId = ___MOD.tonumber(id) or 0
    if npcId ~= 0 then
      local data = dataset:GetCell(i, "data")
      data = ___MOD._WzUtils:parseWzData(data)
      if ___MOD.type(data) == "table" then
        local managedCondition = self:isQuestConditionNpc(npcId)
        local npcData = {
          info = nil,
          anims = {},
          conditions = {}
        }
        local anims = npcData.anims
        if data.info then
          npcData.info = self:makeNpcInfo(npcId, data.info)
        end
        for key, dir in ___MOD.pairs(data) do
          if key ~= "info" and ___MOD.type(dir) == "table" then
            if managedCondition and self:isQuestConditionKey(key) then
              ___MOD.table.insert(npcData.conditions, self:parseNpcQuestCondition(key, dir))
            else
              anims[key] = ___MOD._WzUtils:parseAnimation(dir)
            end
          end
        end
        if managedCondition then
          self:sortNpcQuestConditions(npcData.conditions)
        end
        npcCaches[npcId] = npcData
        self.count = self.count + 1
      end
    end
  end
  for id, npc in ___MOD.pairs(npcCaches) do
    local link = npc.info and npc.info.link or 0
    local src = npcCaches[link]
    if 0 < link and src then
      for k, v in ___MOD.pairs(src) do
        if k ~= "info" then
          npc[k] = v
        end
      end
    end
  end
  self.NpcAnims = npcCaches
  self.scriptIndexBuilt = false
  self.scriptToNpcId = {}
  self.npcRaw = {}
  ___MOD.log(___MOD.string.format("Loaded Npc.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end

function NpcManager.loadNpcLazy(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable("Npc_wz")
  if ds == nil then
    ___MOD.log("Npc.wz table not found")
    return
  end
  local rowCount = ds:GetRowCount()
  local npcRaw = {}
  self.count = 0
  self.NpcAnims = {}
  for i = 1, rowCount do
    local key = ___MOD._UtilLogic:Replace(ds:GetCell(i, "key"), ".img", "")
    local npcId = ___MOD.tonumber(key) or 0
    if npcId ~= 0 then
      local data = ds:GetCell(i, "data")
      if data ~= nil then
        npcRaw[npcId] = data
        self.count = self.count + 1
      end
    end
  end
  self.npcRaw = npcRaw
  self.scriptIndexBuilt = false
  self.scriptToNpcId = {}
  ___MOD.log(___MOD.string.format("Indexed Npc.wz (Lazy) (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end

function NpcManager.loadQuestConditionNpcIds(self)
  if self.questConditionNpcIdsLoaded then
    return
  end
  self.questConditionNpcIdsLoaded = true
  local dataset = ___MOD._DataService:GetTable("NpcQuestCondition")
  if dataset == nil then
    return
  end
  local rowCount = dataset:GetRowCount()
  for i = 1, rowCount do
    local npcId = ___MOD.tonumber(dataset:GetCell(i, "npcId")) or 0
    if 0 < npcId then
      self.questConditionNpcIds[npcId] = true
    end
  end
end

function NpcManager.makeNpcInfo(self, npcId, dir)
  local npcInfo = ___MOD.NPCInfo()
  npcInfo.npcId = npcId
  npcInfo.link = ___MOD.tonumber(___MOD._WzUtils:getString(dir.link, "0")) or 0
  npcInfo.guildRank = ___MOD._WzUtils:getBoolean(dir.guildRank, false)
  npcInfo.hideName = ___MOD._WzUtils:getBoolean(dir.hideName, false)
  npcInfo.hide = ___MOD._WzUtils:getBoolean(dir.hide, false)
  npcInfo.imitate = ___MOD._WzUtils:getBoolean(dir.imitate, false)
  npcInfo.talkMouseOnly = ___MOD._WzUtils:getBoolean(dir.talkMouseOnly, false)
  npcInfo.float = ___MOD._WzUtils:getBoolean(dir.float, false)
  npcInfo.dcMark = ___MOD._WzUtils:getBoolean(dir.dcMark, false)
  npcInfo.quest = ___MOD._WzUtils:getString(dir.quest, "")
  npcInfo.trunkGet = ___MOD._WzUtils:getInteger(dir.trunkGet, 0)
  npcInfo.trunkPut = ___MOD._WzUtils:getInteger(dir.trunkPut, 0)
  npcInfo.storebank = ___MOD._WzUtils:getBoolean(dir.storebank, false)
  npcInfo.parcel = ___MOD._WzUtils:getBoolean(dir.parcel, false)
  npcInfo.rpsGame = ___MOD._WzUtils:getBoolean(dir.rpsGame, false)
  npcInfo.cash = ___MOD._WzUtils:getBoolean(dir.cash, false)
  local dcLeft = ___MOD._WzUtils:getInteger(dir.dcLeft, -22) / 100
  local dcRight = ___MOD._WzUtils:getInteger(dir.dcRight, 22) / 100
  local dcTop = ___MOD._WzUtils:getInteger(dir.dcTop, -65) / 100
  local dcBottom = ___MOD._WzUtils:getInteger(dir.dcBottom, 0) / 100
  local dcRect = ___MOD.FastVector2(dcRight - dcLeft, -dcTop - -dcBottom)
  local dcRectOffset = ___MOD.FastVector2((dcRight + dcLeft) / 2, (-dcTop + -dcBottom) / 2)
  npcInfo.dcRect = dcRect
  npcInfo.dcRectOffset = dcRectOffset
  if dir.default then
    local default = dir.default
    npcInfo.default_RUID = ___MOD._WzUtils:getImageRUID(default, "")
    npcInfo.default_Size = ___MOD._WzUtils:getSize(default, nil)
    local originP = ___MOD._WzUtils:getFastVector(default.origin, ___MOD.FastVector2(0, 0))
    local spriteSize = npcInfo.default_Size
    local offsetX, offsetY = ___MOD._OffsetUtils:GetEvenPivotOffset(spriteSize.x, spriteSize.y, originP.x, originP.y, false)
    npcInfo.default_Origin = ___MOD.FastVector2(offsetX, offsetY)
    local halfX, halfY = ___MOD._OffsetUtils:GetEvenPivotOffset(spriteSize.x, spriteSize.y, originP.x, originP.y, true)
    npcInfo.default_OriginHalf = ___MOD.FastVector2(halfX, halfY)
  end
  if dir.speak ~= nil then
    local speak = npcInfo.speak
    for index, value in ___MOD.pairs(dir.speak) do
      local speakIndex = ___MOD.tonumber(index)
      if speakIndex then
        speakIndex = speakIndex + 1
        speak[speakIndex] = ___MOD._WzUtils:getString(value, "")
      end
    end
  end
  if dir.script ~= nil then
    local s = dir.script
    local _script = s and s["0"] and s["0"].script or nil
    if _script then
      npcInfo._script = ___MOD._WzUtils:getString(_script, "")
    end
  end
  return npcInfo
end

function NpcManager.parseNpcQuestCondition(self, key, dir)
  local condition = {
    key = key,
    hide = ___MOD._WzUtils:getBoolean(dir.hide, false),
    quests = {},
    anims = {}
  }
  for childKey, value in ___MOD.pairs(dir) do
    local questId = ___MOD.tonumber(childKey)
    if questId ~= nil then
      condition.quests[questId] = ___MOD.tonumber(value) or 0
    elseif childKey ~= "hide" and ___MOD.type(value) == "table" then
      condition.anims[childKey] = ___MOD._WzUtils:parseAnimation(value)
    end
  end
  return condition
end

function NpcManager.sortNpcQuestConditions(self, conditions)
  ___MOD.table.sort(conditions, function(a, b)
    local aIndex = a.key == "condition" and 0 or ___MOD.tonumber(___MOD.string.match(a.key, "%d+")) or 0
    local bIndex = b.key == "condition" and 0 or ___MOD.tonumber(___MOD.string.match(b.key, "%d+")) or 0
    return aIndex < bIndex
  end)
end
