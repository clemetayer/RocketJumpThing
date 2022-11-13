extends VBoxContainer
# Video settings

##### ENUMS #####
enum window_modes { FULL_SCREEN, WINDOWED }

##### VARIABLES #####
#---- CONSTANTS -----
const FULL_SCREEN_LABEL := "settings_video_mode_fullscreen"
const WINDOWED_LABEL := "settings_video_mode_windowed"
const TAB_NAME := "Video"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"options": $"WindowType/HBox/Options"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_options()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		onready_paths.options, self, "item_selected", "_on_Options_item_selected"
	)


func _init_options() -> void:
	onready_paths.options.add_item(tr(FULL_SCREEN_LABEL), window_modes.FULL_SCREEN)
	onready_paths.options.add_item(tr(WINDOWED_LABEL), window_modes.WINDOWED)
	onready_paths.options.select(
		window_modes.FULL_SCREEN if OS.window_fullscreen else window_modes.WINDOWED
	)


##### SIGNAL MANAGEMENT #####
func _on_Options_item_selected(idx: int) -> void:
	match idx:
		window_modes.FULL_SCREEN:
			OS.set_window_fullscreen(true)
		window_modes.WINDOWED:
			OS.set_window_fullscreen(false)
