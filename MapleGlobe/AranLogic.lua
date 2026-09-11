

function AranLogic.canRecordFinalAttackCommand(self, now)
  local commandState = self._T.aranCommandState or 0
  if not self._T.aranCommandToken or commandState < 3 or 4 < commandState or 0 < (self._T.aranFinalAttackType or 0) then
    return false
  end
  local tripleEndTime = self._T.aranTripleSwingEndTime or 0
  if 0 < tripleEndTime and now > tripleEndTime then
    return false
  end
  return self._T.aranFinalBlowCommandAvailable and true or false
end

function AranLogic.canUseAranActionInput(self, user)
  if not ___MOD.isvalid(user) or user ~= ___MOD._UserService.LocalPlayer then
    return false
  end
  local player = user.Player
  local pa = user.PlayerActionComponent
  local ts = user.PlayerTemporaryStatComponent
  if not (player and pa) or not ts then
    return false
  end
  if player:isDead() or pa.sitting then
    return false
  end
  if user.CashShopComponent and user.CashShopComponent.inCashShop then
    return false
  end
  if user.AuctionComponent and user.AuctionComponent.inAuction then
    return false
  end
  local utilDlg = user.UtilDlgComponent
  if utilDlg and utilDlg:isRunning() then
    return false
  end
  if ___MOD._TradingLogic.tradingRoom then
    return false
  end
  if pa:hasUIControlLockSource() then
    return false
  end
  local storage = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Storage")
  if ___MOD.isvalid(storage) and storage.Enable then
    return false
  end
  local delivery = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Delivery")
  if ___MOD.isvalid(delivery) and delivery.Enable then
    return false
  end
  if ts:getValue(___MOD._CTS.Seal) ~= 0 or ts:getValue(___MOD._CTS.Attract) ~= 0 or ts:getValue(___MOD._CTS.Stun) ~= 0 then
    return false
  end
  return true
end

function AranLogic.canUseAranCommandSkill(self, attacker)
  return self:isAranPolearmWeapon(attacker) or self:isAranTutorialCommandMode(attacker)
end

function AranLogic.canUseCombatStepAfterBasicAttack(self, player, currentTime)
  if not self:isAranPolearmWeapon(player) then
    return false
  end
  local lastBasicAttackTime = self:getLastBasicAttackTime()
  local basicAttackEndTime = self:getBasicAttackEndTime()
  return 0 < lastBasicAttackTime and 0 < basicAttackEndTime and currentTime >= basicAttackEndTime and currentTime - lastBasicAttackTime <= 0.95
end

function AranLogic.canUseCombatStepByGround(self, player)
  if not ___MOD.isvalid(player) or not player.RigidbodyComponent then
    return false
  end
  return player.RigidbodyComponent:IsOnGround()
end

function AranLogic.clearFinalCommandInput(self)
  self._T.aranFinalBlowDownCommandTime = nil
  self._T.aranFinalTossUpCommandTime = nil
  self._T.aranFinalChargeForwardCommandTime = nil
  self._T.aranFinalChargeInputDirX = 0
end

function AranLogic.getAranAttackTargetCountByLevel(self, level)
  if 120 <= level then
    return 6
  end
  if 70 <= level then
    return 5
  end
  if 30 <= level then
    return 3
  end
  return 2
end

function AranLogic.getAranComboCommandSkillID(self, user, commandType)
  if not ___MOD.isvalid(user) or not user.AranComboComponent then
    return 0
  end
  if commandType == 3 then
    return ___MOD._SkillBook.Rolling_Spin_2111_21110006
  end
  return user.AranComboComponent:getComboCommandSkillID(commandType)
end

function AranLogic.getAranCommandSkillInfo(self, user, swingType, isFullSwing, finalAttackType)
  local isTutorial = self:isAranTutorialCommandMode(user)
  local skillID = ___MOD._SkillBook.Double_Swing_2100_21000002
  local afterimageMotion = "doubleSwing"
  local isFinalBlow = finalAttackType == 1
  local isFinalCharge = finalAttackType == 2
  local isFinalToss = finalAttackType == 3
  if isFinalBlow then
    skillID = isTutorial and ___MOD._SkillBook.Tutorial_Skill_2000_20000016 or ___MOD._SkillBook.Final_Blow_2112_21120005
    afterimageMotion = "finalBlow"
  elseif isFinalCharge then
    if isTutorial then
      return 0, 0, ""
    end
    skillID = ___MOD._SkillBook.Final_Charge_2110_21100002
    afterimageMotion = "finalCharge"
  elseif isFinalToss then
    if isTutorial then
      return 0, 0, ""
    end
    skillID = ___MOD._SkillBook.Final_Toss_2111_21110003
    afterimageMotion = "finalToss"
  elseif swingType == ___MOD._AranCommandType.TripleSwing then
    skillID = isTutorial and ___MOD._SkillBook.Tutorial_Skill_2000_20000015 or ___MOD._SkillBook.Triple_Swing_2110_21100001
    afterimageMotion = "tripleSwing"
  elseif isTutorial then
    skillID = ___MOD._SkillBook.Tutorial_Skill_2000_20000014
  end
  local skillLevel = user.SkillComponent:getSkillLevel(skillID)
  if not (not isTutorial and isFullSwing) or 0 < finalAttackType then
    return skillID, skillLevel, afterimageMotion
  end
  local overSwingLevel = user.SkillComponent:getSkillLevel(___MOD._SkillBook.Over_Swing_2112_21120002)
  if 0 < overSwingLevel then
    skillLevel = overSwingLevel
    if swingType == ___MOD._AranCommandType.DoubleSwing then
      skillID = ___MOD._SkillBook.hidden_Over_Swing__Double_Swing_2112_21120009
    elseif swingType == ___MOD._AranCommandType.TripleSwing then
      skillID = ___MOD._SkillBook.hidden_Over_Swing__Triple_Swing_2112_21120010
    end
  else
    skillLevel = user.SkillComponent:getSkillLevel(___MOD._SkillBook.Full_Swing_2111_21110002)
    if swingType == ___MOD._AranCommandType.DoubleSwing then
      skillID = ___MOD._SkillBook.hidden_Full_Swing__Double_Swing_2111_21110007
    elseif swingType == ___MOD._AranCommandType.TripleSwing then
      skillID = ___MOD._SkillBook.hidden_Full_Swing__Triple_Swing_2111_21110008
    end
  end
  return skillID, skillLevel, afterimageMotion
