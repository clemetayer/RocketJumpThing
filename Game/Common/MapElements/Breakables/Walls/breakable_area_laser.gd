extends BreakableArea
# Area to check the speed before breaking the associated wall

##### VARIABLES #####
#---- CONSTANTS -----
const TB_BREAKABLE_AREA_LASER_MAPPER := [["scale", "_sprite_scale"], ["mangle", "_mangle"]]  # mapper for TrenchBroom parameters
const UI_PATH := "res://Game/Common/MapElements/Breakables/Walls/breakable_area_laser_ui.tscn"
const BREAK_SPEED := 10  # default value to make the wall break

#---- STANDARD -----
#==== PRIVATE ====
var _ui_load := preload(UI_PATH)
var _sprite_scale: Vector3
var _mangle: Vector3


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
		self, properties, TB_BREAKABLE_AREA_LASER_MAPPER
	)


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "area_entered", "_on_breakable_area_laser_area_entered")


func _add_ui_sprite() -> void:
	var ui := _ui_load.instance()
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
func _on_breakable_area_laser_area_entered(area):
	if FunctionUtils.is_laser(area):
		emit_signal("trigger", {"position": area.transform.origin, "speed": BREAK_SPEED})
		if _break_wall_sound != null:
			_break_wall_sound.play()
		self.queue_free()
		yield(_break_wall_sound, "finished")
