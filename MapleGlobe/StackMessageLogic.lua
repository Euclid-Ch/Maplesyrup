

function StackMessageLogic.addMessage(self, message)
  local parent = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/StackMessage")
  local emptyText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyText")
  self.sn = self.sn + 1
  local entity = ___MOD._SpawnService:SpawnByEntity(emptyText, "stackMessage" .. ___MOD.tostring(self.sn), ___MOD.Vector3(0, 0, 0), parent)
  entity.Visible = false
  entity:AddComponent(___MOD.FontGUIRendererComponent)
  entity:AddComponent(___MOD.CanvasGroupComponent)
  self:applyStackMessageEntityLayout(entity, 30)
  local g = entity.FontGUIRendererComponent
  for i = #self.messages, 1, -1 do
    local e = self.messages[i]
    if ___MOD.isvalid(e) and e.UITransformComponent ~= nil then
      e.UITransformComponent.anchoredPosition.y = e.UITransformComponent.anchoredPosition.y + 30
      self.messages[i + 1] = e
    end
  end
  self.messages[1] = entity
  if #self.messages > 6 then
    local toRemove = self.messages[7]
    if toRemove ~= nil then
      toRemove:Destroy()
    end
    self.messages[7] = nil
  end
  g.fontType = ___MOD._FontType.gulim9pt
  g.text = message
  g.color = ___MOD.Color.FromHexCode("#FEFEFE")
  g.notAA = true
  g.stackMessage = true
  g:DrawText()
  ___MOD.wait(1.0E-4)
  entity.Visible = true
  local tween = ___MOD._TweenLogic:MakeTween(1.0, 0.0, 4, ___MOD.EaseType.Linear, function(tweenValue)
    if ___MOD.isvalid(entity) then
      if tweenValue <= 0 then
        entity:Destroy()
        return
      end
      entity.CanvasGroupComponent.GroupAlpha = tweenValue
    end
  end)
  tween.AutoDestroy = true
  tween.LoopCount = 0
  tween:Play()
end

function StackMessageLogic.addMessage_bitmap(self, message, color)
  self._T.inUse = self._T.inUse or {}
  self._T.token = self._T.token or {}
  if self.activeMessages then
    for i = #self.activeMessages, 1, -1 do
      local e = self.activeMessages[i]
      if not ___MOD.isvalid(e) then
        ___MOD.table.remove(self.activeMessages, i)
      end
    end
  else
    self.activeMessages = {}
  end
  local entity
  for _, e in ___MOD.pairs(self.messagePool) do
    if ___MOD.isvalid(e) and not self._T.inUse[e.Id] then
      entity = e
      break
    end
  end
  if not entity then
    ___MOD.log_warning("[addMessage_bitmap] no free message entity (pool exhausted)")
    return
  end
  self._T.inUse[entity.Id] = true
  ___MOD.table.insert(self.activeMessages, 1, entity)
  if #self.activeMessages > self.maxMessages then
    local toRemove = ___MOD.table.remove(self.activeMessages, self.maxMessages + 1)
    if toRemove then
      local tw = self._T[toRemove.Id]
      if tw then
        tw:Destroy()
        self._T[toRemove.Id] = nil
      end
      toRemove.CanvasGroupComponent.GroupAlpha = 1
      self:applyStackMessageEntityLayout(toRemove, 30)
      toRemove:SetVisible(false)
      self._T.inUse[toRemove.Id] = false
    end
  end
  for i = 1, #self.activeMessages do
    local e = self.activeMessages[i]
    if ___MOD.isvalid(e) then
      self:applyStackMessageEntityLayout(e, 30 + (i - 1) * 30)
    end
  end
  local g = entity.BitmapFontRendererComponent
  g.text = message
  g.color = color
  g:drawText()
  entity.CanvasGroupComponent.GroupAlpha = 1
  entity:SetVisible(true)
  local prevTween = self._T[entity.Id]
  if prevTween then
    prevTween:Destroy()
    self._T[entity.Id] = nil
  end
  self._T.token[entity.Id] = (self._T.token[entity.Id] or 0) + 1
  local myToken = self._T.token[entity.Id]
  local canvas = entity.CanvasGroupComponent
  local tween = ___MOD._TweenLogic:PlayTween(1, 0, 4, ___MOD.EaseType.Linear, function(a)
    if not ___MOD.isvalid(entity) then
      return
    end
    canvas.GroupAlpha = a
  end)
  tween:SetOnEndCallback(function()
    if self._T.token[entity.Id] ~= myToken then
      return
    end
    for i = #self.activeMessages, 1, -1 do
      if self.activeMessages[i] == entity then
        ___MOD.table.remove(self.activeMessages, i)
        break
      end
    end
    self._T.inUse[entity.Id] = false
    if ___MOD.isvalid(entity) then
      entity:SetVisible(false)
      self:applyStackMessageEntityLayout(entity, 30)
      entity.CanvasGroupComponent.GroupAlpha = 1
    end
    for i = 1, #self.activeMessages do
      local e = self.activeMessages[i]
      if ___MOD.isvalid(e) then
        self:applyStackMessageEntityLayout(e, 30 + (i - 1) * 30)
      end
    end
  end)
  self._T[entity.Id] = tween
