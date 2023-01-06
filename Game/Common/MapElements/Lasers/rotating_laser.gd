extends Spatial
# A mix between a laser and a rotating spatial node

##### VARIABLES #####
#---- CONSTANTS -----
const LASER_SCENE_PATH := "res://Game/Common/MapElements/Lasers/laser.tscn"

#---- EXPORTS -----
export(Dictionary) var properties


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_rotating_laser()


##### PROTECTED METHODS #####
func _init_rotating_laser() -> void:
	var rotating_spatial := RotatingSpatial.new()
	rotating_spatial.properties = properties
	var laser = load(LASER_SCENE_PATH).instance()
	laser.properties = properties
	rotating_spatial.add_child(laser)
	add_child(rotating_spatial)
