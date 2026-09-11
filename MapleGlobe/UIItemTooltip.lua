

function UIItemTooltip.buildItemTooltipExpireText(self, itemId, ieqp)
  if ieqp == nil or ieqp.expTime == nil or ieqp.expTime == 0 then
    return ""
  end
  local isPet = ___MOD._ItemManager:isPet(itemId)
  local isDiedPet = isPet and ieqp.expTime > 0 and ___MOD.DateTime.UtcNow.Elapsed > ieqp.expTime
  local iexpTime = ieqp.expTime
  if 0 < iexpTime then
    if isPet then
      if isDiedPet then
        return "마법의 시간이 끝났음"
      end
      local expTime = ___MOD.DateTime(ieqp.expTime)
      local localTime = ___MOD._UtilLogic:GetLocalTimeFrom(expTime)
      return localTime:ToFormattedString("마법의 시간: yyyy년 M월 d일 HH시 mm분까지")
    end
    local expTime = ___MOD.DateTime(ieqp.expTime)
    local localTime = ___MOD._UtilLogic:GetLocalTimeFrom(expTime)
    if ___MOD._ItemManager:isExpiredDeleteExcludedItem(itemId) then
      return localTime:ToFormattedString("yyyy년 M월 d일 HH시 mm분까지 환불가능")
    end
    return localTime:ToFormattedString("yyyy년 M월 d일 HH시 mm분까지 사용가능")
  end
  local totalSec = ___MOD.math.max(0, -ieqp.expTime)
  local days = totalSec // 86400
  local hours = totalSec % 86400 // 3600
  return ___MOD.string.format("구입 후 %d일 %d시간 사용 가능", days, hours)
end

