extends CanvasLayer
# Script for the player user interface

#==== PUBLIC ====
var speed := 0.0 setget set_speed

#==== ONREADY ====
onready var onready_paths := {
	"speed_text": $"Screen/MarginScreen/CenterScreen/SpeedContainer/SpeedText"
}


##### PUBLIC METHODS #####
func set_speed(pspeed: float):
	speed = round(pspeed)
	_set_speed_text()


##### PROTECTED METHODS #####
func _set_speed_text() -> void:
	if onready_paths.speed_text != null:
		onready_paths.speed_text.bbcode_text = TextUtils.BBCode_center_text(
			tr(TranslationKeys.PLAYER_UI_SPEED) % speed
		)
