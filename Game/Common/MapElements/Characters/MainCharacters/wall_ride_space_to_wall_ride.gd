extends WallRideStrategy
# Implementation of the wall ride strategy, when the opiton "space to wall ride is active"

##### VARIABLES #####
#---- CONSTANTS -----
const TEST_CLASS_NAME := "space to wall ride"  # for test purposes

#---- STANDARD -----
#==== PRIVATE ====
var _ready_to_wall_jump := false  # used to determine if the player should wall jump. When pressing space once, it should wall ride, twice, it should wall jump (given it still is wall riding)
var _wall_ride := false  # indicator that a player can wall ride based on the inputs


##### PUBLIC METHODS #####
# process input for the standard wall ride
func process_input() -> void:
	if Input.is_action_just_released(GlobalConstants.INPUT_MVT_JUMP) and wall_riding:
		_ready_to_wall_jump = true
	elif Input.is_action_just_released(GlobalConstants.INPUT_MVT_JUMP) and _ready_to_wall_jump:
		_ready_to_wall_jump = false


# if the player should wall ride
func can_wall_ride(is_on_floor: bool, RC_wall_direction: int, wall_ride_lock: bool) -> bool:
	return (
		(Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP) or wall_riding)
		and not is_on_floor
		and RC_wall_direction != 0
		and not wall_ride_lock
	)


# if the player should wall jump. Otherwise, it should wall ride
func should_wall_jump() -> bool:
	return _ready_to_wall_jump and Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP)


# If the wall ride state should be exited (used to manage the states)
func wall_ride_exited(is_on_floor: bool, RC_wall_direction: int) -> bool:
	return is_on_floor or RC_wall_direction == 0
