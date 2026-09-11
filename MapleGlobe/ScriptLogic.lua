

function ScriptLogic.animationDisplay(self, p, path)

end

function ScriptLogic.animationDisplayToClient(self, path)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) then
    return
  end
  local map = user.CurrentMap
  if not ___MOD.isvalid(map) then
    return
  end
  local direction = ___MOD._EffectManager:getDirection(path)
  if direction ~= nil then
    local function normalizeDirectionSoundPath(sound)
      if ___MOD._UtilLogic:IsNilorEmptyString(sound) then
        return ""
      end
      local soundPath = sound
      soundPath, ___MOD._ = soundPath:gsub("/", ".")
      soundPath, ___MOD._ = soundPath:gsub("^Sound%.", "")
      return soundPath
    end

    local function isDirectionBgm(soundPath)
      if ___MOD._UtilLogic:IsNilorEmptyString(soundPath) then
        return false
      end
      local lower = ___MOD.string.lower(soundPath)
      return ___MOD.string.find(lower, "^bgm", 1, false) ~= nil or ___MOD.string.find(lower, "%.bgm", 1, false) ~= nil or ___MOD.string.find(lower, "%.sound%.bgm$", 1, false) ~= nil or ___MOD.string.find(lower, "%.sound%.finalfight$", 1, false) ~= nil or ___MOD.string.find(lower, "%.sound%.crystalcave$", 1, false) ~= nil or ___MOD.string.find(lower, "%.sound%.fantasia$", 1, false) ~= nil
    end

    local function playDirectionSound(sound, forceBgm)
      local soundPath = normalizeDirectionSoundPath(sound)
      if ___MOD._UtilLogic:IsNilorEmptyString(soundPath) then
        return
      end
      local soundRUID = ___MOD.__RUIDManager:get(soundPath)
      if ___MOD._UtilLogic:IsNilorEmptyString(soundRUID) then
        return
      end
      if forceBgm or isDirectionBgm(soundPath) then
        ___MOD._SoundService:PlayBGM(soundRUID, 1)
      else
        ___MOD._SoundService:PlaySound(soundRUID, 1)
      end
    end

    local keys = {}
    for k, _ in ___MOD.pairs(direction) do
      if ___MOD.tonumber(k) then
        ___MOD.table.insert(keys, k)
      end
    end
    ___MOD.table.sort(keys, function(a, b)
      return ___MOD.tonumber(a) < ___MOD.tonumber(b)
    end)
    for _, k in ___MOD.ipairs(keys) do
      local v = direction[k]
      if v.type == ___MOD._EffectDirectionType.imageMove then
        local imageMove = v
        local visual = imageMove.visual
        visual, _ = visual:gsub("^Effect/", "")
        local anim = ___MOD._EffectManager:getEffect(visual .. "/0")
        local isDirectionCN = ___MOD.string.find(visual, "Direction_CN.img/", 1, true) ~= nil
        if isDirectionCN and (anim == nil or anim.anim == nil or anim.anim[1] == nil) then
          anim = ___MOD._EffectManager:getEffect(visual)
        end
        if not isDirectionCN or anim ~= nil and anim.anim ~= nil and anim.anim[1] ~= nil then
          local x = imageMove.x / 100
          local x1 = imageMove.x1 / 100
          local y = -(imageMove.y / 100)
          local y1 = -(imageMove.y1 / 100)
          local start = imageMove.start / 1000
          local duration = imageMove.duration / 1000
          local z = imageMove.z
          local sound = imageMove.sound
          ___MOD._TimerService:SetTimerOnce(function()
            if user.CurrentMapName == "LoadingMap" then
              return
            end
            local e = ___MOD._SpawnService:SpawnByModelId("model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", "direction", ___MOD.FastVector3(x, y, 0), map)
            e.TransformComponent.Scale = ___MOD.FastVector3(0.5, 0.5, 1)
            e.AnimationSpriteComponent:setWzSprite(anim, false)
            e.AnimationSpriteComponent:setOrderInLayer(z)
            e.AnimationSpriteComponent.loop = false
            e.AnimationSpriteComponent.disappearWhenAnimationOnceEnd = true
            if x ~= x1 or y ~= y1 then
              local tween = ___MOD._TweenLogic:MoveOffset(e, ___MOD.FastVector2(x1, y1), duration, ___MOD.EaseType.Linear)
              tween.AutoDestroy = true
              tween:Play()
            end
            if not ___MOD._UtilLogic:IsNilorEmptyString(sound) then
              playDirectionSound(sound, false)
            end
          end, start)
        end
      elseif v.type == ___MOD._EffectDirectionType.transferField then
        local transferField = v
        local field = transferField.field
        local start = transferField.start / 1000
        local z = transferField.z
        ___MOD._TimerService:SetTimerOnce(function()
          if user.CurrentMapName == "LoadingMap" then
            return
          end
          self:registerTransferField(user, field, nil)
          user:SetVisible(true)
          user.PlayerActionComponent.isClimbing = false
          user.MovementComponent.Enable = true
          user.ExtendPlayerControllerComponent.Enable = true
          user.PlayerActionComponent.Enable = true
          user.ExtendPlayerControllerComponent.FixedLookAt = 0
          if self._T.equip_set then
            ___MOD._TimerService:SetTimerOnce(function()
              local itemIdx = {
                5,
                18,
                9,
                12,
                8,
                13,
                14,
                21
              }
              for k, v in ___MOD.pairs(itemIdx) do
                if v == 21 then
                  do
                    local medal = user:GetChildByName("Medal")
                    if ___MOD.isvalid(medal) then
                      medal:Destroy()
                    end
                  end
                else
                  local ruid = self._T["equip_" .. v]
                  local t = ___MOD.MapleAvatarItemCategory.CastFrom(v)
                  user.CostumeManagerComponent:SetEquip(t, ruid)
                end
              end
            end, 1)
            self._T.equip_set = false
          end
        end, start)
      elseif v.type == ___MOD._EffectDirectionType.avatarSetting then
        local avatarSetting = v
        local costume = user.CostumeManagerComponent
        user:SetVisible(true)
        local d = {
          1,
          4,
          5,
          7,
          8,
          11,
          21
        }
        local itemIdx = {
          5,
          18,
          9,
          12,
          8,
          13,
          21
        }
        local itemIDs = avatarSetting.equipItems
        for k, v in ___MOD.ipairs(d) do
          local index = itemIdx[k]
          local itemID = ___MOD._WzUtils:getInteger(itemIDs[v], 0)
          if index == 21 then
            do
              if not ___MOD.isvalid(self._T.medal) then
                self._T.medal = ___MOD._SpawnService:SpawnByModelId(___MOD._EntryService:GetModelIdByName("Model_NameTag"), "Medal", ___MOD.FastVector3(0, -0.38, 0), user)
              end
              local avatar = user.AvatarRendererComponent
              local sortingLayer = avatar.SortingLayer
              local medal = ___MOD._EquipManager:getItemById(itemID)
              if medal == nil then
                return
              end
              if 0 > medal.medalTag then
                return
              end
              local medalName = ___MOD._StringPoolManager:getItemName(itemID)
              local title = ___MOD.string.match(medalName, "(.+)의 훈장$") or medalName
              local medalPath = ___MOD.string.format("NameTag.img/medal/%d", medal.medalTag)
              self._T.medal.ExtendedNameTagComponent:renderNameTag(medalPath, ___MOD._BitmapFontType.Gulim9pt, title, nil, sortingLayer, 4, true)
            end
          else
            local t = ___MOD.MapleAvatarItemCategory.CastFrom(index)
            self._T.equip_set = true
            self._T["equip_" .. index] = user.CostumeManagerComponent:GetEquip(t)
            if v == 11 then
              local weaponType = ___MOD._WeaponType:getWeaponTypeByItemID(itemID)
              if weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD or weaponType == ___MOD._WeaponType.TWO_HANDED_MACE or weaponType == ___MOD._WeaponType.TWO_HANDED_AXE or weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.CROSSBOW or weaponType == ___MOD._WeaponType.BOW or weaponType == ___MOD._WeaponType.KNUCKLE or weaponType == ___MOD._WeaponType.GUN or weaponType == ___MOD._WeaponType.CLAW then
                t = ___MOD.MapleAvatarItemCategory.CastFrom(14)
                self._T.equip_14 = user.CostumeManagerComponent:GetEquip(t)
              end
            end
            local ruid = ___MOD.__RUIDManager:get(___MOD.tostring(itemID))
            user.CostumeManagerComponent:SetEquip(t, ruid)
          end
        end
      elseif v.type == ___MOD._EffectDirectionType.avatarAction then
        local avatarAction = v
        local start = avatarAction.start / 1000
        local pa = user.PlayerActionComponent
        ___MOD._TimerService:SetTimerOnce(function()
          if user.CurrentMapName == "LoadingMap" then
            return
          end
          pa:clearState(user)
          pa:playOnceClient(avatarAction.action, 1.0, user, true, false)
        end, start)
      elseif v.type == ___MOD._EffectDirectionType.playSound then
        local playSound = v
        local sound = playSound.sound
        local start = playSound.start / 1000
        ___MOD._TimerService:SetTimerOnce(function()
          if user.CurrentMapName == "LoadingMap" then
            return
          end
          playDirectionSound(sound, false)
        end, start)
      elseif v.type == ___MOD._EffectDirectionType.targetEffect then
        local targetEffect = v
        local visual = targetEffect.visual
        local npcID = targetEffect.npcID
        local start = targetEffect.start / 1000
        ___MOD._TimerService:SetTimerOnce(function()
          if user.CurrentMapName == "LoadingMap" then
            return
          end
          if npcID == 0 then
            self:onCharacterEffect(visual)
            return
          end
          self:onNpcEffect(npcID, visual)
        end, start)
      end
    end
  end
