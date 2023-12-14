extends Area
class_name VerticalBoost
# Base class for any vertical boost area

##### VARIABLES #####
#---- CONSTANTS -----
const TB_VBOOST_MAPPER := [["mangle", "_mangle"], ["force", "_force"], ["size", "_size"]]  # mapper for TrenchBroom parameters
const TIMER_TIMEOUT := 0.05  # timeout time before adding a new push vector to the player
const ROCKET_POWER_MULTIPLIER := 2.0  # boost multiplier when a rocket enters this area
const ROCKET_BOOST_DECAY := 0.75  # how long the boost will fade back to a normal value (Note : should be <= to the rocket shoot timeout to avoid adding power indefinitely)
#---- EXPORTS -----
export(Dictionary) var properties

#==== PRIVATE ====
var _player_body = null  # keeps an instance of the player's body
var _force := 1.0  # how much the player will be pushed
var _mangle := Vector3(0, 0, 0)  # rotation of the bumper (in degrees)
var _size := Vector3(1, 1, 1)  # size of the bumper
var _boost_multiplier := 1.0  # boost multiplier

#==== ONREADY ====
onready var onready_rocket_tween := Tween.new()  # tween for the boost bonus when a rocket enters the area


##### PROTECTED METHODS #####
# ready function to override if necessary
func _ready_func() -> void:
	_connect_signals()  # exceptionnaly in the ready func, for onready in children
	add_child(onready_rocket_tween)
	_set_TB_params()
	rotation_degrees += _mangle  # Used += to make it face the z axis
	_set_extents()


func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_VBOOST_MAPPER)


# sets the extents of the different boxes used (particle boxes, collision, etc.)
func _set_extents() -> void:
	_get_collision().shape.extents = _size


# An utility func to get the collision node in children classes
func _get_collision() -> Node:
	return null


# sets the properties of the tween when a rocket interacts with the area
func _set_rocket_tween_properties() -> void:
	var mult_boost = _boost_multiplier * ROCKET_POWER_MULTIPLIER
	DebugUtils.log_tween_interpolate_property(
		onready_rocket_tween, self, "_boost_multiplier", mult_boost, 1.0, ROCKET_BOOST_DECAY
	)


##### SIGNAL MANAGEMENT #####
func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	DebugUtils.log_connect(self, self, "area_entered", "_on_area_entered")


func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_player(body):
		var vect = (to_global(Vector3.UP) - to_global(Vector3.ZERO)).normalized()  # Up vector converted to the global transform and normalized
		body.override_velocity_vector(vect * _force * _boost_multiplier)
		body.set_velocity_lock(true)


func _on_area_entered(area: Node) -> void:
	if FunctionUtils.is_rocket(area):
		area.remove()
		DebugUtils.log_tween_stop_all(onready_rocket_tween)
		_set_rocket_tween_properties()
		DebugUtils.log_tween_start(onready_rocket_tween)
