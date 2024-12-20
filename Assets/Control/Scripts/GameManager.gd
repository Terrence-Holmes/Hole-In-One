extends Node

enum BallStatus { PORTAL1, PORTAL2, AIMING, LAUNCHING, MOVING, INACTIVE }

var mainCameraRig : Node3D = null
var mainCamera : Camera3D = null

var preparingAim : bool = false

#Portal shots
var ballStatus : BallStatus = BallStatus.PORTAL1
var cameraRay : CameraRay = null
var selectedFrame : PortalFrame = null

#Mouse lock
var mouseLocked : bool:
	get:
		return Input.mouse_mode == Input.MOUSE_MODE_CAPTURED


func _process(delta):
	_detect_portal_shots()


func _detect_portal_shots():
	if ((ballStatus == BallStatus.PORTAL1 or ballStatus == BallStatus.PORTAL2) and not mouseLocked):
		#Get selected frame
		if (cameraRay != null and cameraRay.resultCollider != null):
			if (cameraRay.resultCollider != null and selectedFrame != cameraRay.resultCollider.get_parent()):
				if (selectedFrame != null):
					selectedFrame.unselect_frame()
				selectedFrame = cameraRay.resultCollider.get_parent()
				selectedFrame.select_frame()
		#Disable selected frame
		elif (selectedFrame != null):
			selectedFrame.unselect_frame()
			selectedFrame = null
		
		#Check for shots
		if (selectedFrame != null and Input.is_action_just_pressed("Portal")):
			if (ballStatus == BallStatus.PORTAL1):
				selectedFrame.set_portal(true)
				ballStatus = BallStatus.PORTAL2
			elif (ballStatus == BallStatus.PORTAL2):
				selectedFrame.set_portal(false)
				ballStatus = BallStatus.PORTAL1
	elif (selectedFrame != null):
		selectedFrame.unselect_frame()
