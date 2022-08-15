tool
extends SpatialStepSequencer
# A solid entity that is like a sequencer, but rotates at the same time

##### VARIABLES #####

#---- STANDARD -----
#==== PRIVATE ====
var material: SpatialMaterial
var _fade_amount := {min = 0.0, max = 1.0}
var _fade := {f_in = 0.2, f_out = 0.4}


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if properties.has("rotation_speeds"):
		rotate_x(properties["rotation_speeds"].x * delta)
		rotate_y(properties["rotation_speeds"].y * delta)
		rotate_z(properties["rotation_speeds"].z * delta)


##### PROTECTED METHODS #####
# made to override _ready
func _ready_func():
	._ready_func()
	for child in get_children():
		if child is MeshInstance and child.mesh != null:
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
	if properties.has("min_fade_amount"):
		_fade_amount.min = properties.min_fade_amount
	if properties.has("max_fade_amount"):
		_fade_amount.max = properties.max_fade_amount
	if properties.has("fade_in_time"):
		_fade.f_in = properties.fade_in_time
	if properties.has("fade_out_time"):
		_fade.f_out = properties.fade_out_time


# function to do when this is the correct step
func _step_function() -> void:
	var tween := Tween.new()
	add_child(tween)
	var albedo_color = material.albedo_color
	if !tween.interpolate_property(
		material,
		"albedo_color",
		Color(albedo_color.r, albedo_color.g, albedo_color.b, _fade_amount.min),
		Color(albedo_color.r, albedo_color.g, albedo_color.b, _fade_amount.max),
		_fade.f_in
	):
		Logger.error(
			(
				"Error while setting tween interpolate property %s at %s"
				% ["albedo_color.a", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if !tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	yield(tween, "tween_all_completed")
	if !tween.interpolate_property(
		material,
		"albedo_color",
		Color(albedo_color.r, albedo_color.g, albedo_color.b, _fade_amount.max),
		Color(albedo_color.r, albedo_color.g, albedo_color.b, _fade_amount.min),
		_fade.f_out
	):
		Logger.error(
			(
				"Error while setting tween interpolate property %s at %s"
				% ["albedo_color.a", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if !tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	yield(tween, "tween_all_completed")
	tween.queue_free()
