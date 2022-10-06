# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
class_name StepSequencerStepParticleTest
# global tests for the step sequencer particles elements

# FIXME : tests failing

##### VARIABLES #####
var step_sequencer_path: String
var step_sequencer


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = step_sequencer_path
	.before()
	step_sequencer = load(step_sequencer_path).instance()


func after():
	step_sequencer.free()
	.after()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_step_function() -> void:
	step_sequencer._step_function()
	assert_bool(step_sequencer.emitting).is_true()


func test_connect_signals() -> void:
	step_sequencer._connect_signals()
	assert_bool(SignalManager.is_connected("sequencer_step", step_sequencer, "_on_SignalManager_sequencer_step")).is_true()


func test_on_SignalManager_sequencer_step() -> void:
	step_sequencer._id = "test"
	step_sequencer._number_of_steps = 2
	step_sequencer._number = 0
	step_sequencer.emitting = false
	# initial test
	assert_int(step_sequencer._step).is_equal(0)
	assert_bool(step_sequencer.emitting).is_false()
	# one step emitting
	step_sequencer._on_SignalManager_sequencer_step("test")
	assert_int(step_sequencer._step).is_equal(1)
	assert_bool(step_sequencer.emitting).is_true()
	# not a sequencer step
	step_sequencer.emitting = false
	step_sequencer._on_SignalManager_sequencer_step("not_test")
	assert_int(step_sequencer._step).is_equal(1)
	assert_bool(step_sequencer.emitting).is_false()
	# not the correct step
	step_sequencer.emitting = false
	step_sequencer._on_SignalManager_sequencer_step("test")
	assert_int(step_sequencer._step).is_equal(0)
	assert_bool(step_sequencer.emitting).is_false()
