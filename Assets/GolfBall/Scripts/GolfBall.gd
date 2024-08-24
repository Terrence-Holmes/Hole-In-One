extends RigidBody3D
class_name GolfBall

var launchPower : Vector2 = Vector2(1, 4)
var powerCharge : float = 1
var aimDirection : Vector3 = Vector3(0, 0, 0)


func _process(delta):
	if (GameManager.mainCamera != null):
		aimDirection = -GameManager.mainCamera.global_transform.basis.z

func launch():
	apply_central_impulse(aimDirection * 30)
