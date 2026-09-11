

function Surgery.applyRandomSurgery(self, player, udc, scriptName, mode, itemList)

end

function Surgery.applySelectedSurgery(self, selectedIndex, mode, scriptName, senderUserId)

end

function Surgery.applySelectedSurgeryLookClient(self, targetUser, itemId, mode)
  if not ___MOD.isvalid(targetUser) or targetUser.Player == nil then
    return
  end
  local selectedRuid = ___MOD.__RUIDManager:get(___MOD.tostring(itemId))
  if targetUser == ___MOD._UserService.LocalPlayer then
    if mode == "style" or mode == "color" or mode == "special" then
      targetUser.Player.Hair = itemId
      if targetUser.CostumeManagerComponent ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(selectedRuid) then
        targetUser.CostumeManagerComponent:SetEquip(___MOD.MapleAvatarItemCategory.Hair, selectedRuid)
        ___MOD.pcall(function()
          targetUser.CostumeManagerComponent.CustomHairEquip = selectedRuid
        end)
      end
    elseif mode == "face" then
      targetUser.Player.Face = itemId
      if targetUser.CostumeManagerComponent ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(selectedRuid) then
        targetUser.CostumeManagerComponent:SetEquip(___MOD.MapleAvatarItemCategory.Face, selectedRuid)
        ___MOD.pcall(function()
          targetUser.CostumeManagerComponent.CustomFaceEquip = selectedRuid
        end)
      end
    elseif mode == "skin" then
      targetUser.Player.Skin = itemId
      if targetUser.CostumeManagerComponent ~= nil then
        local bodyRuid = self:getSkinBodyRuid(itemId)
        if not ___MOD._UtilLogic:IsNilorEmptyString(bodyRuid) then
          targetUser.CostumeManagerComponent:SetEquip(___MOD.MapleAvatarItemCategory.Body, bodyRuid)
          targetUser.CostumeManagerComponent.CustomBodyEquip = bodyRuid
        end
      end
    end
    local equipment = targetUser.EquipmentComponent
    if equipment then
      local player = targetUser.Player
      equipment:updateLookClient(player.Gender, player.Hair, player.Face, player.Skin, player.MSWCody)
      return
    end
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  local blockMSWCody = false
  if ___MOD.isvalid(localPlayer) and localPlayer.Player ~= nil then
    blockMSWCody = localPlayer.Player:getBlockMSWCody(targetUser.Player.PlayerId)
  end
  ___MOD._PlayerAvatarLookLogic:updatePlayerLook(targetUser, targetUser.Player.MSWCody, blockMSWCody)
end

function Surgery.applySelectedSurgeryToPreviewClient(self)
  if not self:ensureSurgeryUIClient() then
    return
  end
  local preview = self._T.surgeryAvatar
  local itemList = self._T.surgeryItemList or {}
  local selectedIndex = ___MOD.tonumber(self._T.surgerySelectedIndex) or 1
  local mode = ___MOD.tostring(self._T.surgeryMode or "")
  if not ___MOD.isvalid(preview) or preview.CostumeManagerComponent == nil then
    return
  end
  if #itemList <= 0 then
    return
  end
  local selectedItemId = ___MOD.tonumber(itemList[selectedIndex]) or 0
  local selectedRuid = ___MOD.__RUIDManager:get(___MOD.tostring(selectedItemId))
  local costume = preview.CostumeManagerComponent
  if mode == "hair" or mode == "style" or mode == "color" then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Hair, selectedRuid)
    ___MOD.pcall(function()
      costume.CustomHairEquip = selectedRuid
    end)
  elseif mode == "face" then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Face, selectedRuid)
    ___MOD.pcall(function()
      costume.CustomFaceEquip = selectedRuid
    end)
  elseif mode == "skin" then
    local bodyRuid = self:getSkinBodyRuid(selectedItemId)
    if not ___MOD._UtilLogic:IsNilorEmptyString(bodyRuid) then
      costume:SetEquip(___MOD.MapleAvatarItemCategory.Body, bodyRuid)
      costume.CustomBodyEquip = bodyRuid
    end
  end
end

function Surgery.applySurgeryItemServer(self, user, itemId, mode, scriptName)

end

