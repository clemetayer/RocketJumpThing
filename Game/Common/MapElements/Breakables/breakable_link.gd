tool
extends Spatial
class_name BreakableLink
# a link to something with a breaking animation

##### VARIABLES #####
#---- CONSTANTS -----
const RECTANGLE_SIDE := 1.0
const PARTICLE_AMOUNT := 5.0
const ANIMATION_EXPLODE := "explode"

#---- EXPORTS -----
export(NodePath) var target
export(Dictionary) var properties

#==== ONREADY ====
onready var _onready_paths := {
	"animation_player": $"AnimationPlayer", 
	"particles": $"Particles"
}


##### PUBLIC METHODS #####
func update_particles() -> void:
	if target != null and get_node_or_null(target) != null:
		var target_pos = get_node(target).global_transform.origin
		var target_distance = global_transform.origin.distance_to(
			get_node(target).global_transform.origin
		)
		_onready_paths.particles.look_at(target_pos, Vector3.UP)
		_onready_paths.particles.global_transform.origin = (
			global_transform.origin
			+ (target_pos - global_transform.origin) / 2.0
		)
		_onready_paths.particles.process_material.emission_box_extents = Vector3(
			RECTANGLE_SIDE, RECTANGLE_SIDE, target_distance / 2.0
		)
		# _onready_paths.particles.amount = int(PARTICLE_AMOUNT * target_distance)
		_onready_paths.particles.visibility_aabb = AABB(
			Vector3(0, 0, -target_distance / 2.0),
			Vector3(RECTANGLE_SIDE, RECTANGLE_SIDE, target_distance)
		)


func update_gradient(texture: GradientTexture):
	_onready_paths.particles.process_material.emission_color_texture = texture


##### PROTECTED METHODS #####
func _explode() -> void:
	_onready_paths.animation_player.play(ANIMATION_EXPLODE)


##### SIGNAL MANAGEMENT #####
func use(_parameters: Dictionary) -> void:
	_explode()
