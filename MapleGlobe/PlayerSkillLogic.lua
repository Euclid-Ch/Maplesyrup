

function PlayerSkillLogic.afterResetTemporaryStat(self, player, skillID)

end

function PlayerSkillLogic.afterResetTemporaryStatByFlag(self, player, skillID, flagIndex, value)

end

function PlayerSkillLogic.afterResetTemporaryStatByFlagClient(self, player, skillID, flagIndex)
  if flagIndex == ___MOD._CTS.Morph then
    player.MorphComponent:resetMorphClient(player, skillID, nil)
    player.MorphComponent:resetMorph(player, skillID)
    player.PlayerActionComponent:ladderOnOff(true)
  elseif flagIndex == ___MOD._CTS.TamingMob then
    player.TamingMobComponent:resetTamingMobByBuffClient(player)
    self:applyBattleshipDismountAttackDelay(player, skillID)
    local skillData = ___MOD._SkillManager:getSkill(skillID)
    if skillData ~= nil then
      if ___MOD.isvalid(skillData.effect) then
        ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, nil, 1.0, true)
      end
      if ___MOD.isvalid(skillData.effect0) then
        ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 1, nil, 1.0, true)
      end
    end
    if self:isSkillRidingTamingMobSkill(skillID, player) then
      self:playTamingMobMountSoundClient(player)
    end
  elseif flagIndex == ___MOD._CTS.ShadowPartner then
    player.ShadowPartnerComponent:destroyShadowPartnerClient(player.PlayerControllerComponent.LookDirectionX == -1, nil)
    player.ShadowPartnerComponent:destroyShadowPartner(player, player.PlayerControllerComponent.LookDirectionX == -1)
  elseif flagIndex == ___MOD._CTS.Attract then
    player.PlayerActionComponent:setControllEnable(___MOD._ControllEnableType.CTS_Attract, false)
  elseif flagIndex == ___MOD._CTS.Stun then
    player.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.ActionAnimation, false)
    player.PlayerActionComponent:setControllEnable(___MOD._ControllEnableType.CTS_Stun, false)
    player.PlayerActionComponent:endAttackState()
  end
  if flagIndex == ___MOD._CTS.Attract or flagIndex == ___MOD._CTS.Stun or flagIndex == ___MOD._CTS.Seal then
    local keyDown = player.KeyDownComponent
    if keyDown ~= nil and keyDown.onKeyDown and self:isBigBangSkill(keyDown.skillID) then
      self:cancelActiveKeyDownForNotice(player)
    end
  end
end

function PlayerSkillLogic.afterResetTemporaryStatClient(self, player, skillID)
  if self:isDarkSightLikeSkill(skillID) then
    if self:isDarkSightSkill(skillID) then
      player.PlayerVariables:setDarkSightStartTimeClient(0)
    end
    local hasOtherDarkSightLike = false
    if self:isDarkSightSkill(skillID) then
      hasOtherDarkSightLike = player.PlayerTemporaryStatComponent:getTemporaryStatData(___MOD._CTS.WindWalk) ~= nil
    elseif self:isWindWalkSkill(skillID) then
      hasOtherDarkSightLike = player.PlayerTemporaryStatComponent:getTemporaryStatData(___MOD._CTS.DarkSight) ~= nil
    end
    if hasOtherDarkSightLike then
      self:setAvatarAlphaClient(player, 0.55)
      self:setAvatarAlpha(player, 0.55)
    else
      self:setAvatarAlphaClient(player, 1.0)
      self:setAvatarAlpha(player, 1.0)
    end
  elseif skillID == ___MOD._SkillBook.Battleship_522_5221006 then
    player.PlayerActionComponent:ladderOnOff(true)
  elseif skillID == ___MOD._SkillBook.Dash_500_5001005 or skillID == ___MOD._SkillBook.Dash_1500_15001003 then
    self:releaseEffectClient(player, skillID)
    self:releaseEffect(player, skillID)
  elseif self:isMonsterRiderSkill(skillID) and player.PlayerActionComponent.isClimbing then
    local action = "rope"
    if ___MOD._PlayerStateLogic.lastState == "LADDER" then
      action = "ladder"
    end
    player.PlayerActionComponent:doAction(action, -1, player, ___MOD.SpriteAnimClipPlayType.Onetime, 0, 0)
    player.PlayerActionComponent:playActionRemote(action, -1, player, ___MOD.tonumber(___MOD.SpriteAnimClipPlayType.Onetime), 0, 0, player)
  end
  if skillID == ___MOD._MobSkillID.Attract then
    player.PlayerActionComponent:setControllEnable(___MOD._ControllEnableType.CTS_Attract, false)
    player.MovementComponent:Stop()
    player.RigidbodyComponent:SetForce(___MOD.FastVector2.zero:Clone())
    player.PlayerActionComponent.attractValue = nil
  elseif skillID == ___MOD._MobSkillID.ReverseInput then
    player.ExtendPlayerControllerComponent:SetActionKey(___MOD.KeyboardKey.RightArrow, "MoveRight")
    player.ExtendPlayerControllerComponent:SetActionKey(___MOD.KeyboardKey.LeftArrow, "MoveLeft")
  elseif skillID == ___MOD._MobSkillID.Fear then
    if player.PlayerVariables.viewRange ~= nil then
      player.PlayerVariables.viewRange:Destroy()
    end
  elseif skillID == ___MOD._MobSkillID.StopMotion then
    player.PlayerActionComponent.stopMotion = false
  elseif skillID == ___MOD._MobSkillID.Weakness then
    player.PlayerActionComponent.weakness = false
  end
end

function PlayerSkillLogic.afterSetTemporaryStat(self, player, skillID)

end

function PlayerSkillLogic.afterSetTemporaryStatByFlagClient(self, player, skillID, flagIndex, value)
  if flagIndex == ___MOD._CTS.Morph then
    player.MorphComponent:setMorphClient(player, skillID, value, player.PlayerControllerComponent.LookDirectionX == -1, nil, true)
    player.MorphComponent:setMorph(player, skillID, value, player.PlayerControllerComponent.LookDirectionX == -1, true)
    player.PlayerActionComponent:ladderOnOff(true)
  elseif flagIndex == ___MOD._CTS.TamingMob then
    player.TamingMobComponent:setTamingMobByBuffClient(player, value)
    self:interruptHurricaneSkillsByAbnormalStatus(player)
    if self:isSkillRidingTamingMobSkill(skillID, player) then
      self:playTamingMobMountSoundClient(player)
    end
  elseif flagIndex == ___MOD._CTS.ShadowPartner then
    player.ShadowPartnerComponent:setShadowPartnerClient(player, skillID, player.PlayerControllerComponent.LookDirectionX == -1, nil)
    player.ShadowPartnerComponent:setShadowPartner(player, skillID, player.PlayerControllerComponent.LookDirectionX == -1)
  elseif flagIndex == ___MOD._CTS.Attract then
    player.PlayerActionComponent:setControllEnable(___MOD._ControllEnableType.CTS_Attract, true)
    self:interruptHurricaneSkillsByAbnormalStatus(player)
  elseif flagIndex == ___MOD._CTS.Stun then
    player.PlayerActionComponent:setControllEnable(___MOD._ControllEnableType.CTS_Stun, true)
    self:interruptHurricaneSkillsByAbnormalStatus(player)
  elseif flagIndex == ___MOD._CTS.Seal then
    self:interruptHurricaneSkillsByAbnormalStatus(player)
  end
end

function PlayerSkillLogic.afterSetTemporaryStatClient(self, player, skillID)
  if self:isDarkSightSkill(skillID) then
    local now = ___MOD._UtilLogic.ServerElapsedSeconds
    player.PlayerVariables:setDarkSightStartTimeClient(now)
    player.PlayerVariables:setAssassinateDarkSightElapsedSecClient(0)
    self:setAvatarAlphaClient(player, 0.55)
    self:setAvatarAlpha(player, 0.55)
  elseif self:isWindWalkSkill(skillID) then
    self:setAvatarAlphaClient(player, 0.55)
    self:setAvatarAlpha(player, 0.55)
  elseif skillID == ___MOD._SkillBook.Battleship_522_5221006 then
    player.PlayerActionComponent:ladderOnOff(false)
  elseif skillID == ___MOD._SkillBook.Dash_500_5001005 or skillID == ___MOD._SkillBook.Dash_1500_15001003 then
    local skillData = ___MOD._SkillManager:getSkill(skillID)
    if skillData ~= nil then
      self:releaseEffectClient(player, skillID)
      self:releaseEffect(player, skillID)
      self:playEffect(player, skillID, skillData.special)
    end
  elseif self:isMonsterRiderSkill(skillID) and player.PlayerActionComponent.isClimbing then
    local action = "rope"
    if ___MOD._PlayerStateLogic.lastState == "LADDER" then
      action = "ladder"
    end
    player.PlayerActionComponent:doAction(action, -1, player, ___MOD.SpriteAnimClipPlayType.Loop, 0, 0)
    player.PlayerActionComponent:playActionRemote(action, -1, player, ___MOD.tonumber(___MOD.SpriteAnimClipPlayType.Loop), 0, 0, player)
  end
  local msid = ___MOD._MobSkillID
  if skillID == msid.Seal then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "스킬이 봉인되어 사용이 불가능합니다.")
  elseif skillID == msid.Darkness then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "암흑 상태에 걸려 명중률이 저하됩니다.")
  elseif skillID == msid.Weakness then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "허약 상태가 되어 점프를 할 수 없습니다.")
    player.PlayerActionComponent.weakness = true
  elseif skillID == msid.Stun then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "스턴 상태에 걸려 움직일 수 없습니다.")
  elseif skillID == msid.Curse then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "저주에 걸려 획득하는 경험치가 줄어듭니다.")
  elseif skillID == msid.Attract then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "유혹에 걸려 움직임을 제어당합니다.")
    player.PlayerActionComponent.attractValue = player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.Attract)
  elseif skillID == msid.ReverseInput then
    player.ExtendPlayerControllerComponent:SetActionKey(___MOD.KeyboardKey.LeftArrow, "MoveRight")
    player.ExtendPlayerControllerComponent:SetActionKey(___MOD.KeyboardKey.RightArrow, "MoveLeft")
  elseif skillID == msid.StopMotion then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "어둠의 그림자에 씌여 계속 움직이지 않으면 데미지를 입게 됩니다.")
    player.PlayerActionComponent.stopMotion = true
  elseif skillID == msid.Fear then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "어둠의 공포가 덮쳐왔다! 시야가 좁아집니다.")
    local viewRagne = ___MOD._SpawnService:SpawnByModelId(___MOD._EntryService:GetModelIdByName("Model_Viewrange"), "Viewrange", ___MOD.FastVector3(0, 0.35, 0), ___MOD._UserService.LocalPlayer)
    player.PlayerVariables.viewRange = viewRagne
  elseif skillID == msid.Poison then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "독에 중독되어 체력(HP)이 서서히 감소합니다.")
  elseif skillID == msid.Undead then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "언데드가 되어 힐에 데미지를 입고, 회복약 효과가 반감됩니다")
  elseif skillID == msid.StopPotion then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.System, "물약을 사용할 수 없는 상태입니다.")
  end
end

function PlayerSkillLogic.appendEffectEntityClientWithRenderSkillID(self, player, data, storageSkillID, renderSkillID)
  self:appendEffectEntityClientWithRenderSkillIDAndKey(player, data, storageSkillID, renderSkillID, "skillLoopAnim")
end

