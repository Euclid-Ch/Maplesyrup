

function PlayerTemporaryStatView.add(self, nID, durationSec, bNoShadow)
  local entry = ___MOD.TemporaryStatViewEntry()
  entry:add(nID, durationSec, bNoShadow)
  local newLayer = self.layerPool[1]
  if not newLayer then
    local uiGroupId = "c1ee38e4-b61d-4299-a1dd-d7a9b11f55c5"
    local uiGroup = ___MOD._EntityService:GetEntity(uiGroupId)
    local modelId = "model://d8041047-af9c-4fe5-986b-9fda11986cd3"
    local name = "tpStatIcon"
    newLayer = ___MOD._SpawnService:SpawnByModelId(modelId, name, ___MOD.Vector3.zero, uiGroup)
    newLayer:ConnectEvent(___MOD.UITouchUpEvent, function(event)
      if event.TouchId == -2 then
        self:tryCancelBuffLayer(event.Entity)
      end
    end)
    if ___MOD.Environment:IsMobilePlatform() then
      newLayer:ConnectEvent(___MOD.UITouchDownEvent, function(event)
        self:onMobileBuffTouchDown(event)
      end)
      newLayer:ConnectEvent(___MOD.UITouchUpEvent, function(event)
        self:onMobileBuffTouchUp(event)
      end)
    end
    newLayer:AddComponent(___MOD.TooltipComponent)
    newLayer.TooltipComponent.type = ___MOD._TooltipType.BUFF
  else
    ___MOD.table.remove(self.layerPool, 1)
  end
  if ___MOD.isvalid(newLayer) and newLayer.UITransformComponent ~= nil then
    ___MOD._UILogic:SetSiblingIndex(newLayer.UITransformComponent, 0)
  end
  if newLayer.TooltipComponent == nil then
    newLayer:AddComponent(___MOD.TooltipComponent)
  end
  newLayer.TooltipComponent.type = ___MOD._TooltipType.BUFF
  newLayer.TooltipComponent.id = nID
  newLayer.TooltipComponent.worldMap_title = ""
  newLayer.TooltipComponent.worldMap_desc = ""
  newLayer.TooltipComponent.worldMap_iconRUID = ""
  local iconRUID, iconSize
  if nID < 0 then
    local item = ___MOD._ItemManager:getItemById(-nID)
    iconRUID = item.iconRaw
    iconSize = item.iconRawSize
  else
    local skill = ___MOD._SkillManager:getSkill(nID)
    iconRUID = skill.icon
    iconSize = ___MOD.FastVector2(64, 64)
  end
  local icon = newLayer and newLayer:GetChildByName("icon") or nil
  if icon then
    icon.UITransformComponent.RectSize = iconSize
    icon.SpriteGUIRendererComponent.ImageRUID = iconRUID
  end
  local gauge = newLayer and newLayer:GetChildByName("gauge") or nil
  if gauge then
    gauge:SetEnable(true)
    gauge:SetVisible(true)
    gauge.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get("UI.UIWindow.Skill.CoolTime.15")
  end
  newLayer.CanvasGroupComponent.GroupAlpha = 1
  entry.layer = newLayer
  entry.layerShadow = gauge
  newLayer:SetEnable(true)
  ___MOD.table.insert(self.list, entry)
  self.count = self.count + 1
  self:setLeft(entry, entry.tLeft)
  self.nextLayoutDirty = true
  return entry
end

function PlayerTemporaryStatView.adjustPosition(self)
  local count = self.count
  if count <= 0 then
    return
  end
  local vt = ___MOD.FastVector2(0, 0)
  for i = 1, count do
    local e = self.list[i]
    if e then
      local layer = e.layer
      if layer then
        vt[1] = -5 + -((i - 1) % 20 * 64)
        vt[2] = -120 + -(___MOD.math.floor((i - 1) / 20) * 80)
        layer.UITransformComponent.anchoredPosition = vt
      end
    end
  end
end

