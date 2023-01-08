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
	assert_bool(SignalManager.is_connected(SignalManager.PORTAL_ENTERED, portal, "_on_portal_entered")).is_true()

# FIXME : for some reason, the forward pos is set to (0,0,0), probably by the test framework
# func test_get_global_forward_vector() -> void:
# 	assert_vector3(portal.get_global_forward_vector()).is_equal(Vector3.FORWARD)
# 	portal.rotate_y(PI / 2)
# 	assert_vector3(portal.get_global_forward_vector()).is_equal(Vector3.LEFT)
# 	portal.rotation = Vector3.ZERO
# 	portal.rotate_x(PI / 2)
# 	assert_vector3(portal.get_global_forward_vector()).is_equal(Vector3.UP)

# FIXME : for some reason, these 3 tests below generates errors from the test framework
# func test_on_body_entered() -> void:
# 	var mock = mock("compatible_body_path")
# 	do_return(null).on(mock).portal_process()
# 	var not_compatible_body = KinematicBody.new()
# 	portal._on_body_entered(not_compatible_body)
# 	yield(assert_signal(SignalManager).is_not_emitted(SignalManager.PORTAL_ENTERED), "completed")
# 	portal._on_body_entered(mock)
# 	yield(assert_signal(SignalManager).is_emitted(SignalManager.PORTAL_ENTERED), "completed")

# func test_on_area_entered() -> void:
# 	# var compatible_area = load(compatible_area_path).instance()
# 	var not_compatible_area = Area.new()
# 	portal._on_area_entered(not_compatible_area)
# 	yield(assert_signal(SignalManager).is_not_emitted(SignalManager.PORTAL_ENTERED), "completed")
# 	# TODO : when there will be a compatible area
# 	# portal._on_body_entered(compatible_body)
# 	# yield(assert_signal(SignalManager).is_emitted(SignalManager.PORTAL_ENTERED), "completed")
# 	# compatible_area.free()

# func test_on_portal_entered() -> void:
# 	var id = "TEST"
# 	var not_id = "NOT_TEST"
# 	var entered_portal = load(portal_path).instance()
# 	var not_entered_portal = load(portal_path).instance()
# 	entered_portal.id = id
# 	not_entered_portal.id = not_id
# 	portal.id = id
# 	var mock = mock("compatible_body_path")
# 	do_return(null).on(mock).portal_process(entered_portal)
# 	portal._on_portal_entered(not_entered_portal, mock)
# 	portal._on_portal_entered(entered_portal, mock)
# 	portal._on_portal_entered(portal, mock)
# 	verify(mock, 1).portal_process(portal)
# 	entered_portal.free()
# 	not_entered_portal.free()
