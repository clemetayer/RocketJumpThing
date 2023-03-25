extends BreakableArea
# Area to check the speed before breaking the associated wall

##### VARIABLES #####
#---- CONSTANTS -----
const TB_BREAKABLE_AREA_SPEED_MAPPER := [
	["treshold", "_treshold"], ["mangle", "_mangle"], ["scale", "_sprite_scale"]
]  # mapper for TrenchBroom parameters
const UI_PATH := "res://Game/Common/MapElements/Breakables/Walls/breakable_area_speed_ui.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _treshold := 100.0  # treshold speed for the wall to break (greater or equal)
var _ui_load := preload(UI_PATH)
var _mangle: Vector3
var _sprite_scale: Vector3


##### PROCESSING #####
func _init():
	_connect_signals()


##### PROTECTED METHODS #####
func _ready_func() -> void:
	._ready_func()
	_add_ui_sprite()


func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_BREAKABLE_AREA_SPEED_MAPPER
	)


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_breakable_area_speed_body_entered")


func _add_ui_sprite() -> void:
	var ui := _ui_load.instance()
	ui.SPEED = _treshold
	add_child(ui)
	var sprite := Sprite3D.new()
	sprite.rotation_degrees = _mangle
	sprite.scale = Vector3(8, 8, 1)
	add_child(sprite)
	sprite.scale = _sprite_scale
	sprite.texture = ui.get_texture()
	sprite.texture.flags = Texture.FLAG_FILTER
	sprite.flip_v = true


##### SIGNAL MANAGEMENT #####
func _on_breakable_area_speed_body_entered(body):
	if FunctionUtils.is_player(body) and body.current_speed >= _treshold:
		emit_signal("trigger", {"position": body.transform.origin, "speed": body.current_speed})
		SignalManager.emit_wall_broken()
		CameraUtils.start_camera_shake(
			CAMERA_SHAKE_DURATION, CAMERA_SHAKE_FREQ, CAMERA_SHAKE_AMP, CAMERA_SHAKE_PRIORITY
		)
		if _break_wall_sound != null:
			_break_wall_sound.play()
		yield(_break_wall_sound, "finished")
		self.queue_free()