function Surgery.applySurgeryTakeoffPreviewClient(self, costume, user)
  if not (costume ~= nil and ___MOD.isvalid(costume) and ___MOD.isvalid(user)) or user.Player == nil then
    return
  end
  local gender = user.Player.Gender
  local defaultCoat = gender == 0 and "d7ca735739a244b88fc10d140b01b03c" or "51ff3745499944a79402e7bd3d3c4016"
  local defaultPants = gender == 0 and "ef0b8ee74abf47adb54e43426d9166e6" or "829c0b278e094bb0a1100a5e6e8abe4a"
  costume.UseCustomEquipOnly = true
  for slot = 1, 19 do
    costume:SetEquip(slot, "")
  end
  local hairRuid = ___MOD.__RUIDManager:get(___MOD.tostring(user.Player.Hair))
  local faceRuid = ___MOD.__RUIDManager:get(___MOD.tostring(user.Player.Face))
  local bodyRuid = self:getSkinBodyRuid(user.Player.Skin)
  if not ___MOD._UtilLogic:IsNilorEmptyString(hairRuid) then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Hair, hairRuid)
    ___MOD.pcall(function()
      costume.CustomHairEquip = hairRuid
    end)
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(faceRuid) then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Face, faceRuid)
    ___MOD.pcall(function()
      costume.CustomFaceEquip = faceRuid
    end)
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(bodyRuid) then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Body, bodyRuid)
    costume.CustomBodyEquip = bodyRuid
  end
  costume:SetEquip(___MOD.MapleAvatarItemCategory.Coat, defaultCoat)
  costume:SetEquip(___MOD.MapleAvatarItemCategory.Pants, defaultPants)
end

function Surgery.buildFaceList(self, player, config)

end

function Surgery.buildHairColorList(self, player, config)

end

function Surgery.buildHairStyleList(self, player, config)

end

function Surgery.buildSkinList(self, config)

end

function Surgery.buildSurgeryItemList(self, player, scriptName, mode)

end

function Surgery.cacheScriptFunc(self)

end

function Surgery.clearSurgerySession(self, player)

end

function Surgery.closeSurgeryUIClient(self)
  if self:ensureSurgeryUIClient() and ___MOD.isvalid(self._T.surgeryRoot) then
    self._T.surgeryRoot:SetEnable(false)
  end
end

function Surgery.ensureSurgeryUIClient(self)
  if self._T.surgeryUIBound == true then
    return ___MOD.isvalid(self._T.surgeryRoot)
  end
  local root = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar")
  if not ___MOD.isvalid(root) then
    ___MOD.log_error("[Surgery] UtilDlgEx_Avatar UI를 찾을 수 없습니다.")
    return false
  end
  self._T.surgeryRoot = root
  self._T.surgeryAvatar = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/avatar")
  self._T.surgeryNameText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/Name")
  self._T.surgeryDescText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/Text")
  self._T.surgeryNpc = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/npc")
  self._T.surgeryNpcAni = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/npc/ani")
  self._T.surgeryBtPrev = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/BtPrev")
  self._T.surgeryBtNext = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/BtNext")
  self._T.surgeryBtTakeoff = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/BtTakeoff")
  self._T.surgeryBtOk = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/BtOk")
  self._T.surgeryBtCancel = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/BtCancel")
  self._T.surgeryBtOut = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UtilDlgEx_Avatar/BtOut")
  if ___MOD.isvalid(self._T.surgeryBtPrev) then
    self._T.surgeryBtPrevEvent = self._T.surgeryBtPrev:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickSurgeryPrevClient()
    end)
  end
  if ___MOD.isvalid(self._T.surgeryBtNext) then
    self._T.surgeryBtNextEvent = self._T.surgeryBtNext:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickSurgeryNextClient()
    end)
  end
  if ___MOD.isvalid(self._T.surgeryBtTakeoff) then
    self._T.surgeryBtTakeoffEvent = self._T.surgeryBtTakeoff:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickSurgeryTakeoffClient()
    end)
  end
  if ___MOD.isvalid(self._T.surgeryBtOk) then
    self._T.surgeryBtOkEvent = self._T.surgeryBtOk:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickSurgeryOkClient()
    end)
  end
  if ___MOD.isvalid(self._T.surgeryBtCancel) then
    self._T.surgeryBtCancelEvent = self._T.surgeryBtCancel:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:closeSurgeryUIClient()
    end)
  end
  if ___MOD.isvalid(self._T.surgeryBtOut) then
    self._T.surgeryBtOutEvent = self._T.surgeryBtOut:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:closeSurgeryUIClient()
    end)
  end
  self._T.surgeryUIBound = true
  root:SetEnable(false)
  return true
end

function Surgery.excludeCurrentSurgeryItems(self, player, mode, itemList)

end

function Surgery.filterAvailableSurgeryItems(self, category, itemList)

end

function Surgery.getSkinBodyRuid(self, skin)
  local skinRuid = ___MOD._PlayerSkinType:getSkinRUID(skin)
  if ___MOD._UtilLogic:IsNilorEmptyString(skinRuid) then
    return ""
  end
  local mappedRuid = ___MOD.__RUIDManager:get(skinRuid)
  if not ___MOD._UtilLogic:IsNilorEmptyString(mappedRuid) then
    return mappedRuid
  end
  return skinRuid
