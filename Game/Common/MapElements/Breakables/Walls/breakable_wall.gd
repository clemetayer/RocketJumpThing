extends RigidBody
# A wall that is breakable depending on the signal that is given on trigger-use

# FIXME : Actual advantage of using a rigisbody for character controler, as it provides better collision support
# OPTIMIZATION : Split the wall procedurally at runtime for general memory optimization

##### VARIABLES #####
#---- CONSTANTS -----
const BREAKABLE_PARTICLES_PATH := "res://Game/Common/MapElements/Breakables/Walls/breakable_wall_particles.tscn"
const SPEED_DIVIDER := .055  # Speed divider to prevent the wall from exploding too much, or not enough # TODO : Why.
const TB_BREAKABLE_WALL_MAPPER := [
	["collision_layer", "collision_layer"], ["collision_layer", "collision_mask"]
]  # mapper for TrenchBroom parameters
#---- EXPORTS -----
export(Dictionary) var properties
#---- STANDARD -----
#==== PRIVATE ====
var _particles_scene: Particles
var _mesh_instance: MeshInstance = null
var _collision: CollisionShape = null


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_TB_params()
	_init_child_instances()
	_init_body()
	_init_particles()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_BREAKABLE_WALL_MAPPER)


func _init_child_instances() -> void:
	for child in get_children():
		if child is MeshInstance:
			_mesh_instance = child
		elif child is CollisionShape:
			_collision = child


func _init_body() -> void:
	weight = 100
	mode = MODE_STATIC
	set_use_continuous_collision_detection(true)


func _init_particles() -> void:
	if _mesh_instance != null:
		_particles_scene = load(BREAKABLE_PARTICLES_PATH).instance()
		_particles_scene.init_particles(
			_mesh_instance.mesh.get_aabb(), _mesh_instance.mesh.surface_get_material(0)
		)
		add_child(_particles_scene)


##### SIGNAL MANAGEMENT #####
#==== Qodot =====
func use(parameters: Dictionary) -> void:
	if _collision != null:
		_collision.disabled = true
	if _mesh_instance != null:
		_mesh_instance.visible = false
	if _particles_scene != null:
		_particles_scene.start_emit(global_transform.origin - parameters.position, parameters.speed)
		yield(_particles_scene, "break_emission_done")
	queue_free()
