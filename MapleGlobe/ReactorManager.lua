

function ReactorManager.getReactor(self, id)
  return self.Reactor[id]
end

function ReactorManager.getReactorState(self, id, state)
  local r = self.Reactor[id]
  return r and r[state] or nil
end

function ReactorManager.loadReactor(self)
  local time = ___MOD._UtilLogic.ElapsedSeconds
  local dataset = ___MOD._DataService:GetTable("Reactor_wz")
  local rowCount = dataset:GetRowCount()
  local anims, id, data, reactorId
  local caches = {}
  for i = 1, rowCount do
    id = ___MOD._UtilLogic:Replace(dataset:GetCell(i, "key"), ".img", "")
    reactorId = ___MOD.tonumber(id) or 0
    if reactorId ~= 0 then
      data = ___MOD._WzUtils:parseWzData(dataset:GetCell(i, "data"))
      if ___MOD.type(data) == "table" then
        caches[reactorId] = {}
        local reactor = caches[reactorId]
        local lastState = 0
        for nodeName, t in ___MOD.pairs(data) do
          if nodeName == "info" then
            if t.link then
              reactor.link = ___MOD.tonumber(___MOD._WzUtils:getString(t.link, "0"))
            end
            goto lbl_216
          elseif nodeName == "action" then
            reactor.action = ___MOD._WzUtils:getString(t, nil)
            goto lbl_216
          end
          nodeName = ___MOD.tonumber(nodeName)
          if nodeName ~= nil then
            nodeName = nodeName + 1
            reactor[nodeName] = {}
            local s = reactor[nodeName]
            s.stand = ___MOD._WzUtils:parseAnimation(t)
            local standAnim = s.stand.anim
            local hitDelay = s.stand.totalDelay / 1000
            s.hitDelay = hitDelay
            local changeStateDelay = 1
            if t.hit then
              s.hit = ___MOD._WzUtils:parseAnimation(t.hit)
              local hitAnim = s.hit.anim
              changeStateDelay = s.hit.totalDelay / 1000
            end
            s.changeStateDelay = changeStateDelay
            if t.event then
              s.eventList = {
                event = {}
              }
              local count = 0
              for i, e in ___MOD.pairs(t.event) do
                if i == "timeOut" then
                  local timeOut = ___MOD._WzUtils:getInteger(e, 0)
                  if 0 < timeOut then
                    timeOut = timeOut / 1000
                  end
                  s.eventList.timeOut = timeOut
                else
                  i = ___MOD.tonumber(i)
                  if i ~= nil then
                    i = i + 1
                    local type = ___MOD._WzUtils:getInteger(e.type, -1)
                    local nextState = ___MOD._WzUtils:getInteger(e.state, -1)
                    if type ~= -1 and nextState ~= -1 then
                      nextState = nextState + 1
                      s.eventList.event[i] = {}
                      local event = s.eventList.event[i]
                      event.type = type
                      event.nextState = nextState
                      if type == 100 then
                        event["0"] = ___MOD.tonumber(___MOD._WzUtils:getString(e["0"], nil))
                        event["1"] = ___MOD._WzUtils:getInteger(e["1"], 0)
                        event["2"] = ___MOD._WzUtils:getBoolean(e["2"], false)
                        event.lt = ___MOD._WzUtils:getFastVector(e.lt, ___MOD.FastVector2.zero:Clone())
                        event.rb = ___MOD._WzUtils:getFastVector(e.rb, ___MOD.FastVector2.zero:Clone())
                      end
                      count = count + 1
                    end
                  end
                end
              end
              s.eventList.count = count
            end
            lastState = lastState + 1
          end
          ::lbl_216::
        end
        reactor.lastState = lastState
        self.count = self.count + 1
      end
    end
  end
  for id, reactor in ___MOD.pairs(caches) do
    local link = reactor.link or 0
    if link ~= 0 then
      local src = caches[link]
      if src then
        for k, v in ___MOD.pairs(src) do
          if k ~= "info" and k ~= "action" then
            reactor[k] = v
          end
        end
      end
    end
  end
  self.Reactor = caches
  ___MOD.log(___MOD.string.format("Loaded Reactor.wz (%.2f secs) Count : %d", ___MOD._UtilLogic.ElapsedSeconds - time, self.count))
  ___MOD._DataLoadManager:compeletedLoad()
end
