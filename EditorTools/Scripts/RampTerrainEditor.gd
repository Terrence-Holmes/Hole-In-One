@tool
extends Node3D

@onready var root : Node3D = get_parent()
@onready var meshContainer : Node3D = root.get_node("Meshes")
@onready var topMesh : MeshInstance3D = meshContainer.get_node("TopMesh")

var prev_rampHeight : float = 1
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


func _detectChange_size():
	if (prev_size != root.size):
		prev_size = root.size


func _detectChange_rampHeight():
	if (prev_rampHeight != root.rampHeight):
		root.rampHeight = max(root.rampHeight, 0)
		prev_rampHeight = root.rampHeight
		
		topMesh.material_override.set("shader_param/rampHeight", root.rampHeight)
		_set_ramp_uv()

func _detectChange_rampOffset():
	if (prev_rampOffset != root.rampOffset):
		root.rampOffset = clampf(root.rampOffset, -1, 1)
		prev_rampOffset = root.rampOffset
		print("?")
		topMesh.material_override.set("shader_param/rampOffset", root.rampOffset * 0.5)


func _detectChange_UVOffset():
	if (prev_UVOffset != root.UVOffset):
		root.UVOffset.x = clampf(root.UVOffset.x, -1, 1)
		root.UVOffset.y = clampf(root.UVOffset.y, -1, 1)
		prev_UVOffset = root.UVOffset
		_set_ramp_uv()


func _set_ramp_uv():
	var rampLength : float = Vector2(root.rampOffset, root.rampHeight).distance_to(Vector2(0.5, 0))
	var uvScale : Vector2 = Vector2(1, rampLength)
	var uvOffset : Vector2 = Vector2(root.UVOffset.x, root.UVOffset.y / rampLength)
	topMesh.material_override.set("shader_param/UVScale", uvScale)
	topMesh.material_override.set("shader_param/UVOffset", uvOffset)
