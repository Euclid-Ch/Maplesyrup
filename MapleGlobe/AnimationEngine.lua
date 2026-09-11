

function AnimationEngine.dequeue(self, index)
  local n = self.queueNum
  if index < 1 or index > n then
    return
  end
  self.queue[index] = self.queue[n]
  self.queue[n] = nil
  self.queueNum = n - 1
end

function AnimationEngine.enqueue(self, entity, func, delay)
  local timeline = ___MOD._UtilLogic.ServerElapsedSeconds + delay
  local n = self.queueNum + 1
  self.queue[n] = {
    entity,
    func,
    timeline
  }
  self.queueNum = n
end

function AnimationEngine.OnBeginPlay(self)

end
