extends Particles
# Broken wall particles (when the wall is broken)

##### SIGNALS #####
signal break_emission_done

##### VARIABLES #####
#---- CONSTANTS -----
const STD_PIECES_SIZE = 1.0 / 30.0
const STD_FORCE = 2


##### PUBLIC METHODS #####
# Inits the particles with the breakable wall data
func init_particles(mesh_aabb: AABB, mesh_material: Material) -> void:
	# sets the emission box
	process_material.emission_box_extents = mesh_aabb.size
	# sets the draw pass size
	draw_pass_1.size = (
		Vector3.ONE
		* STD_PIECES_SIZE
		* (mesh_aabb.size.x * mesh_aabb.size.y * mesh_aabb.size.z)
	)
	# sets the draw pass material
	var part_mat = mesh_material.duplicate()
	if part_mat is SpatialMaterial:
		part_mat.flags_transparent = true
		part_mat.vertex_color_use_as_albedo = true
	draw_pass_1.surface_set_material(0, part_mat)


# emits the break
func start_emit(direction: Vector3, force: float) -> void:
	var pos_diff = direction
	process_material.direction = pos_diff.normalized()
	process_material.initial_velocity = force * STD_FORCE
	process_material.angular_velocity = force * STD_FORCE
	emitting = true
	yield(get_tree().create_timer(lifetime), "timeout")
	emit_signal("break_emission_done")
