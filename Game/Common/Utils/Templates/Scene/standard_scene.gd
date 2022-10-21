extends Node
class_name StandardScene
# A standard template for scenes, should be the root of the scene

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const END_LEVEL_PATH := "res://Game/Common/Menus/EndLevel/end_level_ui.tscn"
const PAUSE_MENU_PATH := "res://Game/Common/Menus/PauseMenu/pause_menu.tscn"

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
var _pause_menu  # instance of the pause menu
var _end_level_ui  # instance of the end level ui


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
	SignalManager.emit_start_level_chronometer()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	_manage_inputs()


##### PROTECTED METHODS #####
func _manage_inputs() -> void:
	if Input.is_action_just_pressed("restart"):
		_restart()
	elif Input.is_action_just_pressed("restart_last_cp"):
		_on_respawn_player_on_last_cp()


func _init_pause() -> void:
	_pause_menu = load(PAUSE_MENU_PATH).instance()
	add_child(_pause_menu)


func _init_end_level() -> void:
	_end_level_ui = load(END_LEVEL_PATH).instance()
	add_child(_end_level_ui)


func _init_song() -> void:
	# init song
	if null != PATHS.bgm.path and PATHS.bgm.path != "":
		_change_song_anim(PATHS.bgm.animation)


# Connects the autoload signals on init
func _connect_autoload_signals() -> void:
	if SignalManager.connect("checkpoint_triggered", self, "_on_checkpoint_triggered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% ["body_exited", "_on_body_exited", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if (
		SignalManager.connect("respawn_player_on_last_cp", self, "_on_respawn_player_on_last_cp")
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
	StandardSongManager.add_to_queue(song_instance, effect)


##### SIGNAL MANAGEMENT #####
func _on_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	_last_cp = checkpoint


func _on_respawn_player_on_last_cp() -> void:
	if _last_cp != null:
		var player = get_node_or_null(PATHS.player)
		if player != null:
			player.transform.origin = _last_cp.get_spawn_point()
			player.rotation_degrees.y = _last_cp.get_spawn_rotation()
			player.vel = Vector3()
			if _last_cp.is_in_group("start_point"):  # if restart at the beginning of the level, restart the chronometer
				SignalManager.emit_start_level_chronometer()
				if null != PATHS.bgm.path and PATHS.bgm.path != "":
					_change_song_anim(PATHS.bgm.animation)
			elif null != PATHS.bgm.path and PATHS.bgm.path != "":
				_change_song_anim(_last_cp.song_animation)
		else:
			Logger.error("Player is null at %s" % DebugUtils.print_stack_trace(get_stack()))
	else:
		Logger.error("_last_cp is null at %s" % DebugUtils.print_stack_trace(get_stack()))
