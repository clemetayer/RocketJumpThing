extends Control
# The level select menu

##### SIGNALS #####
signal return_to_prev_menu

##### VARIABLES #####
#---- CONSTANTS -----
const LEVEL_ICON_PATH := "res://Game/Common/Menus/LevelSelect/level_icon.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _runtime_utils = RuntimeUtils # to override for test purposes
var _scenes_manager = ScenesManager # to override for test purposes

#==== ONREADY ====
onready var onready_paths := {
	"return":$"Menu/VBoxContainer/ReturnButton",
	"grid":$"Menu/VBoxContainer/GridContainer"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_grid()

##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.return,self,"pressed","_on_button_pressed")
	DebugUtils.log_connect(SignalManager,self,SignalManager.LEVELS_DATA_UPDATED,"_on_SignalManager_levels_data_updated")

func _init_grid() -> void:
	_clear_grid()
	for level_idx in range(_runtime_utils.levels_data.LEVELS.size()):
		onready_paths.grid.add_child(_create_level_icon(_runtime_utils.levels_data,level_idx))

func _clear_grid() -> void:
	for child in onready_paths.grid.get_children():
		child.free()

func _create_level_icon(levels_data : LevelsData, level_idx : int) -> Control:
	var icon = load(LEVEL_ICON_PATH).instance()
	icon.LEVELS_DATA = levels_data
	icon.LEVEL_IDX = level_idx
	return icon

##### SIGNAL MANAGEMENT #####
func _on_button_pressed() -> void:
	emit_signal("return_to_prev_menu")

func _on_SignalManager_levels_data_updated() -> void:
	_init_grid()