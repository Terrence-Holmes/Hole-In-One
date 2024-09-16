@tool
extends Node3D

@onready var root : HeightMap = get_parent()
@onready var terrainMesh : MeshInstance3D = root.get_node("Mesh")
@onready var collisionShape : CollisionShape3D = terrainMesh.get_node("CollisionBody/CollisionShape")
@onready var defaultTexture : Texture = preload("res://Assets/Environment/Terrain/HeightMaps/hm_default.png")

var prev_size : Vector3 = Vector3(8, 8, 8)
var prev_heightRatio : float = 1
var prev_UVOffset : Vector2 = Vector2.ZERO
var prev_heightTexture : Texture = null


func _ready():
	if (not Engine.is_editor_hint()):
		queue_free()
	else:
		#Make sure mesh and collision shape are unique
		#TODO: Move these into the level editor so that it does this only once, when the piece is created
		terrainMesh.mesh = terrainMesh.mesh.duplicate()
		terrainMesh.material_override = terrainMesh.material_override.duplicate()


func _process(delta):
	_detectChange_size()
	_detectChange_heightRatio()
	_detectChange_UVOffset()
	_detectChange_heightTexture()


func _detectChange_size():
	if (prev_size != root.size):
		prev_size = root.size
		terrainMesh.mesh.size = Vector2(root.size.x, root.size.z)
		terrainMesh.material_override.set("shader_param/textureUV", Vector2(root.size.x, root.size.z) / 8)
		

func _detectChange_heightRatio():
	if (prev_heightRatio != root.heightRatio):
		prev_heightRatio = root.heightRatio
		terrainMesh.material_override.set("shader_param/heightRatio", root.heightRatio)


func _detectChange_UVOffset():
	if (prev_UVOffset != root.UVOffset):
		root.UVOffset.x = clampf(root.UVOffset.x, -1, 1)
		root.UVOffset.y = clampf(root.UVOffset.y, -1, 1)
		prev_UVOffset = root.UVOffset
		terrainMesh.material_override.set("shader_param/UVOffset", root.UVOffset * 0.5)


func _detectChange_heightTexture():
	if (prev_heightTexture != root.heightTexture):
		if (root.heightTexture == null):
			print("wtf")
			root.heightTexture = defaultTexture
		
		prev_heightTexture = root.heightTexture
		terrainMesh.material_override.set("shader_param/heightmap", root.heightTexture)
