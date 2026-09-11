

function UIMiniMap.applyIconStyle(self, iconEntity, type)
  if type == 4 or type == 6 then
    iconEntity.UITransformComponent.RectSize = ___MOD.FastVector2(10, 18)
    local ruidMap = {
      [4] = "a35f1930c0184e629bdbf610493348b7",
      [6] = "18da2d8b53ad44dd9888c2c441d8c39d"
    }
    iconEntity.SpriteGUIRendererComponent.ImageRUID = ruidMap[type]
  else
    iconEntity.UITransformComponent.RectSize = ___MOD.FastVector2(10, 10)
    local ruidMap = {
      [1] = "5526d8545e624b268bb2bb5522657f14",
      [2] = "7e3279b34a1c4b90b083174e36c8e8e6",
      [3] = "4da986f303e64c47afdda1513f1effdc",
      [5] = "032b2bcd04694414bd3ae67b0ee97ad1"
    }
    iconEntity.SpriteGUIRendererComponent.ImageRUID = ruidMap[type]
  end
end

function UIMiniMap.arrangeMiniMapLayerBeforeMobileChat(self)
  local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
  local tempGroup = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup")
  local mobileChat = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileChat")
  local mobileMenu = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/MobileMenu")
  if not (___MOD.isvalid(uiGroup) and ___MOD.isvalid(tempGroup)) or not ___MOD.isvalid(mobileChat) then
    return
  end
  self:attachMiniMapWindowToUIGroup(self.miniMapNone, tempGroup, uiGroup)
  self:attachMiniMapWindowToUIGroup(self.miniMapMax, tempGroup, uiGroup)
  self:attachMiniMapWindowToUIGroup(self.miniMapMini, tempGroup, uiGroup)
  mobileChat:AttachTo(tempGroup)
  mobileChat:AttachTo(uiGroup)
  if ___MOD.isvalid(mobileMenu) then
    mobileMenu:AttachTo(tempGroup)
    mobileMenu:AttachTo(uiGroup)
  end
end

function UIMiniMap.attachMiniMapWindowToUIGroup(self, miniMapWindow, tempGroup, uiGroup)
  if miniMapWindow == nil then
    return
  end
  local parent = miniMapWindow:getParentUI()
  if not ___MOD.isvalid(parent) then
    return
  end
  parent:AttachTo(tempGroup)
  parent:AttachTo(uiGroup)
end

function UIMiniMap.calculateHeightOffset(self, baseHeight)
  local h = baseHeight
  if self.canvasHeight < self.CANVAS_MAX_HEIGHT then
    local d = self.CANVAS_MAX_HEIGHT - self.canvasHeight
    h = h - d / 2
  end
  return h
end

function UIMiniMap.calculateNameWidth(self, text)
  return 100 + ___MOD._BitmapFontService:calcTotalWidth(text, ___MOD._BitmapFontType.Gulim9pt_bold, true)
end

function UIMiniMap.canShowTargetIcon(self, localPlayer, target)
  if not ___MOD.isvalid(localPlayer) or not ___MOD.isvalid(target) then
    return false
  end
  if localPlayer == target then
    return false
  end
  if target.Player == nil or target.PlayerComponent == nil then
    return false
  end
  if target.Player.AdminHidden == true then
    return false
  end
  if target.CurrentMapName == "LoadingMap" then
    return false
  end
  if target.CurrentMapName ~= localPlayer.CurrentMapName then
    return false
  end
  if target.CurrentMap ~= localPlayer.CurrentMap then
    return false
  end
  if target.Enable == false then
    return false
  end
  return true
end

function UIMiniMap.clamp(self, value, min, max)
  return ___MOD.math.max(min, ___MOD.math.min(value, max))
end

function UIMiniMap.clearMapScopedIcons(self)
  self:clearMapScopedIconsFromCanvas(self.maxCanvas)
  self:clearMapScopedIconsFromCanvas(self.miniCanvas)
  if self._T.activeMiniMapUserIds ~= nil then
    for userId, _ in ___MOD.pairs(self._T.activeMiniMapUserIds) do
      self._T.activeMiniMapUserIds[userId] = nil
    end
  end
end

function UIMiniMap.clearMapScopedIconsFromCanvas(self, canvas)
  if not ___MOD.isvalid(canvas) then
    return
  end
  local targets = {}
  for _, child in ___MOD.pairs(canvas.Children) do
    local childName = child.Name or ""
    local isNpcIcon = ___MOD.string.sub(childName, 1, 7) == "iconNpc"
    local isPortalIcon = ___MOD.string.sub(childName, 1, 10) == "iconPortal"
    local isUserIcon = ___MOD.string.sub(childName, 1, 12) == "iconAnother_"
    if isNpcIcon or isPortalIcon or isUserIcon then
      ___MOD.table.insert(targets, child)
    end
  end
  for _, target in ___MOD.pairs(targets) do
    if ___MOD.isvalid(target) then
      target:Destroy()
    end
  end
end

