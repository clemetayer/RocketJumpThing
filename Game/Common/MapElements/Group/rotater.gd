extends Spatial
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
func _physics_process(delta):
	_rotate_spatial(delta)


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_ROTATING_SPATIAL_MAPPER)


func _rotate_spatial(delta: float) -> void:
	rotation += _rotation_speed * delta
