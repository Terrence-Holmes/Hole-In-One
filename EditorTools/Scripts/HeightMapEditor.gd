@tool
extends TerrainEditorScript

@onready var terrainMesh : MeshInstance3D = null
@onready var collisionShape : CollisionShape3D = null
@onready var defaultTexture : Texture = preload("res://Assets/Environment/Terrain/HeightMaps/hm_default.png")


var prev_heightRatio : float = 1
var prev_heightTexture : Texture = null


func _ready():
	super._ready()
	if (Engine.is_editor_hint()):
		#Make sure mesh and collision shape are unique
		#TODO: Move these into the level editor so that it does this only once, when the piece is created
		terrainMesh.mesh = terrainMesh.mesh.duplicate()
		terrainMesh.material_override = terrainMesh.material_override.duplicate()

func _process(delta):
	_get_references()
	terrainMesh.material_override.set("shader_param/worldPosition", global_position / 8)
	
	_detectChange_size()
	_detectChange_UVOffset()
	_detectChange_heightRatio()
	_detectChange_heightTexture()

func _get_references():
	if (terrainMesh == null):
		terrainMesh = root.get_node("Mesh")
		collisionShape = terrainMesh.get_node("CollisionBody/CollisionShape")

func _detectChange_size():
	if (prev_size != root.size):
		super._detectChange_size()
		terrainMesh.position = Vector3(0, root.size.y, 0)
		terrainMesh.mesh.size = Vector2(root.size.x, root.size.z)
		terrainMesh.material_override.set("shader_param/textureUV", Vector2(root.size.x, root.size.z) / 8)


func _detectChange_heightRatio():
	if (prev_heightRatio != root.heightRatio):
		prev_heightRatio = root.heightRatio
		terrainMesh.material_override.set("shader_param/heightRatio", root.heightRatio)


func _detectChange_UVOffset():
	if (prev_UVOffset != root.UVOffset):
		super._detectChange_UVOffset()
		root.UVOffset.x = clampf(root.UVOffset.x, -1, 1)
		root.UVOffset.y = clampf(root.UVOffset.y, -1, 1)
		prev_UVOffset = root.UVOffset
		terrainMesh.material_override.set("shader_param/UVOffset", root.UVOffset / (Vector2(root.size.x, root.size.z) / 8))
		terrainMesh.material_override.set("shader_param/textureUV", Vector2(root.size.x, root.size.z) / 8)


func _detectChange_heightTexture():
	if (prev_heightTexture != root.heightTexture):
		if (root.heightTexture == null):
			root.heightTexture = defaultTexture
		
		prev_heightTexture = root.heightTexture
		terrainMesh.material_override.set("shader_param/heightmap", root.heightTexture)
