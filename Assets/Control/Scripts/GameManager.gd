extends Node


var mainCameraRig : Node3D = null
var mainCamera : Camera3D = null

#Portal shots
var cameraRay : CameraRay = null
var selectedFrame : PortalFrame = null

var portalBodies : Array[Node3D] = []


func _process(delta):
	_detect_portal_shots()


func _detect_portal_shots():
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
	if (selectedFrame != null):
		if (Input.is_action_just_pressed("Portal1")):
			selectedFrame.set_portal(true)
		elif (Input.is_action_just_pressed("Portal2")):
			selectedFrame.set_portal(false)
