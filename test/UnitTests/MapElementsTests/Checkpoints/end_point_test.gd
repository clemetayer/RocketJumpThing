# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the end point

##### VARIABLES #####
const end_point_path := "res://test/UnitTests/MapElementsTests/Checkpoints/end_point_mock.tscn"
var end_point


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = end_point_path
	.before()
	end_point = load(end_point_path).instance()


func after():
	end_point.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_add_to_end_point_group() -> void:
	end_point._add_to_end_point_group()
	assert_bool(end_point.is_in_group("end_point")).is_true()


func test_connect_signals() -> void:
	end_point._connect_signals()
	assert_bool(end_point.is_connected("body_entered", end_point, "_on_EndPoint_body_entered")).is_true()


func test_on_EndPoint_body_entered() -> void:
	var player = Player.new()
	player.add_to_group("player")
	end_point._on_EndPoint_body_entered(player)
	assert_bool(VariableManager.scene_unloading).is_true()
	assert_signal(SignalManager).is_emitted("end_reached")
	player.free()
