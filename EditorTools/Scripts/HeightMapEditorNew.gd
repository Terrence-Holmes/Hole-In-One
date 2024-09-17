@tool
extends Node3D

@onready var root : TerrainPiece = null
@onready var terrainMesh : MeshInstance3D = null
@onready var collisionShape : CollisionShape3D = null
@onready var defaultTexture : Texture = preload("res://Assets/Environment/Terrain/HeightMaps/hm_default.png")


var prev_size : Vector3 = Vector3(8, 8, 8)
var prev_position : Vector3 = Vector3.ZERO

var prev_heightRatio : float = 1
var prev_heightTexture : Texture = null

func _ready():
	_get_references()
	#Make sure mesh and collision shape are unique
	#TODO: Move these into the level editor so that it does this only once, when the piece is created
	terrainMesh.mesh = terrainMesh.mesh.duplicate()
	terrainMesh.material_override = terrainMesh.material_override.duplicate()
	if (not Engine.is_editor_hint()):
		queue_free()


func _process(delta):
	_get_references()
	_detectChange_size()
	_detectChange_heightRatio()
	_detectChange_heightTexture()

func _get_references():
	if (root == null):
		root = get_parent()
		terrainMesh = root.get_node("Mesh")
		collisionShape = terrainMesh.get_node("CollisionBody/CollisionShape")

func _detectChange_size():
	if (prev_size != root.size):
		prev_size = root.size
		terrainMesh.position = Vector3(0, root.size.y, 0)
		terrainMesh.mesh.size = Vector2(root.size.x, root.size.z)
		terrainMesh.material_override.set("shader_param/size", root.size)
		_set_top_mesh_uv()


func _detectChange_heightRatio():
	if (prev_heightRatio != root.heightRatio):
		prev_heightRatio = root.heightRatio
		terrainMesh.material_override.set("shader_param/heightRatio", root.heightRatio)


func _detectChange_heightTexture():
	if (prev_heightTexture != root.heightTexture):
		if (root.heightTexture == null):
			root.heightTexture = defaultTexture
		
		prev_heightTexture = root.heightTexture
		terrainMesh.material_override.set("shader_param/heightmap", root.heightTexture)



func _set_top_mesh_uv():
	_get_references()
	var sizeUVOffset : Vector2 = -Vector2(fmod(root.size.x, 16) / root.size.x, fmod(root.size.z, 16) / root.size.z) * 0.5
	terrainMesh.material_override.set("shader_param/UVOffset", sizeUVOffset)
	
