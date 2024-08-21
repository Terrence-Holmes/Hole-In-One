extends Node
class_name GolfBallInput

#References
@onready var root : GolfBall = get_parent()
@onready var cameraRig : CameraRig = root.get_node("CameraRig")

var mouseMoved : bool = false

var aimingShot : bool = false


func _process(delta):
	_manage_launch()
	_manage_shot_aim()
	_manage_camera_direction()

func _manage_launch():
	if (Input.is_action_just_pressed("LaunchBall")):
		root.launch()

func _manage_shot_aim():
	aimingShot = Input.is_action_pressed("PrepareAim")

func _manage_camera_direction():
	if (not mouseMoved or aimingShot):
		cameraRig.direction_input = Vector2.ZERO
	else:
		mouseMoved = false


func _input(event):
	if (event is InputEventMouseMotion and not aimingShot):
		cameraRig.direction_input = event.relative
		mouseMoved = true
