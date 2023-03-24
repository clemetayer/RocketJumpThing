extends Resource
class_name SequencerInitParam
# Init data to set default parameters for the sequencer
# TODO : add some securities (if the step sequencer has the variable, etc.)

##### VARIABLES #####
#---- EXPORTS -----
export(Dictionary) var VAR_NODEPATH  # Key as a nodepath of the variable to set, value as the object to set


##### PUBLIC METHODS #####
func init_step_sequencer(step_sequencer: Node) -> void:
	for key in VAR_NODEPATH:
		step_sequencer.set_indexed(key, VAR_NODEPATH[key])
