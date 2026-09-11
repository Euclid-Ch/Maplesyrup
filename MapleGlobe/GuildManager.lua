

function GuildManager.addGuildMemberCacheServer(self, guildId, memberInfo)

end

function GuildManager.addGuildSkillPersonalInvestCountServer(self, user, guildId, skillId, amount)

end

function GuildManager.addGuildSkillPersonalUseCountServer(self, user, skillId, amount)

end

function GuildManager.addGuildSkillTotalPersonalInvestCountServer(self, user, guildId, skillId, amount)

end

function GuildManager.addMesoConsumeChatLog(self, user, meso)

end

function GuildManager.addMesoGainChatLog(self, user, meso)

end

function GuildManager.applyCurrentGuildMark(self, guildMark)
  if not ___MOD.isvalid(guildMark) then
    return false
  end
  local selected = self:getSelectedGuildMark()
  if selected == nil then
    return false
  end
  local backGroundRuid = ___MOD.string.format("UI.GuildMark.BackGround.%s.%d", selected.backGroundCode, selected.backGroundColorIndex)
  local markRuid = ___MOD.string.format("UI.GuildMark.Mark.%s.%s.%d", selected.markCategory, selected.markCode, selected.markColorIndex)
  local appliedBackGround = self:applyGuildMarkSprite(guildMark, "BackGround", backGroundRuid)
  local appliedMark = self:applyGuildMarkSprite(guildMark, "Mark", markRuid)
  return appliedBackGround and appliedMark
end

function GuildManager.applyGuildActiveBuffsServer(self, user)

end

function GuildManager.applyGuildCapacityChangedClient(self, guildId, capacity)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return
  end
  local player = user.Player
  if not ___MOD.isvalid(player) or guildId <= 0 or capacity <= 0 then
    return
  end
  local guildData = player.guildData
  if guildData == nil then
    guildData = ___MOD.Guild()
    guildData.GuildID = guildId
  end
  local dataGuildId = ___MOD.tonumber(guildData.GuildID or 0) or 0
  local playerGuildId = ___MOD.tonumber(player.GuildId or 0) or 0
  if 0 < dataGuildId and dataGuildId ~= guildId then
    return
  end
  if 0 < playerGuildId and playerGuildId ~= guildId then
    return
  end
  player.GuildId = guildId
  guildData.GuildID = guildId
  guildData.Capacity = capacity
  player.guildData = guildData
end

function GuildManager.applyGuildCapacityChangedToLocalGuildPlayers(self, guildId, capacity)

end

function GuildManager.applyGuildInfoClient(self, guildInfo)
  self:setCurrentGuildMarkInfo(guildInfo)
  local guild = self:getGuildEntity()
  if guild then
    local gc = guild.GuildComponent
    if gc then
      gc:initGuildMemberList()
      gc:applyGuildInfo(guildInfo)
    end
    local gnc = guild.GuildNoticeComponent
    if gnc then
      gnc:updateGuildNotice(self:getGuildInfoNotice(guildInfo))
    end
  end
  local skill = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildSkill")
  if ___MOD.isvalid(skill) and skill.GuildSkillComponent ~= nil then
    skill.GuildSkillComponent:applyGuildSkillInfo(self:getGuildInfoSkillInfo(guildInfo))
  end
  self:refreshGuildPassiveBuffIconClient(self:getGuildInfoSkillInfo(guildInfo))
  self:applyGuildInfoUIGuildMark()
end

function GuildManager.applyGuildInfoToLocalGuildPlayers(self, guildId)

end

function GuildManager.applyGuildInfoUIGuildMark(self)
  local guildMark = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildInfo/guildname/guildmark/guildmark")
  if not ___MOD.isvalid(guildMark) then
    return false
  end
  local applied = self:applyCurrentGuildMark(guildMark)
  if applied then
    guildMark.Visible = true
  else
    guildMark.Visible = false
  end
  return applied
end

function GuildManager.applyGuildInviteAcceptedResponseServer(self, guildId, guildInfo, user)

end

function GuildManager.applyGuildMarkChangedClient(self, guildId, guildMarkInfo)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return
  end
  local player = user.Player
  if not ___MOD.isvalid(player) then
    return
  end
  if guildId <= 0 then
    return
  end
  local guildInfo = {
    GuildMarkInfo = guildMarkInfo or {}
  }
  player.GuildId = guildId
  local guildData = player.guildData
  if guildData == nil then
    guildData = ___MOD.Guild()
  end
  guildData.GuildID = guildId
  guildData.GuildMarkInfo = self:getGuildInfoMarkInfo(guildInfo) or {}
  player.guildData = guildData
  self:setCurrentGuildMarkInfo(guildInfo)
  self:applyGuildInfoUIGuildMark()
  local nameTagComponent = user:GetComponent("script.PlayerNameTagComponent")
  if nameTagComponent ~= nil then
    nameTagComponent:renderAllNameTags()
  end
end

function GuildManager.applyGuildMarkChangedToLocalGuildPlayers(self, guildId)

end

function GuildManager.applyGuildMarkSprite(self, target, childName, ruid)
  if not ___MOD.isvalid(target) then
    return false
  end
  local child = target:GetChildByName(childName)
  if not ___MOD.isvalid(child) then
    return false
  end
  local spriteRuid = ___MOD.__RUIDManager:get(ruid)
  local applied = false
  if child.SpriteRendererComponent ~= nil then
    child.SpriteRendererComponent.SpriteRUID = spriteRuid
    applied = true
  end
  if child.SpriteGUIRendererComponent ~= nil then
    child.SpriteGUIRendererComponent.ImageRUID = spriteRuid
    applied = true
  end
  return applied
end

function GuildManager.applyGuildMemberJoinedClient(self, guildId, joinedMemberInfo)
  local guildData = self:getGuildDataForDeltaClient(guildId)
  if guildData == nil or ___MOD.type(joinedMemberInfo) ~= "table" then
    return
  end
  local joinedPlayerId = ___MOD.tostring(joinedMemberInfo.PlayerId or "")
  if ___MOD._UtilLogic:IsNilorEmptyString(joinedPlayerId) then
    return
  end
  local members = guildData.GuildMembers
  local index = 1
  while index <= #members do
    if ___MOD.type(members[index]) == "table" and ___MOD.tostring(members[index].PlayerId or "") == joinedPlayerId then
      ___MOD.table.remove(members, index)
    else
      index = index + 1
    end
  end
  for key, memberInfo in ___MOD.pairs(members) do
    if ___MOD.type(memberInfo) == "table" and ___MOD.tostring(memberInfo.PlayerId or "") == joinedPlayerId then
      members[key] = nil
    end
  end
  members[#members + 1] = joinedMemberInfo
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
    user.Player.guildData = guildData
  end
  self:refreshGuildMemberDeltaClient(guildData)
end

function GuildManager.applyGuildMemberJoinToLocalGuildPlayers(self, guildId, joinedPlayerId, joinedPlayerName, joinedMemberInfo)

end

function GuildManager.applyGuildMemberKickToLocalGuildPlayers(self, guildId, targetPlayerId, targetPlayerName)

end

function GuildManager.applyGuildMemberRankChangedClient(self, guildId, changedPlayerId, changedRankNo)
  local guildData = self:getGuildDataForDeltaClient(guildId)
  if guildData == nil or ___MOD._UtilLogic:IsNilorEmptyString(changedPlayerId) or changedRankNo <= 0 then
    return
  end
  local changed = false
  local changedMemberName = ""
  for _, memberInfo in ___MOD.pairs(guildData.GuildMembers) do
    if ___MOD.type(memberInfo) == "table" and ___MOD.tostring(memberInfo.PlayerId or "") == changedPlayerId then
      changedMemberName = ___MOD.tostring(memberInfo.Name or "")
      memberInfo.Rank = changedRankNo
      memberInfo.RankNo = changedRankNo
      memberInfo.GuildRank = changedRankNo
      changed = true
    end
  end
  if not changed then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) and ___MOD.tostring(user.Player.PlayerId or "") == changedPlayerId then
    guildData.MyRank = changedRankNo
  end
  if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
    user.Player.guildData = guildData
  end
  self:showGuildRankChangedChatClient(changedMemberName, self:getGuildRankNameFromGuildDataClient(guildData, changedRankNo))
  self:refreshGuildMemberDeltaClient(guildData)
end

function GuildManager.applyGuildMemberRankChangedToLocalGuildPlayers(self, guildId, changedPlayerId, changedRankNo)

end

