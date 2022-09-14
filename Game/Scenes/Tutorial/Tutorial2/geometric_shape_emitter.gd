extends Particles
# Geometric shape emitter for the tutorial 2

##### VARIABLES #####

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_properties()


##### PROTECTED METHODS #####
#==== Qodot =====
func _update_properties() -> void:
	if "scale" in properties:
		self.scale = Vector3.ONE * properties.scale
	if "angle" in properties:
		self.rotation_degrees = properties.angle
