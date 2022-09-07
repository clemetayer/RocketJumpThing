extends Viewport
# Used to show the speed on breakable wall

##### VARIABLES #####
#---- CONSTANTS -----
const COLOR_NOK := Color(1, 0, 0, 1)  # color of the text if the player speed is < to the treshold
const COLOR_OK := Color(0, 1, 0, 1)  # color of the text if the player speed is >= to the treshold


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_texture_rect()


##### PROTECTED METHODS #####
func _init_texture_rect() -> void:
	size = $TextureRect.rect_size
	$TextureRect.modulate = COLOR_NOK


##### PUBLIC METHODS #####
# UNUSED for the moment ?
func set_sprite_rocket_ok() -> void:
	$TextureRect.modulate = COLOR_OK
