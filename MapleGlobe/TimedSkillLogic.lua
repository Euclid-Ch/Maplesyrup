

function TimedSkillLogic.applyTimedRidingSkill(self, user, skillType, durationMilliseconds)

end

function TimedSkillLogic.applyTimedRidingSkillDays(self, user, skillType, days)

end

function TimedSkillLogic.applyTimedRidingSkillHours(self, user, skillType, hours)

end

function TimedSkillLogic.applyTimedRidingSkillMinutes(self, user, skillType, minutes)

end

function TimedSkillLogic.applyTimedRidingSkillSeconds(self, user, skillType, seconds)

end

function TimedSkillLogic.applyTimedSkillCoupon(self, user, itemId)

end

function TimedSkillLogic.canUseTimedSkillCoupon(self, user, itemId)

end

function TimedSkillLogic.getCouponDays(self, itemId)
  if itemId == 2430036 or itemId == 2430037 or itemId == 2430038 or itemId == 2430040 then
    return 1
  end
  if itemId == 2430053 or itemId == 2430054 or itemId == 2430055 or itemId == 2430050 then
    return 30
  end
  return 0
end

function TimedSkillLogic.getCouponSkillType(self, itemId)
  if itemId == 2430036 or itemId == 2430053 then
    return "Croco"
  end
  if itemId == 2430037 or itemId == 2430054 then
    return "BlackScooter"
  end
  if itemId == 2430038 or itemId == 2430055 then
    return "PinkScooter"
  end
  if itemId == 2430040 or itemId == 2430050 then
    return "Balrog"
  end
  return ""
end

function TimedSkillLogic.getDayMilliseconds(self)
  return 86400000
end

function TimedSkillLogic.getHourMilliseconds(self)
  return 3600000
end

function TimedSkillLogic.getMaxDaysBySkillId(self, skillId)
  if skillId == ___MOD._SkillBook.Croco__000_1027 or skillId == ___MOD._SkillBook.Croco__1000_10001027 or skillId == ___MOD._SkillBook.Croco__2000_20001027 or skillId == ___MOD._SkillBook.Croco__2001_20011027 then
    return 90
  end
  if skillId == ___MOD._SkillBook.Black_Scooter_000_1028 or skillId == ___MOD._SkillBook.Black_Scooter_1000_10001028 or skillId == ___MOD._SkillBook.Black_Scooter_2000_20001028 or skillId == ___MOD._SkillBook.Black_Scooter_2001_20011028 then
    return 90
  end
  if skillId == ___MOD._SkillBook.Pink_Scooter_000_1029 or skillId == ___MOD._SkillBook.Pink_Scooter_1000_10001029 or skillId == ___MOD._SkillBook.Pink_Scooter_2000_20001029 or skillId == ___MOD._SkillBook.Pink_Scooter_2001_20011029 then
    return 90
  end
  if skillId == ___MOD._SkillBook.Balrog_000_1031 or skillId == ___MOD._SkillBook.Balrog_1000_10001031 or skillId == ___MOD._SkillBook.Balrog_2000_20001031 or skillId == ___MOD._SkillBook.Balrog_2001_20011031 then
    return 90
  end
  return 0
end

function TimedSkillLogic.getMaxDaysBySkillType(self, skillType)
  if skillType == "Croco" or skillType == "BlackScooter" or skillType == "PinkScooter" or skillType == "Balrog" then
    return 90
  end
  return 0
end

function TimedSkillLogic.getMinuteMilliseconds(self)
  return 60000
end

function TimedSkillLogic.getNow(self)
  return ___MOD.tonumber(___MOD.DateTime.UtcNow.Elapsed) or 0
end

