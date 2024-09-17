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
var prev_UVOffset : Vector2 = Vector2.ZERO

func _process(delta):
	_detectChange_size()
	_detectChange_UVOffset()


func _detectChange_size():
	if (prev_size != root.size):
		prev_size = root.size
		
		_set_top_mesh_size_and_pos()
		_set_top_mesh_uv()
		_set_bottom_mesh()

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
		#Set front side
		tm_frontMesh.mesh.size = Vector2(root.size.x, topMeshSizeY)
		tm_frontMesh.position = Vector3(0, topMeshPositionY, -root.size.z / 2)
		#Set back side
		tm_backMesh.mesh.size = Vector2(root.size.x, topMeshSizeY)
		tm_backMesh.position = Vector3(0, topMeshPositionY, root.size.z / 2)
		#Set left side
		tm_leftMesh.mesh.size = Vector2(root.size.z, topMeshSizeY)
		tm_leftMesh.position = Vector3(-root.size.x / 2, topMeshPositionY, 0)
		#Set right side
		tm_rightMesh.mesh.size = Vector2(root.size.z, topMeshSizeY)
		tm_rightMesh.position = Vector3(root.size.x / 2, topMeshPositionY, 0)

func _set_top_mesh_uv():
	var flipUVX : float = 1
	var topMeshUVY : float = min(root.size.y / 8, 0.5)
	
	#Set top side
	if (tm_topMesh != null):
		tm_topMesh.material_override.uv1_scale = Vector3(root.size.x / 8, root.size.z / 8, 1)
		tm_topMesh.material_override.uv1_offset = Vector3(root.UVOffset.x, root.UVOffset.y, 0)
	
	#(THIS IS A MESS!)
	
	#Set front side
	var uvY : float = 1 if ( (abs(fmod(root.UVOffset.y, 1)) < 0.5 and root.UVOffset.y >= 0)
	or (abs(fmod(root.UVOffset.y, 1)) >= 0.5) and root.UVOffset.y < 0 ) else 0.5
	tm_frontMesh.material_override.uv1_scale = Vector3(root.size.x / 8, topMeshUVY, 1)
	tm_frontMesh.material_override.uv1_offset = Vector3(root.UVOffset.x, uvY, 0)
	
	#Set back side
	flipUVX = 1 if (fmod(root.size.z / 8, 1) <= 0.5) else -1
	var uvPositionOffset : float = (0.125 * fmod(abs(root.size.z), 4)) * Math.PosOrNeg(root.UVOffset.y)
	var relativeUVY : float = (fmod(abs(root.UVOffset.y) + uvPositionOffset, 1)) #This is UVOffset.x relative to size.x % 4
	if ((relativeUVY <= 0.5 and relativeUVY != 0 and root.UVOffset.y >= 0)
	or (relativeUVY < 0.5 and relativeUVY != 0 and root.UVOffset.y < 0)):
		flipUVX *= -1
	if (not (root.UVOffset.y < -abs(uvPositionOffset))):
		flipUVX *= -1
	tm_backMesh.material_override.uv1_scale = Vector3((-root.size.x / 8) * flipUVX, topMeshUVY, 1)
	tm_backMesh.material_override.uv1_offset = Vector3((-root.UVOffset.x * flipUVX) , 0.5, 0)
	
	#Set left side
	uvY = 0.5 if ( (abs(fmod(root.UVOffset.x, 1)) < 0.5 and root.UVOffset.x >= 0)
	or (abs(fmod(root.UVOffset.x, 1)) >= 0.5) and root.UVOffset.x < 0 ) else 1
	tm_leftMesh.material_override.uv1_scale = Vector3(root.size.z / 8, topMeshUVY, 1)
	tm_leftMesh.material_override.uv1_offset = Vector3( -root.UVOffset.y + fmod(-root.size.z / 8, 1), uvY, 1)
	
	#Set right side
	flipUVX = 1 if (fmod(root.size.x / 8, 1) <= 0.5) else -1
	uvPositionOffset = (0.125 * fmod(abs(root.size.x), 4)) * Math.PosOrNeg(root.UVOffset.x)
	var relativeUVX : float = (fmod(abs(root.UVOffset.x) + uvPositionOffset, 1)) #This is UVOffset.x relative to size.x % 4
	if ((relativeUVX <= 0.5 and relativeUVX != 0 and root.UVOffset.x >= 0)
	or (relativeUVX < 0.5 and relativeUVX != 0 and root.UVOffset.x < 0)):
		flipUVX *= -1
	if (not (root.UVOffset.x < -abs(uvPositionOffset))):
		flipUVX *= -1
	tm_rightMesh.material_override.uv1_scale = Vector3((root.size.z / 8) * flipUVX, topMeshUVY, 1)
	tm_rightMesh.material_override.uv1_offset = Vector3((-root.UVOffset.y * flipUVX) + (fmod(-root.size.z / 8, 1) * flipUVX), 0.5, 1)

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
