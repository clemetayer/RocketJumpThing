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
const PARTICLES_EMISSION_BOX_HEIGHT := 1.0
const PARTICLES_EMISSION_BOX_DIVIDER:= Vector2.ONE * 1.5
const CUBE_MESH_SCALE_MULTIPLIER := 1.5

#---- STANDARD -----
#==== PRIVATE ====
var _max_length := 1.0  # length of the laser
var _thickness := 1.0  # thickness of the laser
var _mangle := Vector3.ZERO  # trenchbroom angle
var _last_length := 0.0 # keeps the last length to avoid refreshing the particles at each frame
var _debug := false
var _static_size := true # if the size should be computed once and never again (improves performances)
var _init_static_size_done := false # to determine if the initial size has been computed
var _in_player_fov := false # mostly used for static init, to check if the laser is in the player field of view, so that we can enable or disable the laser after init
var _player # Instance of the player kept for optimization purposes
var _collision_point := Vector3.ZERO # Collision point of the laser. Usefull to update the audio stream player 3D position

#==== ONREADY ====
onready var onready_paths := {
	"mesh": $"LaserMesh",
	"collision": $"LaserCollision",
	"raycast": $"RayCast",
	"update_timer": $"UpdateTimer",
	"update_sound_pos_timer": $"UpdateSoundPosTimer",
	"particles": $"Particles",
	"cube_mesh": $"CubeMesh",
	"sound": $"LaserSound"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	._ready_func()
	_init_laser()
	_connect_signals()
	if _static_size:
		onready_paths.update_timer.start() # can't set the size on ready, since the collisions of the environment won't necessarly be ready
		onready_paths.update_sound_pos_timer.start()
	else:
		_toggle_enable(false) # by default, hides all the lasers

##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	._set_TB_params()
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_LASER_MAPPER)
	if properties.has("static_size"):
		_static_size = properties["static_size"] != 0
	else:
		DebugUtils.log_stacktrace(
				"laser does not have the property static_size", DebugUtils.LOG_LEVEL.debug
			)

func _connect_signals() -> void:
	DebugUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	DebugUtils.log_connect(onready_paths.update_timer, self, "timeout", "_on_UpdateTimer_timeout")
	DebugUtils.log_connect(self,self,"area_entered", "_on_area_entered")
	DebugUtils.log_connect(self,self,"area_exited", "_on_area_exited")
	DebugUtils.log_connect(onready_paths.update_sound_pos_timer, self, "timeout", "_on_UpdateSoundPosTimer_timeout")



func _init_laser() -> void:
	add_to_group(GlobalConstants.LASER_GROUP)
	# sets the general height, etc.
	onready_paths.collision.shape.height = _max_length
	onready_paths.collision.shape.radius = _thickness
	onready_paths.mesh.mesh.height = _max_length
	onready_paths.mesh.mesh.top_radius = _thickness
	onready_paths.mesh.mesh.bottom_radius = _thickness
	onready_paths.cube_mesh.scale = Vector3.ONE * _thickness * CUBE_MESH_SCALE_MULTIPLIER
	onready_paths.raycast.cast_to = Vector3(0, 0, _max_length)
	onready_paths.particles.process_material.emission_box_extents = Vector3(_thickness / PARTICLES_EMISSION_BOX_DIVIDER.x, _thickness / PARTICLES_EMISSION_BOX_DIVIDER.y, PARTICLES_EMISSION_BOX_HEIGHT)
	onready_paths.particles.emitting = false
	_last_length = _max_length
	rotation_degrees = _mangle
	# sets the positions according to the heights
	onready_paths.collision.translation.z = _max_length / 2.0
	onready_paths.mesh.translation.z = _max_length / 2.0
	onready_paths.particles.translation.z = _max_length
	onready_paths.sound.translation.z = _max_length / 2.0


func _update_laser(length: float) -> void:
	if not _static_size or not _init_static_size_done:
		# length
		onready_paths.collision.shape.height = length
		onready_paths.mesh.mesh.height = length
		if not is_equal_approx(length,_last_length):
			_last_length = length
		# position
		onready_paths.collision.translation.z = length / 2.0
		onready_paths.mesh.translation.z = length / 2.0
		onready_paths.particles.translation.z = length
		_init_static_size_done = true
	if _player == null and ScenesManager.get_current() != null and ScenesManager.get_current().has_method("get_player"): # avoids a crash on tests
		_player = ScenesManager.get_current().get_player()

func _check_raycast() -> void:
	if onready_paths.raycast.is_colliding():
		_update_laser(
			self.global_transform.origin.distance_to(onready_paths.raycast.get_collision_point())
		)
		_collision_point = onready_paths.raycast.get_collision_point()
		onready_paths.particles.emitting = true
	else:
		_update_laser(_max_length)
		_collision_point = to_global(self.transform.origin + (Vector3(0,0,_max_length)))
		onready_paths.particles.emitting = false

func _toggle_enable(enabled : bool) -> void:
	visible = enabled
	onready_paths.sound.playing = enabled
	onready_paths.update_sound_pos_timer.start() if enabled else onready_paths.update_sound_pos_timer.stop()
	if not _static_size:
		onready_paths.update_timer.start() if enabled else onready_paths.update_timer.stop()
		onready_paths.raycast.enabled = enabled

##### SIGNAL MANAGEMENT #####
func _on_UpdateTimer_timeout() -> void:
	if _static_size and not _init_static_size_done: # If the size is static, stop the update timer and disable the raycast to avoid wasting compute time
		_check_raycast()
		_toggle_enable(true)
		onready_paths.raycast.enabled = false
		onready_paths.update_timer.stop()
	else:
		_check_raycast()


func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_player(body):
		SignalManager.emit_respawn_player_on_last_cp()
		RuntimeUtils.play_death_sound()
		
func _on_area_entered(area : Node) -> void:
	if FunctionUtils.is_laser_enable(area):
		_toggle_enable(true)

func _on_area_exited(area : Node) -> void:
	if FunctionUtils.is_laser_enable(area):
		_toggle_enable(false)

func _on_UpdateSoundPosTimer_timeout() -> void:
	if _player != null: # Kind of a trick to make the laser sound even on its length
		onready_paths.sound.global_transform.origin = Geometry.get_closest_point_to_segment(_player.global_transform.origin, _collision_point, global_transform.origin)