extends Control
class_name BallUI

#References
@onready var chargeBar : ProgressBar = get_node("ChargeBar")
@onready var modeButton : Button = get_node("ModeButton")


func _ready():
	modeButton.connect("pressed", _mode_button_pressed)
	UIManager.charge_changed.append(_update_charge)



func _process(delta):
	_manage_visibility()

func _manage_visibility():
	visible = (GameManager.ballStatus == GameManager.BallStatus.PORTAL1 or GameManager.ballStatus == GameManager.BallStatus.PORTAL2 or GameManager.ballStatus == GameManager.BallStatus.AIMING)


func _mode_button_pressed():
	if (GameManager.ballStatus == GameManager.BallStatus.PORTAL1 or GameManager.ballStatus == GameManager.BallStatus.PORTAL2):
		GameManager.ballStatus = GameManager.BallStatus.AIMING
		modeButton.text = "PORTAL"
	elif (GameManager.ballStatus == GameManager.BallStatus.AIMING):
		GameManager.ballStatus = GameManager.BallStatus.PORTAL1
		modeButton.text = "AIM SHOT"


func _update_charge(newCharge : float):
	chargeBar.value = newCharge
