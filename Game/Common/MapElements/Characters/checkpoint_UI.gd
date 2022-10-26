extends CanvasLayer
# Effect that appear when entering a checkpoint
# TODO : arrivé ici

##### VARIABLES #####
#---- CONSTANTS -----
const ATTACK_TIME := .25  # Time it takes for the text to fade in
const DECAY_TIME := .5  # Time the text stays on the screen
const RELEASE_TIME := ATTACK_TIME  # Time it takes for the text to fade out
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"root": $"CenterContainer", "rich_text_label": $"CenterContainer/MarginContainer/RichTextLabel"
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_UI()


##### PROTECTED METHODS #####
func _init_UI() -> void:
	if onready_paths.root != null:
		onready_paths.root.modulate.a = 0
	if onready_paths.rich_text_label != null:
		onready_paths.rich_text_label.set_bbcode(
			TextUtils.BBCode_center_text(
				TextUtils.BBCode_color_text(
					TextUtils.BBCode_wave_text(tr("player_ui_checkpoint")), "#00ff2a"
				)
			)
		)


func _connect_signals() -> void:
	DebugUtils.log_connect(
		SignalManager,
		self,
		SignalManager.CHECKPOINT_TRIGGERED,
		"_on_SignalManager_checkpoint_triggered"
	)


# displays the effect when triggering a checkpoint
func _display_effect() -> void:
	var tween := get_node("FadeTween")
	if not tween.is_active() and onready_paths != null:
		var col: Color = onready_paths.root.modulate
		DebugUtils.log_tween_interpolate_property(
			tween,
			onready_paths.root,
			"modulate",
			Color(col.r, col.g, col.b, 0),
			Color(col.r, col.g, col.b, 1),
			ATTACK_TIME
		)
		DebugUtils.log_tween_start(tween)
		yield(tween, "tween_all_completed")
		yield(get_tree().create_timer(DECAY_TIME), "timeout")
		DebugUtils.log_tween_interpolate_property(
			tween,
			onready_paths.root,
			"modulate",
			Color(col.r, col.g, col.b, 1),
			Color(col.r, col.g, col.b, 0),
			ATTACK_TIME
		)
		DebugUtils.log_tween_start(tween)
		yield(tween, "tween_all_completed")


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_checkpoint_triggered(_checkpoint: Checkpoint) -> void:
	_display_effect()
