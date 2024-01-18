extends Area
class_name Checkpoint
# Checkpoint to respawn after a death

##### VARIABLES #####
#---- CONSTANTS -----
const TB_CHECKPOINT_MAPPER := [["spawn_position", "_spawn_position"], ["mangle", "_mangle"]]  # mapper for TrenchBroom parameters
const ENTERED_SOUND_PATH := "res://Misc/Audio/FX/Checkpoint/checkpoint.wav"
const ENTERED_SOUND_VOLUME_DB := 13.0

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
var slide_enabled : bool
var rockets_enabled : bool

#==== PRIVATE ====
var _spawn_position: Vector3
var _mangle: Vector3  # rotation angles, in degrees
var _entered_sound : AudioStreamPlayer
var _test_mode := false # a bit hacky, but it helps to avoid trying a non existent current scene and crashing the test


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	_init_entered_sound()
	_init_slide_rockets()


##### PUBLIC METHODS #####
func get_checkpoint() -> Checkpoint:
	return self


func get_spawn_point() -> Vector3:
	if is_inside_tree():
		if _spawn_position != null and _spawn_position != Vector3(0, 0, 0):
			return global_transform.origin + _spawn_position
		return global_transform.origin
	return Vector3.ZERO


func get_spawn_rotation() -> Vector3:
	if _mangle != null:
		return _mangle
	return Vector3.ZERO


##### PROTECTED METHODS #####
func _init_slide_rockets() -> void:
	var scene = ScenesManager.get_current()
	if is_instance_valid(scene) and not _test_mode:
		slide_enabled = scene.ENABLE_SLIDE
		rockets_enabled = scene.ENABLE_ROCKETS

func _play_entered_sound() -> void:
	_entered_sound.play()

func _init_entered_sound() -> void:
	var sound = AudioStreamPlayer.new()
	sound.stream = load(ENTERED_SOUND_PATH)
	sound.bus = GlobalConstants.EFFECTS_BUS
	sound.volume_db = ENTERED_SOUND_VOLUME_DB
	add_child(sound)
	_entered_sound = sound

func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_CHECKPOINT_MAPPER)


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_Checkpoint_body_entered")


##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_Checkpoint_body_entered(body: Node):
	if FunctionUtils.is_player(body):
		SignalManager.emit_checkpoint_triggered(self)
		_play_entered_sound()
		slide_enabled = body.SLIDE_ENABLED
		rockets_enabled = body.ROCKETS_ENABLED