end

function ScriptLogic.appendQuestRewardText(self, text, player, item, exp, pop, meso, skill, propList, itemTable)
  if not item and not exp and not pop and not meso and not skill then
    return text
  end
  text = text .. "\r\n\r\n"
  text = text .. "#fUI.UIWindow.QuestIcon.4.0#\r\n"
  if item then
    if propList ~= nil and 0 < #propList then
      text = text .. "#fUI.UIWindow.QuestIcon.5.0#\r\n"
    elseif itemTable ~= nil then
      for _, v in ___MOD.pairs(itemTable) do
        local itemID, itemQuantity = v[1], v[2]
        if 0 < itemQuantity then
          text = text .. ___MOD.string.format("#i%d# #z%d# %d개\r\n", itemID, itemID, itemQuantity)
        end
      end
    end
  end
  if skill ~= nil then
    for i = 0, 100 do
      local skillData = skill[___MOD.tostring(i)]
      if skillData ~= nil then
        local skillID = ___MOD.tonumber(skillData.id)
        if skillID ~= nil and 0 < skillID then
          local canShow = true
          if skillData.job ~= nil then
            canShow = false
            local playerJob = ___MOD.isvalid(player) and player.Player.Job or -1
            for j = 0, 100 do
              local job = ___MOD.tonumber(skillData.job[___MOD.tostring(j)])
              if job ~= nil and job == playerJob then
                canShow = true
                break
              end
            end
          end
          if canShow then
            text = text .. ___MOD.string.format("#s%d# #q%d#\r\n", skillID, skillID)
          end
        end
      end
    end
  end
  if exp then
    local questExpBonus = self:getQuestExpBonus(player, exp)
    text = text .. ___MOD.string.format("\r\n#fUI.UIWindow.QuestIcon.8.0#  %d exp (%d + %d)", exp + questExpBonus, exp, questExpBonus)
  end
  if pop then
    text = text .. ___MOD.string.format("\r\n#fUI.UIWindow.QuestIcon.6.0#  %d", pop)
  end
  if meso then
    text = text .. ___MOD.string.format("\r\n#fUI.UIWindow.QuestIcon.7.0#  %s 메소", ___MOD._MathUtils:format_thousands_for(meso))
  end
  return text
