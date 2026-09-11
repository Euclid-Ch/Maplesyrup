

function SoundUtils.broadcastCashStickerHitSoundAtPosLocal(self, path, target, volume, isLocalAttacker)
  if not ___MOD.isvalid(target) then
    return
  end
  local ruid = ___MOD.__RUIDManager:get(path)
  if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    return
  end
  if isLocalAttacker then
    if self:playCashStickerHitSoundByComponentPoolLocal(ruid, target, volume) then
      return
    end
    self:playOneShotSoundAtPosLocal(ruid, target.TransformComponent.Position, ___MOD._UserService.LocalPlayer, volume, self.SOUND_CATEGORY_MY_COMBAT)
    return
  end
  self:playOneShotSoundAtPosLocal(ruid, target.TransformComponent.Position, ___MOD._UserService.LocalPlayer, volume, self.SOUND_CATEGORY_NEAR_COMBAT)
end

function SoundUtils.broadcastPlayerSkillSoundAtPosRemote(self, path, speaker, volume, senderUserId)

end

function SoundUtils.broadcastSoundAtPosByRUIDLocal(self, ruid, player, target, volume)
  if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    self:playOneShotSoundAtPosLocal(ruid, target.TransformComponent.Position, ___MOD._UserService.LocalPlayer, volume, self:resolveCombatSoundCategory(player))
  end
end

function SoundUtils.broadcastSoundAtPosLocal(self, path, player, volume)
  local p = ___MOD.__RUIDManager:get(path)
  if not ___MOD._UtilLogic:IsNilorEmptyString(p) then
    self:playOneShotSoundAtPosLocal(p, player.TransformComponent.Position, ___MOD._UserService.LocalPlayer, volume, self.SOUND_CATEGORY_NEAR_COMBAT)
  end
end

function SoundUtils.broadcastSoundAtPosRemote(self, path, player, volume, senderUserId)

end

function SoundUtils.canPlayOneShotSound(self, ruid, soundCategory)
  if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    return false
  end
  local state = self:getSoundGuardState()
  local now = ___MOD._UtilLogic.ElapsedSeconds
  local windowSeconds = 0.25
  local activeCashStickerSoundCount = self:getActiveCashStickerHitSoundCountLocal()
  local maxOneShotCount = 21 - activeCashStickerSoundCount
  local category = self:normalizeSoundCategory(soundCategory)
  if state.windowStart <= 0 or windowSeconds <= now - state.windowStart then
    state.windowStart = now
    state.oneShotCount = 0
    for i = 1, self.SOUND_CATEGORY_COUNT do
      state.categoryCounts[i] = 0
    end
  end
  if maxOneShotCount <= state.oneShotCount then
    return false
  end
  local categoryCount = state.categoryCounts[category]
  if category == self.SOUND_CATEGORY_MY_COMBAT then
    categoryCount = categoryCount + activeCashStickerSoundCount
  end
  local categoryBaseLimit = state.categoryBaseLimits[category]
  local categoryMaxLimit = state.categoryMaxLimits[category]
  if categoryCount >= categoryMaxLimit then
    return false
  end
  if categoryCount >= categoryBaseLimit then
    local reservedHigherPriorityCount = 0
    for i = 1, category - 1 do
      local usedCount = state.categoryCounts[i]
      if i == self.SOUND_CATEGORY_MY_COMBAT then
        usedCount = usedCount + activeCashStickerSoundCount
      end
      local remainingBaseCount = state.categoryBaseLimits[i] - usedCount
      if 0 < remainingBaseCount then
        reservedHigherPriorityCount = reservedHigherPriorityCount + remainingBaseCount
      end
    end
    if reservedHigherPriorityCount > maxOneShotCount - (state.oneShotCount + 1) then
      return false
    end
  end
  state.oneShotCount = state.oneShotCount + 1
  state.categoryCounts[category] = state.categoryCounts[category] + 1
  return true
end

function SoundUtils.clearCashStickerHitSoundComponentPoolLocal(self)
  local entities = self._T.cashStickerHitSoundComponentPoolEntities
  if entities ~= nil then
    for i = 1, self.CASH_STICKER_SOUND_POOL_SIZE do
      local entity = entities[i]
      if ___MOD.isvalid(entity) then
        entity:Destroy()
      end
      entities[i] = nil
    end
  end
  self._T.cashStickerHitSoundComponentPoolIndex = 0
  self._T.cashStickerHitSoundComponentPoolRuid = ""
  self._T.cashStickerHitSoundComponentPoolMap = nil
  self._T.cashStickerHitSoundComponentPoolReady = false
