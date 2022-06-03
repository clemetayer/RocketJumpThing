extends Spatial
class_name Rocket
# A rocket, to rocket jump mostly

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SCENE_PATHS = {"explosion": "res://Game/Common/MovementUtils/Rocket/RocketExplosion.tscn"}
const SPEED := 200.0  # travel speed of the rocket
const RAYCAST_DISTANCE := 200  # maximum distance to detect a floor
const RAYCAST_PLAN_EXPLODE_DISTANCE := 5  # Distance from a floor where the explosion should be planned (since it's imminent), to be sure that is will explode (high speed makes collision weird)

#---- EXPORTS -----
export(Vector3) var START_POS = Vector3(0, 0, 0)
export(Vector3) var DIRECTION = Vector3(0, 0, 0)  # direction (normalized) where the rocket should travel
export(Vector3) var UP_VECTOR = Vector3(0, 1, 0)  # up vector
export(float) var SPEED_PERCENTAGE = 0.0  # How fast the rocket will travel, between MIN and MAX_SPEED (SPEED_PERCENTAGE between 0.0 and 1.0)

#==== PRIVATE ====
var _translate := false
var _expl_planned := false  # if the explosion has been already planned
var _speed := 0.0  # travel speed of the rocket


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	transform.origin = START_POS
	_speed = SPEED
	look_at(START_POS - DIRECTION, UP_VECTOR)
	_translate = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_check_raycast_distance()
	if _translate:
		translate_object_local(Vector3(0, 0, 1) * _speed * delta)


##### PROTECTED METHODS #####
# checks the raycast distance from the closest "floor", to explode if needed
func _check_raycast_distance() -> void:
	var raycast = $RayCast
	raycast.cast_to = Vector3(0, 0, 1) * RAYCAST_DISTANCE
	if raycast.is_colliding():
		var distance = _get_distance_to_collision(raycast)
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
	yield(get_tree().create_timer(distance / _speed), "timeout")
	_explode($RayCast.get_collision_point())


# Explosion of the rocket
# FIXME : Not exploding sometimes, the collision probably doesn't operate well...
func _explode(col_point: Vector3) -> void:
	_translate = false
	$RayCast.enabled = false
	transform.origin = col_point
	var explosion = load(SCENE_PATHS.explosion).instance()
	explosion.EXPLOSION_POSITION = global_transform.origin
	get_tree().get_current_scene().add_child(explosion)
	queue_free()


##### SIGNAL MANAGEMENT #####
# Additional area to make sure the rocket WILL explode
func _on_CloseAreaCheck_body_entered(_body: Node):
	if not _expl_planned:
		_expl_planned = true
		$RayCast.transform.origin.z = -100  # steps back the raycast to get the exact collision point
		$CloseAreaCheck/CollisionShape.disabled = true  # disables the area
		_explode(transform.origin)
