

function MobileActionSlotLogic.alignCooldownNumberToIconCenter(self, slotKey, slotEntity, remainSec)
  if not ___MOD.isvalid(slotEntity) or slotEntity.UITransformComponent == nil or remainSec < 0 then
    return
  end
  local displayNumber = remainSec
  if 60 <= remainSec then
    displayNumber = ___MOD.math.floor(remainSec / 60)
  end
  local countStr = ___MOD.tostring(displayNumber)
  local digitCount = ___MOD.math.min(#countStr, 4)
  if digitCount <= 0 then
    return
  end
  local scale = self:getCooldownNumberScale(slotKey)
  local cellWidth = 16 * scale
  local totalWidth = cellWidth * digitCount
  local digitHeight = 22 * scale
  local slotSize = slotEntity.UITransformComponent.RectSize
  local x = (slotSize.x - totalWidth) * 0.5
  local y = (slotSize.y - digitHeight) * 0.5
  for i = 1, digitCount do
    local digit = slotEntity:GetChildByName("count" .. ___MOD.tostring(i))
    if ___MOD.isvalid(digit) and digit.UITransformComponent ~= nil then
      local digitNum = ___MOD.tonumber(countStr:sub(i, i)) or 0
      local width = (digitNum == 1 and 10 or 16) * scale
      digit.UITransformComponent.RectSize = ___MOD.FastVector2(width, digitHeight)
      digit.UITransformComponent.anchoredPosition = ___MOD.FastVector2(x + (cellWidth - width) * 0.5, y)
      x = x + cellWidth
    end
  end
end

function MobileActionSlotLogic.ApplyMobileActionSlotLayout(self, openX, openY, hiddenOffsetX)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  self:prepareMobileActionSlotsClient()
  local root = self._T.mobileActionSlotRoot
  if not ___MOD.isvalid(root) or root.UITransformComponent == nil then
    return
  end
  local offsetX = ___MOD.tonumber(hiddenOffsetX) or ___MOD.tonumber(self.mobileActionSlotMenuSlideOffsetX) or 800
  self._T.mobileActionSlotMenuOpenX = openX
  self._T.mobileActionSlotMenuOpenY = openY
  self._T.mobileActionSlotMenuSlideOffsetX = offsetX
  local transform = root.UITransformComponent
  if self._T.mobileActionSlotMenuHidden == true then
    transform.anchoredPosition = ___MOD.FastVector2(openX + offsetX, openY)
  else
    transform.anchoredPosition = ___MOD.FastVector2(openX, openY)
  end
end

function MobileActionSlotLogic.applyMobileActionSlotOpacity(self)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  local alpha = self:normalizeMobileActionSlotOpacityPercent(self._T.mobileActionSlotOpacityPercent) / 100
  local root = self._T.mobileActionSlotRoot
  if not ___MOD.isvalid(root) then
    return
  end
  local canvas = root.CanvasGroupComponent
  if canvas == nil then
    root:AddComponent(___MOD.CanvasGroupComponent)
    canvas = root.CanvasGroupComponent
    if canvas ~= nil then
      canvas.Interactable = true
      canvas.BlocksRaycasts = true
    end
  end
  if canvas ~= nil then
    canvas.GroupAlpha = alpha
  end
end

function MobileActionSlotLogic.applyMobileActionSlotSettingBoxState(self)
  local settingBox = self._T.mobileActionSlotSettingBox
  if not ___MOD.isvalid(settingBox) then
    return
  end
  local shouldOpen = self._T.mobileActionSlotSettingBoxOpen == true and self:isMobileActionSlotUIActive()
  settingBox:SetEnable(shouldOpen)
  settingBox:SetVisible(true)
end

function MobileActionSlotLogic.applySlotVisual(self, slotKey)
  local iconEntity = self:ensureIconEntity(slotKey)
  if not ___MOD.isvalid(iconEntity) then
    return
  end
  local slotEntity = self._T.mobileActionSlotEntities and self._T.mobileActionSlotEntities[slotKey] or nil
  local entry = self.localSlotConfig and self.localSlotConfig[slotKey] or nil
  if entry == nil then
    iconEntity:SetEnable(false)
    iconEntity:SetVisible(false)
    if iconEntity.SpriteGUIRendererComponent ~= nil then
      iconEntity.SpriteGUIRendererComponent.ImageRUID = ""
    end
    if iconEntity.TooltipComponent ~= nil then
      iconEntity.TooltipComponent.type = 0
      iconEntity.TooltipComponent.id = 0
    end
    self:clearItemCountVisual(slotKey)
    self:clearCooldownVisual(slotKey)
    return
  end
  local slotType = ___MOD.tonumber(entry.type or 0) or 0
  local id = ___MOD.tonumber(entry.id or 0) or 0
  local ruid = ""
  local iconSize = ___MOD.FastVector2(self:getSlotIconMaxSize(slotKey), self:getSlotIconMaxSize(slotKey))
  local tooltipType = 0
  if slotType == ___MOD._KeyConfigType.ACTION then
    ruid = ___MOD.__RUIDManager:get(___MOD.string.format("UI.UIWindow.KeyConfig.icon.%d", id))
    self:clearItemCountVisual(slotKey)
    self:clearCooldownVisual(slotKey)
  elseif slotType == ___MOD._KeyConfigType.ITEM then
    local item = ___MOD._ItemManager:getItemById(id)
    if item ~= nil then
      local hasRawIcon = item.iconRaw ~= nil and item.iconRaw ~= ""
      ruid = hasRawIcon and item.iconRaw or item.icon
      iconSize = hasRawIcon and item.iconRawSize or item.iconSize
      if iconSize == nil or 0 >= iconSize.x and 0 >= iconSize.y then
        iconSize = ___MOD.FastVector2(64, 64)
      end
      iconSize = self:getAspectFitSlotIconSize(slotKey, iconSize)
      tooltipType = ___MOD._TooltipType.INVENTORY
    end
    self:clearCooldownVisual(slotKey)
  elseif slotType == ___MOD._KeyConfigType.SKILL then
    local skill = ___MOD._SkillManager:getSkill(id)
    if skill ~= nil then
      ruid = skill.icon
      tooltipType = ___MOD._TooltipType.SKILL
    end
    self:clearItemCountVisual(slotKey)
    self:ensureCooldownGauge(slotKey)
    if ___MOD.isvalid(slotEntity) and not ___MOD.isvalid(slotEntity.SlotNumberComponent) then
      slotEntity:AddComponent(___MOD.SlotNumberComponent)
    end
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    iconEntity:SetEnable(false)
    self:clearItemCountVisual(slotKey)
    self:clearCooldownVisual(slotKey)
    return
  end
  iconEntity:SetEnable(false)
  iconEntity.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
  iconEntity.SpriteGUIRendererComponent.ImageRUID = ruid
  iconEntity.UITransformComponent.RectSize = iconSize
  if not iconEntity.TooltipComponent then
    iconEntity:AddComponent(___MOD.TooltipComponent)
  end
  iconEntity.TooltipComponent.type = tooltipType
  iconEntity.TooltipComponent.id = id
  iconEntity:SetVisible(true)
  iconEntity:SetEnable(true)
  if slotType == ___MOD._KeyConfigType.ITEM and ___MOD.isvalid(slotEntity) then
    local player = ___MOD._UserService.LocalPlayer
    local quantity = 0
    if ___MOD.isvalid(player) and player.CInventoryComponent ~= nil then
      quantity = player.CInventoryComponent:getItemCount(id)
    end
    local slotNumber = self:ensureSlotNumberComponent(slotEntity)
    if ___MOD.isvalid(slotNumber) then
      slotNumber:updateNumber(quantity, false)
    end
  end
end

function MobileActionSlotLogic.arrangeMobileActionSlotLayerForUtilDlg(self)
  if not ___MOD.isvalid(self._T.mobileActionSlotRoot) then
    self._T.mobileActionSlotRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlots")
  end
  local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  local tempGroup = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
  if not (___MOD.isvalid(uiGroup) and ___MOD.isvalid(tempGroup)) or not ___MOD.isvalid(self._T.mobileActionSlotRoot) then
    return
  end
  local mobileChat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  local mobileMenu = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileMenu")
  local mobileActionSlotSetting = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting")
  local mobileQuickCloseBtn = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileQuickCloseBtn")
  self._T.mobileActionSlotRoot:AttachTo(tempGroup)
  self._T.mobileActionSlotRoot:AttachTo(uiGroup)
  if ___MOD.isvalid(mobileActionSlotSetting) then
    mobileActionSlotSetting:AttachTo(tempGroup)
    mobileActionSlotSetting:AttachTo(uiGroup)
  end
  if ___MOD.isvalid(mobileQuickCloseBtn) then
    mobileQuickCloseBtn:AttachTo(tempGroup)
    mobileQuickCloseBtn:AttachTo(uiGroup)
  end
  if ___MOD.isvalid(mobileChat) then
    mobileChat:AttachTo(tempGroup)
    mobileChat:AttachTo(uiGroup)
  end
  if ___MOD.isvalid(mobileMenu) then
    mobileMenu:AttachTo(tempGroup)
    mobileMenu:AttachTo(uiGroup)
  end
end

function MobileActionSlotLogic.canExecuteMobileJumpAction(self, player)
  if not ___MOD.isvalid(player) or player.RigidbodyComponent == nil or player.PlayerActionComponent == nil or player.ExtendPlayerControllerComponent == nil then
    return false
  end
  local controller = player.ExtendPlayerControllerComponent
  if controller.Enable ~= true or controller.IsUpdateBlocked or player.PlayerActionComponent:hasMovementLockSource() then
    return false
  end
  return true
end

function MobileActionSlotLogic.clearAllVisibleItemCountVisuals(self)
  if self.localSlotConfig == nil then
    return
  end
  local slotNames = self:getSlotNames()
  for _, slotKey in ___MOD.ipairs(slotNames) do
    local entry = self.localSlotConfig[slotKey]
    local entryType = ___MOD.tonumber(entry and entry.type or 0) or 0
    if entryType == ___MOD._KeyConfigType.ITEM then
      self:clearItemCountVisual(slotKey)
    end
  end
end

function MobileActionSlotLogic.clearCooldownVisual(self, slotKey)
  local slotEntity = self._T.mobileActionSlotEntities and self._T.mobileActionSlotEntities[slotKey] or nil
  if not ___MOD.isvalid(slotEntity) then
    return
  end
  local gauge = slotEntity:GetChildByName("gauge")
  if ___MOD.isvalid(gauge) then
    gauge:SetEnable(false)
    gauge:SetVisible(false)
  end
  if ___MOD.isvalid(slotEntity.SlotNumberComponent) then
    slotEntity.SlotNumberComponent:updateNumber(-1, true)
  end
  local cache = self._T.mobileActionSlotCooldownTotalCache
  if cache ~= nil then
    cache[slotKey] = nil
  end
end

function MobileActionSlotLogic.clearItemCountVisual(self, slotKey)
  local slotEntity = self._T.mobileActionSlotEntities and self._T.mobileActionSlotEntities[slotKey] or nil
  if not ___MOD.isvalid(slotEntity) then
    return
  end
  self:removeSlotNumberComponent(slotEntity)
end

function MobileActionSlotLogic.clearVisibleItemCountVisual(self, itemId)
  if itemId <= 0 or self.localSlotConfig == nil then
    return
  end
  local slotNames = self:getSlotNames()
  for _, slotKey in ___MOD.ipairs(slotNames) do
    local entry = self.localSlotConfig[slotKey]
    local entryType = ___MOD.tonumber(entry and entry.type or 0) or 0
    local entryId = ___MOD.tonumber(entry and entry.id or 0) or 0
    if entryType == ___MOD._KeyConfigType.ITEM and entryId == itemId then
      self:clearItemCountVisual(slotKey)
    end
  end
end

function MobileActionSlotLogic.createDefaultMobileActionSlotConfig(self)

end

function MobileActionSlotLogic.decodeSlotConfig(self, dataTable)
  local result = {}
  result[1] = {}
  result[2] = {}
  if dataTable == nil then
    return result
  end
  local keySets = dataTable.keySets
  if keySets ~= nil then
    for keySetIndex = 1, 2 do
      local source = keySets[keySetIndex] or keySets[___MOD.tostring(keySetIndex)]
      if source ~= nil then
        for key, entry in ___MOD.pairs(source) do
          local slotKey = ___MOD.tostring(entry and entry.slot or key or "")
          local slotType = ___MOD.tonumber(entry and entry.type or 0) or 0
          local id = ___MOD.tonumber(entry and entry.id or 0) or 0
          if self:isMobileActionSlotKey(slotKey) and 0 < slotType and 0 < id then
            result[keySetIndex][slotKey] = {
              slot = slotKey,
              type = slotType,
              id = id
            }
          end
        end
      end
    end
    return result
  end
  for key, entry in ___MOD.pairs(dataTable) do
    local slotKey = ___MOD.tostring(entry and entry.slot or key or "")
    local slotType = ___MOD.tonumber(entry and entry.type or 0) or 0
    local id = ___MOD.tonumber(entry and entry.id or 0) or 0
    if self:isMobileActionSlotKey(slotKey) and 0 < slotType and 0 < id then
      result[1][slotKey] = {
        slot = slotKey,
        type = slotType,
        id = id
      }
    end
  end
  return result
end

function MobileActionSlotLogic.ensureCooldownGauge(self, slotKey)
  local slotEntity = self._T.mobileActionSlotEntities and self._T.mobileActionSlotEntities[slotKey] or nil
  if not ___MOD.isvalid(slotEntity) then
    return nil
  end
  local gauge = slotEntity:GetChildByName("gauge")
  if ___MOD.isvalid(gauge) then
    if gauge.SpriteGUIRendererComponent == nil then
      gauge:AddComponent(___MOD.SpriteGUIRendererComponent)
    end
    gauge.SpriteGUIRendererComponent.RaycastTarget = false
    gauge.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
    gauge:SetVisible(true)
    return gauge
  end
  local emptySprite = self:getEmptySpriteTemplate()
  if not ___MOD.isvalid(emptySprite) then
    return nil
  end
  gauge = ___MOD._SpawnService:SpawnByEntity(emptySprite, "gauge", ___MOD.FastVector3.zero:Clone(), slotEntity)
  if not ___MOD.isvalid(gauge) then
    return nil
  end
  if gauge.SpriteGUIRendererComponent == nil then
    gauge:AddComponent(___MOD.SpriteGUIRendererComponent)
  end
  gauge.SpriteGUIRendererComponent.RaycastTarget = false
  gauge.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
  gauge.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get("UI.UIWindow.Skill.CoolTime.0")
  gauge.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, 0)
  gauge.UITransformComponent.RectSize = ___MOD.FastVector2(self:getSlotIconMaxSize(slotKey), self:getSlotIconMaxSize(slotKey))
  gauge:SetVisible(true)
  gauge:SetEnable(false)
  return gauge