end

function AranLogic.getAranTutorialMapId(self, user)
  if not ___MOD.isvalid(user) then
    return 0
  end
  local player = user.Player
  if player then
    local playerMapId = ___MOD.tonumber(player.Map or 0) or 0
    if 0 < playerMapId then
      return playerMapId
    end
  end
  if ___MOD.isvalid(user.CurrentMap) and user.CurrentMap.MapInfoComponent then
    return ___MOD.tonumber(user.CurrentMap.MapInfoComponent.mapID or 0) or 0
  end
  return 0
end

function AranLogic.getBasicAttackEndTime(self)
  return self._T.aranBasicAttackEndTime or 0
end

function AranLogic.getBasicAttackMotion(self, attacker, skillID)
  if skillID == 0 and self:isAranPolearmWeapon(attacker) then
    if self:isDownProneBasicAttackInput(attacker) then
      return "proneStab", 0, true
    end
    return "swingP1PoleArm", 0, true
  end
  return nil, nil, nil
end

function AranLogic.getBasicAttackTotalActionDelay(self, attacker, skillID, defaultDelay)
  if skillID == 0 and self:canUseAranCommandSkill(attacker) then
    return 0.95
  end
  if (skillID == ___MOD._SkillBook.Final_Blow_2112_21120005 or skillID == ___MOD._SkillBook.Tutorial_Skill_2000_20000016 or skillID == ___MOD._SkillBook.Final_Toss_2111_21110003) and ___MOD.isvalid(attacker) and attacker.Player and ___MOD._JobLogic:isAran(attacker.Player.Job) and attacker.PlayerActionComponent then
    local finalAction = skillID == ___MOD._SkillBook.Final_Toss_2111_21110003 and "finalToss" or "finalBlow"
    local finalBlowDelay = attacker.PlayerActionComponent:getTotalSkillActionDelay(finalAction, skillID)
    if 0 < finalBlowDelay then
      return finalBlowDelay
    end
  end
  return defaultDelay
end

function AranLogic.getDefaultAttackMobCount(self, attacker, defaultCount)
  if self:isAranPolearmWeapon(attacker) then
    return self:getAranAttackTargetCountByLevel(attacker.Player.Level)
  end
  if ___MOD.isvalid(attacker) and attacker.Player and ___MOD._JobLogic:isAran(attacker.Player.Job) then
    return 1
  end
  return defaultCount
end

function AranLogic.getDirectionInputX(self, input)
  if input == "LeftArrow" then
    return -1
  end
  if input == "RightArrow" then
    return 1
  end
  return 0
end

function AranLogic.getDisplayLevel(self, user, realLevel)
  if self:isAranTutorialStatMap(user) then
    return 200
  end
  return realLevel
end

function AranLogic.getLastBasicAttackTime(self)
  return self._T.aranLastBasicAttackTime or 0
end

function AranLogic.getRangeDelayForLocalPlayer(self, skillID)
  local p = ___MOD._UserService.LocalPlayer
  if self:canUseAranCommandSkill(p) then
    return 0.05
  end
  return 0
end

function AranLogic.isAranComboCommandSkill(self, skillID)
  return self:shouldConsumeAranComboCommandSkill(skillID) or skillID == ___MOD._SkillBook.Rolling_Spin_2111_21110006
end

function AranLogic.isAranCommandSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Combat_Step_2100_21001001 or skillID == book.Final_Charge_2110_21100002 or skillID == book.Final_Toss_2111_21110003 or skillID == book.Final_Blow_2112_21120005 or skillID == book.Rolling_Spin_2111_21110006 or self:shouldConsumeAranComboCommandSkill(skillID)
end

function AranLogic.isAranPolearmWeapon(self, attacker)
  if not (___MOD.isvalid(attacker) and attacker.Player) or not ___MOD._JobLogic:isAran(attacker.Player.Job) then
    return false
  end
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(attacker)
  if not weaponInfo then
    return false
  end
  return weaponInfo.weaponType == ___MOD._WeaponType.POLEARM
end

function AranLogic.isAranTutorialCommandMode(self, attacker)
  if not (___MOD.isvalid(attacker) and attacker.Player and ___MOD._JobLogic:isAran(attacker.Player.Job) and attacker.SkillComponent and ___MOD.isvalid(attacker.CurrentMap)) or not attacker.CurrentMap.MapInfoComponent then
    return false
  end
  local mapId = ___MOD.tonumber(attacker.CurrentMap.MapInfoComponent.mapID or 0) or 0
  if mapId // 1000 ~= 914000 then
    return false
  end
  return 0 < attacker.SkillComponent:getSkillLevel(___MOD._SkillBook.Tutorial_Skill_2000_20000014)
end

