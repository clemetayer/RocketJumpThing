extends CanvasLayer
# The loading screen

##### SIGNALS #####
#warning-ignore:UNUSED_SIGNAL
signal appear_finished # for when the loading screen is fully visible
#warning-ignore:UNUSED_SIGNAL
signal disappear_finished # for when the loading screen is fully hidden

##### VARIABLES #####
#---- CONSTANTS -----
const APPEAR_FINISHED_SIGNAL_NAME := "appear_finished"
const DISAPPEAR_FINISHED_SIGNAL_NAME := "disappear_finished"
const APPEAR_ANIM_NAME := "appear"
const DISAPPEAR_ANIM_NAME := "disappear"

#---- EXPORTS -----
export(String) var LEVEL_NAME := "You forgot to add the level name, dumdum."

#---- STANDARD -----
#==== PRIVATE ====
var _loading_screen_active := false # indicates if the loading screen is showing (pretty much)

#==== ONREADY ====
onready var onready_paths := {
	"loading_screen_ui": $"LoadingScreenUI",
	"level_name_label": $"LoadingScreenUI/CenterContainer/VBoxContainer/Label",
	"animation_player":$"LoadingScreenUI/AnimationPlayer"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_hide_loading_screen()
	_set_level_name(LEVEL_NAME)

##### PUBLIC METHODS #####
# makes the loading screen appear
func appear() -> void:
	_set_level_name(LEVEL_NAME)
	onready_paths.animation_player.play(APPEAR_ANIM_NAME)

# makes the loading screen disappear
func disappear() -> void:
	onready_paths.animation_player.play(DISAPPEAR_ANIM_NAME)

func set_loading_screen_active(active : bool) -> void:
	_loading_screen_active = active

func get_loading_screen_active() -> bool:
	return _loading_screen_active

##### PROTECTED METHODS #####
func _hide_loading_screen() -> void:
	onready_paths.loading_screen_ui.visible = false

func _connect_signals() -> void:
	DebugUtils.log_connect(onready_paths.animation_player,self,"animation_finished","_on_AnimationPlayer_animation_finished")

func _set_level_name(level_name : String) -> void:
	onready_paths.level_name_label.set_text(level_name)

##### SIGNAL MANAGEMENT #####
func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	match anim_name:
		APPEAR_ANIM_NAME:
			emit_signal(APPEAR_FINISHED_SIGNAL_NAME)
		DISAPPEAR_ANIM_NAME:
			emit_signal(DISAPPEAR_FINISHED_SIGNAL_NAME)
