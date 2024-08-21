extends Node3D
class_name CameraRig

#References
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



func _process(delta):
	_input_rotation()
	_apply_rotation()


func _input_rotation():
	if (direction_input != Vector2.ZERO):
		camRotation.y += -direction_input.x * sensitivity * 0.0005
		camRotation.x += -direction_input.y * sensitivity * 0.0005
#		camRotation.x = clampf(rotation.x, deg_to_rad(-50), deg_to_rad(20))

func _apply_rotation():
	global_rotation = camRotation
