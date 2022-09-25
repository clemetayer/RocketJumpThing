extends StaticBodyModifyMaterialParamStepSequencer
# A step sequencer using tweens to interact with spatial materials parameters
# Use this template :
"""
{
  "duplicate_material": true,
  "*":{}, # Parameters at start
  "signal_name": [ # Array of steps
	{ # param names in the shader
	  "spatial_material_param_1": { # Tween values for the shader parameter name
		"initial_value": "var",
		"final_value": "var",
		"duration": "float",
		"trans_type": "int",
		"ease_type": "int",
		"delay": "float"
	  },
	  "spatial_material_param_2": {
		"initial_value": "var",
		"final_value": "var",
		"duration": "float",
		"trans_type": "int",
		"ease_type": "int",
		"delay": "float"
	  }
	},
	{
	  "spatial_material_param_1": {
		"initial_value": "var",
		"final_value": "var",
		"duration": "float",
		"trans_type": "int",
		"ease_type": "int",
		"delay": "float"
	  },
	  "spatial_material_param_2": {
		"initial_value": "var",
		"final_value": "var",
		"duration": "float",
		"trans_type": "int",
		"ease_type": "int",
		"delay": "float"
	  }
	}
  ],
  "signal_name_2": [
	{
	  "spatial_material_param_1": {
		"initial_value": "var",
		"final_value": "var",
		"duration": "float",
		"trans_type": "int",
		"ease_type": "int",
		"delay": "float"
	  },
	  "spatial_material_param_2": {
		"initial_value": "var",
		"final_value": "var",
		"duration": "float",
		"trans_type": "int",
		"ease_type": "int",
		"delay": "float"
	  }
	},
	{
	  "spatial_material_param_1": {
		"initial_value": "var",
		"final_value": "var",
		"duration": "float",
		"trans_type": "int",
		"ease_type": "int",
		"delay": "float"
	  },
	  "spatial_material_param_2": {
		"initial_value": "var",
		"final_value": "var",
		"duration": "float",
		"trans_type": "int",
		"ease_type": "int",
		"delay": "float"
	  }
	}
  ]
}
"""


##### PROTECTED METHODS #####
# function to execute at each step
func _step(params: Dictionary) -> void:
	var tween := Tween.new()
	add_child(tween)
	for key in params.keys():
		if !tween.interpolate_property(
			_material,
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
					"Error while setting tween interpolate property %s at %s"
					% ["emission_energy", DebugUtils.print_stack_trace(get_stack())]
				)
			)
		if !tween.start():
			Logger.error(
				"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
			)
	yield(tween, "tween_all_completed")
	tween.queue_free()