function PlayerTemporaryStatView.createGuildPassiveLayer(self)
  local newLayer = self.layerPool[1]
  if not newLayer then
    local uiGroupId = "c1ee38e4-b61d-4299-a1dd-d7a9b11f55c5"
    local uiGroup = ___MOD._EntityService:GetEntity(uiGroupId)
    local modelId = "model://d8041047-af9c-4fe5-986b-9fda11986cd3"
    newLayer = ___MOD._SpawnService:SpawnByModelId(modelId, "guildPassiveBuffIcon", ___MOD.Vector3.zero, uiGroup)
    newLayer:ConnectEvent(___MOD.UITouchUpEvent, function(event)
      if event.TouchId == -2 then
        return
      end
    end)
    newLayer:AddComponent(___MOD.TooltipComponent)
  else
    ___MOD.table.remove(self.layerPool, 1)
  end
  if ___MOD.isvalid(newLayer) and newLayer.UITransformComponent ~= nil then
    ___MOD._UILogic:SetSiblingIndex(newLayer.UITransformComponent, 0)
  end
  if newLayer.TooltipComponent == nil then
    newLayer:AddComponent(___MOD.TooltipComponent)
  end
  return newLayer
end

function PlayerTemporaryStatView.findGuildBuffEntryIndex(self, buffId)
  for i = 1, self.count do
    local entry = self.list[i]
    if entry ~= nil and entry.nID == buffId then
      return i
    end
  end
  return 0
end

function PlayerTemporaryStatView.findID(self, layer)
  for _, e in ___MOD.pairs(self.list) do
    if e.layer == layer then
      return e.nID
    end
  end
  return -1
end

function PlayerTemporaryStatView.getGuildBuffEntry(self, buffId)
  local index = self:findGuildBuffEntryIndex(buffId)
  if index <= 0 then
    return nil
  end
  return self.list[index]
end

function PlayerTemporaryStatView.getGuildPassiveEntry(self)
  for i = 1, self.count do
    local entry = self.list[i]
    if entry ~= nil and entry.nID == self.GUILD_PASSIVE_BUFF_ID then
      return entry
    end
  end
  return nil
end

function PlayerTemporaryStatView.hideAll(self, currentTimeSec, durationSec)
  for i = 1, self.count do
    local e = self.list[i]
    if e then
      e.tHideTime = currentTimeSec + (durationSec or 0)
      self:hideEntry(e)
    end
  end
end

function PlayerTemporaryStatView.hideEntry(self, e)
  local layer = e.layer
  if layer then
    layer.CanvasGroupComponent.GroupAlpha = 0
  end
end

function PlayerTemporaryStatView.isGuildManagedBuffId(self, nID)
  return nID == self.GUILD_PASSIVE_BUFF_ID or nID == self.GUILD_ACTIVE_EXP_BUFF_ID or nID == self.GUILD_ACTIVE_BOSS_BUFF_ID
end

function PlayerTemporaryStatView.onMobileBuffTouchDown(self, event)
  if not ___MOD.Environment:IsMobilePlatform() or event.TouchId <= 0 and event.TouchId ~= -1 then
    return
  end
  self._T.mobileBuffPressLayer = event.Entity
  self._T.mobileBuffPressTouchId = event.TouchId
  self._T.mobileBuffPressStartTime = ___MOD._UtilLogic.ElapsedSeconds
end

