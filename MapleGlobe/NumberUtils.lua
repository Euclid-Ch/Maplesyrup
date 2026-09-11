

function NumberUtils.crossProduct(self, vec1, vec2)
  return -(vec1.x * vec2.y - vec1.y * vec2.x)
end

function NumberUtils.getGenderFromID(self, itemID)
  if ___MOD.math.floor(itemID / 1000000) ~= 1 then
    return 2
  end
  local v2 = ___MOD.math.floor(itemID / 1000) % 10
  if v2 == 0 then
    return 0
  elseif v2 == 1 then
    return 1
  else
    return 2
  end
end

function NumberUtils.getTriggerBoxFromLtRb(self, lt, rb, left)
  local size = ___MOD.FastVector2(rb.x - lt.x, rb.y - lt.y)
  local center = ___MOD.FastVector2.zero:Clone()
  local abs = ___MOD.math.abs
  if abs(lt.x) > abs(rb.x) then
    center.x = -abs(lt.x) + size.x / 2
  else
    center.x = abs(rb.x) - size.x / 2
  end
  if abs(lt.y) > abs(rb.y) then
    center.y = abs(lt.y) - size.y / 2
  else
    center.y = -abs(rb.y) + size.y / 2
  end
  if not left then
    center.x = -center.x
  end
  return center / 100, size / 100
end

function NumberUtils.intersectBox(self, b1, b2)
  if b1 == nil or b2 == nil then
    return nil
  end
  local abs = ___MOD.math.abs
  local p1, s1 = b1.Position, b1.Size
  local p2, s2 = b2.Position, b2.Size
  local hx1, hy1 = s1.x * 0.5, s1.y * 0.5
  local hx2, hy2 = s2.x * 0.5, s2.y * 0.5
  if abs(p1.x - p2.x) > hx1 + hx2 then
    return nil
  end
  if abs(p1.y - p2.y) > hy1 + hy2 then
    return nil
  end
  local l1, r1 = p1.x - hx1, p1.x + hx1
  local b1y, t1 = p1.y - hy1, p1.y + hy1
  local l2, r2 = p2.x - hx2, p2.x + hx2
  local b2y, t2 = p2.y - hy2, p2.y + hy2
  local left = l1 < l2 and l2 or l1
  local right = r1 > r2 and r2 or r1
  local bottom = b1y < b2y and b2y or b1y
  local top = t1 > t2 and t2 or t1
  if left > right or bottom > top then
    return nil
  end
  return ___MOD.Vector2((left + right) * 0.5, (bottom + top) * 0.5)
end

function NumberUtils.intersectRC(self, rc1, rc2)
  if rc1 == nil or rc2 == nil then
    return nil
  end
  local l1 = rc1.left < rc1.right and rc1.left or rc1.right
  local r1 = rc1.left < rc1.right and rc1.right or rc1.left
  local b1 = rc1.bottom < rc1.top and rc1.bottom or rc1.top
  local t1 = rc1.bottom < rc1.top and rc1.top or rc1.bottom
  local l2 = rc2.left < rc2.right and rc2.left or rc2.right
  local r2 = rc2.left < rc2.right and rc2.right or rc2.left
  local b2 = rc2.bottom < rc2.top and rc2.bottom or rc2.top
  local t2 = rc2.bottom < rc2.top and rc2.top or rc2.bottom
  local left = l1 > l2 and l1 or l2
  local right = r1 < r2 and r1 or r2
  local bottom = b1 > b2 and b1 or b2
  local top = t1 < t2 and t1 or t2
  if left > right or bottom > top then
    return nil
  end
  return ___MOD.Vector2((left + right) * 0.5, (bottom + top) * 0.5)
end

function NumberUtils.makeBoxShapeFromLtRb(self, origin, lt, rb, left)
  local center, size = self:getTriggerBoxFromLtRb(lt, rb, left)
  return ___MOD.BoxShape(origin + center, size, 0)
end

function NumberUtils.pointInBoxShape(self, x, y, boxShape)
  local box = boxShape
  if not box then
    return false
  end
  local abs = ___MOD.math.abs
  local p = box.Position
  local s = box.Size
  local hx = s.x * 0.5
  local dx = x - p.x
  if hx < abs(dx) then
    return false
  end
  local hy = s.y * 0.5
  local dy = y - p.y
  if hy < abs(dy) then
    return false
  end
  return true
end

function NumberUtils.pointInRect(self, pt, rc)
  return pt.x >= rc.left and pt.x < rc.right and pt.y >= rc.bottom and pt.y < rc.top
end

function NumberUtils.triggerToBox(self, t)
  return ___MOD.BoxShape(t.Entity.TransformComponent:WorldPositionAsFastVector3():ToVector2() + t.ColliderOffset, t.BoxSize, 0)
end
