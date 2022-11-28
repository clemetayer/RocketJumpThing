extends CanvasLayer
# Script for the pause menu

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const FADE_IN_TIME := 0.5
const SETTINGS_MENU_LAYER_PATH := "res://Game/Common/Menus/SettingsMenu/settings_menu_layer.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _paused := false  # boolean to tell if the menu is paused or not
var _pause_enabled := true  # to tell if the pause menu can be shown or not

#==== ONREADY ====
onready var onready_paths := {
	"root_ui": $"UI",
	"resume": $"UI/Menu/VBoxContainer/ResumeButton",
	"restart": $"UI/Menu/VBoxContainer/RestartButton",
	"options": $"UI/Menu/VBoxContainer/OptionButton",
	"main_menu": $"UI/Menu/VBoxContainer/MainMenuButton"
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.root_ui.hide()
	_set_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	_manage_inputs()


##### PROTECTED METHODS #####
func _set_labels() -> void:
	onready_paths.resume.text = tr(TranslationKeys.MENU_RESUME)
	onready_paths.restart.text = tr(TranslationKeys.MENU_RESTART)
	onready_paths.options.text = tr(TranslationKeys.MENU_OPTIONS)
	onready_paths.main_menu.text = tr(TranslationKeys.MAIN_MENU)


func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager, self, "end_reached", "_on_SignalManager_end_reached")


func _manage_inputs() -> void:
	if Input.is_action_just_pressed("pause"):
		if _paused:
			_unpause()
		else:
			_pause()


func _pause():
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			FunctionUtils.create_filter_auto_effect(FADE_IN_TIME),
			{StandardSongManager.get_current().name: {"fade_in": false}}
		)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	onready_paths.root_ui.show()
	_paused = true


func _unpause():
	if StandardSongManager.get_current() != null:
		StandardSongManager.apply_effect(
			FunctionUtils.create_filter_auto_effect(FADE_IN_TIME),
			{StandardSongManager.get_current().name: {"fade_in": true}}
		)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	onready_paths.root_ui.hide()
	_paused = false


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_end_reached() -> void:
	_pause_enabled = false


func _on_ResumeButton_pressed():
	_unpause()


func _on_MainMenuButton_pressed():
	_unpause()
	ScenesManager.load_main_menu()


func _on_OptionButton_pressed():
	get_tree().get_root().add_child(load(SETTINGS_MENU_LAYER_PATH).instance())


func _on_RestartButton_pressed():
	_unpause()
	ScenesManager.reload_current()
