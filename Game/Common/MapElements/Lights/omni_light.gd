extends OmniLight
# A basic script for the omni light entity

##### VARIABLES #####
#---- CONSTANTS -----
const TB_OMNI_LIGHT_MAPPER := [
	["energy", "light_energy"],
	["range", "omni_range"],
	["specular", "light_specular"],
	["shadow_mode", "omni_shadow_mode"],
	["shadow_enabled", "shadow_enabled"],
	["color", "light_color"]
]  # mapper for TrenchBroom parameters

#---- EXPORTS -----
export(Dictionary) var properties


##### PROCESSING #####
# Called when the object is initialized.
func _ready():
	_set_TB_params()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_OMNI_LIGHT_MAPPER)
