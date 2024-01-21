extends WallRideStrategy
# Standard wall ride, by using the slide button

##### VARIABLES #####
#---- CONSTANTS -----
const TEST_CLASS_NAME := "standard"  # for test purposes

#---- STANDARD -----
#==== PRIVATE ====
var _wall_ride = false  # indicator that a player can wall ride based on the inputs


##### PUBLIC METHODS #####
# process input for the standard wall ride
func process_input() -> void:
	if Input.is_action_just_pressed(GlobalConstants.INPUT_MVT_SLIDE):
		_wall_ride = true
	elif Input.is_action_just_released(GlobalConstants.INPUT_MVT_SLIDE):
		_wall_ride = false


# if the player should wall ride
func can_wall_ride(is_on_floor: bool, RC_wall_direction: int, wall_ride_lock: bool) -> bool:
	return not is_on_floor and _wall_ride and RC_wall_direction != 0 and not wall_ride_lock


# if the player should wall jump. Otherwise, it should wall ride
func should_wall_jump() -> bool:
	return wall_riding and Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP)


# If the wall ride state should be exited (used to manage the states)
func wall_ride_exited(is_on_floor: bool, RC_wall_direction: int) -> bool:
	return (
		not Input.is_action_pressed(GlobalConstants.INPUT_MVT_SLIDE)
		or is_on_floor
		or RC_wall_direction == 0
	)
