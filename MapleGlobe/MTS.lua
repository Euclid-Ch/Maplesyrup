

function MTS.getFlag(self, index)
  return 1 << index - 1
end

function MTS.getIndexFromFlag(self, value)
  if value <= 0 then
    return nil
  end
  local idx = 1
  while 1 < value do
    value = value >> 1
    idx = idx + 1
  end
  return idx
end

function MTS.isBuff(self, skillID, index)
  if 1000 < skillID then
    return false
  end
  if index >= self.Pad and index <= self.Speed or index == self.Eva or index == self.PowerUp or index == self.MagicUp or index == self.PGuardUp or index == self.MGuardUp or self.Acc or self.SpeedUp or index == self.PadR or index == self.MadR or index == self.AccR then
    return true
  end
  return false
end
