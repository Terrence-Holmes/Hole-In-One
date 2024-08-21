extends Node3D
class_name Portal

@export_category("Portal")
@export var otherPortal : Portal = null

#References
@onready var viewport : SubViewport = get_node("CameraViewport")
@onready var camera : Camera3D = viewport.get_node("Camera")
@onready var cameraView : Sprite3D = get_node("CameraView")


var camRotation : Vector3 = Vector3.ZERO

var _active : bool = false
var active : bool:
	set(value):
		_active = value
#		visible = value
	get:
		return _active



func _process(delta):
	_set_rotation()


func _set_rotation():
	if (GameManager.mainCameraRig != null):
		camera.rotation = camRotation + GameManager.mainCameraRig.camRotation + Vector3(0, rotation.y, 0)
