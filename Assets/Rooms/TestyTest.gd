extends HBoxContainer

@export var sourcePortal : Portal = null
@export var sourceCamera : Array[Camera3D] = []
@export var translateCamera : Array[Camera3D] = []


func _process(delta):
	for i in range(sourceCamera.size()):
		translateCamera[i].global_transform = sourceCamera[i].global_transform
		sourcePortal._update_portal_camera_near_clip_plane(translateCamera[i])
