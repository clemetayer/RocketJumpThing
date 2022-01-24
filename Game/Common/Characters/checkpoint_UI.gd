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
	var tween := get_node("FadeTween")
	if not tween.is_active():
		var col: Color = $CenterContainer.modulate
		if ! tween.interpolate_property(
			$CenterContainer,
			"modulate",
			Color(col.r, col.g, col.b, 0),
			Color(col.r, col.g, col.b, 1),
			ATTACK_TIME
		):
			Logger.error(
				(
					"Error while setting tween interpolate property %s at %s"
					% ["modulate", DebugUtils.print_stack_trace(get_stack())]
				)
			)
		if ! tween.start():
			Logger.error(
				"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
			)
		yield(tween, "tween_all_completed")
		yield(get_tree().create_timer(DECAY_TIME), "timeout")
		if ! tween.interpolate_property(
			$CenterContainer,
			"modulate",
			Color(col.r, col.g, col.b, 1),
			Color(col.r, col.g, col.b, 0),
			RELEASE_TIME
		):
			Logger.error(
				(
					"Error while setting tween interpolate property %s at %s"
					% ["modulate", DebugUtils.print_stack_trace(get_stack())]
				)
			)
		if ! tween.start():
			Logger.error(
				"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
			)
		yield(tween, "tween_all_completed")


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_checkpoint_triggered(_checkpoint: Checkpoint) -> void:
	_display_effect()
