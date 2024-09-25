@tool
extends Node3D

@onready var root : TerrainRamp = get_parent()
@onready var meshContainer : Node3D = root.get_node("Meshes")
@onready var topMesh : MeshInstance3D = meshContainer.get_node("TopMesh")
@onready var rightMesh : MeshInstance3D = meshContainer.get_node("RightMesh")
@onready var leftMesh : MeshInstance3D = meshContainer.get_node("LeftMesh")
@onready var backMesh : MeshInstance3D = meshContainer.get_node("BackMesh")
@onready var frontMesh : MeshInstance3D = meshContainer.get_node("FrontMesh")

var prev_rampHeight : float = 1
var prev_rampHeightPoints : Array[float] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var prev_rampOffset : float = 0
var prev_UVOffset : Vector2 = Vector2.ZERO
var prev_size : Vector3 = Vector3(8, 8, 8)

func _ready():
	pass



func _process(delta):
	_detectChange_size()
	_detectChange_rampHeight()
	_detectChange_rampOffset()
	_detectChange_UVOffset()
	
	var sizeUVOffset : Vector2 = -Vector2(fmod(root.size.x, 16) / root.size.x, fmod(root.size.z, 16) / root.size.z) * 0.5
	#frontMesh.material_override.set("shader_param/UVOffset", sizeUVOffset)
	#backMesh.material_override.set("shader_param/UVOffset", sizeUVOffset)


func _detectChange_size():
	if (prev_size != root.size):
		prev_size = root.size


func _detectChange_rampHeight():
	if (prev_rampHeight != root.rampHeight):
		root.rampHeight = max(root.rampHeight, 0)
		prev_rampHeight = root.rampHeight
		
		#frontMesh.material_override.set("shader_param/rampHeight", root.rampHeight)
		#backMesh.material_override.set("shader_param/rampHeight", root.rampHeight)
		rightMesh.material_override.set("shader_param/rampHeight", root.rampHeight)
		leftMesh.material_override.set("shader_param/rampHeight", root.rampHeight)
		
		_update_vertices()
	
	if (prev_rampHeightPoints != root.rampHeightPoints):
		prev_rampHeightPoints = root.rampHeightPoints
		_update_vertices()

func _detectChange_rampOffset():
	if (prev_rampOffset != root.rampOffset):
		root.rampOffset = clampf(root.rampOffset, -1, 1)
		prev_rampOffset = root.rampOffset
		#frontMesh.material_override.set("shader_param/rampOffset", root.rampOffset)
		#backMesh.material_override.set("shader_param/rampOffset", root.rampOffset)
		rightMesh.material_override.set("shader_param/rampOffset", root.rampOffset)
		leftMesh.material_override.set("shader_param/rampOffset", root.rampOffset)
		_update_vertices()


func _detectChange_UVOffset():
	if (prev_UVOffset != root.UVOffset):
		root.UVOffset.x = clampf(root.UVOffset.x, -1, 1)
		root.UVOffset.y = clampf(root.UVOffset.y, -1, 1)
		prev_UVOffset = root.UVOffset
		_update_top_uv()

func _update_vertices():
	_update_top_vertices()
	_update_side_vertices()

