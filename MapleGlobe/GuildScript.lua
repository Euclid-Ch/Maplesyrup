

function GuildScript.applyMakeMarkComboBoxSkin(self, comboBox, comboBoxType)
  if not ___MOD.isvalid(comboBox) then
    return
  end
  local skinType = ___MOD._UtilLogic:IsNilorEmptyString(comboBoxType) and "ComboBox3" or comboBoxType
  local basePath = ___MOD.string.format("UI.Basic.%s", skinType)
  for i = 0, 2 do
    local part = comboBox:GetChildByName(___MOD.tostring(i))
    if ___MOD.isvalid(part) and ___MOD.isvalid(part.SpriteGUIRendererComponent) then
      local ruid = ___MOD.__RUIDManager:get(___MOD.string.format("%s.normal.%d", basePath, i))
      if ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
        ruid = ___MOD.__RUIDManager:get(___MOD.string.format("%s.%d", basePath, i))
      end
      if not ___MOD._UtilLogic:IsNilorEmptyString(ruid) then
        part.SpriteGUIRendererComponent.ImageRUID = ruid
      end
    end
  end
  local buttonPart = comboBox:GetChildByName("2")
  if not ___MOD.isvalid(buttonPart) then
    return
  end
  if ___MOD.isvalid(buttonPart.ButtonComponent) then
    local ruid = buttonPart.ButtonComponent.ImageRUIDs
    ruid.DisabledSprite = ___MOD.__RUIDManager:get(___MOD.string.format("%s.disabled.2", basePath))
    ruid.HighlightedSprite = ___MOD.__RUIDManager:get(___MOD.string.format("%s.mouseOver.2", basePath))
    ruid.PressedSprite = ___MOD.__RUIDManager:get(___MOD.string.format("%s.pressed.2", basePath))
    ruid.SelectedSprite = ___MOD.__RUIDManager:get(___MOD.string.format("%s.normal.2", basePath))
  end
  if ___MOD.isvalid(buttonPart.UIButtonComponent) then
    local ruid = buttonPart.UIButtonComponent.ImageRUIDs
    ruid.DisabledSprite = ___MOD.__RUIDManager:get(___MOD.string.format("%s.disabled.2", basePath))
    ruid.HighlightedSprite = ___MOD.__RUIDManager:get(___MOD.string.format("%s.mouseOver.2", basePath))
    ruid.PressedSprite = ___MOD.__RUIDManager:get(___MOD.string.format("%s.pressed.2", basePath))
    ruid.SelectedSprite = ___MOD.__RUIDManager:get(___MOD.string.format("%s.normal.2", basePath))
  end
end

function GuildScript.applyMakeMarkComboBoxTransform(self, comboBox)
  if not ___MOD.isvalid(comboBox) or not ___MOD.isvalid(comboBox.UITransformComponent) then
    return
  end
  comboBox.UITransformComponent.RectSize = ___MOD.FastVector2(130, 34)
  comboBox.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-97, 140)
end

function GuildScript.applyMakeMarkPreviewMarkNativeSize(self)
  return
end

function GuildScript.bindMakeMarkCategoryComboBox(self, comboBox)
  if not ___MOD.isvalid(comboBox) then
    return
  end
  if self._T.makeMarkCategoryComboBound then
    return
  end
  self:bindMakeMarkCategoryListItems(comboBox)
  ___MOD._UpdateManager:insertUpdateCallback(function()
    self:bindMakeMarkCategoryListItems(comboBox)
  end, 1)
  self._T.makeMarkCategoryComboBound = true
end

function GuildScript.bindMakeMarkCategoryListItems(self, comboBox)
  if not ___MOD.isvalid(comboBox) then
    return
  end
  local listBox = comboBox:GetChildByName("listBox")
  if not ___MOD.isvalid(listBox) then
    return
  end
  if self._T.makeMarkCategoryBoundItems == nil then
    self._T.makeMarkCategoryBoundItems = {}
  end
  local boundItems = self._T.makeMarkCategoryBoundItems
  for _, item in ___MOD.pairs(listBox.Children) do
    local key = ___MOD.tostring(item)
    if ___MOD.isvalid(item) and not boundItems[key] then
      boundItems[key] = true
      item:ConnectEvent(___MOD.ButtonClickEvent, function()
        local text = ""
        if ___MOD.isvalid(item.TextGUIRendererComponent) then
          text = ___MOD.tostring(item.TextGUIRendererComponent.Text or "")
        end
        self:onMakeMarkCategorySelected(text)
      end)
    end
  end
