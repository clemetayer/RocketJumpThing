extends Control
# Script for the pause menu

##### SIGNALS #####
signal settings_requested

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"resume": $"VBoxContainer/ResumeButton",
	"restart": $"VBoxContainer/RestartButton",
	"options": $"VBoxContainer/OptionButton",
	"main_menu": $"VBoxContainer/MainMenuButton"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_set_labels()


##### PROTECTED METHODS #####
func _set_labels() -> void:
	onready_paths.resume.text = tr(TranslationKeys.MENU_RESUME)
	onready_paths.restart.text = tr(TranslationKeys.MENU_RESTART)
	onready_paths.options.text = tr(TranslationKeys.MENU_SETTINGS)
	onready_paths.main_menu.text = tr(TranslationKeys.MAIN_MENU)


func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.resume, self, "pressed", "_on_ResumeButton_pressed")
	DebugUtils.log_connect(onready_paths.restart, self, "pressed", "_on_RestartButton_pressed")
	DebugUtils.log_connect(onready_paths.options, self, "pressed", "_on_OptionButton_pressed")
	DebugUtils.log_connect(onready_paths.main_menu, self, "pressed", "_on_MainMenuButton_pressed")
	DebugUtils.log_connect(SignalManager,self,SignalManager.TRANSLATION_UPDATED,"_on_SignalManager_translation_updated")

##### SIGNAL MANAGEMENT #####
func _on_ResumeButton_pressed():
	MenuNavigator.exit_navigation()
	ScenesManager.unpause(Input.MOUSE_MODE_CAPTURED)
	
func _on_RestartButton_pressed():
	MenuNavigator.exit_navigation()
	ScenesManager.unpause(Input.MOUSE_MODE_CAPTURED)
	ScenesManager.reload_current()

func _on_MainMenuButton_pressed():
	MenuNavigator.exit_navigation()
	ScenesManager.unpause(Input.MOUSE_MODE_VISIBLE)
	ScenesManager.load_main_menu()

func _on_OptionButton_pressed():
	emit_signal("settings_requested")

func _on_SignalManager_translation_updated() -> void:
	_set_labels()