func _update_top_uv():
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(topMesh.mesh, 0)
	
	##############################
	#### Z+, X+
	## Tri+
	mdt.set_vertex_uv(0, Vector2(0.5, 1))
	mdt.set_vertex_uv(1, Vector2(0, 0.5))
	mdt.set_vertex_uv(2, Vector2(0, 1))
	## Tri-
	mdt.set_vertex_uv(3, Vector2(0.5, 0.5))
	mdt.set_vertex_uv(4, Vector2(0, 0.5))
	mdt.set_vertex_uv(5, Vector2(0.5, 1))
	#### Z+, X-
	## Tri+
	mdt.set_vertex_uv(6, Vector2(1, 1))
	mdt.set_vertex_uv(7, Vector2(0.5, 0.5))
	mdt.set_vertex_uv(8, Vector2(0.5, 1))
	## Tri-
	mdt.set_vertex_uv(9, Vector2(1, 0.5))
	mdt.set_vertex_uv(10, Vector2(0.5, 0.5))
	mdt.set_vertex_uv(11, Vector2(1, 1))
	#### Z-, X+
	## Tri+
	mdt.set_vertex_uv(12, Vector2(0.5, 0.5))
	mdt.set_vertex_uv(13, Vector2(0, 0))
	mdt.set_vertex_uv(14, Vector2(0, 0.5))
	## Tri-
	mdt.set_vertex_uv(15, Vector2(0.5, 0))
	mdt.set_vertex_uv(16, Vector2(0, 0))
	mdt.set_vertex_uv(17, Vector2(0.5, 0.5))
	#### Z-, X-
	## Tri+
	mdt.set_vertex_uv(18, Vector2(1, 0.5))
	mdt.set_vertex_uv(19, Vector2(0.5, 0))
	mdt.set_vertex_uv(20, Vector2(0.5, 0.5))
	## Tri-
	mdt.set_vertex_uv(21, Vector2(1, 0))
	mdt.set_vertex_uv(22, Vector2(0.5, 0))
	mdt.set_vertex_uv(23, Vector2(1, 0.5))
	##############################
	#Fix the normals
	for i in range(mdt.get_vertex_count()):
		mdt.set_vertex_normal(i, Vector3.UP)
		#if (i % 3 == 2):
			#var dir : Vector3 = \
			#(mdt.get_vertex(i) - mdt.get_vertex(i - 2)).cross(mdt.get_vertex(i - 1) - mdt.get_vertex(i - 2))
			#var normal : Vector3 = dir.normalized()
			#mdt.set_vertex_normal(i, normal)
			#mdt.set_vertex_normal(i - 1, normal)
			#mdt.set_vertex_normal(i - 2, normal)
	
	topMesh.mesh.clear_surfaces()
	mdt.commit_to_surface(topMesh.mesh)


func _update_top_vertices():
	var t_size : Vector2 = Vector2(4, 4)
	var t_height : Array[float] = root.rampHeightPoints
	
	#Set top mesh
	var vertices = PackedVector3Array()
	
	#### Z+, X+
	## Tri+
	vertices.push_back(Vector3(0, t_height[1], t_size.y)) #0
	vertices.push_back(Vector3(t_size.x, t_height[3], 0)) #1
	vertices.push_back(Vector3(t_size.x, t_height[0], t_size.y)) #2
	## Tri-
	vertices.push_back(Vector3(0, t_height[4], 0)) #3
	vertices.push_back(Vector3(t_size.x, t_height[3], 0)) #4
	vertices.push_back(Vector3(0, t_height[1], t_size.y)) #5
	#### Z+, X-
	## Tri+
	vertices.push_back(Vector3(-t_size.x, t_height[2], t_size.y)) #6
	vertices.push_back(Vector3(0, t_height[4], 0)) #7
	vertices.push_back(Vector3(0, t_height[1], t_size.y)) #8
	## Tri-
	vertices.push_back(Vector3(-t_size.x, t_height[5], 0)) #9
	vertices.push_back(Vector3(0, t_height[4], 0)) #10
	vertices.push_back(Vector3(-t_size.x, t_height[2], t_size.y)) #11
	#### Z-, X+
	## Tri+
	vertices.push_back(Vector3(0, t_height[4], 0)) #12
	vertices.push_back(Vector3(t_size.x, t_height[6], -t_size.y)) #13
	vertices.push_back(Vector3(t_size.x, t_height[3], 0)) #14
	## Tri-
	vertices.push_back(Vector3(0, t_height[7], -t_size.y)) #15
	vertices.push_back(Vector3(t_size.x, t_height[6], -t_size.y)) #16
	vertices.push_back(Vector3(0, t_height[4], 0)) #17
	#### Z-, X-
	## Tri+
	vertices.push_back(Vector3(-t_size.x, t_height[5], 0)) #18
	vertices.push_back(Vector3(0, t_height[7], -t_size.y)) #19
	vertices.push_back(Vector3(0, t_height[4], 0)) #20
	## Tri-
	vertices.push_back(Vector3(-t_size.x, t_height[8], -t_size.y)) #21
	vertices.push_back(Vector3(0, t_height[7], -t_size.y)) #22
	vertices.push_back(Vector3(-t_size.x, t_height[5], 0)) #23
	
	
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	topMesh.mesh = arr_mesh
	
	_update_top_uv()