end

function GuildScript.bindMakeMarkSelectButton(self, path, kind, direction)
  local button = ___MOD._EntityService:GetEntityByPath(path)
  if not ___MOD.isvalid(button) then
    return
  end
  button:ConnectEvent(___MOD.ButtonClickEvent, function()
    self:onMakeMarkSelectButton(kind, direction)
  end)
end

function GuildScript.buildMakeMarkCodeList(self, category)
  local list = {}
  if ___MOD._GuildManager ~= nil and ___MOD.type(___MOD._GuildManager.guildMarkMarkByCategory) == "table" then
    local categoryCache = ___MOD._GuildManager.guildMarkMarkByCategory[category]
    if ___MOD.type(categoryCache) == "table" then
      for codeText, _ in ___MOD.pairs(categoryCache) do
        local code = ___MOD.tonumber(codeText)
        if code ~= nil then
          list[#list + 1] = code
        end
      end
    end
  end
  ___MOD.table.sort(list)
  if 0 < #list then
    return list
  end
  local startCode = self:getDefaultMakeMarkCode(category)
  local endCode = startCode
  if category == "Animal" then
    endCode = 2020
  elseif category == "Plant" then
    endCode = 3006
  end
  for code = startCode, endCode do
    list[#list + 1] = code
  end
  return list
end

function GuildScript.cacheScriptFunc(self)

end

function GuildScript.cycleMakeMarkValue(self, value, direction, minValue, maxValue)
  local nextValue = (___MOD.tonumber(value) or minValue) + direction
  if minValue > nextValue then
    return maxValue
  end
  if maxValue < nextValue then
    return minValue
  end
  return nextValue
end

function GuildScript.ensureMakeMarkActionButtons(self)
  if self._T.makeMarkActionButtonsBound then
    return
  end
  local agree = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark/backgrnd/BtAgree")
  if ___MOD.isvalid(agree) then
    agree:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickMakeMarkAgree()
    end)
  end
  local disagree = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark/backgrnd/BtDisagree")
  if ___MOD.isvalid(disagree) then
    disagree:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickMakeMarkDisagree()
    end)
  end
  self._T.makeMarkActionButtonsBound = true
end

function GuildScript.ensureMakeMarkCategoryComboBox(self, parent, comboBoxType)
  if not ___MOD.isvalid(parent) then
    return
  end
  local skinType = ___MOD._UtilLogic:IsNilorEmptyString(comboBoxType) and "ComboBox3" or comboBoxType
  local comboBox = parent:GetChildByName("MakeMarkCategoryComboBox")
  if ___MOD.isvalid(comboBox) then
    comboBox:SetEnable(true)
    self:applyMakeMarkComboBoxTransform(comboBox)
    self:applyMakeMarkComboBoxSkin(comboBox, skinType)
    self:setupMakeMarkCategoryComboBoxItems(comboBox)
    self:bindMakeMarkCategoryComboBox(comboBox)
    self:setMakeMarkComboBoxTitle(comboBox, "동물")
    return
  end
  local comboBoxModel = ___MOD._EntryService:GetModelIdByName("Model_ComboBox")
  comboBox = ___MOD._SpawnService:SpawnByModelId(comboBoxModel, "MakeMarkCategoryComboBox", ___MOD.FastVector3.zero:Clone(), parent)
  if not ___MOD.isvalid(comboBox) then
    return
  end
  self:applyMakeMarkComboBoxTransform(comboBox)
  if ___MOD.isvalid(comboBox.ComboBoxComponent) then
    comboBox.ComboBoxComponent:canComboBoxTextEdit(false)
  end
  self:applyMakeMarkComboBoxSkin(comboBox, skinType)
  self:setupMakeMarkCategoryComboBoxItems(comboBox)
  self:bindMakeMarkCategoryComboBox(comboBox)
  self:setMakeMarkComboBoxTitle(comboBox, "동물")
