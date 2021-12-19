extends Node
# Autoload script to handle signals globally

##### SIGNALS #####
#==== PLAYER =====
signal respawn_player_on_last_cp
signal trigger_tutorial(key, time)

#==== MAP =====
signal checkpoint_triggered(checkpoint)


##### PUBLIC METHODS #####
#==== PLAYER =====
func emit_respawn_player_on_last_cp() -> void:
	emit_signal("respawn_player_on_last_cp")


func emit_trigger_tutorial(key: String, time: float) -> void:
	emit_signal("trigger_tutorial", key, time)


#==== MAP =====
func emit_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	emit_signal("checkpoint_triggered", checkpoint)
