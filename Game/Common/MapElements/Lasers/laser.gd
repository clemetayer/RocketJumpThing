extends Collidable
# Script for the laser

##### VARIABLES #####
#---- CONSTANTS -----
const TB_LASER_MAPPER := [
	["max_length", "_max_length"],
	["thickness", "_thickness"],
	["color", "_color"],
	["mangle", "_mangle"]
]  # mapper for TrenchBroom parameters

#---- STANDARD -----
#==== PRIVATE ====
var _max_length := 1.0  # length of the laser
var _thickness := 1.0  # thickness of the laser
var _mangle := Vector3.ZERO  # trenchbroom angle

#==== ONREADY ====
onready var onready_paths := {
	"mesh": $"LaserMesh", "collision": $"LaserCollision", "raycast": $"RayCast"
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_connect_signals()


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready_func()
	_init_laser()


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _physics_process(_delta):
	_check_raycast()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_LASER_MAPPER)


func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_body_entered")


func _init_laser() -> void:
	# duplicates the collision and mesh to avoid having the same lasers
	onready_paths.collision.shape = onready_paths.collision.shape.duplicate()
	onready_paths.mesh.mesh = onready_paths.mesh.mesh.duplicate()
	# sets the general height, etc.
	onready_paths.collision.shape.height = _max_length
	onready_paths.collision.shape.radius = _thickness
	onready_paths.mesh.mesh.height = _max_length
	onready_paths.mesh.mesh.top_radius = _thickness
	onready_paths.mesh.mesh.bottom_radius = _thickness
	onready_paths.raycast.cast_to = Vector3(0, 0, _max_length)
	rotation_degrees = _mangle
	# sets the positions according to the heights
	onready_paths.collision.translation.z = _max_length / 2.0
	onready_paths.mesh.translation.z = _max_length / 2.0


func _update_laser(length: float) -> void:
	# length
	onready_paths.collision.shape.height = length
	onready_paths.mesh.mesh.height = length
	# position
	onready_paths.collision.translation.z = length / 2.0
	onready_paths.mesh.translation.z = length / 2.0


func _check_raycast() -> void:
	if onready_paths.raycast.is_colliding():
		_update_laser(
			self.global_transform.origin.distance_to(onready_paths.raycast.get_collision_point())
		)
	else:
		_update_laser(_max_length)


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_player(body):
		SignalManager.emit_respawn_player_on_last_cp()
