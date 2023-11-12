extends Spatial
# Main menu background script

##### VARIABLES #####
#---- EXPORTS -----
export(GradientTexture) var MAIN_MENU_GRADIENT
export(Color) var MAIN_MENU_PARTICLES_COLOR
export(GradientTexture) var SETTINGS_MENU_GRADIENT
export(Color) var SETTINGS_MENU_PARTICLES_COLOR
export(GradientTexture) var LEVEL_SELECT_MENU_GRADIENT
export(Color) var LEVEL_SELECT_MENU_PARTICLES_COLOR

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"camera_focus":$"CameraFocus",
	"color_tween": $"ChangeCubeColorTween",
	"cube":$"Cube",
	"particles":$"Particles"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_init_skybox()

##### PUBLIC METHODS #####
# turns on or of the cube particles around the... cube
func toggle_particles(value : bool) -> void:
	if onready_paths != null and onready_paths.particles != null:
		onready_paths.particles.emitting = value

##### PROTECTED METHODS #####
func _connect_signals() -> void:
	DebugUtils.log_connect(MenuNavigator,self,MenuNavigator.MENU_ACTIVATED_SIGNAL_NAME,"_on_MenuNavigator_menu_activated")

func _init_skybox() -> void:
	if get_tree() != null:
		var skyboxes = get_tree().get_nodes_in_group(GlobalConstants.SKYBOX_GROUP)
		if skyboxes != null and skyboxes.size() > 0 and skyboxes[0] is Skybox:
			skyboxes[0].set_target(onready_paths.camera_focus)

func _change_cubes_color(main_color : Color, gradient : GradientTexture) -> void:
	# Stops the current tween
	DebugUtils.log_tween_stop_all(onready_paths.color_tween)
	# Cube border
	DebugUtils.log_tween_interpolate_property(
		onready_paths.color_tween,
		onready_paths.cube.get_border_material(),
		"albedo_color",
		onready_paths.cube.get_border_material().albedo_color,
		main_color,
		MenuNavigator.TRANSITION_TIME
	)
	DebugUtils.log_tween_interpolate_property(
		onready_paths.color_tween,
		onready_paths.cube.get_border_material(),
		"emission",
		onready_paths.cube.get_border_material().emission,
		main_color,
		MenuNavigator.TRANSITION_TIME
	)
	# Cube faces
	DebugUtils.log_tween_interpolate_method(
		onready_paths.color_tween,
		onready_paths.cube,
		"update_gradient_1",
		onready_paths.cube.get_face_gradient().gradient.get_color(0),
		gradient.gradient.get_color(0),
		MenuNavigator.TRANSITION_TIME
	)
	DebugUtils.log_tween_interpolate_method(
		onready_paths.color_tween,
		onready_paths.cube,
		"update_gradient_2",
		onready_paths.cube.get_face_gradient().gradient.get_color(1),
		gradient.gradient.get_color(1),
		MenuNavigator.TRANSITION_TIME
	)
	# Particles
	DebugUtils.log_tween_interpolate_property(
		onready_paths.color_tween,
		onready_paths.particles.process_material,
		"color",
		onready_paths.particles.process_material.color,
		main_color,
		MenuNavigator.TRANSITION_TIME
	)
	# Start the tween
	DebugUtils.log_tween_start(onready_paths.color_tween)

	

##### SIGNAL MANAGEMENT #####
func _on_MenuNavigator_menu_activated(menu_id : int) -> void:
	match menu_id:
		MenuNavigator.MENU.main:
			_change_cubes_color(MAIN_MENU_PARTICLES_COLOR,MAIN_MENU_GRADIENT)
		MenuNavigator.MENU.settings:
			_change_cubes_color(SETTINGS_MENU_PARTICLES_COLOR,SETTINGS_MENU_GRADIENT)
		MenuNavigator.MENU.level_select:
			_change_cubes_color(LEVEL_SELECT_MENU_PARTICLES_COLOR,LEVEL_SELECT_MENU_GRADIENT)
