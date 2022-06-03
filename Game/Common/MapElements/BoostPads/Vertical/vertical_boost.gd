tool
extends Area
class_name VerticalBoost
# Base class for any vertical boost area

##### VARIABLES #####
#---- CONSTANTS -----
var NODE_PATHS = {"collision": null}  # to complete in subclasses (written as a var just to be accessible for the subclass, but expected as a const)
const TIMER_TIMEOUT = 0.05  # timeout time before adding a new push vector to the player

#---- EXPORTS -----
export(Dictionary) var properties

#==== PRIVATE ====
var _player_body: Player = null  # keeps an instance of the player's body
var _force := 1.0  # how much the player will be pushed
var _angle := Vector3(0, 0, 0)  # rotation of the bumper (in degrees)
var _size := Vector3(1, 1, 1)  # size of the bumper

#==== ONREADY ====
onready var onready_timer := Timer.new()  # timer for adding push vectors to the player (to avoid using _process to much)


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
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	FunctionUtils.log_connect(self, self, "body_exited", "_on_body_exited")


# ready function to override if necessary
func _ready_func() -> void:
	add_child(onready_timer)
	onready_timer.wait_time = TIMER_TIMEOUT
	FunctionUtils.log_connect(onready_timer, self, "timeout", "_on_timer_timeout")
	_set_TB_params()
	_duplicate_common_elements()
	rotation_degrees = _angle
	_set_extents()


func _set_TB_params() -> void:
	if "angle" in properties:
		_angle = properties["angle"]
	if "force" in properties:
		_force = properties["force"]
	if "size" in properties:
		_size = properties["size"]


# makes some elements unique to avoid modifying other boosts (for example the collision shape)
func _duplicate_common_elements() -> void:
	get_node(NODE_PATHS.collision).shape = get_node(NODE_PATHS.collision).shape.duplicate()


# sets the extents of the different boxes used (particle boxes, collision, etc.)
func _set_extents() -> void:
	get_node(NODE_PATHS.collision).shape.extents = _size


##### SIGNAL MANAGEMENT #####
func _on_timer_timeout() -> void:
	if _player_body != null:
		var vect = (to_global(Vector3.UP) - to_global(Vector3.ZERO)).normalized()  # Up vector converted to the global transform and normalized
		_player_body.add_velocity_vector(vect * _force)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_body = body
		_on_timer_timeout()
		onready_timer.start()


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_body = null
		onready_timer.stop()
