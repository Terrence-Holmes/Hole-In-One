extends Node


#References
@onready var body : CharacterBody3D = get_parent()


var lookSensitivity : float = 2.5
var look : Vector2 = Vector2.ZERO
var lastLook : Vector2 = Vector2.ZERO

#Mouse lock
var _mouseLocked : bool:
	get:
		return Input.mouse_mode == Input.MOUSE_MODE_CAPTURED

func _ready():
	lock_mouse()

func _process(delta):
	_input_mouseLock()
	_input_movement()
	_input_look()
	_input_jump()

func _input_mouseLock():
	if (Input.is_action_just_pressed("Pause")):
		if (_mouseLocked):
			unlock_mouse()
		else:
			lock_mouse()

func _input_movement():
	#Get input vector2
	var input : Vector2 = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"))
	
	#Pass input onto player movement
	body.input_move = input


func _input_look():
	#The mouse was moved this frame
	if (lastLook != look):
		lastLook = look
	#The mouse has not moved this frame
	elif (look != Vector2.ZERO):
		look = Vector2.ZERO
		lastLook = Vector2.ZERO
	body.input_look = look * lookSensitivity * 0.1

func _input_jump():
	if (Input.is_action_just_pressed("Select")):
		body.jump()




func _input(event):
	if event is InputEventMouseMotion:
		look = event.relative


func lock_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func unlock_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
