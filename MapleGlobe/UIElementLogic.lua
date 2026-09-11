

function UIElementLogic.cloneMoveToMouse(self)
  if ___MOD.isvalid(self.cloneEntity) then
    local toPositon = ___MOD._UIUtilLogic:getCursorUIPosition()
    self.cloneEntity.UITransformComponent.anchoredPosition = toPositon
  end
end

function UIElementLogic.disableClone(self)
  if self.enable then
    local clickedEntity = self.clickedEntity
    ___MOD._InputService:DisconnectEvent(___MOD.MouseMoveEvent, self.mouseEvent)
    self.cloneEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(10000, 10000)
    if ___MOD.isvalid(clickedEntity) and clickedEntity.UIElementClickInteractionComponent ~= nil then
      clickedEntity.UIElementClickInteractionComponent.isClicked = false
    end
    self.clickedEntity = nil
    self.beforeType = 0
    self.beforeID = 0
    self.beforeSlotPos = 0
    self.beforeSlotType = 0
    self.beforeSlotItemID = 0
    self._T.dragSkillId = 0
    self.blankSpace.SpriteGUIRendererComponent.RaycastTarget = false
    self.mouseEvent = nil
    self.enable = false
    self.lastDisableTime = ___MOD._UtilLogic.ElapsedSeconds
    self.cloneEntity:SetEnable(false)
    ___MOD._MousePointerLogic:onUIElementReleased()
  end
end

function UIElementLogic.enableClone(self, clickedEntity, RUID, size)
  self.clickedEntity = clickedEntity
  local dragSkillId = 0
  if ___MOD.isvalid(clickedEntity) and clickedEntity.SkillUISlotItemComponent ~= nil then
    dragSkillId = ___MOD.tonumber(clickedEntity.SkillUISlotItemComponent.skillId) or 0
  end
  if ___MOD.isvalid(clickedEntity) and ___MOD.isvalid(clickedEntity.Parent) and clickedEntity.Parent.SkillUISlotItemComponent ~= nil then
    dragSkillId = ___MOD.tonumber(clickedEntity.Parent.SkillUISlotItemComponent.skillId) or 0
  end
  self._T.dragSkillId = dragSkillId
  if ___MOD.isvalid(clickedEntity.Parent.KeyConfigSlotItemComponent) then
    self.beforeID = clickedEntity.Parent.KeyConfigSlotItemComponent.id
    self.beforeType = clickedEntity.Parent.KeyConfigSlotItemComponent.type
  end
  self.blankSpace.SpriteGUIRendererComponent.RaycastTarget = true
  self.lastClick = ___MOD._UtilLogic.ElapsedSeconds
  local clone = self.cloneEntity
  clone.SpriteGUIRendererComponent.ImageRUID = RUID
  clone.UITransformComponent.RectSize = size
  clone.UITransformComponent.anchoredPosition = ___MOD._UIUtilLogic:getCursorUIPosition()
  self.mouseEvent = ___MOD._InputService:ConnectEvent(___MOD.MouseMoveEvent, self.cloneMoveToMouse)
  self.enable = true
  ___MOD._UpdateManager:insertUpdateEnable(clone)
end

function UIElementLogic.OnBeginPlay(self)
  self.blankSpace = ___MOD._EntityService:GetEntity("1bb1e574-962a-413a-a0c9-0bad777dde36")
  self.cloneEntity = ___MOD._EntityService:GetEntity("6aae89a4-4f17-4b76-98d3-95aa5db3d41f")
end
