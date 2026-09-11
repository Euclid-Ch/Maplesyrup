

function ClientCommandLogic.checkRemoteFindBlockedByBlackList(self, foundUserId, requesterName, callback)
  if ___MOD._UtilLogic:IsNilorEmptyString(foundUserId) then
    callback(true)
    return
  end
  local tableName = ___MOD.string.format("Account_%s", foundUserId)
  local resolved = ___MOD._WebDBStorageService:resolveKeyInfo(tableName)
  if resolved == nil then
    callback(true)
    return
  end
  local resolvedEntries = {resolved}
  local ok = ___MOD._WorldRequestService:enqueue(___MOD._WorldRequestType.LOAD_DB_TO_WEB, {entries = resolvedEntries}, foundUserId, nil, nil, nil, function(response, queue)
    if response ~= ___MOD._WorldResponseType.SUCCESSED or queue == nil then
      callback(true)
      return
    end
    local loadMap = ___MOD._WebDBStorageService:buildLoadedValueMap(resolvedEntries, queue)
    local accountData = loadMap and loadMap[tableName] or nil
    if accountData == nil or accountData == false then
      callback(true)
      return
    end
    callback(self:isFindBlockedByAccountData(accountData, requesterName))
  end)
  if not ok then
    callback(true)
  end
end

function ClientCommandLogic.commandChatAll(self, user, argc, args)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToALL)
end

function ClientCommandLogic.commandFriend(self, user, argc, args)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToFriends)
end

function ClientCommandLogic.commandGuild(self, user, argc, args)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToGuild)
end

function ClientCommandLogic.commandParty(self, user, argc, args)
  ___MOD._ChatLogic:changeChatTarget(___MOD._ChatTargetType.ToParty)
end

function ClientCommandLogic.commandPartyInfo(self, user, argc, args)
  local player = user.Player
  local partyComponent = user.PartyUIComponent
  if player == nil or partyComponent == nil then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "가입한 파티가 없습니다.")
    return
  end
  if player.PartyId == 0 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "가입한 파티가 없습니다.")
    return
  end
  local partyMembers = partyComponent.partyMembers
  if partyMembers == nil or ___MOD.next(partyMembers) == nil then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "가입한 파티가 없습니다.")
    return
  end
  local amLeader = partyComponent:isLeader()
  local ordered = {}
  local leaderName = ""
  for idx, pm in ___MOD.pairs(partyMembers) do
    if pm ~= nil and pm.name ~= nil then
      ordered[#ordered + 1] = {index = idx, data = pm}
      if pm.isLeader then
        leaderName = pm.name
      end
    end
  end
  if #ordered == 0 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "가입한 파티가 없습니다.")
    return
  end
  ___MOD.table.sort(ordered, function(a, b)
    return a.index < b.index
  end)
  local names = {}
  for i = 1, #ordered do
    names[i] = ordered[i].data.name
  end
  local membersText = ___MOD.string.format("파티원 : %s", ___MOD.table.concat(names, ", "))
  ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, membersText)
  if amLeader then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "당신은 파티장입니다.")
  else
    local leaderDisplayName = leaderName
    if leaderDisplayName == "" then
      leaderDisplayName = "알 수 없음"
    end
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, ___MOD.string.format("파티장은 %s 입니다. 당신은 파티원입니다.", leaderDisplayName))
  end
end

function ClientCommandLogic.commandWhisper(self, user, argc, args)
  local targetName = args[2] or ""
  if ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    local lastTarget = ""
    if ___MOD.isvalid(user) and ___MOD.isvalid(user.PlayerChatComponent) then
      lastTarget = user.PlayerChatComponent.whisperTarget or ""
    end
    targetName = lastTarget
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "귓속말 대상 캐릭터 이름을 입력해주세요.")
    return
  end
  ___MOD._ChatLogic:setWhisperTarget(targetName)
  ___MOD._ChatLogic:activateChatField()
end

function ClientCommandLogic.createParty(self, user, argc, args)
  if 1 < argc then
    return
  end
  if user.Player.PartyId ~= 0 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "이미 가입 한 파티가 있습니다.")
    return
  end
  ___MOD._PartyManager:tryCreateParty()
end

function ClientCommandLogic.find(self, user, argc, args)
  if argc ~= 2 then
    return
  end
  local targetName = args[2] or nil
  self:findPlayer(targetName)
end

function ClientCommandLogic.findPlayer(self, targetName, senderUserId)

end

