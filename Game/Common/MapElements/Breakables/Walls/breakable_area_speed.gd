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

#---- STANDARD -----
#==== PRIVATE ====
var _treshold := 100.0  # treshold speed for the wall to break (greater or equal)
var _ui_load := preload(UI_PATH)
var _break_wall_sound: AudioStreamPlayer


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_add_ui_sprite()
	_add_break_wall_sound()


##### PROTECTED METHODS #####
#==== Qodot =====
func update_properties() -> void:
	.update_properties()


#==== Other things =====
func _add_ui_sprite() -> void:
	if "treshold" in properties:
		self._treshold = properties.treshold
	var ui := _ui_load.instance()
	ui.SPEED = _treshold
	add_child(ui)
	var sprite := Sprite3D.new()
	if "text_direction" in properties:
		sprite.rotation_degrees = properties.text_direction
	sprite.scale = Vector3(15, 15, 1)
	add_child(sprite)
	if "scale" in properties:
		sprite.scale = properties.scale
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
	if body.is_in_group("player") and body.current_speed >= _treshold:
		emit_signal("trigger", {"position": body.transform.origin, "speed": body.current_speed})
		CameraUtils.start_camera_shake(0.6, 13, 0.6, 2.5)
		if _break_wall_sound != null:
			_break_wall_sound.play()
		yield(_break_wall_sound, "finished")
		self.queue_free()