end

function SoundUtils.ensureCashStickerHitSoundComponentPoolLocal(self, ruid, source, volume)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not (___MOD.isvalid(source) and ___MOD.isvalid(localPlayer)) or not ___MOD.isvalid(localPlayer.CurrentMap) then
    return false
  end
  local currentMap = localPlayer.CurrentMap
  if self._T.cashStickerHitSoundComponentPoolMap ~= currentMap or self._T.cashStickerHitSoundComponentPoolRuid ~= ruid then
    self:clearCashStickerHitSoundComponentPoolLocal()
  end
  if self._T.cashStickerHitSoundComponentPoolReady == true then
    return true
  end
  local entities = self._T.cashStickerHitSoundComponentPoolEntities
  if entities == nil then
    entities = {}
    self._T.cashStickerHitSoundComponentPoolEntities = entities
  end
  ___MOD._SoundService:LoadSound(ruid)
  local sourcePosition = source.TransformComponent.WorldPosition
  for i = 1, self.CASH_STICKER_SOUND_POOL_SIZE do
    local entity = ___MOD._SpawnService:SpawnByModelId("model://transformonly", "CashStickerSoundPool" .. ___MOD.tostring(i), sourcePosition, currentMap)
    if not ___MOD.isvalid(entity) then
      self:clearCashStickerHitSoundComponentPoolLocal()
      return false
    end
    entity:AddComponent(___MOD.SoundComponent)
    local soundComponent = entity.SoundComponent
    if not ___MOD.isvalid(soundComponent) then
      entity:Destroy()
      self:clearCashStickerHitSoundComponentPoolLocal()
      return false
    end
    soundComponent.AudioClipRUID = ruid
    soundComponent.Volume = volume
    soundComponent.PlayOnEnable = false
    soundComponent.Bgm = false
    soundComponent.Loop = false
    soundComponent.SetCameraAsListener = false
    soundComponent:SetListenerEntity(localPlayer)
    entities[i] = entity
  end
  self._T.cashStickerHitSoundComponentPoolRuid = ruid
  self._T.cashStickerHitSoundComponentPoolMap = currentMap
  self._T.cashStickerHitSoundComponentPoolReady = true
  return true
end

function SoundUtils.ensureSoundCategoryState(self, state)
  if state.categoryCounts == nil then
    state.categoryCounts = {
      0,
      0,
      0,
      0,
      0,
      0
    }
  end
  if state.categoryBaseLimits == nil then
    state.categoryBaseLimits = {
      7,
      4,
      3,
      2,
      1,
      1
    }
  end
  if state.categoryMaxLimits == nil then
    state.categoryMaxLimits = {
      11,
      7,
      4,
      4,
      3,
      2
    }
  end
  if state.activeLoopCategories == nil then
    state.activeLoopCategories = {}
  end
  if state.activeLoopCounts == nil then
    state.activeLoopCounts = {0, 0}
  end
  if state.loopCategoryLimits == nil then
    state.loopCategoryLimits = {2, 1}
  end
  for i = 1, self.SOUND_CATEGORY_COUNT do
    state.categoryCounts[i] = state.categoryCounts[i] or 0
  end
  for i = 1, self.SOUND_LOOP_CATEGORY_COUNT do
    state.activeLoopCounts[i] = state.activeLoopCounts[i] or 0
  end
end

function SoundUtils.get_sound_volume_by_pos(self, x, y)
  local user = ___MOD._UserService.LocalPlayer
  if not user then
    return 0.4
  end
  local userPos = user.TransformComponent:WorldPositionAsFastVector3()
  local dx = userPos[1] - x
  local dy = userPos[2] - y
  local dist = ___MOD.math.sqrt(dx * dx + dy * dy + 0.001)
  if dist < 2.5 then
    return 1
  end
  if dist < 10 then
    return ___MOD.math.floor(120 - dist * 0.08) * 0.01
  end
  return 0.4
end

