

function OffsetUtils.bankerAdjust(self, size)
  local half = size / 2
  local floor = ___MOD.math.floor(half)
  if size % 2 == 0 then
    return half, false
  end
  local rounded = floor % 2 == 0 and floor or floor + 1
  local dir = half < rounded
  return rounded, dir
end

function OffsetUtils.calcNormalizedBox(self, lt, rb, left)
  local size = ___MOD.Vector2(rb.x - lt.x, rb.y - lt.y)
  local center = ___MOD.Vector2.zero
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
  return center, size
end

function OffsetUtils.calcScrollByCursorPos(self, scrollCount, scrollYSize, barBaseY, prevBaseY, prevButton)
  local barLength = scrollYSize
  local barStartPivotY = ___MOD.math.abs(barBaseY - prevBaseY) * -1
  local barEndPivotY = barStartPivotY + barLength * -1
  local step = barLength / scrollCount
  local cursorPos = ___MOD._InputService:GetCursorPosition()
  local prevBtPos = ___MOD._UILogic:ScreenToLocalUIPosition(cursorPos, prevButton.UITransformComponent)
  local clampedY = ___MOD.math.clamp(prevBtPos.y, barEndPivotY, barStartPivotY)
  local EPS = 1.0E-6
  local relativeY = ___MOD.math.abs(clampedY - barStartPivotY)
  local scrollIndex = ___MOD.math.floor(relativeY / step)
  if scrollIndex < 0 then
    scrollIndex = 0
  end
  if scrollCount < scrollIndex then
    scrollIndex = scrollCount
  end
  local barY = barBaseY - scrollIndex * step
  return scrollIndex, barY
end

function OffsetUtils.GetEvenPivotOffset(self, width, height, originX, originY, half)
  if half then
    width = width * 2
    height = height * 2
    originX = originX * 2
    originY = originY * 2
  end
  local hx, dirX = self:bankerAdjust(width)
  local hy, dirY = self:bankerAdjust(height)
  if height % 2 == 1 then
    hy = hy + (dirY and -1 or 1)
  end
  local mapleBase = ___MOD.Vector2(hx, -hy)
  local origin = mapleBase + ___MOD.Vector2(-originX, originY)
  return origin.x, origin.y
end