function AranLogic.isAranTutorialMissOnlyMap(self, user)
  local mapId = 0
  if ___MOD.isvalid(user) and ___MOD.isvalid(user.CurrentMap) and user.CurrentMap.MapInfoComponent then
    mapId = ___MOD.tonumber(user.CurrentMap.MapInfoComponent.mapID or 0) or 0
  end
  if mapId <= 0 then
    mapId = self:getAranTutorialMapId(user)
  end
  return mapId == 914000200 or mapId == 914000210 or mapId == 914000220
end

function AranLogic.isAranTutorialStatMap(self, user)
  local mapId = self:getAranTutorialMapId(user)
  return self:isAranTutorialStatMapId(mapId)
end

function AranLogic.isAranTutorialStatMapId(self, mapId)
  return 914000000 <= mapId and mapId <= 914000500
end

function AranLogic.isBlockedIntroWindow(self, uiName)
  if not self:isIntroMap() then
    return false
  end
  return uiName == "Equipment" or uiName == "Inventory" or uiName == "CharacterStat" or uiName == "Skill" or uiName == "WorldMap" or uiName == "UserList"
end

function AranLogic.isDownProneBasicAttackInput(self, attacker)
  if not (___MOD.isvalid(attacker) and attacker.RigidbodyComponent) or not attacker.PlayerSettingsComponent then
    return false
  end
  return attacker.RigidbodyComponent:IsOnGround() and attacker.PlayerSettingsComponent:isKeyPressed("DownArrow")
end

function AranLogic.isIntroMap(self)
  local user = ___MOD._UserService.LocalPlayer
  if not (___MOD.isvalid(user) and ___MOD.isvalid(user.CurrentMap)) or not user.CurrentMap.MapInfoComponent then
    return false
  end
  local mapId = ___MOD.tonumber(user.CurrentMap.MapInfoComponent.mapID or 0) or 0
  return mapId // 1000 == 914000
end

function AranLogic.isLocalAranPlayer(self, user)
  return ___MOD.isvalid(user) and user == ___MOD._UserService.LocalPlayer and user.Player and ___MOD._JobLogic:isAran(user.Player.Job)
end

function AranLogic.onAranCommandSkill(self, user, token, swingType, isFullSwing, finalAttackType)
  swingType = swingType or ___MOD._AranCommandType.DoubleSwing
  finalAttackType = finalAttackType or 0
  if (self._T.aranCommandToken or 0) ~= token then
    return
  end
  if not self:isLocalAranPlayer(user) or not user.SkillComponent then
    self:resetAranCommandSkillCheck()
    return
  end
  if not self:canUseAranCommandSkill(user) then
    self:resetAranCommandSkillCheck()
    return
  end
  if not self:canUseAranActionInput(user) then
    self:resetAranCommandSkillCheck()
    return
  end
  local isFinalCharge = finalAttackType == 2
  local isFinalCommand = 0 < finalAttackType
  if isFinalCommand then
    self._T.aranFinalBlowExecuting = true
  end
  local skillID, skillLevel, afterimageMotion = self:getAranCommandSkillInfo(user, swingType, isFullSwing, finalAttackType)
  local isTutorial = self:isAranTutorialCommandMode(user)
  if skillLevel <= 0 then
    self:resetAranCommandSkillCheck()
    return
  end
  if not isTutorial and user.SkillComponent:isAranCommandLocked(skillID) then
    self:resetAranCommandSkillCheck()
    return
  end
  local pa = user.PlayerActionComponent
  if pa then
    if isFinalCommand then
      pa:clearActionTimer()
      pa:endAttackState()
      pa:setMovementLock(___MOD._ControllEnableType.ActionAnimation, false)
    elseif pa.isAttacking then
      pa:endAttackState()
      pa:setMovementLock(___MOD._ControllEnableType.ActionAnimation, false)
    end
    if pa.enableNextAttackTime > ___MOD._UtilLogic.ServerElapsedSeconds then
      pa.enableNextAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds
    end
  end
  if not pa or not user.AfterImageComponent then
    self:resetAranCommandSkillCheck()
    return
  end
  local finalChargeInputDirX = 0
  if isFinalCharge then
    if not user.PlayerControllerComponent or not user.ExtendPlayerControllerComponent then
      self:resetAranCommandSkillCheck()
      return
    end
    finalChargeInputDirX = self._T.aranFinalChargeInputDirX or 0
    if finalChargeInputDirX == 0 then
      finalChargeInputDirX = user.PlayerControllerComponent.LookDirectionX == -1 and -1 or 1
    end
    user.PlayerControllerComponent.LookDirectionX = finalChargeInputDirX
    user.ExtendPlayerControllerComponent.LookDirectionX = finalChargeInputDirX
    user.ExtendPlayerControllerComponent.FixedLookAt = finalChargeInputDirX
  end
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(user)
  local weaponType = weaponInfo.weaponType
  if 0 < weaponInfo.subWeaponID then
    weaponType = ___MOD._WeaponType:getWeaponTypeByItemID(weaponInfo.subWeaponID)
  end
  local attackSound = ___MOD._WeaponType:getAttackSoundByWeaponType(weaponType, false)
  local attackSoundRUID = ___MOD.__RUIDManager:get(attackSound)
  if not isFinalCommand and attackSoundRUID and attackSoundRUID ~= "" then
    ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(attackSoundRUID, user, user, 1)
  end
  local ctx = ___MOD._PlayerAttackLogic_Melee:initSkillCtx(user, skillID, skillLevel, weaponInfo, false, false, false)
  if not ctx then
    if isFinalCharge and user.ExtendPlayerControllerComponent then
      user.ExtendPlayerControllerComponent.FixedLookAt = 0
    end
    self:resetAranCommandSkillCheck()
    return
  end
  local sprites
  if not isTutorial and not isFinalCharge then
    ctx.motion = afterimageMotion
    ctx.afterimageInfo = nil
    local startFrameIndex
    startFrameIndex, sprites = user.AfterImageComponent:getAfterImageData2(afterimageMotion)
    ctx.startFrameIndex = startFrameIndex
  end
  local _, lastAttackDelay = ___MOD._PlayerAttackLogic:makeHitDelayInfo(pa, ctx, sprites)
  local afterimageDelay = lastAttackDelay or 0
  if ___MOD._PlayerAttackLogic:tryPlayerAttack(user, skillID, skillLevel, true, 0.0, nil) then
    if isFinalCommand then
      local inputBlockUntil = ___MOD.math.max(___MOD._UtilLogic.ServerElapsedSeconds + 0.2, pa.enableNextAttackTime)
      self:resetAranCommandSkillCheck()
      self._T.aranCommandInputBlockUntil = inputBlockUntil
      return
    end
    if not isTutorial and not isFullSwing and not isFinalCommand then
      ___MOD._TimerService:SetTimerOnce(function()
        if not ___MOD.isvalid(user) or not user.AfterImageComponent then
          return
        end
        user.AfterImageComponent:playAfterImage(user.AfterImageComponent:getAfterimagePathByWeapon(), afterimageMotion, ctx.playRate, user)
      end, afterimageDelay)
    end
    if swingType == ___MOD._AranCommandType.DoubleSwing then
      local doubleSwingStartTime = ___MOD._UtilLogic.ServerElapsedSeconds
      self._T.aranDoubleSwingInputEndTime = ___MOD.math.max(doubleSwingStartTime, pa.enableNextAttackTime) + 0.1
      if not self._T.aranTripleSwingReserved then
        local inputEndTime = self._T.aranDoubleSwingInputEndTime
        ___MOD._TimerService:SetTimerOnce(function()
          if (self._T.aranCommandToken or 0) ~= token then
            return
          end
          if self._T.aranTripleSwingReserved then
            return
          end
          self:resetAranCommandSkillCheck()
        end, ___MOD.math.max(0, inputEndTime - doubleSwingStartTime))
        return
      end
    end
    if swingType == ___MOD._AranCommandType.DoubleSwing and self._T.aranTripleSwingReserved then
      local nextDelay = ___MOD.math.max(0, pa.enableNextAttackTime - ___MOD._UtilLogic.ServerElapsedSeconds)
      ___MOD._TimerService:SetTimerOnce(function()
        self:onAranCommandSkill(user, token, 2, isFullSwing, 0)
      end, nextDelay)
      return
    end
    if swingType == ___MOD._AranCommandType.TripleSwing then
      self._T.aranTripleSwingExecuted = true
      if 0 >= (self._T.aranFinalAttackType or 0) then
        self._T.aranCommandState = 4
      end
      local nextDelay = ___MOD.math.max(0, pa.enableNextAttackTime - ___MOD._UtilLogic.ServerElapsedSeconds)
      self._T.aranTripleSwingEndTime = ___MOD._UtilLogic.ServerElapsedSeconds + nextDelay + 0.1
      if 0 < (self._T.aranFinalAttackType or 0) then
        self:scheduleReservedFinalBlow(user, token, nextDelay + 0.1)
        return
      end
      ___MOD._TimerService:SetTimerOnce(function()
        if (self._T.aranCommandToken or 0) ~= token then
          return
        end
        self:resetAranCommandSkillCheck()
      end, nextDelay + 0.1)
      return
    end
  end
  if isFinalCharge and user.ExtendPlayerControllerComponent then
    user.ExtendPlayerControllerComponent.FixedLookAt = 0
  end
  self:resetAranCommandSkillCheck()
