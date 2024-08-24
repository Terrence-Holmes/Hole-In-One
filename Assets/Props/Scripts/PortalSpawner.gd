extends Node3D


@export_category("Portal Spawner")
@export var portal1Wall : Node3D = null
@export var portal2Wall : Node3D = null

#References
@onready var portal1 : Portal = get_node("Portal1")
@onready var portal2 : Portal = get_node("Portal2")


func _ready():
	pass
#	set_portal(true, portal1Wall)
#	set_portal(false, portal2Wall)


func _process(delta):
	pass


func set_portal(primaryPortal : bool, wall : Node3D):
	var portalToSet : Portal = portal1 if (primaryPortal) else portal2
	var offset : Vector3 = Vector3(0, 0, 1) if (wall == portal1Wall) else Vector3(0, 0, 1)
	
	portalToSet.global_position = wall.global_position
	portalToSet.global_rotation = wall.global_rotation
	portalToSet.camera.global_position = wall.global_position + offset
	portalToSet.camRotation = wall.global_rotation + Vector3(0, PI, 0)
	portalToSet.active = true
