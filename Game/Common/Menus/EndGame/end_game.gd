extends Node2D
# End game script

##### VARIABLES #####
#---- CONSTANTS -----
const SONG_PATH := "res://Game/Common/Songs/EndGame/end_game.tscn"
const SONG_ANIM := "end_game"

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if Input.is_action_pressed(GlobalConstants.INPUT_CANCEL):
		load_main_menu()

# Called when the node enters the scene tree for the first time.
func _ready():
	_stop_song()

##### PUBLIC METHODS #####
func load_main_menu() -> void:
	ScenesManager.load_main_menu()

func play_song() -> void:
	var song_instance = load(SONG_PATH).instance()
	song_instance.ANIMATION = SONG_ANIM
	StandardSongManager.add_to_queue(song_instance, InstantEffectManager.new())

##### PROTECTED METHODS #####
func _stop_song() -> void:
	StandardSongManager.stop_current(InstantEffectManager.new())