function ClientCommandLogic.help(self, user, argc, args)
  local helpMessage = {}
  helpMessage[1] = "----------------- 도움말 -----------------"
  helpMessage[2] = "/파티정보 : 현재의 파티정보를 알려준다."
  helpMessage[3] = "/파티만들기 : 새로운 파티를 만든다."
  helpMessage[4] = "/파티탈퇴 : 현재 파티에 가입되어있는 경우 빠져나간다."
  helpMessage[5] = "/파티초대 캐릭터이름 : 파티에 초대한다.(파티장만)"
  helpMessage[6] = "/파티강퇴 캐릭터이름 : 강제로 파티 퇴장시킨다.(파티장만)"
  helpMessage[7] = "/길드정보 : 현재의 길드정보를 알려준다."
  helpMessage[8] = "/길드탈퇴 : 현재 길드에 가입되어있는 경우 빠져나간다.(길드원만)"
  helpMessage[9] = "/길드초대 캐릭터이름 : 길드에 초대한다.(마스터/부마스터만)"
  helpMessage[10] = "/길드강퇴 캐릭터이름 : 강제로 길드 퇴장시킨다.(마스터만)"
  helpMessage[11] = "/찾기 캐릭터이름 : 사용자의 접속여부/현재위치를 알려준다."
  helpMessage[12] = "/교환 캐릭터이름 : 게임아이템 교환신청을 한다."
  helpMessage[13] = "/채널 : 현재 채널에 접속해 있는 모두를 대화 상대로 설정한다."
  helpMessage[14] = "/친구 : 접속해 있는 친구를 대화 상대로 설정한다."
  helpMessage[15] = "/파티 : 접속해 있는 파티원을 대화 상대로 설정한다."
  helpMessage[16] = "/길드 : 접속해 있는 길드원을 대화 상대로 설정한다."
  helpMessage[17] = "/귓말 캐릭터이름 : 귓속말 상태로 설정 (캐릭터이름 생략시 최근상대)"
  helpMessage[18] = "/모두 : 귓속말이 아닌 일반대화로 설정"
  helpMessage[19] = "* 채팅 입력창을 열고 Tab 키를 누르거나 채팅 입력창을 닫고"
  helpMessage[20] = "숫자키 1, 2, 3을 누르면 대화 상대를 다르게 설정할 수 있습니다."
  for _, msg in ___MOD.ipairs(helpMessage) do
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Yellow, msg)
  end
end

function ClientCommandLogic.inviteGuild(self, user, argc, args)
  if argc ~= 2 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "사용법: /길드초대 캐릭터이름")
    return
  end
  local targetName = args[2] or ""
  if ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "사용법: /길드초대 캐릭터이름")
    return
  end
  if not ___MOD.isvalid(user) or not ___MOD.isvalid(user.Player) then
    return
  end
  local guildId = ___MOD.tonumber(user.Player.GuildId or 0) or 0
  if guildId <= 0 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "가입한 길드가 없습니다.")
    return
  end
  if ___MOD._GuildManager == nil then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "길드 초대 요청에 실패했습니다.")
    return
  end
  ___MOD._GuildManager:requestGuildMemberInvite(guildId, targetName)
end

function ClientCommandLogic.inviteParty(self, user, argc, args)
  if argc < 2 or 4 < argc then
    return
  end
  local name = args[2] or ""
  if ___MOD._UtilLogic:IsNilorEmptyString(name) then
    return
  end
  ___MOD._PartyManager:tryInviteParty(name)
end

function ClientCommandLogic.inviteTrade(self, user, argc, args)
  if argc < 2 or 4 < argc then
    return
  end
  local name = args[2] or ""
  if ___MOD._UtilLogic:IsNilorEmptyString(name) then
    return
  end
  if user.TradingComponent.isTrading then
    return
  end
  ___MOD._TradingLogic:inviteTrade(name)
end

function ClientCommandLogic.isFindBlockedByAccountData(self, accountData, requesterName)
  if ___MOD._UtilLogic:IsNilorEmptyString(accountData) then
    return false
  end
  local ok, dataTable = ___MOD.pcall(function()
    return ___MOD._HttpService:JSONDecode(accountData)
  end)
  if not ok or ___MOD.type(dataTable) ~= "table" then
    return false
  end
  return self:isNameInBlackListTable(dataTable.BlackList or dataTable.blackList, requesterName)
end

function ClientCommandLogic.isFindBlockedByOnlineTarget(self, requester, target)
  if not ___MOD.isvalid(requester) or not ___MOD.isvalid(target) then
    return false
  end
  if not ___MOD.isvalid(requester.Player) or not ___MOD.isvalid(target.Account) then
    return false
  end
  return target.Account:isInBlackList(requester.Player.Name)
end

