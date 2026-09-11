

function ReportLogic.enqueueUserReportRequest(self, reporter, reported, reason, description, dailyReportCount)

end

function ReportLogic.findReportTargetInSameInstance(self, reporter, targetName)

end

function ReportLogic.getDailyReportCount(self, user)

end

function ReportLogic.getReportAccountId(self, user)

end

function ReportLogic.getReportMapName(self, user)

end

function ReportLogic.getReportPlayerId(self, user)

end

function ReportLogic.hasReportedTargetToday(self, user, targetName)

end

function ReportLogic.markReportedTargetToday(self, user, targetName)

end

function ReportLogic.onDailyReportCountClient(self, count, limit)
  local report = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Report")
  if report ~= nil and ___MOD.isvalid(report) and report.ReportUIComponent ~= nil then
    report.ReportUIComponent:updateDailyReportCount(count, limit)
  end
end

function ReportLogic.onSubmitReportResultClient(self, success, message)
  if success == true then
    local report = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/Report")
    if report ~= nil and ___MOD.isvalid(report) and report.ReportUIComponent ~= nil then
      report.ReportUIComponent:close()
    end
  end
  if ___MOD._UINotice ~= nil then
    ___MOD._UINotice:showAlertUI(message)
  end
end

function ReportLogic.requestDailyReportCountServer(self, senderUserId)

end

function ReportLogic.setDailyReportCount(self, user, count)

end

function ReportLogic.submitReportServer(self, targetName, reason, description, senderUserId)

end
