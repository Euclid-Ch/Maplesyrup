

function DojoRaidUILogic.createFieldUI(self)
  local dojangUIGroup = self:getDojangUIGroup()
  if ___MOD._UtilLogic:IsNilorEmptyString(self.modelId) or not ___MOD.isvalid(dojangUIGroup) then
    return nil
  end
  if ___MOD.isvalid(self.ui) then
    self.ui:Destroy()
  end
  self.ui = nil
  local ui = ___MOD._SpawnService:SpawnByModelId(self.modelId, "DojoRaidUI", ___MOD.FastVector3.zero:Clone(), dojangUIGroup)
  self.ui = ui
  if ___MOD.isvalid(ui) and ___MOD.isvalid(ui.UITransformComponent) then
    ___MOD._UILogic:SetSiblingIndex(ui.UITransformComponent, 0)
  end
  return ui
end

function DojoRaidUILogic.getDojangUIGroup(self)
  if not ___MOD.isvalid(self.uiGroup) then
    self.uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/BackgroundUIGroup")
  end
  return self.uiGroup
end

function DojoRaidUILogic.hide(self)
  self:hideLocal()
end

function DojoRaidUILogic.hideLocal(self)
  local uiEntity = self.ui
  if ___MOD.isvalid(uiEntity) then
    if ___MOD.isvalid(uiEntity.DojoRaidUIComponent) then
      uiEntity.DojoRaidUIComponent:hide()
    else
      uiEntity:SetEnable(false)
    end
  end
end

function DojoRaidUILogic.OnBeginPlay(self)
  self.modelId = ___MOD._EntryService:GetModelIdByName("Model_DojoRaidUI")
  self.uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/BackgroundUIGroup")
end

function DojoRaidUILogic.setEnergy(self, ratio)
  ratio = ___MOD.math.max(0, ___MOD.math.min(1, ratio))
  self.energyRatio = ratio
  local uiEntity = self.ui
  if ___MOD.isvalid(uiEntity) and ___MOD.isvalid(uiEntity.DojoRaidUIComponent) then
    uiEntity.DojoRaidUIComponent:setEnergy(ratio)
  end
end

function DojoRaidUILogic.setRemainingPotion(self, value)
  self.remainingPotion = ___MOD.math.max(0, value)
  if ___MOD.isvalid(self.ui) and ___MOD.isvalid(self.ui.DojoRaidUIComponent) then
    self.ui.DojoRaidUIComponent:setRemainCount("remainPotion", self.remainingPotion)
  end
end

function DojoRaidUILogic.setRemainingWheel(self, value)
  self.remainingWheel = ___MOD.math.max(0, value)
  if ___MOD.isvalid(self.ui) and ___MOD.isvalid(self.ui.DojoRaidUIComponent) then
    self.ui.DojoRaidUIComponent:setRemainCount("remainWheel", self.remainingWheel)
  end
end

function DojoRaidUILogic.setTime(self, seconds)
  self.clockSeconds = seconds
  local uiEntity = self.ui
  if ___MOD.isvalid(uiEntity) and ___MOD.isvalid(uiEntity.DojoRaidUIComponent) then
    uiEntity.DojoRaidUIComponent:setTime(seconds)
  end
end

function DojoRaidUILogic.setTimeRemain(self, seconds)
  self.clockSeconds = seconds
  local uiEntity = self.ui
  if ___MOD.isvalid(uiEntity) and ___MOD.isvalid(uiEntity.DojoRaidUIComponent) then
    uiEntity.DojoRaidUIComponent:setTimeRemain(seconds)
  end
end

function DojoRaidUILogic.show(self, monsterKey)
  local uiEntity = self.ui
  if not ___MOD.isvalid(uiEntity) then
    local dojangUIGroup = self:getDojangUIGroup()
    if ___MOD._UtilLogic:IsNilorEmptyString(self.modelId) or not ___MOD.isvalid(dojangUIGroup) then
      return
    end
    uiEntity = ___MOD._SpawnService:SpawnByModelId(self.modelId, "DojoRaidUI", ___MOD.FastVector3.zero:Clone(), dojangUIGroup)
    self.ui = uiEntity
    if ___MOD.isvalid(uiEntity) and ___MOD.isvalid(uiEntity.UITransformComponent) then
      ___MOD._UILogic:SetSiblingIndex(uiEntity.UITransformComponent, 0)
    end
  end
  if ___MOD.isvalid(uiEntity) then
    uiEntity:SetEnable(true)
    if ___MOD.isvalid(uiEntity.DojoRaidUIComponent) then
      uiEntity.DojoRaidUIComponent:show(monsterKey)
    else
    end
  end
end