end

function MobileActionSlotLogic.ensureIconEntity(self, slotKey)
  local slotEntities = self._T.mobileActionSlotEntities
  local slotEntity = slotEntities and slotEntities[slotKey] or nil
  if not ___MOD.isvalid(slotEntity) then
    return nil
  end
  local iconEntity = slotEntity:GetChildByName("icon")
  if ___MOD.isvalid(iconEntity) then
    if iconEntity.SpriteGUIRendererComponent == nil then
      iconEntity:AddComponent(___MOD.SpriteGUIRendererComponent)
    end
    iconEntity.SpriteGUIRendererComponent.RaycastTarget = false
    iconEntity.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
    return iconEntity
  end
  local emptySprite = self:getEmptySpriteTemplate()
  if not ___MOD.isvalid(emptySprite) then
    return nil
  end
  iconEntity = ___MOD._SpawnService:SpawnByEntity(emptySprite, "icon", ___MOD.FastVector3.zero:Clone(), slotEntity)
  if not ___MOD.isvalid(iconEntity) then
    return nil
  end
  if iconEntity.SpriteGUIRendererComponent == nil then
    iconEntity:AddComponent(___MOD.SpriteGUIRendererComponent)
  end
  iconEntity.SpriteGUIRendererComponent.RaycastTarget = false
  iconEntity.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
  iconEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, 0)
  iconEntity.UITransformComponent.RectSize = ___MOD.FastVector2(64, 64)
  iconEntity:SetVisible(false)
  iconEntity:SetEnable(false)
  return iconEntity
end

function MobileActionSlotLogic.ensureKeySetConfig(self, keySetConfigs, keySet)
  local normalizedKeySet = self:normalizeKeySet(keySet)
  keySetConfigs[normalizedKeySet] = keySetConfigs[normalizedKeySet] or {}
  return keySetConfigs[normalizedKeySet]
end

function MobileActionSlotLogic.ensureSlotNumberComponent(self, targetEntity)
  if not ___MOD.isvalid(targetEntity) then
    return nil
  end
  if not ___MOD.isvalid(targetEntity.SlotNumberComponent) then
    targetEntity:AddComponent(___MOD.SlotNumberComponent)
  end
  return targetEntity.SlotNumberComponent
end

function MobileActionSlotLogic.executeMobileActionSlotHold(self, slotType, id)
  local player = ___MOD._UserService.LocalPlayer
  if slotType == ___MOD._KeyConfigType.ACTION and id == ___MOD._KeyConfigActionType.ATTACK then
    self:executeMobileAttackHoldAction(player)
  elseif slotType == ___MOD._KeyConfigType.ACTION and id == ___MOD._KeyConfigActionType.JUMP then
    self:executeMobileJumpHoldAction(player)
  else
    self:executeSlotEntry(slotType, id)
  end
end

function MobileActionSlotLogic.executeMobileActionSlotPress(self, slotType, id)
  local player = ___MOD._UserService.LocalPlayer
  if slotType == ___MOD._KeyConfigType.ACTION and id == ___MOD._KeyConfigActionType.ATTACK then
    self:executeMobileAttackPressAction(player)
  elseif slotType == ___MOD._KeyConfigType.ACTION and id == ___MOD._KeyConfigActionType.JUMP then
    self:executeMobileJumpPressAction(player)
  else
    self:executeSlotEntry(slotType, id)
  end
end

function MobileActionSlotLogic.executeMobileAttackHoldAction(self, player)
  if not ___MOD.isvalid(player) or ___MOD._PlayerKeyActionFunction == nil then
    return
  end
  ___MOD._PlayerKeyActionFunction:onAttack()
end

function MobileActionSlotLogic.executeMobileAttackPressAction(self, player)
  if not ___MOD.isvalid(player) then
    return
  end
  if ___MOD._PlayerKeyActionFunction == nil then
    return
  end
  ___MOD._PlayerKeyActionFunction._T.basicAttackPressed = true
  ___MOD._PlayerKeyActionFunction:onAttack()
end

function MobileActionSlotLogic.executeMobileJumpHoldAction(self, player)
  if not self:canExecuteMobileJumpAction(player) then
    return
  end
  local settings = player.PlayerSettingsComponent
  local activeSkillID = self:getMobileActiveKeydownSkillID(player)
  if 0 < activeSkillID and ___MOD._PlayerSkillLogic:isHurricaneSkillGroup(activeSkillID) then
    return
  end
  if settings ~= nil and (settings:isDeliveryActive(player) or settings:isItemEnchantActive(player) or settings:isItemProtectorActive(player)) then
    return
  end
  if ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.DownArrow) then
    player.ExtendPlayerControllerComponent:ActionDownJump()
  else
    player.ExtendPlayerControllerComponent:ActionJump()
  end
end

function MobileActionSlotLogic.executeMobileJumpPressAction(self, player)
  if not self:canExecuteMobileJumpAction(player) then
    return
  end
  local settings = player.PlayerSettingsComponent
  local activeSkillID = self:getMobileActiveKeydownSkillID(player)
  if 0 < activeSkillID and ___MOD._PlayerSkillLogic:isHurricaneSkillGroup(activeSkillID) then
    return
  end
  if settings ~= nil and (settings:isDeliveryActive(player) or settings:isItemEnchantActive(player) or settings:isItemProtectorActive(player)) then
    return
  end
  if ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.DownArrow) then
    player.ExtendPlayerControllerComponent:ActionDownJump()
  elseif player.ExtendPlayerControllerComponent.inSwimMap or player.RigidbodyComponent:IsOnGround() or player.PlayerActionComponent.isClimbing then
    player.ExtendPlayerControllerComponent:ActionJump()
  else
    ___MOD._PlayerSkillLogic:tryDoubleJump(player, false)
  end
end

function MobileActionSlotLogic.executeSlotEntry(self, slotType, id)
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) then
    return
  end
  local settings = player.PlayerSettingsComponent
  if slotType == ___MOD._KeyConfigType.ACTION and id == ___MOD._KeyConfigActionType.CHAT_NPC then
    ___MOD._PlayerKeyActionFunction:onMobileChatNPC()
    return
  end
  if settings ~= nil and settings:isShortcutInputBlocked(player) then
    return
  end
  if slotType == ___MOD._KeyConfigType.ITEM then
    local now = ___MOD._UtilLogic.ServerElapsedSeconds
    local lastItemSlotActionTime = ___MOD.tonumber(self._T.lastItemSlotActionTime) or 0
    if lastItemSlotActionTime == 0 or 0.25 <= now - lastItemSlotActionTime then
      self._T.lastItemSlotActionTime = now
      local slot = player.CInventoryComponent:getSlotByItemId(2, id)
      if slot ~= nil then
        ___MOD._UseItemManager:onUseItemClient(2, slot, false, "")
      end
    end
  elseif slotType == ___MOD._KeyConfigType.SKILL then
    if settings ~= nil and settings:isSkillAttackInputBlockedBySkill(player, id) then
      return
    end
    local level = player.SkillComponent:getSkillLevel(id)
    if 0 < level then
      ___MOD._PlayerSkillLogic:tryUseSkillClient(player, id, level, false, false, false)
    end
  elseif slotType == ___MOD._KeyConfigType.ACTION then
    if id == ___MOD._KeyConfigActionType.JUMP then
      self:executeMobileJumpPressAction(player)
      return
    elseif id == ___MOD._KeyConfigActionType.ATTACK then
      self:executeMobileAttackPressAction(player)
      return
    end
    local actionFunc
    if settings ~= nil then
      actionFunc = settings.keyDownAction[id] or settings.keyHoldAction[id]
    end
    if actionFunc ~= nil then
      actionFunc()
    end
  end