function PlayerSkillLogic.appendEffectEntityClientWithRenderSkillIDAndKey(self, player, data, storageSkillID, renderSkillID, keyName)
  local isFaceLeft = player.ExtendPlayerControllerComponent.LookDirectionX == -1
  local ret = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, renderSkillID, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), data, true, isFaceLeft, keyName)
  if ___MOD.type(ret) == "table" then
    for i = 1, #ret do
      local e = ret[i]
      if ___MOD.isvalid(e) then
        e:SetVisible(true)
      end
    end
  end
  self:applySpecialLoopEffectPlacement(storageSkillID, ret)
  if ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId] == nil then
    ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId] = {}
  end
  local prev = ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId][storageSkillID]
  local merged = {}
  if ___MOD.type(prev) == "table" then
    for i = 1, #prev do
      merged[#merged + 1] = prev[i]
    end
  elseif prev ~= nil then
    merged[#merged + 1] = prev
  end
  if ___MOD.type(ret) == "table" then
    for i = 1, #ret do
      merged[#merged + 1] = ret[i]
    end
  elseif ret ~= nil then
    merged[#merged + 1] = ret
  end
  ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId][storageSkillID] = merged
end

function PlayerSkillLogic.appendEffectEntityWithRenderSkillID(self, player, data, storageSkillID, renderSkillID, senderUserId)

end

function PlayerSkillLogic.appendEffectEntityWithRenderSkillIDAndKey(self, player, data, storageSkillID, renderSkillID, keyName, senderUserId)

end

function PlayerSkillLogic.appendEffectWithRenderSkillID(self, player, storageSkillID, renderSkillID, data)
  self:appendEffectWithRenderSkillIDAndKey(player, storageSkillID, renderSkillID, data, "skillLoopAnim")
end

function PlayerSkillLogic.appendEffectWithRenderSkillIDAndKey(self, player, storageSkillID, renderSkillID, data, keyName)
  if data ~= nil then
    self:appendEffectEntityClientWithRenderSkillIDAndKey(player, data, storageSkillID, renderSkillID, keyName)
    self:appendEffectEntityWithRenderSkillIDAndKey(player, data, storageSkillID, renderSkillID, keyName)
  end
end

function PlayerSkillLogic.appendTrackedLoopEffectForState(self, state, fieldName, player, skillID, data)
  if data == nil then
    return
  end
  local ret = ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, data, 1.0)
  local merged = {}
  local prev = state[fieldName]
  if ___MOD.type(prev) == "table" then
    for i = 1, #prev do
      merged[#merged + 1] = prev[i]
    end
  elseif prev ~= nil then
    merged[#merged + 1] = prev
  end
  if ___MOD.type(ret) == "table" then
    for i = 1, #ret do
      merged[#merged + 1] = ret[i]
    end
  elseif ret ~= nil then
    merged[#merged + 1] = ret
  end
  state[fieldName] = merged
end

function PlayerSkillLogic.applyBattleshipDismountAttackDelay(self, player, skillID)
  if skillID ~= ___MOD._SkillBook.Battleship_522_5221006 then
    return
  end
  if player == nil or player.PlayerActionComponent == nil then
    return
  end
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  local pa = player.PlayerActionComponent
  pa.enableNextAttackTime = currentTime + 0.3
  pa.enableNextBuffTime = ___MOD.math.min(pa.enableNextBuffTime, currentTime + 0.1)
end

function PlayerSkillLogic.applyResetAllSkillCooldowns(self, player, exceptSkillID)
  if player == nil or player.PlayerVariables == nil then
    return
  end
  local prevCooltimes = player.PlayerVariables.skillCooltimes or {}
  local prevCanUseSkills = player.PlayerVariables.canUseSkills or {}
  local keepCooltimes = {}
  local keepCanUseSkills = {}
  local coolEnd = ___MOD.tonumber(prevCooltimes[exceptSkillID]) or ___MOD.tonumber(prevCooltimes[___MOD.tostring(exceptSkillID)])
  if coolEnd ~= nil and coolEnd ~= 0 then
    keepCooltimes[exceptSkillID] = coolEnd
  end
  local canUseTime = ___MOD.tonumber(prevCanUseSkills[exceptSkillID]) or ___MOD.tonumber(prevCanUseSkills[___MOD.tostring(exceptSkillID)])
  if canUseTime ~= nil and canUseTime ~= 0 then
    keepCanUseSkills[exceptSkillID] = canUseTime
  end
  player.PlayerVariables.skillCooltimes = keepCooltimes
  player.PlayerVariables.canUseSkills = keepCanUseSkills
end

function PlayerSkillLogic.applySkillLevelDataCooldown(self, player, skillID, skillLevelData, currentTime)
  local cooldownSec = self:getSkillLevelDataCooltimeSec(skillLevelData, skillID)
  if cooldownSec <= 0 then
    return
  end
  local newEndTime = currentTime + cooldownSec
  local prevEndTime = self:getSkillCooldownEndTime(player, skillID)
  if newEndTime < prevEndTime then
    newEndTime = prevEndTime
  end
  self:setSkillCooldownEndTime(player, skillID, newEndTime)
end

function PlayerSkillLogic.applySpecialLoopEffectPlacement(self, storageSkillID, ret)
  if storageSkillID ~= self:getRapidFireKeydown0StorageSkillID(___MOD._SkillBook.Rapid_Fire_522_5221004) then
    return
  end
  local entities = {}
  if ___MOD.type(ret) == "table" then
    entities = ret
  elseif ret ~= nil then
    entities[1] = ret
  end
  for i = 1, #entities do
    local e = entities[i]
    if ___MOD.isvalid(e) and ___MOD.isvalid(e.TransformComponent) then
      e.TransformComponent.Position.z = ___MOD._ZLayer:getRear()
    end
  end
end

function PlayerSkillLogic.applySwimFlyPoseForHurricane(self, player)
  if player == nil or player.PlayerActionComponent == nil then
    return
  end
  ___MOD._PlayerStateLogic:changeState(player, "FLY")
  player.PlayerActionComponent:doAction("fly", -1, player, ___MOD.SpriteAnimClipPlayType.ZigzagLoop, 0, 2)
end

function PlayerSkillLogic.applyTamingMobSecondaryTemporaryStats(self, player, ctsData, tamingMobId)
  if player == nil or ___MOD.type(ctsData) ~= "table" or tamingMobId <= 0 then
    return
  end
  ctsData[___MOD._CTS.TamingMob] = tamingMobId
end

function PlayerSkillLogic.calculateFlashJumpForce(self, velocityY, level)
  local minY = -0.03
  local maxY = 0.08
  local lv1_minX, lv1_maxX = 2.3, 4.6
  local lv1_minY, lv1_maxY = 2.3, 3.7
  local lv20_minX, lv20_maxX = 3.5, 6.2
  local lv20_minY, lv20_maxY = 3.5, 4.3
  local clampedLevel = ___MOD.math.max(1, ___MOD.math.min(20, level))
  local levelT = (clampedLevel - 1) / 19
  local minX = lv1_minX + levelT * (lv20_minX - lv1_minX)
  local maxX = lv1_maxX + levelT * (lv20_maxX - lv1_maxX)
  local minForceY = lv1_minY + levelT * (lv20_minY - lv1_minY)
  local maxForceY = lv1_maxY + levelT * (lv20_maxY - lv1_maxY)
  local clampedY = ___MOD.math.max(minY, ___MOD.math.min(maxY, velocityY))
  local velocityT = (clampedY - minY) / (maxY - minY)
  local forceX = minX + velocityT * (maxX - minX)
  local forceY = minForceY + velocityT * (maxForceY - minForceY)
  return forceX, forceY
end

function PlayerSkillLogic.cancelActiveKeyDownForNotice(self, player)
  if not ___MOD.isvalid(player) or player.KeyDownComponent == nil or not player.KeyDownComponent.onKeyDown then
    return
  end
  local skillID = ___MOD.tonumber(player.KeyDownComponent.skillID) or 0
  if skillID <= 0 then
    player.KeyDownComponent:endKeyDown()
    return
  end
  if self:isHurricaneSkillGroup(skillID) then
    self:finishHurricaneKeydown(player, skillID, ___MOD._SkillManager:getSkill(skillID), true)
    return
  end
  if self:isPiercingSkill(skillID) then
    self:finishPiercingKeydown(player, skillID, ___MOD._SkillManager:getSkill(skillID), true)
    return
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  local skillLevel = player.SkillComponent ~= nil and player.SkillComponent:getSkillLevel(skillID) or 0
  local skillLevelData = skillData ~= nil and skillData.level[skillLevel] or nil
  if skillData ~= nil and skillLevelData ~= nil then
    self:onKeyDown(player, false, true, skillData, skillLevelData, skillID)
  else
    player.KeyDownComponent:endKeyDown()
  end
end

function PlayerSkillLogic.canStartHurricanePrepare(self, player, currentTime)
  local state = self:getHurricaneState(player)
  local nextPrepareTime = ___MOD.tonumber(state.nextPrepareTime) or 0
  return currentTime >= nextPrepareTime
end

function PlayerSkillLogic.canUseBuffSkillByWeaponSilent(self, skillID, weaponInfo)
  if weaponInfo == nil then
    return false
  end
  if skillID == ___MOD._SkillBook.Sword_Booster_110_1101004 or skillID == ___MOD._SkillBook.Sword_Booster_120_1201004 or skillID == ___MOD._SkillBook.Sword_Booster_1110_11101001 then
    return weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD
  elseif skillID == ___MOD._SkillBook.Axe_Booster_110_1101005 then
    return weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_AXE
  elseif skillID == ___MOD._SkillBook.Bow_Booster_310_3101002 or skillID == ___MOD._SkillBook.Bow_Booster_1310_13101001 or skillID == ___MOD._SkillBook.Soul_Arrow__Bow_310_3101004 or skillID == ___MOD._SkillBook.Soul_Arrow_1310_13101003 then
    return weaponInfo.weaponType == ___MOD._WeaponType.BOW
  elseif skillID == ___MOD._SkillBook.Crossbow_Booster_320_3201002 or skillID == ___MOD._SkillBook.Soul_Arrow__Crossbow_320_3201004 then
    return weaponInfo.weaponType == ___MOD._WeaponType.CROSSBOW
  elseif skillID == ___MOD._SkillBook.Claw_Booster_1410_14101002 or skillID == ___MOD._SkillBook.Claw_Booster_410_4101003 then
    return weaponInfo.weaponType == ___MOD._WeaponType.CLAW
  elseif skillID == ___MOD._SkillBook.Dagger_Booster_420_4201002 then
    return weaponInfo.weaponType == ___MOD._WeaponType.DAGGER
  elseif skillID == ___MOD._SkillBook.BW_Booster_120_1201005 then
    return weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_MACE
  elseif skillID == ___MOD._SkillBook.Spear_Booster_130_1301004 then
    return weaponInfo.weaponType == ___MOD._WeaponType.SPEAR
  elseif skillID == ___MOD._SkillBook.Polearm_Booster_2100_21001003 or skillID == ___MOD._SkillBook.Pole_Arm_Booster_130_1301005 then
    return weaponInfo.weaponType == ___MOD._WeaponType.POLEARM
  elseif skillID == ___MOD._SkillBook.Snow_Charge_2111_21111005 or skillID == ___MOD._SkillBook.Smart_Knockback_2111_21111001 then
    return weaponInfo.weaponType == ___MOD._WeaponType.POLEARM
  elseif skillID == ___MOD._SkillBook.Gun_Booster_520_5201003 then
    return weaponInfo.weaponType == ___MOD._WeaponType.GUN
  elseif skillID == ___MOD._SkillBook.Knuckler_Booster_510_5101006 or skillID == ___MOD._SkillBook.Knuckle_Booster_1510_15101002 then
    return weaponInfo.weaponType == ___MOD._WeaponType.KNUCKLE
  elseif skillID == ___MOD._SkillBook.Katara_Booster_430_4301002 then
    return weaponInfo.weaponType == ___MOD._WeaponType.BLADE
  elseif skillID == ___MOD._SkillBook.Fire_Charge_Sword_121_1211003 or skillID == ___MOD._SkillBook.Ice_Charge_Sword_121_1211005 or skillID == ___MOD._SkillBook.Thunder_Charge_Sword_121_1211007 or skillID == ___MOD._SkillBook.Holy_Charge__Sword_122_1221003 then
    return weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD
  elseif skillID == ___MOD._SkillBook.Flame_Charge_BW_121_1211004 or skillID == ___MOD._SkillBook.Blizzard_Charge_BW_121_1211006 or skillID == ___MOD._SkillBook.Lightning_Charge_BW_121_1211008 or skillID == ___MOD._SkillBook.Divine_Charge__BW_122_1221004 then
    return weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_MACE
  elseif skillID == ___MOD._SkillBook.Spell_Booster_211_2111005 or skillID == ___MOD._SkillBook.Spell_Booster_221_2211005 or skillID == ___MOD._SkillBook.Spell_Booster_1210_12101004 or skillID == ___MOD._SkillBook.Magic_Booster_2214_22141002 then
    return weaponInfo.weaponType == ___MOD._WeaponType.STAFF or weaponInfo.weaponType == ___MOD._WeaponType.WAND
  end
  return true
end

function PlayerSkillLogic.canUseHurricaneArrow(self, player)
  if player == nil or player.CInventoryComponent == nil then
    return false
  end
  if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 then
    return true
  end
  local itemId, count, slot = player.CInventoryComponent:findFirstThrowing(1)
  return itemId ~= 0 and 1 <= count and slot ~= 0
end

function PlayerSkillLogic.canUseMonsterRiderSkill(self, player)
  if player == nil or player.EquipmentComponent == nil then
    return false
  end
  local eq = player.EquipmentComponent
  return eq:hasSlotItem(___MOD._EquipmentSlotType.TAMINGMOB, ___MOD._EquipmentSubSlotType.MAIN) and eq:hasSlotItem(___MOD._EquipmentSlotType.SADDLE, ___MOD._EquipmentSubSlotType.MAIN)
end

function PlayerSkillLogic.canUseSkillOnBattleship(self, skillID)
  local sb = ___MOD._SkillBook
  return skillID == sb.Battleship_Cannon_522_5221007 or skillID == sb.Battleship_Torpedo_522_5221008 or skillID == sb.Grenade_520_5201002 or skillID == sb.Gun_Booster_520_5201003 or skillID == sb.Flamethrower_521_5211004 or skillID == sb.Ice_Splitter_521_5211005 or skillID == sb.Gaviota_521_5211002 or skillID == sb.Octopus_521_5211001 or skillID == sb.Wrath_of_the_Octopi_522_5220002 or skillID == sb.Maple_Warrior_522_5221000 or skillID == 5221010
end

function PlayerSkillLogic.checkCanUseSkillByWeapon(self, skillID, weaponInfo)
  local f = false
  if skillID == ___MOD._SkillBook.Sword_Booster_110_1101004 or skillID == ___MOD._SkillBook.Sword_Booster_120_1201004 or skillID == ___MOD._SkillBook.Sword_Booster_1110_11101001 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Axe_Booster_110_1101005 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_AXE then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Bow_Booster_310_3101002 or skillID == ___MOD._SkillBook.Bow_Booster_1310_13101001 or skillID == ___MOD._SkillBook.Soul_Arrow__Bow_310_3101004 or skillID == ___MOD._SkillBook.Soul_Arrow_1310_13101003 then
    if weaponInfo.weaponType == ___MOD._WeaponType.BOW then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Crossbow_Booster_320_3201002 or skillID == ___MOD._SkillBook.Soul_Arrow__Crossbow_320_3201004 then
    if weaponInfo.weaponType == ___MOD._WeaponType.CROSSBOW then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Claw_Booster_1410_14101002 or skillID == ___MOD._SkillBook.Claw_Booster_410_4101003 then
    if weaponInfo.weaponType == ___MOD._WeaponType.CLAW then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Dagger_Booster_420_4201002 then
    if weaponInfo.weaponType == ___MOD._WeaponType.DAGGER then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.BW_Booster_120_1201005 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_MACE then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Spear_Booster_130_1301004 then
    if weaponInfo.weaponType == ___MOD._WeaponType.SPEAR then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Polearm_Booster_2100_21001003 or skillID == ___MOD._SkillBook.Polearm_Booster_2100_21001003 then
    if weaponInfo.weaponType == ___MOD._WeaponType.POLEARM then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Snow_Charge_2111_21111005 or skillID == ___MOD._SkillBook.Smart_Knockback_2111_21111001 then
    if weaponInfo.weaponType == ___MOD._WeaponType.POLEARM then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Gun_Booster_520_5201003 then
    if weaponInfo.weaponType == ___MOD._WeaponType.GUN then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Knuckler_Booster_510_5101006 or skillID == ___MOD._SkillBook.Knuckle_Booster_1510_15101002 then
    if weaponInfo.weaponType == ___MOD._WeaponType.KNUCKLE then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Katara_Booster_430_4301002 then
    if weaponInfo.weaponType == ___MOD._WeaponType.BLADE then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Spell_Booster_211_2111005 or skillID == ___MOD._SkillBook.Spell_Booster_221_2211005 or skillID == ___MOD._SkillBook.Spell_Booster_1210_12101004 or skillID == ___MOD._SkillBook.Magic_Booster_2214_22141002 then
    if weaponInfo.weaponType == ___MOD._WeaponType.STAFF or weaponInfo.weaponType == ___MOD._WeaponType.WAND then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Panic_1111_11111002 or skillID == ___MOD._SkillBook.Panic__Sword_111_1111003 or skillID == ___MOD._SkillBook.Coma_1111_11111003 or skillID == ___MOD._SkillBook.Coma_Sword_111_1111005 or skillID == ___MOD._SkillBook.Fire_Charge_Sword_121_1211003 or skillID == ___MOD._SkillBook.Ice_Charge_Sword_121_1211005 or skillID == ___MOD._SkillBook.Thunder_Charge_Sword_121_1211007 or skillID == ___MOD._SkillBook.Holy_Charge__Sword_122_1221003 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Panic__Axe_111_1111004 or skillID == ___MOD._SkillBook.Coma_Axe_111_1111006 or skillID == ___MOD._SkillBook.Panic_1111_11111002 or skillID == ___MOD._SkillBook.Coma_1111_11111003 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_AXE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_AXE then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Flame_Charge_BW_121_1211004 or skillID == ___MOD._SkillBook.Blizzard_Charge_BW_121_1211006 or skillID == ___MOD._SkillBook.Lightning_Charge_BW_121_1211008 or skillID == ___MOD._SkillBook.Divine_Charge__BW_122_1221004 then
    if weaponInfo.weaponType == ___MOD._WeaponType.ONE_HANDED_MACE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_MACE then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Three_Snails_000_1000 or skillID == ___MOD._SkillBook.Three_Snails_1000_10001000 or skillID == ___MOD._SkillBook.Three_Snails_2000_20001000 or skillID == ___MOD._SkillBook.Three_Snails_2001_20011000 then
    if weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_AXE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_MACE or weaponInfo.weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD or weaponInfo.weaponType == ___MOD._WeaponType.SPEAR or weaponInfo.weaponType == ___MOD._WeaponType.POLEARM or weaponInfo.weaponType == ___MOD._WeaponType.BARE_HANDS or weaponInfo.weaponType == ___MOD._WeaponType.CLAW or weaponInfo.weaponType == ___MOD._WeaponType.CROSSBOW or weaponInfo.weaponType == ___MOD._WeaponType.BOW or weaponInfo.weaponType == ___MOD._WeaponType.GUN or weaponInfo.weaponType == ___MOD._WeaponType.KNUCKLE then
      ___MOD._UserService.LocalPlayer.PlayerActionComponent:displayAttackMessage("한손 무기를 장착한 상태에서만 스킬을 사용할 수 있습니다.")
      return
    end
  elseif skillID == ___MOD._SkillBook.Energy_Bolt_200_2001004 or skillID == ___MOD._SkillBook.Magic_Claw_200_2001005 or skillID == ___MOD._SkillBook.Magic_Claw_1200_12001003 or skillID == ___MOD._SkillBook.Cold_Beam_220_2201004 or skillID == ___MOD._SkillBook.Thunder_Bolt_220_2201005 then
    if weaponInfo.weaponType ~= ___MOD._WeaponType.TWO_HANDED_AXE and weaponInfo.weaponType ~= ___MOD._WeaponType.TWO_HANDED_MACE and weaponInfo.weaponType ~= ___MOD._WeaponType.TWO_HANDED_SWORD and weaponInfo.weaponType ~= ___MOD._WeaponType.SPEAR and weaponInfo.weaponType ~= ___MOD._WeaponType.POLEARM and weaponInfo.weaponType ~= ___MOD._WeaponType.BARE_HANDS and weaponInfo.weaponType ~= ___MOD._WeaponType.CLAW and weaponInfo.weaponType ~= ___MOD._WeaponType.CROSSBOW and weaponInfo.weaponType ~= ___MOD._WeaponType.BOW and weaponInfo.weaponType ~= ___MOD._WeaponType.GUN and weaponInfo.weaponType ~= ___MOD._WeaponType.KNUCKLE then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Spear_Booster_130_1301004 then
    if weaponInfo.weaponType == ___MOD._WeaponType.SPEAR then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Pole_Arm_Booster_130_1301005 then
    if weaponInfo.weaponType == ___MOD._WeaponType.POLEARM then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Double_Shot_500_5001003 then
    if weaponInfo.weaponType == ___MOD._WeaponType.GUN then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Brandish_112_1121008 or skillID == ___MOD._SkillBook.Brandish_1111_11111004 then
    if weaponInfo.weaponType == ___MOD._WeaponType.SPEAR then
      ___MOD._UserService.LocalPlayer.PlayerActionComponent:displayAttackMessage("장착한 무기로는 사용할 수 없는 스킬입니다.")
      return false
    end
  elseif skillID == ___MOD._SkillBook.Recoil_Shot_520_5201006 then
    if weaponInfo.weaponType == ___MOD._WeaponType.GUN then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Hurricane_312_3121004 or skillID == ___MOD._SkillBook.Hurricane_1311_13111002 then
    if weaponInfo.weaponType == ___MOD._WeaponType.BOW then
      return true
    end
    f = true
  elseif skillID == ___MOD._SkillBook.Double_Shot_300_3001005 or skillID == ___MOD._SkillBook.Double_Shot_1300_13001003 or skillID == ___MOD._SkillBook.Arrow_Blow_300_3001004 then
    if weaponInfo.weaponType == ___MOD._WeaponType.BOW or weaponInfo.weaponType == ___MOD._WeaponType.CROSSBOW then
      return true
    end
    f = true
  end
  if f then
    if weaponInfo.valid then
      ___MOD._UserService.LocalPlayer.PlayerActionComponent:displayAttackMessage("장착한 무기로는 사용할 수 없는 스킬입니다.")
    else
      ___MOD._UserService.LocalPlayer.PlayerActionComponent:displayAttackMessage("무기를 장착하지 않아 공격할 수 없습니다.")
    end
    return false
  end
  return true
end

function PlayerSkillLogic.checkHurricaneConsumeClient(self, player, skillID, skillLevelData, currentTime)
  local itemId, count, slot = player.CInventoryComponent:findFirstThrowing(0)
  local result = ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(player, skillID, skillLevelData, itemId, count, 1)
  if result ~= 0 then
    local pa = player.PlayerActionComponent
    pa.enableNextBuffTime = currentTime + 0.1
    pa.enableNextAttackTime = ___MOD.math.max(pa.enableNextAttackTime, currentTime + 0.1)
    return false
  end
  return true
end

function PlayerSkillLogic.checkHurricaneLikeUseConsumeClient(self, player, skillID, skillLevelData, currentTime)
  return self:checkHurricaneConsumeClient(player, skillID, skillLevelData, currentTime)
end

function PlayerSkillLogic.checkPrepare(self, player, skillID, skillLevel, skillData)
  local hurricaneState = self:getHurricaneState(player)
  local piercingState = self:getPiercingState(player)
  if skillID == ___MOD._SkillBook.Explosion_211_2111002 or skillID == ___MOD._SkillBook.Big_Bang_212_2121001 or skillID == ___MOD._SkillBook.Big_Bang_222_2221001 or skillID == ___MOD._SkillBook.Big_Bang_232_2321001 or ___MOD._SkillLogic:isThrowBombSkill(skillID) then
    return false
  end
  local prepare = skillData.prepare
  if prepare ~= nil then
    if skillID == ___MOD._SkillBook.Chakra_421_4211001 then
      player.PlayerVariables:setOnChakraClient(true)
      player.PlayerVariables:setOnChakra(true)
    end
    if self:isHurricaneSkillGroup(skillID) then
      player.PlayerActionComponent:playOnceAndFreezeLastFrameClient(prepare.action, 1.0, player, true, ___MOD._ControllEnableType.Hurricane)
      player.PlayerActionComponent:startRemoteKeydownAction(skillID, prepare.action, player)
    elseif self:isPiercingSkill(skillID) then
      player.PlayerActionComponent:playOnceClient(prepare.action, 1.0, player, false, true)
      player.PlayerActionComponent:playOnce(prepare.action, 1.0, player)
      player.PlayerActionComponent:setControllEnable(___MOD._ControllEnableType.SkillUseDelay, false)
      player.PlayerActionComponent:ladderOnOff(true)
    else
      player.PlayerActionComponent:playOnceClient(prepare.action, 1.0, player, false, true)
    end
    if prepare.anim ~= nil then
      if self:isHurricaneSkillGroup(skillID) then
        self:playTrackedPrepareEffect(player, skillID, prepare.anim)
        self:playHurricanePrepareEffectRemote(player, skillID, prepare.anim)
      elseif self:isPiercingSkill(skillID) then
        self:playTrackedPrepareEffectForState(piercingState, player, skillID, prepare.anim)
        self:playPiercingPrepareEffectRemote(player, skillID, prepare.anim)
      else
        ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, prepare.anim, 1.0)
      end
    end
    local soundSkillId = self:getSkillSoundRefId(skillID)
    local skillIdStr = ___MOD.string.format("%07d", soundSkillId)
    ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", skillIdStr), player, 1)
    local prepareDelayMs = ___MOD.tonumber(prepare.totalDelay) or 0
    if prepareDelayMs <= 0 then
      prepareDelayMs = ___MOD.math.floor(player.PlayerActionComponent:getTotalActionDelay(prepare.action) * 1000)
    end
    if prepareDelayMs <= 0 then
      prepareDelayMs = 1
    end
    local prepareDelaySec = prepareDelayMs / 1000
    local token
    if self:isHurricaneSkillGroup(skillID) then
      token = ___MOD.math.floor(___MOD._UtilLogic.ServerElapsedSeconds * 1000)
      hurricaneState.inputLock = true
      hurricaneState.prepareToken = token
      hurricaneState.prepareSkillID = skillID
      hurricaneState.prepareReleased = false
      hurricaneState.loopStarted = false
      self:ensureHurricaneAttackLoop(player, skillID, skillData)
    elseif self:isPiercingSkill(skillID) then
      token = ___MOD.math.floor(___MOD._UtilLogic.ServerElapsedSeconds * 1000)
      piercingState.inputLock = true
      piercingState.prepareToken = token
      piercingState.prepareSkillID = skillID
      piercingState.prepareReleased = false
      piercingState.loopStarted = false
      local keyDown = player.KeyDownComponent
      if keyDown ~= nil and (not keyDown.onKeyDown or keyDown.skillID ~= skillID) then
        keyDown:startKeyDown(skillID, 2)
      end
      self:startPiercingKeydownFacingSyncClient(player, skillID)
      self:startPiercingKeydownFacingSync(player, skillID)
    end
    ___MOD._TimerService:SetTimerOnce(function()
      if self:isHurricaneSkillGroup(skillID) then
        local callbackState = self:getHurricaneState(player)
        if callbackState.prepareToken ~= token or callbackState.prepareReleased == true then
          if callbackState.prepareToken == token then
            callbackState.prepareToken = nil
            callbackState.prepareSkillID = nil
          end
          return
        end
      elseif self:isPiercingSkill(skillID) then
        local callbackState = self:getPiercingState(player)
        if callbackState.prepareToken ~= token or callbackState.prepareReleased == true then
          if callbackState.prepareToken == token then
            callbackState.prepareToken = nil
            callbackState.prepareSkillID = nil
          end
          return
        end
      end
      self:tryUseSkillClient(player, skillID, skillLevel, false, false, true)
    end, prepareDelaySec)
    if not self:isHurricaneSkillGroup(skillID) and not self:isPiercingSkill(skillID) then
      player.PlayerActionComponent.enableNextBuffTime = ___MOD._UtilLogic.ServerElapsedSeconds + prepareDelaySec
    end
    return true
  end
  if self:isHurricaneSkillGroup(skillID) then
    hurricaneState.inputLock = false
    self:releaseTrackedEffectEntities(hurricaneState.prepareEffectEntities)
    hurricaneState.prepareEffectEntities = nil
  elseif self:isPiercingSkill(skillID) then
    piercingState.inputLock = false
    self:releaseTrackedEffectEntities(piercingState.prepareEffectEntities)
    piercingState.prepareEffectEntities = nil
  end
  return false
end

function PlayerSkillLogic.clearAssassinateFollowUpTimer(self, state)
  local h = state ~= nil and state.followUpTimer or nil
  if h ~= nil then
    ___MOD._TimerService:ClearTimer(h)
    state.followUpTimer = nil
  end
end

function PlayerSkillLogic.clearHurricaneAttackLoop(self, state)
  local h = state ~= nil and state.attackLoopTimer or nil
  if h ~= nil then
    ___MOD._TimerService:ClearTimer(h)
    state.attackLoopTimer = nil
  end
end

function PlayerSkillLogic.clearHurricaneKeydownEffects(self, player, skillID)
  self:setVisibleEffectClient(player, skillID, false)
  self:setVisibleEffect(player, skillID, false)
  self:releaseEffectClient(player, skillID)
  self:releaseEffect(player, skillID)
  if self:isRapidFireSkill(skillID) then
    local keydown0StorageSkillID = self:getRapidFireKeydown0StorageSkillID(skillID)
    self:releaseEffectClient(player, keydown0StorageSkillID)
    self:releaseEffect(player, keydown0StorageSkillID)
  end
end

function PlayerSkillLogic.clearInactiveHurricaneEffects(self, player, skillID)
  local state = self:getHurricaneState(player)
  self:releaseHurricaneTrackedEffects(player, skillID, state)
  self:clearHurricaneKeydownEffects(player, skillID)
end

function PlayerSkillLogic.clearPiercingKeydownVisualEffects(self, player, skillID, skillData)
  if skillData ~= nil and skillData.keydown ~= nil then
    self:setVisibleEffectClient(player, skillID, false)
    self:setVisibleEffect(player, skillID, false)
    self:releaseEffectClient(player, skillID)
    self:releaseEffect(player, skillID)
  end
end

function PlayerSkillLogic.clearPlayerRuntimeState(self, player)

end

function PlayerSkillLogic.clearSkillCooldownEndTime(self, player, skillID)
  if player == nil or player.PlayerVariables == nil then
    return
  end
  local cooltimes = player.PlayerVariables.skillCooltimes
  if cooltimes == nil then
    return
  end
  cooltimes[skillID] = nil
  cooltimes[___MOD.tostring(skillID)] = nil
end

function PlayerSkillLogic.clearSkillCooldownEndTimeClient(self, player, skillID)
  self:clearSkillCooldownEndTime(player, skillID)
end

function PlayerSkillLogic.clearStaleProneStateBeforeAttackSkill(self, player, pa, isDownArrowPressed)
  if player ~= ___MOD._UserService.LocalPlayer then
    return
  end
  if player.StateComponent.CurrentStateName ~= "PRONE" then
    return
  end
  if isDownArrowPressed then
    return
  end
  if pa ~= nil and pa.attractValue == 4 then
    return
  end
  local nextState = "IDLE"
  if pa ~= nil and pa.isAlert then
    nextState = "ALERT"
  end
  ___MOD._PlayerStateLogic:changeState(player, nextState)
end

function PlayerSkillLogic.clearTamingMobEntering(self)
  self._T.tamingMobEntering = nil
  self._T.tamingMobEnteringExpire = nil
end

function PlayerSkillLogic.doActiveSkill_Summon(self, user, skillID)
  if user.RigidbodyComponent:GetCurrentFoothold() == nil or user.StateComponent.CurrentStateName == "JUMP" then
    return
  end
  local sb = ___MOD._SkillBook
  local userPos = user.TransformComponent:WorldPositionAsFastVector3()
  local targetX, targetY = userPos.x, userPos.y
  if skillID == sb.Puppet_311_3111002 or skillID == sb.Puppet_321_3211002 or skillID == sb.Puppet_1311_13111004 or skillID == sb.Mirrored_Target_434_4341006 or skillID == sb.Octopus_521_5211001 or skillID == sb.Wrath_of_the_Octopi_522_5220002 then
    if user.PlayerActionComponent.isClimbing then
      return
    end
    local nDistance = 2
    if skillID == sb.Octopus_521_5211001 or skillID == sb.Wrath_of_the_Octopi_522_5220002 then
      nDistance = 0.45
    elseif skillID == sb.Mirrored_Target_434_4341006 then
      nDistance = -0.5
    end
    local curMap = user.CurrentMap
    local mapInfo = curMap.MapInfoComponent
    local mbr = mapInfo:getMapBound()
    local dir = user.PlayerControllerComponent.LookDirectionX == -1 and -1 or 1
    nDistance = nDistance * dir
    targetX = userPos.x + nDistance
    if targetX <= mbr.left + 0.1 then
      targetX = mbr.left + 0.1
    end
    if targetX >= mbr.right - 0.1 then
      targetX = mbr.right - 0.1
    end
    if userPos.x ~= targetX then
      while true do
        local footholdUnderneath, underneathY = ___MOD._FootholdLogic:getFootholdUnderneath_withDistance(curMap, targetX, targetY + 0.02, 0.8)
        local footholdAbove, aboveY = ___MOD._FootholdLogic:getFootholdAbove_withDistance(curMap, targetX, targetY, 0.8)
        if footholdUnderneath then
          if footholdAbove and targetY - underneathY > aboveY - targetY then
            targetY = aboveY + 0.01
            break
          end
          targetY = underneathY + 0.01
          break
        end
        if footholdAbove then
          targetY = aboveY + 0.01
          break
        end
        targetX = targetX - 0.15 * dir
        if targetX * dir <= userPos.x * dir then
          return nil
        end
      end
    end
  end
  return ___MOD.Vector2(targetX, targetY)
end

function PlayerSkillLogic.doActiveSkill_TownPortal(self, user)
  if not user.RigidbodyComponent:IsOnGround() then
    return nil
  end
  local curMap = user.CurrentMap
  local mapInfo = curMap.MapInfoComponent
  if mapInfo:checkFieldLimit(___MOD._FieldLimit.UnableToUseMysticDoor) or mapInfo.town or mapInfo:isEventMap(false) then
    return nil
  end
  local ptUser = user.TransformComponent:WorldPositionAsFastVector3()
  local ux, uy = ptUser.x, ptUser.y
  local portals = mapInfo.portal
  for _, portal in ___MOD.pairs(portals) do
    if portal.portalType ~= ___MOD._PortalType.SpawnPoint_sp_0 then
      local pt = portal.Entity.TransformComponent:WorldPositionAsFastVector3()
      local dx = pt.x - ux
      local dy = pt.y - uy
      if -0.5 <= dx and dx <= 0.5 and -0.5 <= dy and dy <= 0.5 then
        user.PlayerActionComponent:displayAttackMessage("포탈 가까이에서는 미스틱 도어 스킬을 사용하실 수 없습니다.")
        return
      end
    end
  end
  return ___MOD.Vector2(ux, uy)
end

function PlayerSkillLogic.doUseSkill(self, caster, player, skillID, skillLevel, skillData, skillLevelData, fromPartyBuff, totalTargetOnlyPlayer, ctx)

end

function PlayerSkillLogic.doUseSkillByMob(self, player, mob, skillID, skillLevel, skillData, skillLevelData)

end

function PlayerSkillLogic.endActiveKeyDownForUtilDlg(self, player)
  if not ___MOD.isvalid(player) then
    return
  end
  local activeSkillID = 0
  local keyDown = player.KeyDownComponent
  if player.PlayerVariables ~= nil and player.PlayerVariables.hiddenKeydownActive then
    activeSkillID = ___MOD.tonumber(player.PlayerVariables.hiddenKeydownSkillID) or 0
  elseif keyDown ~= nil and keyDown.onKeyDown then
    activeSkillID = ___MOD.tonumber(keyDown.skillID) or 0
  end
  if activeSkillID == 0 then
    return
  end
  local skillLevel = 0
  if player.SkillComponent ~= nil then
    skillLevel = player.SkillComponent:getSkillLevel(activeSkillID)
  end
  if skillLevel <= 0 then
    return
  end
  self:tryUseSkillClient(player, activeSkillID, skillLevel, true, false, false)
end

function PlayerSkillLogic.endWings(self, player, skillID)
  if player.PlayerVariables.wingsTimer ~= nil then
    ___MOD._TimerService:ClearTimer(player.PlayerVariables.wingsTimer)
    player.PlayerVariables.wingsTimer = nil
    if player.PlayerVariables.beforeFallSpeedMaxY > 0 then
      player.RigidbodyComponent.FallSpeedMaxY = player.PlayerVariables.beforeFallSpeedMaxY
    end
    player.PlayerVariables.beforeFallSpeedMaxY = 0
    self:releaseEffectClient(player, skillID)
    self:releaseEffect(player, skillID)
    local skillData = ___MOD._SkillManager:getSkill(skillID)
    if skillData ~= nil then
      ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, skillID, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), skillData.finish, false, false, nil)
      ___MOD._ExtendedEffectService:playSkillAnimationRemote(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, skillID, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), skillData.finish, false, false, nil)
    end
    local skillIdStr = ___MOD.string.format("%07d", skillID)
    local soundPath = ___MOD.string.format("Skill.img.%s.Loop", skillIdStr)
    local ruid = ___MOD.__RUIDManager:get(soundPath)
    ___MOD._SoundUtils:stopLoopSoundLocal(ruid)
  end
end

function PlayerSkillLogic.ensureHurricaneAttackLoop(self, player, skillID, skillData)
  local state = self:getHurricaneState(player)
  if state.attackLoopTimer ~= nil then
    return
  end
  local skillLevel = player.SkillComponent ~= nil and player.SkillComponent:getSkillLevel(skillID) or 0
  local skillLevelData = skillData ~= nil and skillData.level ~= nil and skillData.level[skillLevel] or nil
  if skillLevelData == nil then
    return
  end
  if not self:checkHurricaneConsumeClient(player, skillID, skillLevelData, ___MOD._UtilLogic.ServerElapsedSeconds) then
    self:finishHurricaneKeydown(player, skillID, skillData, true)
    return
  end
  if not self:canUseHurricaneArrow(player) then
    self:handleHurricaneArrowExhausted(player, skillID)
    self:finishHurricaneKeydown(player, skillID, skillData, true)
    return
  end
  if ___MOD._AntiRepeat:tryRepeat(___MOD._AntiRepeatType.Hurricane) then
    self:spawnHurricaneBulletClient(player, skillID)
  end
  state.attackLoopTimer = ___MOD._TimerService:SetTimerRepeat(function()
    local currentState = self:getHurricaneState(player)
    if currentState.inputLock ~= true then
      self:clearHurricaneAttackLoop(currentState)
      return
    end
    if not self:checkHurricaneConsumeClient(player, skillID, skillLevelData, ___MOD._UtilLogic.ServerElapsedSeconds) then
      self:finishHurricaneKeydown(player, skillID, skillData, true)
      return
    end
    if not self:canUseHurricaneArrow(player) then
      self:handleHurricaneArrowExhausted(player, skillID)
      self:finishHurricaneKeydown(player, skillID, skillData, true)
      return
    end
    if ___MOD._AntiRepeat:tryRepeat(___MOD._AntiRepeatType.Hurricane) then
      self:spawnHurricaneBulletClient(player, skillID)
    end
  end, 0.13, 0.13)
end

function PlayerSkillLogic.findMobTargetsFromHitBoxClient(self, player, ctx, skillLevelData)
  if not ___MOD.isvalid(player) or ctx == nil or skillLevelData == nil then
    return
  end
  local lt = skillLevelData.lt
  local rb = skillLevelData.rb
  local mobCount = ___MOD.tonumber(skillLevelData.mobCount) or 0
  if lt == nil or rb == nil or mobCount <= 0 then
    return
  end
  local pos = player.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  local left = player.PlayerControllerComponent.LookDirectionX == -1
  local box = ___MOD._NumberUtils:makeBoxShapeFromLtRb(pos, lt * 100, rb * 100, left)
  local mobs = ___MOD._PlayerAttackLogic:findValidMobs(player, box.Position, box.Size, box.Angle, mobCount, false)
  local targets = {}
  for i = 1, #mobs do
    local mob = mobs[i]
    if ___MOD.isvalid(mob) then
      targets[#targets + 1] = mob
    end
  end
  ctx.mobTargets = targets
end

function PlayerSkillLogic.finishHurricaneKeydown(self, player, skillID, skillData, playKeydownEnd)
  local state = self:getHurricaneState(player)
  if state.ending == true then
    return
  end
  state.ending = true
  state.prepareReleased = true
  state.inputLock = false
  state.loopStarted = false
  self:resetHurricaneHiddenKeydownState(player)
  self:clearHurricaneAttackLoop(state)
  self:releaseHurricaneTrackedEffects(player, skillID, state)
  self:clearHurricaneKeydownEffects(player, skillID)
  if player.PlayerActionComponent ~= nil then
    player.PlayerActionComponent:setMovementLock(___MOD._ControllEnableType.Hurricane, false)
  end
  self:restoreHurricaneActionAfterKeydown(player, state)
  if player.PlayerActionComponent ~= nil then
    player.PlayerActionComponent:endRemoteKeydownAction(skillID, player)
  end
  if player.KeyDownComponent ~= nil and player.KeyDownComponent.onKeyDown then
    player.KeyDownComponent:endKeyDown()
  end
  if playKeydownEnd and skillData ~= nil and skillData.keydownend ~= nil then
    self:playOneShotEffect(player, skillID, skillData.keydownend)
    self:playHurricaneKeydownEndEffectRemote(player, skillID, skillData.keydownend)
  end
  state.prepareToken = nil
  state.prepareSkillID = nil
  state.prepareReleased = false
  state.inputLock = false
  state.loopStarted = false
  state.wasSwimAirborne = false
  state.ending = false
end

function PlayerSkillLogic.finishKeydownControlledAction(self, player)
  local pa = player.PlayerActionComponent
  if pa == nil then
    return
  end
  pa:cancelActionControlClient(player)
  pa:playerActionEnd()
end

function PlayerSkillLogic.finishPiercingKeydown(self, player, skillID, skillData, playKeydownEnd)
  local state = self:getPiercingState(player)
  local chargePer = 0.0
  self:releasePiercingPrepareState(player, skillID, state)
  self:clearPiercingKeydownVisualEffects(player, skillID, skillData)
  self:resetPiercingHiddenKeydownState(player)
  self:restorePiercingActionAfterKeydown(player)
  if player.KeyDownComponent ~= nil and player.KeyDownComponent.onKeyDown then
    chargePer = player.KeyDownComponent:endKeyDown()
  end
  if playKeydownEnd and skillData ~= nil and skillData.keydownend ~= nil then
    self:playOneShotEffect(player, skillID, skillData.keydownend)
    self:playPiercingKeydownEndEffectRemote(player, skillID, skillData.keydownend)
  end
  state.prepareToken = nil
  state.prepareSkillID = nil
  state.prepareReleased = false
  state.inputLock = false
  state.loopStarted = false
  return chargePer
end

function PlayerSkillLogic.forceCleanupRegularKeydownEffect(self, player, skillID)
  self:setVisibleEffectClient(player, skillID, false)
  self:setVisibleEffect(player, skillID, false)
  self:releaseEffectClient(player, skillID)
  self:releaseEffect(player, skillID)
end

function PlayerSkillLogic.forceCleanupRegularKeydownEffectDeferred(self, player, skillID)
  self:forceCleanupRegularKeydownEffect(player, skillID)
  ___MOD._TimerService:SetTimerOnce(function()
    if not ___MOD.isvalid(player) then
      return
    end
    self:forceCleanupRegularKeydownEffect(player, skillID)
  end, 0.15)
end

function PlayerSkillLogic.freezeHurricanePreparePose(self, player, skillData)
  if skillData == nil or skillData.prepare == nil or skillData.prepare.action == nil then
    return
  end
  local actionName = skillData.prepare.action
  local motionData = ___MOD._MotionDataManager:getMotionData(actionName)
  if motionData == nil then
    return
  end
  local frameCount = #motionData
  if frameCount <= 0 then
    return
  end
  local pa = player.PlayerActionComponent
  if pa == nil then
    return
  end
  pa:freezeLastFrameClient(actionName, player, true, ___MOD._ControllEnableType.Hurricane)
end

function PlayerSkillLogic.getActiveHiddenKeydownSkillID(self, player)
  if player == nil or player.PlayerVariables == nil then
    return 0
  end
  if player.PlayerVariables.hiddenKeydownActive ~= true then
    return 0
  end
  return ___MOD.tonumber(player.PlayerVariables.hiddenKeydownSkillID) or 0
end

function PlayerSkillLogic.getAssassinateFollowUpDelaySec(self, player, skillID)
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData ~= nil and skillData.action ~= nil then
    local totalDelay = ___MOD.tonumber(skillData.action.totalDelay) or 0
    if 0 < totalDelay then
      return ___MOD.math.max(0.1, totalDelay / 1000)
    end
  end
  return ___MOD.math.max(0.1, self:getSkillActionLockDelaySec(player, skillID, "assassination", 0.1, 0))
end

function PlayerSkillLogic.getAssassinateFollowUpTargetPos(self, player)
  local state = self:getAssassinateState(player)
  local tr = player.TransformComponent
  if tr ~= nil then
    state.followUpTargetPos = tr:WorldPositionAsFastVector3():ToVector2()
  else
    state.followUpTargetPos = nil
  end
  local rb = player.RigidbodyComponent
  local map = player.CurrentMap
  if tr == nil or rb == nil or map == nil then
    return nil
  end
  local pos = tr:WorldPositionAsFastVector3():ToVector2()
  local currentFh = rb:GetCurrentFoothold()
  if currentFh == nil then
    return nil
  end
  local footholds = map.FootholdComponent
  local left = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.LeftArrow) and 1 or 0
  local right = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.RightArrow) and 1 or 0
  local up = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.UpArrow) and 1 or 0
  local down = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.DownArrow) and 1 or 0
  local dirHorizon = right - left
  local dirVertical = up - down
  if dirHorizon == 0 and dirVertical == 0 then
    dirHorizon = player.ExtendPlayerControllerComponent.LookDirectionX
  end
  state.followUpMoveDirX = dirHorizon
  state.followUpMoveDirY = dirVertical
  local realTargetX, realTargetY
  if dirHorizon ~= 0 then
    local targetPosX = pos.x + dirHorizon * 1.0
    local footholdAbove = footholds:Raycast(___MOD.Vector2(targetPosX, pos.y - 0.01), ___MOD.Vector2.up, 1.0)
    local footholdUnder = footholds:Raycast(___MOD.Vector2(targetPosX, pos.y + 0.01), ___MOD.Vector2.down, 1.0)
    local aboveY = footholdAbove and footholdAbove:GetYByX(targetPosX) or 0
    local underY = footholdUnder and footholdUnder:GetYByX(targetPosX) or 0
    if footholdUnder ~= nil and footholdAbove ~= nil and aboveY - pos.y <= pos.y - underY then
      realTargetY = aboveY + 0.01
    elseif footholdUnder ~= nil then
      realTargetY = underY + 0.01
    elseif footholdAbove ~= nil then
      realTargetY = aboveY + 0.01
    end
    realTargetX = targetPosX
  elseif dirVertical ~= 0 then
    local targetPosY = pos.y + dirVertical * 1.1
    if 0 < dirVertical then
      realTargetY = pos.y + 0.01
      local footholdAbove = footholds:Raycast(___MOD.Vector2(pos.x, targetPosY + 0.01), ___MOD.Vector2.down, 10)
      if footholdAbove ~= nil and footholdAbove ~= currentFh then
        realTargetY = footholdAbove:GetYByX(pos.x) + 0.01
      end
    else
      local footholdUnder = footholds:Raycast(___MOD.Vector2(pos.x, targetPosY - 0.01), ___MOD.Vector2.up, 10)
      if footholdUnder == nil or footholdUnder == currentFh then
        local underUnderFoothold = footholds:Raycast(___MOD.Vector2(pos.x, targetPosY - 0.01), ___MOD.Vector2.down, 1.09)
        if underUnderFoothold ~= nil then
          local underUnderFootholdY = underUnderFoothold:GetYByX(pos.x) + 0.01
          local startPos = ___MOD.Vector2(pos.x, underUnderFootholdY)
          if ___MOD._FootholdLogic:canGoThrough(map, startPos, ___MOD.Vector2(pos.x, pos.y + 0.01), currentFh.Id) then
            realTargetY = underUnderFootholdY
          end
        end
      else
        realTargetY = footholdUnder:GetYByX(pos.x) + 0.01
      end
    end
    realTargetX = pos.x
  end
  if realTargetX == nil or realTargetY == nil then
    return nil
  end
  local targetPos = ___MOD.Vector2(realTargetX, realTargetY)
  state.followUpTargetPos = targetPos
  return targetPos
