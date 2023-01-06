extends Spatial
class_name RotatingSpatial
# code for a spatial that simply rotates

##### VARIABLES #####
#---- CONSTANTS -----
const TB_ROTATING_SPATIAL_MAPPER := [["rotation_speed", "_rotation_speed"]]  # mapper for TrenchBroom parameters
#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PRIVATE ====
var _rotation_speed := Vector3.ZERO


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	_rotate_spatial(delta)


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_ROTATING_SPATIAL_MAPPER)


func _rotate_spatial(delta: float) -> void:
	rotate_x(_rotation_speed.x * delta)
	rotate_y(_rotation_speed.y * delta)
	rotate_z(_rotation_speed.z * delta)
