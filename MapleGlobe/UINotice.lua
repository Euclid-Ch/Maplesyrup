

function UINotice.createNotice(self, type, message, msgAlignment, msgOutline, addMsgPad, contentType, defInputStr, withComboBox, canComboBoxTextEdit, listBoxItems, disableCancelBtn, withSound, callbackOKBtn, forceMSWPosY)
  local user = ___MOD._UserService.LocalPlayer
  local skipInputAutoFocus = ___MOD.isvalid(user) and user.Player ~= nil and user.Player:isMobileUIPlatform()
  if ___MOD.isvalid(user) and user.KeyDownComponent ~= nil and user.KeyDownComponent.onKeyDown then
    ___MOD._PlayerSkillLogic:cancelActiveKeyDownForNotice(user)
  end
  local noticeEntity = self:spawnNotice(type, disableCancelBtn)
  local isInputNotice = type == ___MOD._UINoticeType.Input or type == ___MOD._UINoticeType.Input_line
  local notice = noticeEntity.UINoticeComponent
  local btOK = notice.btOK
  local textEntity = notice.text
  local text = textEntity.BitmapFontRendererComponent
  if ___MOD.isvalid(text) then
    text.hasComboBoxForMSWPosY = forceMSWPosY == true
    local mswPosY = ___MOD.tonumber(forceMSWPosY)
    text.forceMSWPosY = mswPosY or -9999
  end
  if addMsgPad then
    message = "\n" .. message .. "\n"
  end
  local alignment, pivot, position
  if msgAlignment == 0 then
    alignment = ___MOD.AlignmentType.TopLeft
    pivot = ___MOD.FastVector2(0, 1)
    position = ___MOD.FastVector2(42, 0)
  elseif msgAlignment == 1 then
    alignment = ___MOD.AlignmentType.Center
    pivot = ___MOD.FastVector2(0.5, 0.5)
    position = ___MOD.FastVector2.zero:Clone()
  elseif msgAlignment == 2 then
    alignment = ___MOD.AlignmentType.TopRight
    pivot = ___MOD.FastVector2(1, 1)
    position = ___MOD.FastVector2(-42, 0)
  end
  local textTrasnform = textEntity.UITransformComponent
  textTrasnform.AlignmentOption = alignment
  textTrasnform.Pivot = pivot
  textTrasnform.anchoredPosition = position
  text.alignmentType = msgAlignment
  text.outline = msgOutline
  if msgOutline then
    text.outlineColor = ___MOD.Color.FromHexCode("#315387")
  end
  text.tokens = ___MOD._BitmapFontService:tokenizeRich(message, ___MOD.FastColor.white, true, true)
  local noticeTextWidth = 450
  if type == ___MOD._UINoticeType.AuctionBuyConfirm then
    text.maxLineWidth = noticeTextWidth
    text.tempNoticeWidth = noticeTextWidth
  end
  local textLayout = ___MOD._BitmapFontService:measureRich(text.tokens, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), noticeTextWidth, 6, msgAlignment)
  text.info = textLayout
  text.richText = true
  text.text = message
  text:drawText()
  local rectY = textLayout.contentH or 24
  if type == ___MOD._UINoticeType.AuctionBuyConfirm then
    rectY = ___MOD.math.max(rectY, 140)
  end
  local comboBox
  self:insertUINotice(noticeEntity)
  local destroyWithReturn = true

  local function submitEvent(event)
    if callbackOKBtn then
      local returnVal
      if type == ___MOD._UINoticeType.Standard then
        returnVal = true
      elseif isInputNotice then
        local inputText = notice.inputText
        returnVal = self:getNoticeInputText(inputText)
      end
      local comboVal
      if withComboBox then
        local comboTextEntity = comboBox:GetChildByName("1")
        comboVal = ""
        if type ~= ___MOD._UINoticeType.Input_line and event ~= nil and event.Text ~= nil then
          comboVal = event.Text
        elseif ___MOD.isvalid(comboTextEntity) then
          if comboTextEntity.TextGUIRendererInputComponent ~= nil then
            comboVal = comboTextEntity.TextGUIRendererInputComponent.Text or ""
          elseif comboTextEntity.TextGUIRendererComponent ~= nil then
            comboVal = comboTextEntity.TextGUIRendererComponent.Text or ""
          end
        end
        if type == ___MOD._UINoticeType.Standard then
          returnVal = comboVal
        end
      end
      if (isInputNotice or withComboBox) and ___MOD._UtilLogic:IsNilorEmptyString(returnVal) then
        return
      end
      callbackOKBtn(noticeEntity, returnVal, comboVal)
    end
    noticeEntity:Destroy()
    self:removeUINotice(noticeEntity)
  end

  if not isInputNotice and not withComboBox then
    self:insertUICallback(noticeEntity, callbackOKBtn, nil)
  elseif withComboBox or not ___MOD._UtilLogic:IsNilorEmptyString(defInputStr) then
    self:insertUICallback(noticeEntity, submitEvent, nil)
  end
  if isInputNotice then
    local inputText = notice.inputText
    if ___MOD.isvalid(inputText) and inputText.TextGUIRendererComponent ~= nil then
      inputText.TextGUIRendererComponent.IsRichText = false
    end
    if ___MOD.isvalid(inputText) and inputText.TextComponent ~= nil then
      inputText.TextComponent.IsRichText = false
    end
    if contentType then
      inputText.TextGUIRendererInputComponent.ContentType = contentType
    end
    inputText.TextGUIRendererInputComponent.AutoClear = false
    if not ___MOD._UtilLogic:IsNilorEmptyString(defInputStr) then
      inputText.TextGUIRendererComponent.Text = defInputStr
      inputText.TextGUIRendererInputComponent.Text = defInputStr
    end
    inputText:ConnectEvent(___MOD.TextInputSubmitEvent, submitEvent)
    if not skipInputAutoFocus then
      inputText.TextGUIRendererInputComponent:ActivateInputField()
    end
    destroyWithReturn = false
  end
  if withComboBox then
    local comboBoxModel = ___MOD._EntryService:GetModelIdByName("Model_ComboBox")
    local c = noticeEntity:GetChildByName("c")
    comboBox = ___MOD._SpawnService:SpawnByModelId(comboBoxModel, "ComboBox", ___MOD.FastVector3.zero:Clone(), c)
    comboBox.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    comboBox.ComboBoxComponent:canComboBoxTextEdit(canComboBoxTextEdit)
    local comboTextEntity = comboBox:GetChildByName("1")
    if ___MOD.isvalid(comboTextEntity) and comboTextEntity.TextGUIRendererComponent ~= nil then
      comboTextEntity.TextGUIRendererComponent.IsRichText = false
    end
    if ___MOD.isvalid(comboTextEntity) and comboTextEntity.TextComponent ~= nil then
      comboTextEntity.TextComponent.IsRichText = false
    end
    if listBoxItems ~= nil then
      comboBox.ComboBoxComponent:getListBoxComponent():setItems(listBoxItems)
    end
    if type ~= ___MOD._UINoticeType.Input_line then
      local entity1 = comboTextEntity
      local defaultComboText = defInputStr or ""
      entity1:ConnectEvent(___MOD.TextInputSubmitEvent, submitEvent)
      entity1.TextGUIRendererComponent.Text = defaultComboText
      entity1.TextGUIRendererInputComponent.Text = defaultComboText
      entity1.TextGUIRendererInputComponent.AutoClear = false
      ___MOD._UpdateManager:insertUpdateCallback(function()
        if not ___MOD.isvalid(entity1) or entity1.TextGUIRendererInputComponent == nil then
          return
        end
        if entity1.TextGUIRendererInputComponent.Text ~= defaultComboText then
          return
        end
        entity1.TextGUIRendererComponent.Text = defaultComboText
        entity1.TextGUIRendererInputComponent.Text = defaultComboText
        entity1.TextGUIRendererInputComponent.Enable = false
        entity1.TextGUIRendererInputComponent.Enable = true
        if not skipInputAutoFocus then
          entity1.TextGUIRendererInputComponent:ActivateInputField()
        end
      end, 0)
      ___MOD._UpdateManager:insertUpdateCallback(function()
        if not ___MOD.isvalid(entity1) or entity1.TextGUIRendererInputComponent == nil then
          return
        end
        if entity1.TextGUIRendererInputComponent.Text ~= defaultComboText then
          return
        end
        entity1.TextGUIRendererComponent.Text = defaultComboText
        entity1.TextGUIRendererInputComponent.Text = defaultComboText
        if not skipInputAutoFocus then
          entity1.TextGUIRendererInputComponent:ActivateInputField()
        end
      end, 1)
    end
    destroyWithReturn = false
    rectY = rectY + 50
  end
  self.destroyWithReturnButton[noticeEntity] = destroyWithReturn
  noticeEntity.UITransformComponent.RectSize.y = rectY
  btOK:ConnectEvent(___MOD.ButtonClickEvent, submitEvent)
  if withSound then
    ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("UI.img.DlgNotice"), 1)
  end
  ___MOD._UpdateManager:insertUpdateVisible(noticeEntity, true)
  return noticeEntity