end

function PlayerSkillLogic.getAssassinateState(self, player)
  self._T.assassinateStates = self._T.assassinateStates or {}
  local key = self:getPlayerRuntimeStateKey(player)
  if ___MOD._UtilLogic:IsNilorEmptyString(key) then
    key = "local"
  end
  local state = self._T.assassinateStates[key]
  if state == nil then
    state = {}
    self._T.assassinateStates[key] = state
  end
  return state
end

function PlayerSkillLogic.getBattleshipReuseDelaySec(self)
  return 1
end

function PlayerSkillLogic.getCanUseSkillTime(self, player, skillID)
  local canUseSkills = player.PlayerVariables and player.PlayerVariables.canUseSkills or nil
  if canUseSkills == nil then
    return 0
  end
  local t = ___MOD.tonumber(canUseSkills[skillID]) or ___MOD.tonumber(canUseSkills[___MOD.tostring(skillID)]) or 0
  return t
end

function PlayerSkillLogic.getCorkscrewKeydownStorageSkillID(self, skillID)
  return 600000000 + skillID
end

function PlayerSkillLogic.getDoubleJumpSkillList(self)
  local ret = {
    ___MOD._SkillBook.Flash_Jump_411_4111006,
    ___MOD._SkillBook.Flash_Jump_432_4321003,
    ___MOD._SkillBook.Flash_Jump_1410_14101004
  }
  return ret
end

function PlayerSkillLogic.getDuration(self, player, skillID, duration)
  local ret = 0
  ret = duration
  return ret
end

function PlayerSkillLogic.getHurricaneKeydownEndRemoteEffectSkillID(self, skillID)
  return 200000000 + skillID
end

function PlayerSkillLogic.getHurricanePrepareRemoteEffectSkillID(self, skillID)
  return 100000000 + skillID
end

function PlayerSkillLogic.getHurricaneState(self, player)
  self._T.hurricaneStates = self._T.hurricaneStates or {}
  local key = self:getPlayerRuntimeStateKey(player)
  if ___MOD._UtilLogic:IsNilorEmptyString(key) then
    key = "local"
  end
  local state = self._T.hurricaneStates[key]
  if state == nil then
    state = {}
    self._T.hurricaneStates[key] = state
  end
  return state
end

function PlayerSkillLogic.getPiercingKeydownEndRemoteEffectSkillID(self, skillID)
  return 400000000 + skillID
end

function PlayerSkillLogic.getPiercingPrepareRemoteEffectSkillID(self, skillID)
  return 300000000 + skillID
end

function PlayerSkillLogic.getPiercingState(self, player)
  self._T.piercingStates = self._T.piercingStates or {}
  local key = self:getPlayerRuntimeStateKey(player)
  if ___MOD._UtilLogic:IsNilorEmptyString(key) then
    key = "local"
  end
  local state = self._T.piercingStates[key]
  if state == nil then
    state = {}
    self._T.piercingStates[key] = state
  end
  return state
end

function PlayerSkillLogic.getPlayerRuntimeStateKey(self, player)
  if not ___MOD.isvalid(player) then
    return ""
  end
  return ___MOD.tostring(player.Id or player.Player and player.Player.PlayerId or player.Name or "local")
end

function PlayerSkillLogic.getProneNormalAttackReason(self, player, pa, isDownArrowPressed, isJumpPressed, isLeftPressed, isRightPressed)
  if player ~= ___MOD._UserService.LocalPlayer then
    return ""
  end
  local isProneState = player.StateComponent.CurrentStateName == "PRONE"
  if isProneState then
    return "PRONE_STATE"
  end
  local isInSwimMap = player.ExtendPlayerControllerComponent ~= nil and player.ExtendPlayerControllerComponent.inSwimMap
  local isOnGround = player.RigidbodyComponent:IsOnGround()
  local isClimbing = pa.isClimbing
  local isProneInput = not isInSwimMap and isDownArrowPressed and not isJumpPressed and isOnGround and not isClimbing and (___MOD._PlayerUpdateLogic.canCDF or isLeftPressed or isRightPressed)
  if isProneInput then
    return "PRONE_INPUT"
  end
  local isGroundProneSideInput = not isInSwimMap and isDownArrowPressed and (isLeftPressed or isRightPressed) and isOnGround and not isClimbing
  local isSwimGroundProneSideInput = isInSwimMap and not isJumpPressed and isDownArrowPressed and (isLeftPressed or isRightPressed) and isOnGround and not isClimbing
  if isGroundProneSideInput or isSwimGroundProneSideInput then
    return "PRONE_SIDE_INPUT"
  end
  return ""
end

function PlayerSkillLogic.getRapidFireKeydown0StorageSkillID(self, skillID)
  return 500000000 + skillID
end

function PlayerSkillLogic.getSkillActionLockDelaySec(self, player, skillID, motion, fallbackDelay, extraDelay)
  local pa = player ~= nil and player.PlayerActionComponent or nil
  if pa == nil then
    local delay = fallbackDelay or 0
    if extraDelay ~= nil and 0 < extraDelay then
      delay = delay + extraDelay
    end
    return delay
  end
  return self:getSkillActionLockDelaySecByAttackSpeed(skillID, motion, fallbackDelay, extraDelay, pa:getCurrentSkillActionSpeed(skillID))
end

function PlayerSkillLogic.getSkillActionLockDelaySecByAttackSpeed(self, skillID, motion, fallbackDelay, extraDelay, attackSpeed)
  local speed = ___MOD.math.min(9, ___MOD.math.max(2, attackSpeed))
  local delay = fallbackDelay or 0
  if not ___MOD._UtilLogic:IsNilorEmptyString(motion) then
    local motionDelay = ___MOD._MotionDataManager:getMotionDelayAtAttackSpeed(motion, speed)
    if motionDelay ~= nil and 0 < motionDelay then
      delay = motionDelay
    end
  end
  if extraDelay ~= nil and 0 < extraDelay then
    delay = delay + extraDelay
  end
  local playRate = (speed + 10) / 16
  if skillID == ___MOD._SkillBook.Boomerang_Step_422_4221007 or skillID == ___MOD._SkillBook.Storm_Break_1310_13101005 then
    delay = 0.8 * playRate
  elseif self:isFootholdMeteorActionLockSkill(skillID) then
    delay = delay * 0.8
  elseif skillID == ___MOD._SkillBook.Explosion_211_2111002 then
    delay = delay * playRate
  end
  return delay
end

function PlayerSkillLogic.getSkillCooldownEndTime(self, player, skillID)
  local cooltimes = player.PlayerVariables and player.PlayerVariables.skillCooltimes or nil
  if cooltimes == nil then
    return 0
  end
  local endTime = ___MOD.tonumber(cooltimes[skillID]) or ___MOD.tonumber(cooltimes[___MOD.tostring(skillID)]) or 0
  return endTime
end

function PlayerSkillLogic.getSkillLevelDataCooltimeSec(self, skillLevelData, skillID)
  if self:isBattleshipSkill(skillID) then
    return 0
  end
  if skillLevelData == nil then
    return 0
  end
  if skillLevelData.skillID == ___MOD._SkillBook.Battleship_522_5221006 then
    return 0
  end
  local cooldownSec = ___MOD.tonumber(skillLevelData.cooltime) or 0
  if cooldownSec <= 0 then
    return 0
  end
  return cooldownSec
end

function PlayerSkillLogic.getSkillMinActionLockDelaySec(self, skillID, motion, fallbackDelay, extraDelay)
  return self:getSkillActionLockDelaySecByAttackSpeed(skillID, motion, fallbackDelay, extraDelay, 2)
end

function PlayerSkillLogic.getSkillSoundRefId(self, skillID)
  local book = ___MOD._SkillBook
  if self:isUsefulHasteSkill(skillID) then
    return book.Haste_410_4101004
  end
  if self:isUsefulMysticDoorSkill(skillID) then
    return book.Mystic_Door_231_2311002
  end
  if self:isUsefulSharpEyesSkill(skillID) then
    return book.Sharp_Eyes_312_3121002
  end
  if self:isUsefulHyperBodySkill(skillID) then
    return book.Hyper_Body_130_1301007
  end
  return skillID
end

function PlayerSkillLogic.getTamingMobIDFromSkillID(self, skillID, player)
  if skillID == ___MOD._SkillBook.Battleship_522_5221006 then
    return 1932000
  elseif skillID == ___MOD._SkillBook.Monster_Rider_000_1004 or skillID == ___MOD._SkillBook.Monster_Rider_1000_10001004 or skillID == ___MOD._SkillBook.Monster_Rider_2000_20001004 or skillID == ___MOD._SkillBook.Monster_Rider_2001_20011004 then
    local tamingMob = player.EquipmentComponent:getSlotItem(___MOD._EquipmentSlotType.TAMINGMOB, ___MOD._EquipmentSubSlotType.MAIN)
    if not tamingMob then
      return 0
    end
    return tamingMob.itemId
  elseif skillID == ___MOD._SkillBook.Space_Beam_000_1015 or skillID == ___MOD._SkillBook.Space_Beam_1000_10001016 then
    return 1932001
  elseif skillID == ___MOD._SkillBook.Yeti_Rider_000_1017 or skillID == ___MOD._SkillBook.Yeti_Rider_1000_10001019 or skillID == ___MOD._SkillBook.Yeti_Rider_2000_20001019 or skillID == ___MOD._SkillBook.Yeti_Rider_2001_20011018 then
    return 1932003
  elseif skillID == ___MOD._SkillBook.Yeti_Mount_000_1018 or skillID == ___MOD._SkillBook.Yeti_Mount_1000_10001022 or skillID == ___MOD._SkillBook.Yeti_Mount_2000_20001022 then
    return 1932004
  elseif skillID == ___MOD._SkillBook.Witchs_Broomstick_000_1019 or skillID == ___MOD._SkillBook.Witchs_Broomstick_1000_10001023 or skillID == ___MOD._SkillBook.Witchs_Broomstick_2000_20001023 or skillID == ___MOD._SkillBook.Witchs_Broomstick_2001_20011019 then
    return 1932005
  elseif skillID == ___MOD._SkillBook.Charge_Wooden_Pony_000_1025 or skillID == ___MOD._SkillBook.Charge_Wooden_Pony_1000_10001025 or skillID == ___MOD._SkillBook.Charge_Wooden_Pony_2000_20001025 or skillID == ___MOD._SkillBook.Charge_Wooden_Pony_2001_20011025 then
    return 1932006
  elseif skillID == ___MOD._SkillBook.Croco__000_1027 or skillID == ___MOD._SkillBook.Croco__1000_10001027 or skillID == ___MOD._SkillBook.Croco__2000_20001027 or skillID == ___MOD._SkillBook.Croco__2001_20011027 then
    return 1932007
  elseif skillID == ___MOD._SkillBook.Black_Scooter_000_1028 or skillID == ___MOD._SkillBook.Black_Scooter_1000_10001028 or skillID == ___MOD._SkillBook.Black_Scooter_2000_20001028 or skillID == ___MOD._SkillBook.Black_Scooter_2001_20011028 then
    return 1932008
  elseif skillID == ___MOD._SkillBook.Pink_Scooter_000_1029 or skillID == ___MOD._SkillBook.Pink_Scooter_1000_10001029 or skillID == ___MOD._SkillBook.Pink_Scooter_2000_20001029 or skillID == ___MOD._SkillBook.Pink_Scooter_2001_20011029 then
    return 1932009
  elseif skillID == ___MOD._SkillBook.Nimbus_Cloud_000_1030 or skillID == ___MOD._SkillBook.Nimbus_Cloud_1000_10001030 or skillID == ___MOD._SkillBook.Nimbus_Cloud_2000_20001030 or skillID == ___MOD._SkillBook.Nimbus_Cloud_2001_20011030 then
    return 1932011
  elseif skillID == ___MOD._SkillBook.Balrog_000_1031 or skillID == ___MOD._SkillBook.Balrog_1000_10001031 or skillID == ___MOD._SkillBook.Balrog_2000_20001031 or skillID == ___MOD._SkillBook.Balrog_2001_20011031 then
    return 1932010
  elseif skillID == ___MOD._SkillBook.Kart_000_1033 or skillID == ___MOD._SkillBook.Kart_1000_10001033 or skillID == ___MOD._SkillBook.Kart_2000_20001033 then
    return 1932013
  elseif skillID == ___MOD._SkillBook.ZD_Tiger_000_1034 or skillID == ___MOD._SkillBook.ZD_Tiger_1000_10001034 or skillID == ___MOD._SkillBook.ZD_Tiger_2000_20001034 or skillID == ___MOD._SkillBook.ZD_Tiger_2001_20011034 then
    return 1932014
  elseif skillID == ___MOD._SkillBook.Shinjo_000_1042 or skillID == ___MOD._SkillBook.Shinjo_1000_10001042 or skillID == ___MOD._SkillBook.Shinjo_2000_20001042 or skillID == ___MOD._SkillBook.Shinjo_2001_20011042 then
    return 1932022
  elseif skillID == ___MOD._SkillBook.Mist_Balrog_000_1035 or skillID == ___MOD._SkillBook.Mist_Balrog_1000_10001035 or skillID == ___MOD._SkillBook.Mist_Balrog_2000_20001035 or skillID == ___MOD._SkillBook.Mist_Balrog_2001_20011035 then
    return 1932012
  end
  return 0
end

