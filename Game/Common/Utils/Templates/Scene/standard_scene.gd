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
export(Dictionary) var PATHS = {"bgm": {"path": "", "animation": ""}}  # various paths for the scene
export(bool) var ENABLE_ROCKETS = true
export(bool) var ENABLE_SLIDE = true
export(GradientTexture) var PLAYER_SLIDE_TEXTURE
export(String) var NEXT_SCENE_PATH = null

#---- STANDARD -----
#==== PRIVATE =====
var _last_cp: Checkpoint
var _pause_menu  # instance of the pause menu
var _end_level_ui  # instance of the end level ui
var _player: Node  # player node
var _start_point: Node  # start point


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_init_func()


# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_func()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	_manage_inputs()


##### PUBLIC METHODS #####
func get_player() -> Node:
	return _player


##### PROTECTED METHODS #####
func _init_func() -> void:
	_connect_autoload_signals()


func _ready_func() -> void:
	_init_pause()
	_init_song()
	_init_node_paths()
	_init_skybox()
	_init_player_slide_texture()
	_last_cp = _start_point
	_player.toggle_ability(GlobalConstants.ABILITY_ROCKETS,ENABLE_ROCKETS, false)
	_player.toggle_ability(GlobalConstants.ABILITY_SLIDE,ENABLE_SLIDE, false)
	SignalManager.emit_start_level_chronometer()


func _manage_inputs() -> void:
	if Input.is_action_just_pressed(GlobalConstants.INPUT_RESTART):
		_restart()
	elif Input.is_action_just_pressed(GlobalConstants.INPUT_RESTART_LAST_CP):
		_respawn_player_on_last_cp()


func _init_pause() -> void:
	MenuNavigator.toggle_pause_enabled(true)


func _init_song() -> void:
	# init song
	if null != PATHS.bgm.path and PATHS.bgm.path != "":
		_change_song_anim(PATHS.bgm.animation)


func _init_node_paths() -> void:
	# keep an instance of player
	var player_nodes = get_tree().get_nodes_in_group(GlobalConstants.PLAYER_GROUP)
	if player_nodes != null && player_nodes.size() > 0:
		_player = player_nodes[0]
	# keep an instance of the start_point
	var start_points = get_tree().get_nodes_in_group(GlobalConstants.START_POINT_GROUP)
	if start_points != null && start_points.size() > 0:
		_start_point = start_points[0]

func _init_skybox() -> void:
	var skyboxes = get_tree().get_nodes_in_group(GlobalConstants.SKYBOX_GROUP)
	if skyboxes != null and skyboxes.size() > 0 and skyboxes[0] is Skybox:
		skyboxes[0].set_target(get_player())

func _init_player_slide_texture() -> void:
	get_player().set_trail_gradient_texture(PLAYER_SLIDE_TEXTURE)

# Connects the autoload signals on init
func _connect_autoload_signals() -> void:
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.CHECKPOINT_TRIGGERED, "_on_checkpoint_triggered"
	)
	DebugUtils.log_connect(
		SignalManager,
		self,
		SignalManager.RESPAWN_PLAYER_ON_LAST_CP,
		"_respawn_player_on_last_cp"
	)


func _restart() -> void:
	_last_cp = _start_point
	_respawn_player_on_last_cp()


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


func _respawn_player_on_last_cp() -> void:
	if _last_cp != null:
		var player = get_player()
		if player != null:
			player.checkpoint_process(_last_cp.get_spawn_point(), _last_cp.get_spawn_rotation())
			if FunctionUtils.is_start_point(_last_cp):  # if restart at the beginning of the level, restart the chronometer
				SignalManager.emit_start_level_chronometer()
			SignalManager.emit_player_respawned_on_last_cp()
		else:
			DebugUtils.log_stacktrace("Player is null", DebugUtils.LOG_LEVEL.error)
	else:
		DebugUtils.log_stacktrace("_last_cp is null", DebugUtils.LOG_LEVEL.error)
