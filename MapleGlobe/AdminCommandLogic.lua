

function AdminCommandLogic.abuseLogoutDropUseItemTest(self, user, argc, args)

end

function AdminCommandLogic.abuseLogoutDropUseItemTestClient(self, delayMs, useSlot)
  local delaySec = ___MOD.math.max(0, delayMs) / 1000
  ___MOD._PlayerDataLogic:returnToTitleFromClient()
  ___MOD._TimerService:SetTimerOnce(function()
    local player = ___MOD._UserService.LocalPlayer
    if not ___MOD.isvalid(player) or player.CInventoryComponent == nil then
      return
    end
    player.CInventoryComponent:dropItemFromUser(___MOD._InventorySlotType.USE, useSlot, 1)
  end, delaySec)
end

function AdminCommandLogic.abuseLogoutScrollTest(self, user, argc, args)

end

function AdminCommandLogic.abuseLogoutScrollTestClient(self, delayMs, scrollItemId, useSlot, targetSlot)
  local delaySec = ___MOD.math.max(0, delayMs) / 1000
  ___MOD._PlayerDataLogic:returnToTitleFromClient()
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._UseItemManager:onUseItemServer(scrollItemId, {
      useSlot = useSlot,
      targetInvType = ___MOD._InventorySlotType.EQUIP,
      targetSlot = targetSlot
    })
  end, delaySec)
end

function AdminCommandLogic.addPeriodTestStackToInventory(self, user, itemID, invType, seconds, addTradeCashFlag)

end

function AdminCommandLogic.advanceJobPathForJobTestSetup(self, player, jobId, targetLevel)

end

function AdminCommandLogic.appendJobTestConsumableItem(self, items, itemId, count)

end

function AdminCommandLogic.appendJobTestEquipItem(self, items, itemId)

end

function AdminCommandLogic.appendJobTestProjectileItems(self, items, jobId)

end

function AdminCommandLogic.applyAdminHideAlphaClient(self, user, enabled)
  if not (___MOD._UserService.LocalPlayer == user and ___MOD.isvalid(user)) or user.AvatarRendererComponent == nil then
    return
  end
  local alpha = 1.0
  if enabled then
    alpha = 0.55
  else
    local pts = user.PlayerTemporaryStatComponent
    if pts ~= nil and pts:getTemporaryStatData(___MOD._CTS.DarkSight) ~= nil then
      alpha = 0.55
    end
  end
  user.AvatarRendererComponent:SetAlpha(alpha)
  local hideSkillId = ___MOD._SkillBook.Hide_900_9001004
  ___MOD._PlayerTemporaryStatView:removeBySkillID(hideSkillId)
  if enabled then
    local entry = ___MOD._PlayerTemporaryStatView:add(hideSkillId, 2100000000, false)
    if entry ~= nil and ___MOD.isvalid(entry.layer) and ___MOD.isvalid(entry.layer.SlotNumberComponent) then
      entry.layer.SlotNumberComponent:updateNumber(-1, true)
    end
  end
end

function AdminCommandLogic.applyDebuff(self, user, argc, args)

end

function AdminCommandLogic.applyJobTestSetup(self, user, argc, args)

end

function AdminCommandLogic.attractTest(self, user, argc, args)

end

function AdminCommandLogic.bowExpertPadTest(self, user, argc, args)

end

function AdminCommandLogic.buildCubeVerifyCompactRateString(self, countMap, successCount)

end

function AdminCommandLogic.buildJobTestBasicEquipItems(self, jobId, targetLevel, fallbackItems)

end

