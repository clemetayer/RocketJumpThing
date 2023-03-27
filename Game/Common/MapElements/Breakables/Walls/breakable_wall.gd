extends RigidBody
# A wall that is breakable depending on the signal that is given on trigger-use

# FIXME : Actual advantage of using a rigisbody for character controler, as it provides better collision support
# OPTIMIZATION : Split the wall procedurally at runtime for general memory optimization

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED_DIVIDER := .055  # Speed divider to prevent the wall from exploding too much, or not enough # TODO : Why.
const TIME_TO_DISAPPEAR := 5.0  # Time it takes for the wall to disappear after breaking
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
	collision_layer = 0  # Forces the collision layer to be empty, to not make it interact with anything else than the environment
	set_collision_mask_bit(GlobalConstants.PLAYER_MASK_VALUE, 0)  # forces the body to interact with everything except the player
	apply_central_impulse(
		(
			(self.transform.origin - parameters.position).normalized()
			* parameters.speed
			/ SPEED_DIVIDER
		)
	)
	if get_tree() != null:  # for test purposes
		yield(get_tree().create_timer(TIME_TO_DISAPPEAR), "timeout")
	queue_free()
