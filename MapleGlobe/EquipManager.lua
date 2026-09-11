

function EquipManager.applyFixedPotential(self, inventoryEquip)
  if not inventoryEquip then
    return
  end
  local itemId = ___MOD.tonumber(inventoryEquip.itemId) or 0
  if itemId == 1082392 then
    inventoryEquip.potential = 20
    inventoryEquip.po1 = 30070
    inventoryEquip.po2 = 30086
    inventoryEquip.po3 = 30602
  elseif itemId == 1082393 or itemId == 1082394 then
    inventoryEquip.potential = 20
    inventoryEquip.po1 = 30070
    inventoryEquip.po2 = 20086
    inventoryEquip.po3 = 30601
  end
end

function EquipManager.calcEquipItemQuality(self, ieqp)
  if not ieqp then
    return 0
  end
  local itemID = ieqp.itemId
  local eqp = self:getItemById(itemID)
  if not (self:isEquip(itemID) and eqp) or eqp.cash or itemID // 100000 == 19 then
    return 0
  end
  local score = 0
  score = score + (ieqp.incPAD - eqp.incPAD)
  score = score + (ieqp.incMAD - eqp.incMAD)
  score = score + (ieqp.incSTR - eqp.incSTR)
  score = score + (ieqp.incDEX - eqp.incDEX)
  score = score + (ieqp.incINT - eqp.incINT)
  score = score + (ieqp.incLUK - eqp.incLUK)
  score = score + (ieqp.incPDD - eqp.incPDD)
  score = score + (ieqp.incMDD - eqp.incMDD)
  score = score + (ieqp.incACC - eqp.incACC)
  score = score + (ieqp.incEVA - eqp.incEVA)
  score = score + (ieqp.incMHP - eqp.incMHP) / 10
  score = score + (ieqp.incMMP - eqp.incMMP) / 10
  score = score + (ieqp.incSpeed - eqp.incSpeed)
  score = score + (ieqp.incJump - eqp.incJump)
  if 70 <= score then
    return 5
  elseif 55 <= score then
    return 4
  elseif 40 <= score then
    return 3
  elseif 23 <= score then
    return 2
  elseif 6 <= score then
    return 1
  elseif 0 <= score then
    return 0
  else
    return -1
  end
end

function EquipManager.calcMakerSkillDisassembleCost(self, ieqp, makeCost)
  local base = makeCost / 10
  if not ieqp then
    return base
  end
  local quality = self:calcEquipItemQuality(ieqp)
  local rate = 150
  if quality == -1 then
    rate = 100
  elseif quality == 1 then
    rate = 200
  elseif quality == 2 then
    rate = 250
  elseif quality == 3 then
    rate = 300
  elseif quality == 4 then
    rate = 350
  elseif quality == 5 then
    rate = 400
  end
  local cost = base * rate / 100
  cost = cost - cost % 1000
  return cost
end

function EquipManager.canHavePotential(self, itemId)
  if not self:isEquip(itemId) then
    return false
  end
  local equip = self:getItemById(itemId)
  if equip == nil or equip.cash then
    return false
  end
  if itemId ~= 1122013 and (___MOD.tonumber(equip.tuc) or 0) <= 0 then
    return false
  end
  local itemType = itemId // 10000
  return itemType ~= 114 and itemType // 10 ~= 19
end

function EquipManager.getAdditinalCrystalCategoryByItemID(self, itemID)
  if self._T.additinalCrystal == nil then
    self._T.additinalCrystal = {
      [130] = 11,
      [131] = 11,
      [132] = 11,
      [133] = 11,
      [137] = 10,
      [138] = 10,
      [140] = 11,
      [141] = 11,
      [142] = 11,
      [143] = 11,
      [144] = 11,
      [145] = 8,
      [146] = 8,
      [147] = 11,
      [148] = 11,
      [149] = 8
    }
  end
  local type = itemID // 10000
  return self._T.additinalCrystal[type] or -1
end

function EquipManager.getAttackSpeedLabel(self, value)
  return self._T.attackSpeedLabel[value] or "알 수 없음"
end