function PlayerSkillLogic.handleHurricaneArrowExhausted(self, player, skillID)
  if player == nil or player.CInventoryComponent == nil then
    return
  end
  if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 then
    return
  end
  local sc = player.SkillComponent
  local slv = sc ~= nil and sc:getSkillLevel(skillID) or 0
  local skill = ___MOD._SkillManager:getSkill(skillID)
  local skillLevelData = skill ~= nil and skill.level ~= nil and skill.level[slv] or nil
  local itemId, count, slot = player.CInventoryComponent:findFirstThrowing(1)
  ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(player, skillID, skillLevelData, itemId, count, 1)
end

function PlayerSkillLogic.hasForcedBattleshipCooldown(self, player, skillID, currentTime)
  if not self:isBattleshipSkill(skillID) then
    return false
  end
  local coolEndTime = ___MOD.math.max(self:getCanUseSkillTime(player, skillID), self:getSkillCooldownEndTime(player, skillID))
  return currentTime < coolEndTime
end

function PlayerSkillLogic.interruptHurricaneLikeSkillsByAbnormalStatus(self, player)
  self:interruptHurricaneSkillsByAbnormalStatus(player)
end

function PlayerSkillLogic.interruptHurricaneSkillsByAbnormalStatus(self, player)
  local book = ___MOD._SkillBook
  local targets = {
    book.Hurricane_312_3121004,
    book.Hurricane_1311_13111002,
    book.Rapid_Fire_522_5221004
  }
  for i = 1, #targets do
    local skillID = targets[i]
    if self:isHurricaneActive(player, skillID) then
      local skillData = ___MOD._SkillManager:getSkill(skillID)
      self:finishHurricaneKeydown(player, skillID, skillData, true)
    else
      self:clearInactiveHurricaneEffects(player, skillID)
    end
  end
end

function PlayerSkillLogic.isAmplificationSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Element_Amplification_211_2110001 or skillID == ___MOD._SkillBook.Element_Amplification_221_2210001 or skillID == ___MOD._SkillBook.Element_Amplification_1211_12110001 or skillID == ___MOD._SkillBook.Magic_Amplification_2215_22150000
end

function PlayerSkillLogic.isAssassinateFollowUpActive(self, player)
  local state = self:getAssassinateState(player)
  return state ~= nil and state.inFollowUp == true
end

function PlayerSkillLogic.isAttackSkill(self, skillID)
  if skillID == ___MOD._SkillBook.Arrow_Bomb__Bow_310_3101005 or skillID == ___MOD._SkillBook.Shadow_Meso_411_4111004 or skillID == ___MOD._SkillBook.Heavens_Hammer_122_1221011 or skillID == ___MOD._SkillBook.Snipe_322_3221007 or skillID == ___MOD._SkillBook.Taunt_412_4121003 or skillID == ___MOD._SkillBook.Taunt_422_4221003 or skillID == ___MOD._SkillBook.Hypnotize_522_5221009 then
    return true
  end
  return false
end

function PlayerSkillLogic.isBattleshipMounted(self, player)
  if player == nil or player.TamingMobComponent == nil or not player.TamingMobComponent.onTaming then
    return false
  end
  local ts = player.PlayerTemporaryStatComponent
  if ts == nil then
    return false
  end
  return ts:getSkillID(___MOD._CTS.TamingMob) == ___MOD._SkillBook.Battleship_522_5221006
end

function PlayerSkillLogic.isBattleshipMountOnlySkill(self, skillID)
  return skillID == ___MOD._SkillBook.Battleship_Cannon_522_5221007 or skillID == ___MOD._SkillBook.Battleship_Torpedo_522_5221008
end

function PlayerSkillLogic.isBattleshipSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Battleship_522_5221006
end

function PlayerSkillLogic.isBigBangSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Big_Bang_212_2121001 or skillID == ___MOD._SkillBook.Big_Bang_222_2221001 or skillID == ___MOD._SkillBook.Big_Bang_232_2321001
end

function PlayerSkillLogic.isBooster(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.BW_Booster_120_1201005 or skillID == book.Axe_Booster_110_1101005 or skillID == book.Bow_Booster_310_3101002 or skillID == book.Gun_Booster_520_5201003 or skillID == book.Claw_Booster_410_4101003 or skillID == book.Bow_Booster_1310_13101001 or skillID == book.Spear_Booster_130_1301004 or skillID == book.Spell_Booster_211_2111005 or skillID == book.Spell_Booster_221_2211005 or skillID == book.Sword_Booster_110_1101004 or skillID == book.Sword_Booster_120_1201004 or skillID == book.Claw_Booster_1410_14101002 or skillID == book.Dagger_Booster_420_4201002 or skillID == book.Katara_Booster_430_4301002 or skillID == book.Magic_Booster_2214_22141002 or skillID == book.Spell_Booster_1210_12101004 or skillID == book.Sword_Booster_1110_11101001 or skillID == book.Bow_Booster_1310_13101001 or skillID == book.Crossbow_Booster_320_3201002 or skillID == book.Knuckler_Booster_510_5101006 or skillID == book.Pole_Arm_Booster_130_1301005 or skillID == book.Knuckle_Booster_1510_15101002 or skillID == book.Polearm_Booster_2100_21001003 then
    return true
  end
  return false
end

function PlayerSkillLogic.isBuffSkill(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Meditation_210_2101001 or skillID == book.Meditation_220_2201001 or skillID == book.Meditation_1210_12101000 or skillID == book.Combo_Attack_111_1111002 or skillID == book.Combo_Attack_1111_11111001 or skillID == book.Ice_Charge_Sword_121_1211005 or skillID == book.Fire_Charge_Sword_121_1211003 or skillID == book.Holy_Charge__Sword_122_1221003 or skillID == book.Flame_Charge_BW_121_1211004 or skillID == book.Divine_Charge__BW_122_1221004 or skillID == book.Thunder_Charge_Sword_121_1211007 or skillID == book.Blizzard_Charge_BW_121_1211006 or skillID == book.Lightning_Charge_1510_15101006 or skillID == book.Lightning_Charge_BW_121_1211008 or skillID == book.Magic_Crash_121_1211009 or skillID == book.Power_Crash_131_1311007 or self:isSummonSkill(skillID) or self:isMysticDoorSkill(skillID) or skillID == book.Final_Attack_1110_11101002 or skillID == book.Final_Attack_1310_13101002 or skillID == book.Soul_Charge_1111_11111007 or skillID == book.Wind_Walk_1310_13101006 or skillID == book.Spark_1511_15111006 or skillID == book.Body_Pressure_2110_21101003 or skillID == book.Combo_Drain_2110_21100005 or skillID == book.Snow_Charge_2111_21111005 or skillID == book.Smart_Knockback_2111_21111001 or skillID == book.Combo_Barrier_2112_21120007 or self:isEchoOfHeroSkill(skillID) then
    return true
  end
  return false
end

function PlayerSkillLogic.isCorkscrewSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Corkscrew_Blow_510_5101004 or skillID == ___MOD._SkillBook.Corkscrew_Blow_1510_15101003
end

function PlayerSkillLogic.isDarkSightLikeSkill(self, skillID)
  return self:isDarkSightSkill(skillID) or self:isWindWalkSkill(skillID)
end

function PlayerSkillLogic.isDarkSightSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Dark_Sight_400_4001003 or skillID == ___MOD._SkillBook.Dark_Sight_1400_14001003
end

function PlayerSkillLogic.isDisorder(self, skillID)
  if skillID == ___MOD._SkillBook.Disorder_400_4001002 or skillID == ___MOD._SkillBook.Disorder_1400_14001002 then
    return true
  end
  return false
end

function PlayerSkillLogic.isDoubleJumpSkill(self, skillID)
  if skillID == ___MOD._SkillBook.Flash_Jump_411_4111006 or skillID == ___MOD._SkillBook.Flash_Jump_432_4321003 or skillID == ___MOD._SkillBook.Flash_Jump_1410_14101004 then
    return true
  end
  return false
end

function PlayerSkillLogic.isEchoOfHeroSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Echo_of_Hero_000_1005 or skillID == ___MOD._SkillBook.Echo_of_Hero_1000_10001005 or skillID == ___MOD._SkillBook.Echo_of_Hero_2000_20001005 or skillID == ___MOD._SkillBook.Heros_Echo_2001_20011005
end

function PlayerSkillLogic.isFieldLimitBlockedTamingMobSkill(self, skillID, player)
  if self:isJobRidingSkill(skillID) then
    return false
  end
  return self:isTamingMobSkill(skillID, player)
end

function PlayerSkillLogic.isFlameGearPlacementBlocked(self, player, skillID, skillLevelData)
  if skillID ~= ___MOD._SkillBook.Flame_Gear_1211_12111005 then
    return false
  end
  if player == nil or player.CurrentMap == nil or skillLevelData == nil or skillLevelData.lt == nil or skillLevelData.rb == nil then
    return false
  end
  local mapLife = player.CurrentMap.MapLifeComponent
  if mapLife == nil or mapLife.mistPool == nil then
    return false
  end
  local playerPos = player.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  local center, size = ___MOD._NumberUtils:getTriggerBoxFromLtRb(skillLevelData.lt * 100, skillLevelData.rb * 100, false)
  center.x = 0
  local placementBox = ___MOD.BoxShape(playerPos + center, size, 0)
  local playerId = ""
  if player.Player ~= nil then
    playerId = ___MOD.tostring(player.Player.PlayerId or "")
  end
  for _, mistEntity in ___MOD.pairs(mapLife.mistPool) do
    if ___MOD.isvalid(mistEntity) and mistEntity.MistComponent ~= nil then
      local mist = mistEntity.MistComponent
      local owner = mist.ownerEntity
      local isSameOwner = playerId ~= "" and owner ~= nil and ___MOD.isvalid(owner) and owner.Player ~= nil and ___MOD.tostring(owner.Player.PlayerId or "") == playerId
      if isSameOwner and mist.skillId == ___MOD._SkillBook.Flame_Gear_1211_12111005 and mist.boxShape ~= nil and ___MOD._NumberUtils:intersectBox(placementBox, mist.boxShape) ~= nil then
        return true
      end
    end
  end
  return false
end

function PlayerSkillLogic.isFootholdMeteorActionLockSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Meteor_Shower_212_2121007 or skillID == ___MOD._SkillBook.Blizzard_222_2221007 or skillID == ___MOD._SkillBook.Genesis_232_2321008 or skillID == ___MOD._SkillBook.Meteor_Shower_1211_12111003
end

function PlayerSkillLogic.isHaste(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Haste_1410_14101003 or skillID == book.Haste_410_4101004 or skillID == book.Haste_420_4201003 or self:isUsefulHasteSkill(skillID) or skillID == book.Haste_Normal_900_9001000 then
    return true
  end
end

function PlayerSkillLogic.isHerosWill(self, skillID)
  return skillID == ___MOD._SkillBook.Heros_Will_112_1121011 or skillID == ___MOD._SkillBook.Heros_Will_122_1221012 or skillID == ___MOD._SkillBook.Heros_Will_132_1321010 or skillID == ___MOD._SkillBook.Heros_Will_212_2121008 or skillID == ___MOD._SkillBook.Heros_Will_222_2221008 or skillID == ___MOD._SkillBook.Heros_Will_232_2321009 or skillID == ___MOD._SkillBook.Heros_Will_312_3121009 or skillID == ___MOD._SkillBook.Heros_Will_322_3221008 or skillID == ___MOD._SkillBook.Heros_Will_412_4121009 or skillID == ___MOD._SkillBook.Heros_Will_422_4221008 or skillID == ___MOD._SkillBook.Heros_Will_434_4341008 or skillID == 5121008 or skillID == ___MOD._SkillBook.Heros_Will_522_5221010 or skillID == ___MOD._SkillBook.Heros_Will_2112_21121008 or skillID == ___MOD._SkillBook.Heros_Will_2217_22171004
end

function PlayerSkillLogic.isHurricaneActive(self, player, skillID)
  local state = self:getHurricaneState(player)
  return state.inputLock == true or state.prepareToken ~= nil or state.prepareSkillID == skillID or player.KeyDownComponent ~= nil and player.KeyDownComponent.onKeyDown and player.KeyDownComponent.skillID == skillID
end

function PlayerSkillLogic.isHurricaneLikeSkill(self, skillID)
  return self:isHurricaneSkillGroup(skillID)
end

function PlayerSkillLogic.isHurricaneSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Hurricane_312_3121004 or skillID == ___MOD._SkillBook.Hurricane_1311_13111002
end

function PlayerSkillLogic.isHurricaneSkillGroup(self, skillID)
  return self:isHurricaneSkill(skillID) or self:isRapidFireSkill(skillID)
end

function PlayerSkillLogic.isItemEnchantSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Legendary_Spirit_000_1003 or skillID == ___MOD._SkillBook.Legendary_Spirit_1000_10001003 or skillID == ___MOD._SkillBook.Legendary_Spirit_2000_20001003 or skillID == ___MOD._SkillBook.Legendary_Spirit__2001_20011003
end

function PlayerSkillLogic.isJobRidingSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Battleship_522_5221006
end

function PlayerSkillLogic.isMapleWarriorSkill(self, skillID)
  local SB = ___MOD._SkillBook
  return skillID == SB.Maple_Warrior_112_1121000 or skillID == SB.Maple_Warrior_122_1221000 or skillID == SB.Maple_Warrior_132_1321000 or skillID == SB.Maple_Warrior_212_2121000 or skillID == SB.Maple_Warrior_222_2221000 or skillID == SB.Maple_Warrior_232_2321000 or skillID == SB.Maple_Warrior_312_3121000 or skillID == SB.Maple_Warrior_322_3221000 or skillID == SB.Maple_Warrior_412_4121000 or skillID == SB.Maple_Warrior_422_4221000 or skillID == SB.Maple_Warrior_434_4341000 or skillID == SB.Maple_Warrior_512_5121000 or skillID == SB.Maple_Warrior_522_5221000 or skillID == SB.Maple_Warrior_2112_21121000 or skillID == SB.Maple_Warrior_2217_22171000
end

function PlayerSkillLogic.isMobUnionBoxInSkillBox(self, mob, skillBox)

end

function PlayerSkillLogic.isMonsterMagnetSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Monster_Magnet_112_1121001 or skillID == ___MOD._SkillBook.Monster_Magnet_122_1221001 or skillID == ___MOD._SkillBook.Monster_Magnet_132_1321001
end

function PlayerSkillLogic.isMonsterRiderSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Monster_Rider_000_1004 or skillID == ___MOD._SkillBook.Monster_Rider_1000_10001004 or skillID == ___MOD._SkillBook.Monster_Rider_2000_20001004 or skillID == ___MOD._SkillBook.Monster_Rider_2001_20011004
end

function PlayerSkillLogic.isMorphCancelable(self, player)
  local ts = player.PlayerTemporaryStatComponent
  local morphSkillId = ts:getSkillID(___MOD._CTS.Morph)
  if morphSkillId < 0 then
    local item = ___MOD._ItemManager:getItemById(-morphSkillId)
    if item ~= nil and item.noCancelMouse then
      return false
    end
  end
  return true
end

function PlayerSkillLogic.isMysticDoorSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Mystic_Door_231_2311002 or self:isUsefulMysticDoorSkill(skillID)
end

function PlayerSkillLogic.isNeedBypassMadSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Fire_Charge_Sword_121_1211003 or skillID == ___MOD._SkillBook.Flame_Charge_BW_121_1211004 or skillID == ___MOD._SkillBook.Ice_Charge_Sword_121_1211005 or skillID == ___MOD._SkillBook.Blizzard_Charge_BW_121_1211006 or skillID == ___MOD._SkillBook.Thunder_Charge_Sword_121_1211007 or skillID == ___MOD._SkillBook.Lightning_Charge_BW_121_1211008 or skillID == ___MOD._SkillBook.Holy_Charge__Sword_122_1221003 or skillID == ___MOD._SkillBook.Divine_Charge__BW_122_1221004 or skillID == ___MOD._SkillBook.Soul_Charge_1111_11111007 or skillID == ___MOD._SkillBook.Lightning_Charge_1510_15101006 or skillID == ___MOD._SkillBook.Snow_Charge_2111_21111005
end

function PlayerSkillLogic.isNeedSkipMadSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Meditation_210_2101001 or skillID == ___MOD._SkillBook.Meditation_220_2201001 or skillID == ___MOD._SkillBook.Meditation_1210_12101000
end

function PlayerSkillLogic.isNeedSkipPadSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Rage_110_1101006 or skillID == ___MOD._SkillBook.Rage_1110_11101003 or skillID == ___MOD._SkillBook.Enrage_112_1121010
end

function PlayerSkillLogic.isNeedSkipPddMddSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Iron_Body_100_1001003 or skillID == ___MOD._SkillBook.Magic_Armor_200_2001003 or skillID == ___MOD._SkillBook.Iron_Body_1100_11001001 or skillID == ___MOD._SkillBook.Magic_Armor_1200_12001002
end

function PlayerSkillLogic.isNinjaAmbushSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Ninja_Ambush_412_4121004 or skillID == ___MOD._SkillBook.Ninja_Ambush_422_4221004
end

function PlayerSkillLogic.isPassiveSkill(self, skillID)
  local book = ___MOD._SkillBook
  if skillID == book.Stun_Mastery_511_5110000 then
    return true
  end
  return false
end

function PlayerSkillLogic.isPiercingActive(self, player, skillID)
  local state = self:getPiercingState(player)
  return state.inputLock == true or state.prepareToken ~= nil or state.prepareSkillID == skillID or player.KeyDownComponent ~= nil and player.KeyDownComponent.onKeyDown and player.KeyDownComponent.skillID == skillID
end

function PlayerSkillLogic.isPiercingPrepareRemoteEffectSkillID(self, skillID)
  return skillID == self:getPiercingPrepareRemoteEffectSkillID(3221001)
end

function PlayerSkillLogic.isPiercingSkill(self, skillID)
  return skillID == 3221001
end

function PlayerSkillLogic.isRangeMobDebuffSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Threaten_120_1201006 or skillID == book.Armor_Crash_111_1111007 or skillID == book.Magic_Crash_121_1211009 or skillID == book.Power_Crash_131_1311007 or skillID == book.Slow_210_2101003 or skillID == book.Slow_220_2201003 or skillID == book.Slow_1210_12101001 or skillID == book.Slow_2214_22141003 or skillID == book.Slow_9000_90001002 or skillID == book.Seal_211_2111004 or skillID == book.Seal_221_2211004 or skillID == book.Seal_1211_12111002 or skillID == book.Seal__9000_90001005 or skillID == book.Doom_231_2311005 or skillID == book.Shadow_Web_411_4111003 or skillID == book.Shadow_Web_1411_14111001
end

function PlayerSkillLogic.isRapidFireSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Rapid_Fire_522_5221004
end

function PlayerSkillLogic.isSealSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Seal_211_2111004 or skillID == ___MOD._SkillBook.Seal_221_2211004 or skillID == ___MOD._SkillBook.Seal_1211_12111002
end

function PlayerSkillLogic.isShouldRemovePadSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Concentrate_312_3121008
end

function PlayerSkillLogic.isShouldRemovePddMddSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Hex_of_the_Beholder_132_1320009 or skillID == ___MOD._SkillBook.Iron_Will_130_1301006 or skillID == ___MOD._SkillBook.Bless_230_2301004 or skillID == ___MOD._SkillBook.Transformation_511_5111005 or skillID == ___MOD._SkillBook.Super_Transformation_512_5121003 or skillID == ___MOD._SkillBook.Eagle_Eye_1311_13111005 or skillID == ___MOD._SkillBook.Transformation_1511_15111002 or skillID == ___MOD._SkillBook.Blessing_of_the_Onyx_2218_22181000 or skillID == ___MOD._SkillBook.Spaceship_000_1013 or skillID == ___MOD._SkillBook.Yeti_Rider_000_1017 or skillID == ___MOD._SkillBook.Yeti_Mount_000_1018 or skillID == ___MOD._SkillBook.Witchs_Broomstick_000_1019 or skillID == ___MOD._SkillBook.Charge_Wooden_Pony_000_1025 or skillID == ___MOD._SkillBook.Croco__000_1027 or skillID == ___MOD._SkillBook.Black_Scooter_000_1028 or skillID == ___MOD._SkillBook.Pink_Scooter_000_1029 or skillID == ___MOD._SkillBook.Nimbus_Cloud_000_1030 or skillID == ___MOD._SkillBook.Balrog_000_1031 or skillID == ___MOD._SkillBook.Kart_000_1033 or skillID == ___MOD._SkillBook.ZD_Tiger_000_1034 or skillID == ___MOD._SkillBook.Mist_Balrog_000_1035 or skillID == ___MOD._SkillBook.Shinjo_000_1042 or skillID == ___MOD._SkillBook.Battleship_522_5221006 or skillID == ___MOD._SkillBook.Spaceship_1000_10001014 or skillID == ___MOD._SkillBook.Yeti_Rider_1000_10001019 or skillID == ___MOD._SkillBook.Yeti_Mount_1000_10001022 or skillID == ___MOD._SkillBook.Witchs_Broomstick_1000_10001023 or skillID == ___MOD._SkillBook.Charge_Wooden_Pony_1000_10001025 or skillID == ___MOD._SkillBook.Croco__1000_10001027 or skillID == ___MOD._SkillBook.Black_Scooter_1000_10001028 or skillID == ___MOD._SkillBook.Pink_Scooter_1000_10001029 or skillID == ___MOD._SkillBook.Nimbus_Cloud_1000_10001030 or skillID == ___MOD._SkillBook.Balrog_1000_10001031 or skillID == ___MOD._SkillBook.Kart_1000_10001033 or skillID == ___MOD._SkillBook.ZD_Tiger_1000_10001034 or skillID == ___MOD._SkillBook.Mist_Balrog_1000_10001035 or skillID == ___MOD._SkillBook.Shinjo_1000_10001042 or skillID == ___MOD._SkillBook.Yeti_Rider_2000_20001019 or skillID == ___MOD._SkillBook.Yeti_Mount_2000_20001022 or skillID == ___MOD._SkillBook.Witchs_Broomstick_2000_20001023 or skillID == ___MOD._SkillBook.Charge_Wooden_Pony_2000_20001025 or skillID == ___MOD._SkillBook.Croco__2000_20001027 or skillID == ___MOD._SkillBook.Black_Scooter_2000_20001028 or skillID == ___MOD._SkillBook.Pink_Scooter_2000_20001029 or skillID == ___MOD._SkillBook.Nimbus_Cloud_2000_20001030 or skillID == ___MOD._SkillBook.Balrog_2000_20001031 or skillID == ___MOD._SkillBook.Kart_2000_20001033 or skillID == ___MOD._SkillBook.ZD_Tiger_2000_20001034 or skillID == ___MOD._SkillBook.Mist_Balrog_2000_20001035 or skillID == ___MOD._SkillBook.Shinjo_2000_20001042 or skillID == ___MOD._SkillBook.Yeti_Rider_2001_20011018 or skillID == ___MOD._SkillBook.Witchs_Broomstick_2001_20011019 or skillID == ___MOD._SkillBook.Charge_Wooden_Pony_2001_20011025 or skillID == ___MOD._SkillBook.Croco__2001_20011027 or skillID == ___MOD._SkillBook.Black_Scooter_2001_20011028 or skillID == ___MOD._SkillBook.Pink_Scooter_2001_20011029 or skillID == ___MOD._SkillBook.Nimbus_Cloud_2001_20011030 or skillID == ___MOD._SkillBook.Balrog_2001_20011031 or skillID == ___MOD._SkillBook.Race_Kart_2001_20011033 or skillID == ___MOD._SkillBook.ZD_Tiger_2001_20011034 or skillID == ___MOD._SkillBook.Mist_Balrog_2001_20011035 or skillID == ___MOD._SkillBook.Shinjo_2001_20011042
end

function PlayerSkillLogic.isSkillRidingTamingMobSkill(self, skillID, player)
  return self:getTamingMobIDFromSkillID(skillID, player) > 1932001
end

function PlayerSkillLogic.isSummonSkill(self, skillID)
  local skill = ___MOD._SkillManager:getSkill(skillID)
  if skill == nil then
    return false
  end
  return skill.summon ~= nil
end

function PlayerSkillLogic.isSwimAirborneForHurricane(self, player)
  if player == nil or player.ExtendPlayerControllerComponent == nil or not player.ExtendPlayerControllerComponent.inSwimMap then
    return false
  end
  if player.RigidbodyComponent ~= nil and not player.RigidbodyComponent:IsOnGround() then
    return true
  end
  local stateName = player.StateComponent ~= nil and player.StateComponent.CurrentStateName or ""
  if stateName == "FLY" or stateName == "JUMP" or stateName == "FALL" then
    return true
  end
  local fh = player.RigidbodyComponent ~= nil and player.RigidbodyComponent:GetCurrentFoothold() or nil
  return fh == nil
end

function PlayerSkillLogic.isTamingMobBlockedMorph(self, morphId)
  return morphId == 1000 or morphId == 1100 or morphId == 1001 or morphId == 1101 or morphId == 1002 or morphId == 1102 or morphId == 1003 or morphId == 1103
end

function PlayerSkillLogic.isTamingMobEnteringWindow(self)
  if not self._T.tamingMobEntering then
    return false
  end
  local expire = self._T.tamingMobEnteringExpire or 0
  if expire < ___MOD._UtilLogic.ElapsedSeconds then
    self._T.tamingMobEntering = nil
    self._T.tamingMobEnteringExpire = nil
    return false
  end
  return true
end

function PlayerSkillLogic.isTamingMobSkill(self, skillID, player)
  return self:getTamingMobIDFromSkillID(skillID, player) ~= 0
end

function PlayerSkillLogic.isUnableToUseSkillFieldLimitTargetSkill(self, skillID)
  return ___MOD._SkillLogic:isTeleportSkill(skillID) or ___MOD._SkillLogic:isMoveAffectedSkill(skillID) or self:isHaste(skillID) or self:isDarkSightSkill(skillID) or self:isWindWalkSkill(skillID) or skillID == ___MOD._SkillBook.Recoil_Shot_520_5201006 or skillID == ___MOD._SkillBook.Assaulter_421_4211002
end

function PlayerSkillLogic.isUsefulHasteSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Useful_Haste_000_8000 or skillID == book.Useful_Haste_1000_10008000 or skillID == book.Useful_Haste_2000_20008000 or skillID == book.Useful_Haste_2001_20018000
end

function PlayerSkillLogic.isUsefulHyperBodySkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Useful_Hyper_Body_000_8003 or skillID == book.Useful_Hyper_Body_1000_10008003 or skillID == book.Useful_Hyper_Body_2000_20008003 or skillID == book.Useful_Hyper_Body_2001_20018003
end

function PlayerSkillLogic.isUsefulMysticDoorSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Useful_Mystic_Door_000_8001 or skillID == book.Useful_Mystic_Door_1000_10008001 or skillID == book.Useful_Mystic_Door_2000_20008001 or skillID == book.Useful_Mystic_Door_2001_20018001
end

function PlayerSkillLogic.isUsefulSharpEyesSkill(self, skillID)
  local book = ___MOD._SkillBook
  return skillID == book.Useful_Sharp_Eyes_000_8002 or skillID == book.Useful_Sharp_Eyes_1000_10008002 or skillID == book.Useful_Sharp_Eyes_2000_20008002 or skillID == book.Useful_Sharp_Eyes_2001_20018002
end

function PlayerSkillLogic.isWindArcherMorphAttackSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Wind_Piercing_1311_13111006 or skillID == ___MOD._SkillBook.Wind_Shot_1311_13111007
end

function PlayerSkillLogic.isWindBooster(self, skillID)
  return skillID == ___MOD._SkillBook.Speed_Infusion_512_5121009 or skillID == ___MOD._SkillBook.Speed_Infusion_1511_15111005
end

function PlayerSkillLogic.isWindWalkSkill(self, skillID)
  return skillID == ___MOD._SkillBook.Wind_Walk_1310_13101006
end

function PlayerSkillLogic.logSkillActionLockClient(self, player, source, skillID, motion, actionLockDelay, firstAttackDelay, totalActionDelay)
  if not self:shouldLogSkillActionLock(player) then
    return
  end
  local userID = 0
  if player ~= nil and player.Player ~= nil then
    userID = player.Player.UserId
  end
end

function PlayerSkillLogic.markHurricanePrepareCooldown(self, player, currentTime)
  local state = self:getHurricaneState(player)
  state.nextPrepareTime = currentTime + 0.3
end

function PlayerSkillLogic.markTamingMobEntering(self)
  if self._T.tamingMobEntering then
    return
  end
  self._T.tamingMobEntering = true
  self._T.tamingMobEnteringExpire = ___MOD._UtilLogic.ElapsedSeconds + 1.0
end

function PlayerSkillLogic.onChangeMap(self, player)
  local job = player.Player ~= nil and player.Player.Job or nil
  if job ~= nil then
    if 500 <= job and job <= 522 then
      self:releaseEffectClient(player, ___MOD._SkillBook.Dash_500_5001005)
    elseif 1500 <= job and job <= 1512 then
      self:releaseEffectClient(player, ___MOD._SkillBook.Dash_1500_15001003)
    end
  end
end

function PlayerSkillLogic.onDoubleClickSameDirectionKey(self, player, inputDirX)
  if ___MOD._AranLogic:onDoubleClickSameDirectionKey(player, inputDirX) then
    return
  end
  local job = player.Player.Job
  if 500 <= job and job <= 522 then
    local slv = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Dash_500_5001005)
    if 0 < slv then
      self:tryUseSkillClient(player, ___MOD._SkillBook.Dash_500_5001005, slv, false, false, false)
    end
  elseif 1500 <= job and job <= 1512 then
    local slv = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Dash_1500_15001003)
    if 0 < slv then
      self:tryUseSkillClient(player, ___MOD._SkillBook.Dash_1500_15001003, slv, false, false, false)
    end
  end
end

function PlayerSkillLogic.onGround(self, player)
  local job = player.Player.Job
  if 500 <= job and job <= 522 then
    self:setVisibleEffectClient(player, ___MOD._SkillBook.Dash_500_5001005, true)
    self:setVisibleEffect(player, ___MOD._SkillBook.Dash_500_5001005, true)
  elseif 1500 <= job and job <= 1512 then
    self:setVisibleEffectClient(player, ___MOD._SkillBook.Dash_1500_15001003, true)
    self:setVisibleEffect(player, ___MOD._SkillBook.Dash_1500_15001003, true)
  end
end

function PlayerSkillLogic.onJump(self, player)
  local job = player.Player.Job
  if 500 <= job and job <= 522 then
    self:setVisibleEffectClient(player, ___MOD._SkillBook.Dash_500_5001005, false)
    self:setVisibleEffect(player, ___MOD._SkillBook.Dash_500_5001005, false)
  elseif 1500 <= job and job <= 1512 then
    self:setVisibleEffectClient(player, ___MOD._SkillBook.Dash_1500_15001003, false)
    self:setVisibleEffect(player, ___MOD._SkillBook.Dash_1500_15001003, false)
  end
end

function PlayerSkillLogic.onKeyDown(self, player, fromDoubleClick, endKeyDown, skillData, skillLevelData, skillID)
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  local pa = player.PlayerActionComponent
  if fromDoubleClick then
    return false
  end
  local soundSkillId = self:getSkillSoundRefId(skillID)
  local skillIdStr = ___MOD.string.format("%07d", soundSkillId)
  local soundPath = ___MOD.string.format("Skill.img.%s.Loop", skillIdStr)
  local ruid = ___MOD.__RUIDManager:get(soundPath)
  if not endKeyDown then
    if pa.isClimbing or pa.sitting then
      return false
    end
    if player.KeyDownComponent.onKeyDown then
      return false
    end
    if skillID == ___MOD._SkillBook.Hurricane_312_3121004 or skillID == ___MOD._SkillBook.Hurricane_1311_13111002 then
      local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(player)
      if not self:checkCanUseSkillByWeapon(skillID, weaponInfo) then
        pa.enableNextAttackTime = currentTime + 0.1
        return false
      end
    end
    local itemId, count, slot = player.CInventoryComponent:findFirstThrowing(0)
    if ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(player, skillID, skillLevelData, itemId, count, 0) ~= 0 then
      pa.enableNextBuffTime = currentTime + 0.1
      self:setCanUseSkillTime(player, skillID, currentTime + 1)
      return false
    end
    local type = 1
    if ___MOD._SkillLogic:isThrowBombSkill(skillID) then
      type = 2
    end
    player.KeyDownComponent:startKeyDown(skillID, type)
    pa:setAlert(true)
    pa:setAlertTime(___MOD._UtilLogic.ServerElapsedSeconds + 5)
    if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
      ___MOD._SoundUtils:playLoopSoundLocal(ruid, 1, ___MOD._SoundUtils.SOUND_LOOP_CATEGORY_MY)
    end
    if skillData.keydown ~= nil then
      if self:isCorkscrewSkill(skillID) then
        self:playEffectWithRenderSkillIDAndKey(player, self:getCorkscrewKeydownStorageSkillID(skillID), skillID, skillData.keydown, "corkscrewKeydown")
      else
        self:playEffect(player, skillID, skillData.keydown)
      end
    end
    return false
  else
    if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
      ___MOD._SoundUtils:stopLoopSoundLocal(ruid)
    end
    if skillData.keydown ~= nil then
      if self:isCorkscrewSkill(skillID) then
        local storageSkillID = self:getCorkscrewKeydownStorageSkillID(skillID)
        self:setVisibleEffectClient(player, storageSkillID, false)
        self:setVisibleEffect(player, storageSkillID, false)
        self:releaseEffectClient(player, storageSkillID)
        self:releaseEffect(player, storageSkillID)
      elseif self:isBigBangSkill(skillID) then
        self:forceCleanupRegularKeydownEffectDeferred(player, skillID)
      else
        self:forceCleanupRegularKeydownEffect(player, skillID)
      end
    end
    ___MOD.chargePer = player.KeyDownComponent:endKeyDown()
    if pa.isClimbing or pa.sitting then
      return false
    end
    return true
  end
end

function PlayerSkillLogic.onMesoExplosion(self, player, explodeList)

end

function PlayerSkillLogic.playAffectedEffect(self, player, skillID)
  local effect = ___MOD._SkillManager:getSkill(skillID)
  local affected = effect.affected
  if affected ~= nil then
    ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, 0, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), affected, false, false, nil)
    ___MOD._ExtendedEffectService:playSkillAnimationRemote(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, 0, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), affected, false, false, nil)
  end