end

function GuildScript.ensureMakeMarkSelectionButtons(self)
  if self._T.makeMarkSelectionButtonsBound then
    return
  end
  self:bindMakeMarkSelectButton("/ui/UIGroup/MakeMark/backgrnd/selectBack/BtLeft", "BackGround", -1)
  self:bindMakeMarkSelectButton("/ui/UIGroup/MakeMark/backgrnd/selectBack/BtRight", "BackGround", 1)
  self:bindMakeMarkSelectButton("/ui/UIGroup/MakeMark/backgrnd/selectBackColor/BtLeft", "BackGroundColor", -1)
  self:bindMakeMarkSelectButton("/ui/UIGroup/MakeMark/backgrnd/selectBackColor/BtRight", "BackGroundColor", 1)
  self:bindMakeMarkSelectButton("/ui/UIGroup/MakeMark/backgrnd/selectMark/BtLeft", "Mark", -1)
  self:bindMakeMarkSelectButton("/ui/UIGroup/MakeMark/backgrnd/selectMark/BtRight", "Mark", 1)
  self:bindMakeMarkSelectButton("/ui/UIGroup/MakeMark/backgrnd/selectMarkColor/BtLeft", "MarkColor", -1)
  self:bindMakeMarkSelectButton("/ui/UIGroup/MakeMark/backgrnd/selectMarkColor/BtRight", "MarkColor", 1)
  self._T.makeMarkSelectionButtonsBound = true
end

function GuildScript.formatMakeMarkCode(self, code)
  return ___MOD.string.format("%08d", ___MOD.tonumber(code) or 0)
end

function GuildScript.getDefaultMakeMarkCode(self, category)
  if category == "Plant" then
    return 3000
  elseif category == "Pattern" then
    return 4000
  elseif category == "Letter" then
    return 5000
  elseif category == "Etc" then
    return 6000
  end
  return 2000
end

function GuildScript.getFirstMakeMarkCode(self, category)
  local list = self:getMakeMarkCodeList(category)
  if 0 < #list then
    return list[1]
  end
  return self:getDefaultMakeMarkCode(category)
end

function GuildScript.getLocalMakeMarkGuildId(self)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil or not ___MOD.isvalid(user.Player) then
    return 0
  end
  local guildId = ___MOD.tonumber(user.Player.GuildId or 0) or 0
  if 0 < guildId then
    return guildId
  end
  local guildData = user.Player.guildData
  if guildData ~= nil then
    return ___MOD.tonumber(guildData.GuildID or guildData.guildID or guildData.guildId or 0) or 0
  end
  return 0
end

function GuildScript.getMakeMarkBackgrndAnimation(self)
  local data = ___MOD._WzUtils:ParseGenericWzCollectionWZ("UI_wz", "UIWindow.img")
  if ___MOD.type(data) ~= "table" then
    return nil
  end
  local animPath = ___MOD.string.gsub("UserList.Guild.MakeMark.backgrnd", "%.", "/")
  local backgrnd = ___MOD._WzUtils:getWzTbl(data, animPath)
  if ___MOD.type(backgrnd) ~= "table" then
    return nil
  end
  return ___MOD._WzUtils:parseAnimation(backgrnd)
end

function GuildScript.getMakeMarkCategoryByDisplayName(self, displayName)
  if displayName == "식물" then
    return "Plant"
  elseif displayName == "문양" then
    return "Pattern"
  elseif displayName == "문자" then
    return "Letter"
  elseif displayName == "기타" then
    return "Etc"
  end
  return "Animal"
end

function GuildScript.getMakeMarkCategoryByParam(self, param)
  if param == 2 then
    return "Plant"
  elseif param == 3 then
    return "Pattern"
  elseif param == 4 then
    return "Letter"
  elseif param == 5 then
    return "Etc"
  end
  return "Animal"
end