end

function MobileActionSlotLogic.finishMobileActionSlotOpacityInput(self)
  self._T.mobileActionSlotOpacityKeyPressed = false
  self._T.mobileActionSlotOpacityTouchId = nil
  if self._T.mobileActionSlotOpacityDirty ~= true then
    return
  end
  self._T.mobileActionSlotOpacityDirty = false
  self:setMobileActionSlotOpacityToServer(self:normalizeMobileActionSlotOpacityPercent(self._T.mobileActionSlotOpacityPercent))
end

function MobileActionSlotLogic.getAspectFitSlotIconSize(self, slotKey, sourceSize)
  local maxSize = self:getSlotIconMaxSize(slotKey)
  if sourceSize == nil or sourceSize.x <= 0 or 0 >= sourceSize.y then
    return ___MOD.FastVector2(maxSize, maxSize)
  end
  local scale = ___MOD.math.min(maxSize / sourceSize.x, maxSize / sourceSize.y)
  return ___MOD.FastVector2(___MOD.math.floor(sourceSize.x * scale + 0.5), ___MOD.math.floor(sourceSize.y * scale + 0.5))
end

function MobileActionSlotLogic.getCooldownNumberScale(self, slotKey)
  if ___MOD.string.find(slotKey, "ActionSlot_B_") ~= nil then
    return 1.5
  end
  if ___MOD.string.find(slotKey, "ActionSlot_M_") ~= nil then
    return 1.25
  end
  return 1
end

function MobileActionSlotLogic.getDraggedSkillId(self, clickedEntity)
  if ___MOD.isvalid(clickedEntity) and clickedEntity.SkillUISlotItemComponent ~= nil then
    return ___MOD.tonumber(clickedEntity.SkillUISlotItemComponent.skillId) or 0
  end
  if ___MOD.isvalid(clickedEntity) and ___MOD.isvalid(clickedEntity.Parent) and clickedEntity.Parent.SkillUISlotItemComponent ~= nil then
    return ___MOD.tonumber(clickedEntity.Parent.SkillUISlotItemComponent.skillId) or 0
  end
  return ___MOD.tonumber(___MOD._UIElementLogic._T.dragSkillId) or 0
end

function MobileActionSlotLogic.getDraggedUIElementType(self, clickedEntity)
  if ___MOD.isvalid(clickedEntity) and clickedEntity.UIElementClickInteractionComponent ~= nil then
    return ___MOD.tonumber(clickedEntity.UIElementClickInteractionComponent.type) or 0
  end
  if ___MOD.isvalid(clickedEntity) and ___MOD.isvalid(clickedEntity.Parent) and clickedEntity.Parent.UIElementClickInteractionComponent ~= nil then
    return ___MOD.tonumber(clickedEntity.Parent.UIElementClickInteractionComponent.type) or 0
  end
  return 0
end

function MobileActionSlotLogic.getEmptySpriteTemplate(self)
  local emptySprite = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")
  if ___MOD.isvalid(emptySprite) then
    return emptySprite
  end
  emptySprite = ___MOD._EntityService:GetEntity("68e153c4-5ecf-40f8-b871-b96e34855552")
  if ___MOD.isvalid(emptySprite) then
    return emptySprite
  end
  emptySprite = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup/EmptySprite")
  if ___MOD.isvalid(emptySprite) then
    return emptySprite
  end
  return nil
end

function MobileActionSlotLogic.getMobileActionSlotOpacityHalfRange(self)
  local bar = self._T.mobileActionSlotOpacityBar
  local key = self._T.mobileActionSlotOpacityKey
  if not (___MOD.isvalid(bar) and ___MOD.isvalid(key)) or bar.UITransformComponent == nil or key.UITransformComponent == nil then
    return -1
  end
  return ___MOD.math.max(0, (bar.UITransformComponent.RectSize.x - key.UITransformComponent.RectSize.x) / 2)
end

function MobileActionSlotLogic.getMobileActiveKeydownSkillID(self, player)
  if not ___MOD.isvalid(player) then
    return 0
  end
  if player.KeyDownComponent ~= nil and player.KeyDownComponent.onKeyDown then
    return ___MOD.tonumber(player.KeyDownComponent.skillID) or 0
  end
  local hiddenSkillID = ___MOD._PlayerSkillLogic:getActiveHiddenKeydownSkillID(player)
  if 0 < hiddenSkillID then
    return hiddenSkillID
  end
  local hurricaneState = ___MOD._PlayerSkillLogic:getHurricaneState(player)
  if hurricaneState ~= nil and (hurricaneState.inputLock == true or hurricaneState.prepareToken ~= nil or hurricaneState.loopStarted == true) then
    return ___MOD.tonumber(hurricaneState.prepareSkillID) or 0
  end
  local piercingState = ___MOD._PlayerSkillLogic:getPiercingState(player)
  if piercingState ~= nil and (piercingState.inputLock == true or piercingState.prepareToken ~= nil or piercingState.loopStarted == true) then
    return ___MOD.tonumber(piercingState.prepareSkillID) or 0
  end
  return 0
end

function MobileActionSlotLogic.getSkillCooldownSec(self, skillId)
  local lookupId = self:resolveCooldownLookupId(skillId)
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) or player.SkillComponent == nil then
    return 0
  end
  local level = player.SkillComponent:getSkillLevel(lookupId)
  if level <= 0 then
    return 0
  end
  local levelData = ___MOD._SkillManager:getSkillLevelData(lookupId, level)
  if levelData == nil then
    return 0
  end
  if lookupId == ___MOD._SkillBook.Battleship_522_5221006 then
    return 0
  end
  local cooltime = ___MOD.tonumber(levelData.cooltime) or 0
  if 1000 <= cooltime then
    cooltime = cooltime / 1000
  end
  return cooltime
end

function MobileActionSlotLogic.getSlotIconMaxSize(self, slotKey)
  if ___MOD.string.find(slotKey, "ActionSlot_B_") ~= nil then
    return 96
  end
  if ___MOD.string.find(slotKey, "ActionSlot_M_") ~= nil then
    return 80
  end
  if ___MOD.string.find(slotKey, "ActionSlot_S_") ~= nil then
    return 48
  end
  return 64
end

function MobileActionSlotLogic.getSlotNames(self)
  if self._T.mobileActionSlotNames == nil then
    self._T.mobileActionSlotNames = {
      "ActionSlot_B_1",
      "ActionSlot_B_2",
      "ActionSlot_B_3",
      "ActionSlot_M_1",
      "ActionSlot_M_2",
      "ActionSlot_M_3",
      "ActionSlot_M_4",
      "ActionSlot_S_1",
      "ActionSlot_S_2",
      "ActionSlot_S_3",
      "ActionSlot_S_4"
    }
  end
  return self._T.mobileActionSlotNames
end

function MobileActionSlotLogic.HandleMobileActionSlotEnableUIEvent(self, event)
  if not self:isMobileActionSlotUIActive() or event.uiName ~= "utilDlg" then
    return
  end
  self:arrangeMobileActionSlotLayerForUtilDlg()
end

function MobileActionSlotLogic.handleMobileActionSlotHoldTimer(self)
  if self._T.mobileActionSlotRequestedVisible ~= true or self._T.mobileActionSlotMenuHidden == true or self._T.mobileActionSlotToggleHidden == true then
    self:stopAllMobileActionSlotPresses()
    return
  end
  local pressedEntries = self._T.mobileActionSlotPressedEntries
  if pressedEntries == nil then
    self:stopMobileActionSlotHoldTimerIfIdle()
    return
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local holdLimit = ___MOD.tonumber(self.mobileActionHoldLimitSec) or 60
  local expiredSlotKey
  for slotKey, pressedEntry in ___MOD.pairs(pressedEntries) do
    local startTime = ___MOD.tonumber(pressedEntry.startTime) or now
    if holdLimit <= now - startTime then
      expiredSlotKey = slotKey
      break
    end
    self:executeMobileActionSlotHold(___MOD.tonumber(pressedEntry.type or 0) or 0, ___MOD.tonumber(pressedEntry.id or 0) or 0)
    if 0 >= (___MOD.tonumber(self._T.mobileActionSlotHoldTimerId) or 0) then
      return
    end
  end
  if expiredSlotKey ~= nil then
    self:onMobileActionSlotReleased(expiredSlotKey)
  end
end

function MobileActionSlotLogic.HandleMobileActionSlotKeyConfigAllRemoveCountEvent(self, event)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  self:clearAllVisibleItemCountVisuals()
end

function MobileActionSlotLogic.HandleMobileActionSlotKeyConfigRemoveCountEvent(self, event)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  self:clearVisibleItemCountVisual(event.itemID)
end

function MobileActionSlotLogic.HandleMobileActionSlotKeyConfigUpdateCountEvent(self, event)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  self:refreshVisibleItemCountVisual(event.itemID, event.quantity)
end

function MobileActionSlotLogic.HandleMobileActionSlotOpacityMouseMoveEvent(self, event)
  if not self:isMobileActionSlotUIActive() or self._T.mobileActionSlotSettingBoxOpen ~= true then
    return
  end
  if self._T.mobileActionSlotOpacityKeyPressed ~= true then
    return
  end
  self:updateMobileActionSlotOpacityByScreenPoint(___MOD._InputService:GetCursorPosition())
end

function MobileActionSlotLogic.Initialize(self, user, playerId, preloadData)

end

function MobileActionSlotLogic.initializeMobileActionSlotsClient(self, showIfMobile)
  self:prepareMobileActionSlotsClient()
  if ___MOD.isvalid(self._T.mobileActionSlotRoot) then
    local shouldShow = showIfMobile == true and self:isMobileActionSlotUIActive()
    local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
    if shouldShow and ___MOD.isvalid(uiGroup) then
      uiGroup:SetEnable(true)
      uiGroup:SetVisible(true)
    end
    self._T.mobileActionSlotRoot:SetEnable(shouldShow)
    self._T.mobileActionSlotRoot:SetVisible(true)
    for _, slotEntity in ___MOD.pairs(self._T.mobileActionSlotEntities or {}) do
      if ___MOD.isvalid(slotEntity) then
        slotEntity:SetEnable(shouldShow)
        slotEntity:SetVisible(true)
      end
    end
    if ___MOD.isvalid(self._T.mobileActionSlotKeySwap) then
      self._T.mobileActionSlotKeySwap:SetEnable(shouldShow)
      self._T.mobileActionSlotKeySwap:SetVisible(true)
    end
  end
  self:setMobileActionSlotToggleVisible(showIfMobile)
