extends Node
# Autoload script to handle signals globally

##### VARIABLES #####
#---- CONSTANTS -----
const TUTORIALS_ENABLED = false

##### SIGNALS #####
#==== PLAYER =====
signal respawn_player_on_last_cp
signal trigger_tutorial(key, time)
signal speed_updated(speed)

#==== MAP =====
signal checkpoint_triggered(checkpoint)

#==== VISUALS =====
signal sequencer_step(id)


##### PUBLIC METHODS #####
#==== PLAYER =====
func emit_respawn_player_on_last_cp() -> void:
	emit_signal("respawn_player_on_last_cp")


func emit_trigger_tutorial(key: String, time: float) -> void:
	if TUTORIALS_ENABLED:
		emit_signal("trigger_tutorial", key, time)


func emit_speed_updated(speed: float) -> void:
	emit_signal("speed_updated", speed)


#==== MAP =====
func emit_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	emit_signal("checkpoint_triggered", checkpoint)


#==== VISUALS =====
func emit_sequencer_step(id: String) -> void:
	emit_signal("sequencer_step", id)
