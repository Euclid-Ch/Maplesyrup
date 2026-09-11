

function ShaolinChiefPriestBattleLogic.canUseShaolinSummon(self, mob, skillInfo, msd, temporary)
  local id = mob.MobComponent.id
  if not self:isChiefPriest(id) or skillInfo.skill ~= 201 then
    return true
  end
  local summonCount = self:getAliveSummonCount(mob.CurrentMap, self:shaolinSummonMobId())
  mob.MobComponent.summonCount = summonCount
  return summonCount + #msd.summonList <= self:shaolinSummonLimit()
end

function ShaolinChiefPriestBattleLogic.executeFixedAttackClient(self, mob, attackInfo, attackIdx)
  local player = ___MOD._UserService.LocalPlayer
  if not (___MOD.isvalid(player) and ___MOD.isvalid(player.Player) and not player.Player:isDead() and ___MOD.isvalid(mob)) or attackInfo == nil then
    return
  end
  local isFixedRatio = attackInfo.fixDamR > 0 and attackInfo.fixDamRType == 1
  if not isFixedRatio then
    return
  end
  if attackInfo.hit ~= nil then
    local hit = attackInfo.hit
    ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, 0, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), hit.anim, false, false, "shaolinChiefPriestAttackHit", false, nil)
  end
  ___MOD._SoundUtils:broadcastSoundAtPosLocal(___MOD.string.format("Mob.img.%d.CharDam%d", mob.MobComponent.id, attackIdx), player, 1)
  ___MOD._SoundUtils:broadcastSoundAtPosRemote(___MOD.string.format("Mob.img.%d.CharDam%d", mob.MobComponent.id, attackIdx), player, 1)
  local secondary = player.PlayerSecondaryAbilityComponent
  local bonusHP = ___MOD.isvalid(secondary) and secondary.MaxHP or 0
  local maxHP = player.Player.MaxHP + bonusHP
  local damage = ___MOD.math.max(1, ___MOD.math.floor(maxHP * attackInfo.fixDamR * 0.01))
  local hitByLeft = mob.TransformComponent.WorldPosition.x < player.TransformComponent.WorldPosition.x
  player.PlayerHitComponent:setDamaged(damage, hitByLeft, mob, attackInfo, nil, attackIdx, false)
end

function ShaolinChiefPriestBattleLogic.executeFixedDamageClient(self, mob, skillID, skillLevel, delay)
  local player = ___MOD._UserService.LocalPlayer
  if not (___MOD.isvalid(player) and ___MOD.isvalid(player.Player)) or player.Player:isDead() or not ___MOD.isvalid(mob) then
    return
  end
  local skill = ___MOD._SkillManager:getMobSkill(skillID, skillLevel)
  if skill == nil then
    return
  end
  if skill.screen ~= nil then
    local ui = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
    if ___MOD.isvalid(ui) and ui.UIPool ~= nil then
      local pool = ui.UIPool.UIEffectPool
      local effect = ___MOD._ObjectPool:pick(pool, "Effect", "model://6e36bd76-88aa-4315-b583-986d769f06b2", ___MOD.FastVector3.zero:Clone(), ui, true)
      local animation = effect.AnimationSpriteComponent
      animation:setWzSprite(skill.screen, false)
      animation.loop = false
      animation.releasePool = pool
    end
  end
  ___MOD._TimerService:SetTimerOnce(function()
    if not (___MOD.isvalid(player) and ___MOD.isvalid(player.Player)) or player.Player:isDead() or not ___MOD.isvalid(mob) then
      return
    end
    if player.CurrentMap ~= mob.CurrentMap then
      return
    end
    if skill.hit ~= nil then
      ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, 0, 0, player, 1.0, ___MOD.FastVector3.zero:Clone(), skill.hit, false, false, "shaolinChiefPriestHit", false, nil)
    end
    local secondary = player.PlayerSecondaryAbilityComponent
    local bonusHP = ___MOD.isvalid(secondary) and secondary.MaxHP or 0
    local maxHP = player.Player.MaxHP + bonusHP
    local damage = ___MOD.math.max(1, ___MOD.math.floor(maxHP * skill.fixDamR * 0.01))
    local hitByLeft = mob.TransformComponent.WorldPosition.x < player.TransformComponent.WorldPosition.x
    player.PlayerHitComponent:setDamaged(damage, hitByLeft, mob, nil, nil, -7, false)
  end, delay)
end

function ShaolinChiefPriestBattleLogic.executeSkill(self, mob, skillID, skillLevel, skill, delay)

end

function ShaolinChiefPriestBattleLogic.getAliveSummonCount(self, map, summonMobId)
  local count = 0
  if not ___MOD.isvalid(map) or not ___MOD.isvalid(map.MapLifeComponent) then
    return 0
  end
  local liveMob = map.MapLifeComponent.liveMob
  for i = 1, #liveMob do
    local mob = liveMob[i]
    local mobData = ___MOD.isvalid(mob) and mob.MobComponent or nil
    if ___MOD.isvalid(mobData) and not mobData:isDead() and mobData.id == summonMobId then
      count = count + 1
    end
  end
  return count
end

function ShaolinChiefPriestBattleLogic.isChiefPriest(self, mobID)
  return mobID == 9601068 or mobID == 9601069
end

function ShaolinChiefPriestBattleLogic.isChiefPriestMist(self, skillId, skillLevel, isMobMist)
  return isMobMist and skillId == 186 and skillLevel == 10
end

function ShaolinChiefPriestBattleLogic.isManagedSkill(self, mobID, skillID)

end

function ShaolinChiefPriestBattleLogic.isShaolinBoss(self, mobID)
  return self:isChiefPriest(mobID) or self:isShaolinPriest(mobID)
end

function ShaolinChiefPriestBattleLogic.isShaolinPriest(self, mobID)
  return mobID == 9600025
end

function ShaolinChiefPriestBattleLogic.shaolinSummonLimit(self)
  return 15
end

function ShaolinChiefPriestBattleLogic.shaolinSummonMobId(self)
  return 9601067
end

function ShaolinChiefPriestBattleLogic.shouldHandleShaolinManagedSkill(self, mobID, skillID)
  return self:isChiefPriest(mobID) and self:isManagedSkill(mobID, skillID)
end

function ShaolinChiefPriestBattleLogic.shouldUseFixedRatioAttackClient(self, templateId, attackInfo)
  return self:isChiefPriest(templateId) and attackInfo ~= nil and attackInfo.fixDamR > 0 and attackInfo.fixDamRType == 1
end
