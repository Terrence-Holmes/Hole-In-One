@tool
extends MeshInstance3D

@export var root : Node3D
@export var generate : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (generate):
		generate = false
		var mdt = MeshDataTool.new()
		mdt.create_from_surface(mesh, 0)
		print(root.rampHeight)
		mdt.set_vertex(1, Vector3(0, root.rampHeight, 0))
		mesh.clear_surfaces()
		mdt.commit_to_surface(mesh)
	
	#if (generate):
		#generate = false
		#var vertices = PackedVector3Array()
		#vertices.push_back(Vector3(0, 0, 4))
		#vertices.push_back(Vector3(0, 4, 0))
		#vertices.push_back(Vector3(0, 0, -4))
#
		## Initialize the ArrayMesh.
		#var arr_mesh = ArrayMesh.new()
		#var arrays = []
		#arrays.resize(Mesh.ARRAY_MAX)
		#arrays[Mesh.ARRAY_VERTEX] = vertices
#
		## Create the Mesh.
		#arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		#mesh = arr_mesh