function UIItemTooltip.buildItemTooltipFlagLayout(self, ieqp)
  local result = {
    flagStr = "",
    flagLine2 = nil,
    hasFlag = false,
    hasFlagLine2 = false
  }
  if ieqp == nil or ieqp.flag == nil or ieqp.flag <= 0 then
    return result
  end
  local flags = {}
  local eflag = ieqp.flag
  local itemId = ___MOD.tonumber(ieqp.itemId) or 0
  if eflag & ___MOD._ItemFlag.Only ~= 0 then
    if self:isPotentialResetBlockedRewardEquip(itemId) then
      flags[#flags + 1] = "잠재능력 설정 불가"
    else
      flags[#flags + 1] = "고유 아이템"
    end
  end
  if eflag & ___MOD._ItemFlag.EquipTradeBlock ~= 0 then
    flags[#flags + 1] = "장착 시 교환 불가"
  end
  if eflag & ___MOD._ItemFlag.TradeOnce ~= 0 then
    flags[#flags + 1] = "1회 교환 가능 (거래 후 교환 불가)"
  elseif eflag & ___MOD._ItemFlag.AccountSharable ~= 0 then
    flags[#flags + 1] = "계정 내 이동 가능"
  elseif eflag & ___MOD._ItemFlag.TradeBlock ~= 0 then
    flags[#flags + 1] = "교환 불가"
  end
  if eflag & ___MOD._ItemFlag.NotSale ~= 0 then
    flags[#flags + 1] = "판매 불가"
  end
  if eflag & ___MOD._ItemFlag.QuestItem ~= 0 then
    flags[#flags + 1] = "퀘스트 아이템"
  end
  local flagStr = ___MOD.table.concat(flags, ", ")
  if eflag & ___MOD._ItemFlag.TradeOnce ~= 0 and 1 < #flags then
    local tradeOnceLine
    local otherFlags = {}
    for _, flagTextLine in ___MOD.ipairs(flags) do
      if tradeOnceLine == nil and ___MOD.string.find(flagTextLine, "%(") ~= nil then
        tradeOnceLine = flagTextLine
      else
        otherFlags[#otherFlags + 1] = flagTextLine
      end
    end
    if tradeOnceLine ~= nil and 0 < #otherFlags then
      flagStr = ___MOD.table.concat(otherFlags, ", ") .. "\r\n" .. tradeOnceLine
    end
  end
  local flagLine2
  local splitPos = ___MOD.string.find(flagStr, "\r\n", 1, true)
  if splitPos ~= nil then
    flagLine2 = ___MOD.string.sub(flagStr, splitPos + 2)
    flagStr = ___MOD.string.sub(flagStr, 1, splitPos - 1)
  end
  result.flagStr = flagStr
  result.flagLine2 = flagLine2
  result.hasFlag = flagStr ~= ""
  result.hasFlagLine2 = flagLine2 ~= nil and flagLine2 ~= ""
  return result
end

function UIItemTooltip.buildSkillTooltipExpireText(self, skillId)
  local player = ___MOD._UserService.LocalPlayer
  if player == nil or player.SkillComponent == nil then
    return ""
  end
  local entry = player.SkillComponent:getSkillEntry(skillId)
  if entry == nil then
    return ""
  end
  local expireAt = ___MOD.tonumber(entry.expireAt) or 0
  if expireAt <= 0 or expireAt <= ___MOD.DateTime.UtcNow.Elapsed then
    return ""
  end
  local expTime = ___MOD.DateTime(expireAt)
  local localTime = ___MOD._UtilLogic:GetLocalTimeFrom(expTime)
  return localTime:ToFormattedString("#cyyyy년 M월 d일 HH시 mm분까지 사용가능#")
end

function UIItemTooltip.createGuildBuffSkillTooltipUI(self, skillName, skillDesc, iconRUID, fixedWidth)
  local baseKey = "guildSkill"
  if self.baseEntities[baseKey] == nil then
    self.baseEntities[baseKey] = {}
  end
  local minX = ___MOD.math.max(570, ___MOD.tonumber(fixedWidth) or 0)
  local baseX = minX
  local baseY = 0
  local safeName = ___MOD.tostring(skillName or "")
  local safeDesc = ___MOD.tostring(skillDesc or "")
  local safeIconRUID = ___MOD.tostring(iconRUID or "")
  local descMaxLineW = ___MOD.math.max(baseX - 180, 1)

  local function measureDesc(descFont)
    descFont.tokens = ___MOD._BitmapFontService:tokenizeRich(descFont.text, descFont.color, true, true)
    local info = ___MOD._BitmapFontService:measureRich(descFont.tokens, ___MOD._BitmapFontType.Gulim9pt, descFont.startPos, descMaxLineW, 6, descFont.alignmentType)
    descFont.info = info
    return info
  end

  if self:getBaseEntity(baseKey, "base") ~= nil then
    local base = self:getBaseEntity(baseKey, "base")
    local top = self:getBaseEntity(baseKey, "top")
    local body = self:getBaseEntity(baseKey, "body")
    local body2 = self:getBaseEntity(baseKey, "body2")
    local nameText = self:getBaseEntity(baseKey, "nameText")
    local skillLevelText = self:getBaseEntity(baseKey, "skillLevelText")
    local descEntity = self:getBaseEntity(baseKey, "desc")
    local icon = self:getBaseEntity(baseKey, "icon")
    local outline = self:getBaseEntity(baseKey, "outline")
    nameText.BitmapFontRendererComponent:drawTextArg(safeName, ___MOD._BitmapFontType.Gulim11pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, nil, 0)
    local skillLevelFont = skillLevelText.BitmapFontRendererComponent
    skillLevelFont.text = ""
    skillLevelFont.info = nil
    skillLevelFont:drawText()
    skillLevelText:SetVisible(false)
    skillLevelText:SetEnable(false)
    local descFont = descEntity.BitmapFontRendererComponent
    descFont.text = safeDesc
    descFont.maxLineWidth = descMaxLineW
    local descInfo = measureDesc(descFont)
    descFont:drawTextArg(safeDesc, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, descMaxLineW, 0)
    descEntity.UITransformComponent.RectSize = ___MOD.FastVector2(descMaxLineW, descEntity.UITransformComponent.RectSize.y or 1)
    top.UITransformComponent.RectSize.y = 60
    body.UITransformComponent.RectSize.y = ___MOD.math.max((descInfo and descInfo.contentH or 0) + 20, 160)
    body2.UITransformComponent.RectSize.y = 0
    baseY = top.UITransformComponent.RectSize.y + body.UITransformComponent.RectSize.y
    base.UITransformComponent.RectSize = ___MOD.FastVector2(baseX, baseY)
    if ___MOD.isvalid(outline) then
      outline.UITransformComponent.RectSize = ___MOD.FastVector2(baseX + 5, baseY + 5)
    end
    if ___MOD.isvalid(icon) then
      icon.UITransformComponent.RectSize = ___MOD.FastVector2(128, 128)
      icon.SpriteGUIRendererComponent.ImageRUID = safeIconRUID
    end
    base:SetVisible(true)
    return base
  end
  local emptyEntity = self.emptyEntity
  local emptySprite = self.emptySprite
  local emptyText = self.emptyText
  local bgrnColor = ___MOD.Color.FromHexCode("#221840")
  local base = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "SkillToolTip", ___MOD.FastVector3(2000, 2000, 0), nil)
  base:SetVisible(false)
  base.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  base.UITransformComponent.anchoredPosition = ___MOD.Vector2.zero
  local top = ___MOD._SpawnService:SpawnByEntity(emptySprite, "top", ___MOD.FastVector3.zero:Clone(), base)
  top.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  top.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalTop
  top.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  top.SpriteGUIRendererComponent.Color = bgrnColor
  top.SpriteGUIRendererComponent.Color.a = 0.7
  top.SpriteGUIRendererComponent.RaycastTarget = false
  top:SetVisible(true)
  self.baseEntities[baseKey].top = top
  local body = ___MOD._SpawnService:SpawnByEntity(emptySprite, "body", ___MOD.FastVector3.zero:Clone(), top)
  body.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  body.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalBottom
  body.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  body.SpriteGUIRendererComponent.Color = bgrnColor
  body.SpriteGUIRendererComponent.Color.a = 0.7
  body.SpriteGUIRendererComponent.RaycastTarget = false
  body:SetVisible(true)
  self.baseEntities[baseKey].body = body
  local body2 = ___MOD._SpawnService:SpawnByEntity(emptySprite, "body2", ___MOD.FastVector3.zero:Clone(), body)
  body2.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  body2.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalBottom
  body2.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  body2.SpriteGUIRendererComponent.Color = bgrnColor
  body2.SpriteGUIRendererComponent.Color.a = 0.7
  body2.SpriteGUIRendererComponent.RaycastTarget = false
  body2:SetVisible(false)
  body2:SetEnable(false)
  self.baseEntities[baseKey].body2 = body2
  local iconBox = ___MOD._SpawnService:SpawnByEntity(emptySprite, "iconBox", ___MOD.FastVector3.zero:Clone(), body)
  iconBox.UITransformComponent.RectSize = ___MOD.FastVector2(140, 140)
  iconBox.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  iconBox.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
  iconBox.UITransformComponent.anchoredPosition = ___MOD.FastVector2(20, 0)
  iconBox.SpriteGUIRendererComponent.Color = ___MOD.Color.white
  iconBox.SpriteGUIRendererComponent.Color.a = 0.7
  iconBox.SpriteGUIRendererComponent.RaycastTarget = false
  iconBox:SetVisible(true)
  self.baseEntities[baseKey].iconBox = iconBox
  local icon = ___MOD._SpawnService:SpawnByEntity(emptySprite, "icon", ___MOD.FastVector3.zero:Clone(), iconBox)
  icon.UITransformComponent.RectSize = ___MOD.FastVector2(128, 128)
  icon.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  icon.SpriteGUIRendererComponent.ImageRUID = safeIconRUID
  icon.SpriteGUIRendererComponent.RaycastTarget = false
  icon:SetVisible(true)
  self.baseEntities[baseKey].icon = icon
  local nameText = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "name", ___MOD.FastVector3.zero:Clone(), top)
  nameText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  nameText:SetVisible(true)
  nameText:AddComponent(___MOD.BitmapFontRendererComponent)
  nameText.BitmapFontRendererComponent:drawTextArg(safeName, ___MOD._BitmapFontType.Gulim11pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, nil, 0)
  self.baseEntities[baseKey].nameText = nameText
  local skillLevelText = ___MOD._SpawnService:SpawnByEntity(emptyText, "skillLevelText", ___MOD.FastVector3.zero:Clone(), body2)
  skillLevelText.UITransformComponent.Pivot.y = 1
  skillLevelText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopCenter
  skillLevelText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  skillLevelText:SetVisible(false)
  skillLevelText:SetEnable(false)
  skillLevelText:AddComponent(___MOD.BitmapFontRendererComponent)
  skillLevelText:AddComponent(___MOD.LineGUIRendererComponent)
  self.baseEntities[baseKey].skillLevelText = skillLevelText
  local descText = ___MOD._SpawnService:SpawnByEntity(emptyText, "desc", ___MOD.FastVector3.zero:Clone(), body)
  descText.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
  descText.UITransformComponent.anchoredPosition = ___MOD.FastVector2(180, -10)
  descText:SetVisible(true)
  descText:AddComponent(___MOD.BitmapFontRendererComponent)
  local descFont = descText.BitmapFontRendererComponent
  descFont.text = safeDesc
  descFont.maxLineWidth = descMaxLineW
  local descInfo = measureDesc(descFont)
  descFont:drawTextArg(safeDesc, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, descMaxLineW, 0)
  descText.UITransformComponent.RectSize = ___MOD.FastVector2(descMaxLineW, descText.UITransformComponent.RectSize.y or 1)
  self.baseEntities[baseKey].desc = descText
  top.UITransformComponent.RectSize.y = 60
  body.UITransformComponent.RectSize.y = ___MOD.math.max((descInfo and descInfo.contentH or 0) + 20, 160)
  body2.UITransformComponent.RectSize.y = 0
  baseY = top.UITransformComponent.RectSize.y + body.UITransformComponent.RectSize.y
  base.UITransformComponent.RectSize = ___MOD.FastVector2(baseX, baseY)
  local outline = ___MOD._SpawnService:SpawnByEntity(emptySprite, "outline", ___MOD.FastVector3.zero:Clone(), base)
  outline.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  outline.UITransformComponent.RectSize = ___MOD.FastVector2(baseX + 5, baseY + 5)
  outline.SpriteGUIRendererComponent.Outline = true
  outline.SpriteGUIRendererComponent.OutlineColor = bgrnColor
  outline.SpriteGUIRendererComponent.OutlineWidth = 2
  outline.SpriteGUIRendererComponent.RaycastTarget = false
  outline.SpriteGUIRendererComponent.Color.a = 0
  outline:SetVisible(true)
  self.baseEntities[baseKey].outline = outline
  base:AttachTo(___MOD._EntityService:GetEntityByPath("/ui/TempGroup"))
  base:SetVisible(true)
  self.baseEntities[baseKey].base = base
  return base
end

function UIItemTooltip.createInfoTooltipUI(self, titleStr, descStr, fixedWidth)
  local baseKey = "info"
  local useMSW = ___MOD._FontLogic.UseMSWFont
  local maxWNumber = ___MOD.tonumber(fixedWidth)
  local hasFixedWidth = maxWNumber ~= nil and 0 < maxWNumber
  if not hasFixedWidth then
    maxWNumber = 470
  end
  local maxW = maxWNumber
  local titleAlign = ___MOD._BitmapFontAlignmentType.Center
  local descAlign = hasFixedWidth and ___MOD._BitmapFontAlignmentType.Left or ___MOD._BitmapFontAlignmentType.Center

  local function measuredWidth(layout)
    if layout == nil then
      return 0
    end
    local w = layout.actualW
    if w == nil then
      w = layout.contentW or 0
    end
    return w
  end

  local base = self.baseEntities[baseKey] and self.baseEntities[baseKey].base
  if base ~= nil then
    local title = self:getBaseEntity(baseKey, "title")
    local titleText = self:getBaseEntity(baseKey, "titleText")
    local titleFont = titleText.BitmapFontRendererComponent
    local desc = self:getBaseEntity(baseKey, "desc")
    local descText = self:getBaseEntity(baseKey, "descText")
    local descFont = descText.BitmapFontRendererComponent
    if hasFixedWidth then
      descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
      descText.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
      descText.UITransformComponent.anchoredPosition = ___MOD.FastVector2(15, 0)
    else
      descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Center
      descText.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0.5)
      descText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    end
    descFont.tokens = ___MOD._BitmapFontService:tokenizeRich(descStr, ___MOD.FastColor.white, true, true)
    local layout = ___MOD._BitmapFontService:measureRich(descFont.tokens, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), maxW, 6, descAlign)
    descFont.info = layout
    local titleW = 0
    if not ___MOD._UtilLogic:IsNilorEmptyString(titleStr) then
      local titleTokens = ___MOD._BitmapFontService:tokenizeRich(titleStr, ___MOD.FastColor.white, true, false)
      local titleLayout = ___MOD._BitmapFontService:measureRich(titleTokens, ___MOD._BitmapFontType.Gulim11pt_bold, ___MOD.FastVector2.zero:Clone(), maxW, 6, titleAlign)
      titleW = measuredWidth(titleLayout) + 30
    end
    local descW = measuredWidth(layout) + 30
    local rectX = ___MOD.math.min(___MOD.math.max(descW, titleW), maxW)
    if ___MOD._UtilLogic:IsNilorEmptyString(titleStr) then
      title.UITransformComponent.RectSize = ___MOD.FastVector2.zero:Clone()
    else
      title.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, 50)
    end
    if useMSW then
      titleText.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, 50)
    end
    desc.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, layout.contentH + 30)
    if useMSW then
      descText.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, layout.contentH + 30)
    end
    base.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, title.UITransformComponent.RectSize.y + desc.UITransformComponent.RectSize.y)
    titleFont:drawTextArg(titleStr, ___MOD._BitmapFontType.Gulim11pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, false, maxW, titleAlign)
    descFont:drawTextArg(descStr, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, maxW, descAlign)
    base:SetVisible(true)
    return base
  end
  local emptyEntity = self.emptyEntity
  local emptyText = self.emptyText
  local emptySprite = self.emptySprite
  local color = ___MOD.Color.FromHexCode("#221840")
  base = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "InfoTooltip", ___MOD.FastVector3(2000, 2000, 0), nil)
  base:SetVisible(false)
  base.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  base.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  local title = ___MOD._SpawnService:SpawnByEntity(emptySprite, "title", ___MOD.FastVector3.zero:Clone(), base)
  title.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  title.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
  title.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  title.UITransformComponent.RectSize.y = 50
  title.SpriteGUIRendererComponent.Color = color
  title.SpriteGUIRendererComponent.Color.a = 0.7
  title.SpriteGUIRendererComponent.RaycastTarget = false
  title:SetVisible(true)
  title:AddComponent(___MOD.BitmapFontRendererComponent)
  local titleText = ___MOD._SpawnService:SpawnByEntity(emptyText, "titleText", ___MOD.FastVector3.zero:Clone(), title)
  titleText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  if useMSW then
    titleText.UITransformComponent.RectSize = ___MOD.FastVector2(maxW, 50)
  end
  titleText:SetVisible(true)
  titleText:AddComponent(___MOD.BitmapFontRendererComponent)
  local desc = ___MOD._SpawnService:SpawnByEntity(emptySprite, "desc", ___MOD.FastVector3.zero:Clone(), title)
  desc.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  desc.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.BottomLeft
  desc.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  desc.SpriteGUIRendererComponent.Color = color
  desc.SpriteGUIRendererComponent.Color.a = 0.7
  desc.SpriteGUIRendererComponent.RaycastTarget = false
  desc:SetVisible(true)
  local descText = ___MOD._SpawnService:SpawnByEntity(emptyText, "descText", ___MOD.FastVector3.zero:Clone(), desc)
  if hasFixedWidth then
    descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
    descText.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
    descText.UITransformComponent.anchoredPosition = ___MOD.FastVector2(15, 0)
  else
    descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Center
    descText.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0.5)
    descText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  end
  descText:SetVisible(true)
  descText:AddComponent(___MOD.BitmapFontRendererComponent)
  local outline = ___MOD._SpawnService:SpawnByEntity(emptySprite, "outline", ___MOD.FastVector3.zero:Clone(), base)
  outline.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.StretchAll
  outline.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  outline.UITransformComponent.AnchorsMax = ___MOD.FastVector2(1, 1)
  outline.UITransformComponent.AnchorsMin = ___MOD.FastVector2.zero:Clone()
  outline.UITransformComponent.OffsetMax = ___MOD.FastVector2(4, 4)
  outline.UITransformComponent.OffsetMin = ___MOD.FastVector2(-4, -4)
  outline.SpriteGUIRendererComponent.Outline = true
  outline.SpriteGUIRendererComponent.OutlineColor = color
  outline.SpriteGUIRendererComponent.OutlineWidth = 2
  outline.SpriteGUIRendererComponent.RaycastTarget = false
  outline.SpriteGUIRendererComponent.Color.a = 0
  outline:SetVisible(true)
  local titleFont = titleText.BitmapFontRendererComponent
  local descFont = descText.BitmapFontRendererComponent
  descFont.tokens = ___MOD._BitmapFontService:tokenizeRich(descStr, ___MOD.FastColor.white, true, true)
  local layout = ___MOD._BitmapFontService:measureRich(descFont.tokens, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), maxW, 6, descAlign)
  descFont.info = layout
  local titleW = 0
  if not ___MOD._UtilLogic:IsNilorEmptyString(titleStr) then
    local titleTokens = ___MOD._BitmapFontService:tokenizeRich(titleStr, ___MOD.FastColor.white, true, false)
    local titleLayout = ___MOD._BitmapFontService:measureRich(titleTokens, ___MOD._BitmapFontType.Gulim11pt_bold, ___MOD.FastVector2.zero:Clone(), maxW, 6, titleAlign)
    titleW = measuredWidth(titleLayout) + 30
  end
  local descW = measuredWidth(layout) + 30
  local rectX = ___MOD.math.min(___MOD.math.max(descW, titleW), maxW)
  if ___MOD._UtilLogic:IsNilorEmptyString(titleStr) then
    title.UITransformComponent.RectSize = ___MOD.FastVector2.zero:Clone()
  else
    title.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, 50)
  end
  if useMSW then
    titleText.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, 50)
  end
  desc.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, layout.contentH + 30)
  if useMSW then
    descText.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, layout.contentH + 30)
  end
  base.UITransformComponent.RectSize = ___MOD.FastVector2(rectX, title.UITransformComponent.RectSize.y + desc.UITransformComponent.RectSize.y)
  titleFont:drawTextArg(titleStr, ___MOD._BitmapFontType.Gulim11pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, false, maxW, titleAlign)
  descFont:drawTextArg(descStr, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, maxW, descAlign)
  base:AttachTo(___MOD._EntityService:GetEntityByPath("/ui/TempGroup"))
  base:SetVisible(true)
  self.baseEntities[baseKey] = {
    base = base,
    title = title,
    titleText = titleText,
    desc = desc,
    descText = descText,
    outline = outline
  }
  return base