function GuildManager.applyGuildMemberRemovedClient(self, guildId, removedPlayerId)
  local guildData = self:getGuildDataForDeltaClient(guildId)
  if guildData == nil or ___MOD._UtilLogic:IsNilorEmptyString(removedPlayerId) then
    return
  end
  local members = guildData.GuildMembers
  local removed = false
  local index = 1
  while index <= #members do
    if ___MOD.type(members[index]) == "table" and ___MOD.tostring(members[index].PlayerId or "") == removedPlayerId then
      ___MOD.table.remove(members, index)
      removed = true
    else
      index = index + 1
    end
  end
  for key, memberInfo in ___MOD.pairs(members) do
    if ___MOD.type(memberInfo) == "table" and ___MOD.tostring(memberInfo.PlayerId or "") == removedPlayerId then
      members[key] = nil
      removed = true
    end
  end
  if not removed then
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
    user.Player.guildData = guildData
  end
  self:refreshGuildMemberDeltaClient(guildData)
end

function GuildManager.applyGuildMemberStatusChangedClient(self, guildId, changedPlayerId, online)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return
  end
  local player = user.Player
  if not ___MOD.isvalid(player) or guildId <= 0 or ___MOD._UtilLogic:IsNilorEmptyString(changedPlayerId) then
    return
  end
  local guildData = player.guildData
  if guildData == nil or ___MOD.type(guildData.GuildMembers) ~= "table" then
    return
  end
  local dataGuildId = ___MOD.tonumber(guildData.GuildID or 0) or 0
  local playerGuildId = ___MOD.tonumber(player.GuildId or 0) or 0
  if 0 < dataGuildId and dataGuildId ~= guildId then
    return
  end
  if 0 < playerGuildId and playerGuildId ~= guildId then
    return
  end
  local changed = false
  for _, memberInfo in ___MOD.pairs(guildData.GuildMembers) do
    if ___MOD.type(memberInfo) == "table" and ___MOD.tostring(memberInfo.PlayerId or "") == changedPlayerId then
      memberInfo.IsOnline = online and 1 or 0
      memberInfo.isOnline = online and 1 or 0
      changed = true
    end
  end
  if not changed then
    return
  end
  player.GuildId = guildId
  guildData.GuildID = guildId
  player.guildData = guildData
  local guild = self:getGuildEntity()
  if guild == nil or guild.GuildComponent == nil then
    return
  end
  local gc = guild.GuildComponent
  if not gc.memberListInit then
    gc:initGuildMemberList()
  end
  gc:applyGuildMemberInfo(guildData.GuildMembers)
  gc:refreshGuildInfoButtonState()
  gc:refreshGuildInviteButtonState()
  gc:refreshGuildWithdrawButtonState()
end

function GuildManager.applyGuildMemberStatusChangedToLocalGuildPlayers(self, guildId, changedPlayerId, online)

end

function GuildManager.applyGuildMemberWithdrawToLocalGuildPlayers(self, guildId, targetPlayerId, targetPlayerName)

end

function GuildManager.applyGuildNameTagSync(self, user, guildInfo)

end

function GuildManager.applyGuildNoticeChangedClient(self, guildId, guildNotice)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return
  end
  local player = user.Player
  if not ___MOD.isvalid(player) then
    return
  end
  if guildId <= 0 then
    return
  end
  local safeGuildNotice = ___MOD.tostring(guildNotice or "")
  player.GuildId = guildId
  local guildData = player.guildData
  if guildData == nil then
    guildData = ___MOD.Guild()
  end
  guildData.GuildID = guildId
  guildData.GuildNotice = safeGuildNotice
  player.guildData = guildData
  local guild = self:getGuildEntity()
  if guild == nil then
    return
  end
  if guild.GuildComponent ~= nil then
    guild.GuildComponent:ensureRuntimeTable()
    guild.GuildComponent._T.guildID = guildId
    guild.GuildComponent._T.guildNotice = safeGuildNotice
  end
  local noticeComponent = guild.GuildNoticeComponent
  if noticeComponent == nil then
    local noticeEntity = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildInfo/guildinfo6")
    if ___MOD.isvalid(noticeEntity) then
      noticeComponent = noticeEntity.GuildNoticeComponent
    end
  end
  if noticeComponent ~= nil then
    noticeComponent:updateGuildNotice(safeGuildNotice)
  end
end

function GuildManager.applyGuildNoticeChangedToLocalGuildPlayers(self, guildId, guildNotice)

end

function GuildManager.applyGuildPassiveStatsServer(self, user, guildInfo)

end

function GuildManager.applyGuildRankNameChangedClient(self, guildId, rankNo, rankName)
  local guildData = self:getGuildDataForDeltaClient(guildId)
  if guildData == nil or rankNo <= 0 or ___MOD._UtilLogic:IsNilorEmptyString(rankName) then
    return
  end
  self:setGuildRankNameInGuildDataClient(guildData, rankNo, rankName)
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
    user.Player.guildData = guildData
  end
  local guild = self:getGuildEntity()
  if guild == nil or guild.GuildComponent == nil then
    return
  end
  local gc = guild.GuildComponent
  gc:setGuildRankName(rankNo, rankName)
  gc:refreshGuildGradeInfo()
end

function GuildManager.applyGuildRankNameChangedToLocalGuildPlayers(self, guildId, rankNo, rankName)

end

function GuildManager.applyGuildRemovedClient(self, guildId)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return
  end
  local player = user.Player
  if not ___MOD.isvalid(player) then
    return
  end
  local playerGuildId = ___MOD.tonumber(player.GuildId or 0) or 0
  if 0 < guildId and 0 < playerGuildId and playerGuildId ~= guildId then
    return
  end
  player.GuildId = 0
  player.guildData = nil
  self:applyNoGuildClient()
  local nameTagComponent = user:GetComponent("script.PlayerNameTagComponent")
  if nameTagComponent ~= nil then
    nameTagComponent:renderAllNameTags()
  end
end

function GuildManager.applyGuildSkillChangedClient(self, guildId, guildSkillInfo)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return
  end
  local player = user.Player
  if not ___MOD.isvalid(player) then
    return
  end
  if guildId <= 0 or ___MOD.type(guildSkillInfo) ~= "table" then
    return
  end
  player.GuildId = guildId
  local guildData = player.guildData
  if guildData == nil then
    guildData = ___MOD.Guild()
  end
  guildData.GuildID = guildId
  local guildSkillInfoList = self:upsertGuildSkillInfoClient(guildData, guildSkillInfo)
  player.guildData = guildData
  local skillRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildSkill")
  if ___MOD.isvalid(skillRoot) and skillRoot.GuildSkillComponent ~= nil then
    skillRoot.GuildSkillComponent:applyGuildSkillInfo(guildSkillInfoList)
  end
  self:refreshGuildPassiveBuffIconClient(guildSkillInfoList)
end

function GuildManager.applyGuildSkillChangedToLocalGuildPlayers(self, guildId, changedSkillId, leveledSkillId, leveledSkillLevel, levelUpEventKey)

end

function GuildManager.applyNoGuildClient(self)
  local guild = self:getGuildEntity()
  if guild then
    local gc = guild.GuildComponent
    if gc then
      gc:initGuildMemberList()
      gc:applyGuildInfo({GuildID = 0})
    end
    local gnc = guild.GuildNoticeComponent
    if gnc then
      gnc:clearGuildNotice()
    end
  end
  self:clearGuildNoticeClient()
  local skill = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildSkill")
  if ___MOD.isvalid(skill) and skill.GuildSkillComponent ~= nil then
    skill.GuildSkillComponent:applyGuildSkillInfo({})
    skill:SetEnable(false)
  end
  if ___MOD._PlayerTemporaryStatView ~= nil then
    ___MOD._PlayerTemporaryStatView:removeGuildPassiveIcon()
    ___MOD._PlayerTemporaryStatView:removeGuildActiveBuffIcons()
  end
  ___MOD.table.clear(self.currentGuildMarkInfo)
  ___MOD.table.clear(self.selectedGuildMark)
  self:hideGuildInfoUIGuildMark()
end

function GuildManager.buildGuildInfoForPlayerServer(self, guildInfo, user)

end

