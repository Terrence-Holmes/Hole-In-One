@tool
extends Node3D

#References
@onready var frame : PortalFrame = get_parent()
@onready var mesh : CSGBox3D = frame.get_node("Mesh")
@onready var meshCutout : CSGBox3D = mesh.get_node("Cutout")
@onready var clickArea_cs : CollisionShape3D = frame.get_node("ClickArea/CollisionShape")

var prevSize : float = 7



func _process(delta):
	_set_size()


func _set_size():
	if (prevSize != frame.size):
		prevSize = frame.size
		
		#Resize frame
		mesh.size = Vector3(frame.size + 1, frame.size + 1, 0.5)
		meshCutout.size = Vector3(frame.size, frame.size, 1)
		
		#Resize click area
		clickArea_cs.shape.size = Vector3(frame.size + 1, frame.size + 1, 0.5)
