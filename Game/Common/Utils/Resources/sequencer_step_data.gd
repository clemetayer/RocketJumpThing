extends Resource
class_name SequencerStepData
# Base class for the data of a sequencer step

##### VARIABLES #####
#---- CONSTANTS -----
const STEP_METHOD_NAME := "step"

#---- EXPORTS -----
export(Array, Resource) var STEP_DATA_ITEMS


##### PUBLIC METHODS #####
# For each entry in VAR_NODEPATH, triggers its step method
func call_steps_process(step_sequencer: Node) -> void:
	for step_data_item in STEP_DATA_ITEMS:
		if step_data_item is SequencerStepDataItem:
			step_data_item.step(step_sequencer)
		else:
			Logger.error("resource associated to %s is not a subtype of SequencerStepDataItem")
