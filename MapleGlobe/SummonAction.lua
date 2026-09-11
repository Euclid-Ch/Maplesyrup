

function SummonAction.castKeyFromIndex(self, i)
  return self.sSummonedAction[i] or ""
end

function SummonAction.OnBeginPlay(self)
  local s = self.sSummonedAction
  s[0] = "stand"
  s[1] = "move"
  s[2] = "fly"
  s[3] = "summoned"
  s[4] = "attack1"
  s[5] = "attack2"
  s[6] = "attackTriangle"
  s[7] = "skill1"
  s[8] = "skill2"
  s[9] = "skill3"
  s[10] = "skill4"
  s[11] = "skill5"
  s[12] = "skill6"
  s[13] = "heal"
  s[14] = "subsummon"
  s[15] = "hit"
  s[16] = "die"
  s[17] = "say"
  s[18] = "prepare"
end
