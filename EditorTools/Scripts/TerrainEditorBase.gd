extends Node3D
class_name TerrainEditorScript

@onready var root : TerrainPiece = get_parent()
#Mesh references
@onready var meshContainer : Node3D = root.get_node("Meshes")
#Top mesh references
@onready var topMeshContainer : Node3D = meshContainer.get_node("TopMeshes")
@onready var tm_topMesh : MeshInstance3D = topMeshContainer.get_node_or_null("TopMesh")
@onready var tm_frontMesh : MeshInstance3D = topMeshContainer.get_node("FrontMesh")
@onready var tm_backMesh : MeshInstance3D = topMeshContainer.get_node("BackMesh")
@onready var tm_leftMesh : MeshInstance3D = topMeshContainer.get_node("LeftMesh")
@onready var tm_rightMesh : MeshInstance3D = topMeshContainer.get_node("RightMesh")
#Bottom mesh references
@onready var bottomMeshContainer : Node3D = meshContainer.get_node("BottomMeshes")
@onready var bm_bottomMesh : MeshInstance3D = bottomMeshContainer.get_node("BottomMesh")
@onready var bm_frontMesh : MeshInstance3D = bottomMeshContainer.get_node("FrontMesh")
@onready var bm_backMesh : MeshInstance3D = bottomMeshContainer.get_node("BackMesh")
@onready var bm_leftMesh : MeshInstance3D = bottomMeshContainer.get_node("LeftMesh")
@onready var bm_rightMesh : MeshInstance3D = bottomMeshContainer.get_node("RightMesh")

var sizeUVOffset : Vector2 = Vector2.ZERO


func _ready():
	if (not Engine.is_editor_hint()):
		queue_free()
	else:
		#Make sure mesh and collision shape are unique
		#TODO: Move these into the level editor so that it does this only once, when the piece is created
		for container in meshContainer.get_children():
			for mesh in container.get_children():
				mesh.mesh = mesh.mesh.duplicate()
				mesh.material_override = mesh.material_override.duplicate()


var prev_size : Vector3 = Vector3(8, 8, 8)
var prev_position : Vector3 = Vector3.ZERO
var prev_UVOffset : Vector2 = Vector2.ZERO

func _process(delta):
	_detectChange_size()
	_detectChange_position()
	_detectChange_UVOffset()


func _detectChange_size():
	if (prev_size != root.size):
		prev_size = root.size
		
		_set_top_mesh_size_and_pos()
		_set_top_mesh_uv()
		_set_bottom_mesh()

func _detectChange_position():
	if (prev_position != root.global_position):
		prev_position = root.global_position
		_set_top_mesh_uv()


func _detectChange_UVOffset():
	if (prev_UVOffset != root.UVOffset):
		root.UVOffset.x = clampf(root.UVOffset.x, -1, 1)
		root.UVOffset.y = clampf(root.UVOffset.y, -1, 1)
		prev_UVOffset = root.UVOffset
		_set_top_mesh_uv()

func _set_top_mesh_size_and_pos():
		var topMeshSizeY : float = min(root.size.y, 4)
		var topMeshPositionY : float = max(root.size.y - 2, root.size.y / 2)
		#Set top side
		if (tm_topMesh != null):
			tm_topMesh.mesh.size = Vector2(root.size.x, root.size.z)
			tm_topMesh.position = Vector3(0, root.size.y, 0)
			tm_topMesh.material_override.set("shader_param/size", root.size)
		#Set front side
		tm_frontMesh.mesh.size = Vector2(root.size.x, topMeshSizeY)
		tm_frontMesh.position = Vector3(0, topMeshPositionY, -root.size.z / 2)
		tm_frontMesh.material_override.set("shader_param/size", root.size)
		#Set back side
		tm_backMesh.mesh.size = Vector2(root.size.x, topMeshSizeY)
		tm_backMesh.position = Vector3(0, topMeshPositionY, root.size.z / 2)
		tm_backMesh.material_override.set("shader_param/size", root.size)
		#Set left side
		tm_leftMesh.mesh.size = Vector2(root.size.z, topMeshSizeY)
		tm_leftMesh.position = Vector3(-root.size.x / 2, topMeshPositionY, 0)
		tm_leftMesh.material_override.set("shader_param/size", root.size)
		#Set right side
		tm_rightMesh.mesh.size = Vector2(root.size.z, topMeshSizeY)
		tm_rightMesh.position = Vector3(root.size.x / 2, topMeshPositionY, 0)
		tm_rightMesh.material_override.set("shader_param/size", root.size)
		
		_set_top_mesh_uv()


