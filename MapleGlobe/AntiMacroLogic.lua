

function AntiMacroLogic.addTimeOutTimer(self, userID, timerID)

end

function AntiMacroLogic.applyPlayerDetails(self, userID, details)

end

function AntiMacroLogic.canStartBotDetectionLieDetector(self, user, userID, now)

end

function AntiMacroLogic.clearTimeOutTimer(self, userID)

end

function AntiMacroLogic.consumeLieDetectorReserveConsumeOnSuccess(self, userID)

end

function AntiMacroLogic.detectedMacro(self, userID)

end

function AntiMacroLogic.execute_Mobile(self, userID, type, createType)

end

function AntiMacroLogic.executeLieDetector(self, userID, type, createType)

end

function AntiMacroLogic.executeLieDetectorByStartBotDetectionEvent(self, userID, type)

end

function AntiMacroLogic.getJailedRemainMinute(self, count)

end

function AntiMacroLogic.hackLog(self, userID, title, details)

end

function AntiMacroLogic.HandleMacroReceivedTestQuestionEvent(self, event)
  self:request_log_transparent("MacroReceivedTestQuestion")
end

function AntiMacroLogic.HandleMacroTestCloseByTimeoutEvent(self, event)
  self:request_log_transparent("MacroTestCloseByTimeout")
end

function AntiMacroLogic.HandleMacroTestCloseEvent(self, event)
  self:request_log_transparent("MacroTestClose")
end

function AntiMacroLogic.HandleMacroTestCountDownStartEvent(self, event)
  self:request_log_transparent("MacroTestCountDownStart")
end

function AntiMacroLogic.HandleMacroTestDelayedShutdownEvent(self, event)
  self:request_log_transparent("MacroTestDelayedShutdown")
end

function AntiMacroLogic.HandleMacroTestEndEvent(self, event)
  self:request_log_transparent("MacroTestEnd")
end

function AntiMacroLogic.HandleMacroTestReadyEvent(self, event)
  self:request_log_transparent("MacroTestReady")
  ___MOD._AntiCheatLogic:sendScreenShotLog("MacroTestReady")
end

function AntiMacroLogic.HandleMacroTestReceiveEvent(self, event)
  self:request_log_transparent("MacroTestReceive")
end

function AntiMacroLogic.HandleMacroTestSendEvent(self, event)
  self:request_log_transparent("MacroTestSend")
end

function AntiMacroLogic.HandleMacroTestStartEvent(self, event)
  self:request_log_transparent("MacroTestStart")
end

function AntiMacroLogic.hasRecentBotDetectionActivity(self, user, now)

end

function AntiMacroLogic.isLieDetectorRunning(self, userID)

end

function AntiMacroLogic.isStartBotDetectionHuntingField(self, user)

end

function AntiMacroLogic.jailedUser(self, userID, onlyOnlinePlayer)

end

function AntiMacroLogic.log_LieDetect(self, userID, type, code)

end

function AntiMacroLogic.logValue(self, userID, title, details)

end

function AntiMacroLogic.logValue_requestLieDetect(self, userID, type, code, createType)

end

function AntiMacroLogic.macroCallback(self, userID, code, createType)

end

function AntiMacroLogic.OnBeginPlay(self)

end

function AntiMacroLogic.reduceReserveCountOnLieDetectorSuccess(self, userID)

end

function AntiMacroLogic.releaseJailedUser(self, userID)

end

function AntiMacroLogic.request_log_transparent(self, title, senderUserId)

end

function AntiMacroLogic.setActiveProbability(self, value)

end

function AntiMacroLogic.setLieDetectorReserveConsumeOnSuccess(self, userID, consume)

end

function AntiMacroLogic.tryLieDetectorReservaition(self, user, addCount)

end