end

function UIItemTooltip.createItemTooltipUI(self, itemId, ieqp)
  local item = ___MOD._ItemManager:getItemById(itemId)
  if item == nil then
    ___MOD.log_error("[Tooltip] (createItemTooltipUI) 아이템 정보를 찾을 수 없습니다. ItemId : " .. itemId)
    return
  end
  local minX = 570
  local baseX, baseY
  local isPet = ___MOD._ItemManager:isPet(itemId)
  local isDiedPet = isPet and ieqp.expTime > 0 and ___MOD.DateTime.UtcNow.Elapsed > ieqp.expTime
  local itemName = item.name
  local itemDesc = ""
  if isDiedPet then
    itemDesc = item.descD
  else
    itemDesc = item.desc
  end
  if ieqp then
    local hideKarmaDescription = itemId == 4001902 and ieqp.flag & ___MOD._ItemFlag.TradeBlock ~= 0
    if not hideKarmaDescription and ieqp.flag & ___MOD._ItemFlag.TradeAvailable ~= 0 then
      local desc = "#Cffb630카르마의 가위를 사용하면 1회 교환이\r\n가능하게 할 수 있습니다.#"
      if ___MOD._UtilLogic:IsNilorEmptyString(itemDesc) then
        itemDesc = desc
      else
        itemDesc = itemDesc .. "\r\n" .. desc
      end
    end
    if ieqp.flag & ___MOD._ItemFlag.TradeCash ~= 0 then
      local desc = "#Cffb630사용 전 1회에 한해 타인과 교환할 수 있으며, 아이템 사용 후에는 교환이 제한됩니다.#"
      if ___MOD._UtilLogic:IsNilorEmptyString(itemDesc) then
        itemDesc = desc
      else
        itemDesc = itemDesc .. "\r\n\r\n" .. desc
      end
    end
  end
  local flagLayout = self:buildItemTooltipFlagLayout(ieqp)
  local expireStr = self:buildItemTooltipExpireText(itemId, ieqp)
  local aFlag = flagLayout.hasFlag
  local aExpTime = expireStr ~= ""
  local statusLayout = self:getItemTooltipStatusLayout(aFlag, flagLayout.hasFlagLine2, aExpTime)
  if self:getBaseEntity("item", "base") ~= nil then
    local base = self:getBaseEntity("item", "base")
    local top = self:getBaseEntity("item", "top")
    local top2 = self:getBaseEntity("item", "top2")
    local body = self:getBaseEntity("item", "body")
    local flagText = self:getBaseEntity("item", "flagText")
    local flagText2 = self:getBaseEntity("item", "flagText2")
    local expireText = self:getBaseEntity("item", "expireText")
    local nameText = self:getBaseEntity("item", "nameText")
    local descEntity = self:getBaseEntity("item", "desc")
    local icon = self:getBaseEntity("item", "icon")
    local outline = self:getBaseEntity("item", "outline")
    if expireText == nil then
      expireText = ___MOD._SpawnService:SpawnByEntity(self.emptyEntity, "expireText", ___MOD.FastVector3.zero:Clone(), top)
      expireText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
      expireText:SetVisible(false)
      expireText:AddComponent(___MOD.BitmapFontRendererComponent)
      self.baseEntities.item.expireText = expireText
    end
    if flagText2 == nil then
      flagText2 = ___MOD._SpawnService:SpawnByEntity(flagText, "flagText2", ___MOD.FastVector3.zero:Clone(), top)
      flagText2.UITransformComponent.anchoredPosition = flagText.UITransformComponent.anchoredPosition:Clone()
      flagText2.UITransformComponent.anchoredPosition.y = flagText2.UITransformComponent.anchoredPosition.y - 27
      flagText2:SetVisible(false)
      self.baseEntities.item.flagText2 = flagText2
    end
    nameText.BitmapFontRendererComponent.alignmentType = 1
    nameText.BitmapFontRendererComponent.maxLineWidth = base.UITransformComponent.RectSize.x
    nameText.BitmapFontRendererComponent.text = itemName
    nameText.BitmapFontRendererComponent:drawText()
    nameText.UITransformComponent.anchoredPosition.y = -15
    if aFlag then
      flagText.BitmapFontRendererComponent.alignmentType = 1
      flagText.BitmapFontRendererComponent.maxLineWidth = base.UITransformComponent.RectSize.x
      flagText.BitmapFontRendererComponent.text = flagLayout.flagStr
      flagText.BitmapFontRendererComponent:drawText()
      if flagLayout.hasFlagLine2 then
        flagText2.BitmapFontRendererComponent.alignmentType = 1
        flagText2.BitmapFontRendererComponent.maxLineWidth = base.UITransformComponent.RectSize.x
        flagText2.BitmapFontRendererComponent.text = flagLayout.flagLine2
        flagText2.BitmapFontRendererComponent:drawText()
      end
    end
    flagText:SetVisible(aFlag)
    flagText2:SetVisible(aFlag and flagLayout.hasFlagLine2)
    flagText.UITransformComponent.anchoredPosition.y = statusLayout.flagY
    flagText2.UITransformComponent.anchoredPosition.y = statusLayout.flag2Y
    if aExpTime then
      expireText.BitmapFontRendererComponent.alignmentType = 1
      expireText.BitmapFontRendererComponent.maxLineWidth = base.UITransformComponent.RectSize.x
      expireText.BitmapFontRendererComponent.text = expireStr
      expireText.BitmapFontRendererComponent:drawText()
    end
    expireText:SetVisible(aExpTime)
    top2.UITransformComponent.RectSize.y = statusLayout.top2Height
    expireText.UITransformComponent.anchoredPosition.y = statusLayout.expireY
    baseX = minX
    local descMaxLineW = baseX - 180
    descEntity.BitmapFontRendererComponent.text = itemDesc
    local descFont = descEntity.BitmapFontRendererComponent
    descFont.maxLineWidth = descMaxLineW
    descFont.tokens = ___MOD._BitmapFontService:tokenizeRich(descFont.text, descFont.color, true, true)
    local descfontInfo = ___MOD._BitmapFontService:measureRich(descFont.tokens, descFont.font, descFont.startPos, descFont.maxLineWidth, 6, descFont.alignmentType)
    descFont.info = descfontInfo
    descEntity.BitmapFontRendererComponent:drawText()
    body.UITransformComponent.RectSize.y = self:getItemTooltipDescBodyHeight(descFont, descfontInfo)
    baseY = top.UITransformComponent.RectSize.y + top2.UITransformComponent.RectSize.y + body.UITransformComponent.RectSize.y
    base.UITransformComponent.RectSize = ___MOD.FastVector2(baseX, baseY)
    outline.UITransformComponent.RectSize = ___MOD.FastVector2(baseX + 5, baseY + 5)
    local iconRUID, iconSize
    if isDiedPet then
      iconRUID = item.iconD or ""
      iconSize = item.iconDSize
    else
      iconRUID = item.icon or ""
      iconSize = item.iconSize
    end
    icon.UITransformComponent.RectSize = iconSize * 2
    icon.SpriteGUIRendererComponent.ImageRUID = iconRUID
    base:SetVisible(true)
  else
    local emptyEntity = self.emptyEntity
    local emptySprite = self.emptySprite
    local emptyText = self.emptyText
    local totalRectY = 0
    local nextY = 2.5
    local bgrnColor = ___MOD.Color.FromHexCode("#221840")
    local base = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "ItemToolTip", ___MOD.FastVector3(2000, 2000, 0), nil)
    base:SetVisible(false)
    base.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    base.UITransformComponent.anchoredPosition = ___MOD.Vector2.zero
    local top = ___MOD._SpawnService:SpawnByEntity(emptySprite, "top", ___MOD.FastVector3.zero:Clone(), base)
    top.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    top.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalTop
    top.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    top.SpriteGUIRendererComponent.Color = bgrnColor
    top.SpriteGUIRendererComponent.Color.a = 0.7
    top.SpriteGUIRendererComponent.RaycastTarget = false
    top:SetVisible(true)
    self.baseEntities.item.top = top
    local top2 = ___MOD._SpawnService:SpawnByEntity(emptySprite, "top2", ___MOD.FastVector3.zero:Clone(), top)
    top2.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    top2.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalBottom
    top2.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    top2.SpriteGUIRendererComponent.Color = bgrnColor
    top2.SpriteGUIRendererComponent.Color.a = 0.7
    top2.SpriteGUIRendererComponent.RaycastTarget = false
    top2:SetVisible(true)
    self.baseEntities.item.top2 = top2
    local body = ___MOD._SpawnService:SpawnByEntity(emptySprite, "body", ___MOD.FastVector3.zero:Clone(), top2)
    body.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    body.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalBottom
    body.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    body.SpriteGUIRendererComponent.Color = bgrnColor
    body.SpriteGUIRendererComponent.Color.a = 0.7
    body.SpriteGUIRendererComponent.RaycastTarget = false
    body:SetVisible(true)
    self.baseEntities.item.body = body
    local iconBox = ___MOD._SpawnService:SpawnByEntity(emptySprite, "iconBox", ___MOD.FastVector3.zero:Clone(), body)
    iconBox.UITransformComponent.RectSize = ___MOD.FastVector2(140, 140)
    iconBox.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    iconBox.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    iconBox.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    iconBox.UITransformComponent.anchoredPosition.x = 20
    iconBox.SpriteGUIRendererComponent.Color = ___MOD.Color.white
    iconBox.SpriteGUIRendererComponent.Color.a = 0.7
    iconBox.SpriteGUIRendererComponent.RaycastTarget = false
    iconBox:SetVisible(true)
    self.baseEntities.item.iconBox = iconBox
    local iconRUID, iconSize
    if isDiedPet then
      iconRUID = item.iconD or ""
      iconSize = item.iconDSize
    else
      iconRUID = item.icon or ""
      iconSize = item.iconSize
    end
    local icon = ___MOD._SpawnService:SpawnByEntity(emptySprite, "icon", ___MOD.FastVector3.zero:Clone(), iconBox)
    icon.UITransformComponent.RectSize = iconSize * 2
    icon.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    icon.SpriteGUIRendererComponent.ImageRUID = iconRUID
    icon.SpriteGUIRendererComponent.RaycastTarget = false
    icon:SetVisible(true)
    self.baseEntities.item.icon = icon
    local nameText = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "name", ___MOD.FastVector3.zero:Clone(), top)
    nameText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    nameText.UITransformComponent.anchoredPosition.y = -15
    nameText:SetVisible(true)
    nameText:AddComponent(___MOD.BitmapFontRendererComponent)
    local nameTextfont = nameText.BitmapFontRendererComponent
    nameTextfont:drawTextArg(itemName, ___MOD._BitmapFontType.Gulim11pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, minX, 1)
    self.baseEntities.item.nameText = nameText
    top2.UITransformComponent.RectSize.y = statusLayout.top2Height
    local flagText = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "flag", ___MOD.FastVector3.zero:Clone(), top)
    flagText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    flagText.UITransformComponent.anchoredPosition.y = statusLayout.flagY
    flagText:SetVisible(aFlag)
    flagText:AddComponent(___MOD.BitmapFontRendererComponent)
    local flagTextFont = flagText.BitmapFontRendererComponent
    flagTextFont:drawTextArg(flagLayout.flagStr, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.Color.FromHexCode("#ffb630"), false, false, nil, true, minX, 1)
    self.baseEntities.item.flagText = flagText
    local flagText2 = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "flag2", ___MOD.FastVector3.zero:Clone(), top)
    flagText2.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    flagText2.UITransformComponent.anchoredPosition.y = statusLayout.flag2Y
    flagText2:SetVisible(aFlag and flagLayout.hasFlagLine2)
    flagText2:AddComponent(___MOD.BitmapFontRendererComponent)
    local flagTextFont2 = flagText2.BitmapFontRendererComponent
    flagTextFont2:drawTextArg(flagLayout.flagLine2 or "", ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.Color.FromHexCode("#ffb630"), false, false, nil, true, minX, 1)
    self.baseEntities.item.flagText2 = flagText2
    local expireText = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "expireText", ___MOD.FastVector3.zero:Clone(), top)
    expireText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    expireText.UITransformComponent.anchoredPosition.y = statusLayout.expireY
    expireText:SetVisible(aExpTime)
    expireText:AddComponent(___MOD.BitmapFontRendererComponent)
    local expireFont = expireText.BitmapFontRendererComponent
    expireFont:drawTextArg(expireStr, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, minX, 1)
    self.baseEntities.item.expireText = expireText
    local baseX = minX
    local descMaxLineW = baseX - 180
    local descText = ___MOD._SpawnService:SpawnByEntity(emptyText, "desc", ___MOD.FastVector3.zero:Clone(), body)
    descText.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    descText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    descText.UITransformComponent.anchoredPosition.x = 180
    descText.UITransformComponent.anchoredPosition.y = -10
    descText:SetVisible(true)
    descText:AddComponent(___MOD.BitmapFontRendererComponent)
    local descTextFont = descText.BitmapFontRendererComponent
    descTextFont.tokens = ___MOD._BitmapFontService:tokenizeRich(itemDesc, ___MOD.FastColor.white, true, true)
    local descTextLayout = ___MOD._BitmapFontService:measureRich(descTextFont.tokens, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), descMaxLineW, 6, 1)
    descTextFont.info = descTextLayout
    descTextFont:drawTextArg(itemDesc, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, descMaxLineW, 0)
    self.baseEntities.item.desc = descText
    top.UITransformComponent.RectSize.y = 60
    body.UITransformComponent.RectSize.y = self:getItemTooltipDescBodyHeight(descTextFont, descTextLayout)
    local baseY = top.UITransformComponent.RectSize.y + top2.UITransformComponent.RectSize.y + body.UITransformComponent.RectSize.y
    base.UITransformComponent.RectSize = ___MOD.FastVector2(baseX, baseY)
    local outline = ___MOD._SpawnService:SpawnByEntity(emptySprite, "outline", ___MOD.FastVector3.zero:Clone(), base)
    outline.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    outline.UITransformComponent.RectSize = ___MOD.FastVector2(baseX + 5, baseY + 5)
    outline.SpriteGUIRendererComponent.Outline = true
    outline.SpriteGUIRendererComponent.OutlineColor = bgrnColor
    outline.SpriteGUIRendererComponent.OutlineWidth = 2
    outline.SpriteGUIRendererComponent.RaycastTarget = false
    outline.SpriteGUIRendererComponent.Color.a = 0
    outline:SetVisible(true)
    self.baseEntities.item.outline = outline
    base:AttachTo(___MOD._EntityService:GetEntityByPath("/ui/TempGroup"))
    base:SetVisible(true)
    self.baseEntities.item.base = base
  end
  return self:getBaseEntity("item", "base")