function AdminCommandLogic.buildSkillJobPath(self, id)
  local path = {}
  local p = 1
  local k = id // 1000
  path[p], p = k * 1000, p + 1
  local h = id // 100 % 10
  if h ~= 0 then
    local v = path[#path] + h * 100
    path[p], p = v, p + 1
    local t = id // 10 % 10
    if t ~= 0 then
      v = v + t * 10
      path[p], p = v, p + 1
      local o = id % 10
      if 1 <= o then
        v = v + 1
        path[p], p = v, p + 1
        if o == 2 then
          v = v + 1
          path[p] = v
        end
      end
    end
  end
  return path
end

function AdminCommandLogic.centerNotice(self, user, argc, args)

end

function AdminCommandLogic.centerNoticeClient(self, user, text)
  user.CenterNoticeComponent:drawText(text)
end

function AdminCommandLogic.changeJob(self, user, argc, args)

end

function AdminCommandLogic.changeLevel(self, user, argc, args)

end

function AdminCommandLogic.changeSkillLevel(self, user, argc, args)

end

function AdminCommandLogic.checkMobTime(self, user, argc, args)

end

function AdminCommandLogic.cleanupPreviousJobTestGrantedItems(self, user)

end

function AdminCommandLogic.clearAllSkills(self, user, argc, args)

end

function AdminCommandLogic.clearCrashTestMemory(self, user, argc, args)

end

function AdminCommandLogic.clearCrashTestTimers(self, user, argc, args)

end

function AdminCommandLogic.clearDiseaseImmune(self, user, argc, args)

end

function AdminCommandLogic.clearDrops(self, user)

end

function AdminCommandLogic.clearFixedDamageCheat(self, user, argc, args)

end

function AdminCommandLogic.clearGodMode(self, user, argc, args)

end

function AdminCommandLogic.clearItems(self, user, argc, args)

end

function AdminCommandLogic.clearQuestMobCount(self, user, argc, args)

end

function AdminCommandLogic.completeShaolinEntryPrerequisites(self, user, argc, args)

end

function AdminCommandLogic.consumeAllPetFood(self, user, argc, args)

end

function AdminCommandLogic.countTable(self, values)

end

function AdminCommandLogic.crashTestCpuSpin(self, user, argc, args)

end

function AdminCommandLogic.crashTestMemoryFlood(self, user, argc, args)

end

function AdminCommandLogic.crashTestStackOverflow(self, user, argc, args)

end

function AdminCommandLogic.crashTestTimerFlood(self, user, argc, args)

end

function AdminCommandLogic.createItem(self, user, argc, args)

end

function AdminCommandLogic.createPet(self, user, argc, args)

end

function AdminCommandLogic.crossbowExpertPadTest(self, user, argc, args)

end

function AdminCommandLogic.cubeVerify(self, user, argc, args)

end

function AdminCommandLogic.currentmap(self, user)

end

function AdminCommandLogic.debuffTest(self, user, argc, args)

end

function AdminCommandLogic.doSave(self, user)

end

function AdminCommandLogic.dropItem(self, user, argc, args)

end

function AdminCommandLogic.dropItemServer(self, user, ItemId, Count)

end

function AdminCommandLogic.energyDispelTest(self, user, argc, args)

end

function AdminCommandLogic.executeLieDetector(self, user, argc, args)

end

function AdminCommandLogic.finalizeJobTestSetup(self, user)

end

function AdminCommandLogic.findCubeVerifyEquipItem(self, partKey, requestedReqLevel)

end

function AdminCommandLogic.findJobTestBestEquipItem(self, itemPrefix, jobGroup, targetLevel)

end

function AdminCommandLogic.findTimedRidingSkillCommandTarget(self, user, query)

end

function AdminCommandLogic.findUserByName(self, targetName)

end

function AdminCommandLogic.findUserByPlayerTag(self, playerTag)

end

function AdminCommandLogic.finishCubeVerifyPart(self, sessionId)

end

function AdminCommandLogic.fontChange(self, user, argc, args)
  if not ___MOD.isvalid(user) then
    return
  end
  self:fontChangeClient(user, not ___MOD._FontLogic.UseMSWFont, user.PlayerComponent.UserId)
  ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Yellow, "폰트 모드가 변경되었습니다.", user.PlayerComponent.UserId)
end

function AdminCommandLogic.fontChangeClient(self, user, useMSW)
  if ___MOD._UserService.LocalPlayer ~= user then
    return
  end
  ___MOD._FontLogic.UseMSWFont = useMSW
  self:rerenderAllBitmapFontsClient(useMSW)
end

function AdminCommandLogic.forceDetectMacro(self, user, argc, args)

end

function AdminCommandLogic.forceExecuteLieDetector(self, user, argc, args)

end

function AdminCommandLogic.formatCubeVerifyRate(self, rate)

end

function AdminCommandLogic.formatDetectMacroDuration(self, seconds)

end

function AdminCommandLogic.formatFieldLog(self, fieldLog)

end

function AdminCommandLogic.fwdebug(self, user, argc, args)

end

function AdminCommandLogic.getCubeVerifyGradeLabelByValue(self, grade)

end

function AdminCommandLogic.getCubeVerifyParts(self)

end

function AdminCommandLogic.getCubeVerifyPotentialText(self, cubeItemId, optionId, reqLevel)

end

function AdminCommandLogic.getDetectMacroLastPassText(self, target)

end

function AdminCommandLogic.getJobTestEquipJobGroup(self, jobId)

end

function AdminCommandLogic.getJobTestGrantedItemStore(self)

end

function AdminCommandLogic.getJobTestInventoryItemCount(self, user, itemID)

end

function AdminCommandLogic.getJobTestWeaponPrefixes(self, jobId)

end

function AdminCommandLogic.getMacroProbability(self, user, argc, args)

end

function AdminCommandLogic.getProjectileSkillTestSpecs(self)
  local book = ___MOD._SkillBook
  return {
    {
      book.Fire_Arrow_210_2101004,
      "passThrough, nearRelease"
    },
    {
      book.Fire_Arrow_1210_12101002,
      "passThrough, nearRelease"
    },
    {
      book.Holy_Arrow_230_2301005,
      "nearRelease"
    },
    {
      book.Angel_Ray_232_2321007,
      "nearRelease"
    },
    {
      book.Paralyze_212_2121006,
      "nearRelease"
    },
    {
      book.Element_Composition_211_2111006,
      "nearRelease"
    },
    {
      book.Element_Composition_221_2211006,
      "nearRelease"
    },
    {
      book.Iron_Arrow__Crossbow_320_3201005,
      "passThrough"
    },
    {
      book.Avenger_411_4111005,
      "passThrough"
    },
    {
      book.Battleship_Torpedo_522_5221008,
      "passThrough"
    },
    {
      book.Avenger_1411_14111002,
      "passThrough"
    },
    {
      book.Piercing_Arrow_322_3221001,
      "passThrough"
    },
    {
      book.Cold_Beam_220_2201004,
      "passThrough"
    },
    {
      book.Invisible_Shot_520_5201001,
      "passThrough"
    },
    {
      book.Fire_Demon_212_2121003,
      "passThrough"
    },
    {
      book.Ice_Demon_222_2221003,
      "passThrough"
    },
    {
      book.Dragons_Breath_312_3121003,
      "passThrough"
    },
    {
      book.Dragons_Breath_322_3221003,
      "passThrough"
    },
    {
      book.Taunt_412_4121003,
      "passThrough"
    },
    {
      book.Taunt_422_4221003,
      "passThrough"
    },
    {
      book.Soul_Blade_1110_11101004,
      "passThrough"
    },
    {
      book.Fire_Strike_1211_12111006,
      "passThrough"
    },
    {
      book.Wind_Piercing_1311_13111006,
      "passThrough"
    },
    {
      book.Shark_Wave_1511_15111007,
      "passThrough"
    }
  }
