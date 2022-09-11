extends Node2D
# Script to handle the main menu in general

##### VARIABLES #####
#---- CONSTANTS -----
const PATHS := {"tutorial_scene": "res://Game/Scenes/Tutorial/Scene2/Scene2.tscn"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_disable_pause()
	_enable_mouse_visible()
	_init_global_variables()


##### PROTECTED METHODS #####
func _disable_pause() -> void:
	PauseMenu.ENABLED = false


func _enable_mouse_visible() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _init_global_variables() -> void:
	VariableManager.end_level_enabled = false
	VariableManager.pause_enabled = false


##### SIGNAL MANAGEMENT #####
func _on_PlayButton_pressed():
	get_tree().change_scene(PATHS.tutorial_scene)


func _on_OptionsButton_pressed():
	# TODO : implement this once the option menu is done
	pass  # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
