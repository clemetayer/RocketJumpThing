extends Label
# Just to replace some text at regular intervals

##### VARIABLES #####
#---- CONSTANTS -----
const EGH := ["EGH", "L'EGH", "Le GH", "L'EGG"]

#---- STANDARD -----
#==== ONREADY ====
var _cur_egh_idx := 0


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	DebugUtils.log_connect($ReplaceTimer, self, "timeout", "_on_ReplaceTimer_timeout")


##### SIGNAL MANAGEMENT #####
func _on_ReplaceTimer_timeout() -> void:
	text = tr(TranslationKeys.END_GAME_FAMILY_AND_FRIENDS) % [EGH[_cur_egh_idx]]
	_cur_egh_idx = (_cur_egh_idx + 1) % EGH.size()
