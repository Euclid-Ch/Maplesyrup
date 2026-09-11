

function RichTextUtils.isStrippableColorShorthand(self, tagBody)
  return tagBody:match("^%s*#%w+%s*$") ~= nil
end

function RichTextUtils.isStrippableOpeningTag(self, tagName)
  return tagName == "align" or tagName == "allcaps" or tagName == "alpha" or tagName == "b" or tagName == "br" or tagName == "color" or tagName == "cspace" or tagName == "i" or tagName == "link" or tagName == "indent" or tagName == "line-height" or tagName == "line-indent" or tagName == "lowercase" or tagName == "margin" or tagName == "mark" or tagName == "mspace" or tagName == "nobr" or tagName == "noparse" or tagName == "page" or tagName == "pos" or tagName == "rotate" or tagName == "s" or tagName == "size" or tagName == "smallcaps" or tagName == "space" or tagName == "sprite" or tagName == "strikethrough" or tagName == "style" or tagName == "sub" or tagName == "sup" or tagName == "u" or tagName == "uppercase" or tagName == "voffset" or tagName == "width"
end

function RichTextUtils.stripRichTextCommands(self, message)
  if message == nil then
    return ""
  end
  local strippedMessage = message:gsub("<([^<>]*)>", function(tagBody)
    local originalTag = "<" .. tagBody .. ">"
    if self:isStrippableColorShorthand(tagBody) then
      return ""
    end
    local slashPrefix, tagName, suffix = tagBody:match("^%s*(/?)%s*([%a][%a%-]*)(.*)$")
    if tagName == nil or slashPrefix == "/" then
      return originalTag
    end
    if not self:isStrippableOpeningTag(___MOD.string.lower(tagName)) then
      return originalTag
    end
    local hasValidSuffix = suffix == "" or suffix:match("^%s") ~= nil or suffix:match("^=") ~= nil or suffix:match("^/%s*$") ~= nil
    if not hasValidSuffix then
      return originalTag
    end
    return ""
  end)
  return strippedMessage
end
