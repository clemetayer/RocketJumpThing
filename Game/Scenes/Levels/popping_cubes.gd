extends ParticlesStepSequencer
# Popping spheres rythm element for the level 4

##### VARIABLES #####
#---- CONSTANTS -----
const TB_POPPING_SPHERES_MAPPER := [["color", "_color"]]

#---- STANDARD -----
#==== PRIVATE ====
var _color := Color.white


##### PROTECTED METHODS #####
func _ready_func():
	._ready_func()
	var transparent_color: Color = _color
	transparent_color.a = 0
	# Duplicates the materials (to not target the same instance)
	process_material = process_material.duplicate()
	process_material.color_ramp = process_material.color_ramp.duplicate()
	process_material.color_ramp.gradient = process_material.color_ramp.gradient.duplicate()
	# sets the color
	process_material.color_ramp.gradient.colors = PoolColorArray(
		[transparent_color, _color, transparent_color]
	)


func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_POPPING_SPHERES_MAPPER)
