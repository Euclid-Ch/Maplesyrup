

function MessageLogic.OnBeginPlay(self)
  self.white = ___MOD.Color.white
  self.yellow = ___MOD.Color.yellow
end

function MessageLogic.onDropPickUpMessage(self, type, idOrMesoAmount, amount)
  local function getCategoryByItemId(itemId)
    local t = itemId // 1000000

    if t == 1 then
      return "장비"
    elseif t == 2 then
      return "소비"
    elseif t == 3 then
      return "설치"
    elseif t == 4 then
      return "기타"
    elseif t == 5 then
      return "캐시"
    end
  end

  if type == 1 then
    local player = ___MOD._UserService.LocalPlayer
    if 0 < idOrMesoAmount and ___MOD.isvalid(player) and ___MOD.isvalid(player.UIStatusBar) then
      player.UIStatusBar:addHuntGainedMeso(idOrMesoAmount)
      player.UIStatusBar:updateExpTooltipText()
    end
    ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("메소를 얻었습니다 (+%d)", idOrMesoAmount), self.white)
    ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("Game.img.PickUpItem"), 1)
  elseif type == 0 then
    local item = ___MOD._ItemManager:getItemById(idOrMesoAmount)
    if item == nil then
      item = ___MOD._EquipManager:getItemById(idOrMesoAmount)
    end
    if 1 < amount then
      ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("%s 아이템을 얻었습니다 (%s %d개)", getCategoryByItemId(idOrMesoAmount), item.name, amount), self.white)
    else
      ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("%s 아이템을 얻었습니다 (%s)", getCategoryByItemId(idOrMesoAmount), item.name), self.white)
    end
    ___MOD._SoundService:PlaySound(___MOD.__RUIDManager:get("Game.img.PickUpItem"), 1)
  elseif type == -1 then
    ___MOD._StackMessageLogic:addMessage_bitmap("아이템을 더 이상 가질 수 없습니다.", self.white)
  elseif type == -2 then
    ___MOD._StackMessageLogic:addMessage_bitmap("이 아이템은 더 이상 가질 수 없습니다", self.white)
  end
end

function MessageLogic.onIncEXPMessage(self, t)
  local ctx = ___MOD.IncEXPMessageCtx()
  ctx:fromTable(t)
  local isLastHit = ctx.isLastHit
  local base = ctx.base
  local partyBonus = ctx.partyBonus
  local eventPartyBonus = ctx.eventPartyBonus
  local buffBonus = ctx.buffBonus
  local eventBonus = ctx.eventBonus
  local serverBonus = ctx.serverBonus
  local total = base + serverBonus + eventBonus + partyBonus + eventPartyBonus + buffBonus
  local player = ___MOD._UserService.LocalPlayer
  if 0 < total and ___MOD.isvalid(player) and ___MOD.isvalid(player.UIStatusBar) then
    player.UIStatusBar:addHuntGainedEXP(total)
    player.UIStatusBar:updateExpTooltipText()
  end
  if 0 < base then
    ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("경험치를 얻었습니다 (+%d)", base), isLastHit and self.white or self.yellow)
  end
  if 0 < serverBonus then
    ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("플래닛 보너스 경험치 (+%d)", serverBonus), self.yellow)
  end
  if 0 < eventBonus then
    ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("이벤트 보너스 경험치 (+%d)", eventBonus), self.yellow)
  end
  if 0 < partyBonus then
    ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("파티 보너스 경험치 (+%d)", partyBonus), self.yellow)
  end
  if 0 < eventPartyBonus then
    ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("이벤트 파티 보너스 경험치 (+%d)", eventPartyBonus), self.yellow)
  end
  if 0 < buffBonus then
    ___MOD._StackMessageLogic:addMessage_bitmap(___MOD.string.format("버프 보너스 경험치 (+%d)", buffBonus), self.yellow)
  end
end
