extends HBoxContainer
class_name CommonEditableKey
# A common class to parameter a key that is editable

##### VARIABLES #####
#---- EXPORTS -----
export(String) var ACTION_NAME  # name of the action in the project settings

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"label": $"ActionLabel", "action": $"Action"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_set_action_name(ACTION_NAME)


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.action, self, "pressed", "_on_action_pressed")
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.UPDATE_KEYS, "_on_SignalManager_update_keys"
	)


# for the actions, refer to variable_manager.gd, in the "INPUTS" category
func _set_action_name(action: String) -> void:
	onready_paths.label.text = tr(action)
	onready_paths.action.text = RuntimeUtils.display_input_as_string(
		InputMap.get_action_list(action)[0]
	)
	ACTION_NAME = action


##### SIGNAL MANAGEMENT #####
func _on_action_pressed() -> void:
	SignalManager.emit_change_key_popup(ACTION_NAME)


func _on_SignalManager_update_keys() -> void:
	_set_action_name(ACTION_NAME)
