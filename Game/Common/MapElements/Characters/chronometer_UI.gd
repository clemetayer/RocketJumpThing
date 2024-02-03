extends CanvasLayer
# Script to control the chronometer of the scene

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _last_time := 0.0  # in milliseconds
var _timer_stopped := false

#==== ONREADY ====
onready var onready_paths := {"rich_text_label": $"Background/CenterContainer/RichTextLabel"}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	_update_timer(delta)


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager,
		self,
		SignalManager.START_LEVEL_CHRONOMETER,
		"_on_SignalManager_start_level_chronometer"
	)
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.END_REACHED, "_on_SignalManager_end_reached"
	)
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.GAME_OVER, "_on_SignalManager_game_over"
	)


func _update_timer(delta: float) -> void:
	if !_timer_stopped:
		_last_time += delta * 1000
		var millis = fmod(_last_time, 1000)
		var seconds = floor(fmod(_last_time / 1000, 60))
		var minutes = floor(_last_time / (1000 * 60))
		if onready_paths.rich_text_label != null:
			onready_paths.rich_text_label.set_bbcode(
				"%02d : %02d : %03d" % [minutes, seconds, millis]
			)


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_start_level_chronometer() -> void:
	_last_time = 0
	_timer_stopped = false


func _on_SignalManager_end_reached() -> void:
	_timer_stopped = true
	VariableManager.chronometer.level = _last_time
	RuntimeUtils.save_level_times(VariableManager.chronometer.level)

func _on_SignalManager_game_over() -> void:
	_on_SignalManager_end_reached()
