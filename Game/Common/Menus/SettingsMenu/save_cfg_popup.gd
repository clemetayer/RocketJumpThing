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


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tr()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.SAVE_CFG_POPUP, "_on_SignalManager_save_cfg_popup"
	)
	DebugUtils.log_connect(self, self, "confirmed", "_on_popup_confirmed")


func _init_tr() -> void:
	window_title = tr(TranslationKeys.MENU_SETTINGS_SAVE_CFG_POPUP_TITLE)
	dialog_text = tr(TranslationKeys.MENU_SETTINGS_SAVE_CFG_POPUP_LABEL) % name


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_save_cfg_popup(path: String, name: String, cfg: ConfigFile) -> void:
	_path = path
	_name = name
	_cfg = cfg
	dialog_text = tr(TranslationKeys.MENU_SETTINGS_SAVE_CFG_POPUP_LABEL) % name
	popup_centered()


func _on_popup_confirmed() -> void:
	DebugUtils.log_save_cfg(_cfg, _path + _name)
	SettingsUtils.save_current_settings()
