extends Camera3D

@export var lookat : Node3D


func _process(delta):
	look_at(lookat.global_position, Vector3.UP)
	
	
	if (Input.is_action_pressed("Left")):
		position.x -= 1
		
	if (Input.is_action_pressed("Right")):
		position.x += 1
	
	if (Input.is_action_pressed("Up")):
		position.z -= 1
	
	if (Input.is_action_pressed("Down")):
		position.z += 1
