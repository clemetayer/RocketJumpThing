extends StandardScene
# class_name Class
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const RED_BREAKABLE_LINK_GROUP := "breakable_link_red"
const GREEN_BREAKABLE_LINK_GROUP := "breakable_link_green"
const ENTITY_DESTROYED_ANIMATION := "game_over"
const MIN_ENTITY_HP_TO_UPDATE_SONG := 3
const SONG_LAST_PART := "part_5"
const SONG_ENTITY_DESTROYED_PART := "part_6"
const ENTITY_ANIMATION_4 := "animation_4"
const ENTITY_ANIMATION_FIRE_LOOP := "fire_loop"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _entity: Spatial

#==== ONREADY ====
onready var onready_paths := {
	"scene_animation_player": $"AdditionalThings/AnimationPlayer",
	"entity_animation_player": $"AdditionalThings/EntityStuff/EntityAnimation",
	"entity": $"AdditionalThings/EntityStuff/TheEntity",
	"red_links_timer": $"AdditionalThings/Timers/UpdateRedLinksParticles"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_connect_breakable_links()


##### PUBLIC METHODS #####
func toggle_glitch(enabled: bool) -> void:
	GlobalScreenEffects.toggle_effect(GlobalScreenEffects.EFFECTS.glitch, enabled)

func glitch_audio(part : int) -> void:
	SignalManager.emit_glitch_audio(part)

func switch_to_credits() -> void:
	VariableManager.scene_unloading = true
	SignalManager.emit_game_over()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager,
		self,
		SignalManager.TRIGGER_ENTITY_ANIMATION,
		"_on_SignalManager_TriggerEntityAnimation"
	)
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.ENTITY_DESTROYED, "_on_SignalManager_GameOver"
	)
	DebugUtils.log_connect(onready_paths.entity,self,"health_updated","_on_entity_health_updated")
	DebugUtils.log_connect(SignalManager, self, SignalManager.PLAYER_RESPAWNED_ON_LAST_CP, "_on_SignalManager_player_respawned_on_last_cp")


func _connect_breakable_links() -> void:
	var red_links = get_tree().get_nodes_in_group(RED_BREAKABLE_LINK_GROUP)
	if red_links != null and red_links.size() > 0:
		for red_link in red_links:
			red_link.target = red_link.get_path_to(onready_paths.entity)
			DebugUtils.log_connect(
				onready_paths.red_links_timer, red_link, "timeout", "update_particles"
			)
	var green_links = get_tree().get_nodes_in_group(GREEN_BREAKABLE_LINK_GROUP)
	if green_links != null and green_links.size() > 0:
		for green_link in green_links:
			var green_link_targets = get_tree().get_nodes_in_group(
				green_link.get_target_group_name()
			)
			if green_link_targets != null and green_link_targets.size() > 0:
				green_link.target = green_link.get_path_to(green_link_targets[0])
				green_link.update_particles()


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_TriggerEntityAnimation(animation):
	if onready_paths.entity_animation_player != null:
		match animation:
			"explode":
				onready_paths.entity.shockwave()
			_:
				onready_paths.entity_animation_player.play(animation)


func _on_EmitStomp_timeout():
	SignalManager.emit_sequencer_step("stomp")


func _on_SignalManager_GameOver() -> void:
	onready_paths.scene_animation_player.play(ENTITY_DESTROYED_ANIMATION)
	yield(onready_paths.scene_animation_player,"animation_finished")
	switch_to_credits()
	ScenesManager.load_end()

func _on_entity_health_updated(health : int) -> void:
	var song = StandardSongManager.get_current().duplicate()
	var effect = FilterEffectManager.new()
	effect.TIME = 1.0
	if health <= MIN_ENTITY_HP_TO_UPDATE_SONG:
		song.ANIMATION = SONG_LAST_PART
		StandardSongManager.add_to_queue(song,effect)
	elif health <= 0:
		song.ANIMATION = SONG_ENTITY_DESTROYED_PART
		StandardSongManager.add_to_queue(song,effect)

func _on_SignalManager_player_respawned_on_last_cp() -> void:
	var current_entity_anim = onready_paths.entity_animation_player.current_animation
	if current_entity_anim == ENTITY_ANIMATION_4 or current_entity_anim == ENTITY_ANIMATION_FIRE_LOOP:
		# Reset the entity to a "neutral" animation to avoid spawnkilling the player
		onready_paths.entity.disappear()
		onready_paths.entity_animation_player.play("RESET")