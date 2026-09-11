

function MagnifierLogic.clear(self)
  ___MOD._MousePointerLogic:clearCursorOverrideRUID()
  self.itemId = 0
  self.useSlot = 0
  self.enable = false
end

function MagnifierLogic.set(self, itemId, useSlot)
  if itemId // 10000 ~= 246 then
    return
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(self.RUID) then
    self.RUID = ___MOD.__RUIDManager:get("Item.Consume.0246.02460000.info.iconRaw")
  end
  if not ___MOD._UtilLogic:IsNilorEmptyString(self.RUID) then
    ___MOD._MousePointerLogic:setCursorOverrideRUID(self.RUID)
  end
  self.itemId = itemId
  self.useSlot = useSlot or 0
  self.enable = true
  local event = ___MOD.InventorySetTabEvent()
  event.tab = 1
  local user = ___MOD._UserService.LocalPlayer
  user:SendEvent(event)
end

function MagnifierLogic.showEffect(self, slot)
  local soundPath = "Game.img.GameIn"
  local soundRUID = ___MOD.__RUIDManager:get(soundPath)
  ___MOD._SoundService:PlaySound(soundRUID, 1)
  local inventory = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Inventory")
end
