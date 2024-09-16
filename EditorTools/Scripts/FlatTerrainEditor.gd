@tool
extends Node3D

#References
@onready var root : TerrainPiece = get_parent()
@onready var collisionShape : CollisionShape3D = root.get_node("Body/CollisionShape")
#Mesh references
@onready var meshContainer : Node3D = root.get_node("Meshes")
#Top mesh references
@onready var topMeshContainer : Node3D = meshContainer.get_node("TopMeshes")
@onready var tm_topMesh : MeshInstance3D = topMeshContainer.get_node("TopMesh")
@onready var tm_frontMesh : MeshInstance3D = topMeshContainer.get_node("FrontMesh")
@onready var tm_backMesh : MeshInstance3D = topMeshContainer.get_node("BackMesh")
@onready var tm_leftMesh : MeshInstance3D = topMeshContainer.get_node("LeftMesh")
@onready var tm_rightMesh : MeshInstance3D = topMeshContainer.get_node("RightMesh")

#Bottom mesh references
@onready var bottomMeshContainer : Node3D = meshContainer.get_node("BottomMeshes")

var prev_size : Vector3 = Vector3(8, 8, 8)
var prev_UVOffset : Vector2 = Vector2.ZERO


func _ready():
	if (not Engine.is_editor_hint()):
		queue_free()

func _process(delta):
	_detectChange_size()
	_detectChange_UVOffset()


func _detectChange_size():
	if (prev_size != root.size):
		prev_size = root.size
		
		_set_top_mesh_size()
		_set_top_mesh_uv()

func _set_top_mesh_size():
		var topMeshSizeY : float = min(root.size.y, 4)
		var topMeshPositionY : float = max(root.size.y - 2, root.size.y / 2)
		#Set top side
		tm_topMesh.mesh.size = Vector2(root.size.x, root.size.z)
		tm_topMesh.position.y = root.size.y
		#Set front side
		tm_frontMesh.mesh.size = Vector2(root.size.x, topMeshSizeY)
		tm_frontMesh.position.y = topMeshPositionY
		tm_frontMesh.position.z = -root.size.z / 2
		#Set back side
		tm_backMesh.mesh.size = Vector2(root.size.x, topMeshSizeY)
		tm_backMesh.position.y = topMeshPositionY
		tm_backMesh.position.z = root.size.z / 2
		#Set left side
		tm_leftMesh.mesh.size = Vector2(root.size.z, topMeshSizeY)
		tm_leftMesh.position.y = topMeshPositionY
		tm_leftMesh.position.x = -root.size.x / 2
		#Set right side
		tm_rightMesh.mesh.size = Vector2(root.size.z, topMeshSizeY)
		tm_rightMesh.position.y = topMeshPositionY
		tm_rightMesh.position.x = root.size.x / 2

func _set_top_mesh_uv():
	var flipUVX : float = 1
	var topMeshUVY : float = min(root.size.y / 8, 0.5)
	
	#Set top side
	tm_topMesh.material_override.uv1_scale = Vector3(root.size.x / 8, root.size.z / 8, 1)
	tm_topMesh.material_override.uv1_offset = Vector3(root.UVOffset.x, root.UVOffset.y, 0)
	#Set front side
	tm_frontMesh.material_override.uv1_scale = Vector3(root.size.x / 8, topMeshUVY, 1)
	tm_frontMesh.material_override.uv1_offset = Vector3(root.UVOffset.x, 0, 0)
	#Set back side
	flipUVX = 1 if (fmod(root.size.z / 8, 1) <= 0.5) else -1
	tm_backMesh.material_override.uv1_scale = Vector3((-root.size.x / 8) * flipUVX, topMeshUVY, 1)
	tm_backMesh.material_override.uv1_offset = Vector3(-root.UVOffset.x * flipUVX, 0, 0)
	#Set left side
	tm_leftMesh.material_override.uv1_scale = Vector3(root.size.z / 8, topMeshUVY, 1)
	tm_leftMesh.material_override.uv1_offset = Vector3(fmod(-root.size.z / 8, 1), 0.5, 1)
	tm_leftMesh.material_override.uv1_offset = Vector3(-0.5 - root.UVOffset.y, 0, 0)
	#Set right side
	flipUVX = 1 if (fmod(root.size.x / 8, 1) <= 0.5) else -1
	print( fmod(abs(root.UVOffset.x), 0.5) )
	var uvNegativeAdd : float = 0 if (root.UVOffset.x >= 0) else 0.5
	flipUVX = flipUVX * -1 if ( fmod(abs(root.UVOffset.x) + uvNegativeAdd, 1) < 0.5 ) else flipUVX
	tm_rightMesh.material_override.uv1_scale = Vector3((root.size.z / 8) * flipUVX, topMeshUVY, 1)
	tm_rightMesh.material_override.uv1_offset = Vector3((-root.UVOffset.y * flipUVX) + (fmod(-root.size.z / 8, 1) * flipUVX), 0.5, 1)

func _detectChange_UVOffset():
	if (prev_UVOffset != root.UVOffset):
		root.UVOffset.x = clampf(root.UVOffset.x, -0.999, 0.999)
		root.UVOffset.y = clampf(root.UVOffset.y, -0.999, 0.999)
		prev_UVOffset = root.UVOffset
		_set_top_mesh_uv()
