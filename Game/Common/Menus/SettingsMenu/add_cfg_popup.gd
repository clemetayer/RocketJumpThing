extends ConfirmationDialog
# A popup to save a new cfg

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _path: String
var _cfg: ConfigFile

#==== ONREADY ====
onready var onready_paths := {"line_edit": $"MarginContainer/CenterContainer/LineEdit"}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.ADD_CFG_POPUP, "_on_SignalManager_add_cfg_popup"
	)
	DebugUtils.log_connect(self, self, "confirmed", "_on_popup_confirmed")


# Called when the node enters the scene tree for the first time.
func _ready():
	DebugUtils.log_connect(
		onready_paths.line_edit, self, "text_changed", "_on_LineEdit_text_changed"
	)


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_add_cfg_popup(path: String, cfg: ConfigFile) -> void:
	_path = path
	_cfg = cfg
	popup_centered()


func _on_popup_confirmed() -> void:
	DebugUtils.log_save_cfg(
		_cfg, _path + onready_paths.line_edit.text + SettingsUtils.CFG_FILE_EXTENSION
	)


# Checks if the input name is valid
func _on_LineEdit_text_changed(new_text: String) -> void:
	get_close_button().disabled = !new_text.is_valid_filename()
