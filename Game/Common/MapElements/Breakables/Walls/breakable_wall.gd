extends RigidBody
# A wall that is breakable depending on the signal that is given on trigger-use

# FIXME : Actual advantage of using a rigisbody for character controler, as it provides better collision support
# OPTIMIZATION : Split the wall procedurally at runtime for general memory optimization

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED_DIVIDER := .055  # Speed divider to prevent the wall from exploding too much, or not enough # TODO : Why.
#---- EXPORTS -----
export(Dictionary) var properties setget set_properties


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_body()


##### PROTECTED METHODS #####
#==== Qodot =====
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if "collision_layer" in properties and is_inside_tree():
		self.collision_layer = properties.collision_layer
	if "collision_mask" in properties and is_inside_tree():
		self.collision_mask = properties.collision_mask


#==== Other things =====
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
