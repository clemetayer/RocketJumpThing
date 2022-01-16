extends SpatialStepSequencer
# Some standard sequencer that makes the material light "flash". 
# Note : Can only handle 1 material (the other surfaces will have the same materials)

##### VARIABLES #####
#---- CONSTANTS -----
const FADE_IN_TIME := .2
const FADE_OUT_TIME := FADE_IN_TIME * 2.0
const MIN_INTENSITY := 1.0
const MAX_INTENSITY := 50.0
const SHADER_PARAM_NAME := "intensity"

#---- STANDARD -----
#==== PRIVATE ====
var material: Material


##### PROTECTED METHODS #####
# made to override _ready
func _ready_func():
	._ready_func()
	for child in get_children():
		if child is MeshInstance:
			material = child.mesh.surface_get_material(0)
			material = material.duplicate()  # duplicates the material, so that will truly be a "step"
			for surface_idx in range(0, child.mesh.get_surface_count()):
				child.mesh.surface_set_material(surface_idx, material)
			break


# function to do when this is the correct step 
func _step_function() -> void:
	var tween := Tween.new()
	add_child(tween)
	tween.interpolate_method(
		self, "_set_shader_intensity", MIN_INTENSITY, MAX_INTENSITY, FADE_IN_TIME
	)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_method(
		self, "_set_shader_intensity", MAX_INTENSITY, MIN_INTENSITY, FADE_OUT_TIME
	)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()


# sets the shader intensity
func _set_shader_intensity(value: float):
	material.set_shader_param(SHADER_PARAM_NAME, value)
