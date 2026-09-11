

function ZLayer.clear(self)
  self.front_z = -1
  self.rear_z = 4000
end

function ZLayer.getFront(self)
  self.front_z = self.front_z - 0.1
  if self.front_z <= -29.8 then
    self.front_z = -1
  end
  return self.front_z
end

function ZLayer.getRear(self)
  self.rear_z = self.rear_z - 0.01
  if self.rear_z < 0.1 then
    self.rear_z = 4000
  end
  return self.rear_z
end
