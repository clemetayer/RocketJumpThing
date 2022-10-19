extends Area
class_name VerticalBoost
# Base class for any vertical boost area

##### VARIABLES #####
#---- CONSTANTS -----
var NODE_PATHS = {"collision": null}  # to complete in subclasses (written as a var just to be accessible for the subclass, but expected as a const)
const TB_VBOOST_MAPPER := [["angle", "_angle"], ["force", "_force"], ["size", "_size"]]  # mapper for TrenchBroom parameters
const TIMER_TIMEOUT := 0.05  # timeout time before adding a new push vector to the player
const ROCKET_POWER_MULTIPLIER := 2.0  # boost multiplier when a rocket enters this area
const ROCKET_BOOST_DECAY := 0.75  # how long the boost will fade back to a normal value (Note : should be <= to the rocket shoot timeout to avoid adding power indefinitely)
#---- EXPORTS -----
export(Dictionary) var properties

#==== PRIVATE ====
var _player_body: Player = null  # keeps an instance of the player's body
var _force := 1.0  # how much the player will be pushed
var _angle := Vector3(0, 0, 0)  # rotation of the bumper (in degrees)
var _size := Vector3(1, 1, 1)  # size of the bumper
var _boost_multiplier := 1.0  # boost multiplier

#==== ONREADY ====
onready var onready_rocket_tween := Tween.new()  # tween for the boost bonus when a rocket enters the area


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_init_func()


# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_func()


##### PROTECTED METHODS #####
# init function to override if necessary
func _init_func() -> void:
	_connect_signals()


# ready function to override if necessary
func _ready_func() -> void:
	add_child(onready_rocket_tween)
	_set_TB_params()
	_duplicate_common_elements()
	rotation_degrees = _angle
	_set_extents()


func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_VBOOST_MAPPER)


# makes some elements unique to avoid modifying other boosts (for example the collision shape)
func _duplicate_common_elements() -> void:
	get_node(NODE_PATHS.collision).shape = get_node(NODE_PATHS.collision).shape.duplicate()


# sets the extents of the different boxes used (particle boxes, collision, etc.)
func _set_extents() -> void:
	get_node(NODE_PATHS.collision).shape.extents = _size


# sets the properties of the tween when a rocket interacts with the area
func _set_rocket_tween_properties() -> void:
	var mult_boost = _boost_multiplier * ROCKET_POWER_MULTIPLIER
	onready_rocket_tween.interpolate_property(
		self, "_boost_multiplier", mult_boost, 1.0, ROCKET_BOOST_DECAY
	)


##### SIGNAL MANAGEMENT #####
func _connect_signals() -> void:
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	FunctionUtils.log_connect(self, self, "body_exited", "_on_body_exited")
	FunctionUtils.log_connect(self, self, "area_entered", "_on_area_entered")


func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_player(body):
		var vect = (to_global(Vector3.UP) - to_global(Vector3.ZERO)).normalized()  # Up vector converted to the global transform and normalized
		body.override_velocity_vector(vect * _force * _boost_multiplier)


func _on_area_entered(area: Node) -> void:
	if area.is_in_group("rocket"):
		area.queue_free()
		onready_rocket_tween.stop_all()
		_set_rocket_tween_properties()
		onready_rocket_tween.start()
