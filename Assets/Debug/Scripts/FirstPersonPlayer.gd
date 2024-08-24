extends CharacterBody3D

#References
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera : Camera3D = get_node_or_null("Camera")

#Vector directions
var forward : Vector3:
	get:
		return (-get_global_transform().basis.z)
var backward : Vector3:
	get:
		return (get_global_transform().basis.z)
var left : Vector3:
	get:
		return (-get_global_transform().basis.x)
var right : Vector3:
	get:
		return (get_global_transform().basis.x)
var up : Vector3:
	get:
		return (-get_global_transform().basis.y)
var down : Vector3:
	get:
		return (get_global_transform().basis.y)


#Velocity
var velocity_move : Vector3 = Vector3.ZERO
var velocity_gravity : float = 0

#Movement
var input_move : Vector2 = Vector2.ZERO
var targetMovement : Vector3 = Vector3.ZERO
var walkSpeed : float = 12
var crouchWalkSpeed : float = 5
var airMoveSpeed : float = 5
var jumpStrength : float = 20
var lastPosition : Vector3 = Vector3.ZERO

#Look
var input_look : Vector2 = Vector2.ZERO
var _mouseLocked : bool:
	get:
		return (get_node_or_null("Input") == null or get_node("Input")._mouseLocked)


var deltaTime : float = 0
func _physics_process(delta):
	deltaTime = delta
	if (_mouseLocked):
		#Walking
		_set_movement_velocity()
		_apply_movement()
		#Looking
		_apply_look()


func _set_movement_velocity():
	#Set target speed
	if (on_floor()):
		var movement : Vector2 = input_move * walkSpeed
		targetMovement = (-forward * movement.y) + (right * movement.x)
	else:
		var movement : Vector2 = input_move * airMoveSpeed * 0.1
		targetMovement += (-forward * movement.y) + (right * movement.x)
	
	#Normalize target speed
	if (targetMovement.length() > walkSpeed):
		targetMovement = targetMovement.normalized() * walkSpeed
	
	#Set velocity
	velocity_move = lerp(velocity_move, targetMovement, 0.1)

func _apply_movement():
	if not on_floor():
		velocity_gravity += gravity * deltaTime
	elif (velocity_gravity > 0):
		velocity_gravity = 0
	
	velocity = velocity_move - Vector3(0, velocity_gravity, 0)
	
#	lastPosition = global_position
	move_and_slide()

func _apply_look():
	rotation.y -= deg_to_rad(input_look.x)
	if (camera):
		camera.adjust_aim(-input_look.y)




#ACTIONS


func jump():
	if (on_floor()):
		velocity_gravity = -jumpStrength



#RETURNS

func on_floor() -> bool:
	return is_on_floor()
