extends Node
# Autoload script to handle signals globally

##### SIGNALS #####
#==== PLAYER =====
#warning-ignore:UNUSED_SIGNAL
signal respawn_player_on_last_cp
#warning-ignore:UNUSED_SIGNAL
signal trigger_tutorial(key, time)
#warning-ignore:UNUSED_SIGNAL
signal speed_updated(speed)

#==== MAP =====
#warning-ignore:UNUSED_SIGNAL
signal checkpoint_triggered(checkpoint)
#warning-ignore:UNUSED_SIGNAL
signal start_level_chronometer
#warning-ignore:UNUSED_SIGNAL
signal end_reached

#==== VISUALS =====
#warning-ignore:UNUSED_SIGNAL
signal sequencer_step(id)

##### VARIABLES #####
# Note : Using this in this script creates a warning that signals are declared but unused
#==== PLAYER =====
const RESPAWN_PLAYER_ON_LAST_CP := "respawn_player_on_last_cp"
const TRIGGER_TUTORIAL := "trigger_tutorial"
const SPEED_UPDATED := "speed_updated"

#==== MAP =====
const CHECKPOINT_TRIGGERED := "checkpoint_triggered"
const END_REACHED := "end_reached"
const START_LEVEL_CHRONOMETER := "start_level_chronometer"

#==== VISUALS =====
const SEQUENCER_STEP := "sequencer_step"


##### PUBLIC METHODS #####
#==== PLAYER =====
func emit_respawn_player_on_last_cp() -> void:
	emit_signal(RESPAWN_PLAYER_ON_LAST_CP)


func emit_trigger_tutorial(key: String, time: float) -> void:
	if GlobalParameters.TUTORIALS_ENABLED:
		emit_signal(TRIGGER_TUTORIAL, key, time)


func emit_speed_updated(speed: float) -> void:
	emit_signal(SPEED_UPDATED, speed)


#==== MAP =====
func emit_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	emit_signal(CHECKPOINT_TRIGGERED, checkpoint)


func emit_end_reached() -> void:
	emit_signal(END_REACHED)


func emit_start_level_chronometer() -> void:
	emit_signal(START_LEVEL_CHRONOMETER)


#==== VISUALS =====
func emit_sequencer_step(id: String) -> void:
	emit_signal(SEQUENCER_STEP, id)
