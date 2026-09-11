

function LoginLogic.addCharacterList(self, playerInfo, equipment)
  local playerInfoTbl = ___MOD._HttpService:JSONDecode(playerInfo)
  ___MOD.table.insert(self.playerInfoList, playerInfoTbl)
  local idx = #self.playerInfoList
  local equipmentTbl = ___MOD._HttpService:JSONDecode(equipment)
  if equipmentTbl ~= nil then
    self.chrEntityEquipment[idx] = {}
    for slotIndex, slot in ___MOD.pairs(equipmentTbl) do
      self.chrEntityEquipment[idx][slotIndex] = {}
      for subSlot, equipData in ___MOD.pairs(slot) do
        self.chrEntityEquipment[idx][slotIndex][subSlot] = {}
        local equipment_ = ___MOD.Equipment()
        equipment_:fromTable(equipData)
        if equipment_.equip.itemId ~= nil then
          self.chrEntityEquipment[idx][slotIndex][subSlot] = equipment_
        end
      end
    end
  end
  local page = (#self.playerInfoList - 1) // 3 + 1
  self.currentPage = page
  self._T.lastPage = page
  self:renderCharacterPage()
end

function LoginLogic.applyLoadingMapZoom(self, cameraPos)
  if not ___MOD.Environment:IsMobilePlatform() then
    return
  end
  local zoom = 160
  if cameraPos ~= 1 then
    zoom = 145
  end
  ___MOD._CameraService:ZoomTo(zoom, 0)
end

function LoginLogic.changeCharInfosPage(self, category, direction)
  if category < 1 or 7 < category then
    return
  end
  if direction ~= -1 and direction ~= 1 then
    return
  end
  local cursor = self.makeCharCursor[category] + direction
  local min = 1
  local max = self.makeCharSizeCache[self.chooseKey][category]
  if cursor > max then
    cursor = min
  elseif min > cursor then
    cursor = max
  end
  if category == 7 then
    self.chooseGender = cursor
    self:initCharInfo(self.chooseClass, cursor)
    self.avartarSelTexts[7].BitmapFontRendererComponent.text = self.genderString[cursor]
    self.avartarSelTexts[7].BitmapFontRendererComponent:drawText_World()
    self.avartarSelTexts[7].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
  else
    local chr = self:get("NormalChr").CostumeManagerComponent
    local makeCharInfo = self:getMakeCharInfoTbl(self.chooseKey)
    local id = makeCharInfo[category][cursor]
    if category == 1 then
      chr.CustomFaceEquip = ___MOD.__RUIDManager:get(___MOD.tostring(id))
      self.avartarSelTexts[1].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Face/%d/name", id))
      self.avartarSelTexts[1].BitmapFontRendererComponent:drawText_World()
      self.avartarSelTexts[1].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
    elseif category == 2 then
      chr.CustomHairEquip = ___MOD.__RUIDManager:get(___MOD.tostring(id))
      self.avartarSelTexts[2].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Hair/%d/name", id))
      self.avartarSelTexts[2].BitmapFontRendererComponent:drawText_World()
      self.avartarSelTexts[2].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
    elseif category == 3 then
      chr.CustomCoatEquip = ___MOD.__RUIDManager:get(___MOD.tostring(id))
      self.avartarSelTexts[3].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Coat/%d/name", id))
      self.avartarSelTexts[3].BitmapFontRendererComponent:drawText_World()
      self.avartarSelTexts[3].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
    elseif category == 4 then
      chr.CustomPantsEquip = ___MOD.__RUIDManager:get(___MOD.tostring(id))
      self.avartarSelTexts[4].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Pants/%d/name", id))
      self.avartarSelTexts[4].BitmapFontRendererComponent:drawText_World()
      self.avartarSelTexts[4].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
    elseif category == 5 then
      chr.CustomShoesEquip = ___MOD.__RUIDManager:get(___MOD.tostring(id))
      self.avartarSelTexts[5].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Shoes/%d/name", id))
      self.avartarSelTexts[5].BitmapFontRendererComponent:drawText_World()
      self.avartarSelTexts[5].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
    elseif category == 6 then
      if 1442000 <= id and id < 1443000 then
        chr.CustomTwoHandedWeaponEquip = ___MOD.__RUIDManager:get(___MOD.tostring(id))
      else
        chr.CustomOneHandedWeaponEquip = ___MOD.__RUIDManager:get(___MOD.tostring(id))
      end
      self.avartarSelTexts[6].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Weapon/%d/name", id))
      self.avartarSelTexts[6].BitmapFontRendererComponent:drawText_World()
      self.avartarSelTexts[6].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
    end
  end
  self.makeCharCursor[category] = cursor
end

function LoginLogic.checkgetCharacterList(self, senderUserId)

end

function LoginLogic.checkName(self, name, senderUserId)

end

function LoginLogic.checkNameResponseToClient(self, response)
  if not self.waitingNameCheckResponse then
    self:get("CharName_BtYes").UIButtonComponent.Enable = true
    self:get("CharName_BtNo").UIButtonComponent.Enable = true
    return
  end
  if response == 1 then
    self:get("CharName"):SetEnable(false)
    self:get("CharSet"):SetEnable(true)
  elseif response == 2 then
    ___MOD._UINotice:showAlertUI("이미 사용 중인 이름입니다.")
  elseif response == 3 then
    ___MOD._UINotice:showAlertUI("잠시 후 다시 시도해주세요.")
  end
  self:get("CharName_BtYes").UIButtonComponent.Enable = true
  self:get("CharName_BtNo").UIButtonComponent.Enable = true
  ___MOD._TimerService:ClearTimer(self._T.checkNameTimeOut)
end

function LoginLogic.clear(self)
  self.currentPage = 1
  self.loginStep = 1
  self.playerIndex = 1
  self._T.lastPage = 1
  self._T.lastPlayerIndex = 0
end

function LoginLogic.clearCachedPlayerInfoList(self, userId)

end

function LoginLogic.clearCachedPlayerListResponse(self, userId)

end

function LoginLogic.clearCharacterSlot(self, slotIndex)
  local chrEntity = self.chrEntityList[slotIndex]
  if not ___MOD.isvalid(chrEntity) then
    return
  end
  local nametag = chrEntity:GetChildByName("nametag")
  if ___MOD.isvalid(nametag) then
    nametag:Destroy()
  end
  local costume = chrEntity.CostumeManagerComponent
  for slot = 1, 19 do
    costume:SetEquip(slot, 0)
  end
end

function LoginLogic.clearDelayedAccountInfoWorldRender(self, key)
  local timerKey = "delayedAccountInfoWorldRender_" .. ___MOD.tostring(key or "")
  if self._T[timerKey] ~= nil then
    ___MOD._TimerService:ClearTimer(self._T[timerKey])
    self._T[timerKey] = nil
  end
end

function LoginLogic.clickBtPage(self, direction)
  local maxPage = self.maxPlayer / 3
  self.currentPage = ___MOD.math.max(1, ___MOD.math.min(maxPage, self.currentPage + direction))
  if self.currentPage ~= self._T.lastPage then
    self._T.lastPage = self.currentPage
    self:renderCharacterPage()
  end
end

function LoginLogic.connectCreateCharacterButtons(self, rootPath)
  local charNameBtYes = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharName/BtYes")
  if ___MOD.isvalid(charNameBtYes) then
    charNameBtYes:ConnectEvent(___MOD.ButtonClickEvent, self.onCharName_BtYes)
  end
  local charNameBtNo = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharName/BtNo")
  if ___MOD.isvalid(charNameBtNo) then
    charNameBtNo:ConnectEvent(___MOD.ButtonClickEvent, self.onCharName_BtNo)
  end
  local charSetBtYes = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharSet/BtYes")
  if ___MOD.isvalid(charSetBtYes) then
    charSetBtYes:ConnectEvent(___MOD.ButtonClickEvent, self.onCharSet_BtYes)
  end
  local charSetBtNo = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharSet/BtNo")
  if ___MOD.isvalid(charSetBtNo) then
    charSetBtNo:ConnectEvent(___MOD.ButtonClickEvent, self.onCharSet_BtNo)
  end
end

function LoginLogic.createNameTag(self, chrEntity, name)
  local cX = ___MOD._BitmapFontService:calcTextMetrics(name, ___MOD._BitmapFontType.Gulim9pt, 9999).x
  local nameTagInfo = {
    w = {
      RUID = "5feb7a04d87c4f81adc060256bbd8632",
      x = 16,
      y = 44
    },
    c = {
      RUID = "11cea185f93240769fb02d646fd93c02",
      x = 18,
      y = 44
    },
    e = {
      RUID = "ca349dcf305649eda49dc7e21beecb73",
      x = 20,
      y = 44
    }
  }
  local nameTagEntity = chrEntity:GetChildByName("nametag")
  if nameTagEntity ~= nil then
    nameTagEntity:Destroy()
  end
  local nameTag = ___MOD.SpriteWindow():createSpriteWindow("Third", ___MOD.FastVector2(cX, nameTagInfo.c.y), ___MOD.FastVector2(0.04, -0.46), {
    w = {
      pixelSize = ___MOD.FastVector2(nameTagInfo.w.x, nameTagInfo.w.y),
      rectSize = ___MOD.FastVector2(nameTagInfo.w.x, nameTagInfo.w.y),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = nameTagInfo.w.RUID
    },
    c = {
      pixelSize = ___MOD.FastVector2(nameTagInfo.c.x, nameTagInfo.c.y),
      rectSize = ___MOD.FastVector2(nameTagInfo.c.x, nameTagInfo.c.y),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = nameTagInfo.c.RUID
    },
    e = {
      pixelSize = ___MOD.FastVector2(nameTagInfo.e.x, nameTagInfo.e.y),
      rectSize = ___MOD.FastVector2(nameTagInfo.e.x, nameTagInfo.e.y),
      position = ___MOD.FastVector2.zero:Clone(),
      RUID = nameTagInfo.e.RUID
    }
  }, "nametag", chrEntity, false)
  local parent = nameTag:getParentUI()
  parent.TransformComponent.Scale = ___MOD.FastVector3(0.4, 0.4, 1)
  nameTag:getEntity("c").TransformComponent.Scale.x = nameTag:getEntity("c").TransformComponent.Scale.x + 0.5
  local NameText = ___MOD._SpawnService:SpawnByModelId("model://c9699783-4558-48a0-a997-34e0a944d657", "text", ___MOD.FastVector3.zero:Clone(), parent)
  NameText:AddComponent(___MOD.BitmapFontRendererComponent)
  local font = NameText.BitmapFontRendererComponent
  font.text = name
  font.color = ___MOD.FastColor.white
  font.orderInLayer = 1
  font:drawText_World()
  if font:shouldUseMSWFont() then
    NameText.TransformComponent.Position = ___MOD.FastVector3(0, -0.08, 0)
  else
    NameText.TransformComponent.Position = ___MOD.FastVector3(0, -0.1, 0)
  end
end

function LoginLogic.createPlayer(self, userId, name, class, gender, info)

end

function LoginLogic.deletePlayer(self, playerId, senderUserId)

end

function LoginLogic.deletePlayerToClient(self, index)
  self.deleteInProgress = false
  self:setCharacterActionButtonsEnabled(true)
  local last = #self.playerInfoList
  for i = index + 1, last do
    local fromEquip = self.chrEntityEquipment[i]
    self.chrEntityEquipment[i - 1] = fromEquip
  end
  ___MOD.table.remove(self.playerInfoList, index)
  self.selectedChrIndex = 0
  self:renderCharacterPage()
end

function LoginLogic.doCreateCharacter(self, name, class, gender, info, senderUserId)

end

function LoginLogic.doCreateCharacterResponseToClient(self, success)
  self:get("CharSet_BtYes").UIButtonComponent.Enable = true
  self:get("CharSet_BtNo").UIButtonComponent.Enable = true
  self:moveCamera(2, true, nil)
  if not success then
    ___MOD._UINotice:showAlertUI("알 수 없는 이유로 캐릭터 생성에 실패했습니다. 중복 된 이름이거나 서버 오류일 수 있습니다.")
  end
end

function LoginLogic.drawAccountInfo(self)
  local Nickname = self:get("Nickname")
  local ProfileCode = self:get("Profilecode")
  if Nickname and Nickname.BitmapFontRendererComponent ~= nil then
    self:renderAccountInfoWithWorldText(Nickname, 0.18)
  end
  if ProfileCode and ProfileCode.BitmapFontRendererComponent ~= nil then
    self:renderAccountInfoWithWorldText(ProfileCode, 0.2)
  end
  local version = ___MOD._EntityService:GetEntity("f03fc928-be70-4ad7-8b10-818926d09768")
  if version and version.BitmapFontRendererComponent ~= nil then
    version.BitmapFontRendererComponent.text = ___MOD._ServerConstants.releaseVer
    version.BitmapFontRendererComponent:drawText()
    self:setVersionGlyphPosX()
  end
end

function LoginLogic.failedDeletePlayerToClient(self, reason)
  self.deleteInProgress = false
  self:setCharacterActionButtonsEnabled(true)
  if ___MOD.tostring(reason or "") == "character_in_guild" then
    ___MOD._UINotice:showAlertUI("길드에 소속된 캐릭터는 삭제할 수 없습니다. 길드 탈퇴 또는 해체 후 다시 시도해주세요.")
    return
  end
  ___MOD._UINotice:showAlertUI("알 수 없는 이유로 캐릭터 삭제에 실패했습니다. 잠시후 다시 시도해주세요.")
end

function LoginLogic.failedGetCharacterListToClient(self)
  ___MOD._UINotice:showAlertUI("로그인에 실패했습니다. 잠시 후 다시 시도해주세요.")
  self:get("loginBtn").UIButtonComponent.Enable = true
end

function LoginLogic.failedGetCharacterListToClientBan(self, type, reason, date, banCode)
  if type == 1 then
    if banCode == "6-1" or banCode == "6-2" or banCode == "6-3" then
      ___MOD.log(___MOD.string.format("[LoginLogic] temporary MSW ban alert. code=%s", banCode))
      ___MOD._UINotice:showAlertUI("아래의 내용 중 1가지를 처리하고 있어 게임을 이용할 수 없습니다.\r\n\r\n#e1. 문의로 요청한 내용 처리\r\n2. 비정상적인 게임기록 혹은 운영정책 위반 사항이 감지되어 조사\r\n3. 게임 오류로 발생한 문제 수정#n\r\n\r\n#Y만약 계속해서 접속할 수 없다면 홈페이지의 1:1 문의를 이용해 주세요.#")
      self:get("loginBtn").UIButtonComponent.Enable = true
      return
    end
    ___MOD._UINotice:showAlertUI(___MOD.string.format("#e이용이 정지된 계정입니다.\r\n아래의 기간까지 이용이 불가능합니다.\r\n\r\n#r[제재 사유]\r\n#Y%s#\r\n제재 기간: %s#k#n", reason, date))
  elseif type == 2 then
    ___MOD._UINotice:showAlertUI(___MOD.string.format("#e이용이 제한된 IP입니다.\r\n아래의 기간까지 이용이 불가능합니다.\r\n\r\n#r정보 : %s\r\n제재 기간: %s#k#n", reason, date))
  end
  self:get("loginBtn").UIButtonComponent.Enable = true
end

function LoginLogic.failedGetCharacterListToClientStatus(self, reason)
  ___MOD._UINotice:showAlertUI(___MOD.string.format("#e현재 서버 접속이 불가능합니다.\r\n\r\n#b[사유]#k\r\n#Y%s#\r\n\r\n홈페이지, 디스코드를 참고해 주세요.\r\nhttps://mapleplanet.co.kr#n", reason))
  self:get("loginBtn").UIButtonComponent.Enable = true
end

function LoginLogic.failedLogin(self, type, nugu)
  if nugu ~= nil then
    nugu = nugu:sub(1, -3)
  end
  if type == 1 then
    ___MOD._UINotice:showAlertUI("한국 지역에서 가입 된 Nexon 계정만 로그인이 가능합니다.")
  elseif type == 2 then
    ___MOD._UINotice:showAlertUI("NexonOTP를 설정 한 계정만 로그인이 가능합니다. 설정 후 다시 시도해주세요.")
  elseif type == 3 then
    ___MOD._UINotice:showAlertUI("#eAccess is currently available \r\nonly within #cSouth Korea#\r\n\r\n#nWe apologize for the inconvenience.")
  elseif type == 4 then
    ___MOD._UINotice:showAlertUI("넥슨에서 E-Mail 인증 및 본인 확인을 완료한 계정만 로그인이 가능합니다. 설정 후 다시 시도해주세요.")
  elseif type == 5 then
    ___MOD._UINotice:showAlertUI("#e이용이 제한된 IP입니다.\r\n\r\n다른 기기, 환경를 이용하시거나, 고객센터에 문의하시기 바랍니다.\r\n\r\n에러 코드 : " .. nugu)
  elseif type == 6 then
    ___MOD._UINotice:showAlertUI("일시적인 문제로 인해 로그인이 불가능합니다. 잠시 후 다시 시도해주세요.")
  end
  self:get("loginBtn").UIButtonComponent.Enable = true
end

function LoginLogic.get(self, name)
  return self.entities[name] or nil
end

function LoginLogic.getCachedPlayerInfo(self, userId, playerId)

end

function LoginLogic.getCachedPlayerListResponse(self, userId)

end

function LoginLogic.getCharacterList(self, userId)

end

function LoginLogic.getMakeCharInfoTbl(self, key)
  return ___MOD._EtcManager.makeCharInfo[key] or nil
end

function LoginLogic.initCharInfo(self, class, gender)
  local chr = self:get("NormalChr").CostumeManagerComponent
  self.chooseKey = self.infoKey[class][gender]
  self.chooseClass = class
  if class == 2 then
    chr.CustomBodyEquip = "04e82396b2ba40ab9d860f993447f3eb"
  elseif class == 3 then
    chr.CustomBodyEquip = "2f62f3dbbbcb4809ae353831a4d62c5e"
  else
    chr.CustomBodyEquip = ""
  end
  self.makeCharSizeCache = {}
  for key, node in ___MOD.pairs(___MOD._EtcManager.makeCharInfo) do
    self.makeCharSizeCache[key] = {}
    for category, v in ___MOD.pairs(node) do
      self.makeCharSizeCache[key][category] = #v
    end
    self.makeCharSizeCache[key][7] = 2
  end
  local makeCharInfo = self:getMakeCharInfoTbl(self.chooseKey)
  local maxSize = self.makeCharSizeCache[self.chooseKey]
  for i = 1, 6 do
    self.makeCharCursor[i] = ___MOD._GlobalRand32:randomIntegerRange(1, maxSize[i])
  end
  self.makeCharCursor[7] = self.chooseGender
  local face, hair, coat, pants, shoes, weapon
  face = makeCharInfo[1][self.makeCharCursor[1]]
  hair = makeCharInfo[2][self.makeCharCursor[2]]
  coat = makeCharInfo[3][self.makeCharCursor[3]]
  pants = makeCharInfo[4][self.makeCharCursor[4]]
  shoes = makeCharInfo[5][self.makeCharCursor[5]]
  weapon = makeCharInfo[6][self.makeCharCursor[6]]
  chr.CustomFaceEquip = ___MOD.__RUIDManager:get(___MOD.tostring(face))
  self.avartarSelTexts[1].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Face/%d/name", face))
  self.avartarSelTexts[1].BitmapFontRendererComponent:drawText_World()
  self.avartarSelTexts[1].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
  chr.CustomHairEquip = ___MOD.__RUIDManager:get(___MOD.tostring(hair))
  self.avartarSelTexts[2].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Hair/%d/name", hair))
  self.avartarSelTexts[2].BitmapFontRendererComponent:drawText_World()
  self.avartarSelTexts[2].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
  chr.CustomCoatEquip = ___MOD.__RUIDManager:get(___MOD.tostring(coat))
  self.avartarSelTexts[3].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Coat/%d/name", coat))
  self.avartarSelTexts[3].BitmapFontRendererComponent:drawText_World()
  self.avartarSelTexts[3].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
  chr.CustomPantsEquip = ___MOD.__RUIDManager:get(___MOD.tostring(pants))
  self.avartarSelTexts[4].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Pants/%d/name", pants))
  self.avartarSelTexts[4].BitmapFontRendererComponent:drawText_World()
  self.avartarSelTexts[4].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
  chr.CustomShoesEquip = ___MOD.__RUIDManager:get(___MOD.tostring(shoes))
  self.avartarSelTexts[5].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Shoes/%d/name", shoes))
  self.avartarSelTexts[5].BitmapFontRendererComponent:drawText_World()
  self.avartarSelTexts[5].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
  if class == 3 then
    chr.CustomTwoHandedWeaponEquip = ___MOD.__RUIDManager:get(___MOD.tostring(weapon))
  else
    chr.CustomOneHandedWeaponEquip = ___MOD.__RUIDManager:get(___MOD.tostring(weapon))
  end
  self.avartarSelTexts[6].BitmapFontRendererComponent.text = ___MOD._StringPoolManager:getStringPool(___MOD.string.format("Eqp.img/Eqp/Weapon/%d/name", weapon))
  self.avartarSelTexts[6].BitmapFontRendererComponent:drawText_World()
  self.avartarSelTexts[6].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
  self.avartarSelTexts[7].BitmapFontRendererComponent.text = self.genderString[gender]
  self.avartarSelTexts[7].BitmapFontRendererComponent:drawText_World()
  self.avartarSelTexts[7].TransformComponent.Position = ___MOD.FastVector3(0.14, -0.06, 0)
end

function LoginLogic.initLogin(self, nickname, profileCode, returnToTitle)
  self.loginInitialized = false
  local black = ___MOD._EntityService:GetEntity("9e3982b5-ec71-434a-9220-195f2b3c6450")
  black:SetEnable(false)
  ___MOD.table.clear(self.cameraPos)
  self.cameraPos[1] = ___MOD.FastVector3(0, -1.5, 0)
  local characterSelectCameraX = 0
  if ___MOD.Environment:IsMobilePlatform() then
    characterSelectCameraX = -0.2
  end
  self.cameraPos[2] = ___MOD.FastVector3(characterSelectCameraX, 6.7, 0)
  self.cameraPos[3] = ___MOD.FastVector3(0, 20.6, 0)
  self.cameraPos[4] = ___MOD.FastVector3(0, 14, 0)
  self.cameraPos[5] = ___MOD.FastVector3(0, -1.5, 0)
  self.cameraPos[6] = ___MOD.FastVector3(0, 30.5, 0)
  self.cameraPos[7] = ___MOD.FastVector3(0, 41.6, 0)
  if not ___MOD.isvalid(self.camera) then
    self.camera = ___MOD._SpawnService:SpawnByModelId("model://d38e411b-c0b7-43ec-91f8-dc57d8145186", "Camera", ___MOD.FastVector3.zero:Clone(), ___MOD._EntityService:GetEntityByPath("/maps/LoadingMap"))
  end
  if ___MOD.isvalid(self.camera) and self.camera.TransformComponent ~= nil then
    self.camera.TransformComponent.Position = self.cameraPos[1]
  end
  ___MOD._CameraService.TransitionBlendType = ___MOD.CameraBlendType.Cut
  if ___MOD.isvalid(self.camera) and self.camera.CameraComponent ~= nil then
    ___MOD._CameraService:SwitchCameraTo(self.camera.CameraComponent)
    self:applyLoadingMapZoom(1)
  end
  self.entities.fade = ___MOD._EntityService:GetEntity("06bc1d97-6f63-4281-b7ac-6740a5325acd")
  self.entities.loginBtn = ___MOD._EntityService:GetEntity("165878c7-4546-44e4-b468-d58ce25cc519")
  local destroyButton = ___MOD._EntityService:GetEntity("e9b2253c-f62e-4856-9abf-a2acaa0ddb26")
  destroyButton:ConnectEvent(___MOD.ButtonClickEvent, self.onDestroyBtn)
  self:get("loginBtn"):ConnectEvent(___MOD.ButtonClickEvent, self.onLoginBtn)
  self.entities.Nickname = ___MOD._EntityService:GetEntity("be7bfd1c-db19-49cd-a02f-bc412028ad52")
  self:get("Nickname").BitmapFontRendererComponent.text = nickname
  self.entities.Profilecode = ___MOD._EntityService:GetEntity("b4d66d6e-b055-4a6d-84ec-fbad7d5288a0")
  self:get("Profilecode").BitmapFontRendererComponent.text = profileCode
  self.entities.BtNew = ___MOD._EntityService:GetEntity("7eae00dd-6ffa-43b7-aeab-fd960d38a83c")
  self:get("BtNew"):ConnectEvent(___MOD.ButtonClickEvent, self.onBtNew)
  self.entities.BtSelect = ___MOD._EntityService:GetEntity("546038cf-bfb4-4715-8f80-30cd7bc78c7d")
  self:get("BtSelect"):ConnectEvent(___MOD.ButtonClickEvent, self.onBtSelect)
  self.entities.BtNormal = ___MOD._EntityService:GetEntity("14a6529f-097a-4617-8ae7-b9aadd1277ae")
  self:get("BtNormal"):ConnectEvent(___MOD.ButtonClickEvent, self.onBtNormal)
  self.entities.BtKnight = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/RaceSelect/BtKnight")
  if ___MOD.isvalid(self:get("BtKnight")) then
    self:get("BtKnight"):ConnectEvent(___MOD.ButtonClickEvent, self.onBtKnight)
  end
  self.entities.BtAran = ___MOD._EntityService:GetEntityByPath("/ui/LoadingUIGroup/RaceSelect/BtAran")
  self:get("BtAran"):ConnectEvent(___MOD.ButtonClickEvent, self.onBtAran)
  self.entities.BtDelete = ___MOD._EntityService:GetEntity("a866ee09-ec3e-4e38-a656-32080c0a0025")
  self:get("BtDelete"):ConnectEvent(___MOD.ButtonClickEvent, self.onBtDelete)
  self.chrEntityList[1] = ___MOD._EntityService:GetEntity("140b3ad6-885e-415c-859f-d4c3d5071fa9")
  self.chrEntityList[2] = ___MOD._EntityService:GetEntity("982690d0-1d76-4c0e-b0d2-ac8b7bd4060a")
  self.chrEntityList[3] = ___MOD._EntityService:GetEntity("e965411e-7074-4eb9-820d-816c48d0b02d")
  self.emptyChrList[1] = ___MOD._EntityService:GetEntity("f6d300d4-03f6-4dc4-abc7-542a19abd31e")
  self.emptyChrList[2] = ___MOD._EntityService:GetEntity("8639abd1-c386-4d49-8001-f175c6d67cd6")
  self.emptyChrList[3] = ___MOD._EntityService:GetEntity("e5ef04fc-a37e-4d57-a1f7-195e0939e5cf")
  self:connectCreateCharacterButtons("/maps/LoadingMap/Normal")
  self:connectCreateCharacterButtons("/maps/LoadingMap/Cygnus")
  self:connectCreateCharacterButtons("/maps/LoadingMap/Aran")
  self.entities.RaceSelect = ___MOD._EntityService:GetEntity("c20d4743-7007-4132-b7d4-12d9abfac0e1")
  self:setCreateCharacterEntities("/maps/LoadingMap/Normal")
  local pageL = ___MOD._EntityService:GetEntity("a0ecd40e-8718-428f-b410-8b839403f1cf")
  pageL:ConnectEvent(___MOD.ButtonClickEvent, function()
    self:clickBtPage(-1)
  end)
  local pageR = ___MOD._EntityService:GetEntity("246270bc-17c9-4be3-8261-e4a37ef02c60")
  pageR:ConnectEvent(___MOD.ButtonClickEvent, function()
    self:clickBtPage(1)
  end)
  self.classRaceList[1] = ___MOD._EntityService:GetEntity("40d2c8dc-4f7e-4d5c-b94a-b3f7c28ea7a7")
  self.classRaceList[2] = ___MOD._EntityService:GetEntity("dc0ca327-40a5-4333-a865-957c8f35930a")
  self.classRaceList[3] = ___MOD._EntityService:GetEntity("b6acfbc1-f0fb-4f6f-a1f7-2b45a5e9df77")
  local version = ___MOD._EntityService:GetEntity("f03fc928-be70-4ad7-8b10-818926d09768")
  version.BitmapFontRendererComponent.text = ___MOD._ServerConstants.releaseVer
  version.BitmapFontRendererComponent:drawText()
  self:setVersionGlyphPosX()
  if returnToTitle then
    local frame = ___MOD._EntityService:GetEntityByPath("/ui/LoginFrame")
    if ___MOD.isvalid(frame) then
      frame:SetEnable(___MOD.Environment:IsPCPlatform())
    end
    local all = ___MOD._EntityService:GetEntityByPath("/ui/LoginFrame/all")
    local tween = ___MOD._TweenLogic:MakeTween(0, 1, 2, ___MOD.EaseType.Linear, function(value)
      all.SpriteGUIRendererComponent.Color.a = value
    end)
    tween.AutoDestroy = true
    tween:Play()
    ___MOD._SoundService:PlayBGM(___MOD.__RUIDManager:get("BgmUI.img.Title"), 1)
    self.selectedChrIndex = 0
    self:moveCamera(5, false, nil)
    self:drawAccountInfo()
    local uiGroup = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup")
    uiGroup:SetEnable(false)
    local gameMenu = ___MOD._EntityService:GetEntityByPath("/ui/TempGroup/GameMenu")
    gameMenu:SetEnable(false)
    if ___MOD._ServerConstants.Use_MSW_Fade then
      if ___MOD._UILoading.changedMap then
        ___MOD._UILoading:planetFadeIn(1.0, 1.0)
      end
    else
      ___MOD._CameraService:ZoomTo(160, 0)
      do
        local user = ___MOD._UserService.LocalPlayer
        local player = user.Player
        if player.changedMap then
          player.changedMap = false
          local delay = 1.0
          if player.firstEnteredMap == nil then
            player.firstEnteredMap = true
          end
          ___MOD._UILoading:loadingFadeIn(1.0, delay, player.firstEnteredMap)
          player.firstEnteredMap = nil
        end
      end
    end
  end
  self.loginInitialized = true
end

function LoginLogic.isDeletingPlayer(self, userId)

end

function LoginLogic.isLoginAuthorizedUser(self, userId)

end

function LoginLogic.moveCamera(self, pos, playSound, fadeInCallback)
  self:applyLoadingMapZoom(pos)
  if pos ~= 1 and playSound then
    ___MOD._SoundService:PlaySound("896b5bc828844a05af2b83d5eb332ee3", 1)
  end
  local to = self.cameraPos[pos] or ___MOD.FastVector3.zero:Clone()
  local fade = self:get("fade")
  fade:SetEnable(true)
  if pos ~= 1 then
    local fadeIn = ___MOD._TweenLogic:PlayTween(0, 1, 0.5, ___MOD.EaseType.Linear, function(v)
      fade.SpriteGUIRendererComponent.Color.a = v
      if v == 1 then
        if fadeInCallback then
          fadeInCallback()
        end
        self.camera.TransformComponent.Position = to
        local fadeOut = ___MOD._TweenLogic:PlayTween(1, 0, 0.5, ___MOD.EaseType.Linear, function(v)
          fade.SpriteGUIRendererComponent.Color.a = v
          if v == 0 then
            fade:SetEnable(false)
          end
        end)
        fadeOut.AutoDestroy = true
      end
    end)
    fadeIn.AutoDestroy = true
  end
end

function LoginLogic.moveSelectPlayer(self, direction)
  local index = ___MOD.math.max(1, ___MOD.math.min(3, self.playerIndex + direction))
  if self._T.lastPlayerIndex ~= index then
    if self.playerInfoList[(self.currentPage - 1) * 3 + index] == nil then
      return
    end
    local player = self.chrEntityList[index]
    if player ~= nil then
      player.CharSelectComponent:onClick(false)
    end
    self.playerIndex = index
    self._T.lastPlayerIndex = index
  else
    local maxPage = self.maxPlayer / 3
    local d = 0
    local l = 0
    local i = 0
    if index == 1 then
      d = -1
      l = 1
      i = 3
    elseif index == 3 then
      d = 1
      l = 2
      i = 1
    end
    if self.currentPage ~= l then
      local page = ___MOD.math.max(1, ___MOD.math.min(maxPage, self.currentPage + d))
      local playerRealIndex = (page - 1) * 3 + i
      if self.playerInfoList[playerRealIndex] ~= nil then
        self.playerIndex = i
        self.currentPage = page
        local player = self.chrEntityList[self.playerIndex]
        self:renderCharacterPage()
        player.CharSelectComponent:onClick(false)
      end
    end
  end
end

function LoginLogic.OnBeginPlay(self)

end

function LoginLogic.onBtAran(self)
  if self.deleteInProgress then
    return
  end
  if not self:setCreateCharacterEntities("/maps/LoadingMap/Aran") then
    return
  end
  self.chooseGender = ___MOD._GlobalRand32:randomIntegerRange(1, 2)
  self:initCharInfo(3, self.chooseGender)
  self:get("CharName"):SetEnable(true)
  self:get("InputName").TextComponent.Text = ""
  self:get("CharSet"):SetEnable(false)
  self:moveCamera(7, true, function()
    self:get("RaceSelect"):SetEnable(false)
  end)
  self.loginStep = 4
end

function LoginLogic.onBtDelete(self)
  if self.deleteInProgress then
    return
  end
  local index = self.selectedChrIndex
  if index < 1 or index > self.maxPlayer then
    return
  end
  local playerInfo = self.playerInfoList[index]
  if playerInfo == nil then
    ___MOD.log("playerInfo is nil")
    return
  end
  local name = playerInfo.Name
  ___MOD._UINotice:showYesNoUI(___MOD.string.format("정말 %s 캐릭터를 삭제하시겠습니까? 삭제 이후에는 되돌릴 수 없습니다.", name), function(base)
    if ___MOD.isvalid(base) then
      base:Destroy()
    end
    ___MOD._UINotice:showInputUI(___MOD.string.format("정말 삭제하시겠습니까?\r\n\r\n#e#r삭제된 캐릭터는 복구가 불가능합니다#k#n\r\n\r\n%s 캐릭터를 삭제하시려면 \r\n#c동의합니다#k 를 입력해 주세요.", name), "", function(inputBase, confirmConsent)
      if index == 0 then
        ___MOD.log("index is 0")
        return
      end
      local playerId = playerInfo.PlayerId
      if ___MOD._UtilLogic:IsNilorEmptyString(playerId) then
        ___MOD.log("playerId is nil or empty")
        return
      end
      if ___MOD.tostring(confirmConsent or "") ~= "동의합니다" then
        self.deleteInProgress = false
        self:setCharacterActionButtonsEnabled(true)
        return
      end
      self.deleteInProgress = true
      self:setCharacterActionButtonsEnabled(false)
      self:deletePlayer(playerId)
    end)
  end)
end

function LoginLogic.onBtKnight(self)
  if self.deleteInProgress then
    return
  end
  if not self:setCreateCharacterEntities("/maps/LoadingMap/Cygnus") then
    return
  end
  self.chooseGender = ___MOD._GlobalRand32:randomIntegerRange(1, 2)
  self:initCharInfo(2, self.chooseGender)
  self:get("CharName"):SetEnable(true)
  self:get("InputName").TextComponent.Text = ""
  self:get("CharSet"):SetEnable(false)
  self:moveCamera(6, true, function()
    self:get("RaceSelect"):SetEnable(false)
  end)
  self.loginStep = 4
end

function LoginLogic.onBtNew(self)
  if self.deleteInProgress then
    return
  end
  if #self.playerInfoList >= self.maxPlayer then
    ___MOD._UINotice:showAlertUI("더 이상 캐릭터를 생성할 수 없습니다.")
    return
  end
  self:moveCamera(3, true, function()
    self:get("RaceSelect"):SetEnable(true)
  end)
  self.loginStep = 3
end

function LoginLogic.onBtNormal(self)
  if self.deleteInProgress then
    return
  end
  if not self:setCreateCharacterEntities("/maps/LoadingMap/Normal") then
    return
  end
  self.chooseGender = ___MOD._GlobalRand32:randomIntegerRange(1, 2)
  self:initCharInfo(1, self.chooseGender)
  self:get("CharName"):SetEnable(true)
  self:get("InputName").TextComponent.Text = ""
  self:get("CharSet"):SetEnable(false)
  self:moveCamera(4, true, function()
    self:get("RaceSelect"):SetEnable(false)
  end)
  self.loginStep = 4
end

function LoginLogic.onBtSelect(self)
  if self.deleteInProgress then
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD.log_warning("[캐릭터접속버튼] deleteInProgress=true 상태라 중단합니다.")
    end
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  if not (user ~= nil and ___MOD.isvalid(user)) or user.CurrentMapName ~= "LoadingMap" then
    if ___MOD.Environment:IsMakerPlay() then
      local mapName = user ~= nil and ___MOD.tostring(user.CurrentMapName or "") or "nil"
      ___MOD.log_warning(___MOD.string.format("[캐릭터접속버튼] LoadingMap 상태가 아니라 중단합니다. CurrentMapName:%s", mapName))
    end
    return
  end
  if user.Player == nil or user.Player.inSaveProcess or not user.Player.onClickLogin then
    if ___MOD.Environment:IsMakerPlay() then
      local player = user.Player
      ___MOD.log_warning(___MOD.string.format("[캐릭터접속버튼] 상태 가드로 중단합니다. PlayerId:%s inSaveProcess=%s onClickLogin=%s", ___MOD.tostring(player and player.PlayerId or ""), ___MOD.tostring(player and player.inSaveProcess), ___MOD.tostring(player and player.onClickLogin)))
    end
    return
  end
  if user.Player.init then
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD.log_warning(___MOD.string.format("[캐릭터접속버튼] 이미 접속 중이라 중단합니다. PlayerId:%s init=%s inSaveProcess=%s onClickLogin=%s", ___MOD.tostring(user.Player.PlayerId or ""), ___MOD.tostring(user.Player.init), ___MOD.tostring(user.Player.inSaveProcess), ___MOD.tostring(user.Player.onClickLogin)))
    end
    return
  end
  if self.selectedChrIndex == 0 then
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD.log_warning("[캐릭터접속버튼] 선택된 캐릭터가 없어 중단합니다.")
    end
    return
  end
  if ___MOD.Environment:IsMakerPlay() then
    ___MOD.log_warning(___MOD.string.format("[캐릭터접속버튼] 접속 시도를 시작합니다. selectedChrIndex:%d PlayerId:%s inSaveProcess=%s onClickLogin=%s", self.selectedChrIndex, ___MOD.tostring(user.Player.PlayerId or ""), ___MOD.tostring(user.Player.inSaveProcess), ___MOD.tostring(user.Player.onClickLogin)))
  end
  ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("Game.img.GameIn"), 1)
  if not ___MOD._ServerConstants.Use_MSW_Fade then
    ___MOD._UILoading:loadingFadeOut(0.5, function()
      ___MOD._PlayerDataLogic:initPlayerFromClient(self.selectedChrIndex)
    end)
  else
    ___MOD._PlayerDataLogic:initPlayerFromClient(self.selectedChrIndex)
  end
