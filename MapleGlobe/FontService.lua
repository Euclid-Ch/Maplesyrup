

function FontService.CalcFontWidth(self, fontType, text, bold, outline, minimap)
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return
  end
  local strLength = self:GetUTF8Length(text)
  local totalWidth = 0
  local pixels = {}
  self.fontCache = self.fontCache or {}

  local function getCachedGlyph(unicodeValue)
    if 65535 < unicodeValue then
      return nil
    end
    local codePage = unicodeValue % 5000
    local page = ___MOD.math.tointeger(___MOD.math.floor(unicodeValue / 5000) + 1)
    if codePage == 0 then
      page = ___MOD.math.tointeger(unicodeValue / 5000)
      codePage = 5000
    end
    local pageCache = self.fontCache[page]
    if not pageCache then
      pageCache = {}
      self.fontCache[page] = pageCache
    end
    local codeCache = pageCache[codePage]
    if not codeCache then
      local tableKey = ___MOD.string.format(fontType .. "_%d", page)
      local kr = ___MOD._DataService:GetTable(tableKey)
      codeCache = {
        normal = {
          ___MOD.tonumber(kr:GetCell(codePage, 1)) or 0,
          kr:GetCell(codePage, 2)
        },
        outline = {
          ___MOD.tonumber(kr:GetCell(codePage, 3)) or 0,
          kr:GetCell(codePage, 4)
        },
        bold = {
          ___MOD.tonumber(kr:GetCell(codePage, 5)) or 0,
          kr:GetCell(codePage, 6)
        },
        boldOutline = {
          ___MOD.tonumber(kr:GetCell(codePage, 7)) or 0,
          kr:GetCell(codePage, 8)
        }
      }
      pageCache[codePage] = codeCache
    end
    if bold and outline then
      return codeCache.boldOutline
    elseif bold then
      return codeCache.bold
    elseif outline then
      return codeCache.outline
    else
      return codeCache.normal
    end
  end

  for i = 1, strLength do
    local char = ___MOD._UtilLogic:SubString(text, i, 1)
    local unicodeValue = self:GetUnicode(char)
    local glyph = getCachedGlyph(unicodeValue)
    if glyph then
      local width = glyph[1]
      local pixel = glyph[2]
      if 0 < width then
        ___MOD.table.insert(pixels, {w = width, pix = pixel})
        totalWidth = totalWidth + width
        local decoded, h = self:decodePixel2Bit(pixel, width)
        if outline and i ~= 1 then
          totalWidth = totalWidth - 1
        end
      end
    end
  end
  return totalWidth
end

function FontService.CalcFontWidthHeight(self, fontType, pixelEntity, text, bold, outline, minimap)
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return
  end
  local strLength = self:GetUTF8Length(text)
  local totalWidth = 0
  local maxHeight = 22
  local pixels = {}
  self.fontCache = self.fontCache or {}

  local function getCachedGlyph(unicodeValue)
    if 65535 < unicodeValue then
      return nil
    end
    local codePage = unicodeValue % 5000
    local page = ___MOD.math.tointeger(___MOD.math.floor(unicodeValue / 5000) + 1)
    if codePage == 0 then
      page = ___MOD.math.tointeger(unicodeValue / 5000)
      codePage = 5000
    end
    local pageCache = self.fontCache[page]
    if not pageCache then
      pageCache = {}
      self.fontCache[page] = pageCache
    end
    local codeCache = pageCache[codePage]
    if not codeCache then
      local tableKey = ___MOD.string.format(fontType .. "_%d", page)
      local kr = ___MOD._DataService:GetTable(tableKey)
      codeCache = {
        normal = {
          ___MOD.tonumber(kr:GetCell(codePage, 1)) or 0,
          kr:GetCell(codePage, 2)
        },
        outline = {
          ___MOD.tonumber(kr:GetCell(codePage, 3)) or 0,
          kr:GetCell(codePage, 4)
        },
        bold = {
          ___MOD.tonumber(kr:GetCell(codePage, 5)) or 0,
          kr:GetCell(codePage, 6)
        },
        boldOutline = {
          ___MOD.tonumber(kr:GetCell(codePage, 7)) or 0,
          kr:GetCell(codePage, 8)
        }
      }
      pageCache[codePage] = codeCache
    end
    if bold and outline then
      return codeCache.boldOutline
    elseif bold then
      return codeCache.bold
    elseif outline then
      return codeCache.outline
    else
      return codeCache.normal
    end
  end

  for i = 1, strLength do
    local char = ___MOD._UtilLogic:SubString(text, i, 1)
    local unicodeValue = self:GetUnicode(char)
    local glyph = getCachedGlyph(unicodeValue)
    if glyph then
      local width = glyph[1]
      local pixel = glyph[2]
      if 0 < width then
        ___MOD.table.insert(pixels, {w = width, pix = pixel})
        totalWidth = totalWidth + width
        local decoded, h = self:decodePixel2Bit(pixel, width)
        if maxHeight < h then
          maxHeight = h
        end
        if outline and i ~= 1 then
          totalWidth = totalWidth - 1
        end
      end
    end
  end
  if minimap then
    totalWidth = totalWidth + 3
    maxHeight = maxHeight + 3
  end
  pixelEntity.UITransformComponent.RectSize.x = totalWidth
  pixelEntity.UITransformComponent.RectSize.y = maxHeight
  pixelEntity.FontGUIRendererComponent:ResetWithColor(totalWidth, maxHeight, nil)