end

function UIItemTooltip.createSkillTooltipUI(self, skillId, skillLevel)
  local skill = ___MOD._SkillManager:getSkill(skillId)
  if skill == nil then
    ___MOD.log_error("[Tooltip] (createSkillTooltipUI) 스킬 정보를 찾을 수 없습니다. SkillId : " .. skillId)
    return
  end
  local minX = 570
  local baseX, baseY
  local skillName = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Skill.img/%07d/name", skillId))
  local skillDesc = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Skill.img/%07d/desc", skillId))
  local skillH = ""
  local masterLevel = 0
  if -1 < skillLevel then
    masterLevel = ___MOD._UserService.LocalPlayer.SkillComponent:getMasterLevel(skillId)
    if not ___MOD.string.find(skillDesc, "[마스터", 1, true) then
      skillDesc = ___MOD.string.format("[마스터 레벨 : %d]\n%s", masterLevel, skillDesc)
    end
  else
    masterLevel = skill.fixedMasterLevel
  end
  if -1 < skillLevel then
    skillH = self:getSkillLevelText(skillId, skillLevel, masterLevel)
  end
  local skillExpireText = self:buildSkillTooltipExpireText(skillId)
  if skillExpireText ~= "" then
    skillDesc = ___MOD.string.format([[
  %s

  %s]], skillDesc, skillExpireText)
  end

  local function getBitmapLongestLineWidth(textValue, fontName, color, alignment)
    if ___MOD._UtilLogic:IsNilorEmptyString(textValue) then
      return 0
    end
    local maxW = 0
    for line in ___MOD.string.gmatch(textValue, "([^\r\n]+)") do
      local tokens = ___MOD._BitmapFontService:tokenizeRich(line, color, true, true)
      local info = ___MOD._BitmapFontService:measureRich(tokens, fontName, ___MOD.FastVector2.zero:Clone(), nil, 6, alignment)
      if info ~= nil then
        local w = ___MOD.tonumber(info.actualW) or ___MOD.tonumber(info.contentW) or 0
        if maxW < w then
          maxW = w
        end
      end
    end
    return maxW
  end

  if self:getBaseEntity("skill", "base") ~= nil then
    local base = self:getBaseEntity("skill", "base")
    local top = self:getBaseEntity("skill", "top")
    local body = self:getBaseEntity("skill", "body")
    local body2 = self:getBaseEntity("skill", "body2")
    local nameText = self:getBaseEntity("skill", "nameText")
    local skillLevelText = self:getBaseEntity("skill", "skillLevelText")
    local descEntity = self:getBaseEntity("skill", "desc")
    local icon = self:getBaseEntity("skill", "icon")
    local outline = self:getBaseEntity("skill", "outline")
    nameText.BitmapFontRendererComponent.text = skillName
    nameText.BitmapFontRendererComponent:drawText()
    local skillLevelTextFont = skillLevelText.BitmapFontRendererComponent
    skillLevelTextFont.text = skillH
    skillLevelTextFont.tokens = ___MOD._BitmapFontService:tokenizeRich(skillLevelTextFont.text, skillLevelTextFont.color, true, true)
    local skillLevelTextFontInfo = ___MOD._BitmapFontService:measureRich(skillLevelTextFont.tokens, skillLevelTextFont.font, skillLevelTextFont.startPos, nil, 6, skillLevelTextFont.alignmentType)
    skillLevelTextFont.info = skillLevelTextFontInfo
    baseX = ___MOD.math.max(minX, skillLevelTextFontInfo.contentW + 20)
    skillLevelTextFont.maxLineWidth = nil
    skillLevelTextFont:drawText()
    descEntity.BitmapFontRendererComponent.text = skillDesc
    local descFont = descEntity.BitmapFontRendererComponent
    descFont.maxLineWidth = ___MOD.math.max(baseX - 180, 1)
    descFont.tokens = ___MOD._BitmapFontService:tokenizeRich(descFont.text, descFont.color, true, true)
    local descfontInfo = ___MOD._BitmapFontService:measureRich(descFont.tokens, descFont.font, descFont.startPos, descFont.maxLineWidth, 6, descFont.alignmentType)
    descFont.info = descfontInfo
    descEntity.BitmapFontRendererComponent:drawText()
    descEntity.UITransformComponent.RectSize = ___MOD.FastVector2(___MOD.math.max(baseX - 180, 1), descEntity.UITransformComponent.RectSize.y or 1)
    body.UITransformComponent.RectSize.y = ___MOD.math.max(descfontInfo.contentH + 20, 160)
    body2.UITransformComponent.RectSize.y = ___MOD._UtilLogic:IsNilorEmptyString(skillH) and 0 or 32 * skillLevelTextFontInfo.lineCnt
    baseY = top.UITransformComponent.RectSize.y + body.UITransformComponent.RectSize.y + body2.UITransformComponent.RectSize.y
    base.UITransformComponent.RectSize = ___MOD.FastVector2(baseX, baseY)
    local line = skillLevelText.LineGUIRendererComponent
    local lineY = skillLevelText.UITransformComponent.RectSize.y / 2 - 12
    local leftP = ___MOD.LinePoint(___MOD.FastVector2(-(baseX / 2) + 20, lineY), ___MOD.FastColor.white, 15)
    local rightP = ___MOD.LinePoint(___MOD.FastVector2(baseX / 2 - 20, lineY), ___MOD.FastColor.white, 15)
    line.Points[1] = leftP
    line.Points[2] = rightP
    self:refreshSkillTooltipDividerDeferred(base)
    outline.UITransformComponent.RectSize = ___MOD.FastVector2(baseX + 5, baseY + 5)
    local iconRUID = skill.icon or ""
    icon.SpriteGUIRendererComponent.ImageRUID = iconRUID
    base:SetVisible(true)
  else
    local emptyEntity = self.emptyEntity
    local emptySprite = self.emptySprite
    local emptyText = self.emptyText
    local totalRectY = 0
    local nextY = 2.5
    local bgrnColor = ___MOD.Color.FromHexCode("#221840")
    local base = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "SkillToolTip", ___MOD.FastVector3(2000, 2000, 0), nil)
    base:SetVisible(false)
    base.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    base.UITransformComponent.anchoredPosition = ___MOD.Vector2.zero
    local top = ___MOD._SpawnService:SpawnByEntity(emptySprite, "top", ___MOD.FastVector3.zero:Clone(), base)
    top.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    top.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalTop
    top.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    top.SpriteGUIRendererComponent.Color = bgrnColor
    top.SpriteGUIRendererComponent.Color.a = 0.7
    top.SpriteGUIRendererComponent.RaycastTarget = false
    top:SetVisible(true)
    self.baseEntities.skill.top = top
    local body = ___MOD._SpawnService:SpawnByEntity(emptySprite, "body", ___MOD.FastVector3.zero:Clone(), top)
    body.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    body.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalBottom
    body.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    body.SpriteGUIRendererComponent.Color = bgrnColor
    body.SpriteGUIRendererComponent.Color.a = 0.7
    body.SpriteGUIRendererComponent.RaycastTarget = false
    body:SetVisible(true)
    self.baseEntities.skill.body = body
    local body2 = ___MOD._SpawnService:SpawnByEntity(emptySprite, "body2", ___MOD.FastVector3.zero:Clone(), body)
    body2.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    body2.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.HorizontalBottom
    body2.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    body2.SpriteGUIRendererComponent.Color = bgrnColor
    body2.SpriteGUIRendererComponent.Color.a = 0.7
    body2.SpriteGUIRendererComponent.RaycastTarget = false
    body2:SetVisible(true)
    self.baseEntities.skill.body2 = body2
    local iconBox = ___MOD._SpawnService:SpawnByEntity(emptySprite, "iconBox", ___MOD.FastVector3.zero:Clone(), body)
    iconBox.UITransformComponent.RectSize = ___MOD.FastVector2(140, 140)
    iconBox.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    iconBox.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    iconBox.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    iconBox.UITransformComponent.anchoredPosition.x = 20
    iconBox.SpriteGUIRendererComponent.Color = ___MOD.Color.white
    iconBox.SpriteGUIRendererComponent.Color.a = 0.7
    iconBox.SpriteGUIRendererComponent.RaycastTarget = false
    iconBox:SetVisible(true)
    self.baseEntities.skill.iconBox = iconBox
    local iconSize = ___MOD.FastVector2(128, 128)
    local iconRUID = skill.icon or ""
    local icon = ___MOD._SpawnService:SpawnByEntity(emptySprite, "icon", ___MOD.FastVector3.zero:Clone(), iconBox)
    icon.UITransformComponent.RectSize = iconSize
    icon.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    icon.SpriteGUIRendererComponent.ImageRUID = iconRUID
    icon.SpriteGUIRendererComponent.RaycastTarget = false
    icon:SetVisible(true)
    self.baseEntities.skill.icon = icon
    local nameText = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "name", ___MOD.FastVector3.zero:Clone(), top)
    nameText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    nameText:SetVisible(true)
    nameText:AddComponent(___MOD.BitmapFontRendererComponent)
    local nameTextfont = nameText.BitmapFontRendererComponent
    nameTextfont:drawTextArg(skillName, ___MOD._BitmapFontType.Gulim11pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, nil, 0)
    self.baseEntities.skill.nameText = nameText
    local skillLevelText = ___MOD._SpawnService:SpawnByEntity(emptyText, "skillLevelText", ___MOD.FastVector3.zero:Clone(), body2)
    skillLevelText.UITransformComponent.Pivot.y = 1
    skillLevelText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopCenter
    skillLevelText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    skillLevelText:SetVisible(true)
    skillLevelText:AddComponent(___MOD.BitmapFontRendererComponent)
    local skillLevelTextFont = skillLevelText.BitmapFontRendererComponent
    skillLevelTextFont.tokens = ___MOD._BitmapFontService:tokenizeRich(skillH, ___MOD.FastColor.white, true, true)
    local skillLevelTextLayout = ___MOD._BitmapFontService:measureRich(skillLevelTextFont.tokens, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), nil, 6, 1)
    skillLevelTextFont.info = skillLevelTextLayout
    skillLevelTextFont:drawTextArg(skillH, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, ___MOD.Color.clear, true, nil, 1)
    self.baseEntities.skill.skillLevelText = skillLevelText
    baseX = ___MOD.math.max(minX, skillLevelTextLayout.contentW + 20)
    skillLevelTextFont:drawTextArg(skillH, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, ___MOD.Color.clear, true, nil, 1)
    local descMaxLineW = ___MOD.math.max(baseX - 180, 1)
    local descText = ___MOD._SpawnService:SpawnByEntity(emptyText, "desc", ___MOD.FastVector3.zero:Clone(), body)
    descText.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    descText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    descText.UITransformComponent.anchoredPosition.x = 180
    descText.UITransformComponent.anchoredPosition.y = -10
    descText:SetVisible(true)
    descText:AddComponent(___MOD.BitmapFontRendererComponent)
    local descTextFont = descText.BitmapFontRendererComponent
    descTextFont.tokens = ___MOD._BitmapFontService:tokenizeRich(skillDesc, ___MOD.FastColor.white, true, true)
    local descTextLayout = ___MOD._BitmapFontService:measureRich(descTextFont.tokens, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), descMaxLineW, 6, 1)
    descTextFont.info = descTextLayout
    descTextFont:drawTextArg(skillDesc, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, descMaxLineW, 0)
    descText.UITransformComponent.RectSize = ___MOD.FastVector2(descMaxLineW, descText.UITransformComponent.RectSize.y or 1)
    self.baseEntities.skill.desc = descText
    top.UITransformComponent.RectSize.y = 60
    body.UITransformComponent.RectSize.y = ___MOD.math.max(descTextLayout.contentH + 20, 160)
    body2.UITransformComponent.RectSize.y = ___MOD._UtilLogic:IsNilorEmptyString(skillH) and 0 or 32 * skillLevelTextLayout.lineCnt
    baseY = top.UITransformComponent.RectSize.y + body.UITransformComponent.RectSize.y + body2.UITransformComponent.RectSize.y
    base.UITransformComponent.RectSize = ___MOD.FastVector2(baseX, baseY)
    skillLevelText:AddComponent(___MOD.LineGUIRendererComponent)
    local line = skillLevelText.LineGUIRendererComponent
    local lineY = skillLevelText.UITransformComponent.RectSize.y / 2 - 12
    local leftP = ___MOD.LinePoint(___MOD.FastVector2(-(baseX / 2) + 20, lineY), ___MOD.FastColor.white, 15)
    local rightP = ___MOD.LinePoint(___MOD.FastVector2(baseX / 2 - 20, lineY), ___MOD.FastColor.white, 15)
    line.Points:Add(leftP)
    line.Points:Add(rightP)
    self:refreshSkillTooltipDividerDeferred(base)
    local outline = ___MOD._SpawnService:SpawnByEntity(emptySprite, "outline", ___MOD.FastVector3.zero:Clone(), base)
    outline.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
    outline.UITransformComponent.RectSize = ___MOD.FastVector2(baseX + 5, baseY + 5)
    outline.SpriteGUIRendererComponent.Outline = true
    outline.SpriteGUIRendererComponent.OutlineColor = bgrnColor
    outline.SpriteGUIRendererComponent.OutlineWidth = 2
    outline.SpriteGUIRendererComponent.RaycastTarget = false
    outline.SpriteGUIRendererComponent.Color.a = 0
    outline:SetVisible(true)
    self.baseEntities.skill.outline = outline
    base:AttachTo(___MOD._EntityService:GetEntityByPath("/ui/TempGroup"))
    base:SetVisible(true)
    self.baseEntities.skill.base = base
  end
  return self:getBaseEntity("skill", "base")
