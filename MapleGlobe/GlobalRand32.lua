

function GlobalRand32.new(self, s1, s2, s3)
  self.past_s1 = s1
  self.past_s2 = s2
  self.past_s3 = s3
  self.s1 = s1 | 1048576
  self.s2 = s2 | 4096
  self.s3 = s3 | 16
end

function GlobalRand32.OnBeginPlay(self)
  local init_s1 = ___MOD._UtilLogic:RandomInteger()
  local init_s2 = 1170746341 * init_s1
  local init_s3 = init_s2 - 755606699
  self:new(init_s1, init_s2, init_s3)
end

function GlobalRand32.random(self)
  local s1 = self.s1 & 4294967295
  local s2 = self.s2 & 4294967295
  local s3 = self.s3 & 4294967295
  self.past_s1 = s1
  self.past_s2 = s2
  self.past_s3 = s3
  local v7 = (s1 << 12 ~ s1 >> 19 ~ (s1 >> 6 & 65535 ~ s1 << 12 & 65535) & 8191) & 4294967295
  local v8 = (s2 << 4 ~ s2 >> 25 ~ (s2 << 4 & 255 ~ s2 >> 23 & 255) & 127) & 4294967295
  local v9 = (s3 >> 11 ~ s3 << 17 ~ (s3 >> 8 ~ s3 << 17) & 2097151) & 4294967295
  self.s1 = v7
  self.s2 = v8
  self.s3 = v9
  return (v7 ~ v8 ~ v9) & 4294967295
end

function GlobalRand32.randomDouble(self)
  return self:random() / 4.294967296E9
end

function GlobalRand32.randomDoubleRange(self, n1, n2)
  if n2 < n1 then
    local tmp = n2
    n2 = n1
    n1 = tmp
  end
  local ratio = self:random() / 4.294967296E9
  return n1 + (n2 - n1) * ratio
end

function GlobalRand32.randomInteger(self)
  return self:random() & 2147483647
end

function GlobalRand32.randomIntegerRange(self, n0, n1)
  if n1 < n0 then
    local tmp = n1
    n1 = n0
    n0 = tmp
  end
  local width = n1 - n0 + 1
  if width <= 0 then
    return n0
  end
  local limit = 4294967296 - 4294967296 % width
  while true do
    local r = self:random()
    if limit > r then
      return r % width + n0
    end
  end
end
