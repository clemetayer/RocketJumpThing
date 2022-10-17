extends Node
class_name StepperSetParam
# Step of a sequencer to simply modify a parameter
# frees itself when over


##### PUBLIC METHODS #####
func step(step_sequencer: Node, params: Dictionary) -> void:
	for key in params.keys():
		step_sequencer.set_indexed(key, params[key])
	queue_free()