end

function ScriptLogic.cacheScriptFunc(self)

end

function ScriptLogic.cancelItem(self, player, itemId)

end

function ScriptLogic.canCheckData(self, checkData, stop, player, questID)

end

function ScriptLogic.canGainItems(self, player, rewards, defaultFlag)

end

function ScriptLogic.canGainItemWithFlag(self, player, itemID, itemCount, itemFlag)

end

function ScriptLogic.canGainRewardItems(self, player, rewards)

end

function ScriptLogic.canhold(self, player, itemID)

end

function ScriptLogic.changeJob(self, player, job)

end

function ScriptLogic.checkJobByAct(self, job, flag)
  local jobClass = job // 100
  if job == 9 then
    return true
  end
  if flag >> jobClass & 1 == 1 then
    return true
  end
  return false
end

function ScriptLogic.ClearSaveLocation(self, player, location)

end

function ScriptLogic.currentTime(self)

end

function ScriptLogic.dropMessage(self, player, type, text)

end

function ScriptLogic.effectSound(self, p, path)

end

function ScriptLogic.effectSoundStop(self, p, path)

end

function ScriptLogic.exchange(self, player, values, showMessage, exchangeFlag)

end

function ScriptLogic.gainExp(self, player, exp, showMessage)

end

function ScriptLogic.gainItem(self, player, itemID, itemCount)

