extends Collidable
class_name BreakableArea
# Area to trigger a breakable wall break

##### SIGNALS #####
signal trigger(parameters)

##### VARIABLES #####
#---- CONSTANTS -----
const BREAK_WALL_SOUND_PATH := "res://Misc/Audio/FX/BreakWall/BreakWall.wav"  # Path to the break wall sound
const BREAK_WALL_SOUND_VOLUME_DB := -18.0  # Volume of the break wall sound

#---- STANDARD -----
#==== PRIVATE ====
var _break_wall_sound: AudioStreamPlayer


##### PROTECTED METHODS #####
func _ready_func() -> void:
	._ready_func()
	_add_break_wall_sound()


# adds a break wall sound to the scene
func _add_break_wall_sound() -> void:
	var sound := AudioStreamPlayer.new()
	sound.stream = load(BREAK_WALL_SOUND_PATH)
	sound.volume_db = BREAK_WALL_SOUND_VOLUME_DB
	if get_parent() != null:  # for test purposes
		get_parent().add_child(sound)
	_break_wall_sound = sound