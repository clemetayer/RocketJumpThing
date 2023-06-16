# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests for the end entity

##### VARIABLES #####
const the_entity_path := "res://Game/Scenes/Levels/Level7/TheEntity/the_entity.tscn"
var the_entity


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = the_entity_path
	.before()
	the_entity = load(the_entity_path).instance()
	the_entity._ready()


func after():
	the_entity.free()
	.after()

#---- TESTS -----
#==== ACTUAL TESTS =====
func test_hurt() -> void:
	# standard case
	var test_hp = 10
	the_entity._hp = test_hp
	the_entity.hurt()
	assert_int(the_entity._hp).is_equal(test_hp-1)
	# hp goes to zero
	the_entity._hp = 1
	the_entity.hurt()
	assert_int(the_entity._hp).is_equal(0)
	assert_signal(SignalManager).is_emitted(SignalManager.ENTITY_DESTROYED)
	# hp equals zero
	the_entity._hp = 0
	the_entity.hurt()
	assert_int(the_entity._hp).is_equal(0)
	assert_signal(SignalManager).is_emitted(SignalManager.ENTITY_DESTROYED)

func test_shockwave() -> void:
	the_entity.shockwave()
	_test_animation(the_entity.SHOCKWAVE_ANIM)
	the_entity.onready_paths.animation_player.stop()

func test_appear() -> void:
	the_entity.appear()
	_test_animation(the_entity.APPEAR_ANIM)
	the_entity.onready_paths.animation_player.stop()

func test_disappear() -> void:
	the_entity.disappear()
	_test_animation(the_entity.DISAPPEAR_ANIM)
	the_entity.onready_paths.animation_player.stop()

func test_destroy() -> void:
	the_entity.destroy()
	_test_animation(the_entity.DESTROY_ANIM)
	the_entity.onready_paths.animation_player.stop()

func _test_animation(animation_name : String) -> void:
	assert_str(the_entity.onready_paths.animation_player.current_animation).is_equal(animation_name)
	assert_bool(the_entity.onready_paths.animation_player.is_playing()).is_true()