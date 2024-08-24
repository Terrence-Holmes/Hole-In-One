extends Node3D

@onready var root : Node3D = get_parent()
@onready var camera : Camera3D = root.get_node("Camera")

func _ready():
	GameManager.mainCameraRig = self


var camRotation : Vector3 = Vector3.ZERO
func _process(delta):
	rotation = root.rotation
	rotation.x = camera.rotation.x
	camRotation = rotation
