# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the rocket launcher

##### VARIABLES #####
const rocket_launcher_path = "res://Game/Common/MapElements/Characters/MainCharacters/rocket_launcher.tscn"
var rocket_launcher: MeshInstance


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = rocket_launcher_path
	rocket_launcher = load(rocket_launcher_path).instance()
	rocket_launcher._ready()
	.before()


func after():
	rocket_launcher.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_fire() -> void:
	rocket_launcher.fire()
	assert_bool(rocket_launcher.onready_paths.animation_player.is_playing()).is_true()
	assert_str(rocket_launcher.onready_paths.animation_player.current_animation).is_equal(rocket_launcher.FIRE_ANIM_NAME)