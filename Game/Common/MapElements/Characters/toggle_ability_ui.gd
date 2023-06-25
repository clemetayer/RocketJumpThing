extends CanvasLayer
# Animations to trigger when toggling abilities

##### VARIABLES #####
#---- CONSTANTS -----
const ROCKET_ON_ANIM_NAME := "rocket_on"
const ROCKET_OFF_ANIM_NAME := "rocket_off"
const SLIDE_ON_ANIM_NAME := "slide_on"
const SLIDE_OFF_ANIM_NAME := "slide_off"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"animation_player":$"AnimationPlayer"
}


##### PUBLIC METHODS #####
# plays the enable/disable animation
func toggle_rocket(enabled : bool) -> void:
	if enabled:
		onready_paths.animation_player.play(ROCKET_ON_ANIM_NAME)
	else:
		onready_paths.animation_player.play(ROCKET_OFF_ANIM_NAME)

func toggle_slide(enabled : bool) -> void:
	if enabled:
		onready_paths.animation_player.play(SLIDE_ON_ANIM_NAME)
	else:
		onready_paths.animation_player.play(SLIDE_OFF_ANIM_NAME)
