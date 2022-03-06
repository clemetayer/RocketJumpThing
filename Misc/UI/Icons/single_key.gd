extends CenterContainer
# A simple scene to show a single key

##### VARIABLES #####
#---- EXPORTS -----
export(String) var key_text  # the key as a string to display
export(bool) var pressed  # show as pressed or not


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.set_text(key_text)
	set_emphasis()


##### PUBLIC METHODS ######
func set_emphasis() -> void:
	$Button.pressed = pressed
