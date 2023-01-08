# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends StomperTest
# Tests for a step sequencer stomper


##### TESTS #####
#---- PRE/POST -----
func before():
	stomper_path = "res://test/UnitTests/MapElementsTests/Stompers/step_sequencer_stomper_mock.tscn"
	.before()


func after():
	.after()

#---- TESTS -----
# Not much to test here, since most of the work is done by the StepSequencerCommon
