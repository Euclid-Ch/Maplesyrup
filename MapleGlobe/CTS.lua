

function CTS.checkFlag(self, flag, value)
  if flag & value ~= 0 then
    return true
  end
  return false
end

function CTS.decodeCTSFlag(self, flag)
  local result = {}
  local bitValue = 1
  while flag >= bitValue do
    if ___MOD.math.floor(flag / bitValue) % 2 == 1 then
      ___MOD.table.insert(result, bitValue)
    end
    bitValue = bitValue * 2
  end
  return result
end

function CTS.flagToIndex(self, flag, page)
  page = page or 1
  if flag <= 0 then
    return -1
  end
  local index = 1
  local bit = 1
  while flag > bit do
    bit = bit << 1
    index = index + 1
  end
  if bit == flag then
    return index + (page - 1) * 63
  end
  return -1
end

function CTS.getFlag(self, index)
  if index <= 0 then
    return 0
  end
  return 1 << (index - 1) % 63
end

function CTS.getPage(self, index)
  if index <= 0 then
    return 1
  end
  return ___MOD.math.floor((index - 1) / 63) + 1
end

function CTS.isCanDispelDisease(self, flagIndex)
  if flagIndex == ___MOD._CTS.Poison or flagIndex == ___MOD._CTS.Seal or flagIndex == ___MOD._CTS.Darkness or flagIndex == ___MOD._CTS.Weakness or flagIndex == ___MOD._CTS.Curse or flagIndex == ___MOD._CTS.StopPotion or flagIndex == ___MOD._CTS.Slow then
    return true
  end
  return false
end

function CTS.isDisease(self, flagIndex)
  if flagIndex >= ___MOD._CTS.Stun and flagIndex <= ___MOD._CTS.Undead then
    return true
  end
  return false
end

function CTS.isIndieTemporaryStat(self, index)
  if index <= 0 then
    return false
  end
  if index == self.indiePad or index == self.indieMad or index == self.indiePdd or index == self.indieMdd then
    return true
  end
  return false
end
