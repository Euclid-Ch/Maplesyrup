

function MobAttackElemAttr.getElemAttr(self, elemAttr)
  return self.elemAttrTable[elemAttr] or 0
end

function MobAttackElemAttr.OnBeginPlay(self)
  self.elemAttrTable = {
    I = 1,
    F = 2,
    L = 3,
    P = 4
  }
end
