extends Collidable
# Area to check the speed before breaking the associated wall
# TODO : update entity
# REFACTOR : Make a common class, dammit past me >:(

##### SIGNALS #####
signal trigger(parameters)

##### VARIABLES #####
#---- CONSTANTS -----
const UI_PATH := "res://Game/Common/MapElements/Breakables/Walls/breakable_area_rocket_ui.tscn"
const BREAK_WALL_SOUND_PATH := "res://Misc/Audio/FX/BreakWall/BreakWall.wav"  # Path to the break wall sound
const BREAK_WALL_SOUND_VOLUME_DB := -18.0  # Volume of the break wall sound

#---- STANDARD -----
#==== PRIVATE ====
var _ui_load := preload(UI_PATH)
var _break_wall_sound: AudioStreamPlayer


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_add_break_wall_sound()
	_add_ui_sprite()


##### PROTECTED METHODS #####
#==== Qodot =====
func update_properties() -> void:
	.update_properties()


#==== Other things =====
func _connect_signals() -> void:
	FunctionUtils.log_connect(self, self, "area_entered", "_on_breakable_area_rocket_area_entered")


func _add_ui_sprite() -> void:
	var ui := _ui_load.instance()
	add_child(ui)
	var sprite := Sprite3D.new()
	if "text_direction" in properties:  # text is a texture here. this is a convenient word :)
		sprite.rotation_degrees = properties.text_direction
	sprite.scale = Vector3(15, 15, 1)
	add_child(sprite)
	if "scale" in properties:
		sprite.scale = properties.scale
	sprite.texture = ui.get_texture()
	sprite.texture.flags = Texture.FLAG_FILTER
	sprite.flip_v = true


# adds a break wall sound to the scene
func _add_break_wall_sound() -> void:
	var sound := AudioStreamPlayer.new()
	sound.stream = load(BREAK_WALL_SOUND_PATH)
	sound.volume_db = BREAK_WALL_SOUND_VOLUME_DB
	if get_parent() != null:  # for test purposes
		get_parent().add_child(sound)
	_break_wall_sound = sound


##### SIGNAL MANAGEMENT #####
func _on_breakable_area_rocket_area_entered(area):
	if area is Rocket:
		emit_signal("trigger", {"position": area.transform.origin, "speed": area.SPEED})
		_break_wall_sound.play()
		yield(_break_wall_sound, "finished")
		self.queue_free()