end

function ScriptLogic.gainItemPeriod(self, player, itemID, days, hour, minute, second)

end

function ScriptLogic.gainItems(self, player, rewards, defaultFlag, showMessage)

end

function ScriptLogic.gainItemsWithFlag(self, player, rewards, defaultFlag, rewardAction, sourceId, showMessage)

end

function ScriptLogic.gainItemWithFlag(self, player, itemID, itemCount, itemFlag, showMessage)

end

function ScriptLogic.gainMeso(self, player, meso)

end

function ScriptLogic.gainpop(self, player, pop)

end

function ScriptLogic.gainRewardItems(self, player, rewards, rewardAction, sourceId, showMessage)

end

function ScriptLogic.getCharactersSize(self, mapID)

end

function ScriptLogic.getDefaultItemFlag(self, itemID)

end

function ScriptLogic.getDistance(self, player)

end

function ScriptLogic.getFieldID(self, player)

end

function ScriptLogic.getIntNoRecord(self, player, questID)

end

function ScriptLogic.getItemCount(self, player, itemID)

end

function ScriptLogic.getJob(self, player)

end

function ScriptLogic.getKeyvalue(self, player, key)

end

function ScriptLogic.getLevel(self, player)

end

function ScriptLogic.getMeso(self, player)

end

function ScriptLogic.getMobCount(self, player)

end

function ScriptLogic.getMobCountForMap(self, mapId)

end

function ScriptLogic.getMorphID(self, player)

end

function ScriptLogic.getNpcCount(self, player)

end

function ScriptLogic.getNpcID(self, player)

end

function ScriptLogic.getNpcPosition(self, player)

end

function ScriptLogic.getQuestEx(self, player, questID)

end

function ScriptLogic.getQuestExpBonus(self, player, exp)

end

function ScriptLogic.getQuestExRecord(self, player, questID, qex)

end

function ScriptLogic.getRemainingSp(self, player)

end

function ScriptLogic.GetSaveLocation(self, player, location)

end

function ScriptLogic.getSkillLevel(self, player, skillID)

end

function ScriptLogic.getSpaceSlotCount(self, p, type)

end

function ScriptLogic.getWeekStartMonday(self, dateTime)

end

function ScriptLogic.handleMobDeadQuests(self, attacker, mobID)

end

function ScriptLogic.hasBuffBySkillID(self, player, skillID)

end

function ScriptLogic.hireTutor(self, player, spawn)

end

function ScriptLogic.incHP(self, player, delta)

end

function ScriptLogic.incInventorySlot(self, player, invType, inc)

