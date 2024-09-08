@tool
extends Node3D

#References
@onready var frame : PortalFrame = get_parent()
@onready var mesh : CSGBox3D = frame.get_node("Mesh")
@onready var meshCutout : CSGBox3D = mesh.get_node("Cutout")
@onready var clickArea_cs : CollisionShape3D = frame.get_node("ClickArea/CollisionShape")

var prevSize : float = 7


func _ready():
	if (not Engine.is_editor_hint()):
		queue_free()

