

function DayUtils.getDayOfWeekNumber(self, dow)
  return self.dow[dow] or -1
end

function DayUtils.OnBeginPlay(self)
  local dow = self.dow
  dow.Sunday = 0
  dow.Monday = 1
  dow.Tuesday = 2
  dow.Wednesday = 3
  dow.Thursday = 4
  dow.Friday = 5
  dow.Saturday = 6
end
