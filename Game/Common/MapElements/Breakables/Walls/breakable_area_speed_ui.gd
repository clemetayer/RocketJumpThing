extends Viewport
# Used to show the speed on breakable wall

##### VARIABLES #####
#---- EXPORTS -----
export (int) var FONT_SIZE = 150 # Font size of the label
export (float) var SPEED = 0 # Speed to show on the Sprite3D

var _test = false

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(SPEED)
	$Label.get("custom_fonts/font").set_size(FONT_SIZE)
	size = $Label.rect_size