end

function LoginLogic.onCharName_BtNo(self)
  self:moveCamera(2, true, nil)
end

function LoginLogic.onCharName_BtYes(self)
  if self.deleteInProgress then
    return
  end
  local name = self:get("InputName").TextComponent.Text
  if ___MOD._UtilLogic:IsNilorEmptyString(name) then
    return
  end
  local allow, msg = ___MOD._CheckNameUtils:is_valid_name(name, true)
  if not allow then
    ___MOD._UINotice:showAlertUI(msg)
    return
  end
  self:get("CharName_BtYes").UIButtonComponent.Enable = false
  self:get("CharName_BtNo").UIButtonComponent.Enable = false
  self.waitingNameCheckResponse = true
  self._T.checkNameTimeOut = ___MOD._TimerService:SetTimerOnce(function()
    self:checkNameResponseToClient(3)
    self.waitingNameCheckResponse = false
  end, 5)
  self:checkName(name)
end

function LoginLogic.onCharSet_BtNo(self)
  self:get("CharName"):SetEnable(true)
  self:get("InputName").TextComponent.Text = ""
  self:get("CharSet"):SetEnable(false)
end

function LoginLogic.onCharSet_BtYes(self)
  if self.deleteInProgress then
    return
  end
  self:get("CharSet_BtYes").UIButtonComponent.Enable = false
  self:get("CharSet_BtNo").UIButtonComponent.Enable = false
  local name = self:get("InputName").TextComponent.Text or ""
  local class = self.chooseClass
  local gender = self.chooseGender
  local makeCharInfo = self:getMakeCharInfoTbl(self.chooseKey)
  local face, hair, coat, pants, shoes, weapon
  face = makeCharInfo[1][self.makeCharCursor[1]]
  hair = makeCharInfo[2][self.makeCharCursor[2]]
  coat = makeCharInfo[3][self.makeCharCursor[3]]
  pants = makeCharInfo[4][self.makeCharCursor[4]]
  shoes = makeCharInfo[5][self.makeCharCursor[5]]
  weapon = makeCharInfo[6][self.makeCharCursor[6]]
  local info = {
    face,
    hair,
    coat,
    pants,
    shoes,
    weapon
  }
  self:doCreateCharacter(name, class, gender, info)
