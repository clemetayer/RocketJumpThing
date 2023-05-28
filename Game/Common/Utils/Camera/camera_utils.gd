extends Node
# An utility tool for camera effects

#==== PRIVATE ====
var _camera_offset_shake_variables = {"v_offset": null, "h_offset": null}
var _v_offset_shaker = null
var _h_offset_shaker = null
var _priority = 0


##### PUBLIC METHODS #####
# starts the camera shake
# very inspired from https://www.codingkaiju.com/tutorials/screen-shake-in-godot-the-best-way/
func start_camera_shake(duration = 1.0, frequency = 15, amplitude = 1.0, priority = 0) -> void:
	if priority >= _priority:
		_cancel_current()
		var camera = get_viewport().get_camera()
		_camera_offset_shake_variables.v_offset = ShakeVariable.new(camera, "v_offset", 0.0)
		_camera_offset_shake_variables.h_offset = ShakeVariable.new(camera, "h_offset", 0.0)
		var v_offset_shaker = VariableShaker.new(
			_camera_offset_shake_variables.v_offset,
			amplitude * OS.window_size.x,
			duration,
			frequency
		)
		var h_offset_shaker = VariableShaker.new(
			_camera_offset_shake_variables.h_offset,
			amplitude * OS.window_size.y,
			duration,
			frequency
		)
		add_child(v_offset_shaker)
		add_child(h_offset_shaker)
		v_offset_shaker.start_shake()
		h_offset_shaker.start_shake()


##### PROTECTED METHODS #####
func _cancel_current() -> void:
	if is_instance_valid(_v_offset_shaker):
		_v_offset_shaker.stop_current()
	if is_instance_valid(_h_offset_shaker):
		_h_offset_shaker.stop_current()
