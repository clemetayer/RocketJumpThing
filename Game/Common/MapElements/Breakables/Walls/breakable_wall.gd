extends RigidBody
# A wall that is breakable depending on the signal that is given on trigger-use

# FIXME : Actual advantage of using a rigisbody for character controler, as it provides better collision support
# OPTIMIZATION : Split the wall procedurally at runtime for general memory optimization

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED_DIVIDER := .055  # Speed divider to prevent the wall from exploding too much, or not enough # TODO : Why.
const TB_BREAKABLE_WALL_MAPPER := [
	["collision_layer", "collision_layer"], ["collision_layer", "collision_mask"]
]  # mapper for TrenchBroom parameters
#---- EXPORTS -----
export(Dictionary) var properties


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	_init_body()


##### PROTECTED METHODS #####


func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_BREAKABLE_WALL_MAPPER)


func _init_body() -> void:
	weight = 100
	mode = MODE_STATIC
	set_use_continuous_collision_detection(true)


##### SIGNAL MANAGEMENT #####
#==== Qodot =====
func use(parameters: Dictionary) -> void:
	mode = MODE_RIGID
	apply_central_impulse(
		(
			(self.transform.origin - parameters.position).normalized()
			* parameters.speed
			/ SPEED_DIVIDER
		)
	)
	if get_tree() != null:  # for test purposes
		yield(get_tree().create_timer(30.0), "timeout")  # REFACTOR : magic float here
	queue_free()