end

function MobileActionSlotLogic.isLocalPlayerInitializedClient(self)
  local player = ___MOD._UserService.LocalPlayer
  return ___MOD.isvalid(player) and player.Player ~= nil and player.Player.init == true
end

function MobileActionSlotLogic.isMobileActionSlotKey(self, slotKey)
  local slotNames = self:getSlotNames()
  for _, name in ___MOD.ipairs(slotNames) do
    if name == slotKey then
      return true
    end
  end
  return false
end

function MobileActionSlotLogic.isMobileActionSlotRepeatEntry(self, slotType, id)
  if slotType == ___MOD._KeyConfigType.ITEM or slotType == ___MOD._KeyConfigType.SKILL then
    return true
  end
  return slotType == ___MOD._KeyConfigType.ACTION and (id == ___MOD._KeyConfigActionType.ATTACK or id == ___MOD._KeyConfigActionType.LOOT or id == ___MOD._KeyConfigActionType.JUMP)
end

function MobileActionSlotLogic.IsMobileActionSlotSettingBoxOpen(self)
  return self._T.mobileActionSlotSettingBoxOpen == true
end

function MobileActionSlotLogic.isMobileActionSlotUIActive(self)
  local observerDesktop = ___MOD._ObserverUtilLogic ~= nil and ___MOD._ObserverUtilLogic:IsObserverDesktopUIActive()
  return ___MOD.Environment:IsMobilePlatform() and not observerDesktop
end

function MobileActionSlotLogic.isSlotEntryAllowed(self, slotType, id)
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) or player.KeyConfigComponent == nil then
    return false
  end
  return player.KeyConfigComponent:isKeyConfigEntryAllowed(slotType, id)
end

function MobileActionSlotLogic.normalizeKeySet(self, keySet)
  if keySet == 2 then
    return 2
  end
  return 1
end

function MobileActionSlotLogic.normalizeMobileActionSlotOpacityPercent(self, value)
  local percent = ___MOD.tonumber(value)
  if percent == nil or percent ~= percent then
    return self.mobileActionSlotOpacityMaxPercent
  end
  percent = ___MOD.math.max(self.mobileActionSlotOpacityMinPercent, ___MOD.math.min(self.mobileActionSlotOpacityMaxPercent, percent))
  return ___MOD.math.floor(percent + 0.5)
end

function MobileActionSlotLogic.OnBeginPlay(self)
  if self._T.mobileActionSlotRequestedVisible == nil then
    self._T.mobileActionSlotRequestedVisible = self:isLocalPlayerInitializedClient()
  end
  if self._T.mobileActionSlotOpacityPercent == nil then
    self._T.mobileActionSlotOpacityPercent = self.mobileActionSlotOpacityMaxPercent
  end
  if self._T.mobileActionSlotSettingBoxOpen == nil then
    self._T.mobileActionSlotSettingBoxOpen = false
  end
  self:initializeMobileActionSlotsClient(self._T.mobileActionSlotRequestedVisible)
end

function MobileActionSlotLogic.onKeySwapButtonClick(self)
  if ___MOD._UIElementLogic.enable then
    return
  end
  self:tweenKeySwapScale(0.92)
  ___MOD._TimerService:SetTimerOnce(function()
    self:tweenKeySwapScale(1)
  end, 0.08)
  self:switchMobileActionSlotKeySet()
end

function MobileActionSlotLogic.onKeySwapTouchDown(self)
  if ___MOD._UIElementLogic.enable then
    return
  end
  self:tweenKeySwapScale(0.92)
end

function MobileActionSlotLogic.onKeySwapTouchUp(self)
  if ___MOD._UIElementLogic.enable then
    return
  end
  self:tweenKeySwapScale(1)
end

function MobileActionSlotLogic.onMobileActionSlotOpacityKeyStateChanged(self, event)
  if event.state == ___MOD.ButtonState.Pressed then
    self._T.mobileActionSlotOpacityKeyPressed = true
    return
  end
  if event.state == ___MOD.ButtonState.Released then
    self:finishMobileActionSlotOpacityInput()
  end
end

function MobileActionSlotLogic.onMobileActionSlotOpacityTouchDown(self, event)
  if not self:isMobileActionSlotUIActive() or self._T.mobileActionSlotSettingBoxOpen ~= true then
    return
  end
  self._T.mobileActionSlotOpacityKeyPressed = true
  self._T.mobileActionSlotOpacityTouchId = event.TouchId
  self:updateMobileActionSlotOpacityByScreenPoint(event.TouchPoint)
end

function MobileActionSlotLogic.onMobileActionSlotOpacityTouchDrag(self, event)
  if self._T.mobileActionSlotOpacityKeyPressed ~= true then
    return
  end
  if self._T.mobileActionSlotOpacityTouchId ~= nil and self._T.mobileActionSlotOpacityTouchId ~= event.TouchId then
    return
  end
  self:updateMobileActionSlotOpacityByScreenPoint(event.TouchPoint)
end

function MobileActionSlotLogic.onMobileActionSlotOpacityTouchEndDrag(self, event)
  if self._T.mobileActionSlotOpacityTouchId ~= nil and self._T.mobileActionSlotOpacityTouchId ~= event.TouchId then
    return
  end
  self:finishMobileActionSlotOpacityInput()
end

function MobileActionSlotLogic.onMobileActionSlotOpacityTouchUp(self, event)
  if self._T.mobileActionSlotOpacityTouchId ~= nil and self._T.mobileActionSlotOpacityTouchId ~= event.TouchId then
    return
  end
  self:finishMobileActionSlotOpacityInput()
end

function MobileActionSlotLogic.onMobileActionSlotPressed(self, slotKey)
  if not self:isMobileActionSlotUIActive() or ___MOD._UIElementLogic.enable then
    return
  end
  self:tweenSlotScale(slotKey, 0.92)
  local entry = self.localSlotConfig and self.localSlotConfig[slotKey] or nil
  if entry == nil then
    return
  end
  local slotType = ___MOD.tonumber(entry.type or 0) or 0
  local id = ___MOD.tonumber(entry.id or 0) or 0
  self._T.mobileActionSlotPressedFlags = self._T.mobileActionSlotPressedFlags or {}
  if self._T.mobileActionSlotPressedFlags[slotKey] == true then
    return
  end
  self._T.mobileActionSlotPressedFlags[slotKey] = true
  if not self:isMobileActionSlotRepeatEntry(slotType, id) then
    self:executeSlotEntry(slotType, id)
    return
  end
  self._T.mobileActionSlotPressedEntries = self._T.mobileActionSlotPressedEntries or {}
  if self._T.mobileActionSlotPressedEntries[slotKey] ~= nil then
    return
  end
  self._T.mobileActionSlotPressedEntries[slotKey] = {
    type = slotType,
    id = id,
    startTime = ___MOD._UtilLogic.ServerElapsedSeconds
  }
  self:executeMobileActionSlotPress(slotType, id)
  self:startMobileActionSlotHoldTimer()
end

function MobileActionSlotLogic.onMobileActionSlotReleased(self, slotKey)
  self:tweenSlotScale(slotKey, 1)
  if self._T.mobileActionSlotPressedFlags ~= nil then
    self._T.mobileActionSlotPressedFlags[slotKey] = nil
  end
  local pressedEntries = self._T.mobileActionSlotPressedEntries
  local pressedEntry = pressedEntries and pressedEntries[slotKey] or nil
  if pressedEntry == nil then
    return
  end
  pressedEntries[slotKey] = nil
  local slotType = ___MOD.tonumber(pressedEntry.type or 0) or 0
  local id = ___MOD.tonumber(pressedEntry.id or 0) or 0
  if slotType == ___MOD._KeyConfigType.SKILL then
    self:releaseMobileKeydownSkill(___MOD._UserService.LocalPlayer, id)
  end
  self:stopMobileActionSlotHoldTimerIfIdle()
end

function MobileActionSlotLogic.onMobileActionSlotSettingButtonClick(self, event)
  if event ~= nil and event.Entity ~= nil and event.Entity ~= self._T.mobileActionSlotSetting then
    return
  end
  if ___MOD._UIElementLogic.enable or not self:isMobileActionSlotUIActive() then
    return
  end
  if self._T.mobileActionSlotSettingBoxOpen == true then
    self:finishMobileActionSlotOpacityInput()
  end
  self._T.mobileActionSlotSettingBoxOpen = self._T.mobileActionSlotSettingBoxOpen ~= true
  self:applyMobileActionSlotSettingBoxState()
  self:setMobileActionSlotSettingBoxOpenToServer(self._T.mobileActionSlotSettingBoxOpen)
end

function MobileActionSlotLogic.onMobileActionSlotToggleButtonClick(self)
  if ___MOD._UIElementLogic.enable then
    return
  end
  local hidden = self._T.mobileActionSlotToggleHidden ~= true
  self:setMobileActionSlotsHiddenByToggle(hidden, false, self.mobileActionSlotToggleSlideDuration)
end

function MobileActionSlotLogic.onSlotButtonClick(self, slotKey)
  if self:tryRegisterDraggedEntryToSlot(slotKey) then
    return
  end
end

function MobileActionSlotLogic.OnUpdate(self, delta)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local nextUpdate = ___MOD.tonumber(self._T.nextMobileActionSlotVisualUpdateTime) or 0
  if now < nextUpdate then
    return
  end
  self._T.nextMobileActionSlotVisualUpdateTime = now + 0.25
  if self._T.mobileActionSlotNameCache == nil then
    self._T.mobileActionSlotNameCache = self:getSlotNames()
  end
  local slotNames = self._T.mobileActionSlotNameCache
  for _, slotKey in ___MOD.ipairs(slotNames) do
    self:updateSlotCooldownVisual(slotKey)
  end
end

function MobileActionSlotLogic.prepareKeySwapClient(self)
  local keySwap = self._T.mobileActionSlotKeySwap
  if not ___MOD.isvalid(keySwap) then
    return
  end
  self._T.mobileActionSlotKeySet1 = keySwap:GetChildByName("KeySet_1")
  self._T.mobileActionSlotKeySet2 = keySwap:GetChildByName("KeySet_2")
  if self._T.mobileActionSlotKeySwapClickHandler == nil then
    self._T.mobileActionSlotKeySwapClickHandler = keySwap:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onKeySwapButtonClick()
    end)
  end
  if self._T.mobileActionSlotKeySwapTouchDownHandler == nil then
    self._T.mobileActionSlotKeySwapTouchDownHandler = keySwap:ConnectEvent(___MOD.UITouchDownEvent, function()
      self:onKeySwapTouchDown()
    end)
  end
  if self._T.mobileActionSlotKeySwapTouchUpHandler == nil then
    self._T.mobileActionSlotKeySwapTouchUpHandler = keySwap:ConnectEvent(___MOD.UITouchUpEvent, function()
      self:onKeySwapTouchUp()
    end)
  end
  self:updateKeySetSprites()
