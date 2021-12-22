extends CanvasLayer
# Script to prompt tutorial messages to the player

##### VARIABLES #####
#---- CONSTANTS -----
const ENGINE_SLOW_DOWN_AMOUNT = 0.125  # How much the engine will slow down to display the tutorial
const ENGINE_TUTORIAL_SHOW_TIME = 0.25  # Time to show and slow down the engine to display the tutotial (Note : it is an approximation since the tween will be affected by the engine slowdown as well)

#---- STANDARD -----
#==== PRIVATE ====
var _keys_dict := {}  # Dictionnary of keys, to replace in tutorial texts


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	if SignalManager.connect("trigger_tutorial", self, "_on_SignalManager_trigger_tutorial") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"trigger_tutorial",
					"_on_SignalManager_trigger_tutorial",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)
	set_keys_dict()
	$Screen.hide()
	$Screen/CenterContainer/Label.set_text("")


##### PUBLIC METHODS ######
# sets the _keys_dict variable
# TODO : kind of a dirty way to do this, maybe make a singleton or a static class dedicated to do this
func set_keys_dict() -> void:
	_keys_dict = {
		"##movement_forward##": InputMap.get_action_list("movement_forward")[0].as_text(),
		"##movement_backward##": InputMap.get_action_list("movement_backward")[0].as_text(),
		"##movement_left##": InputMap.get_action_list("movement_left")[0].as_text(),
		"##movement_right##": InputMap.get_action_list("movement_right")[0].as_text(),
		"##movement_jump##": InputMap.get_action_list("movement_jump")[0].as_text(),
		"##restart_last_cp##": InputMap.get_action_list("restart_last_cp")[0].as_text(),
		"##restart##": InputMap.get_action_list("restart")[0].as_text()
	}


# Displays the text of a tutorial key for a given time (in seconds)
func display_tutorial(key: String, time: float) -> void:
	var color_tween := Tween.new()  # color of the canvas
	var engine_time_scale_tween := Tween.new()  # time scale for slow motion
	if ! color_tween.interpolate_property(
		$Screen, "modulate", Color(1, 1, 1, 0.0), Color(1, 1, 1, 1.0), ENGINE_TUTORIAL_SHOW_TIME
	):
		Logger.error(
			(
				"Error while setting tween interpolate property %s at %s"
				% ["modulate", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if ! engine_time_scale_tween.interpolate_method(
		Engine, "set_time_scale", 1.0, ENGINE_SLOW_DOWN_AMOUNT, ENGINE_TUTORIAL_SHOW_TIME
	):
		Logger.error(
			(
				"Error while setting tween interpolate method %s at %s"
				% ["set_time_scale", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	add_child(color_tween)
	add_child(engine_time_scale_tween)
	if ! color_tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	if ! engine_time_scale_tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	$Screen.show()
	$Screen/CenterContainer/Label.set_text(TextUtils.replace_elements(tr(key), _keys_dict))
	yield(color_tween, "tween_all_completed")
	yield(get_tree().create_timer(time), "timeout")
	if ! color_tween.interpolate_property(
		$Screen, "modulate", Color(1, 1, 1, 1.0), Color(1, 1, 1, 0.0), ENGINE_TUTORIAL_SHOW_TIME
	):
		Logger.error(
			(
				"Error while setting tween interpolate property %s at %s"
				% ["modulate", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if ! engine_time_scale_tween.interpolate_method(
		Engine, "set_time_scale", ENGINE_SLOW_DOWN_AMOUNT, 1.0, ENGINE_TUTORIAL_SHOW_TIME
	):
		Logger.error(
			(
				"Error while setting tween interpolate method %s at %s"
				% ["set_time_scale", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if ! color_tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	if ! engine_time_scale_tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	yield(color_tween, "tween_all_completed")
	color_tween.queue_free()
	engine_time_scale_tween.queue_free()
	$Screen.hide()
	$Screen/CenterContainer/Label.set_text("")


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_trigger_tutorial(key: String, time: float) -> void:
	display_tutorial(key, time)
