extends StaticBody3D
class_name PortalFrame

@export_category("Portal Frame")
@export var frame1 : bool = true
@export var size : float = 7

#References
@onready var mesh : CSGBox3D = get_node("Mesh")
@onready var meshCutout : CSGBox3D = mesh.get_node("Cutout")
var portalSpawner : Node3D = null

var selected_mat : StandardMaterial3D = preload("res://Assets/Props/Materials/frameSelect_mat.tres")
var default_mat : StandardMaterial3D = preload("res://Assets/Props/Materials/frame0_mat.tres")
var portal1_mat : StandardMaterial3D = preload("res://Assets/Props/Materials/frame1_mat.tres")
var portal2_mat : StandardMaterial3D = preload("res://Assets/Props/Materials/frame2_mat.tres")


func _ready():
	portalSpawner = get_tree().current_scene.get_node_or_null("PortalSpawner")



func _process(delta):
	if (Input.is_action_just_pressed("Debug1")):
		if (frame1):
			set_portal(true)
		else:
			set_portal(false)
	if (Input.is_action_just_pressed("Debug2")):
		if (not frame1):
			set_portal(true)
		else:
			set_portal(false)

func set_portal(portal1 : bool):
	if (portalSpawner != null):
		var portalToSet : Node3D = portalSpawner.portal1 if (portal1) else portalSpawner.portal2
		
		#Set portal's transform
		portalToSet.global_transform = global_transform
		portalToSet.set_size(Vector2(size, size))
		portalToSet.global_position.y += (size / 2) + 0.5
		
		#Unset the old frame
		#if (portalToSet.frame != null):
			#portalToSet.frame.unset_portal()
		
		#Set new frame reference
		portalToSet.frame = self
		
		#Set frame color
		mesh.material = portal1_mat if (portal1) else portal2_mat
		meshCutout.material = portal1_mat if (portal1) else portal2_mat


func unset_portal():
	mesh.material = default_mat
	meshCutout.material = default_mat


func select_frame():
	mesh.material_override = selected_mat

func unselect_frame():
	print("wtf")
	mesh.material_override = null