end

function LoginLogic.onDestroy(self, senderUserId)

end

function LoginLogic.onDestroyBtn(self)
  self:onDestroy()
end

function LoginLogic.onLoginBtn(self)
  if self.deleteInProgress then
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD.log_warning("[로그인버튼] deleteInProgress=true 상태라 중단합니다.")
    end
    return
  end
  local user = ___MOD._UserService.LocalPlayer
  if not (user ~= nil and ___MOD.isvalid(user)) or user.CurrentMapName ~= "LoadingMap" then
    if ___MOD.Environment:IsMakerPlay() then
      local mapName = user ~= nil and ___MOD.tostring(user.CurrentMapName or "") or "nil"
      ___MOD.log_warning(___MOD.string.format("[로그인버튼] LoadingMap 상태가 아니라 중단합니다. CurrentMapName:%s", mapName))
    end
    return
  end
  if user.Player ~= nil and user.Player.inSaveProcess then
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD.log_warning(___MOD.string.format("[로그인버튼] 저장 중이라 중단합니다. PlayerId:%s inSaveProcess=%s onClickLogin=%s", ___MOD.tostring(user.Player.PlayerId or ""), ___MOD.tostring(user.Player.inSaveProcess), ___MOD.tostring(user.Player.onClickLogin)))
    end
    return
  end
  if user.Player ~= nil and user.Player.init then
    if ___MOD.Environment:IsMakerPlay() then
      ___MOD.log_warning(___MOD.string.format("[로그인버튼] 이미 접속 중이라 중단합니다. PlayerId:%s init=%s inSaveProcess=%s onClickLogin=%s", ___MOD.tostring(user.Player.PlayerId or ""), ___MOD.tostring(user.Player.init), ___MOD.tostring(user.Player.inSaveProcess), ___MOD.tostring(user.Player.onClickLogin)))
    end
    return
  end
  if ___MOD.Environment:IsMakerPlay() then
    local player = user.Player
    ___MOD.log_warning(___MOD.string.format("[로그인버튼] 캐릭터 리스트 요청을 시작합니다. PlayerId:%s inSaveProcess=%s onClickLogin=%s", ___MOD.tostring(player and player.PlayerId or ""), ___MOD.tostring(player and player.inSaveProcess), ___MOD.tostring(player and player.onClickLogin)))
  end
  self:get("loginBtn").UIButtonComponent.Enable = false
  self:checkgetCharacterList()
