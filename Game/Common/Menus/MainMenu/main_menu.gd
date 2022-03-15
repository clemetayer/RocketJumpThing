extends Node2D
# Script to handle the main menu in general

##### VARIABLES #####
#---- CONSTANTS -----
const PATHS := {"tutorial_scene": "res://Game/Scenes/Tutorial/Scene2/Scene2.tscn"}


##### SIGNAL MANAGEMENT #####
func _on_PlayButton_pressed():
	get_tree().change_scene(PATHS.tutorial_scene)


func _on_OptionsButton_pressed():
	# TODO : implement this once the option menu is done
	pass  # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()