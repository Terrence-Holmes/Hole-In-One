extends MeshInstance3D


@onready var collisionShape : CollisionShape3D = get_node("StaticBody3D/CollisionShape3D")
@export var chunkSize : float = 2.0
@export var heightRatio : float = 1.0
@export var collisionQuality : float = 0.1

var image : Image = Image.new()
var shape : HeightMapShape3D = HeightMapShape3D.new()

func _ready():
	collisionShape.shape = shape
	mesh.size = Vector2(chunkSize, chunkSize)
	update_terrain(heightRatio, collisionQuality)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func update_terrain(_heightRatio : float, _collisionQuality : float):
	material_override.set("shader_param/heightRatio", _heightRatio)
	image.load("res://TestHeightMap.png")
	image.convert(Image.FORMAT_RF)
	image.resize(image.get_width() * _collisionQuality, image.get_height() * _collisionQuality)
	var data : PackedFloat32Array = image.get_data().to_float32_array()
	for i in range(0, data.size()):
		data[i] *= _heightRatio
	shape.map_width = image.get_width()
	shape.map_depth = image.get_height()
	shape.map_data = data
	var scaleRatio = chunkSize / float(image.get_width())
	
	collisionShape.scale = Vector3(scaleRatio, 1, scaleRatio)
	collisionShape.shape = shape