end

function AranLogic.onCombatSteb(self, p, skillLevel, inputDirX)
  if not self:isLocalAranPlayer(p) then
    return false
  end
  if not self:canUseAranActionInput(p) then
    return false
  end
  if not (p.RigidbodyComponent and p.PlayerControllerComponent) or not p.PlayerActionComponent then
    return false
  end
  if p.PlayerActionComponent:isOnTamingMob() or ___MOD._PlayerSkillLogic:isTamingMobEnteringWindow() then
    return false
  end
  if not p.RigidbodyComponent:IsOnGround() then
    return false
  end
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  local pa = p.PlayerActionComponent
  if not (not (currentTime < pa.enableNextAttackTime) or self:canUseCombatStepAfterBasicAttack(p, currentTime)) or currentTime < pa.enableMoveAffectedSkillTime then
    return false
  end
  local skillID = ___MOD._SkillBook.Combat_Step_2100_21001001
  local actionDelay = 0.5
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData and ___MOD.isvalid(skillData.action) then
    local motion = skillData.action["0"]
    if motion and motion ~= "" then
      actionDelay = ___MOD.math.max(0.5, ___MOD._PlayerSkillLogic:getSkillActionLockDelaySec(p, skillID, motion, 0.5, 0))
    end
  end
  local level = ___MOD.math.max(1, ___MOD.math.min(skillLevel, 15))
  local forceX = 7 + (level - 1) * 0.2571428571428572
  local dirX = inputDirX
  if dirX == 0 and p.PlayerSettingsComponent then
    local leftPressed = p.PlayerSettingsComponent:isKeyPressed("LeftArrow")
    local rightPressed = p.PlayerSettingsComponent:isKeyPressed("RightArrow")
    if leftPressed and not rightPressed then
      dirX = -1
    elseif rightPressed and not leftPressed then
      dirX = 1
    end
  end
  if dirX == 0 and p.Player and p.Player.lastInputLeftRightKey ~= 0 then
    dirX = p.Player.lastInputLeftRightKey
  end
  if dirX == 0 then
    dirX = p.PlayerControllerComponent.LookDirectionX == -1 and -1 or 1
  end
  if dirX == -1 then
    forceX = -forceX
  end
  p.PlayerControllerComponent.LookDirectionX = dirX
  if p.ExtendPlayerControllerComponent then
    p.ExtendPlayerControllerComponent.LookDirectionX = dirX
  end
  ___MOD._PlayerVecCtrl:SetImpactNext(forceX, 0.1, true)
  self:resetAranCommandSkillCheck()
  pa.enableNextAttackTime = ___MOD.math.max(pa.enableNextAttackTime, currentTime + actionDelay)
  pa.enableMoveAffectedSkillTime = ___MOD.math.max(pa.enableMoveAffectedSkillTime, currentTime + actionDelay)
  local cooltime = ___MOD._SkillLogic:getCooltime(skillID)
  if 0 < cooltime then
    ___MOD._PlayerSkillLogic:setCanUseSkillTime(p, skillID, currentTime + cooltime)
  end
  return true
