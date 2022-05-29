tool
extends Area
# Area that pushes the player up like a bumper

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const NODE_PATHS = {
	"collision": @"Collision",
	"triangle_particles": @"TriangleParticles",
	"square_particles": @"UpSquares",
	"mesh": @"LightBumperMesh"
}
const TIMER_TIMEOUT = 0.05  # timeout time before adding a new push vector to the player

#---- EXPORTS -----
export(Dictionary) var properties

#---- STANDARD -----
#==== PRIVATE ====
var _player_body: Player = null  # keeps an instance of the player's body
var _color := Color.white  # general color of the bumper
var _force := 1.0  # how much the player will be pushed
var _angle := Vector3(0, 0, 0)  # rotation of the bumper (in degrees)
var _size := Vector3(1, 1, 1)  # size of the bumper

#==== ONREADY ====
onready var onready_timer := Timer.new()  # timer for adding push vectors to the player (to avoid using _process to much)


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	FunctionUtils.log_connect(self, self, "body_exited", "_on_body_exited")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(onready_timer)
	onready_timer.wait_time = TIMER_TIMEOUT
	FunctionUtils.log_connect(onready_timer, self, "timeout", "_on_timer_timeout")
	_set_TB_params()
	rotation_degrees = _angle
	_set_extents()
	_set_colors()


##### PROTECTED METHODS #####
func _set_TB_params() -> void:
	if "angle" in properties:
		_angle = properties["angle"]
	if "force" in properties:
		_force = properties["force"]
	if "color" in properties:
		_color = properties["color"]
	if "size" in properties:
		_size = properties["size"]


# sets the extents of the different boxes used (particle boxes, collision, etc.)
func _set_extents() -> void:
	get_node(NODE_PATHS.collision).shape.extents = _size
	get_node(NODE_PATHS.triangle_particles).process_material.emission_box_extents = _size
	get_node(NODE_PATHS.triangle_particles).draw_pass_1.size = (Vector3(
		_size.x / 10.0, _size.y / 10.0, _size.z / 40.0
	))
	get_node(NODE_PATHS.triangle_particles).process_material.initial_velocity = _size.y
	get_node(NODE_PATHS.square_particles).draw_pass_1.size = (Vector3(_size.x, 0.0, _size.z) * 4.0)
	get_node(NODE_PATHS.square_particles).process_material.initial_velocity = _size.y
	get_node(NODE_PATHS.mesh).mesh.size = (
		Vector3(_size.x * 0.75, _size.y / 20.0, _size.z * 0.75)
		* 2.0
	)


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
	get_node(NODE_PATHS.mesh).mesh.material.albedo_color = _color
	get_node(NODE_PATHS.mesh).mesh.material.emission = _color


##### SIGNAL MANAGEMENT #####
func _on_timer_timeout() -> void:
	if _player_body != null:
		var rotated_vec := Vector3.UP.rotated(Vector3.RIGHT, deg2rad(_angle.x)).rotated(Vector3.UP, deg2rad(_angle.y)).rotated(
			Vector3.BACK, deg2rad(_angle.z)
		)  # Not so great
		_player_body.add_velocity_vector(rotated_vec * _force)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_body = body
		_on_timer_timeout()
		onready_timer.start()


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_body = null
		onready_timer.stop()