func _set_top_mesh_uv():
	##Get side UV flip (for left and back side panels)
	##Set UV flip based on size
	#var sizeMod : Vector2 = Vector2( fmod(root.size.x, 8), fmod(root.size.z, 8)  )
	#var flipXPos : bool = sizeMod.x <= 4 and sizeMod.x != 0
	#var flipZPos : bool = not sizeMod.y <= 4 or sizeMod.y == 0
	##Set UV flip based on position
	##Positive sides (right and back)
	#var posMod : Vector2
	#if (global_position.x >= -sizeMod.x):
		#posMod.x = fmod(abs(root.global_position.x) + sizeMod.x, 8)
		#flipXPos = !flipXPos
	#else:
		#posMod.x = fmod(abs(root.global_position.x + sizeMod.x), 8)
	#if (posMod.x <= 4 and posMod.x != 0):
		#flipXPos = !flipXPos
	#if (posMod.y <= 4 and posMod.y != 0):
		#flipZPos = !flipZPos
	##Negative sides (left and front)
	#posMod = Vector2(
		#fmod(abs(root.global_position.x), 8),
		#fmod(abs(root.global_position.z), 8) )
	#var flipXNeg : bool = not (posMod.x <= 4 and posMod.x != 0)
	#var flipZNeg : bool = not (posMod.y <= 4 and posMod.y != 0)
	#if (root.global_position.x < 0):
		#flipXNeg = !flipXNeg
	#if (root.global_position.z < 0):
		#flipZNeg = !flipZNeg
	
	#Flip UV's if the position requires it
	var positionMod : Vector2
	positionMod.x = fmod(abs(root.global_position.x), 8)
	positionMod.y = fmod(abs(root.global_position.z), 8)
	var flipX : bool = not ((root.global_position.x < 0 and (positionMod.x < 4))
	or ((root.global_position.x >= 0) and (positionMod.x > 4 or positionMod.x == 0)))
	var flipZ : bool = not ((root.global_position.z < 0 and (positionMod.y < 4))
	or ((root.global_position.z >= 0) and (positionMod.y > 4 or positionMod.y == 0)))
	#Flip UV's again if the size requires it
	print(positionMod)
	
	tm_backMesh.material_override.set("shader_param/UVFlip", flipZ)
	if (positionMod.y == 4 or positionMod.y == 0):
		flipZ = !flipZ
	tm_frontMesh.material_override.set("shader_param/UVFlip", flipZ)
	tm_rightMesh.material_override.set("shader_param/UVFlip", flipX)
	if (positionMod.x == 4 or positionMod.x == 0):
		flipX = !flipX
	tm_leftMesh.material_override.set("shader_param/UVFlip", flipX)
	
	#Set UV offsets
	sizeUVOffset = -Vector2(fmod(root.size.x, 16) / root.size.x, fmod(root.size.z, 16) / root.size.z) * 0.5
	if (tm_topMesh != null):
		tm_topMesh.material_override.set("shader_param/UVOffset", sizeUVOffset)
	tm_frontMesh.material_override.set("shader_param/UVOffset", Vector2(sizeUVOffset.x, 0))
	tm_backMesh.material_override.set("shader_param/UVOffset", Vector2(sizeUVOffset.x, 0))
	tm_leftMesh.material_override.set("shader_param/UVOffset", Vector2(sizeUVOffset.y, 0))
	tm_rightMesh.material_override.set("shader_param/UVOffset", Vector2(sizeUVOffset.y, 0))

func _set_bottom_mesh():
	var topMeshSizeY : float = max(root.size.y - 4, 0)
	#Set bottom side
	bm_bottomMesh.mesh.size = Vector2(root.size.x, root.size.z)
	bm_bottomMesh.position = Vector3(0, 0, 0)
	bm_bottomMesh.material_override.uv1_scale = Vector3(root.size.x / 8, root.size.z / 8, 1)
	#Set front side
	bm_frontMesh.mesh.size = Vector2(root.size.x, topMeshSizeY)
	bm_frontMesh.position = Vector3(0, (root.size.y / 2) - 2, -root.size.z / 2)
	bm_frontMesh.material_override.uv1_scale = Vector3(root.size.x / 8, (root.size.y - 4) / 8, 1)
	#Set back side
	bm_backMesh.mesh.size = Vector2(root.size.x, topMeshSizeY)
	bm_backMesh.position = Vector3(0, (root.size.y / 2) - 2, root.size.z / 2)
	bm_backMesh.material_override.uv1_scale = Vector3(root.size.x / 8, (root.size.y - 4) / 8, 1)
	#Set left side
	bm_leftMesh.mesh.size = Vector2(root.size.z, topMeshSizeY)
	bm_leftMesh.position = Vector3(-root.size.x / 2, (root.size.y / 2) - 2, 0)
	bm_leftMesh.material_override.uv1_scale = Vector3(root.size.z / 8, (root.size.y - 4) / 8, 1)
	bm_leftMesh.material_override.uv1_offset = Vector3(-root.size.z / 8, 0, 0)
	#Set right side
	bm_rightMesh.mesh.size = Vector2(root.size.z, topMeshSizeY)
	bm_rightMesh.position = Vector3(root.size.x / 2, (root.size.y / 2) - 2, 0)
	bm_rightMesh.material_override.uv1_scale = Vector3(root.size.z / -8, (root.size.y - 4) / 8, 1)
	bm_rightMesh.material_override.uv1_offset = Vector3(root.size.z / 8, 0, 0)
