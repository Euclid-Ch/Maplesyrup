

function PlayerAvatarLookLogic.getAvatarItemCategory(self, itemID)
  local type = itemID // 10000
  local category
  if type == 106 then
    category = ___MOD.MapleAvatarItemCategory.Pants
  elseif type == 103 then
    local subType = itemID // 1000
    if subType == 1032 then
      category = ___MOD.MapleAvatarItemCategory.EarAccessory
    end
  elseif type == 101 then
    category = ___MOD.MapleAvatarItemCategory.FaceAccessory
  elseif type == 102 then
    category = ___MOD.MapleAvatarItemCategory.EyeAccessory
  elseif type == 104 then
    category = ___MOD.MapleAvatarItemCategory.Coat
  elseif type == 108 then
    category = ___MOD.MapleAvatarItemCategory.Glove
  elseif type == 109 then
    category = ___MOD.MapleAvatarItemCategory.SubWeapon
  elseif type == 100 then
    category = ___MOD.MapleAvatarItemCategory.Cap
  elseif type == 110 then
    category = ___MOD.MapleAvatarItemCategory.Cape
  elseif type == 105 then
    category = ___MOD.MapleAvatarItemCategory.Longcoat
  elseif type == 107 then
    category = ___MOD.MapleAvatarItemCategory.Shoes
  elseif type == 134 then
    category = ___MOD.MapleAvatarItemCategory.SubWeapon
  elseif 130 <= type and type <= 149 then
    local weaponType = ___MOD._WeaponType:getWeaponTypeByItemID(itemID)
    if weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD or weaponType == ___MOD._WeaponType.TWO_HANDED_MACE or weaponType == ___MOD._WeaponType.TWO_HANDED_AXE or weaponType == ___MOD._WeaponType.POLEARM or weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.CROSSBOW or weaponType == ___MOD._WeaponType.BOW or weaponType == ___MOD._WeaponType.KNUCKLE or weaponType == ___MOD._WeaponType.GUN or weaponType == ___MOD._WeaponType.CLAW then
      category = ___MOD.MapleAvatarItemCategory.TwoHandedWeapon
    else
      category = ___MOD.MapleAvatarItemCategory.OneHandedWeapon
    end
  elseif type == 170 then
    if ___MOD._EquipManager:isTwoHandedCashWeapon(itemID) then
      category = ___MOD.MapleAvatarItemCategory.TwoHandedWeapon
    else
      category = ___MOD.MapleAvatarItemCategory.OneHandedWeapon
    end
  end
  return category
end

