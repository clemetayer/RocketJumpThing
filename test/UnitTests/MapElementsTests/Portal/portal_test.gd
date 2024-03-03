# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# tests for the portal

##### VARIABLES #####
const portal_path := "res://Game/Common/MapElements/Portal/portal.tscn"
const compatible_body_path := "res://Game/Common/MapElements/Characters/MainCharacters/player.tscn"

var portal


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = portal_path
	.before()
	portal = load(portal_path).instance()
	portal._ready()


func after():
	portal.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	portal._connect_signals()
	assert_bool(portal.is_connected("body_entered", portal, "_on_body_entered")).is_true()
	assert_bool(portal.is_connected("area_entered", portal, "_on_area_entered")).is_true()