

function ItemPotentialOutlineLogic.applyPotentialOutline(self, slotRoot, equipInfo, isEquip)
  local outline = self:ensurePotentialOutline(slotRoot)
  if not ___MOD.isvalid(outline) then
    return
  end
  local potential = 0
  if isEquip == true and equipInfo ~= nil then
    potential = ___MOD.tonumber(equipInfo.potential or equipInfo.p) or 0
  end
  local showPotential = 0 < potential
  if showPotential and outline.SpriteGUIRendererComponent ~= nil then
    outline.SpriteGUIRendererComponent.OutlineColor = self:getPotentialOutlineColor(potential)
  end
  outline:SetEnable(showPotential)
  outline:SetVisible(showPotential)
end

function ItemPotentialOutlineLogic.clearPotentialOutline(self, slotRoot)
  if not ___MOD.isvalid(slotRoot) then
    return
  end
  local outline = slotRoot:GetChildByName("potential")
  if not ___MOD.isvalid(outline) then
    return
  end
  outline:SetEnable(false)
  outline:SetVisible(false)
end

function ItemPotentialOutlineLogic.ensurePotentialOutline(self, slotRoot)
  if not ___MOD.isvalid(slotRoot) then
    return nil
  end
  local outline = slotRoot:GetChildByName("potential")
  if outline ~= nil then
    self:fitPotentialOutlineToSlot(slotRoot, outline)
    return outline
  end
  local template = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")
  if not ___MOD.isvalid(template) then
    template = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup/EmptySprite")
  end
  if not ___MOD.isvalid(template) then
    return nil
  end
  outline = ___MOD._SpawnService:SpawnByEntity(template, "potential", ___MOD.FastVector3.zero:Clone(), slotRoot)
  if outline == nil then
    return nil
  end
  if outline.UITransformComponent ~= nil then
    outline.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Center
    outline.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    outline.UITransformComponent.OffsetMax = ___MOD.FastVector2.zero:Clone()
    outline.UITransformComponent.OffsetMin = ___MOD.FastVector2.zero:Clone()
  end
  if outline.SpriteGUIRendererComponent ~= nil then
    outline.SpriteGUIRendererComponent.Outline = true
    outline.SpriteGUIRendererComponent.OutlineWidth = 2
    outline.SpriteGUIRendererComponent.Color.a = 0
    outline.SpriteGUIRendererComponent.RaycastTarget = false
  end
  outline:SetEnable(false)
  outline:SetVisible(false)
  self:fitPotentialOutlineToSlot(slotRoot, outline)
  return outline
end

function ItemPotentialOutlineLogic.fitPotentialOutlineToSlot(self, slotRoot, outline)
  if not (___MOD.isvalid(slotRoot) and ___MOD.isvalid(outline)) or outline.UITransformComponent == nil then
    return
  end
  if slotRoot.UITransformComponent == nil then
    return
  end
  local width = 68
  local height = 68
  outline.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Center
  outline.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  outline.UITransformComponent.RectSize = ___MOD.FastVector2(width, height)
end

function ItemPotentialOutlineLogic.getPotentialOutlineColor(self, potential)
  if self._T.potentialColor == nil then
    self._T.potentialColor = {}
    self._T.potentialColor[17] = ___MOD.Color.FromHexCode("#DC116D")
    self._T.potentialColor[18] = ___MOD.Color.FromHexCode("#519EEA")
    self._T.potentialColor[19] = ___MOD.Color.FromHexCode("#AF61E1")
    self._T.potentialColor[20] = ___MOD.Color.FromHexCode("#E4BA15")
  end
  return self._T.potentialColor[potential] or ___MOD.FastColor.clear
end
