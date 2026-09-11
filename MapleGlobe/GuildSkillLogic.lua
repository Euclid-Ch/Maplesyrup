

function GuildSkillLogic.createActiveRequiredExpByLevel(self)
  return {
    [1] = 7000,
    [2] = 11700
  }
end

function GuildSkillLogic.createGuildSkillConfig(self, skillIndex)
  local passiveRequiredExpByLevel = self:createPassiveRequiredExpByLevel()
  local activeRequiredExpByLevel = self:createActiveRequiredExpByLevel()
  local requiredMesoByLevel = self:createRequiredMesoByLevel()
  local passiveSkills = {
    [1] = {
      guildName = "보스 공격력 증가",
      guildDescTemplate = "#e[%s]#n\r\n보스 공격력이 %s 증가합니다.",
      descOptionByLevel = {
        [0] = "0%",
        [1] = "1%",
        [2] = "2%",
        [3] = "3%",
        [4] = "4%",
        [5] = "5%"
      },
      passiveEffectTemplate = "보스 공격력이 %s 증가합니다.",
      effectValues = {
        1,
        2,
        3,
        4,
        5
      }
    },
    [2] = {
      guildName = "방어율 무시 증가",
      guildDescTemplate = "#e[%s]#n\r\n방어율 무시가 %s 증가합니다.",
      descOptionByLevel = {
        [0] = "0%",
        [1] = "2%",
        [2] = "4%",
        [3] = "6%",
        [4] = "8%",
        [5] = "10%"
      },
      passiveEffectTemplate = "방어율 무시가 %s 증가합니다.",
      effectValues = {
        2,
        4,
        6,
        8,
        10
      }
    },
    [3] = {
      guildName = "명중률 증가",
      guildDescTemplate = "#e[%s]#n\r\n명중률이 %s 증가합니다.",
      descOptionByLevel = {
        [0] = "0",
        [1] = "10",
        [2] = "15",
        [3] = "20",
        [4] = "25",
        [5] = "30"
      },
      passiveEffectTemplate = "명중률이 %s 증가합니다.",
      effectValues = {
        10,
        15,
        20,
        25,
        30
      }
    },
    [4] = {
      guildName = "경험치 획득량 증가",
      guildDescTemplate = "#e[%s]#n\r\n경험치 획득량이 %s 증가합니다.",
      descOptionByLevel = {
        [0] = "0%",
        [1] = "2%",
        [2] = "4%",
        [3] = "6%",
        [4] = "8%",
        [5] = "10%"
      },
      passiveEffectTemplate = "경험치 획득량이 %s 증가합니다.",
      effectValues = {
        2,
        4,
        6,
        8,
        10
      }
    },
    [5] = {
      guildName = "공격력/마력 증가",
      guildDescTemplate = "#e[%s]#n\r\n%s 증가합니다.",
      descOptionByLevel = {
        [0] = "공격력 0, 마력 0",
        [1] = "공격력 1, 마력 2",
        [2] = "공격력 2, 마력 4",
        [3] = "공격력 3, 마력 6",
        [4] = "공격력 4, 마력 8",
        [5] = "공격력 5, 마력 10"
      },
      passiveEffectTemplate = "%s 증가합니다.",
      attackValues = {
        1,
        2,
        3,
        4,
        5
      },
      magicValues = {
        2,
        4,
        6,
        8,
        10
      }
    }
  }
  local activeSkills = {
    [6] = {
      guildName = "나에게 오라!",
      guildDescTemplate = "#e[%s]#n\r\n금일 사용 가능 횟수: %s회\r\n대상 입력 시 대상을 즉시 본인에게 소환합니다.\r\n#e(소환 가능 지역만 사용 가능)#n\r\n#b- 상대방 보스레이드 중 사용 불가#k",
      descOptionByLevel = {
        [0] = "0",
        [1] = "1",
        [2] = "2"
      },
      useLimitByLevel = {
        [0] = 0,
        [1] = 1,
        [2] = 2
      }
    },
    [7] = {
      guildName = "길드원에게 바로 이동",
      guildDescTemplate = "#e[%s]#n\r\n금일 사용 가능 횟수: %s회\r\n원하는 길드원이 있는 장소로 바로 이동합니다.\r\n#e(이동 가능 지역만 사용 가능)#n",
      descOptionByLevel = {
        [0] = "0",
        [1] = "1",
        [2] = "2"
      },
      useLimitByLevel = {
        [0] = 0,
        [1] = 1,
        [2] = 2
      }
    },
    [8] = {
      guildName = "경험치 50% 증가(30분)",
      guildDescTemplate = "#e[%s]#n\r\n금일 사용 가능 횟수: %s회\r\n몬스터 사냥 시 얻는 경험치가 50% 증가합니다.\r\n#e(30분, 개인적용)#n",
      descOptionByLevel = {
        [0] = "0",
        [1] = "1",
        [2] = "2"
      },
      useLimitByLevel = {
        [0] = 0,
        [1] = 1,
        [2] = 2
      }
    },
    [9] = {
      guildName = "보스따위 두렵지 않다(10분)",
      guildDescTemplate = "#e[%s]#n\r\n금일 사용 가능 횟수: %s회\r\n보스 공격력이 10% 증가합니다.\r\n#e(10분, 개인적용)#n",
      descOptionByLevel = {
        [0] = "0",
        [1] = "1",
        [2] = "2"
      },
      useLimitByLevel = {
        [0] = 0,
        [1] = 1,
        [2] = 2
      }
    }
  }
  local base = passiveSkills[skillIndex]
  if base ~= nil then
    base.skillType = "passive"
    base.maxSkillLevel = 5
    base.requiredExpByLevel = passiveRequiredExpByLevel
  else
    base = activeSkills[skillIndex]
    if base ~= nil then
      base.skillType = "active"
      base.maxSkillLevel = 2
      base.requiredExpByLevel = activeRequiredExpByLevel
    end
  end
  if base == nil then
    base = {
      guildName = ___MOD.string.format("길드 스킬 %d", skillIndex),
      guildDescTemplate = "",
      descOptionByLevel = {},
      skillType = "passive",
      maxSkillLevel = 5,
      requiredExpByLevel = passiveRequiredExpByLevel
    }
  end
  return {
    guildName = base.guildName,
    guildDesc = base.guildDesc or "",
    guildDescTemplate = base.guildDescTemplate or "",
    descOptionByLevel = base.descOptionByLevel,
    passiveEffectTemplate = base.passiveEffectTemplate,
    skillType = base.skillType,
    maxSkillLevel = base.maxSkillLevel,
    investMeso = 5000000,
    limitInvestCount = 10,
    requiredExpByLevel = base.requiredExpByLevel,
    requiredMesoByLevel = requiredMesoByLevel,
    effectValues = base.effectValues,
    attackValues = base.attackValues,
    magicValues = base.magicValues,
    useLimitByLevel = base.useLimitByLevel
  }
