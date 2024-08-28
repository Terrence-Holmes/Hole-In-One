@tool
extends Node3D

#References
@onready var portal : Portal = get_parent()
@onready var cameraViewContainer : Node3D = portal.get_node("CameraViews")
@onready var passHitbox : Area3D = portal.get_node("PassHitbox")
@onready var passHitbox_cs : CollisionShape3D = passHitbox.get_node("CollisionShape")

var prevSize : Vector2 = Vector2.ZERO



func _process(delta):
	_set_size()


func _set_size():
	if (prevSize != portal.size):
		prevSize = portal.size
		#for cameraView in cameraViewContainer.get_children():
			#cameraView.size = Vector3(portal.size.x, portal.size.y, cameraView.size.z)
		passHitbox_cs.shape.size = Vector3(
			portal.size.x + portal.portal_area_margin.x * 2,
			portal.size.y + portal.portal_area_margin.y * 2,
			portal.portal_area_margin.z * 2,)