end

function FontService.decodePixel2Bit(self, encoded, width)
  if #self.base64Map == 0 then
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    for i = 1, #chars do
      self.base64Map[___MOD.string.sub(chars, i, i)] = i - 1
    end
  end
  local cacheKey = encoded .. "_" .. ___MOD.tostring(width)
  local cached = self.decodePixelCache[cacheKey]
  if cached then
    return cached.pixels, cached.height
  end
  local pixels = {}
  for i = 1, #encoded do
    local ch = ___MOD.string.sub(encoded, i, i)
    local val = self.base64Map[ch] or 0
    for shift = 4, 0, -2 do
      local bits = val >> shift & 3
      if bits == 0 then
        ___MOD.table.insert(pixels, "o")
      elseif bits == 1 then
        ___MOD.table.insert(pixels, "l")
      elseif bits == 2 then
        ___MOD.table.insert(pixels, "e")
      else
        ___MOD.table.insert(pixels, "e")
      end
    end
  end
  local height = ___MOD.math.ceil(#pixels / width)
  self.decodePixelCache[cacheKey] = {pixels = pixels, height = height}
  return pixels, height
end

function FontService.DrawText(self, fontType, pixelEntity, text, color, bold, minimap, outline, outlineColor, isCentered, maxPixelWidth)
  if maxPixelWidth == -1 then
    maxPixelWidth = 1000
  elseif maxPixelWidth == 0 then
    maxPixelWidth = 86
  end
  local lines = self:wrapTextByPixelWidth(text, maxPixelWidth, bold, outline, fontType, false)
  local lineHeight = 22
  local lineSpacing = 2
  local krCache = {}

  local function getFontData(page)
    local tableKey = ___MOD.string.format(fontType .. "_%d", page)
    if not krCache[tableKey] then
      krCache[tableKey] = ___MOD._DataService:GetTable(tableKey)
    end
    return krCache[tableKey]
  end

  local totalWidth = 0
  local lineData = {}
  for li, line in ___MOD.ipairs(lines) do
    local strLength = self:GetUTF8Length(line)
    local lineWidth = 0
    local pixels = {}
    for i = 1, strLength do
      local char = ___MOD._UtilLogic:SubString(line, i, 1)
      local unicodeValue = self:GetUnicode(char)
      if not (65535 < unicodeValue) then
        local codePage = unicodeValue % 5000
        local index = ___MOD.math.tointeger(___MOD.math.floor(unicodeValue / 5000) + 1)
        if codePage == 0 then
          index = ___MOD.math.tointeger(unicodeValue / 5000)
          codePage = 5000
        end
        local kr = getFontData(index)
        local width = 0
        local pix = ""
        if bold then
          if outline then
            width = kr:GetCell(codePage, 7)
            pix = kr:GetCell(codePage, 8)
          else
            width = kr:GetCell(codePage, 5)
            pix = kr:GetCell(codePage, 6)
          end
        elseif outline then
          width = kr:GetCell(codePage, 3)
          pix = kr:GetCell(codePage, 4)
        else
          width = kr:GetCell(codePage, 1)
          pix = kr:GetCell(codePage, 2)
        end
        if width ~= nil and width ~= "0" then
          local numWidth = ___MOD.tonumber(width)
          lineWidth = lineWidth + numWidth
          ___MOD.table.insert(pixels, {w = numWidth, pix = pix})
          if outline and i ~= 1 then
            lineWidth = lineWidth - 1
          end
          local decoded, h = self:decodePixel2Bit(pix, width)
          if lineHeight < h then
            lineHeight = h
          end
        end
      end
    end
    if totalWidth < lineWidth then
      totalWidth = lineWidth
    end
    ___MOD.table.insert(lineData, {width = lineWidth, pixels = pixels})
  end
  local totalHeight = lineHeight * #lineData + lineSpacing * (#lineData - 1)
  local renderer = pixelEntity.FontRendererComponent
  renderer:ResetWithColor(totalWidth, totalHeight, nil)
  local pixelBuffer = {}
  for i = 1, totalWidth * totalHeight do
    pixelBuffer[i] = self.transparentColor
  end

  local function setBufferPixel(x, y, col)
    x = ___MOD.math.floor(x)
    y = ___MOD.math.floor(y)
    if x < 1 or x > totalWidth or y < 1 or y > totalHeight then
      return
    end
    local index = (y - 1) * totalWidth + x
    pixelBuffer[index] = col
  end

  local function getBufferPixel(x, y)
    x = ___MOD.math.floor(x)
    y = ___MOD.math.floor(y)
    if x < 1 or x > totalWidth or y < 1 or y > totalHeight then
      return nil
    end
    local index = (y - 1) * totalWidth + x
    return pixelBuffer[index]
  end

  for li, lineInfo in ___MOD.ipairs(lineData) do
    local xOffset = 0
    if isCentered then
      xOffset = ___MOD.math.floor((totalWidth - lineInfo.width) / 2)
    end
    local lastX = xOffset
    local offsetY = ___MOD.math.floor(totalHeight - (li * lineHeight + (li - 1) * lineSpacing))
    for i, v in ___MOD.ipairs(lineInfo.pixels) do
      local width = v.w
      local pix = v.pix
      local pixLen = #pix
      local w = width
      local decoded, h = self:decodePixel2Bit(pix, width)
      for idx = 1, #decoded do
        local x = (idx - 1) % width + 1
        local y = ___MOD.math.floor((idx - 1) / width) + 1
        local pixelChar = decoded[idx]
        if pixelChar == "l" then
          setBufferPixel(lastX + x, offsetY + y, color)
        elseif pixelChar == "e" then
          setBufferPixel(lastX + x, offsetY + y, outlineColor)
        end
      end
      lastX = lastX + width
      if outline then
        lastX = lastX - 1
      end
    end
  end
  renderer.Entity.TransformComponent.Scale.x = renderer.Entity.TransformComponent.Scale.x / 2
  renderer.Entity.TransformComponent.Scale.y = renderer.Entity.TransformComponent.Scale.y / 2
  ___MOD.wait(0.001)
  renderer:SetPixels(pixelBuffer)
end

function FontService.DrawTextGUI(self, fontType, pixelEntity, text, color, bold, minimap, outline, outlineColor, isRichText)
  local maxWidth = 0
  local align = 2
  local GAP = 4
  local OUT_GAP = outline and -1 or 0
  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return
  end
  if isRichText then
    text, ___MOD._ = text:gsub("\\n", "\n"):gsub("\\r", "\r")
  end
  pixelEntity.FontGUIRendererComponent:SetAlpha(0)
  self.fontCache = self.fontCache or {}
  self._glyphDecodedCache = self._glyphDecodedCache or {}
  self.fontCache[fontType] = self.fontCache[fontType] or {}
  self._glyphDecodedCache[fontType] = self._glyphDecodedCache[fontType] or {}
  local pageCache = self.fontCache[fontType]
  local decodeCache = self._glyphDecodedCache[fontType]
  local colorTag = {
    k = ___MOD.Color.black,
    b = ___MOD.Color.blue,
    r = ___MOD.Color.red,
    g = ___MOD.Color.green,
    d = ___MOD.Color.gray,
    c = ___MOD.FastColor(1.0, 0.675, 0.188, 1.0),
    Y = ___MOD.Color.FromHexCode("#ffcc00")
  }
  local curColor, baseColor = color, color
  local curBold = bold

  local function glyph(u)
    if 65535 < u then
      return {0, nil}
    end
    local cp = u % 5000
    local pg = ___MOD.math.tointeger(u / 5000) + (cp == 0 and 0 or 1)
    if cp == 0 then
      cp = 5000
    end
    local pc = pageCache[pg]
    if not pc then
      pc = {}
      pageCache[pg] = pc
    end
    local g = pc[cp]
    if not g then
      local t = ___MOD._DataService:GetTable(___MOD.string.format("%s_%d", fontType, pg))
      g = {
        normal = {
          ___MOD.tonumber(t:GetCell(cp, 1)) or 0,
          t:GetCell(cp, 2)
        },
        outline = {
          ___MOD.tonumber(t:GetCell(cp, 3)) or 0,
          t:GetCell(cp, 4)
        },
        bold = {
          ___MOD.tonumber(t:GetCell(cp, 5)) or 0,
          t:GetCell(cp, 6)
        },
        boldOutline = {
          ___MOD.tonumber(t:GetCell(cp, 7)) or 0,
          t:GetCell(cp, 8)
        }
      }
      pc[cp] = g
    end
    if curBold and outline then
      return g.boldOutline
    elseif curBold then
      return g.bold
    elseif outline then
      return g.outline
    else
      return g.normal
    end
  end

  local function decoded(pix, w)
    local d = decodeCache[pix]
    if not d then
      d = self:decodePixel2Bit(pix, w)
      decodeCache[pix] = d
    end
    return d
  end

  local lines, lineW, lineH = {}, {}, {}
  local curLine, curW, curH = {}, 0, 0
  local maxW, totalH = 0, 0

  local function push()
    lines[#lines + 1], lineW[#lineW + 1], lineH[#lineH + 1] = curLine, curW, curH
    if curW > maxW then
      maxW = curW
    end
    if 1 < #lines then
      totalH = totalH + GAP
    end
    totalH = totalH + curH
    curLine, curW, curH = {}, 0, 0
  end

  local i = 1
  while i <= #text do
    local code = ___MOD.utf8.codepoint(text, i)
    local ch = ___MOD.utf8.char(code)
    local inc = #ch
    if ch == "\n" or ch == "\r" then
      push()
    elseif isRichText and ch == "#" then
      local tagCode = ___MOD.utf8.codepoint(text, i + inc)
      if tagCode == nil then
        curColor = baseColor
        curBold = bold
      else
        local tag = ___MOD.utf8.char(tagCode)
        if tag == "Y" then
          curColor = colorTag[tag]
          curBold = true
        elseif colorTag[tag] then
          curColor = colorTag[tag]
        elseif tag == "e" then
          curBold = true
        elseif tag == "n" then
          curBold = false
        elseif tag == "0" then
          curColor = baseColor
        end
        inc = inc + #tag
      end
    else
      local g = glyph(code)
      local gw, pix = g[1], g[2]
      if 0 < gw then
        local gh = ___MOD.math.ceil(#decoded(pix, gw) / gw) + (outline and 1 or 0)
        if 0 < maxWidth and maxWidth < curW + gw then
          push()
        end
        curLine[#curLine + 1] = {
          w = gw,
          pix = pix,
          color = curColor
        }
        curW = curW + gw + (outline and (1 < #curLine and -1 or 0) or 0)
        if curH < gh then
          curH = gh
        end
      end
    end
    i = i + inc
  end
  if 0 < #curLine then
    push()
  end
  if #lines == 0 then
    return
  end
  local W = 0 < maxWidth and ___MOD.math.max(maxW, maxWidth) or maxW
  local H = totalH
  if minimap then
    W = W + 3
    H = H + 3
  end
  if W < 1 then
    W = 1
  end
  if H < 1 then
    H = 1
  end
  local expected = W * H
  local cache = pixelEntity.FontGUIRendererComponent.canvasCahce
  if cache and #cache ~= expected then
    cache = nil
    pixelEntity.FontGUIRendererComponent.canvasCahce = nil
  end
  pixelEntity.UITransformComponent.RectSize = ___MOD.Vector2(W, H)
  pixelEntity.FontGUIRendererComponent:ResetWithColor(W, H, nil)
  if cache then
    pixelEntity.FontGUIRendererComponent:SetPixels(cache)
    return
  end
  local EMPTY = ___MOD.Color(0, 0, 0, 0)
  local canvas = {}
  for k = 1, expected do
    canvas[k] = EMPTY
  end
  local yCursor = H
  for idx, line in ___MOD.ipairs(lines) do
    local LH = lineH[idx]
    yCursor = yCursor - LH
    local xStart = align == 2 and ___MOD.math.floor((W - lineW[idx]) / 2) or align == 3 and ___MOD.math.max(0, W - lineW[idx]) or 0
    local xCursor = xStart
    for _, g in ___MOD.ipairs(line) do
      local gw, pix, c = g.w, g.pix, g.color
      local dec = decoded(pix, gw)
      for p = 1, #dec do
        local dx = (p - 1) % gw
        local dy = ___MOD.math.floor((p - 1) / gw)
        local cx = xCursor + dx + 1
        local cy = yCursor + dy + 1
        local idxC = (cy - 1) * W + cx
        local pc = dec[p]
        if pc == "l" then
          canvas[idxC] = c
          if minimap then
            local sx, sy = cx + 2, cy - 2
            if 1 <= sx and W >= sx and 1 <= sy and H >= sy then
              local sidx = (sy - 1) * W + sx
              if canvas[sidx].a == 0 then
                canvas[sidx] = ___MOD.Color.black
              end
            end
          end
        elseif pc == "e" and canvas[idxC].a == 0 then
          canvas[idxC] = outlineColor
        end
      end
      xCursor = xCursor + gw + OUT_GAP
    end
    yCursor = yCursor - GAP
  end
  pixelEntity.FontGUIRendererComponent.canvasCahce = canvas
  pixelEntity.FontGUIRendererComponent:SetPixels(canvas)
end

function FontService.DrawTextGUIAA(self, fontType, pixelEntity, text, color, bold, minimap, outline, outlineColor)
  local function glyphValue(pix, x, y, glyphWidth, glyphHeight)
    if x < 0 or y < 0 or glyphWidth <= x or glyphHeight <= y then
      return 0
    end
    local index = y * glyphWidth + x + 1
    return pix[index] == "l" and 1 or 0
  end

  local function contrastCurve(c)
    return 1 / (1 + ___MOD.math.exp(-12 * (c - 0.5)))
  end

  local function renderGlyph(unicodeValue, origWidth, origHeight, pix)
    if bold then
      if self.glyphCacheBold[fontType] == nil then
        self.glyphCacheBold[fontType] = {}
      end
      if self.glyphCacheBold[fontType][unicodeValue] then
        return self.glyphCacheBold[fontType][unicodeValue]
      end
    else
      if self.glyphCache[fontType] == nil then
        self.glyphCache[fontType] = {}
      end
      if self.glyphCache[fontType][unicodeValue] then
        return self.glyphCache[fontType][unicodeValue]
      end
    end
    local scaledWidth = origWidth
    local scaledHeight = origHeight
    local renderedGlyph = {}
    for finalY = 0, scaledHeight - 1 do
      renderedGlyph[finalY] = {}
      for finalX = 0, scaledWidth - 1 do
        local sx = finalX + 0.5
        local sy = finalY + 0.5
        local gx = ___MOD.math.floor(sx)
        local gy = ___MOD.math.floor(sy)
        local fx = sx - gx
        local fy = sy - gy
        local v00 = glyphValue(pix, gx, gy, origWidth, origHeight)
        local v10 = glyphValue(pix, gx + 1, gy, origWidth, origHeight)
        local v01 = glyphValue(pix, gx, gy + 1, origWidth, origHeight)
        local v11 = glyphValue(pix, gx + 1, gy + 1, origWidth, origHeight)
        local coverage = v00 * (1 - fx) * (1 - fy) + v10 * fx * (1 - fy) + v01 * (1 - fx) * fy + v11 * fx * fy
        coverage = contrastCurve(coverage)
        renderedGlyph[finalY][finalX] = coverage
      end
    end
    if bold then
      self.glyphCacheBold[fontType][unicodeValue] = renderedGlyph
    else
      self.glyphCache[fontType][unicodeValue] = renderedGlyph
    end
    return renderedGlyph
  end

  if ___MOD._UtilLogic:IsNilorEmptyString(text) then
    return
  end
  local strLength = self:GetUTF8Length(text)
  local totalWidth = 0
  local maxHeight = 22
  local pixels = {}
  self.fontCache = self.fontCache or {}

  local function getCachedFontGlyph(unicodeValue)
    if 65535 < unicodeValue then
      return nil
    end
    local codePage = unicodeValue % 5000
    local page = ___MOD.math.tointeger(___MOD.math.floor(unicodeValue / 5000) + 1)
    if codePage == 0 then
      page = ___MOD.math.tointeger(unicodeValue / 5000)
      codePage = 5000
    end
    local pageCache = self.fontCache[page]
    if not pageCache then
      pageCache = {}
      self.fontCache[page] = pageCache
    end
    local codeCache = pageCache[codePage]
    if not codeCache then
      local tableKey = ___MOD.string.format(fontType .. "_%d", page)
      local kr = ___MOD._DataService:GetTable(tableKey)
      codeCache = {
        normal = {
          ___MOD.tonumber(kr:GetCell(codePage, 1)) or 0,
          kr:GetCell(codePage, 2)
        },
        outline = {
          ___MOD.tonumber(kr:GetCell(codePage, 3)) or 0,
          kr:GetCell(codePage, 4)
        },
        bold = {
          ___MOD.tonumber(kr:GetCell(codePage, 5)) or 0,
          kr:GetCell(codePage, 6)
        },
        boldOutline = {
          ___MOD.tonumber(kr:GetCell(codePage, 7)) or 0,
          kr:GetCell(codePage, 8)
        }
      }
      pageCache[codePage] = codeCache
    end
    if bold and outline then
      return codeCache.boldOutline
    elseif bold then
      return codeCache.bold
    elseif outline then
      return codeCache.outline
    else
      return codeCache.normal
    end
  end

  for i = 1, strLength do
    local char = ___MOD._UtilLogic:SubString(text, i, 1)
    local unicodeValue = self:GetUnicode(char)
    local glyph = getCachedFontGlyph(unicodeValue)
    if glyph then
      local width = glyph[1]
      local pixel = glyph[2]
      if 0 < width then
        ___MOD.table.insert(pixels, {
          w = width,
          pix = pixel,
          uv = unicodeValue
        })
        totalWidth = totalWidth + width
        local decoded, h = self:decodePixel2Bit(pixel, width)
        if maxHeight < h then
          maxHeight = h
        end
        if outline and i ~= 1 then
          totalWidth = totalWidth - 1
        end
      end
    end
  end
  if minimap then
    totalWidth = totalWidth + 5
    maxHeight = maxHeight + 5
  end
  local canvasWidth = totalWidth
  local canvasHeight = maxHeight
  local expectedPixelCount = canvasWidth * canvasHeight
  pixelEntity.UITransformComponent.RectSize.x = canvasWidth
  pixelEntity.UITransformComponent.RectSize.y = canvasHeight
  pixelEntity.FontGUIRendererComponent:ResetWithColor(canvasWidth, canvasHeight, nil)
  if 0 < #pixelEntity.FontGUIRendererComponent.canvasCacheAA then
    pixelEntity.FontGUIRendererComponent:SetPixels(pixelEntity.FontGUIRendererComponent.canvasCacheAA)
    return
  end
  local canvas = self:getEmptyCanvas(expectedPixelCount)
  if minimap then
    local shadowX = 0
    for i, glyph in ___MOD.ipairs(pixels) do
      local origWidth = glyph.w
      local origHeight = maxHeight
      local pix = self:decodePixel2Bit(glyph.pix, origWidth)
      local unicodeValue = glyph.uv
      local renderedGlyph = renderGlyph(unicodeValue, origWidth, origHeight, pix)
      for finalY = 0, origHeight - 1 do
        for finalX = 0, origWidth - 1 do
          if renderedGlyph[finalY] then
            local coverage = renderedGlyph[finalY][finalX]
            local px = shadowX + finalX + 2
            local py = finalY - 2
            if 0 <= px and canvasWidth > px and 0 <= py and canvasHeight > py and 0.2 < coverage then
              local index = py * canvasWidth + px + 1
              canvas[index] = ___MOD.Color(0, 0, 0, ___MOD.math.min(0.7, coverage * 1.5))
            end
          end
        end
      end
      shadowX = shadowX + origWidth
    end
  end
  local lastX = 0
  for i, glyph in ___MOD.ipairs(pixels) do
    local origWidth = glyph.w
    local origHeight = maxHeight
    local pix, _ = self:decodePixel2Bit(glyph.pix, origWidth)
    local unicodeValue = glyph.uv
    local scaledWidth = origWidth
    local scaledHeight = origHeight
    local renderedGlyph = renderGlyph(unicodeValue, origWidth, origHeight, pix)
    for finalY = 0, scaledHeight - 1 do
      for finalX = 0, scaledWidth - 1 do
        if renderedGlyph[finalY] then
          local coverage = renderedGlyph[finalY][finalX]
          if 0 < coverage then
            local px = lastX + finalX
            local py = finalY
            if 0 <= px and canvasWidth > px and 0 <= py and canvasHeight > py then
              local index = py * canvasWidth + px + 1
              local currentAlpha = canvas[index].a
              if not minimap or coverage > currentAlpha and 0 < coverage then
                canvas[index] = ___MOD.Color(color.r, color.g, color.b, coverage)
              end
            end
          end
        end
      end
    end
    lastX = lastX + scaledWidth
    if outline then
      lastX = lastX - 1
    end
  end
  if 0 >= #pixelEntity.FontGUIRendererComponent.canvasCacheAA then
    pixelEntity.FontGUIRendererComponent.canvasCacheAA = canvas
  end
  pixelEntity.FontGUIRendererComponent:SetPixels(canvas)
end

function FontService.getCachedFontGlyph(self, fontType, unicodeValue, bold, outline)
  if 65535 < unicodeValue then
    return nil
  end
  local codePage = unicodeValue % 5000
  local page = ___MOD.math.tointeger(___MOD.math.floor(unicodeValue / 5000) + 1)
  if codePage == 0 then
    page = ___MOD.math.tointeger(unicodeValue / 5000)
    codePage = 5000
  end
  local pageCache = self.fontCache[page]
  if not pageCache then
    pageCache = {}
    self.fontCache[page] = pageCache
  end
  local codeCache = pageCache[codePage]
  if not codeCache then
    codeCache = {}
    local tableKey = ___MOD.string.format(fontType .. "_%d", page)
    local kr = ___MOD._DataService:GetTable(tableKey)
    codeCache.normal = {
      ___MOD.tonumber(kr:GetCell(codePage, 1)) or 0,
      kr:GetCell(codePage, 2)
    }
    codeCache.outline = {
      ___MOD.tonumber(kr:GetCell(codePage, 3)) or 0,
      kr:GetCell(codePage, 4)
    }
    codeCache.bold = {
      ___MOD.tonumber(kr:GetCell(codePage, 5)) or 0,
      kr:GetCell(codePage, 6)
    }
    codeCache.boldOutline = {
      ___MOD.tonumber(kr:GetCell(codePage, 7)) or 0,
      kr:GetCell(codePage, 8)
    }
    pageCache[codePage] = codeCache
  end
  if bold and outline then
    return codeCache.boldOutline
  elseif bold then
    return codeCache.bold
  elseif outline then
    return codeCache.outline
  else
    return codeCache.normal
  end
end

function FontService.getCharWidth(self, char, bold, outline, fontType, gui)
  local unicodeValue = self:GetUnicode(char)
  if 65535 < unicodeValue then
    return 0
  end
  local codePage = unicodeValue % 5000
  local gulimValue = ___MOD.math.tointeger(___MOD.math.floor(unicodeValue / 5000) + 1)
  if codePage == 0 then
    gulimValue = ___MOD.math.tointeger(unicodeValue / 5000)
    codePage = 5000
  end
  local kr = ___MOD._DataService:GetTable(___MOD.string.format(fontType .. "_%d", gulimValue))
  local width = 0
  if bold then
    if outline then
      width = ___MOD.tonumber(kr:GetCell(codePage, 7))
    else
      width = ___MOD.tonumber(kr:GetCell(codePage, 5))
    end
  elseif outline then
    width = ___MOD.tonumber(kr:GetCell(codePage, 3))
  else
    width = ___MOD.tonumber(kr:GetCell(codePage, 1))
  end
  if not gui then
    width = width / 2
  end
  return width or 0
end

function FontService.getEmptyCanvas(self, size)
  local cached = self.transparentCanvasPool[size]
  if not cached then
    cached = {}
    for i = 1, size do
      cached[i] = self.transparentColor
    end
    self.transparentCanvasPool[size] = cached
  end
  local copy = {}
  for i = 1, size do
    copy[i] = cached[i]
  end
  return copy
end

function FontService.getStringToGulimHeight(self, text, maxPixelWidth, bold, outline)
  local wrappedLines = self:wrapTextByPixelWidth(text, maxPixelWidth, bold, outline, ___MOD._FontType.gulim9pt, true)
  local lineHeight = 22
  local minimap = false
  if minimap then
    lineHeight = lineHeight + 3
  end
  local lineSpacing = 2
  local totalHeight = #wrappedLines * lineHeight + (#wrappedLines - 1) * lineSpacing
  return totalHeight
end

function FontService.getStringWidth(self, text, bold, outline, fontType, _gui)
  local maxWidth = 0
  local currentLineWidth = 0
  local textLength = self:GetUTF8Length(text)
  for i = 1, textLength do
    local char = ___MOD._UtilLogic:SubString(text, i, 1)
    if char == "\n" then
      if maxWidth < currentLineWidth then
        maxWidth = currentLineWidth
      end
      currentLineWidth = 0
    else
      currentLineWidth = currentLineWidth + self:getCharWidth(char, bold, outline, ___MOD._FontType.gulim9pt, _gui)
    end
  end
  if maxWidth < currentLineWidth then
    maxWidth = currentLineWidth
  end
  if not _gui then
    maxWidth = maxWidth / 2
  end
  return maxWidth
end

function FontService.GetUnicode(self, input)
  local utf8 = ___MOD.require("utf8")
  local unicodeValue = utf8.codepoint(input)
  return unicodeValue
end

function FontService.GetUTF8Length(self, input)
  if input == nil then
    return 0
  end
  local utf8 = ___MOD.require("utf8")
  return utf8.len(input)
end

function FontService.splitTextByWidth(self, text, maxWidth, bold, outline, fontType, gui)
  local lines = {}
  local currentLine = ""
  local width = 0
  local i = 1
  local utf8Length = self:GetUTF8Length(text)
  local endsWithLineBreak = false
  while i <= utf8Length do
    local char = ___MOD._UtilLogic:SubString(text, i, 1)
    local isLineBreak = false
    local charWidth = 0
    if char == "\r" and utf8Length >= i + 1 and ___MOD._UtilLogic:SubString(text, i + 1, 1) == "\n" then
      isLineBreak = true
      i = i + 2
    elseif char == "\n" or char == "\r" then
      isLineBreak = true
      i = i + 1
    else
      charWidth = self:getCharWidth(char, bold, outline, fontType, gui)
      i = i + 1
    end
    if isLineBreak then
      ___MOD.table.insert(lines, currentLine)
      currentLine = ""
      width = 0
      endsWithLineBreak = true
    else
      if maxWidth < width + charWidth then
        ___MOD.table.insert(lines, currentLine)
        currentLine = char
        width = charWidth
      else
        currentLine = currentLine .. char
        width = width + charWidth
      end
      endsWithLineBreak = false
    end
  end
  if currentLine ~= "" or endsWithLineBreak then
    ___MOD.table.insert(lines, currentLine)
  end
  return lines
end

function FontService.wrapTextByPixelWidth(self, text, maxPixelWidth, bold, outline, fontType, gui)
  local wrappedLines = {}
  local currentLine = ""
  local currentLineWidth = 0
  local strLength = self:GetUTF8Length(text)
  for i = 1, strLength do
    local char = ___MOD._UtilLogic:SubString(text, i, 1)
    if char == "\n" then
      if currentLine ~= "" then
        ___MOD.table.insert(wrappedLines, currentLine)
      end
      currentLine = ""
      currentLineWidth = 0
    else
      local charWidth = self:getCharWidth(char, bold, outline, fontType, gui) or 0
      if maxPixelWidth < currentLineWidth + charWidth then
        if currentLine ~= "" then
          ___MOD.table.insert(wrappedLines, currentLine)
        end
        currentLine = char
        currentLineWidth = charWidth
      else
        currentLine = currentLine .. char
        currentLineWidth = currentLineWidth + charWidth
      end
    end
  end
  if currentLine ~= "" then
    ___MOD.table.insert(wrappedLines, currentLine)
  end
  return wrappedLines
end
