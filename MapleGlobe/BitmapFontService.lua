

function BitmapFontService.buildRichMetricsCacheKey(self, text, font, defaultColor, richText, maxLineW, alignment, convertEscapedNewline)
  local c = defaultColor or ___MOD.FastColor.black

  local function toByte(v)
    if v == nil then
      return 0
    end
    return ___MOD.math.floor(v * 255 + 0.5)
  end

  local maxLine = maxLineW or -1
  local align = alignment or 0
  return ___MOD.string.format("%s|%s|%d|%d|%d|%d|%d|%d|%d|%d", font or "", text or "", maxLine, align, richText and 1 or 0, convertEscapedNewline and 1 or 0, toByte(c.r), toByte(c.g), toByte(c.b), toByte(c.a))
end

function BitmapFontService.calcTextMetrics(self, text, font, maxWidth)
  local lineSpacing = 4
  if maxWidth == nil or maxWidth <= 0 then
    maxWidth = 999999
  end
  if text == nil then
    text = ""
  elseif text and (___MOD.string.find(text, "\r", 1, true) ~= nil or ___MOD.string.find(text, "\\r", 1, true) ~= nil or ___MOD.string.find(text, "\\n", 1, true) ~= nil) then
    text, ___MOD._ = text:gsub("\r\n", "\n"):gsub("\n\r", "\n"):gsub("\r", "\n"):gsub("\\r\\n", "\n"):gsub("\\r", "\n"):gsub("\\n", "\n")
  end
  local lines = {}
  local currentLine = {}
  local lineWidth = 0
  local maxLineHeight = 0
  local defaultLineHeight = ___MOD._BitmapFontManager:getGlyphSize(font, 65).y
  if defaultLineHeight == nil then
    defaultLineHeight = 0
  end

  local function pushLine()
    local lineHeight = 0 < maxLineHeight and maxLineHeight or defaultLineHeight
    ___MOD.table.insert(lines, {
      glyphs = currentLine,
      width = lineWidth,
      height = lineHeight
    })
    currentLine = {}
    lineWidth = 0
    maxLineHeight = 0
  end

  for _, cp in ___MOD.utf8.codes(text) do
    if cp == 10 then
      pushLine()
    else
      local glyphSize = ___MOD._BitmapFontManager:getGlyphSize(font, cp)
      if 0 < lineWidth and maxWidth < lineWidth + glyphSize.x then
        pushLine()
      end
      ___MOD.table.insert(currentLine, {codepoint = cp, size = glyphSize})
      lineWidth = lineWidth + glyphSize.x
      maxLineHeight = ___MOD.math.max(maxLineHeight, glyphSize.y)
    end
  end
  if 0 < #currentLine or #lines == 0 then
    pushLine()
  end
  local totalHeight = 0
  local maxLineWidth = 0
  for i, line in ___MOD.ipairs(lines) do
    totalHeight = totalHeight + line.height
    if i < #lines then
      totalHeight = totalHeight + lineSpacing
    end
    if maxLineWidth < line.width then
      maxLineWidth = line.width
    end
  end
  return ___MOD.FastVector2(maxLineWidth, totalHeight)
end

function BitmapFontService.calcTotalWidth(self, text, font, convertEscapedNewline)
  if convertEscapedNewline == nil then
    convertEscapedNewline = true
  end
  if ___MOD.string.find(text, "\r", 1, true) ~= nil then
    text, ___MOD._ = text:gsub("\r\n", "\n"):gsub("\n\r", "\n"):gsub("\r", "\n")
  end
  if convertEscapedNewline and ___MOD.string.find(text, "\\", 1, true) ~= nil then
    text, ___MOD._ = text:gsub("\\r\\n", "\n"):gsub("\\r", "\n"):gsub("\\n", "\n")
  end
  local maxLineWidth = 0
  local lineWidth = 0
  for _, cp in ___MOD.utf8.codes(text) do
    local ch = ___MOD.utf8.char(cp)
    if ch == "\n" then
      if maxLineWidth < lineWidth then
        maxLineWidth = lineWidth
      end
      lineWidth = 0
    else
      local glyphSize = ___MOD._BitmapFontManager:getGlyphSize(font, cp)
      local w = glyphSize.x or 0
      lineWidth = lineWidth + w
    end
  end
  if maxLineWidth < lineWidth then
    maxLineWidth = lineWidth
  end
  return maxLineWidth
end

function BitmapFontService.clearRichMetricsCache(self)
  self.richMetricsCache = {}
  self.richMetricsCacheQueue = {}
  self.richMetricsCacheHead = 1
  self.richMetricsCacheTail = 0
end

function BitmapFontService.colorToHexRRGGBB(self, c)
  local tc = c or ___MOD.FastColor.white

  local function toByte(v)
    if v == nil then
      return 255
    end
    return ___MOD.math.max(0, ___MOD.math.min(255, ___MOD.math.floor(v * 255 + 0.5)))
  end

  return ___MOD.string.format("%02X%02X%02X", toByte(tc.r), toByte(tc.g), toByte(tc.b))
end