end

function ScriptLogic.isPartyLeader(self, player)

end

function ScriptLogic.killAllMonster(self, mapID)

end

function ScriptLogic.killMonster(self, mapID, mobID)

end

function ScriptLogic.lockUI(self)
  local ui = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  ui.Enable = false
  local user = ___MOD._UserService.LocalPlayer
  user:SetVisible(false)
  user.PlayerActionComponent.isClimbing = true
  user.MovementComponent.Enable = false
  user.ExtendPlayerControllerComponent.FixedLookAt = -1
end

function ScriptLogic.message(self, player, text)

end

function ScriptLogic.onCharacterEffect(self, path)
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) then
    return
  end
  local udc = player.UtilDlgComponent
  if not ___MOD.isvalid(udc) then
    return
  end
  local lastPart = ___MOD.string.match(path, ".*/(.*)")
  if udc.checkUIEffect[lastPart] == nil then
    local originalPath = path
    local prefix, trimmed = path:match("^([^/]+)/(.+)$")
    if trimmed ~= nil then
      path = trimmed
    end
    local anim
    local pos = ___MOD.FastVector3.zero:Clone()
    if prefix == "UI" then
      anim = ___MOD._EffectManager:getUIEffect(path)
      pos = ___MOD.FastVector3(-0.225, 0, 0)
    else
      anim = ___MOD._EffectManager:getEffect(path)
    end
    if anim == nil then
      ___MOD.log_warning("[onCharacterEffect] effect not found: " .. ___MOD.tostring(originalPath))
      return
    end
    local e = ___MOD._SpawnService:SpawnByModelId("model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", "characterEff", pos, player)
    if not ___MOD.isvalid(e) then
      ___MOD.log_warning("[onCharacterEffect] failed to spawn characterEff: " .. ___MOD.tostring(originalPath))
      return
    end
    e.TransformComponent.Scale = ___MOD.FastVector3(0.5, 0.5, 1)
    e.AnimationSpriteComponent:setWzSprite(anim, false)
    e.AnimationSpriteComponent.loop = false
    e.AnimationSpriteComponent.disappearWhenAnimationOnceEnd = true
    udc.checkUIEffect[lastPart] = true
  end
end

function ScriptLogic.onNpcEffect(self, npcID, path)
  local player = ___MOD._UserService.LocalPlayer
  local map = ___MOD.isvalid(player) and player.CurrentMap or nil
  local mapLife = ___MOD.isvalid(map) and map.MapLifeComponent or nil
  local npcPool = ___MOD.isvalid(mapLife) and mapLife.npcPool or nil
  if not ___MOD.isvalid(npcPool) then
    return
  end
  local targetNpc
  local npcs = npcPool:getNPCAll_Client()
  if npcs ~= nil then
    for _, npc in ___MOD.pairs(npcs) do
      local npcComponent = ___MOD.isvalid(npc) and npc.ExtendNpcComponent or nil
      if ___MOD.isvalid(npcComponent) and npcComponent.npcID == npcID then
        targetNpc = npc
        break
      end
    end
  end
  if not ___MOD.isvalid(targetNpc) then
    return
  end
  local effectPath = path
  effectPath, ___MOD._ = effectPath:gsub("^Effect/", "")
  local anim = ___MOD._EffectManager:getEffect(effectPath)
  if anim == nil then
    return
  end
  local offsetY = 1
  local template = ___MOD._NpcManager:getNpcDefaultTemplate(npcID)
  if template ~= nil and template.spriteSize ~= nil then
    offsetY = template.spriteSize.y * 0.01 + 0.2
  end
  local e = ___MOD._SpawnService:SpawnByModelId("model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", "npcEff", ___MOD.FastVector3(0, offsetY, 0), targetNpc)
  if not ___MOD.isvalid(e) then
    return
  end
  e.TransformComponent.Scale = ___MOD.FastVector3(0.5, 0.5, 1)
  e.AnimationSpriteComponent:setWzSprite(anim, false)
  e.AnimationSpriteComponent:setOrderInLayer(1001)
  e.AnimationSpriteComponent.loop = false
  e.AnimationSpriteComponent.disappearWhenAnimationOnceEnd = true
