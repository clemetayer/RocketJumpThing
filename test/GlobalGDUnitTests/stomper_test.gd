# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
class_name StomperTest
# global tests for a stomper

##### VARIABLES #####
var stomper_path := ""
var stomper


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = stomper_path
	.before()
	stomper = load(stomper_path).instance()


func after():
	stomper.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
# TODO : _stomp is hard to test because of the tweens


func test_connect_signals() -> void:
	stomper._connect_signals()
	assert_bool(stomper.is_connected("body_entered", stomper, "_on_body_entered")).is_true()


func test_on_body_entered() -> void:
	var player := KinematicBody.new()
	player.add_to_group("player")
	var not_player := KinematicBody.new()
	stomper._on_body_entered(not_player)
	yield(
		assert_signal(SignalManager).is_not_emitted(SignalManager.RESPAWN_PLAYER_ON_LAST_CP),
		"completed"
	)
	stomper._on_body_entered(player)
	yield(
		assert_signal(SignalManager).is_emitted(SignalManager.RESPAWN_PLAYER_ON_LAST_CP),
		"completed"
	)
	player.free()
	not_player.free()
