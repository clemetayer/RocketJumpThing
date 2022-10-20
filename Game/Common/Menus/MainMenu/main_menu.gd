extends Node2D
# Script to handle the main menu in general

##### VARIABLES #####
#---- CONSTANTS -----
const PATHS := {"tutorial_scene": "res://Game/Scenes/Tutorial/Tutorial1/tutorial_1.tscn"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_enable_mouse_visible()


##### PROTECTED METHODS #####
func _enable_mouse_visible() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


##### SIGNAL MANAGEMENT #####
func _on_PlayButton_pressed():
	ScenesManager.load_level("Proof of concept")


func _on_OptionsButton_pressed():
	# TODO : implement this once the option menu is done
	pass  # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