end

function MobileActionSlotLogic.prepareMobileActionSlotOpacityControlsClient(self)
  self._T.mobileActionSlotOpacityScroll = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting/SettingBox/OpacityScroll")
  self._T.mobileActionSlotOpacityBar = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting/SettingBox/OpacityScroll/OpacityScroll_Bar")
  self._T.mobileActionSlotOpacityKey = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting/SettingBox/OpacityScroll/OpacityScroll_Key")
  self._T.mobileActionSlotOpacityHitArea = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting/SettingBox/OpacityScroll/OpacityScroll_Key/OpacityScroll_HitArea")
  self._T.mobileActionSlotOpacityText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting/SettingBox/OpacityText")
  local hitArea = self._T.mobileActionSlotOpacityHitArea
  if not ___MOD.isvalid(hitArea) then
    return
  end
  if self._T.mobileActionSlotOpacityControlsConnected ~= true then
    self._T.mobileActionSlotOpacityKeyStateHandler = hitArea:ConnectEvent(___MOD.ButtonStateChangeEvent, self.onMobileActionSlotOpacityKeyStateChanged)
    self._T.mobileActionSlotOpacityTouchDownHandler = hitArea:ConnectEvent(___MOD.UITouchDownEvent, self.onMobileActionSlotOpacityTouchDown)
    self._T.mobileActionSlotOpacityTouchDragHandler = hitArea:ConnectEvent(___MOD.UITouchDragEvent, self.onMobileActionSlotOpacityTouchDrag)
    self._T.mobileActionSlotOpacityTouchUpHandler = hitArea:ConnectEvent(___MOD.UITouchUpEvent, self.onMobileActionSlotOpacityTouchUp)
    self._T.mobileActionSlotOpacityTouchEndDragHandler = hitArea:ConnectEvent(___MOD.UITouchEndDragEvent, self.onMobileActionSlotOpacityTouchEndDrag)
    self._T.mobileActionSlotOpacityControlsConnected = true
  end
  self:updateMobileActionSlotOpacityControls()
end

function MobileActionSlotLogic.prepareMobileActionSlotsClient(self)
  self._T.mobileActionSlotRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlots")
  if not ___MOD.isvalid(self._T.mobileActionSlotRoot) then
    return
  end
  self._T.mobileActionSlotEntities = self._T.mobileActionSlotEntities or {}
  self._T.mobileActionSlotHandlers = self._T.mobileActionSlotHandlers or {}
  self._T.mobileActionSlotStateHandlers = self._T.mobileActionSlotStateHandlers or {}
  self._T.mobileActionSlotKeySwap = self._T.mobileActionSlotRoot:GetChildByName("KeySwap")
  if ___MOD.isvalid(self._T.mobileActionSlotKeySwap) then
    self:prepareKeySwapClient()
  end
  local slotNames = self:getSlotNames()
  for _, slotKey in ___MOD.ipairs(slotNames) do
    local slotEntity = self._T.mobileActionSlotRoot:GetChildByName(slotKey)
    if ___MOD.isvalid(slotEntity) then
      self._T.mobileActionSlotEntities[slotKey] = slotEntity
      if self._T.mobileActionSlotHandlers[slotKey] == nil then
        local capturedSlotKey = slotKey
        self._T.mobileActionSlotHandlers[slotKey] = slotEntity:ConnectEvent(___MOD.ButtonClickEvent, function()
          self:onSlotButtonClick(capturedSlotKey)
        end)
      end
      if self._T.mobileActionSlotStateHandlers[slotKey] == nil then
        local capturedSlotKey = slotKey
        self._T.mobileActionSlotStateHandlers[slotKey] = slotEntity:ConnectEvent(___MOD.ButtonStateChangeEvent, function(event)
          if event.state == ___MOD.ButtonState.Pressed then
            self:onMobileActionSlotPressed(capturedSlotKey)
          else
            self:onMobileActionSlotReleased(capturedSlotKey)
          end
        end)
      end
    end
  end
  self:applyMobileActionSlotOpacity()
end

function MobileActionSlotLogic.prepareMobileActionSlotSettingClient(self)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  self._T.mobileActionSlotSetting = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting")
  self._T.mobileActionSlotSettingBox = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting/SettingBox")
  local setting = self._T.mobileActionSlotSetting
  if not ___MOD.isvalid(setting) then
    return
  end
  if self._T.mobileActionSlotSettingStateHandler == nil then
    self._T.mobileActionSlotSettingStateHandler = setting:ConnectEvent(___MOD.ButtonStateChangeEvent, function(event)
      if event.Entity ~= nil and event.Entity ~= setting then
        return
      end
      if event.state == ___MOD.ButtonState.Pressed then
        self:tweenMobileActionSlotSettingScale(0.92)
      else
        self:tweenMobileActionSlotSettingScale(1)
      end
    end)
  end
  if self._T.mobileActionSlotSettingClickHandler == nil then
    self._T.mobileActionSlotSettingClickHandler = setting:ConnectEvent(___MOD.ButtonClickEvent, self.onMobileActionSlotSettingButtonClick)
  end
  self:prepareMobileActionSlotToggleClient()
  self:prepareMobileActionSlotOpacityControlsClient()
  self:applyMobileActionSlotSettingBoxState()
end

function MobileActionSlotLogic.prepareMobileActionSlotToggleClient(self)
  self._T.mobileActionSlotToggle = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlotSetting/SettingBox/MobileActionSlotToggle")
  local toggle = self._T.mobileActionSlotToggle
  if not ___MOD.isvalid(toggle) then
    return
  end
  if self._T.mobileActionSlotToggleStateHandler == nil then
    self._T.mobileActionSlotToggleStateHandler = toggle:ConnectEvent(___MOD.ButtonStateChangeEvent, function(event)
      if event.state == ___MOD.ButtonState.Pressed then
        self:tweenMobileActionSlotToggleScale(0.92)
      else
        self:tweenMobileActionSlotToggleScale(1)
      end
    end)
  end
  if self._T.mobileActionSlotToggleClickHandler == nil then
    self._T.mobileActionSlotToggleClickHandler = toggle:ConnectEvent(___MOD.ButtonClickEvent, self.onMobileActionSlotToggleButtonClick)
  end
end

function MobileActionSlotLogic.refreshAllSlotVisuals(self)
  local slotNames = self:getSlotNames()
  for _, slotKey in ___MOD.ipairs(slotNames) do
    self:applySlotVisual(slotKey)
  end
end

function MobileActionSlotLogic.refreshVisibleItemCountVisual(self, itemId, quantity)
  if itemId <= 0 or self.localSlotConfig == nil then
    return
  end
  local slotNames = self:getSlotNames()
  for _, slotKey in ___MOD.ipairs(slotNames) do
    local entry = self.localSlotConfig[slotKey]
    local entryType = ___MOD.tonumber(entry and entry.type or 0) or 0
    local entryId = ___MOD.tonumber(entry and entry.id or 0) or 0
    if entryType == ___MOD._KeyConfigType.ITEM and entryId == itemId then
      local slotEntity = self._T.mobileActionSlotEntities and self._T.mobileActionSlotEntities[slotKey] or nil
      local slotNumber = self:ensureSlotNumberComponent(slotEntity)
      if ___MOD.isvalid(slotNumber) then
        slotNumber:updateNumber(quantity, false)
      end
    end
  end
end

function MobileActionSlotLogic.registerDraggedItemToSlot(self, slotKey, clickedEntity)
  if not ___MOD.isvalid(clickedEntity) or clickedEntity.InventoryGridItemComponent == nil then
    return false
  end
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) or player.CInventoryComponent == nil then
    return false
  end
  local itemId = ___MOD.tonumber(___MOD._UIElementLogic.beforeSlotItemID) or 0
  if itemId <= 0 then
    itemId = ___MOD.tonumber(clickedEntity.InventoryGridItemComponent.itemId) or 0
  end
  local invType = ___MOD.tonumber(___MOD._UIElementLogic.beforeSlotType) or 0
  if invType <= 0 then
    invType = ___MOD.tonumber(clickedEntity.InventoryGridItemComponent.invType) or 0
  end
  local invSlot = ___MOD.tonumber(___MOD._UIElementLogic.beforeSlotPos) or 0
  if invSlot <= 0 then
    invSlot = ___MOD.tonumber(clickedEntity.InventoryGridItemComponent.slot) or 0
  end
  if invType ~= 2 then
    return false
  end
  if ___MOD._ItemManager:isArrow(itemId) or ___MOD._ItemManager:isBowArrow(itemId) or ___MOD._ItemManager:isBullet(itemId) or ___MOD._ItemManager:isCrossbowArrow(itemId) or ___MOD._ItemManager:isThrowingStars(itemId) then
    return false
  end
  local itemStack = player.CInventoryComponent:getItemStack(invType, invSlot)
  if itemStack == nil then
    return false
  end
  self:setSlotClient(slotKey, ___MOD._KeyConfigType.ITEM, itemStack.ItemId)
  return true
end

function MobileActionSlotLogic.registerDraggedKeyConfigToSlot(self, slotKey)
  local slotType = ___MOD.tonumber(___MOD._UIElementLogic.beforeType) or 0
  local id = ___MOD.tonumber(___MOD._UIElementLogic.beforeID) or 0
  if slotType <= 0 or id <= 0 then
    return false
  end
  if slotType == ___MOD._KeyConfigType.ITEM then
    local player = ___MOD._UserService.LocalPlayer
    if not ___MOD.isvalid(player) or player.CInventoryComponent == nil or 0 >= player.CInventoryComponent:getItemCount(id) then
      return false
    end
  end
  self:setSlotClient(slotKey, slotType, id)
  return true
end

function MobileActionSlotLogic.registerDraggedMobileKeyConfigPaletteToSlot(self, slotKey, clickedEntity)
  local paletteSlot
  if ___MOD.isvalid(clickedEntity) and clickedEntity.MobileKeyConfigPaletteSlotComponent ~= nil then
    paletteSlot = clickedEntity.MobileKeyConfigPaletteSlotComponent
  elseif ___MOD.isvalid(clickedEntity) and ___MOD.isvalid(clickedEntity.Parent) and clickedEntity.Parent.MobileKeyConfigPaletteSlotComponent ~= nil then
    paletteSlot = clickedEntity.Parent.MobileKeyConfigPaletteSlotComponent
  end
  if paletteSlot == nil then
    return false
  end
  local slotType = ___MOD.tonumber(paletteSlot.slotType) or 0
  local id = ___MOD.tonumber(paletteSlot.actionId) or 0
  if slotType <= 0 or id <= 0 then
    return false
  end
  self:setSlotClient(slotKey, slotType, id)
  return true
