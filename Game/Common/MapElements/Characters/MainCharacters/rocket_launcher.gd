extends MeshInstance
# Rocket launcher script

##### VARIABLES #####
#---- CONSTANTS -----
const FIRE_ANIM_NAME := "fire"

#==== ONREADY ====
onready var onready_paths = {
	"animation_player":$"AnimationPlayer"
}

##### PUBLIC METHODS #####
func fire() -> void:
	onready_paths.animation_player.play(FIRE_ANIM_NAME)
