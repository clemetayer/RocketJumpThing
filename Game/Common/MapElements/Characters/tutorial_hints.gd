extends CanvasLayer
# Script to prompt tutorial messages to the player
# Disclaimer : The way to do it is pretty ugly

##### VARIABLES #####
#---- CONSTANTS -----
const DIRECTION_SCENE_PATH := "res://Misc/UI/Icons/wasd_element.tscn"
const SINGLE_INPUT_SCENE_PATH := "res://Misc/UI/Icons/single_key.tscn"
const MOUSE_SCENE_PATH := "res://Misc/UI/Icons/mouse.tscn"
const BOOST_PAD_SCENE := "res://Misc/UI/Icons/boost_pad.tscn"
const ROCKET_ICON_PATH := "res://Misc/UI/Icons/Kenney/rocket.png"
const ROCKET_JUMP_ICON_PATH := "res://Misc/UI/Icons/Kenney/rocket_jump.png"
const ENGINE_SLOW_DOWN_AMOUNT = 0.125  # How much the engine will slow down to display the tutorial
const ENGINE_TUTORIAL_SHOW_TIME = 0.25  # Time to show and slow down the engine to display the tutotial (Note : it is an approximation since the tween will be affected by the engine slowdown as well)
#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"screen_root": $"Screen", "label": $"Screen/CenterContainer/Label"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	DebugUtils.log_connect(
		SignalManager, self, SignalManager.TRIGGER_TUTORIAL, "_on_SignalManager_trigger_tutorial"
	)
	onready_paths.screen_root.modulate.a = 0.0
	onready_paths.label.set_text("")


##### PUBLIC METHODS ######
# Displays the text of a tutorial key for a given time (in seconds)
func display_tutorial(key: String, time: float) -> void:
	var color_tween := Tween.new()  # color of the canvas
	var engine_time_scale_tween := Tween.new()  # time scale for slow motion
	DebugUtils.log_tween_interpolate_property(
		color_tween,
		onready_paths.screen_root,
		"modulate",
		Color(1, 1, 1, 0.0),
		Color(1, 1, 1, 1.0),
		ENGINE_TUTORIAL_SHOW_TIME
	)
	DebugUtils.log_tween_interpolate_method(
		engine_time_scale_tween,
		Engine,
		"set_time_scale",
		1.0,
		ENGINE_SLOW_DOWN_AMOUNT,
		ENGINE_TUTORIAL_SHOW_TIME
	)
	add_child(color_tween)
	add_child(engine_time_scale_tween)
	DebugUtils.log_tween_start(color_tween)
	DebugUtils.log_tween_start(engine_time_scale_tween)
	onready_paths.screen_root.show()
	_set_tutorial_text(key)
	# onready_paths.label.set_text(TextUtils.replace_elements(tr(key), _keys_dict))
	yield(color_tween, "tween_all_completed")
	yield(get_tree().create_timer(time), "timeout")
	DebugUtils.log_tween_interpolate_property(
		color_tween,
		onready_paths.screen_root,
		"modulate",
		Color(1, 1, 1, 1.0),
		Color(1, 1, 1, 0.0),
		ENGINE_TUTORIAL_SHOW_TIME
	)
	DebugUtils.log_tween_interpolate_method(
		engine_time_scale_tween,
		Engine,
		"set_time_scale",
		ENGINE_SLOW_DOWN_AMOUNT,
		1.0,
		ENGINE_TUTORIAL_SHOW_TIME
	)
	DebugUtils.log_tween_start(color_tween)
	DebugUtils.log_tween_start(engine_time_scale_tween)
	yield(color_tween, "tween_all_completed")
	color_tween.queue_free()
	engine_time_scale_tween.queue_free()
	onready_paths.screen_root.hide()
	onready_paths.label.set_text("")


##### PROTECTED METHODS #####
func _replace_boost_pad(enhanced: bool) -> Control:
	var boost_pad_scene = load(BOOST_PAD_SCENE).instance()
	boost_pad_scene.enhanced = enhanced
	return boost_pad_scene


func _replace_rocket_jump_icon() -> Control:
	return _create_texture_rect_from_path(ROCKET_JUMP_ICON_PATH)


func _replace_rocket_icon() -> Control:
	return _create_texture_rect_from_path(ROCKET_ICON_PATH)


func _replace_shoot() -> Control:
	return _match_input_type(GlobalConstants.TR_REPLACE_TUTORIAL_ACTION_SHOOT)


func _replace_restart_last_cp() -> Control:
	return _match_input_type(GlobalConstants.TR_REPLACE_TUTORIAL_RESTART_LAST_CP)


func _replace_restart() -> Control:
	return _match_input_type(GlobalConstants.TR_REPLACE_TUTORIAL_RESTART)


func _replace_strafe(forward: bool, backward: bool, left: bool, right: bool) -> Control:
	# TODO : Replace here if there is a joypad integration, and maybe if for some reason the player wants to strafe using keyboard keys (???)
	var mouse_scene = load(MOUSE_SCENE_PATH).instance()
	mouse_scene.set_elements(forward, backward, left, right, false, false)
	return mouse_scene