end

function MobileActionSlotLogic.registerDraggedSkillToSlot(self, slotKey, clickedEntity)
  local skillId = self:getDraggedSkillId(clickedEntity)
  if skillId <= 0 then
    return false
  end
  self:setSlotClient(slotKey, ___MOD._KeyConfigType.SKILL, skillId)
  return true
end

function MobileActionSlotLogic.releaseMobileKeydownSkill(self, player, skillID)
  if not ___MOD.isvalid(player) or skillID <= 0 or player.SkillComponent == nil then
    return false
  end
  local skillLevel = player.SkillComponent:getSkillLevel(skillID)
  if skillLevel <= 0 then
    return false
  end
  ___MOD._PlayerSkillLogic:tryUseSkillClient(player, skillID, skillLevel, true, false, false)
  return true
end

function MobileActionSlotLogic.removeSameEntryFromOtherSlots(self, slotConfig, targetSlotKey, slotType, id)
  if slotConfig == nil or slotType <= 0 or id <= 0 then
    return ""
  end
  for slotKey, entry in ___MOD.pairs(slotConfig) do
    if slotKey ~= targetSlotKey then
      local entryType = ___MOD.tonumber(entry and entry.type or 0) or 0
      local entryId = ___MOD.tonumber(entry and entry.id or 0) or 0
      if entryType == slotType and entryId == id then
        slotConfig[slotKey] = nil
        return slotKey
      end
    end
  end
  return ""
end

function MobileActionSlotLogic.removeSlotNumberComponent(self, targetEntity)
  if not ___MOD.isvalid(targetEntity) then
    return
  end
  for i = 1, 4 do
    local countEntity = targetEntity:GetChildByName("count" .. ___MOD.tostring(i))
    if ___MOD.isvalid(countEntity) then
      countEntity:Destroy()
    end
  end
  if ___MOD.isvalid(targetEntity.SlotNumberComponent) then
    targetEntity:RemoveComponent(___MOD.SlotNumberComponent)
  end
end

function MobileActionSlotLogic.resetClientSlotStateForCharacterLoad(self)
  self:stopAllMobileActionSlotPresses()
  self:resetMobileActionSlotToggleStateForCharacterLoad()
  self._T.mobileActionSlotOpacityPercent = self.mobileActionSlotOpacityMaxPercent
  self._T.mobileActionSlotOpacityDirty = false
  self._T.mobileActionSlotOpacityKeyPressed = false
  self._T.mobileActionSlotOpacityTouchId = nil
  self.localKeySetConfigs = {}
  self.currentKeySet = 1
  self.localSlotConfig = self:ensureKeySetConfig(self.localKeySetConfigs, self.currentKeySet)
  self._T.mobileActionSlotCooldownTotalCache = {}
  self:prepareMobileActionSlotsClient()
  self:prepareMobileActionSlotSettingClient()
  self:updateKeySetSprites()
  self:refreshAllSlotVisuals()
end

function MobileActionSlotLogic.resetMobileActionSlotToggleStateForCharacterLoad(self)
  if self._T.mobileActionSlotToggleTween ~= nil then
    self._T.mobileActionSlotToggleTween:Destroy()
    self._T.mobileActionSlotToggleTween = nil
  end
  if self._T.mobileActionSlotSettingScaleTween ~= nil then
    self._T.mobileActionSlotSettingScaleTween:Destroy()
    self._T.mobileActionSlotSettingScaleTween = nil
  end
  self._T.mobileActionSlotToggleHidden = false
  self._T.mobileActionSlotSettingBoxOpen = false
  self:updateMobileActionSlotToggleSprite()
  self:tweenMobileActionSlotToggleScale(1)
  self:tweenMobileActionSlotSettingScale(1)
  self:applyMobileActionSlotSettingBoxState()
end

function MobileActionSlotLogic.resolveCooldownLookupId(self, skillId)
  if skillId ~= ___MOD._SkillBook.Octopus_521_5211001 then
    return skillId
  end
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) or not ___MOD.isvalid(player.SkillComponent) then
    return skillId
  end
  if player.SkillComponent:getSkillLevel(___MOD._SkillBook.Wrath_of_the_Octopi_522_5220002) <= 0 then
    return skillId
  end
  return ___MOD._SkillBook.Wrath_of_the_Octopi_522_5220002
end

function MobileActionSlotLogic.resolveCooldownTotalSec(self, slotKey, skillId, coolEnd, remain, dataTotal)
  self._T.mobileActionSlotCooldownTotalCache = self._T.mobileActionSlotCooldownTotalCache or {}
  local cache = self._T.mobileActionSlotCooldownTotalCache
  local cached = cache[slotKey]
  if cached ~= nil and cached.skillId == skillId and cached.coolEnd == coolEnd and 0 < (cached.total or 0) then
    if 0 < dataTotal then
      cached.total = dataTotal
      return dataTotal
    end
    return cached.total
  end
  local total = dataTotal
  if total <= 0 then
    total = remain
  end
  cache[slotKey] = {
    skillId = skillId,
    coolEnd = coolEnd,
    total = total
  }
  return total
end

function MobileActionSlotLogic.Serialize(self, user)

end

function MobileActionSlotLogic.setMobileActionSlotOpacityClient(self, value, markDirty)
  local percent = self:normalizeMobileActionSlotOpacityPercent(value)
  if self._T.mobileActionSlotOpacityPercent == percent then
    return
  end
  self._T.mobileActionSlotOpacityPercent = percent
  if markDirty then
    self._T.mobileActionSlotOpacityDirty = true
  end
  self:applyMobileActionSlotOpacity()
  self:updateMobileActionSlotOpacityControls()
end

function MobileActionSlotLogic.setMobileActionSlotOpacityToServer(self, opacityPercent, senderUserId)

end

function MobileActionSlotLogic.setMobileActionSlotSettingBoxOpenToServer(self, settingBoxOpen, senderUserId)

end

function MobileActionSlotLogic.setMobileActionSlotsHiddenByMenu(self, hidden, immediate, duration)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  if hidden then
    self:stopAllMobileActionSlotPresses()
  end
  self:prepareMobileActionSlotsClient()
  local root = self._T.mobileActionSlotRoot
  if not ___MOD.isvalid(root) or root.UITransformComponent == nil then
    return
  end
  local transform = root.UITransformComponent
  local wasHiddenByMenu = self._T.mobileActionSlotMenuHidden == true
  if self._T.mobileActionSlotMenuOpenX == nil then
    self._T.mobileActionSlotMenuOpenX = transform.anchoredPosition.x
    self._T.mobileActionSlotMenuOpenY = transform.anchoredPosition.y
  end
  local openX = ___MOD.tonumber(self._T.mobileActionSlotMenuOpenX) or transform.anchoredPosition.x
  local openY = ___MOD.tonumber(self._T.mobileActionSlotMenuOpenY) or transform.anchoredPosition.y
  local offsetX = ___MOD.tonumber(self._T.mobileActionSlotMenuSlideOffsetX) or ___MOD.tonumber(self.mobileActionSlotMenuSlideOffsetX) or 800
  local closedX = openX + offsetX
  local toX = hidden and closedX or openX
  self._T.mobileActionSlotMenuHidden = hidden == true
  if self._T.mobileActionSlotMenuTween ~= nil then
    self._T.mobileActionSlotMenuTween:Destroy()
    self._T.mobileActionSlotMenuTween = nil
  end
  if self._T.mobileActionSlotToggleTween ~= nil then
    self._T.mobileActionSlotToggleTween:Destroy()
    self._T.mobileActionSlotToggleTween = nil
  end
  if hidden ~= true and wasHiddenByMenu and self:isLocalPlayerInitializedClient() then
    self._T.mobileActionSlotToggleHidden = false
    self._T.mobileActionSlotRequestedVisible = true
    self:updateMobileActionSlotToggleSprite()
  end
  if immediate then
    transform.anchoredPosition = ___MOD.FastVector2(toX, openY)
    root:SetEnable(not hidden and self._T.mobileActionSlotRequestedVisible == true and self:isMobileActionSlotUIActive())
    root:SetVisible(true)
    return
  end
  if not hidden then
    root:SetEnable(self._T.mobileActionSlotRequestedVisible == true and self:isMobileActionSlotUIActive())
    root:SetVisible(true)
  end
  local slideDuration = ___MOD.tonumber(duration) or ___MOD.tonumber(self.mobileActionSlotMenuSlideDuration) or 0.36
  local tween = ___MOD._MobileUIMotionLogic:playSlide(root, true, transform.anchoredPosition.x, toX, slideDuration, ___MOD.EaseType.QuadEaseInOut)
  if tween == nil then
    transform.anchoredPosition = ___MOD.FastVector2(toX, openY)
    root:SetEnable(not hidden and self._T.mobileActionSlotRequestedVisible == true and self:isMobileActionSlotUIActive())
    root:SetVisible(true)
    return
  end
  self._T.mobileActionSlotMenuTween = tween
  tween:SetOnEndCallback(function()
    self._T.mobileActionSlotMenuTween = nil
    transform.anchoredPosition = ___MOD.FastVector2(toX, openY)
    if hidden then
      root:SetEnable(false)
      root:SetVisible(true)
    end
  end)
end

function MobileActionSlotLogic.setMobileActionSlotsHiddenByToggle(self, hidden, immediate, duration)
  if not self:isMobileActionSlotUIActive() then
    return
  end
  self:prepareMobileActionSlotsClient()
  self:prepareMobileActionSlotToggleClient()
  local root = self._T.mobileActionSlotRoot
  if not ___MOD.isvalid(root) or root.UITransformComponent == nil then
    return
  end
  self._T.mobileActionSlotToggleHidden = hidden == true
  self._T.mobileActionSlotRequestedVisible = hidden ~= true
  self:updateMobileActionSlotToggleSprite()
  if hidden then
    self:stopAllMobileActionSlotPresses()
  end
  if self._T.mobileActionSlotToggleTween ~= nil then
    self._T.mobileActionSlotToggleTween:Destroy()
    self._T.mobileActionSlotToggleTween = nil
  end
  if self._T.mobileActionSlotMenuHidden ~= true and self._T.mobileActionSlotMenuTween ~= nil then
    self._T.mobileActionSlotMenuTween:Destroy()
    self._T.mobileActionSlotMenuTween = nil
  end
  if self._T.mobileActionSlotMenuHidden == true then
    root:SetEnable(false)
    root:SetVisible(true)
    return
  end
  local transform = root.UITransformComponent
  local openX = ___MOD.tonumber(self._T.mobileActionSlotMenuOpenX) or transform.anchoredPosition.x
  local openY = ___MOD.tonumber(self._T.mobileActionSlotMenuOpenY) or transform.anchoredPosition.y
  local offsetX = ___MOD.tonumber(self.mobileActionSlotToggleSlideOffsetX) or 800
  local closedX = openX + offsetX
  local toX = hidden and closedX or openX
  if immediate then
    transform.anchoredPosition = ___MOD.FastVector2(toX, openY)
    root:SetEnable(not hidden)
    root:SetVisible(true)
    return
  end
  if not hidden then
    transform.anchoredPosition = ___MOD.FastVector2(closedX, openY)
    root:SetEnable(true)
    root:SetVisible(true)
  end
  local slideDuration = ___MOD.tonumber(duration) or ___MOD.tonumber(self.mobileActionSlotToggleSlideDuration) or 0.36
  local tween = ___MOD._MobileUIMotionLogic:playSlide(root, true, transform.anchoredPosition.x, toX, slideDuration, ___MOD.EaseType.QuadEaseInOut)
  if tween == nil then
    transform.anchoredPosition = ___MOD.FastVector2(toX, openY)
    root:SetEnable(not hidden)
    root:SetVisible(true)
    return
  end
  self._T.mobileActionSlotToggleTween = tween
  tween:SetOnEndCallback(function()
    self._T.mobileActionSlotToggleTween = nil
    transform.anchoredPosition = ___MOD.FastVector2(toX, openY)
    if hidden then
      root:SetEnable(false)
      root:SetVisible(true)
    end
  end)
