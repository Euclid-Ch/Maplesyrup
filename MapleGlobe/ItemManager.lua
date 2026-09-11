

function ItemManager.buildPotentialCache(self, itemOption_img)
  local cache = {}
  for i = 0, 4 do
    cache[i] = {}
  end
  local cache2 = {}
  local id, info, p
  for name, node in ___MOD.pairs(itemOption_img) do
    id = ___MOD.tonumber(name)
    if id ~= nil then
      cache2[id] = {}
      p = cache2[id]
      if node.info then
        info = node.info
        p.weight = ___MOD._WzUtils:getInteger(info.weight, 0)
        p.string = ___MOD._WzUtils:getString(info.string, "")
        p.optionType = ___MOD._WzUtils:getInteger(info.optionType, 0)
        p.reqLevel = ___MOD._WzUtils:getInteger(info.reqLevel, 0)
      end
      p.level = {}
      for lv, d in ___MOD.pairs(node.level) do
        lv = ___MOD.tonumber(lv)
        if lv ~= nil then
          p.level[lv] = d
        end
      end
      cache[id // 10000][id] = p
    end
  end
  return cache
end

function ItemManager.checkScrollValid(self, scrollId, targetItemId)
  if scrollId // 10000 ~= 204 then
    return false
  end
  local scrollType = scrollId // 100 % 100
  local targetType = targetItemId // 10000 % 100
  if scrollType == 1 then
    return false
  elseif scrollType == 2 then
    return false
  elseif scrollType == 0 or 3 <= scrollType and scrollType <= 13 or 30 <= scrollType and scrollType <= 49 or scrollType == 80 then
    return targetType == scrollType
  elseif scrollType == 61 then
    return 30 <= targetType and targetType <= 38
  elseif scrollType == 62 then
    return targetType == 0 or 4 <= targetType and targetType <= 10
  elseif scrollType == 63 then
    return 1 <= targetType and targetType <= 3 or 12 <= targetType and targetType <= 15
  elseif scrollType == 70 then
    return false
  elseif scrollType == 71 then
    return false
  elseif scrollType == 72 then
    return false
  elseif scrollType == 73 then
    return false
  elseif scrollType == 90 then
    return true
  elseif scrollType == 91 then
    return true
  elseif scrollType == 92 then
    return 11 <= targetType and targetType <= 13
  elseif scrollType == 94 then
    return targetType ~= 14
  end
end

function ItemManager.copyIconData(self, to, from)
  to.icon = from.icon
  to.iconSize = from.iconSize
  to.iconOrigin = from.iconOrigin
  to.iconRaw = from.iconRaw
  to.iconRawSize = from.iconRawSize
  to.iconRawOrigin = from.iconRawOrigin
  to.iconD = from.iconD
  to.iconDSize = from.iconDSize
  to.iconDOrigin = from.iconDOrigin
  to.iconRawD = from.iconRawD
  to.iconRawDSize = from.iconRawDSize
  to.iconRawDOrigin = from.iconRawDOrigin
  to.action = from.action
  to.bullet = from.bullet
  to.effect = from.effect
  to.effect2 = from.effect2
  to.hit = from.hit
  to.activeEffect = from.activeEffect
end

function ItemManager.dumpPotentialInfoStrings(self)
  if self.potential == nil then
    return
  end
  for grade = 0, 4 do
    local potGradeTbl = self.potential[grade]
    if ___MOD.type(potGradeTbl) == "table" then
      local ids = {}
      for pId, _ in ___MOD.pairs(potGradeTbl) do
        ids[#ids + 1] = pId
      end
      ___MOD.table.sort(ids)
      for _, pId in ___MOD.ipairs(ids) do
        local p = potGradeTbl[pId]
        local str = ""
        local weight = 0
        local optionType = 0
        local reqLevel = 0
        if ___MOD.type(p) == "table" then
          str = p.string or ""
          weight = ___MOD.tonumber(p.weight) or 0
          optionType = ___MOD.tonumber(p.optionType) or 0
          reqLevel = ___MOD.tonumber(p.reqLevel) or 0
        end
      end
    else
      ___MOD.log(___MOD.string.format("[PotentialDump] grade=%d count=0", grade))
    end
  end
end

function ItemManager.dumpPotentialInfoStringsInRange(self, minGrade, maxGrade)
  if self.potential == nil then
    return
  end
  if maxGrade < minGrade then
    local temp = minGrade
    minGrade = maxGrade
    maxGrade = temp
  end
  for grade = minGrade, maxGrade do
    local potGradeTbl = self.potential[grade]
    if ___MOD.type(potGradeTbl) == "table" then
      local ids = {}
      for pId, _ in ___MOD.pairs(potGradeTbl) do
        ids[#ids + 1] = pId
      end
      ___MOD.table.sort(ids)
      for _, pId in ___MOD.ipairs(ids) do
        local p = potGradeTbl[pId]
        local str = ""
        local weight = 0
        local optionType = 0
        local reqLevel = 0
        if ___MOD.type(p) == "table" then
          str = p.string or ""
          weight = ___MOD.tonumber(p.weight) or 0
          optionType = ___MOD.tonumber(p.optionType) or 0
          reqLevel = ___MOD.tonumber(p.reqLevel) or 0
        end
      end
    else
      ___MOD.log(___MOD.string.format("[PotentialDump] grade=%d count=0", grade))
    end
  end
end

function ItemManager.ensureCashLoaded(self)
  if self.cashLoaded then
    return
  end
  local Cash = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Cash")
  if ___MOD.type(Cash) ~= "table" then
    return
  end
  local flat = {}
  for _, imgs in ___MOD.pairs(Cash) do
    for itemIdStr, data in ___MOD.pairs(imgs) do
      local id = ___MOD.tonumber(itemIdStr)
      if id ~= nil then
        flat[id] = data
      end
    end
  end
  self.cashRaw = flat
  self.cashLoaded = true
end

function ItemManager.ensureConsumeLoaded(self)
  if self.consumeLoaded then
    return
  end
  local Consume = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Consume")
  if ___MOD.type(Consume) ~= "table" then
    return
  end
  local flat = {}
  for _, imgs in ___MOD.pairs(Consume) do
    for itemIdStr, data in ___MOD.pairs(imgs) do
      local id = ___MOD.tonumber(itemIdStr)
      if id ~= nil then
        flat[id] = data
      end
    end
  end
  self.consumeRaw = flat
  self.consumeLoaded = true
end

function ItemManager.ensureEtcLoaded(self)
  if self.etcLoaded then
    return
  end
  local Etc = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Etc")
  if ___MOD.type(Etc) ~= "table" then
    return
  end
  local flat = {}
  for _, imgs in ___MOD.pairs(Etc) do
    for itemIdStr, data in ___MOD.pairs(imgs) do
      local id = ___MOD.tonumber(itemIdStr)
      if id ~= nil then
        flat[id] = data
      end
    end
  end
  self.etcRaw = flat
  self.etcLoaded = true
end

function ItemManager.ensureInstallLoaded(self)
  if self.installLoaded then
    return
  end
  local Install = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Install")
  if ___MOD.type(Install) ~= "table" then
    return
  end
  local flat = {}
  for _, imgs in ___MOD.pairs(Install) do
    for itemIdStr, data in ___MOD.pairs(imgs) do
      local id = ___MOD.tonumber(itemIdStr)
      if id ~= nil then
        flat[id] = data
      end
    end
  end
  self.installRaw = flat
  self.installLoaded = true
end

function ItemManager.ensurePetLoaded(self)
  if self.petLoaded then
    return
  end
  local Pet = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Pet")
  if ___MOD.type(Pet) ~= "table" then
    return
  end
  local flat = {}
  for imgName, img in ___MOD.pairs(Pet) do
    local itemIdStr = ___MOD.string.match(imgName, "^(.*)%.img$")
    local id = ___MOD.tonumber(itemIdStr)
    if id ~= nil then
      flat[id] = img
    end
  end
  self.petRaw = flat
  self.petLoaded = true
end

function ItemManager.ensurePotentialLoaded(self)
  if self.potentialLoaded then
    return
  end
  local Potential = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "ItemOption.img")
  if ___MOD.type(Potential) ~= "table" then
    return
  end
  local PotentialCash = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "ItemOptionCash.img")
  self:loadPotentialTables(Potential, PotentialCash)
  self.potentialLoaded = true
end

function ItemManager.ensureWeatherBuffIndexLoaded(self)
  if self.weatherBuffIndexLoaded then
    return
  end
  self:ensureCashLoaded()
  if not self.cashLoaded then
    return
  end
  for _, data in ___MOD.pairs(self.cashRaw) do
    local info = data and data.info or nil
    if ___MOD.isvalid(info) then
      local stateChangeItem = ___MOD._WzUtils:getInteger(info.stateChangeItem, 0)
      if 0 < stateChangeItem then
        self.weatherBuffItemID[stateChangeItem] = true
      end
    end
  end
  self.weatherBuffIndexLoaded = true
end

function ItemManager.finishData(self, item, info)
  item.accountSharable = ___MOD._WzUtils:getBoolean(info.accountSharable, ___MOD._WzUtils:getBoolean(info.accountsharable, false))
  item.tradeBlock = ___MOD._WzUtils:getBoolean(info.tradeBlock, false)
  if item.accountSharable then
    item.tradeBlock = true
  end
  item.cash = ___MOD._WzUtils:getBoolean(info.cash, false)
  item.notSale = ___MOD._WzUtils:getBoolean(info.notSale, false)
  item.quest = ___MOD._WzUtils:getBoolean(info.quest, false)
  item.price = ___MOD._WzUtils:getInteger(info.price, 0)
  item.only = ___MOD._WzUtils:getBoolean(info.only, false)
  item.tradeAvailable = ___MOD._WzUtils:getBoolean(info.tradeAvailable, false)
  item.tradeOnce = ___MOD._WzUtils:getBoolean(info.tradeOnce, false)
  item.max = ___MOD._WzUtils:getInteger(info.max, 0)
  item.expireOnLogout = ___MOD._WzUtils:getBoolean(info.expireOnLogout, false)
  item.timeLimited = ___MOD._WzUtils:getBoolean(info.timeLimited, false)
  item.noCancelMouse = ___MOD._WzUtils:getBoolean(info.noCancelMouse, false)
  item.MCType = ___MOD._WzUtils:getInteger(info.mcType, 0)
  item.slotMax = ___MOD._WzUtils:getInteger(info.slotMax, 0)
  local type = item.itemId // 1000000
  if type == 2 then
    if 0 < item.masterLevel then
      item.slotMax = 25
    elseif 0 >= item.slotMax then
      item.slotMax = 300
    end
  elseif type == 4 then
    if 0 >= item.slotMax then
      item.slotMax = 500
    end
  elseif type == 3 then
    if 0 >= item.slotMax then
      item.slotMax = 1
    end
  elseif type == 5 then
    if item.itemId // 10000 == 501 then
      item.slotMax = 1
    elseif 0 >= item.slotMax then
      item.slotMax = 100
    end
  end
  return item
end

function ItemManager.getItemById(self, itemId)
  local cached = self.itemData[itemId]
  if cached ~= nil and not self:needsIconReload(cached) then
    return cached
  end
  if cached ~= nil then
    local reloaded = self:reloadItemData(itemId)
    return reloaded ~= nil and reloaded or cached
  end
  if self.fastLoad then
    local itemType = itemId // 1000000
    if self:isPet(itemId) then
      self:ensurePetLoaded()
      local raw = self.petRaw[itemId]
      if raw ~= nil then
        local newItem = self:loadPetData(___MOD.tostring(itemId), raw)
        self.itemData[itemId] = newItem
        return newItem
      end
      return nil
    end
    if itemType == 2 then
      self:ensureConsumeLoaded()
      local raw = self.consumeRaw[itemId]
      if raw ~= nil then
        local newItem = self:loadConsumeItemData(___MOD.tostring(itemId), raw)
        self.itemData[itemId] = newItem
        return newItem
      end
    elseif itemType == 3 then
      self:ensureInstallLoaded()
      local raw = self.installRaw[itemId]
      if raw ~= nil then
        local newItem = self:loadInstallItemData(___MOD.tostring(itemId), raw)
        self.itemData[itemId] = newItem
        return newItem
      end
    elseif itemType == 4 then
      self:ensureEtcLoaded()
      local raw = self.etcRaw[itemId]
      if raw ~= nil then
        local newItem = self:loadEtcItemData(___MOD.tostring(itemId), raw)
        self.itemData[itemId] = newItem
        return newItem
      end
    elseif itemType == 5 then
      self:ensureCashLoaded()
      local raw = self.cashRaw[itemId]
      if raw ~= nil then
        local newItem = self:loadCashItemData(___MOD.tostring(itemId), raw)
        self.itemData[itemId] = newItem
        return newItem
      end
    end
    return nil
  end
  return nil
end

function ItemManager.getPetById(self, itemId)
  return self:getItemById(itemId)
end

function ItemManager.getPetDefaultTemplate(self, itemId)
  local pet = self:getItemById(itemId)
  if pet == nil and not self:isPet(itemId) then
    return
  end
  local stand = pet.action and pet.action.stand0
  if stand == nil then
    return
  end
  return stand.anim[1]
end

function ItemManager.getPotentialByCubeItemId(self, cubeItemId)
  if cubeItemId == 5062000 and ___MOD.type(self.potentialCash) == "table" and ___MOD.next(self.potentialCash) ~= nil then
    return self.potentialCash
  end
  return self.potential
end

function ItemManager.getPotentialOptions(self, pId, reqLevel)
  if pId <= 0 then
    return
  end
  self:ensurePotentialLoaded()
  local grade = pId // 10000
  if grade < 0 or 3 < grade then
    return
  end
  local baseReqLevel = ___MOD.math.max(0, ___MOD.tonumber(reqLevel) or 0)
  local levelIdx = 1
  levelIdx = ___MOD.math.min(___MOD.math.max((baseReqLevel + 5) // 10, 1), 20)
  if levelIdx < 1 or 20 < levelIdx then
    return
  end
  local p = self.potential[grade] and self.potential[grade][pId]
  if p == nil then
    return
  end
  local pp = p.level[levelIdx]
  if pp == nil then
    return
  end
  local ops = {}
  for key, v in ___MOD.pairs(pp) do
    ops[key] = ___MOD._WzUtils:getInteger(v, nil)
  end
  return ops
end

function ItemManager.getPotentialStr(self, pId, reqLevel)
  if pId <= 0 then
    return
  end
  self:ensurePotentialLoaded()
  local grade = pId // 10000
  if grade < 0 or 3 < grade then
    return
  end
  local baseReqLevel = ___MOD.math.max(0, ___MOD.tonumber(reqLevel) or 0)
  local levelIdx = 1
  levelIdx = ___MOD.math.min(___MOD.math.max((baseReqLevel + 5) // 10, 1), 20)
  if levelIdx < 1 or 20 < levelIdx then
    return
  end
  local p = self.potential[grade] and self.potential[grade][pId]
  if p == nil then
    return
  end
  local str = p.string
  local pp = p.level[levelIdx]
  if str == nil or pp == nil then
    return
  end
  local result = str:gsub("#(%w+)", function(key)
    local x = pp[key]
    return ___MOD._WzUtils:getString(x, nil) or ___MOD._WzUtils:getInteger(x, nil) or "#" .. key
  end)
  return result
end

function ItemManager.getRaiseItemIDByQuestID(self, itemID)
  return self.raiseItemIDByQuestID[itemID]
end

function ItemManager.isArrow(self, itemId)
  return itemId // 10000 == 206
end

function ItemManager.isBlackCrystal(self, itemID)
  return itemID // 10000 == 425 and itemID // 100 % 100 == 13
end

function ItemManager.isBowArrow(self, itemId)
  return itemId // 1000 == 2060
end

function ItemManager.isBullet(self, itemId)
  return itemId // 10000 == 233
end

function ItemManager.isConsumeOnPickUp(self, itemId)
  if itemId == nil or itemId <= 0 then
    return false
  end
  return self.consumeOnPickup[itemId] == true
end

function ItemManager.isCrossbowArrow(self, itemId)
  return itemId // 1000 == 2061
end

function ItemManager.isExpiredDeleteExcludedItem(self, itemId)
  return self.expiredDeleteExcludedItemIds[itemId] == true
end

function ItemManager.isPet(self, itemId)
  return itemId // 10000 == 500
end

function ItemManager.isRaiseItem(self, itemID)
  return self.raiseItems[itemID]
end

function ItemManager.isThrowingStars(self, itemId)
  return itemId // 10000 == 207
end

function ItemManager.isWeatherBuff(self, itemID)
  if self.weatherBuffItemID[itemID] == true then
    return true
  end
  self:ensureWeatherBuffIndexLoaded()
  return self.weatherBuffItemID[itemID] == true
end

function ItemManager.loadCashItemData(self, itemId, data)
  local item = ___MOD.Item()
  item.itemId = ___MOD.tonumber(itemId)
  item.name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Cash.img/%d/name", item.itemId))
  item.desc = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Cash.img/%d/desc", item.itemId))
  if ___MOD.isvalid(data.info) then
    local info = data.info
    item = self:loadIcon(item, info)
    if ___MOD.isvalid(data.consumeItem) then
    end
    item.protectTime = ___MOD._WzUtils:getInteger(info.protectTime, 0)
    item.weatherType = ___MOD._WzUtils:getInteger(info.type, 0)
    item.weatherPath = ___MOD._WzUtils:getString(info.path, "")
    item.floatType = ___MOD._WzUtils:getInteger(info.floatType, 0)
    item.weatherDirection = ___MOD._WzUtils:getInteger(info.direction, 0)
    item.weatherSpeed = ___MOD._WzUtils:getInteger(info.speed, 0)
    local weatherBgm = ___MOD._WzUtils:getString(info.bgmPath, "")
    if weatherBgm ~= "" then
      weatherBgm = weatherBgm:gsub("^Sound/", ""):gsub("/", ".")
    end
    item.weatherBgm = weatherBgm
    item.stateChangeItem = ___MOD._WzUtils:getInteger(info.stateChangeItem, 0)
    if 0 < item.stateChangeItem then
      self.weatherBuffItemID[item.stateChangeItem] = true
    end
    item.recoveryRate = ___MOD._WzUtils:getInteger(info.recoveryRate, 0)
    item.life = ___MOD._WzUtils:getInteger(info.life, 0)
    item.meso = ___MOD._WzUtils:getInteger(info.meso, 0)
    item.mesoMin = ___MOD._WzUtils:getInteger(info.mesomin, 0)
    item.mesoMax = ___MOD._WzUtils:getInteger(info.mesomax, 0)
    item.mesoStDev = ___MOD._WzUtils:getInteger(info.mesostdev, 0)
    item.maplePoint = ___MOD._WzUtils:getInteger(info.maplepoint, 0)
    item.rate = ___MOD._WzUtils:getInteger(info.rate, 0)
    item = self:finishData(item, info)
  end
  if data.hit then
    item.hit = ___MOD._WzUtils:parseAnimation(data.hit)
  end
  if data.bullet then
    item.bullet = ___MOD._WzUtils:parseAnimation(data.bullet)
  end
  if data.effect and item.itemId // 10000 == 501 then
    item.activeEffect = self:parseActiveEffectItemData(data.effect)
  end
  return item
end

function ItemManager.loadConsumeItemData(self, itemId, data)
  local item = ___MOD.Item()
  item.itemId = ___MOD.tonumber(itemId)
  item.name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Consume.img/%d/name", item.itemId))
  item.desc = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Consume.img/%d/desc", item.itemId))
  if data.req then
    item.req = {}
    for i, v in ___MOD.pairs(data.req) do
      i = ___MOD.tonumber(i)
      if i ~= nil then
        item.req[i] = ___MOD._WzUtils:getInteger(v, 0)
      end
    end
  end
  if data.info then
    local info = data.info
    item = self:loadIcon(item, info)
    item.unitPrice = ___MOD._WzUtils:getDouble(info.unitPrice, 0.0)
    if info.skill then
      item.skill = {}
      for _, v in ___MOD.pairs(info.skill) do
        local skillId = ___MOD.tonumber(v) or 0
        if 0 < skillId then
          item.skill[#item.skill + 1] = skillId
        end
      end
    end
    item.infoType = ___MOD._WzUtils:getInteger(info.type, 0)
    if info.mob then
      local mob = info.mob
    end
    item.masterLevel = ___MOD._WzUtils:getInteger(info.masterLevel, 0)
    item.reqSkillLevel = ___MOD._WzUtils:getInteger(info.reqSkillLevel, 0)
    item.successRate = ___MOD._WzUtils:getInteger(info.success, 0)
    item.monsterBook = ___MOD._WzUtils:getBoolean(info.monsterBook, false)
    item.cursedRate = ___MOD._WzUtils:getInteger(info.cursed, 0)
    item.successRate = ___MOD._WzUtils:getInteger(info.success, 0)
    item.incMHP = ___MOD._WzUtils:getInteger(info.incMHP, 0)
    item.incMMP = ___MOD._WzUtils:getInteger(info.incMMP, 0)
    item.incPAD = ___MOD._WzUtils:getInteger(info.incPAD, 0)
    item.incMAD = ___MOD._WzUtils:getInteger(info.incMAD, 0)
    item.incPDD = ___MOD._WzUtils:getInteger(info.incPDD, 0)
    item.incMDD = ___MOD._WzUtils:getInteger(info.incMDD, 0)
    item.incACC = ___MOD._WzUtils:getInteger(info.incACC, 0)
    item.incEVA = ___MOD._WzUtils:getInteger(info.incEVA, 0)
    item.incINT = ___MOD._WzUtils:getInteger(info.incINT, 0)
    item.incDEX = ___MOD._WzUtils:getInteger(info.incDEX, 0)
    item.incSTR = ___MOD._WzUtils:getInteger(info.incSTR, 0)
    item.incLUK = ___MOD._WzUtils:getInteger(info.incLUK, 0)
    item.incSpeed = ___MOD._WzUtils:getInteger(info.incSpeed, 0)
    item.incJump = ___MOD._WzUtils:getInteger(info.incJump, 0)
    item.incMHP = ___MOD._WzUtils:getInteger(info.incMHP, 0)
    item.incMMP = ___MOD._WzUtils:getInteger(info.incMMP, 0)
    item.preventSlip = ___MOD._WzUtils:getBoolean(info.preventslip, false)
    item.warmSupport = ___MOD._WzUtils:getBoolean(info.warmsupport, false)
    item.incCraft = ___MOD._WzUtils:getInteger(info.incCraft, 0)
    item.recover = ___MOD._WzUtils:getBoolean(info.recover, false)
    item.randStat = ___MOD._WzUtils:getInteger(info.randstat, 0)
    item.incRandVol = ___MOD._WzUtils:getInteger(info.randOption, 0)
    item.mobID = ___MOD._WzUtils:getInteger(info.mob, 0)
    item.create = ___MOD._WzUtils:getInteger(info.create, 0)
    item.left = ___MOD._WzUtils:getInteger(info.left, 0)
    item.right = ___MOD._WzUtils:getInteger(info.right, 0)
    item.top = ___MOD._WzUtils:getInteger(info.top, 0)
    item.bottom = ___MOD._WzUtils:getInteger(info.bottom, 0)
    item = self:finishData(item, info)
  end
  if data.spec then
    local spec = data.spec
    item.hp = ___MOD._WzUtils:getInteger(spec.hp, 0)
    item.mp = ___MOD._WzUtils:getInteger(spec.mp, 0)
    item.hpR = ___MOD._WzUtils:getInteger(spec.hpR, 0)
    item.mpR = ___MOD._WzUtils:getInteger(spec.mpR, 0)
    item.exp = ___MOD._WzUtils:getInteger(spec.exp, 0)
    item.mhpR = ___MOD._WzUtils:getInteger(spec.mhpR, 0)
    item.mmpR = ___MOD._WzUtils:getInteger(spec.mmpR, 0)
    item.pad = ___MOD._WzUtils:getInteger(spec.pad, 0)
    item.mad = ___MOD._WzUtils:getInteger(spec.mad, 0)
    item.indiePad = ___MOD._WzUtils:getInteger(spec.indiePad, 0)
    item.indieMad = ___MOD._WzUtils:getInteger(spec.indieMad, 0)
    item.pdd = ___MOD._WzUtils:getInteger(spec.pdd, 0)
    item.mdd = ___MOD._WzUtils:getInteger(spec.mdd, 0)
    item.padRate = ___MOD._WzUtils:getInteger(spec.padRate, 0)
    item.madRate = ___MOD._WzUtils:getInteger(spec.madRate, 0)
    item.pddRate = ___MOD._WzUtils:getInteger(spec.pddRate, 0)
    item.mddRate = ___MOD._WzUtils:getInteger(spec.mddRate, 0)
    item.acc = ___MOD._WzUtils:getInteger(spec.acc, 0)
    item.eva = ___MOD._WzUtils:getInteger(spec.eva, 0)
    item.accR = ___MOD._WzUtils:getInteger(spec.accR, 0)
    item.evaR = ___MOD._WzUtils:getInteger(spec.evaR, 0)
    item.speed = ___MOD._WzUtils:getInteger(spec.speed, 0)
    item.jump = ___MOD._WzUtils:getInteger(spec.jump, 0)
    item.speedRate = ___MOD._WzUtils:getInteger(spec.speedRate, 0)
    item.jumpRate = ___MOD._WzUtils:getInteger(spec.jumpRate, 0)
    item.moveTo = ___MOD._WzUtils:getInteger(spec.moveTo, 0)
    item.ignoreContinent = ___MOD._WzUtils:getBoolean(spec.ignoreContinent, false)
    item.prob = ___MOD._WzUtils:getInteger(spec.prob, 0)
    item.cp = ___MOD._WzUtils:getInteger(spec.cp, 0)
    item.cpSkill = ___MOD._WzUtils:getInteger(spec.nuffSkill, 0)
    item.thaw = ___MOD._WzUtils:getInteger(spec.thaw, 0)
    item.petfoodInc = ___MOD._WzUtils:getInteger(spec.inc, 0)
    item.cureSeal = ___MOD._WzUtils:getBoolean(spec.seal, false)
    item.cureCurse = ___MOD._WzUtils:getBoolean(spec.curse, false)
    item.curePoison = ___MOD._WzUtils:getBoolean(spec.poison, false)
    item.cureWeakness = ___MOD._WzUtils:getBoolean(spec.weakness, false)
    item.cureDarkness = ___MOD._WzUtils:getBoolean(spec.darkness, false)
    item.consumeOnPickup = ___MOD._WzUtils:getBoolean(spec.consumeOnPickup, false)
    if item.consumeOnPickup then
      self.consumeOnPickup[item.itemId] = true
    end
    item.party = ___MOD._WzUtils:getBoolean(spec.party, false)
    item.bfSkill = ___MOD._WzUtils:getInteger(spec.BFSkill, -1)
    item.dojangShield = ___MOD._WzUtils:getInteger(spec.dojangshield, 0)
    item.expInc = ___MOD._WzUtils:getInteger(spec.expinc, 0)
    item.morph = ___MOD._WzUtils:getInteger(spec.morph, 0)
    item.expUpByItem = ___MOD._WzUtils:getBoolean(spec.expBuff, false)
    item.mesoUpByItem = ___MOD._WzUtils:getBoolean(spec.mesoupbyitem, false)
    item.itemUpByItem = ___MOD._WzUtils:getBoolean(spec.itemupbyitem, false)
    item.expBuffRate = ___MOD._WzUtils:getInteger(spec.expBuff, 0)
    item.itemScript = ___MOD._WzUtils:getString(spec.script, "")
    item.scriptNpc = ___MOD._WzUtils:getInteger(spec.npc, 0)
    item.time = ___MOD._WzUtils:getInteger(spec.time, 0)
  end
  if data.specEx then
    local specEx = {}
    for key, node in ___MOD.pairs(data.specEx) do
      local index = ___MOD.tonumber(key)
      if index ~= nil and ___MOD.type(node) == "table" then
        specEx[index + 1] = {
          mobSkill = ___MOD._WzUtils:getInteger(node.mobSkill, 0),
          level = ___MOD._WzUtils:getInteger(node.level, 0)
        }
      end
    end
    item.specEx = specEx
  end
  if data.mob then
    local mob = {}
    for i = 1, 100 do
      local node = data.mob[___MOD.tostring(i - 1)]
      if node == nil then
        break
      end
      local summonInfo = ___MOD.ItemSummonMob()
      summonInfo.mobTemplateID = ___MOD._WzUtils:getInteger(node.id, 0)
      summonInfo.prob = ___MOD._WzUtils:getInteger(node.prob, 0)
      mob[i] = summonInfo
    end
    item.mob = mob
  end
  if data.bullet then
    item.bullet = ___MOD._WzUtils:parseAnimation(data.bullet)
  end
  if data.reward then
    local rewards = {}
    for k, node in ___MOD.pairs(data.reward) do
      local idx = ___MOD.tonumber(k)
      if idx ~= nil then
        idx = idx + 1
        rewards[idx] = {
          item = ___MOD._WzUtils:getInteger(node.item, 0),
          prob = ___MOD._WzUtils:getInteger(node.prob, 0),
          count = ___MOD._WzUtils:getInteger(node.count, 1)
        }
      end
    end
    item.reward = rewards
  end
  return item
end

function ItemManager.loadEtcItemData(self, itemId, data)
  local item = ___MOD.Item()
  item.itemId = ___MOD.tonumber(itemId)
  item.name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Etc.img/Etc/%d/name", item.itemId))
  item.desc = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Etc.img/Etc/%d/desc", item.itemId))
  if data.book and self:IsClient() then
    local book = ___MOD.Book()
    if book:setBook(data.book) then
      item.book = book
    end
  end
  if ___MOD.isvalid(data.info) then
    local info = data.info
    item = self:loadIcon(item, info)
    item.incMHP = ___MOD._WzUtils:getInteger(info.incMaxHP, 0)
    item.incMMP = ___MOD._WzUtils:getInteger(info.incMaxMP, 0)
    item.incPAD = ___MOD._WzUtils:getInteger(info.incPAD, 0)
    item.incMAD = ___MOD._WzUtils:getInteger(info.incMAD, 0)
    item.incPDD = ___MOD._WzUtils:getInteger(info.incPDD, 0)
    item.incMDD = ___MOD._WzUtils:getInteger(info.incMDD, 0)
    item.incACC = ___MOD._WzUtils:getInteger(info.incACC, 0)
    item.incEVA = ___MOD._WzUtils:getInteger(info.incEVA, 0)
    item.incINT = ___MOD._WzUtils:getInteger(info.incINT, 0)
    item.incDEX = ___MOD._WzUtils:getInteger(info.incDEX, 0)
    item.incSTR = ___MOD._WzUtils:getInteger(info.incSTR, 0)
    item.incLUK = ___MOD._WzUtils:getInteger(info.incLUK, 0)
    item.incSpeed = ___MOD._WzUtils:getInteger(info.incSpeed, 0)
    item.incJump = ___MOD._WzUtils:getInteger(info.incJump, 0)
    item.randStat = ___MOD._WzUtils:getInteger(info.randStat, 0)
    item.incRandVol = ___MOD._WzUtils:getInteger(info.randOption, 0)
    item.lv = ___MOD._WzUtils:getInteger(info.lv, 0)
    item.exp = ___MOD._WzUtils:getInteger(info.exp, 0)
    item.grade = ___MOD._WzUtils:getInteger(info.grade, 0)
    item.questId = ___MOD._WzUtils:getInteger(info.questId, 0)
    if 0 < item.questId and self:IsServer() then
      self.raiseItemIDByQuestID[item.questId] = item.itemId
    end
    item.raiseName = ___MOD._WzUtils:getString(info.name, nil)
    item.pickupBlock = ___MOD._WzUtils:getBoolean(info.pickUpBlock, false)
    item.pquest = ___MOD._WzUtils:getBoolean(info.pquest, false)
    item.hybrid = ___MOD._WzUtils:getBoolean(info.hybrid, false)
    item.shopCoin = ___MOD._WzUtils:getBoolean(info.shopCoin, false)
    item.bigSize = ___MOD._WzUtils:getBoolean(info.bigSize, false)
    if info.uiData then
      local path = ___MOD._WzUtils:getString(info.uiData, nil)
      if path then
        path = path:gsub("^UI/([^/]+)", function(imgName)
          if imgName:match("%.img$") then
            return imgName
          end
          return imgName .. ".img"
        end)
        item.uiData = path
        self.raiseItems[item.itemId] = true
      end
    end
    if info.message then
      for i = 1, 100 do
        local idx = ___MOD.tostring(i - 1)
        local messageNode = info.message[idx]
        if messageNode == nil then
          break
        end
        if item.message == nil then
          item.message = {}
        end
        item.message[i] = ___MOD._WzUtils:getString(messageNode, nil)
      end
    end
    if info.consumeItem then
      for i = 1, 100 do
        local idx = ___MOD.tostring(i - 1)
        local consumeItemNode = info.consumeItem[idx]
        if consumeItemNode == nil then
          break
        end
        if item.consumeItem == nil then
          item.consumeItem = {}
        end
        item.consumeItem[i] = ___MOD._WzUtils:getInteger(consumeItemNode, nil)
      end
    end
    item = self:finishData(item, info)
  end
  return item
end

function ItemManager.loadIcon(self, item, info)
  if info.icon ~= nil and self:IsClient() then
    local fastVector = ___MOD.FastVector2.zero:Clone()
    local tempicon = info.icon
    item.icon = ___MOD.__RUIDManager:get(tempicon.image)
    item.iconSize = ___MOD.FastVector2(tempicon._width * 2, tempicon._height * 2)
    fastVector = ___MOD._WzUtils:getFastVector(tempicon.origin, ___MOD.FastVector2.zero:Clone())
    item.iconOrigin = fastVector * 2
  else
    item.icon = ""
    item.iconSize = ___MOD.FastVector2.zero:Clone()
    item.iconOrigin = ___MOD.FastVector2.zero:Clone()
  end
  if info.iconRaw ~= nil and self:IsClient() then
    local fastVector = ___MOD.FastVector2.zero:Clone()
    local tempiconRaw = info.iconRaw
    item.iconRaw = ___MOD.__RUIDManager:get(tempiconRaw.image)
    item.iconRawSize = ___MOD.FastVector2(tempiconRaw._width * 2, tempiconRaw._height * 2)
    fastVector = ___MOD._WzUtils:getFastVector(tempiconRaw.origin, ___MOD.FastVector2.zero:Clone())
    item.iconRawOrigin = fastVector * 2
  else
    item.iconRaw = ""
    item.iconRawSize = ___MOD.FastVector2.zero:Clone()
    item.iconRawOrigin = ___MOD.FastVector2.zero:Clone()
  end
  if info.iconD ~= nil and self:IsClient() then
    local fastVector = ___MOD.FastVector2.zero:Clone()
    local tempIconD = info.iconD
    item.iconD = ___MOD.__RUIDManager:get(tempIconD.image)
    item.iconDSize = ___MOD.FastVector2(tempIconD._width * 2, tempIconD._height * 2)
    fastVector = ___MOD._WzUtils:getFastVector(tempIconD.origin, ___MOD.FastVector2.zero:Clone())
    item.iconDOrigin = fastVector * 2
  else
    item.iconD = ""
    item.iconDSize = ___MOD.FastVector2.zero:Clone()
    item.iconDOrigin = ___MOD.FastVector2.zero:Clone()
  end
  if info.iconRawD ~= nil and self:IsClient() then
    local fastVector = ___MOD.FastVector2.zero:Clone()
    local tempiconRaw = info.iconRawD
    item.iconRawD = ___MOD.__RUIDManager:get(tempiconRaw.image)
    item.iconRawDSize = ___MOD.FastVector2(tempiconRaw._width * 2, tempiconRaw._height * 2)
    fastVector = ___MOD._WzUtils:getFastVector(tempiconRaw.origin, ___MOD.FastVector2.zero:Clone())
    item.iconRawDOrigin = fastVector * 2
  else
    item.iconRawD = ""
    item.iconRawDSize = ___MOD.FastVector2.zero:Clone()
    item.iconRawDOrigin = ___MOD.FastVector2.zero:Clone()
  end
  return item
end

function ItemManager.loadInstallItemData(self, itemId, data)
  local item = ___MOD.Item()
  item.itemId = ___MOD.tonumber(itemId)
  item.name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Ins.img/%d/name", item.itemId))
  item.desc = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Ins.img/%d/desc", item.itemId))
  if ___MOD.isvalid(data.info) then
    local info = data.info
    item = self:loadIcon(item, info)
    item.recoveryHP = ___MOD._WzUtils:getInteger(info.recoveryHP, 0)
    item.recoveryMP = ___MOD._WzUtils:getInteger(info.recoveryMP, 0)
    item.reqLevel = ___MOD._WzUtils:getInteger(info.reqLevel, 0)
    item.tamingMob = ___MOD._WzUtils:getInteger(info.tamingMob, 0)
    item.nickTag = ___MOD._WzUtils:getInteger(info.nickTag, 0)
    item = self:finishData(item, info)
  end
  if data.effect then
    item.effect = ___MOD._WzUtils:parseAnimation(data.effect)
  end
  if data.effect2 then
    item.effect2 = ___MOD._WzUtils:parseAnimation(data.effect2)
  end
  return item
end

function ItemManager.loadItemPart1(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  if self:IsServer() then
    self.fastLoad = false
  end
  if self.fastLoad then
    self.count1 = 0
    ___MOD.log(___MOD.string.format("Indexed Item.wz Part1 (Lazy mode, no pre-parse) (%.2f secs)", ___MOD._UtilLogic.ElapsedSeconds - time))
    ___MOD._DataLoadManager:compeletedLoad()
    return
  end
  local dataCache = {}
  local Consume = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Consume")
  local Etc = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Etc")
  if ___MOD.type(Consume) ~= "table" or ___MOD.type(Etc) ~= "table" then
    return
  end
  local item
  for _, imgs in ___MOD.pairs(Consume) do
    for itemId, data in ___MOD.pairs(imgs) do
      item = self:loadConsumeItemData(itemId, data)
      dataCache[item.itemId] = item
      self.count1 = self.count1 + 1
    end
  end
  for _, imgs in ___MOD.pairs(Etc) do
    for itemId, data in ___MOD.pairs(imgs) do
      item = self:loadEtcItemData(itemId, data)
      dataCache[item.itemId] = item
      self.count1 = self.count1 + 1
    end
  end
  for k, v in ___MOD.pairs(dataCache) do
    self.itemData[k] = v
  end
  ___MOD.log(___MOD.string.format("Loaded Item.wz Part1 (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count1))
  ___MOD._DataLoadManager:compeletedLoad()
end

function ItemManager.loadItemPart2(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  if self:IsServer() then
    self.fastLoad = ___MOD.Environment:IsMakerPlay()
  end
  if self.fastLoad then
    self.count2 = 0
    ___MOD.log(___MOD.string.format("Indexed Item.wz Part2 (Lazy mode, no pre-parse) (%.2f secs)", ___MOD._UtilLogic.ElapsedSeconds - time))
    ___MOD._DataLoadManager:compeletedLoad()
    return
  end
  local dataCache = {}
  local Install = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Install")
  local Cash = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Cash")
  local Pet = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "Pet")
  local Potential = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "ItemOption.img")
  local PotentialCash = ___MOD._WzUtils:ParseGenericWzCollectionWZ("Item_wz", "ItemOptionCash.img")
  if ___MOD.type(Install) ~= "table" or ___MOD.type(Cash) ~= "table" or ___MOD.type(Pet) ~= "table" or ___MOD.type(Potential) ~= "table" then
    return
  end
  local item
  for _, imgs in ___MOD.pairs(Install) do
    for itemId, data in ___MOD.pairs(imgs) do
      item = self:loadInstallItemData(itemId, data)
      dataCache[item.itemId] = item
      self.count2 = self.count2 + 1
    end
  end
  for _, imgs in ___MOD.pairs(Cash) do
    for itemId, data in ___MOD.pairs(imgs) do
      item = self:loadCashItemData(itemId, data)
      dataCache[item.itemId] = item
      self.count2 = self.count2 + 1
    end
  end
  local itemIdStr
  for imgName, img in ___MOD.pairs(Pet) do
    itemIdStr = ___MOD.string.match(imgName, "^(.*)%.img$")
    item = self:loadPetData(itemIdStr, img)
    dataCache[item.itemId] = item
    self.count2 = self.count2 + 1
  end
  self:loadPotentialTables(Potential, PotentialCash)
  self.potentialLoaded = true
  for k, v in ___MOD.pairs(dataCache) do
    self.itemData[k] = v
  end
  ___MOD.log(___MOD.string.format("Loaded Item.wz Part2 (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count2))
  ___MOD._DataLoadManager:compeletedLoad()
end

function ItemManager.loadPetData(self, itemId, data)
  local item = ___MOD.Item()
  local REPL = "#c스킬: 메소 줍기, 아이템 줍기, 소유권 없는 아이템&메소 줍기, HP 물약충전, MP 물약충전#"

  local function replaceCBlock(text)
    return (text:gsub("#c.-#", REPL))
  end

  item.itemId = ___MOD.tonumber(itemId)
  item.name = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Pet.img/%d/name", item.itemId))
  item.desc = replaceCBlock(___MOD._StringPoolManager:getStringPool(___MOD.string.format("Pet.img/%d/desc", item.itemId)))
  item.descD = replaceCBlock(___MOD._StringPoolManager:getStringPool(___MOD.string.format("Pet.img/%d/descD", item.itemId)))
  for nodeName, node in ___MOD.pairs(data) do
    if nodeName == "info" then
      local info = node
      item = self:loadIcon(item, info)
      item.chatBalloon = ___MOD._WzUtils:getInteger(info.chatBalloon, 0)
      item.nameTag = ___MOD._WzUtils:getInteger(info.nameTag, 0)
      item.pickupItem = ___MOD._WzUtils:getBoolean(info.pickupItem, false)
      item.life = ___MOD._WzUtils:getInteger(info.life, 90)
      item.cash = ___MOD._WzUtils:getBoolean(info.cash, false)
      item.hungry = ___MOD._WzUtils:getInteger(info.hungry, 6)
      item.slotMax = 1
    elseif nodeName == "interact" then
      local cache = {}
      for i, v in ___MOD.pairs(node) do
        local index = ___MOD.tonumber(i)
        if index ~= nil then
          index = index + 1
          cache[index] = {}
          cache[index].command = ___MOD._WzUtils:getString(v.command, "")
          cache[index].inc = ___MOD._WzUtils:getInteger(v.inc, 0)
          cache[index].prob = ___MOD._WzUtils:getInteger(v.prob, 0)
          cache[index].l0 = ___MOD._WzUtils:getInteger(v.l0, 0)
          cache[index].l1 = ___MOD._WzUtils:getInteger(v.l1, 0)
          if v.success and v.success["0"] then
            cache[index].success = {}
            local success = cache[index].success
            success.c = {}
            for n, vv in ___MOD.pairs(v.success["0"]) do
              if n == "act" then
                success.act = ___MOD._WzUtils:getString(vv, "")
              else
                local ii = ___MOD.tonumber(n)
                if ii ~= nil then
                  ii = ii + 1
                  success.c[ii] = ___MOD._WzUtils:getString(vv, "")
                end
              end
            end
          end
          if v.fail and v.fail["0"] then
            cache[index].fail = {}
            local fail = cache[index].fail
            fail.c = {}
            for n, vv in ___MOD.pairs(v.fail["0"]) do
              if n == "act" then
                fail.act = ___MOD._WzUtils:getString(vv, "")
              else
                local ii = ___MOD.tonumber(n)
                if ii ~= nil then
                  ii = ii + 1
                  fail.c[ii] = ___MOD._WzUtils:getString(vv, "")
                end
              end
            end
          end
        end
      end
      item.interact = cache
    elseif nodeName == "food" then
      local cache = {}
      for i, v in ___MOD.pairs(node) do
        local index = ___MOD.tonumber(i)
        if index ~= nil then
          index = index + 1
          cache[index] = {}
          cache[index].l0 = ___MOD._WzUtils:getInteger(v.l0, 0)
          cache[index].l1 = ___MOD._WzUtils:getInteger(v.l1, 0)
          if v.success and v.success["0"] then
            cache[index].success = {}
            local success = cache[index].success
            success.c = {}
            for n, vv in ___MOD.pairs(v.success["0"]) do
              if n == "act" then
                success.act = ___MOD._WzUtils:getString(vv, "")
              else
                local ii = ___MOD.tonumber(n)
                if ii ~= nil then
                  ii = ii + 1
                  success.c[ii] = ___MOD._WzUtils:getString(vv, "")
                end
              end
            end
          end
          if v.fail and v.fail["0"] then
            cache[index].fail = {}
            local fail = cache[index].fail
            fail.c = {}
            for n, vv in ___MOD.pairs(v.fail["0"]) do
              if n == "act" then
                fail.act = ___MOD._WzUtils:getString(vv, "")
              else
                local ii = ___MOD.tonumber(n)
                if ii ~= nil then
                  ii = ii + 1
                  fail.c[ii] = ___MOD._WzUtils:getString(vv, "")
                end
              end
            end
          end
        end
      end
      item.food = cache
    elseif nodeName == "slang" then
      local cache = {}
      for i, v in ___MOD.pairs(node) do
        local index = ___MOD.tonumber(i)
        if index ~= nil then
          index = index + 1
          cache[i] = {}
          cache[i].l0 = ___MOD._WzUtils:getInteger(v.l0, 0)
          cache[i].l1 = ___MOD._WzUtils:getInteger(v.l1, 0)
          cache[i].act = ___MOD._WzUtils:getString(v.act, "")
          cache[i]["0"] = ___MOD._WzUtils:getString(v["0"], "")
        end
      end
      item.slang = cache
    else
      item.action[nodeName] = ___MOD._WzUtils:parseAnimation(node)
    end
  end
  return item
end

function ItemManager.loadPotentialTables(self, itemOption_img, itemOptionCash_img)
  self:parsePotential(itemOption_img)
  self:parsePotentialCash(itemOptionCash_img)
end

function ItemManager.needsIconReload(self, item)
  local failed = self._T.iconReloadFailed
  if failed ~= nil and failed[item.itemId] then
    return false
  end
  return self:IsClient() and ___MOD.__RUIDManager.loadCompleted and ___MOD._UtilLogic:IsNilorEmptyString(item.icon)
end

function ItemManager.parseActiveEffectItemData(self, effectData)
  if ___MOD.type(effectData) ~= "table" then
    return nil
  end
  local activeEffect = {
    action = ___MOD._WzUtils:getBoolean(effectData.action, false),
    follow = ___MOD._WzUtils:getBoolean(effectData.follow, false),
    tamingMob = ___MOD._WzUtils:getBoolean(effectData.tamingMob, true),
    spectrum = ___MOD._WzUtils:getBoolean(effectData.spectrum, false),
    interval = ___MOD.math.max(1, ___MOD._WzUtils:getInteger(effectData.interval, 100)),
    delay = ___MOD.math.max(1, ___MOD._WzUtils:getInteger(effectData.delay, 1000)),
    alpha = ___MOD.math.max(0, ___MOD.math.min(255, ___MOD._WzUtils:getInteger(effectData.alpha, 128))),
    animations = {},
    followLayers = {}
  }
  local metadataKeys = {
    action = true,
    follow = true,
    tamingMob = true,
    spectrum = true,
    interval = true,
    delay = true,
    alpha = true
  }
  for nodeName, node in ___MOD.pairs(effectData) do
    if not metadataKeys[nodeName] and ___MOD.type(node) == "table" then
      local animation = ___MOD._WzUtils:parseAnimation(node)
      if animation ~= nil then
        animation.fixed = ___MOD._WzUtils:getInteger(node.fixed, 0)
        animation.loose = ___MOD._WzUtils:getInteger(node.loose, 0)
        animation.pos = ___MOD._WzUtils:getInteger(node.pos, animation.pos or 0)
        animation.z = ___MOD._WzUtils:getInteger(node.z, animation.z or 0)
        local numericIndex = ___MOD.tonumber(nodeName)
        if activeEffect.follow and numericIndex ~= nil then
          activeEffect.followLayers[numericIndex + 1] = animation
        else
          activeEffect.animations[___MOD.tostring(nodeName)] = animation
        end
      end
    end
  end
  return activeEffect
end

function ItemManager.parsePotential(self, itemOption_img)
  self.potential = self:buildPotentialCache(itemOption_img)
  if ___MOD.Environment:IsMakerPlay() then
    self:dumpPotentialInfoStringsInRange(0, 3)
  end
end

function ItemManager.parsePotentialCash(self, itemOptionCash_img)
  self.potentialCash = self:buildPotentialCache(itemOptionCash_img)
end

function ItemManager.pTest(self, itemId, curGrade)
  if curGrade < 1 or 3 < curGrade then
    return
  end
  self:ensurePotentialLoaded()
  local eqp = ___MOD._EquipManager:getItemById(itemId)
  if eqp == nil then
    ___MOD.log("존재하지 않는 아이템 : ", itemId)
    return
  end
  local reqLev = eqp.reqLevel
  local cat = ___MOD._EquipManager:getCategoryNameById(itemId)
  if curGrade <= 2 then
    local gUpChance
    if curGrade == 1 then
      gUpChance = 60
    elseif curGrade == 2 then
      gUpChance = 18
    end
    if gUpChance >= ___MOD._GlobalRand32:randomIntegerRange(1, 1000) then
      curGrade = curGrade + 1
    end
  end

  local function canApplyOptionType(optType, itemId2)
    if optType == 0 then
      return true
    end
    if optType == 10 then
      return cat == "Weapon"
    end
    if optType == 11 then
      return cat ~= "Weapon"
    end
    if optType == 20 then
      return cat == "Longcoat" or cat == "Pants" or cat == "Coat"
    end
    if optType == 40 then
      return cat == "Accessory" or cat == "Ring"
    end
    if optType == 51 then
      return cat == "Cap"
    end
    if optType == 52 then
      return cat == "Longcoat" or cat == "Coat"
    end
    if optType == 53 then
      return cat == "Longcoat" or cat == "Pants"
    end
    if optType == 54 then
      return cat == "Glove"
    end
    if optType == 55 then
      return cat == "Shoes"
    end
    return false
  end

  local function canApplyReqLevel(optReqLevel, itemReqLevel)
    return optReqLevel <= itemReqLevel
  end

  local lineCount = 3
  local randO, rand1, lg, prob, grade
  for i = 1, lineCount do
    lg = i == 1 and 0 or 1
    if 2 <= i then
      rand1 = ___MOD._GlobalRand32:randomIntegerRange(1, 100)
      prob = 100 / (1 * 10 ^ (i - 1))
      if rand1 <= prob then
        lg = 0
      end
    end
    grade = curGrade - lg
    local potGradeTbl = self.potential[grade]
    if potGradeTbl == nil then
      ___MOD.log("Invalid potential grade: ", grade)
      return
    end
    local candidates, sumWeight = {}, 0
    for id2, p2 in ___MOD.pairs(potGradeTbl) do
      if canApplyOptionType(p2.optionType, itemId) and canApplyReqLevel(p2.reqLevel, reqLev) then
        candidates[#candidates + 1] = {
          id = id2,
          weight = p2.weight,
          ref = p2
        }
        sumWeight = sumWeight + p2.weight
      end
    end
    randO = ___MOD._GlobalRand32:randomIntegerRange(1, sumWeight)
    local acc, chosenKey = 0
    for _, c in ___MOD.ipairs(candidates) do
      acc = acc + c.weight
      if randO <= acc then
        chosenKey = c
        break
      end
    end
    local levelIdx = reqLev // 10 + 1
    local chosenRef = chosenKey and chosenKey.ref or nil
    local levelTbl = chosenRef and chosenRef.level and chosenRef.level[levelIdx]
    if levelTbl then
      for _, v in ___MOD.pairs(levelTbl) do
        ___MOD.log("축하합니다! 뽑힌 키는? ", chosenKey.id, chosenRef.string or "", ___MOD._WzUtils:getInteger(v, 0))
        break
      end
    end
  end
  ___MOD.log("-------------------------------")
end

function ItemManager.reloadItemData(self, itemId)
  local newItem
  if self:isPet(itemId) then
    self:ensurePetLoaded()
    local raw = self.petRaw[itemId]
    if raw == nil then
      return nil
    end
    newItem = self:loadPetData(___MOD.tostring(itemId), raw)
  else
    local itemType = itemId // 1000000
    if itemType == 2 then
      self:ensureConsumeLoaded()
      local raw = self.consumeRaw[itemId]
      if raw == nil then
        return nil
      end
      newItem = self:loadConsumeItemData(___MOD.tostring(itemId), raw)
    elseif itemType == 3 then
      self:ensureInstallLoaded()
      local raw = self.installRaw[itemId]
      if raw == nil then
        return nil
      end
      newItem = self:loadInstallItemData(___MOD.tostring(itemId), raw)
    elseif itemType == 4 then
      self:ensureEtcLoaded()
      local raw = self.etcRaw[itemId]
      if raw == nil then
        return nil
      end
      newItem = self:loadEtcItemData(___MOD.tostring(itemId), raw)
    elseif itemType == 5 then
      self:ensureCashLoaded()
      local raw = self.cashRaw[itemId]
      if raw == nil then
        return nil
      end
      newItem = self:loadCashItemData(___MOD.tostring(itemId), raw)
    else
      return nil
    end
  end
  if newItem == nil or ___MOD._UtilLogic:IsNilorEmptyString(newItem.icon) then
    if self._T.iconReloadFailed == nil then
      self._T.iconReloadFailed = {}
    end
    self._T.iconReloadFailed[itemId] = true
    return nil
  end
  local cached = self.itemData[itemId]
  if cached ~= nil then
    self:copyIconData(cached, newItem)
    return cached
  end
  return nil
end