function GuildScript.getMakeMarkCodeList(self, category)
  local listByCategory = self._T.makeMarkCodeListByCategory
  if ___MOD.type(listByCategory) == "table" and ___MOD.type(listByCategory[category]) == "table" then
    return listByCategory[category]
  end
  return self:buildMakeMarkCodeList(category)
end

function GuildScript.getValidMarkColor(self, color)
  local markCode = self:formatMakeMarkCode(self.makeMarkCode)
  local markRuid = ___MOD.string.format("UI.GuildMark.Mark.%s.%s.%d", self.makeMarkCategory, markCode, color)
  if not ___MOD._UtilLogic:IsNilorEmptyString(___MOD.__RUIDManager:get(markRuid)) then
    return color
  end
  return 1
end

function GuildScript.guild_mark(self, player, udc)

end

function GuildScript.guild_mark_(self, player, udc)

end

function GuildScript.guild_proc(self, player, udc)

end

function GuildScript.guild_proc_(self, player, udc)

end

function GuildScript.guild_union(self, player, udc)

end

function GuildScript.moveMakeMarkCode(self, category, currentCode, direction)
  local list = self:getMakeMarkCodeList(category)
  if #list <= 0 then
    return currentCode
  end
  local currentIndex = 1
  for i = 1, #list do
    if list[i] == currentCode then
      currentIndex = i
      break
    end
  end
  local nextIndex = currentIndex + direction
  if nextIndex < 1 then
    nextIndex = #list
  elseif nextIndex > #list then
    nextIndex = 1
  end
  return list[nextIndex]
end

function GuildScript.onClickMakeMarkAgree(self)
  if ___MOD._UINotice == nil then
    return
  end
  ___MOD._UINotice:showYesNoUI("길드 마크로 저장하시겠습니까?", function()
    self:requestMakeMarkSave()
  end, nil)
end

function GuildScript.onClickMakeMarkDisagree(self)
  local makeMark = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark")
  if ___MOD.isvalid(makeMark) then
    makeMark:SetEnable(false)
  end
end

function GuildScript.onMakeMarkCategorySelected(self, entryName)
  local category = self:getMakeMarkCategoryByDisplayName(entryName)
  self.makeMarkCategory = category
  self.makeMarkCode = self:getFirstMakeMarkCode(category)
  self.makeMarkColor = self:getValidMarkColor(self.makeMarkColor)
  local comboBox = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark/backgrnd/MakeMarkCategoryComboBox")
  if ___MOD.isvalid(comboBox) then
    self:setMakeMarkComboBoxTitle(comboBox, entryName)
  end
  self:updateMakeMarkPreview()
end

function GuildScript.onMakeMarkSelectButton(self, kind, direction)
  if kind == "BackGround" then
    self.makeMarkBackGroundCode = self:cycleMakeMarkValue(self.makeMarkBackGroundCode, direction, 1000, 1030)
  elseif kind == "BackGroundColor" then
    self.makeMarkBackGroundColor = self:cycleMakeMarkValue(self.makeMarkBackGroundColor, direction, 1, 16)
  elseif kind == "Mark" then
    self.makeMarkCode = self:moveMakeMarkCode(self.makeMarkCategory, self.makeMarkCode, direction)
    self.makeMarkColor = self:getValidMarkColor(self.makeMarkColor)
  elseif kind == "MarkColor" then
    local nextColor = self:cycleMakeMarkValue(self.makeMarkColor, direction, 1, 16)
    self.makeMarkColor = self:getValidMarkColor(nextColor)
  end
  self:updateMakeMarkPreview()
end