end

function GuildSkillLogic.createPassiveRequiredExpByLevel(self)
  return {
    [1] = 1000,
    [2] = 2500,
    [3] = 4000,
    [4] = 5200,
    [5] = 6000
  }
end

function GuildSkillLogic.createRequiredMesoByLevel(self)
  return {
    [0] = 5000000,
    [1] = 5000000,
    [2] = 5000000,
    [3] = 5000000,
    [4] = 5000000,
    [5] = 5000000
  }
end

function GuildSkillLogic.getGuildPassiveSkillEffectText(self, skillIndex, skillLevel)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil or ___MOD.tostring(config.skillType or "") ~= "passive" then
    return ""
  end
  local level = ___MOD.math.max(0, ___MOD.tonumber(skillLevel) or 0)
  local maxLevel = ___MOD.tonumber(config.maxSkillLevel or 0) or 0
  if 0 < maxLevel then
    level = ___MOD.math.min(level, maxLevel)
  end
  if level <= 0 then
    return ""
  end
  local option = ""
  if config.descOptionByLevel ~= nil then
    option = ___MOD.tostring(config.descOptionByLevel[level] or "")
  end
  if option == "" then
    return ""
  end
  local template = ___MOD.tostring(config.passiveEffectTemplate or "")
  if template == "" then
    return option
  end
  local replaced = false
  return ___MOD.string.gsub(template, "%%s", function()
    if replaced then
      return ""
    end
    replaced = true
    return option
  end)
end

function GuildSkillLogic.getGuildSkillConfig(self, skillIndex)
  local config = self:getGuildSkillConfigList()
  return config[skillIndex]
end

function GuildSkillLogic.getGuildSkillConfigList(self)
  if self.guildSkillConfig == nil then
    self:initGuildSkillConfig()
  end
  return self.guildSkillConfig
end

function GuildSkillLogic.getGuildSkillCount(self)
  local config = self:getGuildSkillConfigList()
  return #config
end

function GuildSkillLogic.getGuildSkillDescription(self, skillIndex, skillLevel)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil then
    return ""
  end
  local template = ___MOD.tostring(config.guildDescTemplate or config.guildDesc or "")
  if template == "" then
    return ""
  end
  local level = ___MOD.math.max(0, ___MOD.tonumber(skillLevel) or 0)
  local maxLevel = ___MOD.tonumber(config.maxSkillLevel or 0) or 0
  if 0 < maxLevel then
    level = ___MOD.math.min(level, maxLevel)
  end
  local skillType = ___MOD.tostring(config.skillType or "")
  local typeLabel = skillType == "active" and "액티브" or "패시브"
  local option = ""
  if config.descOptionByLevel ~= nil then
    option = ___MOD.tostring(config.descOptionByLevel[level] or "")
    if option == "" and 0 < maxLevel then
      option = ___MOD.tostring(config.descOptionByLevel[maxLevel] or "")
    end
  end
  if option == "" then
    option = "없음"
  end
  local replaceValues = {typeLabel, option}
  local replaceIndex = 0
  return ___MOD.string.gsub(template, "%%s", function()
    replaceIndex = replaceIndex + 1
    return ___MOD.tostring(replaceValues[replaceIndex] or "")
  end)
