

function UIUtilLogic.getCursorUIPosition(self)
  local c = ___MOD._InputService:GetCursorPosition()
  local SW, SH = ___MOD._UILogic.ScreenWidth, ___MOD._UILogic.ScreenHeight
  local refW, refH = 1920, 1080
  local curAspect, refAspect = SW / SH, refW / refH
  local halfW, halfH
  if curAspect < refAspect then
    halfW = refW / 2
    halfH = halfW / curAspect
  else
    halfH = refH / 2
    halfW = halfH * curAspect
  end
  local nx = c.x / SW
  local ny = c.y / SH
  local uiX = (nx * 2 - 1) * halfW
  local uiY = (ny * 2 - 1) * halfH
  local uiPos = ___MOD.FastVector2(uiX, uiY)
  return uiPos
end

function UIUtilLogic.getCursorWorldPosition(self)
  local c = ___MOD._InputService:GetCursorPosition()
  local w = ___MOD._UILogic:ScreenToWorldPosition(c)
  return w
end

function UIUtilLogic.getWorldViewBounds(self)
  local rc = ___MOD.Rect()
  local sw, sh = ___MOD._UILogic.ScreenWidth, ___MOD._UILogic.ScreenHeight
  local lt = ___MOD._UILogic:ScreenToWorldPosition(___MOD.FastVector2(0, sh))
  local rb = ___MOD._UILogic:ScreenToWorldPosition(___MOD.FastVector2(sw, 0))
  rc.left = lt.x
  rc.right = rb.x
  rc.top = lt.y
  rc.bottom = rb.y
  return rc
end

function UIUtilLogic.isAAResoultion(self)
  if ___MOD._UILogic.ScreenWidth ~= 1280 and ___MOD._UILogic.ScreenWidth % 640 == 0 then
    return false
  end
  return true
end

function UIUtilLogic.screenDeltaToUI(self, screenDelta)
  local SW, SH = ___MOD._UILogic.ScreenWidth, ___MOD._UILogic.ScreenHeight
  local refW, refH = 1920, 1080
  local curAspect, refAspect = SW / SH, refW / refH
  local halfW, halfH
  if curAspect < refAspect then
    halfW = refW / 2
    halfH = halfW / curAspect
  else
    halfH = refH / 2
    halfW = halfH * curAspect
  end
  local scaleX = 2 * halfW / SW
  local scaleY = 2 * halfH / SH
  local uiPos = ___MOD.FastVector2(screenDelta.x * scaleX, screenDelta.y * scaleY)
  return uiPos
end

function UIUtilLogic.screenPointToUI(self, screenPoint)
  if screenPoint == nil then
    return self:getCursorUIPosition()
  end
  local SW, SH = ___MOD._UILogic.ScreenWidth, ___MOD._UILogic.ScreenHeight
  local refW, refH = 1920, 1080
  local curAspect, refAspect = SW / SH, refW / refH
  local halfW, halfH
  if curAspect < refAspect then
    halfW = refW / 2
    halfH = halfW / curAspect
  else
    halfH = refH / 2
    halfW = halfH * curAspect
  end
  local nx = screenPoint.x / SW
  local ny = screenPoint.y / SH
  return ___MOD.FastVector2((nx * 2 - 1) * halfW, (ny * 2 - 1) * halfH)
end
