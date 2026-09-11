

function NametagLogic.createNametag(self, type, parentEntity, name, nametagRUID, offset, textColor)
  if name == "" then
    name = "이름 없음"
  end
  local bold = false
  local fontType = ___MOD._BitmapFontType.Gulim9pt
  local sortinglayer = "MapLayer7"
  local orderInLayer = self.sn
  self.sn = self.sn - 1
  if self.sn <= 10 then
    self.sn = 100
  end
  if type ~= "PLAYER" and type ~= "MOB" then
    bold = true
    fontType = ___MOD._BitmapFontType.Gulim9pt_bold
  end
  if type == "MOB" then
    orderInLayer = 2
  elseif type == "NPC" then
    orderInLayer = 3
  end
  local ruid1_x = 4
  local ruid1_y = 36
  local ruid2_x = 8
  local ruid2_y = 36
  local ruid3_x = 4
  local ruid3_y = 36
  local cX = ___MOD._BitmapFontService:calcTextMetrics(name, fontType, 9999).x
  local nameTag = ___MOD.SpriteWindow():createSpriteWindow("Third", ___MOD.Vector2(cX, ruid2_y), offset, {
    w = {
      pixelSize = ___MOD.Vector2(ruid1_x, ruid1_y),
      rectSize = ___MOD.Vector2(ruid1_x, ruid1_y),
      position = ___MOD.Vector2(0, 0),
      RUID = nametagRUID[1]
    },
    c = {
      pixelSize = ___MOD.Vector2(ruid2_x, ruid2_y),
      rectSize = ___MOD.Vector2(ruid2_x, ruid2_y),
      position = ___MOD.Vector2(0, 0),
      RUID = nametagRUID[2]
    },
    e = {
      pixelSize = ___MOD.Vector2(ruid3_x, ruid3_y),
      rectSize = ___MOD.Vector2(ruid3_x, ruid3_y),
      position = ___MOD.Vector2(0, 0),
      RUID = nametagRUID[3]
    }
  }, type .. "_nametag", parentEntity, false)
  local parent = nameTag:getParentUI()
  local c = nameTag:getEntity("c")
  local w = nameTag:getEntity("w")
  local e = nameTag:getEntity("e")
  local NameText = ___MOD._SpawnService:SpawnByModelId("model://c9699783-4558-48a0-a997-34e0a944d657", "text", ___MOD.FastVector3.zero:Clone(), parent)
  NameText:AddComponent(___MOD.BitmapFontRendererComponent)
  NameText.TransformComponent.Scale = ___MOD.Vector3(1, 1, 1)
  parent.SpriteRendererComponent.SortingLayer = sortinglayer
  parent.SpriteRendererComponent.OrderInLayer = orderInLayer - 1
  c.SpriteRendererComponent.SortingLayer = sortinglayer
  c.SpriteRendererComponent.OrderInLayer = orderInLayer - 1
  w.SpriteRendererComponent.SortingLayer = sortinglayer
  w.SpriteRendererComponent.OrderInLayer = orderInLayer - 1
  e.SpriteRendererComponent.SortingLayer = sortinglayer
  e.SpriteRendererComponent.OrderInLayer = orderInLayer - 1
  c.TransformComponent.Scale.y = 0.9
  w.TransformComponent.Scale.y = 0.9
  e.TransformComponent.Scale.y = 0.9
  local color = ___MOD.Color.FromHexCode("#FEFEFE")
  if type == "NPC" then
    color = ___MOD.Color.FromHexCode("#FFFF00")
  end
  if textColor ~= nil then
    color = textColor
  end
  local font = NameText.BitmapFontRendererComponent
  font.font = fontType
  font.color = color
  font.text = name
  font.sortingLayer = sortinglayer
  font.orderInLayer = orderInLayer
  if font:drawText_World() then
    local pos = NameText.TransformComponent:PositionAsFastVector3()
    pos.y = font:getWorldMSWTranslateYOffset(-0.24)
    NameText.TransformComponent.Position = pos
  end
  local key = type .. ":" .. parentEntity.Id
  self._T.creatingNametags[key] = false
end

function NametagLogic.drawNametag(self, type, parentEntity, name, subName, nametagRUID, textColor)
  self._T.creatingNametags = self._T.creatingNametags or {}
  local key = type .. ":" .. parentEntity.Id
  if self._T.creatingNametags[key] or self:getNametagEntity(type, parentEntity) then
    return
  end
  self._T.creatingNametags[key] = true
  if type ~= "PLAYER" and type ~= "NPC" and type ~= "MOB" then
    ___MOD.log("[drawNametag] 존재하지 않는 type입니다... : " .. type)
    return
  end
  if nametagRUID == nil then
    nametagRUID = {}
    nametagRUID[1] = "2b50ac5e41144edc90c4dfdc92e60de0"
    nametagRUID[2] = "3000de2acf7d47a6b9df56a0382c0793"
    nametagRUID[3] = "7a153cd7f0774b0bb73fce23786d20b5"
  end
  if #nametagRUID ~= 3 then
    ___MOD.log("[drawNametag] RUID table의 값이 3개가 아닙니다...")
    return
  end
  local offsetY = 0
  if type == "PLAYER" then
    offsetY = -0.13
  elseif type == "NPC" then
    if ___MOD.isvalid(parentEntity.ExtendNpcComponent) then
      local npc = ___MOD._NpcManager:getNpcDefaultTemplate(parentEntity.ExtendNpcComponent.npcID)
      if npc == nil then
        return
      end
      local spriteSizeY = npc.spriteSize.y / 100
      offsetY = -0.13
    end
  elseif type == "MOB" and ___MOD.isvalid(parentEntity.MobComponent) then
    local mob = ___MOD._MobManager:getMonster(parentEntity.MobComponent.id)
    if ___MOD.isvalid(mob) then
      local anim = mob.stand
      if ___MOD.isvalid(anim) then
        local spriteSizeY = anim.anim[1].spriteSize.y / 100
        offsetY = -0.13
      end
    end
  end
  self:createNametag(type, parentEntity, name, nametagRUID, ___MOD.Vector2(0, offsetY), textColor)
  if subName ~= "" then
    self:createNametag(type, parentEntity, subName, nametagRUID, ___MOD.Vector2(0, -0.33125), textColor)
  end
end

function NametagLogic.getNametagEntity(self, type, targetEntity)
  if type ~= "PLAYER" and type ~= "NPC" and type ~= "MOB" then
    ___MOD.log("[drawNametag] 존재하지 않는 type입니다... : " .. type)
    return nil
  end
  if not ___MOD.isvalid(targetEntity) then
    return
  end
  return targetEntity:GetChildByName(type .. "_nametag")
end

function NametagLogic.removeNametag(self, type, parentEntity)
  if not ___MOD.isvalid(parentEntity) then
    ___MOD.log("[removeNametag] parentEntity가 유효하지 않음")
    return
  end
  local nametagName = type .. "_nametag"
  local nametagEntity = parentEntity:GetChildByName(nametagName)
  if ___MOD.isvalid(nametagEntity) then
    nametagEntity:Destroy()
  end
end
