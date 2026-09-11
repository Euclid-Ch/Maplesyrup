

function Dojang.addDojoClearPoints(self, player, floor, pointEligible)

end

function Dojang.applyCachedMyDojangDamageRankClient(self)
  local hold = self._T.dojangDamageSearchRowHold
  if hold ~= nil and hold.mode == (self._T.dojangDamageRankMode or "") then
    self:fillDojangDamageRankRowClient(1, hold.entry)
    return
  end
  local entry = self._T.dojangDamageMyRankEntry or {rank = 0, damage = 0}
  self:fillDojangDamageRankRowClient(1, entry)
end

function Dojang.applyCachedMyDojangRankClient(self, rankMode)
  local hold = self._T.dojangSearchRowHold
  if hold ~= nil and hold.mode == rankMode then
    self:fillDojangRankRowClient(1, hold.entry)
    return
  end
  self._T.dojangMyRankEntries = self._T.dojangMyRankEntries or {}
  local entry = self._T.dojangMyRankEntries[rankMode] or {
    rank = 0,
    floor = 0,
    clearTime = 0
  }
  self:fillDojangRankRowClient(1, entry)
end

function Dojang.applyDojangDamageRank(self, entries, errorMessage, page, total, rankMode)
  if self._T.dojangDamageRankMode ~= nil and self._T.dojangDamageRankMode ~= rankMode then
    return
  end
  entries = entries or {}
  page = ___MOD.math.max(1, ___MOD.math.floor(___MOD.tonumber(page) or 1))
  self._T.dojangDamageRankPage = page
  if 0 < (___MOD.tonumber(total) or 0) or page == 1 then
    self._T.dojangDamageRankTotal = ___MOD.tonumber(total) or 0
  end
  if page == 1 then
    self:clearDojangDamageRankBoardClient()
  else
    self:clearDojangDamageRankRowsClient(2)
  end
  local pagePath = "/ui/DojangGroup/DojangDamageRankBoard/PageText"
  if not ___MOD._UtilLogic:IsNilorEmptyString(errorMessage) then
    self:setDojangRankTextClient(pagePath, errorMessage)
    self:applyCachedMyDojangDamageRankClient()
    return
  end
  if #entries == 0 then
    self:setDojangRankTextClient(pagePath, "기록 없음")
    self:applyCachedMyDojangDamageRankClient()
    return
  end
  local totalPages = self:getDojangRankTotalPagesClient(self._T.dojangDamageRankTotal or 0)
  self:setDojangRankTextClient(pagePath, ___MOD.tostring(page) .. " / " .. ___MOD.tostring(totalPages))
  local topEntries = {}
  for index, entry in ___MOD.ipairs(entries) do
    local rank = ___MOD.tonumber(entry.rank) or index
    if page == 1 and 1 <= rank and rank <= 5 then
      local base = "/ui/DojangGroup/DojangDamageRankBoard/TopRank" .. ___MOD.tostring(rank)
      local baseColor = ___MOD.Color(0.06666667, 0.06666667, 0.06666667, 1)
      self:setDojangRankTextColorClient(base .. "/NameText", ___MOD.tostring(entry.name or ""), baseColor)
      self:setDojangRankTextColorClient(base .. "/RecordText", self:formatDojangDamageNumber(___MOD.tonumber(entry.damage) or 0), baseColor)
      self:setDojangRankTextColorClient(base .. "/GuildText", self:formatDojangRankGuild(___MOD.tostring(entry.guild or "")), baseColor)
      topEntries[rank] = entry
    end
    if page == 1 and 1 <= rank and rank <= 6 then
      self:fillDojangDamageRankRowClient(rank + 1, entry)
    elseif 2 <= page then
      self:fillDojangDamageRankRowClient(index + 1, entry)
    end
  end
  if page == 1 then
    for rank = 1, 5 do
      self:applyDojangRankAvatarClient(rank, topEntries[rank], "DojangDamageRankBoard")
    end
    self._T.dojangDamageRankTop5 = topEntries
  else
    self:renderDojangDamageRankTop5Client()
  end
  self:applyCachedMyDojangDamageRankClient()
end

function Dojang.applyDojangRank(self, entries, errorMessage, rankMode, total)
  rankMode = self:normalizeDojangRankMode(rankMode)
  if self._T.dojangRankMode ~= nil and self._T.dojangRankMode ~= rankMode then
    return
  end
  self:clearDojangRankBoardClient()
  self:setDojangRankTabVisualClient(rankMode)
  self._T.dojangRankMode = rankMode
  self._T.dojangRankPage = 1
  self._T.dojangRankTotal = ___MOD.tonumber(total) or 0
  entries = entries or {}
  if not ___MOD._UtilLogic:IsNilorEmptyString(errorMessage) then
    self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", errorMessage)
    self:applyCachedMyDojangRankClient(rankMode)
    return
  end
  if #entries == 0 then
    self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", "기록 없음")
    self:applyCachedMyDojangRankClient(rankMode)
    return
  end
  local totalPages = self:getDojangRankTotalPagesClient(self._T.dojangRankTotal)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", "1 / " .. ___MOD.tostring(totalPages))
  local baseColor = ___MOD.Color(0.06666667, 0.06666667, 0.06666667, 1)
  local topEntries = {}
  self:applyCachedMyDojangRankClient(rankMode)
  for index, entry in ___MOD.ipairs(entries) do
    local rank = ___MOD.tonumber(entry.rank) or index
    if 1 <= rank and rank <= 5 then
      local floor = ___MOD.tonumber(entry.floor) or 0
      local recordText = ___MOD.string.format("%d층 / %s", floor, self:formatDojangRankTime(___MOD.tonumber(entry.clearTime) or 0))
      local base = "/ui/DojangGroup/DojangRankBoard/TopRank" .. ___MOD.tostring(rank)
      self:setDojangRankTextColorClient(base .. "/NameText", ___MOD.tostring(entry.name or ""), baseColor)
      self:setDojangRankTextColorClient(base .. "/RecordText", recordText, self:getDojangRankFloorColor(floor))
      self:setDojangRankTextColorClient(base .. "/GuildText", self:formatDojangRankGuild(___MOD.tostring(entry.guild or "")), baseColor)
      topEntries[rank] = entry
    end
    if 1 <= rank and rank <= 6 then
      self:fillDojangRankRowClient(rank + 1, entry)
    end
  end
  for rank = 1, 5 do
    self:applyDojangRankAvatarClient(rank, topEntries[rank], "DojangRankBoard")
  end
  self._T.dojangRankTop5 = topEntries
end

function Dojang.applyDojangRankAvatarClient(self, rank, entry, boardName)
  if ___MOD._UtilLogic:IsNilorEmptyString(boardName) then
    boardName = "DojangRankBoard"
  end
  local avatarEnt = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/" .. boardName .. "/TopRank" .. ___MOD.tostring(rank) .. "/Avatar")
  if not ___MOD.isvalid(avatarEnt) then
    return
  end
  if entry == nil then
    avatarEnt:SetEnable(false)
    return
  end
  local costume = avatarEnt.CostumeManagerComponent
  if not ___MOD.isvalid(costume) then
    return
  end
  avatarEnt:SetEnable(true)
  local userid = ___MOD.tostring(entry.userid or "")
  local look = entry.look
  local useCody = (___MOD.tonumber(entry.mswcody) or 0) == 1 and not ___MOD._UtilLogic:IsNilorEmptyString(userid)
  if useCody and ___MOD.Environment:IsMakerPlay() and ___MOD.type(look) == "table" then
    useCody = false
  end
  if useCody then
    costume.UseCustomEquipOnly = false
    costume.DefaultEquipUserId = userid
    for i = 1, 19 do
      local category = ___MOD.MapleAvatarItemCategory.CastFrom(i)
      ___MOD.pcall(function()
        costume:SetEquip(category, "")
      end)
    end
    return
  end
  costume.DefaultEquipUserId = ""
  costume.UseCustomEquipOnly = true
  if ___MOD.type(look) ~= "table" then
    look = {}
  end
  local gender = ___MOD.tonumber(look.gender) or 0
  local hair = ___MOD.tonumber(look.hair) or 0
  local face = ___MOD.tonumber(look.face) or 0
  local skin = ___MOD.tonumber(look.skin) or 0
  costume:SetEquip(___MOD.MapleAvatarItemCategory.Hair, ___MOD.__RUIDManager:get(___MOD.tostring(hair)))
  costume:SetEquip(___MOD.MapleAvatarItemCategory.Face, ___MOD.__RUIDManager:get(___MOD.tostring(face)))
  local bodyRuid = ___MOD._PlayerSkinType:getSkinRUID(skin)
  if not ___MOD._UtilLogic:IsNilorEmptyString(bodyRuid) then
    costume:SetEquip(___MOD.MapleAvatarItemCategory.Body, bodyRuid)
    costume.CustomBodyEquip = bodyRuid
  end
  local defaultCoat = gender == 0 and "d7ca735739a244b88fc10d140b01b03c" or "51ff3745499944a79402e7bd3d3c4016"
  local defaultPants = gender == 0 and "ef0b8ee74abf47adb54e43426d9166e6" or "829c0b278e094bb0a1100a5e6e8abe4a"
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
  local items = look.items
  if ___MOD.type(items) == "table" then
    for _, itemId in ___MOD.ipairs(items) do
      local id = ___MOD.tonumber(itemId) or 0
      if 0 < id then
        local category = ___MOD._PlayerAvatarLookLogic:getAvatarItemCategory(id)
        local ruid = ___MOD.__RUIDManager:get(___MOD.tostring(id))
        if category ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
          ___MOD.pcall(function()
            costume:SetEquip(category, ruid)
            if category == ___MOD.MapleAvatarItemCategory.OneHandedWeapon then
              costume:SetEquip(___MOD.MapleAvatarItemCategory.TwoHandedWeapon, "")
            elseif category == ___MOD.MapleAvatarItemCategory.TwoHandedWeapon then
              costume:SetEquip(___MOD.MapleAvatarItemCategory.OneHandedWeapon, "")
            end
          end)
        end
      end
    end
  end
