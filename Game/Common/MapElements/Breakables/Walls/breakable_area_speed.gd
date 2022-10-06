extends Collidable
# Area to check the speed before breaking the associated wall
# TODO : update entity
# REFACTOR : Make a common class, dammit past me >:(

##### SIGNALS #####
signal trigger(parameters)

##### VARIABLES #####
#---- CONSTANTS -----
const UI_PATH := "res://Game/Common/MapElements/Breakables/Walls/breakable_area_speed_ui.tscn"
const BREAK_WALL_SOUND_PATH := "res://Misc/Audio/FX/BreakWall/BreakWall.wav"  # Path to the break wall sound
const BREAK_WALL_SOUND_VOLUME_DB := -18.0  # Volume of the break wall sound
const TB_BREAKABLE_AREA_SPEED_MAPPER := [
	["treshold", "_treshold"], ["text_direction", "_text_direction"], ["scale", "_text_direction"]
]  # mapper for TrenchBroom parameters
#---- STANDARD -----
#==== PRIVATE ====
var _treshold := 100.0  # treshold speed for the wall to break (greater or equal)
var _ui_load := preload(UI_PATH)
var _break_wall_sound: AudioStreamPlayer
var _sprite_text_direction: Vector3
var _sprite_scale: float


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_add_ui_sprite()
	_add_break_wall_sound()


##### PROTECTED METHODS #####
func _init_func() -> void:
	._init_func()
	_connect_signals()


func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_BREAKABLE_AREA_SPEED_MAPPER
	)


#==== Other things =====
func _add_ui_sprite() -> void:
	var ui := _ui_load.instance()
	ui.SPEED = _treshold
	add_child(ui)
	var sprite := Sprite3D.new()
	sprite.rotation_degrees = _sprite_text_direction
	sprite.scale = Vector3(15, 15, 1)
	add_child(sprite)
	sprite.scale = _sprite_scale
	sprite.texture = ui.get_texture()
	sprite.texture.flags = Texture.FLAG_FILTER
	sprite.flip_v = true


func _connect_signals() -> void:
	if connect("body_entered", self, "_on_breakable_area_speed_body_entered") != OK:
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"body_entered",
					"_on_breakable_area_speed_body_entered",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


# adds a break wall sound to the scene
func _add_break_wall_sound() -> void:
	var sound := AudioStreamPlayer.new()
	sound.stream = load(BREAK_WALL_SOUND_PATH)
	sound.volume_db = BREAK_WALL_SOUND_VOLUME_DB
	get_parent().add_child(sound)
	_break_wall_sound = sound


##### SIGNAL MANAGEMENT #####
func _on_breakable_area_speed_body_entered(body):
	if FunctionUtils.is_player(body) and body.current_speed >= _treshold:
		emit_signal("trigger", {"position": body.transform.origin, "speed": body.current_speed})
		CameraUtils.start_camera_shake(0.6, 13, 0.6, 2.5)
		if _break_wall_sound != null:
			_break_wall_sound.play()
		yield(_break_wall_sound, "finished")
		self.queue_free()
