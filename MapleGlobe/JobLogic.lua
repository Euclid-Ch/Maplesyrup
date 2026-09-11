

function JobLogic.isAran(self, job)
  if 2000 <= job and job <= 2112 and job ~= 2001 and job ~= 2002 then
    return true
  end
  return false
end

function JobLogic.isBeginner(self, job)
  if job == 0 or job == 1000 or job == 2000 or job == 2001 or job == 3000 or job == 3001 or job == 2002 then
    return true
  end
  return false
end

function JobLogic.isDual(self, job, subcategory)
  if (job == 0 or job == 400) and subcategory ~= 0 then
    return true
  end
  if 430 <= job and job <= 434 then
    return true
  end
  return false
end

function JobLogic.isEvan(self, job)
  if job == 2001 or 2200 <= job and job <= 2218 then
    return true
  end
  return false
end