function GuildScript.openMakeMarkUI(self)
  local makeMark = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark")
  if not ___MOD.isvalid(makeMark) then
    return
  end
  makeMark.Enable = true
  self._T.makeMarkOpenSerial = (___MOD.tonumber(self._T.makeMarkOpenSerial) or 0) + 1
  local openSerial = self._T.makeMarkOpenSerial
  self:resetMakeMarkSelection()
  self:preloadMakeMarkResources()
  local backgrnd = makeMark:GetChildByName("backgrnd")
  if ___MOD.isvalid(backgrnd) then
    if ___MOD.isvalid(backgrnd.UITransformComponent) then
      backgrnd.UITransformComponent.anchoredPosition = ___MOD.Vector2(0, 0)
    end
    backgrnd:SetEnable(false)
  end
  local preview = makeMark:GetChildByName("MakeMarkPreview")
  if not ___MOD.isvalid(preview) then
    preview = ___MOD._SpawnService:SpawnByModelId("model://6e36bd76-88aa-4315-b583-986d769f06b2", "MakeMarkPreview", ___MOD.FastVector3.zero:Clone(), makeMark)
  end
  if not ___MOD.isvalid(preview) then
    return
  end
  preview.Enable = true
  preview:SetEnable(true)
  preview:SetVisible(true)
  if not ___MOD.isvalid(preview.SpriteGUIRendererComponent) then
    preview:AddComponent(___MOD.SpriteGUIRendererComponent)
  end
  if ___MOD.isvalid(preview.SpriteGUIRendererComponent) then
    preview.SpriteGUIRendererComponent.Enable = true
  end
  if ___MOD.isvalid(preview.SpriteRendererComponent) then
    preview.SpriteRendererComponent.Enable = false
  end
  local anim = preview.AnimationSpriteComponent
  if not ___MOD.isvalid(anim) then
    preview:AddComponent(___MOD.AnimationSpriteComponent)
    anim = preview.AnimationSpriteComponent
  end
  if not ___MOD.isvalid(anim) then
    return
  end
  local state = self:getMakeMarkBackgrndAnimation()
  if state == nil then
    return
  end
  anim.loop = false
  anim.disappearWhenAnimationOnceEnd = false
  anim.transparentWhenAnimationOnceEnd = false
  anim.firstAnimationEnded = false
  anim:setWzSprite(state, false)
  anim:SetPaused(false)
  ___MOD._TimerService:SetTimerOnce(function()
    if self._T.makeMarkOpenSerial == openSerial then
      self:showMakeMarkBackgrnd()
    end
  end, 2.1)
end

function GuildScript.preloadMakeMarkResources(self)
  if ___MOD._GuildManager ~= nil then
    ___MOD._GuildManager:preloadGuildMarkResources()
  end
end

function GuildScript.prepareMakeMarkCodeCache(self)
  local listByCategory = {}
  local categories = {
    "Animal",
    "Plant",
    "Pattern",
    "Letter",
    "Etc"
  }
  for _, category in ___MOD.ipairs(categories) do
    listByCategory[category] = self:buildMakeMarkCodeList(category)
  end
  self._T.makeMarkCodeListByCategory = listByCategory
end

function GuildScript.requestMakeMarkSave(self)
  local user = ___MOD._UserService.LocalPlayer
  if user == nil then
    return
  end
  local inventory = user.CInventoryComponent
  local meso = 0
  if ___MOD.isvalid(inventory) then
    meso = ___MOD.tonumber(inventory.Meso or 0) or 0
  end
  if meso < self.GUILD_MARK_CHANGE_COST then
    if ___MOD._UINotice ~= nil then
      ___MOD._UINotice:showAlertUI("길드마크를 변경할 메소가\r\n부족합니다.")
    end
    return
  end
  local guildId = self:getLocalMakeMarkGuildId()
  ___MOD._GuildManager:requestGuildMarkChange(guildId, self.makeMarkBackGroundCode, self.makeMarkBackGroundColor, self.makeMarkCategory, self.makeMarkCode, self.makeMarkColor)
end

function GuildScript.resetMakeMarkSelection(self)
  self.makeMarkBackGroundCode = 1000
  self.makeMarkBackGroundColor = 1
  self.makeMarkCategory = "Animal"
  self:prepareMakeMarkCodeCache()
  self.makeMarkCode = self:getFirstMakeMarkCode("Animal")
  self.makeMarkColor = 1
end

