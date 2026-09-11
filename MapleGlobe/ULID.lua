

function ULID.EncodeRandom(self, length)
  local randomLen = self._T.randomLen
  local encoding = self._T.encoding
  local encodingLen = self._T.encodingLen
  local result = self._T.randomEncodes
  length = length or randomLen
  for i = 1, length do
    result[i] = encoding[___MOD.math.floor(___MOD.math.random() * encodingLen) + 1]
  end
  return ___MOD.table.concat(result, "", 1, length)
end

function ULID.EncodeTime(self, time, length)
  local timeLen = self._T.timeLen
  local encoding = self._T.encoding
  local encodingLen = self._T.encodingLen
  local result = self._T.timeEncodes
  time = ___MOD.math.floor((time or ___MOD.os.time()) * 1000)
  length = length or timeLen
  for i = length, 1, -1 do
    local mod = time % encodingLen
    result[i] = encoding[mod + 1]
    time = (time - mod) / encodingLen
  end
  return ___MOD.table.concat(result, "", 1, length)
end

function ULID.make(self)
  return ___MOD.string.format("%s%s", self:EncodeTime(nil, nil), self:EncodeRandom(nil))
end

function ULID.OnBeginPlay(self)
  self._T.encoding = {
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "J",
    "K",
    "M",
    "N",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  }
  self._T.encodingLen = #self._T.encoding
  self._T.timeLen = 10
  self._T.randomLen = 16
  self._T.timeEncodes = {}
  self._T.randomEncodes = {}
  ___MOD.math.randomseed(___MOD.os.time())
end
