

function MobActionPartType.typeToString(self, type)
  if type == self.Knockback then
    return "Knockback"
  elseif type == self.KnockbackFly then
    return "KnockbackFly"
  elseif type == self.KnockbackPos then
    return "KnockbackPos"
  elseif type == self.HitMotion then
    return "HitMotion"
  elseif type == self.Move then
    return "Move"
  elseif type == self.Jump then
    return "Jump"
  elseif type == self.Fly then
    return "Fly"
  elseif type == self.Die then
    return "Die"
  elseif type == self.Attack1 then
    return "Attack1"
  elseif type == self.Attack2 then
    return "Attack2"
  elseif type == self.Attack3 then
    return "Attack3"
  elseif type == self.Skill1 then
    return "Skill1"
  elseif type == self.Skill2 then
    return "Skill2"
  elseif type == self.Skill3 then
    return "Skill3"
  elseif type == self.StandMotion then
    return "StandMotion"
  elseif type == self.Flip then
    return "Flip"
  elseif type == self.Chase then
    return "Chase"
  elseif type == self.UpdateSpeed then
    return "UpdateSpeed"
  elseif type == self.Doom then
    return "Doom"
  end
  return "Unknown"
end
