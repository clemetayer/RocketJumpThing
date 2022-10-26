extends CenterContainer
# A replacement to show the directions (for instance WASD on a keyboard)

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"forward": $"WASDHBox/W/Button",
	"backward": $"WASDHBox/S/Button",
	"left": $"WASDHBox/ASD/ASDVBox/A/Button",
	"right": $"WASDHBox/ASD/ASDVBox/D/Button"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_keys()


##### PUBLIC METHODS ######
func set_emphasis(forward: bool, backward: bool, left: bool, right: bool) -> void:
	if onready_paths != null:
		if onready_paths.forward != null:
			onready_paths.forward.pressed = forward
		if onready_paths.left != null:
			onready_paths.left.pressed = left
		if onready_paths.backward != null:
			onready_paths.backward.pressed = backward
		if onready_paths.right != null:
			onready_paths.right.pressed = right


##### PROTECTED METHODS #####
func _set_keys() -> void:
	onready_paths.forward.set_text(
		InputMap.get_action_list(VariableManager.INPUT_MVT_FORWARD)[0].as_text()
	)
	onready_paths.left.set_text(
		InputMap.get_action_list(VariableManager.INPUT_MVT_LEFT)[0].as_text()
	)
	onready_paths.backward.set_text(
		InputMap.get_action_list(VariableManager.INPUT_MVT_BACKWARD)[0].as_text()
	)
	onready_paths.right.set_text(
		InputMap.get_action_list(VariableManager.INPUT_MVT_RIGHT)[0].as_text()
	)
