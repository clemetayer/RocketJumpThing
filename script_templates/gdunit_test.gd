# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# description

##### VARIABLES #####
const scene_path := "path_to_scene.tscn"
var scene


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = scene_path
	.before()
	scene = load(scene_path).instance()
	scene._ready()

func after():
	scene.free()
	.after()

func after_test():
	pass

#---- TESTS -----
#==== ACTUAL TESTS =====
# test description
func test_name() -> void:
	assert_not_yet_implemented()

# subtest description
func _subtest_name() -> void:
	assert_not_yet_implemented()

#==== UTILITIES =====
# test utility
func _test_utility() -> void:
	pass
