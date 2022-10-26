extends Node
class_name StepperTween
# Step of a sequencer made for a Tween animation
# frees itself when over


##### PUBLIC METHODS #####
func step(step_sequencer: Node, params: Dictionary) -> void:
	var tween := _init_tween(step_sequencer, params)
	add_child(tween)
	DebugUtils.log_tween_start(tween)
	yield(tween, "tween_all_completed")
	tween.queue_free()
	queue_free()


##### PROTECTED METHODS #####
func _init_tween(step_sequencer: Node, params: Dictionary) -> Tween:
	var tween := Tween.new()
	for key in params.keys():
		DebugUtils.log_tween_interpolate_property(
			tween,
			step_sequencer,
			key,
			params[key].initial_value,
			params[key].final_value,
			params[key].duration,
			params[key].trans_type,
			params[key].ease_type,
			params[key].delay
		)
	return tween
