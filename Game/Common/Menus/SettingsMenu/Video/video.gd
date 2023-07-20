extends MarginContainer
# Video settings

##### ENUMS #####
enum window_modes { FULL_SCREEN, WINDOWED }

##### VARIABLES #####
#---- CONSTANTS -----
const TAB_NAME := "MENU_SETTINGS_TAB_VIDEO"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"window_type":
	{
		"options": $"VBox/WindowType/HBox/Options",
		"category": $"VBox/WindowType",
		"label": $"VBox/WindowType/HBox/Label"
	}
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tr()
	_connect_signals()
	_init_options()


##### PROTECTED METHODS #####
func _init_tr() -> void:
	onready_paths.window_type.category.set_category_name(
		tr(TranslationKeys.SETTINGS_VIDEO_DISPLAY_CATEGORY)
	)
	onready_paths.window_type.label.text = tr(TranslationKeys.SETTINGS_VIDEO_DISPLAY_MODE)


func _connect_signals() -> void:
	DebugUtils.log_connect(
		onready_paths.window_type.options, self, "item_selected", "_on_Options_item_selected"
	)


func _init_options() -> void:
	onready_paths.window_type.options.add_item(
		tr(TranslationKeys.SETTINGS_VIDEO_FULL_SCREEN), window_modes.FULL_SCREEN
	)
	onready_paths.window_type.options.add_item(
		tr(TranslationKeys.SETTINGS_VIDEO_WINDOWED), window_modes.WINDOWED
	)
	onready_paths.window_type.options.select(
		window_modes.FULL_SCREEN if OS.window_fullscreen else window_modes.WINDOWED
	)


##### SIGNAL MANAGEMENT #####
func _on_Options_item_selected(idx: int) -> void:
	match idx:
		window_modes.FULL_SCREEN:
			OS.set_window_fullscreen(true)
		window_modes.WINDOWED:
			OS.set_window_fullscreen(false)
