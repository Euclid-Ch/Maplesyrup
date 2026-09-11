

function TooltipManager.showEquipTooltip(self, itemId, ieqp, subItemID, subEqp)
  local mainItemId, mainEqp = itemId, ieqp
  local subItemIdDraw, subEqpDraw = subItemID, subEqp
  local subTooltipToShow
  if not ___MOD.isvalid(self.equipTooltip) then
    local modelId = ___MOD._EntryService:GetModelIdByName("Model_EquipTooltip")
    local tempGroup = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
    self.equipTooltip = ___MOD._SpawnService:SpawnByModelId(modelId, "EquipTooltip", ___MOD.FastVector3.zero:Clone(), tempGroup)
  end
  self.equipTooltip.EquipTooltipComponent:draw(mainItemId, mainEqp)
  ___MOD._UpdateManager:insertUpdateVisible(self.equipTooltip, true)
  if subItemIdDraw and 0 < subItemIdDraw then
    if not ___MOD.isvalid(self.subEquipTooltip) then
      local modelId = ___MOD._EntryService:GetModelIdByName("Model_EquipTooltip")
      local tempGroup = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
      self.subEquipTooltip = ___MOD._SpawnService:SpawnByModelId(modelId, "SubEquipTooltip", ___MOD.FastVector3.zero:Clone(), tempGroup)
    end
    self.subEquipTooltip.EquipTooltipComponent:draw(subItemIdDraw, subEqpDraw)
    ___MOD._UpdateManager:insertUpdateVisible(self.subEquipTooltip, true)
    subTooltipToShow = self.subEquipTooltip
  elseif ___MOD.isvalid(self.subEquipTooltip) then
    ___MOD._UpdateManager:insertUpdateVisible(self.subEquipTooltip, false)
  end
  return self.equipTooltip, subTooltipToShow
end
