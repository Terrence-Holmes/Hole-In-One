extends Camera3D

#Angles
var aimAngle : float = 0 #The camera's up and down aim angle

#Aim
var aimMinMax : Vector2 = Vector2(-80, 80)


func _ready():
	GameManager.mainCamera = self


func _process(delta):
	_set_rotation()



func _set_rotation():
	rotation.x = deg_to_rad(aimAngle)


#Adjusts the camera's up/down aim
func adjust_aim(anglePlus : float):
	aimAngle += anglePlus
	aimAngle = clampf(aimAngle, aimMinMax.x, aimMinMax.y) 
