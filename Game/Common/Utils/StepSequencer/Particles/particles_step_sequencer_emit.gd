extends ParticlesStepSequencer
# A step sequencer to emit particles
# Use this template :
"""
{
  "signal_name": [ # Array of steps
	{ 
		"emitting":"bool"
	},
	{
		"emitting":"bool"
	}
  ],
  "signal_name_2": [
	{
		"emitting":"bool"
	},
	{
		"emitting":"bool"
	}
  ]
}
"""

##### PROTECTED METHODS #####
# function to execute at each step
func _step(params: Dictionary) -> void:
	emitting = params.has("emitting") and params.emitting