end

function LoginLogic.removeCachedPlayerInfo(self, userId, playerId)

end

function LoginLogic.renderAccountInfoWithWorldText(self, entity, yPos)
  if not ___MOD.isvalid(entity) or entity.BitmapFontRendererComponent == nil then
    return
  end
  local bf = entity.BitmapFontRendererComponent
  if bf.glyphPool ~= nil then
    for _, glyph in ___MOD.ipairs(bf.glyphPool) do
      if ___MOD.isvalid(glyph) then
        glyph:SetVisible(false)
        if glyph.Enable ~= nil then
          glyph.Enable = false
        end
      end
    end
  end
  local worldText = bf:ensureWorldTextRenderer()
  if ___MOD.isvalid(worldText) then
    worldText.Enable = true
    worldText.Text = bf.text or ""
    worldText.IsRichText = false
    worldText.FontColor = bf.color or ___MOD.FastColor.white
    worldText.FontSize = 2.5
    worldText.HorizontalAlignment = ___MOD.TextHorizontalAlignmentOption.Center
    worldText.VerticalAlignment = ___MOD.TextVerticalAlignmentOption.Middle
    worldText.SpacingOption.Line = -33
    worldText.SortingLayer = "UI"
  end
  if ___MOD.isvalid(entity.TransformComponent) then
    local pos = entity.TransformComponent.Position
    entity.TransformComponent.Position = ___MOD.FastVector3(pos.x or 0, yPos, pos.z or 0)
  end
  if ___MOD.isvalid(entity.TextRendererComponent) then
    entity.TextRendererComponent.VerticalAlignment = ___MOD.TextVerticalAlignmentOption.Middle
  end
