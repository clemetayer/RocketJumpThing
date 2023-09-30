extends Viewport
# Used to show the speed on breakable wall

##### VARIABLES #####
#---- EXPORTS -----
export(Color) var COLOR

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"hbox": $"HBoxContainer"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_hbox()


##### PROTECTED METHODS #####
func _init_hbox() -> void:
	if onready_paths.hbox != null:
		size = onready_paths.hbox.rect_size
		onready_paths.hbox.modulate = COLOR