end

function MobileActionSlotLogic.setMobileActionSlotsVisible(self, visible)
  self._T.mobileActionSlotRequestedVisible = visible == true
  if visible ~= true then
    self:stopAllMobileActionSlotPresses()
  end
  if not ___MOD.isvalid(self._T.mobileActionSlotRoot) then
    self._T.mobileActionSlotRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileActionSlots")
  end
  if ___MOD.isvalid(self._T.mobileActionSlotRoot) then
    local isMobile = self:isMobileActionSlotUIActive()
    local shouldShow = visible == true and isMobile
    local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
    if shouldShow and ___MOD.isvalid(uiGroup) then
      uiGroup:SetEnable(true)
      uiGroup:SetVisible(true)
    end
    self._T.mobileActionSlotRoot:SetEnable(shouldShow)
    self._T.mobileActionSlotRoot:SetVisible(true)
    for _, slotEntity in ___MOD.pairs(self._T.mobileActionSlotEntities or {}) do
      if ___MOD.isvalid(slotEntity) then
        slotEntity:SetEnable(shouldShow)
        slotEntity:SetVisible(true)
      end
    end
    if ___MOD.isvalid(self._T.mobileActionSlotKeySwap) then
      self._T.mobileActionSlotKeySwap:SetEnable(shouldShow)
      self._T.mobileActionSlotKeySwap:SetVisible(true)
    end
    if shouldShow then
      self:applyMobileActionSlotOpacity()
    end
  end
end

function MobileActionSlotLogic.setMobileActionSlotToggleVisible(self, visible)
  self:prepareMobileActionSlotSettingClient()
  local setting = self._T.mobileActionSlotSetting
  if not ___MOD.isvalid(setting) then
    return
  end
  local shouldShow = visible == true and self:isMobileActionSlotUIActive()
  setting:SetEnable(shouldShow)
  setting:SetVisible(true)
  self:updateMobileActionSlotToggleSprite()
  self:applyMobileActionSlotSettingBoxState()
end

function MobileActionSlotLogic.setSlotClient(self, slotKey, slotType, id)
  if not self:isMobileActionSlotKey(slotKey) then
    return
  end
  if slotType ~= -1 and not self:isSlotEntryAllowed(slotType, id) then
    return
  end
  local normalizedKeySet = self:normalizeKeySet(self.currentKeySet)
  self.localSlotConfig = self:ensureKeySetConfig(self.localKeySetConfigs, normalizedKeySet)
  if slotType == -1 or id <= 0 then
    self.localSlotConfig[slotKey] = nil
  else
    local movedFromSlotKey = self:removeSameEntryFromOtherSlots(self.localSlotConfig, slotKey, slotType, id)
    if not ___MOD._UtilLogic:IsNilorEmptyString(movedFromSlotKey) then
      self:applySlotVisual(movedFromSlotKey)
    end
    self.localSlotConfig[slotKey] = {
      slot = slotKey,
      type = slotType,
      id = id
    }
  end
  self:applySlotVisual(slotKey)
  self:setSlotToServer(slotKey, slotType, id, normalizedKeySet)
end

function MobileActionSlotLogic.setSlotToServer(self, slotKey, slotType, id, keySet, senderUserId)

end

function MobileActionSlotLogic.startMobileActionSlotHoldTimer(self)
  if 0 < (___MOD.tonumber(self._T.mobileActionSlotHoldTimerId) or 0) then
    return
  end
  local interval = ___MOD.math.max(0.01, ___MOD.tonumber(self.mobileActionHoldRepeatInterval) or 0.05)
  self._T.mobileActionSlotHoldTimerId = ___MOD._TimerService:SetTimerRepeat(self.handleMobileActionSlotHoldTimer, interval, interval)
  if (___MOD.tonumber(self._T.mobileActionSlotHoldTimerId) or 0) <= 0 then
    self._T.mobileActionSlotHoldTimerId = nil
  end
end

function MobileActionSlotLogic.stopAllMobileActionSlotPresses(self)
  self:finishMobileActionSlotOpacityInput()
  local timerId = ___MOD.tonumber(self._T.mobileActionSlotHoldTimerId) or 0
  if 0 < timerId then
    ___MOD._TimerService:ClearTimer(timerId)
  end
  self._T.mobileActionSlotHoldTimerId = nil
  local pressedFlags = self._T.mobileActionSlotPressedFlags
  if pressedFlags ~= nil then
    local slotKey = ___MOD.next(pressedFlags)
    while slotKey ~= nil do
      self:tweenSlotScale(slotKey, 1)
      pressedFlags[slotKey] = nil
      slotKey = ___MOD.next(pressedFlags)
    end
  end
  local pressedEntries = self._T.mobileActionSlotPressedEntries
  if pressedEntries == nil then
    return
  end
  local player = ___MOD._UserService.LocalPlayer
  local slotKey, pressedEntry = ___MOD.next(pressedEntries)
  while slotKey ~= nil do
    self:tweenSlotScale(slotKey, 1)
    if (___MOD.tonumber(pressedEntry.type or 0) or 0) == ___MOD._KeyConfigType.SKILL then
      self:releaseMobileKeydownSkill(player, ___MOD.tonumber(pressedEntry.id or 0) or 0)
    end
    pressedEntries[slotKey] = nil
    slotKey, pressedEntry = ___MOD.next(pressedEntries)
  end
end

function MobileActionSlotLogic.stopMobileActionSlotHoldTimerIfIdle(self)
  local pressedEntries = self._T.mobileActionSlotPressedEntries
  if pressedEntries ~= nil and ___MOD.next(pressedEntries) ~= nil then
    return
  end
  local timerId = ___MOD.tonumber(self._T.mobileActionSlotHoldTimerId) or 0
  if 0 < timerId then
    ___MOD._TimerService:ClearTimer(timerId)
  end
  self._T.mobileActionSlotHoldTimerId = nil
end

function MobileActionSlotLogic.switchMobileActionSlotKeySet(self)
  self:stopAllMobileActionSlotPresses()
  if self.currentKeySet == 2 then
    self.currentKeySet = 1
  else
    self.currentKeySet = 2
  end
  self.localSlotConfig = self:ensureKeySetConfig(self.localKeySetConfigs, self.currentKeySet)
  self:updateKeySetSprites()
  self:refreshAllSlotVisuals()
end

function MobileActionSlotLogic.syncInitializedToClient(self, slotConfig, opacityPercent, settingBoxOpen)
  self.localKeySetConfigs = slotConfig or {}
  self.currentKeySet = 1
  self.localSlotConfig = self:ensureKeySetConfig(self.localKeySetConfigs, self.currentKeySet)
  self._T.mobileActionSlotOpacityPercent = self:normalizeMobileActionSlotOpacityPercent(opacityPercent)
  self._T.mobileActionSlotOpacityDirty = false
  self._T.mobileActionSlotOpacityKeyPressed = false
  self._T.mobileActionSlotOpacityTouchId = nil
  if ___MOD.Environment:IsMobilePlatform() then
    self._T.mobileActionSlotSettingBoxOpen = settingBoxOpen == true
  end
  self:prepareMobileActionSlotsClient()
  self:prepareMobileActionSlotSettingClient()
  self:updateKeySetSprites()
  self:refreshAllSlotVisuals()
end

function MobileActionSlotLogic.syncSetSlotToClient(self, slotKey, slotType, id, keySet)
  local normalizedKeySet = self:normalizeKeySet(keySet)
  local targetConfig = self:ensureKeySetConfig(self.localKeySetConfigs, normalizedKeySet)
  if slotType <= 0 or id <= 0 then
    targetConfig[slotKey] = nil
  else
    local movedFromSlotKey = self:removeSameEntryFromOtherSlots(targetConfig, slotKey, slotType, id)
    if normalizedKeySet == self.currentKeySet and not ___MOD._UtilLogic:IsNilorEmptyString(movedFromSlotKey) then
      self:applySlotVisual(movedFromSlotKey)
    end
    targetConfig[slotKey] = {
      slot = slotKey,
      type = slotType,
      id = id
    }
  end
  if normalizedKeySet == self.currentKeySet then
    self.localSlotConfig = targetConfig
    self:applySlotVisual(slotKey)
  end
end

function MobileActionSlotLogic.tryRegisterDraggedEntryToSlot(self, slotKey)
  if not self:isMobileActionSlotUIActive() or not ___MOD._UIElementLogic.enable then
    return false
  end
  local clickedEntity = ___MOD._UIElementLogic.clickedEntity
  if not ___MOD.isvalid(clickedEntity) then
    ___MOD._UIElementLogic:disableClone()
    return true
  end
  local clickedType = self:getDraggedUIElementType(clickedEntity)
  local registered = false
  if self:registerDraggedMobileKeyConfigPaletteToSlot(slotKey, clickedEntity) then
    registered = true
  elseif clickedType == ___MOD._UIElementType.ITEM then
    registered = self:registerDraggedItemToSlot(slotKey, clickedEntity)
  elseif clickedType == ___MOD._UIElementType.SKILL or self:getDraggedSkillId(clickedEntity) > 0 then
    registered = self:registerDraggedSkillToSlot(slotKey, clickedEntity)
  elseif clickedType == ___MOD._UIElementType.KEYCONFIG or clickedType == ___MOD._UIElementType.QUICKSLOT then
    registered = self:registerDraggedKeyConfigToSlot(slotKey)
  end
  if registered then
    ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.DragEnd"), 1)
  end
  ___MOD._UIElementLogic:disableClone()
  return true
end

