extends Popup
# A popup to assign a new key to an aciton

##### VARIABLES #####
#---- EXPORTS -----
export(String) var ACTION

#---- STANDARD -----
#==== PRIVATE ====
var _input_pressed: InputEvent

#==== ONREADY ====
onready var onready_paths := {"message": $"Messages/Message", "key": $"Messages/Key"}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


func _input(event):
	if (
		visible
		and (
			event is InputEventKey
			or event is InputEventMouseButton
			or event is InputEventJoypadButton
		)
	):
		_input_pressed = event
		_set_key(RuntimeUtils.display_input_as_string(event))
		_change_key(_input_pressed)
		SignalManager.emit_update_keys()
		visible = false


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.CHANGE_KEY_POPUP, "_on_SignalManager_change_key_popup"
	)


func _set_popup_text() -> void:
	onready_paths.message.set_bbcode(
		(
			tr("Enter an action for %s")
			% [TextUtils.BBCode_color_text(tr(ACTION), Color.yellow.to_html())]
		)
	)
	_set_key(RuntimeUtils.display_input_as_string(InputMap.get_action_list(ACTION)[0]))


func _set_key(key: String) -> void:
	onready_paths.key.set_bbcode(
		TextUtils.BBCode_color_text(
			TextUtils.BBCode_center_text(tr(key)), Color.aquamarine.to_html()
		)
	)


func _change_key(key: InputEvent) -> void:
	if !InputMap.get_action_list(ACTION).empty():
		InputMap.action_erase_event(ACTION, InputMap.get_action_list(ACTION)[0])
	InputMap.action_add_event(ACTION, key)


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_change_key_popup(action: String) -> void:
	ACTION = action
	_set_popup_text()
	popup_centered()
