extends Control
# End level UI class

##### VARIABLES #####
#---- CONSTANTS -----
const FADE_IN_TIME := 0.5

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"label": $"VBoxContainer/Time",
	"next_scene_button": $"VBoxContainer/Buttons/NextButton",
	"main_menu_button": $"VBoxContainer/Buttons/MainMenuButton",
	"restart_button": $"VBoxContainer/Buttons/RestartButton"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_set_labels()


##### PROTECTED METHODS #####
func _set_labels() -> void:
	onready_paths.next_scene_button.text = tr(TranslationKeys.MENU_NEXT_LEVEL)
	onready_paths.main_menu_button.text = tr(TranslationKeys.MAIN_MENU)
	onready_paths.restart_button.text = tr(TranslationKeys.MENU_RESTART)


func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager, self, "end_reached", "_on_SignalManager_end_reached")
	DebugUtils.log_connect(onready_paths.next_scene_button, self, "pressed", "_on_NextButton_pressed")
	DebugUtils.log_connect(onready_paths.main_menu_button, self, "pressed", "_on_MainMenuButton_pressed")
	DebugUtils.log_connect(onready_paths.restart_button, self, "pressed", "_on_RestartButton_pressed")  

##### SIGNAL MANAGEMENT #####
func _on_SignalManager_end_reached() -> void:
	MenuNavigator.toggle_pause_enabled(false)
	ScenesManager.pause()
	yield(get_tree().create_timer(0.1), "timeout")  # waits a little before pausing, to at least update the time in VariableManager. 
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	onready_paths.next_scene_button.disabled = not ScenesManager.has_next_level()
	var millis = fmod(VariableManager.chronometer.level, 1000)
	var seconds = floor(fmod(VariableManager.chronometer.level / 1000, 60))
	var minutes = floor(VariableManager.chronometer.level / (1000 * 60))
	onready_paths.label.set_text("%02d : %02d : %03d" % [minutes, seconds, millis])
	MenuNavigator.open_navigation(MenuNavigator.MENU.end_level)


func _on_NextButton_pressed():
	MenuNavigator.exit_navigation()
	ScenesManager.unpause(Input.MOUSE_MODE_CAPTURED)
	MenuNavigator.toggle_pause_enabled(true)
	ScenesManager.next_level()


func _on_RestartButton_pressed():
	MenuNavigator.exit_navigation()
	ScenesManager.unpause(Input.MOUSE_MODE_CAPTURED)
	MenuNavigator.toggle_pause_enabled(true)
	ScenesManager.reload_current()


func _on_MainMenuButton_pressed():
	MenuNavigator.exit_navigation()
	ScenesManager.unpause(Input.MOUSE_MODE_VISIBLE)
	MenuNavigator.toggle_pause_enabled(false) # just to be sure
	ScenesManager.load_main_menu()