function PlayerAvatarLookLogic.updateLook(self, costume, gender, hair, face, skin, equipment, useMSWCody, userID, blockMSWCody)
  if not costume or not ___MOD.isvalid(costume) then
    return
  end
  if userID == nil or ___MOD.Environment:IsMakerPlay() and costume.Entity ~= ___MOD._UserService.LocalPlayer then
    userID = ""
  end
  local entity = costume.Entity
  local activeEffectItem = entity.ActiveEffectItemComponent
  local shouldRefreshSpectrum = activeEffectItem ~= nil
  shouldRefreshSpectrum = shouldRefreshSpectrum and activeEffectItem.activeItemId > 0 and activeEffectItem.activeEffectData ~= nil and activeEffectItem.activeEffectData.spectrum == true and 0 < #activeEffectItem.spectrumEntities
  if ___MOD.isvalid(entity.Player) then
    ___MOD._EffectManager:updateEquipSetEffect(entity, useMSWCody and not blockMSWCody, hair)
  end
  costume.DefaultEquipUserId = userID
  if useMSWCody and not blockMSWCody then
    costume.UseCustomEquipOnly = false
    for i = 1, 19 do
      local category = ___MOD.MapleAvatarItemCategory.CastFrom(i)
      ___MOD.pcall(function()
        costume:SetEquip(category, "")
      end)
    end
    if shouldRefreshSpectrum then
      activeEffectItem:RefreshSpectrumCostumeWithModeClient(useMSWCody, blockMSWCody)
    end
    return
  end
  costume.UseCustomEquipOnly = true
  local defaultCoat = gender == 0 and "d7ca735739a244b88fc10d140b01b03c" or "51ff3745499944a79402e7bd3d3c4016"
  local defaultPants = gender == 0 and "ef0b8ee74abf47adb54e43426d9166e6" or "829c0b278e094bb0a1100a5e6e8abe4a"
  costume:SetEquip(___MOD.MapleAvatarItemCategory.Hair, ___MOD.__RUIDManager:get(___MOD.tostring(hair)))
  costume:SetEquip(___MOD.MapleAvatarItemCategory.Face, ___MOD.__RUIDManager:get(___MOD.tostring(face)))
  local bodyRuid = ___MOD._PlayerSkinType:getSkinRUID(skin)
  if not ___MOD._UtilLogic:IsNilorEmptyString(bodyRuid) then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Body, bodyRuid)
    costume.CustomBodyEquip = bodyRuid
  end
  for i = 5, 19 do
    local category = ___MOD.MapleAvatarItemCategory.CastFrom(i)
    if i == 7 then
      ___MOD.pcall(function()
        costume:SetEquip(category, defaultCoat)
      end)
    elseif i == 10 then
      ___MOD.pcall(function()
        costume:SetEquip(category, defaultPants)
      end)
    else
      ___MOD.pcall(function()
        costume:SetEquip(category, "")
      end)
    end
  end

  local function setEquip(itemID)
    local category = self:getAvatarItemCategory(itemID)
    if category == nil then
      return
    end
    local ruid = ___MOD.__RUIDManager:get(___MOD.tostring(itemID))
    costume:SetEquip(category, ruid)
    if category == ___MOD.MapleAvatarItemCategory.OneHandedWeapon then
      costume:SetEquip(___MOD.MapleAvatarItemCategory.TwoHandedWeapon, "")
    elseif category == ___MOD.MapleAvatarItemCategory.TwoHandedWeapon then
      costume:SetEquip(___MOD.MapleAvatarItemCategory.OneHandedWeapon, "")
    end
  end

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

  local function applySlot(slotIdx)
    local sticker = getSlotItem(slotIdx, ___MOD._EquipmentSubSlotType.STICKER)
    if sticker ~= nil then
      if sticker.itemId == 1702238 then
        local mainWeapon = getSlotItem(slotIdx, ___MOD._EquipmentSubSlotType.MAIN)
        local mainWeaponItemID = mainWeapon ~= nil and mainWeapon.itemId or 0
        if ___MOD._WeaponType:getWeaponTypeByItemID(mainWeaponItemID) == ___MOD._WeaponType.GUN then
          ___MOD.pcall(function()
            costume:SetEquip(___MOD.MapleAvatarItemCategory.TwoHandedWeapon, "cc33dfdecfe2476c9e86138d51461642")
            costume:SetEquip(___MOD.MapleAvatarItemCategory.OneHandedWeapon, "")
          end)
          return
        end
      end
      ___MOD.pcall(setEquip, sticker.itemId)
      return
    end
    if isDiabledSlot(slotIdx) then
      return
    end
    local main = getSlotItem(slotIdx, ___MOD._EquipmentSubSlotType.MAIN)
    if main ~= nil then
      ___MOD.pcall(setEquip, main.itemId)
      return
    end
  end

  for slotIdx, _ in ___MOD.pairs(equipment) do
    applySlot(slotIdx)
  end
  if shouldRefreshSpectrum then
    activeEffectItem:RefreshSpectrumCostumeWithModeClient(useMSWCody, blockMSWCody)
  end
end

function PlayerAvatarLookLogic.updatePlayerLook(self, user, useMSWCody, blockMSWCody)
  local costume = user.CostumeManagerComponent
  local player = user.Player
  local equipment = user.EquipmentComponent
  if not (___MOD.isvalid(costume) and ___MOD.isvalid(player)) or not ___MOD.isvalid(equipment) then
    ___MOD.log_error("[updateLookFromUserEntity] costume, player, equipmentComponent가 유효하지 않습니다.")
    return
  end
  self:updateLook(costume, player.Gender, player.Hair, player.Face, player.Skin, equipment.equipment, useMSWCody, player.UserId, blockMSWCody)
end
