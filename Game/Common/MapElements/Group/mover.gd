extends Spatial
# A spatial brush that simply moves.

##### VARIABLES #####
#---- CONSTANTS -----
const TB_MOVER_MAPPER := [
	["travel_data_path", "_travel_data_path"],
	["path_color", "_path_color"],
	["path_emission", "_path_emission"],
	["path_alpha", "_path_alpha"]
]  # mapper for TrenchBroom parameters
const TB_RESET_ON_CHECKPOINT := "reset_on_checkpoint" # special TB param to convert to a bool
const PATH_MESH_RADIUS = 0.03125  # radius of the cylinder mesh
#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _travel_data_path: String  # Path to the array of travel data (Not ideal, but avoid complex trenchbroom entities)
var _travel_data: Array  # Array of travel datas (MoverTravelDataArray. Not ideal, but avoid complex trenchbroom entities)
var _path_color: Color = Color.white  #  Color of the path
var _path_emission: float = 0.0  # Emission of the path
var _path_alpha: float = 0.0  #  Transparency of the path
var _tween: Tween  # Tween to move the spatial
var _step_idx := 0  # index of the position in the array
var _reset_on_checkpoint := false # if the mover position should reset on checkpoint

#==== ONREADY ====
onready var onready_position := self.translation  # keeps a record of the original position of the spatial
onready var onready_angle := self.rotation_degrees  # keeps a record of the original rotation of the spatial


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	# init
	_step_idx = 0
	_tween = Tween.new()
	DebugUtils.log_connect(_tween, self, "tween_all_completed", "_on_tween_all_completed")
	add_child(_tween)
	# importing trenchbroom params
	_set_TB_params()
	_init_travel_data()
	# sets the path meshes
	if _path_alpha > 0.0:  # show path if it is not completely transparent
		_create_show_path_meshes()
	# sets the first step
	if _travel_data.size() > 1:
		_set_tween_to_pos_idx(_step_idx)
	# inits the mover to reset on respawn
	if _reset_on_checkpoint:
		DebugUtils.log_connect(
			SignalManager,
			self,
			SignalManager.PLAYER_RESPAWNED_ON_LAST_CP,
			"_on_player_respawned_on_last_cp"
		)

##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(self, properties, TB_MOVER_MAPPER)
	if TB_RESET_ON_CHECKPOINT in properties:
		_reset_on_checkpoint = properties[TB_RESET_ON_CHECKPOINT] != 0



#==== Other =====
# makes the travel data exploitable
func _init_travel_data() -> void:
	if ResourceLoader.exists(_travel_data_path):
		var travel_data_resource = ResourceLoader.load(_travel_data_path)
		if travel_data_resource is MoverTravelDataArray:
			_travel_data = travel_data_resource.TRAVEL_DATA_ARRAY
		else:
			DebugUtils.log_stacktrace("The resource at path %s is invalid" % _travel_data_path, DebugUtils.LOG_LEVEL.error)
	else:
		DebugUtils.log_stacktrace("No resource found at path %s" % _travel_data_path, DebugUtils.LOG_LEVEL.error)


# adds (all) the path meshes to the parent
func _create_show_path_meshes() -> void:
	for travel_data_idx in range(1, _travel_data.size()):
		_create_show_path_meshes_between_idx(travel_data_idx - 1, travel_data_idx)
	# mesh between last position and start position
	_create_show_path_meshes_between_idx(_travel_data.size() - 1, 0)
	
func _create_show_path_meshes_between_idx(idx1 : int, idx2 : int) -> void:
	var mesh = _create_show_path_mesh(
		_travel_data[idx1].POSITION, _travel_data[idx2].POSITION
	)
	var mid_pos = (
		(_travel_data[idx1].POSITION - _travel_data[idx2].POSITION)
		/ 2.0
	)  # middle position, since a cylinder mesh starts at the middle
	mesh.transform.origin += (
		self.transform.origin
		- mid_pos
		+ _travel_data[idx1].POSITION
	)  # adds the position of the spatial in the world
	if get_parent() != null:
		get_parent().call_deferred("add_child", mesh)


# adds (one) path mesh to the parent
func _create_show_path_mesh(start_point: Vector3, end_point: Vector3) -> MeshInstance:
	var mesh_instance := MeshInstance.new()
	mesh_instance.mesh = _create_cylinder_mesh(start_point, end_point)
	var normalized_vect := (end_point - start_point).normalized()  # used to check if the vector is aligned with the UP vector
	if normalized_vect == Vector3.UP or normalized_vect == -Vector3.UP:  # aligned with up vector, do not use look_at
		mesh_instance.rotation.x = PI / 2.0
	else:
		# FIXME : Creates an error stating that the mesh instance is not in the tree, but since it hard to fix and is not blocking anything, it should be fine
		mesh_instance.look_at(end_point - start_point, Vector3.UP)
	mesh_instance.set_surface_material(0, _create_path_material())
	return mesh_instance


# creates a cylinder mesh matching the path
func _create_cylinder_mesh(start_point: Vector3, end_point: Vector3) -> CapsuleMesh:
	var mesh := CapsuleMesh.new()
	mesh.radius = PATH_MESH_RADIUS
	mesh.mid_height = abs(start_point.distance_to(end_point))
	return mesh


# creates the material for the path
func _create_path_material() -> SpatialMaterial:
	var material := SpatialMaterial.new()
	material.flags_transparent = true
	material.albedo_color = _path_color
	material.emission_enabled = true
	material.emission = _path_color
	material.emission_energy = _path_emission
	if _path_alpha < 1.0:
		material.flags_transparent = true
		material.albedo_color.a = _path_alpha
	return material


func _set_tween_to_pos_idx(idx: int) -> void:
	DebugUtils.log_tween_interpolate_property(
		_tween,
		self,
		"translation",
		onready_position + _travel_data[idx].POSITION,
		onready_position + _travel_data[(idx + 1) % (_travel_data.size())].POSITION,
		_travel_data[idx].TRAVEL_TIME,
		_travel_data[idx].TRANSITION_TYPE,
		_travel_data[idx].EASE_TYPE,
		_travel_data[idx].WAIT_TIME
	)
	DebugUtils.log_tween_interpolate_property(
		_tween,
		self,
		"rotation_degrees",
		onready_angle + _travel_data[idx].ROTATION_DEGREES,
		onready_angle + _travel_data[(idx + 1) % (_travel_data.size())].ROTATION_DEGREES,
		_travel_data[idx].TRAVEL_TIME,
		_travel_data[idx].TRANSITION_TYPE,
		_travel_data[idx].EASE_TYPE,
		_travel_data[idx].WAIT_TIME
	)
	DebugUtils.log_tween_start(_tween)


##### SIGNAL MANAGEMENT #####
func _on_tween_all_completed() -> void:
	_step_idx = (_step_idx + 1) % _travel_data.size()
	_set_tween_to_pos_idx(_step_idx)

func _on_player_respawned_on_last_cp() -> void:
	if _reset_on_checkpoint: # A bit overkill, but you never know
		DebugUtils.log_tween_stop_all(_tween)
		self.translation = onready_position
		_step_idx = 0
		_set_tween_to_pos_idx(_step_idx)
