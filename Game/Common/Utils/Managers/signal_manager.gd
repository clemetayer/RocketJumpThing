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
#warning-ignore:UNUSED_SIGNAL
signal position_updated(position)

#==== MAP =====
#warning-ignore:UNUSED_SIGNAL
signal checkpoint_triggered(checkpoint)
#warning-ignore:UNUSED_SIGNAL
signal start_level_chronometer
#warning-ignore:UNUSED_SIGNAL
signal end_reached
#warning-ignore:UNUSED_SIGNAL
signal wall_broken

#==== VISUALS =====
#warning-ignore:UNUSED_SIGNAL
signal sequencer_step(id)

#==== OPTIONS =====
#warning-ignore:UNUSED_SIGNAL
signal change_key_popup(action)
#warning-ignore:UNUSED_SIGNAL
signal update_keys
#warning-ignore:UNUSED_SIGNAL
signal save_cfg_popup(cfg_path, cfg_name, cfg)
#warning-ignore:UNUSED_SIGNAL
signal add_cfg_popup(cfg_path, cfg)

##### VARIABLES #####
# Note : Using this in this script creates a warning that signals are declared but unused
#==== PLAYER =====
const RESPAWN_PLAYER_ON_LAST_CP := "respawn_player_on_last_cp"
const TRIGGER_TUTORIAL := "trigger_tutorial"
const SPEED_UPDATED := "speed_updated"
const POSITION_UPDATED := "position_updated"

#==== MAP =====
const CHECKPOINT_TRIGGERED := "checkpoint_triggered"
const END_REACHED := "end_reached"
const START_LEVEL_CHRONOMETER := "start_level_chronometer"
const WALL_BROKEN := "wall_broken"

#==== VISUALS =====
const SEQUENCER_STEP := "sequencer_step"

#==== OPTIONS =====
const CHANGE_KEY_POPUP := "change_key_popup"
const UPDATE_KEYS := "update_keys"
const SAVE_CFG_POPUP := "save_cfg_popup"
const ADD_CFG_POPUP := "add_cfg_popup"


##### PUBLIC METHODS #####
#==== PLAYER =====
func emit_respawn_player_on_last_cp() -> void:
	emit_signal(RESPAWN_PLAYER_ON_LAST_CP)


func emit_trigger_tutorial(key: String, time: float) -> void:
	if GlobalParameters.TUTORIALS_ENABLED:
		emit_signal(TRIGGER_TUTORIAL, key, time)


func emit_speed_updated(speed: float) -> void:
	emit_signal(SPEED_UPDATED, speed)


func emit_position_updated(position: Vector3) -> void:
	emit_signal(POSITION_UPDATED, position)


#==== MAP =====
func emit_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	emit_signal(CHECKPOINT_TRIGGERED, checkpoint)


func emit_end_reached() -> void:
	emit_signal(END_REACHED)


func emit_start_level_chronometer() -> void:
	emit_signal(START_LEVEL_CHRONOMETER)


func emit_wall_broken() -> void:
	emit_signal(WALL_BROKEN)


#==== VISUALS =====
func emit_sequencer_step(id: String) -> void:
	emit_signal(SEQUENCER_STEP, id)


#==== SETTINGS =====
func emit_change_key_popup(action: String) -> void:
	emit_signal(CHANGE_KEY_POPUP, action)


func emit_update_keys() -> void:
	emit_signal(UPDATE_KEYS)


func emit_save_cfg_popup(cfg_path: String, cfg_name: String, cfg: ConfigFile) -> void:
	emit_signal(SAVE_CFG_POPUP, cfg_path, cfg_name, cfg)


func emit_add_cfg_popup(cfg_path: String, cfg: ConfigFile) -> void:
	emit_signal(ADD_CFG_POPUP, cfg_path, cfg)