function EquipManager.getCategoryKoName(self, category)
  return self._T.equipTypeNameMap[category] or "알 수 없음"
end

function EquipManager.getCategoryKoNameById(self, itemId)
  local category = itemId // 10000
  return self._T.equipTypeNameMap[category] or "알 수 없음"
end

function EquipManager.getCategoryNameById(self, itemId)
  local type = itemId // 10000
  local cache = self._T.categoryName
  if cache[type] then
    return cache[type]
  end
  if type == 106 then
    cache[type] = "Pants"
    return "Pants"
  elseif type == 104 then
    cache[type] = "Coat"
    return "Coat"
  elseif type == 108 then
    cache[type] = "Glove"
    return "Glove"
  elseif type == 109 then
    cache[type] = "Shield"
    return "Shield"
  elseif type == 111 then
    cache[type] = "Ring"
    return "Ring"
  elseif type == 100 then
    cache[type] = "Cap"
    return "Cap"
  elseif type == 180 then
    cache[type] = "PetEquip"
    return "PetEquip"
  elseif type == 110 then
    cache[type] = "Cape"
    return "Cape"
  elseif type == 105 then
    cache[type] = "Longcoat"
    return "Longcoat"
  elseif type == 107 then
    cache[type] = "Shoes"
    return "Shoes"
  elseif type == 101 or type == 102 or type == 103 or type == 112 or type == 113 or type == 114 or type == 115 then
    cache[type] = "Accessory"
    return "Accessory"
  elseif 130 <= type and type <= 170 then
    cache[type] = "Weapon"
    return "Weapon"
  elseif type == 190 or type == 191 or type == 193 then
    cache[type] = "TamingMob"
    return "TamingMob"
  elseif self:isDragonEquip(itemId) then
    cache[type] = "Dragon"
    return "Dragon"
  end
end

function EquipManager.getEquipGradeColorAndMaterial(self, ieqp)
  local quality = self:calcEquipItemQuality(ieqp)
  if quality == 5 then
    return self.equipGradeColor[8], "material://6b701222-ea9c-4946-93a2-fc1ddd585c0f", 5
  elseif quality == 4 then
    return self.equipGradeColor[7], "material://4a44ced8-e0ef-407e-bfe7-d569b1da9dbd", 4
  elseif quality == 3 then
    return self.equipGradeColor[6], "material://f546b9f7-2ed1-40bb-88d1-e79f0e7b97fc", 3
  elseif quality == 2 then
    return self.equipGradeColor[5], "material://12854f07-fd10-474b-a01d-c75b68f842d4", 2
  elseif quality == 1 then
    return self.equipGradeColor[4], "material://f14822b7-9041-41ad-9ca5-fd182df05e5d", 1
  elseif quality == 0 then
    if ieqp and 0 < ieqp.uc then
      return self.equipGradeColor[3]
    else
      return self.equipGradeColor[2]
    end
  elseif quality == -1 then
    return self.equipGradeColor[1], nil, 0
  end
end

function EquipManager.getEquipmentSlotIdByItemId(self, itemId)
  local family = itemId // 1000
  if family == 1902 then
    return ___MOD._EquipmentSlotType.TAMINGMOB
  elseif family == 1912 then
    return ___MOD._EquipmentSlotType.SADDLE
  elseif family == 1930 or family == 1931 or family == 1932 or family == 1950 or family == 1951 or family == 1952 then
    return ___MOD._EquipmentSlotType.MOBEQUIP
  end
  local category = itemId // 10000
  return self._T.equipTypeMap[category] or 0
end

function EquipManager.getGrowthEquipMaxEXP(self, itemID, level)
  local ld = self:getLevelUpEquipLevelData(itemID, level)
  return ld and ld.exp or 0
end

function EquipManager.getGrowthEquipMaxLevel(self, itemID)
  local levelUpEquip = self:getLevelUpEquip(itemID)
  if levelUpEquip then
    return levelUpEquip.maxLevel
  end
  return 0
end

function EquipManager.getItemById(self, itemId)
  return self.equipData[itemId] or nil
end

