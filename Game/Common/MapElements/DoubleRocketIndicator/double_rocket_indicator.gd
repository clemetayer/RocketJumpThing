extends Spatial
# Area to check the speed before breaking the associated wall

##### VARIABLES #####
#---- CONSTANTS -----
const TB_DOUBLE_ROCKET_INDICATOR_MAPPER := [["scale", "_sprite_scale"], ["mangle", "_mangle"], ["color", "_color"]]  # mapper for TrenchBroom parameters
const UI_PATH := "res://Game/Common/MapElements/DoubleRocketIndicator/double_rocket_indicator_ui.tscn"

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PRIVATE ====
var _ui_load := preload(UI_PATH)
var _sprite_scale: Vector3
var _mangle: Vector3
var _color: Color


##### PROCESSING #####
func _ready():
	_set_TB_params()
	_add_ui_sprite()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_DOUBLE_ROCKET_INDICATOR_MAPPER
	)


func _add_ui_sprite() -> void:
	var ui := _ui_load.instance()
	ui.COLOR = _color
	add_child(ui)
	var sprite := Sprite3D.new()
	sprite.rotation_degrees = _mangle
	sprite.scale = Vector3(8, 8, 1)
	add_child(sprite)
	sprite.scale = _sprite_scale
	sprite.texture = ui.get_texture()
	sprite.texture.flags = Texture.FLAG_FILTER
	sprite.flip_v = true