func _update_side_vertices():
	var t_size : Vector2 = Vector2(4, 4)
	var t_height : Array[float] = root.rampHeightPoints
	
	#Set top mesh
	var mdt = MeshDataTool.new()
	
	
	#################### RIGHT
	var vertices = PackedVector3Array()
	#### Z+
	## Z+
	vertices.push_back(Vector3(0, t_height[3], 0)) #0
	vertices.push_back(Vector3(0, 0, t_size.y)) #1
	vertices.push_back(Vector3(0, t_height[0], t_size.y)) #2
	## Z-
	vertices.push_back(Vector3(0, 0, 0)) #3
	vertices.push_back(Vector3(0, 0, t_size.y)) #4
	vertices.push_back(Vector3(0, t_height[3], 0)) #5
	##### Z-
	## Z+
	vertices.push_back(Vector3(0, t_height[6], -t_size.y)) #6
	vertices.push_back(Vector3(0, 0, 0)) #7
	vertices.push_back(Vector3(0, t_height[3], 0)) #8
	## Z-
	vertices.push_back(Vector3(0, 0, -t_size.y)) #9
	vertices.push_back(Vector3(0, 0, 0)) #10
	vertices.push_back(Vector3(0, t_height[6], -t_size.y)) #11
	
	# Initialize the ArrayMesh.
	var arr_mesh_R = ArrayMesh.new()
	var arrays_R = []
	arrays_R.resize(Mesh.ARRAY_MAX)
	arrays_R[Mesh.ARRAY_VERTEX] = vertices
	# Create the Mesh.
	arr_mesh_R.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays_R)
	rightMesh.mesh = arr_mesh_R
	
	
	#################### LEFT
	vertices.clear()
	#### Z-
	## Z-
	vertices.push_back(Vector3(0, t_height[5], 0)) #0
	vertices.push_back(Vector3(0, 0, -t_size.y)) #1
	vertices.push_back(Vector3(0, t_height[8], -t_size.y)) #2
	## Z+
	vertices.push_back(Vector3(0, 0, 0)) #3
	vertices.push_back(Vector3(0, 0, -t_size.y)) #4
	vertices.push_back(Vector3(0, t_height[5], 0)) #5
	##### Z+
	## Z-
	vertices.push_back(Vector3(0, t_height[2], t_size.y)) #6
	vertices.push_back(Vector3(0, 0, 0)) #7
	vertices.push_back(Vector3(0, t_height[5], 0)) #8
	## Z+
	vertices.push_back(Vector3(0, 0, t_size.y)) #9
	vertices.push_back(Vector3(0, 0, 0)) #10
	vertices.push_back(Vector3(0, t_height[2], t_size.y)) #11
	
	#Initialize the ArrayMesh
	var arr_mesh_L = ArrayMesh.new()
	var arrays_L = []
	arrays_L.resize(Mesh.ARRAY_MAX)
	arrays_L[Mesh.ARRAY_VERTEX] = vertices
	# Create the Mesh.
	arr_mesh_L.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays_L)
	leftMesh.mesh = arr_mesh_L
	
	
	#################### BACK
	vertices.clear()
	#### X-
	## X-
	vertices.push_back(Vector3(0, t_height[1], 0)) #0
	vertices.push_back(Vector3(-t_size.x, 0, 0)) #1
	vertices.push_back(Vector3(-t_size.x, t_height[2], 0)) #2
	## X+
	vertices.push_back(Vector3(0, 0, 0)) #3
	vertices.push_back(Vector3(-t_size.x, 0, 0)) #4
	vertices.push_back(Vector3(0, t_height[1], 0)) #5
	##### X+
	## X-
	vertices.push_back(Vector3(t_size.x, t_height[0], 0)) #6
	vertices.push_back(Vector3(0, 0, 0)) #7
	vertices.push_back(Vector3(0, t_height[1], 0)) #8
	## X+
	vertices.push_back(Vector3(t_size.x, 0, 0)) #9
	vertices.push_back(Vector3(0, 0, 0)) #10
	vertices.push_back(Vector3(t_size.x, t_height[0], 0)) #11
	
	#Initialize the ArrayMesh
	var arr_mesh_B = ArrayMesh.new()
	var arrays_B = []
	arrays_B.resize(Mesh.ARRAY_MAX)
	arrays_B[Mesh.ARRAY_VERTEX] = vertices
	# Create the Mesh.
	arr_mesh_B.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays_B)
	backMesh.mesh = arr_mesh_B
	
	
	#################### FRONT
	vertices.clear()
	#### X+
	## X+
	vertices.push_back(Vector3(0, t_height[7], 0)) #0
	vertices.push_back(Vector3(t_size.x, 0, 0)) #1
	vertices.push_back(Vector3(t_size.x, t_height[6], 0)) #2
	## X-
	vertices.push_back(Vector3(0, 0, 0)) #3
	vertices.push_back(Vector3(t_size.x, 0, 0)) #4
	vertices.push_back(Vector3(0, t_height[7], 0)) #5
	##### X-
	## X+
	vertices.push_back(Vector3(-t_size.x, t_height[8], 0)) #6
	vertices.push_back(Vector3(0, 0, 0)) #7
	vertices.push_back(Vector3(0, t_height[7], 0)) #8
	## X-
	vertices.push_back(Vector3(-t_size.x, 0, 0)) #9
	vertices.push_back(Vector3(0, 0, 0)) #10
	vertices.push_back(Vector3(-t_size.x, t_height[8], 0)) #11
	
	#Initialize the ArrayMesh
	var arr_mesh_F = ArrayMesh.new()
	var arrays_F = []
	arrays_F.resize(Mesh.ARRAY_MAX)
	arrays_F[Mesh.ARRAY_VERTEX] = vertices
	# Create the Mesh.
	arr_mesh_F.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays_F)
	frontMesh.mesh = arr_mesh_F
	
	_update_side_uv()