end

function LoginLogic.renderCharacterPage(self)
  self._T.characterPageRenderVersion = (self._T.characterPageRenderVersion or 0) + 1
  local renderVersion = self._T.characterPageRenderVersion
  local pageStart = (self.currentPage - 1) * 3
  local pageEnd = pageStart + 3
  if self.selectedChrIndex < pageStart + 1 or pageEnd < self.selectedChrIndex then
    self.selectedChrIndex = 0
    local effect = ___MOD._EntityService:GetEntity("46758946-0eb3-473d-8b2a-0d0de7297dad")
    if ___MOD.isvalid(effect) then
      effect:SetEnable(false)
    end
    local charInfo = ___MOD._EntityService:GetEntity("83ba4922-a5e9-498a-a08f-0bd7c7da46f0")
    if ___MOD.isvalid(charInfo) then
      charInfo:SetVisible(false)
    end
  end
  for i = 1, 3 do
    local playerIndex = pageStart + i
    local playerInfoTbl = self.playerInfoList[playerIndex]
    local chrEntity = self.chrEntityList[i]
    local emptyChr = self.emptyChrList[i]
    local classRace = self.classRaceList[i]
    chrEntity.CharSelectComponent.index = playerIndex
    self:clearCharacterSlot(i)
    if playerInfoTbl == nil then
      chrEntity:SetEnable(false)
      emptyChr:SetEnable(true)
      classRace:SetEnable(false)
    else
      emptyChr:SetEnable(false)
      classRace:SetEnable(true)
      chrEntity:SetEnable(true)
      local raceRUID = "3e5db3c0b450455fb42f8b3cc79ba6c2"
      local job = ___MOD.tonumber(playerInfoTbl.Job) or 0
      if 1000 <= job and job <= 1512 then
        raceRUID = "611bb3d0201e4657b1414261c6c18461"
      elseif ___MOD._JobLogic:isAran(job) then
        raceRUID = "b57541fbe0a448819d43d257c2a489b3"
      end
      classRace.SpriteGUIRendererComponent.ImageRUID = raceRUID
      self:createNameTag(chrEntity, playerInfoTbl.Name)
      local costume = chrEntity.CostumeManagerComponent
      local equipmentCache = self.chrEntityEquipment[playerIndex]
      ___MOD._PlayerAvatarLookLogic:updateLook(costume, playerInfoTbl.Gender, playerInfoTbl.Hair, playerInfoTbl.Face, playerInfoTbl.Skin, equipmentCache, playerInfoTbl.MSWCody or false, nil, false)
      local isTwoHandedMotion = false
      local weaponSlot = equipmentCache[___MOD._EquipmentSlotType.WEAPON]
      if weaponSlot then
        local sticker = weaponSlot[___MOD._EquipmentSubSlotType.STICKER]
        local main = weaponSlot[___MOD._EquipmentSubSlotType.MAIN]
        local weaponItemID
        if sticker then
          weaponItemID = sticker.itemId
        elseif main then
          weaponItemID = main.itemId
        end
        if weaponItemID then
          local weaponType = ___MOD._WeaponType:getWeaponTypeByItemID(weaponItemID)
          if weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.POLEARM then
            isTwoHandedMotion = true
          end
        end
      end
      equipmentCache.isTwoHandedMotion = isTwoHandedMotion
      local chr = self.chrEntityList[i] or nil
      local expectedPlayerIndex = playerIndex
      if chr then
        chr:SendEvent(___MOD.UIAvatarActionEvent(1, ___MOD.MapleAvatarBodyActionState.Stand))
        chr:SendEvent(___MOD.BodyActionStateChangeEvent(true, ___MOD.MapleAvatarBodyActionState.Stand))
        ___MOD._TimerService:SetTimerOnce(function()
          if not ___MOD.isvalid(chr) then
            return
          end
          if self._T.characterPageRenderVersion ~= renderVersion then
            return
          end
          if chr.CharSelectComponent.index ~= expectedPlayerIndex then
            return
          end
          if self.selectedChrIndex == expectedPlayerIndex then
            return
          end
          chr:SendEvent(___MOD.UIAvatarActionEvent(1, ___MOD.MapleAvatarBodyActionState.Stand))
          chr:SendEvent(___MOD.BodyActionStateChangeEvent(true, ___MOD.MapleAvatarBodyActionState.Stand))
        end, 0.05)
      end
    end
  end