function SoundUtils.getActiveCashStickerHitSoundCountLocal(self)
  local entities = self._T.cashStickerHitSoundComponentPoolEntities
  if entities == nil or self._T.cashStickerHitSoundComponentPoolReady ~= true then
    return 0
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not (___MOD.isvalid(localPlayer) and ___MOD.isvalid(localPlayer.CurrentMap)) or self._T.cashStickerHitSoundComponentPoolMap ~= localPlayer.CurrentMap then
    self:clearCashStickerHitSoundComponentPoolLocal()
    return 0
  end
  local activeCount = 0
  for i = 1, self.CASH_STICKER_SOUND_POOL_SIZE do
    local entity = entities[i]
    if ___MOD.isvalid(entity) and ___MOD.isvalid(entity.SoundComponent) and entity.SoundComponent:IsPlaying() then
      activeCount = activeCount + 1
    end
  end
  return activeCount
end

function SoundUtils.getSoundGuardState(self)
  if self._T.soundGuardState == nil then
    self._T.soundGuardState = {
      windowStart = 0,
      oneShotCount = 0,
      activeLoops = {}
    }
  end
  local state = self._T.soundGuardState
  state.windowStart = state.windowStart or 0
  state.oneShotCount = state.oneShotCount or 0
  state.activeLoops = state.activeLoops or {}
  self:ensureSoundCategoryState(state)
  return self._T.soundGuardState
end

function SoundUtils.normalizeSoundCategory(self, soundCategory)
  if soundCategory == nil then
    return self.SOUND_CATEGORY_ETC
  end
  if soundCategory <= 0 then
    return self.SOUND_CATEGORY_ETC
  end
  if soundCategory > self.SOUND_CATEGORY_COUNT then
    return self.SOUND_CATEGORY_ETC
  end
  return soundCategory
end

function SoundUtils.playCashStickerHitSoundByComponentPoolLocal(self, ruid, source, volume)
  if not self:ensureCashStickerHitSoundComponentPoolLocal(ruid, source, volume) then
    return false
  end
  local nextIndex = (self._T.cashStickerHitSoundComponentPoolIndex or 0) + 1
  if nextIndex > self.CASH_STICKER_SOUND_POOL_SIZE then
    nextIndex = 1
  end
  local entities = self._T.cashStickerHitSoundComponentPoolEntities
  local target = entities[nextIndex]
  if not ___MOD.isvalid(target) or not ___MOD.isvalid(target.SoundComponent) then
    self:clearCashStickerHitSoundComponentPoolLocal()
    if not self:ensureCashStickerHitSoundComponentPoolLocal(ruid, source, volume) then
      return false
    end
    entities = self._T.cashStickerHitSoundComponentPoolEntities
    target = entities[nextIndex]
  end
  self._T.cashStickerHitSoundComponentPoolIndex = nextIndex
  target.TransformComponent.WorldPosition = source.TransformComponent.WorldPosition
  target.SoundComponent.Volume = volume
  target.SoundComponent:Play()
  return true
end

function SoundUtils.playLoopSoundLocal(self, ruid, volume, loopCategory)
  if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    return
  end
  local state = self:getSoundGuardState()
  local category = loopCategory
  if category == nil or category <= 0 or category > self.SOUND_LOOP_CATEGORY_COUNT then
    category = self.SOUND_LOOP_CATEGORY_OTHER
  end
  if state.activeLoops[ruid] == true then
    return
  end
  if state.activeLoopCounts[category] >= state.loopCategoryLimits[category] then
    return
  end
  state.activeLoops[ruid] = true
  state.activeLoopCategories[ruid] = category
  state.activeLoopCounts[category] = state.activeLoopCounts[category] + 1
  ___MOD._SoundService:PlayLoopSound(ruid, volume)
end

function SoundUtils.playOneShotSoundAtPosLocal(self, ruid, pos, listener, volume, soundCategory)
  if not self:canPlayOneShotSound(ruid, soundCategory) then
    return
  end
  ___MOD._SoundService:PlaySoundAtPos(ruid, pos, listener, volume)
end

function SoundUtils.playOneShotSoundLocal(self, ruid, volume, soundCategory)
  if not self:canPlayOneShotSound(ruid, soundCategory) then
    return
  end
  ___MOD._SoundService:PlaySound(ruid, volume)
end

function SoundUtils.playPlayerSkillSoundAtPosLocal(self, path, speaker, volume)
  if not self:shouldPlayOtherPlayerSkillSound(speaker) then
    return
  end
  local p = ___MOD.__RUIDManager:get(path)
  if not ___MOD._UtilLogic:IsNilorEmptyString(p) and speaker then
    self:playOneShotSoundAtPosLocal(p, speaker.TransformComponent.Position, ___MOD._UserService.LocalPlayer, volume, self:resolveCombatSoundCategory(speaker))
  end
end

