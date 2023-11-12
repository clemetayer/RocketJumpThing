# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends VerticalBoostTest
# tests the vertical boost area


##### TESTS #####
#---- PRE/POST -----
func before():
	vertical_boost_path = "res://Game/Common/MapElements/BoostPads/Vertical/vertical_boost_area.tscn"
	.before()

func test_on_body_entered_area() -> void:
	.test_on_body_entered()
	var player = load(GlobalTestUtilities.player_path).instance()
	player.add_to_group("player")
	vertical_boost._on_body_entered(player)
	assert_bool(vertical_boost.onready_paths.boost_sound.is_playing()).is_true()
	player.free()