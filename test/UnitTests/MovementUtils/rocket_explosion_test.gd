# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the rocket explosion

##### VARIABLES #####
const rocket_explosion_path := "res://Game/Common/MovementUtils/Rocket/rocket_explosion.tscn"
var rocket_explosion


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = rocket_explosion_path
	.before()
	rocket_explosion = load(rocket_explosion_path).instance()


func after():
	rocket_explosion.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	rocket_explosion._connect_signals()
	assert_bool(rocket_explosion.get_node(rocket_explosion.NODE_PATHS.timer).is_connected("timeout", rocket_explosion, "_on_Timer_timeout")).is_true()
	assert_bool(rocket_explosion.get_node(rocket_explosion.NODE_PATHS.animation).is_connected("animation_finished", rocket_explosion, "_on_AnimationPlayer_animation_finished")).is_true()
	assert_bool(rocket_explosion.is_connected("body_entered", rocket_explosion, "_on_body_entered")).is_true()


func test_explode() -> void:
	# rocket_explosion.EXPLOSION_POSITION = Vector3.ONE
	rocket_explosion._explode()
	assert_bool(rocket_explosion.get_node(rocket_explosion.NODE_PATHS.explosion_audio).playing).is_true()
	# assert_vector3(rocket_explosion.global_transform.origin).is_equal(Vector3.ONE) # TODO : exports not working well
	assert_str(rocket_explosion.get_node(rocket_explosion.NODE_PATHS.animation).current_animation).is_equal(
		rocket_explosion.ANIMATIONS.explode
	)
	assert_bool(rocket_explosion.get_node(rocket_explosion.NODE_PATHS.timer).paused).is_false()


func test_on_body_entered() -> void:
	var player := load(GlobalTestUtilities.player_path).instance()
	player.add_to_group("player")
	rocket_explosion._on_body_entered(player)
	assert_array(player._add_velocity_vector_queue).is_not_empty()
	player.free()