end

function AranLogic.onDoubleClickSameDirectionKey(self, player, inputDirX)
  if not self:isLocalAranPlayer(player) then
    return false
  end
  if not self:canUseAranActionInput(player) then
    return false
  end
  local slv = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Combat_Step_2100_21001001)
  if 0 < slv and not player.SkillComponent:isAranCommandLocked(___MOD._SkillBook.Combat_Step_2100_21001001) then
    self._T.combatStepInputDirX = inputDirX
    ___MOD._PlayerSkillLogic:tryUseSkillClient(player, ___MOD._SkillBook.Combat_Step_2100_21001001, slv, false, false, false)
    self._T.combatStepInputDirX = nil
  end
  return true
end

function AranLogic.recordAranComboSkillCommandDirection(self, user, input)
  if not (self:isLocalAranPlayer(user) and self:isAranPolearmWeapon(user)) or not self:canUseAranActionInput(user) then
    return
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local step = self._T.aranComboSkillCommandStep or 0
  local commandTime = self._T.aranComboSkillCommandTime or 0
  if 0 < step and 0.5 < now - commandTime then
    step = 0
  end
  if input == "UpArrow" then
    if step == 1 then
      self:setAranComboSkillCommand(2, 3, now)
      return
    end
    self:setAranComboSkillCommand(1, 0, now)
    self._T.aranComboSkillFirstInput = "UpArrow"
    return
  end
  if input == "DownArrow" then
    if step == 1 then
      self:setAranComboSkillCommand(2, 2, now)
      return
    end
    self:setAranComboSkillCommand(1, 0, now)
    self._T.aranComboSkillFirstInput = "DownArrow"
    return
  end
  local firstInput = self._T.aranComboSkillFirstInput
  if self:getDirectionInputX(input) ~= 0 then
    if step == 1 and firstInput == "DownArrow" then
      self:setAranComboSkillCommand(2, 1, now)
      return
    end
    self:resetAranComboSkillCommand()
  end
end

function AranLogic.recordAranCommandDirection(self, user, input)
  if not self:isLocalAranPlayer(user) then
    return
  end
  if not self:canUseAranCommandSkill(user) then
    self:resetAranComboSkillCommand()
    self:resetAranCommandSkillCheck()
    return
  end
  if not self:canUseAranActionInput(user) then
    self:resetAranComboSkillCommand()
    self:resetAranCommandSkillCheck()
    return
  end
  if input == "DownArrow" then
    self:recordFinalBlowDownCommand(user)
  elseif input == "UpArrow" then
    self:recordFinalTossUpCommand(user)
  elseif input == "LeftArrow" or input == "RightArrow" then
    self:recordFinalChargeForwardCommand(user, input)
  end
  if self:isAranPolearmWeapon(user) then
    self:recordAranComboSkillCommandDirection(user, input)
  end
end

function AranLogic.recordBasicAttack(self, user, attackTime)
  if not (self:canUseAranCommandSkill(user) and self:canUseAranActionInput(user)) or not user.PlayerActionComponent then
    if ___MOD.isvalid(user) and user.Player and ___MOD._JobLogic:isAran(user.Player.Job) then
      self:resetAranCommandSkillCheck()
    end
    return
  end
  if self:isDownProneBasicAttackInput(user) then
    self:resetAranCommandSkillCheck()
    return
  end
  local actionDelay = self:isAranPolearmWeapon(user) and user.PlayerActionComponent:getTotalActionDelay("swingP1PoleArm") or self:getBasicAttackTotalActionDelay(user, 0, 0.95)
  self:setBasicAttackTime(attackTime, attackTime + actionDelay)
end

function AranLogic.recordFinalBlowDownCommand(self, user)
  if not (self:isLocalAranPlayer(user) and self:canUseAranCommandSkill(user)) or not self:canUseAranActionInput(user) then
    return
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  if not self:canRecordFinalAttackCommand(now) then
    return
  end
  self._T.aranFinalBlowDownCommandTime = now
end

function AranLogic.recordFinalChargeForwardCommand(self, user, input)
  if not (self:isLocalAranPlayer(user) and self:isAranPolearmWeapon(user)) or not self:canUseAranActionInput(user) then
    return
  end
  local inputDirX = self:getDirectionInputX(input)
  if inputDirX == 0 then
    return
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  if not self:canRecordFinalAttackCommand(now) then
    return
  end
  self._T.aranFinalChargeForwardCommandTime = now
  self._T.aranFinalChargeInputDirX = inputDirX
end

function AranLogic.recordFinalTossUpCommand(self, user)
  if not (self:isLocalAranPlayer(user) and self:isAranPolearmWeapon(user)) or not self:canUseAranActionInput(user) then
    return
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  if not self:canRecordFinalAttackCommand(now) then
    return
  end
  self._T.aranFinalTossUpCommandTime = now
