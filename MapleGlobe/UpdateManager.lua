

function UpdateManager.insertUpdateCallback(self, callback, delayFrames)
  self.updateCallbackList[self.updateCallbackListNum + 1] = {
    callback = callback,
    frames = ___MOD.math.max(0, delayFrames or 0)
  }
  self.updateCallbackListNum = self.updateCallbackListNum + 1
end

function UpdateManager.insertUpdateEnable(self, entity)
  self.updateEnableList[self.updateEnableListNum + 1] = entity
  self.updateEnableListNum = self.updateEnableListNum + 1
end

function UpdateManager.insertUpdateInputText(self, entity, text)
  self.updateInputTextList[self.updateInputTextListNum + 1] = {entity = entity, text = text}
  self.updateInputTextListNum = self.updateInputTextListNum + 1
end

function UpdateManager.insertUpdateVisible(self, entity, visible)
  self.updataVisibleList[self.updateVisibleListNum + 1] = {entity = entity, visible = visible}
  self.updateVisibleListNum = self.updateVisibleListNum + 1
end

function UpdateManager.OnUpdate(self, delta)
  local visibleUpdateNum = self.updateVisibleListNum
  if 0 < visibleUpdateNum then
    for i = 1, visibleUpdateNum do
      local item = self.updataVisibleList[i]
      if ___MOD.isvalid(item.entity) then
        item.entity:SetVisible(item.visible)
      end
    end
    ___MOD.table.clear(self.updataVisibleList)
    self.updateVisibleListNum = 0
  end
  local enableUpdateNum = self.updateEnableListNum
  if 0 < enableUpdateNum then
    local list = self.updateEnableList
    for i = 1, enableUpdateNum do
      local item = list[i]
      if ___MOD.isvalid(item) then
        list[i]:SetEnable(true)
      end
    end
    ___MOD.table.clear(self.updateEnableList)
    self.updateEnableListNum = 0
  end
  local inputTextUpdateNum = self.updateInputTextListNum
  if 0 < inputTextUpdateNum then
    for i = 1, inputTextUpdateNum do
      local item = self.updateInputTextList[i]
      if ___MOD.isvalid(item.entity) then
        item.entity.TextGUIRendererComponent.Text = item.text
        item.entity.TextGUIRendererInputComponent.Text = item.text
      end
    end
    ___MOD.table.clear(self.updateInputTextList)
    self.updateInputTextListNum = 0
  end
  local callbackUpdateNum = self.updateCallbackListNum
  if 0 < callbackUpdateNum then
    local list = self.updateCallbackList
    local writeIndex = 1
    for i = 1, callbackUpdateNum do
      local item = list[i]
      if item ~= nil then
        if 0 >= (item.frames or 0) then
          local callback = item.callback
          if callback ~= nil then
            callback()
          end
        else
          item.frames = (item.frames or 0) - 1
          list[writeIndex] = item
          writeIndex = writeIndex + 1
        end
      end
    end
    for i = writeIndex, callbackUpdateNum do
      list[i] = nil
    end
    self.updateCallbackListNum = writeIndex - 1
  end
end

function UpdateManager.removeUpdateEnable(self, entity)
  if entity == nil then
    return
  end
  for i = 1, self.updateEnableListNum do
    if self.updateEnableList[i] == entity then
      self.updateEnableList[i] = nil
    end
  end
end