end

function UIItemTooltip.createTextTooltipUI(self, text, maxWidth)
  local baseKey = "text"
  local emptyEntity = self.emptyEntity
  local emptyText = self.emptyText
  local emptySprite = self.emptySprite
  local useMSW = ___MOD._FontLogic.UseMSWFont
  local maxWNumber = ___MOD.tonumber(maxWidth)
  if maxWNumber == nil or maxWNumber <= 0 then
    maxWNumber = 400
  end
  local maxW = maxWNumber

  local function measuredWidth(layout)
    if layout == nil then
      return 0
    end
    local w = layout.actualW
    if w == nil then
      w = layout.contentW or 0
    end
    return w
  end

  local base = self.baseEntities[baseKey] and self.baseEntities[baseKey].base
  if base ~= nil then
    local textEntity = self.baseEntities[baseKey].text
    local font = textEntity.BitmapFontRendererComponent
    local pos = textEntity.UITransformComponent.anchoredPosition
    if useMSW then
      textEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, pos and pos.y or -10)
    else
      textEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(10, pos and pos.y or -10)
    end
    font.tokens = ___MOD._BitmapFontService:tokenizeRich(text, ___MOD.FastColor.white, true, true)
    local layout = ___MOD._BitmapFontService:measureRich(font.tokens, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), maxW, 6, ___MOD._BitmapFontAlignmentType.Left)
    font.info = layout
    font:drawTextArg(text, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, maxW, ___MOD._BitmapFontAlignmentType.Left)
    local bg = self.baseEntities[baseKey].background
    local bgW = ___MOD.math.min(measuredWidth(layout), maxW) + 20
    bg.UITransformComponent.RectSize = ___MOD.FastVector2(bgW, layout.contentH + 20)
    textEntity.UITransformComponent.RectSize = ___MOD.FastVector2(bgW, layout.contentH + 20)
    base.UITransformComponent.RectSize = bg.UITransformComponent.RectSize
    base:AttachTo(___MOD._EntityService:GetEntityByPath("/ui/TempGroup"))
    base:SetVisible(true)
    return base
  end
  base = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "TextTooltipBase", ___MOD.FastVector3(2000, 2000, 0), nil)
  base:SetVisible(false)
  base.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  base.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  local background = ___MOD._SpawnService:SpawnByEntity(emptySprite, "textTooltipBackground", ___MOD.FastVector3.zero:Clone(), base)
  background.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  background.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
  background.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  background.SpriteGUIRendererComponent.Color = ___MOD.Color.FromHexCode("#221840")
  background.SpriteGUIRendererComponent.Color.a = 0.7
  background.SpriteGUIRendererComponent.RaycastTarget = false
  background:SetVisible(true)
  local textEntity = ___MOD._SpawnService:SpawnByEntity(emptyText, "textTooltipText", ___MOD.FastVector3.zero:Clone(), background)
  textEntity.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
  textEntity.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
  if useMSW then
    textEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, -10)
  else
    textEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(10, -10)
  end
  textEntity:SetVisible(true)
  textEntity:AddComponent(___MOD.BitmapFontRendererComponent)
  local font = textEntity.BitmapFontRendererComponent
  font.tokens = ___MOD._BitmapFontService:tokenizeRich(text, ___MOD.FastColor.white, true, true)
  local layout = ___MOD._BitmapFontService:measureRich(font.tokens, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), maxW, 6, ___MOD._BitmapFontAlignmentType.Left)
  font.info = layout
  font:drawTextArg(text, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, false, false, nil, true, maxW, ___MOD._BitmapFontAlignmentType.Left)
  local bgW = ___MOD.math.min(measuredWidth(layout), maxW) + 20
  background.UITransformComponent.RectSize = ___MOD.FastVector2(bgW, layout.contentH + 20)
  textEntity.UITransformComponent.RectSize = ___MOD.FastVector2(bgW, layout.contentH + 20)
  base.UITransformComponent.RectSize = background.UITransformComponent.RectSize
  base:AttachTo(___MOD._EntityService:GetEntityByPath("/ui/TempGroup"))
  base:SetVisible(true)
  self.baseEntities[baseKey] = {
    base = base,
    text = textEntity,
    background = background
  }
  return base
