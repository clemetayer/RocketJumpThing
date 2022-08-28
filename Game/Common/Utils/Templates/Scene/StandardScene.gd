extends Node
class_name StandardScene
# A standard template for scenes, should be the root of the scene

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS ----
export(Dictionary) var PATHS = {  # various paths for the scene
	"player": NodePath(),
	"start_point": NodePath(),
	"end_level_ui": "res://Game/Common/Menus/EndLevel/end_level_ui.tscn",
	"bgm": {"path": "", "animation": ""}
}
export(bool) var ENABLE_ROCKETS = true
export(bool) var ENABLE_SLIDE = true
export(String) var NEXT_SCENE_PATH = null

#---- STANDARD -----
#==== PRIVATE =====
var _last_cp: Checkpoint

#==== ONREADY ====
# onready var onready_var # Optionnal comment

#==== TESTING =====
var signal_manager = SignalManager  # variable used to mock the signal manager for the tests
var variable_manager = VariableManager  # variable used to mock the variable manager for the tests
var song_manager = StandardSongManager  # variable used to mock the standard song manager for the tests


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_autoload_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_pause()
	_init_end_level()
	_init_song()
	_last_cp = get_node(PATHS.start_point).get_checkpoint()
	get_node(PATHS.player).ROCKETS_ENABLED = ENABLE_ROCKETS
	get_node(PATHS.player).SLIDE_ENABLED = ENABLE_SLIDE
	signal_manager.emit_start_level_chronometer()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		_restart()
	elif Input.is_action_just_pressed("restart_last_cp"):
		_on_respawn_player_on_last_cp()


##### PROTECTED METHODS #####
func _init_pause() -> void:
	PauseMenu.ENABLED = true
	variable_manager.pause_enabled = true


func _init_end_level() -> void:
	variable_manager.end_level_enabled = true
	# init end level ui
	if NEXT_SCENE_PATH != null:
		EndLevelUi.set_next_scene(NEXT_SCENE_PATH)


func _init_song() -> void:
	# init song
	if null != PATHS.bgm.path and PATHS.bgm.path != "":
		_change_song_anim(PATHS.bgm.animation)


# Connects the autoload signals on init
func _connect_autoload_signals() -> void:
	if signal_manager.connect("checkpoint_triggered", self, "_on_checkpoint_triggered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% ["body_exited", "_on_body_exited", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if (
		signal_manager.connect("respawn_player_on_last_cp", self, "_on_respawn_player_on_last_cp")
		!= OK
	):
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% ["body_exited", "_on_body_exited", DebugUtils.print_stack_trace(get_stack())]
			)
		)


func _restart() -> void:
	_last_cp = get_node(PATHS.start_point).get_checkpoint()
	_on_respawn_player_on_last_cp()


# changes the scene song animation
func _change_song_anim(anim_name: String) -> void:
	var song_instance = load(PATHS.bgm.path).instance()
	song_instance.ANIMATION = anim_name
	var effect = VolumeEffectManager.new()
	effect.TIME = 1.0
	song_manager.add_to_queue(song_instance, effect)


##### SIGNAL MANAGEMENT #####
func _on_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	_last_cp = checkpoint


func _on_respawn_player_on_last_cp() -> void:
	if _last_cp != null:
		var player: Player = get_node_or_null(PATHS.player)
		if player != null:
			player.transform.origin = _last_cp.get_spawn_point()
			player.rotation_degrees.y = _last_cp.get_spawn_rotation()
			player.vel = Vector3()
			if _last_cp is StartPoint:  # if restart at the beginning of the level, restart the chronometer
				signal_manager.emit_start_level_chronometer()
				if null != PATHS.bgm.path and PATHS.bgm.path != "":
					_change_song_anim(PATHS.bgm.animation)
			elif null != PATHS.bgm.path and PATHS.bgm.path != "":
				_change_song_anim(_last_cp.song_animation)
		else:
			pass  # TODO : log here
