extends SpatialModifyMaterialParamStepSequencer
# A step sequencer for making shader parameters go in and out at each step (pulse)
# Use this template :
"""
{
  "duplicate_material": true,
  "*":{}, # Parameters at start
  "signal_name": [ # Array of steps
	{ # param names in the shader
	  "shader_param_1": { # Tween values for the shader parameter name
		"initial_value": "var",
		"final_value": "var",
		"duration_in": "float",
		"duration_out": "float",
		"trans_type_in": "int",
		"trans_type_out": "int",
		"ease_type_in": "int",
		"ease_type_out": "int",
		"delay_in": "float",
		"delay_out": "float"
	  },
	  "shader_param_2": {
		"initial_value": "var",
		"final_value": "var",
		"duration_in": "float",
		"duration_out": "float",
		"trans_type_in": "int",
		"trans_type_out": "int",
		"ease_type_in": "int",
		"ease_type_out": "int",
		"delay_in": "float",
		"delay_out": "float"
	  }
	},
	{
	  "shader_param_1": {
		"initial_value": "var",
		"final_value": "var",
		"duration_in": "float",
		"duration_out": "float",
		"trans_type_in": "int",
		"trans_type_out": "int",
		"ease_type_in": "int",
		"ease_type_out": "int",
		"delay_in": "float",
		"delay_out": "float"
	  },
	  "shader_param_2": {
		"initial_value": "var",
		"final_value": "var",
		"duration_in": "float",
		"duration_out": "float",
		"trans_type_in": "int",
		"trans_type_out": "int",
		"ease_type_in": "int",
		"ease_type_out": "int",
		"delay_in": "float",
		"delay_out": "float"
	  }
	}
  ],
  "signal_name_2": [
	{
	  "shader_param_1": {
		"initial_value": "var",
		"final_value": "var",
		"duration_in": "float",
		"duration_out": "float",
		"trans_type_in": "int",
		"trans_type_out": "int",
		"ease_type_in": "int",
		"ease_type_out": "int",
		"delay_in": "float",
		"delay_out": "float"
	  },
	  "shader_param_2": {
		"initial_value": "var",
		"final_value": "var",
		"duration_in": "float",
		"duration_out": "float",
		"trans_type_in": "int",
		"trans_type_out": "int",
		"ease_type_in": "int",
		"ease_type_out": "int",
		"delay_in": "float",
		"delay_out": "float"
	  }
	},
	{
	  "shader_param_1": {
		"initial_value": "var",
		"final_value": "var",
		"duration_in": "float",
		"duration_out": "float",
		"trans_type_in": "int",
		"trans_type_out": "int",
		"ease_type_in": "int",
		"ease_type_out": "int",
		"delay_in": "float",
		"delay_out": "float"
	  },
	  "shader_param_2": {
		"initial_value": "var",
		"final_value": "var",
		"duration_in": "float",
		"duration_out": "float",
		"trans_type_in": "int",
		"trans_type_out": "int",
		"ease_type_in": "int",
		"ease_type_out": "int",
		"delay_in": "float",
		"delay_out": "float"
	  }
	}
  ]
}
"""
##### VARIABLES #####
#---- CONSTANTS -----
const SHADER_PARAMETER_PATH := "shader_param/"


##### PROTECTED METHODS #####
# overriden from parent
func _set_start_parameters() -> void:
	if _params.has("*"):
		for key in _params["*"].keys():
			_material.set_shader_param(key, _params["*"][key])


# function to execute at each step
func _step(params: Dictionary) -> void:
	var tween := Tween.new()
	add_child(tween)
	for key in params.keys():
		if !tween.interpolate_property(
			_material,
			SHADER_PARAMETER_PATH + key,
			params[key].initial_value,
			params[key].final_value,
			params[key].duration_in,
			params[key].trans_type_in,
			params[key].ease_type_in,
			params[key].delay_in
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
	for key in params.keys():
		if !tween.interpolate_property(
			_material,
			SHADER_PARAMETER_PATH + key,
			params[key].final_value,
			params[key].initial_value,
			params[key].duration_out,
			params[key].trans_type_out,
			params[key].ease_type_out,
			params[key].delay_out
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