end

function AranLogic.reserveAranCommandSkillToken(self)
  local token = (self._T.aranCommandTokenSeq or 0) + 1
  self._T.aranCommandTokenSeq = token
  self._T.aranCommandToken = token
  self._T.aranCommandReserveTime = ___MOD._UtilLogic.ServerElapsedSeconds
  self._T.aranCommandState = 2
  self._T.aranCommandAttackCount = 2
  self._T.aranCommandAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds
  self._T.aranDoubleSwingInputEndTime = nil
  self._T.aranTripleSwingReserved = false
  self._T.aranTripleSwingExecuted = false
  self._T.aranTripleSwingEndTime = nil
  self._T.aranFinalBlowCommandAvailable = false
  self:clearFinalCommandInput()
  self._T.aranFinalAttackType = 0
  return token
end

function AranLogic.resetAranComboSkillCommand(self)
  self._T.aranComboSkillCommandStep = 0
  self._T.aranComboSkillCommandType = 0
  self._T.aranComboSkillCommandTime = nil
  self._T.aranComboSkillFirstInput = nil
end

function AranLogic.resetAranCommandSkillCheck(self)
  if self._T.aranFinalBlowTimer then
    ___MOD._TimerService:ClearTimer(self._T.aranFinalBlowTimer)
  end
  self._T.aranCommandToken = nil
  self._T.aranLastBasicAttackTime = nil
  self._T.aranBasicAttackEndTime = nil
  self._T.aranCommandReserveTime = nil
  self._T.aranCommandState = 0
  self._T.aranCommandAttackCount = 0
  self._T.aranCommandAttackTime = nil
  self._T.aranTripleSwingReserved = nil
  self._T.aranTripleSwingExecuted = nil
  self._T.aranTripleSwingEndTime = nil
  self._T.aranDoubleSwingInputEndTime = nil
  self._T.aranFinalBlowCommandAvailable = nil
  self:clearFinalCommandInput()
  self._T.aranFinalAttackType = 0
  self._T.aranFinalBlowExecuting = nil
  self._T.aranFinalBlowTimer = nil
  self._T.aranFinalBlowScheduledTime = nil
  self._T.aranCommandIsFullSwing = nil
end

function AranLogic.runReservedFinalBlow(self, user, token)
  if (self._T.aranCommandToken or 0) ~= token then
    return false
  end
  if 0 >= (self._T.aranFinalAttackType or 0) or self._T.aranFinalBlowExecuting then
    return false
  end
  if not self:canUseAranActionInput(user) then
    self:resetAranCommandSkillCheck()
    return false
  end
  self._T.aranFinalBlowExecuting = true
  self:onAranCommandSkill(user, token, 0, self._T.aranCommandIsFullSwing or false, self._T.aranFinalAttackType or 0)
  return true
end

function AranLogic.scheduleReservedFinalBlow(self, user, token, delay)
  if self._T.aranFinalBlowTimer then
    ___MOD._TimerService:ClearTimer(self._T.aranFinalBlowTimer)
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local scheduledTime = now + ___MOD.math.max(0, delay)
  self._T.aranFinalBlowScheduledTime = scheduledTime
  if ___MOD.isvalid(user) and user.PlayerActionComponent then
    local pa = user.PlayerActionComponent
    pa.enableNextAttackTime = ___MOD.math.max(pa.enableNextAttackTime, scheduledTime)
    pa.enableMoveAffectedSkillTime = ___MOD.math.max(pa.enableMoveAffectedSkillTime, scheduledTime)
  end
  self._T.aranFinalBlowTimer = ___MOD._TimerService:SetTimerOnce(function()
    self._T.aranFinalBlowTimer = nil
    self:runReservedFinalBlow(user, token)
  end, ___MOD.math.max(0, delay))
end

function AranLogic.setAranComboSkillCommand(self, step, commandType, now)
  self._T.aranComboSkillCommandStep = step
  self._T.aranComboSkillCommandType = commandType
  self._T.aranComboSkillCommandTime = now
end

function AranLogic.setBasicAttackTime(self, attackTime, triggerTime)
  self._T.aranLastBasicAttackTime = attackTime
  self._T.aranBasicAttackEndTime = triggerTime
  self._T.aranCommandState = 1
  self._T.aranCommandAttackCount = 1
  self._T.aranCommandAttackTime = attackTime
end

function AranLogic.shouldConsumeAranComboCommandSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Combo_Smash_2110_21100004 or skillID == book.Combo_Drain_2110_21100005 or skillID == book.Combo_Fenrir_2111_21110004 or skillID == book.Combo_Tempest_2112_21120006 or skillID == book.Combo_Barrier_2112_21120007
end

function AranLogic.tryConsumePendingFinalBlowAction(self, user)
  if not self:isLocalAranPlayer(user) then
    return false
  end
  if not self:canUseAranCommandSkill(user) then
    self:resetAranCommandSkillCheck()
    return false
  end
  if not self:canUseAranActionInput(user) then
    self:resetAranCommandSkillCheck()
    return false
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  local commandInputBlockUntil = self._T.aranCommandInputBlockUntil or 0
  if now < commandInputBlockUntil then
    return true
  end
  local token = self._T.aranCommandToken
  if not token then
    return false
  end
  if 0 < (self._T.aranFinalAttackType or 0) then
    local scheduledTime = self._T.aranFinalBlowScheduledTime or self._T.aranTripleSwingEndTime or 0
    if not self._T.aranFinalBlowExecuting and 0 < scheduledTime and now >= scheduledTime then
      self:runReservedFinalBlow(user, token)
      return true
    end
    return true
  end
  if self._T.aranFinalBlowExecuting then
    return true
  end
  return false
