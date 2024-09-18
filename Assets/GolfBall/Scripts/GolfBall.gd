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

var speed : float:
	get:
		return linear_velocity.length()

#Stopping
const minimumSpeed : float = 0.2 #The minimum speed that the ball can travel before stopping
var stopTimer : Timer = Timer.new()
var stopCount : float = 0 #How long you've been stopped
var stopDurationToEnd : float = 0.5 #How long you need to be stopped for your turn to end

#Launch
const launchPower : Vector2 = Vector2(1, 100)
const chargeSpeed : float = 1
var chargeInput : bool = false
var powerCharge : float = -1

#Aim
var aimSensitivity : float = 0.005
const aimLineLength : float = 7
var aimInput : Vector2 = Vector2.ZERO
var aiming : bool = false
var aimAngle : Vector2 = Vector2.ZERO
var aimDirection : Vector3 = Vector3.ZERO


func _ready():
	add_child(stopTimer)
	stopTimer.wait_time = 0.5
	stopTimer.connect("timeout", _end_launch)
	stopTimer.one_shot = true

func _process(delta):
	_aim()
	_charge()
	_prepare_to_stop()
	

func _aim():
	#Line visibility
	aimLine.visible = (GameManager.ballStatus == GameManager.BallStatus.AIMING and aimDirection != Vector3.ZERO)
	
	#Change aim direction
	if (aiming):
		#Set aim forward
		if (aimDirection == Vector3.ZERO):
			aimDirection = Vector3.FORWARD
			aimAngle.x = cameraRig.rotation.y
		
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
	elif (GameManager.ballStatus != GameManager.BallStatus.AIMING):
		aimDirection = Vector3.ZERO

func _charge():
	#Charge hit
	if (chargeInput and GameManager.ballStatus == GameManager.BallStatus.AIMING):
		#Set charge to available
		if (powerCharge == -1):
			powerCharge = 0
		#Increase charge
		powerCharge += chargeSpeed * get_process_delta_time()
		#Loop charge fill
		if (powerCharge > 1):
			powerCharge = 0
		UIManager.charge_changed.invoke(powerCharge)
		
	#Apply hit
	else:
		if (GameManager.ballStatus == GameManager.BallStatus.AIMING and powerCharge > -1):
			#Launch
			launch()
		#Set charge to unavailable
		powerCharge = -1

func _prepare_to_stop():
	if (speed < minimumSpeed and GameManager.ballStatus == GameManager.BallStatus.MOVING):
		stopCount += get_process_delta_time()
		if (stopCount >= stopDurationToEnd):
			#Stop movement
			linear_velocity = Vector3.ZERO
			freeze = true
			#Re-enable turn
			GameManager.ballStatus = GameManager.BallStatus.PORTAL1
	else:
		stopCount = 0

func launch():
	freeze = false
	apply_central_impulse(aimDirection * lerpf(launchPower.x, launchPower.y, powerCharge))
	GameManager.ballStatus = GameManager.BallStatus.LAUNCHING
	stopTimer.start()
func _end_launch():
	GameManager.ballStatus = GameManager.BallStatus.MOVING
