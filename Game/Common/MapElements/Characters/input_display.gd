extends CanvasLayer
# An interface to display inputs. Mostly used to record gameplay tutorial videos

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
onready var onready_paths := {
	"directions": {
		"up": $"Control/Directions/Directions/UpButton",
		"left": $"Control/Directions/Directions/LeftRight/LeftButton",
		"right": $"Control/Directions/Directions/LeftRight/RightButton",
		"down": $"Control/Directions/Directions/DownButton"
	},
	"slide": $"Control/OtherKeys/SlideKey",
	"jump": $"Control/OtherKeys/JumpKey",
	"rocket": $"Control/OtherKeys/RocketKey"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.directions.left.set_rotation_degrees(-90)
	onready_paths.directions.right.set_rotation_degrees(90)
	onready_paths.directions.left.set_rotation_degrees(180)
	onready_paths.slide.rect_scale = Vector2.ONE * 0.5
	onready_paths.rocket.rect_scale = Vector2.ONE * 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	onready_paths.directions.up.self_modulate.a = 1 if Input.is_action_pressed(GlobalConstants.INPUT_MVT_FORWARD) else 0 
	onready_paths.directions.left.self_modulate.a = 1 if Input.is_action_pressed(GlobalConstants.INPUT_MVT_LEFT) else 0
	onready_paths.directions.right.self_modulate.a = 1 if Input.is_action_pressed(GlobalConstants.INPUT_MVT_RIGHT) else 0
	onready_paths.directions.down.self_modulate.a = 1 if Input.is_action_pressed(GlobalConstants.INPUT_MVT_BACKWARD) else 0
	onready_paths.slide.self_modulate.a = 1 if Input.is_action_pressed(GlobalConstants.INPUT_MVT_SLIDE) else 0
	onready_paths.jump.modulate.a = 1 if Input.is_action_pressed(GlobalConstants.INPUT_MVT_JUMP) else 0
	onready_paths.rocket.self_modulate.a = 1 if Input.is_action_pressed(GlobalConstants.INPUT_ACTION_SHOOT) else 0

##### PUBLIC METHODS #####
# Methods that are intended to be "self_modulate.a" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
