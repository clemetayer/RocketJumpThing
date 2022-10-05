extends SpatialModifyMaterialParamStepSequencerPulse
# A solid entity that is like a sequencer, but rotates at the same time

##### VARIABLES #####
#---- CONSTANTS -----
const TB_ROTATE_SPATIAL_SEQUENCER_PULSE_MAPPER := [["rotation_speeds", "_rotation_speeds"]]  # mapper for TrenchBroom parameters

#---- STANDARD -----
#==== PRIVATE ====
var _rotation_speeds: Vector3


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	rotate_x(_rotation_speeds.x * delta)
	rotate_y(_rotation_speeds.y * delta)
	rotate_z(_rotation_speeds.z * delta)


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_ROTATE_SPATIAL_SEQUENCER_PULSE_MAPPER
	)
