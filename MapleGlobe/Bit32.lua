

function Bit32.band(self, a, b)
  local result = 0
  local bitval = 1
  while 0 < a and 0 < b do
    local abit = a % 2
    local bbit = b % 2
    if abit == 1 and bbit == 1 then
      result = result + bitval
    end
    a = ___MOD.math.floor(a / 2)
    b = ___MOD.math.floor(b / 2)
    bitval = bitval * 2
  end
  return result
end

function Bit32.lshift(self, x, n)
  return x * 2 ^ n
end

function Bit32.rshift(self, x, n)
  return ___MOD.math.floor(x / 2 ^ n)
end

function Bit32.toBitFlag(self, value)
  return ___MOD.math.pow(2, value - 1)
end
