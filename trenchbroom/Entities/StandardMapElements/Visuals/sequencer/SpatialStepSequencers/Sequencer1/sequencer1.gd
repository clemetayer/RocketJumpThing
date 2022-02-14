extends SpatialStepSequencer
# Some standard sequencer that makes the material light "flash".
# Note : Can only handle 1 material (the other surfaces will have the same materials)

##### VARIABLES #####
#---- CONSTANTS -----
const SHADER_PARAM_NAME := "intensity"

#---- STANDARD -----
#==== PRIVATE ====
var material: SpatialMaterial
var _intensity := {min = 1.0, max = 50.0}
var _fade := {f_in = 0.2, f_out = 0.4}


##### PROTECTED METHODS #####
# made to override _ready
func _ready_func():
	._ready_func()
	for child in get_children():
		if child is MeshInstance:
			material = child.mesh.surface_get_material(0)
			material = material.duplicate()  # duplicates the material, so that will truly be a "step"
			if properties.has("albedo"):
				material.albedo_color = properties.albedo
			if properties.has("emission_color"):
				material.emission = properties.emission_color
			for surface_idx in range(0, child.mesh.get_surface_count()):
				child.mesh.surface_set_material(surface_idx, material)
			break


func _qodot_properties() -> void:
	if properties.has("min_intensity"):
		_intensity.min = properties.min_intensity
	if properties.has("max_intensity"):
		_intensity.max = properties.max_intensity
	if properties.has("fade_in_time"):
		_fade.f_in = properties.fade_in_time
	if properties.has("fade_out_time"):
		_fade.f_out = properties.fade_out_time


# function to do when this is the correct step
func _step_function() -> void:
	var tween := Tween.new()
	add_child(tween)
	if !tween.interpolate_property(
		material, "emission_energy", _intensity.min, _intensity.max, _fade.f_in
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
	if !tween.interpolate_property(
		material, "emission_energy", _intensity.max, _intensity.min, _fade.f_out
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


# sets the shader intensity
# NOTE : unused method, but might be usefull later
func _set_shader_intensity(value: float):
	material.set_shader_param(SHADER_PARAM_NAME, value)
