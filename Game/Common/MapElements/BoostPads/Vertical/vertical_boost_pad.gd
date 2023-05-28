extends VerticalBoost
# Area that pushes the player up like a bumper

##### VARIABLES #####
#---- CONSTANTS -----
const ROCKET_BOOST_COLOR := Color.white  # Color of the boosted boost pad
const TB_VBOOST_PAD_MAPPER := [["color", "_color"]]  # mapper for TrenchBroom parameters

#---- STANDARD -----
#==== PRIVATE ====
var _color := Color.white  # general color of the bumper
var _gradient_color := Color.white  # color of the gradient for the tweens that changes

#==== ONREADY ====
onready var onready_paths := {
	"collision": $"Collision",
	"triangle_particles": $"TriangleParticles",
	"square_particles": $"UpSquares",
	"mesh": $"LightBumperMesh"
}
onready var onready_gradient_tween := Tween.new()


##### PROTECTED METHODS #####
# ready function to override if necessary
func _ready() -> void:
	._ready_func()
	_set_colors()


func _connect_signals() -> void:
	._connect_signals()
	DebugUtils.log_connect(onready_gradient_tween, self, "tween_step", "_on_gradient_tween_step")


func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_VBOOST_PAD_MAPPER)


func _get_collision() -> Node:
	return onready_paths.collision


# sets the extents of the different boxes used (particle boxes, collision, etc.)
func _set_extents() -> void:
	._set_extents()
	onready_paths.triangle_particles.process_material.emission_box_extents = _size
	onready_paths.triangle_particles.draw_pass_1.size = (Vector3(
		_size.x / 10.0, _size.y / 10.0, _size.z / 40.0
	))
	onready_paths.triangle_particles.process_material.initial_velocity = _size.y
	onready_paths.square_particles.draw_pass_1.size = (Vector3(_size.x, 0.0, _size.z) * 4.0)
	onready_paths.square_particles.process_material.initial_velocity = _size.y
	onready_paths.mesh.mesh.size = (Vector3(_size.x * 0.75, _size.y / 20.0, _size.z * 0.75) * 2.0)


# sets the different colors in the bumper
func _set_colors() -> void:
	onready_paths.triangle_particles.process_material.color_ramp.gradient.colors[0] = _color
	onready_paths.triangle_particles.process_material.color_ramp.gradient.colors[1] = Color(
		_color.r, _color.g, _color.b, 0.0
	)
	onready_paths.square_particles.process_material.color_ramp.gradient.colors[0] = _color
	onready_paths.square_particles.process_material.color_ramp.gradient.colors[1] = Color(
		_color.r, _color.g, _color.b, 0.0
	)
	onready_paths.mesh.mesh.material.albedo_color = _color
	onready_paths.mesh.mesh.material.emission = _color


# sets the properties of the tween when a rocket interacts with the area
func _set_rocket_tween_properties() -> void:
	._set_rocket_tween_properties()
	DebugUtils.log_tween_interpolate_property(
		onready_gradient_tween,
		self,
		"_gradient_color",
		ROCKET_BOOST_COLOR,
		_color,
		ROCKET_BOOST_DECAY
	)
	DebugUtils.log_tween_interpolate_property(
		onready_rocket_tween,
		onready_paths.mesh,
		"mesh:material:albedo_color",
		ROCKET_BOOST_COLOR,
		_color,
		ROCKET_BOOST_DECAY
	)
	DebugUtils.log_tween_interpolate_property(
		onready_rocket_tween,
		onready_paths.mesh,
		"mesh:material:emission",
		ROCKET_BOOST_COLOR,
		_color,
		ROCKET_BOOST_DECAY
	)


##### SIGNAL MANAGEMENT #####
func _on_area_entered(area: Node) -> void:
	DebugUtils.log_tween_stop_all(onready_gradient_tween)
	._on_area_entered(area)
	if FunctionUtils.is_rocket(area):
		DebugUtils.log_tween_start(onready_gradient_tween)


func _on_gradient_tween_step(
	_object: Object, _key: NodePath, _elapsed: float, _value: Object
) -> void:
	onready_paths.square_particles.process_material.color_ramp.gradient.colors[0] = _gradient_color
	onready_paths.triangle_particles.process_material.color_ramp.gradient.colors[0] = _gradient_color
