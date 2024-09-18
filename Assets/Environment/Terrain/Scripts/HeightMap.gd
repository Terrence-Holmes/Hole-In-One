extends TerrainPiece
class_name HeightMap

@export_category("Terrain")
@export_group("Height Map")
@export var heightTexture : Texture = null
@export var heightRatio : float = 2.0
@export_range(0.1, 10, 0.1) var collisionQuality : float = 1
@export_range(10, 300, 1.0) var meshQuality : float = 20


@onready var terrainMesh : MeshInstance3D = get_node("Mesh")

var image : Image = Image.new()
var shape : HeightMapShape3D = HeightMapShape3D.new()

func _ready():
	terrainMesh.mesh = terrainMesh.mesh.duplicate()
	terrainMesh.material_override = terrainMesh.material_override.duplicate()
	


var lateReady : bool = false
func _late_ready():
	lateReady = true
	collisionBody = get_node("Mesh/Body")
	collisionShape = get_node("Mesh/Body/CollisionShape")
	collisionShape.shape = shape
	terrainMesh.position = Vector3(0, size.y, 0)
	terrainMesh.mesh.size = Vector2(size.x, size.z)
	update_terrain(heightRatio, collisionQuality * 0.1)
	terrainMesh.material_override.set("shader_param/heightmap", heightTexture)
	terrainMesh.material_override.set("shader_param/size", size)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!lateReady):
		_late_ready()



func update_terrain(_heightRatio : float, _collisionQuality : float):
	#Set mesh height
	terrainMesh.material_override.set("shader_param/heightRatio", _heightRatio)
	#Load height map
	image.load(heightTexture.resource_path)
	image.convert(Image.FORMAT_RF)
	image.resize(image.get_width() * _collisionQuality, image.get_height() * _collisionQuality)
	#Get height map data
	var data : PackedFloat32Array = image.get_data().to_float32_array()
	for i in range(0, data.size()):
		data[i] *= _heightRatio #Resize height map data to fit with the height ratio
	#Set height map shape with data
	shape.map_width = image.get_width()
	shape.map_depth = image.get_height()
	shape.map_data = data
	#Set collision shape
	var scaleRatio : Vector2 = (Vector2(size.x, size.z) / Vector2(image.get_width(), image.get_height())) * 1.02
	collisionShape.scale = Vector3(scaleRatio.x, 1, scaleRatio.y)
	collisionShape.shape = shape
