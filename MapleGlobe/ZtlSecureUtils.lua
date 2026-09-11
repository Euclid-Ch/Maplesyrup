

function ZtlSecureUtils.new_integer(self, val)
  local t = self:u32(val)
  local rnd = self:u32(___MOD._GlobalRand32:randomInteger())
  local obf = self:ror(t ~ rnd, 5)
  local uCS = self:u32(obf + self:ror(rnd ~ 3131961357, 5))
  local ztl = ___MOD.ZtlSecure_integer()
  ztl.obf = obf
  ztl.rnd = rnd
  ztl.uCS = uCS
  return ztl
end

function ZtlSecureUtils.rol(self, x, r)
  r = r & 31
  x = x & 4294967295
  return self:u32(x << r | x >> 32 - r)
end

function ZtlSecureUtils.ror(self, x, r)
  r = r & 31
  x = x & 4294967295
  return self:u32(x >> r | x << 32 - r)
end

function ZtlSecureUtils.s32(self, x)
  x = x & 4294967295
  if 2147483648 <= x then
    return x - 268435456
  end
  return x
end

function ZtlSecureUtils.u32(self, x)
  return x & 4294967295
end
