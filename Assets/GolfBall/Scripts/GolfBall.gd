extends RigidBody3D
class_name GolfBall

#References
@onready var cameraRig : CameraRig = get_node("CameraRig")
@onready var aimLine : LineRenderer = get_node("AimLine")

var camRotation : Vector3:
	get:
		return cameraRig.camRotation
	set (value):
		cameraRig.camRotation = value

var launchPower : Vector2 = Vector2(1, 4)
var powerCharge : float = 1

#Aim
var aimSensitivity : float = 0.005
var aimLineLength : float = 7
var aimInput : Vector2 = Vector2.ZERO
var aiming : bool = false
var aimAngle : Vector2 = Vector2.ZERO
var aimDirection : Vector3 = Vector3(0, 0, 1)


func _process(delta):
	_aim()

func _aim():
	#Line visibility
	aimLine.visible = GameManager.preparingAim
	
	#Change aim direction
	if (aiming):
		#Set aim angle
		aimAngle.x += -aimInput.x * aimSensitivity
		aimAngle.y += -aimInput.y * aimSensitivity
		aimAngle.y = clampf(aimAngle.y, 0, (PI / 2) - 0.2)
		aimAngle.x = Math.ClampAngleRadians(aimAngle.x)
		
		#Set aim direction
		aimDirection = Vector3.FORWARD.rotated(Vector3.RIGHT, aimAngle.y)
		aimDirection = aimDirection.rotated(Vector3.UP, aimAngle.x)
		
		#Set line points
		aimLine.points[0] = global_position
		aimLine.points[1] = global_position + (aimDirection.normalized() * aimLineLength)


func launch():
	apply_central_impulse(aimDirection * 30)