func _update_side_uv():
	var t_height : Array[float] = root.rampHeightPoints
	
	var meshes : Array[Mesh] = [rightMesh.mesh, leftMesh.mesh, frontMesh.mesh, backMesh.mesh]
	for mesh in meshes:
		
		#Get x UV shift
		var xShift : float = 4 if (mesh == rightMesh.mesh or mesh == backMesh.mesh) else 0
		
		#Get mesh
		var mdt = MeshDataTool.new()
		mdt.create_from_surface(mesh, 0)
		
		#### Left square
		#Get the highest vertex point
		var pointA : float = mdt.get_vertex(2).y
		var pointB : float = mdt.get_vertex(5).y
		var uvA : float = lerpf(0, 0.5, pointA / max(max(pointA, pointB), 4))
		var uvB : float = lerpf(0, 0.5, pointB / max(max(pointA, pointB), 4))
		## Left tri
		mdt.set_vertex_uv(0, Vector2(4 + xShift, uvB * 4))
		mdt.set_vertex_uv(1, Vector2(xShift, 0))
		mdt.set_vertex_uv(2, Vector2(xShift, uvA * 4))
		## Right tri
		mdt.set_vertex_uv(3, Vector2(4 + xShift, 0))
		mdt.set_vertex_uv(4, Vector2(xShift, 0))
		mdt.set_vertex_uv(5, Vector2(4 + xShift, uvB * 4))
		#### Right square
		#Get the highest vertex point
		pointA = mdt.get_vertex(8).y
		pointB = mdt.get_vertex(11).y
		uvA = lerpf(0, 0.5, pointA / max(max(pointA, pointB), 4))
		uvB = lerpf(0, 0.5, pointB / max(max(pointA, pointB), 4))
		## Left tri
		mdt.set_vertex_uv(6, Vector2(8 + xShift, uvB * 4))
		mdt.set_vertex_uv(7, Vector2(4 + xShift, 0))
		mdt.set_vertex_uv(8, Vector2(4 + xShift, uvA * 4))
		## Right tri
		mdt.set_vertex_uv(9, Vector2(8 + xShift, 0))
		mdt.set_vertex_uv(10, Vector2(4 + xShift, 0))
		mdt.set_vertex_uv(11, Vector2(8 + xShift, uvB * 4))
		
		#Apply new UV's to the mesh
		mesh.clear_surfaces()
		mdt.commit_to_surface(mesh)


































