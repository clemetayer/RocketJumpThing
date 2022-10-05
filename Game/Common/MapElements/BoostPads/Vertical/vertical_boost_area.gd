tool
extends VerticalBoost
# Area that pushes the player Up like a cool vortex

##### VARIABLES #####
#---- CONSTANTS -----
const TB_VBOOST_AREA_MAPPER := [["color", "color"]]  # mapper for TrenchBroom parameters
#---- STANDARD -----
#==== PRIVATE ====
var _color := Color.white  # general color of the bumper


##### PROTECTED METHODS #####
# init function to override if necessary
func _init_func() -> void:
	._init_func()
	NODE_PATHS = {
		"collision": @"Collision",
		"triangle_particles": @"TriangleParticles",
		"square_particles": @"UpSquares"
	}


# ready function to override if necessary
func _ready_func() -> void:
	._ready_func()
	_set_colors()


func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_VBOOST_AREA_MAPPER)


# makes some elements unique to avoid modifying other boosts (for example the collision shape)
func _duplicate_common_elements() -> void:
	._duplicate_common_elements()
	get_node(NODE_PATHS.triangle_particles).draw_pass_1 = get_node(
		NODE_PATHS.triangle_particles
	).draw_pass_1
	get_node(NODE_PATHS.triangle_particles).process_material = get_node(NODE_PATHS.triangle_particles).process_material.duplicate()
	get_node(NODE_PATHS.triangle_particles).process_material.color_ramp = get_node(NODE_PATHS.triangle_particles).process_material.color_ramp.duplicate()
	get_node(NODE_PATHS.square_particles).process_material = get_node(NODE_PATHS.square_particles).process_material.duplicate()
	get_node(NODE_PATHS.square_particles).process_material.color_ramp = get_node(NODE_PATHS.square_particles).process_material.color_ramp.duplicate()


# sets the extents of the different boxes used (particle boxes, collision, etc.)
func _set_extents() -> void:
	._set_extents()
	get_node(NODE_PATHS.triangle_particles).process_material.emission_box_extents = _size
	get_node(NODE_PATHS.triangle_particles).draw_pass_1.size = (Vector3(
		_size.x / 10.0, _size.y / 10.0, _size.z / 40.0
	))
	get_node(NODE_PATHS.triangle_particles).process_material.initial_velocity = _size.y
	get_node(NODE_PATHS.square_particles).draw_pass_1.size = (Vector3(_size.x, 0.0, _size.z) * 4.0)
	get_node(NODE_PATHS.square_particles).process_material.initial_velocity = _size.y


# sets the different colors in the bumper
func _set_colors() -> void:
	get_node(NODE_PATHS.triangle_particles).process_material.color_ramp.gradient.colors[0] = _color
	get_node(NODE_PATHS.triangle_particles).process_material.color_ramp.gradient.colors[1] = Color(
		_color.r, _color.g, _color.b, 0.0
	)
	get_node(NODE_PATHS.square_particles).process_material.color_ramp.gradient.colors[0] = _color
	get_node(NODE_PATHS.square_particles).process_material.color_ramp.gradient.colors[1] = Color(
		_color.r, _color.g, _color.b, 0.0
	)


# disables the boost when interacting with a rocket
func _on_area_entered(area: Node) -> void:
	pass