end

function LoginLogic.requestDelayedAccountInfoWorldRender(self, key, yPos)
  self:clearDelayedAccountInfoWorldRender(key)
  local timerKey = "delayedAccountInfoWorldRender_" .. ___MOD.tostring(key or "")
  self._T[timerKey] = ___MOD._TimerService:SetTimerOnce(function()
    self._T[timerKey] = nil
    local entity = self:get(key)
    if not ___MOD.isvalid(entity) or entity.BitmapFontRendererComponent == nil then
      return
    end
    local bf = entity.BitmapFontRendererComponent
    bf._T.lastWorldRenderKey = nil
    ___MOD.pcall(function()
      bf:drawText_World()
    end)
    if ___MOD.isvalid(entity.TransformComponent) then
      local pos = entity.TransformComponent.Position
      entity.TransformComponent.Position = ___MOD.FastVector3(pos.x or 0, yPos, pos.z or 0)
    end
  end, 1)
end

function LoginLogic.setCachedPlayerInfoList(self, userId, playerInfoList)

end

function LoginLogic.setCachedPlayerInfoResponse(self, userId, playerId, response)

end

function LoginLogic.setCachedPlayerListResponse(self, userId, response)

end

function LoginLogic.setCharacterActionButtonsEnabled(self, enable)
  local btNew = self:get("BtNew")
  if ___MOD.isvalid(btNew) then
    btNew.UIButtonComponent.Enable = enable
  end
  local btDelete = self:get("BtDelete")
  if ___MOD.isvalid(btDelete) then
    btDelete.UIButtonComponent.Enable = enable
  end
  local btSelect = self:get("BtSelect")
  if ___MOD.isvalid(btSelect) then
    btSelect.UIButtonComponent.Enable = enable
  end
