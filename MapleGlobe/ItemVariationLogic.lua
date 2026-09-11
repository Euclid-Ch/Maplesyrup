

function ItemVariationLogic.make(self, type, value)
  if value == 0 then
    return value
  end

  local function rd()
    return ___MOD._GlobalRand32:randomInteger()
  end

  if 0 < value then
    local v9 = value // 10 + 1
    if 5 <= v9 then
      v9 = 5
    end
    local v10 = 1 << v9 + 2
    local v11
    if v10 ~= 0 then
      v11 = rd() % v10
    else
      v11 = rd()
    end
    local v12 = v11
    local v14 = (v11 >> 6 & 1) + (v11 >> 5 & 1) + (v11 >> 4 & 1) + (v11 >> 3 & 1) + (v11 >> 2 & 1) + (v11 >> 1 & 1) + (v11 >> 0 & 1) - 2
    if v14 <= 0 then
      v14 = 0
    end
    if type == ___MOD._ItemVariationType.Normal then
      if rd() & 1 == 0 then
        return value - v14
      else
        return value + v14
      end
    elseif type == ___MOD._ItemVariationType.Better then
      if rd() % 10 < 3 then
        return value
      else
        return value + v14
      end
    elseif type == ___MOD._ItemVariationType.Great then
      if rd() % 10 == 0 then
        return value
      else
        return value + v14
      end
    end
  end
  return value
end

function ItemVariationLogic.makeChaosScroll(self, value)
  if value == 0 then
    return value
  end
  local rand = ___MOD._GlobalRand32:randomIntegerRange(1, 10000)
  if 9901 < rand then
    return value + 5
  elseif 9703 < rand then
    return value + 4
  elseif 8682 < rand then
    return value + 3
  elseif 7095 < rand then
    return value + 2
  elseif 5164 < rand then
    return value + 1
  elseif 3326 < rand then
    return value
  elseif 1956 < rand then
    return ___MOD.math.max(0, value - 1)
  elseif 1156 < rand then
    return ___MOD.math.max(0, value - 2)
  elseif 791 < rand then
    return ___MOD.math.max(0, value - 3)
  elseif 494 < rand then
    return ___MOD.math.max(0, value - 4)
  else
    return ___MOD.math.max(0, value - 5)
  end
end

function ItemVariationLogic.variation(self, type, eqp)
  local HPMP = 10
  eqp.incSTR = self:make(type, eqp.incSTR)
  eqp.incDEX = self:make(type, eqp.incDEX)
  eqp.incINT = self:make(type, eqp.incINT)
  eqp.incLUK = self:make(type, eqp.incLUK)
  eqp.incPAD = self:make(type, eqp.incPAD)
  eqp.incPDD = self:make(type, eqp.incPDD)
  eqp.incMAD = self:make(type, eqp.incMAD)
  eqp.incMDD = self:make(type, eqp.incMDD)
  eqp.incMHP = HPMP * self:make(type, eqp.incMHP // HPMP) + eqp.incMHP % HPMP
  eqp.incMMP = HPMP * self:make(type, eqp.incMMP // HPMP) + eqp.incMMP % HPMP
  eqp.incACC = self:make(type, eqp.incACC)
  eqp.incEVA = self:make(type, eqp.incEVA)
  eqp.incSpeed = self:make(type, eqp.incSpeed)
  eqp.incJump = self:make(type, eqp.incJump)
end

function ItemVariationLogic.variationChaosScroll(self, eqp)
  local HPMP = 10
  eqp.incSTR = self:makeChaosScroll(eqp.incSTR)
  eqp.incDEX = self:makeChaosScroll(eqp.incDEX)
  eqp.incINT = self:makeChaosScroll(eqp.incINT)
  eqp.incLUK = self:makeChaosScroll(eqp.incLUK)
  eqp.incPAD = self:makeChaosScroll(eqp.incPAD)
  eqp.incPDD = self:makeChaosScroll(eqp.incPDD)
  eqp.incMAD = self:makeChaosScroll(eqp.incMAD)
  eqp.incMDD = self:makeChaosScroll(eqp.incMDD)
  eqp.incMHP = HPMP * self:makeChaosScroll(eqp.incMHP // HPMP) + eqp.incMHP % HPMP
  eqp.incMMP = HPMP * self:makeChaosScroll(eqp.incMMP // HPMP) + eqp.incMMP % HPMP
  eqp.incACC = self:makeChaosScroll(eqp.incACC)
  eqp.incEVA = self:makeChaosScroll(eqp.incEVA)
  eqp.incSpeed = self:makeChaosScroll(eqp.incSpeed)
  eqp.incJump = self:makeChaosScroll(eqp.incJump)
end
