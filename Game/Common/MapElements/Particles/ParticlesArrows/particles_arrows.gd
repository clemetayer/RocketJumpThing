# tool
extends Particles
# class_name Class
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const TB_PARTICLES_ARROWS_MAPPER := [["mangle", "_mangle"], ["size", "_size"], ["gradient_path", "_gradient_path"], ["velocity", "_velocity"]]  # mapper for TrenchBroom parameters
const ORIGINAL_VISIBILITY_AABB := AABB(
	Vector3(-6.645,-1.989,-1.95),
	Vector3(8.604,3.964,3.888)
)
const ORIGINAL_AMOUNT := 10

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _mangle := Vector3.ZERO  # trenchbroom angles
var _size := Vector3.ONE # size of the particles 
var _gradient_path : String # particles gradient path
var _velocity := 1 # velocity of the arrows. Also used to set the direction of the arrows

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	visibility_aabb.size = ORIGINAL_VISIBILITY_AABB.size * _size
	amount = int(ORIGINAL_AMOUNT * _size.length()) 
	_mangle.y += 90 # adds a 90° rotation since the particles are moving towards the -x axis
	rotation_degrees = _mangle
	process_material.initial_velocity *= _velocity
	process_material.color_ramp = load(_gradient_path)
	process_material.emission_box_extents = _size


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_PARTICLES_ARROWS_MAPPER)

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