function UIMiniMap.createMiniMap(self)
  local miniMapPlayer = self:getMiniMapPlayer()
  if not ___MOD.isvalid(miniMapPlayer) or miniMapPlayer.CurrentMap == nil then
    return
  end
  local currentMap = miniMapPlayer.CurrentMap
  local mapInfo = currentMap.MapInfoComponent
  if mapInfo == nil then
    return
  end
  local mapID = mapInfo.mapID
  local hideMinimap = mapInfo.hideMinimap == true
  self._T.hideMinimap = hideMinimap
  local existingMiniParent = self.miniMapMini ~= nil and self.miniMapMini:getParentUI() or nil
  local existingMaxParent = self.miniMapMax ~= nil and self.miniMapMax:getParentUI() or nil
  local existingNoneParent = self.miniMapNone ~= nil and self.miniMapNone:getParentUI() or nil
  if ___MOD.isvalid(existingMiniParent) and ___MOD.isvalid(existingMaxParent) and ___MOD.isvalid(existingNoneParent) and ___MOD.isvalid(self.miniCanvas) and ___MOD.isvalid(self.maxCanvas) then
    self:refreshMiniMap()
    return
  end
  self.miniMapType = hideMinimap and ___MOD._UIMiniMapType.Minimap_None or self.selectedMiniMapType
  local emptyText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyText")
  local mapName = ___MOD._MapUtils:getMapNameById(mapID)
  local streetName = ___MOD._MapUtils:getStreetNameById(mapID)
  if mapName == nil then
    local none = ___MOD._EntityService:GetEntityByTag("miniMapNone")
    if ___MOD.isvalid(none) then
      none:Destroy()
    end
    local mini = ___MOD._EntityService:GetEntityByTag("miniMapMini")
    if ___MOD.isvalid(mini) then
      mini:Destroy()
    end
    local max = ___MOD._EntityService:GetEntityByTag("miniMapMax")
    if ___MOD.isvalid(max) then
      max:Destroy()
    end
    return
  end
  local utf8 = ___MOD.require("utf8")
  local nameWidth = self:calculateNameWidth(mapName)
  local streetNameWidth = self:calculateNameWidth(streetName)
  local maxWidth = ___MOD.math.max(nameWidth, streetNameWidth)
  local ruid = ___MOD._DataSetUtils:getData("MinimapRUID", "ID", ___MOD.string.format("%09d", mapID) .. ".img.miniMap", "RUID")
  self.miniCanvas = nil
  self.maxCanvas = nil
  local sprite = not hideMinimap and ruid ~= nil and ___MOD._ResourceService:LoadSpriteAndWait(ruid) or nil
  self.canvasWidth = 0
  self.canvasHeight = 40
  self.canScrollX = false
  self.canScrollY = false
  self.canScroll = false
  self.canvasSpriteWidth = 0
  self.canvasSpriteHeight = 0
  if sprite ~= nil then
    self.canScrollX = sprite.Width > self.CANVAS_MAX_WIDTH
    self.canScrollY = sprite.Height > self.CANVAS_MAX_HEIGHT
    self.canScroll = self.canScrollX or self.canScrollY
    self.canvasWidth = ___MOD.math.max(maxWidth, ___MOD.math.min(sprite.Width, self.CANVAS_MAX_WIDTH))
    self.canvasHeight = ___MOD.math.max(self.CANVAS_MIN_HEIGHT, ___MOD.math.min(sprite.Height, self.CANVAS_MAX_HEIGHT))
    self.canvasSpriteWidth = sprite.Width
    self.canvasSpriteHeight = sprite.Height
  end
  local noneName = streetName .. "  " .. mapName
  noneName = self:tripTo40Bytes(noneName)
  local noneNameWidth = self:calculateNameWidth(noneName)
  local noneCanvasWidth = 30 + noneNameWidth
  local lastPos = ___MOD.FastVector2(17, -188)
  local mini = ___MOD._EntityService:GetEntityByTag("miniMapMini")
  if ___MOD.isvalid(mini) then
    mini:Destroy()
  end
  self.miniMapMini = ___MOD.UIWindow():createUIWindow("All", ___MOD.FastVector2(self.canvasWidth, self.canvasHeight), lastPos, {
    nw = {
      rectSize = ___MOD.FastVector2(12, 58),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "5d7c2ea7444c41c39ed0f2a138293216"
    },
    n = {
      rectSize = ___MOD.FastVector2(2, 58),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "1f4ad1e21f3547a8b5f4d75d3e132dc8"
    },
    ne = {
      rectSize = ___MOD.FastVector2(12, 58),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "a37d041ada02498f86e718b798b18ab2"
    },
    w = {
      rectSize = ___MOD.FastVector2(12, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "582e34b9f04b44e4bbf08b1aadc7b6b7"
    },
    c = {
      rectSize = ___MOD.FastVector2(2, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "be674def9acd4571af5c8b425d4471e4"
    },
    e = {
      rectSize = ___MOD.FastVector2(12, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "fa037d887e64452c9332a704deef9dbb"
    },
    sw = {
      rectSize = ___MOD.FastVector2(12, 28),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "e8ac159a2d08447c868e76effce84f7d"
    },
    s = {
      rectSize = ___MOD.FastVector2(2, 28),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "274208834b2e4fbb8b022233b94a0f77"
    },
    se = {
      rectSize = ___MOD.FastVector2(12, 28),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "08d0cbccad5a468f8448634803fe8fd5"
    }
  }, "miniMapMini", nil)
  local parent = self.miniMapMini:getParentUI()
  parent.Visible = false
  parent.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
  parent.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
  local h = -160
  if self.canvasHeight < self.CANVAS_MAX_HEIGHT then
    local d = self.CANVAS_MAX_HEIGHT - self.canvasHeight
    h = h + d / 2
  end
  parent.UITransformComponent.anchoredPosition = ___MOD.FastVector2(14, h)
  parent:AddComponent(___MOD.UIMoveableComponent)
  parent:AddComponent(___MOD.UITouchReceiveComponent)
  parent:AddComponent(___MOD.TagComponent)
  local miniN = self.miniMapMini:getEntity("n")
  miniN:AddComponent(___MOD.UIWindowTouchComponent)
  local dragArea = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "dragArea", ___MOD.FastVector3.zero:Clone(), parent)
  if dragArea ~= nil then
    dragArea.SpriteGUIRendererComponent.ImageRUID = "3e9d52ed52d64794bbd6f72bab8ee3d9"
    dragArea.UITransformComponent.RectSize = ___MOD.FastVector2(self.canvasWidth - 130, 40)
    dragArea.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    dragArea.UITransformComponent.Pivot = ___MOD.FastVector2.zero:Clone()
    dragArea.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, 100)
    dragArea:AddComponent(___MOD.UIMoveableComponent)
    dragArea:SetVisible(true)
  end
  parent.TagComponent:AddTag("miniMapMini")
  local max = ___MOD._EntityService:GetEntityByTag("miniMapMax")
  if ___MOD.isvalid(max) then
    max:Destroy()
  end
  self.miniMapMax = ___MOD.UIWindow():createUIWindow("All", ___MOD.FastVector2(self.canvasWidth, self.canvasHeight), lastPos, {
    nw = {
      rectSize = ___MOD.FastVector2(12, 144),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "bf466edcaf7148c9bf1038ad59ff4e93"
    },
    n = {
      rectSize = ___MOD.FastVector2(2, 144),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "ed611475efe14f85affc199941a188e2"
    },
    ne = {
      rectSize = ___MOD.FastVector2(12, 144),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "6f231ec02bee472cade40ee2b3348ad6"
    },
    w = {
      rectSize = ___MOD.FastVector2(12, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "20cbd5f1409149e88ff3fc5b05c9361f"
    },
    c = {
      rectSize = ___MOD.FastVector2(2, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "3b8db828ae6f455ba9095b9d37059e2c"
    },
    e = {
      rectSize = ___MOD.FastVector2(12, 2),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "b6a35b96742d455ab5f99106e0187347"
    },
    sw = {
      rectSize = ___MOD.FastVector2(12, 30),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "ddf194b56d2848e1a32bc085e6c3490c"
    },
    s = {
      rectSize = ___MOD.FastVector2(2, 30),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "fac4847a82434246999db2cb189c1e8a"
    },
    se = {
      rectSize = ___MOD.FastVector2(12, 30),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "d5a119d188f04bf791be53b47a21c572"
    }
  }, "miniMapMax", nil)
  local minParent = self.miniMapMax:getParentUI()
  minParent.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
  minParent.UITransformComponent.Pivot.x = 0
  h = -246
  if self.canvasHeight < self.CANVAS_MAX_HEIGHT then
    local d = self.CANVAS_MAX_HEIGHT - self.canvasHeight
    h = h + d / 2
  end
  minParent.UITransformComponent.anchoredPosition = ___MOD.Vector2(14, h)
  minParent:AddComponent(___MOD.UIMoveableComponent)
  minParent:AddComponent(___MOD.UITouchReceiveComponent)
  minParent:AddComponent(___MOD.TagComponent)
  local maxN = self.miniMapMax:getEntity("n")
  maxN:AddComponent(___MOD.UIWindowTouchComponent)
  dragArea = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "dragArea", ___MOD.FastVector3.zero:Clone(), minParent)
  if dragArea ~= nil then
    dragArea.SpriteGUIRendererComponent.ImageRUID = "3e9d52ed52d64794bbd6f72bab8ee3d9"
    dragArea.UITransformComponent.RectSize = ___MOD.FastVector2(self.canvasWidth - 130, 40)
    dragArea.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    dragArea.UITransformComponent.Pivot = ___MOD.FastVector2.zero:Clone()
    dragArea.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, 100)
    dragArea:AddComponent(___MOD.UIMoveableComponent)
    dragArea:SetVisible(true)
  end
  minParent.TagComponent:AddTag("miniMapMax")
  local none = ___MOD._EntityService:GetEntityByTag("miniMapNone")
  if ___MOD.isvalid(none) then
    none:Destroy()
  end
  self.miniMapNone = ___MOD.UIWindow():createUIWindow("Third", ___MOD.FastVector2(noneCanvasWidth, 40), lastPos, {
    w = {
      rectSize = ___MOD.FastVector2(16, 40),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "d4005b56dc224c4d845088e776190b61"
    },
    c = {
      rectSize = ___MOD.FastVector2(2, 40),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "aa81cb5da68b494eb17be27746f95139"
    },
    e = {
      rectSize = ___MOD.FastVector2(8, 40),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = "32d3cf2a57304f65a8fec2d4f8e5c301"
    }
  }, "miniMapNone", nil)
  local noneParent = self.miniMapNone:getParentUI()
  noneParent.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
  noneParent.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
  noneParent.UITransformComponent.anchoredPosition = ___MOD.FastVector2(17, -21)
  noneParent:AddComponent(___MOD.UIMoveableComponent)
  noneParent:AddComponent(___MOD.UITouchReceiveComponent)
  noneParent:AddComponent(___MOD.TagComponent)
  noneParent.TagComponent:AddTag("miniMapNone")
  dragArea = ___MOD._SpawnService:SpawnByModelId("model://2d10478f-2810-410a-b288-ab35f6185156", "dragArea", ___MOD.FastVector3.zero:Clone(), noneParent)
  if dragArea ~= nil then
    dragArea.SpriteGUIRendererComponent.ImageRUID = "3e9d52ed52d64794bbd6f72bab8ee3d9"
    local noneDragWidth = hideMinimap and noneCanvasWidth or self.canvasWidth - 130
    dragArea.UITransformComponent.RectSize = ___MOD.FastVector2(noneDragWidth, 40)
    dragArea.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    dragArea.UITransformComponent.Pivot = ___MOD.FastVector2.zero:Clone()
    dragArea.UITransformComponent.anchoredPosition = ___MOD.FastVector2(0, 100)
    dragArea:AddComponent(___MOD.UIMoveableComponent)
    dragArea:SetVisible(true)
  end
  local n = self.miniMapMax:getEntity("n")
  local nMin = self.miniMapMini:getEntity("n")
  local cNone = self.miniMapNone:getEntity("c")
  if parent == nil or minParent == nil or noneParent == nil then
    return
  end
  if n == nil or nMin == nil or cNone == nil then
    return
  end
  cNone.SpriteGUIRendererComponent.Color.a = 0.7
  self.miniMapNone:getEntity("w").SpriteGUIRendererComponent.Color.a = 0.7
  self.miniMapNone:getEntity("e").SpriteGUIRendererComponent.Color.a = 0.7
  if self.miniMapType == ___MOD._UIMiniMapType.Minimap_Min then
    minParent.Visible = false
    noneParent.Visible = false
    parent.Visible = true
  elseif self.miniMapType == ___MOD._UIMiniMapType.Minimap_Max then
    minParent.Visible = true
    noneParent.Visible = false
    parent.Visible = false
  else
    minParent.Visible = false
    noneParent.Visible = true
    parent.Visible = false
  end
  self:arrangeMiniMapLayerBeforeMobileChat()
  if n ~= nil then
    local emptySprite = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")

    local function getUIImageSize(path, defaultW, defaultH)
      local s = ___MOD._UIManager:getImageSize(path)
      local w = s and ___MOD.tonumber(s.x) or defaultW or 24
      local h = s and ___MOD.tonumber(s.y) or defaultH or 24
      return ___MOD.FastVector2(w, h)
    end

    local title = ___MOD._SpawnService:SpawnByEntity(emptySprite, "Title", ___MOD.Vector3(0, 0, 0), n)
    local titlePath = "UI.UIWindow.MiniMap.title"
    local titleRUID = ___MOD.__RUIDManager:get(titlePath)
    local titleSize = getUIImageSize(titlePath, 84, 12)
    if title.UITransformComponent == nil then
      return
    end
    title.UITransformComponent.RectSize = ___MOD.FastVector2(titleSize.x, titleSize.y)
    title.SpriteGUIRendererComponent.ImageRUID = titleRUID
    title.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    title.UITransformComponent.anchoredPosition = ___MOD.FastVector2(50, 47)
    title.Visible = true
    title = ___MOD._SpawnService:SpawnByEntity(emptySprite, "Title", ___MOD.Vector3(0, 0, 0), nMin)
    titleRUID = ___MOD.__RUIDManager:get(titlePath)
    title.UITransformComponent.RectSize = ___MOD.FastVector2(titleSize.x, titleSize.y)
    title.SpriteGUIRendererComponent.ImageRUID = titleRUID
    title.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    title.UITransformComponent.anchoredPosition = ___MOD.FastVector2(50, 5)
    title.Visible = true
    local btMin = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtMin", ___MOD.Vector3(0, 0, 0), n)
    local btMinPath = "UI.Basic.BtMin.normal.0"
    local normalRUID = ___MOD.__RUIDManager:get(btMinPath)
    local btMinSize = getUIImageSize(btMinPath, 22, 22)
    btMin:AddComponent(___MOD.UIButtonComponent)
    btMin.UITransformComponent.RectSize = ___MOD.FastVector2(btMinSize.x, btMinSize.y)
    btMin.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btMin.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-116, 48)
    btMin.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btMin.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    local disabledRUID = ___MOD.__RUIDManager:get("UI.Basic.BtMin.disabled.0")
    local mouseOverRUID = ___MOD.__RUIDManager:get("UI.Basic.BtMin.mouseOver.0")
    local pressedRUID = ___MOD.__RUIDManager:get("UI.Basic.BtMin.pressed.0")
    btMin.UIButtonComponent.ImageRUIDs.DisabledSprite = disabledRUID
    btMin.UIButtonComponent.ImageRUIDs.HighlightedSprite = mouseOverRUID
    btMin.UIButtonComponent.ImageRUIDs.PressedSprite = pressedRUID
    btMin.UIButtonComponent.ImageRUIDs.SelectedSprite = mouseOverRUID
    btMin:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickBtnMin()
    end)
    btMin.Visible = true
    btMin = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtMin", ___MOD.FastVector3(0, 0, 0), nMin)
    btMin:AddComponent(___MOD.UIButtonComponent)
    btMin.UITransformComponent.RectSize.x = btMinSize.x
    btMin.UITransformComponent.RectSize.y = btMinSize.y
    btMin.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btMin.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-116, 5)
    btMin.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btMin.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    btMin.UIButtonComponent.ImageRUIDs.DisabledSprite = disabledRUID
    btMin.UIButtonComponent.ImageRUIDs.HighlightedSprite = mouseOverRUID
    btMin.UIButtonComponent.ImageRUIDs.PressedSprite = pressedRUID
    btMin.UIButtonComponent.ImageRUIDs.SelectedSprite = mouseOverRUID
    btMin:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickBtnMin()
    end)
    btMin.Visible = true
    btMin = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtMin", ___MOD.FastVector3(0, 0, 0), cNone)
    btMin:AddComponent(___MOD.UIButtonComponent)
    btMin.UITransformComponent.RectSize.x = btMinSize.x
    btMin.UITransformComponent.RectSize.y = btMinSize.y
    btMin.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btMin.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-116, -20)
    btMin.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btMin.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    btMin.UIButtonComponent.ImageRUIDs.DisabledSprite = disabledRUID
    btMin.UIButtonComponent.ImageRUIDs.HighlightedSprite = mouseOverRUID
    btMin.UIButtonComponent.ImageRUIDs.PressedSprite = pressedRUID
    btMin.UIButtonComponent.ImageRUIDs.SelectedSprite = mouseOverRUID
    btMin.SpriteGUIRendererComponent.ImageRUID = disabledRUID
    btMin.UIButtonComponent.Enable = false
    btMin.Visible = true
    local btMax = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtMax", ___MOD.FastVector3(0, 0, 0), n)
    local btMaxPath = "UI.Basic.BtMax.normal.0"
    normalRUID = ___MOD.__RUIDManager:get(btMaxPath)
    local btMaxSize = getUIImageSize(btMaxPath, 22, 22)
    btMax:AddComponent(___MOD.UIButtonComponent)
    btMax.UITransformComponent.RectSize = ___MOD.FastVector2(btMaxSize.x, btMaxSize.y)
    btMax.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btMax.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-90, 48)
    btMax.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btMax.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    disabledRUID = ___MOD.__RUIDManager:get("UI.Basic.BtMax.disabled.0")
    mouseOverRUID = ___MOD.__RUIDManager:get("UI.Basic.BtMax.mouseOver.0")
    pressedRUID = ___MOD.__RUIDManager:get("UI.Basic.BtMax.pressed.0")
    btMax.UIButtonComponent.ImageRUIDs.DisabledSprite = disabledRUID
    btMax.UIButtonComponent.ImageRUIDs.HighlightedSprite = mouseOverRUID
    btMax.UIButtonComponent.ImageRUIDs.PressedSprite = pressedRUID
    btMax.UIButtonComponent.ImageRUIDs.SelectedSprite = mouseOverRUID
    btMax:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickBtnMax()
    end)
    btMax.UIButtonComponent.Enable = false
    btMax.Visible = true
    btMax = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtMax", ___MOD.FastVector3(0, 0, 0), nMin)
    btMax:AddComponent(___MOD.UIButtonComponent)
    btMax.UITransformComponent.RectSize = ___MOD.FastVector2(btMaxSize.x, btMaxSize.y)
    btMax.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btMax.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-90, 5)
    btMax.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btMax.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    btMax.UIButtonComponent.ImageRUIDs.DisabledSprite = disabledRUID
    btMax.UIButtonComponent.ImageRUIDs.HighlightedSprite = mouseOverRUID
    btMax.UIButtonComponent.ImageRUIDs.PressedSprite = pressedRUID
    btMax.UIButtonComponent.ImageRUIDs.SelectedSprite = mouseOverRUID
    btMax:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickBtnMax()
    end)
    btMax.Visible = true
    btMax = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtMax", ___MOD.FastVector3(0, 0, 0), cNone)
    btMax:AddComponent(___MOD.UIButtonComponent)
    btMax.UITransformComponent.RectSize = ___MOD.FastVector2(btMaxSize.x, btMaxSize.y)
    btMax.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btMax.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-90, -20)
    btMax.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btMax.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    btMax.UIButtonComponent.ImageRUIDs.DisabledSprite = disabledRUID
    btMax.UIButtonComponent.ImageRUIDs.HighlightedSprite = mouseOverRUID
    btMax.UIButtonComponent.ImageRUIDs.PressedSprite = pressedRUID
    btMax.UIButtonComponent.ImageRUIDs.SelectedSprite = mouseOverRUID
    btMax:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickBtnMax()
    end)
    if sprite == nil then
      btMax.SpriteGUIRendererComponent.ImageRUID = disabledRUID
      btMax.UIButtonComponent.Enable = false
    end
    btMax.Visible = true
    local btWorld = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtWorld", ___MOD.FastVector3(0, 0, 0), n)
    local btWorldPath = "UI.UIWindow.MiniMap.BtMap.normal.0"
    normalRUID = ___MOD.__RUIDManager:get(btWorldPath)
    local btWorldSize = getUIImageSize(btWorldPath, 32, 22)
    btWorld:AddComponent(___MOD.UIButtonComponent)
    btWorld.UITransformComponent.RectSize = ___MOD.FastVector2(btWorldSize.x, btWorldSize.y)
    btWorld.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btWorld.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-38, 48)
    btWorld.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btWorld.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    btWorld.UIButtonComponent.ImageRUIDs.DisabledSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.disabled.0")
    btWorld.UIButtonComponent.ImageRUIDs.HighlightedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.mouseOver.0")
    btWorld.UIButtonComponent.ImageRUIDs.PressedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.pressed.0")
    btWorld.UIButtonComponent.ImageRUIDs.SelectedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.normal.0")
    btWorld:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickBtnWorld()
    end)
    btWorld.Visible = true
    btWorld = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtWorld", ___MOD.FastVector3(0, 0, 0), nMin)
    btWorld:AddComponent(___MOD.UIButtonComponent)
    btWorld.UITransformComponent.RectSize = ___MOD.FastVector2(btWorldSize.x, btWorldSize.y)
    btWorld.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btWorld.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-38, 5)
    btWorld.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btWorld.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    btWorld.UIButtonComponent.ImageRUIDs.DisabledSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.disabled.0")
    btWorld.UIButtonComponent.ImageRUIDs.HighlightedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.mouseOver.0")
    btWorld.UIButtonComponent.ImageRUIDs.PressedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.pressed.0")
    btWorld.UIButtonComponent.ImageRUIDs.SelectedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.normal.0")
    btWorld:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickBtnWorld()
    end)
    btWorld.Visible = true
    btWorld = ___MOD._SpawnService:SpawnByEntity(emptySprite, "BtWorld", ___MOD.FastVector3(0, 0, 0), cNone)
    btWorld:AddComponent(___MOD.UIButtonComponent)
    btWorld.UITransformComponent.RectSize = ___MOD.FastVector2(btWorldSize.x, btWorldSize.y)
    btWorld.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopRight
    btWorld.UITransformComponent.anchoredPosition = ___MOD.FastVector2(-38, -20)
    btWorld.SpriteGUIRendererComponent.ImageRUID = normalRUID
    btWorld.UIButtonComponent.Transition = ___MOD.TransitionType.SpriteSwap
    btWorld.UIButtonComponent.ImageRUIDs.DisabledSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.disabled.0")
    btWorld.UIButtonComponent.ImageRUIDs.HighlightedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.mouseOver.0")
    btWorld.UIButtonComponent.ImageRUIDs.PressedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.pressed.0")
    btWorld.UIButtonComponent.ImageRUIDs.SelectedSprite = ___MOD.__RUIDManager:get("UI.UIWindow.MiniMap.BtMap.normal.0")
    btWorld:ConnectEvent(___MOD.ButtonClickEvent, function()
      self:onClickBtnWorld()
    end)
    btWorld.Visible = true
    if sprite ~= nil and mapInfo.mapMark ~= nil and mapInfo.mapMark ~= "" then
      local markRUID = ___MOD._DataSetUtils:getData("MinimapMarkRUID", "ID", "mark." .. mapInfo.mapMark, "RUID")
      local markSprite = markRUID ~= nil and markRUID ~= "" and ___MOD._ResourceService:LoadSpriteAndWait(markRUID) or nil
      if markSprite ~= nil then
        local minimapMark = ___MOD._SpawnService:SpawnByEntity(emptySprite, "MinimapMark", ___MOD.FastVector3(0, 0, 0), n)
        local ms = minimapMark.SpriteGUIRendererComponent
        ms.ImageRUID = markRUID
        minimapMark.UITransformComponent.RectSize = ___MOD.FastVector2(markSprite.Width, markSprite.Height)
        minimapMark.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
        minimapMark.UITransformComponent.anchoredPosition = ___MOD.FastVector2(40, -13)
        minimapMark.Visible = true
      end
    end
    local minMapStreetName = ___MOD._SpawnService:SpawnByEntity(emptyText, "StreetName", ___MOD.FastVector3(90, 76.5, 0), n)
    local minMapName = ___MOD._SpawnService:SpawnByEntity(emptyText, "MapName", ___MOD.FastVector3(90, 44.5, 0), n)
    minMapStreetName:AddComponent(___MOD.BitmapFontRendererComponent)
    minMapName:AddComponent(___MOD.BitmapFontRendererComponent)
    local g = minMapName.BitmapFontRendererComponent
    minMapStreetName.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
    minMapName.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
    minMapStreetName.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
    minMapName.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
    minMapName.UITransformComponent.anchoredPosition.x = 90
    minMapStreetName.UITransformComponent.anchoredPosition.x = 90
    g:drawTextArg(mapName, ___MOD._BitmapFontType.Gulim9pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, true, false, ___MOD.FastColor.clear, false, nil, 0)
    local g2 = minMapStreetName.BitmapFontRendererComponent
    g2:drawTextArg(streetName, ___MOD._BitmapFontType.Gulim9pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, true, false, ___MOD.FastColor.clear, false, nil, 0)
    minMapName = ___MOD._SpawnService:SpawnByEntity(emptyText, "MapName", ___MOD.FastVector3(0, 0, 0), cNone)
    minMapName:AddComponent(___MOD.BitmapFontRendererComponent)
    g = minMapName.BitmapFontRendererComponent
    minMapName.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
    minMapName.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
    minMapName.UITransformComponent.anchoredPosition.x = 0
    g:drawTextArg(noneName, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.black, false, false, ___MOD.FastColor.clear, false, nil, 0)
    if hideMinimap then
      noneParent.Visible = true
      if ___MOD.isvalid(parent) then
        parent.Visible = false
      end
      if ___MOD.isvalid(minParent) then
        minParent.Visible = false
      end
      self._T.currentMiniMapMapID = mapID
      return
    end
    if sprite ~= nil then
      local maxCanvasParent = self.miniMapMax:getParentUI()
      local miniCanvasParent = self.miniMapMini:getParentUI()
      if maxCanvasParent == nil or miniCanvasParent == nil then
        return
      end
      local emptyEntity = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyEntity")
      local mask = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "MinimapCanvasMask", ___MOD.FastVector3(0, 0, 0), maxCanvasParent)
      if mask == nil then
        return
      end
      mask.UITransformComponent.RectSize = ___MOD.FastVector2(self.canvasWidth, self.canvasHeight)
      mask.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
      mask.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
      mask.UITransformComponent.anchoredPosition.x = 0
      mask:AddComponent(___MOD.MaskComponent)
      local minimapBg = ___MOD._SpawnService:SpawnByEntity(emptySprite, "MinimapCanvasBg", ___MOD.FastVector3(0, 0, 0), mask)
      local blackBg = ___MOD._SpawnService:SpawnByEntity(emptySprite, "blackBg", ___MOD.FastVector3(0, 0, 0), minimapBg)
      blackBg.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0.5)
      blackBg.UITransformComponent.RectSize = ___MOD.FastVector2(sprite.Width, sprite.Height)
      blackBg.SpriteGUIRendererComponent.Color = ___MOD.FastColor(0, 0, 0, 0.7)
      blackBg.UITransformComponent.anchoredPosition.x = 0
      blackBg.UITransformComponent.anchoredPosition.y = 0
      blackBg.Visible = true
      local minimapCanvas = ___MOD._SpawnService:SpawnByEntity(emptySprite, "MinimapCanvas", ___MOD.FastVector3(0, 0, 0), minimapBg)
      local s = minimapCanvas.SpriteGUIRendererComponent
      s.ImageRUID = ruid
      minimapBg.SpriteGUIRendererComponent.Color = ___MOD.FastColor(1, 1, 1, 0.25)
      minimapBg.UITransformComponent.RectSize.x = self.canvasWidth
      minimapBg.UITransformComponent.RectSize.y = self.canvasHeight
      minimapBg.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
      minimapBg.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
      minimapBg.UITransformComponent.anchoredPosition.x = 0
      minimapCanvas.UITransformComponent.RectSize = ___MOD.FastVector2(sprite.Width, sprite.Height)
      minimapCanvas.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.BottomLeft
      minimapCanvas.UITransformComponent.Pivot = ___MOD.FastVector2.zero:Clone()
      minimapCanvas.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
      minimapBg.Visible = true
      minimapCanvas.Visible = true
      self.maxCanvas = minimapCanvas
      local leftBottom, rightTop = ___MOD._CameraService:GetCurrentCameraComponent():GetBound()
      local worldLeftX = leftBottom.x
      local worldRightX = rightTop.x
      local worldWidth = worldRightX - worldLeftX
      local playerPos = ___MOD._UserService.LocalPlayer.TransformComponent:WorldPositionAsFastVector3()
      local progress = (playerPos.x - leftBottom.x) / worldWidth
      local temp = self.canvasSpriteWidth * (6.4 / worldWidth)
      if playerPos.x - worldLeftX >= 6.4 then
        self.baseCanvasX = -self.canvasSpriteWidth * progress + temp
      else
        self.baseCanvasX = 0
      end
      if self.canScrollX and not self.canScrollY then
        minimapCanvas.UITransformComponent.Position.x = self.baseCanvasX
      end
      mask = ___MOD._SpawnService:SpawnByEntity(emptyEntity, "MinimapCanvasMask", ___MOD.FastVector3(0, 0, 0), miniCanvasParent)
      if mask == nil then
        return
      end
      mask.UITransformComponent.RectSize = ___MOD.FastVector2(self.canvasWidth, self.canvasHeight)
      mask.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
      mask.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
      mask.UITransformComponent.anchoredPosition.x = 0
      mask:AddComponent(___MOD.MaskComponent)
      minimapBg = ___MOD._SpawnService:SpawnByEntity(emptySprite, "MinimapCanvasBg", ___MOD.FastVector3(0, 0, 0), mask)
      blackBg = ___MOD._SpawnService:SpawnByEntity(emptySprite, "blackBg", ___MOD.FastVector3(0, 0, 0), minimapBg)
      blackBg.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0.5)
      blackBg.UITransformComponent.RectSize = ___MOD.FastVector2(sprite.Width, sprite.Height)
      blackBg.SpriteGUIRendererComponent.Color = ___MOD.FastColor(0, 0, 0, 0.7)
      blackBg.UITransformComponent.anchoredPosition.x = 0
      blackBg.UITransformComponent.anchoredPosition.y = 0
      blackBg.Visible = true
      minimapCanvas = ___MOD._SpawnService:SpawnByEntity(emptySprite, "MinimapCanvas", ___MOD.FastVector3(0, 0, 0), minimapBg)
      s = minimapCanvas.SpriteGUIRendererComponent
      s.ImageRUID = ruid
      minimapBg.SpriteGUIRendererComponent.Color = ___MOD.FastColor(1, 1, 1, 0.25)
      minimapBg.UITransformComponent.RectSize = ___MOD.FastVector2(self.canvasWidth, self.canvasHeight)
      minimapBg.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
      minimapBg.UITransformComponent.RectSize.y = self.canvasHeight
      minimapBg.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
      minimapBg.UITransformComponent.anchoredPosition.x = 0
      minimapCanvas.UITransformComponent.RectSize = ___MOD.FastVector2(sprite.Width, sprite.Height)
      minimapCanvas.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.BottomLeft
      minimapCanvas.UITransformComponent.Pivot = ___MOD.FastVector2.zero:Clone()
      minimapCanvas.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
      minimapBg.Visible = true
      minimapCanvas.Visible = true
      self.miniCanvas = minimapCanvas
      if self.canScrollX and not self.canScrollY then
        minimapCanvas.UITransformComponent.Position.x = self.baseCanvasX
      end
    else
      self.miniMapType = ___MOD._UIMiniMapType.Minimap_None
      self.miniMapNone:getParentUI().Visible = true
      self.miniMapMax:getParentUI().Visible = false
      self.miniMapMini:getParentUI().Visible = false
    end
    if sprite ~= nil then
      self:createNpcIcon()
      self:createPortalIcon()
    end
    self._T.currentMiniMapMapID = mapID
  end
