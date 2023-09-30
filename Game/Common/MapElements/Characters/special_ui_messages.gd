extends CanvasLayer
# shows a special message for the player

##### VARIABLES #####
#---- CONSTANTS -----
const APPEAR_DISAPPEAR_ANIM_NAME := "appear_disappear"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths = {
	"rtl":$"CenterContainer/MarginContainer/RichTextLabel",
	"animation_player":$"AnimationPlayer"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	DebugUtils.log_connect(SignalManager, self, SignalManager.UI_MESSAGE, "_on_SignalManager_ui_message")
	visible = false

##### SIGNAL MANAGEMENT #####
func _on_SignalManager_ui_message(RTL_message) : 
	Logger.debug(RTL_message)
	onready_paths.rtl.bbcode_text = RTL_message
	onready_paths.animation_player.play(APPEAR_DISAPPEAR_ANIM_NAME)