end

function Surgery.getSurgeryConfig(self, scriptName)

end

function Surgery.getSurgeryCouponItemId(self, scriptName, mode)

end

function Surgery.getSurgeryCurrentItemId(self, player, mode)

end

function Surgery.getSurgeryDescription(self, scriptName, mode)

end

function Surgery.getSurgeryItemNameClient(self, mode, itemId)
  local key
  if mode == "hair" or mode == "style" or mode == "color" then
    key = ___MOD.string.format("Eqp.img/Eqp/Hair/%d/name", itemId)
  elseif mode == "face" then
    key = ___MOD.string.format("Eqp.img/Eqp/Face/%d/name", itemId)
  elseif mode == "skin" then
    return ___MOD.string.format("피부 %d", itemId)
  end
  local name = key ~= nil and ___MOD._StringPoolManager:getStringPool(key) or ""
  if ___MOD._UtilLogic:IsNilorEmptyString(name) then
    name = ___MOD.tostring(itemId)
  end
  return ___MOD.tostring(name)
end

function Surgery.getSurgeryLackCouponMessage(self, scriptName, mode)

end

function Surgery.getSurgerySession(self, player)

end

function Surgery.getSurgerySuccessMessage(self, scriptName, mode)

end

function Surgery.isCurrentSurgeryItem(self, player, mode, itemId)

end

function Surgery.isSurgeryItemAvailable(self, category, itemId)

end

function Surgery.onClickSurgeryNextClient(self)
  local itemList = self._T.surgeryItemList or {}
  if #itemList <= 0 then
    return
  end
  self._T.surgerySelectedIndex = (___MOD.tonumber(self._T.surgerySelectedIndex) or 1) + 1
  self:refreshSurgeryPreviewClient()
end

function Surgery.onClickSurgeryOkClient(self)
  local selectedIndex = ___MOD.tonumber(self._T.surgerySelectedIndex) or 1
  if selectedIndex <= 0 then
    return
  end
  self:applySelectedSurgery(selectedIndex, ___MOD.tostring(self._T.surgeryMode or ""), ___MOD.tostring(self._T.surgeryScriptName or ""))
end

function Surgery.onClickSurgeryPrevClient(self)
  local itemList = self._T.surgeryItemList or {}
  if #itemList <= 0 then
    return
  end
  self._T.surgerySelectedIndex = (___MOD.tonumber(self._T.surgerySelectedIndex) or 1) - 1
  self:refreshSurgeryPreviewClient()
end

function Surgery.onClickSurgeryTakeoffClient(self)
  self._T.surgeryTakeoff = self._T.surgeryTakeoff ~= true
  self:rebuildSurgeryPreviewBaseClient()
  self:refreshSurgeryPreviewClient()
end

function Surgery.openSurgerySelectUI(self, player, udc, scriptName, mode, itemList)

end

function Surgery.openSurgeryUIClient(self, scriptName, mode, itemList, description, npcId)
  if not self:ensureSurgeryUIClient() then
    return
  end
  local copiedList = {}
  for _, itemId in ___MOD.ipairs(itemList or {}) do
    copiedList[#copiedList + 1] = ___MOD.tonumber(itemId) or 0
  end
  self._T.surgeryScriptName = ___MOD.tostring(scriptName or "")
  self._T.surgeryMode = ___MOD.tostring(mode or "")
  self._T.surgeryItemList = copiedList
  self._T.surgerySelectedIndex = 1
  self._T.surgeryTakeoff = ___MOD.tostring(mode or "") == "skin"
  self._T.surgeryDescription = ___MOD.tostring(description or "")
  self._T.surgeryNpcId = ___MOD.tonumber(npcId) or 0
  self._T.surgeryRoot:SetEnable(true)
  self:refreshSurgeryNpcClient()
  self:rebuildSurgeryPreviewBaseClient()
  self:refreshSurgeryPreviewClient()
end

function Surgery.rebuildSurgeryPreviewBaseClient(self)
  if not self:ensureSurgeryUIClient() then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  local preview = self._T.surgeryAvatar
  if not ___MOD.isvalid(user) or user.Player == nil or user.EquipmentComponent == nil then
    return
  end
  if not ___MOD.isvalid(preview) or preview.CostumeManagerComponent == nil then
    return
  end
  local costume = preview.CostumeManagerComponent
  costume.UseCustomEquipOnly = true
  for slot = 1, 19 do
    costume:SetEquip(slot, "")
  end
  local gender = user.Player.Gender
  local defaultCoat = gender == 0 and "d7ca735739a244b88fc10d140b01b03c" or "51ff3745499944a79402e7bd3d3c4016"
  local defaultPants = gender == 0 and "ef0b8ee74abf47adb54e43426d9166e6" or "829c0b278e094bb0a1100a5e6e8abe4a"
  local hairRuid = ___MOD.__RUIDManager:get(___MOD.tostring(user.Player.Hair))
  local faceRuid = ___MOD.__RUIDManager:get(___MOD.tostring(user.Player.Face))
  local bodyRuid = self:getSkinBodyRuid(user.Player.Skin)
  if not ___MOD._UtilLogic:IsNilorEmptyString(hairRuid) then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Hair, hairRuid)
    ___MOD.pcall(function()
      costume.CustomHairEquip = hairRuid
    end)
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(faceRuid) then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Face, faceRuid)
    ___MOD.pcall(function()
      costume.CustomFaceEquip = faceRuid
    end)
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(bodyRuid) then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Body, bodyRuid)
    costume.CustomBodyEquip = bodyRuid
  end
  costume:SetEquip(___MOD.MapleAvatarItemCategory.Coat, defaultCoat)
  costume:SetEquip(___MOD.MapleAvatarItemCategory.Pants, defaultPants)
  if self._T.surgeryTakeoff == true then
    self:applySurgeryTakeoffPreviewClient(costume, user)
  end