end

function StackMessageLogic.applyStackMessageEntityLayout(self, entity, positionY)
  if not ___MOD.isvalid(entity) or entity.UITransformComponent == nil then
    return
  end
  local transform = entity.UITransformComponent
  if ___MOD.Environment:IsMobilePlatform() then
    transform.AlignmentOption = ___MOD.AlignmentType.BottomLeft
    transform.Pivot = ___MOD.FastVector2(0, 1)
    transform.anchoredPosition = ___MOD.FastVector2(-10, positionY)
    return
  end
  transform.AlignmentOption = ___MOD.AlignmentType.BottomRight
  transform.Pivot = ___MOD.FastVector2(1, 1)
  transform.anchoredPosition = ___MOD.FastVector2(10, positionY)
end

function StackMessageLogic.OnBeginPlay(self)
  local parent = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/StackMessage")
  local emptyText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyEntity")
  for i = 1, 10 do
    local entity = ___MOD._SpawnService:SpawnByEntity(emptyText, "stackMessage" .. ___MOD.tostring(i), ___MOD.FastVector3(0, 0, 0), parent)
    entity.Visible = false
    entity:AddComponent(___MOD.BitmapFontRendererComponent)
    entity:AddComponent(___MOD.CanvasGroupComponent)
    entity:AddComponent(___MOD.TextGUIRendererComponent)
    self:applyStackMessageEntityLayout(entity, 30)
    local g = entity.BitmapFontRendererComponent
    g.font = ___MOD._BitmapFontType.Gulim9pt
    g.color = ___MOD.Color.FromHexCode("#FEFEFE")
    g.minimap = true
    g.isStackMessage = true
    self.messagePool[i] = entity
  end
end

function StackMessageLogic.OnMapLeave(self, player)
  if ___MOD._UserService.LocalPlayer ~= player then
    return
  end
  self:resetMessagePool()
end

function StackMessageLogic.resetMessagePool(self)
  self._T.inUse = self._T.inUse or {}
  self._T.token = self._T.token or {}
  self.activeMessages = self.activeMessages or {}
  for _, e in ___MOD.pairs(self.messagePool) do
    if ___MOD.isvalid(e) then
      local tw = self._T[e.Id]
      if tw then
        tw:Destroy()
        self._T[e.Id] = nil
      end
      self._T.inUse[e.Id] = false
    else
    end
  end
  for k in ___MOD.pairs(self._T.inUse) do
    self._T.inUse[k] = nil
  end
  self.activeMessages = {}
  for _, e in ___MOD.ipairs(self.messagePool) do
    if ___MOD.isvalid(e) then
      local tween = self._T[e.Id]
      if tween then
        tween:Destroy()
      end
      self:applyStackMessageEntityLayout(e, 30)
      e.CanvasGroupComponent.GroupAlpha = 0
      e:SetVisible(false)
    end
  end
end