end

function AdminCommandLogic.getQuestData(self, user, argc, args)

end

function AdminCommandLogic.giveJobBasicItemsForJobTestSetup(self, user, items)

end

function AdminCommandLogic.giveTimedRidingSkillByUnit(self, user, argc, args, unit)

end

function AdminCommandLogic.giveTimedRidingSkillDays(self, user, argc, args)

end

function AdminCommandLogic.giveTimedRidingSkillHours(self, user, argc, args)

end

function AdminCommandLogic.giveTimedRidingSkillMinutes(self, user, argc, args)

end

function AdminCommandLogic.giveTimedRidingSkillSeconds(self, user, argc, args)

end

function AdminCommandLogic.grantJobTestItemForJobTestSetup(self, user, itemID, count)

end

function AdminCommandLogic.hideChatBalloonsForFontRerenderClient(self)
  local visited = {}

  local function pushEntity(stack, ent)
    if ___MOD.isvalid(ent) and visited[ent.Id] ~= true then
      stack[#stack + 1] = ent
    end
  end

  local function hideBalloonEntity(ent)
    if not ___MOD.isvalid(ent) or visited[ent.Id] == true then
      return
    end
    visited[ent.Id] = true
    if ___MOD.isvalid(ent.ExtendedChatballoonComponent) or ___MOD.tostring(ent.Name or "") == "ChatBalloon" then
      ent:SetVisible(false)
    end
  end

  local function scan(root)
    if not ___MOD.isvalid(root) then
      return
    end
    local stack = {root}
    while 0 < #stack do
      local ent = ___MOD.table.remove(stack)
      if ___MOD.isvalid(ent) and visited[ent.Id] ~= true then
        hideBalloonEntity(ent)
        local children = ent.Children
        if children ~= nil then
          for _, child in ___MOD.pairs(children) do
            if ___MOD.isvalid(child) then
              stack[#stack + 1] = child
            end
          end
        end
      end
    end
  end

  local function hideFromChatComponent(target)
    if not ___MOD.isvalid(target) or not ___MOD.isvalid(target.PlayerChatComponent) then
      return
    end
    local balloon = target.PlayerChatComponent.balloon
    if ___MOD.isvalid(balloon) then
      balloon:SetVisible(false)
    end
  end

  hideFromChatComponent(___MOD._UserService.LocalPlayer)
  scan(___MOD._UserService.LocalPlayer)
  for _, user in ___MOD.pairs(___MOD._UserService.UserEntities or {}) do
    hideFromChatComponent(user)
    scan(user)
  end
  if ___MOD.isvalid(___MOD._UserService.LocalPlayer) and ___MOD.isvalid(___MOD._UserService.LocalPlayer.PlayerVariables) then
    scan(___MOD._UserService.LocalPlayer.PlayerVariables.head)
  end
  local currentMapName = ___MOD.isvalid(___MOD._UserService.LocalPlayer) and ___MOD.tostring(___MOD._UserService.LocalPlayer.CurrentMapName or "") or ""
  if currentMapName ~= "" then
    local mapRoot = ___MOD._EntityService:GetEntityByPath("/maps/" .. currentMapName)
    scan(mapRoot)
  end
end

function AdminCommandLogic.instanceStatus(self, user, argc, args)

end

function AdminCommandLogic.inviteParty(self, user, argc, args)

end

function AdminCommandLogic.isCubeVerifyItemMatchPart(self, itemId, partKey)

end

function AdminCommandLogic.isCubeVerifyPartAlias(self, partKey, value)

end

function AdminCommandLogic.isJobTestEquipReqJobAllowed(self, reqJob, jobGroup)

end

function AdminCommandLogic.isJobTestProjectileItemForJob(self, itemId, jobId)

end

function AdminCommandLogic.item(self, user, argc, args)

end

function AdminCommandLogic.kickUser(self, user, argc, args)

end

function AdminCommandLogic.killAll(self, user)

end

function AdminCommandLogic.killAllDrop(self, user)

end

function AdminCommandLogic.levelToForJobTestSetup(self, player, targetLevel)

end

function AdminCommandLogic.levelUp(self, user)

end

function AdminCommandLogic.logCubeVerifyRecord(self, payload)

end

function AdminCommandLogic.maplePoint(self, user, argc, args)

end

function AdminCommandLogic.masterAllSkills(self, user, argc, args)

end

function AdminCommandLogic.masterJobSkillsForJobTestSetup(self, user, jobId)

end

function AdminCommandLogic.megaphone(self, user, argc, args)

end

function AdminCommandLogic.mindControl(self, user, argc, args)

end

function AdminCommandLogic.miracleCube(self, user)

end

function AdminCommandLogic.mobBuffDebuff(self, user, argc, args)

end

function AdminCommandLogic.mobSkillSpawnTest(self, user, argc, args)

end

function AdminCommandLogic.OnBeginPlay(self)

end

function AdminCommandLogic.parseCubeVerifyCube(self, cubeArg)

end

function AdminCommandLogic.parseCubeVerifyGrade(self, gradeArg)

end

function AdminCommandLogic.pinkbean(self, user, argc, args)

end

function AdminCommandLogic.popup(self, user, argc, args)

end

function AdminCommandLogic.position(self, user)

end

function AdminCommandLogic.positioncheck(self, user, argc, args)

end

function AdminCommandLogic.prepareShaolinQuest62007TestData(self, user, argc, args)

end

function AdminCommandLogic.prepareShaolinQuest62011TestData(self, user, argc, args)

end

function AdminCommandLogic.projectileSkillTestSet(self, user, argc, args)

end

function AdminCommandLogic.randomBiasTest(self, user, argc, args)

end

function AdminCommandLogic.reconnectPlayerForChannelTransferReproduction(self, userId, playerId, retryCount)

end

function AdminCommandLogic.recordUserAllInstance(self, user, argc, args)

end

function AdminCommandLogic.recordUserHistory(self, user, argc, args)

end

function AdminCommandLogic.removeJobTestGrantedConsumables(self, user, consumables)

end

function AdminCommandLogic.removeJobTestGrantedConsumableSlots(self, user, consumableSlots)

end

function AdminCommandLogic.removeJobTestGrantedEquippedItems(self, user, equipUlids)

end

function AdminCommandLogic.removeJobTestGrantedEquips(self, user, equipUlids)

end

function AdminCommandLogic.removeJobTestGrantedInventoryEquips(self, user, equipUlids)

end

function AdminCommandLogic.reproduceChannelTransfer(self, user, argc, args)

end

function AdminCommandLogic.reproduceExpeditionWorldTransfer(self, user, argc, args)

end

function AdminCommandLogic.rerenderAllBitmapFontsClient(self, useMSW)
  self:hideChatBalloonsForFontRerenderClient()
  local roots = {}
  local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  if ___MOD.isvalid(uiGroup) then
    roots[#roots + 1] = uiGroup
  end
  local tempGroup = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
  if ___MOD.isvalid(tempGroup) then
    roots[#roots + 1] = tempGroup
  end
  local loginFrame = ___MOD._EntityService:GetEntityByPath("/ui/LoginFrame")
  if ___MOD.isvalid(loginFrame) then
    roots[#roots + 1] = loginFrame
  end
  local visited = {}
  local stack = {}
  for _, root in ___MOD.ipairs(roots) do
    if ___MOD.isvalid(root) and visited[root.Id] ~= true then
      visited[root.Id] = true
      stack[#stack + 1] = root
    end
  end
  while 0 < #stack do
    local ent = ___MOD.table.remove(stack)
    if ___MOD.isvalid(ent) then
      if ___MOD.isvalid(ent.BitmapFontRendererComponent) then
        local ev = ___MOD.BitmapFontRefreshEvent()
        ev.useMSW = useMSW
        ent:SendEvent(ev)
      end
      local children = ent.Children
      if children ~= nil then
        for _, child in ___MOD.pairs(children) do
          if ___MOD.isvalid(child) and visited[child.Id] ~= true then
            visited[child.Id] = true
            stack[#stack + 1] = child
          end
        end
      end
    end
  end
end

function AdminCommandLogic.resetAllSkillCooldowns(self, user, argc, args)

end

function AdminCommandLogic.resetAllSkillCooldownsClient(self, user)
  if ___MOD._UserService.LocalPlayer ~= user then
    return
  end
  if user.PlayerVariables ~= nil then
    user.PlayerVariables.skillCooltimes = {}
    user.PlayerVariables.canUseSkills = {}
  end
end

function AdminCommandLogic.resetAranPassClaimState(self, user, argc, args)

end

function AdminCommandLogic.resetBaseCharacterForJobTestSetup(self, user)

end

function AdminCommandLogic.resetBlizzardMasteryBookTest(self, user, argc, args)

end

function AdminCommandLogic.resetFieldSet(self, user, argc, args)

end

function AdminCommandLogic.resetGuildSkillInvestCounts(self, user, argc, args)

end

function AdminCommandLogic.resetMap(self, user, argc, args)

end

function AdminCommandLogic.resetShaolinChiefPriestWeeklyEntryTestData(self, user, argc, args)

end

function AdminCommandLogic.resetShaolinMartialMonkEntryTestData(self, user, argc, args)

end

function AdminCommandLogic.resetShaolinQuestTestData(self, user, argc, args)

end

function AdminCommandLogic.resolveCubeVerifyParts(self, partArg)

end

function AdminCommandLogic.resolveJobTestSetup(self, jobName)

end

function AdminCommandLogic.resolveSkillMaxLevel(self, skill)
  if ___MOD.type(skill) ~= "table" then
    return 0
  end
  local maxLevel = ___MOD.tonumber(skill.masterLevel) or 0
  if maxLevel <= 0 then
    maxLevel = ___MOD.tonumber(skill.fixedMasterLevel) or 0
  end
  if maxLevel <= 0 and ___MOD.type(skill.level) == "table" then
    for level, _ in ___MOD.pairs(skill.level) do
      local parsedLevel = ___MOD.tonumber(level) or 0
      if maxLevel < parsedLevel then
        maxLevel = parsedLevel
      end
    end
  end
  return ___MOD.math.max(0, maxLevel)
end

function AdminCommandLogic.runCubeVerifyForPart(self, sessionId)

end

function AdminCommandLogic.runCubeVerifyPartBatch(self, sessionId)

end

function AdminCommandLogic.scrollNotice(self, user, argc, args)

end

function AdminCommandLogic.search(self, user, argc, args)

end

function AdminCommandLogic.sendPeriodTestCountdown(self, userId, itemID, seconds, label)

end

function AdminCommandLogic.setAbility(self, user, argc, args)

end

function AdminCommandLogic.setAranCombo(self, user, argc, args)

end

function AdminCommandLogic.setDebugMode(self, user, argc, args)

end

function AdminCommandLogic.setDiseaseImmune(self, user, argc, args)

end

function AdminCommandLogic.setDojoGauge(self, user, argc, args)

end

function AdminCommandLogic.setEnableCollisionGizmo(self, user, enable)
  if ___MOD.isvalid(user.CollisionGizmoComponent) then
    local parent = user:GetChildByName("gizmoParent")
    if ___MOD.isvalid(parent) then
      parent.Enable = enable
    end
  end
  local mobs = ___MOD._EntityService:GetEntitiesByTag("CustomMonster")
  if ___MOD.isvalid(mobs) then
    for k, v in ___MOD.pairs(mobs) do
      if v.CurrentMapName == user.CurrentMapName then
        local mob = v
        local p = mob:GetChildByName("gizmoParent")
        if ___MOD.isvalid(p) then
          p.Enable = enable
        end
      end
    end
  end
end

function AdminCommandLogic.setEnableMobAttackHitbox(self, user, enable)

end

function AdminCommandLogic.setEnableMobHitbox(self, user, enable)

end

function AdminCommandLogic.setFixedDamageCheat(self, user, argc, args)

end

function AdminCommandLogic.setFixedDamageCheatClient(self, fixedDamage)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or user.CalcDamageComponent == nil then
    return
  end
  user.CalcDamageComponent.adminFixedDamage = fixedDamage
end

function AdminCommandLogic.setGodMode(self, user, argc, args)

end

function AdminCommandLogic.setGodModeClient(self, untilTime, enabled)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or user.PlayerHitComponent == nil then
    return
  end
  user.PlayerHitComponent.hitTime = untilTime
  user.PlayerHitComponent.adminGodMode = enabled
end

function AdminCommandLogic.setKeyValue(self, user, argc, args)

end

function AdminCommandLogic.setMacroProbability(self, user, argc, args)

end

function AdminCommandLogic.setMeso(self, user, argc, args)

end

function AdminCommandLogic.setMobCount(self, user, argc, args)

end

function AdminCommandLogic.setMSWCody(self, user)

end

function AdminCommandLogic.setPlayerAbility(self, user, argc, args)

end

function AdminCommandLogic.setPlayerKeyValue(self, user, argc, args)

end

function AdminCommandLogic.setQuestEx(self, user, argc, args)

end

function AdminCommandLogic.setQuestExUser(self, user, argc, args)

end

function AdminCommandLogic.showCubeVerifyUsage(self, user, detail)

end

function AdminCommandLogic.showEffect(self, user, argc, args)

end

function AdminCommandLogic.showEffectToClient(self, user, path)
  local anim = ___MOD._EffectManager:getEffect(path)
  if anim == nil then
    return
  end
  local e = ___MOD._SpawnService:SpawnByModelId("model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", "effect", ___MOD.FastVector3.zero:Clone(), user)
  e.TransformComponent.Scale = ___MOD.FastVector3(0.5, 0.5, 1)
  e.AnimationSpriteComponent:setWzSprite(anim, false)
  e.AnimationSpriteComponent.loop = false
  e.AnimationSpriteComponent.disappearWhenAnimationOnceEnd = true
end

function AdminCommandLogic.showFieldLogs(self, user, argc, args)

end

function AdminCommandLogic.showGUIEffect(self, user, argc, args)

end

function AdminCommandLogic.showMapMetrics(self, user, argc, args)

end

function AdminCommandLogic.showMessage(self, user, argc, args)

end

function AdminCommandLogic.showResolutionText(self, user, argc, args)

end

function AdminCommandLogic.showTimedRidingSkillUsage(self, user, commandName)

end

function AdminCommandLogic.spawnAbyssMob(self, user, argc, args)

end

function AdminCommandLogic.spawnArrowDamageTestMob(self, user, argc, args)

end

function AdminCommandLogic.spawnCubeUI(self)
  local modelId = ___MOD._EntryService:GetModelIdByName("Model_MiracleCube")
  local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  ___MOD._SpawnService:SpawnByModelId(modelId, "miracleCube", ___MOD.FastVector3.zero:Clone(), uiGroup)
end

function AdminCommandLogic.spawnDummy(self, user, argc, args)

end

function AdminCommandLogic.spawnMob(self, user, argc, args)

end

function AdminCommandLogic.spawnMobClient(self, newMob)
  local mobAni = newMob.MobAnimationComponent
  if ___MOD.isvalid(mobAni) then
    local msc = newMob.AnimationSpriteComponent
    msc.transparentWhenAnimationOnceEnd = false
    if msc.firstSet then
      msc.noApplyAlpha = true
    end
    msc:setSpriteEntitiesTransparent(true)
    local tween = ___MOD._TweenLogic:MakeTween(0, 1, 1.3, ___MOD.EaseType.Linear, function(value)
      newMob.AnimationSpriteComponent:setSpriteEntitiesAlpha(value)
    end)
    tween.AutoDestroy = true
    tween:Play()
    tween:SetOnEndCallback(function()
      mobAni.isDead = false
      msc:endFirstSet()
    end)
    newMob.Enable = true
    newMob.Visible = true
  end
end

function AdminCommandLogic.spawnNPC(self, user, argc, args)

end

function AdminCommandLogic.spawnReactor(self, user, argc, args)

end

function AdminCommandLogic.statTest(self, user, argc, args)

end

function AdminCommandLogic.stunTest(self, user, argc, args)

end

function AdminCommandLogic.summonTest(self, user, argc, args)

end

function AdminCommandLogic.teachSkillTestSet(self, user, specs, requestedLevel)
  local sc = user.SkillComponent
  if not ___MOD.isvalid(sc) then
    return 0
  end
  local appliedCount = 0
  for _, spec in ___MOD.ipairs(specs) do
    local skillID = ___MOD.tonumber(spec[1]) or 0
    local skill = ___MOD._SkillManager:getSkill(skillID)
    if skill ~= nil then
      local maxLevel = self:resolveSkillMaxLevel(skill)
      if not (maxLevel <= 0) then
        local skillLevel = requestedLevel
        if skillLevel <= 0 or maxLevel < skillLevel then
          skillLevel = maxLevel
        end
        if sc:teachSkill(skillID, skillLevel, maxLevel, true) then
          appliedCount = appliedCount + 1
        end
      end
    end
  end
  sc:refreshSkillStateToClient(true, user.PlayerComponent.UserId)
  return appliedCount
end

function AdminCommandLogic.test1(self, user, argc, args)

end

function AdminCommandLogic.test2(self)

end

function AdminCommandLogic.test3(self, user, argc, args)

end

function AdminCommandLogic.test3Client(self, user)
  local sortingLayer = user.AvatarRendererComponent.SortingLayer
  local orderInLayer = user.AvatarRendererComponent.OrderInLayer
  local pos = user.TransformComponent:PositionAsFastVector3()
  local map = user.CurrentMap
  local isMe = user == ___MOD._UserService.LocalPlayer
  if isMe then
    user.PlayerControllerComponent.Enable = false
    user.ExtendPlayerControllerComponent.FixedLookAt = user.ExtendPlayerControllerComponent.LookDirectionX
    user.StateComponent:ChangeState("DEAD")
  end
  local path = "Game.img.Tombstone"
  local ruid = ___MOD.__RUIDManager:get(path)
  ___MOD._SoundService:PlaySoundAtPos(ruid, user.TransformComponent:WorldPositionAsFastVector3(), ___MOD._UserService.LocalPlayer, 1)
  local anim = ___MOD._EffectManager:getEffect("Tomb.img/fall")
  local startPos = pos:Clone()
  startPos.y = startPos.y + 7
  local fallTomb = ___MOD._ExtendedEffectService:playAnimationOnMap(user.CurrentMap, anim, startPos, nil, nil, nil, true, false, sortingLayer, orderInLayer - 1)
  local tween = ___MOD._TweenLogic:MakeTween(startPos, pos, 0.88, ___MOD.EaseType.Linear, function(value)
    fallTomb.TransformComponent.Position.y = value.y
  end)
  tween.AutoDestroy = true
  tween:Play()
  ___MOD._TimerService:SetTimerOnce(function()
    local anim2 = ___MOD._EffectManager:getEffect("Tomb.img/land")
    local tombLand = ___MOD._ExtendedEffectService:playAnimationOnMap(map, anim2, pos, nil, nil, nil, true, true, sortingLayer, orderInLayer - 1)
    map.MapObjectPool.tombList[user.Player.PlayerId] = tombLand
  end, 1.93)
end

function AdminCommandLogic.test4(self, user, argc, args)

end

function AdminCommandLogic.test4_client(self, user)

end

function AdminCommandLogic.test5(self, user, argc, args)

end

function AdminCommandLogic.test5_client(self, user, angle)
  function ___MOD.spawnChainLineTo(startPos, targetPos, step, countPerBatch, batchDelay, angleOverride)
    local skill = ___MOD._SkillManager:getSkill(___MOD._SkillBook.Chain_Lightning_222_2221006)

    local ball = skill.ball
    local pool = ___MOD._UserService.LocalPlayer.PlayerVariables.ballBulletPool
    step = step or 0.5
    countPerBatch = countPerBatch or 3
    batchDelay = batchDelay or 0.1
    local vx = targetPos.x - startPos.x
    local vy = targetPos.y - startPos.y
    local dist = ___MOD.math.sqrt(vx * vx + vy * vy)
    if dist <= 1.0E-4 then
      dist = 0
    end
    local totalCount = ___MOD.math.max(1, ___MOD.math.ceil(dist / step))
    local ux, uy = 0, 0
    if 0 < dist then
      ux = vx / dist
      uy = vy / dist
    end
    local dx = ux * step
    local dy = uy * step
    local angleDeg = angleOverride
    if angleDeg == nil then
      angleDeg = ___MOD.math.deg(___MOD.math.atan(uy, ux))
    end
    for idx = 0, totalCount - 1 do
      local x = startPos.x + dx * idx
      local y = startPos.y + dy * idx
      local b1 = ball[___MOD.tostring(idx % 3)]
      local bulletObj = ___MOD._ObjectPool:pick(pool, "bullet", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", ___MOD.FastVector3(x, y, 0), ___MOD._UserService.LocalPlayer.CurrentMap, false)
      bulletObj.TransformComponent.ZRotation = angleDeg
      local asp = bulletObj.AnimationSpriteComponent
      asp:setWzSprite(b1, false)
      asp.releasePool = pool
      asp.loop = false
      bulletObj.Enable = true
      bulletObj.Visible = true
    end
  end

  local function getMobTopWorldPos(mob)
    local p = mob.TransformComponent:WorldPositionAsFastVector3():Clone()
    p.y = p.y + mob.MobComponent.spriteSize.y * 0.5
    return p
  end

  local function dist2(pos, mob)
    local p = mob.TransformComponent:WorldPositionAsFastVector3()
    local dx = p.x - pos.x
    local dy = p.y - pos.y
    return dx * dx + dy * dy
  end

  local function chainRecursive(curPos, prevPos, prevMob, hitSet, remainCount, step, mapleRange, shootRange, range, delay, isFaceLeft)
    if remainCount <= 0 then
      return
    end
    local boxShape = ___MOD._PlayerAttackLogic_Shoot:makeBoxShapeFromLtRb(curPos:ToVector2(), ___MOD.FastVector2(-mapleRange, 1), ___MOD.FastVector2.zero:Clone(), isFaceLeft)
    local mobs = {}
    local hitMobCount = ___MOD._PlayerAttackLogic_Shoot:findHitMobInTrapezoid(curPos.x, shootRange, range, curPos.y, 4, mobs, isFaceLeft, boxShape, prevMob, true, nil)
    if hitMobCount <= 0 then
      return
    end
    ___MOD.table.sort(mobs, function(a, b)
      return dist2(curPos, a) < dist2(curPos, b)
    end)
    local nextMob
    for _, m in ___MOD.ipairs(mobs) do
      if ___MOD.isvalid(m) and not hitSet[m] then
        nextMob = m
        break
      end
    end
    if nextMob == nil then
      return
    end
    local nextPos = getMobTopWorldPos(nextMob)
    ___MOD.spawnChainLineTo(curPos, nextPos, step, nil, nil, nil)
    hitSet[nextMob] = true
    ___MOD._TimerService:SetTimerOnce(function()
      chainRecursive(nextPos, curPos, nextMob, hitSet, remainCount - 1, step, mapleRange, 0, range, delay, isFaceLeft)
    end, delay)
  end

  local isFaceLeft = ___MOD._UserService.LocalPlayer.PlayerControllerComponent.LookDirectionX == -1
  local shootRange = 0.3
  local mapleRange = 300
  local range = mapleRange / 100
  local step = 0.5
  local delay = 0.1
  local maxCount = 10
  local sp = ___MOD._UserService.LocalPlayer.TransformComponent:WorldPositionAsFastVector3():Clone()
  sp.y = sp.y + 0.28
  if isFaceLeft then
    sp.x = sp.x - shootRange
  else
    sp.x = sp.x + shootRange
  end
  local boxShape = ___MOD._PlayerAttackLogic_Shoot:makeBoxShapeFromLtRb(sp:ToVector2(), ___MOD.FastVector2(-mapleRange, 1), ___MOD.FastVector2.zero:Clone(), isFaceLeft)
  local mobs = {}
  local hitMobCount = ___MOD._PlayerAttackLogic_Shoot:findHitMobInTrapezoid(sp.x, shootRange, range, sp.y, 4, mobs, isFaceLeft, boxShape, ___MOD._UserService.LocalPlayer, nil)
  if 0 < hitMobCount then
    ___MOD.table.sort(mobs, function(a, b)
      return dist2(sp, a) < dist2(sp, b)
    end)
    local firstMob = mobs[1]
    if ___MOD.isvalid(firstMob) then
      do
        local firstPos = getMobTopWorldPos(firstMob)
        ___MOD.spawnChainLineTo(sp, firstPos, step, nil, nil, nil)
        local hitSet = {}
        hitSet[firstMob] = true
        ___MOD._TimerService:SetTimerOnce(function()
          chainRecursive(firstPos, sp, firstMob, hitSet, maxCount - 1, step, mapleRange, shootRange, range, delay, isFaceLeft)
        end, delay)
      end
    end
  end
end

function AdminCommandLogic.testFadeYesNo(self, user, argc, args)

end

function AdminCommandLogic.testFadeYesNoClient(self, message)
  local text = ___MOD.tostring(message or "")
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    text = "FadeYesNo mobile position test."
  end
  ___MOD._FadeYesNo:createFadeYesNo(1, 10, false, text, 5, nil, ___MOD._BitmapFontAlignmentType.Left, nil, "admin_test_message")
end

function AdminCommandLogic.testFieldSet(self, user, argc, args)

end

function AdminCommandLogic.testMobDrop(self, user, argc, args)

end

function AdminCommandLogic.testPeriodLockerPointCoupon(self, user, argc, args)

end

function AdminCommandLogic.testPeriodPet(self, user, argc, args)

end

function AdminCommandLogic.testPeriodTradeCashItem(self, user, argc, args)

end

function AdminCommandLogic.testPeriodTradePetItem(self, user, argc, args)

end

function AdminCommandLogic.testscript(self, user, argc, args)

end

function AdminCommandLogic.testSkillEntryNil(self, user, argc, args)

end

function AdminCommandLogic.timer(self, sec)
  ___MOD._UserService.LocalPlayer.PlayerClockUIComponent:setClock(sec)
end

function AdminCommandLogic.timerOverlapTest(self, user, argc, args)

end

function AdminCommandLogic.timerTest(self, user, argc, args)

end

function AdminCommandLogic.toggleAdminHide(self, user, argc, args)

end

function AdminCommandLogic.toggleBGM(self, user, argc, args)

end

function AdminCommandLogic.toggleMacroQuestionUI(self, user, argc, args)

end

function AdminCommandLogic.toggleMacroQuestionUIToClient(self, enable)
  local question = self._T.macroQuestion
  if question == nil then
    question = ___MOD._SpawnService:SpawnByModelId(___MOD._EntryService:GetModelIdByName("Model_MacroQuestion"), "macroQuestion", ___MOD.Vector3(0, 0, 0), ___MOD._EntityService:GetEntityByPath("/ui/TempGroup"))
    self._T.macroQuestion = question
  end
  if question.MacroQuestionComponent == nil then
    question:AddComponent(___MOD.MacroQuestionComponent)
  end
  question:SetEnable(enable)
end

function AdminCommandLogic.toggleMobAttackHitbox(self, user, argc, args)

end

function AdminCommandLogic.toggleMobHitbox(self, user, argc, args)
  if ___MOD.isvalid(user) then
    user.PlayerVariables.mobHitboxMode = not user.PlayerVariables.mobHitboxMode
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, ___MOD.string.format("몹 히트박스 표시가 %s되었습니다.", user.PlayerVariables.mobHitboxMode and "설정" or "해제"), user.PlayerComponent.UserId)
    self:setEnableMobHitbox(user, user.PlayerVariables.mobHitboxMode)
  end
end

function AdminCommandLogic.toggleObserveUI(self, user, argc, args)

end

function AdminCommandLogic.toggleObserveUIToClient(self, enable)
  local observe = self._T.observe
  if observe == nil then
    observe = ___MOD._SpawnService:SpawnByModelId(___MOD._EntryService:GetModelIdByName("Model_ObserverUtils"), "observe", ___MOD.Vector3(0, 0, 0), ___MOD._EntityService:GetEntityByPath("/ui/TempGroup"))
    self._T.observe = observe
  end
  observe:SetEnable(enable)
  ___MOD._ObserverUtilLogic:SetObserverPanelOpen(enable)
end

function AdminCommandLogic.toggleresolutionText(self, user)
  if ___MOD._UserService.LocalPlayer ~= user then
    return
  end
  local e = ___MOD._EntityService:GetEntity("7bf8f39d-4d00-4d0c-9b7d-bf2dfac5bc85")
  e.Visible = not e.Visible
end

function AdminCommandLogic.toggleUserAttackLog(self, user, argc, args)

end

function AdminCommandLogic.toggleUserAttackLogStop(self, user, argc, args)

end

function AdminCommandLogic.toggleWorldServiceProfile(self, user, argc, args)

end

function AdminCommandLogic.tpChannel(self, user, argc, args)

end

function AdminCommandLogic.tpTest(self, user, argc, args)

end

function AdminCommandLogic.tpToAdmin(self, user, argc, args)

end

function AdminCommandLogic.tpToUser(self, user, argc, args)

end

function AdminCommandLogic.tryCommand(self, msg, userId)

end

function AdminCommandLogic.trySave(self, user)

end

function AdminCommandLogic.uiposition(self, user)

end

function AdminCommandLogic.uipositionClient(self)
  local e = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup/EmptyEntity")
  local msg = ___MOD.string.format("Postion : %.2f,%.2f Scale : %.2f,%.2f", e.UITransformComponent.Position.x, e.UITransformComponent.Position.y, e.UITransformComponent.UIScale.x, e.UITransformComponent.UIScale.y)
  ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Blue, msg)
  ___MOD.UIWindow():createUIWindow("All", ___MOD.FastVector2(300, 200), ___MOD.FastVector2(0, 0), {
    nw = {
      rectSize = ___MOD.FastVector2(10, 14),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.nw")
    },
    n = {
      rectSize = ___MOD.FastVector2(2, 14),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.n")
    },
    ne = {
      rectSize = ___MOD.FastVector2(288, 14),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.ne")
    },
    w = {
      rectSize = ___MOD.FastVector2(10, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.w")
    },
    c = {
      rectSize = ___MOD.FastVector2(2, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.c")
    },
    e = {
      rectSize = ___MOD.FastVector2(288, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.e")
    },
    sw = {
      rectSize = ___MOD.FastVector2(10, 14),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.sw")
    },
    s = {
      rectSize = ___MOD.FastVector2(2, 14),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.s")
    },
    se = {
      rectSize = ___MOD.FastVector2(288, 14),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = ___MOD.__RUIDManager:get("UI.UIWindow.UserList.Party.PartyHP.se")
    }
  }, "miniMapMax", nil)
end

function AdminCommandLogic.updatePlayerQuestData(self, user, argc, args)

end

function AdminCommandLogic.updateQuestData(self, user, argc, args)

end

function AdminCommandLogic.warpMap(self, user, argc, args)

end

function AdminCommandLogic.whileTest1(self, user, argc, args)

end

function AdminCommandLogic.whileTest2(self, user, argc, args)

end

function AdminCommandLogic.worldInfo(self, user)
  for i, info in ___MOD.ipairs(___MOD._WorldConstants.worldInstancesInfo) do
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, ___MOD.string.format("index : %d / instanceId : %s / currentUsers : %d / maxUsers : %d", i, info.id, info.current, info.max), user.PlayerComponent.UserId)
  end
end
