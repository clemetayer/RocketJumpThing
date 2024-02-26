extends MarginContainer
# The level icon button

##### VARIABLES #####
#---- EXPORTS -----
export(Resource) var LEVELS_DATA
export(int) var LEVEL_IDX

#---- STANDARD -----
#==== PRIVATE ====
var _level_data : LevelData
var _scenes_manager = ScenesManager # to override for tests

#==== ONREADY ====
onready var onready_paths := {
	"button":$"VBoxContainer/Button",
	"level_name":$"VBoxContainer/LevelName",
	"last_time": $"VBoxContainer/LastTime",
	"best_time": $"VBoxContainer/BestTime"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_level_icon()

##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.button, self, "pressed", "_on_button_pressed")
	DebugUtils.log_connect(SignalManager, self, SignalManager.TRANSLATION_UPDATED, "_on_SignalManager_translation_updated")

func _init_level_icon() -> void:
	if LEVELS_DATA != null:
		_level_data = LEVELS_DATA.get_level(LEVEL_IDX)
		onready_paths.button.icon = FunctionUtils.get_texture_at_path(_level_data.PREVIEW_PATH)
		onready_paths.button.disabled = not _level_data.UNLOCKED
		onready_paths.level_name.text = _level_data.NAME
		onready_paths.last_time.text = tr(TranslationKeys.MENU_LEVEL_SELECT_LAST_TIME) % _unix_time_to_str(_level_data.LAST_TIME)
		onready_paths.best_time.text = tr(TranslationKeys.MENU_LEVEL_SELECT_BEST_TIME) % _unix_time_to_str(_level_data.BEST_TIME)
	else:
		DebugUtils.log_stacktrace("Level data is null", DebugUtils.LOG_LEVEL.debug)

func _unix_time_to_str(time : int) -> String:
	var millis = fmod(time, 1000)
	var seconds = floor(fmod(time / 1000, 60))
	var minutes = floor(time / (1000 * 60))
	return "%02d:%02d:%03d" % [minutes, seconds, millis]

##### SIGNAL MANAGEMENT #####
func _on_button_pressed() -> void:
	MenuNavigator.exit_navigation()
	_scenes_manager.load_level(LEVELS_DATA,LEVEL_IDX)
		
func _on_SignalManager_translation_updated() -> void:
	onready_paths.last_time.text = tr(TranslationKeys.MENU_LEVEL_SELECT_LAST_TIME) % _unix_time_to_str(_level_data.LAST_TIME)
	onready_paths.best_time.text = tr(TranslationKeys.MENU_LEVEL_SELECT_BEST_TIME) % _unix_time_to_str(_level_data.BEST_TIME)