end

function PlayerSkillLogic.playAlertAction(self, player)
  local pa = player.PlayerActionComponent
  if pa == nil then
    return
  end
  pa:doAction("alert", -1, player, ___MOD.SpriteAnimClipPlayType.ZigzagLoop, 0, 2)
  pa:playOnce("alert", 1.0, player)
end

function PlayerSkillLogic.playAndSetEffectEntity(self, player, data, skillID, senderUserId)

end

function PlayerSkillLogic.playAndsetEffectEntityClient(self, player, data, skillID)
  self:playAndsetEffectEntityClientWithRenderSkillID(player, data, skillID, skillID)
end

function PlayerSkillLogic.playAndsetEffectEntityClientWithRenderSkillID(self, player, data, storageSkillID, renderSkillID)
  self:playAndsetEffectEntityClientWithRenderSkillIDAndKey(player, data, storageSkillID, renderSkillID, "skillLoopAnim")
end

function PlayerSkillLogic.playAndsetEffectEntityClientWithRenderSkillIDAndKey(self, player, data, storageSkillID, renderSkillID, keyName)
  self:releaseEffectClient(player, storageSkillID)
  local isFaceLeft = player.ExtendPlayerControllerComponent.LookDirectionX == -1
  if self:isPiercingPrepareRemoteEffectSkillID(storageSkillID) then
    isFaceLeft = player.ExtendPlayerControllerComponent.LookDirectionX < 0
  end
  local ret = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.effect, renderSkillID, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), data, true, isFaceLeft, keyName)
  if ___MOD.type(ret) == "table" then
    for i = 1, #ret do
      local e = ret[i]
      if ___MOD.isvalid(e) then
        e:SetVisible(true)
      end
    end
  end
  self:applySpecialLoopEffectPlacement(storageSkillID, ret)
  if ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId] == nil then
    ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId] = {}
  end
  ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId][storageSkillID] = ret
end

function PlayerSkillLogic.playAndSetEffectEntityWithRenderSkillID(self, player, data, storageSkillID, renderSkillID, senderUserId)

end

function PlayerSkillLogic.playAndSetEffectEntityWithRenderSkillIDAndKey(self, player, data, storageSkillID, renderSkillID, keyName, senderUserId)

end

function PlayerSkillLogic.playAssassinateFollowUpVisual(self, player, skillID)
  if not self:registerAssassinateFollowUpTeleport(player) then
    return
  end
  ___MOD._SoundUtils:broadcastSoundAtPosLocal("Skill.img.4221001.Use2", player, 1)
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData ~= nil and skillData.special ~= nil then
    self:playOneShotEffect(player, skillID, skillData.special)
  end
end

function PlayerSkillLogic.playEffect(self, player, skillID, data)
  self:releaseEffectClient(player, skillID)
  self:releaseEffect(player, skillID)
  local isFaceLeft = player.ExtendPlayerControllerComponent.LookDirectionX == -1
  if data ~= nil then
    self:playAndsetEffectEntityClient(player, data, skillID)
    self:playAndSetEffectEntity(player, data, skillID)
  end
end

function PlayerSkillLogic.playEffectWithRenderSkillID(self, player, storageSkillID, renderSkillID, data)
  self:playEffectWithRenderSkillIDAndKey(player, storageSkillID, renderSkillID, data, "skillLoopAnim")
end

function PlayerSkillLogic.playEffectWithRenderSkillIDAndKey(self, player, storageSkillID, renderSkillID, data, keyName)
  self:releaseEffectClient(player, storageSkillID)
  self:releaseEffect(player, storageSkillID)
  if data ~= nil then
    self:playAndsetEffectEntityClientWithRenderSkillIDAndKey(player, data, storageSkillID, renderSkillID, keyName)
    self:playAndSetEffectEntityWithRenderSkillIDAndKey(player, data, storageSkillID, renderSkillID, keyName)
  end
end

function PlayerSkillLogic.playHurricaneKeydownEndEffectRemote(self, player, skillID, data)
  if data == nil then
    return
  end
  local remoteSkillID = self:getHurricaneKeydownEndRemoteEffectSkillID(skillID)
  self:releaseEffect(player, remoteSkillID)
  self:playAndSetEffectEntity(player, data, remoteSkillID)
  local delaySec = ___MOD.math.max(0.1, (___MOD.tonumber(data.totalDelay) or 0) / 1000)
  ___MOD._TimerService:SetTimerOnce(function()
    self:releaseEffect(player, remoteSkillID)
  end, delaySec)
end

function PlayerSkillLogic.playHurricanePrepareEffectRemote(self, player, skillID, data)
  if data == nil then
    return
  end
  local remoteSkillID = self:getHurricanePrepareRemoteEffectSkillID(skillID)
  self:releaseEffect(player, remoteSkillID)
  self:playAndSetEffectEntity(player, data, remoteSkillID)
end

function PlayerSkillLogic.playOneShotEffect(self, player, skillID, data)
  if data ~= nil then
    ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, data, 1.0)
  end
end

function PlayerSkillLogic.playPiercingKeydownEndEffectRemote(self, player, skillID, data)
  if data == nil then
    return
  end
  local remoteSkillID = self:getPiercingKeydownEndRemoteEffectSkillID(skillID)
  self:releaseEffect(player, remoteSkillID)
  self:playAndSetEffectEntity(player, data, remoteSkillID)
  local delaySec = ___MOD.math.max(0.1, (___MOD.tonumber(data.totalDelay) or 0) / 1000)
  ___MOD._TimerService:SetTimerOnce(function()
    self:releaseEffect(player, remoteSkillID)
  end, delaySec)
end

function PlayerSkillLogic.playPiercingPrepareEffectRemote(self, player, skillID, data)
  if data == nil then
    return
  end
  local remoteSkillID = self:getPiercingPrepareRemoteEffectSkillID(skillID)
  self:releaseEffect(player, remoteSkillID)
  self:playAndSetEffectEntity(player, data, remoteSkillID)
end

function PlayerSkillLogic.playTamingMobMountSoundClient(self, player)
  local soundSkillId = self:getSkillSoundRefId(___MOD._SkillBook.Battleship_522_5221006)
  local idStr = ___MOD.string.format("%07d", soundSkillId)
  ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", idStr), player, 1)
end

function PlayerSkillLogic.playTrackedLoopEffectForState(self, state, fieldName, player, skillID, data)
  self:releaseTrackedEffectEntities(state[fieldName])
  state[fieldName] = nil
  if data == nil then
    return
  end
  state[fieldName] = ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, data, 1.0)
end

function PlayerSkillLogic.playTrackedPrepareEffect(self, player, skillID, data)
  local state = self:getHurricaneState(player)
  self:releaseTrackedEffectEntities(state.prepareEffectEntities)
  state.prepareEffectEntities = nil
  if data == nil then
    return
  end
  state.prepareEffectEntities = ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, data, 1.0)
end

function PlayerSkillLogic.playTrackedPrepareEffectForState(self, state, player, skillID, data)
  self:releaseTrackedEffectEntities(state.prepareEffectEntities)
  state.prepareEffectEntities = nil
  if data == nil then
    return
  end
  state.prepareEffectEntities = ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, data, 1.0)
  if skillID == 3221001 then
    local left = 0 > player.ExtendPlayerControllerComponent.LookDirectionX
    if ___MOD.type(state.prepareEffectEntities) == "table" then
      for i = 1, #state.prepareEffectEntities do
        local e = state.prepareEffectEntities[i]
        if ___MOD.isvalid(e) and ___MOD.isvalid(e.AnimationSpriteComponent) then
          e.AnimationSpriteComponent:setLeftFacing(left)
        end
      end
    elseif ___MOD.isvalid(state.prepareEffectEntities) and ___MOD.isvalid(state.prepareEffectEntities.AnimationSpriteComponent) then
      state.prepareEffectEntities.AnimationSpriteComponent:setLeftFacing(left)
    end
  end
end

function PlayerSkillLogic.registerAssassinateFollowUpTeleport(self, player)
  local targetPos = self:getAssassinateFollowUpTargetPos(player)
  if targetPos == nil then
    return false
  end
  local info = ___MOD.TeleportCtx()
  info.valid = true
  info.start = ___MOD._UtilLogic.ElapsedSeconds
  info.coolTimeEnd = info.start + 0.12
  info.position = targetPos
  info.byPortal = false
  info.playEffect = false
  ___MOD._PlayerUpdateLogic.teleport = info
  local state = self:getAssassinateState(player)
  local dir = state.followUpMoveDirX or player.ExtendPlayerControllerComponent.LookDirectionX
  local temporary = player.PlayerTemporaryStatComponent
  if dir ~= 0 and (temporary == nil or temporary:getValue(___MOD._CTS.Stun) == 0) then
    player.MovementComponent:MoveToDirection(___MOD.FastVector2(0.02 * dir, 0), 0)
  end
  return true
end

function PlayerSkillLogic.releaseDirectionKey(self, player)
  local job = player.Player.Job
  if 500 <= job and job <= 522 then
    player.PlayerTemporaryStatComponent:resetTemporaryStat(___MOD._SkillBook.Dash_500_5001005)
  elseif 1500 <= job and job <= 1512 then
    player.PlayerTemporaryStatComponent:resetTemporaryStat(___MOD._SkillBook.Dash_1500_15001003)
  end
end

function PlayerSkillLogic.releaseEffect(self, player, skillID, senderUserId)

end

function PlayerSkillLogic.releaseEffectClient(self, player, skillID)
  local pool = ___MOD._UserService.LocalPlayer.PlayerVariables.loopEffectAnimPool
  if ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId] ~= nil then
    local e = ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId][skillID]
    if ___MOD.type(e) == "table" then
      for i = 1, #e do
        local entity = e[i]
        if entity ~= nil then
          entity.Visible = false
          if ___MOD.isvalid(entity) then
            entity:SetVisible(false)
          end
          local asc = entity.AnimationSpriteComponent
          if ___MOD.isvalid(asc) then
            asc:release()
          end
          ___MOD._ObjectPool:release(pool, entity, false)
        end
      end
      ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId][skillID] = nil
    elseif e ~= nil then
      e.Visible = false
      if ___MOD.isvalid(e) then
        e:SetVisible(false)
      end
      local asc = e.AnimationSpriteComponent
      if ___MOD.isvalid(asc) then
        asc:release()
      end
      ___MOD._ObjectPool:release(pool, e, false)
      ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId][skillID] = nil
    end
  end
end

function PlayerSkillLogic.releaseHurricanePrepareEffectRemote(self, player, skillID)
  self:releaseEffect(player, self:getHurricanePrepareRemoteEffectSkillID(skillID))
end

function PlayerSkillLogic.releaseHurricaneTrackedEffects(self, player, skillID, state)
  self:releaseTrackedEffectEntities(state.prepareEffectEntities)
  state.prepareEffectEntities = nil
  self:releaseTrackedEffectEntities(state.loopEffectEntities)
  state.loopEffectEntities = nil
  self:releaseTrackedEffectEntities(state.loopEffectBackEntities)
  state.loopEffectBackEntities = nil
  self:releaseHurricanePrepareEffectRemote(player, skillID)
end

function PlayerSkillLogic.releasePiercingPrepareEffectRemote(self, player, skillID)
  self:releaseEffect(player, self:getPiercingPrepareRemoteEffectSkillID(skillID))
end

function PlayerSkillLogic.releasePiercingPrepareState(self, player, skillID, state)
  state.prepareReleased = true
  self:releaseTrackedEffectEntities(state.prepareEffectEntities)
  state.prepareEffectEntities = nil
  self:releasePiercingPrepareEffectRemote(player, skillID)
  self:stopPiercingKeydownFacingSyncClient(player)
  self:stopPiercingKeydownFacingSync(player)
end

function PlayerSkillLogic.releaseTrackedEffectEntities(self, entities)
  if entities == nil then
    return
  end
  for i = 1, #entities do
    local e = entities[i]
    if ___MOD.isvalid(e) then
      e.Visible = false
      e:SetVisible(false)
      local asc = e.AnimationSpriteComponent
      if ___MOD.isvalid(asc) then
        asc:release()
      end
    end
  end
end

function PlayerSkillLogic.removeDropFromExplodeClient(self, map, explodeList, exceptPlayer)
  if ___MOD._UserService.LocalPlayer == exceptPlayer then
    return
  end
  if not ___MOD.isvalid(map) then
    return
  end
  local skillData = ___MOD._SkillManager:getSkill(___MOD._SkillBook.Meso_Explosion_421_4211006)
  if skillData == nil then
    return
  end
  local hit = skillData.hit
  if hit == nil then
    return
  end
  local shouldReleaseDrop = exceptPlayer ~= nil
  for _, dropID in ___MOD.pairs(explodeList) do
    local hitIndex = ___MOD._GlobalRand32:randomIntegerRange(1, 9)
    local mapLife = map.MapLifeComponent
    local dropEntity = mapLife.dropItemPool[dropID]
    if dropEntity ~= nil then
      dropEntity:SetVisible(false)
      ___MOD._ExtendedEffectService:playAnimationOnMap(map, hit[hitIndex], dropEntity.TransformComponent:PositionAsFastVector3(), nil, nil, nil, false, false, nil, nil)
      if shouldReleaseDrop then
        mapLife.dropItemPool[dropID] = nil
        dropEntity.CDropItemComponent:release()
      end
    end
  end
end

function PlayerSkillLogic.resetAllSkillCooldowns(self, player, exceptSkillID)

end

function PlayerSkillLogic.resetAllSkillCooldownsClient(self, player, exceptSkillID)
  self:applyResetAllSkillCooldowns(player, exceptSkillID)
end

function PlayerSkillLogic.resetHurricaneHiddenKeydownState(self, player)
  if player.PlayerVariables ~= nil then
    player.PlayerVariables:setHiddenKeydownStateClient(false, 0)
    player.PlayerVariables:setHiddenKeydownState(false, 0)
  end
end

function PlayerSkillLogic.resetPiercingHiddenKeydownState(self, player)
  if player.PlayerVariables ~= nil then
    player.PlayerVariables:setHiddenKeydownStateClient(false, 0)
    player.PlayerVariables:setHiddenKeydownState(false, 0)
  end
end

function PlayerSkillLogic.restoreDefaultActionAfterKeydown(self, player)
  local pa = player.PlayerActionComponent
  if pa == nil then
    return
  end
  self:finishKeydownControlledAction(player)
  self:playAlertAction(player)
end

function PlayerSkillLogic.restoreHurricaneActionAfterKeydown(self, player, state)
  local pa = player.PlayerActionComponent
  if pa == nil then
    return
  end
  self:finishKeydownControlledAction(player)
  if player.Player:isDead() then
    return
  end
  if state.wasSwimAirborne == true then
    self:applySwimFlyPoseForHurricane(player)
    return
  end
  self:playAlertAction(player)
end

function PlayerSkillLogic.restorePiercingActionAfterKeydown(self, player)
  local pa = player.PlayerActionComponent
  if pa == nil then
    return
  end
  if pa.isClimbing then
    pa:cancelActionControlClient(player)
    pa:clearActionFreeze()
    pa:setControllEnable(___MOD._ControllEnableType.SkillUseDelay, false)
    pa:ladderOnOff(true)
    local ac = "ladder"
    if player.StateComponent.CurrentStateName == "CLIMB" then
      ac = "rope"
    end
    pa:doAction(ac, -1, player, ___MOD.SpriteAnimClipPlayType.ZigzagLoop, 0, ac == "rope" and 1 or 2)
    return
  end
  self:restoreDefaultActionAfterKeydown(player)
