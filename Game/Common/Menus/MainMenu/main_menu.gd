extends Spatial
# Main menu script

##### VARIABLES #####
#---- CONSTANTS -----
const MAIN_MENU_SONG_PATH := "res://Game/Common/Songs/MainMenu/main_menu.tscn"
const MAIN_MENU_ANIM_NAME := "main_menu"
const MAIN_MENU_STEP_SIGNAL_ON := "main_menu_particles_on"
const MAIN_MENU_STEP_SIGNAL_OFF := "main_menu_particles_off"

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"background":$"MainMenuBackground"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	MenuNavigator.toggle_pause_enabled(false)
	MenuNavigator.show_main_menu()
	_load_main_menu_song()
	_connect_signals()
	if onready_paths.background != null:
		onready_paths.background.toggle_particles(false)

##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(SignalManager, self, SignalManager.SEQUENCER_STEP, "_on_SignalManager_sequencer_step")

func _load_main_menu_song() -> void:
	var song_instance = load(MAIN_MENU_SONG_PATH).instance()
	song_instance.ANIMATION = MAIN_MENU_ANIM_NAME
	var effect = VolumeEffectManager.new()
	effect.TIME = 1.0
	StandardSongManager.add_to_queue(song_instance, effect)

##### SIGNAL MANAGEMENT #####
func _on_SignalManager_sequencer_step(step : String) -> void:
	match step:
		MAIN_MENU_STEP_SIGNAL_ON:
			onready_paths.background.toggle_particles(true)
		MAIN_MENU_STEP_SIGNAL_OFF:
			onready_paths.background.toggle_particles(false)
