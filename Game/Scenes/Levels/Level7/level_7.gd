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
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_breakable_links()


##### PUBLIC METHODS #####
func toggle_glitch(enabled: bool) -> void:
	GlobalScreenEffects.toggle_effect(GlobalScreenEffects.EFFECTS.glitch, enabled)


func switch_to_credits() -> void:
	VariableManager.scene_unloading = true
	SignalManager.emit_game_over()  # TODO : keep all the times for the "Credits scene"


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
	ScenesManager.load_end()
