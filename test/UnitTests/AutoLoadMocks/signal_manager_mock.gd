extends Node
class_name SignalManagerMock
# mocks the autoload for test purposes

##### SIGNALS #####
#==== PLAYER =====
signal respawn_player_on_last_cp
signal trigger_tutorial(key, time)
signal speed_updated(speed)

#==== MAP =====
signal checkpoint_triggered(checkpoint)
signal start_level_chronometer
signal end_reached

#==== VISUALS =====
signal sequencer_step(id)


##### PUBLIC METHODS #####
#==== PLAYER =====
func emit_respawn_player_on_last_cp() -> void:
	emit_signal("respawn_player_on_last_cp")


func emit_trigger_tutorial(key: String, time: float) -> void:
	if GlobalParameters.TUTORIALS_ENABLED:
		emit_signal("trigger_tutorial", key, time)


func emit_speed_updated(speed: float) -> void:
	emit_signal("speed_updated", speed)


#==== MAP =====
func emit_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	emit_signal("checkpoint_triggered", checkpoint)


func emit_end_reached() -> void:
	emit_signal("end_reached")


func emit_start_level_chronometer() -> void:
	emit_signal("start_level_chronometer")


#==== VISUALS =====
func emit_sequencer_step(id: String) -> void:
	emit_signal("sequencer_step", id)
