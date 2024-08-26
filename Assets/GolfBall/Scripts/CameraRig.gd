extends Node3D
class_name CameraRig

#References
@onready var root : Node3D = get_parent()
@onready var camera : Camera3D = get_node("Camera")

var height : float = 4
var distance : float = 12

var sensitivity : float = 8

var direction_input : Vector2 = Vector2.ZERO

var camRotation : Vector3 = Vector3.ZERO


func _ready():
	GameManager.mainCameraRig = self
	GameManager.mainCamera = camera
	
	camera.position.y = height
	camera.position.z = distance

var lateReady : bool = false
func _late_ready():
	lateReady = true
	var newParent = get_parent().get_parent()
	get_parent().remove_child(self)
	newParent.add_child(self)

func _process(delta):
	if (not lateReady):
		_late_ready()
	_input_rotation()
	_apply_rotation()
	_set_position()


func _input_rotation():
	if (direction_input != Vector2.ZERO):
		camRotation.y += -direction_input.x * sensitivity * 0.0005
		camRotation.x += -direction_input.y * sensitivity * 0.0005

func _apply_rotation():
	global_rotation = camRotation


func _set_position():
	if (root):
		global_position = root.global_position
