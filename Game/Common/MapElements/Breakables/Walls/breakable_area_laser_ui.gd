extends Viewport
# Used to show the laser on breakable wall

##### VARIABLES #####
#---- CONSTANTS -----
const COLOR_NOK := Color(1, 0, 0, 1)  # color of the text if the player speed is < to the treshold
const COLOR_OK := Color(0, 1, 0, 1)  # color of the text if the player speed is >= to the treshold
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"texture_rect": $"TextureRect"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_texture_rect()


##### PROTECTED METHODS #####
func _init_texture_rect() -> void:
	if onready_paths.texture_rect != null:
		size = onready_paths.texture_rect.rect_size
		onready_paths.texture_rect.modulate = COLOR_NOK


##### PUBLIC METHODS #####
# UNUSED for the moment ?
func set_sprite_laser_ok() -> void:
	onready_paths.texture_rect.modulate = COLOR_OK