end

function GuildSkillLogic.getGuildSkillDescriptionWithUseCount(self, skillIndex, skillLevel, personalUseCount)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil or ___MOD.tostring(config.skillType or "") ~= "active" then
    return self:getGuildSkillDescription(skillIndex, skillLevel)
  end
  local template = ___MOD.tostring(config.guildDescTemplate or config.guildDesc or "")
  if template == "" then
    return ""
  end
  local useLimit = self:getGuildSkillUseLimit(skillIndex, skillLevel)
  local remainUseCount = ___MOD.math.max(0, useLimit - ___MOD.math.max(0, ___MOD.tonumber(personalUseCount) or 0))
  local replaceValues = {
    "액티브",
    ___MOD.tostring(remainUseCount)
  }
  local replaceIndex = 0
  return ___MOD.string.gsub(template, "%%s", function()
    replaceIndex = replaceIndex + 1
    return ___MOD.tostring(replaceValues[replaceIndex] or "")
  end)
end

function GuildSkillLogic.getGuildSkillLevelEffectText(self, skillIndex, skillLevel)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil then
    return "효과 없음"
  end
  local level = ___MOD.math.max(0, ___MOD.tonumber(skillLevel) or 0)
  local maxLevel = ___MOD.tonumber(config.maxSkillLevel or 0) or 0
  if 0 < maxLevel then
    level = ___MOD.math.min(level, maxLevel)
  end
  if level <= 0 then
    return "효과 없음"
  end
  if ___MOD.tostring(config.skillType or "") == "passive" then
    local passiveEffect = self:getGuildPassiveSkillEffectText(skillIndex, level)
    if not ___MOD._UtilLogic:IsNilorEmptyString(passiveEffect) then
      return passiveEffect
    end
    return "효과 없음"
  end
  local option = ""
  if config.descOptionByLevel ~= nil then
    option = ___MOD.tostring(config.descOptionByLevel[level] or "")
  end
  if ___MOD._UtilLogic:IsNilorEmptyString(option) then
    return "효과 없음"
  end
  return ___MOD.string.format("금일 사용 가능 횟수: %s회", option)
end

function GuildSkillLogic.getGuildSkillName(self, skillIndex)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil then
    return ""
  end
  return ___MOD.tostring(config.guildName or "")
end

function GuildSkillLogic.getLimitInvestCount(self, skillIndex)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil then
    return 0
  end
  return config.limitInvestCount or 0
end

function GuildSkillLogic.getMaxSkillLevel(self, skillIndex)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil then
    return 0
  end
  return config.maxSkillLevel or 0
end

function GuildSkillLogic.getRequiredExp(self, skillIndex, skillLevel)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil or config.requiredExpByLevel == nil then
    return 0
  end
  return config.requiredExpByLevel[skillLevel] or 0
end

function GuildSkillLogic.getRequiredMeso(self, skillIndex, skillLevel)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil then
    return 0
  end
  if config.requiredMesoByLevel ~= nil then
    local requiredMeso = ___MOD.tonumber(config.requiredMesoByLevel[skillLevel])
    if requiredMeso ~= nil and 0 < requiredMeso then
      return requiredMeso
    end
  end
  return config.investMeso or 0
end

function GuildSkillLogic.getTotalRequiredExp(self, skillIndex)
  local config = self:getGuildSkillConfig(skillIndex)
  if config == nil or config.requiredExpByLevel == nil then
    return 0
  end
  local total = 0
  for _, requiredExp in ___MOD.pairs(config.requiredExpByLevel) do
    total = total + (___MOD.tonumber(requiredExp) or 0)
  end
  return total
end

function GuildSkillLogic.initGuildSkillConfig(self)
  self.guildSkillConfig = {}
  for i = 1, 9 do
    self.guildSkillConfig[i] = self:createGuildSkillConfig(i)
  end
end

function GuildSkillLogic.isActiveSkill(self, skillIndex)
  local config = self:getGuildSkillConfig(skillIndex)
  return config ~= nil and ___MOD.tostring(config.skillType or "") == "active"
end

function GuildSkillLogic.isPassiveSkill(self, skillIndex)
  local config = self:getGuildSkillConfig(skillIndex)
  return config ~= nil and ___MOD.tostring(config.skillType or "") == "passive"
end

function GuildSkillLogic.OnBeginPlay(self)
  self:initGuildSkillConfig()
end