function SoundUtils.playSkillSoundLocal(self, speacker, skillId)
  local soundSkillId = self:resolveSkillSoundRefId(skillId)
  self:playSoundLocal(speacker, "Skill.img", ___MOD.tostring(soundSkillId), "Use")
end

function SoundUtils.playSoundLocal(self, speaker, imgName, l1, l2)
  local cache = {}
  local utilLogic = ___MOD._UtilLogic
  if not utilLogic:IsNilorEmptyString(imgName) then
    cache[#cache + 1] = imgName
  end
  if not utilLogic:IsNilorEmptyString(l1) then
    cache[#cache + 1] = l1
  end
  if not utilLogic:IsNilorEmptyString(l2) then
    cache[#cache + 1] = l2
  end
  local path = ___MOD.table.concat(cache, ".")
  local ruid = ___MOD.__RUIDManager:get(path)
  if utilLogic:IsNilorEmptyString(ruid) then
    ___MOD.log_error("RUID가 Nil or Empty 입니다.")
    return
  end
  if speaker then
    self:playOneShotSoundAtPosLocal(ruid, speaker.TransformComponent.Position, ___MOD._UserService.LocalPlayer, 1, self:resolveCombatSoundCategory(speaker))
  else
    self:playOneShotSoundLocal(ruid, 1, self.SOUND_CATEGORY_ETC)
  end
end

function SoundUtils.resolveCombatSoundCategory(self, speaker)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(localPlayer) and ___MOD.isvalid(speaker) and speaker == localPlayer then
    return self.SOUND_CATEGORY_MY_COMBAT
  end
  return self.SOUND_CATEGORY_NEAR_COMBAT
end

function SoundUtils.resolveSkillSoundRefId(self, skillId)
  local book = ___MOD._SkillBook
  if skillId == book.Useful_Haste_000_8000 or skillId == book.Useful_Haste_1000_10008000 or skillId == book.Useful_Haste_2000_20008000 or skillId == book.Useful_Haste_2001_20018000 then
    return book.Haste_410_4101004
  end
  if skillId == book.Useful_Mystic_Door_000_8001 or skillId == book.Useful_Mystic_Door_1000_10008001 or skillId == book.Useful_Mystic_Door_2000_20008001 or skillId == book.Useful_Mystic_Door_2001_20018001 then
    return book.Mystic_Door_231_2311002
  end
  if skillId == book.Useful_Sharp_Eyes_000_8002 or skillId == book.Useful_Sharp_Eyes_1000_10008002 or skillId == book.Useful_Sharp_Eyes_2000_20008002 or skillId == book.Useful_Sharp_Eyes_2001_20018002 then
    return book.Sharp_Eyes_312_3121002
  end
  if skillId == book.Useful_Hyper_Body_000_8003 or skillId == book.Useful_Hyper_Body_1000_10008003 or skillId == book.Useful_Hyper_Body_2000_20008003 or skillId == book.Useful_Hyper_Body_2001_20018003 then
    return book.Hyper_Body_130_1301007
  end
  return skillId
end

function SoundUtils.shouldPlayDropSound(self, sourceID)
  if ___MOD._UtilLogic:IsNilorEmptyString(sourceID) then
    return true
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not (___MOD.isvalid(localPlayer) and ___MOD.isvalid(localPlayer.Player)) or not ___MOD.isvalid(localPlayer.UISystemOptionComponent) then
    return true
  end
  return ___MOD.tostring(sourceID or "") == ___MOD.tostring(localPlayer.Player.PlayerId or "") or localPlayer.UISystemOptionComponent.enableOtherSkillHitSound
end

function SoundUtils.shouldPlayOtherPlayerSkillSound(self, speaker)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not localPlayer or not localPlayer.UISystemOptionComponent then
    return true
  end
  if not speaker or not speaker.Player then
    return true
  end
  return speaker == localPlayer or localPlayer.UISystemOptionComponent.enableOtherSkillHitSound
end

function SoundUtils.stopLoopSoundLocal(self, ruid)
  if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    return
  end
  local state = self:getSoundGuardState()
  if state.activeLoops[ruid] == true then
    local category = state.activeLoopCategories[ruid] or self.SOUND_LOOP_CATEGORY_OTHER
    if state.activeLoopCounts[category] > 0 then
      state.activeLoopCounts[category] = state.activeLoopCounts[category] - 1
    end
  end
  state.activeLoops[ruid] = nil
  state.activeLoopCategories[ruid] = nil
  ___MOD._SoundService:StopSound(ruid)
end
