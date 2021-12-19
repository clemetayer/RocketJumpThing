extends CanvasLayer
# Script to prompt tutorial messages to the player

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _keys_dict := {}  # Dictionnary of keys, to replace in tutorial texts


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	if SignalManager.connect("trigger_tutorial", self, "_on_SignalManager_trigger_tutorial") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"trigger_tutorial",
					"_on_SignalManager_trigger_tutorial",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)
	set_keys_dict()
	$Screen.hide()
	$Screen/CenterContainer/Label.set_text("")


##### PUBLIC METHODS ######
# sets the _keys_dict variable
# TODO : kind of a dirty way to do this, maybe make a singleton or a static class dedicated to do this
func set_keys_dict() -> void:
	_keys_dict = {
		"##movement_forward##": InputMap.get_action_list("movement_forward")[0].as_text(),
		"##movement_backward##": InputMap.get_action_list("movement_backward")[0].as_text(),
		"##movement_left##": InputMap.get_action_list("movement_left")[0].as_text(),
		"##movement_right##": InputMap.get_action_list("movement_right")[0].as_text(),
		"##movement_jump##": InputMap.get_action_list("movement_jump")[0].as_text(),
	}


# Displays the text of a tutorial key for a given time (in seconds)
func display_tutorial(key: String, time: float) -> void:
	$Screen.show()
	Engine.set_time_scale(0.5)
	$Screen/CenterContainer/Label.set_text(TextUtils.replace_elements(tr(key), _keys_dict))
	yield(get_tree().create_timer(time), "timeout")
	Engine.set_time_scale(1.0)
	$Screen.hide()
	$Screen/CenterContainer/Label.set_text("")


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_trigger_tutorial(key: String, time: float) -> void:
	display_tutorial(key, time)
