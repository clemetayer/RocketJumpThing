extends WallRideStrategy
# Implementation of the wall ride strategy, when the opiton "space to wall ride is active"

##### VARIABLES #####
#---- CONSTANTS -----
const TEST_CLASS_NAME := "space to wall ride"  # for test purposes
const WALL_JUMP_TIMER := 0.5  # in seconds. Time allowed to press jump again for a wall jump

#---- STANDARD -----
#==== PRIVATE ====
var _wall_jump_trigger_active := false  # if the
var _wall_jump_timer: Timer


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_wall_jump_timer = Timer.new()
	add_child(_wall_jump_timer)
	DebugUtils.log_connect(_wall_jump_timer, self, "timeout", "_on_WallJumpTimer_timeout")


##### PUBLIC METHODS #####
# process input for the standard wall ride
func process_input() -> void:
	pass


# if the player should wall ride
func can_wall_ride(is_on_floor: bool, RC_wall_direction: int, wall_ride_lock: bool) -> bool:
	return (
		not is_on_floor
		and Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP)
		and RC_wall_direction != 0
		and not wall_ride_lock
	)


# if the player should wall jump. Otherwise, it should wall ride
func should_wall_jump() -> bool:
	return _wall_jump_trigger_active and Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP)


# If the wall ride state should be exited (used to manage the states)
func wall_ride_exited(is_on_floor: bool, RC_wall_direction: int) -> bool:
	if (
		not Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP)
		or is_on_floor
		or RC_wall_direction == 0
	):
		_wall_jump_trigger_active = true
		_wall_jump_timer.start(WALL_JUMP_TIMER)
		return true
	return false


##### SIGNAL MANAGEMENT #####
func _on_WallJumpTimer_timeout() -> void:
	_wall_jump_trigger_active = false
