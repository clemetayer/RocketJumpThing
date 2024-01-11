extends Node
# Autoload script to handle signals globally

##### SIGNALS #####
#==== PLAYER =====
#warning-ignore:UNUSED_SIGNAL
signal respawn_player_on_last_cp
#warning-ignore:UNUSED_SIGNAL
signal player_respawned_on_last_cp
#warning-ignore:UNUSED_SIGNAL
signal trigger_tutorial(key, time)
#warning-ignore:UNUSED_SIGNAL
signal speed_updated(speed)
#warning-ignore:UNUSED_SIGNAL
signal position_updated(position)
#warning-ignore:UNUSED_SIGNAL
signal ui_message(RTL_message)

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
#warning-ignore:UNUSED_SIGNAL
signal trigger_entity_animation(animation)

#==== OPTIONS =====
#warning-ignore:UNUSED_SIGNAL
signal change_key_popup(action)
#warning-ignore:UNUSED_SIGNAL
signal update_keys
#warning-ignore:UNUSED_SIGNAL
signal save_cfg_popup(cfg_path, cfg_name, cfg)
#warning-ignore:UNUSED_SIGNAL
signal add_cfg_popup(cfg_path, cfg)
#warning-ignore:UNUSED_SIGNAL
signal update_crosshair(path, color, scale)
#warning-ignore:UNUSED_SIGNAL
signal update_fov(value)
#warning-ignore:UNUSED_SIGNAL
signal update_wall_ride_strategy
#warning-ignore:UNUSED_SIGNAL
signal update_settings

#==== MISC =====
#warning-ignore:UNUSED_SIGNAL
signal entity_destroyed
#warning-ignore:UNUSED_SIGNAL
signal glitch_audio(part)

##### VARIABLES #####
#==== PLAYER =====
const RESPAWN_PLAYER_ON_LAST_CP := "respawn_player_on_last_cp"
const PLAYER_RESPAWNED_ON_LAST_CP := "player_respawned_on_last_cp"
const TRIGGER_TUTORIAL := "trigger_tutorial"
const SPEED_UPDATED := "speed_updated"
const POSITION_UPDATED := "position_updated"
const UI_MESSAGE := "ui_message"

#==== MAP =====
const CHECKPOINT_TRIGGERED := "checkpoint_triggered"
const END_REACHED := "end_reached"
const START_LEVEL_CHRONOMETER := "start_level_chronometer"
const WALL_BROKEN := "wall_broken"

#==== VISUALS =====
const SEQUENCER_STEP := "sequencer_step"
const TRIGGER_ENTITY_ANIMATION := "trigger_entity_animation"

#==== OPTIONS =====
const CHANGE_KEY_POPUP := "change_key_popup"
const UPDATE_KEYS := "update_keys"
const SAVE_CFG_POPUP := "save_cfg_popup"
const ADD_CFG_POPUP := "add_cfg_popup"
const UPDATE_CROSSHAIR := "update_crosshair"
const UPDATE_FOV := "update_fov"
const UPDATE_WALL_RIDE_STRATEGY := "update_wall_ride_strategy"
const UPDATE_SETTINGS := "update_settings"

#==== MISC =====
const ENTITY_DESTROYED := "entity_destroyed"
const GAME_OVER := "game_over"
const GLITCH_AUDIO := "glitch_audio"


##### PUBLIC METHODS #####
#==== PLAYER =====
func emit_respawn_player_on_last_cp() -> void:
	emit_signal(RESPAWN_PLAYER_ON_LAST_CP)


func emit_player_respawned_on_last_cp() -> void:
	emit_signal(PLAYER_RESPAWNED_ON_LAST_CP)


func emit_trigger_tutorial(key: String, time: float) -> void:
	if GlobalParameters.TUTORIALS_ENABLED:
		emit_signal(TRIGGER_TUTORIAL, key, time)


func emit_speed_updated(speed: float) -> void:
	emit_signal(SPEED_UPDATED, speed)


func emit_position_updated(position: Vector3) -> void:
	emit_signal(POSITION_UPDATED, position)


func emit_ui_message(RTL_message: String) -> void:
	emit_signal(UI_MESSAGE, RTL_message)


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


func emit_trigger_entity_animation(animation: String) -> void:
	emit_signal(TRIGGER_ENTITY_ANIMATION, animation)


#==== SETTINGS =====
func emit_change_key_popup(action: String) -> void:
	emit_signal(CHANGE_KEY_POPUP, action)


func emit_update_keys() -> void:
	emit_signal(UPDATE_KEYS)


func emit_save_cfg_popup(cfg_path: String, cfg_name: String, cfg: ConfigFile) -> void:
	emit_signal(SAVE_CFG_POPUP, cfg_path, cfg_name, cfg)


func emit_add_cfg_popup(cfg_path: String, cfg: ConfigFile) -> void:
	emit_signal(ADD_CFG_POPUP, cfg_path, cfg)


func emit_update_crosshair(path: String, color: Color, scale: float) -> void:
	emit_signal(UPDATE_CROSSHAIR, path, color, scale)


func emit_update_fov(value: float) -> void:
	emit_signal(UPDATE_FOV, value)


func emit_update_wall_ride_strategy() -> void:
	emit_signal(UPDATE_WALL_RIDE_STRATEGY)

func emit_update_settings() -> void:
	emit_signal(UPDATE_SETTINGS)

#==== MISC =====
func emit_entity_destroyed() -> void:
	emit_signal(ENTITY_DESTROYED)


func emit_game_over() -> void:
	emit_signal(GAME_OVER)

func emit_glitch_audio(part : int) -> void:
	emit_signal(GLITCH_AUDIO, part)