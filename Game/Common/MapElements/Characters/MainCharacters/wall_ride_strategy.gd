extends Node
class_name WallRideStrategy
# Kind of an interface to implement a strategy design pattern to decide of the wall ride process
# Note : this won't handle the physics of the wall ride, it is only used to determine if the player should wall ride based on the context

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var wall_riding := false  # if the player is currently wall riding

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PUBLIC METHODS #####
# process input for the standard wall ride
# SHOULD BE OVERRIDEN BY CHILDREN CLASSES
func process_input() -> void:
	pass


# if the player should wall ride
# SHOULD BE OVERRIDEN BY CHILDREN CLASSES
func can_wall_ride(_is_on_floor: bool, _RC_wall_direction: int, _wall_ride_lock: bool) -> bool:
	return false


# if the player should wall jump. Otherwise, it should wall ride
# SHOULD BE OVERRIDEN BY CHILDREN CLASSES
func should_wall_jump() -> bool:
	return false


# If the wall ride state should be exited (used to manage the states)
# SHOULD BE OVERRIDEN BY CHILDREN CLASSES
func wall_ride_exited(_is_on_floor: bool, _RC_wall_direction: int) -> bool:
	return false