function EquipManager.getLevelUpEquip(self, itemID)
  local equip = self:getItemById(itemID)
  return equip.levelUpEquip
end

function EquipManager.getLevelUpEquipLevelData(self, itemID, level)
  local levelUpEquip = self:getLevelUpEquip(itemID)
  return levelUpEquip.info and levelUpEquip.info[level] or nil
end

function EquipManager.getPotentialGradeStr(self, grade)
  return self._T.gradeStr[grade] or ""
end

function EquipManager.getReqGender(self, itemId)
  return itemId // 1000 % 10
end

function EquipManager.getReqGenderStr(self, itemId)
  local reqGender = self:getReqGender(itemId)
  if reqGender == 0 then
    return "남"
  elseif reqGender == 1 then
    return "여"
  end
end

function EquipManager.getStringCategoryNameById(self, itemId)
  local type = itemId // 10000
  if type == 190 or type == 191 then
    return "Taming"
  end
  return self:getCategoryNameById(itemId)
end

function EquipManager.isBlade(self, itemId)
  local type = itemId // 1000
  if type == 1342 then
    return true
  end
  return false
end

function EquipManager.isDragonEquip(self, itemId)
  local type = itemId // 10000
  return 194 <= type and type <= 197
end

function EquipManager.isEquip(self, itemId)
  if itemId // 1000000 == 1 then
    return true
  end
  return false
end

function EquipManager.isGrowthEquip(self, itemID)
  local equip = self:getItemById(itemID)
  if not equip then
    return false
  end
  return equip.itemLevel > 0
end

function EquipManager.isPotentialChangeBlockedEquip(self, itemId)
  return itemId == 1442031 or itemId == 1442032 or itemId == 1442033 or itemId == 1442034 or itemId == 1082392 or itemId == 1082393 or itemId == 1082394
end

function EquipManager.isTwoHandedCashWeapon(self, itemID)
  if itemID == 1702014 or itemID == 1702021 or itemID == 1702022 or itemID == 1702023 or itemID == 1702026 or itemID == 1702034 or itemID == 1702036 or itemID == 1702039 or itemID == 1702044 or itemID == 1702046 or itemID == 1702056 or itemID == 1702057 or itemID == 1702063 or itemID == 1702064 or itemID == 1702065 or itemID == 1702073 or itemID == 1702074 or itemID == 1702091 or itemID == 1702098 or itemID == 1702107 or itemID == 1702122 or itemID == 1702127 or itemID == 1702147 or itemID == 1702166 or itemID == 1702151 then
    return true
  end
  return false
end

function EquipManager.isWeapon(self, itemID)
  local category = itemID // 10000
  return 130 <= category and category <= 170
end

function EquipManager.loadCashWeaponTypeData(self)
  self.cashWeaponTypeData = {}
  local ds = ___MOD._DataService:GetTable("CashWeaponType")
  if ds == nil then
    return
  end
  local count = ds:GetRowCount()
  local get = ds.GetCell
  for i = 1, count do
    local itemId = ___MOD.tonumber(get(ds, i, 1))
    local data = ___MOD.tostring(get(ds, i, 2) or "")
    data = ___MOD._UtilLogic:Replace(data, "\"", "")
    if itemId ~= nil and 0 < itemId then
      local types = {}
      if data ~= "" then
        for token in ___MOD.string.gmatch(data, "[^,]+") do
          local n = ___MOD.tonumber(token)
          if n ~= nil then
            ___MOD.table.insert(types, n)
          end
        end
      end
      self.cashWeaponTypeData[itemId] = types
    end
  end
end

