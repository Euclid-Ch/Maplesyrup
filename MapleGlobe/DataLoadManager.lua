

function DataLoadManager.beginStartupLogoGate(self)
  self.startupLogoGateActive = true
  local camera = ___MOD._UILoading:ensureLoginCamera()
  if ___MOD.isvalid(camera) and camera.TransformComponent ~= nil then
    camera.TransformComponent.Position = ___MOD.FastVector3(0, -1.5, 0)
  end
  self:playStartupLogo()
  self:setStartupLoadingVisible(false)
  ___MOD._TimerService:SetTimerOnce(function()
    local logoGroup = ___MOD._EntityService:GetEntityByPath("/ui/LogoGroup")
    if ___MOD.isvalid(logoGroup) then
      local logo = logoGroup:GetChildByName("Logo")
      if ___MOD.isvalid(logo) then
        logo.Enable = false
      end
    end
  end, 4.8)
  ___MOD._TimerService:SetTimerOnce(function()
    local logoGroup = ___MOD._EntityService:GetEntityByPath("/ui/LogoGroup")
    if ___MOD.isvalid(logoGroup) then
      logoGroup.Enable = false
    end
    self.startupLogoGateActive = false
    if not self.isLoadCompleteClient then
      ___MOD._UILoading:setDataLoading()
    end
  end, 6)
end

function DataLoadManager.cancelStartupLogoGateAndShowLoading(self)
  local logoGroup = ___MOD._EntityService:GetEntityByPath("/ui/LogoGroup")
  if ___MOD.isvalid(logoGroup) then
    local logo = logoGroup:GetChildByName("Logo")
    if ___MOD.isvalid(logo) then
      logo.Enable = false
    end
    logoGroup.Enable = false
  end
  self.startupLogoGateActive = false
  if not self.isLoadCompleteClient then
    ___MOD._UILoading:setDataLoading()
  end
end

function DataLoadManager.compeletedLoad(self)
  self.loadedCount = self.loadedCount + 1
  if self:IsServer() then
    if self.loadedCount >= self.TOTAL_LOAD_COUNT_SERVER then
      ___MOD.log(self.loadedCount)
      ___MOD.collectgarbage("collect")
      ___MOD.collectgarbage("restart")
      ___MOD.log("Server Data Load Completed.")
      self.isLoadCompleteServer = true
    end
  elseif self:IsClient() then
    ___MOD._UILoading:updateLoadText(self.loadedCount)
    if self.loadedCount >= self.TOTAL_LOAD_COUNT_CLIENT then
      ___MOD.log(self.loadedCount)
      ___MOD.collectgarbage("collect")
      ___MOD.collectgarbage("restart")
      local loadedTime = ___MOD._UtilLogic.ElapsedSeconds - self.clientLoadStartTime
      ___MOD.log(___MOD.string.format("Client Data Load Completed. (Total %ss)", loadedTime))
      self.isLoadCompleteClient = true
      if ___MOD._ServerConstants.Use_MSW_Fade then
        local fade = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/LoadingFade")
        fade.UITransformComponent.RectSize = ___MOD.Vector2(10000, 10000)
        local fadeSprite = fade.SpriteGUIRendererComponent
        fadeSprite.ImageRUID = ""
        fadeSprite.Color = ___MOD.Color.black
        fadeSprite:SetAlpha(0)
        ___MOD._ScreenTransitionService:SetFadeInOutEnable(true)
        ___MOD._ScreenTransitionService:SetFadeInTime(0.5)
        ___MOD._ScreenTransitionService:SetFadeOutTime(0.5)
      end
      self:waitLoginAndFinishClientLoading(0)
    end
  end
end

function DataLoadManager.finishClientLoadingToLogin(self)
  ___MOD._LoginLogic:drawAccountInfo()
  ___MOD._UILoading:completedDataLoading()
end

function DataLoadManager.loadClient(self)
  self.clientLoadStartTime = ___MOD._UtilLogic.ElapsedSeconds
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD.__RUIDManager:loadRUID()
  end, 1.0E-4)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._BitmapFontManager:loadBitmapFont()
  end, 0.001)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._StringPoolManager:loadStringPool()
  end, 0.002)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._ItemManager:loadItemPart1()
  end, 0.003)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._ItemManager:loadItemPart2()
  end, 0.004)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._EquipManager:loadEquipData()
  end, 0.005)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._NpcManager:loadNpc()
  end, 0.006)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MapManager:initLoadMap()
  end, 0.007)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MapManager:loadMapBackStage()
  end, 0.008)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MapManager:loadMapObjStage("Obj1")
  end, 0.009)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MapManager:loadMapObjStage("Obj2")
  end, 0.01)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MapManager:loadMapWorldStage()
  end, 0.011)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MapManager:loadMapZMassStage()
  end, 0.012)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MapManager:loadMapFHOptionStage()
  end, 0.013)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MapManager:finalizeLoadMap()
  end, 0.014)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MotionDataManager:loadMotion()
  end, 0.015)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._AfterImageManager:loadData()
  end, 0.016)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._SkillManager:loadSkill()
  end, 0.017)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._EffectManager:loadEffect()
  end, 0.018)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._EtcManager:loadEtc()
  end, 0.019)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._QuestManager:loadQuest()
  end, 0.02)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._UIManager:loadUI()
  end, 0.021)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._GuildManager:loadGuildMark()
  end, 0.0215)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._BaseManager:loadBase()
  end, 0.022)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._ReactorManager:loadReactor()
  end, 0.023)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._MorphManager:loadMorph()
  end, 0.024)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._TamingMobManager:loadTamingMob()
  end, 0.025)
  ___MOD._TimerService:SetTimerOnce(function()
    ___MOD._DailyGiftManager:loadDailyGift()
  end, 0.026)
