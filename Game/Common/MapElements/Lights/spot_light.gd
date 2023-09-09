extends SpotLight
# A basic script for the spot light entity

##### VARIABLES #####
#---- CONSTANTS -----
const TB_SPOT_LIGHT_MAPPER := [
	["energy", "light_energy"],
	["range", "spot_range"],
	["specular", "light_specular"],
	["shadow_enabled", "shadow_enabled"],
	["color", "light_color"],
	["mangle", "rotation_degrees"],
	["attenuation","spot_attenuation"],
	["angle_size","spot_angle"]
]  # mapper for TrenchBroom parameters

#---- EXPORTS -----
export(Dictionary) var properties

##### PROCESSING #####
# Called when the object is initialized.
func _ready():
	_set_TB_params()
	
##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_SPOT_LIGHT_MAPPER)