end

function UINotice.executeCallbackAndDestroyUI(self, cancel)
  local entity = self.noitceUIList[#self.noitceUIList]
  if ___MOD.isvalid(entity) then
    if cancel then
      local callback = self.callbackCancelList[entity]
      if callback then
        callback()
      elseif ___MOD.isvalid(entity) then
        entity:Destroy()
      end
    else
      local isFocused = false
      if ___MOD.isvalid(entity.UINoticeComponent) and ___MOD.isvalid(entity.UINoticeComponent.inputText) then
        local inputComponent = entity.UINoticeComponent.inputText.TextGUIRendererInputComponent
        if ___MOD.isvalid(inputComponent) then
          isFocused = inputComponent.IsFocused
        end
      end
      local contentRoot = entity:GetChildByName("c")
      if ___MOD.isvalid(contentRoot) then
        local comboBox = contentRoot:GetChildByName("ComboBox")
        if ___MOD.isvalid(comboBox) then
          local comboInput = comboBox:GetChildByName("1")
          if ___MOD.isvalid(comboInput) and ___MOD.isvalid(comboInput.TextGUIRendererInputComponent) and not isFocused then
            isFocused = comboInput.TextGUIRendererInputComponent.IsFocused
          end
        end
      end
      if isFocused then
        return
      end
      local callback = self.callbackList[entity]
      if callback and not isFocused then
        callback()
      end
      if self.destroyWithReturnButton[entity] and ___MOD.isvalid(entity) then
        entity:Destroy()
      end
    end
    self.callbackList[entity] = nil
    self.callbackCancelList[entity] = nil
    self.destroyWithReturnButton[entity] = nil
    for i = #self.noitceUIList, 1, -1 do
      if self.noitceUIList[i] == entity then
        ___MOD.table.remove(self.noitceUIList, i)
        break
      end
    end
  end
end

function UINotice.getNoticeInputText(self, inputText)
  if not ___MOD.isvalid(inputText) then
    return ""
  end
  if inputText.TextGUIRendererInputComponent ~= nil then
    return ___MOD.tostring(inputText.TextGUIRendererInputComponent.Text or "")
  end
  return ""
end

function UINotice.insertUICallback(self, entity, callback, callbackCanel)
  self.callbackList[entity] = callback
  if callbackCanel ~= nil then
    self.callbackCancelList[entity] = callbackCanel
  end
end

function UINotice.insertUINotice(self, uiNotice)
  self.noitceUIList[#self.noitceUIList + 1] = uiNotice
end

function UINotice.removeLastUINotice(self)
  local entity = self.noitceUIList[#self.noitceUIList]
  if ___MOD.isvalid(entity) then
    entity:Destroy()
    self.callbackList[entity] = nil
    self.callbackCancelList[entity] = nil
    self.noitceUIList[#self.noitceUIList] = nil
    self.destroyWithReturnButton[entity] = nil
  end
end

function UINotice.removeUINotice(self, entity)
  for _, v in ___MOD.pairs(self.noitceUIList) do
    if v == entity then
      ___MOD.table.remove(self.noitceUIList, _)
      self.callbackList[entity] = nil
      self.callbackCancelList[entity] = nil
      self.destroyWithReturnButton[entity] = nil
    end
  end
end

function UINotice.showAlertUI(self, message)
  self:createNotice(___MOD._UINoticeType.Standard, message, 1, true, true, nil, nil, false, false, nil, true, true, nil, false)
end

function UINotice.showAuctionBuyConfirmYesNoUI(self, message, callback, forceMSWPosY)
  return self:createNotice(___MOD._UINoticeType.AuctionBuyConfirm, message, 1, true, false, nil, nil, false, false, nil, false, true, callback, forceMSWPosY)
end

function UINotice.showBtAutoUI(self, message, callback)
  self:createNotice(___MOD._UINoticeType.Standard, message, 0, false, false, nil, nil, false, false, nil, false, true, callback, false)
end

function UINotice.showComboBoxUI(self, message, listBoxItems, canComboBoxTextEdit, callback, forceMSWPosY)
  self:createNotice(___MOD._UINoticeType.Standard, message, 0, false, false, nil, nil, true, canComboBoxTextEdit, listBoxItems, false, false, callback, forceMSWPosY)
end

function UINotice.showComboBoxUIDefault(self, message, listBoxItems, canComboBoxTextEdit, defaultMsg, callback, forceMSWPosY)
  self:createNotice(___MOD._UINoticeType.Standard, message, 0, false, false, nil, defaultMsg, true, canComboBoxTextEdit, listBoxItems, false, false, callback, forceMSWPosY)
end

function UINotice.showDropItemUI(self, message, default, callback)
  self:createNotice(___MOD._UINoticeType.Input, message, 0, false, false, ___MOD.InputContentType.IntegerNumber, ___MOD.tostring(default), false, false, nil, false, false, callback, false)
end

function UINotice.showInputAndComboBoxUI(self, message, listBoxItems, canComboBoxTextEdit, callback, forceMSWPosY)
  self:createNotice(___MOD._UINoticeType.Input_line, message, 0, false, false, ___MOD.InputContentType.Standard, "", true, canComboBoxTextEdit, listBoxItems, false, false, callback, forceMSWPosY)
end

function UINotice.showInputIntegerUI(self, message, defInput, callback, forceMSWPosY)
  local defInputStr = ___MOD.tostring(defInput)
  self:createNotice(___MOD._UINoticeType.Input, message, 0, false, false, ___MOD.InputContentType.IntegerNumber, defInputStr, false, false, nil, false, false, callback, forceMSWPosY)
end

function UINotice.showInputUI(self, message, defInputStr, callback, forceMSWPosY)
  self:createNotice(___MOD._UINoticeType.Input, message, 0, false, false, ___MOD.InputContentType.Standard, defInputStr, false, false, nil, false, false, callback, forceMSWPosY)
end

function UINotice.showInputUILimit(self, message, defInputStr, characterLimit, callback, forceMSWPosY)
  local noticeEntity = self:createNotice(___MOD._UINoticeType.Input, message, 0, false, false, ___MOD.InputContentType.Standard, defInputStr, false, false, nil, false, false, callback, forceMSWPosY)
  if not ___MOD.isvalid(noticeEntity) or not ___MOD.isvalid(noticeEntity.UINoticeComponent) then
    return
  end
  local inputText = noticeEntity.UINoticeComponent.inputText
  if ___MOD.isvalid(inputText) and inputText.TextGUIRendererInputComponent ~= nil then
    local limit = characterLimit
    if limit < 0 then
      limit = 0
    end
    inputText.TextGUIRendererInputComponent.CharacterLimit = limit
  end
end

function UINotice.showMobileInputIntegerUI(self, message, defInput, callback, forceMSWPosY)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) or localPlayer.Player == nil or not localPlayer.Player:isMobileUIPlatform() then
    return
  end
  local defInputStr = ___MOD.tostring(defInput)
  self:createNotice(___MOD._UINoticeType.Input, message, 0, false, false, ___MOD.InputContentType.IntegerNumber, defInputStr, false, false, nil, false, false, callback, forceMSWPosY)
end

function UINotice.showYesNoUI(self, message, callback, forceMSWPosY)
  return self:createNotice(___MOD._UINoticeType.Standard, message, 1, true, true, nil, nil, false, false, nil, false, true, callback, forceMSWPosY)
end

function UINotice.spawnNotice(self, type, disableCancelBtn)
  local model = ___MOD._EntryService:GetModelIdByName(type)
  if model == nil then
    ___MOD.log("존재하지 않는 Model : ", type)
    return
  end
  local TempGroup = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
  local noticeEntity = ___MOD._SpawnService:SpawnByModelId(model, "Notice", ___MOD.FastVector3.zero:Clone(), TempGroup)
  local btCancel = noticeEntity.UINoticeComponent.btCancel
  if disableCancelBtn then
    btCancel:SetEnable(false)
  else
    btCancel:ConnectEvent(___MOD.ButtonClickEvent, function()
      noticeEntity:Destroy()
      self:removeUINotice(noticeEntity)
    end)
  end
  return noticeEntity
end