function BitmapFontService.convertLegacyRichToMSW(self, text, defaultColor, convertEscapedNewline, playerEntity)
  text = self:normalizeRichSourceText(text, convertEscapedNewline)
  if text == "" then
    return ""
  end
  local out = {}
  local len = #text
  local i = 1
  local colorOpened = false
  local boldOpened = false
  local yAutoBoldOpened = false
  local orangeHex = "FFAC30"
  local blueHex = "4D80FF"
  local defaultHex = self:colorToHexRRGGBB(defaultColor or ___MOD.FastColor.white)

  local function append(s)
    if s ~= nil and s ~= "" then
      out[#out + 1] = s
    end
  end

  local function closeColor()
    if colorOpened then
      append("</color>")
      colorOpened = false
    end
  end

  local function openColor(hex)
    closeColor()
    append("<color=#" .. ___MOD.tostring(hex or defaultHex) .. ">")
    colorOpened = true
  end

  local function closeBold()
    if boldOpened then
      append("</b>")
      boldOpened = false
    end
    yAutoBoldOpened = false
  end

  local function closeYAutoBold()
    if yAutoBoldOpened then
      closeBold()
    end
  end

  while len >= i do
    local ch = text:sub(i, i)
    if ch == "\n" then
      append("<br>")
      i = i + 1
    elseif ch ~= "#" then
      local cp = ___MOD.utf8.codepoint(text, i)
      local j = ___MOD.utf8.offset(text, 2, i) or len + 1
      if cp ~= nil then
        append(___MOD.utf8.char(cp))
        i = j
      else
        i = i + 1
      end
    else
      local nextCh = text:sub(i + 1, i + 1)
      if nextCh == "" then
        i = i + 1
      elseif nextCh == "b" then
        openColor("0000FF")
        i = i + 2
      elseif nextCh == "r" then
        openColor("FF0000")
        i = i + 2
      elseif nextCh == "g" then
        openColor("A0C24A")
        i = i + 2
      elseif nextCh == "d" then
        openColor("FF00FF")
        i = i + 2
      elseif nextCh == "k" then
        closeColor()
        closeYAutoBold()
        i = i + 2
      elseif nextCh == "e" then
        if not boldOpened then
          append("<b>")
          boldOpened = true
        end
        i = i + 2
      elseif nextCh == "n" then
        closeBold()
        i = i + 2
      elseif nextCh == "C" then
        local s = text:sub(i)
        local hex, endIdx = s:match("^#C([%x][%x][%x][%x][%x][%x][%x][%x])()")
        if hex == nil then
          hex, endIdx = s:match("^#C([%x][%x][%x][%x][%x][%x])()")
        end
        if hex ~= nil then
          openColor(#hex == 8 and hex:sub(1, 6) or hex)
          i = i + endIdx - 1
        else
          append("#")
          i = i + 1
        end
      elseif nextCh == "Y" then
        openColor("ffcc00")
        if not boldOpened then
          append("<b>")
          boldOpened = true
          yAutoBoldOpened = true
        else
          yAutoBoldOpened = false
        end
        i = i + 2
      elseif nextCh == "c" then
        local s = text:sub(i)
        local numPart, _, endIdx = s:match("^#c%s*(%d+)%s*:?([^#]*)#()")
        if numPart ~= nil and #numPart == 7 then
          local itemCount = 0
          local p = playerEntity
          if not ___MOD.isvalid(p) then
            p = ___MOD._UserService.LocalPlayer
          end
          if ___MOD.isvalid(p) and ___MOD.isvalid(p.CInventoryComponent) then
            itemCount = ___MOD.tonumber(p.CInventoryComponent:getItemCount(___MOD.tonumber(numPart))) or 0
          end
          append("<color=#" .. blueHex .. ">" .. ___MOD.tostring(itemCount) .. "</color>")
          i = i + endIdx - 1
        else
          openColor(orangeHex)
          i = i + 2
        end
      elseif nextCh == "L" then
        local s = text:sub(i)
        local _, endIdx = s:match("^#L(%d+)#()")
        if endIdx ~= nil then
          i = i + endIdx - 1
        else
          append("#")
          i = i + 1
        end
      elseif nextCh == "l" then
        i = i + 2
      elseif nextCh == "f" or nextCh == "i" or nextCh == "v" or nextCh == "s" or nextCh == "W" then
        local s = text:sub(i)
        local _, endIdx = s:match("^#" .. nextCh .. "(.-)#()")
        if endIdx ~= nil then
          i = i + endIdx - 1
        else
          append("#")
          i = i + 1
        end
      elseif nextCh == "z" or nextCh == "t" or nextCh == "m" or nextCh == "q" or nextCh == "o" or nextCh == "p" then
        local s = text:sub(i)
        local value, _, endIdx = s:match("^#" .. nextCh .. "(%d+)([^#]*)#()")
        if value ~= nil then
          append(self:resolveLegacyRichDynamicText(nextCh, value, playerEntity))
          i = i + endIdx - 1
        else
          append("#")
          i = i + 1
        end
      elseif nextCh == "h" then
        local s = text:sub(i)
        if s:find("^#h#") ~= nil then
          append(self:resolveLegacyRichDynamicText("h", "", playerEntity))
          i = i + 3
        elseif s:find("^#h #") ~= nil then
          append(self:resolveLegacyRichDynamicText("h", "", playerEntity))
          i = i + 4
        elseif s:find("^#h0#") ~= nil then
          append(self:resolveLegacyRichDynamicText("h", "", playerEntity))
          i = i + 4
        else
          append("#")
          i = i + 1
        end
      else
        closeColor()
        closeYAutoBold()
        i = i + 1
      end
    end
  end
  closeColor()
  closeBold()
  return ___MOD.table.concat(out)
end

function BitmapFontService.getOffset(self, alignment, contentW, lineW)
  if alignment == 1 then
    return (contentW - lineW) * 0.5
  elseif alignment == 2 then
    return contentW - lineW
  else
    return 0
  end
end

function BitmapFontService.getRichMetricsCached(self, text, font, defaultColor, richText, maxLineW, lineGap, alignment, convertEscapedNewline, startPos)
  text = text or ""
  font = font or ___MOD._BitmapFontType.Gulim9pt
  defaultColor = defaultColor or ___MOD.FastColor.black
  if richText == nil then
    richText = false
  end
  if lineGap == nil then
    lineGap = 6
  end
  if alignment == nil then
    alignment = 0
  end
  if convertEscapedNewline == nil then
    convertEscapedNewline = true
  end
  startPos = startPos or ___MOD.FastVector2.zero:Clone()
  local cacheKey = self:buildRichMetricsCacheKey(text, font, defaultColor, richText, maxLineW, alignment, convertEscapedNewline)
  local cached = self.richMetricsCache[cacheKey]
  if cached ~= nil then
    return cached
  end
  local tokens = self:tokenizeRich(text, defaultColor, richText, convertEscapedNewline)
  local info = self:measureRich(tokens, font, startPos, maxLineW, lineGap, alignment)
  if info.hasFallbackGlyph == true then
    return {tokens = tokens, info = info}
  end
  cached = {tokens = tokens, info = info}
  self.richMetricsCache[cacheKey] = cached
  local tail = self.richMetricsCacheTail + 1
  self.richMetricsCacheTail = tail
  self.richMetricsCacheQueue[tail] = cacheKey
  if tail - self.richMetricsCacheHead + 1 > self.richMetricsCacheLimit then
    local oldHead = self.richMetricsCacheHead
    local oldKey = self.richMetricsCacheQueue[oldHead]
    self.richMetricsCacheQueue[oldHead] = nil
    self.richMetricsCacheHead = oldHead + 1
    if oldKey ~= nil and oldKey ~= cacheKey then
      self.richMetricsCache[oldKey] = nil
    end
  end
  return cached
end

function BitmapFontService.isQuestAlramDataContentEntity(self, parent)
  if not ___MOD.isvalid(parent) or parent.Name ~= "content" then
    return false
  end
  local dataEntity = parent.Parent
  local center = ___MOD.isvalid(dataEntity) and dataEntity.Parent or nil
  local questAlram = ___MOD.isvalid(center) and center.Parent or nil
  return ___MOD.isvalid(dataEntity) and ___MOD.string.find(dataEntity.Name or "", "data", 1, true) == 1 and ___MOD.isvalid(center) and center.Name == "center" and ___MOD.isvalid(questAlram) and questAlram.Name == "QuestAlram"
end

function BitmapFontService.measureRich(self, tokens, font, startPos, maxLineW, lineGap, alignment)
  if maxLineW and maxLineW <= 0 then
    maxLineW = nil
  end
  local bold = false
  local hadFallbackGlyph = false
  local lineW, lineH = 0, 0
  local maxW, totalH = 0, 0
  local lines = {}

  local function pushLine()
    lines[#lines + 1] = {
      width = lineW,
      height = 0 < lineH and lineH or 24
    }
    maxW = ___MOD.math.max(maxW, 0 < lineW and lineW or 6)
    lineW, lineH = 0, 0
  end

  for _, t in ___MOD.ipairs(tokens) do
    local tp = t.tp
    if tp == "g" then
      local curFont = bold and font .. "_bold" or font
      local sz = ___MOD._BitmapFontManager:getGlyphSize(curFont, t.cp)
      local gw, gh
      if sz[1] <= 0 or 0 >= sz[2] then
        gw, gh = 6, 14
        hadFallbackGlyph = true
      else
        gw, gh = sz[1], sz[2]
      end
      t.gw, t.gh = gw, gh
      if maxLineW and maxLineW <= lineW + gw then
        pushLine()
      end
      lineW = lineW + gw
      if lineH < gh then
        lineH = gh or lineH
      end
    elseif tp == "nl" then
      pushLine()
    elseif tp == "pushbold" then
      bold = true
    elseif tp == "popbold" then
      bold = false
    end
  end
  pushLine()
  if #lines == 0 then
    lines[1] = {width = 0, height = 0}
  end
  for _, l in ___MOD.ipairs(lines) do
    totalH = totalH + l.height
  end
  if 1 < #lines then
    totalH = totalH + lineGap * (#lines - 1)
  end
  return {
    lineCnt = #lines,
    contentW = maxLineW and maxLineW or maxW,
    actualW = maxW,
    contentH = totalH,
    lines = lines,
    hasFallbackGlyph = hadFallbackGlyph
  }
end

function BitmapFontService.measureRichWithSelect(self, playerEntity, tokens, font, maxLineW, lineGap, alignment, startPos, defaultColor)
  local itemNameCache = self.itemNameCache or {}
  if self._T.iconSizeCache == nil then
    self._T.iconSizeCache = {}
  end
  local iconSizeCache = self._T.iconSizeCache
  local lines = {}
  local layoutInfo = {}
  local lineHeightInfo = {}
  local lineMaxHeight = {}
  local lineW, lineH, maxW, glyphCount = 0, 0, 0, 0
  local bold = false
  local baseColor = defaultColor or ___MOD.FastColor.black
  local color = baseColor
  local selectMode = false
  local lineIdx = 1
  local hasMenu = false
  local hasItem = false
  local menuIdx = 0
  local curLineTokens = {}
  local firstMenu = true
  local menuWidth = 0
  local menuStartPos = 0
  local bfm = ___MOD._BitmapFontManager
  local strPool = ___MOD._StringPoolManager

  local function readIconSize(ruid, rawSize, defaultW, defaultH)
    local w = defaultW or 24
    local h = defaultH or 24
    if rawSize ~= nil and rawSize.x ~= nil and rawSize.y ~= nil then
      w = ___MOD.tonumber(rawSize.x) or w
      h = ___MOD.tonumber(rawSize.y) or h
      if ruid ~= nil and ruid ~= "" then
        iconSizeCache[ruid] = {w = w, h = h}
      end
      return w, h
    end
    if ruid ~= nil and ruid ~= "" then
      local cached = iconSizeCache[ruid]
      if cached ~= nil then
        return cached.w, cached.h
      end
    end
    if ruid ~= nil and ruid ~= "" then
      iconSizeCache[ruid] = {w = w, h = h}
    end
    return w, h
  end

  local function closeSelectForCurrentLine()
    if selectMode then
      layoutInfo[#layoutInfo + 1] = {
        type = "underline",
        line = lineIdx,
        xOffset = menuStartPos,
        width = menuWidth,
        firstMenu = firstMenu,
        hasItem = hasItem
      }
      firstMenu = false
      selectMode = false
      menuWidth = 0
    end
  end

  local function pushLine()
    closeSelectForCurrentLine()
    local h
    if lineW == 0 and #curLineTokens == 0 then
      h = 24
    else
      h = ___MOD.math.max(lineH + 4, 24)
    end
    lines[#lines + 1] = {
      width = lineW,
      height = h,
      hasMenu = hasMenu,
      tokens = curLineTokens
    }
    lineMaxHeight[#lines] = h
    maxW = ___MOD.math.max(maxW, lineW)
    lineW, lineH = 0, 0
    hasMenu = false
    hasItem = false
    lineIdx = lineIdx + 1
    curLineTokens = {}
  end

  for _, t in ___MOD.ipairs(tokens) do
    local tp = t.tp
    if tp == "select" then
      if selectMode then
        closeSelectForCurrentLine()
      end
      selectMode = true
      hasMenu = true
      lineW = lineW + 38
      layoutInfo[#layoutInfo + 1] = {
        type = "dot",
        line = lineIdx,
        xOffset = lineW - 12,
        menuIdx = menuIdx,
        menuStr = t.v
      }
      menuIdx = menuIdx + 1
      menuWidth = 0
      menuStartPos = lineW
    elseif tp == "selectEnd" then
      if selectMode then
        layoutInfo[#layoutInfo + 1] = {
          type = "underline",
          line = lineIdx,
          xOffset = menuStartPos,
          width = menuWidth,
          firstMenu = firstMenu,
          hasItem = hasItem
        }
        firstMenu = false
        selectMode = false
        menuWidth = 0
      end
    elseif tp == "item" then
      local item = ___MOD._ItemManager:getItemById(___MOD.tonumber(t.itemID))
      if t.itemID // 1000000 == 1 then
        item = ___MOD._EquipManager:getItemById(___MOD.tonumber(t.itemID))
      end
      if ___MOD.isvalid(item) then
        local itemRUID = item.icon
        if ___MOD.isvalid(itemRUID) then
          local rawSize = item.iconSize
          local itemWidth, itemHeight = readIconSize(itemRUID, rawSize, 24, 24)
          if selectMode then
            menuWidth = menuWidth + itemWidth
          end
          layoutInfo[#layoutInfo + 1] = {
            type = "item",
            line = lineIdx,
            xOffset = lineW,
            width = itemWidth,
            height = itemHeight,
            ruid = itemRUID,
            itemID = t.itemID,
            tooltip = t.tooltip
          }
          hasItem = true
          lineW = lineW + (itemWidth + 4)
          lineH = ___MOD.math.max(lineH, itemHeight)
        end
      end
    elseif tp == "npcName" then
      local npcID = t.npcID
      local npcName = strPool:getStringPool(___MOD.string.format("Npc.img/%d/name", npcID))
      for _, cp in ___MOD.utf8.codes(npcName) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = color,
          selectMode = selectMode,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "mobName" then
      local mobID = t.mobID
      local mobName = strPool:getStringPool(___MOD.string.format("Mob.img/%d/name", mobID))
      for _, cp in ___MOD.utf8.codes(mobName) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = color,
          selectMode = selectMode,
          hasItem = hasItem,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "mapName" then
      local mapID = t.mapID
      local mapName = ___MOD._MapUtils:getMapNameById(mapID)
      for _, cp in ___MOD.utf8.codes(mapName) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = color,
          selectMode = selectMode,
          hasItem = hasItem,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "skillName" then
      local skillID = t.skillID
      local skillname = strPool:getStringPool(___MOD.string.format("Skill.img/%07d/name", skillID))
      for _, cp in ___MOD.utf8.codes(skillname) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = color,
          selectMode = selectMode,
          hasItem = hasItem,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "skillIcon" then
      local skill = ___MOD._SkillManager:getSkill(___MOD.tonumber(t.skillID))
      local skillRUID = skill and skill.icon or nil
      if skillRUID ~= nil then
        local iconWidth, iconHeight = readIconSize(skillRUID, skill.iconSize, 24, 24)
        if selectMode then
          menuWidth = menuWidth + iconWidth
        end
        if maxLineW and maxLineW <= lineW + iconWidth then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "image",
          line = lineIdx,
          xOffset = lineW,
          width = iconWidth,
          height = iconHeight,
          ruid = skillRUID,
          path = "skill_" .. ___MOD.tostring(t.skillID)
        }
        hasItem = true
        lineW = lineW + (iconWidth + 4)
        lineH = ___MOD.math.max(lineH, iconHeight)
        t.gw = iconWidth + 4
        t.height = iconHeight
      end
    elseif tp == "nickName" then
      local name = playerEntity.Player.Name
      for _, cp in ___MOD.utf8.codes(name) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = color,
          selectMode = selectMode,
          hasItem = hasItem,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "questName" then
      local questInfo = ___MOD._QuestManager:getQuestInfoByQuestID(t.questID)
      local questName = questInfo and questInfo.name or ""
      for _, cp in ___MOD.utf8.codes(questName) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = color,
          selectMode = selectMode,
          hasItem = hasItem,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "questState" then
      local qc = playerEntity.QuestComponent
      local stateText = ""
      if ___MOD.isvalid(qc) then
        local st = qc:getQuestState(t.questID)
        if qc:isQuestStateMatched(t.questID, ___MOD._QuestStateType.complete) then
          stateText = "완료"
        elseif st == ___MOD._QuestStateType.canStart then
          stateText = "시작안함"
        elseif st == ___MOD._QuestStateType.inProgress then
          stateText = "진행중"
        elseif st == ___MOD._QuestStateType.complete then
          stateText = "완료"
        else
          stateText = ""
        end
      end
      for _, cp in ___MOD.utf8.codes(stateText) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = color,
          selectMode = selectMode,
          hasItem = hasItem,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "qex" then
      local key = t.key
      local value = ""
      if key == "level" then
        local p = ___MOD.isvalid(playerEntity) and playerEntity.Player or nil
        value = ___MOD.tostring(___MOD.isvalid(p) and p.Level or 0)
      else
        local ac = ___MOD.isvalid(playerEntity) and playerEntity.QuestComponent or nil
        if ___MOD.isvalid(ac) then
          value = ac:getQuestEx(ac.qexQuestID, key) or ""
        end
      end
      if value ~= "" then
        for _, cp in ___MOD.utf8.codes(value) do
          local sz = bfm:getGlyphSize("Gulim9pt", cp)
          local gw = 0 < sz.x and sz.x or 6
          if selectMode then
            menuWidth = menuWidth + gw
          end
          local gh = 0 < sz.y and sz.y or 14
          if maxLineW and maxLineW <= lineW + gw then
            pushLine()
          end
          layoutInfo[#layoutInfo + 1] = {
            type = "glyph",
            line = lineIdx,
            xOffset = lineW,
            width = gw,
            height = gh,
            isBold = bold,
            color = color,
            selectMode = selectMode,
            hasItem = hasItem,
            token = {
              cp = cp,
              gw = gw,
              gh = gh
            }
          }
          lineW = lineW + gw
          lineH = ___MOD.math.max(lineH, gh)
          glyphCount = glyphCount + 1
        end
      end
    elseif tp == "questExById" then
      local questID = t.questID
      local qc = ___MOD.isvalid(playerEntity) and playerEntity.QuestComponent or nil
      if ___MOD.isvalid(qc) and questID then
        local value = qc:getQuestEx(questID, "Ex") or ""
        for _, cp in ___MOD.utf8.codes(value) do
          local sz = bfm:getGlyphSize("Gulim9pt", cp)
          local gw = 0 < sz.x and sz.x or 6
          if selectMode then
            menuWidth = menuWidth + gw
          end
          local gh = 0 < sz.y and sz.y or 14
          if maxLineW and maxLineW <= lineW + gw then
            pushLine()
          end
          layoutInfo[#layoutInfo + 1] = {
            type = "glyph",
            line = lineIdx,
            xOffset = lineW,
            width = gw,
            height = gh,
            isBold = bold,
            color = color,
            selectMode = selectMode,
            hasItem = hasItem,
            token = {
              cp = cp,
              gw = gw,
              gh = gh
            }
          }
          lineW = lineW + gw
          lineH = ___MOD.math.max(lineH, gh)
          glyphCount = glyphCount + 1
        end
      end
    elseif tp == "mobCount" then
      local questID = t.questID
      local key = t.key
      local mobCount, needCount = playerEntity.QuestComponent:getMobCountByKey(questID, key)
      mobCount = ___MOD.tonumber(mobCount) or 0
      needCount = ___MOD.tonumber(needCount) or 0
      local mobStr = ___MOD.string.format("%d / %d", mobCount, needCount)
      for _, cp in ___MOD.utf8.codes(mobStr) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = color,
          selectMode = selectMode,
          hasItem = hasItem,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "itemCount" then
      local itemID = t.itemID
      local addMsg = t.addMsg or ""
      local count = playerEntity.CInventoryComponent:getItemCount(itemID)
      for _, cp in ___MOD.utf8.codes(___MOD.tostring(count)) do
        local sz = bfm:getGlyphSize("Gulim9pt", cp)
        local gw = 0 < sz.x and sz.x or 6
        if selectMode then
          menuWidth = menuWidth + gw
        end
        local gh = 0 < sz.y and sz.y or 14
        if maxLineW and maxLineW <= lineW + gw then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "glyph",
          line = lineIdx,
          xOffset = lineW,
          width = gw,
          height = gh,
          isBold = bold,
          color = ___MOD.FastColor.blue,
          selectMode = selectMode,
          hasItem = hasItem,
          token = {
            cp = cp,
            gw = gw,
            gh = gh
          }
        }
        lineW = lineW + gw
        lineH = ___MOD.math.max(lineH, gh)
        glyphCount = glyphCount + 1
      end
    elseif tp == "w" then
      local word = t.word
      local prob = "UI.UIWindow.Quest.prob"
      local select = "UI.UIWindow.Quest.select"
      local basic = "UI.UIWindow.Quest.basic"
      local reward = "UI.UIWindow.Quest.reward"
      local imageKey, imgRUID
      if word == "prob" then
        imageKey = prob
      elseif word == "select" then
        imageKey = select
      elseif word == "basic" then
        imageKey = basic
      elseif word == "reward" then
        imageKey = reward
      end
      if imageKey then
        imgRUID = ___MOD.__RUIDManager:get(imageKey)
      end
      if imgRUID then
        local imgSize = ___MOD._UIManager:getImageSize(imageKey)
        local imgWidth = imgSize and ___MOD.tonumber(imgSize.x) or 24
        local imgHeight = imgSize and ___MOD.tonumber(imgSize.y) or 24
        if maxLineW and maxLineW <= lineW + imgWidth then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "image",
          line = lineIdx,
          xOffset = lineW,
          width = imgWidth,
          height = imgHeight,
          ruid = imgRUID,
          path = imageKey
        }
        lineW = lineW + imgWidth
        lineH = ___MOD.math.max(lineH, imgHeight)
        t.height = imgHeight
        t.gw = imgWidth
        curLineTokens[#curLineTokens + 1] = t
      end
    elseif tp == "itemName" then
      local itemID = t.itemID
      local itemName = ___MOD._StringPoolManager:getItemName(itemID)
      local addMsg = t.addMsg or ""
      local totalText = itemName .. addMsg
      if ___MOD.isvalid(totalText) and 0 < #totalText then
        for _, cp in ___MOD.utf8.codes(totalText) do
          local sz = bfm:getGlyphSize("Gulim9pt", cp)
          local gw = 0 < sz.x and sz.x or 6
          if selectMode then
            menuWidth = menuWidth + gw
          end
          local gh = 0 < sz.y and sz.y or 14
          if maxLineW and maxLineW <= lineW + gw then
            pushLine()
          end
          layoutInfo[#layoutInfo + 1] = {
            type = "glyph",
            line = lineIdx,
            xOffset = lineW,
            width = gw,
            height = gh,
            isBold = bold,
            color = color,
            selectMode = selectMode,
            tooltip = t.tooltip,
            tooltipType = itemID // 1000000 == 1 and ___MOD._TooltipType.EQUIP or ___MOD._TooltipType.INVENTORY,
            itemID = itemID,
            hasItem = hasItem,
            token = {
              cp = cp,
              gw = gw,
              gh = gh
            }
          }
          lineW = lineW + gw
          lineH = ___MOD.math.max(lineH, gh)
          glyphCount = glyphCount + 1
        end
        lineW = lineW + 4
      end
    elseif tp == "image" then
      local imgRUID = ___MOD.__RUIDManager:get(t.path)
      if imgRUID then
        local cached = self._T.spriteSizeCache ~= nil and self._T.spriteSizeCache[t.path] or nil
        local imgWidth, imgHeight
        if cached then
          imgWidth, imgHeight = cached.w, cached.h
        else
          local size = ___MOD._UIManager:getImageSize(t.path)
          local w = size and ___MOD.tonumber(size.x) or 24
          local h = size and ___MOD.tonumber(size.y) or 24
          imgWidth, imgHeight = w, h
          if not self._T.spriteSizeCache then
            self._T.spriteSizeCache = {}
          end
          self._T.spriteSizeCache[t.path] = {w = w, h = h}
        end
        if selectMode then
          menuWidth = menuWidth + imgWidth
        end
        if maxLineW and maxLineW <= lineW + imgWidth then
          pushLine()
        end
        layoutInfo[#layoutInfo + 1] = {
          type = "image",
          line = lineIdx,
          xOffset = lineW,
          width = imgWidth,
          height = imgHeight,
          ruid = imgRUID,
          path = t.path
        }
        lineW = lineW + imgWidth
        lineH = ___MOD.math.max(lineH, imgHeight)
        t.height = imgHeight
        t.gw = imgWidth
        curLineTokens[#curLineTokens + 1] = t
      end
    elseif tp == "pushbold" then
      bold = true
    elseif tp == "popbold" then
      bold = false
    elseif tp == "pushclr" then
      color = t.v
    elseif tp == "popclr" then
      color = baseColor
    elseif tp == "nl" then
      closeSelectForCurrentLine()
      pushLine()
    elseif tp == "g" then
      local curFont = bold and font .. "_bold" or font
      local sz = bfm:getGlyphSize(curFont, t.cp)
      local gw = 0 < sz.x and sz.x or 6
      local gh = 0 < sz.y and sz.y or 14
      t.gw, t.gh = gw, gh
      if selectMode then
        menuWidth = menuWidth + gw
      end
      if maxLineW and maxLineW <= lineW + gw then
        pushLine()
      end
      layoutInfo[#layoutInfo + 1] = {
        type = "glyph",
        line = lineIdx,
        xOffset = lineW,
        width = gw,
        height = gh,
        isBold = bold,
        color = color,
        selectMode = selectMode,
        hasItem = hasItem,
        token = t
      }
      lineW = lineW + gw
      lineH = ___MOD.math.max(lineH, gh)
      curLineTokens[#curLineTokens + 1] = t
      glyphCount = glyphCount + 1
    end
  end
  pushLine()
  for i, l in ___MOD.ipairs(lines) do
    lineHeightInfo[i] = l.height + (l.hasMenu and 4 or 0) + lineGap
  end
  return {
    lineHeightInfo = lineHeightInfo,
    layoutInfo = layoutInfo,
    lines = lines,
    contentW = maxW,
    contentH = 0,
    lineMaxHeight = lineMaxHeight,
    lineTokens = lines,
    glyphCount = glyphCount
  }
end

function BitmapFontService.normalizeRichSourceText(self, text, convertEscapedNewline)
  if ___MOD.type(text) ~= "string" or text == "" then
    return ""
  end
  if convertEscapedNewline == nil then
    convertEscapedNewline = true
  end
  if ___MOD.string.find(text, "\r", 1, true) ~= nil then
    text, ___MOD._ = text:gsub("\r\n", "\n"):gsub("\n\r", "\n"):gsub("\r", "\n")
  end
  if convertEscapedNewline and ___MOD.string.find(text, "\\", 1, true) ~= nil then
    text, ___MOD._ = text:gsub("\\r\\n", "\n"):gsub("\\r", "\n"):gsub("\\n", "\n")
  end
  return text
end

function BitmapFontService.OnBeginPlay(self)
  self.emptyGlyph = ___MOD._EntityService:GetEntity("b01f1092-457d-4d09-a7fb-61f3e20b7a3d")
end

function BitmapFontService.renderBitmapText(self, parent, text, font, startPos, color, minimap, outline, outlineColor, richText, maxLineWidth, alignmentType, tokens)
  local emptyGlyph = self.emptyGlyph
  local glyphPool = parent.BitmapFontRendererComponent.glyphPool
  local glyphPoolSize = #glyphPool
  local need = ___MOD.utf8.len(text)
  for i = glyphPoolSize + 1, need do
    local ent = ___MOD._SpawnService:SpawnByEntity(emptyGlyph, "glyph", ___MOD.FastVector3.zero:Clone(), parent)
    local tr = ent and ent.UITransformComponent or nil
    if not ___MOD.isvalid(tr) then
      if ___MOD.isvalid(ent) then
        ent:Destroy()
      end
    else
      tr.Pivot, tr.AlignmentOption = ___MOD.FastVector2(0, 1), ___MOD.AlignmentType.TopLeft
      glyphPool[i] = ent
    end
  end
  tokens = tokens and tokens or self:tokenizeRich(text, color, richText, true)
  local toColor = color
  local colorStack = {}
  local bold = false
  local x, y = startPos.x, startPos.y
  local idx = 1
  local curLineMax, totalH, lineIndex, maxW = 0, 0, 0, 0
  local LINE_GAP = 6
  local lines = {}
  local lineStartIdx = 1
  local lineWidth = 0

  local function pushColor(c)
    colorStack[#colorStack + 1] = toColor
    toColor = c
  end

  local function popColor()
    if 0 < #colorStack then
      toColor = colorStack[#colorStack]
      colorStack[#colorStack] = nil
    else
      toColor = color
    end
  end

  local function pushLineInfo()
    lines[#lines + 1] = {startIdx = lineStartIdx, width = lineWidth}
    lineStartIdx, lineWidth = idx, 0
  end

  local function newline()
    pushLineInfo()
    totalH = totalH + curLineMax
    curLineMax = 0
    lineIndex = lineIndex + 1
    y = startPos.y - totalH - LINE_GAP * lineIndex
    x = startPos.x
  end

  for _, t in ___MOD.ipairs(tokens) do
    local tp = t.tp
    if tp == "g" then
      local curFont = bold and font .. "_bold" or font
      local ruid = ___MOD._BitmapFontManager:getGlyphRUID(curFont, t.cp)
      local gSize = ___MOD._BitmapFontManager:getGlyphSize(curFont, t.cp)
      if maxLineWidth and maxLineWidth < x - startPos.x + gSize.x then
        newline()
      end
      local ent = glyphPool[idx]
      idx = idx + 1
      local spr = ent.SpriteGUIRendererComponent
      local tr = ent.UITransformComponent
      spr.ImageRUID = ruid
      spr.Color = toColor
      spr.Outline = outline
      if outline then
        spr.OutlineColor, spr.OutlineWidth = outlineColor, 2
      end
      spr.DropShadow = minimap
      if minimap then
        spr.DropShadowAngle, spr.DropShadowColor, spr.DropShadowDistance = 120, ___MOD.FastColor.black, 2
      end
      tr.RectSize = gSize
      tr.anchoredPosition = ___MOD.FastVector2(x, y)
      ent:SetVisible(true)
      curLineMax = ___MOD.math.max(curLineMax, gSize.y)
      x = x + gSize.x
      maxW = ___MOD.math.max(maxW, x - startPos.x)
      lineWidth = lineWidth + gSize.x
    elseif tp == "pushclr" then
      pushColor(t.v)
    elseif tp == "popclr" then
      popColor()
    elseif tp == "pushbold" then
      bold = true
    elseif tp == "popbold" then
      bold = false
    elseif tp == "nl" then
      newline()
    end
  end
  pushLineInfo()
  local contentH = totalH + curLineMax + LINE_GAP * lineIndex
  local contentW = maxLineWidth and 0 < maxLineWidth and maxLineWidth or maxW
  parent.UITransformComponent.RectSize = ___MOD.FastVector2(contentW, contentH)
  if alignmentType == 1 or alignmentType == 2 then
    for i, ln in ___MOD.ipairs(lines) do
      local offset
      if alignmentType == 1 then
        offset = (contentW - ln.width) * 0.5
      else
        offset = contentW - ln.width
      end
      if 0 < offset then
        local nextStart = lines[i + 1] and lines[i + 1].startIdx or idx
        for j = ln.startIdx, nextStart - 1 do
          local tr = glyphPool[j].UITransformComponent
          tr.anchoredPosition = ___MOD.FastVector2(tr.anchoredPosition.x + offset, tr.anchoredPosition.y)
        end
      end
    end
  end
  for i = idx, #glyphPool do
    glyphPool[i]:SetVisible(false)
  end
  parent:SetVisible(true)
end

function BitmapFontService.renderBitmapText_World(self, parent, text, font, startPos, color, maxWidth, sortingLayer, orderInLayer, alignmentType, applyBaseYOffset, legacyWorldLayout)
  local com = parent.BitmapFontRendererComponent
  local glyphPool = com.glyphPool
  local glyphPoolIndex = 1
  local startPos_ = ___MOD.FastVector2(startPos.x, startPos.y)
  local base = parent
  local baseY = 0
  local ruid, ent, sprite, transform
  local toColor = color
  local position
  local lineSpacing = 4
  if alignmentType == nil then
    alignmentType = 1
  end
  if applyBaseYOffset == nil then
    applyBaseYOffset = true
  end
  if legacyWorldLayout == nil then
    legacyWorldLayout = true
  end
  if maxWidth == nil or maxWidth <= 0 then
    maxWidth = 999999
  end
  if (not legacyWorldLayout or not applyBaseYOffset) and text and (___MOD.string.find(text, "\r", 1, true) ~= nil or ___MOD.string.find(text, "\\r", 1, true) ~= nil or ___MOD.string.find(text, "\\n", 1, true) ~= nil) then
    text, ___MOD._ = text:gsub("\r\n", "\n"):gsub("\n\r", "\n"):gsub("\r", "\n"):gsub("\\r\\n", "\n"):gsub("\\r", "\n"):gsub("\\n", "\n")
  end
  local glyphPoolMaxSize = ___MOD.utf8.len(text)
  local glyphPoolSize = #glyphPool
  if glyphPoolMaxSize > glyphPoolSize then
    for i = glyphPoolSize + 1, glyphPoolMaxSize do
      ent = ___MOD._SpawnService:SpawnByModelId("model://c498a510-463c-4aff-a025-eadf8a04522f", "glyph", ___MOD.FastVector3.zero:Clone(), base)
      transform = ent.TransformComponent
      sprite = ent.SpriteRendererComponent
      glyphPool[i] = ent
    end
  end
  local lines = {}
  local currentLine = {}
  local lineWidth = 0
  local maxLineHeight = 0
  local defaultLineHeight = ___MOD._BitmapFontManager:getGlyphSize(font, 65).y
  if defaultLineHeight == nil then
    defaultLineHeight = 0
  end

  local function pushLine(useDefaultHeight)
    local lineHeight = maxLineHeight
    if useDefaultHeight and lineHeight <= 0 then
      lineHeight = defaultLineHeight
    end
    ___MOD.table.insert(lines, {
      glyphs = currentLine,
      width = lineWidth,
      height = lineHeight
    })
    currentLine = {}
    lineWidth = 0
    maxLineHeight = 0
  end

  if legacyWorldLayout and applyBaseYOffset then
    for _, cp in ___MOD.utf8.codes(text) do
      local glyphSize = ___MOD._BitmapFontManager:getGlyphSize(font, cp)
      if maxWidth < lineWidth + glyphSize.x then
        pushLine(false)
      end
      ___MOD.table.insert(currentLine, {codepoint = cp, size = glyphSize})
      lineWidth = lineWidth + glyphSize.x
      maxLineHeight = ___MOD.math.max(maxLineHeight, glyphSize.y)
    end
    if 0 < #currentLine then
      pushLine(false)
    end
  else
    for _, cp in ___MOD.utf8.codes(text) do
      if cp == 10 then
        pushLine(true)
      else
        local glyphSize = ___MOD._BitmapFontManager:getGlyphSize(font, cp)
        if 0 < lineWidth and maxWidth < lineWidth + glyphSize.x then
          pushLine(true)
        end
        ___MOD.table.insert(currentLine, {codepoint = cp, size = glyphSize})
        lineWidth = lineWidth + glyphSize.x
        maxLineHeight = ___MOD.math.max(maxLineHeight, glyphSize.y)
      end
    end
    if 0 < #currentLine or #lines == 0 then
      pushLine(true)
    end
  end
  local totalHeight = 0
  for i, line in ___MOD.ipairs(lines) do
    totalHeight = totalHeight + line.height
    if i < #lines then
      totalHeight = totalHeight + lineSpacing
    end
  end
  local y = startPos_.y + (applyBaseYOffset and totalHeight * 0.5 or 0)
  local yTop = startPos_.y
  local cp, size
  for _, line in ___MOD.ipairs(lines) do
    local glyphs = line.glyphs
    local totalWidth = line.width
    local lineHeight = line.height
    local x = startPos_.x
    local yLine = applyBaseYOffset and y or yTop - lineHeight * 0.5
    if alignmentType == 1 then
      x = startPos_.x - totalWidth / 2
    elseif alignmentType == 2 then
      x = startPos_.x - totalWidth
    end
    for _, g in ___MOD.ipairs(glyphs) do
      cp = g.codepoint
      size = g.size
      ruid = ___MOD._BitmapFontManager:getGlyphRUID(font, cp)
      ent = glyphPool[glyphPoolIndex]
      if not ___MOD.isvalid(ent) or ent.SpriteRendererComponent == nil or ent.TransformComponent == nil then
        glyphPoolIndex = glyphPoolIndex + 1
      else
        sprite = ent.SpriteRendererComponent
        transform = ent.TransformComponent
        sprite.SpriteRUID = ruid
        sprite.Color = toColor
        if sortingLayer ~= "Default" then
          sprite.SortingLayer = sortingLayer
        end
        if 0 < orderInLayer then
          sprite.OrderInLayer = orderInLayer
        end
        x = x + size.x / 2
        position = transform:PositionAsFastVector3()
        position.x = x * 0.01
        position.y = yLine * 0.01
        transform.Position = position
        ent:SetVisible(true)
        x = x + size.x / 2
        if baseY < size.y then
          baseY = size.y
        end
        glyphPoolIndex = glyphPoolIndex + 1
      end
    end
    if applyBaseYOffset then
      y = y - (lineHeight + lineSpacing)
    else
      yTop = yTop - (lineHeight + lineSpacing)
    end
  end
  for i = glyphPoolIndex, #glyphPool do
    glyphPool[i]:SetVisible(false)
  end
  position = base.TransformComponent:PositionAsFastVector3()
  position.y = applyBaseYOffset and totalHeight * 0.01 * 0.5 or 0
  base.TransformComponent.Position = position
end

function BitmapFontService.renderRich(self, tokens, metrics, parent, text, font, startPos, color, minimap, outline, outlineColor, LINE_GAP, alignment, udc, isUtilDlg)
  if ___MOD.isvalid(udc) and not isUtilDlg and parent then
    if parent.UITransformComponent then
      parent.UITransformComponent.RectSize = ___MOD.FastVector2(metrics.contentW, metrics.contentH)
    end
    udc.canClickMenu = true
    parent:SetVisible(true)
  end
  if ___MOD.type(text) ~= "string" or text == "" then
    local pool = parent.BitmapFontRendererComponent.glyphPool
    for i = 1, #pool do
      if ___MOD.isvalid(pool[i]) then
        pool[i]:SetVisible(false)
      end
    end
    if parent then
      if parent.UITransformComponent then
        parent.UITransformComponent.RectSize = ___MOD.FastVector2.zero:Clone()
      end
      parent:SetVisible(false)
    end
    return
  end
  for k, v in ___MOD.pairs(parent.BitmapFontRendererComponent.garbage) do
    v:Destroy()
  end
  parent.BitmapFontRendererComponent.garbage = {}
  local pool = parent.BitmapFontRendererComponent.glyphPool
  local need = 0
  for _, t in ___MOD.ipairs(tokens) do
    if t.tp == "g" then
      need = need + 1
    end
  end
  for i = 1, need do
    local existing = pool[i]
    if not ___MOD.isvalid(existing) then
      local ent = ___MOD._SpawnService:SpawnByEntity(self.emptyGlyph, "g", ___MOD.FastVector3.zero:Clone(), parent)
      local tr = ent and ent.UITransformComponent or nil
      if not ___MOD.isvalid(tr) and ___MOD.isvalid(ent) then
        ___MOD.pcall(function()
          ent:AddComponent(___MOD.UITransformComponent)
        end)
        tr = ent.UITransformComponent
      end
      if not ___MOD.isvalid(tr) then
        if ___MOD.isvalid(ent) then
          ent:Destroy()
        end
        pool[i] = nil
      else
        tr.Pivot, tr.AlignmentOption = ___MOD.FastVector2(0, 1), ___MOD.AlignmentType.TopLeft
        pool[i] = ent
      end
    end
  end

  local function resetState()
    return {
      idx = 1,
      lineIdx = 1,
      lineW = metrics.lines[1].width,
      lineH = metrics.lines[1].height,
      diff = metrics.contentW - metrics.lines[1].width,
      offset = 0,
      x = 0,
      y = startPos.y,
      remW = metrics.lines[1].width,
      bold = false,
      toColor = color,
      colStack = {},
      selectMode = false,
      menuIdx = 0,
      hasMenu = false,
      menuWidth = 0,
      menuStartPosX = 0,
      menuStartPosY = 0,
      firstMenu = true
    }
  end

  local s = resetState()
  s.offset = alignment == 1 and s.diff * 0.5 or alignment == 2 and s.diff or 0
  s.x = startPos.x + s.offset

  local function renderGlyph(t)
    local ent = pool[s.idx]
    s.idx = s.idx + 1
    if not ___MOD.isvalid(ent) then
      return
    end
    local spr = ent.SpriteGUIRendererComponent
    if not ___MOD.isvalid(spr) then
      return
    end
    local curFont = s.bold and font .. "_bold" or font
    spr.ImageRUID = ___MOD._BitmapFontManager:getGlyphRUID(curFont, t.cp)
    spr.Color = s.toColor
    if outline then
      spr.Outline, spr.OutlineColor, spr.OutlineWidth = true, outlineColor, 1
    end
    if minimap then
      spr.DropShadow, spr.DropShadowAngle = true, 120
      spr.DropShadowColor, spr.DropShadowDistance = ___MOD.FastColor.black, 2
    end
    local tr = ent.TransformComponent
    tr.RectSize = ___MOD.FastVector2(t.gw, t.gh)
    tr.anchoredPosition = ___MOD.FastVector2(s.x, s.y)
    ent:SetVisible(true)
    if s.hasMenu then
      s.menuWidth = s.menuWidth + t.gw
    end
  end

  local function newline()
    s.lineIdx = s.lineIdx + 1
    if not metrics.lines[s.lineIdx] then
      return
    end
    s.lineW = metrics.lines[s.lineIdx].width
    s.diff = metrics.contentW - s.lineW
    s.offset = alignment == 1 and s.diff * 0.5 or alignment == 2 and s.diff or 0
    s.x = startPos.x + s.offset
    s.y = s.y - metrics.lines[s.lineIdx - 1].height - LINE_GAP
    s.remW = s.lineW
    if s.hasMenu then
      s.y = s.y - 4
      s.hasMenu = false
    end
  end

  local function renderImage(t)
    local imgRUID = ___MOD.__RUIDManager:get(t.path)
    if imgRUID then
      local imgSize = ___MOD._UIManager:getImageSize(t.path)
      local imgWidth = imgSize and ___MOD.tonumber(imgSize.x) or 24
      local imgHeight = imgSize and ___MOD.tonumber(imgSize.y) or 24
      local imgEntity = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "img_" .. t.path:gsub("[^%w]", "_"), ___MOD.FastVector3.zero:Clone(), parent)
      imgEntity.SpriteGUIRendererComponent.ImageRUID = imgRUID
      imgEntity.UITransformComponent.RectSize = ___MOD.FastVector2(imgWidth, imgHeight)
      imgEntity.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      imgEntity.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
      imgEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(s.x, s.y)
      imgEntity:SetVisible(true)
      ___MOD.table.insert(parent.BitmapFontRendererComponent.garbage, imgEntity)
      local gw = ___MOD.tonumber(t.gw) or imgWidth or 24
      local remW = ___MOD.tonumber(s.remW) or 0
      if gw > remW then
        newline()
        remW = ___MOD.tonumber(s.remW) or remW
      end
      s.remW = remW - gw
      s.x = s.x + gw
    end
  end

  local function pushColor(c)
    s.colStack[#s.colStack + 1], s.toColor = s.toColor, c
  end

  local function popColor()
    s.toColor = s.colStack[#s.colStack] or color
    s.colStack[#s.colStack] = nil
  end

  local function createDot()
    local dot0 = "4885c0c8d14541e2827656856cebb161"
    local dot1 = "6e9262bdd95c4409b44cde546f77a9ee"
    local type = 0
    if s.menuIdx == 0 then
      type = 1
    end
    s.x = s.x + 20
    local ruid = type == 0 and dot0 or dot1
    local dot = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "dot" .. s.menuIdx, ___MOD.FastVector3.zero:Clone(), parent)
    dot.SpriteGUIRendererComponent.ImageRUID = ruid
    dot.UITransformComponent.RectSize = ___MOD.FastVector2(12, 14)
    dot.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    dot.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    dot.UITransformComponent.anchoredPosition = ___MOD.FastVector2(s.x, s.y - 4)
    dot.Visible = true
    s.startPos = s.x
    s.x = s.x + 14
    s.menuIdx = s.menuIdx + 1
    s.menuStartPosX = s.x
    s.menuStartPosY = s.y
    s.hasMenu = true
    s.menuStr = ""
  end

  local function createMenuUnderline()
    local underbarRUID = "a4522d4f429f453db2d697645697bf59"
    local underbar = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", s.menuStr, ___MOD.FastVector3.zero:Clone(), parent)
    underbar.SpriteGUIRendererComponent.ImageRUID = underbarRUID
    underbar.UITransformComponent.RectSize = ___MOD.FastVector2(s.menuWidth, 26)
    underbar.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    underbar.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
    underbar.SpriteGUIRendererComponent.Type = ___MOD.ImageType.Tiled
    underbar.UITransformComponent.anchoredPosition = ___MOD.FastVector2(s.menuStartPosX, s.menuStartPosY)
    underbar.Visible = true
    if not s.firstMenu then
      underbar.SpriteGUIRendererComponent.Color.a = 0
    else
      underbar.SpriteGUIRendererComponent.Color.a = 1
    end
    underbar:AddComponent(___MOD.UITouchReceiveComponent)
    udc:addMenuEntityList(underbar)
    underbar:ConnectEvent(___MOD.UITouchEnterEvent, function()
      udc:mouseOnMenu(underbar)
    end)
    underbar:ConnectEvent(___MOD.UITouchExitEvent, function()
      udc:mouseOutMenu(underbar)
    end)
    underbar:ConnectEvent(___MOD.UITouchUpEvent, function()
      udc:onMenuClickClient(underbar.Name)
    end)
    s.menuWidth = 0
    s.menuStartPosX = 0
    s.menuStartPosY = 0
    s.firstMenu = false
  end

  for _, t in ___MOD.ipairs(tokens) do
    local tp = t.tp
    if tp == "select" then
      createDot()
      s.menuStr = t.v
      s.selectMode = true
    elseif tp == "selectEnd" then
      s.selectMode = false
      createMenuUnderline()
    elseif tp == "image" then
      renderImage(t)
    elseif tp == "nl" then
      newline()
    elseif tp == "g" then
      if t.gw > s.remW then
        newline()
      end
      s.remW = s.remW - t.gw
      if s.selectMode then
        renderGlyph(t)
      else
        s.idx = s.idx + 1
      end
      s.x = s.x + t.gw
      if outline then
        s.x = s.x + 1
      end
    elseif tp == "pushclr" then
      pushColor(t.v)
    elseif tp == "popclr" then
      popColor()
    elseif tp == "pushbold" then
      s.bold = true
    elseif tp == "popbold" then
      s.bold = false
    end
  end
  ___MOD.table.clear(s)
  s = resetState()
  s.offset = alignment == 1 and s.diff * 0.5 or alignment == 2 and s.diff or 0
  s.x = startPos.x + s.offset
  for _, t in ___MOD.ipairs(tokens) do
    local tp = t.tp
    if tp == "select" then
      s.x = s.x + 50
      s.selectMode = true
      s.hasMenu = true
    elseif tp == "selectEnd" then
      s.selectMode = false
    elseif tp == "image" then
      local gw = ___MOD.tonumber(t.gw) or 24
      if gw > s.remW then
        newline()
      end
      s.remW = s.remW - gw
      s.x = s.x + gw
    elseif tp == "nl" then
      newline()
    elseif tp == "g" then
      if t.gw > s.remW then
        newline()
      end
      s.remW = s.remW - t.gw
      if not s.selectMode then
        renderGlyph(t)
        if ___MOD.isvalid(udc) and not udc.skipTypingEffect then
          ___MOD.wait(0.03)
        end
      else
        s.idx = s.idx + 1
      end
      s.x = s.x + t.gw
      if outline then
        s.x = s.x + 1
      end
    elseif tp == "pushclr" then
      pushColor(t.v)
    elseif tp == "popclr" then
      popColor()
    elseif tp == "pushbold" then
      s.bold = true
    elseif tp == "popbold" then
      s.bold = false
    end
  end
  if udc then
    udc:setEnableNext(true)
  end
  for i = s.idx, #pool do
    if ___MOD.isvalid(pool[i]) then
      pool[i]:SetVisible(false)
    end
  end
  if not udc then
    if not isUtilDlg and parent and parent.UITransformComponent then
      parent.UITransformComponent.RectSize = ___MOD.FastVector2(metrics.contentW, metrics.contentH)
    end
    parent:SetVisible(true)
  end
end

function BitmapFontService.renderRichByCache(self, metrics, parent, font, startPos, color, minimap, outline, outlineColor, LINE_GAP, alignment, udc, isUtilDlg)
  local layoutInfo = metrics.layoutInfo
  local validUDC = ___MOD.isvalid(udc)
  local isQuestAlramContent = self:isQuestAlramDataContentEntity(parent)
  if not isQuestAlramContent then
    parent:SetVisible(false)
  end
  if not isUtilDlg then
    local targetH = metrics.contentH
    if isQuestAlramContent and (targetH == nil or targetH <= 0) and ___MOD.isvalid(parent.UITransformComponent) then
      targetH = parent.UITransformComponent.RectSize.y or 1
    end
    parent.UITransformComponent.RectSize = ___MOD.FastVector2(metrics.contentW, targetH)
  end
  local renderer = parent.BitmapFontRendererComponent
  local garbage = renderer.garbage
  for i = 1, #garbage do
    garbage[i]:Destroy()
  end
  ___MOD.table.clear(renderer.garbage)
  local pool = renderer.glyphPool
  if not isQuestAlramContent then
    for i = 1, #pool do
      pool[i]:SetVisible(false)
    end
  end
  local glyphCount = metrics.glyphCount or 0
  local trPivot = ___MOD.FastVector2(0, 1)
  local trAlign = ___MOD.AlignmentType.TopLeft
  for i = #pool + 1, glyphCount do
    local ent = ___MOD._SpawnService:SpawnByEntity(self.emptyGlyph, "g", ___MOD.FastVector3.zero:Clone(), parent)
    ent.Visible = false
    local tr = ent and ent.UITransformComponent or nil
    if not ___MOD.isvalid(tr) and ___MOD.isvalid(ent) then
      ___MOD.pcall(function()
        ent:AddComponent(___MOD.UITransformComponent)
      end)
      tr = ent.UITransformComponent
    end
    if not ___MOD.isvalid(tr) then
      if ___MOD.isvalid(ent) then
        ent:Destroy()
      end
    else
      tr.Pivot = trPivot
      tr.AlignmentOption = trAlign
      pool[i] = ent
    end
  end
  local lineY = {}
  local y = startPos.y
  for i, h in ___MOD.ipairs(metrics.lineHeightInfo) do
    lineY[i] = y
    y = y - h
  end
  local lineOffsetX = {}
  for i, line in ___MOD.ipairs(metrics.lines) do
    lineOffsetX[i] = self:getOffset(alignment, metrics.contentW, line.width)
  end
  local lineHasItem = {}
  local lineItemHeight = {}
  for _, layout in ___MOD.ipairs(layoutInfo) do
    if layout.type == "item" then
      local li = layout.line
      lineHasItem[li] = true
      local oldH = lineItemHeight[li] or 0
      if oldH < layout.height then
        lineItemHeight[li] = layout.height
      end
    end
  end
  local hasMenu = false
  local glyphs = {}
  local idx = 1
  local menuStr = ""
  for _, e in ___MOD.ipairs(layoutInfo) do
    if e.type == "dot" then
      local dot0 = "374b227f16a54cb59ca9b318bba4bb75"
      local dot1 = "cc0e04ae21a84e37a7ff5d2b223bf23d"
      local ruid = e.menuIdx == 0 and dot1 or dot0
      local dot = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "dot" .. e.menuIdx, ___MOD.FastVector3.zero:Clone(), parent)
      local lineIdx = e.line
      local hasItem = lineHasItem[lineIdx] == true
      local itemHeight = lineItemHeight[lineIdx] or 0
      dot.SpriteGUIRendererComponent.ImageRUID = ruid
      dot.UITransformComponent.RectSize = ___MOD.FastVector2(12, 14)
      dot.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      dot.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
      local offsetX = lineOffsetX[e.line] or 0
      local yPos = lineY[e.line] - 4
      if hasItem then
        yPos = yPos - itemHeight / 2
      end
      dot.UITransformComponent.anchoredPosition = ___MOD.FastVector2(startPos.x + offsetX + e.xOffset - 8, yPos)
      menuStr = e.menuStr
      dot:SetVisible(true)
      ___MOD.table.insert(renderer.garbage, dot)
    elseif e.type == "underline" then
      local underbarRUID = "a4522d4f429f453db2d697645697bf59"
      local underbar = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", menuStr, ___MOD.FastVector3.zero:Clone(), parent)
      underbar.SpriteGUIRendererComponent.ImageRUID = underbarRUID
      underbar.UITransformComponent.RectSize = ___MOD.FastVector2(e.width, 26)
      underbar.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      underbar.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
      underbar.SpriteGUIRendererComponent.Type = ___MOD.ImageType.Tiled
      local lineIdx = e.line
      local yPos = lineY[e.line]
      if e.hasItem then
        yPos = yPos - (metrics.lineMaxHeight[lineIdx] / 2 + 12)
      end
      underbar.UITransformComponent.anchoredPosition = ___MOD.FastVector2(e.xOffset, yPos)
      underbar.Visible = true
      if not e.firstMenu then
        underbar.SpriteGUIRendererComponent.Color.a = 0
      else
        underbar.SpriteGUIRendererComponent.Color.a = 1
      end
      underbar:AddComponent(___MOD.UITouchReceiveComponent)
      udc:addMenuEntityList(underbar)
      underbar:ConnectEvent(___MOD.UITouchEnterEvent, function()
        udc:mouseOnMenu(underbar)
      end)
      underbar:ConnectEvent(___MOD.UITouchExitEvent, function()
        udc:mouseOutMenu(underbar)
      end)
      underbar:ConnectEvent(___MOD.UITouchUpEvent, function()
        udc:onMenuClickClient(underbar.Name)
      end)
      menuStr = ""
      ___MOD.table.insert(renderer.garbage, underbar)
    elseif e.type == "item" then
      local itemRUID = e.ruid
      if ___MOD.isvalid(itemRUID) then
        local itemEntity = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "item_" .. e.itemID, ___MOD.FastVector3.zero:Clone(), parent)
        if e.tooltip then
          itemEntity:AddComponent(___MOD.UITouchReceiveComponent)
          itemEntity:AddComponent(___MOD.TooltipComponent)
          itemEntity.TooltipComponent.type = ___MOD._TooltipType.TEXT
          local itemName = ___MOD._StringPoolManager:getItemName(e.itemID)
          if ___MOD._UtilLogic:IsNilorEmptyString(itemName) then
            itemName = ___MOD.tostring(e.itemID)
          end
          itemEntity.TooltipComponent.text = itemName
          itemEntity.TooltipComponent.id = ___MOD.tonumber(e.itemID)
        end
        itemEntity.SpriteGUIRendererComponent.ImageRUID = itemRUID
        itemEntity.UITransformComponent.RectSize = ___MOD.FastVector2(e.width, e.height)
        itemEntity.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
        itemEntity.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
        local offsetX = lineOffsetX[e.line] or 0
        itemEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(startPos.x + offsetX + e.xOffset, lineY[e.line])
        itemEntity:SetVisible(true)
        ___MOD.table.insert(renderer.garbage, itemEntity)
      end
    elseif e.type == "image" then
      local imgEntity = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "img_" .. e.path:gsub("[^%w]", "_"), ___MOD.FastVector3.zero:Clone(), parent)
      imgEntity.SpriteGUIRendererComponent.ImageRUID = e.ruid
      imgEntity.UITransformComponent.RectSize = ___MOD.FastVector2(e.width, e.height)
      imgEntity.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
      imgEntity.UITransformComponent.Pivot = ___MOD.FastVector2(0, 1)
      local offsetX = lineOffsetX[e.line] or 0
      imgEntity.UITransformComponent.anchoredPosition = ___MOD.FastVector2(startPos.x + offsetX + e.xOffset, lineY[e.line])
      imgEntity:SetVisible(true)
      ___MOD.table.insert(renderer.garbage, imgEntity)
    elseif e.type == "glyph" and e.selectMode then
      local ent = pool[idx]
      idx = idx + 1
      local spr = ent.SpriteGUIRendererComponent
      local tr = ent.UITransformComponent
      local curFont = e.isBold and font .. "_bold" or font
      spr.ImageRUID = ___MOD._BitmapFontManager:getGlyphRUID(curFont, e.token.cp)
      spr.Color = e.color
      if outline then
        spr.Outline = true
        spr.OutlineColor = outlineColor
        spr.OutlineWidth = 1
      end
      if minimap then
        spr.DropShadow = true
        spr.DropShadowAngle = 120
        spr.DropShadowColor = ___MOD.FastColor.black
        spr.DropShadowDistance = 2
      end
      tr.RectSize = ___MOD.FastVector2(e.width, e.height)
      local offsetX = lineOffsetX[e.line] or 0
      if outline then
        offsetX = offsetX + 1
      end
      local yPos = lineY[e.line]
      if e.hasItem then
        yPos = lineY[e.line] - (metrics.lineHeightInfo[e.line] - 15) + e.height
      end
      tr.anchoredPosition = ___MOD.FastVector2(startPos.x + offsetX + e.xOffset, yPos)
      ___MOD._UpdateManager:insertUpdateVisible(ent, true)
      if not hasMenu then
        hasMenu = true
      end
    elseif e.type == "glyph" and not e.selectMode then
      local ent = pool[idx]
      idx = idx + 1
      local spr = ent.SpriteGUIRendererComponent
      local tr = ent.UITransformComponent
      local curFont = e.isBold and font .. "_bold" or font
      spr.ImageRUID = ___MOD._BitmapFontManager:getGlyphRUID(curFont, e.token.cp)
      spr.Color = e.color
      if outline then
        spr.Outline = true
        spr.OutlineColor = outlineColor
        spr.OutlineWidth = 1
      end
      if minimap then
        spr.DropShadow = true
        spr.DropShadowAngle = 120
        spr.DropShadowColor = ___MOD.FastColor.black
        spr.DropShadowDistance = 2
      end
      tr.RectSize = ___MOD.FastVector2(e.width, e.height)
      local offsetX = lineOffsetX[e.line] or 0
      if outline then
        offsetX = offsetX + 1
      end
      local yPos = lineY[e.line] - (metrics.lineHeightInfo[e.line] - 6) + e.height
      if e.hasItem then
        yPos = yPos + 4
      end
      tr.anchoredPosition = ___MOD.FastVector2(startPos.x + offsetX + e.xOffset, yPos)
      if e.tooltip then
        ent.SpriteGUIRendererComponent.RaycastTarget = true
        ent:AddComponent(___MOD.UITouchReceiveComponent)
        ent:AddComponent(___MOD.TooltipComponent)
        ent.TooltipComponent.type = e.tooltipType
        if e.tooltipType == ___MOD._TooltipType.EQUIP or e.tooltipType == ___MOD._TooltipType.INVENTORY then
          local item = ___MOD._ItemManager:getItemById(e.itemID)
          if item == nil then
            item = ___MOD._EquipManager:getItemById(e.itemID)
            if item == nil then
              goto lbl_739
            end
          end
          if ent.TooltipComponent.type == ___MOD._TooltipType.EQUIP then
            ent.TooltipComponent.equip = item:addInventoryEquip()
          else
            ent.TooltipComponent.equip = item:addInventoryItem()
          end
          ent.TooltipComponent.id = ___MOD.tonumber(e.itemID)
        end
        ent.TooltipComponent.id = ___MOD.tonumber(e.itemID)
      end
      glyphs[#glyphs + 1] = ent
    end
    ::lbl_739::
  end
  if isQuestAlramContent then
    for i = idx, #pool do
      if ___MOD.isvalid(pool[i]) then
        pool[i]:SetVisible(false)
      end
    end
  end
  ___MOD._UpdateManager:insertUpdateVisible(parent, true)
  if validUDC then
    udc.canClickMenu = true
  end

  local function bumpGen(renderer)
    renderer.renderGen = (renderer.renderGen or 0) + 1
    return renderer.renderGen
  end

  local step = 0.03
  local gen = bumpGen(renderer)
  local i = 1
  while i <= #glyphs and gen == renderer.renderGen and not (i > #glyphs) and gen == renderer.renderGen do
    local ent = glyphs[i]
    ent:SetVisible(true)
    i = i + 1
    if gen ~= renderer.renderGen then
      break
    end
    if validUDC and not udc.skipTypingEffect then
      ___MOD.wait(step)
    end
  end
  if validUDC and gen == renderer.renderGen then
    udc:setEnableNext(true)
  end
end

function BitmapFontService.resolveLegacyRichDynamicText(self, tagType, payload, playerEntity)
  local raw = ___MOD.tostring(payload or "")
  local num = ___MOD.tonumber(raw)
  if tagType == "z" or tagType == "t" then
    if num == nil then
      return ""
    end
    return ___MOD._StringPoolManager:getItemName(num) or ""
  elseif tagType == "m" then
    if num == nil then
      return ""
    end
    return ___MOD._MapUtils:getMapNameById(num) or ""
  elseif tagType == "q" then
    if num == nil then
      return ""
    end
    return ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Skill.img/%07d/name", num)) or ""
  elseif tagType == "o" then
    if num == nil then
      return ""
    end
    return ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Mob.img/%d/name", num)) or ""
  elseif tagType == "p" then
    if num == nil then
      return ""
    end
    return ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Npc.img/%d/name", num)) or ""
  elseif tagType == "h" then
    local p = playerEntity
    if not ___MOD.isvalid(p) then
      p = ___MOD._UserService.LocalPlayer
    end
    if ___MOD.isvalid(p) and ___MOD.isvalid(p.Player) then
      return p.Player.Name or ""
    end
    return ""
  end
  return ""
end

function BitmapFontService.tokenizeRich(self, text, defaultColor, richText, convertEscapedNewline)
  if ___MOD.type(text) ~= "string" or text == "" then
    return {}
  end
  if convertEscapedNewline == nil then
    convertEscapedNewline = true
  end
  if ___MOD.string.find(text, "\r", 1, true) ~= nil then
    text, ___MOD._ = text:gsub("\r\n", "\n"):gsub("\n\r", "\n"):gsub("\r", "\n")
  end
  if convertEscapedNewline and ___MOD.string.find(text, "\\", 1, true) ~= nil then
    text, ___MOD._ = text:gsub("\\r\\n", "\n"):gsub("\\r", "\n"):gsub("\\n", "\n")
  end
  local tok = {}
  local i = 1
  local len = #text
  local selectOpen = false
  local colorAutoBoldStack = {}
  if richText then
    while i <= len do
      local s3 = text:sub(i, i + 2)
      local s2 = s3:sub(1, 2)
      local s1 = s3:sub(1, 1)
      if s2 == "#b" then
        tok[#tok + 1] = {
          tp = "pushclr",
          v = ___MOD.FastColor.blue
        }
        colorAutoBoldStack[#colorAutoBoldStack + 1] = false
        i = i + 2
      elseif s2 == "#r" then
        tok[#tok + 1] = {
          tp = "pushclr",
          v = ___MOD.FastColor.red
        }
        colorAutoBoldStack[#colorAutoBoldStack + 1] = false
        i = i + 2
      elseif s2 == "#d" then
        tok[#tok + 1] = {
          tp = "pushclr",
          v = ___MOD.FastColor.magenta
        }
        colorAutoBoldStack[#colorAutoBoldStack + 1] = false
        i = i + 2
      elseif s2 == "#g" then
        tok[#tok + 1] = {
          tp = "pushclr",
          v = ___MOD.FastColor(0.627, 0.76, 0.29, 1.0)
        }
        colorAutoBoldStack[#colorAutoBoldStack + 1] = false
        i = i + 2
      elseif s2 == "#C" then
        local hex = text:sub(i + 2, i + 7)
        tok[#tok + 1] = {
          tp = "pushclr",
          v = ___MOD.Color.FromHexCode("#" .. hex)
        }
        colorAutoBoldStack[#colorAutoBoldStack + 1] = false
        i = i + 8
      elseif s2 == "#Y" then
        tok[#tok + 1] = {
          tp = "pushclr",
          v = ___MOD.Color.FromHexCode("#ffcc00")
        }
        tok[#tok + 1] = {tp = "pushbold"}
        colorAutoBoldStack[#colorAutoBoldStack + 1] = true
        i = i + 2
      elseif s2 == "#k" then
        tok[#tok + 1] = {tp = "pushclr", v = defaultColor}
        colorAutoBoldStack[#colorAutoBoldStack + 1] = false
        i = i + 2
      elseif s2 == "#n" then
        tok[#tok + 1] = {tp = "popbold"}
        i = i + 2
      elseif s2 == "#e" then
        tok[#tok + 1] = {tp = "pushbold"}
        i = i + 2
      elseif s2 == "#f" then
        local s = text:sub(i)
        local imgPath, endIdx = s:match("^#f([^#]+)#()")
        if imgPath then
          tok[#tok + 1] = {tp = "image", path = imgPath}
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#i" or s2 == "#v" then
        local s = text:sub(i)
        local numPart, rest, endIdx = s:match("^#" .. s2:sub(2) .. "%s*(%d+)([^#]*)#()")
        if numPart then
          local itemID = ___MOD.tonumber(numPart)
          local addMsg = rest and rest:match("^%s*:?(.-)%s*$") or nil
          if addMsg == "" then
            addMsg = nil
          end
          tok[#tok + 1] = {
            tp = "item",
            itemID = itemID,
            addMsg = addMsg,
            tooltip = s2 == "#i"
          }
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#z" or s2 == "#t" then
        local s = text:sub(i)
        local numPart, rest, endIdx = s:match("^#" .. s2:sub(2) .. "%s*(%d+)([^#]*)#()")
        if numPart then
          local itemID = ___MOD.tonumber(numPart)
          local addMsg = rest and rest:match("^%s*:?(.-)%s*$") or nil
          if addMsg == "" then
            addMsg = nil
          end
          tok[#tok + 1] = {
            tp = "itemName",
            itemID = itemID,
            addMsg = addMsg,
            tooltip = s2 == "#z"
          }
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#c" then
        local s = text:sub(i)
        local numPart, rest, endIdx = s:match("^#c%s*(%d+)%s*:?([^#]*)#()")
        if numPart and #numPart == 7 then
          local itemID = ___MOD.tonumber(numPart)
          local addMsg = rest:match("^%s*(.-)%s*$")
          if addMsg == "" then
            addMsg = nil
          end
          tok[#tok + 1] = {
            tp = "itemCount",
            itemID = itemID,
            addMsg = addMsg
          }
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "pushclr",
            v = ___MOD.FastColor(1.0, 0.675, 0.188, 1.0)
          }
          colorAutoBoldStack[#colorAutoBoldStack + 1] = false
          i = i + 2
        end
      elseif s2 == "#L" then
        local s = text:sub(i)
        local idStr, endIdx = s:match("^#L(%d+)#()")
        if idStr then
          if selectOpen then
            tok[#tok + 1] = {tp = "selectEnd"}
          end
          tok[#tok + 1] = {tp = "select", v = idStr}
          selectOpen = true
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#l" then
        if selectOpen then
          tok[#tok + 1] = {tp = "selectEnd"}
          selectOpen = false
        end
        i = i + 2
      elseif s2 == "#m" then
        local s = text:sub(i)
        local num, endIdx = s:match("^#m(%d+)#()")
        if num then
          tok[#tok + 1] = {tp = "mapName", mapID = num}
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#q" then
        local s = text:sub(i)
        local num, endIdx = s:match("^#q(%d+)#()")
        if num then
          tok[#tok + 1] = {tp = "skillName", skillID = num}
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#s" then
        local s = text:sub(i)
        local num, endIdx = s:match("^#s(%d+)#()")
        if num then
          tok[#tok + 1] = {
            tp = "skillIcon",
            skillID = ___MOD.tonumber(num)
          }
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#W" then
        local s = text:sub(i)
        local word, endIdx = s:match("^#W([^#]+)#()")
        if word then
          tok[#tok + 1] = {tp = "w", word = word}
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#o" then
        local s = text:sub(i)
        local numStr, endIdx = s:match("^#o(%d+)#()")
        if numStr then
          local mobID = ___MOD.tonumber(numStr)
          tok[#tok + 1] = {tp = "mobName", mobID = mobID}
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#j" then
        local s = text:sub(i)
        local content, endIdx = s:match("^#j(.-)#()")
        if content then
          tok[#tok + 1] = {tp = "qex", key = content}
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#a" then
        local s = text:sub(i)
        local str, endIdx = s:match("^#a(%d+)#()")
        if str then
          local questID = ___MOD.tonumber(str:sub(1, -2))
          local key = ___MOD.tonumber(str:sub(-1))
          tok[#tok + 1] = {
            tp = "mobCount",
            questID = questID,
            key = key
          }
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#h" then
        local s = text:sub(i)
        if s:find("^#h#") then
          tok[#tok + 1] = {tp = "nickName"}
          i = i + 2
        elseif s:find("^#h #") then
          tok[#tok + 1] = {tp = "nickName"}
          i = i + 3
        elseif s:find("^#h0#") then
          tok[#tok + 1] = {tp = "nickName"}
          i = i + 4
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#p" then
        local s = text:sub(i)
        local all, numPart, rest, endIdx = s:match("^(#p)(%d+)(.-)#()")
        if all then
          local npcID = numPart
          tok[#tok + 1] = {tp = "npcName", npcID = npcID}
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#y" then
        local s = text:sub(i)
        local num, endIdx = s:match("^#y(%d+)#()")
        if num then
          tok[#tok + 1] = {
            tp = "questName",
            questID = ___MOD.tonumber(num)
          }
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#u" then
        local s = text:sub(i)
        local num, endIdx = s:match("^#u(%d+)#()")
        if num then
          tok[#tok + 1] = {
            tp = "questState",
            questID = ___MOD.tonumber(num)
          }
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s2 == "#R" then
        local s = text:sub(i)
        local num, endIdx = s:match("^#R(%d+)#()")
        if num then
          tok[#tok + 1] = {
            tp = "questExById",
            questID = ___MOD.tonumber(num)
          }
          i = i + endIdx - 1
        else
          tok[#tok + 1] = {
            tp = "g",
            cp = ___MOD.utf8.codepoint("#")
          }
          i = i + 1
        end
      elseif s1 == "#" then
        tok[#tok + 1] = {tp = "popclr"}
        if colorAutoBoldStack[#colorAutoBoldStack] == true then
          tok[#tok + 1] = {tp = "popbold"}
        end
        colorAutoBoldStack[#colorAutoBoldStack] = nil
        i = i + 1
      elseif s1 == "\n" then
        tok[#tok + 1] = {tp = "nl"}
        i = i + 1
        text:sub(i, i + 2)
      else
        local cp = ___MOD.utf8.codepoint(text, i)
        local j = ___MOD.utf8.offset(text, 2, i) or len + 1
        if cp ~= nil then
          tok[#tok + 1] = {tp = "g", cp = cp}
          i = j
        else
          i = i + 1
        end
      end
    end
    if selectOpen then
      tok[#tok + 1] = {tp = "selectEnd"}
      selectOpen = false
    end
  else
    while len >= i do
      local cp = ___MOD.utf8.codepoint(text, i)
      local j = ___MOD.utf8.offset(text, 2, i) or len + 1
      if cp ~= nil then
        tok[#tok + 1] = {tp = "g", cp = cp}
        i = j
      else
        i = i + 1
      end
    end
  end
  return tok
end

function BitmapFontService.tripToBytes(self, str, maxByte)
  local byteCount = 0
  local charCount = 0
  local over = false
  local skipNextColorChar = false
  for pos, code in ___MOD.utf8.codes(str) do
    local ch = ___MOD.utf8.char(code)
    local len = #ch
    local addLen = len
    if skipNextColorChar then
      addLen = 0
      skipNextColorChar = false
    elseif ch == "#" then
      local nextChar = str:sub(pos + 1, pos + 1)
      if nextChar == "r" or nextChar == "e" or nextChar == "k" or nextChar == "n" then
        addLen = 0
        skipNextColorChar = true
      end
    end
    if maxByte < byteCount + addLen then
      over = true
      break
    end
    byteCount = byteCount + addLen
    charCount = charCount + 1
  end
  local nextPos = ___MOD.utf8.offset(str, charCount + 1)
  if nextPos then
    return over, str:sub(1, nextPos - 1)
  else
    return over, str
  end
end

function BitmapFontService.wrapTextByWidth(self, text, font, maxWidth, convertEscapedNewline)
  if convertEscapedNewline == nil then
    convertEscapedNewline = true
  end
  if ___MOD.string.find(text, "\r", 1, true) ~= nil then
    text, ___MOD._ = text:gsub("\r\n", "\n"):gsub("\n\r", "\n"):gsub("\r", "\n")
  end
  if convertEscapedNewline and ___MOD.string.find(text, "\\", 1, true) ~= nil then
    text, ___MOD._ = text:gsub("\\r\\n", "\n"):gsub("\\r", "\n"):gsub("\\n", "\n")
  end
  local lines = {}
  local currentLine = ""
  local lineWidth = 0
  for _, cp in ___MOD.utf8.codes(text) do
    local ch = ___MOD.utf8.char(cp)
    if ch == "\n" then
      ___MOD.table.insert(lines, currentLine)
      currentLine = ""
      lineWidth = 0
    else
      local glyphSize = ___MOD._BitmapFontManager:getGlyphSize(font, cp)
      local w = glyphSize.x or 0
      if maxWidth < lineWidth + w then
        ___MOD.table.insert(lines, currentLine)
        currentLine = ch
        lineWidth = w
      else
        currentLine = currentLine .. ch
        lineWidth = lineWidth + w
      end
    end
  end
  if currentLine ~= "" then
    ___MOD.table.insert(lines, currentLine)
  end
  return lines
end