end

function AranLogic.tryReserveAranCommandSkill(self, user, isFreshAttackInput)
  if not (___MOD.isvalid(user) and user.Player and user.SkillComponent and user.PlayerActionComponent) or not user.PlayerComponent then
    return false
  end
  if not ___MOD._JobLogic:isAran(user.Player.Job) then
    return false
  end
  if not self:canUseAranCommandSkill(user) then
    self:resetAranCommandSkillCheck()
    return false
  end
  if not self:canUseAranActionInput(user) then
    self:resetAranCommandSkillCheck()
    self:resetAranComboSkillCommand()
    return false
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  if self:tryConsumePendingFinalBlowAction(user) then
    return true
  end
  local reservedToken = self._T.aranCommandToken
  local commandState = self._T.aranCommandState or 0
  local commandAttackTime = self._T.aranCommandAttackTime or self._T.aranCommandReserveTime or 0
  local isTutorial = self:isAranTutorialCommandMode(user)
  local isDownProneAttackInput = self:isDownProneBasicAttackInput(user)
  if reservedToken and 3 <= commandState then
    local downCommandTime = self._T.aranFinalBlowDownCommandTime or 0
    local upCommandTime = self._T.aranFinalTossUpCommandTime or 0
    local forwardCommandTime = self._T.aranFinalChargeForwardCommandTime or 0
    local tripleEndTime = self._T.aranTripleSwingEndTime or 0
    local finalAttackType = 0
    local finalCommandTime = 0
    local canUseFinalBlowCommand = self._T.aranFinalBlowCommandAvailable and 0 < downCommandTime and (tripleEndTime <= 0 or downCommandTime <= tripleEndTime) and not user.SkillComponent:isAranCommandLocked(___MOD._SkillBook.Final_Blow_2112_21120005)
    local canUseFinalTossCommand = self._T.aranFinalBlowCommandAvailable and 0 < upCommandTime and (tripleEndTime <= 0 or upCommandTime <= tripleEndTime) and not user.SkillComponent:isAranCommandLocked(___MOD._SkillBook.Final_Toss_2111_21110003)
    local canUseFinalChargeCommand = self._T.aranFinalBlowCommandAvailable and 0 < forwardCommandTime and (tripleEndTime <= 0 or forwardCommandTime <= tripleEndTime) and not user.SkillComponent:isAranCommandLocked(___MOD._SkillBook.Final_Charge_2110_21100002)
    if canUseFinalBlowCommand then
      finalAttackType = 1
      finalCommandTime = downCommandTime
    end
    if canUseFinalTossCommand and upCommandTime >= finalCommandTime then
      finalAttackType = 3
      finalCommandTime = upCommandTime
    end
    if canUseFinalChargeCommand and forwardCommandTime >= finalCommandTime then
      finalAttackType = 2
      finalCommandTime = forwardCommandTime
    end
    if isFreshAttackInput and 0 < finalAttackType and now > finalCommandTime and 0 >= (self._T.aranFinalAttackType or 0) then
      local _, finalSkillLevel = self:getAranCommandSkillInfo(user, 0, false, finalAttackType)
      if 0 < finalSkillLevel then
        self._T.aranCommandReserveTime = now
        self._T.aranCommandState = 5
        self._T.aranFinalAttackType = finalAttackType
        self._T.aranFinalBlowExecuting = nil
        local finalChargeInputDirX = self._T.aranFinalChargeInputDirX or 0
        self:clearFinalCommandInput()
        if finalAttackType ~= 2 then
          self._T.aranFinalChargeInputDirX = 0
        else
          self._T.aranFinalChargeInputDirX = finalChargeInputDirX
        end
        if self._T.aranTripleSwingExecuted then
          self:scheduleReservedFinalBlow(user, reservedToken, ___MOD.math.max(0, tripleEndTime - now))
        end
        return true
      end
    end
    if self._T.aranTripleSwingExecuted and 0 < tripleEndTime and now >= tripleEndTime then
      self:resetAranCommandSkillCheck()
      return false
    end
    self._T.aranCommandReserveTime = now
    return true
  end
  if isDownProneAttackInput then
    self:resetAranCommandSkillCheck()
    return false
  end
  if reservedToken and commandState == 2 then
    local doubleSwingInputEndTime = self._T.aranDoubleSwingInputEndTime or 0
    if (commandAttackTime <= 0 or 0.5 < now - commandAttackTime) and (doubleSwingInputEndTime <= 0 or now > doubleSwingInputEndTime) then
      return true
    end
    if not isFreshAttackInput then
      return true
    end
    local tripleSkillID = isTutorial and ___MOD._SkillBook.Tutorial_Skill_2000_20000015 or ___MOD._SkillBook.Triple_Swing_2110_21100001
    local tripleSkillLevel = user.SkillComponent:getSkillLevel(tripleSkillID)
    if tripleSkillLevel <= 0 then
      return false
    end
    self._T.aranCommandState = 3
    self._T.aranCommandAttackCount = 3
    self._T.aranCommandAttackTime = now
    self._T.aranTripleSwingReserved = true
    self._T.aranFinalBlowCommandAvailable = true
    self:clearFinalCommandInput()
    self._T.aranTripleSwingEndTime = nil
    self._T.aranCommandReserveTime = now
    if 0 < doubleSwingInputEndTime then
      local nextDelay = ___MOD.math.max(0, user.PlayerActionComponent.enableNextAttackTime - now)
      local scheduledToken = reservedToken
      local scheduledIsFullSwing = self._T.aranCommandIsFullSwing or false
      ___MOD._TimerService:SetTimerOnce(function()
        if (self._T.aranCommandToken or 0) ~= scheduledToken then
          return
        end
        self:onAranCommandSkill(user, scheduledToken, ___MOD._AranCommandType.TripleSwing, scheduledIsFullSwing, 0)
      end, nextDelay)
    end
    return true
  end
  if not isFreshAttackInput then
    return false
  end
  local skillID = isTutorial and ___MOD._SkillBook.Tutorial_Skill_2000_20000014 or ___MOD._SkillBook.Double_Swing_2100_21000002
  local skillLevel = user.SkillComponent:getSkillLevel(skillID)
  if skillLevel <= 0 then
    return false
  end
  local lastBasicAttackTime = self:getLastBasicAttackTime()
  local triggerTime = self:getBasicAttackEndTime()
  if triggerTime <= 0 then
    self:setBasicAttackTime(0, 0)
    return false
  end
  if (lastBasicAttackTime <= 0 or 0.5 < now - lastBasicAttackTime) and now > triggerTime + 0.1 then
    self:setBasicAttackTime(0, 0)
    return false
  end
  local pa = user.PlayerActionComponent
  if now > triggerTime then
    triggerTime = now
  end
  pa.enableNextAttackTime = triggerTime
  self:setBasicAttackTime(0, 0)
  local isFullSwing = 0 < user.SkillComponent:getSkillLevel(___MOD._SkillBook.Full_Swing_2111_21110002) or 0 < user.SkillComponent:getSkillLevel(___MOD._SkillBook.Over_Swing_2112_21120002)
  local token = self:reserveAranCommandSkillToken()
  self._T.aranCommandIsFullSwing = isFullSwing
  ___MOD._TimerService:SetTimerOnce(function()
    self:onAranCommandSkill(user, token, 1, isFullSwing, 0)
  end, triggerTime - now)
  return true
