extends Node
class_name StepperPulse
# Step of a sequencer made for a pulse (tween in/out)
# frees itselfs when over


##### PUBLIC METHODS #####
func step(step_sequencer: Node, params: Dictionary) -> void:
	var tweens = _init_tweens(step_sequencer, params)
	add_child(tweens[0])
	add_child(tweens[1])
	if !tweens[0].start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	yield(tweens[0], "tween_all_completed")
	if !tweens[1].start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	yield(tweens[1], "tween_all_completed")
	tweens[0].queue_free()
	tweens[1].queue_free()
	queue_free()


##### PROTECTED METHODS #####
func _init_tweens(step_sequencer: Node, params: Dictionary) -> Array:
	var tween_in := Tween.new()
	var tween_out := Tween.new()
	for key in params.keys():
		if !tween_in.interpolate_property(
			step_sequencer,
			key,
			params[key].initial_value,
			params[key].final_value,
			params[key].duration_in,
			params[key].trans_type_in,
			params[key].ease_type_in,
			params[key].delay_in
		):
			Logger.error(
				(
					"Error while setting tween interpolate params %s at %s"
					% [params[key], DebugUtils.print_stack_trace(get_stack())]
				)
			)
		if !tween_out.interpolate_property(
			step_sequencer,
			key,
			params[key].final_value,
			params[key].initial_value,
			params[key].duration_out,
			params[key].trans_type_out,
			params[key].ease_type_out,
			params[key].delay_out
		):
			Logger.error(
				(
					"Error while setting tween interpolate params %s at %s"
					% [params[key], DebugUtils.print_stack_trace(get_stack())]
				)
			)
	return [tween_in,tween_out]
