extends CanvasLayer
# Script to control the chronometer of the scene

# TEST : Minutes > 60

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _last_time := 0
var _timer_stopped := false


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	FunctionUtils.log_connect(
		SignalManager, self, "start_level_chronometer", "_on_SignalManager_start_level_chronometer"
	)
	FunctionUtils.log_connect(SignalManager, self, "end_reached", "_on_SignalManager_end_reached")


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if !_timer_stopped:
		_last_time += delta * 1000
		var millis = _last_time % 1000
		var seconds = floor((_last_time / 1000) % 60)
		var minutes = floor(_last_time / (1000 * 60))
		$Background/CenterContainer/RichTextLabel.set_bbcode(
			"%02d : %02d : %03d" % [minutes, seconds, millis]
		)


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_start_level_chronometer() -> void:
	_last_time = 0
	_timer_stopped = false


func _on_SignalManager_end_reached() -> void:
	_timer_stopped = true
	VariableManager.chronometer.level = _last_time
