extends Spatial
class_name Rocket
# A rocket, to rocket jump mostly

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED := 150.0  # travel speed of the rocket
const EXPLOSION_RADIUS := 5.0  # explosion radius
const EXPLOSION_DECAY := 0.1  # how much time the explosion remains
const EXPLOSION_POWER := 13  # power of the explosion
const RAYCAST_DISTANCE := 200  # maximum distance to detect a floor
const RAYCAST_PLAN_EXPLODE_DISTANCE := 5  # Distance from a floor where the explosion should be planned (since it's imminent), to be sure that is will explode (high speed makes collision weird)

#---- EXPORTS -----
export (Vector3) var START_POS = Vector3(0, 0, 0)
export (Vector3) var DIRECTION = Vector3(0, 0, 0)  # direction (normalized) where the rocket should travel
export (Vector3) var UP_VECTOR = Vector3(0, 1, 0)  # up vector 

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _translate := false
var _expl_planned := false  # if the explosion has been already planned

#==== ONREADY ====
# onready var onready_var # Optionnal comment


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	transform.origin = START_POS
	look_at(START_POS - DIRECTION, UP_VECTOR)
	_translate = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_check_raycast_distance()
	if _translate:
		translate_object_local(Vector3(0, 0, 1) * SPEED * delta)


##### PUBLIC METHODS #####


##### PROTECTED METHODS #####
# checks the raycast distance from the closest "floor", to explode if needed
func _check_raycast_distance() -> void:
	var raycast = $RayCast
	raycast.cast_to = Vector3(0, 0, 1) * RAYCAST_DISTANCE
	if raycast.is_colliding():
		var distance = _get_distance_to_collision(raycast)
		print("distance = %f" % distance)
		if distance <= RAYCAST_PLAN_EXPLODE_DISTANCE and not _expl_planned:
			_plan_explosion(distance)


# returns the distance from the rocket position to the collision point (using the normal)
func _get_distance_to_collision(raycast: RayCast) -> float:
	var col_point = raycast.get_collision_point()
	var normalized_traj = col_point.direction_to(self.transform.origin)
	var normalized_normal = col_point.direction_to(
		raycast.get_collision_point() + raycast.get_collision_normal()
	)
	var angle_to_normal = normalized_traj.angle_to(normalized_normal)
	var normal_vect = (
		raycast.get_collision_normal()
		* (cos(angle_to_normal) * self.transform.origin.distance_to(col_point))
	)
	DebugDraw.draw_line_3d(
		$RayCast.get_collision_point(), $RayCast.get_collision_point() + normal_vect, Color(1, 1, 1)
	)
	return normal_vect.length()


# plans an explosion, since the rocket is close to the floor (to make sure it explodes)
func _plan_explosion(distance: float) -> void:
	_expl_planned = true
	yield(get_tree().create_timer(distance / SPEED), "timeout")
	_explode()


# Explosion of the rocket
# FIXME : Not exploding sometimes, the collision probably doesn't operate well...
func _explode() -> void:
	_translate = false
	$RayCast.enabled = false
	if get_node_or_null("MeshInstance") != null and is_instance_valid($MeshInstance):
		$MeshInstance.queue_free()
	var area := Area.new()
	area.collision_layer = int(pow(2, 3))  # layer mask set to "explosive"
	area.collision_mask = int(pow(2, 0))  # can collide with player
	var collision := CollisionShape.new()
	var shape := SphereShape.new()
	shape.radius = EXPLOSION_RADIUS
	collision.shape = shape
	area.add_child(collision)
	add_child(area)
	var _err = area.connect("body_entered", self, "interact_with_body", [area])
	yield(get_tree().create_timer(EXPLOSION_DECAY), "timeout")
	queue_free()


##### SIGNAL MANAGEMENT #####
func interact_with_body(body, area):
	if body.is_in_group("player"):
		var vector = (body.global_transform.origin - area.global_transform.origin) * EXPLOSION_POWER
		body.add_velocity_vector(vector)