function TimedSkillLogic.getRidingSkillIdByJob(self, user, skillType)
  if user == nil or user.Player == nil then
    return 0
  end
  local job = ___MOD.tonumber(user.Player.Job) or 0
  local skillGroup = 0
  if ___MOD._JobLogic:isEvan(job) then
    skillGroup = 2001
  elseif ___MOD._JobLogic:isAran(job) then
    skillGroup = 2000
  elseif 1000 <= job and job <= 1512 then
    skillGroup = 1000
  end
  if skillType == "Croco" then
    if skillGroup == 1000 then
      return ___MOD._SkillBook.Croco__1000_10001027
    end
    if skillGroup == 2000 then
      return ___MOD._SkillBook.Croco__2000_20001027
    end
    if skillGroup == 2001 then
      return ___MOD._SkillBook.Croco__2001_20011027
    end
    return ___MOD._SkillBook.Croco__000_1027
  end
  if skillType == "BlackScooter" then
    if skillGroup == 1000 then
      return ___MOD._SkillBook.Black_Scooter_1000_10001028
    end
    if skillGroup == 2000 then
      return ___MOD._SkillBook.Black_Scooter_2000_20001028
    end
    if skillGroup == 2001 then
      return ___MOD._SkillBook.Black_Scooter_2001_20011028
    end
    return ___MOD._SkillBook.Black_Scooter_000_1028
  end
  if skillType == "PinkScooter" then
    if skillGroup == 1000 then
      return ___MOD._SkillBook.Pink_Scooter_1000_10001029
    end
    if skillGroup == 2000 then
      return ___MOD._SkillBook.Pink_Scooter_2000_20001029
    end
    if skillGroup == 2001 then
      return ___MOD._SkillBook.Pink_Scooter_2001_20011029
    end
    return ___MOD._SkillBook.Pink_Scooter_000_1029
  end
  if skillType == "Balrog" then
    if skillGroup == 1000 then
      return ___MOD._SkillBook.Balrog_1000_10001031
    end
    if skillGroup == 2000 then
      return ___MOD._SkillBook.Balrog_2000_20001031
    end
    if skillGroup == 2001 then
      return ___MOD._SkillBook.Balrog_2001_20011031
    end
    return ___MOD._SkillBook.Balrog_000_1031
  end
  return 0
end

function TimedSkillLogic.getSecondMilliseconds(self)
  return 1000
end

function TimedSkillLogic.getSkillIdByCoupon(self, user, itemId)
  local skillType = self:getCouponSkillType(itemId)
  if skillType == "" then
    return 0
  end
  return self:getRidingSkillIdByJob(user, skillType)
end

function TimedSkillLogic.getTimedSkillExpireAtText(self, expireAt)

end

function TimedSkillLogic.getTimedSkillName(self, skillId)

end

function TimedSkillLogic.hasActiveTimedSkillCoupon(self, user, itemId)

end

function TimedSkillLogic.isRegisteredTimedSkill(self, skillId)

end

function TimedSkillLogic.isTimedSkillCoupon(self, itemId)
  return self:getCouponDays(itemId) > 0
end

function TimedSkillLogic.normalizeRidingSkillType(self, skillType)
  local value = ___MOD.string.lower(___MOD.tostring(skillType or ""))
  if value == "croco" or value == "crocodile" or value == "1027" then
    return "Croco"
  end
  if value == "black" or value == "blackscooter" or value == "black_scooter" or value == "1028" then
    return "BlackScooter"
  end
  if value == "pink" or value == "pinkscooter" or value == "pink_scooter" or value == "1029" then
    return "PinkScooter"
  end
  if value == "balrog" or value == "1031" then
    return "Balrog"
  end
  return ""
end

function TimedSkillLogic.notifyTimedSkillApplied(self, user, skillId, expireAt, maxDays, extended)

end

function TimedSkillLogic.notifyTimedSkillCouponApplied(self, user, itemId, extended)

end

function TimedSkillLogic.notifyTimedSkillExpired(self, user, skillId)

end

function TimedSkillLogic.removeExpiredTimedSkills(self, user)

end

function TimedSkillLogic.removeTimedSkill(self, user, skillId)

end
