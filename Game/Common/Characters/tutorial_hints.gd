extends CanvasLayer
# Script to prompt tutorial messages to the player

##### VARIABLES #####
#---- CONSTANTS -----
const ENGINE_SLOW_DOWN_AMOUNT = 0.125  # How much the engine will slow down to display the tutorial
const ENGINE_TUTORIAL_SHOW_TIME = 0.25  # Time to show and slow down the engine to display the tutotial (Note : it is an approximation since the tween will be affected by the engine slowdown as well)
const REPLACE_STRING := [  # substrings that can be replaced in texts
	"##movement_wasd##",
	"##movement_wa##",
	"##movement_wd##",
	"##movement_w##",
	"##movement_jump##",
	"##movement_slide##",
	"##mouse_strafe_left##",
	"##mouse_strafe_right##",
	"##mouse_strafe_left_right##",
	"##restart##",
	"##restart_last_cp##"
]
const PATHS = {
	"wasd_elements_path": "res://Misc/UI/Icons/wasd_element.tscn",
	"single_key_path": "res://Misc/UI/Icons/single_key.tscn",
	"mouse_icon_path": "res://Misc/UI/Icons/Kenney/mouse.png",
	"l_arrow_icon_path": "res://Misc/UI/Icons/Kenney/arrowLeft.png",
	"r_arrow_icon_path": "res://Misc/UI/Icons/Kenney/arrowRight.png"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	FunctionUtils.log_connect(
		SignalManager, self, "trigger_tutorial", "_on_SignalManager_trigger_tutorial"
	)
	$Screen.hide()
	$Screen/CenterContainer/Label.set_text("")


##### PUBLIC METHODS ######
# Displays the text of a tutorial key for a given time (in seconds)
func display_tutorial(key: String, time: float) -> void:
	var color_tween := Tween.new()  # color of the canvas
	var engine_time_scale_tween := Tween.new()  # time scale for slow motion
	if !color_tween.interpolate_property(
		$Screen, "modulate", Color(1, 1, 1, 0.0), Color(1, 1, 1, 1.0), ENGINE_TUTORIAL_SHOW_TIME
	):
		Logger.error(
			(
				"Error while setting tween interpolate property %s at %s"
				% ["modulate", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if !engine_time_scale_tween.interpolate_method(
		Engine, "set_time_scale", 1.0, ENGINE_SLOW_DOWN_AMOUNT, ENGINE_TUTORIAL_SHOW_TIME
	):
		Logger.error(
			(
				"Error while setting tween interpolate method %s at %s"
				% ["set_time_scale", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	add_child(color_tween)
	add_child(engine_time_scale_tween)
	if !color_tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	if !engine_time_scale_tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	$Screen.show()
	_set_tutorial_text(key)
	# $Screen/CenterContainer/Label.set_text(TextUtils.replace_elements(tr(key), _keys_dict))
	yield(color_tween, "tween_all_completed")
	yield(get_tree().create_timer(time), "timeout")
	if !color_tween.interpolate_property(
		$Screen, "modulate", Color(1, 1, 1, 1.0), Color(1, 1, 1, 0.0), ENGINE_TUTORIAL_SHOW_TIME
	):
		Logger.error(
			(
				"Error while setting tween interpolate property %s at %s"
				% ["modulate", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if !engine_time_scale_tween.interpolate_method(
		Engine, "set_time_scale", ENGINE_SLOW_DOWN_AMOUNT, 1.0, ENGINE_TUTORIAL_SHOW_TIME
	):
		Logger.error(
			(
				"Error while setting tween interpolate method %s at %s"
				% ["set_time_scale", DebugUtils.print_stack_trace(get_stack())]
			)
		)
	if !color_tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	if !engine_time_scale_tween.start():
		Logger.error(
			"Error when starting tween at %s" % [DebugUtils.print_stack_trace(get_stack())]
		)
	yield(color_tween, "tween_all_completed")
	color_tween.queue_free()
	engine_time_scale_tween.queue_free()
	$Screen.hide()
	$Screen/CenterContainer/Label.set_text("")


##### PROTECTED METHODS #####
func _set_tutorial_text(key: String) -> void:
	var vbox_node = get_node("Screen/CenterContainer/VBoxContainer")
	for child in vbox_node.get_children():
		child.queue_free()
	var key_str := tr(key)
	var split_line := key_str.split("\n")  # splits all the \n to later put these in an HBox container
	for line in split_line:
		var split_array = line.split("##")
		var hbox := HBoxContainer.new()
		for part in split_array:
			hbox.add_child(_handle_str_part(part))
		vbox_node.add_child(hbox)


func _handle_str_part(part: String):
	if (
		part == "movement_w"
		or part == "movement_wasd"
		or part == "movement_wa"
		or part == "movement_wd"
	):
		var wasd_element_scene = load(PATHS.wasd_elements_path).instance()
		match part:
			"movement_w":
				wasd_element_scene.emphase_keys = {"W": true, "A": false, "S": false, "D": false}
			"movement_wa":
				wasd_element_scene.emphase_keys = {"W": true, "A": true, "S": false, "D": false}
			"movement_wd":
				wasd_element_scene.emphase_keys = {"W": true, "A": false, "S": false, "D": true}
			"movement_wasd":
				wasd_element_scene.emphase_keys = {"W": true, "A": true, "S": true, "D": true}
		wasd_element_scene.set_emphasis()
		return wasd_element_scene
	if (
		part == "mouse_strafe_left"
		or part == "mouse_strafe_right"
		or part == "mouse_strafe_left_right"
	):
		var hbox := HBoxContainer.new()
		var mouse_tex := _create_texture_rect_from_path(PATHS.mouse_icon_path)
		match part:
			"mouse_strafe_left":
				hbox.add_child(_create_texture_rect_from_path(PATHS.l_arrow_icon_path))
				hbox.add_child(mouse_tex)
			"mouse_strafe_right":
				hbox.add_child(mouse_tex)
				hbox.add_child(_create_texture_rect_from_path(PATHS.r_arrow_icon_path))
			"mouse_strafe_left_right":
				hbox.add_child(_create_texture_rect_from_path(PATHS.l_arrow_icon_path))
				hbox.add_child(mouse_tex)
				hbox.add_child(_create_texture_rect_from_path(PATHS.r_arrow_icon_path))
		return hbox
	if (
		part == "movement_jump"
		or part == "movement_slide"
		or part == "restart"
		or part == "restart_last_cp"
	):
		var single_key_scene = load(PATHS.single_key_path).instance()
		match part:
			"movement_jump":
				single_key_scene.key_text = InputMap.get_action_list("movement_jump")[0].as_text()
				single_key_scene.pressed = true
			"movement_slide":
				single_key_scene.key_text = InputMap.get_action_list("movement_slide")[0].as_text()
				single_key_scene.pressed = true
			"restart":
				single_key_scene.key_text = InputMap.get_action_list("restart")[0].as_text()
				single_key_scene.pressed = true
			"restart_last_cp":
				single_key_scene.key_text = InputMap.get_action_list("restart_last_cp")[0].as_text()
				single_key_scene.pressed = true
		return single_key_scene
	else:  # returns a standard label with the string
		var label := Label.new()
		label.set_text(part)
		return label


func _create_texture_rect_from_path(path: String) -> TextureRect:
	var texture_rect := TextureRect.new()
	var texture := ImageTexture.new()
	var image := Image.new()
	image.load(path)
	texture.create_from_image(image)
	texture_rect.texture = texture
	return texture_rect


##### SIGNAL MANAGEMENT #####
func _on_SignalManager_trigger_tutorial(key: String, time: float) -> void:
	display_tutorial(key, time)
