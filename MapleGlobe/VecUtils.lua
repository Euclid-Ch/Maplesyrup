

function VecUtils.AccSpeed(self, v, f, m, vMax, tSec)
  if vMax < 0 then
    return v
  end
  if f <= 0 then
    if v > -vMax then
      v = v + f / m * tSec
      if v < -vMax then
        v = -vMax
      end
    end
  elseif vMax > v then
    v = v + f / m * tSec
    if vMax < v then
      v = vMax
    end
  end
  return v
end

function VecUtils.DecSpeed(self, v, f, m, vMax, tSec)
  if vMax < 0 then
    return v
  end
  if vMax < v then
    v = v - f / m * tSec
    if vMax > v then
      v = vMax
    end
    return v
  end
  local neg = -vMax
  if v < neg then
    v = v + f / m * tSec
    if neg < v then
      v = neg
    end
  end
  return v
end