function PlayerTemporaryStatView.onMobileBuffTouchUp(self, event)
  if not ___MOD.Environment:IsMobilePlatform() or event.TouchId <= 0 and event.TouchId ~= -1 then
    return
  end
  local layer = event.Entity
  local pressStartTime
  if self._T.mobileBuffPressLayer == layer and self._T.mobileBuffPressTouchId == event.TouchId then
    pressStartTime = ___MOD.tonumber(self._T.mobileBuffPressStartTime)
  end
  self._T.mobileBuffPressLayer = nil
  self._T.mobileBuffPressTouchId = nil
  self._T.mobileBuffPressStartTime = nil
  if pressStartTime == nil or not ___MOD.isvalid(layer) then
    return
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  local pressDuration = now - pressStartTime
  if pressDuration < 0 or 0.45 <= pressDuration then
    self._T.mobileBuffLastTapLayer = nil
    self._T.mobileBuffLastTapId = nil
    self._T.mobileBuffLastTapTime = nil
    return
  end
  local id = self:findID(layer)
  local lastTapTime = ___MOD.tonumber(self._T.mobileBuffLastTapTime) or 0
  local elapsed = now - lastTapTime
  if self._T.mobileBuffLastTapLayer == layer and self._T.mobileBuffLastTapId == id and 0 <= elapsed and elapsed <= 0.3 then
    self._T.mobileBuffLastTapLayer = nil
    self._T.mobileBuffLastTapId = nil
    self._T.mobileBuffLastTapTime = nil
    self:tryCancelBuffLayer(layer)
    return
  end
  self._T.mobileBuffLastTapLayer = layer
  self._T.mobileBuffLastTapId = id
  self._T.mobileBuffLastTapTime = now
end

function PlayerTemporaryStatView.removeAt(self, i)
  local e = self.list[i]
  if not e then
    return
  end
  local layer = e.layer
  if layer then
    if self:isGuildManagedBuffId(e.nID) then
      layer:Destroy()
    else
      layer:SetEnable(false)
      ___MOD.table.insert(self.layerPool, layer)
    end
  end
  local tween = e.tween
  if tween then
    tween:Destroy()
  end
  ___MOD.table.remove(self.list, i)
  self.count = self.count - 1
  self.nextLayoutDirty = true
end

function PlayerTemporaryStatView.removeBySkillID(self, skillID)
  for i = self.count, 1, -1 do
    local e = self.list[i]
    if e and e.nID == skillID then
      self:removeAt(i)
      break
    end
  end
end

function PlayerTemporaryStatView.removeGuildActiveBuffIcons(self)
  self:removeBySkillID(self.GUILD_ACTIVE_EXP_BUFF_ID)
  self:removeBySkillID(self.GUILD_ACTIVE_BOSS_BUFF_ID)
end

function PlayerTemporaryStatView.removeGuildPassiveIcon(self)
  for i = self.count, 1, -1 do
    local entry = self.list[i]
    if entry ~= nil and entry.nID == self.GUILD_PASSIVE_BUFF_ID then
      self:removeAt(i)
      return
    end
  end
end

function PlayerTemporaryStatView.reset(self)
  for i = self.count, 1, -1 do
    local e = self.list[i]
    if e then
      self:removeAt(i)
    end
  end
  for i = 1, #self.layerPool do
    local layer = self.layerPool[i]
    layer:Destroy()
  end
  self.layerPool = {}
  self.count = 0
  self.nextLayoutDirty = false
end