end

function UIMiniMap.createNpcIcon(self)
  local miniMapPlayer = self:getMiniMapPlayer()
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(miniMapPlayer) or miniMapPlayer.CurrentMap == nil or not ___MOD.isvalid(localPlayer) then
    return
  end
  local lifepools = miniMapPlayer.CurrentMap:GetChildComponentsByTypeName("LifePoolComponent")
  for _, lifepool in ___MOD.ipairs(lifepools) do
    if lifepool.type == "n" then
      local npcID = lifepool.id
      local questConditionManaged = ___MOD._NpcManager:isQuestConditionNpc(npcID)
      local shouldShowNpcIcon = true
      if questConditionManaged then
        shouldShowNpcIcon = ___MOD._NpcManager:isNpcVisibleForQuest(npcID, localPlayer.QuestComponent)
      end
      if ___MOD._NpcConstants:checkCanSpawn(npcID) and (not lifepool.hide or questConditionManaged) then
        local emptySprite = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")
        local position = lifepool.Entity.TransformComponent:WorldPositionAsFastVector3()
        local canStartList, inProgressList, canCompleteList = ___MOD._QuestManager:getQuestInfoByNpcID(localPlayer, npcID)
        local state = -1
        if 0 < #canStartList then
          state = 0
        end
        if 0 < #canCompleteList then
          state = 1
        end
        local iconNpc = ___MOD._SpawnService:SpawnByEntity(emptySprite, "iconNpc" .. npcID, ___MOD.FastVector3(0, 0, 0), self.maxCanvas)
        if state == 0 then
          iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 26)
          iconNpc.SpriteGUIRendererComponent.ImageRUID = "ccef719bb5d14e068cbf099f0bf68a53"
        elseif state == 1 then
          iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 26)
          iconNpc.SpriteGUIRendererComponent.ImageRUID = "56263f71bad14cf6b3f0e70058682d2b"
        else
          iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 14)
          iconNpc.SpriteGUIRendererComponent.ImageRUID = "cc008ed233c2464398f3cd9514e34b1c"
        end
        local npcName = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Npc.img/%d/name", npcID))
        iconNpc:AddComponent(___MOD.UITouchReceiveComponent)
        iconNpc:AddComponent(___MOD.TooltipComponent)
        iconNpc.TooltipComponent.type = ___MOD._TooltipType.TEXT
        iconNpc.TooltipComponent.text = npcName
        iconNpc.TooltipComponent.maxWidth = nil
        iconNpc.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
        iconNpc.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0)
        iconNpc.Visible = shouldShowNpcIcon
        local mPos = self:worldToMiniMap(___MOD.FastVector2(position.x, position.y))
        iconNpc.UITransformComponent.anchoredPosition = mPos
        iconNpc = ___MOD._SpawnService:SpawnByEntity(emptySprite, "iconNpc" .. npcID, ___MOD.FastVector3(0, 0, 0), self.miniCanvas)
        if state == 0 then
          iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 26)
          iconNpc.SpriteGUIRendererComponent.ImageRUID = "ccef719bb5d14e068cbf099f0bf68a53"
        elseif state == 1 then
          iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 26)
          iconNpc.SpriteGUIRendererComponent.ImageRUID = "56263f71bad14cf6b3f0e70058682d2b"
        else
          iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 14)
          iconNpc.SpriteGUIRendererComponent.ImageRUID = "cc008ed233c2464398f3cd9514e34b1c"
        end
        iconNpc:AddComponent(___MOD.UITouchReceiveComponent)
        iconNpc:AddComponent(___MOD.TooltipComponent)
        iconNpc.TooltipComponent.type = ___MOD._TooltipType.TEXT
        iconNpc.TooltipComponent.text = npcName
        iconNpc.TooltipComponent.maxWidth = nil
        iconNpc.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
        iconNpc.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0)
        iconNpc.Visible = shouldShowNpcIcon
        mPos = self:worldToMiniMap(___MOD.FastVector2(position.x, position.y))
        iconNpc.UITransformComponent.anchoredPosition = mPos
      end
    end
  end