end

function PlayerSkillLogic.scheduleAssassinateFinishAttack(self, player, skillID, skillLevel, lastAttackMobs)
  local state = self:getAssassinateState(player)
  if lastAttackMobs == nil or #lastAttackMobs <= 0 then
    return
  end
  self:clearAssassinateFollowUpTimer(state)
  local copiedMobs = {}
  for i = 1, #lastAttackMobs do
    copiedMobs[i] = lastAttackMobs[i]
  end
  local delaySec = self:getAssassinateFollowUpDelaySec(player, skillID)
  state.followUpTimer = ___MOD._TimerService:SetTimerOnce(function()
    state.followUpTimer = nil
    if player == nil or player.Player == nil or player.Player:isDead() then
      return
    end
    local pa = player.PlayerActionComponent
    if pa == nil then
      return
    end
    state.inFollowUp = true
    if player.PlayerHitComponent ~= nil then
      player.PlayerHitComponent.hitTime = ___MOD.math.max(player.PlayerHitComponent.hitTime, ___MOD._UtilLogic.ServerElapsedSeconds + 1)
    end
    self:playAssassinateFollowUpVisual(player, skillID)
    pa.enableNextAttackTime = 0
    pa.enableNextBuffTime = 0
    ___MOD._PlayerAttackLogic_Melee:tryMeleeAttack(player, skillID, skillLevel, pa, ___MOD._PlayerAttackLogic:getWeaponInfo(player), false, 0.0, "assassinationS", true, copiedMobs)
    state.inFollowUp = false
  end, delaySec)
end

function PlayerSkillLogic.scheduleAssassinateFollowUp(self, player, skillID, skillLevel)
  local state = self:getAssassinateState(player)
  if state.inFollowUp == true or state.lastHitHasTarget ~= true then
    return
  end
  self:clearAssassinateFollowUpTimer(state)
  local delaySec = self:getAssassinateFollowUpDelaySec(player, skillID)
  state.followUpTimer = ___MOD._TimerService:SetTimerOnce(function()
    self:triggerAssassinateFollowUp(player, skillID, skillLevel)
  end, delaySec)
end

function PlayerSkillLogic.setAvatarAlpha(self, player, alpha, senderUserId)

end

function PlayerSkillLogic.setAvatarAlphaClient(self, player, alpha)
  player.AvatarRendererComponent:SetAlpha(alpha)
  if player.MorphComponent ~= nil then
    player.MorphComponent:applyMorphAlphaClient(alpha)
  end
end

function PlayerSkillLogic.setCanUseSkillTime(self, player, skillID, nextTime)
  local canUseSkills = player.PlayerVariables.canUseSkills
  if canUseSkills == nil then
    canUseSkills = {}
    player.PlayerVariables.canUseSkills = canUseSkills
  end
  canUseSkills[skillID] = nextTime
  canUseSkills[___MOD.tostring(skillID)] = nil
end

function PlayerSkillLogic.setCanUseSkillTimeClient(self, player, skillID, nextTime)
  self:setCanUseSkillTime(player, skillID, nextTime)
end

function PlayerSkillLogic.setSkillCooldownEndTime(self, player, skillID, endTime)
  local cooltimes = player.PlayerVariables.skillCooltimes
  if cooltimes == nil then
    cooltimes = {}
    player.PlayerVariables.skillCooltimes = cooltimes
  end
  cooltimes[skillID] = endTime
  cooltimes[___MOD.tostring(skillID)] = nil
end

function PlayerSkillLogic.setSkillCooldownEndTimeClient(self, player, skillID, endTime)
  self:setSkillCooldownEndTime(player, skillID, endTime)
end

function PlayerSkillLogic.setTrackedEffectEntitiesRear(self, entities)
  if entities == nil then
    return
  end
  for i = 1, #entities do
    local e = entities[i]
    if not ___MOD.isvalid(e) or ___MOD.isvalid(e.TransformComponent) then
    end
  end
end

function PlayerSkillLogic.setVisibleEffect(self, player, skillID, visible, senderUserId)

end

function PlayerSkillLogic.setVisibleEffectClient(self, player, skillID, visible)
  local mapObjectPool = player.CurrentMap.MapObjectPool
  if not ___MOD.isvalid(mapObjectPool) then
    return
  end
  if ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId] ~= nil then
    local effect = ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties[player.Player.PlayerId][skillID]
    if ___MOD.type(effect) == "table" then
      for i = 1, #effect do
        local e = effect[i]
        if ___MOD.isvalid(e) then
          e:SetVisible(visible)
        end
      end
    elseif ___MOD.isvalid(effect) then
      effect:SetVisible(visible)
    end
  end
end

function PlayerSkillLogic.shiftThunderChargeToAssist(self, player)

end

function PlayerSkillLogic.shouldBlockOtherActionByExclusiveKeydown(self, player, skillID, endKeyDown)
  if ___MOD._SkillLogic:isTeleportSkill(skillID) then
    return false
  end
  local activeSkillID = 0
  local keyDown = player.KeyDownComponent
  if keyDown ~= nil and keyDown.onKeyDown then
    activeSkillID = ___MOD.tonumber(keyDown.skillID) or 0
  elseif player.PlayerVariables.hiddenKeydownActive then
    activeSkillID = ___MOD.tonumber(player.PlayerVariables.hiddenKeydownSkillID) or 0
  end
  if activeSkillID == 0 then
    return false
  end
  if skillID == activeSkillID then
    return false
  end
  return true
end

function PlayerSkillLogic.shouldBlockWindArcherMorphAttackSkill(self, player, skillID, morphId)
  if not self:isWindArcherMorphAttackSkill(skillID) or morphId == 1003 or morphId == 1103 then
    return false
  end
  local pa = player.PlayerActionComponent
  local current = ___MOD._UtilLogic.ElapsedSeconds
  if pa.nextDisplayAttackMessageTime == 0 or current >= pa.nextDisplayAttackMessageTime then
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에만 사용할 수 있는 스킬입니다.")
    pa.nextDisplayAttackMessageTime = current + 0.5
  end
  return true
end

function PlayerSkillLogic.shouldLogSkillActionLock(self, player)
  if ___MOD.Environment:IsMakerPlay() then
    return true
  end
  if player == nil or player.PlayerVariables == nil then
    return false
  end
  return player.PlayerVariables.debugMode == true
end

function PlayerSkillLogic.shouldSyncTeleportLockWithAttack(self, skillID)
  return skillID == ___MOD._SkillBook.Meteor_Shower_212_2121007 or skillID == ___MOD._SkillBook.Blizzard_222_2221007 or skillID == ___MOD._SkillBook.Genesis_232_2321008 or skillID == ___MOD._SkillBook.Meteor_Shower_1211_12111003 or skillID == ___MOD._SkillBook.Explosion_211_2111002
end

function PlayerSkillLogic.spawnHurricaneBulletClient(self, player, skillID)
  if player == nil or player.CurrentMap == nil or player.Player == nil then
    return
  end
  local skillLevel = player.SkillComponent ~= nil and player.SkillComponent:getSkillLevel(skillID) or 0
  if skillLevel <= 0 then
    return
  end
  local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(player)
  if weaponInfo == nil or weaponInfo.disabled or not weaponInfo.valid then
    return
  end
  if (skillID == ___MOD._SkillBook.Hurricane_312_3121004 or skillID == ___MOD._SkillBook.Hurricane_1311_13111002) and not self:checkCanUseSkillByWeapon(skillID, weaponInfo) then
    self:finishHurricaneKeydown(player, skillID, nil, true)
    return
  end
  if not self:isRapidFireSkill(skillID) then
    local soundSkillId = self:getSkillSoundRefId(skillID)
    local skillIdStr = ___MOD.string.format("%07d", soundSkillId)
    ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", skillIdStr), player, 1)
  end
  local ctx = ___MOD._PlayerAttackLogic_Melee:initSkillCtx(player, skillID, skillLevel, weaponInfo, false, true, false)
  if ctx == nil then
    return
  end
  local pos = player.TransformComponent:PositionAsFastVector3()
  local startPos = pos:Clone():ToVector2()
  local shootRange = ___MOD._PlayerAttackLogic_Shoot:getShootStartRange(skillID)
  local playerInputX = player.PlayerControllerComponent.LookDirectionX
  local isFaceLeft = playerInputX == -1
  if isFaceLeft then
    startPos.x = startPos.x - shootRange
  else
    startPos.x = startPos.x + shootRange
  end
  startPos.y = startPos.y + 0.28
  local itemId = 0
  local count = 0
  local slot = 0
  itemId, count, slot = player.CInventoryComponent:findFirstThrowing(0)
  local item = 0 < itemId and ___MOD._ItemManager:getItemById(itemId) or nil
  local bullet = item ~= nil and item.bullet or nil
  local mapleRange = 400
  if ctx.skillLevelData ~= nil and ___MOD.tonumber(ctx.skillLevelData.range) ~= nil and 0 < ___MOD.tonumber(ctx.skillLevelData.range) then
    mapleRange = ___MOD.tonumber(ctx.skillLevelData.range)
  end
  local boxShape = ___MOD._PlayerAttackLogic_Shoot:makeBoxShapeFromLtRb(startPos, ___MOD.FastVector2(-mapleRange, 1), ___MOD.FastVector2.zero:Clone(), isFaceLeft)
  local mobs = {}
  local range = mapleRange / 100
  ___MOD._PlayerAttackLogic_Shoot:findHitMobInTrapezoid(startPos.x, shootRange, range, startPos.y, 4, mobs, isFaceLeft, boxShape, player, nil)
  if 1 < #mobs then
    local function getDistance(e)
      if ___MOD.isvalid(e) and e.TriggerComponent ~= nil then
        local pt = ___MOD._PlayerAttackLogic_Shoot:intersectBox(___MOD._PlayerAttackLogic_Shoot:triggerToBox(e.TriggerComponent), boxShape)

        if pt == nil then
          return ___MOD.math.huge
        end
        return startPos:Distance(pt)
      end
      return startPos:Distance(e.TransformComponent:PositionAsFastVector3():ToVector2())
    end

    ___MOD.table.sort(mobs, function(a, b)
      return getDistance(a) < getDistance(b)
    end)
  end
  if 1 < #mobs then
    local firstMob = mobs[1]
    mobs = {firstMob}
  end
  local soulArrowSkillID = 0
  if player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.NonComsumeBullet) ~= 0 then
    soulArrowSkillID = player.PlayerTemporaryStatComponent:getSkillID(___MOD._CTS.NonComsumeBullet)
  end
  ___MOD._PlayerAttackLogic_Shoot:createBulletClient(player.CurrentMap, player, mobs, 1, 0, 0, startPos, bullet, weaponInfo.weaponType, isFaceLeft, false, false, boxShape, mapleRange, soulArrowSkillID, ctx)
  if #mobs <= 0 then
    local emptySad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(ctx.skillID, ctx.skillLevel, startPos, playerInputX, 1, 1, ctx.motion, ___MOD._SkillAttackType.Shoot, {}, {}, {}, {}, 0, ctx.playRate, isFaceLeft, 0, itemId, mapleRange, 0, slot, nil, 0.0, ctx.finishAttack, nil)
    ___MOD._PlayerAttackLogic:onPlayerAttack(player, emptySad:toTable())
    ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(player)
    return
  end
  if 0 < #mobs then
    local mob = mobs[1]
    local hitPt = ___MOD._PlayerAttackLogic_Shoot:getHitPointByBox(mob, boxShape)
    local distance = startPos:Distance(hitPt)
    local ballDelay = distance * 150
    local attackCount = ctx.skillLevelData ~= nil and (ctx.skillLevelData.attackCount or 0) or 0
    if attackCount <= 0 then
      attackCount = 1
    end
    local damageDelays = {}
    for i = 1, attackCount do
      damageDelays[i] = ballDelay
    end
    local damages, criticals, highestDamage = ___MOD._PlayerAttackLogic:calcDamageClient(player, mob, ctx.skillID, ctx.skillLevel, attackCount, damageDelays, ctx.motion, 0, 1, slot, 1, 0, ctx.finishAttack)
    local damagesByMob = {damages}
    local criticalsByMob = {criticals}
    local delaysByMob = {damageDelays}
    local totalDelay = ballDelay / 1000
    local totalDamage, deadlyAttack = ___MOD._PlayerAttackLogic:onAttackClient(player, mob, damages)
    local attackerPosSnapshot = player.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
    if ctx.skillID ~= ___MOD._SkillBook.Hypnotize_522_5221009 then
      ___MOD._PlayerAttackLogic:displaySkillDamageByAttackerClient(player, mob, ctx.skillID, damages, criticals, damageDelays)
    end
    local sad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(ctx.skillID, ctx.skillLevel, attackerPosSnapshot, playerInputX, 1, attackCount, ctx.motion, ___MOD._SkillAttackType.Shoot, mobs, damagesByMob, criticalsByMob, delaysByMob, 0, ctx.playRate, isFaceLeft, 0, itemId, mapleRange, 0, slot, nil, 0.0, ctx.finishAttack, nil)
    ___MOD._PlayerAttackLogic:applyPendingWindWalkAttackBoost(player, sad)
    ___MOD._PlayerAttackLogic:onPlayerAttack(player, sad:toTable())
    ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(player)
  end
end

function PlayerSkillLogic.startHiddenKeyDown(self, player, skillID)
  local keyDown = player.KeyDownComponent
  if keyDown == nil then
    return
  end
  keyDown.startTime = ___MOD._UtilLogic.ElapsedSeconds
  keyDown.percentage = 0
  keyDown.onKeyDown = true
  keyDown.skillID = skillID
  keyDown.maxChargeTime = ___MOD.math.max(0.1, ___MOD._SkillLogic:getMaxGaugeTime(skillID) / 1000)
  if ___MOD.isvalid(keyDown.parent) then
    keyDown.parent.Enable = false
  end
  if player.PlayerVariables ~= nil then
    player.PlayerVariables:setHiddenKeydownStateClient(true, skillID)
    player.PlayerVariables:setHiddenKeydownState(true, skillID)
  end
end

function PlayerSkillLogic.startHurricaneKeyDownEffect(self, player, skillID, skillData)
  local state = self:getHurricaneState(player)
  self:freezeHurricanePreparePose(player, skillData)
  self:startHiddenKeyDown(player, skillID)
  if player.PlayerVariables ~= nil then
    player.PlayerVariables:setHiddenKeydownStateClient(true, skillID)
    player.PlayerVariables:setHiddenKeydownState(true, skillID)
  end
  self:ensureHurricaneAttackLoop(player, skillID, skillData)
  if self:isRapidFireSkill(skillID) and skillData ~= nil and skillData.keydown ~= nil then
    self:playEffectWithRenderSkillIDAndKey(player, skillID, skillID, skillData.keydown, "rapidFireKeydown")
  elseif skillData ~= nil and skillData.keydown ~= nil then
    self:playEffectWithRenderSkillIDAndKey(player, skillID, skillID, skillData.keydown, "hurricaneKeydown")
  end
  if self:isRapidFireSkill(skillID) and skillData ~= nil and skillData.keydown0 ~= nil then
    self:playEffectWithRenderSkillIDAndKey(player, self:getRapidFireKeydown0StorageSkillID(skillID), skillID, skillData.keydown0, "rapidFireKeydown0")
  end
end

function PlayerSkillLogic.startPiercingKeyDownEffect(self, player, skillID, skillData)
  local state = self:getPiercingState(player)
  local pa = player.PlayerActionComponent
  local keyDown = player.KeyDownComponent
  if keyDown ~= nil and (not keyDown.onKeyDown or keyDown.skillID ~= skillID) then
    keyDown:startKeyDown(skillID, 2)
  end
  state.inputLock = true
  state.loopStarted = true
  self:releaseTrackedEffectEntities(state.prepareEffectEntities)
  state.prepareEffectEntities = nil
  self:releasePiercingPrepareEffectRemote(player, skillID)
  self:stopPiercingKeydownFacingSyncClient(player)
  self:startPiercingKeydownFacingSyncClient(player, skillID)
  self:startPiercingKeydownFacingSync(player, skillID)
  if pa ~= nil then
    pa:setControllEnable(___MOD._ControllEnableType.SkillUseDelay, false)
    pa:ladderOnOff(true)
  end
  if skillData ~= nil and skillData.keydown ~= nil then
    self:playEffectWithRenderSkillIDAndKey(player, skillID, skillID, skillData.keydown, "piercingKeydown")
    self:setVisibleEffectClient(player, skillID, true)
    self:setVisibleEffect(player, skillID, true)
  end
end

function PlayerSkillLogic.startPiercingKeydownFacingSync(self, player, skillID, senderUserId)

end

function PlayerSkillLogic.startPiercingKeydownFacingSyncClient(self, player, skillID)
  if not ___MOD.isvalid(player) then
    return
  end
  local state = self:getPiercingState(player)
  if state.facingTimer ~= nil then
    ___MOD._TimerService:ClearTimer(state.facingTimer)
    state.facingTimer = nil
  end
  local facingTimer

  local function clearFacingTimer()
    if facingTimer ~= nil then
      ___MOD._TimerService:ClearTimer(facingTimer)
    end
    if state.facingTimer == facingTimer then
      state.facingTimer = nil
    end
  end

  facingTimer = ___MOD._TimerService:SetTimerRepeat(function()
    local localPlayer = ___MOD._UserService.LocalPlayer
    if not ___MOD.isvalid(player) or not ___MOD.isvalid(localPlayer) then
      clearFacingTimer()
      return
    end
    local playerComponent = player.Player
    local playerVariables = localPlayer.PlayerVariables
    local controller = player.ExtendPlayerControllerComponent
    if not (___MOD.isvalid(playerComponent) and ___MOD.isvalid(playerVariables)) or not ___MOD.isvalid(controller) then
      clearFacingTimer()
      return
    end
    self:syncPiercingChargeDirection(player)
    local loopMap = playerVariables.loopSkillEnties
    local byPlayer = loopMap ~= nil and loopMap[playerComponent.PlayerId] or nil
    local effect = byPlayer ~= nil and byPlayer[skillID] or nil
    local prepareRemoteSkillID = self:getPiercingPrepareRemoteEffectSkillID(skillID)
    local prepareRemoteEffect = byPlayer ~= nil and byPlayer[prepareRemoteSkillID] or nil
    local prepareLocalEffect = state.prepareEffectEntities
    local left = controller.LookDirectionX == -1
    if ___MOD.type(prepareLocalEffect) == "table" then
      for i = 1, #prepareLocalEffect do
        local e = prepareLocalEffect[i]
        if ___MOD.isvalid(e) and ___MOD.isvalid(e.AnimationSpriteComponent) then
          e.AnimationSpriteComponent:setLeftFacing(left)
        end
      end
    elseif ___MOD.isvalid(prepareLocalEffect) and ___MOD.isvalid(prepareLocalEffect.AnimationSpriteComponent) then
      prepareLocalEffect.AnimationSpriteComponent:setLeftFacing(left)
    end
    if ___MOD.type(prepareRemoteEffect) == "table" then
      for i = 1, #prepareRemoteEffect do
        local e = prepareRemoteEffect[i]
        if ___MOD.isvalid(e) and ___MOD.isvalid(e.AnimationSpriteComponent) then
          e.AnimationSpriteComponent:setLeftFacing(left)
        end
      end
    elseif ___MOD.isvalid(prepareRemoteEffect) and ___MOD.isvalid(prepareRemoteEffect.AnimationSpriteComponent) then
      prepareRemoteEffect.AnimationSpriteComponent:setLeftFacing(left)
    end
    if ___MOD.type(effect) == "table" then
      for i = 1, #effect do
        local e = effect[i]
        if ___MOD.isvalid(e) and ___MOD.isvalid(e.AnimationSpriteComponent) then
          e.AnimationSpriteComponent:setLeftFacing(left)
        end
      end
    elseif ___MOD.isvalid(effect) and ___MOD.isvalid(effect.AnimationSpriteComponent) then
      effect.AnimationSpriteComponent:setLeftFacing(left)
    end
  end, 0.05, 0.05)
  state.facingTimer = facingTimer
end

function PlayerSkillLogic.stopPiercingKeydownFacingSync(self, player, senderUserId)

end

function PlayerSkillLogic.stopPiercingKeydownFacingSyncClient(self, player)
  local state = self:getPiercingState(player)
  local h = state ~= nil and state.facingTimer or nil
  if h ~= nil then
    ___MOD._TimerService:ClearTimer(h)
    state.facingTimer = nil
  end
end

function PlayerSkillLogic.syncLookDirectionByHorizontalInput(self, player)
  local leftPressed = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.LeftArrow)
  local rightPressed = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.RightArrow)
  if leftPressed == rightPressed then
    return false
  end
  local dir = leftPressed and -1 or 1
  if player.PlayerControllerComponent ~= nil then
    player.PlayerControllerComponent.LookDirectionX = dir
  end
  if player.ExtendPlayerControllerComponent ~= nil then
    player.ExtendPlayerControllerComponent.LookDirectionX = dir
    player.ExtendPlayerControllerComponent.FixedLookAt = 0
  end
  return true
end

function PlayerSkillLogic.syncPiercingChargeDirection(self, player)
  local pa = player.PlayerActionComponent
  if pa ~= nil and pa.isClimbing then
    return
  end
  self:syncLookDirectionByHorizontalInput(player)
end

function PlayerSkillLogic.triggerAssassinateFollowUp(self, player, skillID, skillLevel)
  local state = self:getAssassinateState(player)
  self:clearAssassinateFollowUpTimer(state)
  state.inFollowUp = true
  self:registerAssassinateFollowUpTeleport(player)
  ___MOD._SoundUtils:broadcastSoundAtPosLocal("Skill.img.4221001.Use2", player, 1)
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData ~= nil and skillData.special ~= nil then
    self:playOneShotEffect(player, skillID, skillData.special)
  end
  local pa = player.PlayerActionComponent
  pa.enableNextAttackTime = 0
  pa.enableNextBuffTime = 0
  ___MOD._PlayerAttackLogic_Melee:tryMeleeAttack(player, skillID, skillLevel, pa, ___MOD._PlayerAttackLogic:getWeaponInfo(player), false, 0.0, "assassinationS", true, nil)
  state.inFollowUp = false
end

function PlayerSkillLogic.tryActiveSkill(self, caster, player, skillID, skillLevel, skillData, skillLevelData, totalTargetOnlyPlayer)

end

function PlayerSkillLogic.tryDoubleJump(self, player, fromSkillUse)
  if player.CurrentMap.MapInfoComponent:checkFieldLimit(___MOD._FieldLimit.UnableToUseSkill) then
    return
  elseif player.TamingMobComponent ~= nil and player.TamingMobComponent.onTaming then
    return
  elseif not player.Player.canDoubleJump then
    return
  elseif player.RigidbodyComponent:IsOnGround() then
    return
  elseif player.PlayerActionComponent.isClimbing or player.PlayerActionComponent.sitting then
    return
  elseif player.ExtendPlayerControllerComponent.inSwimMap then
    return
  elseif player.Player:isDead() then
    return
  elseif player.PlayerVariables.jumpCount <= 0 then
    return
  elseif ___MOD._PlayerVecCtrl:isImpactMoving() then
    return
  end
  local ts = player.PlayerTemporaryStatComponent
  local morphId = ts:getValue(___MOD._CTS.Morph)
  if morphId ~= 0 and morphId ~= 1000 and morphId ~= 1100 and morphId ~= 1001 and morphId ~= 1101 and morphId ~= 1003 and morphId ~= 1103 then
    if self:isMorphCancelable(player) then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에는 할 수 없습니다. 오른쪽 위의 아이콘을 우클릭하여 변신을 해제할 수 있습니다.")
    else
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에는 할 수 없습니다.")
    end
    return
  end
  local rv = player.RigidbodyComponent.RealMoveVelocity
  local faceLeft = player.ExtendPlayerControllerComponent.LookDirectionX == -1
  local dir = faceLeft and -1 or 1
  if rv.y < -0.025 or rv.y == 0 then
    return
  end
  if not (ts:getTemporaryStatData(___MOD._CTS.DarkSight) == nil and ts:getTemporaryStatData(___MOD._CTS.WindWalk) == nil and ts:getValue(___MOD._CTS.Seal) == 0 and (ts:getValue(___MOD._CTS.Attract) == 0 or self:isHerosWill(___MOD.skillID))) or ts:getValue(___MOD._CTS.Stun) ~= 0 then
    return
  end
  local testSkill = player.QuestComponent:getQuestEx(99999, "fj") == "1"
  if not testSkill and not fromSkillUse then
    return
  end
  local skillID = 0
  local skillLevel = 0
  local sc = player.SkillComponent
  if not ___MOD.isvalid(sc) then
    return
  end
  if testSkill then
    skillID = ___MOD._SkillBook.Flash_Jump_1410_14101004
    skillLevel = 20
  else
    for _, sid in ___MOD.pairs(self:getDoubleJumpSkillList()) do
      local slv = sc:getSkillLevel(sid)
      if 0 < slv then
        skillID = sid
        skillLevel = slv
        break
      end
    end
  end
  if skillLevel <= 0 then
    return
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData == nil then
    return
  end
  local skillLevelData = skillData.level[skillLevel]
  if skillLevelData == nil then
    return
  end
  if ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(player, skillID, skillLevelData, 0, 0, 0) ~= 0 then
    return
  end
  local vx, vy = 0, 0
  vx = 0.4 * (skillLevel / 4) + 3.5
  vy = 0.2 * (skillLevel / 4) + 2.5
  ___MOD._PlayerVecCtrl:SetImpactNext(vx * dir, vy)
  local path = "BasicEff.img/Flying"
  if skillID == ___MOD._SkillBook.Flash_Jump_1410_14101004 then
    path = "BasicEff.img/Flying1"
  elseif skillID == ___MOD._SkillBook.Flash_Jump_432_4321003 then
    path = "BasicEff.img/Flying2"
  end
  if not testSkill then
    ___MOD._PlayerAttackLogic_Shoot:tryUseConsume(player, skillID, ___MOD._SkillAttackType.Skill, false)
  end
  local useEffect = ___MOD._ExtendedEffectService:playEffectAnimationLocal(path, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, player.TransformComponent.Position, false, 1.0, faceLeft, player.CurrentMap, nil, false, 0)
  ___MOD._ExtendedEffectService:playEffectAnimationRemote(path, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, player.TransformComponent.Position, false, 1.0, faceLeft, player.CurrentMap, true, player, nil, false, 0)
  ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%d.Use", 4321003), player, 1)
  local ac = player.PlayerActionComponent
  player.Player.canDoubleJump = false
