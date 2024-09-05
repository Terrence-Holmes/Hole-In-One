extends Node3D
class_name CameraRay


@export_category("Camera Raycast")
@export var camera : Camera3D = null
@export var rayLength : float = 100
@export_flags_3d_physics var collisionMask : int = 1
@export var collideWithAreas : bool = true
@export var collideWithBodies : bool = true


var resultPosition : Vector3:
	get:
		return get_results()["position"]

var resultCollider : Node:
	get:
		return get_results()["collider"]


func _ready():
	GameManager.cameraRay = self

func get_results() -> Dictionary:
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var ray_length : float = rayLength
	var ray_origin : Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_end : Vector3 = ray_origin + camera.project_ray_normal(mouse_pos) * ray_length
	var space : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_query.from = ray_origin
	ray_query.to = ray_end
	ray_query.collision_mask = collisionMask
	ray_query.collide_with_areas = collideWithAreas
	ray_query.collide_with_bodies = collideWithBodies
	var result : Dictionary = space.intersect_ray(ray_query)
	
	if (result.is_empty()):
		result["collider"] = null
		result["position"] = ray_end
	
	return result