function EquipManager.loadEquipData(self)
  self:tryMapping()
  self:loadCashWeaponTypeData()
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local dataCache = {}
  local loadWz = {
    Accessory = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Accessory"),
    Cap = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Cap"),
    Cape = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Cape"),
    Coat = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Coat"),
    Glove = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Glove"),
    Longcoat = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Longcoat"),
    Pants = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Pants"),
    PetEquip = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "PetEquip"),
    Ring = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Ring"),
    Shoes = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Shoes"),
    Weapon = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Weapon"),
    Shield = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Shield"),
    Dragon = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "Dragon"),
    TamingMob = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Character_wz", "TamingMob")
  }
  local itemId_, item
  for key, imgs in ___MOD.pairs(loadWz) do
    if ___MOD.type(imgs) == "table" then
      for itemId, data in ___MOD.pairs(imgs) do
        itemId_ = ___MOD.tonumber(___MOD._UtilLogic:Replace(itemId, ".img", ""))
        item = self:loadEquipItemData(itemId_, data)
        dataCache[itemId_] = item
        self.count = self.count + 1
      end
    end
  end
  self.equipData = dataCache
  ___MOD.log(___MOD.string.format("Loaded Character.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end

function EquipManager.loadEquipItemData(self, itemId, data)
  if ___MOD.type(data) ~= "table" then
    return nil
  end
  local equip = ___MOD.Equip()
  equip.itemId = ___MOD.tonumber(itemId)
  equip.canEquippedTypes = {}
  local category = self:getStringCategoryNameById(equip.itemId)
  equip.name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/%s/%d/name", category, equip.itemId))
  equip.desc = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/%s/%d/desc", category, equip.itemId))
  equip.h1 = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/%s/%d/h1", category, equip.itemId))
  if ___MOD.isvalid(data.info) then
    local info = data.info
    equip = self:loadIcon(equip, info)
    equip.avartar = ___MOD.__RUIDManager:get(___MOD.tostring(equip.itemId))
    equip.accountSharable = ___MOD._WzUtils:getBoolean(info.accountSharable, ___MOD._WzUtils:getBoolean(info.accountsharable, false))
    equip.cash = ___MOD._WzUtils:getBoolean(info.cash, false)
    equip.price = ___MOD._WzUtils:getInteger(info.price, 0)
    equip.tradeBlock = ___MOD._WzUtils:getBoolean(info.tradeBlock, false)
    if equip.accountSharable then
      equip.tradeBlock = true
    end
    equip.notSale = ___MOD._WzUtils:getBoolean(info.notSale, false)
    equip.only = ___MOD._WzUtils:getBoolean(info.only, false)
    equip.timeLimited = ___MOD._WzUtils:getBoolean(info.timeLimited, false)
    equip.expireOnLogout = ___MOD._WzUtils:getBoolean(info.expireOnLogout, false)
    equip.notExtend = ___MOD._WzUtils:getBoolean(info.notExtend, false)
    equip.equipTradeBlock = ___MOD._WzUtils:getBoolean(info.equipTradeBlock, false)
    equip.tradeAvailable = ___MOD._WzUtils:getBoolean(info.tradeAvailable, false)
    equip.quest = ___MOD._WzUtils:getBoolean(info.quest, false)
    equip.afterImage = ___MOD.__RUIDManager:get(___MOD._WzUtils:getString(info.afterImage, ""))
    equip.sfx = ___MOD.__RUIDManager:get(___MOD._WzUtils:getString(info.sfx, ""))
    equip.attackSpeed = ___MOD._WzUtils:getInteger(info.attackSpeed, 1)
    equip.stand = ___MOD._WzUtils:getInteger(info.stand, 0)
    equip.walk = ___MOD._WzUtils:getInteger(info.walk, 0)
    equip.reqLevel = ___MOD._WzUtils:getInteger(info.reqLevel, 0)
    equip.reqJob = ___MOD._WzUtils:getInteger(info.reqJob, 0)
    equip.reqSTR = ___MOD._WzUtils:getInteger(info.reqSTR, 0)
    equip.reqDEX = ___MOD._WzUtils:getInteger(info.reqDEX, 0)
    equip.reqINT = ___MOD._WzUtils:getInteger(info.reqINT, 0)
    equip.reqLUK = ___MOD._WzUtils:getInteger(info.reqLUK, 0)
    equip.reqPOP = ___MOD._WzUtils:getInteger(info.reqPOP, 0)
    equip.tuc = ___MOD._WzUtils:getInteger(info.tuc, 0)
    equip.incSTR = ___MOD._WzUtils:getInteger(info.incSTR, 0)
    equip.incDEX = ___MOD._WzUtils:getInteger(info.incDEX, 0)
    equip.incINT = ___MOD._WzUtils:getInteger(info.incINT, 0)
    equip.incLUK = ___MOD._WzUtils:getInteger(info.incLUK, 0)
    equip.incMHP = ___MOD._WzUtils:getInteger(info.incMHP, 0)
    equip.incMMP = ___MOD._WzUtils:getInteger(info.incMMP, 0)
    equip.incMHPr = ___MOD._WzUtils:getInteger(info.incMHPr, 0)
    equip.incMMPr = ___MOD._WzUtils:getInteger(info.incMMPr, 0)
    equip.incPAD = ___MOD._WzUtils:getInteger(info.incPAD, 0)
    equip.incMAD = ___MOD._WzUtils:getInteger(info.incMAD, 0)
    equip.incPDD = ___MOD._WzUtils:getInteger(info.incPDD, 0)
    equip.incMDD = ___MOD._WzUtils:getInteger(info.incMDD, 0)
    equip.incACC = ___MOD._WzUtils:getInteger(info.incACC, 0)
    equip.incEVA = ___MOD._WzUtils:getInteger(info.incEVA, 0)
    equip.incCraft = ___MOD._WzUtils:getInteger(info.incCraft, 0)
    equip.incSpeed = ___MOD._WzUtils:getInteger(info.incSpeed, 0)
    equip.incJump = ___MOD._WzUtils:getInteger(info.incJump, 0)
    equip.slotMax = ___MOD._WzUtils:getInteger(info.slotMax, 1)
    equip.fs = ___MOD._WzUtils:getInteger(info.fs, 0)
    equip.chatBalloon = ___MOD._WzUtils:getInteger(info.chatBalloon, 0)
    equip.nameTag = ___MOD._WzUtils:getInteger(info.nameTag, 0)
    equip.medalTag = ___MOD._WzUtils:getInteger(info.medalTag, -1)
    equip.knockback = ___MOD._WzUtils:getInteger(info.knockback, 0)
    local levelNode = info.level
    if levelNode then
      local lvInfoNode = levelNode.info
      local lvInfo = ___MOD.LevelUpEquip()
      if lvInfoNode then
        for lvStr, ldTbl in ___MOD.pairs(lvInfoNode) do
          local lv = ___MOD.tonumber(lvStr)
          if lv then
            local ld = ___MOD.LevelUpEquipLevelData()
            ld.exp = ___MOD._WzUtils:getInteger(ldTbl.exp, 0)
            ld.incSTRMax = ___MOD._WzUtils:getInteger(ldTbl.incSTRMax, 0)
            ld.incSTRMin = ___MOD._WzUtils:getInteger(ldTbl.incSTRMin, 0)
            ld.incDEXMax = ___MOD._WzUtils:getInteger(ldTbl.incDEXMax, 0)
            ld.incDEXMin = ___MOD._WzUtils:getInteger(ldTbl.incDEXMin, 0)
            ld.incINTMax = ___MOD._WzUtils:getInteger(ldTbl.incINTMax, 0)
            ld.incINTMin = ___MOD._WzUtils:getInteger(ldTbl.incINTMin, 0)
            ld.incLUKMax = ___MOD._WzUtils:getInteger(ldTbl.incLUKMax, 0)
            ld.incLUKMin = ___MOD._WzUtils:getInteger(ldTbl.incLUKMin, 0)
            ld.incPADMax = ___MOD._WzUtils:getInteger(ldTbl.incPADMax, 0)
            ld.incPADMin = ___MOD._WzUtils:getInteger(ldTbl.incPADMin, 0)
            ld.incMADMax = ___MOD._WzUtils:getInteger(ldTbl.incMADMax, 0)
            ld.incMADMin = ___MOD._WzUtils:getInteger(ldTbl.incMADMin, 0)
            ld.incPDDMax = ___MOD._WzUtils:getInteger(ldTbl.incPDDMax, 0)
            ld.incPDDMin = ___MOD._WzUtils:getInteger(ldTbl.incPDDMin, 0)
            ld.incMDDMax = ___MOD._WzUtils:getInteger(ldTbl.incMDDMax, 0)
            ld.incMDDMin = ___MOD._WzUtils:getInteger(ldTbl.incMDDMin, 0)
            ld.incMHPMax = ___MOD._WzUtils:getInteger(ldTbl.incMHPMax, 0)
            ld.incMHPMin = ___MOD._WzUtils:getInteger(ldTbl.incMHPMin, 0)
            ld.incMMPMax = ___MOD._WzUtils:getInteger(ldTbl.incMMPMax, 0)
            ld.incMMPMin = ___MOD._WzUtils:getInteger(ldTbl.incMMPMin, 0)
            ld.incEVAMax = ___MOD._WzUtils:getInteger(ldTbl.incEVAMax, 0)
            ld.incEVAMin = ___MOD._WzUtils:getInteger(ldTbl.incEVAMin, 0)
            ld.incJumpMax = ___MOD._WzUtils:getInteger(ldTbl.incJumpMax, 0)
            ld.incJumpMin = ___MOD._WzUtils:getInteger(ldTbl.incJumpMin, 0)
            ld.incSpeedMax = ___MOD._WzUtils:getInteger(ldTbl.incSpeedMax, 0)
            ld.incSpeedMin = ___MOD._WzUtils:getInteger(ldTbl.incSpeedMin, 0)
            lvInfo:addLevelData(lv, ld)
          end
        end
      end
      local lvCaseNode = levelNode.case
      if lvCaseNode then
      end
      equip.levelUpEquip = lvInfo
      equip.itemLevel = 1
    end
  end
  local equipCategory = equip.itemId and equip.itemId // 10000 or 0
  if equipCategory == 180 then
    local petEquip = equip.petEquip
    for nodeName, node in ___MOD.pairs(data) do
      local petID = ___MOD.tonumber(nodeName) or nil
      if petID ~= nil then
        if petEquip == nil then
          equip.petEquip = {}
          petEquip = equip.petEquip
        end
        petEquip[petID] = {}
        local petAnimation = petEquip[petID]
        for stateKey, state in ___MOD.pairs(node) do
          petAnimation[stateKey] = ___MOD._WzUtils:parseAnimation(state)
        end
      end
    end
  end
  if equipCategory == 170 then
    local cachedTypes = self.cashWeaponTypeData[equip.itemId]
    if ___MOD.type(cachedTypes) == "table" then
      for _, n in ___MOD.ipairs(cachedTypes) do
        ___MOD.table.insert(equip.canEquippedTypes, n)
      end
    end
    ___MOD.table.sort(equip.canEquippedTypes, function(a, b)
      return a < b
    end)
  end
  return equip
end

function EquipManager.loadIcon(self, equip, info)
  if ___MOD.isvalid(info.icon) and self:IsClient() then
    local fastVecotr2 = ___MOD.FastVector2.zero:Clone()
    local tempicon = info.icon
    equip.icon = ___MOD.__RUIDManager:get(tempicon.image)
    equip.iconSize = ___MOD.FastVector2(tempicon._width * 2, tempicon._height * 2)
    fastVecotr2 = ___MOD._WzUtils:getFastVector(tempicon.origin, ___MOD.FastVector2.zero:Clone())
    equip.iconOrigin = fastVecotr2 * 2
  else
    equip.icon = ""
    equip.iconSize = ___MOD.FastVector2.zero:Clone()
    equip.iconOrigin = ___MOD.FastVector2.zero:Clone()
  end
  if ___MOD.isvalid(info.iconRaw) and self:IsClient() then
    local fastVecotr2 = ___MOD.FastVector2.zero:Clone()
    local tempiconRaw = info.iconRaw
    equip.iconRaw = ___MOD.__RUIDManager:get(tempiconRaw.image)
    equip.iconRawSize = ___MOD.FastVector2(tempiconRaw._width * 2, tempiconRaw._height * 2)
    fastVecotr2 = ___MOD._WzUtils:getFastVector(tempiconRaw.origin, ___MOD.FastVector2.zero:Clone())
    equip.iconRawOrigin = fastVecotr2 * 2
  else
    equip.iconRaw = ""
    equip.iconRawSize = ___MOD.FastVector2.zero:Clone()
    equip.iconRawOrigin = ___MOD.FastVector2.zero:Clone()
  end
  return equip
end

function EquipManager.tryMapping(self)
  local to = self.equipGradeColor
  to[1] = ___MOD.Color.FromHexCode("#BFC1B6")
  to[2] = ___MOD.FastColor.white
  to[3] = ___MOD.Color.FromHexCode("#DE905F")
  to[4] = ___MOD.Color.FromHexCode("#72A7F8")
  to[5] = ___MOD.Color.FromHexCode("#C46EFF")
  to[6] = ___MOD.Color.FromHexCode("#FFFF46")
  to[7] = ___MOD.Color.FromHexCode("#87FB44")
  to[8] = ___MOD.Color.FromHexCode("#E23276")
  self._T.equipTypeNameMap = {
    [100] = "모자",
    [101] = "얼굴장식",
    [102] = "눈장식",
    [103] = "귀고리",
    [104] = "상의",
    [105] = "한벌옷",
    [106] = "하의",
    [107] = "신발",
    [108] = "장갑",
    [109] = "방패",
    [110] = "망토",
    [111] = "반지",
    [112] = "펜던트",
    [113] = "벨트",
    [114] = "훈장",
    [115] = "어깨장식",
    [116] = "포켓아이템",
    [117] = "휘장",
    [118] = "엠블렘",
    [119] = "기계심장",
    [130] = "한손검",
    [131] = "한손도끼",
    [132] = "한손둔기",
    [133] = "단검",
    [134] = "블레이드",
    [136] = "부채",
    [137] = "완드",
    [138] = "스태프",
    [139] = "ESP리미터",
    [140] = "두손검",
    [141] = "두손도끼",
    [142] = "두손둔기",
    [143] = "창",
    [144] = "폴암",
    [145] = "활",
    [146] = "석궁",
    [147] = "아대",
    [148] = "너클",
    [149] = "건",
    [170] = "캐시무기",
    [180] = "펫장비",
    [181] = "펫장비(눈/귀)",
    [182] = "펫무기",
    [183] = "안드로이드",
    [190] = "길들인 몬스터",
    [191] = "안장",
    [194] = "드래곤 모자",
    [195] = "드래곤 펜던트",
    [196] = "드래곤 날개장식",
    [197] = "드래곤 꼬리장식",
    [425] = "강화보석",
    [400] = "기타",
    [200] = "소비"
  }
  self._T.attackSpeedLabel = {
    [9] = "매우 느림",
    [8] = "느림",
    [7] = "느림",
    [6] = "보통",
    [5] = "빠름",
    [4] = "빠름",
    [3] = "매우 빠름",
    [2] = "매우 빠름",
    [1] = "매우 빠름"
  }
  self._T.equipTypeMap = {
    [100] = 1,
    [101] = 3,
    [102] = 6,
    [103] = 7,
    [104] = 10,
    [105] = 10,
    [106] = 15,
    [107] = 19,
    [108] = 14,
    [109] = 13,
    [110] = 9,
    [111] = 4,
    [112] = 11,
    [113] = 16,
    [114] = 2,
    [115] = 8,
    [130] = 12,
    [131] = 12,
    [132] = 12,
    [133] = 12,
    [134] = 12,
    [136] = 12,
    [137] = 12,
    [138] = 12,
    [139] = 12,
    [140] = 12,
    [141] = 12,
    [142] = 12,
    [143] = 12,
    [144] = 12,
    [145] = 12,
    [146] = 12,
    [147] = 12,
    [148] = 12,
    [149] = 12,
    [170] = 12,
    [134] = 13,
    [180] = 22,
    [190] = 23,
    [191] = 24,
    [193] = 25
  }
  self._T.gradeStr = {
    [17] = "미확인",
    [18] = "레어",
    [19] = "에픽",
    [20] = "유니크"
  }
  self._T.categoryName = {}
end