function GuildScript.resizeMakeMarkPreviewMark(self)
  if ___MOD._GuildManager == nil then
    return
  end
  local markCode = self:formatMakeMarkCode(self.makeMarkCode)
  local size = ___MOD._GuildManager:getGuildMarkMarkSize(self.makeMarkCategory, markCode, self.makeMarkColor)
  if ___MOD.type(size) ~= "table" then
    return
  end
  local width = ___MOD.tonumber(size.width) or 0
  local height = ___MOD.tonumber(size.height) or 0
  if width <= 0 or height <= 0 then
    return
  end
  local mark = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark/backgrnd/GuildMark/Mark")
  if not ___MOD.isvalid(mark) or not ___MOD.isvalid(mark.UITransformComponent) then
    return
  end
  mark.UITransformComponent.RectSize = ___MOD.FastVector2(width * 2, height * 2)
end

function GuildScript.setMakeMarkComboBoxTitle(self, comboBox, text)
  if not ___MOD.isvalid(comboBox) then
    return
  end
  local title = comboBox:GetChildByName("1")
  if not ___MOD.isvalid(title) then
    title = comboBox:GetChildByName("Title")
  end
  if not ___MOD.isvalid(title) then
    return
  end
  if ___MOD.isvalid(title.TextGUIRendererComponent) then
    title.TextGUIRendererComponent.Text = text
  end
  if ___MOD.isvalid(title.TextGUIRendererInputComponent) then
    title.TextGUIRendererInputComponent.Text = text
    title.TextGUIRendererInputComponent.AutoClear = false
  end
  if ___MOD.isvalid(title.BitmapFontRendererComponent) then
    title.BitmapFontRendererComponent.text = text
    title.BitmapFontRendererComponent:drawText()
  end
end

function GuildScript.setupMakeMarkCategoryComboBoxItems(self, comboBox)
  if not ___MOD.isvalid(comboBox) then
    return
  end
  if not ___MOD.isvalid(comboBox.ComboBoxComponent) then
    return
  end
  comboBox.ComboBoxComponent:canComboBoxTextEdit(false)
  if self._T.makeMarkCategoryComboListInitialized then
    return
  end
  local listBox = comboBox.ComboBoxComponent:getListBoxComponent()
  if ___MOD.isvalid(listBox) then
    listBox:setItems({
      "동물",
      "식물",
      "문양",
      "문자",
      "기타"
    })
    self._T.makeMarkCategoryComboListInitialized = true
  end
end

function GuildScript.showMakeMarkBackgrnd(self)
  local makeMark = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark")
  if not ___MOD.isvalid(makeMark) then
    return
  end
  local preview = makeMark:GetChildByName("MakeMarkPreview")
  if ___MOD.isvalid(preview) then
    preview:SetEnable(false)
  end
  local backgrnd = makeMark:GetChildByName("backgrnd")
  if not ___MOD.isvalid(backgrnd) then
    return
  end
  backgrnd:SetEnable(true)
  self:ensureMakeMarkCategoryComboBox(backgrnd, "ComboBox3")
  self:preloadMakeMarkResources()
  local comboBox = backgrnd:GetChildByName("MakeMarkCategoryComboBox")
  if ___MOD.isvalid(comboBox) then
    self:setMakeMarkComboBoxTitle(comboBox, "동물")
  end
  self:ensureMakeMarkSelectionButtons()
  self:ensureMakeMarkActionButtons()
  self:updateMakeMarkPreview()
end

function GuildScript.updateMakeMarkPreview(self)
  local guildMark = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MakeMark/backgrnd/GuildMark")
  if not ___MOD.isvalid(guildMark) then
    return
  end
  local backGroundCode = self:formatMakeMarkCode(self.makeMarkBackGroundCode)
  local markCode = self:formatMakeMarkCode(self.makeMarkCode)
  local backGroundRuid = ___MOD.string.format("UI.GuildMark.BackGround.%s.%d", backGroundCode, self.makeMarkBackGroundColor)
  local markRuid = ___MOD.string.format("UI.GuildMark.Mark.%s.%s.%d", self.makeMarkCategory, markCode, self.makeMarkColor)
  if ___MOD._GuildManager ~= nil then
    ___MOD._GuildManager:applyGuildMarkSprite(guildMark, "BackGround", backGroundRuid)
    ___MOD._GuildManager:applyGuildMarkSprite(guildMark, "Mark", markRuid)
  end
  self:resizeMakeMarkPreviewMark()
end