end

function UIItemTooltip.getBaseEntity(self, dir, name)
  return self.baseEntities[dir] and self.baseEntities[dir][name] or nil
end

function UIItemTooltip.getEquipOptionsText(self, equip, equipInfo)
  local EquipMgr = ___MOD._EquipManager
  local getCatKo = EquipMgr.getCategoryKoNameById
  local getSpd = EquipMgr.getAttackSpeedLabel
  local out = {}
  local n = 1
  out[n] = "─────────────────"
  n = n + 1
  out[n] = ("· 장비분류 : %s"):format(getCatKo(EquipMgr, equip.itemId))
  n = n + 1
  if EquipMgr:getCategoryNameById(equip.itemId) == "Weapon" then
    out[n] = ("· 공격속도 : %s"):format(getSpd(EquipMgr, equipInfo.attackSpeed or 0))
    n = n + 1
  end

  local function put(label, val, always)
    if val and (0 < val or always) then
      out[n] = ("%s : %s"):format(label, always and val or "+" .. val)
      n = n + 1
    end
  end

  put("· STR", equip.incSTR, false)
  put("· DEX", equip.incDEX, false)
  put("· INT", equip.incINT, false)
  put("· LUK", equip.incLUK, false)
  put("· HP", equip.incMHP, false)
  put("· MP", equip.incMMP, false)
  put("· 공격력", equip.incPAD, false)
  put("· 마력", equip.incMAD, false)
  put("· 물리 방어력", equip.incPDD, false)
  put("· 마법 방어력", equip.incMDD, false)
  put("· 명중률", equip.incACC, false)
  put("· 회피율", equip.incEVA, false)
  put("· 이동속도", equip.incSpeed, false)
  put("· 점프력", equip.incJump, false)
  put("· 업그레이드 가능 횟수", equip.tuc or 0, not equipInfo.cash)
  local itemFamily = (___MOD.tonumber(equip.itemId) or 0) // 10000
  if itemFamily == 190 or itemFamily == 191 then
    for i = #out, 1, -1 do
      if ___MOD.string.find(___MOD.tostring(out[i]), "잛닔", 1, true) ~= nil then
        ___MOD.table.remove(out, i)
        break
      end
    end
  end
  return out
end

