extends TerrainPiece
class_name TerrainRamp

@export_category("Ramp")
@export var rampHeight : float = 2
@export var rampOffset : float = 0

@export var rampHeightPoints : Array[float] = \
[0, 0, 0,
0, 0, 0,
0, 0, 0]

@onready var meshContainer : Node3D = get_node("Meshes")


func _ready():
	_generate_collision()


func _process(delta):
	pass


func _generate_collision():
	var vertices : PackedVector3Array
	var shape : ConcavePolygonShape3D = ConcavePolygonShape3D.new()
	var t_size : Vector2 = Vector2(size.x, size.z) / 2
	
	
	######### TOP
	#### X+, Z+
	## Tri+
	vertices.push_back(Vector3(0, rampHeightPoints[1], t_size.y))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[3], 0))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[0], t_size.y))
	## Tri-
	vertices.push_back(Vector3(0, rampHeightPoints[4], 0))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[3], 0))
	vertices.push_back(Vector3(0, rampHeightPoints[1], t_size.y))
	### X-, Z+
	## Tri+
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[2], t_size.y))
	vertices.push_back(Vector3(0, rampHeightPoints[4], 0))
	vertices.push_back(Vector3(0, rampHeightPoints[1], t_size.y))
	## Tri-
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[5], 0))
	vertices.push_back(Vector3(0, rampHeightPoints[4], 0))
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[2], t_size.y))
	#### X+, Z-
	## Tri+
	vertices.push_back(Vector3(0, rampHeightPoints[4], 0))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[6], -t_size.y))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[3], 0))
	## Tri-
	vertices.push_back(Vector3(0, rampHeightPoints[7], -t_size.y))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[6], -t_size.y))
	vertices.push_back(Vector3(0, rampHeightPoints[4], 0))
	### X-, Z-
	## Tri+
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[5], 0))
	vertices.push_back(Vector3(0, rampHeightPoints[7], -t_size.y))
	vertices.push_back(Vector3(0, rampHeightPoints[4], 0))
	## Tri-
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[8], -t_size.y))
	vertices.push_back(Vector3(0, rampHeightPoints[7], -t_size.y))
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[5], 0))
	
	######### FRONT
	#### X+
	## X+
	vertices.push_back(Vector3(0, rampHeightPoints[7], -t_size.y))
	vertices.push_back(Vector3(t_size.x, 0, -t_size.y))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[6], -t_size.y))
	## X-
	vertices.push_back(Vector3(0, 0, -t_size.y))
	vertices.push_back(Vector3(t_size.x, 0, -t_size.y))
	vertices.push_back(Vector3(0, rampHeightPoints[7], -t_size.y))
	#### X-
	## X+
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[8], -t_size.y))
	vertices.push_back(Vector3(0, 0, -t_size.y))
	vertices.push_back(Vector3(0, rampHeightPoints[7], -t_size.y))
	## X-
	vertices.push_back(Vector3(-t_size.x, 0, -t_size.y))
	vertices.push_back(Vector3(0, 0, -t_size.y))
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[8], -t_size.y))
	
	######### BACK
	#### X-
	## X-
	vertices.push_back(Vector3(0, rampHeightPoints[1], t_size.y))
	vertices.push_back(Vector3(-t_size.x, 0, t_size.y))
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[2], t_size.y))
	## X+
	vertices.push_back(Vector3(0, 0, t_size.y))
	vertices.push_back(Vector3(-t_size.x, 0, t_size.y))
	vertices.push_back(Vector3(0, rampHeightPoints[1], t_size.y))
	#### X+
	## X-
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[0], t_size.y))
	vertices.push_back(Vector3(0, 0, t_size.y))
	vertices.push_back(Vector3(0, rampHeightPoints[1], t_size.y))
	## X+
	vertices.push_back(Vector3(t_size.x, 0, t_size.y))
	vertices.push_back(Vector3(0, 0, t_size.y))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[0], t_size.y))
	
	######### LEFT
	#### Z-
	## Z-
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[5], 0))
	vertices.push_back(Vector3(-t_size.x, 0, -t_size.y))
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[8], -t_size.y))
	## Z+
	vertices.push_back(Vector3(-t_size.x, 0, -t_size.y))
	vertices.push_back(Vector3(-t_size.x, 0, 0))
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[5], -t_size.y))
	#### Z+
	## Z-
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[2], t_size.y))
	vertices.push_back(Vector3(-t_size.x, 0, 0))
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[5], 0))
	## Z+
	vertices.push_back(Vector3(-t_size.x, 0, t_size.y))
	vertices.push_back(Vector3(-t_size.x, 0, 0))
	vertices.push_back(Vector3(-t_size.x, rampHeightPoints[2], t_size.y))
	
	######### RIGHT
	#### Z+
	## Z+
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[3], 0))
	vertices.push_back(Vector3(t_size.x, 0, t_size.y))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[0], t_size.y))
	## Z-
	vertices.push_back(Vector3(t_size.x, 0, 0))
	vertices.push_back(Vector3(t_size.x, 0, t_size.y))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[3], 0))
	#### Z-
	## Z+
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[6], -t_size.y))
	vertices.push_back(Vector3(t_size.x, 0, 0))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[3], 0))
	## Z-
	vertices.push_back(Vector3(t_size.x, 0, -t_size.y))
	vertices.push_back(Vector3(t_size.x, 0, 0))
	vertices.push_back(Vector3(t_size.x, rampHeightPoints[6], -t_size.y))
	
	
	shape.set_faces(vertices)
	collisionShape.shape = shape


















