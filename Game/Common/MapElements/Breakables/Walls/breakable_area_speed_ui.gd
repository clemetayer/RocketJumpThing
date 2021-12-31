extends Viewport
# Used to show the speed on breakable wall

##### VARIABLES #####
export (float) var SPEED = 0 # Speed to show on the Sprite3D

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(SPEED)
	size = $Label.rect_size
