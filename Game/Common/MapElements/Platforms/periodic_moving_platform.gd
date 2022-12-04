extends KinematicBody

# code for a platform that moves periodically between a maximum of 5 points (use Vector3(0,0,0) to use less points)
# Note : the collision safe margin of the colliding entity needs to be rather large (like 1 maybe), so that the platform can go against gravity with a kinematic body on it

##### VARIABLES #####
#---- CONSTANTS -----
const TB_PERIODIC_MOVING_PLATFORM_MAPPER := [
	["wait_time", "_wait_time"],
	["travel_time", "_travel_time"],
	["trans_type", "_trans_type"],
	["ease", "_ease"],
	["path_color", "_path_color"],
	["path_emission", "_path_emission"]
]  # mapper for TrenchBroom parameters
const PATH_TRANSPARENCY = 1.0  # alpha value of the material showing the path of the platform
const PATH_MESH_RADIUS = 0.03125  # radius of the cylinder mesh

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _pos_array = []  # array of position to cycle through
var _tween: Tween  # Tween to move the platform
var _step_idx := 0  # index of the position in the array
var _travel_time := 0  # times it takes to go from one point to another
var _wait_time := 0  # time to wait after reaching a point
var _transition_type := Tween.TRANS_LINEAR  # Tween transition type
var _ease := Tween.EASE_IN  # Tween ease
var _desired_pos := false
var _path_color := Color.white  # color of the platform path
var _path_emission := 2.0  # emission intensity of the  platform path
var _trans_type: int  # transition move type

#==== ONREADY ====
onready var onready_translation := self.translation  # keeps a record of the original position of the platform
onready var onready_desired_pos := self.translation  # desired position for the platform to be (variable modified by tween)


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	# init
	_step_idx = 0
	_tween = Tween.new()
	DebugUtils.log_connect(_tween, self, "tween_all_completed", "_on_tween_all_completed")
	add_child(_tween)
	_pos_array.append(Vector3(0, 0, 0))
	# importing trenchbroom params
	_set_TB_params()
	# sets the path meshes
	_create_show_path_meshes()
	# sets the first step
	if _pos_array.size() > 1:
		_set_tween_to_pos_idx(_step_idx)


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	var delta_dist = onready_desired_pos - self.translation
	var _unused = move_and_slide(delta_dist / delta)


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, Collidable.TB_COLLIDABLE_MAPPER
	)
	TrenchBroomEntityUtils._map_trenchbroom_properties(
		self, properties, TB_PERIODIC_MOVING_PLATFORM_MAPPER
	)
	# special mapper for the array of points
	for i in range(0, 5):
		if properties.has("point%d" % i) and properties["point%d" % i] != Vector3(0, 0, 0):
			_pos_array.append(properties["point%d" % i])


#==== Other =====
# for test purposes
func _set_translation(p_translation: Vector3) -> void:
	translation = p_translation


# adds (all) the path meshes to the parent
func _create_show_path_meshes() -> void:
	for pos_idx in range(1, _pos_array.size()):
		var mesh = _create_show_path_mesh(_pos_array[pos_idx - 1], _pos_array[pos_idx])
		var mid_pos = (_pos_array[pos_idx - 1] - _pos_array[pos_idx]) / 2.0  # middle position, since a cylinder mesh starts at the middle
		mesh.transform.origin += self.transform.origin - mid_pos + _pos_array[pos_idx - 1]  # adds the position of the platform in the world
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
	_path_color.a = PATH_TRANSPARENCY
	material.albedo_color = _path_color
	material.emission_enabled = true
	material.emission = _path_color
	material.emission_energy = _path_emission
	return material


func _set_tween_to_pos_idx(idx: int) -> void:
	DebugUtils.log_tween_interpolate_property(
		_tween,
		self,
		"onready_desired_pos",
		onready_desired_pos,
		onready_translation + _pos_array[idx],
		_travel_time,
		_transition_type,
		_ease,
		_wait_time
	)
	DebugUtils.log_tween_start(_tween)


##### SIGNAL MANAGEMENT #####
func _on_tween_all_completed() -> void:
	_step_idx = (_step_idx + 1) % _pos_array.size()
	_set_tween_to_pos_idx(_step_idx)