function GuildManager.buildGuildMarkPreloadRuidList(self)
  local ruidList = {}
  local exists = {}
  for _, info in ___MOD.ipairs(self.guildMarkBackGroundList) do
    local code = ___MOD.tostring(info.code or "")
    if not ___MOD._UtilLogic:IsNilorEmptyString(code) then
      for color = 1, 16 do
        self:pushGuildMarkPreloadRuid(ruidList, exists, ___MOD.string.format("UI.GuildMark.BackGround.%s.%d", code, color))
      end
    end
  end
  for _, info in ___MOD.ipairs(self.guildMarkMarkList) do
    local category = ___MOD.tostring(info.category or "")
    local code = ___MOD.tostring(info.code or "")
    if not ___MOD._UtilLogic:IsNilorEmptyString(category) and not ___MOD._UtilLogic:IsNilorEmptyString(code) then
      for color = 1, 16 do
        self:pushGuildMarkPreloadRuid(ruidList, exists, ___MOD.string.format("UI.GuildMark.Mark.%s.%s.%d", category, code, color))
      end
    end
  end
  return ruidList
end

function GuildManager.buildGuildPassiveBuffTooltipDescClient(self, guildSkillInfo)
  if ___MOD.type(guildSkillInfo) ~= "table" then
    return ""
  end
  local effects = {}
  local seenSkillIds = {}

  local function addEffect(rawSkill, fallbackSkillId)
    if ___MOD.type(rawSkill) ~= "table" then
      return
    end
    local skillId = self:getGuildSkillInfoSkillIdClient(rawSkill, fallbackSkillId)
    local level = self:getGuildSkillInfoLevelClient(rawSkill)
    if skillId <= 0 or level <= 0 then
      return
    end
    if seenSkillIds[skillId] then
      return
    end
    if not ___MOD._GuildSkillLogic:isPassiveSkill(skillId) then
      return
    end
    local skillName = ___MOD._GuildSkillLogic:getGuildSkillName(skillId)
    local effectText = ___MOD._GuildSkillLogic:getGuildPassiveSkillEffectText(skillId, level)
    if ___MOD._UtilLogic:IsNilorEmptyString(skillName) or ___MOD._UtilLogic:IsNilorEmptyString(effectText) then
      return
    end
    seenSkillIds[skillId] = true
    effects[#effects + 1] = {
      skillId = skillId,
      skillName = skillName,
      effectText = effectText
    }
  end

  for i, rawSkill in ___MOD.ipairs(guildSkillInfo) do
    addEffect(rawSkill, i)
  end
  for key, rawSkill in ___MOD.pairs(guildSkillInfo) do
    addEffect(rawSkill, ___MOD.tonumber(key) or 0)
  end
  if #effects <= 0 then
    return ""
  end
  ___MOD.table.sort(effects, function(a, b)
    return (a.skillId or 0) < (b.skillId or 0)
  end)
  local desc = "길드 스킬 효과에 의해 아래와 같은 효과가 적용된다.\r\n"
  for _, effect in ___MOD.ipairs(effects) do
    desc = desc .. ___MOD.string.format("\r\n #e%s#n#c\r\n  - %s#k", effect.skillName, effect.effectText)
  end
  return desc
end

function GuildManager.buildGuildSkillInfoForPlayerServer(self, guildId, guildSkillInfo, user)

end

