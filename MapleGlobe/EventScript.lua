

function EventScript.cacheScriptFunc(self)

end

function EventScript.canGainIceboxReward(self, player, reward)

end

function EventScript.consumeIceboxItem(self, player, itemId)

end

function EventScript.createIceboxItemInfo(self, itemId, itemFlag, expTime, potential)

end

function EventScript.event_script(self, player, udc)

end

function EventScript.gainIceboxReward(self, player, reward)

end

function EventScript.getIceboxExpireTime(self)

end

function EventScript.getIceboxIcebarExpireTime(self)

end

function EventScript.getIceboxThirtyDayExpireTime(self)

end

function EventScript.getTestWorldSupportText(self)

end

function EventScript.hasIceboxOpenInventorySpace(self, player)

end

function EventScript.icebox(self, player, udc)

end

function EventScript.icebox1(self, player, udc)

end

function EventScript.isBestTesterRewardTarget(self, player)

end

function EventScript.isIceboxEventExpired(self)

end

function EventScript.isRecoverTargetSkill(self, player, skillData)

end

function EventScript.newPet(self, p, udc)
  udc:setNpcTemplateID(1012005)
  udc:say("내가 만든 아이를 키워줄 분이로군! 이 아이는 본디 인형이었지만 생명에 대한 오랜 연구 끝에 탄생한 마법의 동물이오. \r\n조금씩 밖에 나지 않는 생명의 물을 어렵게 구해 뿌려주었지. 하여 생명의 물이 마르는 #b#e90일#k#n 뒤엔 인형으로 되돌아 간다오. 아, 그렇다고 너무 걱정할 것 없소. #b#e생명의 물#n#k을 다시 뿌려주면 아이는 되살아나 전처럼 똑같이 지낼 수 있다오. 아이가 배고파 한다면 먹이를 챙겨 주시오. #b#e펫의 먹이#k#n는 헤네시스의 NPC 큐트 말고도 여러 상인들에게 구할 수 있으니 어렵지 않을 거요. \r\n참, 내 소개를 안 했군. 나는 세계수의 가장 밑바닥 부근에서 생명수를 채취하고 있는 마법사라오. 혹시 더 궁금한 것이 있다면 내 제자들이 지상에 있으니 찾아가면 친절히 알려줄 것이오.")
end

function EventScript.notifyIceboxEventExpired(self, player)

end

function EventScript.npc_9010000(self, player, udc)

end

function EventScript.openAranPassClient(self)
  local aranPass = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/AranPass")
  if not ___MOD.isvalid(aranPass) then
    return
  end
  if not aranPass.Enable then
    ___MOD._UIWindowLogic:enableUI(aranPass)
    return
  end
  ___MOD._UIWindowLogic:moveToTopLayer(aranPass)
  if ___MOD.isvalid(aranPass.AranPassComponent) then
    aranPass.AranPassComponent:requestState()
    aranPass.AranPassComponent:setupAranPass()
  end
end

function EventScript.openDailyGiftClient(self)
  if ___MOD._WorldConstants.canEnterDailyGift ~= true then
    ___MOD._UINotice:showAlertUI("데일리 기프트가 일시적으로 제한됩니다.\r\n\r\n잠시 후 다시 시도해 주세요.")
    return
  end
  local dailyGift = ___MOD._EntityService:GetEntityByPath("/ui/UIGroup/DailyGift")
  if not ___MOD.isvalid(dailyGift) then
    return
  end
  if not dailyGift.Enable then
    ___MOD._UIWindowLogic:enableUI(dailyGift)
    return
  end
  ___MOD._UIWindowLogic:moveToTopLayer(dailyGift)
  if ___MOD.isvalid(dailyGift.DailyGiftComponent) then
    dailyGift.DailyGiftComponent:setupDailyGift()
  end
end

function EventScript.premium_icebox_exchange(self, player, udc)

end

function EventScript.quest_script(self, player, udc)

end

function EventScript.recoverQuestTeachSkills(self, player, udc)

end

function EventScript.selectIcebox1Reward(self)

end

function EventScript.selectIceboxReward(self)

end