function UIItemTooltip.getGrowthRUID(self, name, enabled)
  local dir = ""
  if enabled then
    dir = "GrowthEnabled"
  else
    dir = "GrowthDisabled"
  end
  return self.EquipTooltipRUID[dir][name].ruid
end

function UIItemTooltip.getItemTooltipDescBodyHeight(self, fontComp, layoutInfo)
  local contentH = ___MOD.tonumber(layoutInfo ~= nil and layoutInfo.contentH or nil) or 0
  if fontComp ~= nil and fontComp.shouldUseNativeMSWRichTextRenderer ~= nil and fontComp:shouldUseNativeMSWRichTextRenderer() and fontComp.Entity ~= nil and ___MOD.isvalid(fontComp.Entity) and ___MOD.isvalid(fontComp.Entity.UITransformComponent) then
    local nativeH = ___MOD.tonumber(fontComp.Entity.UITransformComponent.RectSize.y) or 0
    if 0 < nativeH then
      contentH = nativeH
    end
  end
  return ___MOD.math.max(contentH + 20, 160)
end

function UIItemTooltip.getItemTooltipStatusLayout(self, hasFlag, hasFlagLine2, hasExpTime)
  local lineHeight = 27
  local bottomPadding = 13
  local sectionGap = 9
  local layout = {
    top2Height = 0,
    flagY = -55,
    flag2Y = -82,
    expireY = -83
  }
  local currentY = -55
  local usedHeight = 0
  if hasFlag then
    layout.flagY = currentY
    usedHeight = lineHeight
    currentY = currentY - lineHeight
    if hasFlagLine2 then
      layout.flag2Y = currentY
      usedHeight = usedHeight + lineHeight
      currentY = currentY - lineHeight
    end
  end
  if hasExpTime then
    if hasFlag then
      currentY = currentY - sectionGap
      usedHeight = usedHeight + sectionGap
    end
    layout.expireY = currentY
    usedHeight = usedHeight + lineHeight
  end
  if 0 < usedHeight then
    usedHeight = usedHeight + bottomPadding
  end
  layout.top2Height = usedHeight
  return layout
end

function UIItemTooltip.getRequireRUID(self, name, can)
  local dir = ""
  if can then
    dir = "Can"
  else
    dir = "Cannot"
  end
  return self.EquipTooltipRUID[dir][name].ruid
end

function UIItemTooltip.getSizeGrowthRUID(self, name, enabled)
  local dir = ""
  if enabled then
    dir = "GrowthEnabled"
  else
    dir = "GrowthDisabled"
  end
  return self.EquipTooltipRUID[dir][name].size
end

function UIItemTooltip.getSizeRequireRUID(self, name, can)
  local dir = ""
  if can then
    dir = "Can"
  else
    dir = "Cannot"
  end
  return self.EquipTooltipRUID[dir][name].size
end

function UIItemTooltip.getSkillLevelText(self, skillId, skillLevel, masterLevel)
  local levelTextTable = {}
  local levelText = ""
  levelTextTable[1] = " "
  if skillLevel <= 0 then
    levelTextTable[2] = ___MOD.string.format("[다음 레벨 : %d]", skillLevel + 1)
    levelTextTable[3] = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Skill.img/%07d/h%d", skillId, skillLevel + 1))
  elseif masterLevel <= skillLevel then
    levelTextTable[2] = ___MOD.string.format("[현재 레벨 : %d]", skillLevel)
    levelTextTable[3] = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Skill.img/%07d/h%d", skillId, skillLevel))
  else
    levelTextTable[2] = ___MOD.string.format("[현재 레벨 : %d]", skillLevel)
    levelTextTable[3] = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Skill.img/%07d/h%d", skillId, skillLevel))
    levelTextTable[4] = ___MOD.string.format("[다음 레벨 : %d]", skillLevel + 1)
    levelTextTable[5] = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Skill.img/%07d/h%d", skillId, skillLevel + 1))
  end
  levelText = ___MOD.table.concat(levelTextTable, "\n")
  return levelText
end

function UIItemTooltip.isPotentialResetBlockedRewardEquip(self, itemId)
  return ___MOD._EquipManager:isPotentialChangeBlockedEquip(itemId)
end

function UIItemTooltip.OnBeginPlay(self)
  local function loadRUID()
    if not ___MOD._DataLoadManager.isLoadCompleteClient then
      return
    end
    ___MOD._TimerService:ClearTimer(self._T.loadTimer)
    self.emptyEntity = ___MOD._EntityService:GetEntity("41ac3e60-7ab1-46ff-afd6-fa4b4b641dea")
    self.emptySprite = ___MOD._EntityService:GetEntity("5c015165-9aac-4c2d-8672-0b8c07809421")
    self.emptyText = ___MOD._EntityService:GetEntity("0a82fce2-686f-4426-b4e1-11a634c62cf0")
    self.baseEntities.equip = {}
    self.baseEntities.item = {}
    self.baseEntities.skill = {}
    self.baseEntities.guildSkill = {}
    self.EquipTooltipRUID.Can = {}
    self.EquipTooltipRUID.Cannot = {}
    self.EquipTooltipRUID.GrowthEnabled = {}
    self.EquipTooltipRUID.GrowthDisabled = {}
    self.EquipTooltipRUID.Can.reqLEV = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.reqLEV"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Can.reqSTR = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.reqSTR"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Can.reqDEX = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.reqDEX"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Can.reqINT = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.reqINT"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Can.reqLUK = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.reqLUK"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Can.reqPOP = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.reqPOP"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Can.none = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.none"),
      size = ___MOD.FastVector2(10, 5)
    }
    self.EquipTooltipRUID.Can.durability = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.durability"),
      size = ___MOD.FastVector2(124, 14)
    }
    self.EquipTooltipRUID.Can.percent = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Can.percent"),
      size = ___MOD.FastVector2(10, 14)
    }
    for i = 0, 9 do
      local index = ___MOD.tostring(i)
      self.EquipTooltipRUID.Can[index] = {
        ruid = ___MOD.__RUIDManager:get(___MOD.string.format("UI.UIWindow.ToolTip.Equip.Can.%s", index)),
        size = i == 1 and ___MOD.Vector2(6, 14) or ___MOD.Vector2(10, 14)
      }
    end
    self.EquipTooltipRUID.Cannot.reqLEV = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.reqLEV"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Cannot.reqSTR = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.reqSTR"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Cannot.reqDEX = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.reqDEX"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Cannot.reqINT = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.reqINT"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Cannot.reqLUK = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.reqLUK"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Cannot.reqPOP = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.reqPOP"),
      size = ___MOD.FastVector2(90, 14)
    }
    self.EquipTooltipRUID.Cannot.none = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.none"),
      size = ___MOD.FastVector2(10, 5)
    }
    self.EquipTooltipRUID.Cannot.durability = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.durability"),
      size = ___MOD.FastVector2(124, 14)
    }
    self.EquipTooltipRUID.Cannot.percent = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.Cannot.percent"),
      size = ___MOD.FastVector2(10, 14)
    }
    for i = 0, 9 do
      local index = ___MOD.tostring(i)
      self.EquipTooltipRUID.Cannot[index] = {
        ruid = ___MOD.__RUIDManager:get(___MOD.string.format("UI.UIWindow.ToolTip.Equip.Cannot.%s", index)),
        size = i == 1 and ___MOD.FastVector2(6, 14) or ___MOD.FastVector2(10, 14)
      }
    end
    self.EquipTooltipRUID.GrowthEnabled.itemLEV = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthEnabled.itemLEV"),
      size = ___MOD.FastVector2(98, 14)
    }
    self.EquipTooltipRUID.GrowthEnabled.itemEXP = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthEnabled.itemEXP"),
      size = ___MOD.FastVector2(98, 14)
    }
    self.EquipTooltipRUID.GrowthEnabled.none = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthEnabled.none"),
      size = ___MOD.FastVector2(10, 5)
    }
    self.EquipTooltipRUID.GrowthEnabled.durability = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthEnabled.durability"),
      size = ___MOD.FastVector2(124, 14)
    }
    self.EquipTooltipRUID.GrowthEnabled.percent = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthEnabled.percent"),
      size = ___MOD.FastVector2(10, 14)
    }
    for i = 0, 9 do
      local index = ___MOD.tostring(i)
      self.EquipTooltipRUID.GrowthEnabled[index] = {
        ruid = ___MOD.__RUIDManager:get(___MOD.string.format("UI.UIWindow.ToolTip.Equip.GrowthEnabled.%s", index)),
        size = i == 1 and ___MOD.FastVector2(6, 14) or ___MOD.FastVector2(10, 14)
      }
    end
    self.EquipTooltipRUID.GrowthDisabled.itemLEV = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthDisabled.itemLEV"),
      size = ___MOD.FastVector2(98, 14)
    }
    self.EquipTooltipRUID.GrowthDisabled.itemEXP = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthDisabled.itemEXP"),
      size = ___MOD.FastVector2(98, 14)
    }
    self.EquipTooltipRUID.GrowthDisabled.none = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthDisabled.none"),
      size = ___MOD.FastVector2(10, 5)
    }
    self.EquipTooltipRUID.GrowthDisabled.durability = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthDisabled.durability"),
      size = ___MOD.FastVector2(124, 14)
    }
    self.EquipTooltipRUID.GrowthDisabled.percent = {
      ruid = ___MOD.__RUIDManager:get("UI.UIWindow.ToolTip.Equip.GrowthDisabled.percent"),
      size = ___MOD.FastVector2(10, 14)
    }
    for i = 0, 9 do
      local index = ___MOD.tostring(i)
      self.EquipTooltipRUID.GrowthDisabled[index] = {
        ruid = ___MOD.__RUIDManager:get(___MOD.string.format("UI.UIWindow.ToolTip.Equip.GrowthDisabled.%s", index)),
        size = i == 1 and ___MOD.FastVector2(6, 14) or ___MOD.FastVector2(10, 14)
      }
    end
  end

  self._T.loadTimer = ___MOD._TimerService:SetTimerRepeat(function()
    loadRUID()
  end, 1)
