extends Node3D
class_name TerrainPiece

@export_category("Terrain Piece")
@export var size : Vector3 = Vector3(8, 8, 8)
@export var UVOffset : Vector2 = Vector2.ZERO

#References
@onready var collisionBody : StaticBody3D = get_node("Body")
@onready var collisionShape : CollisionShape3D = get_node("Body/CollisionShape")


func _ready():
	_set_collision()

func _set_collision():
	collisionShape.shape = collisionShape.shape.duplicate()
	collisionShape.shape.size = size
	collisionBody.position.y = size.y / 2