end

function Surgery.refreshSurgeryLookClient(self, targetUser)
  if not ___MOD.isvalid(targetUser) or targetUser.Player == nil then
    return
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  local blockMSWCody = false
  if ___MOD.isvalid(localPlayer) and localPlayer.Player ~= nil then
    blockMSWCody = localPlayer.Player:getBlockMSWCody(targetUser.Player.PlayerId)
  end
  ___MOD._PlayerAvatarLookLogic:updatePlayerLook(targetUser, targetUser.Player.MSWCody, blockMSWCody)
end

function Surgery.refreshSurgeryLookForMap(self, targetUser)

end

function Surgery.refreshSurgeryNpcClient(self)
  if not self:ensureSurgeryUIClient() then
    return
  end
  local npcId = ___MOD.tonumber(self._T.surgeryNpcId) or 0
  if ___MOD.isvalid(self._T.surgeryNpc) then
    self._T.surgeryNpc.Visible = 0 < npcId
  end
  if not ___MOD.isvalid(self._T.surgeryNpcAni) or self._T.surgeryNpcAni.AnimationSpriteComponent == nil then
    return
  end
  if npcId <= 0 then
    self._T.surgeryNpcAni.Visible = false
    return
  end
  local npcClip = ___MOD._NpcManager:getNpcAction(npcId, "stand")
  if npcClip == nil or npcClip.anim == nil then
    npcClip = ___MOD._NpcManager:getNpcDefaultAction(npcId)
  end
  if npcClip == nil or npcClip.anim == nil then
    self._T.surgeryNpcAni.Visible = false
    return
  end
  self._T.surgeryNpcAni.Visible = true
  self._T.surgeryNpcAni.AnimationSpriteComponent:changeScale(2)
  self._T.surgeryNpcAni.AnimationSpriteComponent:setLeftFacing(false)
  self._T.surgeryNpcAni.AnimationSpriteComponent:setWzSprite(npcClip, false)
end

function Surgery.refreshSurgeryPreviewClient(self)
  if not self:ensureSurgeryUIClient() then
    return
  end
  local itemList = self._T.surgeryItemList or {}
  local selectedIndex = ___MOD.tonumber(self._T.surgerySelectedIndex) or 1
  local mode = ___MOD.tostring(self._T.surgeryMode or "")
  if #itemList <= 0 then
    return
  end
  if selectedIndex < 1 then
    selectedIndex = #itemList
  elseif selectedIndex > #itemList then
    selectedIndex = 1
  end
  self._T.surgerySelectedIndex = selectedIndex
  local selectedItemId = ___MOD.tonumber(itemList[selectedIndex]) or 0
  self:applySelectedSurgeryToPreviewClient()
  self:setSurgeryTextClient(self._T.surgeryNameText, self:getSurgeryItemNameClient(mode, selectedItemId))
  self:setSurgeryTextClient(self._T.surgeryDescText, ___MOD.tostring(self._T.surgeryDescription or ""))
end

function Surgery.saveSurgerySession(self, player, scriptName, mode, itemList)

end

function Surgery.setSurgeryTextClient(self, target, text)
  if not ___MOD.isvalid(target) then
    return
  end
  local finalText = ___MOD.tostring(text or "")
  if target.BitmapFontRendererComponent then
    target.BitmapFontRendererComponent.text = finalText
    target.BitmapFontRendererComponent:drawText()
  end
end

function Surgery.Surgery(self, player, udc, scriptName)

end
