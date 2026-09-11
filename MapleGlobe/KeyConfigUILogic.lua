

function KeyConfigUILogic.HandleEntityEnabledInHierarchyChangedEvent(self, event)
  local EnabledInHierarchy = event.EnabledInHierarchy
  if EnabledInHierarchy then
    self.tempKeyConfig = {}
    for _, t in ___MOD.pairs(___MOD._UserService.LocalPlayer.KeyConfigComponent.keyConfig) do
      local key = t.key
      local type = t.type
      local id = t.id
      if key ~= nil and type ~= nil and id ~= nil then
        self.tempKeyConfig[key] = {
          key = key,
          type = type,
          id = id
        }
      end
    end
    if ___MOD.next(self.tempKeyConfig) == nil then
      for _, t in ___MOD.pairs(___MOD._ExtendedKeyboardKey.defaultKeyTable) do
        local key = t.key
        local type = t.type
        local id = t.id
        if key ~= nil and type ~= nil and id ~= nil then
          self.tempKeyConfig[key] = {
            key = key,
            type = type,
            id = id
          }
        end
      end
    end
  else
    self.tempKeyConfig = nil
  end
  self.isEnableUI = EnabledInHierarchy
  self.isChanged = false
end
