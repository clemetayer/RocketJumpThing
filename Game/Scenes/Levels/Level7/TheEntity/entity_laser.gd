tool
extends Area
# The laser entity

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const LASER_OFFSET := Vector3(0, 0, -7)  # The offset that makes the laser appears in front of the entity
const FIRE_PARTICLES_1_AMOUNT := 10  # number of particles per unit of distance
const FIRE_ANIM_NAME := "fire"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var update_rotation := true  # true if it should update its own rotation to the player position
var mock_position := Vector3.ZERO  # a mock position for the tests
var mock := false  # true if it should mock the behaviour

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
onready var onready_paths := {
	"laser_mesh": $"LaserMesh",
	"raycast": $"RayCast",
	"laser_shape": $"LaserShape",
	"update_raycast_timer": $"UpdateRaycastTimer",
	"fire_particles_1": $"FireParticles",
	"fire_particles_2": $"FireParticles2",
	"target": $"Target",
	"animation_player": $"AnimationPlayer"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(GlobalConstants.LASER_GROUP)
	DebugUtils.log_connect(
		onready_paths.update_raycast_timer, self, "timeout", "_on_UpdateRaycastTimer_timeout"
	)
	DebugUtils.log_connect(self, self, "body_entered", "_on_body_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _physics_process(_delta):
	_update_laser_length()


##### PUBLIC METHODS #####
# toggles the update_rotation variable
func toggle_update_rotation(value: bool) -> void:
	update_rotation = value


# triggers the fire animation
func fire() -> void:
	onready_paths.animation_player.play(FIRE_ANIM_NAME)


##### PROTECTED METHODS #####
func _update_laser_length() -> void:
	var distance
	if mock:
		distance = (global_transform.origin + LASER_OFFSET).distance_to(mock_position)
	else:
		var collision_point = onready_paths.raycast.get_collision_point()
		distance = onready_paths.raycast.global_transform.origin.distance_to(collision_point)
	_update_laser_mesh(distance)
	_update_laser_shape(distance)
	_update_fire_particles(distance)


func _update_target() -> void:
	onready_paths.target.set_pos(
		onready_paths.raycast.get_collision_point(), onready_paths.raycast.get_collision_normal()
	)


func _update_laser_mesh(distance: float) -> void:
	onready_paths.laser_mesh.mesh.height = distance
	onready_paths.laser_mesh.transform.origin = LASER_OFFSET - Vector3(0, 0, distance / 2.0)


func _update_laser_shape(distance: float) -> void:
	onready_paths.laser_shape.shape.height = distance
	onready_paths.laser_shape.transform.origin = LASER_OFFSET - Vector3(0, 0, distance / 2.0)


func _update_fire_particles(distance: float) -> void:
	# Fire particles 1
	onready_paths.fire_particles_1.transform.origin = LASER_OFFSET - Vector3(0, 0, distance / 2.0)
	onready_paths.fire_particles_1.visibility_aabb.size.z = distance
	onready_paths.fire_particles_1.visibility_aabb.position.z = -distance / 2.0
	onready_paths.fire_particles_1.process_material.emission_box_extents.z = distance / 2.0
	onready_paths.fire_particles_1.amount = int(distance * FIRE_PARTICLES_1_AMOUNT)
	# Fire particles 2
	onready_paths.fire_particles_2.visibility_aabb.size.z = distance
	onready_paths.fire_particles_2.visibility_aabb.position.z = -distance / 2.0
	onready_paths.fire_particles_2.lifetime = (
		distance
		/ onready_paths.fire_particles_2.process_material.initial_velocity
	)


##### SIGNAL MANAGEMENT #####
func _on_UpdateRaycastTimer_timeout() -> void:
	_update_laser_length()
	_update_target()


func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_player(body):
		SignalManager.emit_respawn_player_on_last_cp()
