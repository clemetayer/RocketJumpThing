extends Node
class_name StepperTween
# Step of a sequencer made for a Tween animation
# frees itself when over


##### PUBLIC METHODS #####
func step(step_sequencer: Node, params: Dictionary) -> void:
	var tween := _init_tween(step_sequencer, params)
	add_child(tween)
	if !tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	yield(tween, "tween_all_completed")
	tween.queue_free()
	queue_free()


##### PROTECTED METHODS #####
func _init_tween(step_sequencer: Node, params: Dictionary) -> Tween:
	var tween := Tween.new()
	for key in params.keys():
		if !tween.interpolate_property(
			step_sequencer,
			key,
			params[key].initial_value,
			params[key].final_value,
			params[key].duration,
			params[key].trans_type,
			params[key].ease_type,
			params[key].delay
		):
			Logger.error(
				(
					"Error while setting tween interpolate params %s at %s"
					% [params[key], DebugUtils.print_stack_trace(get_stack())]
				)
			)
	return tween
