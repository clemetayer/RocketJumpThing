extends CanvasLayer
# Toggles an effect that applies to the global screen

##### ENUMS #####
enum EFFECTS { glitch }

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"glitch": $"GlitchEffect"}


##### PUBLIC METHODS #####
func toggle_effect(effect: int, active: bool):
	match effect:
		EFFECTS.glitch:
			onready_paths.glitch.visible = active
