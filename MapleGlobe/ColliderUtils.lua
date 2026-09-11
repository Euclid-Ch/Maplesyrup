

function ColliderUtils.d(self, map, boxId, b)
  local box = b
  if self._T.Boxes == nil then
    self._T.Boxes = {}
  end
  local boxEntity = self._T.Boxes[boxId]
  if not ___MOD.isvalid(boxEntity) then
    boxEntity = ___MOD._SpawnService:SpawnByModelId("model://transformonly", "BoxLine" .. boxId, ___MOD.Vector3.zero, map)
    boxEntity:AddComponent(___MOD.LineRendererComponent)
    self._T.Boxes[boxId] = boxEntity
  end
  local lineRenderer = boxEntity.LineRendererComponent
  lineRenderer.Points:Clear()
  lineRenderer.Loop = true
  local halfSize = box.Size / 2
  local offset = box.Position
  local color = ___MOD.Color(1, 1, 0, 1)
  local width = 0.1
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(-halfSize.x, halfSize.y) + offset, color, width))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(halfSize.x, halfSize.y) + offset, color, width))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(halfSize.x, -halfSize.y) + offset, color, width))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(-halfSize.x, -halfSize.y) + offset, color, width))
end

function ColliderUtils.drawBox(self, map, position, size)
  local lineWidth = 0.2
  local color = ___MOD.FastColor.red
  if not ___MOD.isvalid(self.gizmoAnchor) then
    self.gizmoAnchor = ___MOD._SpawnService:SpawnByModelId("model://transformonly", "Collider", position:ToVector3(), map)
  else
    self.gizmoAnchor.TransformComponent.WorldPosition = position:ToVector3()
  end
  if not ___MOD.isvalid(self.gizmoBody) then
    self.gizmoBody = ___MOD._SpawnService:SpawnByModelId("model://transformonly", "body", ___MOD.Vector3.zero, self.gizmoAnchor)
    self.gizmoBody:AddComponent(___MOD.LineRendererComponent)
  end
  local lineRenderer = self.gizmoBody.LineRendererComponent
  lineRenderer.Points:Clear()
  lineRenderer.Loop = true
  local halfSize = size / 2
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(-halfSize.x, halfSize.y), color, lineWidth))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(halfSize.x, halfSize.y), color, lineWidth))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(halfSize.x, -halfSize.y), color, lineWidth))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(-halfSize.x, -halfSize.y), color, lineWidth))
end

function ColliderUtils.drawBox2(self, map, position, size)
  local lineWidth = 0.2
  local color = ___MOD.FastColor.red
  local gizmoAnchor = ___MOD._SpawnService:SpawnByModelId("model://transformonly", "Collider", position:ToVector3(), map)
  local gizmoBody = ___MOD._SpawnService:SpawnByModelId("model://transformonly", "body", ___MOD.Vector3.zero, gizmoAnchor)
  gizmoBody:AddComponent(___MOD.LineRendererComponent)
  local lineRenderer = gizmoBody.LineRendererComponent
  lineRenderer.Points:Clear()
  lineRenderer.Loop = true
  local halfSize = size / 2
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(-halfSize.x, halfSize.y), color, lineWidth))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(halfSize.x, halfSize.y), color, lineWidth))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(halfSize.x, -halfSize.y), color, lineWidth))
  lineRenderer.Points:Add(___MOD.LinePoint(___MOD.Vector2(-halfSize.x, -halfSize.y), color, lineWidth))
end

function ColliderUtils.drawBoxToClient(self, map, pos, lt, rb, left, boxId)
  local box = ___MOD._NumberUtils:makeBoxShapeFromLtRb(pos, lt, rb, left)
  self:d(map, boxId, box)
end
