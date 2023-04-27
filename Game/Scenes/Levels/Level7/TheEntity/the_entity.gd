tool
extends Spatial
# The big bad spooky entity

##### VARIABLES #####
#---- CONSTANTS -----
const APPEAR_ANIM := "appear"
const DISAPPEAR_ANIM := "disappear"

#==== PRIVATE ====
var _player : KinematicBody

#==== ONREADY ====
onready var onready_paths := {
	"eye":$Eye,
	"animation_player":$AnimationPlayer
}

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if(_get_player() != null and onready_paths.eye != null):
		onready_paths.eye.look_at(_get_player().global_transform.origin, Vector3.UP)

##### PUBLIC METHODS #####
# triggers the appear animation
func appear() -> void:
	onready_paths.animation_player.play(APPEAR_ANIM)

# triggers the disappear animation
func disappear() -> void:
	onready_paths.animation_player.play(DISAPPEAR_ANIM)

##### PROTECTED METHODS #####
func _get_player() -> KinematicBody:
	if _player == null:
		_player = get_tree().get_nodes_in_group(GlobalConstants.PLAYER_GROUP)[0]
	return _player