end

function UIMiniMap.createOrUpdateTargetIcon(self, userId, type, pos)
  if self._T.hideMinimap then
    return
  end
  if self.maxCanvas == nil and self.miniCanvas == nil then
    return
  end
  if ___MOD.isvalid(self.maxCanvas) then
    self:createOrUpdateTargetIconInCanvas(userId, type, pos, self.maxCanvas)
  end
  if ___MOD.isvalid(self.miniCanvas) then
    self:createOrUpdateTargetIconInCanvas(userId, type, pos, self.miniCanvas)
  end
end

function UIMiniMap.createOrUpdateTargetIconInCanvas(self, userId, type, pos, canvas)
  local name = "iconAnother_" .. userId
  local icon = canvas:GetChildByName(name)
  if not ___MOD.isvalid(icon) then
    local template = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")
    icon = ___MOD._SpawnService:SpawnByEntity(template, name, ___MOD.FastVector3(0, 0, 0), canvas)
    icon.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    icon.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0)
    icon.Visible = true
  end
  self:applyIconStyle(icon, type)
  icon.UITransformComponent.anchoredPosition = self:worldToMiniMap(___MOD.FastVector2(pos.x, pos.y))
end

function UIMiniMap.createPortalIcon(self)
  local miniMapPlayer = self:getMiniMapPlayer()
  if not ___MOD.isvalid(miniMapPlayer) or miniMapPlayer.CurrentMap == nil then
    return
  end
  local currentMapName = miniMapPlayer.CurrentMapName
  local entites = ___MOD._EntityService:GetEntitiesByTag("CustomPortal")
  if ___MOD.isvalid(entites) then
    for _, entity in ___MOD.ipairs(entites) do
      if ___MOD.isvalid(entity) and entity.CurrentMapName == currentMapName then
        local portal = entity.ExtendPortalComponent
        if ___MOD.isvalid(portal) and (portal.portalType == ___MOD._PortalType.PortalVisible_pv_2 or portal.portalType == ___MOD._PortalType.PortalScript_ps_7) then
          local emptySprite = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")
          local position = entity.TransformComponent:WorldPositionAsFastVector3()
          local iconPortal = ___MOD._SpawnService:SpawnByEntity(emptySprite, "iconPortal" .. portal.portalName, ___MOD.FastVector3(0, 0, 0), self.maxCanvas)
          iconPortal.UITransformComponent.RectSize = ___MOD.FastVector2(16, 16)
          iconPortal.SpriteGUIRendererComponent.ImageRUID = "a05fac186bcf48fa96d103a4f25faa25"
          iconPortal.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
          iconPortal.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0)
          iconPortal.Visible = true
          local mapName = ___MOD._StringPoolManager:getMapName(portal.targetMap)
          if not ___MOD._UtilLogic:IsNilorEmptyString(mapName) then
            iconPortal:AddComponent(___MOD.UITouchReceiveComponent)
            iconPortal:AddComponent(___MOD.TooltipComponent)
            iconPortal.TooltipComponent.type = ___MOD._TooltipType.TEXT
            iconPortal.TooltipComponent.text = mapName
            iconPortal.TooltipComponent.maxWidth = nil
          end
          local mPos = self:worldToMiniMap(___MOD.FastVector2(position.x, position.y))
          iconPortal.UITransformComponent.anchoredPosition = mPos
          iconPortal = ___MOD._SpawnService:SpawnByEntity(emptySprite, "iconPortal" .. portal.portalName, ___MOD.FastVector3(0, 0, 0), self.miniCanvas)
          iconPortal.UITransformComponent.RectSize = ___MOD.FastVector2(16, 16)
          iconPortal.SpriteGUIRendererComponent.ImageRUID = "a05fac186bcf48fa96d103a4f25faa25"
          iconPortal.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
          iconPortal.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0)
          iconPortal.Visible = true
          if not ___MOD._UtilLogic:IsNilorEmptyString(mapName) then
            iconPortal:AddComponent(___MOD.UITouchReceiveComponent)
            iconPortal:AddComponent(___MOD.TooltipComponent)
            iconPortal.TooltipComponent.type = ___MOD._TooltipType.TEXT
            iconPortal.TooltipComponent.text = mapName
            iconPortal.TooltipComponent.maxWidth = nil
          end
          mPos = self:worldToMiniMap(___MOD.FastVector2(position.x, position.y))
          iconPortal.UITransformComponent.anchoredPosition = mPos
        end
      end
    end
  end
