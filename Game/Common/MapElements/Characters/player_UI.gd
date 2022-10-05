extends CanvasLayer
# Script for the player user interface

#==== PUBLIC ====
var speed := 0.0 setget set_speed


##### PUBLIC METHODS #####
func set_speed(pspeed: float):
	speed = round(pspeed)
	_set_speed_text()


##### PROTECTED METHODS #####
func _set_speed_text() -> void:
	$Screen/MarginScreen/CenterScreen/SpeedContainer/SpeedText.bbcode_text = TextUtils.BBCode_center_text(
		"%s : %d" % [tr("player_ui_speed"), speed]
	)
