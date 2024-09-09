extends Node
class_name GolfBallInput

#References
@onready var root : GolfBall = get_parent()
@onready var cameraRig : CameraRig = root.get_node("CameraRig")

var mouseMoved : bool = false
var cameraGrabbed : bool = false
var aiming : bool:
	get:
		return root.aiming
	set (value):
		root.aiming = value

#Mouse lock
var _mouseLocked : bool:
	get:
		return Input.mouse_mode == Input.MOUSE_MODE_CAPTURED


func _process(delta):
	_manage_launch()
	_manage_shot_aim()
	_manage_camera_movement()
	_manage_mouse_lock()

func _manage_launch():
	pass

func _manage_shot_aim():
	if (GameManager.preparingAim):
		aiming = (Input.is_action_pressed("PrepareAim") and not cameraGrabbed)
		if (not mouseMoved):
			root.aimInput = Vector2.ZERO
	else:
		aiming = false
		root.aimInput = Vector2.ZERO

func _manage_camera_movement():
	cameraGrabbed = (Input.is_action_pressed("GrabCamera") and not aiming)
	if (not mouseMoved):
		cameraRig.direction_input = Vector2.ZERO
	else:
		mouseMoved = false

func _manage_mouse_lock():
	if (not _mouseLocked and
	(aiming or cameraGrabbed)):
		lock_mouse()
	elif (_mouseLocked and 
	(not aiming and not cameraGrabbed)):
		unlock_mouse()


func _input(event):
	if (event is InputEventMouseMotion):
		if (_mouseLocked and not root.aiming):
			cameraRig.direction_input = event.relative
		elif (root.aiming):
			root.aimInput = event.relative
		mouseMoved = true



func lock_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func unlock_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
