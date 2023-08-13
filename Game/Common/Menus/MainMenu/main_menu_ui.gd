extends Control
# Script to handle the main menu ui in general

##### SIGNALS #####
signal level_select_requested
signal settings_requested

##### VARIABLES #####
#---- CONSTANTS -----

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"play": $"Buttons/PlayButton",
	"level_selection": $"Buttons/LevelSelectButton",
	"options": $"Buttons/OptionsButton",
	"quit": $"Buttons/QuitButton"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_set_labels()
	_enable_mouse_visible()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.play,self,"pressed","_on_PlayButton_pressed")
	DebugUtils.log_connect(onready_paths.level_selection,self,"pressed","_on_LevelSelectButton_pressed")
	DebugUtils.log_connect(onready_paths.options,self,"pressed","_on_OptionsButton_pressed")
	DebugUtils.log_connect(onready_paths.quit,self,"pressed","_on_QuitButton_pressed")

func _load_start_levels() -> void:
	ScenesManager.load_level(RuntimeUtils.levels_data,0)

func _set_labels() -> void:
	onready_paths.level_selection.text = tr(TranslationKeys.MENU_LEVEL_SELECTION)
	onready_paths.play.text = tr(TranslationKeys.MENU_PLAY)
	onready_paths.options.text = tr(TranslationKeys.MENU_SETTINGS)
	onready_paths.quit.text = tr(TranslationKeys.MENU_QUIT)


func _enable_mouse_visible() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


##### SIGNAL MANAGEMENT #####
func _on_PlayButton_pressed():
	MenuNavigator.exit_navigation()
	_load_start_levels()

func _on_OptionsButton_pressed():
	emit_signal("settings_requested")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_LevelSelectButton_pressed():
	emit_signal("level_select_requested")
