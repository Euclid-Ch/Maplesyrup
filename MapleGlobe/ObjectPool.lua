

function ObjectPool.clear(self, pool)
  for _, e in ___MOD.pairs(pool) do
    local entity = e
    if entity then
      entity:Destroy()
    end
  end
  ___MOD.table.clear(pool)
end

function ObjectPool.pick(self, pool, objName, modelId, pos, parent, enable)
  if ___MOD.next(pool) == nil then
    if pos == nil then
      pos = ___MOD.FastVector3(0, 0, 0)
    end
    local ret = ___MOD._SpawnService:SpawnByModelId(modelId, objName, pos, parent)
    if not enable then
      ret.Enable = false
    end
    return ret, true
  else
    local id, entity = ___MOD.next(pool)
    pool[id] = nil
    if not ___MOD.isvalid(entity) then
      return self:pick(pool, objName, modelId, pos, parent, enable)
    end
    if parent and entity.Parent ~= parent then
      entity:AttachTo(parent)
    end
    if pos ~= nil then
      local t = entity.TransformComponent
      local uit = entity.UITransformComponent
      if ___MOD.isvalid(uit) then
        uit.Position = pos
      elseif ___MOD.isvalid(t) then
        t.WorldPosition = pos
      end
    end
    if enable then
      entity.Enable = true
    end
    return entity, false
  end
end

function ObjectPool.release(self, pool, entity, forceRelease)
  if entity and (entity.Enable or forceRelease) then
    if ___MOD.isvalid(entity.UITransformComponent) then
      entity.UITransformComponent.Position = self.releasePos
    elseif ___MOD.isvalid(entity.TransformComponent) then
      entity.TransformComponent.WorldPosition = self.releasePos
    end
    if pool[entity.Id] == nil then
      pool[entity.Id] = entity
    end
    entity.Enable = false
  end
end