function PlayerTemporaryStatView.setGuildActiveBuffIcon(self, buffId, remainSec, tooltipTitle, tooltipDesc)
  local safeRemainSec = ___MOD.math.max(0, ___MOD.tonumber(remainSec) or 0)
  if safeRemainSec <= 0 then
    self:removeBySkillID(buffId)
    return
  end
  local durationSec = safeRemainSec
  if buffId == self.GUILD_ACTIVE_EXP_BUFF_ID then
    durationSec = self.GUILD_ACTIVE_EXP_DURATION_SEC
  elseif buffId == self.GUILD_ACTIVE_BOSS_BUFF_ID then
    durationSec = self.GUILD_ACTIVE_BOSS_DURATION_SEC
  end
  local entry = self:getGuildBuffEntry(buffId)
  if entry == nil then
    entry = ___MOD.TemporaryStatViewEntry()
    entry:add(buffId, durationSec, false)
    entry.tLeft = safeRemainSec
    entry.layer = self:createGuildPassiveLayer()
    entry.layerShadow = entry.layer:GetChildByName("gauge")
    local insertIndex = 1
    local passiveIndex = self:findGuildBuffEntryIndex(self.GUILD_PASSIVE_BUFF_ID)
    if 0 < passiveIndex then
      insertIndex = passiveIndex + 1
    end
    ___MOD.table.insert(self.list, insertIndex, entry)
    self.count = self.count + 1
  else
    entry.tLeft = safeRemainSec
    entry.tLeftUnit = durationSec / 16
    entry.bNoShadow = false
  end
  local layer = entry.layer
  if not ___MOD.isvalid(layer) then
    entry.layer = self:createGuildPassiveLayer()
    layer = entry.layer
    entry.layerShadow = layer:GetChildByName("gauge")
  end
  local icon = layer:GetChildByName("icon")
  if ___MOD.isvalid(icon) then
    icon.UITransformComponent.RectSize = ___MOD.FastVector2(64, 64)
    icon.SpriteGUIRendererComponent.ImageRUID = self.GUILD_ACTIVE_BUFF_ICON_RUID
  end
  local gauge = layer:GetChildByName("gauge")
  if ___MOD.isvalid(gauge) then
    entry.layerShadow = gauge
    gauge:SetEnable(true)
    gauge:SetVisible(true)
  end
  layer.TooltipComponent.type = ___MOD._TooltipType.BUFF
  layer.TooltipComponent.id = 0
  layer.TooltipComponent.worldMap_title = ___MOD.tostring(tooltipTitle or "")
  layer.TooltipComponent.worldMap_desc = ___MOD.tostring(tooltipDesc or "")
  layer.TooltipComponent.worldMap_iconRUID = self.GUILD_ACTIVE_BUFF_ICON_RUID
  layer.TooltipComponent.fixedWidth = 360
  layer.CanvasGroupComponent.GroupAlpha = 1
  layer:SetEnable(true)
  self:setLeft(entry, safeRemainSec)
  self.nextLayoutDirty = true
end

function PlayerTemporaryStatView.setGuildPassiveIcon(self, tooltipDesc)
  if ___MOD._UtilLogic:IsNilorEmptyString(tooltipDesc) then
    self:removeGuildPassiveIcon()
    return
  end
  local entry = self:getGuildPassiveEntry()
  if entry == nil then
    entry = ___MOD.TemporaryStatViewEntry()
    entry.nID = self.GUILD_PASSIVE_BUFF_ID
    entry.tLeft = 0
    entry.tLeftUnit = 0
    entry.bNoShadow = true
    entry.nIndexShadow = 0
    entry.tHideTime = 0
    entry.layer = self:createGuildPassiveLayer()
    entry.layerShadow = entry.layer:GetChildByName("gauge")
    ___MOD.table.insert(self.list, 1, entry)
    self.count = self.count + 1
  end
  local layer = entry.layer
  if not ___MOD.isvalid(layer) then
    entry.layer = self:createGuildPassiveLayer()
    layer = entry.layer
  end
  local icon = layer:GetChildByName("icon")
  if ___MOD.isvalid(icon) then
    icon.UITransformComponent.RectSize = ___MOD.FastVector2(64, 64)
    icon.SpriteGUIRendererComponent.ImageRUID = self.GUILD_PASSIVE_BUFF_ICON_RUID
  end
  local gauge = layer:GetChildByName("gauge")
  if ___MOD.isvalid(gauge) then
    gauge:SetVisible(false)
    gauge:SetEnable(false)
  end
  if ___MOD.isvalid(layer.SlotNumberComponent) then
    layer.SlotNumberComponent:updateNumber(-1, true)
  end
  layer.TooltipComponent.type = ___MOD._TooltipType.BUFF
  layer.TooltipComponent.id = 0
  layer.TooltipComponent.worldMap_title = "길드 스킬 패시브"
  layer.TooltipComponent.worldMap_desc = tooltipDesc
  layer.TooltipComponent.worldMap_iconRUID = self.GUILD_PASSIVE_BUFF_ICON_RUID
  layer.TooltipComponent.fixedWidth = 520
  layer.CanvasGroupComponent.GroupAlpha = 1
  layer:SetEnable(true)
  self.nextLayoutDirty = true
