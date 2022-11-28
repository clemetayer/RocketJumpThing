extends Node2D
# Script to handle the main menu in general

##### VARIABLES #####
#---- CONSTANTS -----
const PATHS := {"tutorial_scene": "res://Game/Scenes/Tutorial/Tutorial1/tutorial_1.tscn"}
const SETTINGS_MENU_LAYER_PATH := "res://Game/Common/Menus/SettingsMenu/settings_menu_layer.tscn"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"play": $"Menu/CenterContainer/Buttons/PlayButton",
	"options": $"Menu/CenterContainer/Buttons/OptionsButton",
	"quit": $"Menu/CenterContainer/Buttons/QuitButton"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_labels()
	_enable_mouse_visible()


##### PROTECTED METHODS #####
func _set_labels() -> void:
	onready_paths.play.text = tr(TranslationKeys.MENU_PLAY)
	onready_paths.options.text = tr(TranslationKeys.MENU_OPTIONS)
	onready_paths.quit.text = tr(TranslationKeys.MENU_QUIT)


func _enable_mouse_visible() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


##### SIGNAL MANAGEMENT #####
func _on_PlayButton_pressed():
	ScenesManager.load_level("Proof of concept")


func _on_OptionsButton_pressed():
	get_tree().get_root().add_child(load(SETTINGS_MENU_LAYER_PATH).instance())


func _on_QuitButton_pressed():
	get_tree().quit()