function MobileActionSlotLogic.tweenKeySwapScale(self, scale)
  local keySwap = self._T.mobileActionSlotKeySwap
  if not ___MOD.isvalid(keySwap) or keySwap.UITransformComponent == nil then
    return
  end
  self._T.mobileActionSlotBaseScales = self._T.mobileActionSlotBaseScales or {}
  self._T.mobileActionSlotTweens = self._T.mobileActionSlotTweens or {}
  local tweenKey = "KeySwap"
  if self._T.mobileActionSlotBaseScales[tweenKey] == nil then
    self._T.mobileActionSlotBaseScales[tweenKey] = keySwap.UITransformComponent.Scale:Clone()
  end
  local oldTween = self._T.mobileActionSlotTweens[tweenKey]
  if oldTween ~= nil then
    oldTween:Destroy()
    self._T.mobileActionSlotTweens[tweenKey] = nil
  end
  local base = self._T.mobileActionSlotBaseScales[tweenKey]
  local target = ___MOD.Vector3(base.x * scale, base.y * scale, base.z)
  local tween = ___MOD._MobileUIMotionLogic:playScaleTo(keySwap, target, 0.08, ___MOD.EaseType.QuadEaseInOut)
  if tween == nil then
    return
  end
  self._T.mobileActionSlotTweens[tweenKey] = tween
end

function MobileActionSlotLogic.tweenMobileActionSlotSettingScale(self, scale)
  local setting = self._T.mobileActionSlotSetting
  if not ___MOD.isvalid(setting) or setting.SpriteGUIRendererComponent == nil then
    return
  end
  local renderer = setting.SpriteGUIRendererComponent
  if self._T.mobileActionSlotSettingBaseScale == nil then
    self._T.mobileActionSlotSettingBaseScale = renderer.LocalScale:Clone()
  end
  if self._T.mobileActionSlotSettingScaleTween ~= nil then
    self._T.mobileActionSlotSettingScaleTween:Destroy()
    self._T.mobileActionSlotSettingScaleTween = nil
  end
  local baseScale = self._T.mobileActionSlotSettingBaseScale
  local target = ___MOD.FastVector2(baseScale.x * scale, baseScale.y * scale)
  local tween = ___MOD._TweenLogic:MakeTween(renderer.LocalScale, target, 0.08, ___MOD.EaseType.QuadEaseInOut, function(value)
    if ___MOD.isvalid(setting) and setting.SpriteGUIRendererComponent ~= nil then
      setting.SpriteGUIRendererComponent.LocalScale = value
    end
  end)
  if tween ~= nil then
    tween.AutoDestroy = true
    tween:Play()
    self._T.mobileActionSlotSettingScaleTween = tween
  end
end

function MobileActionSlotLogic.tweenMobileActionSlotToggleScale(self, scale)
  local toggle = self._T.mobileActionSlotToggle
  if not ___MOD.isvalid(toggle) or toggle.UITransformComponent == nil then
    return
  end
  if self._T.mobileActionSlotToggleBaseScale == nil then
    self._T.mobileActionSlotToggleBaseScale = toggle.UITransformComponent.Scale:Clone()
  end
  if self._T.mobileActionSlotToggleScaleTween ~= nil then
    self._T.mobileActionSlotToggleScaleTween:Destroy()
    self._T.mobileActionSlotToggleScaleTween = nil
  end
  local baseScale = self._T.mobileActionSlotToggleBaseScale
  local target = ___MOD.FastVector3(baseScale.x * scale, baseScale.y * scale, baseScale.z)
  local tween = ___MOD._MobileUIMotionLogic:playScaleTo(toggle, target, 0.08, ___MOD.EaseType.QuadEaseInOut)
  if tween ~= nil then
    self._T.mobileActionSlotToggleScaleTween = tween
  end
end

function MobileActionSlotLogic.tweenSlotScale(self, slotKey, scale)
  local slotEntity = self._T.mobileActionSlotEntities and self._T.mobileActionSlotEntities[slotKey] or nil
  if not ___MOD.isvalid(slotEntity) or slotEntity.UITransformComponent == nil then
    return
  end
  self._T.mobileActionSlotBaseScales = self._T.mobileActionSlotBaseScales or {}
  self._T.mobileActionSlotTweens = self._T.mobileActionSlotTweens or {}
  if self._T.mobileActionSlotBaseScales[slotKey] == nil then
    self._T.mobileActionSlotBaseScales[slotKey] = slotEntity.UITransformComponent.Scale:Clone()
  end
  local oldTween = self._T.mobileActionSlotTweens[slotKey]
  if oldTween ~= nil then
    oldTween:Destroy()
    self._T.mobileActionSlotTweens[slotKey] = nil
  end
  local base = self._T.mobileActionSlotBaseScales[slotKey]
  local target = ___MOD.Vector3(base.x * scale, base.y * scale, base.z)
  local tween = ___MOD._MobileUIMotionLogic:playScaleTo(slotEntity, target, 0.08, ___MOD.EaseType.QuadEaseInOut)
  if tween == nil then
    return
  end
  self._T.mobileActionSlotTweens[slotKey] = tween
end

function MobileActionSlotLogic.updateKeySetSprites(self)
  local current = self:normalizeKeySet(self.currentKeySet)
  local keySet1 = self._T.mobileActionSlotKeySet1
  local keySet2 = self._T.mobileActionSlotKeySet2
  if ___MOD.isvalid(keySet1) and keySet1.SpriteGUIRendererComponent ~= nil then
    keySet1.SpriteGUIRendererComponent.ImageRUID = current == 1 and self.keySetActiveRuid or self.keySetInactiveRuid
    keySet1:SetVisible(true)
    keySet1:SetEnable(true)
  end
  if ___MOD.isvalid(keySet2) and keySet2.SpriteGUIRendererComponent ~= nil then
    keySet2.SpriteGUIRendererComponent.ImageRUID = current == 2 and self.keySetActiveRuid or self.keySetInactiveRuid
    keySet2:SetVisible(true)
    keySet2:SetEnable(true)
  end
end

function MobileActionSlotLogic.updateMobileActionSlotOpacityByScreenPoint(self, screenPoint)
  local scroll = self._T.mobileActionSlotOpacityScroll
  if not ___MOD.isvalid(scroll) or scroll.UITransformComponent == nil then
    return
  end
  local halfRange = self:getMobileActionSlotOpacityHalfRange()
  if halfRange < 0 then
    return
  end
  local scrollTransform = scroll.UITransformComponent
  local localPosition = ___MOD._UILogic:ScreenToLocalUIPosition(screenPoint, scrollTransform)
  local leftX = -halfRange
  local rightX = halfRange
  local cursorX = localPosition.x - scrollTransform.anchoredPosition.x
  local keyX = ___MOD.math.max(leftX, ___MOD.math.min(rightX, cursorX))
  local ratio = rightX ~= leftX and (keyX - leftX) / (rightX - leftX) or 0
  local percent = self.mobileActionSlotOpacityMinPercent + (self.mobileActionSlotOpacityMaxPercent - self.mobileActionSlotOpacityMinPercent) * ratio
  self:setMobileActionSlotOpacityClient(percent, true)
end

function MobileActionSlotLogic.updateMobileActionSlotOpacityControls(self)
  local key = self._T.mobileActionSlotOpacityKey
  local text = self._T.mobileActionSlotOpacityText
  local percent = self:normalizeMobileActionSlotOpacityPercent(self._T.mobileActionSlotOpacityPercent)
  self._T.mobileActionSlotOpacityPercent = percent
  if ___MOD.isvalid(text) and text.TextGUIRendererComponent ~= nil then
    text.TextGUIRendererComponent.Text = ___MOD.string.format("투명도 : %d%%", percent)
  end
  if not ___MOD.isvalid(key) or key.UITransformComponent == nil then
    return
  end
  local halfRange = self:getMobileActionSlotOpacityHalfRange()
  if halfRange < 0 then
    return
  end
  local leftX = -halfRange
  local rightX = halfRange
  local percentRange = self.mobileActionSlotOpacityMaxPercent - self.mobileActionSlotOpacityMinPercent
  local ratio = 0 < percentRange and (percent - self.mobileActionSlotOpacityMinPercent) / percentRange or 0
  key.UITransformComponent.anchoredPosition.x = leftX + (rightX - leftX) * ratio
end

function MobileActionSlotLogic.updateMobileActionSlotToggleSprite(self)
  local toggle = self._T.mobileActionSlotToggle
  if not ___MOD.isvalid(toggle) or toggle.SpriteGUIRendererComponent == nil then
    return
  end
  if self._T.mobileActionSlotToggleHidden == true then
    toggle.SpriteGUIRendererComponent.ImageRUID = self.mobileActionSlotToggleHiddenRuid
  else
    toggle.SpriteGUIRendererComponent.ImageRUID = self.mobileActionSlotToggleVisibleRuid
  end
end

function MobileActionSlotLogic.updateSlotCooldownVisual(self, slotKey)
  local entry = self.localSlotConfig and self.localSlotConfig[slotKey] or nil
  if entry == nil or (___MOD.tonumber(entry.type or 0) or 0) ~= ___MOD._KeyConfigType.SKILL then
    return
  end
  local slotEntity = self._T.mobileActionSlotEntities and self._T.mobileActionSlotEntities[slotKey] or nil
  if not ___MOD.isvalid(slotEntity) then
    return
  end
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) then
    return
  end
  local skillId = ___MOD.tonumber(entry.id or 0) or 0
  local lookupId = self:resolveCooldownLookupId(skillId)
  local cooltimes = player.PlayerVariables and player.PlayerVariables.skillCooltimes or nil
  local coolEnd = cooltimes and (___MOD.tonumber(cooltimes[lookupId]) or ___MOD.tonumber(cooltimes[___MOD.tostring(lookupId)]) or 0) or 0
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local remain = ___MOD.math.max(0, coolEnd - now)
  if remain <= 0 then
    self:clearCooldownVisual(slotKey)
    return
  end
  local gauge = self:ensureCooldownGauge(slotKey)
  local dataTotal = self:getSkillCooldownSec(skillId)
  local total = self:resolveCooldownTotalSec(slotKey, skillId, coolEnd, remain, dataTotal)
  local elapsed = ___MOD.math.max(0, total - remain)
  local ratio = ___MOD.math.max(0, ___MOD.math.min(1, elapsed / ___MOD.math.max(0.001, total)))
  local idx = ___MOD.math.floor(ratio * 15 + 0.5)
  if idx < 0 then
    idx = 0
  end
  if 15 < idx then
    idx = 15
  end
  if ___MOD.isvalid(gauge) then
    gauge:SetVisible(true)
    gauge:SetEnable(true)
    gauge.SpriteGUIRendererComponent.Color = ___MOD.FastColor.white
    gauge.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get(___MOD.string.format("UI.UIWindow.Skill.CoolTime.%d", idx))
  end
  local slotNumber = self:ensureSlotNumberComponent(slotEntity)
  if ___MOD.isvalid(slotNumber) then
    local remainSec = ___MOD.math.ceil(remain)
    slotNumber:updateNumber(remainSec, true)
    self:alignCooldownNumberToIconCenter(slotKey, slotEntity, remainSec)
  end
end
