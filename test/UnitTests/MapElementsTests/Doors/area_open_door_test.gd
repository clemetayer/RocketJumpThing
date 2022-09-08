# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests the area that opens a door

##### VARIABLES #####
const area_open_door_path := "res://test/UnitTests/MapElementsTests/Doors/area_open_door_mock.tscn"
var area_open_door


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = area_open_door_path
	.before()
	area_open_door = load(area_open_door_path).instance()


func after():
	if is_instance_valid(area_open_door):
		area_open_door.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	area_open_door._connect_signals()
	assert_bool(area_open_door.is_connected("body_entered", area_open_door, "_on_area_open_door_body_entered")).is_true()


func test_on_area_open_door_body_entered() -> void:
	var player := Player.new()
	player.add_to_group("player")
	area_open_door._on_area_open_door_body_entered(player)
	assert_signal(area_open_door).is_emitted("trigger")
