

function Adventure2._3jobExit(self, player, udc)

end

function Adventure2.bowman3(self, player, udc)

end

function Adventure2.cacheScriptFunc(self)

end

function Adventure2.crack(self, player, udc)
  local s = ___MOD._ScriptLogic
  local qex = s:getQuestEx(player, 195000) or "0"
  local jobDiff = s:getJob(player) // 100 * 100
  if jobDiff == 100 and s:getFieldID(player) ~= 105070001 then
    udc:sayOk("다른 세계로 통할 것 같은 이상한 모양의 차원의 균열이다.")
    return
  end
  if jobDiff == 200 and s:getFieldID(player) ~= 100040106 then
    udc:sayOk("다른 세계로 통할 것 같은 이상한 모양의 차원의 균열이다.")
    return
  end
  if jobDiff == 300 and s:getFieldID(player) ~= 105040305 then
    udc:sayOk("다른 세계로 통할 것 같은 이상한 모양의 차원의 균열이다.")
    return
  end
  if jobDiff == 400 and s:getFieldID(player) ~= 107000402 then
    udc:sayOk("다른 세계로 통할 것 같은 이상한 모양의 차원의 균열이다.")
    return
  end
  if jobDiff == 500 and s:getFieldID(player) ~= 105070200 then
    udc:sayOk("다른 세계로 통할 것 같은 이상한 모양의 차원의 균열이다.")
    return
  end
  if qex ~= "job3_trial1_2" or s:getItemCount(player, 4031059) >= 1 then
    udc:sayOk("다른 세계로 통할 것 같은 이상한 모양의 차원의 균열이다.")
    return
  end
  if udc:askYesNo("차원의 문을 통해 다른 차원으로 이동할 수 있습니다. 이동하시겠습니까?") == 1 then
    self:portal_3th_jobQuestMap(player, udc)
  end
end

function Adventure2.holySton(self, player, udc)

end

function Adventure2.holyStone(self, player, udc)

end

function Adventure2.pirate3(self, player, udc)

end

function Adventure2.portal_3th_jobQuestMap(self, player, udc)

end

function Adventure2.thief3(self, player, udc)

end

function Adventure2.warrior3(self, player, udc)

end

function Adventure2.wizard3(self, player, udc)

end
