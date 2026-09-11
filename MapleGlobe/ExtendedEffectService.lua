

function ExtendedEffectService.applySkillEffectAlpha(self, effectObject, ownerEntity)
  if not effectObject then
    return
  end
  if ___MOD.type(effectObject) == "table" then
    for i = 1, #effectObject do
      self:applySkillEffectAlpha(effectObject[i], ownerEntity)
    end
    return
  end
  if not effectObject.AnimationSpriteComponent then
    return
  end
  local asc = effectObject.AnimationSpriteComponent
  local effectAlpha = self:getSkillEffectAlpha(ownerEntity)
  asc.forcedAlphaRate = effectAlpha
  asc:setSpriteEntitiesAlpha(effectAlpha)
end

function ExtendedEffectService.broadcastSkillEffect(self, parent, skillID, key, faceLeft, z)

end

function ExtendedEffectService.effectTremble(self, player, trembleForce, heavyNShortTremble, delay, addEffectTime, enforceTremble, senderUserId)

end

function ExtendedEffectService.effectTrembleClient(self, trembleForce, heavyNShortTremble, delay, addEffectTime, enforceTremble)
  if ___MOD._PlayerUpdateLogic.tremble or not enforceTremble and not ___MOD._UserService.LocalPlayer.UISystemOptionComponent.canTremble then
    return
  end
  local ctx = ___MOD.TrembleCtx()
  local now = ___MOD._UtilLogic.ElapsedSeconds
  local start = delay + now
  ctx.trembleStart = start
  ctx.trembleEnd = addEffectTime + start + (heavyNShortTremble and 1.5 or 2)
  local reduction
  if 0 < addEffectTime then
    reduction = 1.0
  elseif heavyNShortTremble then
    reduction = 0.85
  else
    reduction = 0.92
  end
  ctx.trembleReduction = reduction
  ctx.trembleForce = trembleForce
  ___MOD._PlayerUpdateLogic.tremble = ctx
end

function ExtendedEffectService.getMistCellKey(self, cx, cy)
  return ___MOD.tostring(cx) .. ":" .. ___MOD.tostring(cy)
end

function ExtendedEffectService.getMistCellPool(self, parent)
  local map = parent and parent.CurrentMap
  if map == nil or map.MapObjectPool == nil then
    return {
      cell = {},
      part = {},
      allowOverlapRatio = 0.25,
      minCellsForOverlap = 3
    }
  end
  local mop = map.MapObjectPool
  local occ = mop.mistCellPool
  if occ == nil or ___MOD.type(occ) ~= "table" then
    occ = {}
    mop.mistCellPool = occ
  end
  occ.cell = occ.cell or {}
  occ.part = occ.part or {}
  if occ.allowOverlapRatio == nil then
    occ.allowOverlapRatio = 0.25
  end
  if occ.minCellsForOverlap == nil then
    occ.minCellsForOverlap = 3
  end
  return occ
end

function ExtendedEffectService.getMistCountBlockedCells(self, pool, ownerGroup, cells)
  local blocked = 0
  for i = 1, #cells do
    local q = pool.cell[cells[i]]
    if q ~= nil and q[1] ~= nil and q[1].owner ~= ownerGroup then
      blocked = blocked + 1
    end
  end
  return blocked
end

function ExtendedEffectService.getSkillEffectAlpha(self, ownerEntity)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not localPlayer or not localPlayer.UISystemOptionComponent then
    return 1.0
  end
  local isSummonBody = false
  if ___MOD.isvalid(ownerEntity) and not ownerEntity.Player and ___MOD.isvalid(ownerEntity.SummonComponent) then
    local summonComp = ownerEntity.SummonComponent
    if ___MOD.isvalid(summonComp.owner) then
      ownerEntity = summonComp.owner
      isSummonBody = true
    end
  end
  if not ownerEntity or not ownerEntity.Player then
    return 1.0
  end
  local sysOpt = localPlayer.UISystemOptionComponent
  local localUserId = localPlayer.Player and localPlayer.Player.UserId or ""
  local ownerUserId = ownerEntity.Player and ownerEntity.Player.UserId or ""
  local isSelf = localUserId ~= "" and ownerUserId == localUserId
  local opacity
  if isSelf then
    opacity = ___MOD.tonumber(sysOpt.selfSkillEffectOpacity) or 100
    if isSummonBody then
      opacity = ___MOD.math.max(opacity, 30)
    end
  else
    opacity = ___MOD.tonumber(sysOpt.otherSkillEffectOpacity) or 100
  end
  opacity = ___MOD.math.max(0, ___MOD.math.min(100, opacity))
  return opacity / 100
end

function ExtendedEffectService.makeEffect(self, parent, effect, pool, faceLeft, halfScale, loop, syncLayer, syncParent, z, position)
  if effect == nil then
    ___MOD.log_error("존재하지 않는 Effect")
    return
  end
  local modelPath = halfScale and "model://be4c6fda-1e4b-41e3-b47a-23509361a7d8" or "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928"
  local pos = effect.pos or 0
  local localPosition, pickPosition
  if position ~= nil and pos == 0 then
    localPosition = ___MOD.FastVector3(position.x, position.y, z or 0)
    pickPosition = localPosition
    if parent ~= nil and ___MOD.isvalid(parent.TransformComponent) then
      pickPosition = parent.TransformComponent:WorldPositionAsFastVector3() + localPosition
    end
  end
  local e, spawned = ___MOD._ObjectPool:pick(pool, "effect", modelPath, pickPosition, parent, false)
  if localPosition ~= nil then
    e.TransformComponent.Position = localPosition
  elseif position == nil or 0 < pos then
    if pos == 1 then
      e.TransformComponent.Position = ___MOD.FastVector3(0, 0, z)
    else
      e.TransformComponent.Position = ___MOD.FastVector3(0, 0, z)
    end
  end
  if spawned and halfScale then
    e.TransformComponent.Scale = ___MOD.FastVector3(0.5, 0.5, 1)
  end
  if not syncLayer then
    local sprite = e.SpriteRendererComponent
    sprite.SortingLayer = "MapLayer7"
    sprite.OrderInLayer = 5
  end
  local asp = e.AnimationSpriteComponent
  asp.releasePool = pool
  asp.loop = loop
  asp.syncLayerTargetEntity = syncLayer and syncParent or nil
  asp.syncParentLayer = syncLayer
  asp:setLeftFacing(faceLeft)
  asp:setWzSprite(effect, false)
  if syncLayer then
    asp:connectEventSyncParentLayer()
    asp:applyParentLayerToChildren()
  end
  return e