end

function ScriptLogic.onSummonEffect(self, path)
  self:onSummonEffectRetry(path, 0)
end

function ScriptLogic.onSummonEffectRetry(self, path, retryCount)
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) then
    return
  end
  local udc = player.UtilDlgComponent
  if not ___MOD.isvalid(udc) then
    return
  end
  local summon
  local map = player.CurrentMap
  local mapLife = map and map.MapLifeComponent or nil
  local summonPool = mapLife and mapLife.summonPool or nil
  local pool = summonPool and summonPool.pool or nil
  if pool ~= nil then
    for _, e in ___MOD.pairs(pool) do
      local sc = ___MOD.isvalid(e) and e.SummonComponent or nil
      if ___MOD.isvalid(sc) and sc.owner == player and sc.nSkillID % 10000 == 1013 and e.Visible then
        summon = e
        break
      end
    end
  end
  if not ___MOD.isvalid(summon) then
    if retryCount < 10 then
      ___MOD._TimerService:SetTimerOnce(function()
        self:onSummonEffectRetry(path, retryCount + 1)
      end, 0.1)
    else
      ___MOD.log("[onSummonEffect] hireTutor summon not found", path)
    end
    return
  end
  if ___MOD.isvalid(self._T.summonTutorialEffect) then
    self._T.summonTutorialEffect:Destroy()
    self._T.summonTutorialEffect = nil
  end
  local prefix, trimmed = path:match("^([^/]+)/(.+)$")
  path = trimmed
  local anim = ___MOD._EffectManager:getUIEffect(path)
  local pos = ___MOD.FastVector3.zero:Clone()
  if prefix == "UI" then
    pos = ___MOD.FastVector3(0, 0.73, 0)
  end
  local e = ___MOD._SpawnService:SpawnByModelId("model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", "summonEff", pos, summon)
  e.TransformComponent.Scale = ___MOD.FastVector3(0.5, 0.5, 1)
  e.AnimationSpriteComponent:setWzSprite(anim, false)
  e.AnimationSpriteComponent.loop = true
  e.AnimationSpriteComponent.disappearWhenAnimationOnceEnd = false
  self._T.summonTutorialEffect = e
  ___MOD._TimerService:SetTimerOnce(function()
    if self._T.summonTutorialEffect == e and ___MOD.isvalid(e) then
      e:Destroy()
      self._T.summonTutorialEffect = nil
    end
  end, 4)
end

function ScriptLogic.openNPC(self, player, npcID)

end

function ScriptLogic.passedByMidnight(self, current, target)

end

function ScriptLogic.passedByWeek(self, current, target)

end

function ScriptLogic.pickByWeightWithShuffle(self, list)
  function ___MOD.shuffleList(list)
    for i = #list, 2, -1 do
      local j = ___MOD.math.random(1, i)

      list[i], list[j] = list[j], list[i]
    end
  end

  if #list == 0 then
    return nil
  end
  ___MOD.shuffleList(list)
  local totalWeight = 0
  for _, item in ___MOD.ipairs(list) do
    totalWeight = totalWeight + item.prop
  end
  local rand = ___MOD.math.random() * totalWeight
  local sum = 0
  for _, item in ___MOD.ipairs(list) do
    sum = sum + item.prop
    if rand <= sum then
      return item
    end
  end
end

function ScriptLogic.playPortalSE(self, player)

end

function ScriptLogic.qrGetState(self, player, questID)

end

function ScriptLogic.qrSetState(self, player, questID, state)

end

function ScriptLogic.questDialog(self, player, questID, state, npcID)

end

function ScriptLogic.registerTransferField(self, user, fieldID, portal, senderUserId)

end

function ScriptLogic.registerTransferFieldPos(self, user, fieldID, pos)

end

function ScriptLogic.removeAll(self, player, itemid)

end

function ScriptLogic.removeNpc(self, mapID, npcID)

