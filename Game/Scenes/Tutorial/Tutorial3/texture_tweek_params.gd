extends Node
# tweeks the parameters of some materials to render better

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_POS_SHADER_PARAM := "target_pos"

#---- EXPORTS -----
export(Array, Material) var SET_PLAYER_POS

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass


##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass


##### PROTECTED METHODS #####
func _set_player_pos_params() -> void:
	var player = ScenesManager.get_current().get_player()
	if player != null:
		for material in SET_PLAYER_POS:
			material.set_shader_param(PLAYER_POS_SHADER_PARAM, player.global_transform.origin)


##### SIGNAL MANAGEMENT #####
func _on_UpdateTextures_timeout():
	_set_player_pos_params()