end

function LoginLogic.setCharacterList(self, playerInfoList, equipmentList)
  self.playerInfoList = {}
  self.chrEntityEquipment = {}
  local count = ___MOD.math.min(#playerInfoList, self.maxPlayer)
  for i = 1, count do
    local playerInfo = playerInfoList[i]
    if not ___MOD._UtilLogic:IsNilorEmptyString(playerInfo) then
      self.playerInfoList[i] = ___MOD._HttpService:JSONDecode(playerInfo)
    end
    local equipment = equipmentList[i]
    if not ___MOD._UtilLogic:IsNilorEmptyString(equipment) then
      local equipmentTbl = ___MOD._HttpService:JSONDecode(equipment)
      if equipmentTbl ~= nil then
        self.chrEntityEquipment[i] = {}
        for slotIndex, slot in ___MOD.pairs(equipmentTbl) do
          self.chrEntityEquipment[i][slotIndex] = {}
          for subSlot, equipData in ___MOD.pairs(slot) do
            self.chrEntityEquipment[i][slotIndex][subSlot] = {}
            local equipment_ = ___MOD.Equipment()
            equipment_:fromTable(equipData)
            if equipment_.equip.itemId ~= nil then
              self.chrEntityEquipment[i][slotIndex][subSlot] = equipment_
            end
          end
        end
      end
    end
  end
  self:renderCharacterPage()
  self:moveCamera(2, true, nil)
  self.loginStep = 2
  self:get("loginBtn").UIButtonComponent.Enable = true
end

function LoginLogic.setCreateCharacterEntities(self, rootPath)
  local charName = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharName")
  local charSet = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharSet")
  local inputName = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharName/InputName")
  local normalChr = ___MOD._EntityService:GetEntityByPath(rootPath .. "/NormalChr")
  local charNameBtYes = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharName/BtYes")
  local charNameBtNo = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharName/BtNo")
  local charSetBtYes = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharSet/BtYes")
  local charSetBtNo = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharSet/BtNo")
  if not (___MOD.isvalid(charName) and ___MOD.isvalid(charSet) and ___MOD.isvalid(inputName) and ___MOD.isvalid(normalChr) and ___MOD.isvalid(charNameBtYes) and ___MOD.isvalid(charNameBtNo) and ___MOD.isvalid(charSetBtYes)) or not ___MOD.isvalid(charSetBtNo) then
    ___MOD.log_warning("[LoginLogic.setCreateCharacterEntities] invalid create character root: " .. ___MOD.tostring(rootPath))
    return false
  end
  self.entities.CharName = charName
  self.entities.CharSet = charSet
  self.entities.InputName = inputName
  self.entities.NormalChr = normalChr
  self.entities.CharName_BtYes = charNameBtYes
  self.entities.CharName_BtNo = charNameBtNo
  self.entities.CharSet_BtYes = charSetBtYes
  self.entities.CharSet_BtNo = charSetBtNo
  for i = 1, 7 do
    local text = ___MOD._EntityService:GetEntityByPath(rootPath .. "/CharSet/AvartarSel" .. ___MOD.tostring(i) .. "/AvartarSel" .. ___MOD.tostring(i) .. "_Text")
    if ___MOD.isvalid(text) then
      self.avartarSelTexts[i] = text
    end
  end
  return true
end

function LoginLogic.setDeletingPlayer(self, userId, deleting)

end

function LoginLogic.setEquip(self, chrEntityIndex, slot, equip, equipCacheIndex)
  local storeIndex = equipCacheIndex or chrEntityIndex
  if self.chrEntityEquipment[storeIndex] == nil then
    self.chrEntityEquipment[storeIndex] = {}
  end
  local equipStore = self.chrEntityEquipment[storeIndex]
  local category
  local type = equip.itemId // 10000
  local equipInfo = ___MOD._EquipManager:getItemById(equip.itemId)
  if type == 106 then
    category = ___MOD.MapleAvatarItemCategory.Pants
  elseif type == 104 then
    category = ___MOD.MapleAvatarItemCategory.Coat
  elseif type == 108 then
    category = ___MOD.MapleAvatarItemCategory.Glove
  elseif type == 109 then
    category = ___MOD.MapleAvatarItemCategory.SubWeapon
  elseif type == 100 then
    category = ___MOD.MapleAvatarItemCategory.Cap
  elseif type == 110 then
    category = ___MOD.MapleAvatarItemCategory.Cape
  elseif type == 105 then
    category = ___MOD.MapleAvatarItemCategory.Longcoat
  elseif type == 107 then
    category = ___MOD.MapleAvatarItemCategory.Shoes
  elseif type == 134 then
    category = ___MOD.MapleAvatarItemCategory.SubWeapon
  elseif 130 <= type and type <= 149 then
    local weaponType = ___MOD._WeaponType:getWeaponTypeByItemID(equip.itemId)
    if weaponType == ___MOD._WeaponType.TWO_HANDED_SWORD or weaponType == ___MOD._WeaponType.TWO_HANDED_MACE or weaponType == ___MOD._WeaponType.TWO_HANDED_AXE or weaponType == ___MOD._WeaponType.POLEARM or weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.CROSSBOW or weaponType == ___MOD._WeaponType.BOW or weaponType == ___MOD._WeaponType.KNUCKLE or weaponType == ___MOD._WeaponType.GUN or weaponType == ___MOD._WeaponType.CLAW then
      category = ___MOD.MapleAvatarItemCategory.TwoHandedWeapon
    else
      category = ___MOD.MapleAvatarItemCategory.OneHandedWeapon
    end
    local isTwoHandedMotion = weaponType == ___MOD._WeaponType.SPEAR or weaponType == ___MOD._WeaponType.POLEARM
    equipStore.isTwoHandedMotion = isTwoHandedMotion
  end
  if type == 170 then
    category = ___MOD.MapleAvatarItemCategory.OneHandedWeapon
    equipStore.isTwoHandedMotion = false
  end
  local isCash = equipInfo.cash
  local chrEntity = self.chrEntityList[chrEntityIndex]
  if not ___MOD.isvalid(chrEntity) then
    return
  end
  local slotStore = equipStore[slot]
  if not isCash then
    if (slotStore == nil or slotStore[2] == nil) and category ~= nil then
      chrEntity.CostumeManagerComponent:SetEquip(category, ___MOD.__RUIDManager:get(___MOD.tostring(equip.itemId)))
    end
  elseif category ~= nil then
    chrEntity.CostumeManagerComponent:SetEquip(category, ___MOD.__RUIDManager:get(___MOD.tostring(equip.itemId)))
  end
end

function LoginLogic.setLoginAuthorizedUser(self, userId, authorized)

end

function LoginLogic.setLoginButtonEnabled(self, enable)
  local loginBtn = self:get("loginBtn")
  if ___MOD.isvalid(loginBtn) and loginBtn.UIButtonComponent ~= nil then
    loginBtn.UIButtonComponent.Enable = enable
  end
end

function LoginLogic.setVersionGlyphPosX(self)
  local glyph = ___MOD._EntityService:GetEntityByPath("/ui/LoginFrame/version/__MSWGlyph_1")
  if not ___MOD.isvalid(glyph) then
    return
  end
  local tr = glyph.UITransformComponent
  if ___MOD.isvalid(tr) then
    local y = 0
    if tr.anchoredPosition ~= nil then
      y = tr.anchoredPosition.y or 0
    end
    tr.anchoredPosition = ___MOD.FastVector2(150, y)
  end
end
