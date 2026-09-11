

function MacroQuestionLogic.askTextNoEsc(self, udc, text, default)

end

function MacroQuestionLogic.buildAttackPowerText(self, target)

end

function MacroQuestionLogic.buildReport(self, target, question, answer)

end

function MacroQuestionLogic.buildStatText(self, target)

end

function MacroQuestionLogic.captureTimeoutAnswerClient(self, requestId)
  local user = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(user) or user.UtilDlgComponent == nil then
    return
  end
  local udc = user.UtilDlgComponent
  if udc.currentScriptName ~= "MacroQuestion" then
    return
  end
  local answer = ___MOD.tostring(udc.inputText or "")
  if ___MOD.isvalid(udc.cEntity) then
    local textInput = udc.cEntity:GetChildByName("textInput")
    if ___MOD.isvalid(textInput) then
      if textInput.TextGUIRendererInputComponent ~= nil then
        answer = ___MOD.tostring(textInput.TextGUIRendererInputComponent.Text or answer)
      elseif textInput.TextInputComponent ~= nil then
        answer = ___MOD.tostring(textInput.TextInputComponent.Text or answer)
      elseif textInput.TextGUIRendererComponent ~= nil then
        answer = ___MOD.tostring(textInput.TextGUIRendererComponent.Text or answer)
      elseif textInput.TextComponent ~= nil then
        answer = ___MOD.tostring(textInput.TextComponent.Text or answer)
      end
    end
  end
  self:submitTimeoutAnswer(requestId, answer)
end

function MacroQuestionLogic.clearQuestionClock(self, userId)

end

function MacroQuestionLogic.completeQuestion(self, requestId, adminUserId, userId, targetName, question, answer)

end

function MacroQuestionLogic.createQuestionRequest(self, adminUserId, userId, targetName, timeoutSeconds, requestKey, question, fromWeb)

end

function MacroQuestionLogic.createRequestKey(self, userId)

end

function MacroQuestionLogic.finalizeTimeoutQuestion(self, requestId)

end

function MacroQuestionLogic.findUserByAccountIdOrName(self, accountId, targetName)

end

function MacroQuestionLogic.findUserByName(self, targetName)

end

function MacroQuestionLogic.getActivityQuestionBlockReason(self, target)

end

function MacroQuestionLogic.getQuestionNpcTemplateId(self)

end

function MacroQuestionLogic.getQuestionRequest(self, requestId)

end

function MacroQuestionLogic.getQuestionText(self, questionType, customQuestion)

end

function MacroQuestionLogic.getQuestionTimeoutSeconds(self, questionType)

end

function MacroQuestionLogic.getServerKnownInputText(self, userId)

end

function MacroQuestionLogic.popQuestionRequest(self, requestId)

end

function MacroQuestionLogic.readDialogInputText(self, udc)

end

function MacroQuestionLogic.requestJail(self, targetName, inJail, senderUserId)

end

function MacroQuestionLogic.requestQuestion(self, targetName, questionType, customQuestion, senderUserId)

end

function MacroQuestionLogic.requestQuestionFromWeb(self, requestKey, targetAccountId, targetName, questionType, customQuestion)

end

function MacroQuestionLogic.sayToOperator(self, adminUser, message)

end

function MacroQuestionLogic.sendQuestionResultToWeb(self, requestKey, forUserId, targetName, question, answer, status, reason)

end

function MacroQuestionLogic.startQuestionClock(self, target, timeoutSeconds)

end

function MacroQuestionLogic.submitTimeoutAnswer(self, requestId, answer, senderUserId)

end

function MacroQuestionLogic.timeoutQuestion(self, requestId)

end

function MacroQuestionLogic.trim(self, text)

end