end

function AranLogic.tryUseAranComboCommandSkill(self, user)
  if not self:isLocalAranPlayer(user) or not user.SkillComponent then
    return false
  end
  if not self:isAranPolearmWeapon(user) then
    self:resetAranComboSkillCommand()
    return false
  end
  if not self:canUseAranActionInput(user) then
    self:resetAranComboSkillCommand()
    self:resetAranCommandSkillCheck()
    return false
  end
  local commandType = self._T.aranComboSkillCommandType or 0
  local commandTime = self._T.aranComboSkillCommandTime or 0
  if commandType <= 0 or ___MOD._UtilLogic.ServerElapsedSeconds - commandTime > 0.5 then
    self:resetAranComboSkillCommand()
    return false
  end
  local skillID = self:getAranComboCommandSkillID(user, commandType)
  if skillID <= 0 then
    self:resetAranComboSkillCommand()
    return false
  end
  if user.SkillComponent:isAranCommandLocked(skillID) then
    self:resetAranComboSkillCommand()
    return false
  end
  local skillLevel = user.SkillComponent:getSkillLevel(skillID)
  if skillLevel <= 0 then
    self:resetAranComboSkillCommand()
    return false
  end
  local actionComponent = user.PlayerActionComponent
  if not actionComponent then
    self:resetAranComboSkillCommand()
    return false
  end
  if self._T.aranComboSkillPendingTimer then
    self:resetAranComboSkillCommand()
    return true
  end
  local now = ___MOD._UtilLogic.ServerElapsedSeconds
  if actionComponent.isAttacking or now < actionComponent.enableNextAttackTime then
    self:resetAranComboSkillCommand()
    self:resetAranCommandSkillCheck()
    local token = (self._T.aranComboSkillPendingToken or 0) + 1
    self._T.aranComboSkillPendingToken = token
    local runPending

    function runPending()
      if (self._T.aranComboSkillPendingToken or 0) ~= token then
        return
      end
      if not (self:isLocalAranPlayer(user) and user.PlayerActionComponent) or not user.AranComboComponent then
        self._T.aranComboSkillPendingTimer = nil
        return
      end
      if not self:canUseAranActionInput(user) then
        self._T.aranComboSkillPendingTimer = nil
        self:resetAranComboSkillCommand()
        self:resetAranCommandSkillCheck()
        return
      end
      local currentPa = user.PlayerActionComponent
      local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
      if currentPa.isAttacking or currentTime < currentPa.enableNextAttackTime then
        local nextDelay = ___MOD.math.max(0.05, currentPa.enableNextAttackTime - currentTime)
        self._T.aranComboSkillPendingTimer = ___MOD._TimerService:SetTimerOnce(runPending, nextDelay)
        return
      end
      self._T.aranComboSkillPendingTimer = nil
      if user.SkillComponent:isAranCommandLocked(skillID) then
        return
      end
      ___MOD._PlayerSkillLogic:tryUseSkillClient(user, skillID, skillLevel, false, false, false)
    end

    local nextDelay = ___MOD.math.max(0.05, actionComponent.enableNextAttackTime - now)
    self._T.aranComboSkillPendingTimer = ___MOD._TimerService:SetTimerOnce(runPending, nextDelay)
    return true
  end
  self:resetAranComboSkillCommand()
  self:resetAranCommandSkillCheck()
  local pa = user.PlayerActionComponent
  if pa then
    if pa.isAttacking then
      pa:endAttackState()
      pa:setMovementLock(___MOD._ControllEnableType.ActionAnimation, false)
    end
    if pa.enableNextAttackTime > ___MOD._UtilLogic.ServerElapsedSeconds then
      pa.enableNextAttackTime = ___MOD._UtilLogic.ServerElapsedSeconds
    end
  end
  ___MOD._PlayerSkillLogic:tryUseSkillClient(user, skillID, skillLevel, false, false, false)
  return true
end
