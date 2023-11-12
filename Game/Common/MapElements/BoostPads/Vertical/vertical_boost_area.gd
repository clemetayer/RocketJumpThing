extends VerticalBoost
# Area that pushes the player Up like a cool vortex

##### VARIABLES #####
#---- CONSTANTS -----
const TB_VBOOST_AREA_MAPPER := [["color", "_color"]]  # mapper for TrenchBroom parameters
#---- STANDARD -----
#==== PRIVATE ====
var _color := Color.white  # general color of the bumper

#==== ONREADY ====
onready var onready_paths := {
	"collision": $"Collision",
	"triangle_particles": $"TriangleParticles",
	"square_particles": $"UpSquares",
	"boost_sound": $"BoostSound"
}


##### PROTECTED METHODS #####
# ready function to override if necessary
func _ready() -> void:
	._ready_func()
	_set_colors()


func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_VBOOST_AREA_MAPPER)


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


# disables the boost when interacting with a rocket
func _on_area_entered(_area: Node) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	._on_body_entered(body)
	if FunctionUtils.is_player(body):
		onready_paths.boost_sound.play()