end

function UIItemTooltip.refreshSkillTooltipDivider(self, base)
  if not ___MOD.isvalid(base) then
    return
  end
  local skillLevelText = base:GetChildByName("skillLevelText", true)
  if not ___MOD.isvalid(skillLevelText) or not ___MOD.isvalid(skillLevelText.LineGUIRendererComponent) then
    return
  end
  local baseTr = base.UITransformComponent
  local textTr = skillLevelText.UITransformComponent
  if not ___MOD.isvalid(baseTr) or not ___MOD.isvalid(textTr) then
    return
  end
  local baseW = baseTr.RectSize.x or 0
  local textH = textTr.RectSize.y or 0
  if baseW <= 0 or textH <= 0 then
    return
  end
  local line = skillLevelText.LineGUIRendererComponent
  local lineY = textH / 2 - 12
  local leftP = ___MOD.LinePoint(___MOD.FastVector2(-(baseW / 2) + 20, lineY), ___MOD.FastColor.white, 15)
  local rightP = ___MOD.LinePoint(___MOD.FastVector2(baseW / 2 - 20, lineY), ___MOD.FastColor.white, 15)
  ___MOD.pcall(function()
    line.Points[1] = leftP
    line.Points[2] = rightP
  end)
end

function UIItemTooltip.refreshSkillTooltipDividerDeferred(self, base)
  if not ___MOD.isvalid(base) then
    return
  end
  self:refreshSkillTooltipDivider(base)
  ___MOD._UpdateManager:insertUpdateCallback(function()
    self:refreshSkillTooltipDivider(base)
  end, 1)
  ___MOD._UpdateManager:insertUpdateCallback(function()
    self:refreshSkillTooltipDivider(base)
  end, 2)
end

function UIItemTooltip.renderDigitSprite(self, reqName, value, can, startPos, parent)
  local emptySprite = self.emptySprite
  local maxPoolSize = 3
  local str = ___MOD.tostring(value)
  local digits = {}
  for i = 1, #str do
    local ch = str:sub(i, i)
    digits[i] = ch
  end
  local nextX = startPos.x
  local digit, getSize
  if self:getBaseEntity("equip", "base") == nil then
    for i = 1, maxPoolSize do
      digit = ___MOD._SpawnService:SpawnByEntity(emptySprite, reqName .. "_digit_" .. i, ___MOD.Vector3.zero, parent)
      digit.UITransformComponent.Pivot.x = 0
      digit.UITransformComponent.Pivot.y = 1
      digit.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      digit.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
      digit.UITransformComponent.anchoredPosition.y = startPos.y
      digit.UITransformComponent.Scale = ___MOD.FastVector3(1.02, 1.02, 1)
      self.baseEntities.equip[reqName .. "_digit_" .. i] = digit
    end
  end
  for i, v in ___MOD.ipairs(digits) do
    digit = self.baseEntities.equip[reqName .. "_digit_" .. i]
    digit.SpriteGUIRendererComponent.ImageRUID = self:getRequireRUID(v, can)
    getSize = self:getSizeRequireRUID(v, can)
    digit.UITransformComponent.RectSize = getSize
    digit.UITransformComponent.anchoredPosition.x = nextX
    digit.UITransformComponent.anchoredPosition.y = startPos.y
    digit.UITransformComponent.Scale = ___MOD.FastVector3(1.02, 1.02, 1)
    digit:SetVisible(true)
    nextX = nextX + (getSize.x + 1)
  end
  for i = #digits + 1, maxPoolSize do
    digit = self.baseEntities.equip[reqName .. "_digit_" .. i]
    digit:SetVisible(false)
  end
end

function UIItemTooltip.renderRequireJob(self, parent, reqJob)
  local emptyText = self.emptyText
  local job = {
    {
      name = "초보자",
      x = 60,
      job = nil
    },
    {
      name = "전사",
      x = 135,
      job = 1
    },
    {
      name = "마법사",
      x = 210,
      job = 2
    },
    {
      name = "궁수",
      x = 285,
      job = 4
    },
    {
      name = "도적",
      x = 348,
      job = 8
    },
    {
      name = "해적",
      x = 411,
      job = 16
    }
  }
  if self:getBaseEntity("equip", "base") == nil then
    self.baseEntities.equip.jobText = {}
    for i, entry in ___MOD.pairs(job) do
      local jobText = ___MOD._SpawnService:SpawnByEntity(emptyText, "desc", ___MOD.Vector3.zero, parent)
      jobText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
      jobText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
      jobText.UITransformComponent.anchoredPosition.x = entry.x
      jobText:AddComponent(___MOD.BitmapFontRendererComponent)
      jobText:SetVisible(true)
      self.baseEntities.equip.jobText[i] = jobText
    end
  end
  for i, entry in ___MOD.ipairs(job) do
    local isAllowed = false
    if reqJob == 0 then
      isAllowed = true
    elseif entry.job == nil then
      isAllowed = false
    else
      isAllowed = reqJob & entry.job ~= 0
    end
    local jobText = self.baseEntities.equip.jobText[i]
    local font = jobText.BitmapFontRendererComponent
    font:drawTextArg(entry.name, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), isAllowed and ___MOD.FastColor.white or ___MOD.FastColor.red, false, false, ___MOD.FastColor.clear)
  end
end

function UIItemTooltip.renderRequireValues(self, parent, equipInfo)
  local emptySprite = self.emptySprite
  local digits, descText
  local nextY_ = 0
  local first = ___MOD._UserService.LocalPlayer.Player
  local second = ___MOD._UserService.LocalPlayer.PlayerSecondaryAbilityComponent
  local require = {
    {
      name = "reqLEV",
      value = equipInfo.reqLevel,
      can = first.Level >= equipInfo.reqLevel
    },
    {
      name = "reqSTR",
      value = equipInfo.reqSTR,
      can = first.STR + second.STR >= equipInfo.reqSTR
    },
    {
      name = "reqDEX",
      value = equipInfo.reqDEX,
      can = first.DEX + second.DEX >= equipInfo.reqDEX
    },
    {
      name = "reqINT",
      value = equipInfo.reqINT,
      can = first.INT + second.INT >= equipInfo.reqINT
    },
    {
      name = "reqLUK",
      value = equipInfo.reqLUK,
      can = first.LUK + second.LUK >= equipInfo.reqLUK
    },
    {
      name = "reqPOP",
      value = equipInfo.reqPOP,
      can = first.Fame >= equipInfo.reqPOP
    }
  }
  if self:getBaseEntity("equip", "base") == nil then
    for _, entry in ___MOD.ipairs(require) do
      local size = self:getSizeRequireRUID(entry.name, true)
      descText = ___MOD._SpawnService:SpawnByEntity(emptySprite, entry.name, ___MOD.Vector3.zero, parent)
      descText.UITransformComponent.RectSize = size
      descText.UITransformComponent.Pivot.x = 0
      descText.UITransformComponent.Pivot.y = 1
      descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      descText.UITransformComponent.anchoredPosition = ___MOD.Vector2.zero
      descText.UITransformComponent.anchoredPosition.x = 185
      descText.UITransformComponent.anchoredPosition.y = -nextY_
      descText:SetVisible(true)
      self.baseEntities.equip[entry.name] = descText
      nextY_ = nextY_ + (size.y + 10)
    end
  end
  for _, entry in ___MOD.ipairs(require) do
    local reqText = self.baseEntities.equip[entry.name]
    reqText.SpriteGUIRendererComponent.ImageRUID = self:getRequireRUID(entry.name, entry.can)
    local digitStartPos = ___MOD.FastVector2(reqText.UITransformComponent.anchoredPosition.x + self:getSizeRequireRUID(entry.name, entry.can).x + 10, reqText.UITransformComponent.anchoredPosition.y)
    self:renderDigitSprite(entry.name, entry.value, entry.can, digitStartPos, parent)
  end
  local growth = {
    {
      name = "itemLEV",
      value = 0,
      can = true
    },
    {
      name = "itemEXP",
      value = 0,
      can = true
    }
  }
  if self:getBaseEntity("equip", "base") == nil then
    for _, entry in ___MOD.ipairs(growth) do
      local size = self:getSizeGrowthRUID(entry.name, false)
      descText = ___MOD._SpawnService:SpawnByEntity(emptySprite, entry.name, ___MOD.Vector3.zero, parent)
      descText.UITransformComponent.RectSize = size
      descText.UITransformComponent.Pivot.x = 0
      descText.UITransformComponent.Pivot.y = 1
      descText.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      descText.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
      descText.UITransformComponent.anchoredPosition.x = 185
      descText.UITransformComponent.anchoredPosition.y = -nextY_
      descText:SetVisible(true)
      nextY_ = nextY_ + (size.y + 10)
      self.baseEntities.equip[entry.name] = descText
    end
  end
  for _, entry in ___MOD.ipairs(growth) do
    local reqText = self.baseEntities.equip[entry.name]
    reqText.SpriteGUIRendererComponent.ImageRUID = self:getGrowthRUID(entry.name, entry.can)
    local digitStartPos = ___MOD.FastVector2(reqText.UITransformComponent.anchoredPosition.x + self:getSizeGrowthRUID(entry.name, entry.can).x + 10, reqText.UITransformComponent.anchoredPosition.y)
    self:renderDigitSprite(entry.name, entry.value, entry.can, digitStartPos, parent)
  end
end