function ClientCommandLogic.isNameInBlackListTable(self, blackList, targetName)
  if ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    return false
  end
  if ___MOD.type(blackList) ~= "table" then
    return false
  end
  local normalizedTarget = ___MOD.tostring(targetName)
  normalizedTarget = ___MOD.string.gsub(normalizedTarget, "^%s+", "")
  normalizedTarget = ___MOD.string.gsub(normalizedTarget, "%s+$", "")
  if ___MOD._UtilLogic:IsNilorEmptyString(normalizedTarget) then
    return false
  end
  for _, row in ___MOD.pairs(blackList) do
    if ___MOD.type(row) == "table" then
      local rowName = ___MOD.tostring(row.name or "")
      rowName = ___MOD.string.gsub(rowName, "^%s+", "")
      rowName = ___MOD.string.gsub(rowName, "%s+$", "")
      if rowName == normalizedTarget then
        return true
      end
    elseif ___MOD.type(row) == "string" then
      local rowName = ___MOD.string.gsub(row, "^%s+", "")
      rowName = ___MOD.string.gsub(rowName, "%s+$", "")
      if rowName == normalizedTarget then
        return true
      end
    end
  end
  return false
end

function ClientCommandLogic.kickPartyMember(self, user, argc, args)
  if argc < 2 or 4 < argc then
    return
  end
  local targetName = args[2] or ""
  local player = user.Player
  if player.PartyId == 0 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "가입한 파티가 없습니다")
    return
  end
  local pm = user.PartyUIComponent:findPartyMemberByName(player.Name)
  if pm == nil then
    return
  end
  if not pm.isLeader then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "파티 강퇴는 파티장만 가능합니다")
    return
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(targetName) then
    return
  end
  if targetName == player.Name then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "자기 자신은 강퇴할 수 없습니다")
    return
  end
  ___MOD._PartyManager:tryKickMember(targetName)
end

function ClientCommandLogic.leaveParty(self, user, argc, args)
  if 1 < argc then
    return
  end
  local player = user.Player
  if player.PartyId == 0 then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "가입한 파티가 없습니다")
    return
  end
  local findPM = user.PartyUIComponent:findPartyMemberByName(player.Name)
  if findPM == nil then
    return
  end
  ___MOD._PartyManager:tryLeaveParty()
end

function ClientCommandLogic.OnBeginPlay(self)
  self.commands = {
    ["/도움말"] = self.help,
    ["/파티정보"] = self.commandPartyInfo,
    ["/파티만들기"] = self.createParty,
    ["/파티탈퇴"] = self.leaveParty,
    ["/파티초대"] = self.inviteParty,
    ["/파티강퇴"] = self.kickPartyMember,
    ["/길드초대"] = self.inviteGuild,
    ["/게임교환"] = self.inviteTrade,
    ["/찾기"] = self.find,
    ["/모두"] = self.commandChatAll,
    ["/귓말"] = self.commandWhisper,
    ["/길드"] = self.commandGuild,
    ["/파티"] = self.commandParty,
    ["/친구"] = self.commandFriend,
    ["/교환"] = self.trade
  }
end

function ClientCommandLogic.testFriendList(self, user, argc, args)
  if not ___MOD.isvalid(user) or user.FriendComponent == nil then
    return
  end
  user.FriendComponent:addTemporaryTestFriendsClient()
  ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Yellow, "친구창 테스트 친구 50명을 임시로 추가했습니다.")
end

function ClientCommandLogic.trade(self, user, argc, args)
  local targetName = args[2]
  if not targetName or ___MOD.type(targetName) ~= "string" then
    return
  end
  local target
  for _, user in ___MOD.pairs(___MOD._UserService.UserEntities) do
    local player = user and user.Player or nil
    if player and player.Name == targetName then
      target = user
      break
    end
  end
  if not target then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "캐릭터를 찾을 수 없습니다.")
    return
  end
  ___MOD._TradingLogic:inviteTrade(targetName)
end

function ClientCommandLogic.tryCommand(self, msg)
  local user = ___MOD._UserService.LocalPlayer
  local hasCommandPrefix = ___MOD.type(msg) == "string" and ___MOD.string.sub(msg, 1, 1) == "/"
  local isAdmin = false
  if ___MOD.isvalid(user) and ___MOD.isvalid(user.Player) then
    isAdmin = 0 < (user.Player.AdminLevel or 0)
  end
  local args = ___MOD._UtilLogic:Split(msg, " ")
  local argc = #args
  local func = self.commands[args[1]]
  if func ~= nil then
    local ret = func(self, user, argc, args)
    if ret == nil then
      return true
    end
  end
  if hasCommandPrefix and isAdmin then
    return false
  end
  return hasCommandPrefix
end
