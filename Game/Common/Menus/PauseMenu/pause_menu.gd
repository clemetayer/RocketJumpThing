extends CanvasLayer
# Script for the pause menu

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const FADE_IN_TIME := 0.5

#---- STANDARD -----
#==== PRIVATE ====
var _paths := {
	"tween": "./OpacityTween",
	"root_ui": "./UI",
	"main_menu_scene": "res://Game/Common/Menus/MainMenu/main_menu.tscn",
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(_paths.root_ui).hide()


##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass


##### SIGNAL MANAGEMENT #####
func _on_ResumeButton_pressed():
	pass  # Replace with function body.


func _on_MainMenuButton_pressed():
	pass  # Replace with function body.


func _on_OptionButton_pressed():
	pass  # Replace with function body.


func _on_RestartButton_pressed():
	pass  # Replace with function body.
