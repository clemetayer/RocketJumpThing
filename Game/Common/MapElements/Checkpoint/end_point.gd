extends Area
# End point area of the map

##### VARIABLES #####
#---- CONSTANTS -----
const ENTERED_SOUND_PATH := "res://Misc/Audio/FX/EndPoint/end_point.wav"
const ENTERED_SOUND_VOLUME_DB := 13.0

#---- STANDARD -----
#==== PRIVATE ====
var _entered_sound: AudioStreamPlayer


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_add_to_end_point_group()
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_entered_sound()


##### PROTECTED METHODS #####
func _play_entered_sound() -> void:
	_entered_sound.play()


func _init_entered_sound() -> void:
	var sound = AudioStreamPlayer.new()
	sound.stream = load(ENTERED_SOUND_PATH)
	sound.bus = GlobalConstants.EFFECTS_BUS
	sound.volume_db = ENTERED_SOUND_VOLUME_DB
	add_child(sound)
	sound.pause_mode = PAUSE_MODE_PROCESS
	_entered_sound = sound


func _save_level_data() -> void:
	RuntimeUtils.save_level_times(VariableManager.chronometer.level)
	ScenesManager.enable_next_level()


# adds the end point to the end_point group
func _add_to_end_point_group() -> void:
	add_to_group("end_point")


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_EndPoint_body_entered")


func _is_best_time(level_data: LevelData) -> bool:
	if level_data != null:
		return (
			VariableManager.chronometer.level < level_data.BEST_TIME or level_data.BEST_TIME == 0.0
		)
	DebugUtils.log_stacktrace("Level data is null", DebugUtils.LOG_LEVEL.warn)
	return false


##### SIGNAL MANAGEMENT #####
func _on_EndPoint_body_entered(body: Node):
	if FunctionUtils.is_player(body):
		SignalManager.emit_end_reached()
		_play_entered_sound()
		_save_level_data()
		SignalManager.emit_levels_data_updated()
		VariableManager.scene_unloading = true
