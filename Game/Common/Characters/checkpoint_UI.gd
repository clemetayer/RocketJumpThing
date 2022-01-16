extends CanvasLayer
# Effect that appear when entering a checkpoint

##### VARIABLES #####
#---- CONSTANTS -----
const ATTACK_TIME := .25  # Time it takes for the text to fade in
const DECAY_TIME := .5  # Time the text stays on the screen
const RELEASE_TIME := ATTACK_TIME  # Time it takes for the text to fade out


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	if (
		SignalManager.connect(
			"checkpoint_triggered", self, "_on_SignalManager_checkpoint_triggered"
		)
		!= OK
	):
		Logger.error(
			(
				"Error connecting %s to %s in %s"
				% [
					"checkpoint_triggered",
					"_on_SignalManager_checkpoint_triggered",
					DebugUtils.print_stack_trace(get_stack())
				]
			)
		)


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer.modulate.a = 0
	$CenterContainer/MarginContainer/RichTextLabel.set_bbcode(
		TextUtils.BBCode_center_text(
			TextUtils.BBCode_color_text(
				TextUtils.BBCode_wave_text(tr("player_ui_checkpoint")), "#00ff2a"
			)
		)
	)


##### PROTECTED METHODS #####
# displays the effect when triggering a checkpoint
func _display_effect() -> void:
	var tween := Tween.new()
	add_child(tween)
	var col: Color = $CenterContainer.modulate
	tween.interpolate_property(
		$CenterContainer, "modulate", col, Color(col.r, col.g, col.b, 1), ATTACK_TIME
	)
	tween.start()
	yield(tween, "tween_all_completed")
	yield(get_tree().create_timer(DECAY_TIME), "timeout")
	tween.interpolate_property(
		$CenterContainer, "modulate", Color(col.r, col.g, col.b, 1), col, RELEASE_TIME
	)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.queue_free()


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_checkpoint_triggered(checkpoint: Checkpoint) -> void:
	_display_effect()
