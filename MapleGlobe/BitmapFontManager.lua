

function BitmapFontManager.getGlyphRUID(self, font, code)
  local cache = self.glyphCache[font] or {}
  return cache[code] or ""
end

function BitmapFontManager.getGlyphSize(self, font, code)
  local cache = self.sizeCache[font] or {}
  local unicode = cache[code] or nil
  if unicode == nil then
    return ___MOD.FastVector2.zero:Clone()
  end
  return unicode
end

function BitmapFontManager.isvalidKSX1001(self, cp)
  if 44032 <= cp and cp < 46382 and 48 <= cp and cp <= 57 and 65 <= cp and cp <= 90 and 97 <= cp and cp <= 122 then
    return true
  end
  return false
end

function BitmapFontManager.loadBitmapFont(self)
  self:loadGlyphRUID("Gulim9pt")
  self:loadGlyphRUID("Gulim9pt_bold")
  self:loadGlyphRUID("Gulim11pt")
  self:loadGlyphRUID("Gulim11pt_bold")
  self:loadGlyphRUID("Tahoma9pt")
  self:loadGlyphRUID("Tahoma9pt_bold")
  self:loadGlyphRUID("Terminal8pt")
  self:loadSizeTable("Gulim9pt_sizes")
  self:loadSizeTable("Gulim11pt_sizes")
  self:loadSizeTable("Tahoma9pt_sizes")
  self:loadSizeTable("Terminal8pt_sizes")
  if ___MOD._BitmapFontService ~= nil then
    ___MOD._BitmapFontService:clearRichMetricsCache()
  end
  ___MOD._DataLoadManager:compeletedLoad()
end

function BitmapFontManager.loadGlyphRUID(self, collection)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable(collection)
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  for i = 1, count do
    self.glyphCache[collection] = self.glyphCache[collection] or {}
    local cp = ___MOD.tonumber(get(ds, i, 2))
    local ruid = get(ds, i, 1)
    self.glyphCache[collection][cp] = ruid
    count1 = count1 + 1
  end
  ___MOD.log(___MOD.string.format("Loaded BitmapFont %s Table (%.2f secs) Count : %d", collection, ___MOD._UtilLogic.ElapsedSeconds - time, count1))
end

function BitmapFontManager.loadSizeTable(self, collection)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local ds = ___MOD._DataService:GetTable(collection)
  local count = ds:GetRowCount()
  local get = ds.GetCell
  local count1 = 0
  local font = ""
  local code = 0
  local w = 0
  local h = 0
  for i = 1, count do
    font = get(ds, i, 1)
    self.sizeCache[font] = self.sizeCache[font] or {}
    code = ___MOD.tonumber(get(ds, i, 2))
    w = ___MOD.tonumber(get(ds, i, 3))
    h = ___MOD.tonumber(get(ds, i, 4))
    self.sizeCache[font][code] = ___MOD.FastVector2(w, h)
    count1 = count1 + 1
  end
  ___MOD.log(___MOD.string.format("Loaded BitmapFont %s Table (%.2f secs) Count : %d", collection, ___MOD._UtilLogic.ElapsedSeconds - time, count1))
end

function BitmapFontManager.preloadFonts(self)
  ___MOD._ResourceService:PreloadAsync(self.preload, function()
    ___MOD.log(___MOD.string.format("Preloaded BitmapFont Count : %d", #self.preload))
  end)
end