end

function ExtendedEffectService.makeExplosionAnimation(self, map, ea, pos, lt, rb, delay, ownerEntity)
  if not self:shouldPlaySkillEffect(ownerEntity) then
    return
  end
  ___MOD._TimerService:SetTimerOnce(function()
    local explosion = ___MOD._ObjectPool:pick(map.MapObjectPool.explosionPool, "explosion", "model://4ba93aea-af7b-4668-865c-aec57678bbb9", nil, map, true)
    explosion.ExplosionAnimationComponent:registerExplosionAnimation(ea, pos, lt, rb, ownerEntity)
  end, delay)
end

function ExtendedEffectService.makeFallingAnimation(self, map, fa, pos, faceLeft, skillID, skillLevel, ownerEntity, rangeLt, rangeRb)
  if not self:shouldPlaySkillEffect(ownerEntity) then
    return
  end
  local falling = ___MOD._ObjectPool:pick(map.MapObjectPool.fallingPool, "falling", "model://b184095b-0d73-446c-90e6-9d49c7736e23", nil, map, true)
  falling.FallingAnimationComponent:registerFallingAnimation(fa, pos, faceLeft, skillID, skillLevel, ownerEntity, rangeLt, rangeRb)
end

function ExtendedEffectService.makeFogEffect(self, parent, releasePool, ft, b, ownerEntity)
  local fog = ft.effect
  local count = ft.effectCount
  if not fog or not count then
    return
  end
  local effectAlpha = self:getSkillEffectAlpha(ownerEntity)
  if effectAlpha <= 0 then
    return {}
  end
  local box = b
  local halfX = box.Size.x * 0.5
  local halfY = box.Size.y * 0.5
  local position = box.Position
  local rcLeft = position.x - halfX
  local rcRight = position.x + halfX
  local rcTop = position.y + halfY
  local rcBottom = position.y - halfY
  local width = rcRight - rcLeft
  local height = rcTop - rcBottom
  local centerX = position.x
  local rand32 = ___MOD._GlobalRand32
  local entities = {}
  local cellSize = 0.25
  local shrink = 0.65
  local occ = self:getMistCellPool(parent)
  occ.allowOverlapRatio = occ.allowOverlapRatio or 0.25
  occ.minCellsForOverlap = occ.minCellsForOverlap or 3
  local tmp = {}

  local function makeEffect(effect, p, faceLeft)
    local e = ___MOD._ObjectPool:pick(releasePool, "mapEffect", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", p, parent, true)
    if ___MOD.isvalid(e) and ___MOD.isvalid(e.TransformComponent) then
      e.TransformComponent.WorldPosition = p
    end
    e:SetVisible(false)
    local asc = e.AnimationSpriteComponent
    asc.releasePool = releasePool
    e.SpriteRendererComponent.SortingLayer = "MapLayer7"
    e.SpriteRendererComponent.OrderInLayer = 5
    asc.loop = true
    asc.noApplyAlpha = false
    asc.forcedAlphaRate = effectAlpha
    asc:setSpriteEntitiesAlpha(effectAlpha)
    asc:setLeftFacing(faceLeft)
    asc:setWzSprite(effect, false)
    asc:setSpriteEntitiesAlpha(effectAlpha)
    return e
  end

  local x = rcLeft
  while rcRight > x do
    local dist = ___MOD.math.abs(x - centerX)
    local margin = dist / width * 0.5 * height
    local yStart = rcBottom + margin
    local yEnd = rcTop - margin
    if yStart < yEnd then
      local y = yStart
      while yEnd > y do
        local effect = fog[rand32:randomIntegerRange(1, count)]
        if effect then
          local anim1 = effect.anim and effect.anim[1]
          if anim1 and anim1.spriteSize then
            local w = anim1.spriteSize.x / 100
            local h = anim1.spriteSize.y / 100
            local z = rand32:randomIntegerRange(-10, 10)
            local faceLeft = rand32:randomIntegerRange(0, 1) == 0
            local p = ___MOD.FastVector3(x, y, z)
            local e = makeEffect(effect, p, faceLeft)
            local lt = ___MOD.Vector2(p.x - w * 0.5, p.y + h * 0.5)
            local rb = ___MOD.Vector2(p.x + w * 0.5, p.y - h * 0.5)
            self:mistShrinkLtRb(lt, rb, shrink, tmp)
            self:registerPart_Mist(parent, parent, e, tmp.lt, tmp.rb, cellSize, true)
            entities[#entities + 1] = e
            y = y + h * 0.8
          else
            y = y + 0.1
          end
        else
          y = y + 0.1
        end
      end
    end
    x = x + rand32:randomIntegerRange(35, 54) / 100
  end
  for i = 1, #entities do
    local ent = entities[i]
    self:updateVisibleMist(occ, ent)
  end
  return entities
end

function ExtendedEffectService.makeFootholdEffect(self, map, fhEffect, pos, lt, rb, delay, ownerEntity)
  ___MOD._TimerService:SetTimerOnce(function()
    local effectCount = fhEffect.effectCount
    local randomPos = fhEffect.randomPos
    local effectDist = fhEffect.effectDistance
    if lt == nil then
      lt = fhEffect.lt
    end
    if rb == nil then
      rb = fhEffect.rb
    end
    if effectCount <= 0 or effectDist <= 0 then
      return
    end
    local rand32 = ___MOD._GlobalRand32
    local box = ___MOD._NumberUtils:makeBoxShapeFromLtRb(pos, lt, rb, true)
    local boxPos = box.Position
    local boxSize = box.Size
    local rcLeft = boxPos.x - boxSize.x / 2
    local rcRight = boxPos.x + boxSize.x / 2
    local rcTop = boxPos.y + boxSize.y / 2
    local rcBottom = boxPos.y - boxSize.y / 2
    local x = rcLeft
    local effect = fhEffect.effect
    local footholdsY = {}
    while rcRight > x do
      local x2 = x
      if randomPos then
        x2 = x2 + rand32:randomIntegerRange(0, ___MOD.math.floor(effectDist / 3) / 100)
      end
      ___MOD.table.clear(footholdsY)
      ___MOD._FootholdLogic:getFootholdRange(map, x2, rcTop, rcBottom, footholdsY)
      for i = 1, #footholdsY do
        local y = footholdsY[i] + (rand32:randomIntegerRange(0, 4) - 2) / 100
        local pickedEffect = effect[rand32:randomIntegerRange(1, effectCount)]
        self:playAnimationOnMap(map, pickedEffect, ___MOD.FastVector3(x2, y, 0), 128, 255, 0.5, false, nil, nil, nil, ownerEntity)
      end
      x = x + effectDist / 100
    end
  end, delay)
end

function ExtendedEffectService.makeFootholdEffectGlobalXSpacing(self, map, fhEffect, pos, lt, rb, delay, maxCount, forcedEffectIndex, ownerEntity)
  ___MOD._TimerService:SetTimerOnce(function()
    local effectCount = fhEffect.effectCount
    local randomPos = fhEffect.randomPos
    local effectDist = fhEffect.effectDistance
    if lt == nil then
      lt = fhEffect.lt
    end
    if rb == nil then
      rb = fhEffect.rb
    end
    if effectCount <= 0 or effectDist <= 0 then
      return
    end
    local rand32 = ___MOD._GlobalRand32
    local fhc = map.FootholdComponent
    local box = ___MOD._NumberUtils:makeBoxShapeFromLtRb(pos, lt, rb, true)
    local boxPos = box.Position
    local boxSize = box.Size
    local rcLeft = boxPos.x - boxSize.x / 2
    local rcRight = boxPos.x + boxSize.x / 2
    local rcTop = boxPos.y + boxSize.y / 2
    local rcBottom = boxPos.y - boxSize.y / 2
    local minDist = effectDist / 100
    local effect = fhEffect.effect
    local spawnedCount = 0
    local x = rcLeft
    local centerY = (rcTop + rcBottom) * 0.5
    local distY = ___MOD.math.abs(rcTop - rcBottom)
    local platformNextAllowedX = {}

    local function getPlatformKey(fh)
      if fh == nil then
        return nil
      end
      local platformInfo = map.PlatformInfoComponent
      if platformInfo ~= nil and platformInfo.FootholdToPlatform ~= nil then
        local platform = platformInfo.FootholdToPlatform[fh.Id]
        if platform ~= nil then
          return platform.id or fh.Id
        end
      end
      return fh.Id
    end

    local function collectFootholdsAtX(sampleX, output)
      ___MOD.table.clear(output)
      if fhc == nil then
        return
      end
      local visitedFh = {}

      local function collect(list)
        if list == nil then
          return
        end
        for _, fh in ___MOD.ipairs(list) do
          if fh ~= nil and visitedFh[fh.Id] == nil then
            visitedFh[fh.Id] = true
            local y = fh:GetYByX(sampleX)
            if y >= rcBottom and y <= rcTop then
              output[#output + 1] = {
                fh = fh,
                y = y,
                platformKey = getPlatformKey(fh)
              }
            end
          end
        end
      end

      collect(fhc:RaycastAll(___MOD.Vector2(sampleX, centerY), ___MOD.Vector2.up, distY))
      collect(fhc:RaycastAll(___MOD.Vector2(sampleX, centerY), ___MOD.Vector2.down, distY))
      ___MOD.table.sort(output, function(a, b)
        return a.y > b.y
      end)
    end

    local footholds = {}
    while rcRight > x and (not (maxCount ~= nil and 0 < maxCount) or not (spawnedCount >= maxCount)) do
      local x2 = x
      if randomPos then
        x2 = x2 + rand32:randomIntegerRange(0, ___MOD.math.floor(effectDist / 3)) / 100
      end
      collectFootholdsAtX(x2, footholds)
      if 0 < #footholds then
        for j = 1, #footholds do
          if maxCount ~= nil and 0 < maxCount and spawnedCount >= maxCount then
            break
          end
          local info = footholds[j]
          local platformKey = info.platformKey
          if platformKey ~= nil and platformNextAllowedX[platformKey] == nil then
            platformNextAllowedX[platformKey] = rcLeft + rand32:randomIntegerRange(0, ___MOD.math.max(1, ___MOD.math.floor(minDist * 100))) / 100
          end
          local nextAllowedX = platformKey ~= nil and platformNextAllowedX[platformKey] or rcLeft
          if not (x2 < nextAllowedX) then
            local spawnX = x2
            local jitter = ___MOD.math.max(0.06, minDist * 0.18)
            spawnX = spawnX + rand32:randomIntegerRange(-___MOD.math.floor(jitter * 100), ___MOD.math.floor(jitter * 100)) / 100
            if rcLeft > spawnX then
              spawnX = rcLeft
            elseif rcRight < spawnX then
              spawnX = rcRight
            end
            local y = info.y + (rand32:randomIntegerRange(0, 4) - 2) / 100
            local pickedEffect
            if forcedEffectIndex ~= nil and 0 < forcedEffectIndex and effectCount >= forcedEffectIndex then
              pickedEffect = effect[forcedEffectIndex]
            else
              pickedEffect = effect[rand32:randomIntegerRange(1, effectCount)]
            end
            self:playAnimationOnMap(map, pickedEffect, ___MOD.FastVector3(spawnX, y, 0), nil, nil, nil, false, false, nil, nil, ownerEntity)
            spawnedCount = spawnedCount + 1
            if platformKey ~= nil then
              platformNextAllowedX[platformKey] = x2 + minDist
            end
          end
        end
      end
      x = x + minDist
    end
  end, delay)
end

function ExtendedEffectService.makeSingleCenteredFogEffect(self, parent, releasePool, ft, b, ownerEntity)
  local fog = ft.effect
  local count = ft.effectCount
  if not fog or not count then
    return {}
  end
  local effectAlpha = self:getSkillEffectAlpha(ownerEntity)
  if effectAlpha <= 0 then
    return {}
  end
  local box = b
  local effect = fog[1]
  if effect == nil then
    return {}
  end
  local p = ___MOD.FastVector3(box.Position.x, box.Position.y, 0)
  local anim1 = effect.anim and effect.anim[1]
  local offset = anim1 and (anim1.originOffsetFlip or anim1.originOffset) or nil
  if offset ~= nil then
    p.x = p.x - offset.x
    p.y = p.y - offset.y
  end
  local e = ___MOD._ObjectPool:pick(releasePool, "mapEffect", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", p, parent, true)
  e:SetVisible(false)
  if ___MOD.isvalid(e) and ___MOD.isvalid(e.TransformComponent) then
    e.TransformComponent.WorldPosition = p
  end
  local asc = e.AnimationSpriteComponent
  asc.releasePool = releasePool
  e.SpriteRendererComponent.SortingLayer = "MapLayer7"
  e.SpriteRendererComponent.OrderInLayer = 5
  asc.loop = true
  asc.noApplyAlpha = false
  asc.forcedAlphaRate = effectAlpha
  asc:setSpriteEntitiesAlpha(effectAlpha)
  asc:setLeftFacing(false)
  asc:setWzSprite(effect, false)
  asc:setSpriteEntitiesAlpha(effectAlpha)
  e:SetVisible(true)
  return {e}
end

function ExtendedEffectService.mistLtRbToCells(self, lt, rb, cellSize)
  local left = ___MOD.math.min(lt.x, rb.x)
  local right = ___MOD.math.max(lt.x, rb.x)
  local bottom = ___MOD.math.min(lt.y, rb.y)
  local top = ___MOD.math.max(lt.y, rb.y)
  local l = ___MOD.math.floor(left / cellSize)
  local r = ___MOD.math.floor(right / cellSize)
  local b = ___MOD.math.floor(bottom / cellSize)
  local t = ___MOD.math.floor(top / cellSize)
  local out = {}
  for cy = b, t do
    for cx = l, r do
      out[#out + 1] = self:getMistCellKey(cx, cy)
    end
  end
  return out
end

function ExtendedEffectService.mistShrinkLtRb(self, lt, rb, scale, outLtRb)
  if scale == nil then
    scale = 1.0
  end
  if 1.0 <= scale then
    outLtRb.lt = lt
    outLtRb.rb = rb
    return
  end
  local left = ___MOD.math.min(lt.x, rb.x)
  local right = ___MOD.math.max(lt.x, rb.x)
  local bottom = ___MOD.math.min(lt.y, rb.y)
  local top = ___MOD.math.max(lt.y, rb.y)
  local cx = (left + right) * 0.5
  local cy = (bottom + top) * 0.5
  local hx = (right - left) * 0.5 * scale
  local hy = (top - bottom) * 0.5 * scale
  outLtRb.lt = ___MOD.Vector2(cx - hx, cy + hy)
  outLtRb.rb = ___MOD.Vector2(cx + hx, cy - hy)
end

function ExtendedEffectService.playAnimationOnMap(self, map, anim, pos, a0, a1, duration, halfScale, loop, sortingLayer, orderInLayer, ownerEntity)
  local pool = map.MapObjectPool.mapEffectPool
  if halfScale then
    pool = map.MapObjectPool.effectHalfAnimPool
  end
  local modelPath = "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928"
  if halfScale then
    modelPath = "model://be4c6fda-1e4b-41e3-b47a-23509361a7d8"
  end
  local effectAlpha = self:getSkillEffectAlpha(ownerEntity)
  if effectAlpha <= 0 then
    return
  end
  local e = ___MOD._ObjectPool:pick(pool, "mapEffect", modelPath, pos, map, true)
  local asc = e.AnimationSpriteComponent
  asc.releasePool = pool
  e.SpriteRendererComponent.SortingLayer = sortingLayer == nil and "MapLayer7" or sortingLayer
  e.SpriteRendererComponent.OrderInLayer = orderInLayer == nil and 5 or orderInLayer
  if a0 ~= nil and a1 ~= nil and duration ~= nil then
    asc.loop = true
    asc.noApplyAlpha = true
    asc:setSpriteEntitiesAlpha(0)
    local startDuration = ___MOD._GlobalRand32:randomIntegerRange(100, 500) / 1000
    local alpha = ___MOD._GlobalRand32:randomIntegerRange(a0, a1) / 255
    alpha = alpha * effectAlpha
    local tw1 = ___MOD._TweenLogic:PlayTween(0, alpha, startDuration, ___MOD.EaseType.Linear, function(f)
      if asc then
        asc:setSpriteEntitiesAlpha(f)
      end
    end)
    ___MOD._TimerService:SetTimerOnce(function()
      if ___MOD.isvalid(e) then
        local tw2 = ___MOD._TweenLogic:PlayTween(alpha, 0, duration, ___MOD.EaseType.Linear, function(f)
          if asc then
            asc:setSpriteEntitiesAlpha(f)
          end
        end)
        tw2:SetOnEndCallback(function()
          if asc then
            asc:release()
          end
        end)
      end
    end, duration)
  else
    asc.loop = loop
    asc.noApplyAlpha = true
    asc:setSpriteEntitiesAlpha(effectAlpha)
    asc:setLeftFacing(true)
  end
  asc:setWzSprite(anim, false)
  self:applySkillEffectAlpha(e, ownerEntity)
  return e
end

function ExtendedEffectService.playEffectAnimationLocal(self, path, animationType, scaleType, offset, loop, playRate, faceLeft, targetEntity, key, syncParentLayer, syncOrderInLayer)
  if self:shouldHideRemotePlayerVisual(targetEntity) then
    return
  end
  if not self:shouldPlaySkillEffect(targetEntity) then
    return
  end
  if animationType == ___MOD._AnimationType.effect or animationType == ___MOD._AnimationType.effectBackTarget then
    local anim = ___MOD._EffectManager:getEffect(path)
    if anim == nil then
      return
    end
    local pool
    if not ___MOD.isvalid(targetEntity.MapComponent) then
      if targetEntity.PlayerVariables ~= nil then
        pool = targetEntity.PlayerVariables.effectObjPool
        if scaleType == ___MOD._EffectAnimationSubType.halfScale then
          pool = targetEntity.PlayerVariables.effectHalfObjPool
        end
      end
      if pool == nil and ___MOD.isvalid(targetEntity.CurrentMap) and targetEntity.CurrentMap.MapObjectPool ~= nil then
        pool = targetEntity.CurrentMap.MapObjectPool.effectAnimPool
        if scaleType == ___MOD._EffectAnimationSubType.halfScale then
          pool = targetEntity.CurrentMap.MapObjectPool.effectHalfAnimPool
        end
      end
    else
      pool = targetEntity.MapObjectPool.effectAnimPool
      if scaleType == ___MOD._EffectAnimationSubType.halfScale then
        pool = targetEntity.MapObjectPool.effectHalfAnimPool
      end
    end
    if pool == nil then
      return
    end
    local modelPath = "model://95b30da5-4659-4d3f-997a-4fb8f409cfd6"
    if scaleType == ___MOD._EffectAnimationSubType.halfScale then
      modelPath = "model://be4c6fda-1e4b-41e3-b47a-23509361a7d8"
    end
    local position = offset
    if not ___MOD.isvalid(targetEntity.MapComponent) then
      position = targetEntity.TransformComponent:WorldPositionAsFastVector3() + offset
    end
    local e, spawned = ___MOD._ObjectPool:pick(pool, key == nil and "effectAnimation" or key, modelPath, position, targetEntity, true)
    if spawned then
      e.TransformComponent.Position = ___MOD.FastVector3.zero:Clone() + offset
    end
    local asc = e.AnimationSpriteComponent
    if animationType == ___MOD._AnimationType.effectBackTarget then
      e.SpriteRendererComponent.SortingLayer = targetEntity.AvatarRendererComponent.SortingLayer
      e.SpriteRendererComponent.OrderInLayer = 0
    end
    asc.releasePool = pool
    asc.loop = loop
    asc:setLeftFacing(faceLeft)
    asc:setPlayRate(playRate)
    asc:setWzSprite(anim, false)
    self:applySkillEffectAlpha(e, targetEntity)
    local orderInLayer = syncOrderInLayer
    if syncParentLayer then
      asc.syncParentLayer = true
      asc:setOrderInLayer(orderInLayer ~= nil and orderInLayer or targetEntity.AvatarRendererComponent.OrderInLayer)
      asc:setSortingLayer(targetEntity.AvatarRendererComponent.SortingLayer)
      asc:connectEventSyncParentLayer()
    end
    return e
  end
end

function ExtendedEffectService.playEffectAnimationRemote(self, path, animationType, scaleType, offset, loop, playRate, faceLeft, parent, useTargetEntityPosition, targetEntity, key, syncParentLayer, syncOrderInLayer, senderUserId)

end

function ExtendedEffectService.playHlafSkillAnimationLocal(self, attacker, targetEntity, offset, animData, isFaceLeft)
  if self:shouldHideRemotePlayerVisual(targetEntity) then
    return
  end
  if not self:shouldPlaySkillEffect(attacker) then
    return
  end
  if not (___MOD.isvalid(attacker) and attacker.PlayerVariables ~= nil and ___MOD.isvalid(targetEntity)) or not ___MOD.isvalid(animData) then
    return
  end
  local releasePool = attacker.PlayerVariables.halfHitPool
  if releasePool == nil then
    return
  end
  local modelPath = ___MOD._EntryService:GetModelIdByName("Bullet")
  local worldPos = targetEntity.TransformComponent:WorldPositionAsFastVector3() + offset
  local hitObj, spawned = ___MOD._ObjectPool:pick(releasePool, "stickerBulletHit", modelPath, worldPos, targetEntity, true)
  if hitObj == nil then
    return
  end
  hitObj.Visible = true
  if spawned then
    hitObj.TransformComponent.Position = ___MOD.FastVector3.zero:Clone() + offset
  end
  hitObj:SetEnable(true)
  local hitAsc = hitObj.AnimationSpriteComponent
  hitAsc.releasePool = releasePool
  hitAsc.loop = false
  hitAsc:setLeftFacing(isFaceLeft)
  hitAsc:setPlayRate(1.0)
  hitAsc:setWzSprite(animData, false)
  self:applySkillEffectAlpha(hitObj, attacker)
  if hitObj.BulletComponent ~= nil then
    hitObj.BulletComponent.Enable = false
  end
  return hitObj
end

function ExtendedEffectService.playSkillAfterimageLocal(self, targetEntity, data, playRate, offset, loop)
  if self:shouldHideRemotePlayerVisual(targetEntity) then
    return
  end
  if not self:shouldPlaySkillEffect(targetEntity) then
    return
  end
  local map = targetEntity.CurrentMap
  local pool = map.MapObjectPool.skillAnimPool
  if ___MOD.isvalid(data) then
    local e, spawned = ___MOD._ObjectPool:pick(pool, "skillAfterimage", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", targetEntity.TransformComponent:WorldPositionAsFastVector3() + offset, targetEntity, true)
    if spawned then
      e.TransformComponent.Position = ___MOD.FastVector3.zero:Clone() + offset
    end
    local asc = e.AnimationSpriteComponent
    asc.releasePool = pool
    local leftFacing = targetEntity.PlayerControllerComponent.LookDirectionX == -1
    asc.loop = loop
    asc:setLeftFacing(leftFacing)
    asc:setPlayRate(playRate)
    asc:setWzSprite(data, false)
    self:applySkillEffectAlpha(e, targetEntity)
  end
end

function ExtendedEffectService.playSkillAfterimageRemote(self, targetEntity, data, playRate, offset, loop, senderUserId)

end

function ExtendedEffectService.playSkillAnimationLocal(self, animationType, subType, id, effectIndex, targetEntity, playRate, offset, specialData, loop, isFaceLeft, keyName, forceBackLayer, ownerEntity)
  if self:shouldHideRemotePlayerVisual(targetEntity) then
    return
  end
  if not self:shouldPlaySkillEffect(targetEntity) then
    return
  end
  local ret = {}
  if animationType == ___MOD._AnimationType.skill then
    local map = targetEntity.CurrentMap
    local pool
    if ___MOD.isvalid(targetEntity.Player) then
      pool = loop and targetEntity.PlayerVariables.loopEffectAnimPool or targetEntity.PlayerVariables.skillAnimPool
    else
      pool = loop and map.MapObjectPool.loopEffectAnimPool or map.MapObjectPool.skillAnimPool
    end
    local data = ___MOD._SkillManager:getSkill(id)
    local faceLeft = false
    if id == 0 or ___MOD.isvalid(data) then
      local d = {}
      if subType == ___MOD._SkillAnimationSubType.effect then
        local effect = specialData or data.effect
        if effect == nil then
          return
        end
        if effect.anim == nil then
          d[1] = effect[___MOD.tostring(effectIndex)]
        else
          d[1] = effect
        end
        if specialData == nil then
          for i = 1, 10 do
            local eff = data["effect" .. i - 1]
            if eff ~= nil then
              if eff.anim == nil then
                d[i + 1] = eff["0"]
              else
                d[i + 1] = eff
              end
            end
          end
        end
      elseif subType == ___MOD._SkillAnimationSubType.hit then
        local hit = specialData or data.hit
        if id == ___MOD._SkillBook.Savage_Blow_420_4201005 then
          d[1] = hit[2]
        elseif id == 0 or id == ___MOD._SkillBook.Mortal_Blow_311_3110001 or id == ___MOD._SkillBook.Mortal_Blow_321_3210001 then
          d[1] = hit
        elseif hit ~= nil then
          d[1] = hit[effectIndex + 1]
        end
        faceLeft = isFaceLeft
      end
      for i = 1, #d do
        if ___MOD.isvalid(d[i]) then
          local pos
          if ___MOD.isvalid(targetEntity.MapComponent) then
            pos = offset
          else
            pos = targetEntity.TransformComponent:WorldPositionAsFastVector3() + offset
          end
          local e, spawned = ___MOD._ObjectPool:pick(pool, keyName ~= nil and keyName or "skillAnimation", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", pos, targetEntity, true)
          e.Visible = true
          if spawned then
            e.TransformComponent.Position = ___MOD.FastVector3.zero:Clone() + offset
          end
          local asc = e.AnimationSpriteComponent
          asc.releasePool = pool
          if isFaceLeft ~= nil then
            faceLeft = isFaceLeft
          else
            faceLeft = targetEntity.ExtendPlayerControllerComponent.LookDirectionX == -1
          end
          asc.loop = loop
          local effectOrderInLayer
          if subType == ___MOD._SkillAnimationSubType.effect and ___MOD.isvalid(targetEntity.AvatarRendererComponent) then
            effectOrderInLayer = targetEntity.AvatarRendererComponent.OrderInLayer + 1
            if forceBackLayer or d[i].z == -1 then
              effectOrderInLayer = targetEntity.AvatarRendererComponent.OrderInLayer - 1
            elseif id ~= 0 and ___MOD.isvalid(targetEntity.Player) and (___MOD._PlayerSkillLogic:isSkillRidingTamingMobSkill(id, targetEntity) or ___MOD._PlayerSkillLogic:isTamingMobSkill(id, targetEntity)) then
              effectOrderInLayer = targetEntity.AvatarRendererComponent.OrderInLayer + 5
            end
            e.SpriteRendererComponent.SortingLayer = targetEntity.AvatarRendererComponent.SortingLayer
            e.SpriteRendererComponent.OrderInLayer = effectOrderInLayer
          elseif subType == ___MOD._SkillAnimationSubType.hit and d[i].renderAboveTarget and ___MOD.isvalid(targetEntity.AvatarRendererComponent) then
            effectOrderInLayer = targetEntity.AvatarRendererComponent.OrderInLayer + 1
          end
          if ___MOD.isvalid(targetEntity.AvatarRendererComponent) and effectOrderInLayer == nil and d[i].z == -1 then
            e.SpriteRendererComponent.SortingLayer = targetEntity.AvatarRendererComponent.SortingLayer
            e.SpriteRendererComponent.OrderInLayer = targetEntity.AvatarRendererComponent.OrderInLayer - 1
          end
          asc:setLeftFacing(faceLeft)
          asc:setPlayRate(playRate)
          asc:setWzSprite(d[i], false)
          if effectOrderInLayer ~= nil then
            asc:setSortingLayer(targetEntity.AvatarRendererComponent.SortingLayer)
            asc:setOrderInLayer(effectOrderInLayer)
          end
          if subType ~= ___MOD._SkillAnimationSubType.hit then
            local alphaOwner = targetEntity
            if ownerEntity ~= nil then
              alphaOwner = ownerEntity
            end
            self:applySkillEffectAlpha(e, alphaOwner)
          end
          ret[#ret + 1] = e
        end
      end
    end
  end
  return ret
end

function ExtendedEffectService.playSkillAnimationRemote(self, animationType, subType, id, effectIndex, targetEntity, playRate, offset, specialData, loop, isFaceLeft, keyName, forceBackLayer, ownerEntity, senderUserId)

end

function ExtendedEffectService.playSummonEffectLocal(self, targetEntity, data, offset)
  if not self:shouldPlaySkillEffect(targetEntity) then
    return
  end
  local map = targetEntity.CurrentMap
  local pool = map.MapObjectPool.summonEffectAnimPool
  if ___MOD.isvalid(data) then
    local e, spawned = ___MOD._ObjectPool:pick(pool, "skillAfterimage", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", offset, map, true)
    if spawned then
      e.TransformComponent.Position = ___MOD.FastVector3.zero:Clone() + offset
    end
    local asc = e.AnimationSpriteComponent
    asc.releasePool = pool
    asc.loop = false
    asc:setWzSprite(data, false)
    self:applySkillEffectAlpha(e, targetEntity)
  end
end

function ExtendedEffectService.registerPart_Mist(self, parent, ownerGroup, ent, lt, rb, cellSize, skipVisibilityUpdate)
  local pool = self:getMistCellPool(parent)
  if pool == nil then
    return
  end
  local cells = self:mistLtRbToCells(lt, rb, cellSize)
  for i = 1, #cells do
    local key = cells[i]
    local q = pool.cell[key]
    if q == nil then
      q = {}
      pool.cell[key] = q
    end
    q[#q + 1] = {ent = ent, owner = ownerGroup}
  end
  pool.part[ent] = {owner = ownerGroup, cells = cells}
  if not skipVisibilityUpdate then
    self:updateVisibleMist(pool, ent)
  end
end

function ExtendedEffectService.removeGroup_Mist(self, parent, children)
  if children == nil then
    return
  end
  for i = 1, #children do
    local item = children[i]
    local ent = item
    if ___MOD.type(item) == "table" then
      ent = item.ent
    end
    if ent ~= nil then
      self:removePart_Mist(parent, ent)
    end
  end
end

function ExtendedEffectService.removePart_Mist(self, parent, ent)
  local pool = self:getMistCellPool(parent)
  if pool == nil or pool.part == nil then
    return
  end
  local meta = pool.part[ent]
  if meta == nil then
    return
  end
  local affected = {}
  for i = 1, #meta.cells do
    local key = meta.cells[i]
    local q = pool.cell[key]
    if q ~= nil then
      for j = #q, 1, -1 do
        if q[j].ent == ent then
          local lastIndex = #q
          if j ~= lastIndex then
            q[j] = q[lastIndex]
          end
          q[lastIndex] = nil
          break
        end
      end
      affected[key] = true
      if #q == 0 then
        pool.cell[key] = nil
      end
    end
  end
  pool.part[ent] = nil
  local candidates = {}
  for key, _ in ___MOD.pairs(affected) do
    local q = pool.cell[key]
    if q ~= nil then
      for k = 1, #q do
        local e = q[k].ent
        if e ~= nil and pool.part[e] ~= nil then
          candidates[e] = true
        end
      end
    end
  end
  for candEnt, _ in ___MOD.pairs(candidates) do
    self:updateVisibleMist(pool, candEnt)
  end
end

function ExtendedEffectService.responseEnchantScroll(self, success, destroy)
  local msg
  if success then
    msg = "주문서가 한 순간 빛나더니 신비로운 힘이 그대로 아이템에 전해졌습니다."
  elseif destroy then
    msg = "주문서의 힘에 의해서 아이템이 파괴되었습니다."
  else
    msg = "주문서가 한 순간 빛났지만 아이템에는 아무런 변화도 일어나지 않았습니다."
  end
  ___MOD._ChatLogic:addChatLog(___MOD._ChatMessageType.Red, msg)
end

function ExtendedEffectService.shouldHideRemotePlayerVisual(self, entity)
  if not ___MOD.isvalid(entity) or not ___MOD.isvalid(entity.Player) then
    return false
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) then
    return false
  end
  return entity ~= localPlayer and entity.Player.AdminHidden
end

function ExtendedEffectService.shouldPlaySkillEffect(self, ownerEntity)
  if not ownerEntity then
    return true
  end
  return self:getSkillEffectAlpha(ownerEntity) > 0
end

function ExtendedEffectService.showEffect(self, targetUser, type, data, remote)

end

function ExtendedEffectService.showEffect_general(self, parent, effect, faceLeft, z, halfScale, position, ownerEntity)
  if effect == nil then
    ___MOD.log_error("존재하지 않는 Effect")
    return
  end
  local modelPath = halfScale and "model://be4c6fda-1e4b-41e3-b47a-23509361a7d8" or "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928"
  local pool = parent.CurrentMap.MapObjectPool
  local releasePool = halfScale and pool.effectHalfAnimPool or pool.effectAnimPool
  local pos = effect.pos or 0
  local e, spawned = ___MOD._ObjectPool:pick(releasePool, "effect", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", position and pos == 0 and ___MOD.FastVector3(position.x, position.y, z) or nil, parent, true)
  if position == nil or 0 < pos then
    if pos == 1 then
      e.TransformComponent.Position = ___MOD.FastVector3(0, 0, z)
    else
      e.TransformComponent.Position = ___MOD.FastVector3(0, 0, z)
    end
  end
  if spawned and halfScale then
    e.TransformComponent.Scale = ___MOD.FastVector3(0.5, 0.5, 1)
  end
  e.SpriteRendererComponent.SortingLayer = "MapLayer7"
  e.SpriteRendererComponent.OrderInLayer = 5
  local asc = e.AnimationSpriteComponent
  asc.releasePool = releasePool
  asc.loop = false
  asc:setLeftFacing(faceLeft)
  asc:setWzSprite(effect, false)
  if ownerEntity ~= nil then
    self:applySkillEffectAlpha(e, ownerEntity)
  end
end

function ExtendedEffectService.showEffectClient(self, target, type, data)
  local etype = ___MOD._EffectType
  if 1 <= type and type <= 99 then
    self:showUserEffectClient(target, type)
  end
end

function ExtendedEffectService.showSkillEffect(self, parent, skillID, key, faceLeft, z)
  if self:shouldHideRemotePlayerVisual(parent) then
    return
  end
  if not self:shouldPlaySkillEffect(parent) then
    return
  end
  local skill = ___MOD._SkillManager:getSkill(skillID)
  if not skill then
    ___MOD.log_error("존재하지 않는 SkillID", skillID)
    return
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(key) then
    key = "effect"
  end
  local effect = skill[key]
  if effect == nil then
    ___MOD.log_error("존재하지 않는 Effect")
    return
  end
  local modelPath = "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928"
  local pool = parent.CurrentMap.MapObjectPool
  local releasePool = pool.skillAnimPool
  local pos = effect.pos or 0
  local position = parent.TransformComponent:WorldPositionAsFastVector3()
  if z then
    position.z = z
  end
  local e, spawned = ___MOD._ObjectPool:pick(releasePool, "effect", "model://f4bb0e1c-f068-4fcb-ab5c-c53e53d72928", position, parent, true)
  e.SpriteRendererComponent.SortingLayer = parent.AvatarRendererComponent.SortingLayer
  e.SpriteRendererComponent.OrderInLayer = parent.AvatarRendererComponent.OrderInLayer
  local asc = e.AnimationSpriteComponent
  asc.releasePool = releasePool
  asc.loop = false
  asc:setLeftFacing(faceLeft)
  asc:setWzSprite(effect, false)
  self:applySkillEffectAlpha(e, parent)
end

function ExtendedEffectService.showUserEffect(self, targetUser, type, remote)

end

function ExtendedEffectService.showUserEffectClient(self, targetUser, type)
  local effectPath, soundPath, effect, sound
  local etype = ___MOD._EffectType
  if type == etype.LevelUp_1 then
    effectPath = "BasicEff.img/LevelUp"
    soundPath = "Game.img.LevelUp"
  elseif type == etype.JobChanged_2 then
    effectPath = "BasicEff.img/JobChanged"
    soundPath = "Game.img.JobChanged"
  elseif type == etype.PortalSoundEffect_3 then
    soundPath = "Game.img.Portal"
  elseif type == etype.QuestComplete_4 then
    effectPath = "BasicEff.img/QuestClear"
    soundPath = "Game.img.QuestClear"
  elseif type == etype.Enchant_Success_6 then
    effectPath = "BasicEff.img/Enchant/Success"
    soundPath = "Game.img.EnchantSuccess"
  elseif type == etype.Enchant_Failure_7 then
    effectPath = "BasicEff.img/Enchant/Failure"
    soundPath = "Game.img.EnchantFailure"
  elseif type == etype.ItemMake_Success_8 then
    effectPath = "BasicEff.img/ItemMake/Success"
    soundPath = "Game.img.EnchantSuccess"
  elseif type == etype.ItemMake_Failure_9 then
    effectPath = "BasicEff.img/ItemMake/Failure"
    soundPath = "Game.img.EnchantFailure"
  elseif type == etype.ItemLevelUp_10 then
    effectPath = "BasicEff.img/ItemLevelUp"
    soundPath = "Game.img.ItemLevelUp"
  end
  if effectPath then
    effect = ___MOD._EffectManager:getEffect(effectPath)
  end
  if effect then
    local pool = targetUser.PlayerVariables.effectHalfObjPool
    self:makeEffect(targetUser, effect, pool, true, true, false, true, targetUser, 0, nil)
  end
  if soundPath then
    sound = ___MOD.__RUIDManager:get(soundPath)
  end
  if sound then
    local user = ___MOD._UserService.LocalPlayer
    ___MOD._SoundUtils:playOneShotSoundAtPosLocal(sound, targetUser.TransformComponent:WorldPositionAsFastVector3(), user, 1, ___MOD._SoundUtils:resolveCombatSoundCategory(targetUser))
  end
end

function ExtendedEffectService.updateVisibleMist(self, pool, ent)
  if ent == nil or ___MOD.isvalid ~= nil and not ___MOD.isvalid(ent) then
    return
  end
  local meta = pool.part[ent]
  if meta == nil then
    return
  end
  local owner = meta.owner
  local cells = meta.cells
  local total = #cells
  if total <= 0 then
    ent:SetVisible(true)
    return
  end
  local allowRatio = pool.allowOverlapRatio or 0.25
  local minCells = pool.minCellsForOverlap or 3
  local blocked = self:getMistCountBlockedCells(pool, owner, cells)
  if total < minCells then
    ent:SetVisible(blocked == 0)
    return
  end
  ent:SetVisible(allowRatio >= blocked / total)
end
