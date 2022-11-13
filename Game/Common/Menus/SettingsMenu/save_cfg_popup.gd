extends ConfirmationDialog
# Save an existing cfg preset

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _cfg: ConfigFile
var _path: String
var _name: String


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.SAVE_CFG_POPUP, "_on_SignalManager_save_cfg_popup"
	)
	DebugUtils.log_connect(self, self, "confirmed", "_on_popup_confirmed")


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_save_cfg_popup(path: String, name: String, cfg: ConfigFile) -> void:
	_path = path
	_name = name
	_cfg = cfg
	dialog_text = tr("Do you want to overwrite %s") % name
	popup_centered()


func _on_popup_confirmed() -> void:
	DebugUtils.log_save_cfg(_cfg, _path + _name)
