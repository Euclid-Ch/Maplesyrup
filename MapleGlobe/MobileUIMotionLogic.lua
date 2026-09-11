

function MobileUIMotionLogic.playFade(self, target, fromAlpha, toAlpha, duration, easeType)
  if not ___MOD.isvalid(target) then
    return nil
  end
  local renderer = target.SpriteGUIRendererComponent
  if renderer == nil then
    return nil
  end
  local tween = ___MOD._TweenLogic:MakeTween(0, 1, duration, easeType or ___MOD.EaseType.QuadEaseInOut, function(value)
    if ___MOD.isvalid(target) then
      renderer:SetAlpha(fromAlpha + (toAlpha - fromAlpha) * value)
    end
  end)
  tween.AutoDestroy = true
  tween:Play()
  return tween
end

function MobileUIMotionLogic.playScaleTo(self, target, toScale, duration, easeType)
  if not ___MOD.isvalid(target) then
    return nil
  end
  local transform = target.UITransformComponent
  if transform == nil then
    return nil
  end
  local tween = ___MOD._TweenLogic:MakeTween(transform.Scale, toScale, duration, easeType or ___MOD.EaseType.QuadEaseInOut, function(value)
    if ___MOD.isvalid(target) then
      transform.Scale = value
    end
  end)
  tween.AutoDestroy = true
  tween:Play()
  return tween
end

function MobileUIMotionLogic.playSlide(self, target, isXAxis, fromValue, toValue, duration, easeType)
  if not ___MOD.isvalid(target) then
    return nil
  end
  local transform = target.UITransformComponent
  if transform == nil then
    return nil
  end
  local tween = ___MOD._TweenLogic:MakeTween(0, 1, duration, easeType or ___MOD.EaseType.QuadEaseInOut, function(value)
    if ___MOD.isvalid(target) then
      local currentValue = fromValue + (toValue - fromValue) * value
      if isXAxis then
        transform.anchoredPosition.x = currentValue
      else
        transform.anchoredPosition.y = currentValue
      end
    end
  end)
  tween.AutoDestroy = true
  tween:Play()
  return tween
end

function MobileUIMotionLogic.playSlideCanvasGroupFade(self, target, isXAxis, fromValue, toValue, fromAlpha, toAlpha, duration, easeType)
  if not ___MOD.isvalid(target) then
    return nil
  end
  local transform = target.UITransformComponent
  if transform == nil then
    return nil
  end
  local canvas = target.CanvasGroupComponent
  if canvas == nil then
    return nil
  end
  local tween = ___MOD._TweenLogic:MakeTween(0, 1, duration, easeType or ___MOD.EaseType.QuadEaseInOut, function(value)
    if not ___MOD.isvalid(target) then
      return
    end
    local currentValue = fromValue + (toValue - fromValue) * value
    if isXAxis then
      transform.anchoredPosition.x = currentValue
    else
      transform.anchoredPosition.y = currentValue
    end
    canvas.GroupAlpha = fromAlpha + (toAlpha - fromAlpha) * value
  end)
  tween.AutoDestroy = true
  tween:Play()
  return tween
end

function MobileUIMotionLogic.playSlideFade(self, target, isXAxis, fromValue, toValue, fromAlpha, toAlpha, duration, easeType)
  if not ___MOD.isvalid(target) then
    return nil
  end
  local transform = target.UITransformComponent
  if transform == nil then
    return nil
  end
  local renderer = target.SpriteGUIRendererComponent
  local tween = ___MOD._TweenLogic:MakeTween(0, 1, duration, easeType or ___MOD.EaseType.QuadEaseInOut, function(value)
    local currentValue = fromValue + (toValue - fromValue) * value
    if isXAxis then
      transform.anchoredPosition.x = currentValue
    else
      transform.anchoredPosition.y = currentValue
    end
    if renderer ~= nil then
      renderer:SetAlpha(fromAlpha + (toAlpha - fromAlpha) * value)
    end
  end)
  tween.AutoDestroy = true
  tween:Play()
  return tween
end