end

function PlayerSkillLogic.tryMesoExplosion(self, player, explodeList, senderUserId)

end

function PlayerSkillLogic.tryMesoExplosionClient(self, player, skillID, skillLevel, skillLevelData)
  local simulator = ___MOD._CollisionService:GetSimulator(player)
  self._T.overlap = {}
  local overlap = self._T.overlap
  local boxShape = ___MOD._PlayerAttackLogic_Shoot:makeBoxShapeFromLtRb(player.TransformComponent:PositionAsFastVector3():ToVector2(), skillLevelData.lt * 100, skillLevelData.rb * 100, player.PlayerControllerComponent.LookDirectionX == -1)
  local count = simulator:OverlapAllFast("Item", boxShape, overlap)
  if ___MOD.Environment:IsMakerPlay() then
    ___MOD._ColliderUtils:drawBox(player.CurrentMap, boxShape.Position, boxShape.Size)
  end
  if 0 < count then
    local explodeList = {}
    local attackCount = skillLevelData.attackCount
    local mobCount = skillLevelData.mobCount
    local mobsArr = {}
    local mobIndexByEnt = {}
    local mesoExplosionInfo = {}

    local function distSq2(ax, ay, bx, by)
      local dx = ax - bx
      local dy = ay - by
      return dx * dx + dy * dy
    end

    local function ensureMobIndex(mobEnt)
      local idx = mobIndexByEnt[mobEnt]
      if idx ~= nil then
        return idx
      end
      if #mobsArr >= mobCount then
        return nil
      end
      idx = #mobsArr + 1
      mobIndexByEnt[mobEnt] = idx
      mobsArr[idx] = {
        ent = mobEnt,
        mesos = {
          0,
          0,
          0,
          0,
          0,
          0
        },
        _mesoAddCount = 0,
        dropIDs = {}
      }
      mesoExplosionInfo[idx] = mobsArr[idx].dropIDs
      return idx
    end

    local dedicatedDropMap = ___MOD._DedicatedMonsterLogic:isEnabledMap(player.CurrentMap)
    for _, item in ___MOD.pairs(overlap) do
      if item.EnableInHierarchy then
        local itemEntity = item.Entity
        if ___MOD.isvalid(itemEntity) then
          local drop = itemEntity.CDropItemComponent
          local enterCtx = drop.dropEnterFieldCtx
          local ownType = enterCtx.ownType
          local ownerID = enterCtx.ownerID
          local canUseDedicatedDrop = not dedicatedDropMap or ___MOD._DropItemLogic:canUseDedicatedDropOwnerId(player, ownerID)
          if (dedicatedDropMap and canUseDedicatedDrop or ___MOD._UtilLogic:IsNilorEmptyString(enterCtx.sourceID) or (ownType ~= ___MOD._DropOwnType.UserOwn_0 or ownerID == player.Player.PlayerId) and (ownType ~= ___MOD._DropOwnType.PartyOwn_1 or ownerID == ___MOD.tostring(player.Player.PartyId))) and canUseDedicatedDrop and drop.Enable and drop.nState == 3 and drop.isMoney then
            if attackCount <= #explodeList then
              break
            end
            explodeList[#explodeList + 1] = drop.dropID
            local lt = ___MOD.FastVector2(-50, -50)
            local rb = ___MOD.FastVector2(50, 50)
            self._T.overlap2 = {}
            local overlap2 = self._T.overlap2
            local itemPos2 = itemEntity.TransformComponent:PositionAsFastVector3():ToVector2()
            local b = ___MOD._PlayerAttackLogic_Shoot:makeBoxShapeFromLtRb(itemPos2, lt, rb, false)
            simulator:OverlapAllFast("Monster", b, overlap2)
            local candidates = {}
            local seen = {}
            local dedicated = ___MOD._DedicatedMonsterLogic
            local useDedicated = dedicated and dedicated:isEnabledMap(player.CurrentMap)
            local ix, iy = itemPos2.x, itemPos2.y
            for _, tr in ___MOD.pairs(overlap2) do
              local mobEnt = tr.Entity
              if tr.EnableInHierarchy and ___MOD.isvalid(mobEnt) and not seen[mobEnt] and not mobEnt.MobComponent:isDead() and not mobEnt.MobComponent.damagedByMob and not mobEnt.MobComponent.suspended and (not useDedicated or dedicated:isOwnedMob(player, mobEnt)) then
                local mts = mobEnt.MobTemporaryStatComponent
                if mts:getValue(___MOD._MTS.Dazzle) == 0 then
                  seen[mobEnt] = true
                  local p2 = mobEnt.TransformComponent:PositionAsFastVector3():ToVector2()
                  local d = distSq2(p2.x, p2.y, ix, iy)
                  local id = mobEnt.Id
                  if id == nil then
                    id = 0
                  end
                  candidates[#candidates + 1] = {
                    ent = mobEnt,
                    dist = d,
                    id = id
                  }
                end
              end
            end
            if 1 < #candidates then
              ___MOD.table.sort(candidates, function(a, b)
                if a.dist ~= b.dist then
                  return a.dist < b.dist
                end
                return a.id < b.id
              end)
            end
            local mesoVal = enterCtx.pInfo
            local added = 0
            for i = 1, #candidates do
              if mobCount <= added then
                break
              end
              local mobEnt = candidates[i].ent
              local idx = ensureMobIndex(mobEnt)
              if idx ~= nil then
                local entry = mobsArr[idx]
                entry._mesoAddCount = entry._mesoAddCount + 1
                local slot = (entry._mesoAddCount - 1) % 6 + 1
                entry.mesos[slot] = entry.mesos[slot] + mesoVal
                entry.dropIDs[#entry.dropIDs + 1] = drop.dropID
                added = added + 1
              end
            end
          end
        end
      end
    end
    mesoExplosionInfo[7] = explodeList
    self:removeDropFromExplodeClient(player.CurrentMap, explodeList, nil)
    self:tryMesoExplosion(player, explodeList)
    local delays = {}
    local damages = {}
    local criticals = {}
    local playerInputX = player.PlayerControllerComponent.LookDirectionX
    local attackerPosSnapshot = player.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
    for i = 1, #mobsArr do
      local mobEntity = mobsArr[i].ent
      local mesos = mobsArr[i].mesos
      local damage, critical = ___MOD._CalcDamageLogic:calcDamage_MesoExplosion(player, mobEntity, skillID, skillLevel, mesos)
      damages[i] = damage
      criticals[i] = critical
      local delay = {}
      local totalDelay = 0
      for idx, _ in ___MOD.ipairs(damage) do
        delay[idx] = (idx - 1) * 100
        local d = (idx - 1) * 0.1
        totalDelay = totalDelay + d
        ___MOD._TimerService:SetTimerOnce(function()
          ___MOD._PlayerAttackLogic_Melee:playAttackSound(player, mobEntity, skillID, mobEntity.MobComponent.overrideMobID ~= 0 and mobEntity.MobComponent.overrideMobID or mobEntity.MobComponent.id)
        end, d)
      end
      delays[i] = delay
      local highestDamage = 0
      for k = 1, #damage do
        if highestDamage < damage[k] then
          highestDamage = damage[k]
        end
      end
      if skillID ~= ___MOD._SkillBook.Hypnotize_522_5221009 then
        ___MOD._PlayerAttackLogic:displaySkillDamageByAttackerClient(player, mobEntity, skillID, damage, critical, delay)
      end
      local totalDamage, deadlyAttack = ___MOD._PlayerAttackLogic:onAttackClient(player, mobEntity, damage)
    end
    local mobEntities = {}
    for i = 1, #mobsArr do
      mobEntities[i] = mobsArr[i].ent
    end
    local sad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(skillID, skillLevel, attackerPosSnapshot, playerInputX, #mobsArr, 0, "", ___MOD._SkillAttackType.Melee, mobEntities, damages, criticals, delays, 0, 1.0, false, 0, 0, 0, 0, 0, nil, 0.0, false, mesoExplosionInfo)
    ___MOD._PlayerAttackLogic:applyPendingWindWalkAttackBoost(player, sad)
    ___MOD._PlayerAttackLogic:onPlayerAttack(player, sad:toTable())
    ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(player)
  end
end

function PlayerSkillLogic.tryRush(self, player)
  if player.CurrentMap.MapInfoComponent:checkFieldLimit(___MOD._FieldLimit.UnableToUseSkill) then
    return
  elseif player.TamingMobComponent ~= nil and player.TamingMobComponent.onTaming then
    return
  elseif not player.RigidbodyComponent:IsOnGround() then
    return
  elseif player.PlayerActionComponent.isClimbing or player.PlayerActionComponent.sitting then
    return
  elseif player.Player:isDead() then
    return
  elseif ___MOD._PlayerVecCtrl:isImpactMoving() then
    return
  end
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  if currentTime < player.PlayerActionComponent.enableNextAttackTime then
    return
  end
  local skillID = ___MOD._SkillBook.Soul_Rush_1110_11101005
  local skillLevel = player.SkillComponent:getSkillLevel(skillID)
  if skillLevel <= 0 then
    return
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData == nil then
    return
  end
  local skillLevelData = skillData.level[skillLevel]
  if skillLevelData == nil then
    return
  end
  if ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(player, skillID, skillLevelData, 0, 0, 0) ~= 0 then
    return
  end
  local faceLeft = player.ExtendPlayerControllerComponent.LookDirectionX == -1
  local dir = faceLeft and -1 or 1
  local levelRatio = ___MOD.math.max(0, ___MOD.math.min(9, skillLevel - 1)) / 9
  local vx = 3.5 + 2.5 * levelRatio
  local vy = 2.5 + 1.0 * levelRatio
  ___MOD._PlayerVecCtrl:SetImpactNext(vx * dir, vy, true)
  local path = "BasicEff.img/SoulRush"
  local useEffect = ___MOD._ExtendedEffectService:playEffectAnimationLocal(path, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, player.TransformComponent.Position, false, 1.0, faceLeft, player.CurrentMap, nil, false, 0)
  ___MOD._ExtendedEffectService:playEffectAnimationRemote(path, ___MOD._AnimationType.effect, ___MOD._EffectAnimationSubType.halfScale, player.TransformComponent.Position, false, 1.0, faceLeft, player.CurrentMap, true, player, nil, false, 0)
  ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%d.Use", skillID), player, 1)
  ___MOD._PlayerAttackLogic_Shoot:tryUseConsume(player, skillID, ___MOD._SkillAttackType.Skill, false)
  player.PlayerActionComponent.enableNextAttackTime = currentTime + 0.2
  player.PlayerActionComponent.enableNextTeleportTime = currentTime + 1.5
end

function PlayerSkillLogic.tryUseSkill(self, player, skillID, skillLevel, ctx, senderUserId)

end

function PlayerSkillLogic.tryUseSkillClient(self, player, skillID, skillLevel, endKeyDown, fromDoubleClick, afterPrepare)
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  local pa = player.PlayerActionComponent
  if not endKeyDown and not afterPrepare and ___MOD._AranLogic:tryConsumePendingFinalBlowAction(player) then
    return
  end
  local mapInfo = player.CurrentMap.MapInfoComponent
  local isRideSkill = self:isMonsterRiderSkill(skillID)
  local isTamingMobSkill = self:isTamingMobSkill(skillID, player)
  if isTamingMobSkill and currentTime < (pa._T.enableNextTamingMobSkillTime or 0) then
    return
  end
  local blockedByFieldLimit = false
  if isTamingMobSkill then
    blockedByFieldLimit = self:isFieldLimitBlockedTamingMobSkill(skillID, player) and mapInfo:checkFieldLimit(___MOD._FieldLimit.UnableToUseTamingMob)
  else
    blockedByFieldLimit = self:isUnableToUseSkillFieldLimitTargetSkill(skillID) and mapInfo:checkFieldLimit(___MOD._FieldLimit.UnableToUseSkill)
  end
  if blockedByFieldLimit then
    if pa.nextDisplayAttackMessageTime == 0 or currentTime >= pa.nextDisplayAttackMessageTime then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "이곳에서는 사용할 수 없는 스킬입니다.")
      pa.nextDisplayAttackMessageTime = currentTime + 1
    end
    return
  end
  local hurricaneState = self:getHurricaneState(player)
  local piercingState = self:getPiercingState(player)
  local isAranComboCommandSkill = ___MOD._AranLogic:isAranComboCommandSkill(skillID)
  if (skillID == ___MOD._SkillBook.Combat_Step_2100_21001001 or isAranComboCommandSkill) and not ___MOD._AranLogic:canUseAranActionInput(player) then
    return
  end
  if skillID == ___MOD._SkillBook.Combo_Drain_2110_21100005 and (not player.AranComboComponent or not player.AranComboComponent:canUseComboDrainClient()) then
    return
  end
  if self:isBattleshipSkill(skillID) then
    if self:hasForcedBattleshipCooldown(player, skillID, currentTime) then
      return
    end
    self:setCanUseSkillTime(player, skillID, 0)
    self:clearSkillCooldownEndTime(player, skillID)
  end
  if isRideSkill then
    if not self:canUseMonsterRiderSkill(player) then
      if pa.nextDisplayAttackMessageTime == 0 or currentTime >= pa.nextDisplayAttackMessageTime then
        ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "길들인 몬스터와 안장을 착용하셔야 스킬이 사용 가능합니다.")
        pa.nextDisplayAttackMessageTime = currentTime + 1
      end
      return
    elseif ___MOD._PlayerVecCtrl:isImpactMoving() and not player.CurrentMap.MapInfoComponent.swim then
      return
    end
  end
  if self:isBattleshipMountOnlySkill(skillID) and not self:isBattleshipMounted(player) then
    return
  end
  if not self:isBattleshipMounted(player) and player.PlayerTemporaryStatComponent:getValue(___MOD._CTS.TamingMob) ~= 0 and not self:isTamingMobSkill(skillID, player) then
    return
  end
  if skillID == ___MOD._SkillBook.Battleship_522_5221006 and pa.isClimbing then
    return
  end
  if self:isSealSkill(skillID) and pa.isClimbing then
    return
  end
  if self:isSummonSkill(skillID) and pa.isClimbing then
    return
  end
  if self:isBattleshipMounted(player) and not self:isBattleshipSkill(skillID) and not self:canUseSkillOnBattleship(skillID) then
    if pa.nextDisplayAttackMessageTime == 0 or currentTime >= pa.nextDisplayAttackMessageTime then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "탈것 탑승 중에는 할 수 없습니다.")
      pa.nextDisplayAttackMessageTime = currentTime + 1
    end
    return
  end
  if self:isHurricaneSkillGroup(skillID) and endKeyDown then
    local skillData = ___MOD._SkillManager:getSkill(skillID)
    local hasLoopEffect = false
    local loopSkillEnties = ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties
    if loopSkillEnties ~= nil and loopSkillEnties[player.Player.PlayerId] ~= nil then
      hasLoopEffect = loopSkillEnties[player.Player.PlayerId][skillID] ~= nil
    end
    if hurricaneState.prepareToken ~= nil or hurricaneState.loopStarted == true or hurricaneState.inputLock == true or hasLoopEffect or player.KeyDownComponent ~= nil and player.KeyDownComponent.onKeyDown and player.KeyDownComponent.skillID == skillID then
      hurricaneState.prepareReleased = true
      self:finishHurricaneKeydown(player, skillID, skillData, true)
    end
    return
  end
  if self:isPiercingSkill(skillID) and endKeyDown then
    local skillData = ___MOD._SkillManager:getSkill(skillID)
    local hasLoopEffect = false
    local wasKeydown = piercingState.loopStarted == true
    local wasPreparing = piercingState.prepareToken ~= nil
    local loopSkillEnties = ___MOD._UserService.LocalPlayer.PlayerVariables.loopSkillEnties
    if loopSkillEnties ~= nil and loopSkillEnties[player.Player.PlayerId] ~= nil then
      hasLoopEffect = loopSkillEnties[player.Player.PlayerId][skillID] ~= nil
    end
    if piercingState.prepareToken ~= nil or piercingState.loopStarted == true or piercingState.inputLock == true or hasLoopEffect or player.KeyDownComponent ~= nil and player.KeyDownComponent.onKeyDown and player.KeyDownComponent.skillID == skillID then
      local chargePer = self:finishPiercingKeydown(player, skillID, skillData, true)
      if (wasKeydown or wasPreparing) and player.Player:isDead() == false then
        local currentSkillLevel = player.SkillComponent ~= nil and player.SkillComponent:getSkillLevel(skillID) or skillLevel
        if 0 < currentSkillLevel then
          if chargePer <= 0 then
            chargePer = 0.1
          end
          self:syncLookDirectionByHorizontalInput(player)
          ___MOD._PlayerAttackLogic:tryPlayerAttack(player, skillID, currentSkillLevel, false, chargePer)
        end
      end
    end
    return
  end
  if self:isHurricaneSkillGroup(skillID) and not endKeyDown and not afterPrepare and not self:isHurricaneActive(player, skillID) then
    local onLadder = pa.isClimbing
    if onLadder then
      return
    end
    if not player.ExtendPlayerControllerComponent.inSwimMap and not player.RigidbodyComponent:IsOnGround() then
      return
    end
    hurricaneState.wasSwimAirborne = self:isSwimAirborneForHurricane(player)
    if not self:canUseHurricaneArrow(player) then
      self:handleHurricaneArrowExhausted(player, skillID)
      ___MOD._PlayerAttackLogic:tryPlayerAttack(player, 0, 0, true, 0.0)
      return
    end
    if not self:canStartHurricanePrepare(player, currentTime) then
      return
    end
  end
  if self:isHurricaneSkillGroup(skillID) and not endKeyDown and not afterPrepare and self:isHurricaneActive(player, skillID) then
    return
  end
  if self:isPiercingSkill(skillID) and not endKeyDown and not afterPrepare and self:isPiercingActive(player, skillID) then
    return
  end
  if self:isPiercingSkill(skillID) and not endKeyDown and not afterPrepare and pa.isClimbing then
    return
  end
  if skillID == ___MOD._SkillBook.Octopus_521_5211001 then
    local slv = player.SkillComponent:getSkillLevel(___MOD._SkillBook.Wrath_of_the_Octopi_522_5220002)
    if 0 < slv then
      skillID = ___MOD._SkillBook.Wrath_of_the_Octopi_522_5220002
      skillLevel = slv
    end
  end
  local keyDown = player.KeyDownComponent
  if self:shouldBlockOtherActionByExclusiveKeydown(player, skillID, endKeyDown) then
    return
  end
  if keyDown ~= nil and keyDown.onKeyDown and self:isMonsterMagnetSkill(keyDown.skillID) and (not self:isMonsterMagnetSkill(skillID) or not endKeyDown) then
    return
  end
  if not afterPrepare then
    if skillID == ___MOD._SkillBook.Boomerang_Step_422_4221007 and currentTime < pa.enableNextBoomerangStepTime then
      return
    end
    if not self:isHurricaneSkillGroup(skillID) and not ___MOD._SkillLogic:isMoveAffectedSkill(skillID) and not ___MOD._SkillLogic:isTeleportSkill(skillID) and not isAranComboCommandSkill and currentTime < pa.enableNextBuffTime + 0.2 then
      return
    end
    local combatStepSkillMatched = skillID == ___MOD._SkillBook.Combat_Step_2100_21001001
    local canUseCombatStepAfterBasicAttack = combatStepSkillMatched and ___MOD._AranLogic:canUseCombatStepAfterBasicAttack(player, currentTime)
    if not isAranComboCommandSkill and (not ___MOD._SkillLogic:isMoveAffectedSkill(skillID) or combatStepSkillMatched) and not ___MOD._SkillLogic:isTeleportSkill(skillID) and currentTime < pa.enableNextAttackTime and not canUseCombatStepAfterBasicAttack then
      return
    end
    if not ___MOD._SkillLogic:isCanUseSkillOnLadder(skillID) and pa.isClimbing then
      return
    end
  end
  if self:usesLegacyCooldown(skillID) then
    local coolEndTime = self:getCanUseSkillTime(player, skillID)
    if currentTime < coolEndTime then
      return
    end
  end
  if isRideSkill or isTamingMobSkill then
    if player.PlayerActionComponent:isOnTamingMob() then
      self:clearTamingMobEntering()
    else
      self:markTamingMobEntering()
    end
  end
  if self:isBattleshipSkill(skillID) and self:isBattleshipMounted(player) then
    local reuseDelaySec = self:getBattleshipReuseDelaySec()
    pa.enableNextBuffTime = ___MOD.math.max(pa.enableNextBuffTime, currentTime + reuseDelaySec)
  end
  if skillID == ___MOD._SkillBook.Wings_520_5201005 and not player.RigidbodyComponent:IsOnGround() then
    return
  end
  if skillID == ___MOD._SkillBook.Combat_Step_2100_21001001 and not ___MOD._AranLogic:canUseCombatStepByGround(player) then
    return
  end
  if player.Player:isDead() then
    return
  end
  if self:isItemEnchantSkill(skillID) then
    player.CInventoryComponent:toggleItemEnchantUI()
    pa.enableNextBuffTime = currentTime + 0.2
    return
  end
  local makerSkillID = ___MOD._SkillManager:get_novice_skill_as_race(___MOD._SkillBook.Maker_000_1007, player.Player.Job)
  if skillID == makerSkillID then
    ___MOD._UIWindowLogic:showMakerUI()
    pa.enableNextBuffTime = currentTime + 0.2
    return
  end
  if pa.sitting then
    return
  end
  local ts = player.PlayerTemporaryStatComponent
  local morphId = ts:getValue(___MOD._CTS.Morph)
  if self:isTamingMobSkill(skillID, player) and self:isTamingMobBlockedMorph(morphId) then
    return
  end
  if self:shouldBlockWindArcherMorphAttackSkill(player, skillID, morphId) then
    return
  end
  if morphId ~= 0 then
    local check = true
    local isJobMorph = false
    if morphId == 1000 or morphId == 1100 then
      isJobMorph = true
      if skillID == ___MOD._SkillBook.Double_Shot_500_5001003 or skillID == ___MOD._SkillBook.Oak_Barrel_510_5101007 or skillID == ___MOD._SkillBook.Demolition_512_5121004 or skillID == ___MOD._SkillBook.Snatch_512_5121005 then
        check = false
      end
    elseif morphId == 1001 or morphId == 1101 then
      isJobMorph = true
      if skillID == ___MOD._SkillBook.Double_Shot_500_5001003 or skillID == ___MOD._SkillBook.Oak_Barrel_510_5101007 then
        check = false
      end
    elseif morphId == 1003 or morphId == 1103 then
      isJobMorph = true
    end
    if not check then
      ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에는 할 수 없습니다. 오른쪽 위의 아이콘을 우클릭하여 변신을 해제할 수 있습니다.")
      pa.enableNextBuffTime = currentTime + 0.5
      return
    elseif not isJobMorph then
      if self:isMorphCancelable(player) then
        ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에는 할 수 없습니다. 오른쪽 위의 아이콘을 우클릭하여 변신을 해제할 수 있습니다.")
      else
        ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "변신 중에는 할 수 없습니다.")
      end
      pa.enableNextBuffTime = currentTime + 0.5
      return
    end
  end
  if not ___MOD.soundLoadTestMode and ts:getValue(___MOD._CTS.Seal) ~= 0 and skillID ~= ___MOD._SkillBook.Dispel_231_2311001 then
    return
  end
  if not ___MOD.soundLoadTestMode and ts:getValue(___MOD._CTS.Attract) ~= 0 and not self:isHerosWill(skillID) then
    return
  end
  if not ___MOD.soundLoadTestMode and ts:getValue(___MOD._CTS.Stun) ~= 0 then
    return
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if not skillData then
    return
  end
  local skillLevelData = skillData.level[skillLevel]
  if not skillLevelData then
    return
  end
  if skillID == ___MOD._SkillBook.Storm_Break_1310_13101005 and not player.ExtendPlayerControllerComponent.inSwimMap and not player.RigidbodyComponent:IsOnGround() then
    return
  end
  if self:isBattleshipSkill(skillID) and self:isBattleshipMounted(player) then
    local reuseDelaySec = self:getBattleshipReuseDelaySec()
    pa.enableNextBuffTime = ___MOD.math.max(pa.enableNextBuffTime, currentTime + reuseDelaySec)
    self:tryUseSkill(player, skillID, skillLevel, nil)
    return
  end
  local currentTamingSkillID = ts:getSkillID(___MOD._CTS.TamingMob)
  if self:isTamingMobSkill(skillID, player) and 0 < currentTamingSkillID then
    pa._T.enableNextTamingMobSkillTime = currentTime + 0.25
    ts:resetTemporaryStatClient(currentTamingSkillID)
    ts:resetTemporaryStat(currentTamingSkillID)
    return
  end
  if self:isHurricaneSkillGroup(skillID) and not endKeyDown and not afterPrepare and not self:checkHurricaneConsumeClient(player, skillID, skillLevelData, currentTime) then
    return
  end
  if skillID == ___MOD._SkillBook.Assassinate_422_4221001 then
    if not player.RigidbodyComponent:IsOnGround() then
      return
    end
    local darkSightData = ts:getTemporaryStatData(___MOD._CTS.DarkSight)
    local darkSightSkillID = ts:getSkillID(___MOD._CTS.DarkSight)
    if darkSightData == nil or darkSightSkillID <= 0 then
      return
    end
    local pv = player.PlayerVariables
    if pv ~= nil then
      local now = ___MOD._UtilLogic.ServerElapsedSeconds
      local startTime = ___MOD.tonumber(pv.darkSightStartTime) or 0
      local elapsed = ___MOD.math.max(0, now - startTime)
      pv:setAssassinateDarkSightElapsedSecClient(elapsed)
      pv:setAssassinateDarkSightElapsedSec(elapsed)
    end
    ts:resetTemporaryStatClient(darkSightSkillID)
    ts:resetTemporaryStat(darkSightSkillID)
    local darkSightSkillData = ___MOD._SkillManager:getSkill(darkSightSkillID)
    local darkSightSoundId = self:getSkillSoundRefId(darkSightSkillID)
    local darkSightSoundStr = ___MOD.string.format("%07d", darkSightSoundId)
    ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", darkSightSoundStr), player, 1)
    if darkSightSkillData ~= nil then
      self:playOneShotEffect(player, darkSightSkillID, darkSightSkillData.effect)
    end
  end
  if self:isHurricaneSkillGroup(skillID) and not endKeyDown and not afterPrepare then
    hurricaneState.inputLock = true
    self:markHurricanePrepareCooldown(player, currentTime)
    pa.enableNextAttackTime = ___MOD.math.max(pa.enableNextAttackTime, currentTime + 0.3)
  end
  local levelDataCooldownSec = self:getSkillLevelDataCooltimeSec(skillLevelData, skillID)
  if 0 < levelDataCooldownSec and currentTime < self:getSkillCooldownEndTime(player, skillID) then
    return
  end
  local isRushSkill = ___MOD._SkillLogic:isRushAttackSkill(skillID)
  if isRushSkill and currentTime < pa.enableNextRushTime then
    return
  end
  if ___MOD._SkillLogic:isMoveAffectedSkill(skillID) then
    if currentTime < pa.enableMoveAffectedSkillTime then
      return
    end
    if (skillID == ___MOD._SkillBook.Dash_500_5001005 or skillID == ___MOD._SkillBook.Dash_1500_15001003) and player.TamingMobComponent ~= nil and player.TamingMobComponent.onTaming then
      return
    end
    if skillID == ___MOD._SkillBook.Dash_500_5001005 or skillID == ___MOD._SkillBook.Dash_1500_15001003 then
      pa.enableMoveAffectedSkillTime = ___MOD._UtilLogic.ServerElapsedSeconds + 0.1
    end
  end
  if ___MOD._SkillLogic:isTeleportAttackSkill(skillID) and currentTime < pa.enableNextTeleportTime then
    return
  end
  if self:isFlameGearPlacementBlocked(player, skillID, skillLevelData) then
    if not player.RigidbodyComponent:IsOnGround() then
      pa.enableNextBuffTime = currentTime + 0.1
      return
    end
    ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, "여기서는 사용할 수 없습니다.")
    pa.enableNextBuffTime = currentTime + 0.5
    return
  end
  local chargePer = 0.0
  if (skillData.keydown ~= nil or self:isMonsterMagnetSkill(skillID)) and not afterPrepare and not self:isHurricaneSkillGroup(skillID) and not self:isPiercingSkill(skillID) then
    if not self:onKeyDown(player, fromDoubleClick, endKeyDown, skillData, skillLevelData, skillID) then
      return
    end
    if endKeyDown then
      chargePer = ___MOD.tonumber(player.KeyDownComponent._T.lastChargePer) or 0
    else
      chargePer = ___MOD.tonumber(player.KeyDownComponent.percentage) or 0
    end
  end
  if self:isHurricaneSkillGroup(skillID) and afterPrepare then
    if hurricaneState.prepareReleased == true then
      hurricaneState.prepareToken = nil
      hurricaneState.prepareSkillID = nil
      return
    end
    if hurricaneState.loopStarted == true then
      return
    end
    hurricaneState.prepareToken = nil
    hurricaneState.prepareSkillID = nil
    hurricaneState.prepareReleased = false
    hurricaneState.loopStarted = true
    self:startHurricaneKeyDownEffect(player, skillID, skillData)
    return
  end
  if self:isPiercingSkill(skillID) and afterPrepare then
    if piercingState.prepareReleased == true then
      piercingState.prepareToken = nil
      piercingState.prepareSkillID = nil
      return
    end
    if piercingState.loopStarted == true then
      return
    end
    piercingState.prepareToken = nil
    piercingState.prepareSkillID = nil
    piercingState.prepareReleased = false
    piercingState.loopStarted = true
    self:startPiercingKeyDownEffect(player, skillID, skillData)
    return
  end
  if afterPrepare and self:isMonsterMagnetSkill(skillID) then
    local currentChargePer = ___MOD.tonumber(player.KeyDownComponent.percentage) or 0
    local lastChargePer = ___MOD.tonumber(player.KeyDownComponent._T.lastChargePer) or 0
    chargePer = ___MOD.math.max(currentChargePer, lastChargePer)
    if chargePer <= 0 then
      chargePer = 0.1
    elseif 0.99 <= chargePer then
      chargePer = 1
    end
  end
  if ___MOD._SkillLogic:isTeleportSkill(skillID) then
    if currentTime < pa.enableNextTeleportTime then
      return
    elseif player.CurrentMap.MapInfoComponent:checkFieldLimit(___MOD._FieldLimit.UnableToUseSkill) then
      return
    end
    if skillID == ___MOD._SkillBook.Soul_Rush_1110_11101005 then
      self:tryRush(player)
    elseif ___MOD._PlayerSkillLogic_Teleport:tryRegisterTeleport(player, skillID, skillLevel, nil, nil, false, 0) then
      self:applySkillLevelDataCooldown(player, skillID, skillLevelData, currentTime)
    end
    return
  elseif ___MOD._SkillLogic:isTeleportAttackSkill(skillID) then
    if ___MOD._PlayerAttackLogic:tryPlayerAttack(player, skillID, skillLevel, false, chargePer) then
      if skillID == ___MOD._SkillBook.Backspin_Blow_510_5101002 then
        pa.enableNextTeleportTime = currentTime + 1.0
      end
      if self:shouldSyncTeleportLockWithAttack(skillID) then
        pa.enableNextTeleportTime = ___MOD.math.max(pa.enableNextTeleportTime, pa.enableNextAttackTime)
      end
      self:applySkillLevelDataCooldown(player, skillID, skillLevelData, currentTime)
    end
  elseif ___MOD._SkillLogic:isHeal(skillID) then
    if ___MOD._PlayerAttackLogic:tryPlayerAttack(player, skillID, skillLevel, true, chargePer) then
      self:tryUseSkill(player, skillID, skillLevel, nil)
      self:applySkillLevelDataCooldown(player, skillID, skillLevelData, currentTime)
    end
    return
  elseif self:isNinjaAmbushSkill(skillID) then
    if not afterPrepare and self:checkPrepare(player, skillID, skillLevel, skillData) then
      return
    end
    if not ___MOD._AntiRepeat:tryRepeat(___MOD._AntiRepeatType.Attack) then
      return
    end
    local motion
    local action = skillData.action
    if ___MOD.isvalid(action) then
      motion = action["0"]
    end
    local totalActionDelay = 0.5
    if motion ~= nil and motion ~= "" then
      totalActionDelay = ___MOD.math.max(0.5, self:getSkillActionLockDelaySec(player, skillID, motion, 0.5, 0))
      ___MOD._PlayerStateLogic:changeState(player, "SKILL")
      pa:playOnceClient(motion, 1.0, player, false, false)
      pa:playOnce(motion, 1.0, player)
    end
    if ___MOD.isvalid(skillData.effect) then
      ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, nil, 1.0)
    end
    local soundSkillId = self:getSkillSoundRefId(skillID)
    local idStr = ___MOD.string.format("%07d", soundSkillId)
    ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", idStr), player, 1)
    self:tryUseSkill(player, skillID, skillLevel, nil)
    pa.enableNextAttackTime = currentTime + totalActionDelay
    return
  elseif self:isDisorder(skillID) or self:isAttackSkill(skillID) or not self:isPassiveSkill(skillID) and not self:isBuffSkill(skillID) and (skillLevelData.damage ~= nil and 0 < skillLevelData.damage or skillLevelData.fixDamage ~= nil and 0 < skillLevelData.fixDamage or skillLevelData.MAD ~= nil and 0 < skillLevelData.MAD) then
    if not afterPrepare and self:checkPrepare(player, skillID, skillLevel, skillData) then
      return
    end
    local isDownArrowPressed = player.PlayerSettingsComponent ~= nil and player.PlayerSettingsComponent:isKeyPressed("DownArrow")
    local isJumpPressed = false
    local keyConfig = player.KeyConfigComponent
    if keyConfig ~= nil then
      local jumpKey = keyConfig:getKeyIdByAction(___MOD._KeyConfigActionType.JUMP)
      isJumpPressed = jumpKey ~= nil and ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.CastFrom(jumpKey))
    end
    isJumpPressed = isJumpPressed or ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.LeftAlt) or ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.RightAlt)
    local isLeftPressed = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.LeftArrow)
    local isRightPressed = ___MOD._InputService:IsKeyPressed(___MOD.KeyboardKey.RightArrow)
    self:clearStaleProneStateBeforeAttackSkill(player, pa, isDownArrowPressed)
    local proneAttackReason = self:getProneNormalAttackReason(player, pa, isDownArrowPressed, isJumpPressed, isLeftPressed, isRightPressed)
    if not isAranComboCommandSkill and proneAttackReason ~= "" then
      if player.StateComponent.CurrentStateName ~= "PRONE" and proneAttackReason == "PRONE_INPUT" then
        ___MOD._PlayerStateLogic:changeState(player, "PRONE")
      end
      if ___MOD.Environment:IsMakerPlay() then
        ___MOD.log(___MOD.string.format("[ProneAttackFallback] reason=%s skillID=%d state=%s down=%s jump=%s left=%s right=%s onGround=%s climbing=%s swim=%s", proneAttackReason, skillID, ___MOD.tostring(player.StateComponent.CurrentStateName), ___MOD.tostring(isDownArrowPressed), ___MOD.tostring(isJumpPressed), ___MOD.tostring(isLeftPressed), ___MOD.tostring(isRightPressed), ___MOD.tostring(player.RigidbodyComponent:IsOnGround()), ___MOD.tostring(pa.isClimbing), ___MOD.tostring(player.ExtendPlayerControllerComponent ~= nil and player.ExtendPlayerControllerComponent.inSwimMap)))
      end
      ___MOD._PlayerAttackLogic:tryPlayerAttack(player, 0, 0, true, 0.0)
      return
    end
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD.log(___MOD.string.format("[SkillAttackPass] skillID=%d state=%s down=%s jump=%s left=%s right=%s onGround=%s climbing=%s swim=%s", skillID, ___MOD.tostring(player.StateComponent.CurrentStateName), ___MOD.tostring(isDownArrowPressed), ___MOD.tostring(isJumpPressed), ___MOD.tostring(isLeftPressed), ___MOD.tostring(isRightPressed), ___MOD.tostring(player.RigidbodyComponent:IsOnGround()), ___MOD.tostring(pa.isClimbing), ___MOD.tostring(player.ExtendPlayerControllerComponent ~= nil and player.ExtendPlayerControllerComponent.inSwimMap)))
    end
    if ___MOD._PlayerAttackLogic:tryPlayerAttack(player, skillID, skillLevel, false, chargePer) then
      if self:isBigBangSkill(skillID) then
        pa.enableNextAttackTime = ___MOD.math.max(pa.enableNextAttackTime, currentTime + 1.0)
      end
      if skillID == ___MOD._SkillBook.Backspin_Blow_510_5101002 then
        pa.enableNextTeleportTime = currentTime + 1.0
      end
      if self:shouldSyncTeleportLockWithAttack(skillID) then
        pa.enableNextTeleportTime = ___MOD.math.max(pa.enableNextTeleportTime, pa.enableNextAttackTime)
      end
      self:applySkillLevelDataCooldown(player, skillID, skillLevelData, currentTime)
    end
  else
    local ctx = {}
    if skillID ~= ___MOD._SkillBook.Wrath_of_the_Octopi_522_5220002 and ___MOD._SkillLogic:getSkillType(skillID) == ___MOD._SkillType.passiveSkill and not self:isAmplificationSkill(skillID) and not self:isBuffSkill(skillID) then
      return
    elseif self:isDoubleJumpSkill(skillID) then
      self:tryDoubleJump(player, true)
      return
    end
    if self:isAmplificationSkill(skillID) then
      if ___MOD._AntiRepeat:tryRepeat(___MOD._AntiRepeatType.Buff) then
        self:tryUseSkill(player, skillID, skillLevel, ctx)
        pa.enableNextBuffTime = currentTime + 0.2
        pa.enableNextAttackTime = ___MOD.math.max(pa.enableNextAttackTime, currentTime + 0.5)
      end
      return
    end
    local itemId, count, slot = player.CInventoryComponent:findFirstThrowing(0)
    if ___MOD._PlayerAttackLogic_Shoot:checkUseConsumeClient(player, skillID, skillLevelData, itemId, count, 0) ~= 0 then
      pa.enableNextBuffTime = currentTime + 0.1
      if ___MOD._SkillLogic:isMoveAffectedSkill(skillID) then
        pa.enableMoveAffectedSkillTime = currentTime + 0.5
      end
      if ___MOD._SkillLogic:isTeleportSkill(skillID) then
        pa.enableNextTeleportTime = currentTime + 0.5
      end
      return
    end
    local weaponInfo = ___MOD._PlayerAttackLogic:getWeaponInfo(player)
    if skillData ~= nil and skillData.weapon ~= nil and not ___MOD._PlayerAttackLogic:checkWeapon(skillData.weapon, weaponInfo.itemID) then
      if not weaponInfo.valid then
        pa:displayAttackMessage("무기를 장착하지 않아 공격할 수 없습니다.")
        pa.enableNextAttackTime = currentTime + 0.1
        return
      end
      pa:displayAttackMessage("장착한 무기로는 사용할 수 없는 스킬입니다.")
      pa.enableNextAttackTime = currentTime + 0.1
      return
    end
    if not self:checkCanUseSkillByWeapon(skillID, weaponInfo) then
      pa.enableNextAttackTime = currentTime + 0.1
      return
    end
    if ts:getTemporaryStatData(___MOD._CTS.DarkSight) ~= nil or ts:getTemporaryStatData(___MOD._CTS.WindWalk) ~= nil then
      return
    end
    if not afterPrepare and self:checkPrepare(player, skillID, skillLevel, skillData) then
      return
    end
    if ___MOD._AntiRepeat:tryRepeat(___MOD._AntiRepeatType.Buff) then
      if self:isSummonSkill(skillID) then
        local summonPos = self:doActiveSkill_Summon(player, skillID)
        if summonPos == nil then
          return
        else
          ctx[1] = summonPos
        end
      elseif self:isMysticDoorSkill(skillID) then
        local townPortalPos = self:doActiveSkill_TownPortal(player)
        if townPortalPos == nil then
          return
        else
          ctx[1] = townPortalPos
        end
      elseif skillID == ___MOD._SkillBook.Meso_Explosion_421_4211006 then
        ___MOD._TimerService:SetTimerOnce(function()
          self:tryMesoExplosionClient(player, skillID, skillLevel, skillLevelData)
        end, 0.9)
      end
      if self:isMonsterMagnetSkill(skillID) then
        ctx.magnetChargePer = chargePer
      end
      if skillID == ___MOD._SkillBook.Dispel_231_2311001 or self:isRangeMobDebuffSkill(skillID) then
        self:findMobTargetsFromHitBoxClient(player, ctx, skillLevelData)
      end
      if skillID == ___MOD._SkillBook.Combat_Step_2100_21001001 and not ___MOD._AranLogic:onCombatSteb(player, skillLevel, ___MOD._AranLogic._T.combatStepInputDirX or 0) then
        return
      end
      self:tryUseSkill(player, skillID, skillLevel, ctx)
      self:applySkillLevelDataCooldown(player, skillID, skillLevelData, currentTime)
      if self:isMonsterMagnetSkill(skillID) then
        self:setCanUseSkillTime(player, skillID, currentTime + 2)
      end
      if afterPrepare and self:isMonsterMagnetSkill(skillID) then
        pa:setControllEnable(___MOD._ControllEnableType.SkillUseDelay, false)
        pa:setAlert(true)
        pa:setAlertTime(___MOD._UtilLogic.ServerElapsedSeconds + 5)
      end
      if skillID == ___MOD._SkillBook.Wings_520_5201005 then
        self:tryWings(player, skillID, skillLevel, skillData)
      end
    end
    local motion
    local action = skillData.action
    if ___MOD.isvalid(action) then
      motion = action["0"]
    end
    local totalActionDelay = 0.5
    local effectiveSkillLockDelay = 0.5
    if motion ~= nil then
      totalActionDelay = ___MOD.math.max(0.5, self:getSkillActionLockDelaySec(player, skillID, motion, 0.5, 0))
      effectiveSkillLockDelay = totalActionDelay
      if pa.isClimbing then
        local ac = "ladder"
        if player.StateComponent.CurrentStateName == "CLIMB" then
          ac = "rope"
        end
        player.PlayerActionComponent:doAction(ac, -1, player, ___MOD.SpriteAnimClipPlayType.ZigzagLoop, 0, ac == "rope" and 1 or 2)
        player.PlayerActionComponent:playOnetimeAction(ac, 1, player)
        player.PlayerActionComponent:setControllEnable(___MOD._ControllEnableType.SkillUseDelay, true)
        effectiveSkillLockDelay = 0.8
        ___MOD._TimerService:SetTimerOnce(function()
          player.PlayerActionComponent:setControllEnable(___MOD._ControllEnableType.SkillUseDelay, false)
          player.ExtendPlayerControllerComponent.FixedLookAt = player.ExtendPlayerControllerComponent.LookDirectionX
        end, effectiveSkillLockDelay)
      else
        local taming = player.TamingMobComponent
        if taming and taming.onTaming then
          ___MOD._PlayerStateLogic:changeState(player, "SIT")
          if motion ~= nil and motion ~= "" then
            taming:playActionMotionClient(player, motion)
          else
            ___MOD.log(___MOD.string.format("[BattleshipMotion][SkillLogic] skip empty motion skillID=%d", skillID))
          end
        else
          ___MOD._PlayerStateLogic:changeState(player, "SKILL")
          pa:playOnceClient(motion, 1.0, player, false, false)
          pa:playOnce(motion, 1.0, player)
        end
        if self:isMonsterMagnetSkill(skillID) then
          ___MOD._TimerService:SetTimerOnce(function()
            pa:setControllEnable(___MOD._ControllEnableType.SkillUseDelay, false)
          end, totalActionDelay)
        end
      end
    end
    local effectData = skillData.effect
    if self:isBattleshipSkill(skillID) then
      if ___MOD.isvalid(effectData) then
        ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, nil, 1.0)
      end
      if ___MOD.isvalid(skillData.effect0) then
        ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 1, nil, 1.0)
      end
    elseif ___MOD.isvalid(effectData) and skillLevelData.morph == 0 then
      ___MOD._PlayerAttackLogic:playSkillEffect(player, skillID, 0, nil, 1.0)
    end
    if skillID == ___MOD._SkillBook.Iron_Body_100_1001003 or skillID == ___MOD._SkillBook.Iron_Body_1100_11001001 or skillID == ___MOD._SkillBook.Magic_Armor_200_2001003 or skillID == ___MOD._SkillBook.Magic_Armor_1200_12001002 then
      ___MOD._PlayerUpdateLogic:playIronBodyEffectLocal(player)
      ___MOD._PlayerUpdateLogic:playIronBodyEffectRemote()
    end
    if self:isBattleshipSkill(skillID) then
      local soundSkillId = self:getSkillSoundRefId(skillID)
      local idStr = ___MOD.string.format("%07d", soundSkillId)
      ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", idStr), player, 1)
    elseif skillLevelData.morph == 0 and not afterPrepare then
      local soundSkillId = self:getSkillSoundRefId(skillID)
      local idStr = ___MOD.string.format("%07d", soundSkillId)
      ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Skill.img.%s.Use", idStr), player, 1)
    end
    if not ___MOD._SkillLogic:isMoveAffectedSkill(skillID) then
      player.PlayerActionComponent.enableNextBuffTime = currentTime + effectiveSkillLockDelay
      if pa.isClimbing then
        player.PlayerActionComponent.enableNextAttackTime = currentTime + effectiveSkillLockDelay
      end
      pa.enableNextTeleportTime = ___MOD._UtilLogic.ServerElapsedSeconds + 0.3
    end
  end