function GuildManager.cacheGuildMarkBackGround(self, backGroundData)
  if backGroundData == nil then
    return
  end
  for code, data in ___MOD.pairs(backGroundData) do
    if ___MOD.type(data) == "table" then
      local codeText = ___MOD.tostring(code)
      local name = ___MOD._WzUtils:getString(data.name, "")
      local cache = {code = codeText, name = name}
      self.guildMarkBackGroundByCode[codeText] = cache
      self.guildMarkBackGroundList[#self.guildMarkBackGroundList + 1] = cache
    end
  end
end

function GuildManager.cacheGuildMarkMark(self, markData)
  if markData == nil then
    return
  end
  for category, categoryData in ___MOD.pairs(markData) do
    if ___MOD.type(categoryData) == "table" then
      local categoryText = ___MOD.tostring(category)
      local categoryCache = self.guildMarkMarkByCategory[categoryText]
      if categoryCache == nil then
        categoryCache = {}
        self.guildMarkMarkByCategory[categoryText] = categoryCache
      end
      for code, data in ___MOD.pairs(categoryData) do
        if ___MOD.type(data) == "table" then
          local codeText = ___MOD.tostring(code)
          local name = ___MOD._WzUtils:getString(data.name, "")
          local sizesByColor = {}
          local width = 0
          local height = 0
          for color = 1, 16 do
            local spriteData = data[color] or data[___MOD.tostring(color)]
            if ___MOD.type(spriteData) == "table" then
              local spriteWidth = ___MOD.tonumber(spriteData._width) or 0
              local spriteHeight = ___MOD.tonumber(spriteData._height) or 0
              if 0 < spriteWidth and 0 < spriteHeight then
                sizesByColor[color] = {width = spriteWidth, height = spriteHeight}
                if width <= 0 or height <= 0 then
                  width = spriteWidth
                  height = spriteHeight
                end
              end
            end
          end
          local cache = {
            category = categoryText,
            code = codeText,
            name = name,
            width = width,
            height = height,
            sizesByColor = sizesByColor
          }
          categoryCache[codeText] = cache
          self.guildMarkMarkList[#self.guildMarkMarkList + 1] = cache
        end
      end
    end
  end
end

function GuildManager.calculateGuildPassiveStatsServer(self, guildInfo)

end

function GuildManager.canUseGuildActiveMoveInCurrentMapServer(self, user)

end

function GuildManager.cleanupStaleGuildSkillAccountKeysServer(self, user, currentGuildId)

end

function GuildManager.clearGuildActiveBossBuffServer(self, user)

end

function GuildManager.clearGuildActiveBuffsServer(self, user)

end

function GuildManager.clearGuildActiveBuffTimerServer(self, userId, playerId, skillId)

end

function GuildManager.clearGuildMembershipCacheForPlayerServer(self, playerId)

end

function GuildManager.clearGuildNoticeClient(self)
  local guildNotice = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildInfo/guildinfo6")
  if ___MOD.isvalid(guildNotice) and guildNotice.GuildNoticeComponent ~= nil then
    guildNotice.GuildNoticeComponent:clearGuildNotice()
  end
  local noticeText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildInfo/guildinfo6/text")
  if not ___MOD.isvalid(noticeText) then
    return
  end
  if noticeText.BitmapFontRendererComponent ~= nil then
    local bitmap = noticeText.BitmapFontRendererComponent
    bitmap.text = ""
    bitmap.tokens = nil
    bitmap.info = nil
    bitmap.metrics = nil
    if bitmap._T ~= nil then
      bitmap._T.lastRenderKey = nil
    end
    bitmap:drawText()
  end
  if ___MOD.isvalid(noticeText.TextGUIRendererComponent) then
    noticeText.TextGUIRendererComponent.Text = ""
  end
  if ___MOD.isvalid(noticeText.TextComponent) then
    noticeText.TextComponent.Text = ""
  end
end

function GuildManager.clearGuildPassiveStatsServer(self, user)

end

function GuildManager.clearGuildUserRuntimeState(self, user)

end

function GuildManager.clearLocalGuildPlayer(self, guildId, playerId)

end

function GuildManager.cloneGuildTableServer(self, source)

end

function GuildManager.collectLocalGuildPlayersForDeltaServer(self, guildId)

end

function GuildManager.consumeGuildDeltaAppliedServer(self, eventKey)

end

function GuildManager.consumeGuildMemberLoginNotice(self, guildId, loginPlayerId)

end

function GuildManager.containsGuildNoticeProfanity(self, guildNotice)
  if ___MOD._CheckNameUtils == nil then
    return false
  end
  local text = ___MOD.tostring(guildNotice or "")
  for _, allowWord in ___MOD.ipairs(self.guildNoticeProfanityAllowWords) do
    local word = ___MOD.tostring(allowWord or "")
    if not ___MOD._UtilLogic:IsNilorEmptyString(word) then
      local escapedWord = ___MOD.string.gsub(word, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
      text = ___MOD.string.gsub(text, escapedWord, "")
    end
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return false
  end
  return ___MOD._CheckNameUtils:contains_profanity(text)
end

function GuildManager.countGuildInfoMembersServer(self, guildInfo)

end

function GuildManager.countLocalGuildPlayers(self, guildId)

end

function GuildManager.decodeGuildBroadcastPayload(self, queue)

end

function GuildManager.deleteGuildActiveBuffExpireAccountKeysForGuildServer(self, user, guildId)

end

function GuildManager.deleteGuildSkillAccountKeysForGuildServer(self, user, guildId)

end

function GuildManager.dispatchGuildCapacityChangedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildDisbandedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildMarkChangedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildMemberJoinedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildMemberKickedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildMemberStatusChangedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildMemberWithdrawnRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildNoticeChangedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildRankChangedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildRankNameChangedRequest(self, guildId, payload)

end

function GuildManager.dispatchGuildRequest(self, queue)

end

function GuildManager.dispatchGuildSkillChangedRequest(self, guildId, payload)

end

function GuildManager.drawGuildSkillInvestExpServer(self)

end

function GuildManager.ensureGuildRuntimeTables(self)

end

function GuildManager.executeGuildWhereClient(self, targetName)
  if ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    return
  end
  ___MOD._ClientCommandLogic:tryCommand("/찾기 " .. targetName)
end

function GuildManager.findCachedGuildIdByPlayerId(self, playerId)

end

function GuildManager.findGuildInviteTargetUser(self, targetName)

end

function GuildManager.findOnlineUserByPlayerNameServer(self, playerName)

end

function GuildManager.findUserEntityByPlayerId(self, playerId)

end

function GuildManager.finishGuildActiveSkillUseRequest(self, success, message, skillId, personalUseCount)
  local skillRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildSkill")
  if ___MOD.isvalid(skillRoot) and skillRoot.GuildSkillComponent ~= nil then
    skillRoot.GuildSkillComponent:updateGuildSkillPersonalUseCount(skillId, personalUseCount)
  end
  if not success and ___MOD._UINotice ~= nil then
    local safeMessage = ___MOD.tostring(message or "")
    if ___MOD._UtilLogic:IsNilorEmptyString(safeMessage) then
      safeMessage = "길드 스킬 사용에 실패했습니다."
    end
    ___MOD._UINotice:showAlertUI(safeMessage)
  end
end

function GuildManager.finishGuildCreateRequest(self, success, message)
  local safeMessage = ___MOD.tostring(message or "")
  if ___MOD._UtilLogic:IsNilorEmptyString(safeMessage) then
    if success then
      safeMessage = "길드가 성공적으로 생성되었습니다."
    else
      safeMessage = "길드 생성에 실패했습니다."
    end
  end
  if ___MOD._UINotice ~= nil then
    ___MOD._UINotice:showAlertUI(safeMessage)
  end
end

function GuildManager.finishGuildDisbandRequest(self, success, message)
  if success then
    return
  end
  local safeMessage = ___MOD.tostring(message or "")
  if ___MOD._UtilLogic:IsNilorEmptyString(safeMessage) then
    safeMessage = "길드 해체에 실패했습니다."
  end
  if ___MOD._UINotice ~= nil then
    ___MOD._UINotice:showAlertUI(safeMessage)
  end
end

function GuildManager.finishGuildKickRequest(self, success, changed, message)
  local guild = self:getGuildEntity()
  if guild == nil or guild.GuildComponent == nil then
    return
  end
  guild.GuildComponent:onGuildKickRequestFinished(success, changed, message)
end

function GuildManager.finishGuildMarkChangeRequest(self, success, message)
  local safeMessage = ___MOD.tostring(message or "")
  if ___MOD._UtilLogic:IsNilorEmptyString(safeMessage) then
    safeMessage = success and "완료되었습니다." or "길드마크 변경에 실패했습니다."
  end
  if success then
    local makeMark = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark")
    if ___MOD.isvalid(makeMark) then
      makeMark:SetEnable(false)
    end
  end
  if ___MOD._UINotice ~= nil then
    ___MOD._UINotice:showAlertUI(safeMessage)
  end
end

function GuildManager.finishGuildMemberRankChangeRequest(self, success, changed, message)
  local guild = self:getGuildEntity()
  if guild == nil or guild.GuildComponent == nil then
    return
  end
  guild.GuildComponent:onGuildRankChangeRequestFinished(success, changed, message)
end

function GuildManager.finishGuildRankNameChangeRequest(self, success, changed, message)
  local gradeRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildInfo2")
  if ___MOD.isvalid(gradeRoot) and gradeRoot.GuildGradeComponent ~= nil then
    gradeRoot.GuildGradeComponent:onGuildRankNameChangeRequestFinished(success, changed, message)
  end
end

function GuildManager.finishGuildSkillInvestRequest(self, success, message, skillId, personalInvestCount, meso)
  local skillRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildSkill")
  if ___MOD.isvalid(skillRoot) and skillRoot.GuildSkillComponent ~= nil then
    skillRoot.GuildSkillComponent:updateGuildSkillPersonalInvestCount(skillId, personalInvestCount)
    skillRoot.GuildSkillComponent:updateGuildSkillMeso(meso)
  end
  if not success and ___MOD._UINotice ~= nil then
    local safeMessage = ___MOD.tostring(message or "")
    if ___MOD._UtilLogic:IsNilorEmptyString(safeMessage) then
      safeMessage = "길드 스킬 투자에 실패했습니다."
    end
    ___MOD._UINotice:showAlertUI(safeMessage)
  end
end

function GuildManager.finishGuildWithdrawRequest(self, success, changed, message)
  local guild = self:getGuildEntity()
  if guild == nil or guild.GuildComponent == nil then
    return
  end
  guild.GuildComponent:onGuildWithdrawRequestFinished(success, changed, message)
end

function GuildManager.getCachedGuildInfo(self, guildId)

end

function GuildManager.getCurrentMapIdServer(self, user)

end

function GuildManager.getGuildActiveBuffExpireAccountKey(self, guildId, playerId, skillId)

end

function GuildManager.getGuildActiveBuffExpireStorageKey(self, guildId, playerId, skillId)

end

function GuildManager.getGuildActiveBuffPlayerStorageKey(self, playerId)

end

function GuildManager.getGuildActiveBuffRemainSecServer(self, user, skillId)

end

function GuildManager.getGuildActiveSkillUseLimitServer(self, skillId, skillLevel)

end

function GuildManager.getGuildBossPlayerIdServer(self, guildInfo)

end

function GuildManager.getGuildCacheKey(self, guildId)

end

function GuildManager.getGuildCapacityFromBroadcastPayloadServer(self, payload, guildInfo, fallbackCapacity)

end

function GuildManager.getGuildCapacityFromUserServer(self, user)

end

function GuildManager.getGuildDataForDeltaClient(self, guildId)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return nil
  end
  local player = user.Player
  if not ___MOD.isvalid(player) or guildId <= 0 then
    return nil
  end
  local guildData = player.guildData
  if guildData == nil then
    return nil
  end
  local dataGuildId = ___MOD.tonumber(guildData.GuildID or 0) or 0
  local playerGuildId = ___MOD.tonumber(player.GuildId or 0) or 0
  if 0 < dataGuildId and dataGuildId ~= guildId then
    return nil
  end
  if 0 < playerGuildId and playerGuildId ~= guildId then
    return nil
  end
  player.GuildId = guildId
  guildData.GuildID = guildId
  if ___MOD.type(guildData.GuildMembers) ~= "table" then
    guildData.GuildMembers = {}
  end
  if ___MOD.type(guildData.GuildRankInfo) ~= "table" then
    guildData.GuildRankInfo = {}
  end
  player.guildData = guildData
  return guildData
end

function GuildManager.getGuildEntity(self)
  if self.guildEntity then
    return self.guildEntity
  end
  local ui = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild")
  self.guildEntity = ui
  return ui
end

function GuildManager.getGuildIdFromBroadcastPayloadServer(self, payload)

end

function GuildManager.getGuildIdFromUserServer(self, user)

end

function GuildManager.getGuildInfoCapacityServer(self, guildInfo)

end

function GuildManager.getGuildInfoGuildId(self, guildInfo)
  if guildInfo == nil then
    return 0
  end
  return ___MOD.tonumber(guildInfo.GuildID or 0) or 0
end

function GuildManager.getGuildInfoMarkInfo(self, guildInfo)
  if guildInfo == nil then
    return nil
  end
  local markInfo = guildInfo.GuildMarkInfo
  local backGroundCode, backGroundColor, markCategory, markCode, markColor
  if markInfo ~= nil then
    backGroundCode = markInfo.BackGroundCode
    backGroundColor = markInfo.BackGroundColorIndex
    markCategory = markInfo.MarkCategory
    markCode = markInfo.MarkCode
    markColor = markInfo.MarkColorIndex
  end
  if backGroundCode == nil or markCategory == nil or markCode == nil then
    return nil
  end
  local backGroundCodeNumber = ___MOD.tonumber(backGroundCode)
  local markCodeNumber = ___MOD.tonumber(markCode)
  local backGroundCodeText = backGroundCodeNumber ~= nil and ___MOD.string.format("%08d", backGroundCodeNumber) or ___MOD.tostring(backGroundCode)
  local markCategoryText = ___MOD.tostring(markCategory)
  local markCodeText = markCodeNumber ~= nil and ___MOD.string.format("%08d", markCodeNumber) or ___MOD.tostring(markCode)
  local backGroundColorIndex = ___MOD.tonumber(backGroundColor) or 0
  local markColorIndex = ___MOD.tonumber(markColor) or 0
  if ___MOD.tonumber(markCategoryText) ~= nil then
    if markCodeNumber ~= nil and 9000 <= markCodeNumber then
      markCategoryText = "Etc"
    elseif markCodeNumber ~= nil and 5000 <= markCodeNumber then
      markCategoryText = "Letter"
    elseif markCodeNumber ~= nil and 4000 <= markCodeNumber then
      markCategoryText = "Pattern"
    elseif markCodeNumber ~= nil and 3000 <= markCodeNumber then
      markCategoryText = "Plant"
    else
      markCategoryText = "Animal"
    end
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(backGroundCodeText) or ___MOD._UtilLogic:IsNilorEmptyString(markCategoryText) or ___MOD._UtilLogic:IsNilorEmptyString(markCodeText) then
    return nil
  end
  if backGroundColorIndex < 1 or 16 < backGroundColorIndex or markColorIndex < 1 or 16 < markColorIndex then
    return nil
  end
  return {
    backGroundCode = backGroundCodeText,
    backGroundColorIndex = backGroundColorIndex,
    markCategory = markCategoryText,
    markCode = markCodeText,
    markColorIndex = markColorIndex
  }
end

function GuildManager.getGuildInfoMembersServer(self, guildInfo)

end

function GuildManager.getGuildInfoNotice(self, guildInfo)
  if guildInfo == nil then
    return ""
  end
  return ___MOD.tostring(guildInfo.GuildNotice or "")
end

function GuildManager.getGuildInfoSkillInfo(self, guildInfo)
  if guildInfo == nil then
    return {}
  end
  return guildInfo.GuildSkillInfo or {}
end

function GuildManager.getGuildInfoSkillInfoServer(self, guildInfo)

end

function GuildManager.getGuildInviteJobName(self, user)

end

function GuildManager.getGuildMarkMarkSize(self, category, code, color)
  local categoryCache = self.guildMarkMarkByCategory[___MOD.tostring(category or "")]
  if ___MOD.type(categoryCache) ~= "table" then
    return nil
  end
  local codeText = ___MOD.tostring(code or "")
  local cache = categoryCache[codeText]
  if ___MOD.type(cache) ~= "table" then
    local codeNumber = ___MOD.tonumber(codeText)
    if codeNumber ~= nil then
      cache = categoryCache[___MOD.string.format("%08d", codeNumber)] or categoryCache[___MOD.tostring(codeNumber)]
    end
  end
  if ___MOD.type(cache) ~= "table" then
    return nil
  end
  local colorIndex = ___MOD.tonumber(color) or 0
  if ___MOD.type(cache.sizesByColor) == "table" then
    local colorSize = cache.sizesByColor[colorIndex] or cache.sizesByColor[___MOD.tostring(colorIndex)]
    if ___MOD.type(colorSize) == "table" then
      return colorSize
    end
  end
  local width = ___MOD.tonumber(cache.width) or 0
  local height = ___MOD.tonumber(cache.height) or 0
  if 0 < width and 0 < height then
    return {width = width, height = height}
  end
  return nil
end

function GuildManager.getGuildMemberCacheByPlayerIdServer(self, guildInfo, playerId)

end

function GuildManager.getGuildMemberNameByPlayerIdServer(self, guildInfo, playerId)

end

function GuildManager.getGuildMemberPlayerIdServer(self, memberInfo)

end

function GuildManager.getGuildMemberRankNoByPlayerIdServer(self, guildInfo, playerId)

end

function GuildManager.getGuildPassiveStatBonusServer(self, skillId, skillLevel)

end

function GuildManager.getGuildRankNameFromGuildDataClient(self, guildData, rankNo)
  if guildData == nil or rankNo <= 0 then
    return ""
  end
  local rankInfo = guildData.GuildRankInfo
  if ___MOD.type(rankInfo) ~= "table" then
    return ""
  end
  for key, value in ___MOD.pairs(rankInfo) do
    local currentRankNo = 0
    local currentRankName = ""
    if ___MOD.type(value) == "table" then
      currentRankNo = ___MOD.tonumber(value.Rank or value.RankNo or key) or 0
      currentRankName = ___MOD.tostring(value.RankName or value.Name or "")
    else
      currentRankNo = ___MOD.tonumber(key) or 0
      currentRankName = ___MOD.tostring(value or "")
    end
    if currentRankNo == rankNo then
      return currentRankName
    end
  end
  return ""
end

function GuildManager.getGuildRankNoFromUserServer(self, user)

end

function GuildManager.getGuildSkillAccountCleanupDateKey(self)

end

function GuildManager.getGuildSkillInfoByIdServer(self, guildInfo, skillId)

end

function GuildManager.getGuildSkillInfoLevelClient(self, skillInfo)
  if skillInfo == nil then
    return 0
  end
  return ___MOD.tonumber(skillInfo.SkillLevel or 0) or 0
end

function GuildManager.getGuildSkillInfoLevelServer(self, skillInfo)

end

function GuildManager.getGuildSkillInfoSkillIdClient(self, skillInfo, fallbackSkillId)
  if skillInfo == nil then
    return fallbackSkillId
  end
  return ___MOD.tonumber(skillInfo.SkillID or fallbackSkillId) or fallbackSkillId
end

function GuildManager.getGuildSkillInfoSkillIdServer(self, skillInfo)

end

function GuildManager.getGuildSkillInvestAccountKey(self, guildId, skillId, suffix)

end

function GuildManager.getGuildSkillInvestStorageKey(self, guildId, skillId, suffix)

end

function GuildManager.getGuildSkillKeyGuildId(self, guildId)

end

function GuildManager.getGuildSkillMaxLevelFromInfoServer(self, skillInfo, skillId)

end

function GuildManager.getGuildSkillMaxLevelServer(self, skillId)

end

function GuildManager.getGuildSkillNameServer(self, skillId)

end

function GuildManager.getGuildSkillPersonalInvestCountServer(self, user, guildId, skillId)

end

function GuildManager.getGuildSkillPersonalUseCountServer(self, user, skillId)

end

function GuildManager.getGuildSkillTotalInvestAccountKey(self, guildId, skillId)

end

function GuildManager.getGuildSkillTotalInvestStorageKey(self, guildId, skillId)

end

function GuildManager.getGuildSkillTotalPersonalInvestCountServer(self, user, guildId, skillId)

end

function GuildManager.getGuildSkillUseDateQexKey(self)

end

function GuildManager.getGuildSkillUseQexKey(self, skillId)

end

function GuildManager.getGuildStatusInstanceId(self)

end

function GuildManager.getPlayerIdFromUser(self, user)

end

function GuildManager.getPlayerNameFromUser(self, user)

end

function GuildManager.getSelectedGuildMark(self)
  if self.selectedGuildMark ~= nil and self.selectedGuildMark.backGroundCode ~= nil then
    return self.selectedGuildMark
  end
  if self.currentGuildMarkInfo ~= nil and self.currentGuildMarkInfo.backGroundCode ~= nil then
    self.selectedGuildMark = self.currentGuildMarkInfo
    return self.selectedGuildMark
  end
  return nil
end

function GuildManager.getUtf8CharacterCount(self, text)
  local content = ___MOD.tostring(text or "")
  local count = 0
  for _, _code in ___MOD.utf8.codes(content) do
    count = count + 1
  end
  return count
end

function GuildManager.hasGuildCache(self, guildId)

end

function GuildManager.hasGuildMemberByPlayerIdServer(self, guildInfo, playerId)

end

function GuildManager.hasLocalPlayerGuild(self)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil or user.Player == nil then
    return false
  end
  return 0 < (___MOD.tonumber(user.Player.GuildId) or 0)
end

function GuildManager.hideGuildInfoUIGuildMark(self)
  local guildMark = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildInfo/guildname/guildmark/guildmark")
  if ___MOD.isvalid(guildMark) then
    guildMark.Visible = false
  end
end

function GuildManager.initGuild(self, user, suppressLoginNotice)

end

function GuildManager.initGuildClient(self, guildInfo)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return
  end
  local player = user.Player
  if not ___MOD.isvalid(player) then
    return
  end
  local guildID = self:getGuildInfoGuildId(guildInfo)
  player.GuildId = guildID
  if guildID <= 0 then
    player.guildData = nil
    self:applyNoGuildClient()
    local nameTagComponent = user:GetComponent("script.PlayerNameTagComponent")
    if nameTagComponent ~= nil then
      nameTagComponent:renderAllNameTags()
    end
    return
  end
  local guildData = ___MOD.Guild()
  guildData.GuildID = guildID
  guildData.GuildName = ___MOD.tostring(guildInfo.GuildName or "")
  guildData.GuildNotice = ___MOD.tostring(guildInfo.GuildNotice or "")
  guildData.GP = ___MOD.tonumber(guildInfo.GP or 0) or 0
  guildData.Capacity = ___MOD.tonumber(guildInfo.Capacity or 10) or 10
  guildData.MyRank = ___MOD.tonumber(guildInfo.MyRank or 0) or 0
  guildData.GuildMembers = guildInfo.GuildMembers or {}
  guildData.GuildRankInfo = guildInfo.GuildRankInfo or {}
  guildData.GuildSkillInfo = guildInfo.GuildSkillInfo or {}
  guildData.GuildMarkInfo = self:getGuildInfoMarkInfo(guildInfo) or {}
  player.guildData = guildData
  self:setCurrentGuildMarkInfo(guildInfo)
  self:applyGuildInfoClient(guildInfo)
  local nameTagComponent = user:GetComponent("script.PlayerNameTagComponent")
  if nameTagComponent ~= nil then
    nameTagComponent:renderAllNameTags()
  end
end

function GuildManager.isGuildInfoMemberNameServer(self, guildInfo, memberName)

end

function GuildManager.isGuildMemberOnlineByPlayerIdServer(self, guildInfo, playerId)

end

function GuildManager.isGuildMemberOnlineServer(self, guildMember)

end

function GuildManager.isGuildSkillAccountGuildTouchedToday(self, user, guildId, today)

end

function GuildManager.isValidGuildMarkSelectionServer(self, category, backGroundCode, backGroundColor, markCode, markColor)

end

function GuildManager.loadGuildMark(self)
  local data = ___MOD._WzUtils:ParseGenericWzCollectionWZ("UI_wz", "GuildMark.img")
  ___MOD.table.clear(self.guildMarkBackGroundList)
  ___MOD.table.clear(self.guildMarkBackGroundByCode)
  ___MOD.table.clear(self.guildMarkMarkList)
  ___MOD.table.clear(self.guildMarkMarkByCategory)
  ___MOD.table.clear(self.selectedGuildMark)
  self.isGuildMarkLoaded = false
  self.isGuildMarkResourcePreloadRequested = false
  self.isGuildMarkResourcePreloadFinished = false
  if data ~= nil then
    self:cacheGuildMarkBackGround(data.BackGround)
    self:cacheGuildMarkMark(data.Mark)
  end
  self.isGuildMarkLoaded = #self.guildMarkBackGroundList > 0 and #self.guildMarkMarkList > 0
  if self.isGuildMarkLoaded then
    self:preloadGuildMarkResources()
    if self:hasLocalPlayerGuild() then
      self:applyGuildInfoUIGuildMark()
    end
  end
  ___MOD._DataLoadManager:compeletedLoad()
end

function GuildManager.logGuildActionServer(self, actorUser, action2, guildId, guildInfo, targetPlayerId, targetName, details)

end

function GuildManager.markGuildDeltaAppliedServer(self, eventKey)

end

function GuildManager.notifyGuildMemberLogin(self, guildId, loginPlayerId, loginPlayerName)

end

function GuildManager.notifyGuildRankChanged(self, guildId, message)

end

function GuildManager.notifyGuildSkillLevelUp(self, guildId, skillId, skillLevel, eventKey)

end

function GuildManager.OnEndPlay(self)

end

function GuildManager.onGuildPlayerLeave(self, user)

end

function GuildManager.preloadGuildMarkResources(self)
  if not self.isGuildMarkLoaded then
    return
  end
  if self.isGuildMarkResourcePreloadRequested then
    return
  end
  self.isGuildMarkResourcePreloadRequested = true
  local ruidList = self:buildGuildMarkPreloadRuidList()
  if #ruidList <= 0 then
    self.isGuildMarkResourcePreloadFinished = true
    return
  end
  ___MOD._ResourceService:PreloadAsync(ruidList, function()
    self.isGuildMarkResourcePreloadFinished = true
  end)
end

function GuildManager.preserveGuildMemberOnlineStates(self, oldGuildInfo, newGuildInfo)

end

function GuildManager.preserveLocalGuildMemberOnlineStates(self, guildId, guildInfo)

end

function GuildManager.publishGuildMemberLoginLocal(self, guildId, loginPlayerId, loginPlayerName)

end

function GuildManager.pushGuildMarkPreloadRuid(self, ruidList, exists, ruidPath)
  if ___MOD._UtilLogic:IsNilorEmptyString(ruidPath) then
    return
  end
  local ruid = ___MOD.__RUIDManager:get(ruidPath)
  if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    return
  end
  if exists[ruid] then
    return
  end
  exists[ruid] = true
  ruidList[#ruidList + 1] = ruid
end

function GuildManager.pushGuildNameToStatUI(self, user, guildName)

end

function GuildManager.rebuildGuildMemberIndexServer(self, guildId, guildInfo)

end

function GuildManager.rebuildGuildSkillIndexServer(self, guildId, guildInfo)

end

function GuildManager.refreshGuildInfoAfterInviteAcceptedServer(self, user, expectedGuildId, requestPlayerId, requesterUserId)

end

function GuildManager.refreshGuildMemberDeltaClient(self, guildData)
  if guildData == nil then
    return
  end
  local guild = self:getGuildEntity()
  if guild == nil or guild.GuildComponent == nil then
    return
  end
  local gc = guild.GuildComponent
  if not gc.memberListInit then
    gc:initGuildMemberList()
  end
  gc:ensureRuntimeTable()
  gc._T.guildID = ___MOD.tonumber(guildData.GuildID or 0) or 0
  gc._T.guildGP = ___MOD.tonumber(guildData.GP or gc._T.guildGP or 0) or 0
  gc._T.myGuildRankNo = ___MOD.tonumber(guildData.MyRank or gc._T.myGuildRankNo or 0) or 0
  gc:applyGuildRankInfo(guildData.GuildRankInfo)
  gc:applyGuildMemberInfo(guildData.GuildMembers)
  gc:refreshGuildInfoButtonState()
  gc:refreshGuildInviteButtonState()
  gc:refreshGuildWithdrawButtonState()
  gc:refreshGuildGradeInfo()
end

function GuildManager.refreshGuildPassiveBuffIconClient(self, guildSkillInfo)
  local desc = self:buildGuildPassiveBuffTooltipDescClient(guildSkillInfo)
  if ___MOD._PlayerTemporaryStatView == nil then
    return
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(desc) then
    ___MOD._PlayerTemporaryStatView:removeGuildPassiveIcon()
    return
  end
  ___MOD._PlayerTemporaryStatView:setGuildPassiveIcon(desc)
end

function GuildManager.removeGuildMemberCacheServer(self, guildId, playerId)

end

function GuildManager.requestGuildActiveSkillUse(self, skillId, targetName, senderUserId)

end

function GuildManager.requestGuildCapacityIncreaseFromNpc(self, user)

end

function GuildManager.requestGuildCreate(self, guildName, senderUserId)

end

function GuildManager.requestGuildCreateFromNpc(self, user, guildName)

end

function GuildManager.requestGuildCreateServer(self, user, guildName, requesterUserId)
  local safeUserId = ___MOD.tostring(requesterUserId or "")
  local nameOk, nameMessage, safeGuildName = self:validateGuildNameText(guildName)
  if not nameOk then
    self:finishGuildCreateRequest(false, ___MOD.tostring(nameMessage or "사용할 수 없는 이름입니다."), safeUserId)
    return
  end
  if not (___MOD.isvalid(user) and ___MOD.isvalid(user.Player)) or ___MOD._UtilLogic:IsNilorEmptyString(safeGuildName) then
    self:finishGuildCreateRequest(false, "길드 생성 요청에 실패했습니다.", safeUserId)
    return
  end
  local playerId = self:getPlayerIdFromUser(user)
  local playerName = self:getPlayerNameFromUser(user)
  if ___MOD._UtilLogic:IsNilorEmptyString(playerId) then
    self:finishGuildCreateRequest(false, "길드 생성 요청에 실패했습니다.", safeUserId)
    return
  end
  local currentGuildId = ___MOD.tonumber(user.Player.GuildId or 0) or 0
  if currentGuildId <= 0 then
    self:clearGuildMembershipCacheForPlayerServer(playerId)
  end
  if 0 < currentGuildId then
    self:finishGuildCreateRequest(false, "이미 가입된 길드가 있습니다.", safeUserId)
    return
  end
  if not ___MOD.isvalid(user.CInventoryComponent) or user.CInventoryComponent.Meso < self.GUILD_CREATE_COST then
    self:finishGuildCreateRequest(false, "메소가 부족하여 생성할 수 없습니다.", safeUserId)
    return
  end
  self:ensureGuildRuntimeTables()
  if self.guildCreatePendingByPlayerId[playerId] == true then
    self:finishGuildCreateRequest(false, "이미 길드 생성 요청을 처리 중입니다.", safeUserId)
    return
  end
  self.guildCreatePendingByPlayerId[playerId] = true
  user.CInventoryComponent:gainMeso(-self.GUILD_CREATE_COST, "GUILD_CREATE")
  self:addMesoConsumeChatLog(user, self.GUILD_CREATE_COST)
  local request = {actorPlayerId = playerId, guildName = safeGuildName}
  local requestPlayerId = playerId
  local enqueued = ___MOD._WorldRequestService:enqueue(___MOD._WorldRequestType.GUILD_CREATE, request, playerId, playerName, nil, nil, function(response, queue)
    self.guildCreatePendingByPlayerId[playerId] = nil
    if self:getPlayerIdFromUser(user) ~= requestPlayerId then
      return
    end
    local ok = response == ___MOD._WorldResponseType.SUCCESSED
    local result = queue ~= nil and (queue.m or queue.msg or queue.message) or nil
    local changed = false
    local message = ""
    local guildInfo
    if ___MOD.type(result) == "table" then
      changed = result.changed == true or (___MOD.tonumber(result.changed or 0) or 0) == 1
      message = ___MOD.tostring(result.message or result.error or "")
      guildInfo = result.GuildInfo
    end
    if not (ok and changed) or ___MOD.type(guildInfo) ~= "table" then
      if ___MOD.isvalid(user) and ___MOD.isvalid(user.CInventoryComponent) then
        user.CInventoryComponent:gainMeso(self.GUILD_CREATE_COST, "GUILD_CREATE_REFUND")
        self:addMesoGainChatLog(user, self.GUILD_CREATE_COST)
      end
      if ___MOD._UtilLogic:IsNilorEmptyString(message) then
        message = "길드 생성에 실패했습니다."
      end
      self:finishGuildCreateRequest(false, message, safeUserId)
      return
    end
    local guildId = self:getGuildInfoGuildId(guildInfo)
    if guildId <= 0 then
      if ___MOD.isvalid(user) and ___MOD.isvalid(user.CInventoryComponent) then
        user.CInventoryComponent:gainMeso(self.GUILD_CREATE_COST, "GUILD_CREATE_REFUND")
        self:addMesoGainChatLog(user, self.GUILD_CREATE_COST)
      end
      self:finishGuildCreateRequest(false, "길드 생성에 실패했습니다.", safeUserId)
      return
    end
    if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
      user.Player.GuildId = guildId
      self:setGuildCache(guildId, guildInfo)
      self:setLocalGuildPlayer(guildId, playerId, user)
      self:setGuildMemberOnlineState(guildInfo, playerId, true)
      self:setGuildInfoMyRankForPlayer(guildInfo, playerId)
      self:applyGuildNameTagSync(user, guildInfo)
      self:initGuildClient(self:buildGuildInfoForPlayerServer(guildInfo, user), safeUserId)
    end
    self:finishGuildCreateRequest(true, "길드가 성공적으로 생성되었습니다.", safeUserId)
  end)
  if not enqueued then
    self.guildCreatePendingByPlayerId[playerId] = nil
    if ___MOD.isvalid(user.CInventoryComponent) then
      user.CInventoryComponent:gainMeso(self.GUILD_CREATE_COST, "GUILD_CREATE_REFUND")
      self:addMesoGainChatLog(user, self.GUILD_CREATE_COST)
    end
    self:finishGuildCreateRequest(false, "길드 생성 요청에 실패했습니다.", safeUserId)
  end
end

function GuildManager.requestGuildDisbandFromNpc(self, user)

end

function GuildManager.requestGuildMarkChange(self, guildId, backGroundCode, backGroundColor, markCategory, markCode, markColor, senderUserId)

end

function GuildManager.requestGuildMemberInvite(self, guildId, targetName, senderUserId)

end

function GuildManager.requestGuildMemberKick(self, guildId, targetPlayerId, senderUserId)

end

function GuildManager.requestGuildMemberRankChange(self, guildId, targetPlayerId, direction, senderUserId)

end

function GuildManager.requestGuildMemberStatusChanged(self, guildId, playerId, playerName, online, isWarpLogin)

end

function GuildManager.requestGuildMemberStatusChangedRetry(self, guildId, playerId, playerName, online, isWarpLogin, retryCount)

end

function GuildManager.requestGuildMemberWithdraw(self, guildId, senderUserId)

end

function GuildManager.requestGuildNoticeChange(self, guildId, guildNotice, senderUserId)

end

function GuildManager.requestGuildRankNameChange(self, guildId, rankNames, senderUserId)

end

function GuildManager.requestGuildSkillInvest(self, skillId, senderUserId)

end

function GuildManager.requestGuildWhere(self, targetName, senderUserId)

end

function GuildManager.resetAllGuildSkillPersonalInvestCountsServer(self, user)

end

function GuildManager.resetAllGuildSkillPersonalUseCountsServer(self, user)

end

function GuildManager.resetGuildSkillPersonalUseCountsIfNeedServer(self, user)

end

function GuildManager.responseGuildInvite(self, accept, guildId, inviterPlayerId, targetPlayerId, senderUserId)

end

function GuildManager.scheduleGuildActiveBuffExpireServer(self, user, skillId, remainSec)

end

function GuildManager.setCurrentGuildMarkInfo(self, guildInfo)
  local markInfo = self:getGuildInfoMarkInfo(guildInfo)
  ___MOD.table.clear(self.currentGuildMarkInfo)
  ___MOD.table.clear(self.selectedGuildMark)
  if markInfo == nil then
    return false
  end
  self.currentGuildMarkInfo = markInfo
  self.selectedGuildMark = markInfo
  return true
end

function GuildManager.setGuildActiveBuffExpireTimeServer(self, user, skillId, expireMs)

end

function GuildManager.setGuildCache(self, guildId, guildInfo)

end

function GuildManager.setGuildCapacityCacheServer(self, guildId, capacity)

end

function GuildManager.setGuildInfoMyRankForPlayer(self, guildInfo, playerId)

end

function GuildManager.setGuildMarkInfoCacheServer(self, guildId, guildMarkInfo)

end

function GuildManager.setGuildMemberOnlineState(self, guildInfo, playerId, online)

end

function GuildManager.setGuildMemberRankCacheServer(self, guildId, playerId, rankNo)

end

function GuildManager.setGuildNoticeCacheServer(self, guildId, guildNotice)

end

function GuildManager.setGuildRankNameCacheServer(self, guildId, rankNo, rankName)

end

function GuildManager.setGuildRankNameInGuildDataClient(self, guildData, rankNo, rankName)
  if guildData == nil or rankNo <= 0 or ___MOD._UtilLogic:IsNilorEmptyString(rankName) then
    return
  end
  if ___MOD.type(guildData.GuildRankInfo) ~= "table" then
    guildData.GuildRankInfo = {}
  end
  local rankInfo = guildData.GuildRankInfo
  local changed = false
  for key, value in ___MOD.pairs(rankInfo) do
    local currentRankNo = 0
    if ___MOD.type(value) == "table" then
      currentRankNo = ___MOD.tonumber(value.Rank or value.RankNo or key) or 0
      if currentRankNo == rankNo then
        value.RankName = rankName
        value.Name = rankName
        changed = true
      end
    else
      currentRankNo = ___MOD.tonumber(key) or 0
      if currentRankNo == rankNo then
        rankInfo[key] = rankName
        changed = true
      end
    end
  end
  if not changed then
    rankInfo[rankNo] = rankName
  end
end

function GuildManager.setGuildSkillInfoCacheServer(self, guildId, guildSkillInfo)

end

function GuildManager.setGuildSkillPersonalInvestCountServer(self, user, guildId, skillId, count)

end

function GuildManager.setGuildSkillPersonalUseCountServer(self, user, skillId, count)

end

function GuildManager.setGuildSkillTotalPersonalInvestCountServer(self, user, guildId, skillId, count)

end

function GuildManager.setLocalGuildPlayer(self, guildId, playerId, user)

end

function GuildManager.showGuildCreateNameInput(self)
  if ___MOD._UINotice == nil then
    return
  end
  ___MOD._UINotice:showInputUI("길드 이름을 입력해 주세요", "", function(base, inputText)
    local nameOk, nameMessage, guildName = self:validateGuildNameText(___MOD.tostring(inputText or ""))
    if ___MOD._UtilLogic:IsNilorEmptyString(guildName) then
      return
    end
    if not nameOk then
      ___MOD._UINotice:showAlertUI(___MOD.tostring(nameMessage or "사용할 수 없는 이름입니다."))
      return
    end
    self:requestGuildCreate(guildName)
  end, false)
end

function GuildManager.showGuildInviteFadeYesNo(self, inviterLevel, inviterJobName, inviterName, guildId, inviterPlayerId, targetPlayerId)
  if ___MOD._FadeYesNo == nil then
    return
  end
  local message = ___MOD.string.format("Lv. %d  %s\r\n'%s'님의\r\n길드 초대입니다.", ___MOD.tonumber(inviterLevel) or 0, ___MOD.tostring(inviterJobName or ""), ___MOD.tostring(inviterName or ""))
  ___MOD._FadeYesNo:createFadeYesNo(1, 5, false, message, nil, function(result)
    self:responseGuildInvite(result == true, guildId, inviterPlayerId, targetPlayerId)
  end, ___MOD._BitmapFontAlignmentType.Center, nil, "guild_invite_" .. inviterPlayerId)
end

function GuildManager.showGuildMemberLoginNotice(self, playerName)
  local user = ___MOD._UserService.LocalPlayer
  if user ~= nil and user.UIGameOptionComponent ~= nil and not user.UIGameOptionComponent.enableGuildLoginNotice then
    return
  end
  if ___MOD._FadeYesNo == nil or ___MOD._UtilLogic:IsNilorEmptyString(playerName) then
    return
  end
  local message = ___MOD.string.format("%s님이\r\n로그인했습니다.", playerName)
  ___MOD._FadeYesNo:createFadeYesNo(4, 3, true, message, 5, nil, ___MOD._BitmapFontAlignmentType.Left, 66, "guild_login_notice_" .. playerName)
end

function GuildManager.showGuildRankChangedChatClient(self, memberName, rankName)
  local safeMemberName = ___MOD.tostring(memberName or "")
  local safeRankName = ___MOD.tostring(rankName or "")
  if ___MOD._UtilLogic:IsNilorEmptyString(safeMemberName) then
    safeMemberName = "길드원"
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(safeRankName) then
    safeRankName = "새 직위"
  end
  ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, ___MOD.string.format("'%s'님의 직위가 '%s'(으)로 변경되었습니다.", safeMemberName, safeRankName))
end

function GuildManager.showGuildSkillLevelUpChat(self, skillId, skillLevel)
  if skillId <= 0 or skillLevel <= 0 then
    return
  end
  local skillName = ___MOD.tostring(skillId)
  if ___MOD._GuildSkillLogic ~= nil then
    local config = ___MOD._GuildSkillLogic:getGuildSkillConfig(skillId)
    if ___MOD.type(config) == "table" and not ___MOD._UtilLogic:IsNilorEmptyString(___MOD.tostring(config.guildName or "")) then
      skillName = ___MOD.tostring(config.guildName)
    end
  end
  ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, ___MOD.string.format("[%s] 길드 스킬의 레벨이 %d가 되었습니다.", skillName, skillLevel))
end

function GuildManager.syncGuildActiveBuffIconsClient(self, expRemainSec, bossRemainSec)
  if ___MOD._PlayerTemporaryStatView == nil then
    return
  end
  local safeExpRemainSec = ___MOD.math.max(0, ___MOD.tonumber(expRemainSec) or 0)
  local safeBossRemainSec = ___MOD.math.max(0, ___MOD.tonumber(bossRemainSec) or 0)
  if 0 < safeExpRemainSec then
    ___MOD._PlayerTemporaryStatView:setGuildActiveBuffIcon(___MOD._PlayerTemporaryStatView.GUILD_ACTIVE_EXP_BUFF_ID, safeExpRemainSec, "경험치 50% 증가", "일정 시간동안 몬스터 처치 시 경험치를 50% 추가 획득한다.")
  else
    ___MOD._PlayerTemporaryStatView:removeBySkillID(___MOD._PlayerTemporaryStatView.GUILD_ACTIVE_EXP_BUFF_ID)
  end
  if 0 < safeBossRemainSec then
    ___MOD._PlayerTemporaryStatView:setGuildActiveBuffIcon(___MOD._PlayerTemporaryStatView.GUILD_ACTIVE_BOSS_BUFF_ID, safeBossRemainSec, "보스따위 두렵지 않다", ___MOD.string.format("일정 시간 동안 보스 공격력이 %s 증가한다.", "10%"))
  else
    ___MOD._PlayerTemporaryStatView:removeBySkillID(___MOD._PlayerTemporaryStatView.GUILD_ACTIVE_BOSS_BUFF_ID)
  end
end

function GuildManager.syncGuildSkillMesoClient(self, meso)
  local skillRoot = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/UserList/Guild/GuildSkill")
  if ___MOD.isvalid(skillRoot) and skillRoot.GuildSkillComponent ~= nil then
    skillRoot.GuildSkillComponent:updateGuildSkillMeso(meso)
  end
end

function GuildManager.trimGuildInviteName(self, targetName)

end

function GuildManager.tryAcquireGuildWhereCooldownServer(self, userId)

end

function GuildManager.tryLockGuildActiveSkillUseServer(self, userId, skillId)

end

function GuildManager.unlockGuildActiveSkillUseServer(self, userId, skillId)

end

function GuildManager.upsertGuildSkillInfoClient(self, guildData, skillInfo)
  if guildData == nil or ___MOD.type(skillInfo) ~= "table" then
    return {}
  end
  local skillId = ___MOD.tonumber(skillInfo.SkillID or 0) or 0
  if skillId <= 0 then
    return guildData.GuildSkillInfo or {}
  end
  local currentSkills = guildData.GuildSkillInfo
  if ___MOD.type(currentSkills) ~= "table" then
    currentSkills = {}
  end
  local nextSkills = {}
  for _, currentSkillInfo in ___MOD.pairs(currentSkills) do
    if ___MOD.type(currentSkillInfo) == "table" and (___MOD.tonumber(currentSkillInfo.SkillID or 0) or 0) ~= skillId then
      nextSkills[#nextSkills + 1] = currentSkillInfo
    end
  end
  nextSkills[#nextSkills + 1] = skillInfo
  ___MOD.table.sort(nextSkills, function(a, b)
    return (___MOD.tonumber(a.SkillID or 0) or 0) < (___MOD.tonumber(b.SkillID or 0) or 0)
  end)
  guildData.GuildSkillInfo = nextSkills
  return nextSkills
end

function GuildManager.validateGuildNameText(self, guildName)
  local safeGuildName = ___MOD.string.gsub(___MOD.tostring(guildName or ""), "^%s+", "")
  safeGuildName = ___MOD.string.gsub(safeGuildName, "%s+$", "")
  if ___MOD._UtilLogic:IsNilorEmptyString(safeGuildName) then
    return false, "사용할 수 없는 이름입니다.", ""
  end
  local allow, message = ___MOD._CheckNameUtils:is_valid_name(safeGuildName, true)
  if not allow then
    local errorMessage = ___MOD.tostring(message or "")
    if ___MOD._UtilLogic:IsNilorEmptyString(errorMessage) then
      errorMessage = "사용할 수 없는 이름입니다."
    end
    return false, errorMessage, safeGuildName
  end
  return true, "", safeGuildName
end

function GuildManager.validateGuildRankNameText(self, rankName)
  local safeRankName = ___MOD.string.gsub(___MOD.tostring(rankName or ""), "^%s+", "")
  safeRankName = ___MOD.string.gsub(safeRankName, "%s+$", "")
  if ___MOD._UtilLogic:IsNilorEmptyString(safeRankName) then
    return false, "사용할 수 없는 이름입니다.", ""
  end
  if self:getUtf8CharacterCount(safeRankName) > 5 then
    return false, "직위명은 5글자까지만 입력할 수 있습니다.", safeRankName
  end
  local allow, message = ___MOD._CheckNameUtils:is_valid_name(safeRankName, true)
  if not allow then
    local errorMessage = ___MOD.tostring(message or "")
    if ___MOD._UtilLogic:IsNilorEmptyString(errorMessage) then
      errorMessage = "사용할 수 없는 이름입니다."
    end
    return false, errorMessage, safeRankName
  end
  return true, "", safeRankName
end