end

function Dojang.applyDojangRankRows(self, entries, rankMode, page, total)
  rankMode = self:normalizeDojangRankMode(rankMode)
  if self._T.dojangRankMode ~= nil and self._T.dojangRankMode ~= rankMode then
    return
  end
  entries = entries or {}
  self._T.dojangRankMode = rankMode
  self._T.dojangRankPage = page
  if 0 < (___MOD.tonumber(total) or 0) then
    self._T.dojangRankTotal = ___MOD.tonumber(total)
  end
  for row = 2, 7 do
    local base = "/ui/DojangGroup/DojangRankBoard/RankRows/Row" .. ___MOD.tostring(row)
    for col = 1, 6 do
      self:setDojangRankTextClient(base .. "/Col" .. ___MOD.tostring(col), "")
    end
    self:setDojangRankJobCellClient(base .. "/Col3", "", nil)
  end
  for i = 1, ___MOD.math.min(6, #entries) do
    self:fillDojangRankRowClient(i + 1, entries[i])
  end
  self:renderDojangRankTop5Client()
  self:applyCachedMyDojangRankClient(rankMode)
  local totalPages = self:getDojangRankTotalPagesClient(self._T.dojangRankTotal or 0)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", ___MOD.tostring(page) .. " / " .. ___MOD.tostring(totalPages))
end

function Dojang.applyMyDojangDamageRank(self, entry, rankMode)
  if self._T.dojangDamageRankMode ~= nil and self._T.dojangDamageRankMode ~= rankMode then
    return
  end
  self._T.dojangDamageMyRankEntry = entry or {rank = 0, damage = 0}
  self:applyCachedMyDojangDamageRankClient()
end

function Dojang.applyMyDojangRank(self, entry, rankMode)
  self._T.dojangMyRankEntries = self._T.dojangMyRankEntries or {}
  self._T.dojangMyRankEntries[rankMode] = entry or {
    rank = 0,
    floor = 0,
    clearTime = 0
  }
  if self._T.dojangRankMode == rankMode then
    self:applyCachedMyDojangRankClient(rankMode)
  end
end

function Dojang.beginDojangDamageTestWithBlockCheck(self, player, fs)

end

function Dojang.beginDojoEntryWithBlockCheck(self, player, practiceMode)

end

function Dojang.beltDialog(self, player, udc)

end

function Dojang.buildDojangDamageRankCacheEntries(self, list)

end

function Dojang.buildDojangRankCacheEntries(self, list)

end

function Dojang.buildDojangRankLook(self, player)

end

function Dojang.buildDojoRankRewardConfirmMessage(self, rewards)

end

function Dojang.buildDojoRankRewards(self, rankEntry, expireTime)

end

function Dojang.bumpDojangSearchGenerationClient(self, boardName)
  if boardName == "DojangRankBoard" then
    local generation = ___MOD.math.floor(___MOD.tonumber(self._T.dojangRankSearchGeneration) or 0) + 1
    self._T.dojangRankSearchGeneration = generation
    return generation
  end
  local generation = ___MOD.math.floor(___MOD.tonumber(self._T.dojangDamageRankSearchGeneration) or 0) + 1
  self._T.dojangDamageRankSearchGeneration = generation
  return generation
end

function Dojang.cacheScriptFunc(self)

end

function Dojang.canGainDojoRankRewards(self, player, rewards)

end

function Dojang.claimDojoRankReward(self, player, udc)

end

function Dojang.clearCurrentDojoDrops(self, player)

end

function Dojang.clearDojangDamageRankBoardClient(self)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangDamageRankBoard/PageText", "")
  for rank = 1, 5 do
    local base = "/ui/DojangGroup/DojangDamageRankBoard/TopRank" .. ___MOD.tostring(rank)
    self:setDojangRankTextClient(base .. "/NameText", "")
    self:setDojangRankTextClient(base .. "/RecordText", "")
    self:setDojangRankTextClient(base .. "/GuildText", "")
    local avatarEnt = ___MOD._EntityService:GetEntityByPath(base .. "/Avatar")
    if ___MOD.isvalid(avatarEnt) then
      avatarEnt:SetEnable(false)
    end
  end
  self:clearDojangDamageRankRowsClient(1)
end

function Dojang.clearDojangDamageRankRowsClient(self, firstRow)
  for row = ___MOD.math.max(1, firstRow), 7 do
    local base = "/ui/DojangGroup/DojangDamageRankBoard/RankRows/Row" .. ___MOD.tostring(row)
    for col = 1, 6 do
      self:setDojangRankTextClient(base .. "/Col" .. ___MOD.tostring(col), "")
    end
    self:setDojangRankJobCellClient(base .. "/Col3", "", nil)
  end
end

function Dojang.clearDojangRankBoardClient(self)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", "")
  for rank = 1, 5 do
    local base = "/ui/DojangGroup/DojangRankBoard/TopRank" .. ___MOD.tostring(rank)
    self:setDojangRankTextClient(base .. "/NameText", "")
    self:setDojangRankTextClient(base .. "/RecordText", "")
    self:setDojangRankTextClient(base .. "/GuildText", "")
    local avatarEnt = ___MOD._EntityService:GetEntityByPath(base .. "/Avatar")
    if ___MOD.isvalid(avatarEnt) then
      avatarEnt:SetEnable(false)
    end
  end
  for row = 1, 7 do
    local base = "/ui/DojangGroup/DojangRankBoard/RankRows/Row" .. ___MOD.tostring(row)
    for col = 1, 6 do
      self:setDojangRankTextClient(base .. "/Col" .. ___MOD.tostring(col), "")
    end
    self:setDojangRankJobCellClient(base .. "/Col3", "", nil)
  end
end

function Dojang.clearDojangSearchTextClient(self, boardName)
  local textEnt = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/" .. boardName .. "/SearchBox/SearchText")
  if not ___MOD.isvalid(textEnt) then
    return
  end
  if textEnt.TextInputComponent ~= nil then
    textEnt.TextInputComponent.Text = ""
  end
  if textEnt.TextComponent ~= nil then
    textEnt.TextComponent.Text = ""
  end
end

function Dojang.collectDojangBlockEquips(self, player)

end

function Dojang.collectDojangEquippedBlockItems(self, player)

end

function Dojang.composeDojangRankMode(self, period, job)
  period = period == "weekly_last" and "weekly_last" or "weekly_current"
  return period .. "#" .. ___MOD.tostring(___MOD.math.floor(___MOD.tonumber(job) or -1))
end

function Dojang.connectDojangDamageRankPageClient(self)
  if self._T.dojangDamageRankPageHandlers ~= nil then
    return
  end
  local connected = {}
  local pagers = {PrevPageButton = -1, NextPageButton = 1}
  for btnName, pageDelta in ___MOD.pairs(pagers) do
    local btn = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojangDamageRankBoard/" .. btnName)
    if ___MOD.isvalid(btn) then
      local capturedDelta = pageDelta
      local eventHandler = btn:ConnectEvent(___MOD.ButtonClickEvent, function()
        self:onDojangDamageRankPageClient(capturedDelta)
      end)
      connected[#connected + 1] = {entity = btn, eventHandler = eventHandler}
    end
  end
  local tabs = {
    WeeklyNowRankButton = "weekly_current",
    WeeklyBeforeRankButton = "weekly_last"
  }
  for btnName, tabMode in ___MOD.pairs(tabs) do
    local btn = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojangDamageRankBoard/" .. btnName)
    if ___MOD.isvalid(btn) then
      local capturedMode = tabMode
      local eventHandler = btn:ConnectEvent(___MOD.ButtonClickEvent, function()
        self:onDojangDamageRankTabClient(capturedMode)
      end)
      connected[#connected + 1] = {entity = btn, eventHandler = eventHandler}
      local stateHandler = btn:ConnectEvent(___MOD.ButtonStateChangeEvent, function()
        if self:getDojangRankPeriod(self._T.dojangDamageRankMode or "") == capturedMode then
          self:setDojangDamageRankTabVisualClient(self._T.dojangDamageRankMode or capturedMode)
        end
      end)
      connected[#connected + 1] = {entity = btn, eventHandler = stateHandler}
    end
  end
  self._T.dojangDamageRankPageHandlers = connected
end

function Dojang.connectDojangRankTabsClient(self)
  if self._T.dojangRankTabHandlers ~= nil then
    return
  end
  local modes = {
    WeeklyNowRankButton = "weekly_current",
    WeeklyBeforeRankButton = "weekly_last"
  }
  local connected = {}
  for btnName, rankMode in ___MOD.pairs(modes) do
    local btn = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojangRankBoard/" .. btnName)
    if ___MOD.isvalid(btn) then
      local capturedMode = rankMode
      local eventHandler = btn:ConnectEvent(___MOD.ButtonClickEvent, function()
        self:onDojangRankTabClient(capturedMode)
      end)
      connected[#connected + 1] = {entity = btn, eventHandler = eventHandler}
      local stateHandler = btn:ConnectEvent(___MOD.ButtonStateChangeEvent, function()
        if self:getDojangRankPeriod(self._T.dojangRankMode or "") == capturedMode then
          self:setDojangRankTabVisualClient(self._T.dojangRankMode or capturedMode)
        end
      end)
      connected[#connected + 1] = {entity = btn, eventHandler = stateHandler}
    end
  end
  local pagers = {PrevPageButton = -1, NextPageButton = 1}
  for btnName, pageDelta in ___MOD.pairs(pagers) do
    local btn = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojangRankBoard/" .. btnName)
    if ___MOD.isvalid(btn) then
      local capturedDelta = pageDelta
      local eventHandler = btn:ConnectEvent(___MOD.ButtonClickEvent, function()
        self:onDojangRankPageClient(capturedDelta)
      end)
      connected[#connected + 1] = {entity = btn, eventHandler = eventHandler}
    end
  end
  self._T.dojangRankTabHandlers = connected
end

function Dojang.consumeDojangRankRequestQuota(self, player, action, refillPerSecond, burst)

end

function Dojang.createDojoRankRewardItemInfo(self, itemId, expireTime)

end

function Dojang.dojang_DPS(self, player)

end

function Dojang.dojang_enter(self, player, udc)

end

function Dojang.dojang_exit(self, player, udc, portal)

end

function Dojang.dojang_next(self, player, udc, portal)

end

function Dojang.dojang_up(self, player, udc, portal)

end

function Dojang.dummyDamageDialog(self, player, udc)

end

function Dojang.ensureDojangDamageRankCache(self, player, mode, callback)

end

function Dojang.ensureDojangRankCache(self, player, rankMode, callback)

end

function Dojang.ensureDojangRankFlushTimer(self)

end

function Dojang.ensureDojoRankRewardCache(self, weekId, callback)

end

function Dojang.ensureDojoRankRewardCacheFresh(self)

end

function Dojang.exitDojo(self, player)

end

function Dojang.fillDojangDamageRankRowClient(self, row, entry)
  if entry == nil or row < 1 or 7 < row then
    return
  end
  local baseColor = ___MOD.Color(0.06666667, 0.06666667, 0.06666667, 1)
  local base = "/ui/DojangGroup/DojangDamageRankBoard/RankRows/Row" .. ___MOD.tostring(row)
  local rank = ___MOD.tonumber(entry.rank) or 0
  local name = ___MOD.tostring(entry.name or "")
  local job = entry.job
  local level = ___MOD.tonumber(entry.level) or 0
  if row == 1 and rank <= 0 then
    local lp = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(lp) and ___MOD.isvalid(lp.Player) then
      name = ___MOD.tostring(lp.Player.Name or name)
      job = ___MOD.tonumber(lp.Player.Job) or job
      level = ___MOD.tonumber(lp.Player.Level) or level
    end
  end
  self:setDojangRankTextColorClient(base .. "/Col1", 0 < rank and ___MOD.tostring(rank) .. "위" or "-위", baseColor)
  self:setDojangRankTextColorClient(base .. "/Col2", name, baseColor)
  self:setDojangRankJobCellClient(base .. "/Col3", self:getDojangRankJobNameClient(job), baseColor)
  self:setDojangRankTextColorClient(base .. "/Col4", ___MOD.tostring(level), baseColor)
  self:setDojangRankTextColorClient(base .. "/Col5", self:formatDojangDamageNumber(___MOD.tonumber(entry.damage) or 0), baseColor)
  self:setDojangRankTextColorClient(base .. "/Col6", ___MOD.tostring(entry.guild or ""), baseColor)
end

function Dojang.fillDojangRankRowClient(self, row, entry)
  if entry == nil or row < 1 or 7 < row then
    return
  end
  local baseColor = ___MOD.Color(0.06666667, 0.06666667, 0.06666667, 1)
  local floor = ___MOD.tonumber(entry.floor) or 0
  local recordText = ___MOD.string.format("%d층 / %s", floor, self:formatDojangRankTime(___MOD.tonumber(entry.clearTime) or 0))
  local base = "/ui/DojangGroup/DojangRankBoard/RankRows/Row" .. ___MOD.tostring(row)
  local rank = ___MOD.tonumber(entry.rank) or 0
  local name = ___MOD.tostring(entry.name or "")
  local job = entry.job
  local level = ___MOD.tonumber(entry.level) or 0
  if row == 1 and rank <= 0 then
    local lp = ___MOD._UserService.LocalPlayer
    if ___MOD.isvalid(lp) and ___MOD.isvalid(lp.Player) then
      name = ___MOD.tostring(lp.Player.Name or name)
      job = ___MOD.tonumber(lp.Player.Job) or job
      level = ___MOD.tonumber(lp.Player.Level) or level
    end
  end
  self:setDojangRankTextColorClient(base .. "/Col1", 0 < rank and ___MOD.tostring(rank) .. "위" or "-위", baseColor)
  self:setDojangRankTextColorClient(base .. "/Col2", name, baseColor)
  self:setDojangRankJobCellClient(base .. "/Col3", self:getDojangRankJobNameClient(job), baseColor)
  self:setDojangRankTextColorClient(base .. "/Col4", ___MOD.tostring(level), baseColor)
  self:setDojangRankTextColorClient(base .. "/Col5", recordText, self:getDojangRankFloorColor(floor))
  self:setDojangRankTextColorClient(base .. "/Col6", ___MOD.tostring(entry.guild or ""), baseColor)
end

function Dojang.filterMissingDojoRankRewards(self, player, rewards)

end

function Dojang.finishDojoRankRewardCacheLoad(self, weekId, ok, payload)

end

function Dojang.flushDojangRankWeb(self)

end

function Dojang.formatDojangBlockLines(self, blocked)

end

function Dojang.formatDojangDamageNumber(self, value)
  local text = ___MOD.string.format("%.0f", ___MOD.math.max(0, value))
  local suffix = ""
  while 3 < #text do
    suffix = "," .. ___MOD.string.sub(text, #text - 2) .. suffix
    text = ___MOD.string.sub(text, 1, #text - 3)
  end
  return text .. suffix
end

function Dojang.formatDojangRankGuild(self, guildName)
  if ___MOD._UtilLogic:IsNilorEmptyString(guildName) then
    return ""
  end
  return "[" .. guildName .. "]"
end

function Dojang.formatDojangRankTime(self, totalMs)
  local totalSec = ___MOD.math.max(0, totalMs) // 1000
  if totalSec == 0 then
    return "00:00"
  end
  return ___MOD.string.format("%d:%02d", totalSec // 60, totalSec % 60)
end

function Dojang.gainDojoRankRewards(self, player, rewards)

end

function Dojang.getDojangDamageRankCacheKey(self, player, mode)

end

function Dojang.getDojangMonthKey(self)

end

function Dojang.getDojangRankCacheKey(self, player, rankMode)

end

function Dojang.getDojangRankComboItemForJob(self, job)
  local group = self:getDojangRankJobGroup(job)
  for _, item in ___MOD.ipairs(self:getDojangRankJobFilterList()) do
    if item.job >= 0 and self:getDojangRankJobGroup(item.job) == group then
      return item
    end
  end
  return nil
end

function Dojang.getDojangRankExpectedPeriodStart(self, periodToken)

end

function Dojang.getDojangRankFloorColor(self, floor)
  if 30 <= floor then
    return ___MOD.Color(0.843137264, 0.09803922, 0.1254902, 1)
  elseif 20 <= floor then
    return ___MOD.Color(0.52156866, 0.32156864, 0.13333334, 1)
  elseif 10 <= floor then
    return ___MOD.Color(0.06666667, 0.06666667, 0.06666667, 1)
  end
  return ___MOD.Color(0.654902, 0.647058845, 0.6392157, 1)
end

function Dojang.getDojangRankJobFilterList(self)
  return {
    {job = -1, name = "전체"},
    {job = 0, name = "초보자"},
    {job = 100, name = "검사"},
    {job = 112, name = "히어로"},
    {job = 122, name = "팔라딘"},
    {
      job = 132,
      name = "다크나이트"
    },
    {job = 200, name = "마법사"},
    {
      job = 212,
      name = "아크메이지(불,독)"
    },
    {
      job = 222,
      name = "아크메이지(썬,콜)"
    },
    {job = 232, name = "비숍"},
    {job = 300, name = "아처"},
    {
      job = 312,
      name = "보우마스터"
    },
    {job = 322, name = "신궁"},
    {job = 400, name = "로그"},
    {
      job = 412,
      name = "나이트로드"
    },
    {job = 422, name = "섀도어"},
    {job = 500, name = "해적"},
    {job = 512, name = "바이퍼"},
    {job = 522, name = "캡틴"},
    {
      job = 1000,
      name = "노블레스"
    },
    {
      job = 1100,
      name = "소울마스터"
    },
    {
      job = 1200,
      name = "플레임위자드"
    },
    {
      job = 1300,
      name = "윈드브레이커"
    },
    {
      job = 1400,
      name = "나이트워커"
    },
    {
      job = 1500,
      name = "스트라이커"
    },
    {job = 2100, name = "아란"}
  }
end

function Dojang.getDojangRankJobFromMode(self, rankMode)
  local mode = ___MOD.tostring(rankMode or "")
  local hashPos = ___MOD.string.find(mode, "#", 1, true)
  if hashPos == nil then
    return -1
  end
  return ___MOD.math.floor(___MOD.tonumber(___MOD.string.sub(mode, hashPos + 1)) or -1)
end

function Dojang.getDojangRankJobGroup(self, job)
  job = ___MOD.math.max(0, ___MOD.math.floor(___MOD.tonumber(job) or 0))
  if 1100 <= job then
    return 1000 + job // 100
  end
  return job // 10
end

function Dojang.getDojangRankJobNameClient(self, job)
  return ___MOD.tostring(___MOD._PlayerConstants:getJobNameById(___MOD.tonumber(job) or 0) or "")
end

function Dojang.getDojangRankPeriod(self, rankMode)
  local mode = ___MOD.tostring(rankMode or "")
  local hashPos = ___MOD.string.find(mode, "#", 1, true)
  if hashPos ~= nil then
    mode = ___MOD.string.sub(mode, 1, hashPos - 1)
  end
  if mode == "weekly_last" then
    return "weekly_last"
  end
  return "weekly_current"
end

function Dojang.getDojangRankPeriodOffset(self, rankMode)
  return self:getDojangRankPeriod(rankMode) == "weekly_last" and -1 or 0
end

function Dojang.getDojangRankScope(self, rankMode)
  return self:getDojangRankJobFromMode(rankMode) >= 0 and "job" or "all"
end

function Dojang.getDojangRankTotalPagesClient(self, total)
  total = ___MOD.tonumber(total) or 0
  return ___MOD.math.max(1, ___MOD.math.ceil(total / 6))
end

function Dojang.getDojangUnavailableEquipItemName(self, itemId)

end

function Dojang.getDojoClearPointReward(self, floor)

end

function Dojang.getDojoDailyEntryTryCount(self, player)

end

function Dojang.getDojoDamageMeterDisplaySkillID(self, skillID)
  if skillID == ___MOD._SkillBook.hidden_Full_Swing__Double_Swing_2111_21110007 or skillID == ___MOD._SkillBook.hidden_Over_Swing__Double_Swing_2112_21120009 then
    return ___MOD._SkillBook.Double_Swing_2100_21000002
  elseif skillID == ___MOD._SkillBook.hidden_Full_Swing__Triple_Swing_2111_21110008 or skillID == ___MOD._SkillBook.hidden_Over_Swing__Triple_Swing_2112_21120010 then
    return ___MOD._SkillBook.Triple_Swing_2110_21100001
  end
  return skillID
end

function Dojang.getDojoFieldSetByMap(self, mapid)

end

function Dojang.getDojoPoints(self, player)

end

function Dojang.getDojoRankRewardExpireTime(self)

end

function Dojang.getDojoWeekId(self)

end

function Dojang.getEquippedDojangUnavailableItemId(self, player)

end

function Dojang.getStageId(self, mapid)
  if 925020600 <= mapid and mapid <= 925020614 then
    return 1
  elseif 925021200 <= mapid and mapid <= 925021214 then
    return 2
  elseif 925021800 <= mapid and mapid <= 925021814 then
    return 3
  elseif 925022400 <= mapid and mapid <= 925022414 then
    return 4
  elseif 925023000 <= mapid and mapid <= 925023014 then
    return 5
  elseif 925023600 <= mapid and mapid <= 925023614 then
    return 6
  end
  return 0
end

function Dojang.hasDojoRankRewardItemById(self, player, itemId)

end

function Dojang.hasParty(self, player)
  return ___MOD.isvalid(player.Player) and player.Player.PartyId > 0
end

function Dojang.initDojangJobComboBoxClient(self, boardName)
  local combo = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/" .. boardName .. "/searchType")
  if not ___MOD.isvalid(combo) or combo.N_ComboBoxComponent == nil then
    return
  end
  if self._T.dojangJobComboReady == nil then
    self._T.dojangJobComboReady = {}
  end
  local cb = combo.N_ComboBoxComponent
  if self._T.dojangJobComboReady[boardName] then
    self._T["dojangJobComboOpen_" .. boardName] = false
    cb:visible(false)
    self:setDojangRankTextClient("/ui/DojangGroup/" .. boardName .. "/searchType/text", "전체")
    return
  end
  self._T.dojangJobComboReady[boardName] = true
  cb:initializeComboBox(34)
  for _, item in ___MOD.ipairs(self:getDojangRankJobFilterList()) do
    cb:addItem(item.job, item.name)
  end
  local capturedBoard = boardName
  combo:ConnectEvent(___MOD.ButtonClickEvent, function()
    local key = "dojangJobComboOpen_" .. capturedBoard
    local open = not self._T[key] and true
    self._T[key] = open
    cb:visible(open)
  end)
  combo:ConnectEvent(___MOD.ComboBoxEntryClickEvent, function(event)
    self._T["dojangJobComboOpen_" .. capturedBoard] = false
    cb:visible(false)
    self:onDojangJobSelectedClient(capturedBoard, event.param, event.entryName, false)
  end)
  self:setDojangRankTextClient("/ui/DojangGroup/" .. boardName .. "/searchType/text", "전체")
end

function Dojang.initDojangSearchBtnClient(self, boardName)
  local btn = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/" .. boardName .. "/SearchBox/SearchBtn")
  if not ___MOD.isvalid(btn) then
    return
  end
  if self._T.dojangSearchReady == nil then
    self._T.dojangSearchReady = {}
  end
  if self._T.dojangSearchReady[boardName] then
    return
  end
  self._T.dojangSearchReady[boardName] = true
  local capturedBoard = boardName
  btn:ConnectEvent(___MOD.ButtonClickEvent, function()
    self:onDojangRankSearchClient(capturedBoard)
  end)
end

function Dojang.isAllowedDojangRankJobFilter(self, job)

end

function Dojang.isCurrentDojangSearchRequestClient(self, boardName, requestMode, requestGeneration)
  local board = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/" .. boardName)
  if not ___MOD.isvalid(board) or not board.Enable then
    return false
  end
  requestGeneration = ___MOD.math.floor(___MOD.tonumber(requestGeneration) or -1)
  if boardName == "DojangRankBoard" then
    return requestGeneration == ___MOD.math.floor(___MOD.tonumber(self._T.dojangRankSearchGeneration) or 0) and self:normalizeDojangRankMode(self._T.dojangRankMode or "") == self:normalizeDojangRankMode(requestMode)
  end
  return requestGeneration == ___MOD.math.floor(___MOD.tonumber(self._T.dojangDamageRankSearchGeneration) or 0) and self:normalizeDojangDamageRankMode(self._T.dojangDamageRankMode or "") == self:normalizeDojangDamageRankMode(requestMode)
end

function Dojang.isDojangBlockEquipmentExcludedItem(self, itemId)

end

function Dojang.isDojangDamageEquipSwapBlockedServer(self, player, equip, itemId)

end

function Dojang.isDojangEquipSwapBlockedServer(self, player, equip, itemId)

end

function Dojang.isDojangRankCacheFresh(self, cache, periodToken)

end

function Dojang.isDojangRankCacheWeekCompatible(self, cache, periodToken)

end

function Dojang.isDojangRankPeriodStartCurrent(self, periodToken, periodStart)

end

function Dojang.isDojangUnavailableEquipItem(self, itemId)

end

function Dojang.isDojangUnavailableEquipSwapBlockedServer(self, player, itemId)

end

function Dojang.isDojoBattleFloorClient(self)
  local player = ___MOD._UserService.LocalPlayer
  if not (___MOD.isvalid(player) and ___MOD.isvalid(player.CurrentMap)) or player.CurrentMap.MapInfoComponent == nil then
    return false
  end
  local mapid = ___MOD.tonumber(player.CurrentMap.MapInfoComponent.mapID or 0) or 0
  if not ___MOD._MapManager:isDojoField(mapid) then
    return false
  end
  return self:getStageId(mapid) == 0
end

function Dojang.isDojoCleared(self, mapid)

end

function Dojang.isDojoInUse(self)

end

function Dojang.isDojoMidnightBlock(self)

end

function Dojang.isDojoMidnightBlockFrom(self, fromMinute)

end

function Dojang.isDojoPracticeInUse(self)

end

function Dojang.isDojoRankRewardItem(self, itemId)

end

function Dojang.isRestingSpot(self, mapid)
  return self:getStageId(mapid) > 0
end

function Dojang.loadDojangDamageRankBoard(self, player, mode, page)

end

function Dojang.loadDojangRankBoard(self, player, rankMode)

end

function Dojang.loadMyDojangDamageRankCached(self, player, mode, callback)

end

function Dojang.loadMyDojangRankCached(self, player, rankMode, callback)

end

function Dojang.lobbyDialog(self, player, udc)

end

function Dojang.logDojangEquipment(self, player, action, ulid, itemId, month, reason, extra)

end

function Dojang.markDojoCmdSkillUsedClient(self, skillID)
  self._T.dojoCmdSkillUsedClient = self._T.dojoCmdSkillUsedClient or {}
  self._T.dojoCmdSkillUsedClient[skillID] = true
end

function Dojang.normalizeDojangDamageRankMode(self, mode)
  return self:composeDojangRankMode(self:getDojangRankPeriod(mode), self:getDojangRankJobFromMode(mode))
end

function Dojang.normalizeDojangRankMode(self, rankMode)
  return self:composeDojangRankMode(self:getDojangRankPeriod(rankMode), self:getDojangRankJobFromMode(rankMode))
end

function Dojang.OnBeginPlay(self)
  if self:IsServer() then
    self._T.dojoRankRewardStartupTimer = ___MOD._TimerService:SetTimerOnce(function()
      self._T.dojoRankRewardStartupTimer = 0
      self:preloadDojoRankRewardCache()
    end, 1)
    return
  end
  self.dojoKeyHandler = ___MOD._InputService:ConnectEvent(___MOD.KeyDownEvent, self.onDojoCommandKeyDown)
end

function Dojang.onDojangDamageRankPageClient(self, delta)
  local page = (self._T.dojangDamageRankPage or 1) + delta
  local totalPages = self:getDojangRankTotalPagesClient(self._T.dojangDamageRankTotal or 0)
  if page < 1 or page > totalPages then
    return
  end
  self:bumpDojangSearchGenerationClient("DojangDamageRankBoard")
  self._T.dojangDamageSearchRowHold = nil
  self:requestDojangDamageRankPage(self._T.dojangDamageRankMode or "weekly_current", page)
end

function Dojang.onDojangDamageRankTabClient(self, mode)
  self:bumpDojangSearchGenerationClient("DojangDamageRankBoard")
  local period = self:getDojangRankPeriod(mode)
  local job = self:getDojangRankJobFromMode(self._T.dojangDamageRankMode or "")
  mode = self:composeDojangRankMode(period, job)
  self._T.dojangDamageSearchRowHold = nil
  self._T.dojangDamageRankMode = mode
  self._T.dojangDamageRankPage = 1
  self._T.dojangDamageRankTotal = 0
  self._T.dojangDamageMyRankEntry = {rank = 0, damage = 0}
  self._T.dojangDamageRankTop5 = {}
  self:clearDojangDamageRankBoardClient()
  self:setDojangDamageRankTabVisualClient(mode)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangDamageRankBoard/PageText", "Loading")
  self:requestDojangDamageRankPage(mode, 1)
end

function Dojang.onDojangJobSelectedClient(self, boardName, job, jobName, preserveSearchRequest)
  if not preserveSearchRequest then
    self:bumpDojangSearchGenerationClient(boardName)
  end
  if boardName == "DojangRankBoard" then
    self._T.dojangSearchRowHold = nil
  else
    self._T.dojangDamageSearchRowHold = nil
  end
  self:setDojangRankTextClient("/ui/DojangGroup/" .. boardName .. "/searchType/text", jobName)
  if boardName == "DojangRankBoard" then
    local period = self:getDojangRankPeriod(self._T.dojangRankMode or "")
    local rankMode = self:composeDojangRankMode(period, job)
    self._T.dojangRankMode = rankMode
    self._T.dojangRankPage = 1
    self._T.dojangMyRankEntries = self._T.dojangMyRankEntries or {}
    self._T.dojangMyRankEntries[rankMode] = self._T.dojangMyRankEntries[rankMode] or {
      rank = 0,
      floor = 0,
      clearTime = 0
    }
    self:clearDojangRankBoardClient()
    self:setDojangRankTabVisualClient(rankMode)
    self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", "Loading")
    self:requestDojangRankTab(rankMode)
  else
    local period = self:getDojangRankPeriod(self._T.dojangDamageRankMode or "")
    local rankMode = self:composeDojangRankMode(period, job)
    self._T.dojangDamageRankMode = rankMode
    self._T.dojangDamageRankPage = 1
    self._T.dojangDamageRankTotal = 0
    self._T.dojangDamageMyRankEntry = {rank = 0, damage = 0}
    self._T.dojangDamageRankTop5 = {}
    self:clearDojangDamageRankBoardClient()
    self:setDojangDamageRankTabVisualClient(rankMode)
    self:setDojangRankTextClient("/ui/DojangGroup/DojangDamageRankBoard/PageText", "Loading")
    self:requestDojangDamageRankPage(rankMode, 1)
  end
end

function Dojang.onDojangRankPageClient(self, delta)
  local rankMode = self._T.dojangRankMode or "weekly_current"
  local page = (self._T.dojangRankPage or 1) + delta
  local totalPages = self:getDojangRankTotalPagesClient(self._T.dojangRankTotal or 0)
  if page < 1 or page > totalPages then
    return
  end
  self:bumpDojangSearchGenerationClient("DojangRankBoard")
  self._T.dojangSearchRowHold = nil
  self:requestDojangRankPage(rankMode, page)
end

function Dojang.onDojangRankSearchClient(self, boardName)
  local textEnt = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/" .. boardName .. "/SearchBox/SearchText")
  if not ___MOD.isvalid(textEnt) or textEnt.TextInputComponent == nil then
    return
  end
  local requestGeneration = self:bumpDojangSearchGenerationClient(boardName)
  local name = ___MOD.string.match(___MOD.tostring(textEnt.TextInputComponent.Text or ""), "^%s*(.-)%s*$") or ""
  if ___MOD._UtilLogic:IsNilorEmptyString(name) then
    return
  end
  if boardName == "DojangRankBoard" then
    local mode = self._T.dojangRankMode or ""
    self:requestDojangRankSearch(name, self:getDojangRankPeriodOffset(mode), self:getDojangRankJobFromMode(mode), requestGeneration)
  else
    local mode = self._T.dojangDamageRankMode or ""
    self:requestDojangDamageRankSearch(name, self:getDojangRankPeriodOffset(mode), self:getDojangRankJobFromMode(mode), requestGeneration)
  end
end

function Dojang.onDojangRankTabClient(self, rankMode)
  self:bumpDojangSearchGenerationClient("DojangRankBoard")
  self._T.dojangSearchRowHold = nil
  local period = self:getDojangRankPeriod(rankMode)
  local job = self:getDojangRankJobFromMode(self._T.dojangRankMode or "")
  rankMode = self:composeDojangRankMode(period, job)
  self:clearDojangRankBoardClient()
  self._T.dojangRankMode = rankMode
  self._T.dojangMyRankEntries = self._T.dojangMyRankEntries or {}
  self._T.dojangMyRankEntries[rankMode] = self._T.dojangMyRankEntries[rankMode] or {
    rank = 0,
    floor = 0,
    clearTime = 0
  }
  self:setDojangRankTabVisualClient(rankMode)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", "Loading")
  self:requestDojangRankTab(rankMode)
end

function Dojang.onDojoCommandKeyDown(self, event)
  if ___MOD._DojoRaidUILogic.energyRatio < 1 then
    return
  end
  if not self:isDojoBattleFloorClient() then
    return
  end
  local k = event.key
  local isCtrlKey = k == ___MOD.KeyboardKey.LeftControl or k == ___MOD.KeyboardKey.RightControl
  local isAltKey = k == ___MOD.KeyboardKey.LeftAlt or k == ___MOD.KeyboardKey.RightAlt
  local isDirectionKey = k == ___MOD.KeyboardKey.UpArrow or k == ___MOD.KeyboardKey.LeftArrow or k == ___MOD.KeyboardKey.RightArrow
  if not isCtrlKey and not isAltKey and not isDirectionKey then
    return
  end
  local ctrlHeld = isCtrlKey or ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.LeftControl) or ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.RightControl)
  local altHeld = isAltKey or ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.LeftAlt) or ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.RightAlt)
  if not ctrlHeld or not altHeld then
    return
  end
  local dir
  if k == ___MOD.KeyboardKey.UpArrow then
    dir = "up"
  elseif k == ___MOD.KeyboardKey.LeftArrow then
    dir = "left"
  elseif k == ___MOD.KeyboardKey.RightArrow then
    dir = "right"
  elseif ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.UpArrow) then
    dir = "up"
  elseif ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.LeftArrow) then
    dir = "left"
  elseif ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.RightArrow) then
    dir = "right"
  end
  if dir == nil then
    return
  end
  self:useDojoCommandSkillClient(dir)
end

function Dojang.OnUpdate(self, delta)
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if now - self.dojoDamageMeterLastRefresh < 1 then
    return
  end
  self.dojoDamageMeterLastRefresh = now
  local aliveSamples = {}
  for i = 1, #self.dojoDamageSamples do
    local sample = self.dojoDamageSamples[i]
    if now - (___MOD.tonumber(sample.t or 0) or 0) <= 10 then
      aliveSamples[#aliveSamples + 1] = sample
    end
  end
  self.dojoDamageSamples = aliveSamples
  local meter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeter")
  local bigMeter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterBig")
  local miniMeter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterSmall")
  if (not ___MOD.isvalid(meter) or not meter.Enable) and (not ___MOD.isvalid(bigMeter) or not bigMeter.Enable) and (not ___MOD.isvalid(miniMeter) or not miniMeter.Enable) then
    return
  end
  self:refreshDojoDamageMeterClient()
end

function Dojang.openDojangDamageRank(self)
  local rankBoard = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojangDamageRankBoard")
  if not ___MOD.isvalid(rankBoard) then
    return
  end
  self:bumpDojangSearchGenerationClient("DojangDamageRankBoard")
  self:connectDojangDamageRankPageClient()
  self:clearDojangDamageRankBoardClient()
  self._T.dojangDamageSearchRowHold = nil
  self:clearDojangSearchTextClient("DojangDamageRankBoard")
  local defaultMode = self:composeDojangRankMode("weekly_current", -1)
  self._T.dojangDamageRankMode = defaultMode
  self._T.dojangDamageRankPage = 1
  self._T.dojangDamageRankTotal = 0
  self._T.dojangDamageMyRankEntry = {rank = 0, damage = 0}
  self:setDojangDamageRankTabVisualClient(defaultMode)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangDamageRankBoard/PageText", "Loading")
  if not rankBoard.Enable then
    ___MOD._UIWindowLogic:enableUI(rankBoard)
  end
  ___MOD._UIWindowLogic:moveToTopLayer(rankBoard)
  self:initDojangJobComboBoxClient("DojangDamageRankBoard")
  self:initDojangSearchBtnClient("DojangDamageRankBoard")
end

function Dojang.openDojangRank(self)
  local rankBoard = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojangRankBoard")
  if not ___MOD.isvalid(rankBoard) then
    return
  end
  self:bumpDojangSearchGenerationClient("DojangRankBoard")
  self:connectDojangRankTabsClient()
  self:clearDojangRankBoardClient()
  self._T.dojangSearchRowHold = nil
  self:clearDojangSearchTextClient("DojangRankBoard")
  local defaultMode = self:composeDojangRankMode("weekly_current", -1)
  self:setDojangRankTabVisualClient(defaultMode)
  self._T.dojangRankMode = defaultMode
  self._T.dojangRankPage = 1
  self._T.dojangMyRankEntries = {}
  self._T.dojangMyRankEntries[defaultMode] = {
    rank = 0,
    floor = 0,
    clearTime = 0
  }
  self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", "Loading")
  if not rankBoard.Enable then
    ___MOD._UIWindowLogic:enableUI(rankBoard)
  end
  ___MOD._UIWindowLogic:moveToTopLayer(rankBoard)
  self:initDojangJobComboBoxClient("DojangRankBoard")
  self:initDojangSearchBtnClient("DojangRankBoard")
end

function Dojang.openDojoDamageMeterBigClient(self)
  self:openDojoDamageMeterBySizeClient(true, false)
end

function Dojang.openDojoDamageMeterBySizeClient(self, showBig, isDojoEntry)
  local meter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeter")
  local bigMeter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterBig")
  if isDojoEntry and (___MOD.isvalid(meter) and meter.Enable or ___MOD.isvalid(bigMeter) and bigMeter.Enable) then
    return
  end
  local controller = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterController")
  if not ___MOD.isvalid(controller) then
    return
  end
  local comp = controller:GetComponent("script.DojoDamageMeterUIComponent")
  if not comp then
    return
  end
  comp.currentPage = 1
  comp:initActionStateForCurrentContext()
  self:refreshDojoDamageMeterClient()
  if showBig then
    comp:showBig()
  else
    comp:showSmall()
  end
  if isDojoEntry and ___MOD.isvalid(meter) and ___MOD.isvalid(meter.UITransformComponent) then
    meter.UITransformComponent.anchoredPosition = ___MOD.FastVector2(656, 37)
    comp:applyImageAlpha(0.6)
  end
end

function Dojang.openDojoDamageMeterClient(self)
  self:openDojoDamageMeterBySizeClient(false, false)
end

function Dojang.openDojoDamageMeterMiniClient(self)
  local controller = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterController")
  if not ___MOD.isvalid(controller) then
    return
  end
  local comp = controller:GetComponent("script.DojoDamageMeterUIComponent")
  if not comp then
    return
  end
  comp.currentPage = 1
  comp:initActionStateForCurrentContext()
  self:refreshDojoDamageMeterClient()
  comp:showSmallest()
end

function Dojang.openDojoDamageMeterSmallClient(self)
  self:openDojoDamageMeterBySizeClient(false, false)
end

function Dojang.openDojoGate(self, player)

end

function Dojang.playDojoCastLocal(self, skillID)
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) or player.PlayerActionComponent == nil then
    return
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData == nil then
    return
  end
  local pa = player.PlayerActionComponent
  local motion
  if ___MOD.isvalid(skillData.action) then
    motion = skillData.action["0"]
  end
  if motion ~= nil and motion ~= "" then
    local totalActionDelay = ___MOD.math.max(0.5, ___MOD._PlayerSkillLogic:getSkillActionLockDelaySec(player, skillID, motion, 0.5, 0))
    ___MOD._PlayerStateLogic:changeState(player, "SKILL")
    pa:playOnceClient(motion, 1.0, player, false, false)
    pa:playOnce(motion, 1.0, player)
    pa.enableNextAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds + totalActionDelay
    pa:armDojangActionHitRecovery(pa.enableNextAttackTime)
  end
  if ___MOD.isvalid(skillData.effect) then
    ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, nil, 1.0, false)
  end
  if ___MOD.isvalid(skillData.affected) then
    ___MOD._PlayerSkillLogic:playAffectedEffect(player, skillID)
  end
  ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%07d.Use", skillID), player, 1)
end

function Dojang.playDojoSkillHit(self, player, mob, skillID)
  if not ___MOD.isvalid(mob) or not ___MOD.isvalid(mob.MobComponent) then
    return
  end
  local sd = ___MOD._SkillManager:getSkill(skillID)
  if sd == nil or sd.hit == nil then
    return
  end
  local faceLeft = false
  if ___MOD.isvalid(player) and ___MOD.isvalid(player.PlayerControllerComponent) then
    faceLeft = player.PlayerControllerComponent.LookDirectionX == -1
  end
  ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, skillID, 0, mob, 1.0, ___MOD.FastVector3.zero:Clone(), sd.hit, false, faceLeft, nil, false, nil)
end

function Dojang.preloadDojoRankRewardCache(self)

end

function Dojang.prepareDojoDamageMeterClient(self)
  self:resetDojoDamageClient()
  self:setDojoDamageMeterMeasuringStateClient()
  local meter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeter")
  local bigMeter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterBig")
  local miniMeter = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterSmall")
  if ___MOD.isvalid(meter) and meter.Enable or ___MOD.isvalid(bigMeter) and bigMeter.Enable or ___MOD.isvalid(miniMeter) and miniMeter.Enable then
    self:refreshDojoDamageMeterClient()
    return
  end
  self:openDojoDamageMeterBySizeClient(false, true)
end

function Dojang.proceedDojoEntry(self, player, practiceMode)

end

function Dojang.queueDojangRankWeb(self, request)

end

function Dojang.recordDojoDailyEntryTry(self, player)

end

function Dojang.recordDojoDamage(self, attacker, mob, skillID, delta, hitCount)

end

function Dojang.recordDojoDamageClient(self, skillID, delta, floorID, hitCount)
  if delta <= 0 then
    return
  end
  if self.dojoMeasurePaused then
    return
  end
  local displaySkillID = self:getDojoDamageMeterDisplaySkillID(skillID)
  if self.dojoCurrentFloorID ~= floorID then
    self.dojoCurrentFloorID = floorID
    self.dojoFloorDmgBySkill = {}
    self.dojoDamageStoppedFloorID = 0
  end
  self.dojoDmgBySkill[displaySkillID] = (self.dojoDmgBySkill[displaySkillID] or 0) + delta
  self.dojoFloorDmgBySkill[displaySkillID] = (self.dojoFloorDmgBySkill[displaySkillID] or 0) + delta
  if 0 < hitCount then
    self.dojoDamageHitCount = self.dojoDamageHitCount + hitCount
    self.dojoDamageAttackCount = self.dojoDamageAttackCount + 1
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if 0 >= self.dojoDamageStartedAt then
    self.dojoDamageStartedAt = now
  end
  if not self.dojoDamageTimerRunning and self.dojoDamageStoppedFloorID ~= floorID then
    self.dojoDamageTimerStartedAt = now
    self.dojoDamageTimerRunning = true
  end
  self.dojoDamageSamples[#self.dojoDamageSamples + 1] = {t = now, d = delta}
end

function Dojang.refreshDojoDamageMeterClient(self)
  local controller = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterController")
  if not ___MOD.isvalid(controller) then
    return
  end
  local comp = controller:GetComponent("script.DojoDamageMeterUIComponent")
  if comp == nil then
    return
  end
  local sorted = {}
  local total = 0
  for skillID, dmg in ___MOD.pairs(self.dojoDmgBySkill) do
    sorted[#sorted + 1] = {id = skillID, d = dmg}
    total = total + dmg
  end
  ___MOD.table.sort(sorted, function(a, b)
    return a.d > b.d
  end)
  local rows = {}
  local maxRows = 12
  local etcDamage = 0
  for i = 1, #sorted do
    if i <= maxRows then
      local nm
      if 0 >= sorted[i].id then
        nm = "일반 공격"
      else
        nm = ___MOD._StringPoolManager:getSkillName(sorted[i].id)
        if nm == nil or nm == "" then
          nm = ___MOD.tostring(sorted[i].id)
        end
      end
      local iconRuid = ""
      if 0 >= sorted[i].id then
        iconRuid = "120457a0b3954cd0814bc1d973c7ead2"
      else
        local skillData = ___MOD._SkillManager:getSkill(sorted[i].id)
        if skillData ~= nil and not ___MOD._UtilLogic:IsNilorEmptyString(skillData.icon) then
          iconRuid = ___MOD.tostring(skillData.icon)
        end
      end
      rows[#rows + 1] = {
        n = nm,
        d = sorted[i].d,
        floorDmg = self.dojoFloorDmgBySkill[sorted[i].id] or 0,
        totalDmg = sorted[i].d,
        ruid = iconRuid
      }
    else
      etcDamage = etcDamage + sorted[i].d
    end
  end
  if 0 < etcDamage then
    local etcFloorDamage = 0
    for i = maxRows + 1, #sorted do
      etcFloorDamage = etcFloorDamage + (self.dojoFloorDmgBySkill[sorted[i].id] or 0)
    end
    rows[#rows + 1] = {
      n = "기타",
      d = etcDamage,
      floorDmg = etcFloorDamage,
      totalDmg = etcDamage,
      ruid = ""
    }
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  local oneSecDamage = 0
  local tenSecDamage = 0
  local aliveSamples = {}
  for i = 1, #self.dojoDamageSamples do
    local sample = self.dojoDamageSamples[i]
    local t = ___MOD.tonumber(sample.t or 0) or 0
    local d = ___MOD.tonumber(sample.d or 0) or 0
    if now - t <= 10 then
      aliveSamples[#aliveSamples + 1] = sample
      tenSecDamage = tenSecDamage + d
      if now - t <= 1 then
        oneSecDamage = oneSecDamage + d
      end
    end
  end
  self.dojoDamageSamples = aliveSamples
  local elapsedForAverage = ___MOD.math.max(1, ___MOD.math.min(10, now - self.dojoDamageStartedAt))
  local currentDps = ___MOD.math.floor(oneSecDamage)
  local averageDps = ___MOD.math.floor(tenSecDamage / elapsedForAverage)
  self.dojoDamageBestDps = ___MOD.math.max(self.dojoDamageBestDps, currentDps)
  local totalFloor = ___MOD.math.floor(total)
  local battleTime = self.dojoDamageBattleTime
  if self.dojoDamageTimerRunning and 0 < self.dojoDamageTimerStartedAt then
    battleTime = battleTime + ___MOD.math.max(0, now - self.dojoDamageTimerStartedAt)
  end
  comp:setSummary(currentDps, self.dojoDamageBestDps, averageDps, totalFloor, battleTime, self.dojoDamageHitCount, self.dojoDamageAttackCount)
  comp:setData(rows, totalFloor)
end

function Dojang.releaseDojoSlot(self, slotKey, uid)

end

function Dojang.renderDojangDamageRankTop5Client(self)
  local topEntries = self._T.dojangDamageRankTop5 or {}
  local baseColor = ___MOD.Color(0.06666667, 0.06666667, 0.06666667, 1)
  for rank = 1, 5 do
    local entry = topEntries[rank]
    if entry ~= nil then
      local base = "/ui/DojangGroup/DojangDamageRankBoard/TopRank" .. ___MOD.tostring(rank)
      self:setDojangRankTextColorClient(base .. "/NameText", ___MOD.tostring(entry.name or ""), baseColor)
      self:setDojangRankTextColorClient(base .. "/RecordText", self:formatDojangDamageNumber(___MOD.tonumber(entry.damage) or 0), baseColor)
      self:setDojangRankTextColorClient(base .. "/GuildText", self:formatDojangRankGuild(___MOD.tostring(entry.guild or "")), baseColor)
    end
  end
end

function Dojang.renderDojangRankTop5Client(self)
  local topEntries = self._T.dojangRankTop5 or {}
  local baseColor = ___MOD.Color(0.06666667, 0.06666667, 0.06666667, 1)
  for rank = 1, 5 do
    local entry = topEntries[rank]
    if entry ~= nil then
      local base = "/ui/DojangGroup/DojangRankBoard/TopRank" .. ___MOD.tostring(rank)
      local floor = ___MOD.tonumber(entry.floor) or 0
      local recordText = ___MOD.string.format("%d층 / %s", floor, self:formatDojangRankTime(___MOD.tonumber(entry.clearTime) or 0))
      self:setDojangRankTextColorClient(base .. "/NameText", ___MOD.tostring(entry.name or ""), baseColor)
      self:setDojangRankTextColorClient(base .. "/RecordText", recordText, self:getDojangRankFloorColor(floor))
      self:setDojangRankTextColorClient(base .. "/GuildText", self:formatDojangRankGuild(___MOD.tostring(entry.guild or "")), baseColor)
    end
  end
end

function Dojang.requestDojangBlockCheck(self, player, items, callback)

end

function Dojang.requestDojangDamageBlockCheck(self, player, items, callback)

end

function Dojang.requestDojangDamageRankingWeb(self, player, rankOffset, rankCount, mode, myOnly, callback)

end

function Dojang.requestDojangDamageRankPage(self, mode, page, senderUserId)

end

function Dojang.requestDojangDamageRankSearch(self, name, periodOffset, jobFilter, requestGeneration, senderUserId)

end

function Dojang.requestDojangRankingWeb(self, player, rankOffset, rankCount, rankMode, callback)

end

function Dojang.requestDojangRankPage(self, rankMode, page, senderUserId)

end

function Dojang.requestDojangRankSearch(self, name, periodOffset, jobFilter, requestGeneration, senderUserId)

end

function Dojang.requestDojangRankTab(self, rankMode, senderUserId)

end

function Dojang.requestDojoCommandSkill(self, dir, senderUserId)

end

function Dojang.resetDojoCmdSkillUsedClient(self)
  self._T.dojoCmdSkillUsedClient = {}
end

function Dojang.resetDojoDamageClient(self)
  self.dojoDmgBySkill = {}
  self.dojoFloorDmgBySkill = {}
  self.dojoCurrentFloorID = 0
  self.dojoDamageSamples = {}
  self.dojoDamageStartedAt = 0
  self.dojoDamageBattleTime = 0
  self.dojoDamageTimerStartedAt = 0
  self.dojoDamageTimerRunning = false
  self.dojoDamageStoppedFloorID = 0
  self.dojoDamageBestDps = 0
  self.dojoDamageHitCount = 0
  self.dojoDamageAttackCount = 0
end

function Dojang.resetDojoDamageMeterSessionClient(self, closeWindows)
  self:resetDojoDamageClient()
  self.dojoMeasurePaused = true
  local controller = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterController")
  if not ___MOD.isvalid(controller) then
    return
  end
  local comp = controller:GetComponent("script.DojoDamageMeterUIComponent")
  if comp then
    comp:resetMeterClient(closeWindows)
  end
end

function Dojang.restingDialog(self, player, udc, mapid)

end

function Dojang.searchDojangDamageRankByNameWeb(self, player, name, periodOffset, jobFilter, requestGeneration)

end

function Dojang.searchDojangRankByNameWeb(self, player, name, periodOffset, jobFilter, requestGeneration)

end

function Dojang.setDojangDamageRankTabVisualClient(self, mode)
  local map = {
    weekly_current = {
      buttonName = "WeeklyNowRankButton",
      normalRUID = "88b54dd6fd6b40fea2da37441592608a",
      selectedRUID = "489e2f384ed54e829713d16ed554dcb4"
    },
    weekly_last = {
      buttonName = "WeeklyBeforeRankButton",
      normalRUID = "00d47758c04c4d579ee8a12c87b2dc16",
      selectedRUID = "720b646a48b94a8daa05ed54901549ca"
    }
  }
  local period = self:getDojangRankPeriod(mode)
  for m, tab in ___MOD.pairs(map) do
    local btn = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojangDamageRankBoard/" .. tab.buttonName)
    if ___MOD.isvalid(btn) and ___MOD.isvalid(btn.SpriteGUIRendererComponent) then
      local selected = m == period
      if ___MOD.isvalid(btn.ButtonComponent) then
        btn.ButtonComponent.Selectable = false
        btn.ButtonComponent.Enable = true
        btn.ButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
      end
      btn.SpriteGUIRendererComponent.ImageRUID = selected and tab.selectedRUID or tab.normalRUID
    end
  end
end

function Dojang.setDojangRankJobCellClient(self, path, jobDisplayName, textColor)
  local entity = ___MOD._EntityService:GetEntityByPath(path)
  if not ___MOD.isvalid(entity) then
    return
  end
  local fullName = ___MOD.tostring(jobDisplayName or "")
  local charCount = ___MOD.utf8.len(fullName) or 0
  local useTooltip = 5 < charCount
  local displayName = fullName
  if useTooltip then
    local nextPosition = ___MOD.utf8.offset(fullName, 6)
    local lastByte = nextPosition ~= nil and nextPosition - 1 or #fullName
    displayName = ___MOD.string.sub(fullName, 1, lastByte) .. "..."
  end
  self:setDojangRankTextColorClient(path, displayName, textColor)
  if entity.SpriteGUIRendererComponent ~= nil then
    entity.SpriteGUIRendererComponent.RaycastTarget = useTooltip
  end
  if not useTooltip then
    if entity.TooltipComponent ~= nil then
      entity.TooltipComponent.text = ""
      entity.TooltipComponent:showTooltip(false)
    end
    if entity.UITouchReceiveComponent ~= nil then
      entity.UITouchReceiveComponent.Enable = false
    end
    return
  end
  if entity.UITouchReceiveComponent == nil then
    entity:AddComponent(___MOD.UITouchReceiveComponent)
  end
  if entity.TooltipComponent == nil then
    entity:AddComponent(___MOD.TooltipComponent)
  end
  if entity.UITouchReceiveComponent ~= nil then
    entity.UITouchReceiveComponent.Enable = true
  end
  if entity.TooltipComponent ~= nil then
    entity.TooltipComponent.type = ___MOD._TooltipType.TEXT
    entity.TooltipComponent.text = fullName
    entity.TooltipComponent.maxWidth = 240
  end
end

function Dojang.setDojangRankTabVisualClient(self, rankMode)
  rankMode = self:normalizeDojangRankMode(rankMode)
  local map = {
    weekly_current = {
      buttonName = "WeeklyNowRankButton",
      normalRUID = "88b54dd6fd6b40fea2da37441592608a",
      selectedRUID = "489e2f384ed54e829713d16ed554dcb4"
    },
    weekly_last = {
      buttonName = "WeeklyBeforeRankButton",
      normalRUID = "00d47758c04c4d579ee8a12c87b2dc16",
      selectedRUID = "720b646a48b94a8daa05ed54901549ca"
    }
  }
  local period = self:getDojangRankPeriod(rankMode)
  for mode, tab in ___MOD.pairs(map) do
    local btn = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojangRankBoard/" .. tab.buttonName)
    if ___MOD.isvalid(btn) and ___MOD.isvalid(btn.SpriteGUIRendererComponent) then
      local selected = mode == period
      if ___MOD.isvalid(btn.ButtonComponent) then
        btn.ButtonComponent.Selectable = false
        btn.ButtonComponent.Enable = true
        btn.ButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
      end
      btn.SpriteGUIRendererComponent.ImageRUID = selected and tab.selectedRUID or tab.normalRUID
    end
  end
end

function Dojang.setDojangRankTextClient(self, path, value)
  local entity = ___MOD._EntityService:GetEntityByPath(path)
  if not ___MOD.isvalid(entity) or entity.BitmapFontRendererComponent == nil then
    return
  end
  local bf = entity.BitmapFontRendererComponent
  if ___MOD._UtilLogic:IsNilorEmptyString(value) and entity.TextGUIRendererComponent ~= nil then
    entity.TextGUIRendererComponent.Text = ""
  end
  bf.text = value
  bf:drawText()
  if ___MOD._UtilLogic:IsNilorEmptyString(value) and entity.TextGUIRendererComponent ~= nil then
    entity.TextGUIRendererComponent.Text = ""
  end
end

function Dojang.setDojangRankTextColorClient(self, path, value, textColor)
  local entity = ___MOD._EntityService:GetEntityByPath(path)
  if not ___MOD.isvalid(entity) or entity.BitmapFontRendererComponent == nil then
    return
  end
  local bf = entity.BitmapFontRendererComponent
  if textColor ~= nil then
    bf.color = textColor
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(value) and entity.TextGUIRendererComponent ~= nil then
    entity.TextGUIRendererComponent.Text = ""
  end
  bf.text = value
  bf:drawText()
  if ___MOD._UtilLogic:IsNilorEmptyString(value) and entity.TextGUIRendererComponent ~= nil then
    entity.TextGUIRendererComponent.Text = ""
  end
end

function Dojang.setDojoDamageMeterMeasuringStateClient(self)
  self.dojoMeasurePaused = false
  local controller = ___MOD._EntityService:GetEntityByPath("/ui/DojangGroup/DojoDamageMeterController")
  if not ___MOD.isvalid(controller) then
    return
  end
  local comp = controller:GetComponent("script.DojoDamageMeterUIComponent")
  if comp ~= nil then
    comp:applyActionButtonState(1)
  end
end

function Dojang.setDojoMeasurePausedClient(self, paused)
  if self.dojoMeasurePaused == paused then
    return
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if paused then
    if self.dojoDamageTimerRunning and self.dojoDamageTimerStartedAt > 0 then
      self.dojoDamageBattleTime = self.dojoDamageBattleTime + ___MOD.math.max(0, now - self.dojoDamageTimerStartedAt)
    end
    self.dojoDamageTimerRunning = false
    self.dojoMeasurePaused = true
  else
    self.dojoMeasurePaused = false
    self.dojoDamageTimerStartedAt = now
    self.dojoDamageTimerRunning = true
    if 0 >= self.dojoDamageStartedAt then
      self.dojoDamageStartedAt = now
    end
  end
  self:refreshDojoDamageMeterClient()
end

function Dojang.setDojoPoints(self, player, points)

end

function Dojang.shortenPortalCooldown(self, player)

end

function Dojang.shortenPortalCooldownClient(self)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or not ___MOD.isvalid(user.PlayerVariables) then
    return
  end
  user.PlayerVariables.lastPortalTime = ___MOD._UtilLogic.ElapsedSeconds - 0.8
end

function Dojang.showDojangDamageRankSearchResultClient(self, entry, scope, requestMode, requestGeneration)
  if not self:isCurrentDojangSearchRequestClient("DojangDamageRankBoard", requestMode, requestGeneration) then
    return
  end
  entry = entry or {}
  if scope ~= "job" then
    self._T.dojangDamageSearchRowHold = {
      mode = self._T.dojangDamageRankMode or "",
      entry = entry
    }
    self:fillDojangDamageRankRowClient(1, entry)
    return
  end
  local comboItem = self:getDojangRankComboItemForJob(___MOD.tonumber(entry.job) or 0)
  if comboItem == nil then
    self._T.dojangDamageSearchRowHold = {
      mode = self._T.dojangDamageRankMode or "",
      entry = entry
    }
    self:fillDojangDamageRankRowClient(1, entry)
    return
  end
  local currentMode = self._T.dojangDamageRankMode or ""
  local targetMode = self:composeDojangRankMode(self:getDojangRankPeriod(currentMode), comboItem.job)
  if targetMode == currentMode then
    self._T.dojangDamageSearchRowHold = {mode = currentMode, entry = entry}
    self:fillDojangDamageRankRowClient(1, entry)
    return
  end
  self:onDojangJobSelectedClient("DojangDamageRankBoard", comboItem.job, comboItem.name, true)
  self._T.dojangDamageSearchRowHold = {mode = targetMode, entry = entry}
  self:fillDojangDamageRankRowClient(1, entry)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangDamageRankBoard/PageText", "검색 결과")
end

function Dojang.showDojangRank(self, player)

end

function Dojang.showDojangRankSearchResultClient(self, entry, scope, requestMode, requestGeneration)
  if not self:isCurrentDojangSearchRequestClient("DojangRankBoard", requestMode, requestGeneration) then
    return
  end
  entry = entry or {}
  if scope ~= "job" then
    self._T.dojangSearchRowHold = {
      mode = self._T.dojangRankMode or "",
      entry = entry
    }
    self:fillDojangRankRowClient(1, entry)
    return
  end
  local comboItem = self:getDojangRankComboItemForJob(___MOD.tonumber(entry.job) or 0)
  if comboItem == nil then
    self._T.dojangSearchRowHold = {
      mode = self._T.dojangRankMode or "",
      entry = entry
    }
    self:fillDojangRankRowClient(1, entry)
    return
  end
  local currentMode = self._T.dojangRankMode or ""
  local targetMode = self:composeDojangRankMode(self:getDojangRankPeriod(currentMode), comboItem.job)
  if targetMode == currentMode then
    self._T.dojangSearchRowHold = {mode = currentMode, entry = entry}
    self:fillDojangRankRowClient(1, entry)
    return
  end
  self:onDojangJobSelectedClient("DojangRankBoard", comboItem.job, comboItem.name, true)
  self._T.dojangSearchRowHold = {mode = targetMode, entry = entry}
  self:fillDojangRankRowClient(1, entry)
  self:setDojangRankTextClient("/ui/DojangGroup/DojangRankBoard/PageText", "검색 결과")
end

function Dojang.showDojangSearchErrorClient(self, boardName, message, requestMode, requestGeneration)
  if not self:isCurrentDojangSearchRequestClient(boardName, requestMode, requestGeneration) then
    return
  end
  ___MOD._UINotice:showAlertUI(message)
end

function Dojang.showDojoDamageMeter(self, player)

end

function Dojang.showDojoDamageMeterBig(self, player)

end

function Dojang.showDojoTaunt(self, msg)
  ___MOD._UIWindowLogic:createFloatNotice(33, msg, 5)
end

function Dojang.showDummyDamageRanking(self, player)

end

function Dojang.sliceDojangRankCacheEntries(self, entries, startIndex, count)

end

function Dojang.startDojo(self, player, udc)

end

function Dojang.startDojoDamageTimerClient(self)
  if self.dojoDamageTimerRunning then
    return
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if self.dojoDamageStartedAt <= 0 then
    self.dojoDamageStartedAt = now
  end
  self.dojoDamageTimerStartedAt = now
  self.dojoDamageTimerRunning = true
  self.dojoDamageStoppedFloorID = 0
  self:refreshDojoDamageMeterClient()
end

function Dojang.startDojoPractice(self, player, udc)

end

function Dojang.stopDojoDamageTimerClient(self)
  if not self.dojoDamageTimerRunning then
    return
  end
  local now = ___MOD._UtilLogic.ElapsedSeconds
  if self.dojoDamageTimerStartedAt > 0 then
    self.dojoDamageBattleTime = self.dojoDamageBattleTime + ___MOD.math.max(0, now - self.dojoDamageTimerStartedAt)
  end
  self.dojoDamageTimerStartedAt = 0
  self.dojoDamageTimerRunning = false
  self.dojoDamageStoppedFloorID = self.dojoCurrentFloorID
  self:refreshDojoDamageMeterClient()
end

function Dojang.storeMyDojangDamageRankCache(self, player, mode, myRow, periodStart)

end

function Dojang.storeMyDojangRankCache(self, player, rankMode, myRow, periodStart)

end

function Dojang.submitDojangDamageRankWeb(self, player, damage, items)

end

function Dojang.submitDojangRank(self, player, floor, clearTime, achievedAt)

end

function Dojang.submitDojangRankWeb(self, player, floor, clearTime, achievedAt)

end

function Dojang.tryClaimDojoSlot(self, slotKey, uid)

end

function Dojang.useDojoCommandSkillClient(self, dir)
  if ___MOD._DojoRaidUILogic.energyRatio < 1 or not self:isDojoBattleFloorClient() then
    return
  end
  local skillID = 1009
  if dir == "left" then
    skillID = 1010
  elseif dir == "right" then
    skillID = 1011
  elseif dir ~= "up" then
    return
  end
  if self._T.dojoCmdSkillUsedClient ~= nil and self._T.dojoCmdSkillUsedClient[skillID] then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "무릉 비기는 도전당 종류별 1회만 사용할 수 있습니다.")
    return
  end
  self:playDojoCastLocal(skillID)
  self:requestDojoCommandSkill(dir)
end

function Dojang.warpInto(self, player, udc, mapid)

end