end

function PlayerSkillLogic.tryUseSkillServerInternal(self, player, skillID, skillLevel, ctx)

end

function PlayerSkillLogic.tryWings(self, player, skillID, skillLevel, skillData)
  if player.PlayerVariables.wingsTimer ~= nil then
    ___MOD._TimerService:ClearTimer(player.PlayerVariables.wingsTimer)
  end
  player.MovementComponent:Jump()
  ___MOD._PlayerStateLogic:changeState(player, "JUMP")
  local vy = ___MOD._Physics:getWingsFallSpeedMaxY(skillID, skillLevel)
  if player.PlayerVariables.beforeFallSpeedMaxY == 0 then
    player.PlayerVariables.beforeFallSpeedMaxY = player.RigidbodyComponent.FallSpeedMaxY
  end
  player.RigidbodyComponent.FallSpeedMaxY = vy
  self:playAndsetEffectEntityClient(player, skillData.special, skillID)
  self:playAndSetEffectEntity(player, skillData.special, skillID)
  local skillIdStr = ___MOD.string.format("%07d", ___MOD._SkillBook.Wings_520_5201005)
  local soundPath = ___MOD.string.format("Skill.img.%s.Loop", skillIdStr)
  local ruid = ___MOD.__RUIDManager:get(soundPath)
  if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
    ___MOD._SoundUtils:playLoopSoundLocal(ruid, 1, ___MOD._SoundUtils.SOUND_LOOP_CATEGORY_MY)
  end
  player.PlayerVariables.wingsTimer = ___MOD._TimerService:SetTimerOnce(function()
    self:endWings(player, skillID)
  end, 5)
end

function PlayerSkillLogic.usesLegacyCooldown(self, skillID)
  return ___MOD._SkillLogic:isCooltimeSkill(skillID) or self:isMonsterMagnetSkill(skillID)
end

function PlayerSkillLogic.verifyMobTargetsFromCtx(self, player, output, ctx, maxCount, skillBox)

end
