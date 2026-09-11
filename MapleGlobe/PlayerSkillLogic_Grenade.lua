

function PlayerSkillLogic_Grenade.spawnPoisonBombMist(self, attacker, skillID, skillLevel, pos, senderUserId)

end

function PlayerSkillLogic_Grenade.tryGrenadeAttack(self, attacker, skillID, skillLevel, pos, isFinalAttack)
  local isMe = attacker == ___MOD._UserService.LocalPlayer
  if attacker.Player:isDead() then
    return false
  end
  local currentTime = ___MOD._UtilLogic.ServerElapsedSeconds
  local skillHitPath = ___MOD.__RUIDManager:get(___MOD.string.format("Skill.img.%d.Use2", skillID))
  if not ___MOD._UtilLogic:IsNilorEmptyString(skillHitPath) and ___MOD._PlayerAttackLogic_Melee:shouldPlayAttackSound(attacker) then
    ___MOD._SoundUtils:broadcastSoundAtPosByRUIDLocal(skillHitPath, attacker, attacker, 1)
  end
  local skillData = ___MOD._SkillManager:getSkill(skillID)
  if skillData == nil then
    return
  end
  local skillLevelData = ___MOD._SkillManager:getSkillLevelData(skillID, skillLevel)
  if skillLevelData == nil then
    return
  end
  local special = skillData.special
  if special ~= nil then
    local anim = ___MOD._ExtendedEffectService:playAnimationOnMap(attacker.CurrentMap, special, ___MOD.FastVector3(pos.x, pos.y, 0), nil, nil, nil, false, false, nil, nil)
  end
  if not isMe then
    return
  end
  if skillID == ___MOD._SkillBook.Poison_Bomb_1411_14111006 then
    self:spawnPoisonBombMist(attacker, skillID, skillLevel, pos)
  end
  local lt = skillLevelData.lt
  local rb = skillLevelData.rb
  local box
  if lt and rb then
    local center, size = ___MOD._OffsetUtils:calcNormalizedBox(lt, rb, false)
    box = ___MOD.BoxShape(center, size, 0)
  end
  box.Position = box.Position + attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2()
  local mobs = ___MOD._PlayerAttackLogic:findValidMobs(attacker, pos, box.Size, 0, skillLevelData.mobCount, false)
  local delays = {}
  local damages = {}
  local criticals = {}
  local attackCount = 1
  local playerInputX = attacker.PlayerControllerComponent.LookDirectionX
  if ___MOD.next(mobs) then
    local attackerPosSnapshot = attacker.TransformComponent:WorldPositionAsFastVector3():ToVector2():Clone()
    for i, m in ___MOD.ipairs(mobs) do
      local mob = m
      local mobFaceLeft = mob.MovementComponent:IsFaceLeft()
      local mobPos = mob.TransformComponent.Position:ToVector2()
      local damageDelays = {}
      local damages_, criticals_, highestDamage = ___MOD._PlayerAttackLogic:calcDamageClient(attacker, mob, skillID, skillLevel, attackCount, {0}, "", 0, 0, -1, i, 0.0, false)
      damages[#damages + 1] = damages_
      criticals[#criticals + 1] = criticals_
      damageDelays[#damageDelays + 1] = 0
      local hitOffset = ___MOD._PlayerAttackLogic:getHitOffset(mob, pos, mobPos, box, false, mobFaceLeft, false)
      local effectTarget = mob
      local hitData = skillData.hit
      local hitCount = 0
      for j = 1, 100 do
        if hitData ~= nil then
          local eff = hitData[j]
          if eff ~= nil then
            hitCount = hitCount + 1
          else
            break
          end
        end
      end
      local hitIndex = ___MOD._GlobalRand32:randomIntegerRange(0, hitCount - 1)
      local hitEffects = ___MOD._ExtendedEffectService:playSkillAnimationLocal(___MOD._AnimationType.skill, ___MOD._SkillAnimationSubType.hit, skillID, hitIndex, effectTarget, 1.0, hitOffset, hitData, false, false, nil)
      ___MOD._ExtendedEffectService:applySkillEffectAlpha(hitEffects, attacker)
      delays[#delays + 1] = damageDelays
      ___MOD._PlayerAttackLogic:displaySkillDamageByAttackerClient(attacker, mob, skillID, damages_, criticals_, damageDelays)
      local totalDamage, deadlyAttack = ___MOD._PlayerAttackLogic:onAttackClient(attacker, mob, damages_)
    end
    local sad = ___MOD._PlayerAttackLogic_Melee:initSkillAttackData(skillID, skillLevel, attackerPosSnapshot, playerInputX, #mobs, attackCount, "", ___MOD._SkillAttackType.Shoot, mobs, damages, criticals, delays, 0, 1.0, false, 0, 0, 0, 0, -1, nil, 0.0, false, nil)
    ___MOD._PlayerAttackLogic:onPlayerAttack(attacker, sad:toTable())
    ___MOD._PlayerAttackLogic:refreshSummonAttackAbleTimeClient(attacker)
  end
end
