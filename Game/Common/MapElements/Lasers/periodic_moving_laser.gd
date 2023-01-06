extends Spatial
# A mix between a laser and a periodic moving spatial node

##### VARIABLES #####
#---- CONSTANTS -----
const LASER_SCENE_PATH := "res://Game/Common/MapElements/Lasers/laser.tscn"

#---- EXPORTS -----
export(Dictionary) var properties


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_periodic_moving_laser()


##### PROTECTED METHODS #####
func _init_periodic_moving_laser() -> void:
	var periodic_moving_spatial := PeriodicMovingSpatial.new()
	periodic_moving_spatial.properties = properties
	var laser = load(LASER_SCENE_PATH).instance()
	laser.properties = properties
	periodic_moving_spatial.add_child(laser)
	add_child(periodic_moving_spatial)