end

function UIMiniMap.createTargetIcon(self, userId, pos)
  if self._T.hideMinimap then
    return
  end
  local v = ___MOD._UserService:GetUserEntityByUserId(userId)
  if not ___MOD.isvalid(v) then
    return
  end
  if v.Player ~= nil and v.Player.AdminHidden == true then
    self:destroyTargetIcon(userId)
    return
  end
  if self.maxCanvas == nil and self.miniCanvas == nil then
    return
  end
  local type = self:getTargetIconType(v)
  self:createOrUpdateTargetIcon(userId, type, pos)
end

function UIMiniMap.destroyStaleTargetIcons(self, canvas, activeUserIds)
  if not ___MOD.isvalid(canvas) then
    return
  end
  local prefix = "iconAnother_"
  if self._T.staleMiniMapUserIds == nil then
    self._T.staleMiniMapUserIds = {}
  end
  local staleUserIds = self._T.staleMiniMapUserIds
  for i, _ in ___MOD.pairs(staleUserIds) do
    staleUserIds[i] = nil
  end
  for _, child in ___MOD.pairs(canvas.Children) do
    local childName = child.Name
    if ___MOD.string.sub(childName, 1, #prefix) == prefix then
      local userId = ___MOD.string.sub(childName, #prefix + 1)
      if activeUserIds[userId] ~= true then
        ___MOD.table.insert(staleUserIds, userId)
      end
    end
  end
  for _, userId in ___MOD.pairs(staleUserIds) do
    self:destroyTargetIcon(userId)
  end
end

function UIMiniMap.destroyTargetIcon(self, userId)
  if not self.maxCanvas or not self.miniCanvas then
    return
  end
  local iconAnother = self.maxCanvas:GetChildByName("iconAnother_" .. userId)
  if ___MOD.isvalid(iconAnother) then
    iconAnother:Destroy()
  end
  iconAnother = self.miniCanvas:GetChildByName("iconAnother_" .. userId)
  if ___MOD.isvalid(iconAnother) then
    iconAnother:Destroy()
  end
end

function UIMiniMap.getAnchoredPos(self, canvasSize, spriteSize)
  if spriteSize <= canvasSize then
    return (canvasSize - spriteSize) / 2
  else
    return 0
  end
end

function UIMiniMap.getFriendGroup(self)
  local groups = {}
  local find = false
  for _, g in ___MOD.pairs(___MOD._UserService.LocalPlayer.FriendComponent.friend) do
    local group = g
    ___MOD.table.insert(groups, group)
    find = true
  end
  if not find then
    return nil
  end
  return groups
end

function UIMiniMap.getMiniMapPlayer(self)
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(localPlayer) or ___MOD._ObserverService == nil or localPlayer.PlayerComponent == nil then
    return localPlayer
  end
  local observedUserProfileCode = ___MOD._ObserverService:GetObservedUserProfileCode(localPlayer.PlayerComponent.ProfileCode)
  if observedUserProfileCode == nil or observedUserProfileCode == "" then
    return localPlayer
  end
  local observedUser = ___MOD._UserService:GetUserByProfileCode(observedUserProfileCode)
  if observedUser == nil then
    return localPlayer
  end
  local observedUserEntity = ___MOD._UserService:GetUserEntityByUserId(observedUser.UserId)
  if ___MOD.isvalid(observedUserEntity) and observedUserEntity.CurrentMap ~= nil then
    return observedUserEntity
  end
  return localPlayer
end

function UIMiniMap.getTargetIconType(self, userEntity)
  local type = 1
  local toFriend = self:getFriendGroup()
  local targetPlayerId = ___MOD.tostring(userEntity.Player.PlayerId or "")
  if toFriend and not ___MOD._UtilLogic:IsNilorEmptyString(targetPlayerId) then
    for _, group in ___MOD.pairs(toFriend) do
      for __, node in ___MOD.pairs(group.node) do
        if node.playerId == targetPlayerId and node.accepted then
          return 2
        end
      end
    end
  end
  local localPlayer = ___MOD._UserService.LocalPlayer
  if localPlayer.Player.PartyId ~= 0 and localPlayer.Player.PartyId == userEntity.Player.PartyId then
    local m = localPlayer.PartyUIComponent:findPartyMemberByName(userEntity.Player.Name)
    if m and m.isLeader then
      return 4
    end
    return 3
  end
  local localGuildId = ___MOD.tonumber(localPlayer.Player.GuildId or 0) or 0
  local targetGuildId = ___MOD.tonumber(userEntity.Player.GuildId or 0) or 0
  if 0 < localGuildId and localGuildId == targetGuildId then
    local guildData = localPlayer.Player.guildData
    if guildData ~= nil and guildData.GuildMembers ~= nil then
      for _, memberInfo in ___MOD.pairs(guildData.GuildMembers) do
        local memberPlayerId = ___MOD.tostring(memberInfo.PlayerId or "")
        if memberPlayerId == targetPlayerId then
          local rankNo = ___MOD.tonumber(memberInfo.Rank or 0) or 0
          if rankNo == 1 then
            return 6
          end
          break
        end
      end
    end
    return 5
  end
  return type
end

function UIMiniMap.OnBeginPlay(self)
  self.miniMapTransitionRules = {
    onClickBtnMax = {
      [___MOD._UIMiniMapType.Minimap_None] = function()
        self:switchMiniMapUI(___MOD._UIMiniMapType.Minimap_Min, self.miniMapNone, self.miniMapMini, -3, -self:calculateHeightOffset(139))
      end,
      [___MOD._UIMiniMapType.Minimap_Min] = function()
        self:switchMiniMapUI(___MOD._UIMiniMapType.Minimap_Max, self.miniMapMini, self.miniMapMax, 0, -86)
      end
    },
    onMinimapKey = {
      [___MOD._UIMiniMapType.Minimap_Max] = function()
        self:switchMiniMapUI(___MOD._UIMiniMapType.Minimap_Min, self.miniMapMax, self.miniMapMini, 0, 86)
      end,
      [___MOD._UIMiniMapType.Minimap_Min] = function()
        self:switchMiniMapUI(___MOD._UIMiniMapType.Minimap_None, self.miniMapMini, self.miniMapNone, 3, self:calculateHeightOffset(139))
      end,
      [___MOD._UIMiniMapType.Minimap_None] = function()
        self:switchMiniMapUI(___MOD._UIMiniMapType.Minimap_Max, self.miniMapNone, self.miniMapMax, -3, -86 - self:calculateHeightOffset(139))
      end
    },
    onClickBtnMin = {
      [___MOD._UIMiniMapType.Minimap_Min] = function()
        self:switchMiniMapUI(___MOD._UIMiniMapType.Minimap_None, self.miniMapMini, self.miniMapNone, 3, self:calculateHeightOffset(139))
      end,
      [___MOD._UIMiniMapType.Minimap_Max] = function()
        self:switchMiniMapUI(___MOD._UIMiniMapType.Minimap_Min, self.miniMapMax, self.miniMapMini, 0, 86)
      end
    }
  }
end

function UIMiniMap.onClickBtnMax(self)
  if self._T.hideMinimap then
    return
  end
  local h = self.miniMapTransitionRules.onClickBtnMax[self.miniMapType]
  if h then
    h()
  end
end

function UIMiniMap.onClickBtnMin(self)
  if self._T.hideMinimap then
    return
  end
  local h = self.miniMapTransitionRules.onClickBtnMin[self.miniMapType]
  if h then
    h()
  end
end

function UIMiniMap.onClickBtnWorld(self)
  ___MOD._PlayerKeyActionFunction:onWorldmap()
end

function UIMiniMap.onMinimapKey(self)
  if self._T.hideMinimap then
    return
  end
  local h = self.miniMapTransitionRules.onMinimapKey[self.miniMapType]
  if h then
    h()
  end
end

function UIMiniMap.OnUpdate(self, delta)
  if self._T.hideMinimap then
    return
  end
  if self.miniMapType == ___MOD._UIMiniMapType.Minimap_None then
    return
  end
  local currentTime = ___MOD._UtilLogic.ElapsedSeconds
  if self.lastUpdateTime == 0 or currentTime - self.lastUpdateTime >= 0.1 then
    self.lastUpdateTime = currentTime
    local player = self:getMiniMapPlayer()
    if not ___MOD.isvalid(player) then
      return
    end
    if player.CurrentMap == nil then
      return
    end
    local mapInfoComponent = player.CurrentMap.MapInfoComponent
    if not ___MOD.isvalid(mapInfoComponent) then
      return
    end
    local canvasWidth = self.canvasSpriteWidth
    local canvasHeight = self.canvasSpriteHeight
    local visibleWidth = self.canvasWidth
    local visibleHeight = self.canvasHeight
    local c = self.miniMapType == ___MOD._UIMiniMapType.Minimap_Max and self.maxCanvas or self.miniCanvas
    if not ___MOD.isvalid(c) then
      return
    end
    self:onUpdateIcon()
    local transform = c.UITransformComponent
    local playerWorldPos = player.TransformComponent:WorldPositionAsFastVector3()
    local pos = self:worldToMiniMap(___MOD.FastVector2(playerWorldPos.x, playerWorldPos.y))
    if self.canScrollX then
      local scrollRangeX = visibleWidth - canvasWidth
      local centerX = visibleWidth / 2
      local moveX = centerX - pos.x
      transform.anchoredPosition.x = self:clamp(moveX, scrollRangeX, 0)
    else
      transform.anchoredPosition.x = (visibleWidth - canvasWidth) / 2
    end
    if self.canScrollY then
      local scrollMinY = -(canvasHeight - visibleHeight)
      local scrollMaxY = 0
      local viewCenterOffset = visibleHeight / 2
      local iconY = pos.y
      local anchoredY = scrollMinY
      if iconY < -viewCenterOffset then
        anchoredY = scrollMinY - (iconY + viewCenterOffset)
      end
      anchoredY = self:clamp(anchoredY, scrollMinY, 0)
      transform.anchoredPosition.y = anchoredY
    else
      transform.anchoredPosition.y = (visibleHeight - canvasHeight) / 2
    end
  end
end

function UIMiniMap.onUpdateIcon(self)
  local player = self:getMiniMapPlayer()
  local c = self.miniMapType == ___MOD._UIMiniMapType.Minimap_Max and self.maxCanvas or self.miniCanvas
  if not ___MOD.isvalid(player) or not ___MOD.isvalid(c) then
    return
  end
  local iconUser = c:GetChildByName("iconUser")
  if not ___MOD.isvalid(iconUser) then
    local emptySprite = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")
    iconUser = ___MOD._SpawnService:SpawnByEntity(emptySprite, "iconUser", ___MOD.FastVector3(0, 0, 0), c)
    iconUser.UITransformComponent.RectSize = ___MOD.FastVector2(12, 12)
    iconUser.SpriteGUIRendererComponent.ImageRUID = "33a561c348b440e18936d4ef890eb47c"
    iconUser.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
    iconUser.UITransformComponent.Pivot = ___MOD.FastVector2(0.5, 0)
    iconUser.Visible = true
  end
  local playerWorldPos = player.TransformComponent:WorldPositionAsFastVector3()
  local pos = self:worldToMiniMap(playerWorldPos:ToVector2())
  iconUser.UITransformComponent.anchoredPosition = pos
  if self._T.activeMiniMapUserIds == nil then
    self._T.activeMiniMapUserIds = {}
  end
  local activeUserIds = self._T.activeMiniMapUserIds
  for userId, _ in ___MOD.pairs(activeUserIds) do
    activeUserIds[userId] = nil
  end
  for i, p in ___MOD.pairs(___MOD._UserService:GetUsersByMapComponent(player.CurrentMap.MapComponent)) do
    if self:canShowTargetIcon(player, p) then
      activeUserIds[p.PlayerComponent.UserId] = true
      local iconAnother = c:GetChildByName("iconAnother_" .. p.PlayerComponent.UserId)
      if ___MOD.isvalid(iconAnother) then
        local wPos = p.TransformComponent:WorldPositionAsFastVector3()
        local mPos = self:worldToMiniMap(wPos:ToVector2())
        iconAnother.UITransformComponent.anchoredPosition = mPos
      end
    end
  end
  self:destroyStaleTargetIcons(c, activeUserIds)
end

function UIMiniMap.refreshMiniMap(self)
  local player = self:getMiniMapPlayer()
  if not ___MOD.isvalid(player) or player.CurrentMap == nil then
    return
  end
  local mapInfo = player.CurrentMap.MapInfoComponent
  if not ___MOD.isvalid(mapInfo) then
    return
  end
  local mapID = mapInfo.mapID
  if self._T.currentMiniMapMapID ~= mapID then
    local miniParent = self.miniMapMini ~= nil and self.miniMapMini:getParentUI() or nil
    local maxParent = self.miniMapMax ~= nil and self.miniMapMax:getParentUI() or nil
    local noneParent = self.miniMapNone ~= nil and self.miniMapNone:getParentUI() or nil
    if not (___MOD.isvalid(miniParent) and ___MOD.isvalid(maxParent)) or not ___MOD.isvalid(noneParent) then
      return
    end
    self:clearMapScopedIcons()
    local mapName = ___MOD._MapUtils:getMapNameById(mapID)
    local streetName = ___MOD._MapUtils:getStreetNameById(mapID)
    if mapName == nil or streetName == nil then
      return
    end
    local hideMinimap = mapInfo.hideMinimap == true
    local ruid = ___MOD._DataSetUtils:getData("MinimapRUID", "ID", ___MOD.string.format("%09d", mapID) .. ".img.miniMap", "RUID")
    local sprite = not hideMinimap and ruid ~= nil and ___MOD._ResourceService:LoadSpriteAndWait(ruid) or nil
    self._T.hideMinimap = hideMinimap
    if sprite ~= nil and ___MOD.isvalid(self.miniCanvas) and ___MOD.isvalid(self.maxCanvas) then
      local maxWidth = ___MOD.math.max(self:calculateNameWidth(mapName), self:calculateNameWidth(streetName))
      self.canScrollX = sprite.Width > self.CANVAS_MAX_WIDTH
      self.canScrollY = sprite.Height > self.CANVAS_MAX_HEIGHT
      self.canScroll = self.canScrollX or self.canScrollY
      self.canvasWidth = ___MOD.math.max(maxWidth, ___MOD.math.min(sprite.Width, self.CANVAS_MAX_WIDTH))
      self.canvasHeight = ___MOD.math.max(self.CANVAS_MIN_HEIGHT, ___MOD.math.min(sprite.Height, self.CANVAS_MAX_HEIGHT))
      self.canvasSpriteWidth = sprite.Width
      self.canvasSpriteHeight = sprite.Height
      local viewportSize = ___MOD.FastVector2(self.canvasWidth, self.canvasHeight)
      local spriteSize = ___MOD.FastVector2(sprite.Width, sprite.Height)
      self:resizeMiniMapWindow(self.miniMapMini, viewportSize)
      self:resizeMiniMapWindow(self.miniMapMax, viewportSize)
      self:updateMiniMapCanvas(self.miniCanvas, ruid, spriteSize, viewportSize)
      self:updateMiniMapCanvas(self.maxCanvas, ruid, spriteSize, viewportSize)
      local miniY = -160
      local maxY = -246
      if self.canvasHeight < self.CANVAS_MAX_HEIGHT then
        local delta = (self.CANVAS_MAX_HEIGHT - self.canvasHeight) / 2
        miniY = miniY + delta
        maxY = maxY + delta
      end
      miniParent.UITransformComponent.anchoredPosition = ___MOD.FastVector2(14, miniY)
      maxParent.UITransformComponent.anchoredPosition = ___MOD.FastVector2(14, maxY)
      local maxDragArea = maxParent:GetChildByName("dragArea")
      if ___MOD.isvalid(maxDragArea) then
        maxDragArea.UITransformComponent.RectSize = ___MOD.FastVector2(self.canvasWidth - 130, 40)
      end
      local miniDragArea = miniParent:GetChildByName("dragArea")
      if ___MOD.isvalid(miniDragArea) then
        miniDragArea.UITransformComponent.RectSize = ___MOD.FastVector2(self.canvasWidth - 130, 40)
      end
      self.miniMapType = self.selectedMiniMapType
    else
      self.miniMapType = ___MOD._UIMiniMapType.Minimap_None
    end
    local emptySprite = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptySprite")
    local emptyText = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/EmptyText")
    local maxHeader = self.miniMapMax:getEntity("n")
    if ___MOD.isvalid(maxHeader) then
      local markRUID
      if sprite ~= nil and mapInfo.mapMark ~= nil and mapInfo.mapMark ~= "" then
        markRUID = ___MOD._DataSetUtils:getData("MinimapMarkRUID", "ID", "mark." .. mapInfo.mapMark, "RUID")
        if markRUID == "" then
          markRUID = nil
        end
      end
      local minimapMark = maxHeader:GetChildByName("MinimapMark")
      local currentMarkRUID = ___MOD.isvalid(minimapMark) and minimapMark.SpriteGUIRendererComponent ~= nil and minimapMark.SpriteGUIRendererComponent.ImageRUID or nil
      if markRUID == nil then
        if ___MOD.isvalid(minimapMark) then
          minimapMark:Destroy()
        end
      elseif markRUID ~= currentMarkRUID then
        local markSprite = ___MOD._ResourceService:LoadSpriteAndWait(markRUID)
        if markSprite ~= nil then
          if ___MOD.isvalid(minimapMark) then
            minimapMark.SpriteGUIRendererComponent.ImageRUID = markRUID
            minimapMark.UITransformComponent.RectSize = ___MOD.FastVector2(markSprite.Width, markSprite.Height)
            minimapMark.Visible = true
          elseif ___MOD.isvalid(emptySprite) then
            minimapMark = ___MOD._SpawnService:SpawnByEntity(emptySprite, "MinimapMark", ___MOD.FastVector3(0, 0, 0), maxHeader)
            minimapMark.SpriteGUIRendererComponent.ImageRUID = markRUID
            minimapMark.UITransformComponent.RectSize = ___MOD.FastVector2(markSprite.Width, markSprite.Height)
            minimapMark.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.TopLeft
            minimapMark.UITransformComponent.anchoredPosition = ___MOD.FastVector2(40, -13)
            minimapMark.Visible = true
          end
        elseif ___MOD.isvalid(minimapMark) then
          minimapMark:Destroy()
        end
      end

      local function rebuildMaxHeaderName(entityName, text, spawnY)
        local old = maxHeader:GetChildByName(entityName)
        local oldText = ___MOD.isvalid(old) and old.BitmapFontRendererComponent ~= nil and old.BitmapFontRendererComponent.text or nil
        if ___MOD.isvalid(old) and oldText == text then
          return
        end
        if ___MOD.isvalid(old) then
          old:Destroy()
        end
        if not ___MOD.isvalid(emptyText) then
          return
        end
        local nameEntity = ___MOD._SpawnService:SpawnByEntity(emptyText, entityName, ___MOD.FastVector3(90, spawnY, 0), maxHeader)
        nameEntity:AddComponent(___MOD.BitmapFontRendererComponent)
        nameEntity.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
        nameEntity.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
        nameEntity.UITransformComponent.anchoredPosition.x = 90
        nameEntity.BitmapFontRendererComponent:drawTextArg(text, ___MOD._BitmapFontType.Gulim9pt_bold, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.white, true, false, ___MOD.FastColor.clear, false, nil, 0)
      end

      rebuildMaxHeaderName("StreetName", streetName, 76.5)
      rebuildMaxHeaderName("MapName", mapName, 44.5)
    end
    local noneName = self:tripTo40Bytes(streetName .. "  " .. mapName)
    local noneCenter = self.miniMapNone:getEntity("c")
    if ___MOD.isvalid(noneCenter) then
      local oldNoneMapName = noneCenter:GetChildByName("MapName")
      local oldNoneText = ___MOD.isvalid(oldNoneMapName) and oldNoneMapName.BitmapFontRendererComponent ~= nil and oldNoneMapName.BitmapFontRendererComponent.text or nil
      if not ___MOD.isvalid(oldNoneMapName) or oldNoneText ~= noneName then
        if ___MOD.isvalid(oldNoneMapName) then
          oldNoneMapName:Destroy()
        end
        if ___MOD.isvalid(emptyText) then
          local noneMapName = ___MOD._SpawnService:SpawnByEntity(emptyText, "MapName", ___MOD.FastVector3(0, 0, 0), noneCenter)
          noneMapName:AddComponent(___MOD.BitmapFontRendererComponent)
          noneMapName.UITransformComponent.AlignmentOption = ___MOD.AlignmentType.Left
          noneMapName.UITransformComponent.Pivot = ___MOD.FastVector2(0, 0.5)
          noneMapName.UITransformComponent.anchoredPosition.x = 0
          noneMapName.BitmapFontRendererComponent:drawTextArg(noneName, ___MOD._BitmapFontType.Gulim9pt, ___MOD.FastVector2.zero:Clone(), ___MOD.FastColor.black, false, false, ___MOD.FastColor.clear, false, nil, 0)
        end
      end
      local noneBtMax = noneCenter:GetChildByName("BtMax")
      if ___MOD.isvalid(noneBtMax) and noneBtMax.UIButtonComponent ~= nil then
        if sprite == nil then
          noneBtMax.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get("UI.Basic.BtMax.disabled.0")
          noneBtMax.UIButtonComponent.Enable = false
        else
          noneBtMax.SpriteGUIRendererComponent.ImageRUID = ___MOD.__RUIDManager:get("UI.Basic.BtMax.normal.0")
          noneBtMax.UIButtonComponent.Enable = true
        end
      end
    end
    self:resizeMiniMapWindow(self.miniMapNone, ___MOD.FastVector2(30 + self:calculateNameWidth(noneName), 40))
    local noneDragArea = noneParent:GetChildByName("dragArea")
    if ___MOD.isvalid(noneDragArea) then
      local noneDragWidth = hideMinimap and 30 + self:calculateNameWidth(noneName) or self.canvasWidth - 130
      noneDragArea.UITransformComponent.RectSize = ___MOD.FastVector2(noneDragWidth, 40)
    end
    miniParent.Visible = self.miniMapType == ___MOD._UIMiniMapType.Minimap_Min
    maxParent.Visible = self.miniMapType == ___MOD._UIMiniMapType.Minimap_Max
    noneParent.Visible = self.miniMapType == ___MOD._UIMiniMapType.Minimap_None
    if sprite ~= nil and ___MOD.isvalid(self.miniCanvas) and ___MOD.isvalid(self.maxCanvas) then
      self:createNpcIcon()
      self:createPortalIcon()
    end
    self._T.currentMiniMapMapID = mapID
  end
  if self.miniMapType == ___MOD._UIMiniMapType.Minimap_None or self._T.hideMinimap then
    return
  end
  self:onUpdateIcon()
  self:arrangeMiniMapLayerBeforeMobileChat()
end

function UIMiniMap.refreshQuestConditionNpcIcons(self)
  local player = self:getMiniMapPlayer()
  local localPlayer = ___MOD._UserService.LocalPlayer
  if not ___MOD.isvalid(player) or player.CurrentMap == nil or not ___MOD.isvalid(localPlayer) then
    return
  end
  local questComponent = localPlayer.QuestComponent
  if not ___MOD.isvalid(questComponent) then
    return
  end
  local lifepools = player.CurrentMap:GetChildComponentsByTypeName("LifePoolComponent")
  for _, lifepool in ___MOD.ipairs(lifepools) do
    local npcID = lifepool.id
    if lifepool.type == "n" and ___MOD._NpcManager:isQuestConditionNpc(npcID) then
      local visible = ___MOD._NpcManager:isNpcVisibleForQuest(npcID, questComponent)
      if ___MOD.isvalid(self.maxCanvas) then
        local maxIcon = self.maxCanvas:GetChildByName("iconNpc" .. npcID)
        if ___MOD.isvalid(maxIcon) then
          maxIcon.Visible = visible
        end
      end
      if ___MOD.isvalid(self.miniCanvas) then
        local miniIcon = self.miniCanvas:GetChildByName("iconNpc" .. npcID)
        if ___MOD.isvalid(miniIcon) then
          miniIcon.Visible = visible
        end
      end
    end
  end
end

function UIMiniMap.resizeMiniMapWindow(self, window, centerSize)
  if window == nil then
    return
  end
  local center = window:getEntity("c")
  if not ___MOD.isvalid(center) then
    return
  end
  window:setRectSize("c", centerSize)
  for _, partName in ___MOD.pairs({"n", "s"}) do
    local part = window:getEntity(partName)
    if ___MOD.isvalid(part) then
      window:setRectSize(partName, ___MOD.FastVector2(centerSize.x, part.UITransformComponent.RectSize.y))
    end
  end
  for _, partName in ___MOD.pairs({"w", "e"}) do
    local part = window:getEntity(partName)
    if ___MOD.isvalid(part) then
      window:setRectSize(partName, ___MOD.FastVector2(part.UITransformComponent.RectSize.x, centerSize.y))
    end
  end
end

function UIMiniMap.switchMiniMapUI(self, nextType, fromUI, toUI, offsetX, offsetY)
  if self.miniCanvas == nil then
    return
  end
  self.miniMapType = nextType
  self.selectedMiniMapType = nextType
  local parent = toUI:getParentUI()
  local before = fromUI:getParentUI()
  parent.UITransformComponent.Position.x = before.UITransformComponent.Position.x + (offsetX or 0)
  parent.UITransformComponent.Position.y = before.UITransformComponent.Position.y + (offsetY or 0)
  before.Visible = false
  ___MOD.wait(0.01)
  parent.Visible = true
end

function UIMiniMap.tripTo40Bytes(self, str)
  local byteCount = 0
  local charCount = 0
  for _, code in ___MOD.utf8.codes(str) do
    local char = ___MOD.utf8.char(code)
    local len = #char
    if 40 < byteCount + len then
      break
    end
    byteCount = byteCount + len
    charCount = charCount + 1
  end
  return str:sub(1, ___MOD.utf8.offset(str, charCount + 1) and ___MOD.utf8.offset(str, charCount + 1) - 1 or #str)
end

function UIMiniMap.updateMiniMapCanvas(self, canvas, ruid, spriteSize, viewportSize)
  if not ___MOD.isvalid(canvas) then
    return
  end
  canvas.SpriteGUIRendererComponent.ImageRUID = ruid
  canvas.UITransformComponent.RectSize = spriteSize
  canvas.UITransformComponent.anchoredPosition = ___MOD.FastVector2.zero:Clone()
  canvas.Visible = true
  local background = canvas.Parent
  if not ___MOD.isvalid(background) then
    return
  end
  background.UITransformComponent.RectSize = viewportSize
  background.Visible = true
  local blackBg = background:GetChildByName("blackBg")
  if ___MOD.isvalid(blackBg) then
    blackBg.UITransformComponent.RectSize = spriteSize
    blackBg.Visible = true
  end
  local mask = background.Parent
  if ___MOD.isvalid(mask) then
    mask.UITransformComponent.RectSize = viewportSize
  end
end

function UIMiniMap.updateNpcIcon(self, npcID, questState)
  if ___MOD.isvalid(self.maxCanvas) then
    local iconNpc = self.maxCanvas:GetChildByName("iconNpc" .. npcID)
    if ___MOD.isvalid(iconNpc) then
      if questState == -1 then
        iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 14)
        iconNpc.SpriteGUIRendererComponent.ImageRUID = "cc008ed233c2464398f3cd9514e34b1c"
      elseif questState == 0 then
        iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 26)
        iconNpc.SpriteGUIRendererComponent.ImageRUID = "ccef719bb5d14e068cbf099f0bf68a53"
      elseif questState == 1 then
        iconNpc.UITransformComponent.RectSize = ___MOD.FastVector2(8, 26)
        iconNpc.SpriteGUIRendererComponent.ImageRUID = "56263f71bad14cf6b3f0e70058682d2b"
      end
    end
  end
end

function UIMiniMap.updateTargetIcon(self, userId)
  if self._T.hideMinimap then
    return
  end
  local v = ___MOD._UserService:GetUserEntityByUserId(userId)
  if not ___MOD.isvalid(v) then
    return
  end
  if v.Player ~= nil and v.Player.AdminHidden == true then
    self:destroyTargetIcon(userId)
    return
  end
  local type = self:getTargetIconType(v)
  self:updateTargetIconByType(userId, type)
end

function UIMiniMap.updateTargetIconByType(self, userId, type)
  if self._T.hideMinimap then
    return
  end
  for _, canvas in ___MOD.pairs({
    self.maxCanvas,
    self.miniCanvas
  }) do
    local icon = canvas:GetChildByName("iconAnother_" .. userId)
    if ___MOD.isvalid(icon) then
      self:applyIconStyle(icon, type)
    end
  end
end

function UIMiniMap.worldToMiniMap(self, worldPos)
  local miniMapPlayer = self:getMiniMapPlayer()
  if not ___MOD.isvalid(miniMapPlayer) or miniMapPlayer.CurrentMap == nil then
    return
  end
  local mapInfoComponent = miniMapPlayer.CurrentMap.MapInfoComponent
  if not ___MOD.isvalid(mapInfoComponent) then
    return
  end
  local realPos = worldPos
  local centerX = mapInfoComponent.centerX or 0
  local centerY = mapInfoComponent.centerY or 0
  local centerXOffset = centerX / 100
  local centerYOffset = centerY / 100
  local mag = mapInfoComponent.mag - 1 or 3
  local multiplier = 100 / 2 ^ mag
  local rx = (realPos.x + centerXOffset) * multiplier
  local ry = (worldPos.y - centerYOffset) * multiplier
  return ___MOD.FastVector2(rx, ry)
end