end

function DataLoadManager.OnBeginPlay(self)
  ___MOD.collectgarbage("stop")
  if self:IsClient() then
    ___MOD._UILoading:initLoading()
    if ___MOD._UILoading.isWarp then
      self:cancelStartupLogoGateAndShowLoading()
    else
      self:beginStartupLogoGate()
    end
    if self.isLoadCompleteServer then
      self:tryStartClientLoad()
    end
  else
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD.__RUIDManager:loadRUID()
    end, 0)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._StringPoolManager:loadStringPool()
    end, 0.01)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._ScriptLogic:cacheScriptFunc()
    end, 0.02)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._ServerDataSetManager:loadDataSet()
    end, 0.03)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._ItemManager:loadItemPart1()
    end, 0.04)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._ItemManager:loadItemPart2()
    end, 0.05)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._EquipManager:loadEquipData()
    end, 0.06)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._NpcManager:loadNpc()
    end, 0.07)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._MapManager:initLoadMap()
    end, 0.08)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._MapManager:loadMapServerAreaCodeStage()
    end, 0.09)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._MapManager:loadMapServerMAPDIRStage()
    end, 0.1)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._MotionDataManager:loadMotion()
    end, 0.11)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._SkillManager:loadSkill()
    end, 0.12)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._EffectManager:loadEffect()
    end, 0.13)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._EtcManager:loadEtc()
    end, 0.14)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._QuestManager:loadQuest()
    end, 0.15)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._ReactorManager:loadReactor()
    end, 0.16)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._BaseManager:loadBase()
    end, 0.17)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._FieldSetManager:loadFieldSet()
    end, 0.18)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._ContinentManager:loadContinent()
    end, 0.19)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._MorphManager:loadMorph()
    end, 0.2)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._AreaBossManager:parseAreaBoss()
    end, 0.21)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._TamingMobManager:loadTamingMob()
    end, 0.22)
    ___MOD._TimerService:SetTimerOnce(function()
      ___MOD._DailyGiftManager:loadDailyGift()
    end, 0.23)
  end
end

function DataLoadManager.OnSyncProperty(self, name, value)
  if name == "isLoadCompleteServer" then
    if ___MOD._UILoading.isWarp and self.startupLogoGateActive then
      self:cancelStartupLogoGateAndShowLoading()
    end
    self:tryStartClientLoad()
    if not self.startupLogoGateActive then
      ___MOD._UILoading:setDataLoading()
    end
  end
end

function DataLoadManager.playStartupLogo(self)
  local logoGroup = ___MOD._EntityService:GetEntityByPath("/ui/LogoGroup")
  if not ___MOD.isvalid(logoGroup) then
    return
  end
  logoGroup.Enable = true
  local logo = logoGroup:GetChildByName("Logo")
  if ___MOD.isvalid(logo) then
    logo.Enable = true
  end
  ___MOD._SoundService:PlaySound("6c75b26b688f4b488b6b38a18dc0aadc", 1)
end

function DataLoadManager.setStartupLoadingVisible(self, visible)
  if ___MOD._UILoading.Loading == nil then
    ___MOD._UILoading:initLoading()
  end
  if ___MOD._UILoading.Loading ~= nil then
    ___MOD._UILoading.Loading:SetEnable(visible)
  end
end

function DataLoadManager.tryStartClientLoad(self)
  if self.clientLoadStarted then
    return
  end
  self.clientLoadStarted = true
  self:loadClient()
end

function DataLoadManager.waitLoginAndFinishClientLoading(self, retryCount)
  if ___MOD._LoginLogic.loginInitialized then
    self:finishClientLoadingToLogin()
    return
  end
  if 50 <= retryCount then
    self:finishClientLoadingToLogin()
    return
  end
  ___MOD._TimerService:SetTimerOnce(function()
    self:waitLoginAndFinishClientLoading(retryCount + 1)
  end, 0.1)
end
