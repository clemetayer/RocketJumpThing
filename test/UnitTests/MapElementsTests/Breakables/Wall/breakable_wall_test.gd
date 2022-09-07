# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# breakable wall tests

##### VARIABLES #####
const breakable_wall_path = "res://test/UnitTests/MapElementsTests/Breakables/Wall/breakable_wall_mock.tscn"
var breakable_wall: RigidBody


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = breakable_wall_path
	.before()
	breakable_wall = load(breakable_wall_path).instance()


func after():
	if is_instance_valid(breakable_wall):
		breakable_wall.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_init_body() -> void:
	breakable_wall._init_body()
	assert_str(str(breakable_wall.weight)).is_equal("100")
	assert_int(breakable_wall.mode).is_equal(RigidBody.MODE_STATIC)


func test_use() -> void:
	breakable_wall.use({"position": Vector3.ONE, "speed": 200})
	assert_int(breakable_wall.mode).is_equal(RigidBody.MODE_RIGID)