end

function ScriptLogic.resetMAP(self, mapID)

end

function ScriptLogic.resetMorph(self, player)

end

function ScriptLogic.resolveGainItemFlag(self, itemID, rowFlag, defaultFlag)

end

function ScriptLogic.runPortalSC(self, player, scriptName)

end

function ScriptLogic.runScript(self, player, portal, scriptName, onUserEnter, onScript, itemNpcID)

end

function ScriptLogic.sendMessage(self, cName, msg)

end

function ScriptLogic.setKeyvalue(self, player, key, value)

end

function ScriptLogic.setNpcSpecialAction(self, player, npcID, action, broadcast)

end

function ScriptLogic.setQuestEx(self, player, questID, value)

end

function ScriptLogic.setQuestExRecord(self, player, questID, qex, value)

end

function ScriptLogic.SetSaveLocation(self, player, location)

end

function ScriptLogic.showScreenEffect(self, path)
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) then
    return
  end
  local ui = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  if not ___MOD.isvalid(ui) then
    return
  end
  local anim
  if ___MOD.string.find(path, ".img/", 1, true) ~= nil then
    local effectPath = path
    effectPath, ___MOD._ = effectPath:gsub("^Effect/", "")
    anim = ___MOD._EffectManager:getEffect(effectPath)
  else
    anim = ___MOD._EffectManager:getMapEffect("Effect.img/" .. path)
  end
  if anim == nil then
    return
  end
  local pool = ui.UIPool.UIEffectPool
  local e = ___MOD._ObjectPool:pick(pool, "Effect", "model://6e36bd76-88aa-4315-b583-986d769f06b2", ___MOD.FastVector3.zero:Clone(), ui, true)
  local asp = e.AnimationSpriteComponent
  asp:setWzSprite(anim, false)
  asp.loop = false
  asp.releasePool = pool
end

function ScriptLogic.showTimedScreenEffect(self, path, duration)
  local player = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) or duration <= 0 then
    return
  end
  local ui = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  if not ___MOD.isvalid(ui) then
    return
  end
  local anim
  if ___MOD.string.find(path, ".img/", 1, true) ~= nil then
    local effectPath = path
    effectPath, ___MOD._ = effectPath:gsub("^Effect/", "")
    anim = ___MOD._EffectManager:getEffect(effectPath)
  else
    anim = ___MOD._EffectManager:getMapEffect("Effect.img/" .. path)
  end
  if anim == nil then
    return
  end
  local pool = ui.UIPool.UIEffectPool
  local effectEntity = ___MOD._ObjectPool:pick(pool, "Effect", "model://6e36bd76-88aa-4315-b583-986d769f06b2", ___MOD.FastVector3.zero:Clone(), ui, true)
  local animation = effectEntity.AnimationSpriteComponent
  animation:setWzSprite(anim, false)
  animation.loop = false
  animation.disappearWhenAnimationOnceEnd = false
  animation.releasePool = pool
  ___MOD._TimerService:SetTimerOnce(function()
    if ___MOD.isvalid(effectEntity) then
      ___MOD._ObjectPool:release(pool, effectEntity, true)
    end
  end, duration)
end

function ScriptLogic.spawnMob(self, mapID, mobID, x, y)

end

function ScriptLogic.spawnNpc(self, mapID, npcID, x, y)

end

function ScriptLogic.summonMob(self, mapID, itemID, x, y)

end

function ScriptLogic.teachSkill(self, player, skillID, skillLevel, masterLevel)

end

function ScriptLogic.timeMoveMap(self, user, tomap, boatmap, sec)

end

function ScriptLogic.tutorMsg(self, player, type)

end

function ScriptLogic.unLockUI(self)
  local ui = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  ui.Enable = true
  local user = ___MOD._UserService.LocalPlayer
  if ___MOD.isvalid(user) and not user.Enable then
    user.Enable = true
  end
end

function ScriptLogic.useItem(self, player, itemId)

end

function ScriptLogic.warpParty(self, player, mapID, portal)

end