end

function PlayerTemporaryStatView.setLeft(self, e, newLeftSec)
  local prev = e.tLeft
  e.tLeft = newLeftSec
  self:updateShadowIndex(e)
  self:updateRemain(e)
  if e.nID == 5221006 or e.nID == 35001002 then
    ___MOD.threshold = e.tLeftUnit
  end
  if 3 < prev and e.tLeft <= 3 then
    e:playTween()
  end
end

function PlayerTemporaryStatView.showEntry(self, e)
  local layer = e.layer
  if layer then
    layer.CanvasGroupComponent.GroupAlpha = 1
  end
end

function PlayerTemporaryStatView.tryCancelBuffLayer(self, layer)
  local ID = self:findID(layer)
  if self:isGuildManagedBuffId(ID) then
    return
  end
  if ID < 0 then
    local item = ___MOD._ItemManager:getItemById(-ID)
    if item ~= nil and item.noCancelMouse then
      if item.morph ~= nil and 0 < item.morph then
        ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신을 취소할 수 없습니다.")
      end
      return
    end
    ___MOD._UserService.LocalPlayer.PlayerTemporaryStatComponent:resetTemporaryStat(ID)
  elseif 1000 <= ID and ID ~= ___MOD._SkillBook.Dragon_Roar_131_1311006 and ID ~= ___MOD._SkillBook.Energy_Charge_511_5110001 and ID ~= ___MOD._SkillBook.Energy_Charge_1510_15100004 then
    ___MOD._UserService.LocalPlayer.PlayerTemporaryStatComponent:resetTemporaryStat(ID)
  end
end

function PlayerTemporaryStatView.update(self, currentTimeSec)
  local lastUpdate = self._T.lastUpdate or currentTimeSec
  local delta = 0 < lastUpdate and currentTimeSec - lastUpdate or 0
  for i = self.count, 1, -1 do
    local e = self.list[i]
    if e ~= nil then
      if 0 < e.tHideTime then
        if currentTimeSec < e.tHideTime then
          self:hideEntry(e)
        else
          self:showEntry(e)
          e.tHideTime = 0
        end
      end
      if e.nID == self.GUILD_PASSIVE_BUFF_ID then
        if ___MOD.isvalid(e.layer) and ___MOD.isvalid(e.layer.SlotNumberComponent) then
          e.layer.SlotNumberComponent:updateNumber(-1, true)
        end
      elseif e.nID ~= 5221006 and e.nID ~= 35001002 then
        self:setLeft(e, e.tLeft - delta)
      end
      if e.nID ~= self.GUILD_PASSIVE_BUFF_ID and 0 >= e.tLeft then
        self:removeAt(i)
      end
    end
  end
  if self.nextLayoutDirty then
    self.nextLayoutDirty = false
    self:adjustPosition()
  end
  self._T.lastUpdate = currentTimeSec
end

function PlayerTemporaryStatView.updateRemain(self, e)
  local layer = e.layer
  layer.SlotNumberComponent:updateNumber(___MOD.math.ceil(e.tLeft), true)
end

function PlayerTemporaryStatView.updateShadowIndex(self, e)
  if e.bNoShadow then
    return
  end
  local unit = e.tLeftUnit
  if not unit or unit <= 0 then
    unit = 1.0
    e.tLeftUnit = 1.0
  end
  local idx = ___MOD.math.floor(___MOD.math.clamp(e.tLeft / unit, 0, 15))
  if e.nIndexShadow == idx then
    return
  end
  e.nIndexShadow = idx
  local layerShadow = e.layerShadow
  layerShadow.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get(___MOD.string.format("UI.UIWindow.Skill.CoolTime.%d", idx))
end
