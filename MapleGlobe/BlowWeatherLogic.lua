

function BlowWeatherLogic.addParticle(self, map, spawnPos)
  local p = ___MOD._SpawnService:SpawnByModelId(___MOD._EntryService:GetModelIdByName("BlowWeatherParitcle"), "particle", spawnPos, map)
end

function BlowWeatherLogic.test(self, map, type, direction, speed)
  local width, height = ___MOD._UILogic.ScreenWidth, ___MOD._UILogic.ScreenHeight
  local startX = ___MOD._GlobalRand32:randomIntegerRange(0, width)
  local startY = ___MOD._GlobalRand32:randomIntegerRange(0, height)
  local startPos = ___MOD._UILogic:ScreenToWorldPosition(___MOD.Vector2(startX, startY))
  self:addParticle(map, startPos:ToVector3())
end
