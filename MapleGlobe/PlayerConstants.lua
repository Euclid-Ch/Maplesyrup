

function PlayerConstants.getBOFSkillID(self, jobID)
  local jobClass = jobID // 1000
  if jobClass == 0 then
    return ___MOD._SkillBook.Blessing_of_the_Fairy_000_12
  elseif jobClass == 1 then
    return ___MOD._SkillBook.Blessing_of_the_Fairy_1000_10000012
  elseif jobClass == 2 then
    local jobSub = jobID // 100
    if jobID == 2000 or jobSub == 21 then
      return ___MOD._SkillBook.Blessing_of_the_Fairy_2000_20000012
    elseif jobID == 2001 or jobSub == 22 then
      return ___MOD._SkillBook.Blessing_of_the_Fairy_2001_20010012
    end
  end
end

function PlayerConstants.getDefaultAnchor(self, leftFacing)
  return leftFacing and self.DefaultAnchor or self.DefaultAnchor_Flip
end

function PlayerConstants.getJobNameById(self, job)
  local jobNames = self.jobNameById
  if jobNames[0] == nil then
    jobNames[0] = "초보자"
    jobNames[100] = "검사"
    jobNames[110] = "파이터"
    jobNames[111] = "크루세이더"
    jobNames[112] = "히어로"
    jobNames[120] = "페이지"
    jobNames[121] = "나이트"
    jobNames[122] = "팔라딘"
    jobNames[130] = "스피어맨"
    jobNames[131] = "용기사"
    jobNames[132] = "다크나이트"
    jobNames[200] = "마법사"
    jobNames[210] = "위자드 (불,독)"
    jobNames[211] = "메이지 (불,독)"
    jobNames[212] = "아크메이지 (불,독)"
    jobNames[220] = "위자드 (썬,콜)"
    jobNames[221] = "메이지 (썬,콜)"
    jobNames[222] = "아크메이지 (썬,콜)"
    jobNames[230] = "클레릭"
    jobNames[231] = "프리스트"
    jobNames[232] = "비숍"
    jobNames[300] = "아처"
    jobNames[310] = "헌터"
    jobNames[311] = "레인저"
    jobNames[312] = "보우마스터"
    jobNames[320] = "사수"
    jobNames[321] = "저격수"
    jobNames[322] = "신궁"
    jobNames[400] = "로그"
    jobNames[410] = "어쌔신"
    jobNames[411] = "허밋"
    jobNames[412] = "나이트로드"
    jobNames[420] = "시프"
    jobNames[421] = "시프마스터"
    jobNames[422] = "섀도어"
    jobNames[430] = "세미듀어러"
    jobNames[431] = "듀어러"
    jobNames[432] = "듀얼마스터"
    jobNames[433] = "슬래셔"
    jobNames[434] = "듀얼블레이더"
    jobNames[500] = "해적"
    jobNames[510] = "인파이터"
    jobNames[511] = "버커니어"
    jobNames[512] = "바이퍼"
    jobNames[520] = "건슬링거"
    jobNames[521] = "발키리"
    jobNames[522] = "캡틴"
    jobNames[530] = "캐논슈터"
    jobNames[531] = "캐논블래스터"
    jobNames[532] = "캐논마스터"
    jobNames[900] = "운영자"
    local categoryNames = self.jobNameByCategory
    categoryNames[10] = "노블레스"
    categoryNames[11] = "소울마스터"
    categoryNames[12] = "플레임위자드"
    categoryNames[13] = "윈드브레이커"
    categoryNames[14] = "나이트워커"
    categoryNames[15] = "스트라이커"
    categoryNames[20] = "레전드"
    categoryNames[21] = "아란"
    categoryNames[22] = "에반"
    categoryNames[23] = "메르세데스"
    categoryNames[24] = "팬텀"
  end
  local jobName = jobNames[job]
  if jobName ~= nil then
    return jobName
  end
  local categoryName = self.jobNameByCategory[job // 100]
  if categoryName ~= nil then
    return categoryName
  end
  return ""
end

function PlayerConstants.getMaxEXP(self, level)
  return self.expTable[level] or 0
end

function PlayerConstants.getMaxEXPByJob(self, level, job)
  level = ___MOD.tonumber(level) or 0
  if level >= self:getMaxLevelByJob(job) then
    return 0
  end
  return self:getMaxEXP(level)
end

function PlayerConstants.getMaxLevelByJob(self, job)
  if self:isCygnusJob(job) then
    return 120
  end
  return 200
end

function PlayerConstants.getNobleMindSkillID(self, jobID)
  local jobClass = jobID // 1000
  if jobClass == 0 then
    return ___MOD._SkillBook.Noble_Mind_000_73
  elseif jobClass == 1 then
    return ___MOD._SkillBook.Noble_Mind_1000_10000073
  elseif jobClass == 2 then
    local jobSub = jobID // 100
    if jobID == 2000 or jobSub == 21 then
      return ___MOD._SkillBook.Noble_Mind_2000_20000073
    elseif jobID == 2001 or jobSub == 22 then
      return ___MOD._SkillBook.Noble_Mind_2001_20010073
    end
  end
end

function PlayerConstants.isCygnusJob(self, job)
  job = ___MOD.tonumber(job) or 0
  return 1000 <= job and job <= 1512
end

function PlayerConstants.isDualBlade(self, job)
  return ___MOD._JobLogic:isDual(job, 0)
end

function PlayerConstants.OnBeginPlay(self)
  if ___MOD.Environment:IsMakerPlay() then
    self.MAX_DAMAGE = ___MOD.math.maxinteger
    self.MAX_CRITICAL_DAMAGE = ___MOD.math.maxinteger
  end
  local expTable = self.expTable
  for i = 1, 199 do
    if i < 3 then
      expTable[i] = 2 * i ^ 2 + 13 * i
    elseif i < 6 then
      expTable[i] = 4 * i ^ 2 + 7 * i
    elseif i < 51 then
      if i % 3 == 0 then
        expTable[i] = (i ^ 4 + 57 * i ^ 2) / 9
      else
        expTable[i] = (i ^ 4 + 55 * i ^ 2 - 56) / 9
      end
    else
      expTable[i] = ___MOD.math.floor(1.0548 * expTable[i - 1])
    end
  end
end
