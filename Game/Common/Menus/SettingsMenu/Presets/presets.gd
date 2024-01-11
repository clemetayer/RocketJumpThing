extends HBoxContainer
class_name Presets
# A general preset selector, can be customized by children classes

##### SIGNALS ######
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _cfg_files_list := []  # list of cfg files

#==== ONREADY ====
onready var onready_paths := {
	"label": $"Label",
	"options_menu": $"OptionButton",
	"save_button": $"SaveButton",
	"add_preset": $"AddPreset",
	"folder_button": $"FolderButton",
	"refresh_button": $"RefreshButton"
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_cfg_files_list = FunctionUtils.list_dir_files(
		_get_config_path(), SettingsUtils.REGEX_PATTERN_CFG_FILE
	)


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tr()
	_connect_signals()
	_init_list()


##### PROTECTED METHODS #####
func _init_tr() -> void:
	onready_paths.label.text = tr(TranslationKeys.PRESET_LABEL)
	onready_paths.options_menu.hint_tooltip = tr(TranslationKeys.PRESET_OPTION_TOOLTIP)
	onready_paths.save_button.hint_tooltip = tr(TranslationKeys.PRESET_SAVE_TOOLTIP)
	onready_paths.add_preset.hint_tooltip = tr(TranslationKeys.PRESET_ADD_TOOLTIP)
	onready_paths.folder_button.hint_tooltip = tr(TranslationKeys.PRESET_FOLDER_TOOLTIP)
	onready_paths.refresh_button.hint_tooltip = tr(TranslationKeys.PRESET_REFRESH_TOOLTIP)


func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.save_button, self, "pressed", "_on_SaveButton_pressed")
	DebugUtils.log_connect(onready_paths.add_preset, self, "pressed", "_on_AddPresetButton_pressed")
	DebugUtils.log_connect(onready_paths.folder_button, self, "pressed", "_on_FolderButton_pressed")
	DebugUtils.log_connect(
		onready_paths.refresh_button, self, "pressed", "_on_RefreshButton_pressed"
	)
	DebugUtils.log_connect(onready_paths.options_menu, self, "item_selected", "_on_preset_selected")
	DebugUtils.log_connect(SignalManager, self, SignalManager.UPDATE_SETTINGS, "_on_SignalManager_update_settings")


func _init_list() -> void:
	var cfg_list := _cfg_files_list
	for file_idx in range(cfg_list.size()):
		onready_paths.options_menu.add_item(
			cfg_list[file_idx].rstrip(SettingsUtils.CFG_FILE_EXTENSION.length())
		)
		if cfg_list[file_idx] == _get_init_selected_cfg():
			onready_paths.options_menu.select(file_idx)


# returns the current selected cfg name
func _get_cfg_name() -> String:
	return _cfg_files_list[onready_paths.options_menu.selected]


# Should be overriden by children classes
func _get_init_selected_cfg() -> String:
	return SettingsUtils.CURRENT_PRESET_FILE_NAME + SettingsUtils.CFG_FILE_EXTENSION


# Should be overriden by children classes
func _generate_cfg_file() -> ConfigFile:
	return ConfigFile.new()


# Should be overriden by children classes
func _get_config_path() -> String:
	return SettingsUtils.ROOT_PRESETS_FOLDER


# Should be overriden by children classes
func _apply_preset(_path: String) -> void:
	pass


##### SIGNAL MANAGEMENT #####
func _on_SaveButton_pressed() -> void:
	if not _cfg_files_list.empty() and onready_paths.options_menu.selected != -1:
		SignalManager.emit_save_cfg_popup(_get_config_path(), _get_cfg_name(), _generate_cfg_file())


func _on_AddPresetButton_pressed() -> void:
	SignalManager.emit_add_cfg_popup(_get_config_path(), _generate_cfg_file())


func _on_FolderButton_pressed() -> void:
	DebugUtils.log_shell_open(str("file://", ProjectSettings.globalize_path(_get_config_path())))


func _on_RefreshButton_pressed() -> void:
	onready_paths.options_menu.clear()
	_cfg_files_list = FunctionUtils.list_dir_files(
		_get_config_path(), SettingsUtils.REGEX_PATTERN_CFG_FILE
	)
	_init_list()


func _on_preset_selected(_idx: int) -> void:
	_apply_preset(_get_config_path() + _get_cfg_name())

func _on_SignalManager_update_settings() -> void:
	_on_RefreshButton_pressed() 