func _replace_slide() -> Control:
	return _match_input_type(GlobalConstants.TR_REPLACE_TUTORIAL_MVT_SLIDE)


func _replace_jump() -> Control:
	return _match_input_type(GlobalConstants.TR_REPLACE_TUTORIAL_MVT_JUMP)


func _replace_move_direction(
	forward: bool, backward: bool, left: bool, right: bool
) -> CenterContainer:
	var direction_scene = load(DIRECTION_SCENE_PATH).instance()
	direction_scene.set_emphasis(forward, backward, left, right)
	return direction_scene


func _call_replace_method(key: String) -> Control:
	var control = Control.new()  # empty control in case it is not a recognozed string
	match key:
		GlobalConstants.TR_REPLACE_TUTORIAL_MVT_WASD:
			control = _replace_move_direction(true, true, true, true)
		GlobalConstants.TR_REPLACE_TUTORIAL_MVT_WA:
			control = _replace_move_direction(true, false, true, false)
		GlobalConstants.TR_REPLACE_TUTORIAL_MVT_WD:
			control = _replace_move_direction(true, false, false, true)
		GlobalConstants.TR_REPLACE_TUTORIAL_MVT_W:
			control = _replace_move_direction(true, false, false, false)
		GlobalConstants.TR_REPLACE_TUTORIAL_MVT_JUMP:
			control = _replace_jump()
		GlobalConstants.TR_REPLACE_TUTORIAL_MVT_SLIDE:
			control = _replace_slide()
		GlobalConstants.TR_REPLACE_TUTORIAL_MOUSE_STRAFE_LEFT:
			control = _replace_strafe(false, false, true, false)
		GlobalConstants.TR_REPLACE_TUTORIAL_MOUSE_STRAFE_RIGHT:
			control = _replace_strafe(false, false, false, true)
		GlobalConstants.TR_REPLACE_TUTORIAL_MOUSE_STRAFE_LEFT_RIGHT:
			control = _replace_strafe(false, false, true, true)
		GlobalConstants.TR_REPLACE_TUTORIAL_RESTART:
			control = _replace_restart()
		GlobalConstants.TR_REPLACE_TUTORIAL_RESTART_LAST_CP:
			control = _replace_restart_last_cp()
		GlobalConstants.TR_REPLACE_TUTORIAL_ACTION_SHOOT:
			control = _replace_shoot()
		GlobalConstants.TR_REPLACE_TUTORIAL_ROCKET_ICON:
			control = _replace_rocket_icon()
		GlobalConstants.TR_REPLACE_TUTORIAL_ROCKET_JUMP_ICON:
			control = _replace_rocket_jump_icon()
		GlobalConstants.TR_REPLACE_TUTORIAL_BOOST_PAD:
			control = _replace_boost_pad(false)
		GlobalConstants.TR_REPLACE_TUTORIAL_BOOST_PAD_ENHANCED:
			control = _replace_boost_pad(true)
		_:
			control = Label.new()
			control.set_text(key)
	return control


func _match_input_type(input_name: String) -> Control:
	var control = Control.new()
	var input_list = InputMap.get_action_list(input_name)
	if input_list.size() > 0:
		if input_list[0] is InputEventKey:
			control = _handle_keyboard_input(input_list[0])
		elif input_list[0] is InputEventMouseButton:
			control = _handle_mouse_input(input_list[0])
		elif input_list[0] is InputEventJoypadButton:
			control = _handle_joypad_input(input_list[0])
	return control


func _handle_keyboard_input(input: InputEventKey) -> Control:
	var single_input_scene = load(SINGLE_INPUT_SCENE_PATH).instance()
	single_input_scene.key_text = input.as_text()
	single_input_scene.pressed = true
	return single_input_scene


func _handle_mouse_input(input: InputEventMouseButton) -> Control:
	var mouse_scene = load(MOUSE_SCENE_PATH).instance()
	mouse_scene.set_elements(
		false,
		false,
		false,
		false,
		input.button_index == BUTTON_LEFT,
		input.button_index == BUTTON_RIGHT
	)
	return mouse_scene


func _handle_joypad_input(_input: InputEventJoypadButton) -> Control:
	# TODO : Complete this for joypad integration
	return Control.new()


func _set_tutorial_text(key: String) -> void:
	var vbox_node = get_node("Screen/CenterContainer/VBoxContainer")
	for child in vbox_node.get_children():
		child.queue_free()
	var key_str := tr(
		(
			TrenchBroomEntityUtils.TB_TR_MAPPER[key]
			if TrenchBroomEntityUtils.TB_TR_MAPPER.has(key)
			else key
		)
	)
	var split_line := key_str.split("\n")  # splits all the \n to later put these in an HBox container
	for line in split_line:
		var split_array = line.split(GlobalConstants.TR_REPLACE_PATTERN)
		var hbox := HBoxContainer.new()
		for part in split_array:
			hbox.add_child(_call_replace_method(part))
		vbox_node.add_child(hbox)


func _create_texture_rect_from_path(path: String) -> TextureRect:
	var texture_rect := TextureRect.new()
	var texture: StreamTexture = load(path)
	texture_rect.texture = texture
	return texture_rect


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_trigger_tutorial(key: String, time: float) -> void:
	display_tutorial(key, time)
