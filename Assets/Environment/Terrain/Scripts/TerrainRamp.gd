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
	
	####### TOP
	### X+, Z+
	## Tri+
	vertices.push_back(Vector3(0, 5, 4))
	vertices.push_back(Vector3(4, 5, 0))
	vertices.push_back(Vector3(4, 5, 4))
	## Tri-
	vertices.push_back(Vector3(0, 5, 0))
	vertices.push_back(Vector3(4, 5, 0))
	vertices.push_back(Vector3(0, 5, 4))
	
	shape.set_faces(vertices)
	collisionShape.shape = shape
